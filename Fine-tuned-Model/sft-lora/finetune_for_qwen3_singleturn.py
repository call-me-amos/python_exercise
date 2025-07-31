# This code is based on the revised code from fastchat based on tatsu-lab/stanford_alpaca.

from dataclasses import dataclass, field
import json
import logging
import os
import pathlib
from typing import Dict, Optional, List
import torch
from torch.utils.data import Dataset
import deepspeed
from deepspeed import zero
from deepspeed.utils.zero_to_fp32 import get_fp32_state_dict_from_zero_checkpoint
from deepspeed.runtime.zero.partition_parameters import ZeroParamStatus
import transformers
from transformers import AutoModelForCausalLM, AutoTokenizer, Qwen3ForCausalLM
from transformers import Trainer, BitsAndBytesConfig
from transformers.trainer_pt_utils import LabelSmoother
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training, PeftModel
from accelerate.utils import DistributedType
from transformers.modeling_outputs import CausalLMOutputWithPast
from typing import List, Optional, Tuple, Union
from torch.nn import CrossEntropyLoss
from transformers import DataCollatorWithPadding, DataCollatorForLanguageModeling


def truncate_messages_for_reasoning(messages, tokenizer, max_len):
    """默认第一句不截断，因为默认第一句为system, 从第二句开始截断，截断的最小单元为一条消息"""
    length_list = []
    for msg in messages:     
        tokens = tokenizer.encode(f"<|_start|>{msg['role']}\n{msg['content']}<|_end|>")
        length_list.append(len(tokens))
    length_list[-1] = length_list[-1] + 4
    length_list[:-1] = [length + 1 for length in length_list[:-1]]
    new_messages = []
    remain_length = max_len - length_list[0]
    for length, msg in zip(reversed(length_list[1:]), reversed(messages[1:])):
        if remain_length >= length:
            new_messages.insert(0, msg)
            remain_length -= length
        else:
            break
    new_messages.insert(0, messages[0])
    return new_messages


IGNORE_TOKEN_ID = LabelSmoother.ignore_index

local_rank = None

def rank0_print(*args):
    if local_rank == 0:
        print(*args)


@dataclass
class ModelArguments:
    base_model_path: str = field(default=None, metadata={"help": "基础模型路径"})
    base_adapter_model_path: str = field(default=None, metadata={"help": "基础adapter模型路径"})

    model_max_length: int = field(default=4096, metadata={"help": "Maximum sequence length. Sequences will be right padded (and possibly truncated)."},)

    model_adapter_name: str = field(default="", metadata={"help": "DPO训练时使用的adapter名称"})
    ref_adapter_name: str = field(default="", metadata={"help": "参考模型使用的adapter名称"})

    force_use_ref_model: bool = field(default=False, metadata={"help": "是否使用独立的参考模型，而不与训练模型共基底"})
    disable_dropout: bool = field(default=False, metadata={"help": "是否禁用dropout"})


@dataclass
class DataArguments:
    data_path: str = field(
        default=None, metadata={"help": "Path to the training data."}
    )
    eval_data_path: str = field(
        default=None, metadata={"help": "Path to the evaluation data."}
    )
    lazy_preprocess: bool = False


@dataclass
class LoraArguments:
    lora_r: int = field(default=8, metadata={"help": "LoRA的秩"})
    lora_alpha: float = field(default=16, metadata={"help": "LoRA的alpha"})
    lora_dropout: float = field(default=0.05, metadata={"help": "LoRA的dropout"})
    lora_bias: str = field(default="none", metadata={"help": "LoRA的偏置"})
    q_lora: bool = field(default=False, metadata={"help": "是否使用Q-LoRA"})
    lora_target_modules: List[str] = field(
        default_factory=lambda: [
            "q_proj",
            "k_proj",
            "v_proj",
            "o_proj",
            "up_proj",
            "gate_proj",
            "down_proj",
        ]
    )


@dataclass
class TrainingArguments(transformers.TrainingArguments):
    # 基础训练参数
    optim: str = field(default="adamw_torch")
    output_dir: str = field(default=None, metadata={"help": "输出目录"})
    cache_dir: Optional[str] = field(default=None)

    per_device_train_batch_size: int = field(default=2, metadata={"help": "每个设备训练的batch size"})
    per_device_eval_batch_size: int = field(default=2, metadata={"help": "每个设备评估的batch size"})
    gradient_accumulation_steps: int = field(default=1, metadata={"help": "梯度累积步数"})
    gradient_checkpointing: bool = field(default=True, metadata={"help": "是否使用梯度检查点"})
    num_train_epochs: int = field(default=3, metadata={"help": "训练的epoch数"})

    learning_rate: float = field(default=3e-4, metadata={"help": "学习率"})
    weight_decay: float = field(default=0.01, metadata={"help": "权重衰减"})
    adam_beta2: float = field(default=0.95, metadata={"help": "Adam2的beta2"})
    warmup_ratio: float = field(default=0.01, metadata={"help": "warmup比例"})
    
    lr_scheduler_type: str = field(default="cosine", metadata={"help": "学习率调度器类型"})
    bf16: bool = field(default=True, metadata={"help": "是否使用bf16"})

    save_strategy: str = field(default="steps", metadata={"help": "保存策略"})
    save_steps: int = field(default=10, metadata={"help": "保存模型的步数"})
    save_total_limit: int = field(default=10, metadata={"help": "保存模型的最大数量"})
    
    logging_dir: str = field(default=None, metadata={"help": "Directory for storing logs."})
    logging_steps: int = field(default=1, metadata={"help": "日志记录的步数"})

    report_to: str = field(default="none", metadata={"help": "报告方式"})

    evaluation_strategy: str = field(default="no", metadata={"help": "评估策略，可选值：no, steps, epoch"})

    # 添加wandb相关参数
    wandb_project: Optional[str] = field(default=None, metadata={"help": "wandb项目名称"})
    wandb_api_key: Optional[str] = field(default=None, metadata={"help": "wandb API密钥"})


def maybe_zero_3(param):
    if hasattr(param, "ds_id"):
        assert param.ds_status == ZeroParamStatus.NOT_AVAILABLE
        with zero.GatheredParameters([param]):
            param = param.data.detach().cpu().clone()
    else:
        param = param.detach().cpu().clone()
    return param


# Borrowed from peft.utils.get_peft_model_state_dict
def get_peft_state_maybe_zero_3(named_params, bias):
    if bias == "none":
        to_return = {k: t for k, t in named_params if "lora_" in k}
    elif bias == "all":
        to_return = {k: t for k, t in named_params if "lora_" in k or "bias" in k}
    elif bias == "lora_only":
        to_return = {}
        maybe_lora_bias = {}
        lora_bias_names = set()
        for k, t in named_params:
            if "lora_" in k:
                to_return[k] = t
                bias_name = k.split("lora_")[0] + "bias"
                lora_bias_names.add(bias_name)
            elif "bias" in k:
                maybe_lora_bias[k] = t
        for k, t in maybe_lora_bias:
            if bias_name in lora_bias_names:
                to_return[bias_name] = t
    else:
        raise NotImplementedError
    to_return = {k: maybe_zero_3(v) for k, v in to_return.items()}
    return to_return


def safe_save_model_for_hf_trainer(
    trainer: transformers.Trainer, output_dir: str, bias="none"
):
    """Collects the state dict and dump to disk."""
    # check if zero3 mode enabled
    if getattr(trainer.model, "is_deepspeed_enabled", False) and trainer.deepspeed.zero_optimization_stage() == 3:
        state_dict = trainer.model_wrapped._zero3_consolidated_16bit_state_dict()
    else:
        # 这里用模型类型判断是否是LoRA
        if isinstance(trainer.model, PeftModel):
            state_dict = get_peft_state_maybe_zero_3(
                trainer.model.named_parameters(), bias
            )
        else:
            state_dict = trainer.model.state_dict()
    if trainer.args.should_save and trainer.args.local_rank == 0:
        trainer._save(output_dir, state_dict=state_dict)
        # 保存tokenizer相关文件
        trainer.tokenizer.save_pretrained(output_dir)



def preprocess(
    messages,
    tokenizer: transformers.PreTrainedTokenizer,
    max_len: int,
) -> Dict:
    input_ids = []
    target_ids = []

    for i, msg in enumerate(messages):
        msg = truncate_messages_for_reasoning(msg, tokenizer, max_len)

        whole_sequence_tokens_ids = tokenizer.apply_chat_template(
            msg,
            tokenize=True,
            add_generation_prompt=False,
            padding=False,  # 这里不要pad，交给collator
            max_length=max_len,
            truncation=True,
            enable_thinking=True,
        )

        input_id = tokenizer.apply_chat_template(
            msg[:-1],
            tokenize=True,
            add_generation_prompt=True,
            enable_thinking=True,
        )

        input_len = len(input_id)
        target_id = whole_sequence_tokens_ids.copy()
        target_id[:input_len] = [IGNORE_TOKEN_ID] * input_len

        input_ids.append(whole_sequence_tokens_ids)
        target_ids.append(target_id)
        # attention_mask 交给collator自动生成

    return dict(
        input_ids=input_ids,
        target_ids=target_ids,
        # 不需要 attention_mask
    )


class SupervisedDataset(Dataset):
    """Dataset for supervised fine-tuning."""

    def __init__(
        self, raw_data, tokenizer: transformers.PreTrainedTokenizer, max_len: int
    ):
        super().__init__()
        messages = [example["messages"] for example in raw_data]
        data_dict = preprocess(messages, tokenizer, max_len)
        self.input_ids = data_dict["input_ids"]
        self.target_ids = data_dict["target_ids"]

    def __len__(self):
        return len(self.input_ids)

    def __getitem__(self, i):
        return {
            "input_ids": self.input_ids[i],
            "labels": self.target_ids[i],  # Trainer默认用labels作为target
        }


class LazySupervisedDataset(Dataset):
    """Dataset for supervised fine-tuning."""

    def __init__(
        self, raw_data, tokenizer: transformers.PreTrainedTokenizer, max_len: int
    ):
        super().__init__()
        self.tokenizer = tokenizer
        self.max_len = max_len
        self.raw_data = raw_data
        self.cached_data_dict = {}

    def __len__(self):
        return len(self.raw_data)

    def __getitem__(self, i):
        if i in self.cached_data_dict:
            return self.cached_data_dict[i]

        ret = preprocess([self.raw_data[i]["messages"]], self.tokenizer, self.max_len)
        # 只取list，不要tensor，也不要attention_mask
        item = {
            "input_ids": ret["input_ids"][0],
            "labels": ret["target_ids"][0],
        }
        self.cached_data_dict[i] = item
        return item


def make_supervised_data_module(
    tokenizer: transformers.PreTrainedTokenizer,
    data_args,
    max_len,
) -> Dict:
    """Make dataset and collator for supervised fine-tuning."""
    dataset_cls = (
        LazySupervisedDataset if data_args.lazy_preprocess else SupervisedDataset
    )
    rank0_print("Loading data...")

    train_data = []
    with open(data_args.data_path, "r") as f:
        for line in f:
            train_data.append(json.loads(line))
    train_dataset = dataset_cls(train_data, tokenizer=tokenizer, max_len=max_len)

    if data_args.eval_data_path:
        eval_data = []
        with open(data_args.eval_data_path, "r") as f:
            for line in f:
                eval_data.append(json.loads(line))
        eval_dataset = dataset_cls(eval_data, tokenizer=tokenizer, max_len=max_len)
    else:
        eval_dataset = None

    return dict(train_dataset=train_dataset, eval_dataset=eval_dataset)


class DataCollatorForCausalLMWithIgnore(DataCollatorWithPadding):
    def __call__(self, features):
        # 先用父类方法对 input_ids 做 padding
        batch = super().__call__([{k: v for k, v in f.items() if k != "labels"} for f in features])
        # 手动对 labels 做 padding
        labels = [f["labels"] for f in features]
        # 找到本 batch 内 labels 的最大长度
        max_label_length = max(len(l) for l in labels)
        # pad 到最大长度
        padded_labels = []
        for l in labels:
            padded = l + [self.tokenizer.pad_token_id] * (max_label_length - len(l))
            padded_labels.append(padded)
        # 转成 tensor
        batch["labels"] = torch.tensor(padded_labels, dtype=torch.long)
        # 替换 pad_token_id 为 IGNORE_TOKEN_ID
        batch["labels"][batch["labels"] == self.tokenizer.pad_token_id] = IGNORE_TOKEN_ID
        return batch


def train():
    global local_rank

    parser = transformers.HfArgumentParser(
        (ModelArguments, DataArguments, TrainingArguments, LoraArguments)
    )
    (
        model_args,
        data_args,
        training_args,
        lora_args,
    ) = parser.parse_args_into_dataclasses()

    # This serves for single-gpu qlora.
    if (
        getattr(training_args, "deepspeed", None)
        and int(os.environ.get("WORLD_SIZE", 1)) == 1
    ):
        training_args.distributed_state.distributed_type = DistributedType.DEEPSPEED

    local_rank = training_args.local_rank

    device_map = None

    model_load_kwargs = {
        "low_cpu_mem_usage": "zero_optimization" in training_args.deepspeed and training_args.deepspeed["zero_optimization"]["stage"] == 3,
    }

    compute_dtype = (
        torch.float16
        if training_args.fp16
        else (torch.bfloat16 if training_args.bf16 else torch.float32)
    )

    # Load model and tokenizer
    config = transformers.AutoConfig.from_pretrained(
        model_args.base_model_path,
        cache_dir=training_args.cache_dir,
    )
    config.use_cache = False

    model = AutoModelForCausalLM.from_pretrained(
        model_args.base_model_path,
        config=config,
        cache_dir=training_args.cache_dir,
        device_map=device_map,
        quantization_config=None,
        **model_load_kwargs,
    )

    tokenizer = AutoTokenizer.from_pretrained(
        model_args.base_model_path,
        cache_dir=training_args.cache_dir,
        model_max_length=model_args.model_max_length,
        padding_side="right",
        use_fast=False,
    )

    # with open("/root/autodl-tmp/workplace/Qwen1.5-main/examples/sft/chat_template.jinja2", "r", encoding="utf-8") as f:
    #     tokenizer.chat_template = f.read()

    data_collator = DataCollatorForCausalLMWithIgnore(tokenizer=tokenizer, padding='longest')

    lora_config = LoraConfig(
        r=lora_args.lora_r,
        lora_alpha=lora_args.lora_alpha,
        target_modules=lora_args.lora_target_modules,
        lora_dropout=lora_args.lora_dropout,
        bias=lora_args.lora_bias,
        task_type="CAUSAL_LM",
    )

    model = get_peft_model(model, lora_config)

    # Print peft trainable params
    model.print_trainable_parameters()

    if training_args.gradient_checkpointing:
        model.enable_input_require_grads()

    # Load data
    data_module = make_supervised_data_module(
        tokenizer=tokenizer, data_args=data_args, max_len=model_args.model_max_length
    )
    # print("=======>>data_module", data_module)

    # for idx, data in enumerate(data_module["train_dataset"]):
    #     print(f"-------------------------------Data index {idx}: {data}")

    # Start trainer
    # import pdb
    # pdb.set_trace()

    trainer = Trainer(
        model=model,
        tokenizer=tokenizer,
        args=training_args,
        data_collator=data_collator,
        **data_module
    )

    trainer.train(resume_from_checkpoint=training_args.resume_from_checkpoint)
    trainer.save_state()

    safe_save_model_for_hf_trainer(
        trainer=trainer, output_dir=training_args.output_dir, bias=lora_args.lora_bias
    )


if __name__ == "__main__":
    train()

"""
送进模型前：
{'role': 'system', 'content': 'You are a helpful assistant.\n\n# Tools\n\n## You have access to the following tools:\n\n### get_current_weather\n\nget_current_weather: Get the current weather in a given location Parameters: {"type": "object", "properties": {"location": {"type": "string", "description": "The city and state, e.g. San Francisco, CA"}, "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]}}, "required": ["location"]}\n\n## When you need to call a tool, please insert the following command in your reply, which can be called zero or multiple times according to your needs:\n\n✿FUNCTION✿: The tool to use, should be one of [get_current_weather]\n✿ARGS✿: The input of the tool\n✿RESULT✿: The result returned by the tool. The image needs to be rendered as ![](url)\n✿RETURN✿: Reply based on tool result'}, 
{'role': 'user', 'content': "What's the weather like in San Francisco?"}, 
{'role': 'assistant', 'content': '✿FUNCTION✿: get_current_weather\n✿ARGS✿: { "location": "San Francisco, CA", "unit": "fahrenheit" }\n✿RESULT✿: {"location": "San Francisco", "temperature": "72", "unit": "fahrenheit"}\n✿RETURN✿: The current weather in San Francisco, CA is 72 degrees Fahrenheit. Enjoy your day!'}, 
{'role': 'user', 'content': 'And, what about Paris?\n\n✿FUNCTION✿: get_current_weather\n✿ARGS✿: { "location": "Paris, France", "unit": "celsius" }\n✿RESULT✿: {"location": "Paris", "temperature": "22", "unit": "celsius"}\n✿RETURN✿'}]

在中间时，需要将带有 function_call 键和 function 角色的消息转换为 assistant 的内容，在需要调用工具时，
将带有function_call和入参的assistant消息转换到上一个user中。
"""


import transformers
from transformers import AutoTokenizer
import copy
import torch
import logging
from typing import Dict, List, Optional, Union
import json, json5
from transformers.trainer_pt_utils import LabelSmoother

FN_NAME = "✿FUNCTION✿"
FN_ARGS = "✿ARGS✿"
FN_RESULT = "✿RESULT✿"
FN_EXIT = "✿RETURN✿"
FN_STOP_WORDS = ['✿RESULT✿', '✿RESULT✿:', '✿RESULT✿:\n']

IGNORE_TOKEN_ID = LabelSmoother.ignore_index

TEMPLATE_WITHOUT_SYSTEM = "{% for message in messages %}{{'<|im_start|>' + message['role'] + '\n' + message['content']}}{% if loop.last %}{{ '<|im_end|>'}}{% else %}{{ '<|im_end|>\n' }}{% endif %}{% endfor %}"


# print(f"FN_NAME: {FN_NAME}\nFN_ARGS: {FN_ARGS}\nFN_RESULT: {FN_RESULT}\nFN_EXIT: {FN_EXIT}\nFN_STOP_WORDS: {FN_STOP_WORDS}")


def process_messages_for_nous(messages: List[Dict]) -> List[Dict]:
    """将messages的消息处理成模型输入与输出的格式,此处不进行tokenize, 支持并行调用工具，但工具响应结果在content需要是list形式，List[原content]
        自动支持并行的格式处理：并content为List时，按并行处理，当不是List时，按串行或单条处理。当然：入参function_call也需要是List形式
    """
    new_messages = []
    skip_idx_list = []
    length = len(messages)
    for idx, msg in enumerate(messages):
        # print("***", idx, msg)
        if not msg or idx in skip_idx_list:
            continue
        elif msg["role"] == "user" or msg["role"] == "assistant":
            if idx < length - 1:
                if 'function_call' not in messages[idx+1]:
                    if "function_call" not in msg:
                        new_messages.append(msg)
                    else:
                        if idx <= length - 4:
                            # tmp_resp = f'{FN_NAME}: {msg["function_call"]["name"]}\n{FN_ARGS}: {msg["function_call"]["arguments"]}\n{FN_RESULT}: {messages[idx+1]["content"]}\n{FN_EXIT}: {messages[idx+2]["content"]}'
                            if isinstance(msg["function_call"], list):
                                tmp_tool_call = '\n'.join(f'<tool_call>\n{f_i}\n</tool_call>' for f_i in msg["function_call"])
                            else:
                                tmp_tool_call = f'<tool_call>\n{msg["function_call"]}\n</tool_call>'
                            if isinstance(messages[idx+1]["content"], list):
                                tmp_tool_response = '\n'.join(f'<tool_response>\n{f_i}\n</tool_response>' for f_i in messages[idx+1]["content"])
                            else:
                                tmp_tool_response = f'<tool_response>\n{messages[idx+1]["content"]}\n</tool_response>'
                            new_messages.append({"role": "assistant", "content": tmp_tool_call})
                            if "slots" in msg:
                                new_messages[-1]["slots"] = msg["slots"]
                            new_messages.append({"role": "user", "content": tmp_tool_response})
                            new_messages.append({"role": "assistant", "content": messages[idx+2]["content"]})
                            if "slots" in messages[idx+2]:
                                new_messages[-1]["slots"] = msg["slots"]

                            # new_messages.append({"role": "assistant", "content": tmp_resp})
                            skip_idx_list.extend([idx+1, idx+2])
                        else:
                            print("messages", messages, idx)
                            raise Exception("Unexpected case")
                else:  # 已经去掉以工具返回结果结尾的对话数据
                    if idx + 1 == length - 1:  # idx为倒数第二个，function_call在最后一个
                        new_messages.append(msg)
                        # tmp_resp = f'{FN_NAME}: {messages[idx+1]["function_call"]["name"]}\n{FN_ARGS}: {messages[idx+1]["function_call"]["arguments"]}\n'
                        # new_messages.append({"role": "assistant", "content": tmp_resp})
                        if isinstance(messages[idx+1]["function_call"], list):
                            tmp_tool_call = '\n'.join(f'<tool_call>\n{f_i}\n</tool_call>' for f_i in messages[idx+1]["function_call"])
                        else:
                            tmp_tool_call = f'<tool_call>\n{messages[idx+1]["function_call"]}\n</tool_call>'
                        new_messages.append({"role": "assistant", "content": tmp_tool_call})
                        if "slots" in messages[idx+1]:
                            new_messages[-1]["slots"] = messages[idx+1]["slots"]
                        skip_idx_list.append(idx+1)

                    elif idx + 1 == length - 3:  # idx为倒数第四个，function_call在倒数第三个，通过倒数第三、第二个，生成倒数第一个
                        # tmp_resp = f'{FN_NAME}: {messages[idx+1]["function_call"]["name"]}\n{FN_ARGS}: {messages[idx+1]["function_call"]["arguments"]}\n{FN_RESULT}: {messages[idx+2]["content"]}\n{FN_EXIT}'
                        # new_messages.append({"role": "user", "content": msg["content"] + f'\n\n{tmp_resp}'})
                        # new_messages.append({"role": msg["role"], "content": msg["content"] + f'\n\n{tmp_resp}'})
                        
                        if isinstance(messages[idx+1]["function_call"], list):
                            tmp_tool_call = '\n'.join(f'<tool_call>\n{f_i}\n</tool_call>' for f_i in messages[idx+1]["function_call"])
                        else:
                            tmp_tool_call = f'<tool_call>\n{messages[idx+1]["function_call"]}\n</tool_call>'
                        if isinstance(messages[idx+2]["content"], list):
                            tmp_tool_response = '\n'.join(f'<tool_response>\n{f_i}\n</tool_response>' for f_i in messages[idx+2]["content"])
                        else:
                            tmp_tool_response = f'<tool_response>\n{messages[idx+2]["content"]}\n</tool_response>'

                        new_messages.append({"role": "assistant", "content": tmp_tool_call})
                        if "slots" in messages[idx+1]:
                            new_messages[-1]["slots"] = messages[idx+1]["slots"]
                        new_messages.append({"role": "user", "content": tmp_tool_response})

                        assert messages[idx+3]["role"] == "assistant"  # 工具返回结果后，必须紧跟assistant角色
                        new_messages.append(messages[idx+3])
                        skip_idx_list.extend([idx+1, idx+2, idx+3])

                    else:  # idx + 1 == length - 4:  # idx为倒数第五个，function_call在倒数第四个，通过倒数第四个，第三个，第二个，生成倒数第一个
                        new_messages.append(msg)
                        # tmp_resp = f'{FN_NAME}: {messages[idx+1]["function_call"]["name"]}\n{FN_ARGS}: {messages[idx+1]["function_call"]["arguments"]}\n{FN_RESULT}: {messages[idx+2]["content"]}\n{FN_EXIT}: {messages[idx+3]["content"]}'
                        # new_messages.append({"role": "assistant", "content": tmp_resp})
                        if isinstance(messages[idx+1]["function_call"], list):
                            tmp_tool_call = '\n'.join(f'<tool_call>\n{f_i}\n</tool_call>' for f_i in messages[idx+1]["function_call"])
                        else:
                            tmp_tool_call = f'<tool_call>\n{messages[idx+1]["function_call"]}\n</tool_call>'
                        if isinstance(messages[idx+2]["content"], list):
                            tmp_tool_response = '\n'.join(f'<tool_response>\n{f_i}\n</tool_response>' for f_i in messages[idx+2]["content"])
                        else:
                            tmp_tool_response = f'<tool_response>\n{messages[idx+2]["content"]}\n</tool_response>'

                        new_messages.append({"role": "assistant", "content": tmp_tool_call})
                        if "slots" in messages[idx+1]:
                            new_messages[-1]["slots"] = messages[idx+1]["slots"]
                        new_messages.append({"role": "user", "content": tmp_tool_response})
                        new_messages.append({"role": "assistant", "content": messages[idx+3]["content"]})
                        if "slots" in messages[idx+3]:
                            new_messages[-1]["slots"] = messages[idx+3]["slots"]

                        skip_idx_list.extend([idx+1, idx+2, idx+3])
            else:
                if "function_call" not in msg:
                    new_messages.append(msg)
                else:
                    # tmp_resp = f'{FN_NAME}: {msg["function_call"]["name"]}\n{FN_ARGS}: {msg["function_call"]["arguments"]}\n'
                    # new_messages.append({"role": "assistant", "content": tmp_resp})
                    if isinstance(msg["function_call"], list):
                        tmp_tool_call = '\n'.join(f'<tool_call>\n{f_i}\n</tool_call>' for f_i in msg["function_call"])
                    else:
                        tmp_tool_call = f'<tool_call>\n{msg["function_call"]}\n</tool_call>'
                    new_messages.append({"role": "assistant", "content": tmp_tool_call})
                    if "slots" in msg:
                        new_messages[-1]["slots"] = msg["slots"]

        elif msg["role"] == "system":
            new_messages.append(msg)
        else:
            print("messages", json.dumps(messages, ensure_ascii=False), idx)
            raise Exception("Unexpected case")
    return new_messages


def process_messages_for_qwen(messages: List[Dict]) -> List[Dict]:
    """将messages的消息处理成模型输入与输出的格式,此处不进行tokenize, 并行调用工具时，需要重构"""
    new_messages = []
    skip_idx_list = []
    length = len(messages)
    for idx, msg in enumerate(messages):
        # print("***", idx, msg)
        if not msg or idx in skip_idx_list:
            continue
        elif msg["role"] == "user" or msg["role"] == "assistant":
            if idx < length - 1:
                if 'function_call' not in messages[idx+1]:
                    if "function_call" not in msg:
                        new_messages.append(msg)
                    else:
                        if idx <= length - 4:
                            tmp_resp = f'{FN_NAME}: {msg["function_call"]["name"]}\n{FN_ARGS}: {msg["function_call"]["arguments"]}\n{FN_RESULT}: {messages[idx+1]["content"]}\n{FN_EXIT}: {messages[idx+2]["content"]}'
                            new_messages.append({"role": "assistant", "content": tmp_resp})
                            skip_idx_list.extend([idx+1, idx+2])
                        else:
                            print("messages", messages, idx)
                            raise Exception("Unexpected case")
                else:  # 已经去掉以工具返回结果结尾的对话数据
                    if idx + 1 == length - 1:  # idx为倒数第二个，function_call在最后一个
                        new_messages.append(msg)
                        tmp_resp = f'{FN_NAME}: {messages[idx+1]["function_call"]["name"]}\n{FN_ARGS}: {messages[idx+1]["function_call"]["arguments"]}\n'
                        new_messages.append({"role": "assistant", "content": tmp_resp})
                        skip_idx_list.append(idx+1)

                    elif idx + 1 == length - 3:  # idx为倒数第四个，function_call在倒数第三个，通过倒数第三、第二个，生成倒数第一个
                        tmp_resp = f'{FN_NAME}: {messages[idx+1]["function_call"]["name"]}\n{FN_ARGS}: {messages[idx+1]["function_call"]["arguments"]}\n{FN_RESULT}: {messages[idx+2]["content"]}\n{FN_EXIT}'
                        # new_messages.append({"role": "user", "content": msg["content"] + f'\n\n{tmp_resp}'})
                        new_messages.append({"role": msg["role"], "content": msg["content"] + f'\n\n{tmp_resp}'})
                        assert messages[idx+3]["role"] == "assistant"  # 工具返回结果后，必须紧跟assistant角色
                        new_messages.append(messages[idx+3])
                        skip_idx_list.extend([idx+1, idx+2, idx+3])

                    else:  # idx + 1 == length - 4:  # idx为倒数第五个，function_call在倒数第四个，通过倒数第四个，第三个，第二个，生成倒数第一个
                        new_messages.append(msg)
                        tmp_resp = f'{FN_NAME}: {messages[idx+1]["function_call"]["name"]}\n{FN_ARGS}: {messages[idx+1]["function_call"]["arguments"]}\n{FN_RESULT}: {messages[idx+2]["content"]}\n{FN_EXIT}: {messages[idx+3]["content"]}'
                        new_messages.append({"role": "assistant", "content": tmp_resp})
                        skip_idx_list.extend([idx+1, idx+2, idx+3])
            else:
                if "function_call" not in msg:
                    new_messages.append(msg)
                else:
                    tmp_resp = f'{FN_NAME}: {msg["function_call"]["name"]}\n{FN_ARGS}: {msg["function_call"]["arguments"]}\n'
                    new_messages.append({"role": "assistant", "content": tmp_resp})

        elif msg["role"] == "system":
            new_messages.append(msg)
        else:
            print("messages", json.dumps(messages, ensure_ascii=False), idx)
            raise Exception("Unexpected case")
    return new_messages


def truncate_messages(messages, tokenizer, max_len):
    """默认第一句不截断，因为默认第一句为system, 从第二句开始截断，截断的最小单元为一条消息"""
    length_list = []
    for msg in messages:     
        tokens = tokenizer.encode(f"<|_start|>{msg['role']}\n{msg['content']}<|_end|>")
        length_list.append(len(tokens))
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


def sliding_window_messages(messages, tokenizer, max_len):
    """使用滑动窗口方式生成训练数据，确保system消息始终在窗口的第一条，并且后续消息不会被截断"""
    length_list = []
    for msg in messages:
        tokens = tokenizer.encode(f"<|im_start|>{msg['role']}\n{msg['content']}<|_end|>")
        length_list.append(len(tokens))

    length_list[:-1] = [length + 1 for length in length_list[:-1]]  # 计算消息间的分隔符占用

    system_msg = messages[0]  # system 消息始终在窗口的第一条
    system_tokens = length_list[0]

    new_datasets = []
    start_idx = 1  # 从第二条消息开始滑动

    while start_idx < len(messages):
        remain_length = max_len - system_tokens
        window_messages = [system_msg]
        end_idx = start_idx

        # 逐步添加尽可能多的消息
        while end_idx < len(messages) and remain_length >= length_list[end_idx]:
            window_messages.append(messages[end_idx])
            remain_length -= length_list[end_idx]
            end_idx += 1

        new_datasets.append(window_messages)

        # 如果 end_idx 已经到达 messages 末尾，则停止滑动
        if end_idx >= len(messages):
            break

        # 依次滑入与滑出，每次仅滑动一条消息
        start_idx += 1

    return new_datasets


def truncate_and_normailize_messages(messages, tokenizer, max_len):
    """根据max_len截断messages, 同时将工具调用的消息转成正常的assistant与user消息"""
    messages = truncate_messages(messages, tokenizer, max_len)
    messages = process_messages_for_qwen(messages)
    return messages


class PreprocessWithLossMask:
    def __init__(self, tokenizer, max_len):
        self.tokenizer = tokenizer
        self.max_len = max_len

        self.seperator = "\n"
        self.token_seperator = self.tokenizer.encode(self.seperator, add_special_tokens=False)  # list

    def sliding_window_messages(self, messages, fn_call_prompt_type="nous"):
        """使用滑动窗口方式生成训练数据，确保system消息始终在窗口的第一条，并且每条消息依次滑入与滑出，overlap最大"""
        length_list = []
        if fn_call_prompt_type == "nous":
            messages = process_messages_for_nous(messages)
        for msg in messages:
            tokens = self.tokenizer.encode(f"<|im_start|>{msg['role']}\n{msg['content']}<|im_end|>")
            length_list.append(len(tokens))

        length_list[:-1] = [length + 1 for length in length_list[:-1]]  # 计算消息间的分隔符占用

        system_msg = messages[0]  # system 消息始终在窗口的第一条
        system_tokens = length_list[0]

        new_datasets = []
        start_idx = 1  # 从第二条消息开始滑动

        while start_idx < len(messages):
            remain_length = self.max_len - system_tokens
            window_messages = [system_msg]
            end_idx = start_idx

            # 逐步添加尽可能多的消息
            while end_idx < len(messages) and remain_length >= length_list[end_idx]:
                window_messages.append(messages[end_idx])
                remain_length -= length_list[end_idx]
                end_idx += 1

            new_datasets.append(window_messages)

            # 如果 end_idx 已经到达 messages 末尾，则停止滑动
            if end_idx >= len(messages):
                break

            # 依次滑入与滑出，每次仅滑动一条消息
            start_idx += 1

        new_datasets = [i for i in new_datasets if i[-1]["role"] == "assistant"]  # 最后一条消息必须是assistant
        return new_datasets

    def preprocess_batch_conversations(self, conversations, fncall_prompt_type="qwen"):
        """一次性处理多个对话"""

        texts_tokens_list = []
        tokens_loss_marks_list = []

        for conversation in conversations:
            if fncall_prompt_type == "qwen":
                if sum([1 if msg.get("loss") else 0 for msg in conversation if msg["role"] == "assistant"]) in [0, 1]:  # 没有loss的字段，则按单轮处理
                    tokens_list, loss_mark_list = self.preprocess_single_conversation_for_single_turn_loss_with_fnc(conversation, fncall_prompt_type=fncall_prompt_type)

                elif sum([1 if "function_call" in msg or msg["role"] in ["function", "tool"] else 0 for msg in conversation]) >= 1:
                    tokens_list, loss_mark_list = self.preprocess_single_conversation_for_single_turn_loss_with_fnc(conversation, fncall_prompt_type=fncall_prompt_type)
                else:
                    tokens_list, loss_mark_list = self.preprocess_single_conversation_for_multi_turn_loss(conversation)
            else:
                tokens_list, loss_mark_list = self.preprocess_single_conversation_for_multi_turn_loss(conversation)

            assert len(tokens_list) == len(loss_mark_list), "====>>tokens与loss_mark的长度不一致"
                
            texts_tokens_list.append(tokens_list)
            tokens_loss_marks_list.append(loss_mark_list)

        # input_ids = torch.tensor(texts, dtype=torch.int)
        input_ids = torch.tensor(texts_tokens_list, dtype=torch.int)
        target_ids = input_ids.clone()
        target_ids[target_ids == self.tokenizer.pad_token_id] = IGNORE_TOKEN_ID
        attention_mask = input_ids.ne(self.tokenizer.pad_token_id)
        loss_mask = torch.as_tensor(tokens_loss_marks_list, dtype=torch.int)

        return dict(
            input_ids=input_ids, target_ids=target_ids, attention_mask=attention_mask, loss_mask=loss_mask,
        )

    def preprocess_single_conversation_for_multi_turn_loss(self, conversation):
        """一次性处理多轮loss, 当包含有工具调用时，不要使用此方法"""
        segments_list = []
        tokens_list = []
        loss_mark_list = []  # 为True的位置，需要计算loss，与loss_mask是相同的概念

        conversation = process_messages_for_nous(conversation)
        conversation = self.truncate_messages(conversation)

        for n_msg, msg in enumerate(conversation):
            if msg["role"] in ["system", "user"]:
                segment = self.tokenizer.apply_chat_template(conversation=[msg], chat_template=TEMPLATE_WITHOUT_SYSTEM, add_generation_prompt=False, tokenize=False, padding=False, max_length=self.max_len, truncation=False)
                tokens = self.tokenizer.encode(text=segment, add_special_tokens=False)
                
                segments_list, tokens_list, loss_mark_list = self.add_seperator(segments_list, tokens_list, loss_mark_list)

                segments_list.extend([segment])
                tokens_list.extend(tokens)
                loss_mark_list.extend([0] * len(tokens))

            elif msg["role"] == "assistant":
                if msg.get("loss", True):
                    weight = msg.get("weight", 1)
                    segment = self.tokenizer.apply_chat_template(conversation=[msg], chat_template=TEMPLATE_WITHOUT_SYSTEM, add_generation_prompt=False, tokenize=False, padding=False, max_length=self.max_len, truncation=False)
                    tokens = self.tokenizer.encode(text=segment, add_special_tokens=False)

                    prefix_tokens = self.tokenizer.encode(f"<|im_start|>assistant\n", add_special_tokens=False)
                    content_tokens = self.tokenizer.encode(msg["content"], add_special_tokens=False)
                    suffix_tokens = self.tokenizer.encode(f"<|im_end|>", add_special_tokens=False)

                    assert len(prefix_tokens + content_tokens + suffix_tokens) == len(tokens), "拆分的tokens总数与整体的tokens长度不一致"

                    segments_list, tokens_list, loss_mark_list = self.add_seperator(segments_list, tokens_list, loss_mark_list)
                    
                    segments_list.extend([segment])
                    tokens_list.extend(tokens)
                    loss_mark_list.extend([0] * len(prefix_tokens) + [weight] * (len(content_tokens) + len(suffix_tokens)))  # <|im_end|>也加上weight

                else:
                    segment = self.tokenizer.apply_chat_template(conversation=[msg], chat_template=TEMPLATE_WITHOUT_SYSTEM, add_generation_prompt=False, tokenize=False, padding=False, max_length=self.max_len, truncation=False)
                    tokens = self.tokenizer.encode(text=segment, add_special_tokens=False)

                    segments_list, tokens_list, loss_mark_list = self.add_seperator(segments_list, tokens_list, loss_mark_list)
                    
                    segments_list.extend([segment])
                    tokens_list.extend(tokens)
                    loss_mark_list.extend([0] * len(tokens))
            else:
                raise Exception("Only support system, user, assistant roles")

        if len(tokens_list) < self.max_len:
            padding_length = self.max_len - len(tokens_list)
            tokens_list += [self.tokenizer.pad_token_id] * padding_length
            loss_mark_list += [0] * padding_length  # No loss calculation for padding

        assert len(tokens_list) == len(loss_mark_list), "====>>tokens与oss_mark的长度不一致"
        return tokens_list, loss_mark_list

    def preprocess_single_conversation_for_single_turn_loss_with_fnc(self, conversation, fncall_prompt_type="qwen"):
        """只处理单轮loss, 包含工具调用，但不支持工具的并行调用，并行调用需要重构新的方法"""
        if fncall_prompt_type == "qwen":
            msg = process_messages_for_qwen(conversation)
        elif fncall_prompt_type == "nous":
            msg = process_messages_for_nous(conversation)
        else:
            raise Exception("fncall_prompt_type只支持qwen和nous")
        # print("====>> processed msg ====>>", msg)

        msg = self.truncate_messages(msg)

        first_partial_tokens = self.tokenizer.apply_chat_template(
            msg[:-1],
            # chat_template=TEMPLATE,
            tokenize=True,
            add_generation_prompt=True,
            padding=False,
            max_length=self.max_len,
            truncation=False
        )
        second_partial_tokens = self.tokenizer.encode(msg[-1]["content"] + "<|im_end|>", add_special_tokens=False)
        # 尤其注意消息间的"\n"换行符，不要计算loss。因此生成的消息为："content + <|im_end|>"。"\n<|im_start|>role\n"需要人工添加上，并且不纳入loss计算。

        all_tokens = first_partial_tokens + second_partial_tokens
        # loss_mask = [0] * len(first_partial_tokens) + [1] * len(second_partial_tokens)
        loss_mask = [0] * len(first_partial_tokens) + [msg[-1].get("weight", 1)] * len(second_partial_tokens)  # <|im_end|>也加上weight

        if len(all_tokens) < self.max_len:
            padding_length = self.max_len - len(all_tokens)
            all_tokens += [self.tokenizer.pad_token_id] * padding_length
            loss_mask += [0] * padding_length  # No loss calculation for padding

        assert len(all_tokens) == len(loss_mask), "====>>texts_single与loss_mask_single的长度不一致"
        return all_tokens, loss_mask        

    def preprocess_single_conversation_for_parallel_fnc(self, conversation):
        pass

    def truncate_messages(self, messages):
        """默认第一句不截断，因为默认第一句为system, 从第二句开始截断，截断的最小单元为一条消息"""
        length_list = []
        for msg in messages:     
            tokens = self.tokenizer.encode(f"<|im_start|>{msg['role']}\n{msg['content']}<|im_end|>")
            length_list.append(len(tokens))
        length_list[:-1] = [length + 1 for length in length_list[:-1]]
        new_messages = []
        remain_length = self.max_len - length_list[0]
        for length, msg in zip(reversed(length_list[1:]), reversed(messages[1:])):
            if remain_length >= length:
                new_messages.insert(0, msg)
                remain_length -= length
            else:
                break
        new_messages.insert(0, messages[0])
        return new_messages

    def add_seperator(self, segments_list, tokens_list, loss_mark_list):
        assert len(tokens_list) == len(loss_mark_list), "长度不一致"
        if segments_list and loss_mark_list and tokens_list:
            segments_list.append(self.seperator)
            tokens_list.extend(self.token_seperator)
            loss_mark_list.append(0)
        return segments_list, tokens_list, loss_mark_list

if __name__ == "__main__":

    model_name_or_path = r"E:\qwen\Qwen2___5-0___5B"
    tokenizer = AutoTokenizer.from_pretrained(
        model_name_or_path,
        model_max_length=4096,
        padding_side="right",
        use_fast=False,
    )

    data_path = r"D:\workplaces\AI-General\data\target\final\1112-1\train_set_for_qwen_agent.jsonl"
    # # data_path = r"c:\Users\yean.zhu\Downloads\error_data.bak1.jsonl"

    with open(data_path, "r", encoding="utf-8") as f:
        lines = f.readlines()
        dataset = [json.loads(line) for line in lines]

    # # # 重新保存
    # # with open(r"c:\Users\yean.zhu\Downloads\error_data.bak1.jsonl", "w", encoding="utf-8") as f:
    # #     for data in dataset:
    # #         f.write(json.dumps(data, ensure_ascii=False) + "\n")

    # # res = process_messages_for_qwen(messages=dataset[38371]["messages"])  # 数据badcase
    # # print(res)
    # # print()
    # # messages = [{'role': 'assistant', 'content': 'hi，我是土巴兔装修顾问小陈，很高兴可以认识您～（人工回复时间早9-晚18.30分）①您提供下【城市+小区名+房屋面积+出租/自住】信息 ②我看到后给您计算装修参考报价，安排设计师出设计方案和报价明细【免费】', 'is_question': False}, {'role': 'user', 'content': '沈阳'}, {'role': 'assistant', 'content': '您是考虑近两三个月装修在了解方案报价吗？', 'is_question': False}, {'role': 'user', 'content': '先了解一下'}, {'role': 'assistant', 'content': '您家是毛坯房还是老房需要改造呀?', 'is_question': False}, {'role': 'user', 'content': '老房'}, {'role': 'assistant', 'content': '这次装修是计划拆成毛坯换个风格含水电一起改造下嘛？', 'is_question': False}, {'role': 'user', 'content': '不'}, {'role': 'assistant', 'content': '好的，厨卫这部分会考虑含水电简单改造下嘛？', 'is_question': False}, {'role': 'user', 'content': '对'}, {'role': 'assistant', 'content': '您这次装修是打算自己住还是出租出去呀？（报价和设计师不同~）', 'is_question': False}, {'role': 'user', 'content': '自己'}, {'role': 'assistant', 'content': '对了，咱房子目前已经交付了对吧', 'is_question': False}, {'role': 'user', 'content': '在住'}, {'role': 'assistant', 'content': '✅目前咱们所在的区域可以享受到【免费】服务 我给您发下风格案例这些  您可以看一看， 我这边免费出参考报价对比看下 ✅合适再做，不合适就不做的， 不收费！目前只是先对比的', 'is_question': False}, {'role': 'assistant', 'content': '咱今天方便设计师过去看下房屋具体情况吗？ 出报价清单/设计图免费的哦 ', 'is_question': True}, {'role': 'user', 'content': '不方便'}, {'role': 'assistant', 'content': '', 'function_call': {'name': 'confirm_appointment', 'arguments': '{"time": "今天", "type": "inconvenient"}'}, 'loss': True}, {'role': 'function', 'name': 'confirm_appointment', 'content': '{"new_time": "下周", "thought": ""}'}, {'role': 'assistant', 'content': '好的， 那要不我先帮您预约设计师 ，看看有没有相似的户型案例和报价可以免费发你参考对比一下 ~  \n\n\n考虑到您目前也定不下具体时间 ，上门量房的话我先安排到下周的样子， 这期间具体时间您和设计师沟通就好，您看这样可以嘛  ？'}, {'role': 'user', 'content': '我只是先了解'}, {'role': 'assistant', 'content': '那我先帮您预约设计师， 等您有空了，可以提前给您先做规划，看看相似户型的方案对比参考， 您也可以先了解对应的风格的报价情况，不会耽误后面的时间哈~'}, {'role': 'function', 'name': 'confirm_appointment', 'content': '{"new_time": "7月20-29日", "thought": ""}'}, {'role': 'assistant', 'content': '现场量房先帮您延期预约到 7月20日~7月29日， 朝九晚八都可以，这期间具体测量时间您和设计师沟通就好，这样您看可以嘛？'}, {'role': 'user', 'content': '还没决定装\n\n\n好'}, {'role': 'assistant', 'content': '', 'function_call': {'name': 'confirm_appointment', 'arguments': '{"time": "7月20-29日", "type": "unspecified"}'}, 'loss': True}, {'role': 'function', 'name': 'confirm_appointment', 'content': '{"new_time": "7月20-29日", "thought": ""}'}, {'role': 'assistant', 'content': '这个没关系呀，我们给您测量完也不是让您现在就装修呢，就像咱们给小孩选择学校一样，前期综合要看学校场地、师资、教育环境，价格等，前期都考察合适了，后面也会更加省心 咱们量房也是一样，第一个量房的时候我们可以从现场考察设计师的专业性； 第二个是通过和设计师沟通，让咱们自己可以更加完善装修的计划和改造想法； 第三个比较重要的是，保证量尺准确性能够规避因为尺寸带来的增项漏项。\n\n\n现场测量主要是为了让设计师更好更加直观的和您沟通您的装修需求，以及房屋的装修细节和工艺的展现。给您细致化的装修设计方案和精确到每一项的报价，全程也不收费的。\n\n\n这是一条引用/回复消息："现场量房先帮您延期预约到 7月20日~7月29日， 朝九晚八都可以，这期间具体测量时间您和设计师沟通就好，这样您看可以嘛？"------到时候出的方案和报价 合适您就用 不合适就当免费对比参考的资料，也方便咱拿着方案报价去多家对比，反正也是不收取您任何费用的，您看可以不？'}, {'role': 'assistant', 'content': '咱们是在哪个小区呢？我看看有没有做过同楼盘的设计师和案例。'}]
    
    # # for i in dataset[38370: 38373]:
    # #     uid = i["uid"]
    # #     messages = i["messages"]
    # #     res = preprocess_for_function_call_in_multi_turn_with_loss_mask(messages=[messages], tokenizer=tokenizer, max_len=4096)
    # #     print(res)

    # output_path = r"c:\Users\yean.zhu\Downloads\new_processed_data.jsonl"
    
    # processed_data = []

    # for i in dataset: 
    #     uid = i["uid"]
    #     messages = i["messages"]
    #     res = process_messages_for_qwen(messages)
    #     processed_data.append({uid: res})

    # with open(output_path, 'w', encoding='utf-8') as f:
    #     json.dump(processed_data, f, ensure_ascii=False, indent=4)
    
    # print(f"Saved processed data to {output_path}")
    # res = preprocess_for_function_call_in_multi_turn_with_loss_mask(messages=[dataset[0]["messages"]], tokenizer=tokenizer, max_len=4096)
    # res = preprocess_for_function_call_in_multi_turn_with_loss_mask(messages=[messages], tokenizer=tokenizer, max_len=3096)
    # print(res)
    preprocess = PreprocessWithLossMask(tokenizer=tokenizer, max_len=1024)

    # data = {"uid": 16480929.0, "messages": [{"role": "system", "content": "## 角色\n你是土巴兔平台的微信核需客服。当前的时间为：2024-04-23(农历：三月十五),周二,晚上,18:33。\n\n## 任务\n你需要按照**工作流程**与用户进行多轮沟通，从而了解用户房屋的：\n- 装修时间\n- 交房时间\n- 量房时间\n- 姓氏\n- 房屋情况\n- 房屋面积\n- 房屋类型（新房、旧房、简装、精装、自建房、农村房、公寓、酒店等）\n- 装修类型（家装、公装）\n- 房屋装修用途（自住、出租）\n- 房屋所在城市及地址、小区名称\n- 装修工程量（整改、局改、硬装、软装、已完成项目）\n\n### 工作流程\n1. 开场白：简要自我介绍，告知添加用户的原因以及询问【城市+小区名+房屋面积+出租/自住】。\n    - 参考话术：hi，我是土巴兔装修管家，很高兴可以认识您～（人工回复时间早9 - 晚18.30分）①您提供下【城市+小区名+房屋面积+出租/自住】信息 ②我看到后给您计算装修参考报价，安排设计师出设计方案和报价明细【免费】\n2. 询问【房屋类型】\n    - 参考话术：请问是毛坯房，还是旧房/精装房呢？\n3. 若用户提及工装，询问工装房屋类型\n    - 参考话术：咱们商铺是毛坯的还是之前装修过的需要翻新呢？\n4. 询问是否已租下商铺\n    - 参考话术：咱们商铺交了定金已经签了合同租下来了嘛？\n5. 介绍免费设计方案和报价流程\n    - 参考话术：我们会安排擅长商铺的设计师帮你出1 - 4套设计方案和报价参考下， 觉得合适可以进一步沟通了解，不合适可以当做市场行情的参考，不收费哦\n6. 询问【装修时间】\n    - 参考话术：是现在在对比，找到满意的报价方案， 4 - 6月份这几月就考虑装修是吗？\n7. 询问【房屋地址】\n    - 参考话术：您商铺是位于哪个位置（村或路段）呀？我看看平台上有没有做过这边房子的案例发您参考~\n    - 参考话术：咱们商铺在哪个位置呢？\n    - 参考话术：是根据您的需求和店铺的位置我们来匹配负责的优质设计师哈~大概的就可以哦\n8. 询问【装修用途】\n    - 参考话术：咱们店铺打算做什么的，给您安排擅长的设计师出设计方案和报价清单\n9. 再次介绍免费服务并邀请量房\n    - 参考话术：✅目前咱们所在的区域可以享受到【免费】服务 我给您发下风格案例这些 您可以看一看 我这边免费出参考报价对比看下 ✅合适再做，不合适就不做的，不收费！目前只是先对比的\n    - 参考话术：明天方便设计师过去商铺看看现场情况。给您出设计方案和报价明细吗？供您提前做个参考对比【全程不收费】\n10. 询问【量房时间】\n    - 参考话术：量房先延后在5.1 - 10号档期，期间具体啥时候去都行 您和设计师沟通约，可以吗？\n11. 询问【称呼】\n    - 参考话术：您贵姓呀\n    - 参考话术：怎么称呼您呢\n\n\n\n注意: 用户的消息和你自己的消息均可触发你选择是否需要调用工具\n\n# 工具\n\n## 你拥有如下工具：\n\n### confirm_appointment\n\nconfirm_appointment: 根据用户在预约上门量房时提到时间与时间类型确定下一次与用户预约上门的时间 输入参数：{type: \"object\", properties: {time: {type: \"string\", description: \"用户方便的上门量房时间，或不方便的上门量房时间，或外出时间，或回家时间，或房子交房或封顶时间或模糊的时间。\"}, type: {type: \"string\", description: \"用户提到的time类型\", \"enum\": [\"convenient\", \"ask_when\", \"inconvenient\", \"return\", \"away\", \"delivery\", \"unspecified\", \"reject\", \"irresolute\"]}}, required: [\"time\", \"type\"]}\n\n## 你可以在回复中插入零次、一次或多次以下命令以调用工具：\n\n✿FUNCTION✿: 工具名称，必须是[confirm_appointment]之一。\n✿ARGS✿: 工具输入\n✿RESULT✿: 工具结果，需将图片用![](url)渲染出来。\n✿RETURN✿: 根据工具结果进行回复"}, {"role": "user", "content": "我已经添加了你，现在我们可以开始聊天了。"}, {"role": "assistant", "content": "hi，我是土巴兔装修管家夏夏，很高兴可以认识您～（人工回复时间早9-晚18.30分）①您提供下【城市+小区名+房屋面积+出租/自住】信息 ②我看到后给您计算装修参考报价，安排设计师出设计方案和报价明细【免费】"}, {"role": "assistant", "content": "你好，在的，请问是毛坯房，还是旧房/精装房呢？[愉快]"}, {"role": "user", "content": "只做家装？\n工装可以吗，商铺"}, {"role": "assistant", "content": "公装会的"}, {"role": "assistant", "content": "咱们商铺是毛坯的还是之前装修过的需要翻新呢》？"}, {"role": "user", "content": "毛坯"}, {"role": "assistant", "content": "咱们商铺交了定金已经签了合同租下来了嘛？"}, {"role": "user", "content": "已经租了"}, {"role": "assistant", "content": "我们会安排擅长商铺的设计师帮你出1-4套设计方案和报价参考下， 觉得合适可以进一步沟通了解，不合适可以当做市场行情的参考，不收费哦[玫瑰]"}, {"role": "assistant", "content": "是现在在对比，找到满意的报价方案， 4-6月份这几月就考虑装修是吗？"}, {"role": "user", "content": "是"}, {"role": "assistant", "content": "好的 ，您商铺是位于哪个位置（村或路段）呀？我看看平台上有没有做过这边房子的案例发您参考~"}, {"role": "assistant", "content": "咱们商铺在哪个位置呢？"}, {"role": "assistant", "content": "是根据您的需求和店铺的位置我们来匹配负责的优质设计师哈~大概的就可以哦"}, {"role": "user", "content": "北站附近"}, {"role": "assistant", "content": "好的，咱们店铺打算做什么的，给您安排擅长的设计师出设计方案和报价清单"}, {"role": "user", "content": "冒菜"}, {"role": "assistant", "content": "好的"}, {"role": "assistant", "content": "✅目前咱们所在的区域可以享受到【免费】服务 我给您发下风格案例这些 您可以看一看 我这边免费出参考报价对比看下 ✅合适再做，不合适就不做的，不收费！目前只是先对比的"}, {"role": "assistant", "content": "明天方便设计师过去商铺看看现场情况。给您出设计方案和报价明细吗？供您提前做个参考对比【全程不收费】"}, {"role": "assistant", "content": "方便去看看吗？不方便也没事可以和我说下，我对接问下设计师"}, {"role": "user", "content": "60 平你直接问一下"}, {"role": "assistant", "content": "给您安排了金牌设计师复尺，测量后会帮您评估搭配选材用料，有一份详细的材料清单供您参考，为您定制专属于您店铺的个性化方案设计，【不收取任何费用的】"}, {"role": "assistant", "content": "这是一条引用/回复消息：\"明天方便设计师过去商铺看看现场情况。给您出设计方案和报价明细吗？供您提前做个参考对比【全程不收费】\"------您看可以不？早9晚8都行的，测量20分钟左右"}, {"role": "assistant", "content": "那这样吧，预约到设计师可以先沟通下需求   根据户型图  您先了解下大概的方案和报价。也先发您相似户型案例和我们的门店地址，"}, {"role": "assistant", "content": "", "function_call": {"name": "confirm_appointment", "arguments": "{\"time\": \"明天\", \"type\": \"inconvenient\"}"}, "loss": True}]}
    # data = {"uid": 384756373.0, "messages": [{"role": "system", "content": "你是土巴兔装修平台的一名客服，你的主要工作为根据用户的需求，收集用户的装修需求、并为用户预约上门量房的时间。今天是2024-09-11,农历:二零二四年八月初九(龙年),周三,晚上,21:32。\n\n注意: 只有用户的消息才能触发你选择是否需要调用工具\n\n# 工具\n\n## 你拥有如下工具：\n\n### confirm_appointment\n\nconfirm_appointment: 根据用户在预约上门量房时提到时间与时间类型确定下一次与用户预约上门的时间 据工具结果进行回复"}, {"role": "user", "content": "我已经添加了你，现在我们可以开始聊天了。"}, {"role": "assistant", "content": "您好，我是土巴兔--小怡，专注从事家装行业已经10年了，看到您最近在关注装修报价，您是无锡市150m²旧房翻新精装要了解装修嘛？确认信息无误后回复OK，我看到后给您出报价单"}, {"role": "user", "content": "ok\nOK"}, {"role": "assistant", "content": "您是考虑近两三个月装修在了解方案报价吗？", "loss": True}, {"role": "user", "content": "是"}, {"role": "assistant", "content": "这次装修是计划拆成毛坯换个风格含水电一起改造下嘛？", "loss": True}, {"role": "user", "content": "是"}, {"role": "assistant", "content": "您这次装修是打算自己住还是出租出去呀？（报价和设计师不同~）", "loss": False}, {"role": "user", "content": "自主"}, {"role": "assistant", "content": "因为有的业主是买的二手房翻新，咱房屋钥匙目前是在手上的是吧？", "loss": True}]}

    res = preprocess.preprocess_batch_conversations(conversations=[dataset[38]["messages"]], fncall_prompt_type="nous")
    print(res)

    new_dataset = preprocess.sliding_window_messages(messages=dataset[38]["messages"])
    print(new_dataset)

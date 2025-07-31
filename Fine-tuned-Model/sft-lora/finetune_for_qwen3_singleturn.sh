#!/bin/bash
export CUDA_DEVICE_MAX_CONNECTIONS=1
DIR=`pwd`

# Guide:
# This script supports distributed training on multi-gpu workers (as well as single-worker training).
# Please set the options below according to the comments.
# For multi-gpu workers training, these options should be manually set for each worker.
# After setting the options, please run the script on each worker.

# Number of GPUs per GPU worker
GPUS_PER_NODE=$(python -c 'import torch; print(torch.cuda.device_count())')

# Number of GPU workers, for single-worker training, please set to 1
NNODES=${NNODES:-1}

# The rank of this worker, should be in {0, ..., WORKER_CNT-1}, for single-worker training, please set to 0
NODE_RANK=${NODE_RANK:-0}

# The ip address of the rank-0 worker, for single-worker training, please set to localhost
MASTER_ADDR=${MASTER_ADDR:-localhost}

# The port for communication
MASTER_PORT=${MASTER_PORT:-6001}

# 新增，支持断点恢复训练
RESUME_FROM_CHECKPOINT=${RESUME_FROM_CHECKPOINT:-""}
RESUME_ARG=""
if [ ! -z "$RESUME_FROM_CHECKPOINT" ]; then
    RESUME_ARG="--resume_from_checkpoint $RESUME_FROM_CHECKPOINT"
fi

DISTRIBUTED_ARGS="
    --nproc_per_node $GPUS_PER_NODE \
    --nnodes $NNODES \
    --node_rank $NODE_RANK \
    --master_addr $MASTER_ADDR \
    --master_port $MASTER_PORT
"

torchrun $DISTRIBUTED_ARGS finetune_for_qwen3_singleturn.py \
    --base_model_path /root/autodl-tmp/model/Qwen/Qwen3-14B \
    --data_path /root/autodl-tmp/dataset/no_fnc_slots_without_think.jsonl \
    --eval_data_path "" \
    --output_dir /root/autodl-tmp/model/output/sft-Qwen3-14B-0526-1-no_fnc_slots-lora64 \
    --num_train_epochs 1 \
    --per_device_train_batch_size 2 \
    --per_device_eval_batch_size 1 \
    --gradient_accumulation_steps 8 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 10 \
    --save_total_limit 10 \
    --learning_rate 3e-4 \
    --weight_decay 0.01 \
    --adam_beta2 0.95 \
    --warmup_ratio 0.01 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --model_max_length 4096 \
    --lazy_preprocess True \
    --gradient_checkpointing True \
    --bf16 True \
    --lora_r 64 \
    --lora_alpha 16 \
    --lora_dropout 0.05 \
    --lora_bias "none" \
    --report_to wandb \
    --run_name sft-Qwen3-14B-0526-1 \
    --wandb_project Qwen3-14B-sft \
    --wandb_api_key fc074cbced804a9bd0407be79fed158981358c03 \
    --deepspeed ds_config_zero2.json \
    $RESUME_ARG
#!/bin/bash

while true
do
    bash finetune_for_qwen3_singleturn.sh
    status=$?
    if [ $status -eq 0 ]; then
        echo "训练正常结束，退出循环。"
        break
    else
        echo "训练异常退出，$status，10秒后重试..."
        sleep 10
    fi
done
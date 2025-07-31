from modelscope.hub.snapshot_download import snapshot_download

model_dir = snapshot_download('Qwen/Qwen3-0.6B', cache_dir=r'/autodl-tmp/workplace/amos/model')
# model_dir = snapshot_download('deepseek-ai/DeepSeek-R1-Distill-Qwen-7B', cache_dir=r'E:')
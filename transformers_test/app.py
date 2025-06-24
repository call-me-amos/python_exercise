import json
import pdb

from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
import torch
# import pdb
from transformers import BertTokenizer, BertForNextSentencePrediction, BertConfig
from logger.logger import logger  # 导入日志记录器

# 初始化日志记录器
log = logger(service='nsp')


# 加载模型和分词器
model_path = "/data1/amos_test/local_mode/bert-chinese-wwm/"
config = BertConfig.from_json_file(f"{model_path}/bert_config.json")
tokenizer = BertTokenizer(vocab_file=f"{model_path}/vocab.txt")
model = BertForNextSentencePrediction.from_pretrained(model_path, config=config)
model.load_state_dict(torch.load("best_model.pth"))  # 加载最优模型
model.eval()

# 创建 FastAPI 实例
app = FastAPI()


# 输入数据模型
class SentencesInput(BaseModel):
    sentence_a: str
    sentence_b: str

# 定义预测函数
def predict_next_sentence(sentence_a: str, sentence_b: str):
    inputs = tokenizer(sentence_a, sentence_b, return_tensors="pt", padding=True, truncation=True, max_length=256)
    with torch.no_grad():
        outputs = model(**inputs)
    logits = outputs.logits
    # pdb.set_trace()
    prob = torch.softmax(logits, dim=-1).tolist()[0]
    label = torch.argmax(logits, dim=-1).item()
    return label, prob[0], prob[1]

# 创建接口
@app.post("/predict/")
def predict(input_data: SentencesInput):
    try:
        sentence_a = input_data.sentence_a
        sentence_b = input_data.sentence_b
        prediction, prob1, prob2 = predict_next_sentence(sentence_a, sentence_b)
        result = "1" if prediction == 1 else "0"
        result_json = {
            "sentence_a": sentence_a,
            "sentence_b": sentence_b,
            "prediction": result,
            "probability_0": prob1,
            "probability_1": prob2
        }
        log.info(f"请求消息体和响应体：{result_json}")
        return result_json
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# 运行服务
# 通过 Uvicorn 运行：uvicorn app:app --reload
# uvicorn app:app --reload --port 8090 --log-level debug --host 0.0.0.0

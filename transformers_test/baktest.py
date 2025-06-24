import requests
'''
    批量回测 句子对模型
'''


data_path = r"datasets/nsp.test.data"
with open(data_path, "r", encoding="utf-8") as f:
    lines = f.readlines()
    fileData = [i.strip().split("\t") for i in lines[0:]]  # 不跳过表头

def call_http(sentence_a, sentence_b):
    url = "http://192.168.11.119:7000/predict"
    data = {
        "sentence_a": sentence_a,
        "sentence_b": sentence_b
    }
    res = requests.post(url=url, json=data)
    return res.json()


if __name__ == '__main__':
    for sentence_a, sentence_b, result in fileData:
        # print(sentence_a, sentence_b, result)
        resp = call_http(sentence_a, sentence_b)
        # {"prediction": result, "probability_0": prob1, "probability_1": prob2}

        print(f"{sentence_a}^{sentence_b}^{resp['prediction']}^{resp['probability_0']}^{resp['probability_1']}")

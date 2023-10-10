import requests

"""
    对比两个字符串的相似度
    如果需要自定义相似度，可以训练自己的模型：train/traindata.py
"""


def load_file(file_id):
    data = open("./{}".format(file_id), "r", encoding="utf-8")
    data = [line.strip() for line in data]
    return data


def call_http(recommend_text, user_say_text):
    if user_say_text == "":
        return "顾问没回复"
    url = "http://192.168.11.114:40122/similarity/v1"
    data = {
        "compare": recommend_text,
        "content": user_say_text
    }
    res = requests.post(url=url, json=data)
    return res.json()


if __name__ == '__main__':
    # id
    data_id = load_file("id.txt")
    # 会话id
    data_chatId = load_file("chatId.txt")
    # 用户回复内容
    data_user_say = load_file("user_say.txt")
    # QA推荐内容
    data_QA_recommend = load_file("QA_recommend.txt")
    # 实发
    data_real = load_file("real.txt")
    # 推荐时间
    data_createTime = load_file("createTime.txt")

    n = len(data_QA_recommend)
    print(f"推荐总数：{n}")
    for i in range(n):
        # if i != 733:
        #     continue
        if "" == data_user_say[i]:
            print(f"第{i}行&{data_id[i]}&{data_chatId[i]}&{data_user_say[i]}&{data_QA_recommend[i]}&顾问没回复&顾问没回复"&{data_createTime[i]})
        else:
            resJson = call_http(data_QA_recommend[i], data_real[i])
            print(f"第{i}行&{data_id[i]}&{data_chatId[i]}&{data_user_say[i]}&{data_QA_recommend[i]}&{data_real[i]}&{resJson}&{data_createTime[i]}")
            if i > 4788:
                print("======================")
                break

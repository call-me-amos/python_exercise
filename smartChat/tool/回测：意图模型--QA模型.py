import requests

"""
    QA数据回测
    方案一：
    1、捞取历史用户回复内容
    2、走QA模型
    3、人工标注准确性
    
    方案二：
    1、捞取历史用户回复内容
    2、走文本分类模型，捞取意图为咨询、询问类型的意图
    3、走QA模型
    4、人工标注准确性
"""
user_reply_list = [
    "我是噔噔噔噔噔噔噔噔",
    "我是黄丽雅",
    "98平",
    "现在不装，下半年即9一10月再考虑谢谢"

]


# 调用意图模型
def call_http_text_intention(content):
    url = "http://192.168.41.112:40015/nlp/nerAndcategory"
    data = {
        "bussinessKey": "intelligentPlatform",
        "bussinessId": "111111",
        "content": content,
        "currentTime": "123"
    }
    res = requests.post(url=url, json=data)
    return res.json()


def call_http_qa_model(qa_text):
    url = "http://192.168.41.112:40015/nlp/qa"
    data = {
        "bussinessId": "1",
        "bussinessKey": "intelligentPlatform",
        "content": qa_text
    }
    res = requests.post(url=url, json=data)
    return res.json()


if __name__ == '__main__':
    for text in user_reply_list:
        resJson = call_http_qa_model(text)
        #print(resJson)
        print(resJson.get("data").get("qaInfoVO", {}))

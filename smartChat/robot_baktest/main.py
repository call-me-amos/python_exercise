#coding=utf-8
# This is a sample Python script.


# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.
import time
import requests
import uuid


def test_bot(user_name, text):

    """

    :param user_name:
    :param text:
    :return:
    """
    
    # url = "https://apigw.to8to.com/cgi/tls/smartChat/testReply"
    # url = "http://10.4.41.34:8849/tls/smartChat/testReply"
    url = "http://192.168.41.142:40701/tls/smartChat/testReply"
    mode = 1
    if text == "":
        print("开启会话: chatId:", user_name)
        mode = 2
    data = {
        "user": user_name,
        # "weChat": "xiaohao",
        "weChat": "WeiDongMing",
        "eventType": mode,
        "reply": text
    }
    # print(data)
    res = requests.post(url=url, json=data)

    return res.json()


def single_test_bot(user_name, text, question_id):
    """

    :param user_name:
    :param text:
    :return:
    """

    # url = "https://apigw.to8to.com/cgi/tls/smartChat/testReply"
    # url = "http://10.4.41.34:8849/tls/smartChat/testReply"
    url = "http://192.168.41.142:40701/tls/smartChat/testReply"
    mode = 1
    if text == "":
        print("开启会话: chatId:", user_name)
        mode = 2
    data = {
        "user": user_name,
        "weChat": "WeiDongMing",
        "eventType": mode,
        "reply": text,
        "preRobotAskId": int(question_id)
    }
    # print(data)
    res = requests.post(url=url, json=data)
    if mode == 2:
        data = {k: v for k, v in res.json().items() if v}
        print("bot: ", data.get("data", {}).get("nextRobotAskContent", " "))
    return res.json()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # text = "start_bot"
    # test_bot(text=text)
    print("开启会话请直接回车!")
    while True:
        text = input("user: ")
        if text == "":
            user_name = str(int(time.time())) + "_" + uuid.uuid4().hex
        # data = single_test_bot(user_name, text, 123)
        data = test_bot(user_name, text)
        data = {k: v for k, v in data.items() if v}
        temp = data.get("data", {})
        state = temp.get("state", {})
        print("state:", state)
        print("bot: " + str(temp.get("nextRobotAskContent", "")))
        print("response:", data)

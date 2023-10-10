import time
import requests
import uuid


def test_bot(user_name, text):
    #url = "https://apigw.to8to.com/cgi/tls/smartChat/testReply"
    url = "http://10.4.42.48:40121/tls/smartChat/testReply"
    #url = "http://192.168.41.142:40701/tls/smartChat/testReply"
    #url = "https://apigw.to8to.com/cgi/tls/smartChat/testReply"
    mode = 1
    if text == "":
        print("开启会话: chatId:", user_name)
        mode = 2
    dataJson = {
        "user": user_name,
        #"user": "wmXookCgAArjI0J7V_EJY_d2IeJN6A2A",
        #"weChat": "13683560870", #线上
        #"weChat": "WeiDongMing", #测试
        "weChat": "tongzhiwei", #新回测配置
        #"weChat": "fantong",
        #"weChat": "13683560870",
        #"weChat": "12361597",
        "eventType": mode,
        #"preRobotAskId": 179,
        "messageId": uuid.uuid4().hex,
        "reply": text

    }
    res = requests.post(url=url, json=dataJson)
    return res.json()


if __name__ == '__main__':
    # text = "start_bot"
    # test_bot(text=text)
    print("开启会话请直接回车!")
    while True:
        text = input("user: ")
        if text == "":
            user_name = str(int(time.time())) + "_" + uuid.uuid4().hex
        result = test_bot(user_name, text)

        temp = result.get("data", {})
        print("bot: " + str(temp.get("nextRobotAskContent", "")))
        state = temp.get("state", {})
        print("state:", state)
        print("response:", result)

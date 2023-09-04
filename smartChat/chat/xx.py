#coding=utf-8
# This is a sample Python script.


# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.
import time
import requests
import uuid
import random

def test_bot(user_name, text):

    """
    :param user_name:
    :param text:
    :return:
    """

    # url = "https://apigw.to8to.com/cgi/tls/smartChat/testReply"
    url = "http://10.4.41.24:40121/tls/smartChat/testReply"
    url = "http://192.168.41.142:40701/tls/smartChat/testReply"
    mode = 1
    if text == "new":
        print("开启会话: chatId:", user_name)
        mode = 2
    data = {
        "user": user_name,
        "weChat": "WeiDongMing",
        "eventType": mode,
        "reply": text
    }
    res = requests.post(url=url, json=data)
    # print(res)
    return res.json()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # text = "start_bot"
    # test_bot(text=text)
    print("=======================================================")
    house = ["毛坯","旧房","不需要","先看看","我想看下效果图"]
    h_data = ["8月","年底","下个月","下周","周二","明年了","不确定呢"]
    xiaoqu = ["深圳万科云城","文心花园","荔枝小区","前海花园","顺天大厦","南阳林溪谷","驻马店建业城邦"]
    mianji = ["100","80平","80m","80 m2","80左右","60","80多"]
    liangfang = ["方便","需要","好的","不需要","行","不方便","可以的","我看看","后面再说"]
    xing = ["齐","毛","赵","欧阳","习","钱"]

    random_value = random.choice(house)
    arr = ["new",random.choice(house),random.choice(h_data),random.choice(xiaoqu),"北京朝阳",random.choice(mianji),
           random.choice(liangfang),random.choice(liangfang),random.choice(liangfang),random.choice(xing)]

    i = 0
    user_name = str(int(time.time())) + "_" + uuid.uuid4().hex
    while bool(arr[i]):
        # text = input("user: ")
        # if text == "new":
        # user_name = str(int(time.time())) + "_" + uuid.uuid4().hex
        # print("=======================================================")
        text = arr[i]
        print("user:", text)
        data = test_bot(user_name, text)
        temp = data.get("data", {})
        # print(temp)
        print("bot: " + str(temp.get("nextRobotAskContent", "")))
        state = temp.get("state", {})
        print("state:", state)

        if str(temp.get("nextRobotAskContent", "")) == "None":
            break;

        if i < len(arr)-1:
            i = i+1
        else:
            break;

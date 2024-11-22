import json
import time
import requests
import uuid

preRobotAskId = 0


def test_bot(user_name, text):
    # 调用 apigw域名，接口返回接口需要微调一下。好像是 data换成result
    # 测试环境
    # url = "https://test-apigw.to8to.com/cgi/tls/smartChat/testReply"
    # 开发本地环境
    url = "http://10.4.42.48:40121/tls/smartChat/testReply"
    # 生产环境
    # url = "https://apigw.to8to.com/cgi/tls/smartChat/testReply"
    mode = 1
    if text == "":
        print("开启会话: chatId:", user_name)
        mode = 2
    dataJson = {
        "user": user_name,
        "weChat": "xiaozhi50",  # 应答50
        # "weChat": "aiCallCheck-1",  # AI外呼核需
        "eventType": mode,
        "preRobotAskId": preRobotAskId,
        "messageId": uuid.uuid4().hex,
        "reply": text,
        "time": None

    }
    res = requests.post(url=url, json=dataJson)
    return res.json()


# 定义一个函数来递归地移除值为 None 的键
def remove_none_values(d):
    if isinstance(d, dict):
        return {k: remove_none_values(v) for k, v in d.items() if v is not None}
    elif isinstance(d, list):
        return [remove_none_values(i) for i in d if i is not None]
    else:
        return d


if __name__ == '__main__':
    print("开启会话请直接回车!")
    while True:
        text = input("【用户】: \r\n    ")
        if text == "":
            user_name = str(int(time.time())) + "_" + uuid.uuid4().hex
        result = test_bot(user_name, text)
        temp = result.get("data", {})
        state = temp.get("state", {})

        # 移除值为 None 的键
        state = remove_none_values(state)
        print("state:\r\n", json.dumps(state, indent=4, ensure_ascii=False))
        print("result:\r\n", result)
        print("【机器人】: \r\n    ①：" + str(temp.get("nextRobotAskContent", [])[0]))
        if len(temp.get("nextRobotAskContent", [])) > 1:
            print("    ②：" + str(temp.get("nextRobotAskContent", [])[1]))

        print()

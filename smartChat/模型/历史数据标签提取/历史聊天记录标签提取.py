import time
import requests
import uuid
import operator
import base64
import pandas as pd

'''
    捞取历史聊天记录，走话术推荐逻辑，提取标签
'''


def load_file(file_id):
    data = open("./{}".format(file_id), "r", encoding="utf-8")
    data = [line.strip() for line in data]
    return data


def test_bot(user_name, text):
    url = "http://10.4.42.48:40121/tls/smartChat/testReply"
    mode = 1
    if text == "":
        chat_id = base64.encodebytes(("tongzhiwei#" + str(user_name)).encode("utf-8"))
        print(f"开启会话: user:{user_name}, chatId={str(chat_id, 'utf-8')}")
        mode = 2
    dataJson = {
        "user": user_name,
        "weChat": "tongzhiwei",  # 设置特殊的顾问id，方便提取数据
        "eventType": mode,
        "messageId": uuid.uuid4().hex,
        "reply": text

    }
    test_bot_res = requests.post(url=url, json=dataJson)
    print(f"test_bot_res={test_bot_res.json()}")
    return test_bot_res.json()


def get_label_obj(text):
    url = "http://192.168.11.116:8992/classify/zw_v1"
    data_json = {
        "id": "1",
        "text": [text]
    }

    label_obj_res = requests.post(url=url, json=data_json)
    if len(label_obj_res.json()["data"]["labels"][0]["predictions"]) == 0:
        return None
    return label_obj_res.json()["data"]["labels"][0]["predictions"][0]


def update_ask_slot(user_name, intention):
    url = "http://10.4.42.48:40121/tls/smartChat/testForHistoryUpdateAskSlot"
    dataJson = {
        "user": user_name,
        "weChat": "tongzhiwei",  # 设置特殊的顾问id，方便提取数据
        "intention": intention
    }
    update_ask_slot_res = requests.post(url=url, json=dataJson)
    return update_ask_slot_res.json()


def process_reply(row_array):
    print(f"process_reply={str(row_array)}")
    row_phone_id = str(row_array[2])
    row_direction = str(row_array[3])
    row_msg_type = str(row_array[5])
    row_content = str(row_array[6])

    if "" == row_content:
        print("回复空字符串")
        return None

    # 只处理文本格式的聊天记录
    if "text" != row_msg_type:
        print("非文本消息，不处理")
        return None

    # 引用消息格式化
    if operator.contains(row_content, "这是一条引用/回复消息"):
        print("引用消息")
        row_content = row_content.split("------")[1]
    if operator.contains(row_content, "- - - - - - - - - - - - - - -"):
        print("引用消息")
        row_content = row_content.split("- - - - - - - - - - - - - - -")[1]

    # 开启会话
    if "我通过了你的联系人验证请求，现在我们可以开始聊天了" == row_content or "我已经添加了你，现在我们可以开始聊天了。" == row_content:
        test_bot(row_phone_id, "")
    elif "2" == row_direction and operator.contains(row_content, "我看到您完善了信息"):
        # 顾问回复-小程序卡 TODO
        print("小程序卡 TODO")
    elif "1" == row_direction:
        # 用户回复。走话术推荐逻辑，完成标签提取
        test_bot(row_phone_id, row_content)
    else:
        # 顾问回复-提问。通过字符相似度匹配逻辑，判断顾问是否在提问
        label_obj_res = get_label_obj(row_content)
        if label_obj_res is None:
            return None

        # 意图
        label_intention = str(label_obj_res["label"]).split("询问")[1]
        if label_intention == "小区地址":
            label_intention = "小区名称"
        if label_intention == "面积":
            label_intention = "房屋面积"
        if label_intention == "其他":
            print("顾问发送其他意图话术")
            return None
        # 更新record当前槽位。存在就不处理，不存在就更新record最新意图
        res = update_ask_slot(row_phone_id, label_intention)
        print(f"更新提问槽位{res}")
    return "success"


if __name__ == '__main__':
    # 打开文件
    data_df = pd.read_excel('C:\\Users\\amos.tong\\Desktop\\历史记录-标签提取\\聊天记录+顾问意图训练数据.xls')

    for index, row in data_df.iterrows():
        process_reply_res = process_reply(row)
        print(f"当前行: {index}, process_reply_res={process_reply_res}")
    print(" ============   over！")

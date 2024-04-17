import time
import requests
import uuid
import operator
import base64
import pandas as pd
import format_mini_program as miniProgramFormat
import jsonmerge
from typing import List
import log

'''
    捞取历史聊天记录，走话术推荐逻辑，提取标签
'''

logger = log.set_log('history_record_server', 'logs', False)


def user_reply(user_name, text, direction):
    url = "http://192.168.41.142:40701/tls/smartChat/historyRecordReply"
    mode = 1
    dataJson = {
        "user": user_name,
        "weChat": "tongzhiwei",  # 设置特殊的顾问id，方便提取数据
        "eventType": mode,
        "messageId": uuid.uuid4().hex,
        "direction": direction,
        "reply": text
    }
    test_bot_res = requests.post(url=url, json=dataJson)
    logger.info(f"test_bot_res={test_bot_res.json()}")
    return test_bot_res.json()


def create_session(user_name):
    url = "http://192.168.41.142:40701/tls/smartChat/historyRecordCreate"
    chat_id = base64.encodebytes(("tongzhiwei#" + str(user_name)).encode("utf-8"))
    logger.info(f"开启会话: user:{user_name}, chatId={str(chat_id, 'utf-8')}")
    dataJson = {
        "user": user_name,
        "weChat": "tongzhiwei"
    }
    create_session_res = requests.post(url=url, json=dataJson)
    logger.info(f"test_bot_res={create_session_res.json()}")
    return create_session_res.json()


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
    url = "http://192.168.41.142:40701/tls/smartChat/testForHistoryUpdateAskSlot"
    dataJson = {
        "user": user_name,
        "weChat": "tongzhiwei",
        "intention": intention
    }
    update_ask_slot_res = requests.post(url=url, json=dataJson)
    return update_ask_slot_res.json()


def historyRecordMiniProgram(user_name, message={}):
    url = "http://192.168.41.142:40701/tls/smartChat/historyRecordMiniProgram"
    dataJson = {
        "user": user_name,
        "weChat": "tongzhiwei"
    }
    dataJson = jsonmerge.merge(dataJson, message)
    logger.info(f"小程序卡请求参数：{dataJson}")
    historyRecordMiniProgram_res = requests.post(url=url, json=dataJson)
    return historyRecordMiniProgram_res.json()


def historyRecordFindTagByPhoneId(user_name):
    url = "http://192.168.41.142:40701/tls/smartChat/historyRecordFindTagByPhoneId"
    dataJson = {
        "user": user_name,
        "weChat": "tongzhiwei"
    }
    logger.info(f"统计会话收集到的标签详情 req：{dataJson}")
    historyRecordFindTagByPhoneId_res = requests.post(url=url, json=dataJson).json()
    logger.info(f"统计会话收集到的标签详情 res：{historyRecordFindTagByPhoneId_res}")
    return historyRecordFindTagByPhoneId_res


def process_reply(row_array):
    logger.info(f"当前行数据 row={str(row_array)}")
    row_phone_id = str(row_array[2])
    row_direction = str(row_array[3])
    row_send_time = int(row_array[4])
    row_msg_type = str(row_array[5])
    row_content = str(row_array[6])

    if "" == row_content:
        logger.info("回复空字符串")
        return None

    # 只处理文本格式的聊天记录
    if "text" != row_msg_type:
        logger.info("非文本消息，不处理")
        return None

    # 引用消息格式化
    if operator.contains(row_content, "这是一条引用/回复消息"):
        row_content = row_content.split("------")[1]
    if operator.contains(row_content, "- - - - - - - - - - - - - - -"):
        row_content = row_content.split("- - - - - - - - - - - - - - -")[1]

    # # 测试代码
    # if row_content == "有合适的方案和报价，是有考虑10-12月份装修是嘛？":
    #     print("测试数据")

    # 开启会话
    if "我通过了你的联系人验证请求，现在我们可以开始聊天了" == row_content or "我已经添加了你，现在我们可以开始聊天了。" == row_content:
        create_session(row_phone_id)
        return "success"
    if "2" == row_direction and (
            operator.contains(row_content, "我看到您完善了信息") or operator.contains(row_content, "hello，咱们填写的信息是")):
        miniProgramFormatRes = miniProgramFormat.get_tag(row_content, row_send_time)
        logger.info(f"小程序卡结构化结果：{miniProgramFormatRes}")
        if miniProgramFormatRes is not None:
            historyRecordMiniProgram_res = historyRecordMiniProgram(row_phone_id, miniProgramFormatRes)
            logger.info(f"回复小程序卡内容处理完成,res:{historyRecordMiniProgram_res}")
        return "success"
    if "1" == row_direction:
        # 用户回复。走话术推荐逻辑，完成标签提取
        user_reply(row_phone_id, row_content, row_direction)
        return "success"
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
            logger.info("顾问发送其他意图话术")
            return None
        # 更新record当前槽位。存在就不处理，不存在就更新record最新意图
        update_ask_res = update_ask_slot(row_phone_id, label_intention)
        logger.info(f"更新提问槽位{update_ask_res}")
    return "success"


def import_historyRecord_and_findTagByPhoneId(req: List[List[str]], uid: str):
    # 模拟json_array用这个
    # 企微号，外部联系人id，电话id，direction，发送时间，msg_type，发送内容
    for index in range(len(req)):
        row = req[index]
        process_reply_res = process_reply(row)
        logger.info(f"当前行: {index + 1}, process_reply_res={process_reply_res}")

    logger.info(" 历史聊天记录解析完成，可以查询提取结果了！")
    # 所有聊天记录提取完成之后，再调用本方法获取提取到的标签详情。
    record_res = historyRecordFindTagByPhoneId(uid)
    logger.info(f"标签提取结果 data={record_res['data']}")
    return record_res


if __name__ == '__main__':
    # # 模拟数据源
    data_list = [[
        '19820810743', 'wmJiIbDAAAGcyu8a_2YetfpJ4d3XJE2w', '30113407', '1', '1698485034', 'text',
        '我已经添加了你，现在我们可以开始聊天了。'],
        [
            '19820810743', 'wmJiIbDAAAGcyu8a_2YetfpJ4d3XJE2w', '30113407', '2', '1698485034', 'text',
            '哈喽，我是土巴兔伊白顾问（人工回复时间：早9:00~晚18:30）不是机器人哦~ ①您提供下【贵姓+城市+小区名+房屋面积+毛坯/旧房整改+自住/出租】信息 ②我看到后给您计算装修参考报价，安排设计师出设计方案和报价明细哈【免费】'],
        [
            '19820810743', 'wmJiIbDAAAGcyu8a_2YetfpJ4d3XJE2w', '30113407', '1', '1698485034', 'text',
            '乔先生北京市通州区方恒东景建筑面积 83.77 平米旧房整改自住'],
        [
            '19820810743', 'wmJiIbDAAAGcyu8a_2YetfpJ4d3XJE2w', '30113407', '2', '1698485034', 'text',
            '好的，咱是全部翻新墙面地面水电整改，重新换个风格一起做嘛？']]
    # import_historyRecord_and_findTagByPhoneId(data_list)

    # excel 数据源
    data_df = pd.read_excel('C:\\Users\\amos.tong\\Desktop\\历史记录-标签提取\\1-测试表格.xlsx', sheet_name='5062370')
    for index, row in data_df.iterrows():
        process_reply_res = process_reply(row)
        print(f"当前行: {index + 1}, process_reply_res={process_reply_res}")

    print(" 历史聊天记录解析完成，可以查询提取结果了！")
    # 所有聊天记录提取完成之后，再调用本方法获取提取到的标签详情。
    res = historyRecordFindTagByPhoneId('5062370')
    print(f"标签提取结果 data={res['data']}")

    print(" ============   over！")

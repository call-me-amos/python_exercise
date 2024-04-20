"""
    excel表头：策略名称	规则条件	跳转策略	询问槽位	话术内容	赋值操作
    根据：询问槽位	话术内容 生成话术，并且批量启用

"""
import warnings
import requests
import pandas as pd

'''
    捞取历史聊天记录，走话术推荐逻辑，提取标签
'''
# 默认模板名
template_id = 60

excel_name = "C:\\Users\\amos.tong\\Desktop\\条件跳转\\智能应答策略2.0-7.xlsx"

ticket = "?uid=20678&ticket=AWAMY52PNGc1k8Nvwm9Al_4eUFeUpyykcVhIrztXNSt1byUrUzSHihfhJzf_xOpuT1XysE-C7aG3HLaLVCbUA7eLf4Cclu4YiGw4AnXnOwXwJQDg1CE9pjUMEiMmV2q5&appName=operat-tools&refsrc=%2F"

# 槽位中文名和code映射关系
check_type_code_mapping = {"开场白-澄清槽位-城市": "7!711!71102!56"}


def createOrUpdate(robotAskId, check_type_code, replyListContent):
    url = "https://test-apigw.to8to.com/cgi/tls/smartChatRobotAsk/createOrUpdate" + ticket
    dataJson = {
        "data": {
            "id": robotAskId,
            "relateTemplateId": template_id,
            "delayTime": 0,
            "type": 0,
            "checkTypeCode": check_type_code,
            "backDelayTime": 0,
            "replyList": [
                {
                    "sendWeiXinCardId": "",
                    "content": replyListContent,
                    "photoFileUrl": "",
                    "photoLink": "",
                    "router": "",
                    "targetUrl": "",
                    "type": 0,
                    "delayTime": 0
                }
            ],
            "backReplyList": [],
            "defaultReplyList": [
                {
                    "tagStatus": 0,
                    "robotAskId": robotAskId,
                    "relateRobotAskId": 0,
                    "updateUser": 20678,
                    "updateTime": 1713321943,
                    "type": 2,
                    "affNegIntentionName": "肯定回答",
                    "content": "/",
                    "stopRobotMsg": 0,
                    "createTime": 1713258877,
                    "createUser": 21227,
                    "id": 5716,
                    "intentionName": "",
                    "hasRelate": "true"
                }
            ],
            "noResponseList": [
                # {
                #     "sendWeiXinCardId": "",
                #     "content": "1-您在哪个区？？",
                #     "delayTime": 12,
                #     "photoFileUrl": "",
                #     "photoLink": "",
                #     "router": "",
                #     "targetUrl": "",
                #     "type": 0
                # }
            ],
            "defaultReplySubtitle": ""
        }
    }
    res = requests.post(url=url, json=dataJson).json()
    return res


def queryContentByChatIdAndCheckTypeCode(askSlot):
    url = "https://test-apigw.to8to.com/cgi/tls/smartChat/oms/findByTemplateIdAndCheckTypeCode" + ticket
    # url = "http://10.4.42.48:40121/tls/smartChat/oms/findByTemplateIdAndCheckTypeCode"
    dataJson = {
        "templateId": template_id,
        "askSlot": askSlot
    }
    res = requests.post(url=url, json=dataJson).json()
    return res


def effectOrInvalid(status, ids):
    url = "https://test-apigw.to8to.com/cgi/tls/smartChatRobotAsk/effectOrInvalid" + ticket
    # url = "http://10.4.42.48:40121/tls/smartChatRobotAsk/effectOrInvalid"
    dataJson = {
        "status": status,
        "ids": [ids]
    }
    res = requests.post(url=url, json=dataJson).json()
    return res


if __name__ == '__main__':
    # 忽略特定警告
    warnings.filterwarnings('ignore', message="Workbook contains no default style, apply openpyxl's default")
    # excel 数据源
    # data_df = pd.read_excel(excel_name, sheet_name='策略规则')
    data_df = pd.read_excel(excel_name)
    for index, row in data_df.iterrows():
        # if index > 2:
        #     break
        ask_slot = str(row[3])
        robotAskContent = str(row[4])
        if ask_slot == "/":
            continue
        check_type_code = check_type_code_mapping.get(ask_slot)
        if check_type_code is None:
            print(f"异常的槽位，不配置话术:{ask_slot}")
            continue
        robotAsk = queryContentByChatIdAndCheckTypeCode(check_type_code)
        new_add_id = 0
        new_update_id = 0
        if ("data" in robotAsk and robotAsk["data"] is None) or ("result" in robotAsk and robotAsk["result"] is None):
            new_add_id = createOrUpdate(0, check_type_code, robotAskContent)['result']
            # 启用话术
            effectOrInvalid(1, new_add_id)
        elif "result" in robotAsk and robotAsk["result"] is not None:
            new_update_id = robotAsk["result"]["id"]
            createOrUpdate(new_update_id, check_type_code, str(robotAskContent))
        else:
            print(f"error: 服务调用异常 {ask_slot}")
            break
        if new_add_id != 0:
            print(f"新增话术id{new_add_id}询问槽位：{ask_slot} code：{check_type_code_mapping.get(ask_slot)}话术：{robotAskContent}")
        else:
            print(
                f"更新话术id{new_update_id}询问槽位：{ask_slot} code：{check_type_code_mapping.get(ask_slot)}话术：{robotAskContent}")

    print(" ============   over！")

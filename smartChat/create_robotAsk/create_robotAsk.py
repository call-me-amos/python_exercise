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
check_type_code_mapping = {"开场白-澄清槽位-城市": "7!711!71102!56", "硬装需求": "7!711!71102!19", "仅加微-引导操作加微": "7!711!71102!82",
                           "装修用途": "7!711!71102!22", "正问装修时间": "7!711!71102!53", "开场白-澄清槽位-房屋面积": "7!711!71102!57",
                           "已做工程项": "7!711!71102!210", "工程项": "7!711!71102!208", "地址追问-小区地址-农村自建房": "7!711!71102!42",
                           "填充话术-装修时间-带槽位开场白场景替换话术": "7!711!71102!77", "房屋类型-局改": "7!711!71102!60",
                           "装修时间": "7!711!71102!1", "房屋类型-暂不方便沟通": "7!711!71102!85", "工程量-缺少水电": "7!711!71102!26",
                           "交房时间": "7!711!71102!13", "工程量-只有否定局改详情": "7!711!71102!32",
                           "地址追问-小区地址-咨询设计方案": "7!711!71102!47", "工程量-只有局改详情": "7!711!71102!25",
                           "仅加微-挽留话术": "7!711!71102!81", "房屋类型-自建房": "7!711!71102!30", "仅加微-告知平台服务": "7!711!71102!83",
                           "工程量（整局改）": "7!711!71102!87", "是否精装房": "7!711!71102!206", "仅加微-开场白": "7!711!71102!79",
                           "工程量-已有": "7!711!71102!37", "工程量-图核工程量": "7!711!71102!68", "电话": "7!711!71102!17",
                           "小区地址": "7!711!71102!214", "工程量-只有否定局改空间": "7!711!71102!31", "房屋类型": "7!711!71102!4",
                           "开场白-澄清槽位": "7!711!71102!54", "同步项目信息": "7!711!71102!300", "工程量-只有局改空间": "7!711!71102!24",
                           "预约全屋定制": "7!711!71102!18", "装修预算": "7!711!71102!15", "地址追问-小区地址-收到户型图": "7!711!71102!45",
                           "需求类型": "7!711!71102!84", "地址追问-小区地址-非农村自建房": "7!711!71102!43",
                           "填充话术-农村自建房-追问小区地址话术": "7!711!71102!71", "工程量-否定意图追问": "7!711!71102!70",
                           "工程空间": "7!711!71102!209", "工程量-无空间和局改详情": "7!711!71102!29", "房屋类型-毛坯出租": "7!711!71102!63",
                           "是否交房": "7!711!71102!20", "房屋类型-新房": "7!711!71102!61", "地址追问-小区地址-咨询报价": "7!711!71102!48",
                           "开场白-澄清槽位-超时促开口话术": "7!711!71102!69", "反向-房屋类型": "7!711!71102!73", "姓氏": "7!711!71102!11",
                           "交房时间-三个月后交房": "7!711!71102!50", "装修类型": "7!711!71102!34", "是否自建房": "7!711!71102!207",
                           "开场白-澄清槽位-房屋类型": "7!711!71102!55", "房屋类型-精装房": "7!711!71102!62",
                           "地址追问-小区地址-模糊楼盘": "7!711!71102!44", "开场白-澄清槽位-装修用途": "7!711!71102!58",
                           "工程量": "7!711!71102!8", "到店时间": "7!711!71102!203", "价值点-房屋类型-追问1": "7!711!71102!86",
                           "房屋面积": "7!711!71102!2", "居住类型": "7!711!71102!7", "反问装修时间": "7!711!71102!51",
                           "时间": "7!711!71102!14", "默认填充编码": "7!711!71102!0", "是否毛坯": "7!711!71102!205",
                           "工程量-只做墙面": "7!711!71102!27", "填充话术-有城市无小区地址-追问小区地址话术": "7!711!71102!72",
                           "房屋类型-追问1": "7!711!71102!65", "填充话术-旧房翻新-替换交房时间话术": "7!711!71102!74",
                           "地址追问-城市": "7!711!71102!40", "工程量-非局改范围": "7!711!71102!28", "房屋类型-澄清槽位值": "7!711!71102!67",
                           "房屋用途": "7!711!71102!204", "量房时间": "7!711!71102!212", "街道": "7!711!71102!9",
                           "工程量-未识别到工程量": "7!711!71102!33", "区县": "7!711!71102!10", "小区名称": "7!711!71102!3",
                           "地址追问-城市澄清问": "7!711!71102!41", "仅加微-告知加微原因": "7!711!71102!80", "装修风格": "7!711!71102!5",
                           "装修时间-三个月外": "7!711!71102!35", "房屋类型-追问2": "7!711!71102!66", "待做工程项": "7!711!71102!211",
                           "询问装修时间": "7!711!71102!52", "地址追问-小区地址-回复房屋信息": "7!711!71102!46", "意向量房时间": "7!711!71102!6",
                           "量房时间-一个月外": "7!711!71102!36", "是否全屋定制": "7!711!71102!12", "性别": "7!711!71102!201",
                           "虚拟房屋类型": "7!711!71102!213", "外出回来时间": "7!711!71102!23", "交房类型": "7!711!71102!202",
                           "手机号": "7!711!71102!21", "房屋类型-精装": "7!711!71102!64", "开场白-澄清槽位-装修时间": "7!711!71102!59",
                           "城市": "7!711!71102!16"}


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
            "defaultReplyList": [],
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
                # },
                # {
                #     "sendWeiXinCardId": "",
                #     "content": "1187",
                #     "delayTime": 24,
                #     "photoFileUrl": "",
                #     "photoLink": "",
                #     "router": "",
                #     "targetUrl": "",
                #     "type": 3
                # },
                # {
                #     "sendWeiXinCardId": "",
                #     "content": "2-您在哪个区？？",
                #     "delayTime": 36,
                #     "photoFileUrl": "",
                #     "photoLink": "",
                #     "router": "",
                #     "targetUrl": "",
                #     "type": 5,
                #     "subCheckTypeCode": "7!711!71102!12"
                # },
                # {
                #     "sendWeiXinCardId": "",
                #     "content": "3-您在哪个区？？",
                #     "delayTime": 48,
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

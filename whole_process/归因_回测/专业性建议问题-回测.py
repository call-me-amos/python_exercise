import json
from datetime import datetime

import whole_process.归因_回测.common as common
from diy_config.config import ConfigManager

config_manager = ConfigManager("config.ini")
# 获取特定配置值
api_key = config_manager.get_value("知识-专业性建议问题-回测", "api_key")
fastgpt_api_url = config_manager.get_value("知识-专业性建议问题-回测", "fastgpt_api_url")

# fastgpt工作流日志
file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems-20251107.json"
output_file = f"C:/Users/amos.tong/Desktop/归因/归因_每天/知识-专业性建议问题-回测-结果-{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.xlsx"


def init_config():
    config_manager = ConfigManager("config.ini")
    # 获取特定配置值
    api_key = config_manager.get_value("知识-专业性建议问题-回测", "api_key")
    fastgpt_api_url = config_manager.get_value("知识-专业性建议问题-回测", "fastgpt_api_url")
    return api_key, fastgpt_api_url


def process_all_rows(max_row, api_key, fastgpt_api_url, data_list=None):
    results = []
    if data_list is None or len(data_list) == 0:
        data_list = common.read_json_file(file_path)
    for index, item in enumerate(data_list):
        try:
            if index > max_row:
                print(f"当前行：{index}，超过最大值，不再处理后续数据")
                break

            print(f"当前fastgpt处理行：{index}")
            responseData = item['responseData']
            if len(responseData) == 0:
                continue

            # list转成map。key：工作流组价的名称，value：节点对象。避免节点调整，导致list中的数序变化
            responseData_map = {item['moduleName']: item for i, item in enumerate(responseData)}

            # slots 槽位信息
            slots_list = responseData_map['代码运行#判断最后一句消息角色']['customOutputs']['slots']

            # 角色判断
            last_say_role_str = responseData_map['代码运行#判断最后一句消息角色']['customOutputs'][
                '最后一句消息发送人角色']
            if '用户' != last_say_role_str:
                continue

            # 用户问题
            user_question_str = responseData_map['AI对话-首轮槽位变量赋值']['query']

            # 将messages转成conversation
            conversation_str = responseData_map['将messages转成conversation']['pluginOutput']['conversation']
            messages_list = responseData_map['将messages转成conversation']['pluginDetail'][1]['customInputs'][
                'messages']

            # 当前询问槽位
            current_ask_slot_str = responseData_map['槽位话术解析']['customOutputs']['question']
            # 当前槽位问题
            answer_str = responseData_map['槽位话术解析']['customOutputs']['answer']

            # QA回复话术
            qa_undertake = responseData_map['咨询承接 -时间压缩']['pluginOutput']['咨询承接响应']

            # 专业性建议
            pro_suggestion = ''
            if responseData_map['专业度承接-时间压缩'] is not None and len(responseData_map['专业度承接-时间压缩']) > 0:
                pro_suggestion = responseData_map['专业度承接-时间压缩']['pluginOutput']['承接综合回复']

            # 需要获取的键名集合
            keys_to_search = {"phoneId", "chatId", "外部联系人id"}
            # 调用方法
            value_from_slots = common.parse_filed_from_slots(slots_list, keys_to_search)

            payload = {
                "variables": {
                    "用户问题": user_question_str,
                    "messages": messages_list,
                    "slots": slots_list,
                    "当前询问槽位": current_ask_slot_str,
                    "当前槽位问题": answer_str,
                    "专业性建议-预测": pro_suggestion,
                    "QA回复话术-预测": qa_undertake
                },
                "messages": messages_list
            }
            content_str = common.call_fastgpt_api(payload, api_key, fastgpt_api_url)
            content_json = json.loads(content_str, strict=False)

            # 拼接返回行数据
            result = {
                '序号': index,
                'phoneId': value_from_slots.get("phoneId"),
                'chatId': value_from_slots.get("chatId"),
                'uid': value_from_slots.get("外部联系人id"),
                '用户问题': user_question_str,
                'messages': messages_list,
                '历史槽位信息': slots_list,
                '当前询问槽位': current_ask_slot_str,
                '当前槽位问题': answer_str,
                '专业性建议-预测': pro_suggestion,
                'QA回复话术-预测': qa_undertake,

                'QA回复话术是否合适': content_json.get('QA回复话术是否合适', ''),
                'QA回复话术不合适理由': content_json.get('QA回复话术不合适理由', ''),
                '专业性建议是否合适': content_json.get('专业性建议是否合适', ''),
                '专业性建议是否合适的理由': content_json.get('专业性建议是否合适的理由', '')
            }
            results.append(result)
        except Exception as e:
            print(f"index={index}，数据解析异常 e={e}")
    return results


if __name__ == "__main__":
    print("开始处理。。。。。")
    results = process_all_rows(2000, api_key, fastgpt_api_url,[])
    common.write_to_excel(results, output_file)
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    print("@@@@@@@@@@  处理完成  @@@@@@@@@@@@@")
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")

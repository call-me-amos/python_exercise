import json
from datetime import datetime

import whole_process.归因_回测.common as common
from diy_config.config import ConfigManager

config_manager = ConfigManager("config.ini")
# 获取特定配置值
api_key = config_manager.get_value("引导任务-快核需", "api_key")
fastgpt_api_url = config_manager.get_value("引导任务-快核需", "fastgpt_api_url")

# fastgpt工作流日志
file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems-20251107.json"
output_file = f"C:/Users/amos.tong/Desktop/归因/归因_每天/引导任务-快核需-回测-结果-{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.xlsx"


def init_config():
    config_manager = ConfigManager("config.ini")
    # 获取特定配置值
    api_key = config_manager.get_value("引导任务-快核需", "api_key")
    fastgpt_api_url = config_manager.get_value("引导任务-快核需", "fastgpt_api_url")
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

            print(f"当前行：{index}")
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

            pluginDetail_check = responseData_map['引导任务-时间压缩-俊山#2']['pluginDetail']
            pluginDetail_check_map = {item['moduleName']: item for i, item in enumerate(pluginDetail_check)}
            new_slots_json = pluginDetail_check_map['代码运行#槽位赋值']['customInputs']['data1']

            # 需要获取的键名集合
            keys_to_search = {"phoneId", "chatId", "外部联系人id"}
            # 调用方法
            value_from_slots = common.parse_filed_from_slots(slots_list, keys_to_search)

            payload = {
                "variables": {
                    "用户问题": user_question_str,
                    "messages": messages_list,
                    "当前提取到的最新槽位": new_slots_json
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
                'messages': json.dumps(messages_list, indent=2, ensure_ascii=False),
                '当前提取到的最新槽位': new_slots_json,

                'ner提取结果是否一致': content_json.get('ner提取结果是否一致', ''),
                'ner提取结果差异': content_json.get('ner提取结果差异', ''),
                'ner提取明细': json.dumps(content_json.get('ner提取明细', ''), indent=2, ensure_ascii=False),
            }
            results.append(result)
        except Exception as e:
            print(f"index={index}，数据解析异常，错误信息：{e}")
            continue
    return results


if __name__ == "__main__":
    print("开始处理。。。。。")
    api_key, fastgpt_api_url = init_config()
    results = process_all_rows(2000, api_key, fastgpt_api_url,[])
    common.write_to_excel(results, output_file)
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    print("@@@@@@@@@@  处理完成  @@@@@@@@@@@@@")
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")

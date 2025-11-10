import json
from datetime import datetime

import whole_process.归因_回测.common as common
from diy_config.config import ConfigManager

file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems-20251107.json"
output_file = f"C:/Users/amos.tong/Desktop/归因/归因_每天/情绪价值承接-回测-结果-{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.xlsx"


def init_config():
    """初始化配置信息"""
    config_manager = ConfigManager("config.ini")
    # 获取特定配置值
    api_key = config_manager.get_value("情绪价值承接-回测", "api_key")
    fastgpt_api_url = config_manager.get_value("情绪价值承接-回测", "fastgpt_api_url")
    return api_key, fastgpt_api_url


def process_all_rows(max_row, api_key, fastgpt_api_url, data_list=None):
    results = []
    if data_list is None or len(data_list) == 0:
        data_list = common.read_json_file(file_path)
    for index, item in enumerate(data_list):
        try:
            if index > max_row:
                print(f"当前行：{index}，超过最大值{max_row}，不再处理后续数据")
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

            # 情绪承接话术
            emotions_undertake = responseData_map['情绪承接-时间压缩']['pluginOutput']['情绪价值承接话术']
            # 情绪价值标签
            emotions_flag = responseData_map['情绪承接-时间压缩']['pluginOutput']['情绪价值标签']

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
                    "情绪标签-预测": emotions_flag,
                    "综合回复-预测": emotions_undertake
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
                '历史对话': json.dumps(messages_list, indent=4, ensure_ascii=False),
                '历史槽位信息': slots_list,
                '当前询问槽位': current_ask_slot_str,
                '当前槽位问题': answer_str,
                '情绪标签-预测': emotions_flag,
                '综合回复-预测': emotions_undertake,
                '情绪标签是否一致': content_json.get('情绪标签是否一致', ''),
                '综合回复是否一致': content_json.get('综合回复是否一致', ''),
                '情绪标签不一致的理由': content_json.get('情绪标签不一致的理由', ''),
                '综合回复不合适理由': content_json.get('综合回复不合适理由', '')
            }
            results.append(result)
        except KeyError as e:
            print(f"index={index}，数据解析异常 {e}")
            continue
    return results


if __name__ == "__main__":
    print("情绪价值承接_回测 开始处理。。。。。")
    api_key, fastgpt_api_url = init_config()
    results = process_all_rows(1000, api_key, fastgpt_api_url, [])
    common.write_to_excel(results, output_file)
    print("over。。。。")

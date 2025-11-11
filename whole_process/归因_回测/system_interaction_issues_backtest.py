import json
from datetime import datetime

import whole_process.归因_回测.common as common
from diy_config.config import ConfigManager
from metabase_utils.prestodb_my import query_from_db

file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems-20251107.json"
output_file = f"C:/Users/amos.tong/Desktop/归因/归因_每天/系统交互问题-回测-结果-{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.xlsx"


def init_config():
    config_manager = ConfigManager("config.ini")
    # 获取特定配置值
    api_key = config_manager.get_value("系统交互问题-回测", "api_key")
    fastgpt_api_url = config_manager.get_value("系统交互问题-回测", "fastgpt_api_url")
    return api_key, fastgpt_api_url


# 获取消息列表
def getTransferManualReasonByChartId(chartId):
    query_sql = f"""
    select chat_id,transfer_manual_reason
    from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record
    WHERE chat_id = '{chartId}' and deleted =0
    """
    messages = query_from_db(query_sql)
    return messages


def process_all_rows(max_row, api_key, fastgpt_api_url, data_list=None):
    results = []
    chat_id_map = {}
    match_chat_id_set = []
    if data_list is None or len(data_list)==0:
        data_list = common.read_json_file(file_path)
    for index, item in enumerate(data_list):
        try:
            # if index < 300:
            #     continue
            print(f"当前fastgpt处理行 系统交互问题：{index}")
            responseData = item['responseData']
            if len(responseData) == 0:
                continue

            # list转成map。key：工作流组价的名称，value：节点对象。避免节点调整，导致list中的数序变化
            responseData_map = {item['moduleName']: item for i, item in enumerate(responseData)}

            # slots 槽位信息
            slots_list = responseData_map['代码运行#判断最后一句消息角色']['customOutputs']['slots']
            # 如果chat_id_list包含 slots_list.get("chatId", "") 则continue
            if "chatId" not in slots_list:
                continue
            current_chat_id = slots_list.get("chatId", "")
            if current_chat_id != "" and current_chat_id not in chat_id_map:
                message_df = getTransferManualReasonByChartId(current_chat_id)
                for i, row in message_df.iterrows():
                    chat_id_map[current_chat_id] = row

            transfer_manual_reason = chat_id_map[current_chat_id]['transfer_manual_reason']
            if transfer_manual_reason != 58:
                # 不是提示语异常的场景，目前不处理
                continue
            if responseData_map['指定回复#槽位兜底'] is None:
                continue

            # fastGpt返回字符串
            textOutput_str = responseData_map['指定回复#槽位兜底']['textOutput']

            # 将messages转成conversation
            conversation_str = responseData_map['将messages转成conversation']['pluginOutput']['conversation']
            messages_list = responseData_map['将messages转成conversation']['pluginDetail'][1]['customInputs'][
                'messages']

            # 需要获取的键名集合
            keys_to_search = {"phoneId", "chatId", "外部联系人id"}
            # 调用方法
            value_from_slots = common.parse_filed_from_slots(slots_list, keys_to_search)
            payload = {
                "variables": {
                    "content": textOutput_str
                },
                "messages": [
                    {
                        "role": "user",
                        "content": "我已经添加了你，现在我们可以开始聊天了。"
                    }
                ]
            }
            content_str = common.call_fastgpt_api(payload, api_key, fastgpt_api_url)
            content_json = json.loads(content_str, strict=False)

            # 拼接返回行数据
            result = {
                '序号': index,
                'phoneId': value_from_slots.get("phoneId"),
                'chatId': value_from_slots.get("chatId"),
                'uid': value_from_slots.get("外部联系人id"),
                'current_chat_id': current_chat_id,
                '历史对话': json.dumps(messages_list, indent=4, ensure_ascii=False),
                '转人工原因': transfer_manual_reason,
                '原始字符串': textOutput_str,
                '提取结果': content_json.get('提取结果', ""),
                '提取到的json数据': content_json.get('提取到的json数据', {}),
            }
            results.append(result)
            if value_from_slots.get("chatId") not in match_chat_id_set:
                match_chat_id_set.append(value_from_slots.get("chatId"))
            if len(match_chat_id_set) > max_row:
                break
        except Exception as ex:
            print(f"index={index}，数据解析异常 ex={ex}")
            continue
    return results


if __name__ == "__main__":
    # 转人工原因为：58： 提示语异常，检查工作流返回的内容是不是非json
    print("开始处理。。。。。")
    api_key, fastgpt_api_url = init_config()
    results = process_all_rows(1000, api_key, fastgpt_api_url,[])
    common.write_to_excel(results, output_file)
    print("over。。。。")

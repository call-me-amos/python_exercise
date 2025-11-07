from datetime import datetime
import json

import whole_process.归因_回测.common as common
from diy_config.config import ConfigManager
from metabase_utils.prestodb_my import query_from_db

config_manager = ConfigManager("config.ini")
# 获取特定配置值
api_key = config_manager.get_value("SOP-问题-回测", "api_key")
fastgpt_api_url = config_manager.get_value("SOP-问题-回测", "fastgpt_api_url")


file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems-20251107.json"
output_file = f"C:/Users/amos.tong/Desktop/归因/归因_每天/SOP-问题-回测-结果-{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.xlsx"


def init_config():
    config_manager = ConfigManager("config.ini")
    # 获取特定配置值
    api_key = config_manager.get_value("SOP-问题-回测", "api_key")
    fastgpt_api_url = config_manager.get_value("SOP-问题-回测", "fastgpt_api_url")
    return api_key, fastgpt_api_url


# 获取消息列表
def getMessagesByChartId(chartId):
    query_sql = f"""
    select direction,system_type,send_time,message_type,text_content
    from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record
    WHERE chat_id = '{chartId}'
    order by send_time asc
    """
    messages = query_from_db(query_sql)
    return messages


def process_all_rows(max_row, api_key, fastgpt_api_url, data_list=None):
    results = []
    if data_list is None or len(data_list) == 0:
        data_list = common.read_json_file(file_path)
    chat_id_list = []
    phone_id_list = []
    for index, item in enumerate(data_list):
        try:
            print(f"当前fastgpt处理行：{index}")
            responseData = item['responseData']
            if len(responseData) == 0:
                continue

            # list转成map。key：工作流组价的名称，value：节点对象。避免节点调整，导致list中的数序变化
            responseData_map = {item['moduleName']: item for i, item in enumerate(responseData)}

            # slots 槽位信息
            slots_list = responseData_map['代码运行#判断最后一句消息角色']['customOutputs']['slots']

            # 如果chat_id_list包含 slots_list.get("chatId", "") 则continue
            current_chat_id = slots_list.get("chatId", "")
            if current_chat_id == "" or current_chat_id in chat_id_list:
                continue
            if len(chat_id_list) > max_row:
                print(f"chat_id_list 超过最大值，不再处理后续数据")
                break

            chat_id_list.append(current_chat_id)
            message_df = getMessagesByChartId(current_chat_id)
            messages = []
            for i, row in message_df.iterrows():
                messages.append({"role": ("assistant" if row["direction"] == 2 else "user"),
                                 "send_time": datetime.fromtimestamp(row["send_time"]).strftime(
                                     "%Y-%m-%d %H:%M:%S"), "message_type": row["message_type"],
                                 "content": row["text_content"]})

            # 需要获取的键名集合
            keys_to_search = {"phoneId", "chatId", "外部联系人id"}
            # 调用方法
            value_from_slots = common.parse_filed_from_slots(slots_list, keys_to_search)

            payload = {
                "variables": {
                    "messages": messages,
                },
                "messages": messages
            }
            content_str = common.call_fastgpt_api(payload, api_key, fastgpt_api_url)
            content_json = json.loads(content_str, strict=False)

            # 拼接返回行数据
            result = {
                '序号': index,
                'phoneId': value_from_slots.get("phoneId"),
                'chatId': value_from_slots.get("chatId"),
                'uid': value_from_slots.get("外部联系人id"),
                '历史对话': json.dumps(messages, indent=4, ensure_ascii=False),

                '未满足派单标准': content_json.get('未满足派单标准', ''),
                '未满足派单标准原因': content_json.get('未满足派单标准原因', ''),
                '用户表达不着急': content_json.get('用户表达不着急', ''),
                '负向情绪': content_json.get('负向情绪', ''),
                '询问是否AI': content_json.get('询问是否AI', ''),
                '用户未回复': content_json.get('用户未回复', '')
            }
            results.append(result)
        except Exception as e:
            print(f"index={index}，数据解析异常，错误信息：{e}")
    return results


if __name__ == "__main__":
    print("开始处理。。。。。")
    api_key, fastgpt_api_url = init_config()
    results = process_all_rows(10000, api_key, fastgpt_api_url,[])
    common.write_to_excel(results, output_file)
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    print("@@@@@@@@@@  处理完成  @@@@@@@@@@@@@")
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")

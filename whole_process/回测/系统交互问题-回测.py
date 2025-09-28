from exceptiongroup import catch

from diy_config.config import ConfigManager
import json
import pandas as pd
from typing import Any, Dict, List
import os
import time
import requests
from metabase_utils.prestodb_my import query_from_db


config_manager = ConfigManager("config.ini")
# 获取特定配置值
api_key = config_manager.get_value("系统交互问题-回测", "api_key")
fastgpt_api_url = config_manager.get_value("系统交互问题-回测", "fastgpt_api_url")

file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems_25.json"
output_file = f"C:/Users/amos.tong/Desktop/归因/系统交互问题-回测-结果-{time.time()}.xlsx"
def read_json_file(file_path: str) -> List[Any]:
    """读取JSON文件"""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            data = json.load(file)
            return data
    except FileNotFoundError:
        print(f"错误：文件 {file_path} 不存在")
        return []
    except json.JSONDecodeError:
        print(f"错误：文件 {file_path} 不是有效的JSON格式")
        return []
    except Exception as e:
        print(f"读取文件时发生错误: {e}")
        return []

def write_to_excel(data: List[Any], output_file: str) -> bool:
    """将数据写入Excel文件"""
    try:
        if not data:
            print("没有数据可写入Excel")
            return False

        # 创建DataFrame
        df = pd.DataFrame(data)

        # 写入Excel文件
        df.to_excel(output_file, index=False, engine='openpyxl')
        print(f"数据已成功写入: {output_file}")
        print(f"共写入 {len(data)} 条记录，{len(df.columns)} 个字段")
        return True
    except Exception as e:
        print(f"写入Excel时发生错误: {e}")
        return False

def call_fastgpt_api(payload: any) -> str:
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }
    try:
        response = requests.post(
            fastgpt_api_url,
            headers=headers,
            json=payload,
            timeout=30
        )

        if response.status_code == 200:
            content_str = response.json().get("choices", [{}])[0].get("message", {}).get("content", "")
            print(f"fastgpt返回内容：\n{content_str}")
            return content_str
        else:
            print(f"API调用失败: {response.status_code} - {response.text}")
            return ""

    except requests.exceptions.RequestException as e:
        print(f"API请求异常: {e}")
        return ""
    except json.JSONDecodeError as e:
        print(f"JSON解析失败: {e}")
        return ""


#获取消息列表
def getTransferManualReasonByChartId(chartId):
    query_sql = f"""
    select chat_id,transfer_manual_reason
    from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record
    WHERE chat_id = '{chartId}' and deleted =0
    """
    messages = query_from_db(query_sql)
    return messages
def process_all_rows(max_row):
    results = []
    chat_id_map = {}
    data_list = read_json_file(file_path)
    for index, item in enumerate(data_list):
        try:
            if index < 300:
                continue
            print(f"当前fastgpt处理行：{index}")
            responseData = item['responseData']
            if len(responseData) == 0:
                continue

            # list转成map。key：工作流组价的名称，value：节点对象。避免节点调整，导致list中的数序变化
            responseData_map = {item['moduleName']:item for i,item in enumerate(responseData)}

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
            if len(chat_id_map) > max_row:
                print(f"chat_id_map 超过最大值，不再处理后续数据")
                break
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
            messages_list = responseData_map['将messages转成conversation']['pluginDetail'][1]['customInputs']['messages']

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
            content_str = call_fastgpt_api(payload)
            content_json = json.loads(content_str, strict=False)

            # 拼接返回行数据
            result = {
                '序号': index,
                'current_chat_id': current_chat_id,
                '历史对话': json.dumps(messages_list, indent=4, ensure_ascii=False),
                '转人工原因': transfer_manual_reason,
                '原始字符串': textOutput_str,
                '提取结果': content_json.get('提取结果', ""),
                '提取到的json数据': content_json.get('提取到的json数据', {}),
            }
            results.append(result)
        except Exception as e:
            print(f"index={index}，数据解析异常，item={item} e={e}")
    return results




if __name__ == "__main__":
    print("开始处理。。。。。")
    results = process_all_rows(10)
    write_to_excel(results, output_file)
    print("over。。。。")
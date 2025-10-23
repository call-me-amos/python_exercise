from exceptiongroup import catch

from diy_config.config import ConfigManager
import json
import pandas as pd
from typing import Any, Dict, List
import os
import time
import requests

from whole_process.回测.common import parse_filed_from_slots

config_manager = ConfigManager("config.ini")
# 获取特定配置值
api_key = config_manager.get_value("知识-专业性建议问题-回测", "api_key")
fastgpt_api_url = config_manager.get_value("知识-专业性建议问题-回测", "fastgpt_api_url")
# fastgpt工作流日志
file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems-设计类2.0.json"
output_file = f"C:/Users/amos.tong/Desktop/归因/知识-专业性建议问题-回测-结果-{time.time()}.xlsx"
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

def process_all_rows(max_row):
    results = []
    data_list = read_json_file(file_path)
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
            responseData_map = {item['moduleName']:item for i,item in enumerate(responseData)}

            # slots 槽位信息
            slots_list = responseData_map['代码运行#判断最后一句消息角色']['customOutputs']['slots']

            # 角色判断
            last_say_role_str = responseData_map['代码运行#判断最后一句消息角色']['customOutputs']['最后一句消息发送人角色']
            if '用户' != last_say_role_str:
                continue

            # 用户问题
            user_question_str = responseData_map['AI对话-首轮槽位变量赋值']['query']

            # 将messages转成conversation
            conversation_str = responseData_map['将messages转成conversation']['pluginOutput']['conversation']
            messages_list = responseData_map['将messages转成conversation']['pluginDetail'][1]['customInputs']['messages']

            # 当前询问槽位
            current_ask_slot_str = responseData_map['槽位话术解析']['customOutputs']['question']
            # 当前槽位问题
            answer_str = responseData_map['槽位话术解析']['customOutputs']['answer']

            # QA回复话术
            qa_undertake = responseData_map['咨询承接 -强核需']['pluginOutput']['咨询承接响应']

            # 专业性建议
            pro_suggestion = ''
            if responseData_map['专业性承接-快核需'] is not None and len(responseData_map['专业性承接-快核需']) > 0:
                pro_suggestion = responseData_map['专业性承接-快核需']['pluginOutput']['承接综合回复']

            # 需要获取的键名集合
            keys_to_search = {"phoneId", "chatId", "外部联系人id"}
            # 调用方法
            value_from_slots = parse_filed_from_slots(slots_list, keys_to_search)

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
            content_str = call_fastgpt_api(payload)
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
        except Exception:
            print(f"index={index}，数据解析异常，item={item}")
    return results




if __name__ == "__main__":
    print("开始处理。。。。。")
    results = process_all_rows(2000)
    write_to_excel(results, output_file)
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    print("@@@@@@@@@@  处理完成  @@@@@@@@@@@@@")
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
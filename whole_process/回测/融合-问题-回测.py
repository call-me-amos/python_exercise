

from diy_config.config import ConfigManager
import json
import pandas as pd
from typing import Any, Dict, List
import os
import time
import requests


config_manager = ConfigManager("config.ini")
# 获取特定配置值
api_key = config_manager.get_value("融合-问题", "api_key")
fastgpt_api_url = config_manager.get_value("融合-问题", "fastgpt_api_url")

file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems_25.json"
output_file = f"C:/Users/amos.tong/Desktop/归因/融合-问题-结果-{time.time()}.xlsx"
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
            try:
                response_json = response.json()
                content_str = response_json.get("choices", [{}])[0].get("message", {}).get("content", "")
                if not content_str or content_str.strip() == "":
                    print("警告：API返回空内容")
                    return ""
                print(f"fastgpt返回内容：\n{content_str}")
                return content_str
            except (KeyError, IndexError, TypeError) as e:
                print(f"API响应格式错误: {e}")
                return ""
        else:
            print(f"API调用失败: {response.status_code} - {response.text}")
            return ""

    except requests.exceptions.RequestException as e:
        print(f"API请求异常: {e}")
        return ""
    except json.JSONDecodeError as e:
        print(f"JSON解析失败: {e}")
        return ""
    except Exception as e:
        print(f"API调用发生未知错误: {e}")
        return ""

def process_all_rows():
    results = []
    data_list = read_json_file(file_path)
    for index, item in enumerate(data_list):
        try:
            # if index > 1000:
            #     print(f"当前行：{index}，超过最大值，不再处理后续数据")
            #     break
            print(f"当前fastgpt处理行：{index}")
            responseData = item['responseData']
            if len(responseData) == 0:
                continue

            # list转成map。key：工作流组价的名称，value：节点对象。避免节点调整，导致list中的数序变化
            responseData_map = {}
            for i, item in enumerate(responseData):
                if 'moduleName' in item:
                    responseData_map[item['moduleName']] = item

            # 角色判断
            try:
                last_say_role_str = responseData_map['代码运行#判断最后一句消息角色']['customOutputs']['最后一句消息发送人角色']
                if '用户' != last_say_role_str:
                    continue
            except KeyError:
                print(f"index={index}，无法获取角色信息")
                continue

            # 融合模块
            try:
                fused_result = responseData_map['融合-快核需']['pluginOutput']['fused_result']
                fused_input = responseData_map['融合-快核需']['pluginOutput']['融合输入']
            except KeyError:
                print(f"index={index}，无法获取fused_result信息")
                continue

            # 将messages转成conversation
            try:
                messages_list = responseData_map['将messages转成conversation']['pluginDetail'][1]['customInputs']['messages']
            except (KeyError, IndexError):
                print(f"index={index}，无法获取conversation信息")
                continue

            payload = {
                "variables": {
                    "推荐承接话术": fused_result,
                    "messages": messages_list,
                },
                "messages": messages_list
            }
            content_str = call_fastgpt_api(payload)
            if content_str.startswith("```json"):
                content_str = content_str.strip().removeprefix("```json")
            if content_str.endswith("```"):
                content_str = content_str.removesuffix("```").strip()
            content_json = json.loads(content_str, strict=False)

            # 拼接返回行数据
            result = {
                '序号': index,
                "融合输入": fused_input,
                "推荐承接话术": fused_result,
                "messages": json.dumps(messages_list, indent=4, ensure_ascii=False),

                "推荐承接话术不合理": content_json.get('推荐承接话术不合理', ''),
                "思考过程": content_json.get('思考过程', ''),
            }
            results.append(result)
        except Exception as e:
            print(f"index={index}，数据解析异常， e={e}")
    return results




if __name__ == "__main__":
    print("开始处理。。。。。")
    results = process_all_rows()
    write_to_excel(results, output_file)
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    print("@@@@@@@@@@  处理完成  @@@@@@@@@@@@@")
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
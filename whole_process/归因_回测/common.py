from typing import Any, Dict, List
import os
import time
import requests
import json
import pandas as pd

def parse_filed_from_slots(slots_list, search_key_name):
    """
    从slots_list中获取search_key_name集合中指定的键值
    :param slots_list: 包含键值对的JSON对象（字典）
    :param search_key_name: 需要获取值的键名集合
    :return: 包含键值对的字典，键为search_key_name中的元素，值为对应的值或默认空字符串
    """
    result = {}
    for key in search_key_name:
        try:
            # 检查键是否存在，存在则获取值，否则返回空字符串
            result[key] = slots_list.get(key, "") if key in slots_list else ""
        except Exception as e:
            print(f"获取{key}失败: {e}")
            result[key] = ""
    return result

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

def call_fastgpt_api(payload: any, api_key:str, fastgpt_api_url:str) -> str:
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

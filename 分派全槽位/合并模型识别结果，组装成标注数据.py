import json

import openpyxl
import requests
import re
from datetime import datetime
from functools import cmp_to_key
from datetime import datetime


mapping_slots_to_label = {
    "【装修时间": "decorate_time",
    "【装修时间】": "decorate_time",
    "【是否交房】": "has_delivered",
    "【交房时间】": "delivery_time",
    "【量房时间】": "measure_time",
    "【姓氏】": "person",
    "【房屋面积】": "house_area",
    "【房屋类型】": "house_type",
    "【装修类型】": "decorate_type",
    "【装修工程量】": "decorate_content",
    "【房屋装修用途】": "decorate_purpose",
    "【房屋所在城市】": "house_city",
    "【房屋地址】": "house_address",
    "【小区名称】": "community_name"
}

# 创建反向映射字典：value -> key
reverse_mapping = {}
for k, v in mapping_slots_to_label.items():
    # 如果有多个key对应同一个value，我们取第一个遇到的
    if v not in reverse_mapping:
        reverse_mapping[v] = k

def getMappingSlots(slots):
    # 创建新的slots字典
    new_slots = {}
    for old_key, value in slots.items():
        if old_key in reverse_mapping:
            new_key = reverse_mapping[old_key]
            new_slots[new_key] = value
        else:
            # 如果没有匹配的key，保留原key
            new_slots[old_key] = value
    return new_slots


# 2. 解析send_time（返回datetime对象，无send_time返回None）
def parse_send_time(item):
    if "send_time" not in item:
        return None

    # 提取日期时间部分（如 "2025-06-08 17:13:18"）
    match = re.search(r"(\d{4}-\d{2}-\d{2}).*?(\d{2}:\d{2}:\d{2})", item["send_time"])
    if not match:
        return None

    date_str = match.group(1) + " " + match.group(2)
    try:
        return datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S")
    except:
        return None

def sort_key(item):
    dt = parse_send_time(item)
    return (dt is not None, dt)  # (False, None)会排在最前


def deduplicate(arr):
    seen = {}
    for item in arr:
        # 使用 role + send_time + content 作为唯一键
        send_time = ''
        if "send_time" in item :
            send_time = item["send_time"]
        key = (item["role"], send_time, item["content"])

        # 如果键不存在，直接保存
        if key not in seen:
            seen[key] = item
        else:
            # 如果已存在，检查是否有 slots，优先保留有 slots 的项
            if "slots" in item and "slots" not in seen[key]:
                seen[key] = item
    return list(seen.values())

if __name__ == '__main__':
    # 打开文件
    fileName = 'C:\\Users\\amos.tong\\\Desktop\\prompt-06-09.xlsx'
    workbook = openpyxl.load_workbook(fileName)

    # 选择要操作的工作表
    worksheet = workbook['Sheet']

    # 获取工作表的行数和列数
    num_rows = worksheet.max_row

    # key:uid%phoneId
    # value: 对象
    result = {}

    # 遍历工作表并读取数据
    for row_index in range(2, num_rows+1):
        try:
            # if row_index > 1000:
            #     print(f" ============   over！")
            #     break

            column2_input = worksheet.cell(row_index, 2).value
            column2_input_array = json.loads(column2_input, strict=False)
            column2_input_array[0].get('send_time')

            # 电话id uid
            column3_slots = worksheet.cell(row_index, 3).value
            column3_slots_json = json.loads(column3_slots, strict=False)

            column4_output = worksheet.cell(row_index, 4).value
            column4_output_json = json.loads(column4_output, strict=False)
            column4_output_reply = column4_output_json['reply']
            column4_output_slots = column4_output_json['slots']
            column4_output_slots = getMappingSlots(column4_output_slots)

            # 提示语
            column5_prompt = worksheet.cell(row_index, 5).value

            # 大模型返回
            column6_prompt_output = worksheet.cell(row_index, 6).value
            column6_prompt_output_json = json.loads(column6_prompt_output, strict=False)
            column6_prompt_output_answer = column6_prompt_output_json.get('answer')
            # column6_prompt_output_slots = {"decorate_time": "近两三月", "delivery_time": "30天内"}
            column6_prompt_output_slots = column6_prompt_output_json.get("slots")
            column6_prompt_output_slots = getMappingSlots(column6_prompt_output_slots)

            # 时间
            column9_time = worksheet.cell(row_index, 9).value
            cTime = column9_time.strip().replace("cTime：", "")
            cTime_day =datetime.strptime(cTime, '%Y-%m-%d %H:%M:%S %A').date()


            uid = column3_slots_json.get('chatId')
            phoneId = column3_slots_json.get("phoneId", 0)



            # 如果input的日期和ctime的日期不是同一天，丢弃本消息。（默认为回测数据）
            first_send_time = parse_send_time(column2_input_array[0])
            if cTime_day != first_send_time.date():
                continue

            value = result.get(f'{uid}%{phoneId}')
            if value is None:
                # 第一条消息为提示语
                prompt = {
                    "role": "system",
                    "content": column5_prompt,
                    "timestamp": 0,
                    "edited_time": "",
                    "operator": "",
                    "has_deleted": False,
                }
                messages = [prompt]
                result[f'{uid}%{phoneId}'] = {
                    "uid": uid,
                    "phoneId": phoneId,
                    "messages": messages,
                    # cTime对应的日期。精确到天
                    "cTime_day": cTime_day
                }
                value= result.get(f'{uid}%{phoneId}')

            # 拼接当前大模型回复内容
            message = {
                "role": "assistant",
                "send_time": cTime,
                "content": column6_prompt_output_answer,
                "slots": column6_prompt_output_slots,
                "completed_content_gpt": column4_output_reply,
                "completed_slots_gpt": column4_output_slots,
                "completed_content_own": column4_output_reply,
                "completed_slots_own": column4_output_slots,
                "timestamp": 0,
                "edited_time": "",
                "operator": "",
                "has_deleted": False
            }
            messages = value.get('messages',[])
            messages.append(message)

            # 拼接全量的聊天记录
            messages.extend(column2_input_array)
            # 排序
            all_messages_sorted = sorted(messages, key=sort_key)
            # 去重
            all_messages_deduplicate = deduplicate(all_messages_sorted)
            result[f'{uid}%{phoneId}']['messages'] = all_messages_deduplicate
        except Exception as e:
            print(f"{row_index}--{e}")
            continue



    with open(r'C:\\Users\\amos.tong\\\Desktop\\标注数据.jsonl', "w", encoding="utf-8") as f:
        for key, value in result.items():
            f.write(json.dumps(value, ensure_ascii=False) + "\n")

    # 打印
    # for key, value in result.items():
    #     # if key.endswith("424136515"):
    #         # print(f"key: {json.dumps(value, indent=4, ensure_ascii=False)}")
    #     # print(f"value: {json.dumps(value, indent=4, ensure_ascii=False)}")
    #     print(f"{json.dumps(value, ensure_ascii=False)}")
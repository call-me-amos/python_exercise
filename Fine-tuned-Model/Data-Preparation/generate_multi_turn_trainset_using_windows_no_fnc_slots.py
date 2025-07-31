"""使用新提示词，并将槽位信息与输出进行整合，输出格式改成同DeepSeek R1的推理格式"""

import os
import json
from transformers import AutoTokenizer
from preprocess_qwen_data_v4 import PreprocessWithLossMask, process_messages_for_nous
from utils import reformat_time_string


def reuse_slots_within_assistant(messages):
    """在 role 为 assistant 且不包含 slots 字段时，优先复用前面的 assistant 消息的 slots，
    如果前面没有，则复用后面的 assistant 消息的 slots，允许跨 content 包含 'tool_response' 的 user 消息"""
    updated_messages = []
    
    def can_cross_user(msg):
        """判断是否可以跨越 user 消息"""
        return msg["role"] == "user" and "tool_response" in msg["content"]

    for i, msg in enumerate(messages):
        if msg["role"] == "assistant":
            if "slots" not in msg:
                # 查找前面的 slots（优先），可以跨多个 assistant，但不能跨普通 user
                prev_slots = None
                for j in reversed(range(i)):
                    if messages[j]["role"] == "user" and not can_cross_user(messages[j]):
                        break  # 遇到普通 user 停止查找
                    if messages[j]["role"] == "assistant" and "slots" in messages[j]:
                        prev_slots = messages[j]["slots"]
                        break

                # 如果前面没有 slots，则查找后面的 slots，可以跨多个 assistant，但不能跨普通 user
                next_slots = None
                if not prev_slots:
                    for j in range(i + 1, len(messages)):
                        if messages[j]["role"] == "user" and not can_cross_user(messages[j]):
                            break  # 遇到普通 user 停止查找
                        if messages[j]["role"] == "assistant" and "slots" in messages[j]:
                            next_slots = messages[j]["slots"]
                            break

                # 选择最近的 slots 进行复用（优先使用前面的）
                chosen_slots = prev_slots or next_slots
                if chosen_slots:
                    msg["slots"] = chosen_slots
                else:
                    print(f"警告: 消息 '{msg['content']}' 没有找到可复用的 slots")

            # response = response_template.format(**json.loads(msg["slots"]), answer=msg["content"]) if "slots" in msg else msg["content"]
            updated_messages.append({"role": "assistant", "content": msg["content"], "slots": msg["slots"]})
        else:
            updated_messages.append(msg)

    return updated_messages


prompt_tool = """\
  # Tools

  You may call one or more functions to assist with the user query.

  You are provided with function signatures within <tools></tools> XML tags:
  <tools>
  {"type": "function", "function": {"name": "confirm_appointment", "description": "根据用户在预约上门量房时提到时间与时间类型确定下一次与用户预约上门的时间", "parameters": {"type": "object", "properties": {"time": {"type": "string", "description": "用户方便的上门量房时间，或不方便的上门量房时间，或外出时间，或回家时间，或房子交房或封顶时间或模糊的时间。"}, "type": {"type": "string", "description": "用户提到的time类型", "enum": ["convenient", "ask_when", "inconvenient", "return", "away", "delivery", "unspecified", "reject", "irresolute"]}}, "required": ["time", "type"]}}}
  </tools>

  For each function call, return a json object with function name and arguments within <tool_call></tool_call> XML tags:
  <tool_call>
  {"name": <function-name>, "arguments": <args-json-object>}
  </tool_call>
"""

empty_slots = {
    "decorate_time": "",
    "has_delivered": "",
    "delivery_time": "",
    "measure_time": "",
    "person": "",
    "house_area": "",
    "house_type": "",
    "decorate_type": "",
    "decorate_content": "",
    "decorate_purpose": "",
    "house_city": "",
    "house_address": "",
    "community_name": ""
}

response_template = """\
<slots>
<slot> name="decorate_time" value="{decorate_time}" </slot>
<slot> name="has_delivered" value="{has_delivered}" </slot>
<slot> name="delivery_time" value="{delivery_time}" </slot>
<slot> name="measure_time" value="{measure_time}" </slot>
<slot> name="person" value="{person}" </slot>
<slot> name="house_area" value="{house_area}" </slot>
<slot> name="house_type" value="{house_type}" </slot>
<slot> name="decorate_content" value="{decorate_content}" </slot>
<slot> name="decorate_type" value="{decorate_type}" </slot>
<slot> name="decorate_purpose" value="{decorate_purpose}" </slot>
<slot> name="house_city" value="{house_city}" </slot>
<slot> name="house_address" value="{house_address}" </slot>
<slot> name="community_name" value="{community_name}" </slot>
</slots>
<answer>{answer}</answer>"""

# print(transform_time("2024-04-22 14:27:16"))

prompt_prefix = """\
### **角色**
你是土巴兔平台的微信核需客服。当前的时间为：{send_time}

### **历史槽位**
- 装修时间(decorate_time): {decorate_time}
- 是否交房(has_delivered): {has_delivered}
- 交房时间(delivery_time): {delivery_time}
- 量房时间(measure_time): {measure_time}
- 姓氏(person): {person}
- 房屋面积(house_area): {house_area}
- 房屋类型(house_type): {house_type}
- 装修类型(decorate_type): {decorate_type}
- 装修工程量(decorate_content): {decorate_content}
- 房屋装修用途(decorate_purpose): {decorate_purpose}
- 房屋所在城市(house_city): {house_city}
- 房屋地址(house_address): {house_address}
- 小区名称(community_name): {community_name}

### **目标**
收集如下槽位信息：
- 装修时间(decorate_time)
- 是否交房(has_delivered)
- 交房时间(delivery_time)
- 量房时间(measure_time)
- 姓氏(person)
- 房屋面积(house_area)
- 房屋类型(house_type)
- 装修类型(decorate_type)
- 装修工程量(decorate_content)
- 房屋装修用途(decorate_purpose)
- 房屋所在城市(house_city)
- 房屋地址(house_address)
- 小区名称(community_name)

### **默认工作流程**
{workflow}

### **输出格式**
<slots>
<slot> name="decorate_time" value=... </slot>
<slot> name="has_delivered" value=... </slot>
<slot> name="delivery_time" value=... </slot>
<slot> name="measure_time" value=... </slot>
<slot> name="person" value=... </slot>
<slot> name="house_area" value=... </slot>
<slot> name="house_type" value=... </slot>
<slot> name="decorate_content" value=... </slot>
<slot> name="decorate_type" value=... </slot>
<slot> name="decorate_purpose" value=... </slot>
<slot> name="house_city" value=... </slot>
<slot> name="house_address" value=... </slot>
<slot> name="community_name" value=... </slot>
</slots>
<answer>...</answer>"""

model_name_or_path = r"E:\Qwen\Qwen3-0___6B"
tokenizer = AutoTokenizer.from_pretrained(
    model_name_or_path,
    model_max_length=4096,
    padding_side="right",
    use_fast=False,
)


# data_path = r"D:\workplaces\GRPO\data\优质片段\origin\test.jsonl"
data_path = r"C:/Users/amos.tong/Desktop/待训练的数据.jsonl"
with open(data_path, "r", encoding="utf-8") as f:
    data = [json.loads(line) for line in f.readlines()]

dataset = []

preprocess = PreprocessWithLossMask(tokenizer=tokenizer, max_len=4096)


for _idx, d in enumerate(data[:]):
    try:
        uid = d["uid"]
        print(uid)
        workflow = d["workflow"]
        send_time = d["send_time"]
        messages = d["messages"]

        tmp = []
        slots_list = [empty_slots]

        # messages = process_messages_for_nous(messages)
        # messages = reuse_slots_within_assistant(messages)

        for i, msg in enumerate(messages):
            send_time = reformat_time_string(send_time)
            if msg["role"] == "function" or "function_call" in msg["content"]:
                continue

            if msg["role"] == "system":
                continue
                # prompt = prompt_prefix.replace("{workflow}", workflow).replace("{send_time}", send_time)
                # tmp.append({"role": "system", "content": prompt})

            elif msg["role"] == "assistant":
                if not msg["content"]:
                    continue
                # slots = json.loads(msg.get("slots", json.dumps(empty_slots, ensure_ascii=False)))
                slots = msg.get("slots", json.dumps(empty_slots, ensure_ascii=False))
                slots_list.append(slots)
                prompt = prompt_prefix.format(send_time=send_time, **slots_list[-2], workflow=workflow)
                response = response_template.format(**slots, answer=msg["content"])
                dataset.append({"uid": f"{uid}_{i}", "messages": [{"role": "system", "content": prompt}] + tmp + [{"role": "assistant", "content": response}]})
                
                tmp.append({"role": "assistant", "content": msg["content"]})
            else:
                tmp.append({"role": "user", "content": msg["content"]})

        # new_messages_list = preprocess.sliding_window_messages(tmp)
        # for _idx2, new_messages in enumerate(new_messages_list):
        #     dataset.append({
        #         "uid": f"{d['uid']}-{_idx2}",
        #         "workflow": workflow,
        #         "send_time": send_time,
        #         "messages": new_messages,
        #         "is_norm": d["is_norm"],
        #         "is_change": d["is_change"],
        #         "add_note": True,
        #     })
    except Exception as e:
        print(f"Error: {e}\n{_idx}")

output_path = r"C:/Users/amos.tong/Desktop\2025-07-01-sft.jsonl"

with open(output_path, "w", encoding="utf-8") as f:
    for item in dataset:
        if "md5sum" in "".join([msg["content"] for msg in item["messages"]]):
            continue
        text = json.dumps(item, ensure_ascii=False)
        f.write(text + "\n")



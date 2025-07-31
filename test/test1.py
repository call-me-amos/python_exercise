import json

def main(data1, data2):
    # 解析 data1（JSON字符串 -> 字典）
    try:
        aiReply = json.loads(data1)
    except json.JSONDecodeError:
        return {
            "error": "Invalid JSON in data1",
            "aiReply": None
        }

    # 处理 data2（直接使用列表，无需解析）
    messages = data2 if isinstance(data2, list) else []

    # 获取 answer
    answer = aiReply.get('answer', [])

    # answer 为空，返回原始的AI回复
    if not answer:
        return {
            "aiReply": aiReply
        }

    # 历史顾问发送的消息
    assistant_contents = [
        i["content"].strip()
        for i in messages
        if isinstance(i, dict) and i.get("role") == "assistant"
    ]

    # answer 重复的索引
    repeat_list = []
    reply_in_assistant_contents = False  # 初始化标志变量

    # 顾问发送的消息和当前AI推荐的消息对比，是否存在重复话术
    for msg in assistant_contents:
        for i, part in enumerate(answer):
            if part == msg:
                reply_in_assistant_contents = True
                repeat_list.append(i)

    # 遍历重复的AI回复，替换成引用消息
    if reply_in_assistant_contents:
        for j in repeat_list:
            repeat_str = answer[j]
            answer[j] = f'这是一条引用/回复消息：\\\"{repeat_str}\\\"------{repeat_str}'

        aiReply['answer'] = answer

    return {
        "aiReply": aiReply
    }
import json


def main(data1, data3):
    # 解析 data1（JSON字符串 -> 字典）
    try:
        data1 = data1.replace("\\n", "")
        aiReply = json.loads(data1)
    except json.JSONDecodeError:
        return {
            "aiReply": None,
        }

    # 将finish塞到返回字段
    aiReply['finish'] = data3

    return {
        "aiReply": aiReply
    }

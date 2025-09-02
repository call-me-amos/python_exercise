import json


def main(data1):
    # 尝试自动处理各种可能的输入
    if isinstance(data1, str):
        try:
            data1 = json.loads(data1)
        except:
            try:
                # 可能是类似字典的字符串，如 "{'alias':'xxx'}"
                data1 = eval(data1)
            except:
                return {"error": "Cannot parse input"}

    if isinstance(data1, dict):
        return {
            "slots": data1,
            "alias": data1.get("alias"),
            "question_store": data1.get("question_store", []),
            "最后一句消息发送人角色": data1.get("最后一句消息发送人角色", "用户"),
            "projDeliveredTime": data1.get("projDeliveredTime", 0),
            "app入口": data1.get("app入口", ""),
            "是否加微成功app": data1.get("是否加微成功app", "否"),
        }

    return {"error": "Unsupported input format"}
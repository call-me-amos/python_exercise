import json

def main(messages):
    if not messages:
        return {
            "conversation": "",
            "last_role": None,
            "last_response": None,
            "history_conversation": "",
            "conversation_with_sendtime": "",
            "msg_list": []
        }

    msg_list = []
    conversation = []
    conversation_with_sendtime = []

    for i in messages:
        role = "顾问" if i.get("role") == "assistant" else "用户"
        content = i.get("content", "")
        send_time = i.get("send_time") or i.get("sendtime") or ""

        # 如果 content 是 JSON 字符串，尝试解析
        try:
            parsed = json.loads(content)
            if isinstance(parsed, dict) and "url" in parsed:
                content = f"[图片] {parsed.get('url')}"
        except Exception:
            pass  # 普通文本就直接用

        conversation.append(f"{role}：{content}")
        msg_list.append({"role": i.get("role"), "content": content, "send_time": send_time})
        conversation_with_sendtime.append(f"{role}[{send_time}]：{content}")

    history_conversation = "\n".join(conversation[:-1]) if len(conversation) > 1 else ""
    conversation_str = "\n".join(conversation)
    conversation_with_sendtime_str = "\n".join(conversation_with_sendtime)

    return {
        "conversation": conversation_str,
        "last_role": messages[-1].get("role"),
        "last_response": msg_list[-1]["content"],
        "history_conversation": history_conversation,
        "conversation_with_sendtime": conversation_with_sendtime_str,
        "msg_list": msg_list  # 把结构化结果也返回
    }

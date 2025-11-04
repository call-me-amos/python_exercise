import json
def main(data1, data2):
    # 解析 data1（JSON字符串 -> 字典）
    try:
        aiReply = json.loads(data1)
    except json.JSONDecodeError:
        return {
            "是否存在重复话术": False
        }

    # 处理 data2（直接使用列表，无需解析）
    messages = data2 if isinstance(data2, list) else []
    # 获取 answer
    if 'answer' not in aiReply:
        aiReply['answer'] = []
    answer = aiReply.get('answer', [])

    # answer 为空，返回原始的AI回复
    if not answer:
        return {
            "是否存在重复话术": False
        }

    white_repeat = ["可以", "了解", "好嘞", "行的", "可以的", "消息类型：加微卡", "好的", "好滴", "收到", "明白", "嗯嗯", "嗯呢", "行呢", "记下啦", "知道啦", "ok"]

    # 历史顾问发送的消息
    assistant_history_contents = [
        i["content"].strip()
        for i in messages
        if isinstance(i, dict) and i.get("role") == "assistant" and i["content"].strip() not in white_repeat
    ]

    # answer 重复的索引
    repeat_index_list = []
    repeat_content_list = []
    flag_for_repeat = False  # 初始化标志变量

    # 顾问发送的消息和当前AI推荐的消息对比，是否存在重复话术
    for msg in assistant_history_contents:
        for i, part in enumerate(answer):
            if part == msg:
                flag_for_repeat = True
                repeat_index_list.append(i)
                repeat_content_list.append(part)

    return {
        "是否存在重复话术": flag_for_repeat,
        "推荐话术": answer,
        "重复话术的索引号": repeat_index_list,
        "重复话术内容": repeat_content_list
    }


param= {
  "data1": "[\n  {\n    \"answer\": [\n      \"您这次装修是自住还是出租呢？（出租造价更低）~\"\n    ],\n    \"询问槽位\": [\n      \"姓氏\"\n    ],\n    \"思考过程\": \"{历史对话中，小区名称为万科云城，房屋地址为深圳万科云城，装修时间为明天，房屋面积为120平米，均已填充，根据槽位顺序，接下来应询问非必填的姓氏。}\",\n    \"round4_end\": 1,\n    \"decorate_time\": \"明天\",\n    \"has_delivered\": \"是\",\n    \"delivery_time\": \"\",\n    \"measure_time\": \"明天\",\n    \"person\": \"\",\n    \"house_area\": \"120平米\",\n    \"house_type\": \"毛坯&毛坯房\",\n    \"decorate_content\": \"\",\n    \"decorate_type\": \"家装\",\n    \"decorate_purpose\": \"自住\",\n    \"house_city\": \"深圳\",\n    \"house_address\": \"深圳万科云城\",\n    \"community_name\": \"万科云城\",\n    \"is_commercial\": \"\",\n    \"是否在外地\": \"\",\n    \"外地回来时间\": \"\",\n    \"装修风格\": \"\",\n    \"finish\": \"核需完成\"\n  }\n]",
  "data2": [
    {
      "role": "assistant",
      "send_time": "2025-10-28(农历:九月初八),周二下午,16:12:01",
      "id": 2625063,
      "content": "你好，您家是毛坯房还是老房需要改造呀?"
    },
    {
      "role": "user",
      "send_time": "2025-10-28(农历:九月初八),周二下午,16:12:46",
      "id": 2625064,
      "content": "毛坯"
    },
    {
      "role": "assistant",
      "send_time": "2025-10-28(农历:九月初八),周二下午,16:13:04",
      "id": 2625065,
      "content": "您这次装修是自住还是出租呢？（出租造价更低）~"
    },
    {
      "role": "user",
      "send_time": "2025-10-28(农历:九月初八),周二下午,16:15:03",
      "id": 2625074,
      "content": "可以呀"
    }
  ]
}
if __name__ == "__main__":
    print("开始处理。。。。。")
    result = main(**param)
    print(result)
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    print("@@@@@@@@@@  处理完成  @@@@@@@@@@@@@")
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
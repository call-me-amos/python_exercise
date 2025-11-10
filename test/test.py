import json


def main(data1, data2, data3, data4, data5):
    # 解析 data1（JSON字符串 -> 字典）
    try:
        aiReply = json.loads(data1)
    except json.JSONDecodeError:
        return {
            "aiReply": data1
        }
    try:
        # 润色后的话术，字符串数组
        aiReply_for_polish = json.loads(data2)
    except json.JSONDecodeError:
        return {
            "aiReply": data1
        }

    # data3为数字数组，存储的为data4数组索引号，data3的大小和aiReply_for_polish一致
    # data4为字符串数组
    # 要求，遍历data3，依次使用aiReply_for_polish中的字符串替换到data4中索引为value的字符串

    # 遍历data3，使用aiReply_for_polish中的字符串替换data4中对应索引的字符串
    for i, index in enumerate(data3):
        if 0 <= index < len(data4) and i < len(aiReply_for_polish):
            data4[index] = aiReply_for_polish[index]

    aiReply['answer'] = data4
    aiReply['repeatFlag'] = '是'
    aiReply['重复话术的原始话术'] = data5
    aiReply['重复话术的索引号'] = data3
    return {
        "aiReply": aiReply
    }


param= {
  "data1": "{\"answer\":[\"没关系的，你这边有户型图了随时可以发我哈，能免费做个AI效果图参考，那目前我先给您找一些同面积，比较流行的装修风格案例给您找下灵感哈~\",\"咱们此次装修是打算自己住的，还是出租出去的呀？\"],\"询问槽位\":[\"未发送户型图信息\",\"装修用途\"],\"思考过程\":\"{历史槽位信息中，房屋类型已填充为毛坯房，根据对话流程，当前未填充的必填槽位按顺序为未发送户型图信息和装修用途。由于图像类型未填充为户型图，先执行未发送户型图信息的参考话术，然后询问装修用途。}\",\"round4_end\":0,\"decorate_time\":\"\",\"has_delivered\":\"\",\"delivery_time\":\"\",\"measure_time\":\"\",\"person\":\"\",\"house_area\":\"\",\"house_type\":\"毛坯房&毛坯房\",\"decorate_content\":\"\",\"decorate_type\":\"\",\"decorate_purpose\":\"\",\"house_city\":\"\",\"house_address\":\"\",\"community_name\":\"\",\"is_commercial\":\"\",\"是否在外地\":\"\",\"外地回来时间\":\"\",\"装修风格\":\"\",\"finish\":\"核需中\",\"question\":\"装修用途\",\"feature_store\":\"''\",\"fusion_input\":\"[\\\"mz79ETu2YxrHPh4B\\\",\\\"融合输入\\\"]\",\"fusion_output\":\"[\\\"mz79ETu2YxrHPh4B\\\",\\\"fused_result\\\"]\"}",
  "data2": "[\n    \"没关系的，你有户型图后随时发给我，能免费做个AI效果图参考，那我先给您找找同面积又流行的装修风格案例，找找灵感哈~\",\n    \"这次装修您是打算自住，还是用来出租呀？\"\n]",
  "data3": [
    1
  ],
  "data4": [
    "没关系的，你这边有户型图了随时可以发我哈，能免费做个AI效果图参考，那目前我先给您找一些同面积，比较流行的装修风格案例给您找下灵感哈~",
    "咱们此次装修是打算自己住的，还是出租出去的呀？"
  ],
  "data5": [
    "咱们此次装修是打算自己住的，还是出租出去的呀？"
  ]
}
if __name__ == "__main__":
    print("开始处理。。。。。")
    result = main(**param)
    print(result)
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    print("@@@@@@@@@@  处理完成  @@@@@@@@@@@@@")
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
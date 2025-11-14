# 好的对话维度--历史数据打标签

import json
from datetime import datetime

import whole_process.归因_回测.common as common
from diy_config.config import ConfigManager

file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems-20251107.json"
output_file = f"C:/Users/amos.tong/Desktop/归因/归因_每天/历史数据打标签-回测-结果-{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.xlsx"


def init_config():
    """初始化配置信息"""
    config_manager = ConfigManager("config.ini")
    # 获取特定配置值
    api_key = config_manager.get_value("历史数据打标签-回测", "api_key")
    fastgpt_api_url = config_manager.get_value("历史数据打标签-回测", "fastgpt_api_url")
    return api_key, fastgpt_api_url


def process_all_rows(max_row, api_key, fastgpt_api_url, data_list=None):
    results = []
    if data_list is None or len(data_list) == 0:
        data_list = common.read_json_file(file_path)
    for index, item in enumerate(data_list):
        try:
            if index > max_row:
                print(f"历史数据打标签 当前行：{index}，超过最大值{max_row}，不再处理后续数据")
                break
            print(f"当前fastgpt处理行 历史数据打标签：{index}")
            fastgpt_message_time = item['time']
            responseData = item['responseData']
            if len(responseData) == 0:
                continue

            # list转成map。key：工作流组价的名称，value：节点对象。避免节点调整，导致list中的数序变化
            responseData_map = {item['moduleName']: item for i, item in enumerate(responseData)}

            # 角色判断
            try:
                last_say_role_str = responseData_map['代码运行#判断最后一句消息角色']['customOutputs']['最后一句消息发送人角色']
            except KeyError:
                print(f"index={index}，无法获取角色信息")
                continue

            try:
                # slots 槽位信息
                slots_list = responseData_map['代码运行#判断最后一句消息角色']['customOutputs']['slots']
            except KeyError:
                print(f"index={index}，无法获取槽位信息")
                continue

            # 将messages转成conversation
            try:
                messages_list = responseData_map['将messages转成conversation']['pluginDetail'][1]['customInputs']['messages']
            except (KeyError, IndexError):
                print(f"index={index}，无法获取conversation信息")
                continue
            # 从messages_list 倒序获取第一条角色为user 的消息内容
            user_question_str = ""
            # 从 messages_list 截取最后4个元素
            sub_messages_list = messages_list[-4:] if messages_list else []
            if messages_list:
                for message in reversed(messages_list):
                    if message.get('role') == 'user':
                        user_question_str = message.get('content', '')
                        break

            # 指定回复#槽位兜底
            try:
                textOutput = responseData_map['指定回复#槽位兜底']['textOutput']
                textOutput_json = json.loads(textOutput, strict=False)
            except KeyError:
                print(f"index={index}，无法获取 指定回复#槽位兜底 信息")
                continue

            finish = textOutput_json.get("finish", '')

            if finish == '核需完成':
                print(f"核需完成，暂时不记录")
                continue

            # 需要获取的键名集合
            keys_to_search = {"phoneId", "chatId", "外部联系人id"}
            # 调用方法
            value_from_slots = common.parse_filed_from_slots(slots_list, keys_to_search)
            payload = {
                "variables": {
                    "messages": messages_list,
                    "sub_messages_list": sub_messages_list,
                    "slots": slots_list,
                    "最后一句消息发送人角色": last_say_role_str,
                    "用户最新回复话术": user_question_str,
                    "推荐话术": textOutput_json.get("answer", [])
                },
                "messages": messages_list
            }
            try:
                content_str = common.call_fastgpt_api(payload, api_key, fastgpt_api_url)
                if content_str.startswith("```json"):
                    content_str = content_str.strip().removeprefix("```json")
                if content_str.endswith("```"):
                    content_str = content_str.removesuffix("```").strip()
                content_json = json.loads(content_str, strict=False)
            except (json.JSONDecodeError, Exception) as ex:
                print(f"index={index}，API调用或JSON解析失败: {ex}")
                content_json ={}

            # 拼接返回行数据
            result = {
                '序号': index,
                'phoneId': value_from_slots.get("phoneId"),
                'fastgpt_message_time': fastgpt_message_time,
                'chatId': value_from_slots.get("chatId"),
                'uid': value_from_slots.get("外部联系人id"),
                '历史对话': json.dumps(messages_list, indent=4, ensure_ascii=False),
                '历史槽位信息': slots_list,
                "最后一句消息发送人角色": last_say_role_str,
                '用户最新回复话术': user_question_str,
                "推荐话术": textOutput_json.get("answer", []),
                '流程一致性': content_json.get('流程一致性', ''),
                '信息引导性': content_json.get('信息引导性', ''),
                '需求识别': content_json.get('需求识别', ''),
                '需求理解': content_json.get('需求理解', ''),
                '情感识别': content_json.get('情感识别', ''),
                '情感互动': content_json.get('情感互动', ''),
                '礼貌性与专业性': content_json.get('礼貌性与专业性', ''),
                '上下文衔接与连贯性': content_json.get('上下文衔接与连贯性', ''),
                '行业知识匹配程度': content_json.get('行业知识匹配程度', ''),
                '用户策略分类': content_json.get('用户策略分类', ''),
                '用户策略分类判断依据': content_json.get('用户策略分类判断依据', ''),
            }
            results.append(result)
        except Exception as ex:
            print(f"index={index}，数据解析异常 ex={ex}")
            continue
    return results


if __name__ == "__main__":
    print("好的对话维度--历史数据打标签 开始处理。。。。。")
    api_key, fastgpt_api_url = init_config()
    results = process_all_rows(1000, api_key, fastgpt_api_url, [])
    common.write_to_excel(results, output_file)
    print("over。。。。")

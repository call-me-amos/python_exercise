import json
from datetime import datetime

import whole_process.归因_回测.common as common
from diy_config.config import ConfigManager


file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems-20251107.json"
output_file = f"C:/Users/amos.tong/Desktop/归因/归因_每天/融合-问题-回测结果-{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.xlsx"

def init_config():
    config_manager = ConfigManager("config.ini")
    # 获取特定配置值
    api_key = config_manager.get_value("融合-问题", "api_key")
    fastgpt_api_url = config_manager.get_value("融合-问题", "fastgpt_api_url")
    return api_key, fastgpt_api_url

def process_all_rows(max_row, api_key, fastgpt_api_url, data_list=None):
    results = []
    if data_list is None or len(data_list) == 0:
        data_list = common.read_json_file(file_path)
    for index, item in enumerate(data_list):
        try:
            if index > max_row:
                print(f"当前行：{index}，超过最大值，不再处理后续数据")
                break
            print(f"当前fastgpt处理行：{index}")
            responseData = item['responseData']
            if len(responseData) == 0:
                continue

            # list转成map。key：工作流组价的名称，value：节点对象。避免节点调整，导致list中的数序变化
            responseData_map = {}
            for i, item in enumerate(responseData):
                if 'moduleName' in item:
                    responseData_map[item['moduleName']] = item

            # 角色判断
            try:
                last_say_role_str = responseData_map['代码运行#判断最后一句消息角色']['customOutputs'][
                    '最后一句消息发送人角色']
                if '用户' != last_say_role_str:
                    continue
            except KeyError:
                print(f"index={index}，无法获取角色信息")
                continue
            # slots 槽位信息
            slots_list = responseData_map['代码运行#判断最后一句消息角色']['customOutputs']['slots']

            # 融合模块
            try:
                fused_result = responseData_map['融合-快核需']['pluginOutput']['fused_result']
                fused_input = responseData_map['融合-快核需']['pluginOutput']['融合输入']
            except KeyError:
                print(f"index={index}，无法获取fused_result信息")
                continue

            # 将messages转成conversation
            try:
                messages_list = responseData_map['将messages转成conversation']['pluginDetail'][1]['customInputs'][
                    'messages']
            except (KeyError, IndexError):
                print(f"index={index}，无法获取conversation信息")
                continue

            try:
                phoneId = slots_list.get("phoneId", 0) if "phoneId" in slots_list else ""
            except KeyError:
                print(f"获取phoneId失败 {index}")
                phoneId = 0
            try:
                chatId = slots_list.get("chatId", "") if "chatId" in slots_list else ""
            except KeyError:
                print(f"获取chatId失败 {index}")
                chatId = ''
            try:
                uid = slots_list.get("外部联系人id", "") if "外部联系人id" in slots_list else ""
            except KeyError:
                print(f"获取uid失败 {index}")
                uid = ''
            # 需要获取的键名集合
            keys_to_search = {"phoneId", "chatId", "外部联系人id"}
            # 调用方法
            value_from_slots = common.parse_filed_from_slots(slots_list, keys_to_search)

            payload = {
                "variables": {
                    "推荐承接话术": fused_result,
                    "messages": messages_list,
                },
                "messages": messages_list
            }
            content_str = common.call_fastgpt_api(payload, api_key, fastgpt_api_url)
            if content_str.startswith("```json"):
                content_str = content_str.strip().removeprefix("```json")
            if content_str.endswith("```"):
                content_str = content_str.removesuffix("```").strip()
            content_json = json.loads(content_str, strict=False)
            if content_json is None:
                continue

            # 拼接返回行数据
            result = {
                '序号': index,
                'phoneId': value_from_slots.get("phoneId"),
                'chatId': value_from_slots.get("chatId"),
                'uid': value_from_slots.get("外部联系人id"),
                "融合输入": fused_input,
                "推荐承接话术": fused_result,
                "messages": json.dumps(messages_list, indent=4, ensure_ascii=False),

                "推荐承接话术不合理": content_json.get('推荐承接话术不合理', ''),
                "思考过程": content_json.get('思考过程', ''),
            }
            results.append(result)
        except Exception as ex:
            print(f"index={index}，数据解析异常， e={ex}")
            continue
    return results


if __name__ == "__main__":
    print("融合-问题-回测 开始处理。。。。。")
    api_key, fastgpt_api_url = init_config()
    results = process_all_rows(1000, api_key, fastgpt_api_url,[])
    common.write_to_excel(results, output_file)
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    print("@@@@@@@@@@  处理完成  @@@@@@@@@@@@@")
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")

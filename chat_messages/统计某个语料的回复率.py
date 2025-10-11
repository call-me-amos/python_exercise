from exceptiongroup import catch
import datetime
from diy_config.config import ConfigManager
import json
import pandas as pd
from typing import Any, Dict, List
import os
import time
import requests
from metabase_utils.prestodb_my import query_from_db


file_path = f"C:/Users/amos.tong/Desktop/归因/fastgpt.chatitems_09-13.json"
output_file_for_temp = f"C:/Users/amos.tong/Desktop/待处理聊天记录/待处理聊天记录-语料回复.xlsx"
output_file = f"C:/Users/amos.tong/Desktop/待处理聊天记录/语料回复的明细-{time.time()}.xlsx"
def read_json_file(file_path: str) -> List[Any]:
    """读取JSON文件"""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            data = json.load(file)
            return data
    except FileNotFoundError:
        print(f"错误：文件 {file_path} 不存在")
        return []
    except json.JSONDecodeError:
        print(f"错误：文件 {file_path} 不是有效的JSON格式")
        return []
    except Exception as e:
        print(f"读取文件时发生错误: {e}")
        return []

def write_to_excel(data: List[Any], output_file: str) -> bool:
    """将数据写入Excel文件"""
    try:
        if not data:
            print("没有数据可写入Excel")
            return False

        # 创建DataFrame
        df = pd.DataFrame(data)

        # 写入Excel文件
        df.to_excel(output_file, index=False, engine='openpyxl')
        print(f"数据已成功写入: {output_file}")
        print(f"共写入 {len(data)} 条记录，{len(df.columns)} 个字段")
        return True
    except Exception as e:
        print(f"写入Excel时发生错误: {e}")
        return False

# 获取聊天记录
def getMessages():
    query_sql = f"""
select 
CONCAT(t1.wechat,'@',t1.external_userid) as sid
,t1.direction
,(
	case when t1.direction =2 then '客服' else '用户' end
) as "发送人"
,t1.msg_time/1000 as msg_time
,from_unixtime(t1.msg_time/1000+8*3600) as "发送时间"
,t1.content 
from 
(
	SELECT 
		if(substr(from_id,1,2)='wm',tolist,from_id) as wechat,
		if(substr(tolist,1,2)='wm',tolist,from_id) as external_userid,
		if(substr(from_id,1,2)='wm',1,2) as direction,
		msg_time,
		msg_type,
		content 
	FROM hive2.ads.v_kudu2_stg_idc_new_t8t_mid_ucchat_uc_wechat_chatdata
	WHERE msg_type='text'
	 	and content <>'【未知消息类型】'
	 	and content <>''
	 	and msg_time>((to_unixtime(cast ('2025-10-08 00:00:0' as timestamp)) - 8*3600) *1000)
	 	and msg_time<((to_unixtime(cast ('2025-10-09 00:00:0' as timestamp)) - 8*3600) *1000)
) as t1 
where 
--t1.wechat in('18575677395','16625124081','13244727305','17679207507','10708951')
--and 
t1.external_userid like 'wm%'
order by CONCAT(t1.wechat,'@',t1.external_userid),t1.msg_time
    """
    messages = query_from_db(query_sql)
    return messages

#获取消息列表
def getMessagesByChartId(chartId):
    query_sql = f"""
    select direction,system_type,send_time,message_type,text_content
    from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record
    WHERE chat_id = '{chartId}'
    order by send_time asc
    """
    messages = query_from_db(query_sql)
    return messages
def process_all_rows(max_row):
    results = []
    data_list = read_json_file(file_path)
    chat_id_list = []
    phone_id_list =[]
    for index, item in enumerate(data_list):
        try:
            print(f"当前fastgpt处理行：{index}")
            responseData = item['responseData']
            if len(responseData) == 0:
                continue

            # list转成map。key：工作流组价的名称，value：节点对象。避免节点调整，导致list中的数序变化
            responseData_map = {item['moduleName']:item for i,item in enumerate(responseData)}

            # slots 槽位信息
            slots_list = responseData_map['代码运行#判断最后一句消息角色']['customOutputs']['slots']

            # 如果chat_id_list包含 slots_list.get("chatId", "") 则continue
            current_chat_id = slots_list.get("chatId", "")
            if current_chat_id == "" or current_chat_id in chat_id_list:
                continue
            if len(chat_id_list) > max_row:
                print(f"chat_id_list 超过最大值，不再处理后续数据")
                break

            chat_id_list.append(current_chat_id)
            message_df = getMessagesByChartId(current_chat_id)
            messages = []
            for i, row in message_df.iterrows():
                messages.append({"role": ("assistant" if row["direction"] == 2 else "user"),
                                 "send_time": datetime.datetime.fromtimestamp(row["send_time"]).strftime(
                                     "%Y-%m-%d %H:%M:%S"), "message_type": row["message_type"],
                                 "content": row["text_content"]})
            # 拼接返回行数据
            result = {
                '序号': index,
                '历史对话': json.dumps(messages, indent=4, ensure_ascii=False),

                '未满足派单标准': content_json.get('未满足派单标准', ''),
                '未满足派单标准原因': content_json.get('未满足派单标准原因', ''),
                '用户表达不着急': content_json.get('用户表达不着急', ''),
                '负向情绪': content_json.get('负向情绪', ''),
                '询问是否AI': content_json.get('询问是否AI', ''),
                '用户未回复': content_json.get('用户未回复', '')
            }
            results.append(result)
        except Exception as e:
            print(f"index={index}，数据解析异常，错误信息：{e}")
            print(f"异常数据项：{item}")
    return results




if __name__ == "__main__":
    print("开始处理。。。。。")
    # 将聊天记录写入Excel文件，如果需要多次分析，可以使用缓存的聊天记录，避免重复查询数据
    message_df = getMessages()
    message_df.to_excel(output_file_for_temp, index=False, engine='openpyxl')
    print(f"聊天记录已成功写入: {output_file_for_temp}")


    results = process_all_rows(100)
    write_to_excel(results, output_file)
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    print("@@@@@@@@@@  处理完成  @@@@@@@@@@@@@")
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
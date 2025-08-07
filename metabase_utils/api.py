# -*- coding: utf-8 -*-
from typing import List, Dict, Any
from metabase_utils.presto_util.my_prestodb import query_from_db
#from prestodb_my import query_from_db
from metabase_utils.presto_util.LoggerClass import logger
from datetime import datetime

def get_chat_history(startTimeStr, endTimeStr) -> List[Dict[str, Any]]:
    # 查询微信聊天记录

    # 通过Metabase查询
    sql = f"""
select 
cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
, cr.chat_id 
, cr.conversation_template_id as "模板id"
, from_unixtime(cr.create_time+8*3600) as "会话开始时间"
, getday(cr.create_time+8*3600) as "会话开始时间-日期"
,(
	case when exists(
		select cb.id
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		where cb.behavior_status =7 and cb.chat_id =cr.chat_id 
		limit 1
	)  then '暂停托管' else '正常托管' end 
) as "托管类型"
from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where  cr.deleted =0 and cr.robot_takeover_type =0 and cr.strategy_scene =9
and json_extract_scalar(cr.extend_info  , '$.allSlotFlag')='1' 
and cr.transfer_manual_reason not in (19,29,53)
and cr.robot_id != '18576473328'
-- and cr.create_time >=to_unixtime(cast ('2025-07-31 23:30:0' as timestamp)) - 8*3600 
-- and cr.create_time <to_unixtime(cast ('2025-08-01 00:00:0' as timestamp)) - 8*3600 
and cr.create_time >=to_unixtime(cast ('{startTimeStr}' as timestamp)) - 8*3600 
and cr.create_time <to_unixtime(cast ('{endTimeStr}' as timestamp)) - 8*3600 
    """

    # logger.info(f"get_chat_history sql: {sql}")
    # logger.info(f"get_chat_history sql: ownerWechat:{ownerWechat} | externalUserid:{externalUserid}")
    logger.info(f"开始执行 query_from_db， 开始时间：{datetime.now()}, sql: {sql}")
    req = query_from_db(sql)
    query_from_db(sql)
    logger.info(f"query_from_db 执行完成， 结束时间：{datetime.now()}, req={req}")
    # 创建一个字典列表，每个字典代表一行数据
    data = [dict(zip(req['cols'], row)) for row in req['rows']]
    return data



if __name__ == '__main__':
    get_chat_history('2025-07-31 23:30:0','2025-08-01 00:00:0')
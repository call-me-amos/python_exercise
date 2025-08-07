import prestodb
import pandas as pd
# from prestodb import constants


def get_conn():
    conn = prestodb.dbapi.connect(
        host='presto.to8to.com',
        port=443,
        user='yanfa_user_guest',
        catalog='hive2',
        schema='default',
        http_scheme='https',
        request_timeout=900.0,
        auth=prestodb.auth.BasicAuthentication("yanfa_user_guest", "Mim6GO+W2RGNgVbb")
    )
    return conn


class Prestodb(object):
    def __init__(self, conn=None):
        self.conn = conn if conn else get_conn()

    def query(self, query_sql):
        conn = self.conn
        cur = conn.cursor()
        cur.execute(query_sql)
        try:
            rows = cur.fetchall()
            columns = [c['name'] for c in cur._query.columns]
            data_df = pd.DataFrame(data=rows, columns=columns)
        finally:
            cur.close()
            conn.close()
        return data_df


def query_from_db(query_sql):
    print(query_sql)
    prestodb = Prestodb()
    data_df = prestodb.query(query_sql)
    return data_df


if __name__ == '__main__':
    startTimeStr = '2025-07-31 23:30:0'
    endTimeStr = '2025-08-01 00:00:0'
    sql = f"""
--- 分派全槽位 进入率和收集率
--- 大模型槽位进入率和收集率
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
    result = query_from_db(sql)
    print(f'{result}')
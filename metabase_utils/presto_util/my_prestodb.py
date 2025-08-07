import pandas as pd
from pyhive import presto



def get_conn2():
    conn = presto.connect(
        host='presto.to8to.com',
        port=443,
        username='yanfa_user_guest',
        catalog='hive2',
        schema='default',
        protocol='https',
        requests_kwargs={
            'timeout': 900.0,  # 请求超时时间（秒）
            'auth': ('yanfa_user_guest', 'Mim6GO+W2RGNgVbb')  # Basic认证
        }
    )
    return conn


class Prestodb(object):
    def __init__(self, conn=None):
        """初始化连接

        Args:
            conn: 可传入现有连接，否则新建连接
        """
        self.conn = conn if conn else get_conn2()

    def query(self, query_sql):
        """执行查询并返回DataFrame

        Args:
            query_sql: 要执行的SQL语句

        Returns:
            pd.DataFrame: 包含查询结果的DataFrame
        """
        cur = None
        try:

            # cur = self.conn.cursor()
            # cur.execute("SHOW SCHEMAS")  # 查看当前 catalog 下的所有 schemas
            # print(cur.fetchall())  # 例如：[('default',), ('analytics',)]


            cur = self.conn.cursor()
            cur.execute(query_sql)

            # 获取列名（pyhive的特殊处理）
            if hasattr(cur, '_description'):
                columns = [col[0] for col in cur._description]
            else:
                columns = [desc[0] for desc in cur.description]

            # 获取数据并构建DataFrame
            rows = cur.fetchall()
            return pd.DataFrame(rows, columns=columns)

        finally:
            # 确保资源释放
            if cur:
                cur.close()
            if self.conn:
                self.conn.close()


def query_from_db(query_sql):
    print(query_sql)
    prestodb_temp = Prestodb()
    data_df = prestodb_temp.query(query_sql)
    return data_df


if __name__ == '__main__':
    sql = f"""
select 
cast(json_extract(cr.extend_info, '$.phone_id') as integer) 
, cr.chat_id 
, cr.conversation_template_id
, from_unixtime(cr.create_time+8*3600) 
, getday(cr.create_time+8*3600) 
,(
	case when exists(
		select cb.id
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		where cb.behavior_status =7 and cb.chat_id =cr.chat_id 
		limit 1
	)  then '暂停托管' else '正常托管' end 
) 
from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where  cr.deleted =0 and cr.robot_takeover_type =0 and cr.strategy_scene =9
and json_extract_scalar(cr.extend_info  , '$.allSlotFlag')='1' 
and cr.transfer_manual_reason not in (19,29,53)
and cr.robot_id != '18576473328'
and cr.create_time >=to_unixtime(cast ('2025-07-31 23:30:0' as timestamp)) - 8*3600 
and cr.create_time <to_unixtime(cast ('2025-08-01 00:00:0' as timestamp)) - 8*3600 
limit 200
    """
    result = query_from_db(sql)
    print(f'{result}')
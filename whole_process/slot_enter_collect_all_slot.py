import json
import pandas as pd
from openpyxl.styles import Alignment
import datetime
from datetime import timedelta
from metabase_utils.prestodb_my import query_from_db
import requests
import markdown
import imgkit
import hashlib
import base64

from metabase_utils.presto_util.LoggerClass import logger




# 企微机器人-全流程-调用fastGPT异常-告警群
# robot_url = 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=87098f26-b97e-4631-8b63-83916e09e00b'
# 企微机器人-大模型
robot_url = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=ba179f55-ebad-467e-bf73-ae20f62d196c"

# 手动执行sql，保存到：source_data.xlsx
# 然后通过这个方法，生成统计数据，并保存到excel
def statistic_and_save_to_excel(df = None):
    output_file = "./data/槽位的进入和收集数据.xlsx"
    if df is None:
        ## 通过sql查询到的槽位收集和进入明细表
        input_file = 'C:/Users/amos.tong/Desktop/source_data.xlsx'
        # 1. 读取数据
        df = pd.read_excel(input_file)

    # 2. 创建统计结果
    result = pd.DataFrame({
        '槽位': ['装修时间', '房屋类型', '工程量', '装修用途','是否交房','交房时间','意向量房时间','小区名称','房屋面积','姓氏'],
        '项目数量': len(df),
    })

    # 3. 计算指标
    result['槽位进入数'] = [
        df['进入-装修时间'].eq('进入').sum(),
        df['进入-房屋类型'].eq('进入').sum(),
        df['进入-工程量'].eq('进入').sum(),
        df['进入-装修用途'].eq('进入').sum(),
        df['进入-是否交房'].eq('进入').sum(),
        df['进入-交房时间'].eq('进入').sum(),
        df['进入-意向量房时间'].eq('进入').sum(),
        df['进入-小区名称'].eq('进入').sum(),
        df['进入-房屋面积'].eq('进入').sum(),
        df['进入-姓氏'].eq('进入').sum()
    ]

    # 4. 计算比率（保留数值用于格式化和潜在计算）
    result['槽位进入率'] = (result['槽位进入数'] / result['项目数量']).apply(lambda x: f"{x:.2%}")

    result['槽位收集数'] = [
        df['收集-装修时间'].eq('收集').sum(),
        df['收集-房屋类型'].eq('收集').sum(),
        df['收集-工程量'].eq('收集').sum(),
        df['收集-装修用途'].eq('收集').sum(),
        df['收集-是否交房'].eq('收集').sum(),
        df['收集-交房时间'].eq('收集').sum(),
        df['收集-意向量房时间'].eq('收集').sum(),
        df['收集-小区名称'].eq('收集').sum(),
        df['收集-房屋面积'].eq('收集').sum(),
        df['收集-姓氏'].eq('收集').sum()
    ]
    result['槽位收集率'] = (result['槽位收集数'] / result['项目数量']).apply(lambda x: f"{x:.2%}")

    # 5. 输出到Excel并自动调整列宽
    with pd.ExcelWriter(output_file, engine='openpyxl') as writer:
        result.to_excel(writer, index=False, sheet_name='统计结果')

        # 获取工作表对象
        worksheet = writer.sheets['统计结果']

        # 设置百分比列右对齐
        right_align = Alignment(horizontal='right')
        for col in ['D', 'F']:  # D列是槽位进入率，F列是槽位收集率
            for cell in worksheet[col]:
                cell.alignment = right_align

        # 自动调整列宽
        for col in worksheet.columns:
            max_length = 0
            column = col[0].column_letter  # 获取列字母

            # 计算列中单元格的最大字符长度
            for cell in col:
                try:
                    cell_value = str(cell.value)
                    # 中文按2字符宽度计算
                    chinese_count = sum(1 for c in cell_value if '\u4e00' <= c <= '\u9fff')
                    adjusted_length = len(cell_value) + chinese_count
                    if adjusted_length > max_length:
                        max_length = adjusted_length
                except:
                    pass

            # 设置列宽（基础宽度+缓冲）
            adjusted_width = (max_length + 2) * 1.2  # 1.2倍系数
            worksheet.column_dimensions[column].width = min(adjusted_width, 50)  # 限制最大列宽50

    logger.info(f"收集率和进入率统计完成：{output_file}")
    return result

# 将sql中的开始和结束时间替换后返回
def get_exec_sql(startTimeStr, endTimeStr):
    param_sql = f"""
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
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!692'
		and cd.reply ='90天内'
	) then '收集' else '未收集' end 
) as "收集-装修时间"
,(
	case when exists (
		-- 大模型主动提问
		select cd.reply 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		left join ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
		where cd.chat_id =cr.chat_id 
		and sp.property_name ='分派全槽位-提问队列'
		and cd.reply like '%装修时间%'
	) then '进入' else '未进入' end 
) as "进入-装修时间"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!697'
		and cd.reply !='' --TODO 需要细分
	) then '收集' else '未收集' end 
) as "收集-房屋类型"
,(
	case when exists (
		-- 大模型主动提问
		select cd.reply 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		left join ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
		where cd.chat_id =cr.chat_id 
		and sp.property_name ='分派全槽位-提问队列'
		and cd.reply like '%房屋类型%'
	) then '进入' else '未进入' end 
) as "进入-房屋类型"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!702'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-工程量"
,(
	case when exists (
		-- 大模型主动提问
		select cd.reply 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		left join ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
		where cd.chat_id =cr.chat_id 
		and sp.property_name ='分派全槽位-提问队列'
		and cd.reply like '%工程量%'
	) then '进入' else '未进入' end 
) as "进入-工程量"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!699'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-装修用途"
,(
	case when exists (
		-- 大模型主动提问
		select cd.reply 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		left join ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
		where cd.chat_id =cr.chat_id 
		and sp.property_name ='分派全槽位-提问队列'
		and cd.reply like '%装修用途%'
	) then '进入' else '未进入' end 
) as "进入-装修用途"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!705'
		and cd.reply ='是'
	) then '收集' else '未收集' end 
) as "收集-是否交房"
,(
	case when exists (
		-- 大模型主动提问
		select cd.reply 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		left join ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
		where cd.chat_id =cr.chat_id 
		and sp.property_name ='分派全槽位-提问队列'
		and cd.reply like '%是否交房%'
	) then '进入' else '未进入' end 
) as "进入-是否交房"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!693'
		and cd.reply ='3个月内'
	) then '收集' else '未收集' end 
) as "收集-交房时间"
,(
	case when exists (
		-- 大模型主动提问
		select cd.reply 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		left join ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
		where cd.chat_id =cr.chat_id 
		and sp.property_name ='分派全槽位-提问队列'
		and cd.reply like '%交房时间%'
	) then '进入' else '未进入' end 
) as "进入-交房时间"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!694'
		and cd.reply ='一个月内'
	) then '收集' else '未收集' end 
) as "收集-意向量房时间"
,(
	case when exists (
		-- 大模型主动提问
		select cd.reply 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		left join ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
		where cd.chat_id =cr.chat_id 
		and sp.property_name ='分派全槽位-提问队列'
		and cd.reply like '%量房时间%'
	) then '进入' else '未进入' end 
) as "进入-意向量房时间"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!703'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-小区名称"
,(
	case when exists (
		-- 大模型主动提问
		select cd.reply 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		left join ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
		where cd.chat_id =cr.chat_id 
		and sp.property_name ='分派全槽位-提问队列'
		and cd.reply like '%小区名称%'
	) then '进入' else '未进入' end 
) as "进入-小区名称"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!696'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-房屋面积"
,(
	case when exists (
		-- 大模型主动提问
		select cd.reply 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		left join ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
		where cd.chat_id =cr.chat_id 
		and sp.property_name ='分派全槽位-提问队列'
		and cd.reply like '%房屋面积%'
	) then '进入' else '未进入' end 
) as "进入-房屋面积"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!695'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-姓氏"
,(
	case when exists (
		-- 大模型主动提问
		select cd.reply 
		from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		left join ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
		where cd.chat_id =cr.chat_id 
		and sp.property_name ='分派全槽位-提问队列'
		and cd.reply like '%姓氏%'
	) then '进入' else '未进入' end 
) as "进入-姓氏"
from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where  cr.deleted =0 and cr.robot_takeover_type =0 and cr.strategy_scene =9
and json_extract_scalar(cr.extend_info  , '$.allSlotFlag')='1' 
and cr.transfer_manual_reason not in (19,29,53)
and cr.robot_id != '18576473328'

    """
    param_sql = f"""
{param_sql}
--and cr.create_time >=to_unixtime(cast ('{startTimeStr}' as timestamp)) - 8*3600 
--and cr.create_time <to_unixtime(cast ('{endTimeStr}' as timestamp)) - 8*3600 

and cr.chat_id='MTMyMTcwNDcwNjkjd21KaUliREFBQWJ3ZHlVTWFxZ0xsaVhjd0c1Wm5FM3c='
"""
    return param_sql

#格式化播报内容
def format_message(merged_df):
    result = statistic_and_save_to_excel(merged_df)
    message = f"""\
### 【销冠】槽位收集率和进入率 统计结果
| 槽位 | 项目数量 | 槽位进入数  | 槽位进入率 | 槽位收集数 | 槽位收集率 | 
| :----- | :----: | :----: | :----: | :----: | :----: |\
"""
    for index, row in result.iterrows():
        message += f"""
| {row['槽位']} | {row['项目数量']} | {row['槽位进入数']} | {row['槽位进入率']} | {row['槽位收集数']}  | {row['槽位收集率']}  |"""
    return message

#post请求发送播报数据
def send_post_message(data):
    url = robot_url
    headers = {
        "Content-Type": "application/json"
    }
    data = {
        "msgtype": "markdown_v2",
        "markdown_v2": {
            "content": data
        }
    }
    response = requests.post(url, headers=headers, data=json.dumps(data))
    logger.info(f"发送文本信息：{response.text}")
    return response.json()

# # 把markdown生成图片
def markdown_to_image(md_text, output_path="output.png"):
    # Markdown 转 HTML
    html_content = markdown.markdown(md_text,extensions=['tables'])

    logger.info(f"当前的markdown信息：\n{html_content}")

    # 完整 HTML 结构（添加 CSS 样式）
    full_html = f"""
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <style>
        body {{
          font-family: 'Arial', sans-serif;
          line-height: 1.6;
          padding: 20px;
          max-width: 800px;
          margin: 0 auto;
        }}
        pre {{
          background-color: #f5f5f5;
          padding: 10px;
          border-radius: 4px;
        }}
        table {{
            border: 2px solid black;
        }}
         th, td {{
            border: 1px solid black; 
         }}
        code {{ background-color: #f5f5f5; }}
      </style>
    </head>
    <body>{html_content}</body>
    </html>
    """
    # 指定 wkhtmltoimage 路径（根据你的实际安装位置修改）
    config = imgkit.config(wkhtmltoimage=r'C:\Program Files\wkhtmltopdf\bin\wkhtmltoimage.exe')

    # HTML 转图片（添加 config 参数）
    imgkit.from_string(
        full_html,
        output_path,
        config=config,  # 添加这行
        options={"format": "png", "enable-local-file-access": None}
    )
    logger.info(f"图片已保存至: {output_path}")

def get_md5_and_base64(file_path):
    # 获取 MD5
    md5_hash = hashlib.md5()

    # 读取文件并计算 MD5
    with open(file_path, "rb") as f:
        while chunk := f.read(8192):
            md5_hash.update(chunk)

    md5_value = md5_hash.hexdigest()

    # 获取 Base64 编码内容
    with open(file_path, "rb") as f:
        base64_data = base64.b64encode(f.read()).decode("utf-8")

    return md5_value, base64_data

#post请求发送播报数据
def send_post_img_message(data):
    md5_value, base64_content = get_md5_and_base64(data)
    url = robot_url
    headers = {
        "Content-Type": "application/json"
    }
    data = {
        "msgtype": "image",
        "image": {
            "base64": base64_content,
            "md5": md5_value
        }
    }
    response = requests.post(url, headers=headers, data=json.dumps(data))
    logger.info(f"发送图片信息：{response.text}")
    return response.json()


if __name__ == "__main__":
    # 开始和结束时间组，前闭后开
    exec_time = [
        ["00:00:0", "00:00:0"]
        # ["00:00:0", "10:00:0"],
        # ["10:00:0", "15:00:0"],
        # ["15:00:0", "00:00:0"],

        # 测试
        # ["15:00:0", "15:30:0"],
        # ["15:00:0", "15:30:0"],
    ]

    now = datetime.datetime.now()
    # 计算今天的零点
    today_midnight = now.replace(hour=0, minute=0, second=0, microsecond=0).strftime("%Y-%m-%d")
    # 计算第二天的零点
    next_day_midnight = (now.replace(hour=0, minute=0, second=0, microsecond=0) + datetime.timedelta(days=1)).strftime("%Y-%m-%d")
    logger.info(f"今天零点：{today_midnight}。第二天零点:{next_day_midnight}")

    # 在循环前创建一个空列表来收集DataFrame
    all_dfs = []
    for i in range(len(exec_time)):
        if i == len(exec_time):
            startTimeStr = today_midnight + " " + exec_time[i][0]
            endTimeStr = today_midnight + " " + exec_time[i][1]
        else:
            startTimeStr = today_midnight + " " + exec_time[i][0]
            endTimeStr = next_day_midnight + " " + exec_time[i][1]
        query_sql = get_exec_sql(startTimeStr, endTimeStr)
        # 查询数据
        data_df = query_from_db(query_sql)
        # 将每个DataFrame添加到列表中
        all_dfs.append(data_df)

    # 使用pd.concat合并所有DataFrame
    merged_df = pd.concat(all_dfs, ignore_index=True)
    # 格式化成markdown文本
    format_md_text = format_message(merged_df)


    logger.info(f"拼接表头后的最终报表数据：\n{format_md_text}")

    # send_post_message(format_md_text)   # 发送文本 markdown格式

    # 把markdown生成图片
    markdown_to_image(format_md_text, output_path="data/output.png")
    # 发送图片
    send_post_img_message("data/output.png")

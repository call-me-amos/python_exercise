@set hivevar_smart_chat_dt = '20240118'

select ${hivevar_smart_chat_dt}

-------------------------------------------------------
-- 表5：转人工
-- 视图  v_hive_ads_smart_chat_tb_transfer_manual_reason_report
drop table if exists hive2.test.tmp_smart_chat_tb_transfer_manual_reason_report;

create table if not exists hive2.test.tmp_smart_chat_tb_transfer_manual_reason_report as
(
	select create_time, valid_takeover_total ,transfer_manual_total 
	,transfer_manual_reason
	, sum(transfer_manual_num) as transfer_manual_num
	, sum(transfer_manual_total_rate) as transfer_manual_total_rate
	from 
	(
					select tb_temp_vt.create_time, tb_temp_vt.valid_takeover_total
					,tb_temp_transfer_manual_total.transfer_manual_total
					,
					case tb_temp_ccr_02.transfer_manual_reason
					when 	18	 then '未开启托管'
					when 	22	 then '未开启托管'
					when 	1	 then '主动取消托管'
					when 	3	 then '用户删微'
					when 	19	 then '项目已获权'
					when 	6	 then '内容识别失败'
					when 	8	 then '内容识别失败'
					when 	11	 then '意图识别失败'
					when 	13	 then '槽位值归一失败'
					when 	4	 then '系统错误'
					when 	9	 then '系统错误'
					when 	16	 then '系统错误'
					when 	20	 then '系统错误'
					when 	21	 then '系统错误'
					when 	12	 then '无问题答案'
					when 	14	 then '无策略话术'
					when 	5	 then '策略转人工'
					when 	10	 then '策略转人工'
					when 	15	 then '策略转人工'
					when 	17	 then '策略转人工'
					when 	23	 then '策略转人工'
					when 	27	 then '策略转人工'
					when 	28	 then '策略转人工'
					when 	7	 then '机器人自闭环'
					when 	24	 then '机器人自闭环'
					end as transfer_manual_reason
					, tb_temp_ccr_02.transfer_manual_num
					, round(cast(tb_temp_ccr_02.transfer_manual_num as double)/ tb_temp_transfer_manual_total.transfer_manual_total, 2)  as  transfer_manual_total_rate
					from 
					(--总的有效托管数
						select vt.create_time, sum(vt.valid_takeover_total) valid_takeover_total 
						from hive2.test.tmp_smart_chat_tb_valid_takeover vt
						group by vt.create_time
					) as tb_temp_vt
					left join 
					(---总的转人工数（包含无效托管数）
						select tb_temp_ccr.create_time , count(1) as transfer_manual_total
						from 
						(
							select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time
							from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
							where ccr1.dt =${hivevar_smart_chat_dt} 
							and ccr1.robot_takeover_type =0 
							--and ccr1.conversation_template_id in (13, 20, 21)
							and (conversation_template_id in (13, 20, 21, 26) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26))
							and ccr1.check_status =5
						) as tb_temp_ccr
						group by tb_temp_ccr.create_time
					) as tb_temp_transfer_manual_total
						on tb_temp_vt.create_time = tb_temp_transfer_manual_total.create_time
					left join 
					(--转人工原因分组
							select tb_temp_ccr.create_time ,tb_temp_ccr.transfer_manual_reason, count(1) as transfer_manual_num
							from 
							(
								select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time
								,  ccr1.transfer_manual_reason
								
								--select ccr1.robot_id 
								from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
								where ccr1.dt =${hivevar_smart_chat_dt} 
								and ccr1.robot_takeover_type =0 
								--and ccr1.conversation_template_id in (13, 20, 21)
								and (conversation_template_id in (13, 20, 21, 26) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26))
								and ccr1.check_status =5
								-- 测试
								--and ccr1.create_time between 1701964800 and 1701964800+3600*24
							) as tb_temp_ccr
							group by tb_temp_ccr.create_time ,tb_temp_ccr.transfer_manual_reason
					) as tb_temp_ccr_02
						on tb_temp_vt.create_time =  tb_temp_ccr_02.create_time	
	) 
	group by create_time, valid_takeover_total ,transfer_manual_total,transfer_manual_reason
	
);

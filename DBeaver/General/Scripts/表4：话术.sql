@set hivevar_smart_chat_dt = '20240118'

select ${hivevar_smart_chat_dt}

-------------------------------------------------------

-- 表4：话术维度
drop table if exists hive2.test.tmp_smart_chat_tb_robot_ask_report;

--视图：  v_hive_ads_smart_chat_tb_robot_ask_report
create table if not exists hive2.test.tmp_smart_chat_tb_robot_ask_report as
(
		select tvt.create_time  --加微时间
		,tvt.valid_takeover_total   --托管项目数
		,  tb_temp_qiwei_record.slot_name --槽位
		, tb_temp_qiwei_record.script_type --话术类型
		, tb_temp_qiwei_record.text_content --话术文本
		, tb_temp_qiwei_record.send_num     --发送数
		, tb_temp_qiwei_record_02.response_num   --回复数
		, round(cast(tb_temp_qiwei_record_02.response_num as double)/ tb_temp_qiwei_record.send_num, 2)  as  response_ratio  --回复率
		, tb_temp_qiwei_record_02.right_response_num--正向回复数
		, round(cast(tb_temp_qiwei_record_02.right_response_num as double)/ tb_temp_qiwei_record.send_num, 2)  as  right_response_ratio--正向回复率
		
-- 		测试 TODO 
--		select *
		-- 加微时间，有效托管数
		from 
		(
			select tb_tvt.create_time, sum(tb_tvt.valid_takeover_total) as valid_takeover_total
			from 
			hive2.test.tmp_smart_chat_tb_valid_takeover tb_tvt
			group by tb_tvt.create_time 
		) as tvt
		-- 测试
--		where tvt.create_time  = 1700841600
		left join 
		(
			select tb_temp_qiwei.create_time, tb_temp_qiwei.slot_name, tb_temp_qiwei.script_type, tb_temp_qiwei.text_content
				, count(1)  send_num
			from 
			(
					select ccr.create_time
					,if(cqr.robot_ask_id=0 or cqr.robot_ask_id is null, '无',
						(
							select 
								case cra.check_type_code
								when '' then '未配置'
								when '7!711!71102!16' then '城市'
								when '7!711!71102!3' then '小区地址'
								when '7!711!71102!2' then '房屋面积'
								when '7!711!71102!8' then '工程量'
								when '7!711!71102!10' then '区县'
								when '7!711!71102!3' then '小区名称'
								when '7!711!71102!4' then '房屋类型'
								when '7!711!71102!9' then '街道'
								when '7!711!71102!11' then '姓氏'
								when '7!711!71102!14' then '时间'
								when '7!711!71102!1' then '装修时间'
								when '7!711!71102!6' then '意向量房时间'
								when '7!711!71102!21' then '手机号'
								when '7!711!71102!22' then '房屋用途'
								when '7!711!71102!34' then '装修类型'
								else cra.check_type_code
								end as check_type_code
							from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
							where cqr.robot_ask_id= cra.id 
						)
					) as slot_name
					, cqr.script_type
					, cqr.text_content
					, cqr.id
					from 
					(
						select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time
						, ccr1.robot_id 
						, ccr1.chat_id 
						,ccr1.staff_service_time 
						from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
						where ccr1.dt =${hivevar_smart_chat_dt} 
						and ccr1.robot_takeover_type =0 
						and ccr1.conversation_template_id in (13, 20, 21)
					) as ccr
					left join 
					(
						select cqr.chat_id , min(cqr.send_time) as fisrt_msg_send_time
						 from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record cqr
						 where cqr.direction = 2
						 group by cqr.chat_id 
					) as tb_fisrt_msg_create_time
						on    ccr.chat_id = tb_fisrt_msg_create_time.chat_id  
					left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record cqr
						on ccr.chat_id= cqr.chat_id 
					
					where ccr.staff_service_time >= cqr.create_time  --转人工之前发送的消息有效
					and ccr.staff_service_time > tb_fisrt_msg_create_time.fisrt_msg_send_time
					and cqr.direction=2 and cqr.system_type=1
			) as tb_temp_qiwei
			group by tb_temp_qiwei.create_time, tb_temp_qiwei.slot_name, tb_temp_qiwei.script_type, tb_temp_qiwei.text_content
		) as tb_temp_qiwei_record
			on tvt.create_time = tb_temp_qiwei_record.create_time
		-- TODO 测试
		--where tvt.create_time  = 1700841600
		left join 
		(---回复数+正向回复数
			select tb_temp_qiwei.create_time, tb_temp_qiwei.slot_name, tb_temp_qiwei.script_type, tb_temp_qiwei.text_content
				, count(tb_temp_qiwei.min_qiwei_id)  as response_num  --回复数
				, sum(tb_temp_qiwei.right_response_type) as right_response_num--正向回复数
			from 
			(---业主是否回复
					select tb_temp_qiwei_record_03.create_time, tb_temp_qiwei_record_03.slot_name, tb_temp_qiwei_record_03.script_type, tb_temp_qiwei_record_03.text_content
					, tb_temp_qiwei_record_03.min_qiwei_id
					,  
					case tb_temp_qiwei_record_04.user_reply_intention 
						when '表达拒绝服务' then 0
						when '表达不耐烦' then 0
						when '用户投诉' then 0
						else 1
					end as right_response_type
					
					-- 是否正向回复
					from
					(---获取顾问提问之后，下一个话术的id（可能是顾问发的，也有可能是业主发送的）
									select tb_temp_qiwei_record_05.create_time
									, tb_temp_qiwei_record_05.chat_id
									,  tb_temp_qiwei_record_05.slot_name, tb_temp_qiwei_record_05.script_type, tb_temp_qiwei_record_05.text_content
									, min(tb_temp_qiwei_record_05.all_qiwei_id) as min_qiwei_id  --距离上一次回复最近的一个聊天记录
									from 
									(
											select ccr.create_time
											, ccr.chat_id
											,if(cqr.robot_ask_id=0 or cqr.robot_ask_id is null, '无',
													(
														select 
															case cra.check_type_code
															when '' then '未配置'
															when '7!711!71102!16' then '城市'
															when '7!711!71102!3' then '小区地址'
															when '7!711!71102!2' then '房屋面积'
															when '7!711!71102!8' then '工程量'
															when '7!711!71102!10' then '区县'
															when '7!711!71102!3' then '小区名称'
															when '7!711!71102!4' then '房屋类型'
															when '7!711!71102!9' then '街道'
															when '7!711!71102!11' then '姓氏'
															when '7!711!71102!14' then '时间'
															when '7!711!71102!1' then '装修时间'
															when '7!711!71102!6' then '意向量房时间'
															when '7!711!71102!21' then '手机号'
															when '7!711!71102!22' then '房屋用途'
															when '7!711!71102!34' then '装修类型'
															else cra.check_type_code
															end as check_type_code
														from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
														where cqr.robot_ask_id= cra.id 
													)
												) as slot_name
											, cqr.script_type
											, cqr.text_content
											, cqr2.id as all_qiwei_id
											from 
											(
												select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time
												, ccr1.chat_id ,ccr1.staff_service_time 
												from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
												where ccr1.dt =${hivevar_smart_chat_dt} 
												and ccr1.robot_takeover_type =0 
												and ccr1.conversation_template_id in (13, 20, 21)
											) as ccr
											left join 
											(
												select cqr.chat_id , min(cqr.send_time) as fisrt_msg_send_time
												 from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record cqr
												 where cqr.direction = 2
												 group by cqr.chat_id 
											) as tb_fisrt_msg_create_time
												on    ccr.chat_id = tb_fisrt_msg_create_time.chat_id 
											left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record cqr
												on ccr.chat_id= cqr.chat_id 
											
											left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record cqr2
												on cqr2.chat_id= cqr.chat_id 
											where ccr.staff_service_time > tb_fisrt_msg_create_time.fisrt_msg_send_time ---有效托管
											and cqr.direction=2 and cqr.system_type=1 and ccr.staff_service_time >= cqr.create_time and cqr2.id > cqr.id  --顾问发送消息之后的消息  --转人工之前发送的消息有效.顾问被动发送（机器人发送）的消息 
											
									) as tb_temp_qiwei_record_05
--									 
									
									group by tb_temp_qiwei_record_05.create_time, tb_temp_qiwei_record_05.chat_id,  tb_temp_qiwei_record_05.slot_name, tb_temp_qiwei_record_05.script_type, tb_temp_qiwei_record_05.text_content
									
					) as tb_temp_qiwei_record_03
					left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record tb_temp_qiwei_record_04
						on tb_temp_qiwei_record_03.min_qiwei_id = tb_temp_qiwei_record_04.id 
					where tb_temp_qiwei_record_03.min_qiwei_id is not null 
					and tb_temp_qiwei_record_04.id  is not null
					and  tb_temp_qiwei_record_04.direction =1 and tb_temp_qiwei_record_04.system_type =0  --必须是业主主动回复
					
					
			) as tb_temp_qiwei
			
			group by tb_temp_qiwei.create_time, tb_temp_qiwei.slot_name, tb_temp_qiwei.script_type, tb_temp_qiwei.text_content
			
			-- TODO 测试ceshi 
			--having count(1)>1
		) as tb_temp_qiwei_record_02  --获取回复数
			on tb_temp_qiwei_record_02.create_time = tb_temp_qiwei_record.create_time 
			and tb_temp_qiwei_record_02.slot_name=tb_temp_qiwei_record.slot_name 
			and tb_temp_qiwei_record_02.script_type=tb_temp_qiwei_record.script_type 
			and tb_temp_qiwei_record_02.text_content=tb_temp_qiwei_record.text_content
);		

		
			
			
			
			
			
			
			
			
			
			
		
		
		
		
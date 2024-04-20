
------------------------------------------------------------------
--trusteeship_status 0：未托管，1托管中，2取消托管
select * 
from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_session iis
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on iis.wechat = cr.robot_id and iis.unique_id = cr.uid 
where unique_id ='wmJiIbDAAAu3aWzXN6Ne_LQR5QEJstvA' and wechat ='085472' and trusteeship_status= 1



---------------------------------  行转列
select cr.chat_id  
, min(cr.extend_info) as extend_info --电话id
, min(case when cd.check_type_code='7!711!71102!4' then cd.reply end) as HOUSE_TYPE --房屋类型
, min(case when cd.check_type_code='7!711!71102!2' then cd.reply end) as AREA --房屋面积
, min(case when cd.check_type_code='7!711!71102!1' then cd.reply end) as TIME --装修时间
, min(case when cd.check_type_code='7!711!71102!13' then cd.reply end) as COMPLETION_DATE --交房时间
, min(case when cd.check_type_code='7!711!71102!6' then cd.reply end) as MEASUREMENT_TIME --意向量房时间
, min(case when cd.check_type_code='7!711!71102!11' then cd.reply end) as LAST_NAME --姓氏
--, concat_ws(',', collect_set(case when cd.check_type_code not in ('7!711!71102!4') then cd.reply end)) as other --其他字段
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd on cr.chat_id = cd.chat_id 
where  cr.extend_info in (

)
and cr.deleted =0
and cd.reply !=''
group by cr.chat_id

================================================


---账号取消托管，  存量的用户需要主动取消托管
select from_unixtime(cd.create_time+8*3600) as ct
,cd.extend_info 
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
,from_unixtime(cd.staff_service_time +8*3600) as sst
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where 
cd.robot_id  in 
(
'52648',	'533327','25384282','79082174','86825975','86835702','tongzhiwei','fantong','0196','13683560870','010450757','19076199802','19924512641','19071463969','19168536979','13714057126','19860846047','18124142504','18126462094','18038174915','18194057743','19065033242','19076125944','18025393154','18038174267','18124144642','19076199760','13554702790','19075699072'
)
--and cd.check_status !=5
and cd.robot_takeover_type =0
order by id desc

      
--
select from_unixtime(cd.create_time+8*3600) as ct
,cd.extend_info 
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
,from_unixtime(cd.staff_service_time +8*3600) as sst
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where 
cd.strategy_scene =8
order by id desc


--  电话id查询 会话记录
select from_unixtime(cd.create_time+8*3600) as ct
,cd.extend_info 
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
,from_unixtime(cd.staff_service_time +8*3600) as sst
,cd.check_status 
,cd.transfer_manual_reason 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where
--cd.uid in (
--'wmJiIbDAAAGIUC30eD7vkNaTuEPygCSQ','wmJiIbDAAAYezmk1oQ2b1XJYUMnecOcw','wmJiIbDAAAEliqPoQxg4QyqPRnlZWeKQ','wmJiIbDAAAQQftIU57VTgXbbusGw0WLA','wmJiIbDAAAv5fu8AT8kjt-OZfTRFdcYg','wmJiIbDAAAsJOkNzFnvrTG8-CblJ5Jgg','wmJiIbDAAAYWtdT3BBQ1YY1DTMqZ3_2g','wmJiIbDAAAXKOOkOnawBlBbq2FLVc_Ag','wmJiIbDAAAraL6Unl1dqpzcaATL1Mt8g','wmJiIbDAAAfIomozUqkabUT1zVTK6a7A','wmJiIbDAAA3TklvnZ8IAUdI72jCeFCvw','wmJiIbDAAAB_AtRJ2euBEiBLJmOoR0sQ','wmJiIbDAAA6ZOmskWC7ss7C28xEwMULA'
--)
cd.extend_info like '%380179974%'
--cd.robot_id in ('10732163','15361532146', '17744967690','18129976274')
order by id desc
limit 100



select from_unixtime(cd.create_time+8*3600) as ct
,cd.extend_info 
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
,from_unixtime(cd.staff_service_time +8*3600) as sst
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where 
--cd.chat_id ='MTkwNjUwMTc2MDQjd21KaUliREFBQW5XY0loSUlYMmZEMzgyUjQ5M3Nxdnc='
cd.uid ='wmJiIbDAAA-D2XhCIx-cxbnSPeFAV5Eg'
order by id desc


select from_unixtime(t.create_time+8*3600) as "创建时间",* from 
hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior t
where 
t.behavior_status >=5
--and t.chat_id ='MTkwNzU2OTE0NDgjd21KaUliREFBQW1PTG1xNVJDb0JrdDFORWlTUl9UYkE='
and t.we_chat in
(
'79081421','70227341','19168533573','13554703502','19065033242','19065037246','19065037545','13554701752','10346305','02194','19065033180','18124142504'
)
and t.create_time >=to_unixtime(cast ('2024-03-18 00:00:0' as timestamp)) - 8*3600 
and t.create_time < to_unixtime(cast ('2024-04-15 00:00:0' as timestamp)) - 8*3600 
----------------------------------

select from_unixtime(cd.create_time+8*3600) as ct
,cd.check_status 
,cd.extend_info 
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
,from_unixtime(cd.staff_service_time +8*3600) as sst
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where 
cd.chat_id in 
(
'MTk4MjA4MTA3NDMjd21KaUliREFBQXlxQXNzemRUY3dac2hmNGpFekZpWkE='
)
order by id desc
-------------------------

select from_unixtime(create_time+8*3600) as create_time
, from_unixtime(update_time+8*3600) as update_time
, cd.check_type_code 
, cd.reply 
, cd.source_reply 
, cd.nlp_reply 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
where 
cd.chat_id ='MTk4MjA4MTA3NDMjd21KaUliREFBQWhqb3g3NnRpZHdtNW8yekdqOGtpUlE='
and cd.deleted =0
order by id desc


select from_unixtime(cd.create_time+8*3600) as ct
, from_unixtime(cd.reply_time +8*3600) as rt
,* 
from  hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
where 
cd.chat_id ='MTM1NTQ3MDI2NDcjd21KaUliREFBQUNoQ3NGYmlwLVU2dG1JVnhwVVhqX0E='
order by cd.reply_time  desc


select from_unixtime(cd.create_time+8*3600) as ct
,* 
from  hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
where cd.check_type_code in ('7!711!71102!55' )
order by id desc


select from_unixtime(qr.create_time+8*3600) as ct,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where 
--qr.chat_id ='MTM1NTQ3MDM1MDIjd21KaUliREFBQUkzYVBvZ1BVandRbzVweW14VllIVUE='
qr.text_content like '%hi在不咯%'
and create_time >=to_unixtime(cast ('2024-03-26 00:00:0' as timestamp)) - 8*3600 
and create_time < to_unixtime(cast ('2024-03-27 00:00:0' as timestamp)) - 8*3600 
order by id 


select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where 
--qr.text_content like '%津南区小站菊香园%'
qr.chat_id ='MTkwNjUwMzc1NDUjd21KaUliREFBQWlPRElxRjRSQWNKbERuUm9XTl82dkE='
order by qr.id asc
;


--  用户行为
select from_unixtime(ccb.create_time+8*3600) as ct,
* 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior ccb
where ccb.behavior_status in (5,6,7,8,9,10)



--------


-- 静默信息
select 
from_unixtime(ccr.create_time+8*3600) as ct
--,ccr.transfer_manual_reason 
, ccr.extend_info 
, (json_extract_scalar(ccr.extend_info, '$.silentType')) as silentType
, *
--count(distinct ccr.robot_id)
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr
where 
 (conversation_template_id in (13, 20, 21, 26) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26))
and ccr.robot_takeover_type =0
--and ccr.deleted =0
--and ccr.create_time >= 1703174400 
and ccr.create_time < 1705680000
--and ccr.chat_id ='MTgxMjQxNDUzMjQjd21KaUliREFBQXpqaU8tcHgxanNiNVhOS0xoN2hMd1E='
--and ccr.transfer_manual_reason !=1
and ccr.check_status !=5
--and ccr.robot_id in('13554702790', '19924512641', '19146449816')
--and ccr.deleted =1
order by id desc


--- 还在静默状态的用户
select 
from_unixtime(ccr.create_time+8*3600) as ct
,ccr.transfer_manual_reason 
, ccr.extend_info 
, (json_extract_scalar(ccr.extend_info, '$.silentType')) as silentType
, *
--count(distinct ccr.robot_id)
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr
where 
ccr.conversation_template_id in (12, 13, 20, 21)
and ccr.robot_takeover_type =0
and ccr.deleted =0
and ccr.check_status =6
order by id desc

-------------
--通过电话id查询需求的获权时间。（异常情况需要看项目的获权时间或者需求的创建时间）
-- 按电话找联系人id
select id from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_contact where phone_id = 320217517;
-- 按联系人id项目
select proj_id,* from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_project where con_id = 9833622;
-- 按项目id找需求。可能有多个，找有值那个查看获权时间
select dem_id,granted_time,granted_uid from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_demand where proj_id = 44657011;

---tips：合并在一起查询很慢
select dem_id,granted_time,granted_uid from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_demand where proj_id in (
    select proj_id from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_project where con_id = (
        select id from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_contact  where phone_id = 373992463
        )
    );
---------------------------

===========================================================
---
@set hivevar_smart_chat_dt = '20240217'
-- 自闭环汇总
		select tb_self_close_temp_2.create_time, tb_self_close_temp_2.robot_id, count(tb_self_close_temp_2.chat_id) as self_close_total
		from 
		(
				select tb_self_close_temp.create_time ,tb_self_close_temp.chat_id, tb_self_close_temp.robot_id, count(tb_self_close_temp.check_type_code) as self_close_slot_total
				from 
				(
					select ccr.create_time, ccr.chat_id ,ccr.robot_id ,ccd.check_type_code
					from 
					(
						select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time, ccr1.robot_id , ccr1.chat_id 
						from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
						where ccr1.dt =${hivevar_smart_chat_dt} 
						and ccr1.robot_takeover_type =0 
						and (conversation_template_id in (13, 20, 21, 26,33,35,36,37,38) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26,33,35,36,37,38))
						and ccr1.deleted =0
						and ccr1.transfer_manual_reason <>1
						and ccr1.robot_id in ('13554701752','10346305','02194')
					) as ccr
					left join hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail ccd on ccr.chat_id = ccd.chat_id 
					where ccd.dt =${hivevar_smart_chat_dt}
					and ccd.reply_time >0
					and ccd.deleted =0
					and ccd.check_type_code in ('7!711!71102!4', '7!711!71102!1', '7!711!71102!3', '7!711!71102!2', '7!711!71102!6', '7!711!71102!11')
					and ccd.role_type in (1,3,4)
					group by ccr.create_time, ccr.chat_id ,ccr.robot_id , ccd.check_type_code
				) as tb_self_close_temp
				where tb_self_close_temp.check_type_code in ('7!711!71102!4', '7!711!71102!1', '7!711!71102!3', '7!711!71102!2', '7!711!71102!6', '7!711!71102!11')
				group by tb_self_close_temp.create_time ,tb_self_close_temp.chat_id, tb_self_close_temp.robot_id
		) as tb_self_close_temp_2
		where tb_self_close_temp_2.self_close_slot_total =6  -- 核需到6个槽位
		group by tb_self_close_temp_2.create_time, tb_self_close_temp_2.robot_id
----------------------
		@set hivevar_smart_chat_dt = '20240227'
					select tb_temp_vt.create_time, tb_temp_vt.valid_takeover_total
					,tb_temp_transfer_manual_total.transfer_manual_total
					,tb_temp_ccr_02.transfer_manual_reason transfer_manual_reason
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
							and (conversation_template_id in (13, 20, 21, 26,33,35,36,37,38) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26,33,35,36,37,38))
							and ccr1.check_status =5
						) as tb_temp_ccr
						group by tb_temp_ccr.create_time
					) as tb_temp_transfer_manual_total
						on tb_temp_vt.create_time = tb_temp_transfer_manual_total.create_time
					left join 
					(--转人工原因分组
					
					
							select tb_temp_ccr.create_time ,tb_temp_ccr.transfer_manual_reason, count(1) as transfer_manual_num
							select *
							from 
							(
								select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time
								,  ccr1.transfer_manual_reason
								,ccr1.chat_id 
								
								--select ccr1.robot_id 
								from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
								where ccr1.dt =${hivevar_smart_chat_dt} 
								and ccr1.robot_takeover_type =0 
								and (conversation_template_id in (13, 20, 21, 26,33,35,36,37,38) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26,33,35,36,37,38))
								and ccr1.check_status =5
								and ccr1.transfer_manual_reason = 2 
								and ccr1.create_time >=1708963200 and ccr1.create_time <1709049600
							
							
							) as tb_temp_ccr
							
							group by tb_temp_ccr.create_time ,tb_temp_ccr.transfer_manual_reason
							
							
							
							
							
					) as tb_temp_ccr_02
						on tb_temp_vt.create_time =  tb_temp_ccr_02.create_time			
		
		
		
		
		

-------------------------

						select t6.dialog_version              as "会话版本"
     , chat_date                      as "日期"
     , t6.id                          as "ID"
     , t6.send_user                   as "顾问编码"
     , t6.accept_user                 as "用户编码"
     , t6.external_userid             as "外部联系人编码"
     , t6.we_link_nick_name           as "机器人或顾问昵称"
     , t6.question                    as "问题内容"
     , t6.question_send_datetime      as "问题发送时间"
     , t6.responses                   as "用户回复内容"
     , t6.response_send_datetime      as "用户回复时间"
     , t6.next_id                     as "下一个问题ID"
     , t6.next_question               as "下一个问题"
     , t6.next_question_send_datetime as "下一个问题发送时间"
     , t6.next_responses              as "下一个问题用户回复内容"
     , t6.next_response_send_datetime as "下一个问题用户回复时间"
from (select t5.dialog_version
           , date_format(from_unixtime(t5.question_send_time / 1000, 'Asia/Shanghai'), '%Y-%m-%d')               as chat_date
           , t5.id
           , t5.send_user
           , t5.accept_user
           , t5.external_userid
           , t5.we_link_nick_name
           , t5.question
           , t5.question_send_time
           , date_format(from_unixtime(t5.question_send_time / 1000, 'Asia/Shanghai'), '%Y-%m-%d %H:%i:%s')      as question_send_datetime
           , t5.responses
           , date_format(from_unixtime(t5.response_send_time / 1000, 'Asia/Shanghai'), '%Y-%m-%d %H:%i:%s')      as response_send_datetime
           , t5.next_id
           , t5.next_question
           , date_format(from_unixtime(t5.next_question_send_time / 1000, 'Asia/Shanghai'), '%Y-%m-%d %H:%i:%s') as next_question_send_datetime
           , t5.next_responses
           , date_format(from_unixtime(t5.next_response_send_time / 1000, 'Asia/Shanghai'), '%Y-%m-%d %H:%i:%s') as next_response_send_datetime
      from (select t4.dialog_version
                 , t4.id
                 , t4.send_user
                 , t4.accept_user
                 , t4.external_userid
                 , t4.we_link_nick_name
                 , t4.question
                 , t4.question_send_time
                 , t4.responses
                 , t4.response_send_time
                 , lead(t4.id) over (partition by t4.accept_user order by t4.question_send_time) as next_id
                , lead(t4.question) over (partition by t4.accept_user order by t4.question_send_time) as next_question
                , lead(t4.question_send_time) over (partition by t4.accept_user order by t4.question_send_time) as next_question_send_time
                , lead(t4.responses) over (partition by t4.accept_user order by t4.question_send_time) as next_responses
                , lead(t4.response_send_time) over (partition by t4.accept_user order by t4.question_send_time) as next_response_send_time
            from (select t3.dialog_version
                       , t3.id
                       , t3.send_user
                       , t3.accept_user
                       , t3.external_userid
                       , t3.we_link_nick_name
                       , t3.question
                       , t3.question_send_time
                       , array_join(array_agg(t3.response), chr(10)) as responses
                       , min(t3.response_send_time)                  as response_send_time
                  from (select t1.dialog_version,
                               t1.id,
                               t1.send_user,
                               t1.accept_user,
                               t1.owner_wechat,
                               t1.we_link_nick_name,
                               t1.relate_message_id,
                               t1.external_userid,
                               t1.send_time    as question_send_time,
                               t1.send_status,
                               t1.call_back_time,
                               t1.content      as question,
                               t1.message_type as question_msg_type,
                               t2.send_time    as response_send_time,
                               t2.content      as response,
                               t2.message_type as response_msg_type,
                               ROW_NUMBER()       over (partition by t1.send_user, t1.accept_user, t1.send_time order by t2.send_time) as response_rank
                        from (select w.id,
                                     w.profile_platform_uid as                                                                                                                                                                                                send_user,
                                     w.platform_uid         as                                                                                                                                                                                                accept_user,
                                     m.owner_wechat,
                                     w.we_link_nick_name,
                                     w.send_time,
                                     lead(w.send_time)                                                                                                                                                                                                        over (partition by w.profile_platform_uid, w.platform_uid order by w.send_time) as next_send_time, w.content,
                                     w.message_type,
                                     c.user_id              as                                                                                                                                                                                                external_userid,
                                     t.send_status,
                                     t.relate_message_id,
                                     t.call_back_time,
                                     case when d.conversation_template_id in (5, 6, 7) then 1.0 when d.conversation_template_id = 12 then 1.1 when d.conversation_template_id in (8, 9, 10) then 2.0 when d.conversation_template_id = 13 then 2.5 else 0 end dialog_version
                              from (select id, profile_platform_uid, platform_uid, we_link_nick_name, send_time, direction, content, message_type, external_userid from hive2.ads.v_kudu2_stg_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link) w
                                       join (select send_user, accept_user, owner_wechat from hive2.ads.v_kudu2_stg_idc_new_t8t_mid_wec_wec_wechat_single_send_message_log group by send_user, accept_user, owner_wechat) m on m.send_user = w.profile_platform_uid and m.accept_user = w.platform_uid
                                       join (select robot_id, conversation_template_id
                                             from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record
                                             where robot_id!='13683560870'
                                             group by robot_id, conversation_template_id) d on m.owner_wechat = d.robot_id
                                       left join hive2.ads.v_kudu2_stg_mid_t8t_mid_uc_uc_user_we_link c on w.platform_uid = c.platform_uid
                                       left join (select send_user, accept_user, send_status, min(call_back_time) call_back_time, content, uuid as relate_message_id from hive2.ads.v_kudu2_stg_idc_new_t8t_mid_wec_wec_wechat_single_send_message_log group by send_user, accept_user, send_status, content, uuid) t
                                                 on t.send_user = w.profile_platform_uid and t.accept_user = w.platform_uid and t.content = w.content
                              where w.send_time >= 1691683200000
                                and w.send_time < 1694448000000
                                and w.direction = 2
                                and w.content not like '我通过了%'
                                and w.content not like '我已经添加了%'
                              order by w.profile_platform_uid, w.platform_uid, w.send_time) t1
                                 left join (select w.profile_platform_uid as send_user, w.platform_uid as accept_user, w.we_link_nick_name, w.send_time, w.content, w.message_type
                                            from (select profile_platform_uid, platform_uid, we_link_nick_name, send_time, direction, content, message_type from hive2.ads.v_kudu2_stg_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link) w
                                                     join (select send_user, accept_user from hive2.ads.v_kudu2_stg_idc_new_t8t_mid_wec_wec_wechat_single_send_message_log group by send_user, accept_user) t on t.send_user = w.profile_platform_uid and t.accept_user = w.platform_uid
                                            where w.send_time >= 1691683200000
                                              and w.send_time < 1694448000000
                                              and w.direction = 1
                                              and w.content not like '我通过了%'
                                              and w.content not like '我已经添加了%'
                                            order by w.profile_platform_uid, w.platform_uid, w.send_time) t2 on t1.send_user = t2.send_user and t1.accept_user = t2.accept_user and (t1.send_time <= t2.send_time and (t2.send_time < t1.next_send_time or t1.next_send_time is null))
                        where t1.dialog_version!=0.0) t3
                  where t3.question is not null
                    and t3.question!=''
                    and t3.response is not null
                    and t3.response!=''
                  group by t3.dialog_version, t3.id, t3.send_user, t3.accept_user, t3.external_userid, t3.we_link_nick_name, t3.question, t3.question_send_time) t4) t5) t6
order by t6.dialog_version, t6.chat_date, t6.send_user, t6.accept_user, t6.question_send_time;

select r.tag_text
from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail d
join hive2.ads.v_kudu2_stg_idc_new_t8t_nlp_fls_nlp_tag_content_record r on cast( d.id as varchar) = r.bussiness_id and r.bussiness_key='intelligentPlatform'
where d.dt='20230911' and d.check_type_code = '7!711!71102!3'
  and r.create_time>=1691683200 and r.create_time<1694448000;

--------------------------------  【用户发送消息】企微接收时间-微联接收时间
select from_unixtime(t1.send_time/1000 +8*3600) as f_send_time
, from_unixtime(t1.ctime /1000 +8*3600) as f_ctime
, (t1.ctime-t1.send_time ) as diff_time_ms
, (t1.ctime-t1.send_time )/1000 as diff_time_s
, t1.*
--select count(*)
from hive2.ads.v_kudu_stg_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link t1
where t1.scene='RECMSG' 
and t1.direction=1
and t1.ctime/1000 >= to_unixtime(cast ('2024-03-05 00:00:0' as timestamp)) - 8*3600 
and t1.ctime/1000 < to_unixtime(cast ('2024-03-06 00:00:0' as timestamp)) - 8*3600 
and t1.external_userid !=''
AND     t1.text_content  !=''
AND     t1.content NOT LIKE '%现在我们可以开始聊天了%'
AND     t1.content NOT LIKE '%现在可以开始聊天了%'
AND     t1.content NOT LIKE '%以上是打招呼内容%'
AND     t1.content NOT LIKE '%请先发送联系人验证请求%'
AND     t1.content NOT LIKE '%请求添加你为朋友%'
AND     t1.content NOT LIKE '%请求添加你为联系人%'
AND     t1.content NOT LIKE '%若不同意可拒绝存档%'
AND     t1.content NOT LIKE '%工作变更%'
AND     t1.message_type <> 10000
AND     t1.send_message_uid <> '1'
and (t1.ctime-t1.send_time )/1000>0
---



---顾问发送的文本消息
select from_unixtime(qr.create_time+8*3600) as ct,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where qr.direction =2
and qr.system_type =0
and qr.message_type =1
and qr.create_time >=to_unixtime(cast ('2024-03-10 00:00:0' as timestamp)) - 8*3600 
and qr.create_time < to_unixtime(cast ('2024-03-14 00:00:0' as timestamp)) - 8*3600 
order by id 











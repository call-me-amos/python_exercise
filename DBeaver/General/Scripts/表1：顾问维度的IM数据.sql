/** 涉及到的表清单
v_kudu_stg_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link  hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link
v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat  没有ods表
v_hive2_dwd_info_wechat        				没有ods表
v_kudu_stg_mid_t8t_mid_uc_uc_admin_information		没有ods表
v_hive_ads_shentu_public_target_summary				没有ods表
v_kudu2_stg_mid_t8t_mid_uc_uc_user_we_link  hive2.ads.v_hive2_ods_mid_t8t_mid_uc_uc_user_we_link
v_kudu2_stg_idc_new_t8t_mid_wec_wec_wechat_single_send_message_log	hive2.ads.v_hive2_ods_idc_new_t8t_mid_wec_wec_wechat_single_send_message_log
v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record	没有ods表

hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record
hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail

hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record   没有ods表


ods_mid_t8t_mid_uc_uc_user_wechat  好有关系表
ods_mid_t8t_mid_uc_uc_user_we_link  外部联和微联id映射表
ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link   微联私聊聊天记录表
ods.ods_mid_t8t_mid_uc_uc_external_contact_transfer  删微表

------------------------------------------------------------------------------------
ods_mid_t8t_mid_uc_uc_user_wechat t1
 t1.external_userid 外部联id  企微用户id
  t1.owner_wechat    微信号
  
ods.ods_mid_t8t_mid_uc_uc_user_we_link t2  外部联和微联id映射表
t2.platform_uid  微联用户id
t2.user_id   外部联idid

ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link  t3  微联私聊聊天记录表
t3.profile_custom_id   微信号
t3.platform_uid	微联用户id
t3.profile_platform_uid  微信在微联的唯一id  一般内部用于发消息用的

t1.external_userid = t2.user_id
t2.platform_uid = t3.platform_uid
t1.owner_wechat = t3.profile_custom_id
------------------------------------------------------------------------------------


*/
------------------------------------------ 报表需求 ---------------------------------------------------------------------------

@set hivevar_smart_chat_dt = '20231220'

select ${hivevar_smart_chat_dt}

----- 删除临时表
drop table if exists hive2.test.tmp_smart_chat_tb_all_wechat_relate;
drop table if exists hive2.test.tmp_smart_chat_tb_common;
drop table if exists hive2.test.tmp_smart_chat_tb_common_takeover;
drop table if exists hive2.test.tmp_smart_chat_tb_valid_takeover;
drop table if exists hive2.test.tmp_smart_chat_tb_self_exit_takeover;
drop table if exists hive2.test.tmp_smart_chat_tb_cal_message_ratio;
drop table if exists hive2.test.tmp_smart_chat_tb_cal_message_ratio_for_robot;
drop table if exists hive2.test.tmp_smart_chat_tb_self_close;
drop table if exists hive2.test.tmp_smart_chat_tb_rollback_message;
drop table if exists hive2.test.tmp_smart_chat_tb_quick_response;
drop table if exists hive2.test.tmp_smart_chat_tb_no_open_mouth;
drop table if exists hive2.test.tmp_smart_chat_tb_takeover_no_open_mouth;


----- 创建临时表  TODO
create table if not exists hive2.test.tmp_smart_chat_tb_all_wechat_relate as
(-- 全量的加微数据。 顾问企微号，顾问加粉总数，顾问总托管数
		select tb_user_wechat.add_wechat_time, tb_user_wechat.owner_wechat, tb_user_wechat.all_user, count(ccr.create_time) as all_takeover_user
		from 
		(--  全量好友关系表
			select add_wechat_time, uuw.owner_wechat ,count(uuw.external_userid) as all_user  
			from
			(
--				select getday(create_time) add_wechat_time, owner_wechat, external_userid
				select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as add_wechat_time , owner_wechat, external_userid
				from hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat 
				--
			) uuw
			group by add_wechat_time, uuw.owner_wechat 
		) as tb_user_wechat
		left join 
		(
			--select getday(create_time) create_time
			select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time
			, ccr1.robot_id 
			from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
			where ccr1.dt =${hivevar_smart_chat_dt} 
			and ccr1.robot_takeover_type =0 
			and ccr1.conversation_template_id in (13, 20, 21)
		) as ccr
			on tb_user_wechat.add_wechat_time = ccr.create_time and tb_user_wechat.owner_wechat=ccr.robot_id
		--where add_wechat_time ='20231122'  --TODO 测试
		group by tb_user_wechat.add_wechat_time, tb_user_wechat.owner_wechat, tb_user_wechat.all_user
		--order by tb_user_wechat.add_wechat_time desc
		
)
;


create table if not exists hive2.test.tmp_smart_chat_tb_common as
(		--大数据加微总表（已派数据）
			select iw.add_wechat_time, iw.assigner_name, iw.assigner_id, uai.wechat, iw.assigner_immed_boss--, iw.project_city_name, iw.project_grounded_type
			, sum(iw.match_abc_total) as match_abc_total
			, sum(iw.match_abc_total_for_assigner) as match_abc_total_for_assigner
			, sum(iw.delete_wechat_count) as delete_wechat_count
			from 
			(
					select temp1.add_wechat_time ,temp1.external_userid ,temp1.phone_id ,temp1.assigner_name ,temp1.assigner_id ,temp1.assigner_immed_boss
--					, project_city_name
--					, project_grounded_type
					,count(distinct case when temp1.match_abc_total =1 then "项目id" end)  as match_abc_total
					,count(distinct case when temp1.match_abc_total_for_assigner=1 then "项目id" end) as match_abc_total_for_assigner
					,count(distinct case when temp1.delete_wechat=1 then phone_id end) as delete_wechat_count
					from
					(
						select  (select to_unixtime(cast (getday(add_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as add_wechat_time 
						,external_userid ,phone_id ,t2."项目id" 
--						,t2."项目_城市名称" as project_city_name
--						,t2."项目_城市落地类型" as project_grounded_type
						,t1.is_delete as delete_wechat
						,t1.assigner_name assigner_name
						,t1.assigner_id 
						,t1.assigner_immed_boss assigner_immed_boss
						,case when t2."ABC可匹配项目数" = 1 then 1 else 0 end as match_abc_total
						,case when t2."需求最新可匹配人角色" = '顾问' then 1 else 0 end as match_abc_total_for_assigner
						from hive2.ads.v_hive2_dwd_info_wechat t1 
						left join hive2.ads.v_hive_ads_shentu_public_target_summary t2 on t1.phone_id = t2."电话id"
						where t1.dt =${hivevar_smart_chat_dt}
						and add_time  > 100000000 --过滤异常数据
						--and phone_id =340931489 --TODO 测试
					) as temp1
					group by add_wechat_time, external_userid ,phone_id ,assigner_name, assigner_id ,assigner_immed_boss--,project_city_name, project_grounded_type
			) as iw
			left join hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_admin_information uai on iw.assigner_id = uai.uid 
			group by iw.add_wechat_time, iw.assigner_name, iw.assigner_id, uai.wechat, iw.assigner_immed_boss--,iw.project_city_name,iw.project_grounded_type
			--order by iw.add_wechat_time desc
) ;





create table if not exists hive2.test.tmp_smart_chat_tb_common_takeover as
(--大数据加微总表--托管用户删微数
		select ccr.create_time, ccr.robot_id , count(tb_temp_common.delete_wechat_count) as takeover_delete_total
		from 
		(
			select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time, ccr1.robot_id , ccr1.uid 
			from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
			where ccr1.dt =${hivevar_smart_chat_dt} 
			and ccr1.robot_takeover_type =0 
			and ccr1.conversation_template_id in (13, 20, 21)
		) as ccr
		left join hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_admin_information uai  
			on uai.wechat = ccr.robot_id  
		left join 
		(
				select 
				add_wechat_time
				,external_userid
				,phone_id
				,assigner_name
				, assigner_id
				,assigner_immed_boss
				,count(distinct case when match_abc_total =1 then "项目id" end)  as match_abc_total
				,count(distinct case when match_abc_total_for_assigner=1 then "项目id" end) as match_abc_total_for_assigner
				,count(distinct case when delete_wechat=1 then phone_id end) as delete_wechat_count
				from
				(
					select 
					(select to_unixtime(cast (getday(add_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as add_wechat_time
					,external_userid
					,phone_id
					,t2."项目id" 
					,t1.is_delete as delete_wechat
					,t1.assigner_name assigner_name
					,t1.assigner_id 
					,t1.assigner_immed_boss assigner_immed_boss
					,case when t2."ABC可匹配项目数" = 1 then 1 else 0 end as match_abc_total
					,case when t2."需求最新可匹配人角色" = '顾问' then 1 else 0 end as match_abc_total_for_assigner
					from hive2.ads.v_hive2_dwd_info_wechat t1 
					left join hive2.ads.v_hive_ads_shentu_public_target_summary t2 on t1.phone_id = t2."电话id"
					where t1.dt =${hivevar_smart_chat_dt}
					and add_time  > 100000000
				) temp1
				group by add_wechat_time, external_userid ,phone_id ,assigner_name, assigner_id ,assigner_immed_boss
		) as tb_temp_common
		on  tb_temp_common.assigner_id = uai.uid and tb_temp_common.external_userid = ccr.uid 
		where tb_temp_common.delete_wechat_count>0
		group by ccr.create_time, ccr.robot_id 
		--order by ccr.create_time desc
)   
;





create table if not exists hive2.test.tmp_smart_chat_tb_valid_takeover as
(
		-- 有效托管数。剔除首问之前取消托管数的托管数(机器人从没发言)
		select ccr.create_time, ccr.robot_id
		, sum(case  
			when tb_fisrt_msg_create_time.fisrt_robot_msg_send_time=0 then 0
			when ccr.staff_service_time > tb_fisrt_msg_create_time.fisrt_robot_msg_send_time  then 1 else 0  end ) as valid_takeover_total
		, sum(case  
			when tb_fisrt_msg_create_time.fisrt_robot_msg_send_time=0 then 1
			when ccr.staff_service_time <= tb_fisrt_msg_create_time.fisrt_robot_msg_send_time  then 1 else 0  end ) as invalid_takeover_total
		
--		select ccr.staff_service_time 
--		, if(null = tb_fisrt_msg_create_time.fisrt_robot_msg_send_time, 0, tb_fisrt_msg_create_time.fisrt_robot_msg_send_time)
--		,(ccr.staff_service_time - if(null = tb_fisrt_msg_create_time.fisrt_robot_msg_send_time, 0, tb_fisrt_msg_create_time.fisrt_robot_msg_send_time)) as diff
--		,*
		from 
		(
			select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time
			, ccr1.robot_id 
			,ccr1.uid
			, ccr1.chat_id ,ccr1.staff_service_time 
			from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
			where ccr1.dt =${hivevar_smart_chat_dt} 
			and ccr1.robot_takeover_type =0 
			and ccr1.conversation_template_id in (13, 20, 21)
		) as ccr
		left join 
		(
			select owner_wechat, external_userid
			, if(fisrt_robot_msg_send_time is null, 0, fisrt_robot_msg_send_time/1000) as fisrt_robot_msg_send_time
			from 
			(
				select tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
				, min (tb_cwl.send_time) as fisrt_robot_msg_send_time
				--select *
				from 
				(--  全量好友关系表
					select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as add_wechat_time 
					, getday(create_time,'yyyy-MM-dd 00:00:00')
					, owner_wechat
					, external_userid
					, uuw.delete_time 
					from hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat uuw
					--order by add_wechat_time desc
				) as tb_user_wechat
				left join hive2.ads.v_hive2_ods_mid_t8t_mid_uc_uc_user_we_link as tb_uwl 
					on tb_user_wechat.external_userid = tb_uwl.user_id 
				left join 
				(--机器人发送的消息
				 	select  t.*
				 	from hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link t
				 	where t.dt =${hivevar_smart_chat_dt} 
				 	and  t.direction = 2 and t.scene='IR' --应答发送消息
				 	AND     t.content IS NOT NULL
					AND     t.content NOT LIKE '%现在我们可以开始聊天了%'
					AND     t.content NOT LIKE '%现在可以开始聊天了%'
					AND     t.content NOT LIKE '%以上是打招呼内容%'
					AND     t.message_type <> 10000
					AND     t.send_message_uid <> '1'
				 ) as tb_cwl 
					on tb_cwl.platform_uid =tb_uwl.platform_uid and tb_user_wechat.owner_wechat = tb_cwl.profile_custom_id 
--				where tb_user_wechat.owner_wechat='19146449816' and tb_user_wechat.external_userid
--				in ('wmJiIbDAAA43RLz7Tkj9xOmyBxcPPkYg')
				group by tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
			)
		) as tb_fisrt_msg_create_time
			on ccr.robot_id = tb_fisrt_msg_create_time.owner_wechat and ccr.uid = tb_fisrt_msg_create_time.external_userid 
			
		--where ccr.create_time=1701792000
--		and ccr.uid = 'wmJiIbDAAAVcF49uiZ9iijzfcALdMP2Q'
--		and ccr.robot_id = '19075699072'
		group by ccr.create_time, ccr.robot_id  
)
;






create table if not exists hive2.test.tmp_smart_chat_tb_self_exit_takeover as
(
		-- 有效托管数。剔除首问之前取消托管数的托管数(机器人从没发言)---顾问主动取消数
		select ccr.create_time, ccr.robot_id
		, count(ccr.id) as self_exit_takeover
		from 
		(
			select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time, ccr1.id 
			,ccr1.robot_id 
			,ccr1.uid 
			, ccr1.chat_id ,ccr1.staff_service_time
			from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
			where ccr1.dt =${hivevar_smart_chat_dt} 
			and ccr1.robot_takeover_type =0 
			and ccr1.conversation_template_id in (13, 20, 21)
			and ccr1.transfer_manual_reason = 1
		) as ccr
		left join 
		(
			select owner_wechat, external_userid
			, if(fisrt_robot_msg_send_time is null, 0, fisrt_robot_msg_send_time/1000) as fisrt_robot_msg_send_time
			from 
			(
				select tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
				, min (tb_cwl.send_time) as fisrt_robot_msg_send_time
				--select *
				from 
				(--  全量好友关系表
					select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as add_wechat_time 
					, getday(create_time,'yyyy-MM-dd 00:00:00')
					, owner_wechat
					, external_userid
					, uuw.delete_time 
					from hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat uuw
					--order by add_wechat_time desc
				) as tb_user_wechat
				left join hive2.ads.v_hive2_ods_mid_t8t_mid_uc_uc_user_we_link as tb_uwl 
					on tb_user_wechat.external_userid = tb_uwl.user_id 
				left join 
				(--机器人发送的消息
				 	select  t.*
				 	from hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link t
				 	where t.dt =${hivevar_smart_chat_dt} 
				 	and  t.direction = 2 and t.scene='IR' --应答发送消息
				 	AND     t.content IS NOT NULL
					AND     t.content NOT LIKE '%现在我们可以开始聊天了%'
					AND     t.content NOT LIKE '%现在可以开始聊天了%'
					AND     t.content NOT LIKE '%以上是打招呼内容%'
					AND     t.message_type <> 10000
					AND     t.send_message_uid <> '1'
				 ) as tb_cwl 
					on tb_cwl.platform_uid =tb_uwl.platform_uid and tb_user_wechat.owner_wechat = tb_cwl.profile_custom_id 
--				where tb_user_wechat.owner_wechat='19146449816' and tb_user_wechat.external_userid
--				in ('wmJiIbDAAA43RLz7Tkj9xOmyBxcPPkYg')
				group by tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
			)
		) as tb_fisrt_msg_create_time
			on ccr.robot_id = tb_fisrt_msg_create_time.owner_wechat and ccr.uid = tb_fisrt_msg_create_time.external_userid 
		where 
		tb_fisrt_msg_create_time.fisrt_robot_msg_send_time > 0
		and ccr.staff_service_time > tb_fisrt_msg_create_time.fisrt_robot_msg_send_time
		group by ccr.create_time, ccr.robot_id  
)
;



create table if not exists hive2.test.tmp_smart_chat_tb_cal_message_ratio as
(
		-- 消息渗透率：总消息数
		 select t.send_time ,b.user_id, count(b.id) as total_record
		 from 
		 (
		 	select (select to_unixtime(cast (getday(send_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) send_time, t.profile_platform_uid, t.platform_uid
		 	from hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link t
		 	where t.dt =${hivevar_smart_chat_dt} 
		 	and  t.direction = 2
		 ) as t
         join hive2.ads.v_hive2_ods_mid_t8t_mid_uc_uc_user_we_link as b 
         	on  b.dt =${hivevar_smart_chat_dt} and t.profile_platform_uid = b.platform_uid 
         join 
         (
         	select t.robot_id, t.conversation_template_id
            from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record t
            where t.dt =${hivevar_smart_chat_dt} 
            --and  t.create_time between ${hivevar_smart_chat_start_add_time} and ${hivevar_smart_chat_end_add_time}
			and t.conversation_template_id in ( 13, 20,21)
            and t.robot_takeover_type=0
            group by t.robot_id, t.conversation_template_id 
         ) c on b.user_id = c.robot_id
         join hive2.ads.v_hive2_ods_mid_t8t_mid_uc_uc_user_we_link wc on  wc.dt =${hivevar_smart_chat_dt} and t.platform_uid = wc.platform_uid 
         join 
         ( 
         	select distinct t.uid
            from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record t
            where  t.dt =${hivevar_smart_chat_dt} 
            --and  t.create_time  between ${hivevar_smart_chat_start_add_time} and ${hivevar_smart_chat_end_add_time}
			and t.conversation_template_id in ( 13, 20,21)
            and t.robot_takeover_type=0 
         ) u 
         	on u.uid = wc.user_id
		--where
		group by t.send_time ,b.user_id
)
;




create table if not exists hive2.test.tmp_smart_chat_tb_cal_message_ratio_for_robot as
(
		-- 消息渗透率：机器人消息数
		 select t.create_time ,t.owner_wechat, count(1) as robot_total_record
		 from 
		 (
		 	select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time, sml.owner_wechat ,sml.external_userid ,sml.send_status , sml.scene 
		 	from hive2.ads.v_hive2_ods_idc_new_t8t_mid_wec_wec_wechat_single_send_message_log sml
		 	where sml.dt =${hivevar_smart_chat_dt}
		 ) as t
	     join 
	     (
	     		select t.robot_id, t.conversation_template_id
	            from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record t
	            where t.dt =${hivevar_smart_chat_dt} 
				and  t.conversation_template_id in ( 13, 20,21)
	            and t.robot_takeover_type=0
	            group by t.robot_id, t.conversation_template_id 
	     ) c on t.owner_wechat = c.robot_id
	     join 
	     ( 
	     		select distinct t.uid
	            from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record t
	            where t.dt =${hivevar_smart_chat_dt} 
				and t.conversation_template_id in ( 13, 20,21)
	            and t.robot_takeover_type=0 
	      ) u on u.uid = t.external_userid
		--where 
		group by t.create_time ,t.owner_wechat
) 
;






create table if not exists hive2.test.tmp_smart_chat_tb_self_close as
(
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
						and ccr1.conversation_template_id in (13, 20, 21)
						and ccr1.deleted =0
						and ccr1.transfer_manual_reason <>1
					) as ccr
					left join hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail ccd on ccr.chat_id = ccd.chat_id 
					where ccd.dt =${hivevar_smart_chat_dt}
					and ccd.reply_time >0
					and ccd.deleted =0
					and ccd.check_type_code in ('7!711!71102!4', '7!711!71102!1', '7!711!71102!3', '7!711!71102!2', '7!711!71102!6', '7!711!71102!11')
					and ccd.role_type in (1,3)
					group by ccr.create_time, ccr.chat_id ,ccr.robot_id , ccd.check_type_code
				) as tb_self_close_temp
				where tb_self_close_temp.check_type_code in ('7!711!71102!4', '7!711!71102!1', '7!711!71102!3', '7!711!71102!2', '7!711!71102!6', '7!711!71102!11')
				group by tb_self_close_temp.create_time ,tb_self_close_temp.chat_id, tb_self_close_temp.robot_id
		) as tb_self_close_temp_2
		where tb_self_close_temp_2.self_close_slot_total =6  -- 核需到6个槽位
		group by tb_self_close_temp_2.create_time, tb_self_close_temp_2.robot_id
) 
;




create table if not exists hive2.test.tmp_smart_chat_tb_rollback_message as
(
		-- 撤回数:消息发送时间小于等于转人工时间 
		select ccr.create_time, ccr.robot_id , count(scr.id) as rollback_message_total 
		--select ccr.robot_id ,*
		from 
		(
			select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time, ccr1.robot_id , ccr1.uid ,ccr1.staff_service_time
			from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
			where ccr1.dt =${hivevar_smart_chat_dt} 
			and ccr1.robot_takeover_type =0 
			and ccr1.conversation_template_id in (13, 20, 21)
		) as ccr
		left join hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record scr on scr.wechat =ccr.robot_id and scr.toid = ccr.uid 
		where scr.revokes =1
		and scr.send_time <=ccr.staff_service_time 
		group by ccr.create_time, ccr.robot_id 
) 
;



create table if not exists hive2.test.tmp_smart_chat_tb_quick_response as
(
		select tb_tmp_quick_response_record_total.create_time, tb_tmp_quick_response_record_total.robot_id
		, count(tb_tmp_quick_response_record_total.quick_response_record_total) as quick_response_robot_total
		from 
		(
			-- 托管账号，顾问抢答:转人工之前，顾问发送的消息数（scene：IM）
			select ccr.create_time, ccr.chat_id, ccr.robot_id  , count(cwl.id) as quick_response_record_total
			from 
			(
				select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time, ccr1.robot_id , ccr1.uid ,ccr1.chat_id ,ccr1.staff_service_time
				from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
				where ccr1.dt =${hivevar_smart_chat_dt} 
				and ccr1.robot_takeover_type =0 
				and ccr1.conversation_template_id in (13, 20, 21)
			) as ccr
			left join hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link cwl
				on ccr.robot_id =cwl.profile_custom_id  and ccr.uid = cwl.external_userid 
			where cwl.dt =${hivevar_smart_chat_dt}
	        --and cwl.send_time between 1000*${hivevar_smart_chat_start_add_time} and 1000*${hivevar_smart_chat_end_add_time}
	        and cwl.scene ='IM'
	        and ccr.staff_service_time * 1000 >= cwl.send_time
	        group by ccr.create_time, ccr.chat_id, ccr.robot_id 
		) as tb_tmp_quick_response_record_total
		group by tb_tmp_quick_response_record_total.create_time,  tb_tmp_quick_response_record_total.robot_id
) 
;




create table if not exists hive2.test.tmp_smart_chat_tb_no_open_mouth as
(
		--未开口数+未开口删微数
		select tb_user_wechat.add_wechat_time
		, tb_user_wechat.owner_wechat
		--, tb_user_wechat.external_userid
		, count(1) as total_no_open_mouth
		, sum(
			case tb_user_wechat.delete_time
				when 0 then 0
				else 1
			end
		) as total_no_open_mouth_delete
		
		--select *
		from 
		(--  全量好友关系表
			select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as add_wechat_time 
			, getday(create_time,'yyyy-MM-dd 00:00:00')
			, owner_wechat
			, external_userid
			, uuw.delete_time 
			from hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat uuw
			--order by add_wechat_time desc
		) as tb_user_wechat
		left join hive2.ads.v_hive2_ods_mid_t8t_mid_uc_uc_user_we_link as tb_uwl 
			on tb_user_wechat.external_userid = tb_uwl.user_id 
		left join 
		(--用户开口了，有聊天记录
		 	select t.id
		 	, t.platform_uid
		 	, t.profile_custom_id 
--		 	, t.*
		 	from hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link t
		 	where t.dt =${hivevar_smart_chat_dt} 
		 	and  t.direction = 1
		 	AND     t.content IS NOT NULL
			AND     t.content NOT LIKE '%现在我们可以开始聊天了%'
			AND     t.content NOT LIKE '%现在可以开始聊天了%'
			AND     t.content NOT LIKE '%以上是打招呼内容%'
			AND     t.message_type <> 10000
			AND     t.send_message_uid <> '1'
			--order by send_time desc
		 ) as tb_cwl 
			on tb_cwl.platform_uid =tb_uwl.platform_uid and tb_user_wechat.owner_wechat = tb_cwl.profile_custom_id 
			
			--todo  测试数据
		where 
		tb_cwl.platform_uid is null
		group by tb_user_wechat.add_wechat_time, tb_user_wechat.owner_wechat--, tb_user_wechat.external_userid
		--order by tb_user_wechat.add_wechat_time desc
) 
;

-----------------------------------------------------------------------


create table if not exists hive2.test.tmp_smart_chat_tb_takeover_no_open_mouth as
(
		--  有效托管： 未开口数+未开口删微数
		select tb_ccr.create_time
		--, getday(cast(tb_ccr.create_time as bigint))
		, tb_ccr.robot_id 
		, count(1) as total_takeover_no_open_mouth
		, sum(
			case tb_user_wechat.delete_time
				when 0 then 0
				else 1
			end
		) as total_takeover_no_open_mouth_delete
		
		--select *
		from 
		(--托管
			select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time
			,ccr1.robot_id 
			,ccr1.uid 
			,ccr1.chat_id 
			,ccr1.staff_service_time
			--, ccr1.extend_info 
			from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
			where ccr1.dt =${hivevar_smart_chat_dt} 
			and ccr1.robot_takeover_type =0 
			and ccr1.conversation_template_id in (13, 20, 21)
		) as tb_ccr
		left join 
		( --有效托管
			select owner_wechat, external_userid
			, if(fisrt_robot_msg_send_time is null, 0, fisrt_robot_msg_send_time/1000) as fisrt_robot_msg_send_time
			from 
			(
				select tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
				, min (tb_cwl.send_time) as fisrt_robot_msg_send_time
				--select *
				from 
				(--  全量好友关系表
					select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as add_wechat_time 
					, getday(create_time,'yyyy-MM-dd 00:00:00')
					, owner_wechat
					, external_userid
					, uuw.delete_time 
					from hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat uuw
					--order by add_wechat_time desc
				) as tb_user_wechat
				left join hive2.ads.v_hive2_ods_mid_t8t_mid_uc_uc_user_we_link as tb_uwl 
					on tb_user_wechat.external_userid = tb_uwl.user_id 
				left join 
				(--机器人发送的消息
				 	select  t.*
				 	from hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link t
				 	where t.dt =${hivevar_smart_chat_dt} 
				 	and  t.direction = 2 and t.scene='IR' --应答发送消息
				 	AND     t.content IS NOT NULL
					AND     t.content NOT LIKE '%现在我们可以开始聊天了%'
					AND     t.content NOT LIKE '%现在可以开始聊天了%'
					AND     t.content NOT LIKE '%以上是打招呼内容%'
					AND     t.message_type <> 10000
					AND     t.send_message_uid <> '1'
				 ) as tb_cwl 
					on tb_cwl.platform_uid =tb_uwl.platform_uid and tb_user_wechat.owner_wechat = tb_cwl.profile_custom_id 
				group by tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
			)
		) as tb_fisrt_msg_create_time
			on tb_ccr.robot_id = tb_fisrt_msg_create_time.owner_wechat and tb_ccr.uid = tb_fisrt_msg_create_time.external_userid 
		left join 
		(--  全量好友关系表
			select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as add_wechat_time 
			, getday(create_time,'yyyy-MM-dd 00:00:00')
			, owner_wechat
			, external_userid
			, uuw.delete_time 
			from hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat uuw
			--order by add_wechat_time desc
		) as tb_user_wechat
			on tb_user_wechat.owner_wechat=tb_ccr.robot_id  and tb_user_wechat.external_userid=tb_ccr.uid
		left join hive2.ads.v_hive2_ods_mid_t8t_mid_uc_uc_user_we_link as tb_uwl 
			on tb_user_wechat.external_userid = tb_uwl.user_id 
		left join 
		(--用户开口了，有聊天记录
		 	select t.id
		 	, t.platform_uid
		 	, t.profile_custom_id 
		 	from hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link t
		 	where t.dt =${hivevar_smart_chat_dt} 
		 	and  t.direction = 1
		 	AND     t.content IS NOT NULL
			AND     t.content NOT LIKE '%现在我们可以开始聊天了%'
			AND     t.content NOT LIKE '%现在可以开始聊天了%'
			AND     t.content NOT LIKE '%以上是打招呼内容%'
			AND     t.message_type <> 10000
			AND     t.send_message_uid <> '1'
			--order by send_time desc
		 ) as tb_cwl 
			on tb_cwl.platform_uid =tb_uwl.platform_uid and tb_user_wechat.owner_wechat = tb_cwl.profile_custom_id 
--			
		where 
--		tb_ccr.create_time = 1701792000
--		and 
		tb_user_wechat.owner_wechat is not null
		and tb_cwl.platform_uid is null
		and tb_fisrt_msg_create_time.fisrt_robot_msg_send_time>0
		and tb_ccr.staff_service_time > tb_fisrt_msg_create_time.fisrt_robot_msg_send_time
--		
		--and  tb_ccr.robot_id in('18826528179')
--		and tb_ccr.uid in('wmJiIbDAAAoHCp17gs3pSGZofS1aHAkQ', 'wmJiIbDAAAuNbOtq4gmKze7_OrtuqgEw','wmJiIbDAAAVw_r880EMVgjR3-60LjyQA') 
		--and getday(tb_ccr.create_time)='20231204'
		--and tb_ccr.robot_id='18124682501'
		
		group by tb_ccr.create_time, tb_ccr.robot_id 
		--order by tb_ccr.create_time desc
		
) 
;



-- 视图名称：  v_hive_ads_smart_chat_tb_smartchat_report
drop table if exists hive2.test.tmp_smart_chat_tb_smartchat_report;

create table if not exists hive2.test.tmp_smart_chat_tb_smartchat_report as
(-- 智能应答监控报表

				select all_wechat_relate.add_wechat_time --加微时间
				--TODO 测试
				,getday(cast(all_wechat_relate.add_wechat_time as bigint)) as add_wechat_time2
				, tb_common.assigner_name --分派顾问名称
--				, tb_common.project_city_name
--				, tb_common.project_grounded_type
				, 
				case 
				when (tb_common.assigner_name is null or tb_common.assigner_name ='') then ''
				else regexp_replace(tb_common.assigner_name, '[0-9]', '')
				end as assigner_name_main      -- 分派顾问主账号，assigner_name剔除了后面的数字
				, tb_common.assigner_id
				, tb_common.wechat --顾问微信号
					, tb_common.assigner_immed_boss --直属上级
					, tb_common.match_abc_total --总abc可匹配项目数
					, tb_common.match_abc_total_for_assigner --顾问abc可匹配项目数
					, tb_common.delete_wechat_count --删微数
				, tb_common_takeover.takeover_delete_total --托管删微数
					, round(cast(tb_common_takeover.takeover_delete_total as double)/tb_valid_takeover.valid_takeover_total, 2)  as takeover_delete_total_ratio --托管删微率
				,all_wechat_relate.owner_wechat --微信账号
					, all_wechat_relate.all_user --加微数
					, all_wechat_relate.all_takeover_user --总托管数
				,tb_valid_takeover.valid_takeover_total  --有效托管数
				,tb_valid_takeover.invalid_takeover_total --无效托管数
				,tb_cal_message_ratio.total_record  --总消息数
					, tb_cal_message_ratio_for_robot.robot_total_record --托管消息数
					, round(cast(tb_cal_message_ratio_for_robot.robot_total_record as double)/tb_cal_message_ratio.total_record, 2)  as  cal_message_ratio--消息渗透率
				,tb_self_close.self_close_total --自闭环数
					, round(cast(tb_self_close.self_close_total as double)/tb_valid_takeover.valid_takeover_total, 2)  as  self_close_total_ratio --自闭环率
				,tb_self_exit_takeover.self_exit_takeover --托管主动取消数
					, round(cast(tb_self_exit_takeover.self_exit_takeover as double)/tb_valid_takeover.valid_takeover_total, 2) as self_exit_takeover_rate--托管主动取消率
				, tb_rollback_message.rollback_message_total  --消息撤回数
					, round(cast(tb_rollback_message.rollback_message_total as double)/tb_valid_takeover.valid_takeover_total, 2)  as  rollback_message_total_rate--消息撤回率
				, tb_quick_response.quick_response_robot_total --托管抢答数
					, round(cast(tb_quick_response.quick_response_robot_total as double)/tb_valid_takeover.valid_takeover_total, 2)  as  quick_response_robot_total_rate --托管抢答率
					
				,tb_no_open_mouth.total_no_open_mouth  --未开口数
				,tb_no_open_mouth.total_no_open_mouth_delete --未开口删微数
				, round(cast(tb_no_open_mouth.total_no_open_mouth_delete as double)/tb_no_open_mouth.total_no_open_mouth , 2) as no_open_mouth_delete_rate  --未开口删微率
				
				,tb_takeover_no_open_mouth.total_takeover_no_open_mouth  --托管：未开口数
				,tb_takeover_no_open_mouth.total_takeover_no_open_mouth_delete  --托管：未开口删微数
				, round(cast(tb_takeover_no_open_mouth.total_takeover_no_open_mouth_delete as double)/tb_takeover_no_open_mouth.total_takeover_no_open_mouth , 2) as takeover_no_open_mouth_rate  --托管：未开口删微率
				from 
				hive2.test.tmp_smart_chat_tb_all_wechat_relate as all_wechat_relate
				left join hive2.test.tmp_smart_chat_tb_common as tb_common
					on all_wechat_relate.add_wechat_time  = tb_common.add_wechat_time  and all_wechat_relate.owner_wechat = tb_common.wechat
				left join hive2.test.tmp_smart_chat_tb_common_takeover as tb_common_takeover
					on all_wechat_relate.add_wechat_time  = tb_common_takeover.create_time  and all_wechat_relate.owner_wechat = tb_common_takeover.robot_id
				left join hive2.test.tmp_smart_chat_tb_valid_takeover as tb_valid_takeover
					on all_wechat_relate.add_wechat_time  = tb_valid_takeover.create_time  and all_wechat_relate.owner_wechat = tb_valid_takeover.robot_id
				left join hive2.test.tmp_smart_chat_tb_self_exit_takeover as tb_self_exit_takeover
					on all_wechat_relate.add_wechat_time  = tb_self_exit_takeover.create_time  and all_wechat_relate.owner_wechat = tb_self_exit_takeover.robot_id
				left join hive2.test.tmp_smart_chat_tb_cal_message_ratio as tb_cal_message_ratio
					on all_wechat_relate.add_wechat_time  = tb_cal_message_ratio.send_time  and all_wechat_relate.owner_wechat = tb_cal_message_ratio.user_id
				left join hive2.test.tmp_smart_chat_tb_cal_message_ratio_for_robot as tb_cal_message_ratio_for_robot
					on all_wechat_relate.add_wechat_time  = tb_cal_message_ratio_for_robot.create_time  and all_wechat_relate.owner_wechat = tb_cal_message_ratio_for_robot.owner_wechat
				left join hive2.test.tmp_smart_chat_tb_self_close as tb_self_close
					on  all_wechat_relate.add_wechat_time  = tb_self_close.create_time  and all_wechat_relate.owner_wechat = tb_self_close.robot_id
				left join hive2.test.tmp_smart_chat_tb_rollback_message as tb_rollback_message
					on all_wechat_relate.add_wechat_time  = tb_rollback_message.create_time  and all_wechat_relate.owner_wechat = tb_rollback_message.robot_id
				left join hive2.test.tmp_smart_chat_tb_quick_response as 	tb_quick_response
					on all_wechat_relate.add_wechat_time  = tb_quick_response.create_time  and all_wechat_relate.owner_wechat = tb_quick_response.robot_id
				left join hive2.test.tmp_smart_chat_tb_no_open_mouth as tb_no_open_mouth
					on all_wechat_relate.add_wechat_time  = tb_no_open_mouth.add_wechat_time  and all_wechat_relate.owner_wechat = tb_no_open_mouth.owner_wechat
				left join hive2.test.tmp_smart_chat_tb_takeover_no_open_mouth as tb_takeover_no_open_mouth
					on all_wechat_relate.add_wechat_time  = tb_takeover_no_open_mouth.create_time  and all_wechat_relate.owner_wechat = tb_takeover_no_open_mouth.robot_id
				-- TODO  测试
--				where all_wechat_relate.add_wechat_time>=1701187200
					
)
;


------------------------------- ===================================================================



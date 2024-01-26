@set hivevar_smart_chat_dt = '20240122'




select * 
from 


select ccr.create_time,ccr.chat_id, ccr.robot_id,ccr.phone_id
,(case  
	when tb_fisrt_msg_create_time.fisrt_robot_msg_send_time=0 then 1
	when ccr.staff_service_time <= tb_fisrt_msg_create_time.fisrt_robot_msg_send_time  then 1 else 0  end ) as invalid_takeover_total
	, tb_fisrt_msg_create_time.fisrt_robot_msg_send_time, ccr.staff_service_time
from 
(
	select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time
	, ccr1.chat_id , ccr1.robot_id , ccr1.uid  ,ccr1.staff_service_time 
	, cast(json_extract(extend_info, '$.phone_id') as int) as phone_id
	from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
	where ccr1.dt =${hivevar_smart_chat_dt} 
	and ccr1.robot_takeover_type =0 
	and (conversation_template_id in (13, 20, 21, 26) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26))
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
		--where tb_user_wechat.owner_wechat ='19128450735' and  tb_user_wechat.external_userid ='wmJiIbDAAAFUF2oM5rJYjwsOr4WKil9w'
		group by tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
	)
	--where owner_wechat ='19128450735' and  external_userid ='wmJiIbDAAAFUF2oM5rJYjwsOr4WKil9w'
) as tb_fisrt_msg_create_time
	on ccr.robot_id = tb_fisrt_msg_create_time.owner_wechat and ccr.uid = tb_fisrt_msg_create_time.external_userid
where ccr.create_time>1704038400
and chat_id = 'MTkxMjg0NTA3MzUjd21KaUliREFBQUZVRjJvTTVySllqd3NPcjRXS2lsOXc='

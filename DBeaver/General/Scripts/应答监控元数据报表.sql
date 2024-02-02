@set hivevar_smart_chat_dt = '20240201'
select ${hivevar_smart_chat_dt}
--- 顾问有效托管信息
===================================
---------------------------------------
		-- 有效托管数。剔除首问之前取消托管数的托管数(机器人从没发言)
		select ccr.create_time ,from_unixtime(ccr.create_time+8*3600) as "会话开始时间"
		, ccr.chat_id
		, ccr.robot_id as "顾问id"
		, ccr.uid
		, ccr.phone_id as "电话id"
		,tb_fisrt_msg_create_time.fisrt_robot_msg_send_time
		, from_unixtime(tb_fisrt_msg_create_time.fisrt_robot_msg_send_time+8*3600) as "机器人发送第一句话的时间"
		, ccr.staff_service_time 
		, from_unixtime(ccr.staff_service_time+8*3600)  as "转人工时间"
		, (case  
			when tb_fisrt_msg_create_time.fisrt_robot_msg_send_time=0 then '无效'
			when ccr.staff_service_time <= tb_fisrt_msg_create_time.fisrt_robot_msg_send_time  then '无效' else '有效'  end ) as "是否有效托管"
		-- , *
		from 
		(--正常托管的用户
			select create_time
			, ccr1.robot_id 
			,ccr1.uid
			, cast(json_extract(extend_info, '$.phone_id') as int) as phone_id
			, ccr1.chat_id ,ccr1.staff_service_time 
			from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1 
			where ccr1.dt =${hivevar_smart_chat_dt} 
			and ccr1.robot_takeover_type =0 
			and ccr1.deleted =0
			and (conversation_template_id in (13, 20, 21, 26,33,35,36,37,38) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26,33,35,36,37,38))
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
					select owner_wechat
					, external_userid
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
--				where tb_user_wechat.owner_wechat='19075699974' and tb_user_wechat.external_userid
--				in ('wmJiIbDAAAdT3eixbih5fJeFjYZmd7uA')
				group by tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
			)
		) as tb_fisrt_msg_create_time
			on ccr.robot_id = tb_fisrt_msg_create_time.owner_wechat and ccr.uid = tb_fisrt_msg_create_time.external_userid 
			
			
			
		where create_time > 1706371200 and create_time <1706803200 -- TODO 就取近期的数据
		and ccr.uid = 'wmJiIbDAAA9DK-qjiQaxieS9v_HauMlQ'
		and ccr.robot_id = '19860845604'


----------------------   超时没有转人工
--select days,count(days) 
--from 
--(
	select *
	from 
	(
		SELECT  
	    (cast(to_unixtime(now()) as int) - chat_start_time )/(24*3600) as days
	    , id
	    , chat_id
	    , robot_id
	    , uid
	    , cast(json_extract(extend_info, '$.phone_id') as int) as phone_id 
	    , cd.conversation_template_id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
		where cd.robot_takeover_type =0
		and check_status = 1 
		and deleted=0 
		and chat_start_time < cast(to_unixtime(now()) as int)
		and (conversation_template_id in (13, 20, 21, 26,33,35,36,37,38) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26,33,35,36,37,38))
	) as a
	where a.days>30
	and a.conversation_template_id !=12
	
--) as b
--group by days
--order by days asc		




--------------------------  根据顾问id+用户id，查询历史聊天记录发送情况

select tb_user_wechat.owner_wechat
, tb_user_wechat.external_userid
, from_unixtime(tb_cwl.send_time/1000+8*3600) as "消息发送的时间"
, tb_cwl.scene
, tb_cwl.direction
, tb_cwl.content
from 
(--  全量好友关系表
	select owner_wechat
	, external_userid
	from hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat uuw
) as tb_user_wechat
left join hive2.ads.v_hive2_ods_mid_t8t_mid_uc_uc_user_we_link as tb_uwl 
	on tb_user_wechat.external_userid = tb_uwl.user_id 
left join 
(--机器人发送的消息
 	select  t.*
 	from hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link t
 	where t.dt =${hivevar_smart_chat_dt} 
 	--and  t.direction = 2 
 	--and t.scene='IR' --应答发送消息
 	AND     t.content IS NOT NULL
	AND     t.content NOT LIKE '%现在我们可以开始聊天了%'
	AND     t.content NOT LIKE '%现在可以开始聊天了%'
	AND     t.content NOT LIKE '%以上是打招呼内容%'
	AND     t.message_type <> 10000
	AND     t.send_message_uid <> '1'
 ) as tb_cwl 
	on tb_cwl.platform_uid =tb_uwl.platform_uid and tb_user_wechat.owner_wechat = tb_cwl.profile_custom_id 
where tb_user_wechat.owner_wechat='19065033180' 
and tb_user_wechat.external_userid in ('wmJiIbDAAAFma0q83ZhphkzZEfOhdeRA')
order by tb_cwl.send_time asc


---------  最新渗透率指标 start
    --create table if not exists tmp.tmp_smart_chat_tb_cal_message_ratio_for_robot as
    -- 消息渗透率：机器人消息数
    select t.create_time ,t.owner_wechat, count(1) as robot_total_record
    from 
    (
    select unix_timestamp(default.getday(create_time),'yyyyMMdd') as create_time, sml.owner_wechat ,sml.external_userid ,sml.send_status , sml.scene 
    from ods.ods_idc_new_t8t_mid_wec_wec_wechat_single_send_message_log sml
    where sml.dt = '${date_dt}' 
    ) as t
    join 
    (
        select distinct t.robot_id
        from ods.ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record t
        where t.dt = '${date_dt}' 
        and t.conversation_template_id in (13,20,21,26,33,35,36,37,38) or cast(GET_JSON_OBJECT(t.extend_info, '$.preTemplateId') as int) in (13,20,21,26,33,35,36,37,38))
        and t.robot_takeover_type=0 and t.robot_id not in ('13683560870','18025436210') and t.transfer_manual_reason <> 1
        group by t.robot_id
    ) c on t.owner_wechat = c.robot_id
    join 
    ( 
        select distinct t.uid
        from ods.ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record t
        where t.dt = '${date_dt}' 
        and t.conversation_template_id in (13,20,21,26,33,35,36,37,38) or cast(GET_JSON_OBJECT(t.extend_info, '$.preTemplateId') as int) in (13,20,21,26,33,35,36,37,38))
        and t.robot_takeover_type=0 and t.robot_id not in ('13683560870','18025436210') and t.transfer_manual_reason <> 1
    ) u on u.uid = t.external_userid
    group by t.create_time ,t.owner_wechat
;
-------------------------------------------------------------

--create table if not exists tmp.tmp_smart_chat_tb_guwen_response as
select t.create_time, t.robot_id
, count(t.guwen_response_record_total) as response_guwen_total
from 
(   -- 顾问发送的消息数（scene：IM）
    select ccr.create_time, ccr.chat_id, ccr.robot_id  , count(cwl.text_content) as guwen_response_record_total
    from 
    (
        select unix_timestamp(default.getday(create_time),'yyyyMMdd') as create_time, ccr1.robot_id , ccr1.uid ,ccr1.chat_id ,ccr1.staff_service_time
        from ods.ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
        where ccr1.dt = '${date_dt}'
        and ccr1.robot_takeover_type =0 and t.robot_id not in ('13683560870','18025436210') and t.transfer_manual_reason <> 1
        and (ccr1.conversation_template_id in (13,20,21,26,33,35,36,37,38) or cast(GET_JSON_OBJECT(ccr1.extend_info, '$.preTemplateId') as int) in (13,20,21,26,33,35,36,37,38))
    ) as ccr
    left join ods.ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link cwl
    on ccr.robot_id =cwl.profile_custom_id  and ccr.uid = cwl.external_userid 
    where cwl.dt = '${date_dt}'
    and cwl.scene ='IM'
    group by ccr.create_time, ccr.chat_id, ccr.robot_id 
) as t
group by t.create_time,  t.robot_id
;

-- 注：消息渗透率=(机器人消息数)/(机器人消息数+顾问发送的消息数)
---------  最新渗透率指标 end









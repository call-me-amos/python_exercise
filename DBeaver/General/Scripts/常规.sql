-- 常量设置
@set hivevar_transfer_manual_reason = (case  when cr.transfer_manual_reason=0 then '会话中' when cr.transfer_manual_reason=1 then '主动取消' when cr.transfer_manual_reason=2 then '用户开口' when cr.transfer_manual_reason=3 then '用户拉黑删除好友' when cr.transfer_manual_reason=4 then '微联回调消息失败' when cr.transfer_manual_reason=5 then '用户超时无响应' when cr.transfer_manual_reason=6 then '回复内容不识别' when cr.transfer_manual_reason=7 then '话术流程结束' when cr.transfer_manual_reason=8 then '回复非文本内容不识别' when cr.transfer_manual_reason=9 then '调用素材中心接口失败' when cr.transfer_manual_reason=10 then '二次促开口，不满足跟进条件' when cr.transfer_manual_reason=11 then '无法识别用户回复意图' when cr.transfer_manual_reason=12 then '没有匹配到问题' when cr.transfer_manual_reason=13 then '槽位值归一失败' when cr.transfer_manual_reason=14 then '没找到话术调度策略' when cr.transfer_manual_reason=15 then '话术调度策略转人工' when cr.transfer_manual_reason=16 then '查找状态策略表级联超过了10次' when cr.transfer_manual_reason=17 then '转人工意图策略' when cr.transfer_manual_reason=18 then '顾问企微账号不再使用兔小智' when cr.transfer_manual_reason=19 then '项目状态已是已获权以上' when cr.transfer_manual_reason=20 then '模型调用失败' when cr.transfer_manual_reason=21 then '促开口配置错误' when cr.transfer_manual_reason=22 then '账号取消托管' when cr.transfer_manual_reason=23 then '槽位提问超过2次' when cr.transfer_manual_reason=24 then '达到闭环条件' when cr.transfer_manual_reason=25 then '公装' when cr.transfer_manual_reason=26 then '相同话术不允许重复发' when cr.transfer_manual_reason=27 then '待发送话术对应的槽位已经有值' when cr.transfer_manual_reason=28 then '特殊意图超过阈值' when cr.transfer_manual_reason=29 then '项目状态已是已获权以上，且用户开口' when cr.transfer_manual_reason=30 then '用户未开口' when cr.transfer_manual_reason=31 then '用户二次开口' when cr.transfer_manual_reason=32 then '三个月后交房[闭环]' when cr.transfer_manual_reason=33 then '主动取消-话术流程错误' when cr.transfer_manual_reason=34 then '主动取消-话术不恰当' when cr.transfer_manual_reason=35 then '顾问主动要求' when cr.transfer_manual_reason=36 then '顾问抢答或撤回消息' when cr.transfer_manual_reason=37 then '大模型兜底内容无法识别其意图' when cr.transfer_manual_reason=38 then '大模型兜底导致相同内容超过2次' when cr.transfer_manual_reason=39 then '系统未知异常' when cr.transfer_manual_reason=40 then '暂停托管次数超过阈值' when cr.transfer_manual_reason=41 then '无人工响应' when cr.transfer_manual_reason=42 then '暂停托管跟进超时' when cr.transfer_manual_reason=43 then '在职转接删除好友' when cr.transfer_manual_reason=44 then '结束跟进' when cr.transfer_manual_reason=45 then '规则查找超过20次' when cr.transfer_manual_reason=46 then '用户填写小程序卡' when cr.transfer_manual_reason=47 then '话术存在占位符' when cr.transfer_manual_reason=48 then '计算大模型兜底意向量房时间异常' when cr.transfer_manual_reason=49 then '大模型推荐转人工' when cr.transfer_manual_reason=50 then '话术流程结束-ABC闭环' when cr.transfer_manual_reason=51 then '根据话术条件查询失败' when cr.transfer_manual_reason=52 then '话术流程结束-发完姓氏闭环' when cr.transfer_manual_reason=101 then '开启会话失败' when cr.transfer_manual_reason=102 then '获取当前槽位失败' when cr.transfer_manual_reason=103 then '静默超时转人工挂机' when cr.transfer_manual_reason=104 then '用户出现负向意图-挂机' when cr.transfer_manual_reason=105 then '用户累计2次中性意图-挂机' when cr.transfer_manual_reason=106 then '用户表达不能操作1-挂机' when cr.transfer_manual_reason=107 then '会话调度流程结束-挂机' when cr.transfer_manual_reason=108 then '找不到对应的话术策略-挂机' when cr.transfer_manual_reason=109 then '加微操作未引导成功-挂机' when cr.transfer_manual_reason=110 then '收不到短信-挂机' when cr.transfer_manual_reason=111 then '短信加微操作未引导成功-挂机' when cr.transfer_manual_reason=112 then '结束语' when cr.transfer_manual_reason=113 then '用户表达不能操作2-挂机' when cr.transfer_manual_reason=114 then '用户辱骂-挂机' when cr.transfer_manual_reason=115 then '加微操作未引导成功1-挂机' when cr.transfer_manual_reason=116 then '用户表达不能操作3-挂机' when cr.transfer_manual_reason=117 then '用户主动挂机' when cr.transfer_manual_reason=108 then '找不到素材信息-挂机' when cr.transfer_manual_reason=119 then '前置话术-联系官网类-挂机' when cr.transfer_manual_reason=120 then '已匹配结束语' when cr.transfer_manual_reason=121 then '未匹配结束语' when cr.transfer_manual_reason=122 then '结束语-已转化' when cr.transfer_manual_reason=123 then '结束语-未转化' when cr.transfer_manual_reason=124 then '后续联系-结束语' else '未知' end )  as "转人工原因"

@set hivevar_qiwei_message_type = (case when qr.message_type =1 then '文本' when qr.message_type =2 then '语音' when qr.message_type =3 then '图片' when qr.message_type =4 then '视频' when qr.message_type =5 then '名片' when qr.message_type =6 then '链接' when qr.message_type =9 then '企微表情' when qr.message_type =14 then '语音聊天' when qr.message_type =18 then '小程序' when qr.message_type =19 then '文件' when qr.message_type =251 then '引用' else '其他' end) as "企微消息类型"


select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config cc
where cc.relate_id =1042549

select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
where ra.check_type_code ='7!711!71102!604'  

-- 根据企微账号，查询erp账号
select  distinct gw.nickname,gw.wechat 
from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_acc_group_wechat gw
where 
gw.nickname like '%朱佳乐%' 



-- 根据企微账号查询顾问接粉情况
select "日期", count(*)
from 
(
	select  gw.nickname
	,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid
	,from_unixtime(cr.create_time+8*3600) as "创建时间"
	,getday(cr.create_time) as "日期"
	,from_unixtime(cr.staff_service_time +8*3600) as "转人工时间"
	,${hivevar_transfer_manual_reason} 
	,cr.*
	,gw.* 
	from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_acc_group_wechat gw
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on gw.wechat =cr.robot_id 
	where 
	--wechat in(
	--'18579087613','13554702047','13528757385','18507941973','18826567057'
	--)
	--and 
	gw.nickname like '%朱佳乐%'
	and cr.create_time >=to_unixtime(cast ('2024-05-10 00:00:0' as timestamp)) - 8*3600 
	and cr.create_time < to_unixtime(cast ('2024-06-07 00:00:0' as timestamp)) - 8*3600 
	--order by cr.create_time desc
) t
group by "日期"
order by "日期"


select *
from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
where 
dr.id in(1356211)
dr.version_no ='1731503415761'
and dr.rule_condition like '%公共策略%'
and dr.next_strategy_type  like '%ABC闭环%'


select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
where ra.check_type_code ='7!711!71102!20079'
and ra.version_no ='1730885177252'


select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config cc
where cc.relate_id =2763
order by scene , msg_type ,id

----------------------------------

-- 是否还有顾问在用老版本
select getday(cr.create_time) as getday, count(*) as ct
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where cr.deleted =0
and cr.strategy_scene =9
and cr.check_status =1
and cr.robot_takeover_type =0
group by getday(cr.create_time)
order by getday(cr.create_time) desc


select from_unixtime(cd.create_time+8*3600) as ct,cd.extend_info 
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
,from_unixtime(cd.staff_service_time +8*3600) as sst
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where 
cd.transfer_manual_reason =39
order by id desc



--  电话id查询 会话记录
select from_unixtime(cr.create_time+8*3600) as ct ,cr.extend_info 
,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid,from_unixtime(cr.staff_service_time +8*3600) as sst,cr.check_status 
,${hivevar_transfer_manual_reason} 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where
--cr.chat_id ='MTg4MjY1MTU3Njkjd21KaUliREFBQWw4S1N4SmJYUGprRGJCTWR6ZmdmOHc='
--cr.uid ='wmJiIbDAAAk5RzekJaXV87rtrCImy9UA'
cr.extend_info like '%282406839%'
order by id desc
limit 10

-------------------------
select from_unixtime(cd.create_time+8*3600) as create_time, cd.role_type 
, cd.check_type_code , sp.property_name ,cd.reply , cd.source_reply , cd.nlp_reply 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cd.chat_id =cr.chat_id 
left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
where 
cd.chat_id ='MTM0Nzk0MjY3NTQjd21KaUliREFBQVFZVGg4NFFWU0lobmwxdlF0X2ZxX3c='
and cd.deleted =0
order by cd.id desc





select from_unixtime(qr.create_time+8*3600) as ct
, from_unixtime(qr.send_time +8*3600) as "消息实际发送时间" 
,qr.text_content ,qr.user_reply_intention ,qr.user_reply_slot 
,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on qr.chat_id =cr.chat_id 
where 
--cr.extend_info like '%238610382%'
qr.chat_id ='MTkwNzYxMjM2MTMjd21KaUliREFBQVRUR3Q4VFY3eU1tZXVQaHdqQW9HSXc='
--qr.uid ='6e8097be-6032-425c-9364-ceacc3e5626b'
order by qr.id asc
;
--------------------------------------------------------------------------------------------------------------



-- 意向量房时间转人工了，后面还提取到了意向量房时间
select 
from_unixtime(cd.create_time+8*3600) as "创建时间"
,from_unixtime(cd.staff_service_time  +8*3600) as "转人工时间"
,json_extract_scalar(cd.transfer_manual_remark  , '$.askSlot') as askSlot
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
, cd.extend_info 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where cd.robot_takeover_type =0
and cd.deleted =0
and cd.strategy_scene in (9)
and cd.create_time >=to_unixtime(cast ('2024-06-25 00:00:0' as timestamp)) - 8*3600 
and cd.create_time < to_unixtime(cast ('2024-06-26 00:00:0' as timestamp)) - 8*3600 
and json_extract_scalar(cd.transfer_manual_remark  , '$.askSlot') like '%意向量房时间%'
and cd.chat_id not in (
	select chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
	where cb.chat_id =cd.chat_id and cb.behavior_status =7
)
and cd.transfer_manual_reason  !=7
and cd.chat_id in (
	select chat_id 
	from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail ccd 
	where ccd.chat_id = cd.chat_id 
	and ccd.check_type_code ='7!711!71102!6'
	and ccd.reply ='一个月内'
)

-- 查看某个槽位历史值
select cr.conversation_template_id 
,from_unixtime(cd.create_time+8*3600) as "创建时间"
,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid
,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cd.chat_id =cr.chat_id 
where cd.check_type_code ='7!711!71102!196'
and cd.reply not in ('','30~90天','90天外','30天内','是','否','已交房','未交房')
and cd.reply !=''
and cr.strategy_scene in (9)
order by cd.id desc
;

-- 查看话术配置的话术详情
select * 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config t1
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask t2 on t1.relate_id =t2.id 
where t2.relate_template_id in (57)
and t2.check_type_code ='7!711!71102!20051'


--- 聊天语料。 顾问和用户一问一答
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
		(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色",
       qr.system_type as "是否主动发送",
       qr.text_content as "消息内容",
       (
			select sp.property_name 
			from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
			left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
			where ra.id = qr.robot_ask_id  
		) as "提问槽位",
       qr.user_reply_intention as "用户回复意图",
       qr.user_reply_slot as "用户回复槽位值",
       (
       	case when 
       		qr.direction=1 and '' != regexp_extract(qr.text_content, '局部|局改|部分装')
       		then 1
       		else 0	end
       ) as "命中语料"
       ,regexp_extract(qr.text_content, '局部|局改|部分装') as "命中语料2"
       , 
		(
		case when qr.send_time > cr.staff_service_time  then '转人工后' else '转人工前' end 
		) as "转人工前后"
		,
		(
			case when exists(
				select cb.id
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
				where cb.behavior_status =7 and cb.chat_id =qr.chat_id 
				limit 1
			)  then '暂停托管' else '非暂停托管' end 
		) as "托管类型"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id = qr.chat_id and cr.chat_id is not null 
where cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.chat_id in 
(
	select distinct qr1.chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr1
	where 
	qr1.create_time >=to_unixtime(cast ('2024-12-01 00:00:0' as timestamp)) - 8*3600 
	and qr1.create_time < to_unixtime(cast ('2024-12-04 00:00:0' as timestamp)) - 8*3600 
	and qr1.direction =1
	and '' != regexp_extract(qr1.text_content, '局部|局改|部分装')
)
order by cr.chat_id asc, qr.id asc;



--- 聊天语料。 某个槽位下，用户的回复内容
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
		(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色",
       qr.system_type as "是否主动发送",
       qr.text_content as "消息内容",
       (
			select sp.property_name 
			from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
			left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
			where ra.id = qr.robot_ask_id  
		) as "提问槽位",
       qr.user_reply_intention as "用户回复意图",
       qr.user_reply_slot as "用户回复槽位值",
       (
       	case when 
       		qr.direction =2
			and qr.robot_ask_id in
			(
				select cra.id 
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
				where cra.relate_template_id =cr.conversation_template_id 
				and cra.check_type_code in (
					'7!711!71102!157'
				)
			)
       		then 1
       		else 0	end
       ) as "命中语料"
       , 
		(
		case when qr.send_time > cr.staff_service_time  then '转人工后' else '转人工前' end 
		) as "转人工前后"
		,
		(
			case when exists(
				select cb.id
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
				where cb.behavior_status =7 and cb.chat_id =qr.chat_id 
				limit 1
			)  then '暂停托管' else '非暂停托管' end 
		) as "托管类型"
		,${hivevar_transfer_manual_reason} 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id = qr.chat_id and cr.chat_id is not null 
where cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.chat_id in 
(
	select distinct qr1.chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr1
	where 
	qr1.create_time >=to_unixtime(cast ('2024-12-01 00:00:0' as timestamp)) - 8*3600 
	and qr1.create_time < to_unixtime(cast ('2024-12-10 00:00:0' as timestamp)) - 8*3600 
	and qr1.direction =2
	and qr1.robot_ask_id in
	(
		select cra.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
		where cra.relate_template_id in(47,58,65,71)--= cr.conversation_template_id 
		and cra.check_type_code in (
			'7!711!71102!157'
		)
	)
)
order by cr.chat_id asc, qr.id asc;






--- 聊天语料。 包含某个槽位
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
		(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色",
       qr.system_type as "是否主动发送",
       qr.text_content as "消息内容",
       (
			select sp.property_name 
			from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
			left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
			where ra.id = qr.robot_ask_id  
		) as "提问槽位",
       qr.user_reply_intention as "用户回复意图",
       qr.user_reply_slot as "用户回复槽位值",
       (
       	case when 
       		qr.direction =2
			and qr.robot_ask_id in
			(
				select cra.id 
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
				where cra.relate_template_id =cr.conversation_template_id 
				and cra.check_type_code in (
					'7!711!71102!157'
				)
			)
       		then 1
       		else 0	end
       ) as "命中语料"
       , 
		(
		case when qr.send_time > cr.staff_service_time  then '转人工后' else '转人工前' end 
		) as "转人工前后"
		,
		(
			case when exists(
				select cb.id
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
				where cb.behavior_status =7 and cb.chat_id =qr.chat_id 
				limit 1
			)  then '暂停托管' else '非暂停托管' end 
		) as "托管类型"
		,${hivevar_transfer_manual_reason} 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id = qr.chat_id and cr.chat_id is not null 
where cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.chat_id in 
(
	select distinct qr1.chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr1
	where 
	qr1.create_time >=to_unixtime(cast ('2024-12-01 00:00:0' as timestamp)) - 8*3600 
	and qr1.create_time < to_unixtime(cast ('2024-12-10 00:00:0' as timestamp)) - 8*3600 
	and qr1.direction =2
	and qr1.robot_ask_id in
	(
		select cra.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
		where cra.relate_template_id in(47,58,65,71)--= cr.conversation_template_id 
		and cra.check_type_code in (
			'7!711!71102!157'
		)
	)
)
order by cr.chat_id asc, qr.id asc;


-- 微联消息耗时 消息延迟
select "日期",t.message_type, t.intervalSecend as "耗时-秒",count(*) as "汇总"
from 
(
	select getday(cwl.ctime/1000) as "日期"
	, message_type 
	, (ctime -send_time)/1000 as intervalSecend
	--select *
	from hive2.ads.v_kudu_stg_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link cwl
	where cwl.ctime >=1000*(to_unixtime(cast ('2024-10-10 23:00:0' as timestamp)) - 8*3600)
	and cwl.ctime <1000*(to_unixtime(cast ('2024-10-24 00:00:0' as timestamp)) - 8*3600)
	and cwl.profile_custom_id in 
	(
	'10732163','10416912','70227341','19146467056','19168536983','13554702344','13554702141','13554701776','15361532146','13554701752','13554701247','13302315437','19076120476','13237949237','19860845604','19168533649','13554702106','19076121128','18098964084','19076199802','19065017604','19075364656','13302314503','18028709334','18038190475','18126462094','18025393154','19128456601','18124142379','13684846449','panpan.tu','10346305','19168536963','18026931270','15216262372','652638','95243','82696751','13554702042','17744967690','18924658705','19065031581','18025374141','19065037246','010450746','10412506','02194','13554701970','13554702790','13538027121','19820810964','19076127294','19075695630','17722571120','18025378466','19075697872','18124145324','13427909754','18129976274','18118784704','19075363641','19065033242','19065037545','18128858413','18126466301','13263943732','10413563','13554703502','19539046420','19065033180','18038198104','19075697422','18026938174','18124146022','18806652573','19076193023','13197821524','958972','38275061','79081421','17722570337','13530040013','15361640009','19128456739','13197941063','19811970090','19168533573','13554702612','13728810954','18038174915','18124140605','18124148095','18128857074','19076125944','18128823041','13177664329'
	)
) as t 
group by "日期",t.message_type, t.intervalSecend
--having count(*)>5
order by "日期",t.message_type, t.intervalSecend,count(*) desc
;


---- 询问槽位+回复意图+回复ner+下一槽位
select qr.chat_id,qr.id  
,cc.conversation_template_id as "模板id"
,from_unixtime(cc.create_time+8*3600) as "会话开始时间"
,json_extract_scalar(cc.extend_info , '$.phone_id') as phoneid
,qr.robot_ask_id --提问槽位
,(
	select sp.property_name 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
	left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
	where ra.id = qr.robot_ask_id 
) as "提问槽位"
,qr.next_robot_ask_ids --下一槽位
,(
	select sp.property_name 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
	left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
	where cast(ra.id as varchar) = qr.next_robot_ask_ids  
) as "下一槽位"
,qr.user_reply_intention  as "回复意图"
,qr.user_reply_slot 	as "回复槽位"
,qr.text_content 
,(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色"
,qr.system_type as "是否主动发送"
, 
(
case when qr.send_time > cc.staff_service_time  then '转人工后' else '转人工前' end 
) as "转人工前后"
,
(
	case when exists(
		select cb.id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		where cb.behavior_status =7 and cb.chat_id =qr.chat_id 
		limit 1
	)  then '暂停托管' else '非暂停托管' end 
) as "托管类型"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cc on qr.chat_id =cc.chat_id 
where cc.strategy_scene =9
and cc.robot_takeover_type =0
--and cc.conversation_template_id in (58)
and cc.create_time >=to_unixtime(cast ('2024-10-20 00:00:0' as timestamp)) - 8*3600 
and cc.create_time <to_unixtime(cast ('2024-11-05 00:00:0' as timestamp)) - 8*3600 
and qr.direction in (1, 2)
order by cc.chat_id ,qr.id asc


-- 询问槽位+槽位进入率+收集率
select cd.chat_id 
,json_extract_scalar(cc.extend_info , '$.phone_id') as phoneid
,cd.reply 
,(
	select sp.property_name 
	from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp 
	where cd.check_type_code =sp.whole_code 
) as "核需槽位"
, cd.check_type_code
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cc on cd.chat_id =cc.chat_id 
where cc.strategy_scene =9
and cc.robot_takeover_type =0
and cc.create_time >=to_unixtime(cast ('2024-10-13 00:00:0' as timestamp)) - 8*3600 
and cc.create_time <to_unixtime(cast ('2024-10-14 00:00:0' as timestamp)) - 8*3600 
and cd.reply !=''
and cd.role_type =1
order by cc.chat_id 


-- 引用功能效果分析
select from_unixtime(cr.create_time+8*3600) as ct ,cr.extend_info 
,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid,from_unixtime(cr.staff_service_time +8*3600) as sst,cr.check_status 
,${hivevar_transfer_manual_reason} 
, qr.user_final_intention as "用户意图"
, qr.create_time  as "消息发送时间"
, cr.staff_service_time as "转人工时间"
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id  = qr.chat_id 
where
--qr.create_time < cr.staff_service_time 
--and 
qr.message_type = 25
and qr.direction = 1
--and qr.user_final_intention !=''
and cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.conversation_template_id =71


--图片识别成无明显意图后 效果
select from_unixtime(cr.create_time+8*3600) as "创建时间" ,cr.extend_info 
,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid,from_unixtime(cr.staff_service_time +8*3600) as sst,cr.check_status 
,${hivevar_transfer_manual_reason} 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id  = qr.chat_id 
where
qr.create_time < cr.staff_service_time 
--and qr.message_type = 3
and qr.direction = 1
and qr.user_final_intention ='表达不耐烦'
and cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.create_time >=to_unixtime(cast ('2024-09-16 00:00:0' as timestamp)) - 8*3600 
and cr.create_time <to_unixtime(cast ('2024-11-26 00:00:0' as timestamp)) - 8*3600 
order by cr.id desc
limit 30000


---包含在外地 上线效果
select from_unixtime(cr.create_time+8*3600) as "会话开始时间" ,cr.extend_info 
,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid,from_unixtime(cr.staff_service_time +8*3600) as sst,cr.check_status 
,${hivevar_transfer_manual_reason} 
,
(
	case when exists(
		select cb.id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		where cb.behavior_status =7 and cb.chat_id =qr.chat_id 
		limit 1
	)  then '暂停托管' else '非暂停托管' end 
) as "托管类型"
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id  = qr.chat_id 
where
qr.create_time <= cr.staff_service_time 
and qr.direction = 1
and qr.user_final_intention like '%表达在外地%'
and cr.robot_takeover_type =0
and cr.conversation_template_id in (71,58)
and cr.create_time >=to_unixtime(cast ('2024-09-16 00:00:0' as timestamp)) - 8*3600 
and cr.create_time <to_unixtime(cast ('2024-10-01 00:00:0' as timestamp)) - 8*3600 


-- 拉一下上周末，出现无识别结果（引用，链接，打电话，表情包，图片、文件）的一个明细  带电话ID和转人工原因就可以
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
		(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色",
       qr.system_type as "是否主动发送",
       qr.text_content as "消息内容",
       (
			select sp.property_name 
			from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
			left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
			where ra.id = qr.robot_ask_id  
		) as "提问槽位",
       qr.user_reply_intention as "用户意图",
       qr.user_final_intention as "用户最终意图",
       qr.user_reply_slot as "用户回复槽位值",
       (
       	case when 
       		qr.direction=1 and qr.message_type in (25,6,14,9,3,19)
       		then 1
       		else 0	end
       ) as "命中语料"
       , ${hivevar_qiwei_message_type}
       , ${hivevar_transfer_manual_reason}
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id = qr.chat_id and cr.chat_id is not null 
where cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.chat_id in 
(
	select distinct qr1.chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr1
	where 
	qr1.create_time >=to_unixtime(cast ('2024-10-19 00:00:0' as timestamp)) - 8*3600 
	and qr1.create_time < to_unixtime(cast ('2024-10-21 00:00:0' as timestamp)) - 8*3600 
	and qr1.direction =1
	and qr1.message_type in (25,6,14,9,3,19)
)
order by cr.chat_id asc, qr.id asc;


/**
 * 收集槽位名:	装修时间		装修时间：三个月内
 * 进入槽位名:	装修时间-初轮	装修时间-引导
 * 
 * 先统计每个会话中，槽位是否收集，槽位是否进入；然后再汇总所有会话的槽位收集和进入
 * 
 */

select 
cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
, cr.chat_id 
, cr.conversation_template_id as "模板id"
, from_unixtime(cr.create_time+8*3600) as "会话开始时间"
, getday(cr.create_time+8*3600) as "会话开始时间-日期"
,(
	case when exists(
		select cb.id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		where cb.behavior_status =7 and cb.chat_id =cr.chat_id 
		limit 1
	)  then '暂停托管' else '正常托管' end 
) as "托管类型"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!1'
		and cd.reply ='90天内'
	) then '收集' else '未收集' end 
) as "收集-装修时间"
,(
	case when exists (
		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = cr.conversation_template_id 
			and dr.next_ask_slot = sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name in ('装修时间-初轮', '装修时间-引导')
	) then '进入' else '未进入' end 
) as "进入-装修时间"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!4'
		and cd.reply !='' --TODO 需要细分
	) then '收集' else '未收集' end 
) as "收集-房屋类型"
,(
	case when exists (
		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = cr.conversation_template_id 
			and dr.next_ask_slot = sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name in ('房屋类型')
	) then '进入' else '未进入' end 
) as "进入-房屋类型"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!8'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-工程量"
,(
	case when exists (
		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = cr.conversation_template_id 
			and dr.next_ask_slot = sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name in ('工程量')
	) then '进入' else '未进入' end 
) as "进入-工程量"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!22'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-装修用途"
,(
	case when exists (
		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = cr.conversation_template_id 
			and dr.next_ask_slot = sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name in ('装修用途')
	) then '进入' else '未进入' end 
) as "进入-装修用途"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!16'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-城市"
,(
	case when exists (
		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = cr.conversation_template_id 
			and dr.next_ask_slot = sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name in ('城市')
	) then '进入' else '未进入' end 
) as "进入-城市"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!13'
		and cd.reply ='3个月内'
	) then '收集' else '未收集' end 
) as "收集-交房时间"
,(
	case when exists (
		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = cr.conversation_template_id 
			and dr.next_ask_slot = sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name in ('交房时间')
	) then '进入' else '未进入' end 
) as "进入-交房时间"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!6'
		and cd.reply ='一个月内'
	) then '收集' else '未收集' end 
) as "收集-意向量房时间"
,(
	case when exists (
		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = cr.conversation_template_id 
			and dr.next_ask_slot = sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name in ('意向量房时间')
	) then '进入' else '未进入' end 
) as "进入-意向量房时间"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!3'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-小区名称"
,(
	case when exists (
		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = cr.conversation_template_id 
			and dr.next_ask_slot = sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name in ('小区名称', '小区地址')
	) then '进入' else '未进入' end 
) as "进入-小区名称"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!2'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-房屋面积"
,(
	case when exists (
		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = cr.conversation_template_id 
			and dr.next_ask_slot = sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name in ('房屋面积')
	) then '进入' else '未进入' end 
) as "进入-房屋面积"
------------------------------------------------------------------------------------
,(
	case when exists (
		select cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
		where cd.chat_id = cr.chat_id 
		and cd.role_type =1
		and cd.check_type_code ='7!711!71102!11'
		and cd.reply !=''
	) then '收集' else '未收集' end 
) as "收集-姓氏"
,(
	case when exists (
		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = cr.conversation_template_id 
			and dr.next_ask_slot = sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name in ('姓氏')
	) then '进入' else '未进入' end 
) as "进入-姓氏"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where 
cr.strategy_scene =9
and cr.robot_takeover_type =0
--and cc.conversation_template_id in (58)
and cr.create_time >=to_unixtime(cast ('2024-10-01 00:00:0' as timestamp)) - 8*3600 
and cr.create_time <to_unixtime(cast ('2024-10-31 00:00:0' as timestamp)) - 8*3600 

--------------------------------------------------------------
---NER 提取包含时间标签的记录
select * 
from  hive2.ads.v_hive2_ods_idc_new_t8t_nlp_fls_nlp_tag_content_record cr
where bussiness_key ='intelligentPlatform'
and cr.create_time >=to_unixtime(cast ('2024-11-01 00:00:0' as timestamp)) - 8*3600 
and cr.create_time <to_unixtime(cast ('2024-11-06 00:00:0' as timestamp)) - 8*3600 
and json_extract_scalar(JSON_EXTRACT(CR.tag_result, '$[0]'), '$.tagText') like '%时间%'
order by cr.id desc

----------------------------------------------------------------------

--- 应答问到了量房时间，完整语料，并且需要标记转人工位置
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色",
qr.system_type as "是否主动发送",
qr.text_content as "消息内容",
   (
		select sp.property_name 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where ra.id = qr.robot_ask_id  
	) as "提问槽位",
qr.user_reply_intention as "用户回复意图",
qr.user_reply_slot as "用户回复槽位值",
(
case when 
	qr.text_content = json_extract_scalar(cr.transfer_manual_remark , '$.reply')
	then 1
	else 0	end
) as "是否用户回复后转人工"
,from_unixtime(qr.send_time +8*3600) as "消息发送时间"
,(
	case when exists(
		select temp_cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail temp_cd
		where temp_cd.chat_id = cr.chat_id 
		and temp_cd.check_type_code = '7!711!71102!6'
		and temp_cd.reply ='一个月内'
		and temp_cd.role_type =1
		limit 1
	)  then '是' else '否' end 
) as "是否机器人提取到意向量房时间"
,${hivevar_transfer_manual_reason} 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id = qr.chat_id and cr.chat_id is not null 
where cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.chat_id in --机器人发送过意向量房时间槽位
(
	select distinct qr1.chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr1
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr1.robot_ask_id = ra.id 
	left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
	where 
	qr1.create_time >=to_unixtime(cast ('2024-10-10 00:00:0' as timestamp)) - 8*3600 
	and qr1.create_time < to_unixtime(cast ('2024-11-25 00:00:0' as timestamp)) - 8*3600 
	and qr1.direction =2
	and qr1.robot_ask_id >0
	and sp.property_name like '%意向量房时间%'
)
and cr.chat_id not in (-- 不包含暂停托管
		select cb.chat_id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		where cb.behavior_status =7 and cb.chat_id =qr.chat_id 
)
order by cr.chat_id asc, qr.id asc;



-- 企微表情包
select from_unixtime(qr.create_time+8*3600) as ct
,qr.direction 
,qr.system_type 
,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where qr.we_chat not in ('aiCall')
and qr.message_type in (3,9) --3-图片 9-表情包
and qr.direction =1
and qr.create_time >=to_unixtime(cast ('2024-11-21 00:00:0' as timestamp)) - 8*3600 
order by qr.id desc


-----------------------------------------
--- 语料导出：用户回复包含时间，测试大模型时间解析效果 ---
-----------------------------------------
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色",
qr.system_type as "是否主动发送",
qr.text_content as "消息内容",
   (
		select sp.property_name 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where ra.id = qr.robot_ask_id  
	) as "提问槽位",
qr.user_reply_intention as "用户回复意图",
qr.user_reply_slot as "用户回复槽位值",
(
case when 
	qr.text_content = json_extract_scalar(cr.transfer_manual_remark , '$.reply')
	then 1
	else 0	end
) as "是否用户回复后转人工"
,from_unixtime(qr.send_time +8*3600) as "消息发送时间"
,(
	case when exists(
		select temp_cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail temp_cd
		where temp_cd.chat_id = cr.chat_id 
		and temp_cd.check_type_code = '7!711!71102!6'
		and temp_cd.reply ='一个月内'
		and temp_cd.role_type =1
		limit 1
	)  then '是' else '否' end 
) as "是否机器人提取到意向量房时间"
,${hivevar_transfer_manual_reason} 
,
(
	case when exists(
		select cb.id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		where cb.behavior_status =7 and cb.chat_id =cr.chat_id 
		limit 1
	)  then '暂停托管' else '非暂停托管' end 
) as "托管类型"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id = qr.chat_id and cr.chat_id is not null 
where cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.chat_id in --机器人发送过意向量房时间槽位
(
	select distinct tcr.session_id 
	from  hive2.ads.v_hive2_ods_idc_new_t8t_nlp_fls_nlp_tag_content_record tcr
	where bussiness_key ='intelligentPlatform'
	and tcr.create_time >=to_unixtime(cast ('2024-11-01 00:00:0' as timestamp)) - 8*3600 
	and tcr.create_time <to_unixtime(cast ('2024-11-06 00:00:0' as timestamp)) - 8*3600 
	and json_extract_scalar(JSON_EXTRACT(tcr.tag_result, '$[0]'), '$.tagText') like '%时间%'
)
order by cr.chat_id asc, qr.id asc;





--- 聊天语料
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
cr.conversation_template_id as "模板id",
(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色",
qr.system_type as "是否主动发送",
qr.text_content as "消息内容",
   (
		select sp.property_name 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where ra.id = qr.robot_ask_id  
	) as "提问槽位",
qr.user_reply_intention as "用户回复意图",
qr.user_reply_slot as "用户回复槽位值",
(
case when 
	qr.text_content = json_extract_scalar(cr.transfer_manual_remark , '$.reply')
	then 1
	else 0	end
) as "是否用户回复后转人工"
,from_unixtime(qr.send_time +8*3600) as "消息发送时间"
,(
	case when exists(
		select temp_cd.id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail temp_cd
		where temp_cd.chat_id = cr.chat_id 
		and temp_cd.check_type_code = '7!711!71102!6'
		and temp_cd.reply ='一个月内'
		and temp_cd.role_type =1
		limit 1
	)  then '是' else '否' end 
) as "是否机器人提取到意向量房时间"
,${hivevar_transfer_manual_reason} 
,
(
	case when exists(
		select cb.id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		where cb.behavior_status =7 and cb.chat_id =cr.chat_id 
		limit 1
	)  then '暂停托管' else '非暂停托管' end 
) as "托管类型"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id = qr.chat_id and cr.chat_id is not null 
where cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.chat_id in --机器人发送过意向量房时间槽位
(
	select distinct cd_temp.chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd_temp
	where cd_temp.check_type_code ='7!711!71102!157'
	and cd_temp.create_time >=to_unixtime(cast ('2024-12-01 00:00:0' as timestamp)) - 8*3600 
	and cd_temp.create_time <to_unixtime(cast ('2024-12-07 00:00:0' as timestamp)) - 8*3600 
	and cd_temp.reply ='是'
	and cd_temp.role_type =1
)
order by cr.chat_id asc, qr.id asc;








--  电话id查询 会话记录
select from_unixtime(cr.create_time+8*3600) as ct ,cr.extend_info 
,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid,from_unixtime(cr.staff_service_time +8*3600) as sst,cr.check_status 
,${hivevar_transfer_manual_reason} 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where
--cr.chat_id ='MTkwNzU2OTc0MDIjd21KaUliREFBQWJVN0hOZmY2OVQ1NVcwbkZaNnpKc0E='
cr.transfer_manual_reason =4
and cr.check_status =5
	and cr.create_time >=to_unixtime(cast ('2024-11-28 00:00:0' as timestamp)) - 8*3600 
	and cr.create_time <to_unixtime(cast ('2024-11-30 00:00:0' as timestamp)) - 8*3600 
order by id desc
limit 10

--- 时间槽位，没有归一成功的
	select distinct tcr.session_id 
	, tcr.tag_result
	, tcr.*
	from  hive2.ads.v_hive2_ods_idc_new_t8t_nlp_fls_nlp_tag_content_record tcr
	where bussiness_key ='intelligentPlatform'
	and tcr.create_time >=to_unixtime(cast ('2024-12-01 00:00:0' as timestamp)) - 8*3600 
	and tcr.create_time <to_unixtime(cast ('2024-12-06 00:00:0' as timestamp)) - 8*3600 
	and json_extract_scalar(JSON_EXTRACT(tcr.tag_result, '$[0]'), '$.tagText') like '%时间%'
	and json_extract_scalar(JSON_EXTRACT(tcr.tag_result, '$[0]'), '$.tagValue') not like '%[%'


--------------------------  查询 槽位+意图的辅助资料
select *
from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp
where sp.parent_id = 
(
	select parent.id as parent_id
	from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property parent
	where parent.whole_code ='7!711!71103'
)
and sp.property_status =1
order by sp.property_name 
;



select qr.message_type 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
group by qr.message_type 
where qr.message_type =13

	
	

	
	
	





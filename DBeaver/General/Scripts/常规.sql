-- 常量设置
@set hivevar_transfer_manual_reason = (case  when cr.transfer_manual_reason=0 then '会话中' when cr.transfer_manual_reason=1 then '主动取消' when cr.transfer_manual_reason=2 then '用户开口' when cr.transfer_manual_reason=3 then '用户拉黑删除好友' when cr.transfer_manual_reason=4 then '微联回调消息失败' when cr.transfer_manual_reason=5 then '用户超时无响应' when cr.transfer_manual_reason=6 then '回复内容不识别' when cr.transfer_manual_reason=7 then '话术流程结束' when cr.transfer_manual_reason=8 then '回复非文本内容不识别' when cr.transfer_manual_reason=9 then '调用素材中心接口失败' when cr.transfer_manual_reason=10 then '二次促开口，不满足跟进条件' when cr.transfer_manual_reason=11 then '无法识别用户回复意图' when cr.transfer_manual_reason=12 then '没有匹配到问题' when cr.transfer_manual_reason=13 then '槽位值归一失败' when cr.transfer_manual_reason=14 then '没找到话术调度策略' when cr.transfer_manual_reason=15 then '话术调度策略转人工' when cr.transfer_manual_reason=16 then '查找状态策略表级联超过了10次' when cr.transfer_manual_reason=17 then '转人工意图策略' when cr.transfer_manual_reason=18 then '顾问企微账号不再使用兔小智' when cr.transfer_manual_reason=19 then '项目状态已是已获权以上' when cr.transfer_manual_reason=20 then '模型调用失败' when cr.transfer_manual_reason=21 then '促开口配置错误' when cr.transfer_manual_reason=22 then '账号取消托管' when cr.transfer_manual_reason=23 then '槽位提问超过2次' when cr.transfer_manual_reason=24 then '达到闭环条件' when cr.transfer_manual_reason=25 then '公装' when cr.transfer_manual_reason=26 then '相同话术不允许重复发' when cr.transfer_manual_reason=27 then '待发送话术对应的槽位已经有值' when cr.transfer_manual_reason=28 then '特殊意图超过阈值' when cr.transfer_manual_reason=29 then '项目状态已是已获权以上，且用户开口' when cr.transfer_manual_reason=30 then '用户未开口' when cr.transfer_manual_reason=31 then '用户二次开口' when cr.transfer_manual_reason=32 then '三个月后交房[闭环]' when cr.transfer_manual_reason=33 then '主动取消-话术流程错误' when cr.transfer_manual_reason=34 then '主动取消-话术不恰当' when cr.transfer_manual_reason=35 then '顾问主动要求' when cr.transfer_manual_reason=36 then '顾问抢答或撤回消息' when cr.transfer_manual_reason=37 then '大模型兜底内容无法识别其意图' when cr.transfer_manual_reason=38 then '大模型兜底导致相同内容超过2次' when cr.transfer_manual_reason=39 then '系统未知异常' when cr.transfer_manual_reason=40 then '暂停托管次数超过阈值' when cr.transfer_manual_reason=41 then '无人工响应' when cr.transfer_manual_reason=42 then '暂停托管跟进超时' when cr.transfer_manual_reason=43 then '在职转接删除好友' when cr.transfer_manual_reason=44 then '结束跟进' when cr.transfer_manual_reason=45 then '规则查找超过20次' when cr.transfer_manual_reason=46 then '用户填写小程序卡' when cr.transfer_manual_reason=47 then '话术存在占位符' when cr.transfer_manual_reason=48 then '计算大模型兜底意向量房时间异常' when cr.transfer_manual_reason=49 then '大模型推荐转人工' when cr.transfer_manual_reason=50 then '话术流程结束-ABC闭环' when cr.transfer_manual_reason=51 then '根据话术条件查询失败' when cr.transfer_manual_reason=52 then '话术流程结束-发完姓氏闭环' when cr.transfer_manual_reason=53 then '审核编辑后，项目状态已是已获权以上'  when cr.transfer_manual_reason=54 then '用户超长时间后开口'  when cr.transfer_manual_reason=55 then '不满足大模型兜底条件-未交房'  when cr.transfer_manual_reason=56 then '不满足大模型兜底条件-在外地'  when cr.transfer_manual_reason=57 then '触发过年期间不可约量房时间'  when cr.transfer_manual_reason=58 then '提示语返回异常'  when cr.transfer_manual_reason=59 then '已签约，转人工'  when cr.transfer_manual_reason=62 then '分派全槽位-用户超时无响应'	when cr.transfer_manual_reason=63 then '分派全槽位-大模型返回不可派'	when cr.transfer_manual_reason=64 then '分派全槽位-大模型返回核需完成'	when cr.transfer_manual_reason=65 then '分派全槽位-大模型返回其他'	when cr.transfer_manual_reason=66 then '分派全槽位-fastGPT返回包含特殊字符'	when cr.transfer_manual_reason=67 then '分派全槽位-核需中但是没有推荐话术' when cr.transfer_manual_reason=68 then '全流程-恢复托管没有获取到互动环名称' when cr.transfer_manual_reason=69 then '好友被拉黑'	when cr.transfer_manual_reason=70 then '未知大模型返回文本格式' when cr.transfer_manual_reason=71 then '未知大模型返回文本内容' when cr.transfer_manual_reason=72 then '解析大模型格式异常' when cr.transfer_manual_reason=73 then '大模型返回结果命中违规词' when cr.transfer_manual_reason=74 then '提示语返回的answer为空' when cr.transfer_manual_reason=75 then '没有符合发送的话术' when cr.transfer_manual_reason=101 then '开启会话失败' when cr.transfer_manual_reason=102 then '获取当前槽位失败' when cr.transfer_manual_reason=103 then '静默超时转人工挂机' when cr.transfer_manual_reason=104 then '用户出现负向意图-挂机' when cr.transfer_manual_reason=105 then '用户累计2次中性意图-挂机' when cr.transfer_manual_reason=106 then '用户表达不能操作1-挂机' when cr.transfer_manual_reason=107 then '会话调度流程结束-挂机' when cr.transfer_manual_reason=108 then '找不到对应的话术策略-挂机' when cr.transfer_manual_reason=109 then '加微操作未引导成功-挂机' when cr.transfer_manual_reason=110 then '收不到短信-挂机' when cr.transfer_manual_reason=111 then '短信加微操作未引导成功-挂机' when cr.transfer_manual_reason=112 then '结束语' when cr.transfer_manual_reason=113 then '用户表达不能操作2-挂机' when cr.transfer_manual_reason=114 then '用户辱骂-挂机' when cr.transfer_manual_reason=115 then '加微操作未引导成功1-挂机' when cr.transfer_manual_reason=116 then '用户表达不能操作3-挂机' when cr.transfer_manual_reason=117 then '用户主动挂机' when cr.transfer_manual_reason=108 then '找不到素材信息-挂机' when cr.transfer_manual_reason=119 then '前置话术-联系官网类-挂机' when cr.transfer_manual_reason=120 then '已匹配结束语' when cr.transfer_manual_reason=121 then '未匹配结束语' when cr.transfer_manual_reason=122 then '结束语-已转化' when cr.transfer_manual_reason=123 then '结束语-未转化' when cr.transfer_manual_reason=124 then '后续联系-结束语' else '未知' end )  as "转人工原因"
@set hivevar_qiwei_message_type = (case when qr.message_type =1 then '文本' when qr.message_type =2 then '语音' when qr.message_type =3 then '图片' when qr.message_type =4 then '视频' when qr.message_type =5 then '名片' when qr.message_type =6 then '链接' when qr.message_type =9 then '企微表情' when qr.message_type =14 then '语音聊天' when qr.message_type =18 then '小程序' when qr.message_type =19 then '文件' when qr.message_type =251 then '引用' else '其他' end) as "企微消息类型"
@set hivevar_behaviorStatus = (case when cb.behavior_status = 1 then '请求'  when cb.behavior_status = 2 then '点击'  when cb.behavior_status = 3 then '回复'  when cb.behavior_status = 4 then '点击之后回复的内容'  when cb.behavior_status = 5 then '开始托管'  when cb.behavior_status = 6 then '结束托管'  when cb.behavior_status = 7 then '暂停托管'  when cb.behavior_status = 8 then '恢复托管'  when cb.behavior_status = 9 then '顾问采纳应答策略'  when cb.behavior_status = 10 then '顾问纠错应答策略'  when cb.behavior_status = 11 then '无人工响应'  when cb.behavior_status = 12 then '引用消息'  when cb.behavior_status = 13 then '互动环开始托管'  when cb.behavior_status = 14 then '互动环结束托管' else '其他' end) as "事件类型"

-- 根据企微账号，查询erp账号
select  distinct gw.nickname,gw.wechat 
from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_acc_group_wechat gw
where 
gw.nickname like '%陈聪%' 

--  电话id查询 会话记录
	select from_unixtime(cr.create_time+8*3600) as "加微时间" 
	,cr.robot_takeover_type 
	,cr.extend_info 
	,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid,from_unixtime(cr.staff_service_time +8*3600) as "转人工时间",cr.check_status 
	,${hivevar_transfer_manual_reason} , *
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
	where
	--cr.chat_id ='MTM1NTQ3MDI0MTAjd21KaUliREFBQWlJTW44cXRSekN0OXlfdkhQeHdSM1E='
	--cr.uid ='wmJiIbDAAAE0gnN6CX4GPq3lR6C61llg'
	--cr.robot_id ='16562297954'
	json_extract_scalar(cr.extend_info  , '$.phone_id')='19077642'
	--cr.transfer_manual_reason =58 and
	--cr.robot_id ='10416912'
	--cr.strategy_scene =9
	--cr.conversation_template_id =167
	and cr.create_time >=to_unixtime(cast ('2025-10-01 00:00:0' as timestamp)) - 8*3600 
	order by id desc
	limit 10

-------------------------
select from_unixtime(cd.create_time+8*3600) as create_time,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid, cd.role_type 
, cd.check_type_code , sp.property_name ,cd.reply , cd.source_reply , cd.nlp_reply 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cd.chat_id =cr.chat_id 
left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
where 
cd.chat_id ='MTMxOTc5NDEwNjMjd21KaUliREFBQVNJeHhKYlVpRVJHa0F3UTJnbGNfT0E='
--cd.id =167796158
--cd.reply like '%称呼%'
--and cd.check_type_code ='7!711!71102!754'
and cd.deleted =0
and cr.deleted =0
and cr.create_time >=to_unixtime(cast ('2025-10-20 00:00:0' as timestamp)) - 8*3600 
order by cd.id desc
limit 100




select from_unixtime(qr.create_time+8*3600) as "消息创建时间"
--,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid
, from_unixtime(qr.send_time +8*3600) as "消息实际发送时间" 
, (qr.create_time - qr.send_time) as "消息延迟接收秒数"
,(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色"
,qr.text_content ,qr.user_reply_intention ,qr.user_reply_slot 
,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where 
--qr.uid ='wmJiIbDAAAfXcZK46mIKp8DZAv18Q2sw'
qr.chat_id ='MTY1NzEzMDg1MzIjd21KaUliREFBQVhkS0JLMTI3N2VmY3dXNFZ4X0FyRlE='
--qr.message_type =18
and qr.create_time >=to_unixtime(cast ('2025-10-09 00:00:0' as timestamp)) - 8*3600 
order by qr.id asc
limit 100
;

select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where qr.system_type =0 and qr.direction =2
and qr.answer_relate_message_id like 'WECSMG_WECCLT_%'
and qr.create_time >=to_unixtime(cast ('2025-10-20 00:00:0' as timestamp)) - 8*3600 


select from_unixtime(qr.create_time+8*3600) as ct
--,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid
, from_unixtime(qr.send_time +8*3600) as "消息实际发送时间" 
,(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色"
,qr.text_content ,qr.user_reply_intention ,qr.user_reply_slot 
--, cd.reply ,cd.source_reply ,cd.nlp_reply 
,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
--left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd on qr.chat_id =cd.chat_id 
where qr.text_content like '%具体哪天%'
and qr.create_time >=to_unixtime(cast ('2025-08-15 00:00:0' as timestamp)) - 8*3600 
limit 10


select from_unixtime(cb.create_time+8*3600) as ct,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
where cb.extend_info like '%transferManualReason%'
and cb.create_time >=to_unixtime(cast ('2025-08-15 00:00:0' as timestamp)) - 8*3600 
order by cb.id asc


select *
from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
where dr.version_no ='1747658867200'
order by dr.id 



--- 用户小程序行为
select from_unixtime(ub.create_time+8*3600) as "创建时间"
, from_unixtime(ub.event_time  +8*3600) as "消息触发时间" 
, (ub.create_time - ub.event_time) as diff_time
,json_extract_scalar(ub.change_content  , '$.newData.miniAppEventInfo.miniAppPageName')    as miniAppPageName
,json_extract_scalar(ub.change_content  , '$.newData.miniAppEventInfo.triggerEventType')    as triggerEventType
,json_extract_scalar(ub.change_content  , '$.newData.miniAppEventInfo.brainMapName')    as brainMapName
,ub.chat_id 
,ub.change_content
,*
from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_smart_chat_user_behavior ub
where ub.chat_id = 'MTA0MTIwOTUjd21KaUliREFBQVF6LUtCMF9zcFVBTWlWdW9PZXdCQUE='
and ub.page_name ='报价-权益-匹配收集2.0' 
--and ub.event_type =''
order by ub.id desc
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




--- 聊天语料。 顾问和用户一问一答  ---模板
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
       		qr.direction=1 and '' != regexp_extract(qr.text_content, '几点|什么时候来|能早一点吗|什么时候|什么时间')
       		then 1
       		else 0	end
       ) as "命中语料"
       ,regexp_extract(qr.text_content, '几点|什么时候来|能早一点吗|什么时候|什么时间') as "命中语料2"
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
	qr1.create_time >=to_unixtime(cast ('2024-11-01 00:00:0' as timestamp)) - 8*3600 
	and qr1.create_time < to_unixtime(cast ('2024-11-07 00:00:0' as timestamp)) - 8*3600 
	and qr1.direction =1
	and '' != regexp_extract(qr1.text_content, '几点|什么时候来|能早一点吗|什么时候|什么时间')
)
order by cr.chat_id asc, qr.id asc;




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
       		qr.direction=2 and '' != regexp_extract(qr.text_content, '是房子还没交房呀，还是什么原因呢|咱们现在是已经定好施工方了嘛？还是在对比了解中啊？')
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
	qr1.create_time >=to_unixtime(cast ('2024-11-01 00:00:0' as timestamp)) - 8*3600 
	and qr1.create_time < to_unixtime(cast ('2025-11-07 00:00:0' as timestamp)) - 8*3600 
	and qr1.direction =2
	and '' != regexp_extract(qr1.text_content, '是房子还没交房呀，还是什么原因呢|咱们现在是已经定好施工方了嘛？还是在对比了解中啊？')
)
order by cr.chat_id asc, qr.id asc;




--  智能应答消息渗透率
select scr.toid ,scr.fromid ,cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
,(case when scr.direction =2 then scr.toid ||'@' || scr.fromid  when scr.direction=1 then scr.fromid ||'@' ||scr.toid  else '其他' end )  as "用户@顾问"
,from_unixtime(scr.send_time +8*3600) as "消息发送时间"
,(case when scr.direction =2 then '顾问' when scr.direction=1 then '用户' else '其他' end )  as "发送角色"
,scr.message_type 
,scr.content 
,scr.object_content 
,scr.scene 
,(
	select cast(json_extract(cb.extend_info, '$.currentSlot') as varchar) as currentSlot
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
	where cb.id = cb_temp.max_id 
) as "互动环"
from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record scr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr 
	on ((case when scr.direction =2 then scr.toid ||'@' || scr.fromid  when scr.direction=1 then scr.fromid ||'@' ||scr.toid  else '其他' end ))
	=
	(cr.uid || '@' || cr.robot_id)
left join 
(-- 消息id、uid、robot_id、互动环名称
	select 
	max(cb.id) as max_id
	, cb.uid ,cb.we_chat 
	, cast(json_extract(cb.extend_info, '$.currentSlot') as varchar) as currentSlot
	, scr1.id 
	from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record scr1 
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb 
		on ((case when scr1.direction =2 then scr1.toid ||'@' || scr1.fromid  when scr1.direction=1 then scr1.fromid ||'@' ||scr1.toid  else '其他' end ))
		=
		(cb.uid || '@' || cb.we_chat)
	where cb.behavior_status =13
	and scr1.send_time  >=to_unixtime(cast ('2025-05-10 00:00:0' as timestamp)) - 8*3600 
	and cb.create_time < scr1.send_time 
	group by cb.uid ,cb.we_chat, cast(json_extract(cb.extend_info, '$.currentSlot') as varchar) ,scr1.id 
) as cb_temp on cb_temp.id= scr.id --(cb_temp.uid ||'@'|| cb_temp.we_chat) = (cr.uid || '@' || cr.robot_id)
where 
scr.send_time  >=to_unixtime(cast ('2025-05-10 00:00:0' as timestamp)) - 8*3600 
and '' != regexp_extract(cr.extend_info , 'interactiveRingNameList')
and json_array_length(json_extract(cr.extend_info, '$.interactiveRingNameList')) > 0
and cr.id is not null
--and scr.scene in ('IR')
order by "用户@顾问", scr.send_time asc
--limit 100;


--- 聊天语料。 顾问和用户一问一答
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
from_unixtime(cr.staff_service_time  +8*3600) as "转人工时间",
from_unixtime(qr.create_time  +8*3600) as "消息发送时间",
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
       		cr.transfer_manual_reason in (13,11, 14)
       		then 1
       		else 0	end
       ) as "命中语料",
       json_extract(cr.transfer_manual_remark , '$.reply') as "转人工语料",
       ${hivevar_transfer_manual_reason} 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr 
	on cr.chat_id = qr.chat_id and cr.chat_id is not null 
where cr.robot_takeover_type =0
and cr.strategy_scene =9
--and cr.transfer_manual_reason in (13,11, 14)
and qr.direction !=3
	and cr.create_time >=to_unixtime(cast ('2025-01-01 00:00:0' as timestamp)) - 8*3600 
	and cr.create_time < to_unixtime(cast ('2025-02-20 00:00:0' as timestamp)) - 8*3600 
order by cr.chat_id asc, qr.id asc;



--  正则匹配全量语料中的关键字 --全流程语料
select 
(
       	case when 
       		'' != regexp_extract(scr.content , '拉你进群') 
       		then 1
       		else 0	end
) as "命中语料"
,from_unixtime(scr.send_time +8*3600) as "消息发送时间"
,(case when scr.direction =2 then '顾问' when scr.direction=1 then '用户' else '其他' end )  as "发送角色"
,scr.message_type ,scr.content ,scr.object_content 
from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record scr
left join 
(
	select cr.toid ,cr.fromid 
	from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record cr
	where '' != regexp_extract(cr.content , '拉你进群') 
	and cr.send_time  >=to_unixtime(cast ('2025-04-01 00:00:0' as timestamp)) - 8*3600 
) t on( ( t.toid= scr.toid and t.fromid= scr.fromid ) or ( t.toid= scr.fromid and t.fromid= scr.toid ))
where 
scr.send_time  >=to_unixtime(cast ('2025-04-01 00:00:0' as timestamp)) - 8*3600 
--and scr.send_time  < to_unixtime(cast ('2025-11-07 00:00:0' as timestamp)) - 8*3600 
and 
t.toid is not null
order by scr.send_time asc;



--  正则匹配全量语料中的关键字--全流程语料
select scr.toid ,scr.fromid 
,(case when scr.direction =2 then scr.toid ||'@' || scr.fromid  when scr.direction=1 then scr.fromid ||'@' ||scr.toid  else '其他' end )  as "用户@顾问"
,(
       	case when 
       		'' != regexp_extract(scr.content , '最后一句话如果是提示语') 
       		then 1
       		else 0	end
) as "命中语料"
,from_unixtime(scr.send_time +8*3600) as "消息发送时间"
,(case when scr.direction =2 then '顾问' when scr.direction=1 then '用户' else '其他' end )  as "发送角色"
,scr.message_type ,scr.content ,scr.object_content 
from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record scr
left join 
(
	select 
	cr.toid ,cr.fromid 
	--*
	from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record cr
	where cr.direction=2 --顾问说的
	and '' != regexp_extract(cr.content , '最后一句话如果是提示语') 
	and cr.send_time  >=to_unixtime(cast ('2025-03-01 00:00:0' as timestamp)) - 8*3600 
) t on( ( t.toid= scr.toid and t.fromid= scr.fromid ) or ( t.toid= scr.fromid and t.fromid= scr.toid ))
where 
scr.send_time  >=to_unixtime(cast ('2025-04-07 00:00:0' as timestamp)) - 8*3600 
--and scr.send_time  < to_unixtime(cast ('2025-11-07 00:00:0' as timestamp)) - 8*3600 
and 
t.toid is not null
order by "用户@顾问", scr.send_time asc;



--  销冠语料
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
		(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色",
       qr.text_content as "消息内容"
       ,from_unixtime(qr.send_time  +8*3600) as "消息发送时间"
       ,qr.id 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr 
	on cr.chat_id = qr.chat_id and cr.chat_id is not null 
left join 
(
	select distinct qr_temp.chat_id  
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr_temp
	where  qr_temp.direction =2 and qr_temp .system_type =1
	and qr_temp.create_time >=to_unixtime(cast ('2025-02-01 00:00:0' as timestamp)) - 8*3600 
) qr1 on qr1.chat_id = cr.chat_id 
left join  hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_contact co  on co.phone_id = cast(json_extract(cr.extend_info, '$.phone_id') as integer)
inner join hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_project p on co.id  = p.con_id 
inner join hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_demand cd on p.proj_id  = cd.proj_id 
inner join hive2.ads.v_kudu_stg_to8to_to8to_to8to_yuyue_apply_fp fp on cd.dem_id  = fp.yid 
where cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.create_time >=to_unixtime(cast ('2025-02-01 00:00:0' as timestamp)) - 8*3600 
and qr1.chat_id is null
and cr.robot_id in 
(
	'19065015413','19075697422','19146483662','16562298406','18002569934','13554701787','16562297954','19811970735','13554702790','595443','13554701564','13155899102','18924658705','18025374141','95243','19811970205','24460470','18665347660','16562296417','13509682240','15946933592','19075364656','19128456601','19065037054','19860845954','13197821524','18675541506','18128823041','13647047598','19168533649','19820810743','18025378466','18165747834','15216262372','13728810954','79082174','13177674642','085472','13479426754','19075697872','19820811461','13554701574','17722578189','19168533575','18124142379','13263943732','18124142507','18806651721','10412506','82650967','19860845604','18813863425','17061707946'
)
and qr.text_content is not null
order by cr.chat_id asc, qr.id asc;



select *
from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record cr
where cr.content like '%具体时间定在%'






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



--- 聊天语料。 策略转人工”前的用户最后一句话 表达意图
select 
from_unixtime(cd.create_time+8*3600) as "创建时间"
,from_unixtime(cd.staff_service_time  +8*3600) as "转人工时间"
,cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
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
	select distinct crr.chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record crr
	where 
	crr.create_time >=to_unixtime(cast ('2024-12-10 00:00:0' as timestamp)) - 8*3600 
	and crr.create_time < to_unixtime(cast ('2024-12-21 00:00:0' as timestamp)) - 8*3600 
	and crr.transfer_manual_reason in (14,15)
	
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

--- ===========================================================================
--- ===========================================================================
--- ===========================================================================
--- ===========================================================================

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

and cr.create_time >=to_unixtime(cast ('2025-07-31 00:00:0' as timestamp)) - 8*3600 
and cr.create_time <to_unixtime(cast ('2025-07-31 12:00:0' as timestamp)) - 8*3600 
 

--- 全流程 进入率和收集率
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
		and sp.property_name ='全流程-提问队列'
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
		and sp.property_name ='全流程-提问队列'
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
		and sp.property_name ='全流程-提问队列'
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
		and sp.property_name ='全流程-提问队列'
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
		and sp.property_name ='全流程-提问队列'
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
		and sp.property_name ='全流程-提问队列'
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
		and sp.property_name ='全流程-提问队列'
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
		and sp.property_name ='全流程-提问队列'
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
		and sp.property_name ='全流程-提问队列'
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
		and sp.property_name ='全流程-提问队列'
		and cd.reply like '%姓氏%'
	) then '进入' else '未进入' end 
) as "进入-姓氏"
from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where  cr.deleted =0 and cr.robot_takeover_type =0 and cr.strategy_scene =9
and '' != regexp_extract(cr.extend_info , 'interactiveRingNameList')
and json_array_length(json_extract(cr.extend_info, '$.interactiveRingNameList')) > 0
and cr.transfer_manual_reason not in (19,29,53)
and cr.robot_id != '18576473328'

and cr.create_time >=to_unixtime(cast ('2025-07-31 00:00:0' as timestamp)) - 8*3600 
and cr.create_time <to_unixtime(cast ('2025-07-31 12:00:0' as timestamp)) - 8*3600 



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





--- 聊天语料  是否在外地=是
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
from_unixtime(cr.create_time+8*3600) as "创建时间" ,
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
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr_temp on cd_temp.chat_id  = cr_temp.chat_id  
	where  cd_temp.check_type_code ='7!711!71102!157' -- 是否在外地
	and cr_temp.create_time >=to_unixtime(cast ('2024-12-01 00:00:0' as timestamp)) - 8*3600 
	and cr_temp.create_time <to_unixtime(cast ('2024-12-16 00:00:0' as timestamp)) - 8*3600 
	and cd_temp.reply ='是'
	and cd_temp.role_type =1
)
order by cr.chat_id asc, qr.id asc;



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





	
--  大模型兜底意向量房时间槽位 
select from_unixtime(cr.create_time+8*3600) as "加微时间" 
,(
	case when exists(
		select cr1.chat_id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr1
		where json_extract_scalar(cr1.extend_info  , '$.llmForMeasurementForBottomUpIsOver')='true'
		and cr1.chat_id = cr.chat_id 
		limit 1
	)  then '大模型获取到量房时间'
	when exists(
		select cr1.chat_id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr1
		where json_extract_scalar(cr1.extend_info  , '$.llmForMeasurementForBottomUpStarted')='true'
		and cr1.chat_id = cr.chat_id 
		limit 1
	)  then '大模型推荐了话术' 
	else '大模型未推荐话术转人工' end 
)  as "大模型推荐类型"
,cr.extend_info 
,json_extract_scalar(cr.extend_info , '$.phone_id') as "电话id"
,cr.check_status 
, cr.chat_id 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where
cr.create_time >=to_unixtime(cast ('2025-01-06 22:00:0' as timestamp)) - 8*3600 
and cr.chat_id in 
(
	(	-- 大模型推荐转人工
		select cr1.chat_id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr1
		where cr1.transfer_manual_reason in (28, 38, 48, 49, 55, 56)
		and cr1.create_time >=to_unixtime(cast ('2025-01-06 23:00:0' as timestamp)) - 8*3600 
	)
	union 
	(	-- 推荐过话术
		select cr1.chat_id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr1
		where json_extract_scalar(cr1.extend_info  , '$.llmForMeasurementForBottomUpStarted')='true'
		and cr1.create_time >=to_unixtime(cast ('2025-01-06 23:00:0' as timestamp)) - 8*3600 
	)
)
order by id desc
limit 10
	




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
		where qr.chat_id = 'MTgxMjQxNDI5Nzcjd21KaUliREFBQXJEbXRodVJzRm9DMWJFTTZtVlFNcVE='--cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name like '意向量房时间%'
		and 
	) then '进入' else '未进入' end 
) as "进入-意向量房时间"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where 
cr.strategy_scene =9
and cr.robot_takeover_type =0
--and cc.conversation_template_id in (58)
and cr.create_time >=to_unixtime(cast ('2025-01-01 00:00:0' as timestamp)) - 8*3600 
and cr.create_time <to_unixtime(cast ('2025-01-10 00:00:0' as timestamp)) - 8*3600 






		select qr.id 
		,(
			select if(dr.rule_condition like '%skipSlot%', split(dr.rule_condition, '''')[2], '无跳过槽位') as slotName
			from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
			where dr.template_id = 47--cr.conversation_template_id 
			and dr.next_ask_slot ='意向量房时间-首问'-- sp.property_name 
		) as skipSlot --跳过槽位(脑图二级节点名)
		, *
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra on qr.robot_ask_id = ra.id 
		left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on ra.check_type_code =sp.whole_code 
		where qr.chat_id = 'MTgxMjQxNDI5Nzcjd21KaUliREFBQXJEbXRodVJzRm9DMWJFTTZtVlFNcVE='--cr.chat_id 
		and qr.direction =2
		and qr.system_type = 1
		and qr.robot_ask_id >0
		and sp.property_name like '%意向量房时间%'

;









--- 标注页面 微信应答查询页面 case分析系统
select distinct cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
, cr.create_time as "会话时间"
-- 负责人 加微方式
,(
	case when exists(
			select qr_temp .chat_id 
			from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr_temp
			where qr_temp.chat_id = 
			--'MTMxNzc2NzQ2NDIjd21KaUliREFBQUF2WE5OZ014NWFydl9INW1FYmh6a3c='
			cr.chat_id 
			and qr_temp .direction =2
			and qr_temp .system_type = 1
			and qr_temp .answer_relate_message_id like 'WECSMG_IR%'
			limit 1
	) then '有效托管' else '无效托管' end
) as "是否有效托管"
, (
			case when exists(
				select cb.id
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
				where cb.behavior_status =7 and cb.chat_id =qr.chat_id 
				limit 1
			)  then '暂停托管' else '正常托管' end 
		) as "托管状态"
,${hivevar_transfer_manual_reason} 
,cr.staff_service_time as "转人工时间"
, (
	select sp.property_name 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd_temp
	left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd_temp .check_type_code =sp.whole_code 
	where cd_temp .chat_id =
	--'MTMxNzc2NzQ2NDIjd21KaUliREFBQUF2WE5OZ014NWFydl9INW1FYmh6a3c='
	cr.chat_id 
	and cd_temp .id = cast(json_extract(cr.transfer_manual_remark , '$.conversationDetailId') as integer)
) as "转人工槽位"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id = qr.chat_id and cr.chat_id is not null 
where cr.robot_takeover_type =0 --正常托管
and cr.strategy_scene =9 --应答模式
-- 会话筛选条件--槽位
and cr.chat_id in (
	select cd.chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
	left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
	where cd.chat_id =
	--'MTMxNzc2NzQ2NDIjd21KaUliREFBQUF2WE5OZ014NWFydl9INW1FYmh6a3c='
	cr.chat_id
	and sp.property_name ='装修时间-初轮'
)
-- 会话筛选条件--意图
and cr.chat_id in (
	select qr_where .chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr_where
	where qr_where .chat_id = 
	--'MTMxNzc2NzQ2NDIjd21KaUliREFBQUF2WE5OZ014NWFydl9INW1FYmh6a3c='
	cr.chat_id
	and qr_where .user_reply_intention like '%肯定回答%'
)
--
and cr.create_time >=to_unixtime(cast ('2025-03-03 00:00:0' as timestamp)) - 8*3600 
and cr.create_time < to_unixtime(cast ('2025-03-04 00:00:0' as timestamp)) - 8*3600 






--- 并发语料 用户发送消息每条间隔时间60秒内的语料
SELECT 
	phone_id,
    chat_id,
    uid,
    prev_create_time AS "前一条消息时间",
    create_time AS "当前消息时间",
    (create_time - prev_create_time) / 1000 AS "间隔秒数",
    text_content AS "消息内容"
FROM 
(
    SELECT 
    	cast(json_extract(cr.extend_info, '$.phone_id') as integer) as phone_id,
        qr.chat_id,
        qr.uid,
        qr.create_time ,
        LAG(qr.create_time) OVER (
            PARTITION BY qr.chat_id, qr.uid 
            ORDER BY qr.create_time
        ) AS prev_create_time,
        qr.text_content
    FROM hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
    left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on qr.chat_id=cr.chat_id
    WHERE qr.direction = 1  -- 用户发送的消息
    and qr.system_type =0    
    and qr.create_time >=to_unixtime(cast ('2025-03-03 00:00:0' as timestamp)) - 8*3600 
	and qr.create_time < to_unixtime(cast ('2025-03-04 00:00:0' as timestamp)) - 8*3600 
) t1
WHERE 
    prev_create_time IS NOT NULL
    AND (create_time - prev_create_time) <= 30000  -- 60秒间隔判断
ORDER BY phone_id, chat_id, uid, create_time






select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where qr.id=117027335

select *
from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
where dr.id =1837614

-- 删微埋点：  sql开发
--	1、查看删微的大槽位
select 
cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
,from_unixtime(cr.create_time+8*3600) as "会话时间"
,qr_temp.qr_id
,qr_rule_temp.rule_id
, dr.next_ask_slot as "删微大槽位"
,(
	case when exists(
			select qr_temp .chat_id 
			from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr_temp
			where qr_temp.chat_id = 
			--'MTMxNzc2NzQ2NDIjd21KaUliREFBQUF2WE5OZ014NWFydl9INW1FYmh6a3c='
			cr.chat_id 
			and qr_temp .direction =2
			and qr_temp .system_type = 1
			and qr_temp .answer_relate_message_id like 'WECSMG_IR%'
			limit 1
	) then '有效托管' else '无效托管' end
) as "是否有效托管"
, (
			case when exists(
				select cb.id
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
				where cb.behavior_status =7 and cb.chat_id =cr.chat_id 
				limit 1
			)  then '暂停托管' else '正常托管' end 
		) as "托管状态"
from  hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join (
		select qr.chat_id  
		, max(qr.id) as qr_id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr 
		where qr.rule_ids !=''
		and qr.direction =2
		and qr.system_type=1
		group by qr.chat_id
) qr_temp on qr_temp.chat_id = cr.chat_id 
left join 
(
	select qr.id
	,cast(split(qr.rule_ids, ',')[CARDINALITY(split(qr.rule_ids, ','))] as integer) as rule_id
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr 
	where qr.rule_ids !=''
	and qr.direction =2
	and qr.system_type=1
) qr_rule_temp on qr_temp.qr_id=  qr_rule_temp.id
left join hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr on qr_rule_temp.rule_id=dr.id 
where cr.transfer_manual_reason =3
and cr.robot_takeover_type =0
and cr.create_time >=to_unixtime(cast ('2025-02-20 00:00:0' as timestamp)) - 8*3600  


--	2、删微前激活次数
select 
cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
,from_unixtime(cr.create_time+8*3600) as "会话时间"
,temp_count.total_qr as "删微前激活次数"
from  hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join (
	-- 用户说的最后一句话之后，机器人说的话：包含1~2条核需话术和激活话术
	select qr.chat_id,-- qr_temp.qr_id,qr.id
	count(qr.chat_id) as total_qr
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr 
	left join (
		-- 用户说的最后一句话
		select qr.chat_id  
		, max(qr.id) as qr_id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr 
		where qr.rule_ids !=''
		and qr.direction =1
		and qr.system_type=0
		--and qr.chat_id ='MTMxMjUyNDU2NzEjd21KaUliREFBQTZFTnRmYk9QZ2tqcy04LUJNX3lVSkE='
		group by qr.chat_id
	) qr_temp on qr.chat_id=qr_temp.chat_id
	where 
	(qr_temp.qr_id < qr.id or qr_temp.chat_id is null)
	and qr.answer_relate_message_id like 'WECSMG_IR%'
	--and qr.chat_id ='MTMxMjUyNDU2NzEjd21KaUliREFBQTZFTnRmYk9QZ2tqcy04LUJNX3lVSkE='
	group by qr.chat_id
) temp_count on cr.chat_id =temp_count.chat_id
where cr.transfer_manual_reason =3
and cr.robot_takeover_type =0
and cr.create_time >=to_unixtime(cast ('2025-02-20 00:00:0' as timestamp)) - 8*3600 




--	3、删微前激活时长
select 
cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
,from_unixtime(cr.create_time+8*3600) as "会话时间"
,from_unixtime(cr.staff_service_time +8*3600) as "转人工时间时间"
,temp_count.total_qr as "删微前激活次数"
,from_unixtime(temp_count.min_create_time +8*3600)  as "开始时间"
,from_unixtime(temp_count.max_create_time +8*3600)  as "结束时间"
from  hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join (
	-- 用户说的最后一句话之后，机器人说的话：包含1~2条核需话术和激活话术
	select qr.chat_id,-- qr_temp.qr_id,qr.id
	count(qr.chat_id) as total_qr,
	min(qr.create_time) as min_create_time,
	max(qr.create_time) as max_create_time
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr 
	left join (
		-- 用户说的最后一句话
		select qr.chat_id  
		, max(qr.id) as qr_id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr 
		where qr.rule_ids !=''
		and qr.direction =1
		and qr.system_type=0
		--and qr.chat_id ='MTMxMjUyNDU2NzEjd21KaUliREFBQTZFTnRmYk9QZ2tqcy04LUJNX3lVSkE='
		group by qr.chat_id
	) qr_temp on qr.chat_id=qr_temp.chat_id
	where 
	(qr_temp.qr_id < qr.id or qr_temp.chat_id is null)
	and qr.answer_relate_message_id like 'WECSMG_IR%'
	--and qr.chat_id ='MTMxMjUyNDU2NzEjd21KaUliREFBQTZFTnRmYk9QZ2tqcy04LUJNX3lVSkE='
	group by qr.chat_id
) temp_count on cr.chat_id =temp_count.chat_id
where cr.transfer_manual_reason =3
and cr.robot_takeover_type =0
and cr.create_time >=to_unixtime(cast ('2025-02-20 00:00:0' as timestamp)) - 8*3600 










SELECT cd.`chat_id` AS chatId, 
MIN(cr.uid) AS uid,
MIN(CASE WHEN cd.check_type_code='7!711!71102!11' THEN cd.reply END) AS lastName,
MIN(CASE WHEN cd.check_type_code='7!711!71102!11' THEN cd.source_reply END) AS lastName_source_reply,
MIN(CASE WHEN cd.check_type_code='7!711!71102!16' THEN cd.reply END) AS city,
MIN(CASE WHEN cd.check_type_code='7!711!71102!16' THEN cd.source_reply END) AS city_source_reply,
MIN(CASE WHEN cd.check_type_code='7!711!71102!10' THEN cd.reply END) AS town,
MIN(CASE WHEN cd.check_type_code='7!711!71102!10' THEN cd.source_reply END) AS town_source_reply,
MIN(CASE WHEN cd.check_type_code='7!711!71102!3' THEN cd.reply END) AS address,
MIN(CASE WHEN cd.check_type_code='7!711!71102!3' THEN cd.source_reply END) AS address_source_reply,
MIN(CASE WHEN cd.check_type_code='7!711!71102!2' THEN cd.reply END) AS areaValue,
MIN(CASE WHEN cd.check_type_code='7!711!71102!2' THEN cd.source_reply END) AS area_source_reply,
MIN(CASE WHEN cd.check_type_code='7!711!71102!4' THEN cd.reply END) AS houseType,
MIN(CASE WHEN cd.check_type_code='7!711!71102!4' THEN cd.source_reply END) AS houseType_source_reply,
MIN(CASE WHEN cd.check_type_code='7!711!71102!13' THEN cd.reply END) AS completionDate,
MIN(CASE WHEN cd.check_type_code='7!711!71102!13' THEN cd.source_reply END) AS completionDate_source_reply,
MIN(CASE WHEN cd.check_type_code='7!711!71102!1' THEN cd.reply END) AS decoTime,
MIN(CASE WHEN cd.check_type_code='7!711!71102!1' THEN cd.source_reply END) AS decoTime_source_reply,
MIN(CASE WHEN cd.check_type_code='7!711!71102!6' THEN cd.reply END) AS measurementTime,
MIN(CASE WHEN cd.check_type_code='7!711!71102!6' THEN cd.source_reply END) AS measurementTime_source_reply
FROM tls_smart_chat_conversation_record cr
LEFT JOIN tls_smart_chat_conversation_detail cd ON cr.`chat_id`= cd.`chat_id`
WHERE 
cr.`robot_id`='tongzhiwei'
#and cr.`uid` = 30113407
GROUP BY cd.`chat_id`





-- 全流程接粉/开粉情况
select 
cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
,from_unixtime(cr.create_time+8*3600) as "会话时间"
,from_unixtime(cr.staff_service_time +8*3600) as "转人工时间时间"
,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where cr.deleted =0 and cr.robot_takeover_type =0 and cr.strategy_scene =9
and '' != regexp_extract(cr.extend_info , 'interactiveRingNameList')
and json_array_length(json_extract(cr.extend_info, '$.interactiveRingNameList')) > 0
and cr.create_time >=to_unixtime(cast ('2025-03-20 00:00:0' as timestamp)) - 8*3600 
order by cr.create_time desc

;
--- 根据辅助资料名称，查询级联关系
select t1.property_name ,t2_temp.property_name, t3_temp.property_name, t3_temp.description
from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property t1
left join  
(
	select t2.id, t2.parent_id ,t2.property_name
	from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property t2
) t2_temp on t2_temp.parent_id=t1.id
left join 
(
	select t3.parent_id ,t3.property_name, t3.description
	from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property t3
	where 
	t3.description like '%round%'
	--t3.property_name  like 'round'
	--t3.whole_code like '%17007092%'
) t3_temp on t3_temp.parent_id = t2_temp.id
where t3_temp.property_name is not null;

select *
from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp
where sp.whole_code ='5!504!50416!121'
;





-- 统计每个用户接了多少互动环
select 
cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
,cr.chat_id 
,cr.conversation_template_id as "机器人模版id"
, cr.robot_id as "企微id"
,from_unixtime(cr.create_time+8*3600) as "托管时间"
, 
(
	select sp.property_name 
	from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp
	where sp.whole_code =cr.ask_slot 
) as "托管环节"
,from_unixtime(cr.staff_service_time +8*3600) as "转人工时间时间"
, ${hivevar_transfer_manual_reason}
, ${hivevar_behaviorStatus}
,from_unixtime(cb.create_time+8*3600) as "事件触发时间"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cb.chat_id =cr.chat_id 
where cr.robot_takeover_type =0
and cr.strategy_scene =9
and cr.deleted =0
and cr.create_time >=to_unixtime(cast ('2025-01-01 00:00:0' as timestamp)) - 8*3600 
and '' != regexp_extract(cr.extend_info , 'interactiveRingNameList')
and json_array_length(json_extract(cr.extend_info, '$.interactiveRingNameList')) > 0
order by cb.chat_id , cb.id  



;


select *
from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp
where 
sp.whole_code ='7!711!71102!807'
sp.parent_id =16031
and sp.description like 'round%'
order by sp.id  asc

select *
from hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_diy_rule dr
where dr.version_no ='1747916372316'
and dr.rule_describe like '%小程序事件-赠送【审核报价】权益%'
;


select * 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config cc
where cc.id=1237525;


select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
where ra.id =105992

select *
from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp
where sp.whole_code ='7!711!71102!804'

select from_unixtime(qr.create_time+8*3600) as ct,* from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where qr.message_type =18
order by qr.id desc
limit 200

;


-- 统计每个用户接了多少互动环，进入互动环和退出互动环时间 
select "电话id",chat_id,"机器人模版id","企微id","负责人","托管时间","托管环节","转人工时间时间","转人工原因"
,min(case when "事件类型"='互动环开始托管' then t."事件触发时间" else null end) as "进入互动环时间"
,min(case when "事件类型"='互动环结束托管' then t."事件触发时间" else null end) as "退出互动环时间"
,min(case when "事件类型"='结束托管' then t."事件触发时间" else null end) as "结束托管"
from 
(
		select 
		cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
		,cr.chat_id 
		,cr.conversation_template_id as "机器人模版id"
		, cr.robot_id as "企微id"
		,(case
		            ---全流程测试
		            when cr.robot_id in ('16625270453') then '陈慧娜'
		            when cr.robot_id in ('16625109037') then '丁雄1'
					when cr.robot_id in ('82635937') then '熊壮3' 
					when cr.robot_id in ('24451249') then '杨茜2' 
					when cr.robot_id in ('16625562976') then '温著亮' 
					when cr.robot_id in ('13048861235') then '谢金华1' 
					when cr.robot_id in ('13246767295') then '邓梁健'
					when cr.robot_id in ('17840973392') then '李杜娟'
					when cr.robot_id in ('19146448842') then '谢金洪4'
					when cr.robot_id in ('18664323115') then '刘诗英1'
					when cr.robot_id in ('16625578275') then '马乘风1'
		            --分派前小程序测试
					when cr.robot_id in ('15692452723') then '刘桂花22' 
					when cr.robot_id in ('13554702410') then '李代高2' 
		            when cr.robot_id in ('18126462094') then '杜俊杰2'
		            when cr.robot_id in ('18025377414') then '廖燊1'
					when cr.robot_id in ('13128944752') then '毛淦民1'
					when cr.robot_id in ('17620416642') then '李琪1' 
					when cr.robot_id in ('19076123613') then '谢金洪1' 
					when cr.robot_id in ('13554702410') then '李代高2' 
					when cr.robot_id in ('13168038263') then '叶泳霞7' 
					when cr.robot_id in ('18566766142') then '叶泳霞1' 
					when cr.robot_id in ('15692085226') then '叶泳霞2' 
					when cr.robot_id in ('13147076706') then '叶泳霞3' 
					when cr.robot_id in ('15626521492') then '叶泳霞8' 
					when cr.robot_id in ('17061708243') then '叶泳霞4' 
					when cr.robot_id in ('17061708274') then '叶泳霞5' 
					when cr.robot_id in ('17061708401') then '叶泳霞6' 
					when cr.robot_id in ('17061708004') then '樊毅12'
					when cr.robot_id in ('17061708044') then '樊毅13'
					when cr.robot_id in ('17180669523') then '樊毅14'
					when cr.robot_id in ('17180669514') then '樊毅15'
					when cr.robot_id in ('17061707649') then '樊毅2'
					when cr.robot_id in ('085472') then '陈聪2'
					when cr.robot_id in ('18165747834') then '陈聪5'
					when cr.robot_id in ('19811970735') then '陈聪3'
					when cr.robot_id in ('15946933592') then '陈聪10'
					when cr.robot_id in ('13479426754') then '陈聪8'
					when cr.robot_id in ('82650967') then '陈聪'
					when cr.robot_id in ('18665347660') then '陈聪6'
					when cr.robot_id in ('13237949237') then '黄日归7'
					when cr.robot_id in ('010450746') then '黄日归'
					when cr.robot_id in ('18566235546') then '樊毅7'
					when cr.robot_id in ('19076127294') then '黄日归6'
					when cr.robot_id in ('16625215716') then '樊毅11'
					when cr.robot_id in ('19065031581') then '黄日归5'
					when cr.robot_id in ('13554701934') then '黄日归8'
					when cr.robot_id in ('79081421') then '樊毅5'
					
					--朱伟组
					when cr.robot_id in ('13128719847') then '王迎迎1'
					when cr.robot_id in ('13148704572') then '陈会米'
					when cr.robot_id in ('13169912402') then '王松'
					when cr.robot_id in ('18529580742') then '杜豪杰'
					when cr.robot_id in ('10412106') then '杨涵5'
					when cr.robot_id in ('699483') then '梁美琪1'
					when cr.robot_id in ('19075692593') then '吴新泽1'
					when cr.robot_id in ('837754') then '汤少婷1'
					when cr.robot_id in ('13249828259') then '丘国诚1'
					when cr.robot_id in ('17688798412') then '庄紫华1'
					
					--梁欢组
					when cr.robot_id in ('17665461063') then '江欢1'
					when cr.robot_id in ('13172452820') then '周文倩1'
					when cr.robot_id in ('17675455136') then '陈木旺1'
					when cr.robot_id in ('17811634818') then '谢永利2'
					when cr.robot_id in ('10710392') then '曾丽娴2'
					when cr.robot_id in ('960021') then '李清燕'
					when cr.robot_id in ('18098960441') then '黄诗婷3'
					when cr.robot_id in ('13266858246') then '彭园娣4'
					when cr.robot_id in ('18129976364') then '杨媛1'
					
					--梁欢组
					when cr.robot_id in ('13554702743') then '刘域1'
					when cr.robot_id in ('18620319427') then '陈德斌1'
					when cr.robot_id in ('18033061704') then '钟裕平2'
					when cr.robot_id in ('19075697231') then '周珍妮1'
					when cr.robot_id in ('15692088753') then '谈丽2'
					when cr.robot_id in ('18682261781') then '张颖1'
					when cr.robot_id in ('18594242803') then '陈晓双1'
					when cr.robot_id in ('16675412543') then '罗文慧1'
					when cr.robot_id in ('15361422304') then '陈昊1'
		
		else '未找到' end
		) as "负责人"
		,from_unixtime(cr.create_time+8*3600) as "托管时间"
		--, 
		--(
		--        select sp.property_name 
		--        from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp
		--        where sp.whole_code =cr.ask_slot 
		--) as "托管环节"
		, 
		json_extract(cb.extend_info, '$.currentSlot') as "托管环节"
		,from_unixtime(cr.staff_service_time +8*3600) as "转人工时间时间"
		, (case  when cr.transfer_manual_reason=0 then '会话中' when cr.transfer_manual_reason=1 then '主动取消' when cr.transfer_manual_reason=2 then '用户开口' when cr.transfer_manual_reason=3 then '用户拉黑删除好友' when cr.transfer_manual_reason=4 then '微联回调消息失败' when cr.transfer_manual_reason=5 then '用户超时无响应' when cr.transfer_manual_reason=6 then '回复内容不识别' when cr.transfer_manual_reason=7 then '话术流程结束' when cr.transfer_manual_reason=8 then '回复非文本内容不识别' when cr.transfer_manual_reason=9 then '调用素材中心接口失败' when cr.transfer_manual_reason=10 then '二次促开口，不满足跟进条件' when cr.transfer_manual_reason=11 then '无法识别用户回复意图' when cr.transfer_manual_reason=12 then '没有匹配到问题' when cr.transfer_manual_reason=13 then '槽位值归一失败' when cr.transfer_manual_reason=14 then '没找到话术调度策略' when cr.transfer_manual_reason=15 then '话术调度策略转人工' when cr.transfer_manual_reason=16 then '查找状态策略表级联超过了10次' when cr.transfer_manual_reason=17 then '转人工意图策略' when cr.transfer_manual_reason=18 then '顾问企微账号不再使用兔小智' when cr.transfer_manual_reason=19 then '项目状态已是已获权以上' when cr.transfer_manual_reason=20 then '模型调用失败' when cr.transfer_manual_reason=21 then '促开口配置错误' when cr.transfer_manual_reason=22 then '账号取消托管' when cr.transfer_manual_reason=23 then '槽位提问超过2次' when cr.transfer_manual_reason=24 then '达到闭环条件' when cr.transfer_manual_reason=25 then '公装' when cr.transfer_manual_reason=26 then '相同话术不允许重复发' when cr.transfer_manual_reason=27 then '待发送话术对应的槽位已经有值' when cr.transfer_manual_reason=28 then '特殊意图超过阈值' when cr.transfer_manual_reason=29 then '项目状态已是已获权以上，且用户开口' when cr.transfer_manual_reason=30 then '用户未开口' when cr.transfer_manual_reason=31 then '用户二次开口' when cr.transfer_manual_reason=32 then '三个月后交房[闭环]' when cr.transfer_manual_reason=33 then '主动取消-话术流程错误' when cr.transfer_manual_reason=34 then '主动取消-话术不恰当' when cr.transfer_manual_reason=35 then '顾问主动要求' when cr.transfer_manual_reason=36 then '顾问抢答或撤回消息' when cr.transfer_manual_reason=37 then '大模型兜底内容无法识别其意图' when cr.transfer_manual_reason=38 then '大模型兜底导致相同内容超过2次' when cr.transfer_manual_reason=39 then '系统未知异常' when cr.transfer_manual_reason=40 then '暂停托管次数超过阈值' when cr.transfer_manual_reason=41 then '无人工响应' when cr.transfer_manual_reason=42 then '暂停托管跟进超时' when cr.transfer_manual_reason=43 then '在职转接删除好友' when cr.transfer_manual_reason=44 then '结束跟进' when cr.transfer_manual_reason=45 then '规则查找超过20次' when cr.transfer_manual_reason=46 then '用户填写小程序卡' when cr.transfer_manual_reason=47 then '话术存在占位符' when cr.transfer_manual_reason=48 then '计算大模型兜底意向量房时间异常' when cr.transfer_manual_reason=49 then '大模型推荐转人工' when cr.transfer_manual_reason=50 then '话术流程结束-ABC闭环' when cr.transfer_manual_reason=51 then '根据话术条件查询失败' when cr.transfer_manual_reason=52 then '话术流程结束-发完姓氏闭环' when cr.transfer_manual_reason=53 then '审核编辑后，项目状态已是已获权以上'  when cr.transfer_manual_reason=54 then '用户超长时间后开口'  when cr.transfer_manual_reason=55 then '不满足大模型兜底条件-未交房'  when cr.transfer_manual_reason=56 then '不满足大模型兜底条件-在外地'  when cr.transfer_manual_reason=57 then '触发过年期间不可约量房时间'  when cr.transfer_manual_reason=58 then '提示语返回异常'  when cr.transfer_manual_reason=59 then '已签约，转人工'  when cr.transfer_manual_reason=101 then '开启会话失败' when cr.transfer_manual_reason=102 then '获取当前槽位失败' when cr.transfer_manual_reason=103 then '静默超时转人工挂机' when cr.transfer_manual_reason=104 then '用户出现负向意图-挂机' when cr.transfer_manual_reason=105 then '用户累计2次中性意图-挂机' when cr.transfer_manual_reason=106 then '用户表达不能操作1-挂机' when cr.transfer_manual_reason=107 then '会话调度流程结束-挂机' when cr.transfer_manual_reason=108 then '找不到对应的话术策略-挂机' when cr.transfer_manual_reason=109 then '加微操作未引导成功-挂机' when cr.transfer_manual_reason=110 then '收不到短信-挂机' when cr.transfer_manual_reason=111 then '短信加微操作未引导成功-挂机' when cr.transfer_manual_reason=112 then '结束语' when cr.transfer_manual_reason=113 then '用户表达不能操作2-挂机' when cr.transfer_manual_reason=114 then '用户辱骂-挂机' when cr.transfer_manual_reason=115 then '加微操作未引导成功1-挂机' when cr.transfer_manual_reason=116 then '用户表达不能操作3-挂机' when cr.transfer_manual_reason=117 then '用户主动挂机' when cr.transfer_manual_reason=108 then '找不到素材信息-挂机' when cr.transfer_manual_reason=119 then '前置话术-联系官网类-挂机' when cr.transfer_manual_reason=120 then '已匹配结束语' when cr.transfer_manual_reason=121 then '未匹配结束语' when cr.transfer_manual_reason=122 then '结束语-已转化' when cr.transfer_manual_reason=123 then '结束语-未转化' when cr.transfer_manual_reason=124 then '后续联系-结束语' else '未知' end )  as "转人工原因"
		, (case when cb.behavior_status = 1 then '请求'  when cb.behavior_status = 2 then '点击'  when cb.behavior_status = 3 then '回复'  when cb.behavior_status = 4 then '点击之后回复的内容'  when cb.behavior_status = 5 then '开始托管'  when cb.behavior_status = 6 then '结束托管'  when cb.behavior_status = 7 then '暂停托管'  when cb.behavior_status = 8 then '恢复托管'  when cb.behavior_status = 9 then '顾问采纳应答策略'  when cb.behavior_status = 10 then '顾问纠错应答策略'  when cb.behavior_status = 11 then '无人工响应'  when cb.behavior_status = 12 then '引用消息'  when cb.behavior_status = 13 then '互动环开始托管'  when cb.behavior_status = 14 then '互动环结束托管' else '其他' end) as "事件类型"
		,from_unixtime(cb.create_time+8*3600) as "事件触发时间"
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cb.chat_id =cr.chat_id 
		where cr.robot_takeover_type =0
		and cr.strategy_scene =9
		and cr.deleted =0
		and cr.create_time >=to_unixtime(cast ('2025-06-04 00:00:0' as timestamp)) - 8*3600 
		and '' != regexp_extract(cr.extend_info , 'interactiveRingNameList')
		and json_array_length(json_extract(cr.extend_info, '$.interactiveRingNameList')) > 0
		--and json_extract_scalar(cr.extend_info , '$.phone_id') = '423737242'
		--order by cb.chat_id , cb.id  ;
) t
group by "电话id",chat_id,"机器人模版id","企微id","负责人","托管时间","托管环节","转人工时间时间","转人工原因"


select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
where cb.chat_id ='MTM1NTQ3MDE5MzQjd21KaUliREFBQUl6M21FQmttTExlYXE3WHBWNGw2M0E='

;




----测试  分派全槽位测试
select from_unixtime(cr.create_time+8*3600) as "加微时间" ,cr.extend_info 
,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid,cr.uid ,from_unixtime(cr.staff_service_time +8*3600) as sst,cr.check_status 
,${hivevar_transfer_manual_reason} 
,
case when exists (
	select qr.id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
	where qr.chat_id =cr.chat_id 
	and qr.direction =1
	and qr.system_type =0
) then '用户开口'  else '用户未开口' end 
as "用户是否开口"
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where
json_extract_scalar(cr.extend_info  , '$.allSlotFlag')='1' 
and cr.create_time >=to_unixtime(cast ('2025-06-06 16:00:0' as timestamp)) - 8*3600 
and cr.create_time <to_unixtime(cast ('2025-06-07 16:00:0' as timestamp)) - 8*3600 
order by id desc
limit 10






select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ra
where ra.id =106290









--  正则匹配全量语料中的关键字
select scr.toid ,scr.fromid 
,(case when scr.direction =2 then scr.toid ||'@' || scr.fromid  when scr.direction=1 then scr.fromid ||'@' ||scr.toid  else '其他' end )  as "用户@顾问"
,(
        case when 
         '' != regexp_extract(scr.content , '避免电话打扰') 
         then 1
         else 0 end
) as "命中语料"
,from_unixtime(scr.send_time +8*3600) as "消息发送时间"
,(case when scr.direction =2 then '顾问' when scr.direction=1 then '用户' else '其他' end )  as "发送角色"
, scr.scene as "发送角色2"
,scr.message_type ,scr.content ,scr.object_content 
from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record scr
left join 
(
 select 
 cr.toid ,cr.fromid 
 from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record cr
 where cr.direction=2 --顾问说的
 and '' != regexp_extract(cr.content , '避免电话打扰') 
 and cr.send_time  >=to_unixtime(cast ('2025-06-03 00:00:0' as timestamp)) - 8*3600 
) t on( ( t.toid= scr.toid and t.fromid= scr.fromid ) or ( t.toid= scr.fromid and t.fromid= scr.toid ))
where 
scr.send_time  >=to_unixtime(cast ('2025-06-03 00:00:0' as timestamp)) - 8*3600 
and 
t.toid is not null
--and scr.scene ='IR'
order by "用户@顾问", scr.send_time asc








select from_unixtime(cd.create_time+8*3600) as create_time,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid, cd.role_type 
, cd.check_type_code , sp.property_name ,cd.reply , cd.source_reply , cd.nlp_reply 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cd.chat_id =cr.chat_id 
left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
where 
cd.reply != ''
and cd.check_type_code ='7!711!71102!3'
and cd.deleted =0
and cr.deleted =0
and cd.role_type =3
and cr.create_time >=to_unixtime(cast ('2025-06-01 00:00:0' as timestamp)) - 8*3600 
order by cd.id desc





select from_unixtime(cd.create_time+8*3600) as create_time,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid, cd.role_type 
, cd.check_type_code , sp.property_name ,cd.reply , cd.source_reply , cd.nlp_reply 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cd.chat_id =cr.chat_id 
left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
where 
cd.check_type_code in ('7!711!71102!693','7!711!71102!692', '7!711!71102!694','7!711!71102!1','7!711!71102!6','7!711!71102!13')
and cd.reply !=''
and cd.deleted =0
and cr.deleted =0
and cr.create_time >=to_unixtime(cast ('2025-06-01 00:00:0' as timestamp)) - 8*3600 
order by cd.id desc


select 
cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
,from_unixtime(cr.create_time+8*3600) as "会话时间"
,from_unixtime(cr.staff_service_time +8*3600) as "转人工时间时间"
,${hivevar_transfer_manual_reason} 
,*


--- 最后一句话是用户的记录
select 
(
	select json_extract_scalar(cr1.extend_info , '$.phone_id')
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr1 
	where cr1.chat_id =qr1.chat_id 
) as "电话id"
,(
	select from_unixtime(cr2.create_time  +8*3600) as "加微时间"
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr2
	where cr2.chat_id =qr1.chat_id 
) as "加微时间"
, qr1.text_content as "用户的最后一句话"
,from_unixtime(qr1.create_time  +8*3600) as "最后一句话的发送时间"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr1
where qr1.id in 
(
	select max(qr.id) as max_qr_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id =qr.chat_id 
	where cr.deleted =0 and cr.robot_takeover_type =0 and cr.strategy_scene =9
	and '' != regexp_extract(cr.extend_info , 'interactiveRingNameList')
	and json_array_length(json_extract(cr.extend_info, '$.interactiveRingNameList')) > 0
	and cr.create_time >=to_unixtime(cast ('2025-06-01 00:00:0' as timestamp)) - 8*3600 
	group by qr.chat_id 
)
and qr1.create_time >=to_unixtime(cast ('2025-06-01 00:00:0' as timestamp)) - 8*3600 
and qr1.direction = 1
and qr1.system_type =0










--  正则匹配全量语料中的关键字
select scr.toid ,scr.fromid 
,(case when scr.direction =2 then scr.toid ||'@' || scr.fromid  when scr.direction=1 then scr.fromid ||'@' ||scr.toid  else '其他' end )  as "用户@顾问"
,(
        case when 
         '' != regexp_extract(scr.content , '有看小程序里给你准备的报价行情吗？里面是我们平台根据近期近万家装修业主的真实成交价给的参考价，还是可以看看的～') 
         then 1
         else 0 end
) as "命中语料"
,from_unixtime(scr.send_time +8*3600) as "消息发送时间"
,(case when scr.direction =2 then '顾问' when scr.direction=1 then '用户' else '其他' end )  as "发送角色"
, scr.scene as "发送角色2"
,scr.message_type ,scr.content ,scr.object_content 
,(

	select json_extract_scalar(cr.extend_info , '$.phone_id') 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
	where (cr.robot_id = scr.toid  and cr.uid =scr.fromid) or (cr.robot_id =scr.fromid  and cr.uid =scr.toid)
	and cr.deleted =0 and cr.robot_takeover_type =0 and cr.strategy_scene =9
) as "电话id"
from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record scr
left join 
(
 select 
 cr.toid ,cr.fromid 
 from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_single_chat_record cr
 where cr.direction=2 --顾问说的
 and '' != regexp_extract(cr.content , '有看小程序里给你准备的报价行情吗？里面是我们平台根据近期近万家装修业主的真实成交价给的参考价，还是可以看看的～') 
 and cr.send_time  >=to_unixtime(cast ('2025-06-10 00:00:0' as timestamp)) - 8*3600 
) t on( ( t.toid= scr.toid and t.fromid= scr.fromid ) or ( t.toid= scr.fromid and t.fromid= scr.toid ))
where 
scr.send_time  >=to_unixtime(cast ('2025-06-10 00:00:0' as timestamp)) - 8*3600 
and 
t.toid is not null
--and scr.scene ='IR'
order by "用户@顾问", scr.send_time asc



select uwechat.external_userid, uinfo.phone_id from hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat uwechat 
left join hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_info uinfo on uwechat.user_id = uinfo.user_id
where uwechat.external_userid in ('wmJiIbDAAAMBnSsWxhXHAla-vt_Opl4w','wmJiIbDAAAqKkQZDtCRafzqcIqLzPw3Q');



--------
-- 根据外部联系人id 查询电话id
select uwechat.external_userid, uinfo.phone_id 
from hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat uwechat 
left join hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_info uinfo 
	on uwechat.user_id = uinfo.user_id
where uwechat.external_userid in ('wmJiIbDAAAMBnSsWxhXHAla-vt_Opl4w','wmJiIbDAAAqKkQZDtCRafzqcIqLzPw3Q')
























-- 统计每个用户接了多少互动环
select "电话id",chat_id,"机器人模版id","企微id","负责人","托管时间","托管环节","转人工时间时间","转人工原因"
,min(case when "事件类型"='互动环开始托管' then t."事件触发时间" else null end) as "进入互动环时间"
,min(case when "事件类型"='互动环结束托管' then t."事件触发时间" else null end) as "退出互动环时间"
,min(case when "事件类型"='结束托管' then t."事件触发时间" else null end) as "结束托管"
from 
(
		select 
		cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
		,cr.chat_id 
		,cr.conversation_template_id as "机器人模版id"
		, cr.robot_id as "企微id"
		,(case
		            ---全流程测试
		            when cr.robot_id in ('16625270453') then '陈慧娜'
		
		else '未找到' end
		) as "负责人"
		,from_unixtime(cr.create_time+8*3600) as "托管时间"
		, 
		json_extract(cb.extend_info, '$.currentSlot') as "托管环节"
		,from_unixtime(cr.staff_service_time +8*3600) as "转人工时间时间"
		, (case  when cr.transfer_manual_reason=0 then '会话中' when cr.transfer_manual_reason=1 then '主动取消' when cr.transfer_manual_reason=2 then '用户开口' when cr.transfer_manual_reason=3 then '用户拉黑删除好友' when cr.transfer_manual_reason=4 then '微联回调消息失败' when cr.transfer_manual_reason=5 then '用户超时无响应' when cr.transfer_manual_reason=6 then '回复内容不识别' when cr.transfer_manual_reason=7 then '话术流程结束' when cr.transfer_manual_reason=8 then '回复非文本内容不识别' when cr.transfer_manual_reason=9 then '调用素材中心接口失败' when cr.transfer_manual_reason=10 then '二次促开口，不满足跟进条件' when cr.transfer_manual_reason=11 then '无法识别用户回复意图' when cr.transfer_manual_reason=12 then '没有匹配到问题' when cr.transfer_manual_reason=13 then '槽位值归一失败' when cr.transfer_manual_reason=14 then '没找到话术调度策略' when cr.transfer_manual_reason=15 then '话术调度策略转人工' when cr.transfer_manual_reason=16 then '查找状态策略表级联超过了10次' when cr.transfer_manual_reason=17 then '转人工意图策略' when cr.transfer_manual_reason=18 then '顾问企微账号不再使用兔小智' when cr.transfer_manual_reason=19 then '项目状态已是已获权以上' when cr.transfer_manual_reason=20 then '模型调用失败' when cr.transfer_manual_reason=21 then '促开口配置错误' when cr.transfer_manual_reason=22 then '账号取消托管' when cr.transfer_manual_reason=23 then '槽位提问超过2次' when cr.transfer_manual_reason=24 then '达到闭环条件' when cr.transfer_manual_reason=25 then '公装' when cr.transfer_manual_reason=26 then '相同话术不允许重复发' when cr.transfer_manual_reason=27 then '待发送话术对应的槽位已经有值' when cr.transfer_manual_reason=28 then '特殊意图超过阈值' when cr.transfer_manual_reason=29 then '项目状态已是已获权以上，且用户开口' when cr.transfer_manual_reason=30 then '用户未开口' when cr.transfer_manual_reason=31 then '用户二次开口' when cr.transfer_manual_reason=32 then '三个月后交房[闭环]' when cr.transfer_manual_reason=33 then '主动取消-话术流程错误' when cr.transfer_manual_reason=34 then '主动取消-话术不恰当' when cr.transfer_manual_reason=35 then '顾问主动要求' when cr.transfer_manual_reason=36 then '顾问抢答或撤回消息' when cr.transfer_manual_reason=37 then '大模型兜底内容无法识别其意图' when cr.transfer_manual_reason=38 then '大模型兜底导致相同内容超过2次' when cr.transfer_manual_reason=39 then '系统未知异常' when cr.transfer_manual_reason=40 then '暂停托管次数超过阈值' when cr.transfer_manual_reason=41 then '无人工响应' when cr.transfer_manual_reason=42 then '暂停托管跟进超时' when cr.transfer_manual_reason=43 then '在职转接删除好友' when cr.transfer_manual_reason=44 then '结束跟进' when cr.transfer_manual_reason=45 then '规则查找超过20次' when cr.transfer_manual_reason=46 then '用户填写小程序卡' when cr.transfer_manual_reason=47 then '话术存在占位符' when cr.transfer_manual_reason=48 then '计算大模型兜底意向量房时间异常' when cr.transfer_manual_reason=49 then '大模型推荐转人工' when cr.transfer_manual_reason=50 then '话术流程结束-ABC闭环' when cr.transfer_manual_reason=51 then '根据话术条件查询失败' when cr.transfer_manual_reason=52 then '话术流程结束-发完姓氏闭环' when cr.transfer_manual_reason=53 then '审核编辑后，项目状态已是已获权以上'  when cr.transfer_manual_reason=54 then '用户超长时间后开口'  when cr.transfer_manual_reason=55 then '不满足大模型兜底条件-未交房'  when cr.transfer_manual_reason=56 then '不满足大模型兜底条件-在外地'  when cr.transfer_manual_reason=57 then '触发过年期间不可约量房时间'  when cr.transfer_manual_reason=58 then '提示语返回异常'  when cr.transfer_manual_reason=59 then '已签约，转人工'  when cr.transfer_manual_reason=101 then '开启会话失败' when cr.transfer_manual_reason=102 then '获取当前槽位失败' when cr.transfer_manual_reason=103 then '静默超时转人工挂机' when cr.transfer_manual_reason=104 then '用户出现负向意图-挂机' when cr.transfer_manual_reason=105 then '用户累计2次中性意图-挂机' when cr.transfer_manual_reason=106 then '用户表达不能操作1-挂机' when cr.transfer_manual_reason=107 then '会话调度流程结束-挂机' when cr.transfer_manual_reason=108 then '找不到对应的话术策略-挂机' when cr.transfer_manual_reason=109 then '加微操作未引导成功-挂机' when cr.transfer_manual_reason=110 then '收不到短信-挂机' when cr.transfer_manual_reason=111 then '短信加微操作未引导成功-挂机' when cr.transfer_manual_reason=112 then '结束语' when cr.transfer_manual_reason=113 then '用户表达不能操作2-挂机' when cr.transfer_manual_reason=114 then '用户辱骂-挂机' when cr.transfer_manual_reason=115 then '加微操作未引导成功1-挂机' when cr.transfer_manual_reason=116 then '用户表达不能操作3-挂机' when cr.transfer_manual_reason=117 then '用户主动挂机' when cr.transfer_manual_reason=108 then '找不到素材信息-挂机' when cr.transfer_manual_reason=119 then '前置话术-联系官网类-挂机' when cr.transfer_manual_reason=120 then '已匹配结束语' when cr.transfer_manual_reason=121 then '未匹配结束语' when cr.transfer_manual_reason=122 then '结束语-已转化' when cr.transfer_manual_reason=123 then '结束语-未转化' when cr.transfer_manual_reason=124 then '后续联系-结束语' else '未知' end )  as "转人工原因"
		, (case when cb.behavior_status = 1 then '请求'  when cb.behavior_status = 2 then '点击'  when cb.behavior_status = 3 then '回复'  when cb.behavior_status = 4 then '点击之后回复的内容'  when cb.behavior_status = 5 then '开始托管'  when cb.behavior_status = 6 then '结束托管'  when cb.behavior_status = 7 then '暂停托管'  when cb.behavior_status = 8 then '恢复托管'  when cb.behavior_status = 9 then '顾问采纳应答策略'  when cb.behavior_status = 10 then '顾问纠错应答策略'  when cb.behavior_status = 11 then '无人工响应'  when cb.behavior_status = 12 then '引用消息'  when cb.behavior_status = 13 then '互动环开始托管'  when cb.behavior_status = 14 then '互动环结束托管' else '其他' end) as "事件类型"
		,from_unixtime(cb.create_time+8*3600) as "事件触发时间"
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cb.chat_id =cr.chat_id 
		where cr.robot_takeover_type =0
		and cr.strategy_scene =9
		and cr.deleted =0
		and cr.transfer_manual_reason =35
		and cr.create_time >=to_unixtime(cast ('2025-04-02 00:00:0' as timestamp)) - 8*3600 
		and '' != regexp_extract(cr.extend_info , 'interactiveRingNameList')
		and json_array_length(json_extract(cr.extend_info, '$.interactiveRingNameList')) > 0
		--order by cb.chat_id , cb.id  ;
) t
group by "电话id",chat_id,"机器人模版id","企微id","负责人","托管时间","托管环节","转人工时间时间","转人工原因"











 select from_unixtime(cr.create_time+8*3600) as "加微时间",cr.chat_id ,cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where cr.transfer_manual_reason =35
and cr.strategy_scene =9
and cr.deleted =0
limit 10












    
  select cr.reply_time as "槽位收集到的时间" 
  from hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp
  left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cr on cr.check_type_code= sp.whole_code
  where sp.property_name = ${当前槽位} 
    
    
 
  
  
  
  ----测试  分派全槽位测试
select cr.chat_id 
,from_unixtime(cr.staff_service_time  +8*3600) as "转人工时间"
,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid
,from_unixtime(cr.create_time+8*3600) as "加微时间" ,cr.extend_info 
,from_unixtime(cr.staff_service_time +8*3600) as sst,cr.check_status 
,${hivevar_transfer_manual_reason} 
,
case when exists (
        select qr.id 
        from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
        where qr.chat_id =cr.chat_id 
        and qr.direction =1
        and qr.system_type =0
) then '用户开口'  else '用户未开口' end 
as "是否开口"
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where
json_extract_scalar(cr.extend_info  , '$.allSlotFlag')='1' 
and cr.create_time >=to_unixtime(cast ('2025-07-02 16:00:0' as timestamp)) - 8*3600
and cr.create_time <=to_unixtime(cast ('2025-07-03 09:00:0' as timestamp)) - 8*3600
and cr.transfer_manual_reason not in (19,29,53)
and cr.robot_id != '18576473328'
order by id desc
limit 500    




select from_unixtime(qr.create_time+8*3600) as "消息创建时间"
--,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid
, from_unixtime(qr.send_time +8*3600) as "消息实际发送时间" 
, (qr.create_time - qr.send_time) as "消息延迟接收秒数"
,(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色"
,qr.text_content ,qr.user_reply_intention ,qr.user_reply_slot 
,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where qr.text_content_real like '%interactiveRing%'
and qr.text_content_real not like '%分派-全槽位收集%'
and qr.create_time >=to_unixtime(cast ('2025-07-28 00:00:0' as timestamp)) - 8*3600 
order by qr.id asc





select from_unixtime(cd.create_time+8*3600) as create_time
, (
select json_extract_scalar(cr2.extend_info , '$.phone_id') as phoneid
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr2
where cr2.chat_id =cd.chat_id 
and cr2.deleted =0
) as "电话id"
, cd.role_type 
, cd.check_type_code , sp.property_name ,cd.reply , cd.source_reply , cd.nlp_reply 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
where 1=1
and cd.chat_id in (
	select cr1.chat_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr1
	where 1=1
	and cr1.create_time >=to_unixtime(cast ('2025-07-26 00:00:0' as timestamp)) - 8*3600 
	and cr1.create_time <=to_unixtime(cast ('2025-07-27 00:00:0' as timestamp)) - 8*3600 
	and cr1.strategy_scene =9
	and cr1.deleted =0
)
and cd.deleted =0
order by cd.chat_id ,cd.id desc



-- 当前大模型提取值
select cd.chat_id
,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid
,cd.check_type_code, sp.property_name ,cd.reply  
from ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
left join ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cd.chat_id =cr.chat_id 
where cr.deleted =0 and cr.robot_takeover_type =0 and cr.strategy_scene =9
--	and '' != regexp_extract(cr.extend_info , 'interactiveRingNameList')
--	and json_array_length(json_extract(cr.extend_info, '$.interactiveRingNameList')) > 0
	and json_extract_scalar(cr.extend_info  , '$.allSlotFlag')='1' 
	and cr.transfer_manual_reason not in (19,29,53)
	and cr.robot_id != '18576473328'
	and cr.create_time >=to_unixtime(cast ('2025-07-31 00:00:0' as timestamp)) - 8*3600 
	and cr.create_time <to_unixtime(cast ('2025-07-31 12:00:0' as timestamp)) - 8*3600 
--and cd.role_type =1
--and cd.check_type_code in
--(
--'7!711!71102!692','7!711!71102!697','7!711!71102!702','7!711!71102!699','7!711!71102!705','7!711!71102!693','7!711!71102!694','7!711!71102!703','7!711!71102!696','7!711!71102!695'
--)
and cd.check_type_code in('7!711!71102!692')
and cd.reply !=''





--查询QA 语料
select cr1.id 
,cr1.qa_question as "用户回复"
,(
case when json_extract_scalar(cr1.qa_return  , '$.qaMulityVO.similarity') = '-1.0' then '否' else '是' end
) as "小模型预测是否QA"
,json_extract_scalar(cr1.qa_return  , '$.qaMulityVO.questionType') as "小模型预测置QA类型"
,json_extract_scalar(cr1.qa_return  , '$.qaMulityVO.similarity') as "小模型预测置信度"
,JSON_EXTRACT(cr1.qa_return  , '$.qaMulityVO.candidateAnswer') as "小模型推荐承接话术"
from hive2.ads.v_kudu2_stg_idc_new_t8t_nlp_fls_fls_qa_content_record cr1
where cr1.id in 
(76690960,76690924,76710029,76743697,76691047,76698884,76690939,76695568,76777853,76745034,76709468,76713737,76712107,76777874,76703484,80112640,76697146,76703625,76690925,76721899,76722663,76777976,76703989,76722332,76717282,76691101,76777851,76691068,76700597,76745525,76715496,76758540,76744361,76777989,76777838,76777897,76690984,76777961,76690911,76777936,76690945,76749196,76703630,76713367,76740814,76742345,76777845,76725938,76690947,76767049,76702470,76697239,76753775,76777876,76712456,76690914,76691007,76777836,76777852,76733211,76731100,76725282,76750555,76767012,76777893,76691035,76777985,76707942,76690950,76691086,76704664,76777887,76736550,76713304,76733541,76708814,76690944,76747237,76719107,76752437,80113329,76777863,76741502,76690997,76753788,76690993,76771288,76731842,76713608,76694504,76741401,76690966,80112728,76690949,76738731,76742162,76715023,76712016,76692456,76713753
--	(
--		-- 查询非QA 文本
--		select cr.id 
--		from hive2.ads.v_kudu2_stg_idc_new_t8t_nlp_fls_fls_qa_content_record cr
--		where cr.create_time >=to_unixtime(cast ('2025-08-21 00:00:0' as timestamp)) - 8*3600
--		and json_extract_scalar(cr.qa_return  , '$.qaMulityVO.similarity') = '-1.0'
--		and cr.bussiness_key ='intelligentPlatform'
--		limit 20
--	)
--	union 
--	(
--		-- 查询QA 文本
--		select 
--		cr.id 
--		from hive2.ads.v_kudu2_stg_idc_new_t8t_nlp_fls_fls_qa_content_record cr
--		where cr.create_time >=to_unixtime(cast ('2025-08-21 00:00:0' as timestamp)) - 8*3600
--		and json_extract_scalar(cr.qa_return  , '$.qaMulityVO.similarity') != '-1.0'
--		and cr.bussiness_key ='intelligentPlatform'
--		limit 80
--	)
--	order by rand()
)

----------------------------------------------------------------------------------------------------------

-- 查询可匹配聊天记录
select cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id",
       qr.direction as "发送角色",
       qr.system_type as "是否主动发送",
       qr.text_content as "消息内容",
       format_datetime(FROM_UNIXTIME(qr.send_time + 28800), 'yyyy-MM-dd HH:mm:ss')  as "消息发送时间",
       qr.user_reply_intention as "用户回复意图",
       qr.user_reply_slot as "用户回复槽位值",
       ak.check_type_code AS "问题分类",
       cr.robot_id 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cr.chat_id = qr.chat_id and cr.chat_id is not null 
LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask ak ON qr.robot_ask_id=ak.id
where 
cr.create_time  >=to_unixtime(cast ('2025-09-20 00:00:0' as timestamp)) - 8*3600 
and cr.create_time  <to_unixtime(cast ('2025-09-26 00:00:0' as timestamp)) - 8*3600 
and cast(json_extract(cr.extend_info, '$.phone_id') as integer) in 
(
	select --a.external_userid,a.owner_wechat as wechat,
	b.phone_id as phone_id
	FROM hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat AS a 
	    LEFT JOIN hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_info AS b ON a.user_id=b.user_id
	    left join hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_housekeeper as housekeeper on a.user_id = housekeeper .user_id  
	    LEFT JOIN hive2.ads.v_kudu2_stg_idc_new_t8t_mid_ucchat_uc_wechat_agree_status as c on a.owner_wechat=c.qr_user_id and a.external_userid=c.external_open_id and c.agree_status="agree_status"
	where a.add_wechat_time  >=to_unixtime(cast ('2025-09-20 00:00:0' as timestamp)) - 8*3600 
	and a.add_wechat_time  <to_unixtime(cast ('2025-09-26 00:00:0' as timestamp)) - 8*3600 
	and a.user_all_message>5 and a.create_user = housekeeper.owner_id and b.phone_id IN (
	    SELECT b.phone_id
	    FROM hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_project AS a 
	        LEFT JOIN hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_contact AS b ON a.con_id=b.id 
	        LEFT JOIN hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_demand AS c ON a.dem_id=c.dem_id 
	        LEFT JOIN hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_demand_hard AS d ON a.dem_id=d.dem_id 
	        LEFT JOIN hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_house AS e ON a.proj_id=e.proj_id
	        LEFT JOIN hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_proj_granted_record AS g ON a.proj_id=g.proj_id AND a.granted_time=g.granted_time
	    WHERE  a.granted_time >=to_unixtime(cast ('2025-09-20 00:00:0' as timestamp)) - 8*3600 
	    and a.granted_time <to_unixtime(cast ('2025-09-26 00:00:0' as timestamp)) - 8*3600 
	            AND a.status=110 AND g.granted_source=5 
	)
)
and qr.text_content is not null 
--and cr.chat_id in 
--(	
--	select cd.chat_id 
--	from	hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
--	where cd.deleted =0
--	and cd.create_time >=to_unixtime(cast ('2025-08-28 00:00:0' as timestamp)) - 8*3600 
--	and cd.create_time <to_unixtime(cast ('2025-09-08 00:00:0' as timestamp)) - 8*3600 
--	and cd.check_type_code = '7!711!71102!545'
--	and cd.reply !=''
--)
order by cr.chat_id asc, qr.send_time asc
limit 500;





-- 查询聊天记录 微信聊天记录
select 
CONCAT(t1.wechat,'@',t1.external_userid) as sid
,t1.direction
,(
	case when t1.direction =2 then '客服' else '用户' end
) as "发送人"
, as "发送场景"
,t1.msg_time/1000 as msg_time
,from_unixtime(t1.msg_time/1000+8*3600) as "发送时间"
,t1.content 
from 
(
	SELECT 
		if(substr(from_id,1,2)='wm',tolist,from_id) as wechat,
		if(substr(tolist,1,2)='wm',tolist,from_id) as external_userid,
		if(substr(from_id,1,2)='wm',1,2) as direction,
		msg_time,
		msg_type,
		content
	FROM hive2.ads.v_kudu2_stg_idc_new_t8t_mid_ucchat_uc_wechat_chatdata wc
	WHERE msg_type='text'
	 	and content <>'【未知消息类型】'
	 	and content <>''
	 	and msg_time>((to_unixtime(cast ('2025-10-08 00:00:0' as timestamp)) - 8*3600) *1000)
	 	and msg_time<((to_unixtime(cast ('2025-10-09 00:00:0' as timestamp)) - 8*3600) *1000)
) as t1 
where 
--t1.wechat in('18575677395','16625124081','13244727305','17679207507','10708951')
--and 
t1.external_userid like 'wm%'
order by CONCAT(t1.wechat,'@',t1.external_userid),t1.msg_time


-- 查询聊天记录 微联侧
select 
CONCAT(t1.wechat,'@',t1.external_userid) as sid
,t1.direction
,(
	case when t1.direction =2 then '客服' else '用户' end
) as "发送人"
, as "发送场景"
,t1.msg_time/1000 as msg_time
,from_unixtime(t1.msg_time/1000+8*3600) as "发送时间"
,t1.content 
from 



-- 智能应答消息渗透率 当天消息、24小时内消息
select qr.chat_id
,(case when qr.direction=2 then '顾问' when qr.direction=1 then '用户' else '其他' end )  as "发送角色"
,qr.uid 
,qr.we_chat 
,qr.text_content 
,from_unixtime(qr.send_time+8*3600) as "发送时间"
,regexp_extract(qr.answer_relate_message_id, '^([^_]+_[^_]+)_', 1) as  sence
,from_unixtime(cr.create_time +8*3600) as "加微时间"
-- 新增字段1：判断是否同一天
,if(
    getday(qr.send_time,'yyyy-MM-dd 00:00:00') = getday(qr.create_time,'yyyy-MM-dd 00:00:00'), 
    '是', 
    '否'
) as "是否同一天"
    -- 新增字段2：判断是否相差在24小时内
,if(
        abs(qr.send_time - cr.create_time) <= 24*3600, 
        '是', 
        '否'
    ) as "是否相差24小时内"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on qr.chat_id =cr.chat_id 
where cr.chat_id is not null and cr.deleted =0 and cr.strategy_scene =9
and qr.create_time >=to_unixtime(cast ('2025-09-27 00:00:0' as timestamp)) - 8*3600 
and qr.create_time < to_unixtime(cast ('2025-09-30 00:00:0' as timestamp)) - 8*3600 


-- 恢复托管之后，机器人还发言了
select t1.chat_id , t1.execute_time , t1.phoneId, t1.we_chat 
from 
(
	select t.chat_id
	, from_unixtime(cb1.create_time+8*3600) as execute_time
	, t.phoneId
	,qr.we_chat 
	from 
	(
		select cb.chat_id 
		,max(cb.id) as max_id
		,max(json_extract_scalar(cr.extend_info , '$.phone_id')) as phoneId
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cb.chat_id =cr.chat_id 
		where cr.deleted =0 and cr.strategy_scene =9 and cr.check_status =1
		group by cb.chat_id 
	) t
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb1 on t.max_id=cb1.id
	left join 
	hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on qr.chat_id =t.chat_id and qr.send_time >cb1.create_time
	where cb1.behavior_status = 15
	and qr.chat_id is not null 
	and regexp_extract(qr.answer_relate_message_id, '^([^_]+_[^_]+)_', 1)='WECSMG_IR'
) t1
group by t1.chat_id , t1.execute_time , t1.phoneId,t1.we_chat 



--装企推荐话术的回复率--智能应答
select t3.chat_id
,t3.start_qiwei_record_id as "关键字话术id"
,t5.text_content  as "关键字话术"
, from_unixtime(t5.send_time +8*3600) as "关键字话术发送时间"
,t3.next_qiwei_record_id as "回复话术id"
,t4.text_content as "回复话术"
, from_unixtime(t4.send_time +8*3600) as "回复话术发送时间"
,regexp_extract(t4.answer_relate_message_id, '^([^_]+_[^_]+)_', 1) as "发送角色"
,t3.phone_id as phone_id
from 
(
	select t2detail.chat_id
	,min(t2detail.id) as start_qiwei_record_id
	,case 
        when count(case when t1.direction = 1 and t1.system_type = 0 then 1 end) > 0 
        then max(case when t1.direction = 1 and t1.system_type = 0 then t1.id else null end)
        else 0 
    end as next_qiwei_record_id
	, min(json_extract_scalar(cr.extend_info , '$.phone_id')) as phone_id
	from 
	(
		select qr.id ,qr.chat_id 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
		where qr.text_content like '%避免您沟通几遍%'
		-- 测试：228585507 394496446 MTUyMTYyNjIzNzIjd21KaUliREFBQTlBVU5zVDlGOGo1WEJVdDFycGFPRVE=  2025-09-28
		--and qr.id =228585507
		and qr.create_time >=to_unixtime(cast ('2025-09-01 00:00:0' as timestamp)) - 8*3600 
		and qr.create_time < to_unixtime(cast ('2025-09-30 00:00:0' as timestamp)) - 8*3600 
	) t2
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record t2detail on t2.id = t2detail.id 
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record t1 on t1.chat_id =t2detail.chat_id 
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cr.chat_id = t1.chat_id
	where 
	t1.id > t2detail.id
	and cr.chat_id is not null and cr.deleted =0 and cr.strategy_scene =9
	--当天
	and getday(t1.send_time,'yyyy-MM-dd 00:00:00') = getday(t2detail.send_time,'yyyy-MM-dd 00:00:00')
	-- 24小时内
	--and t1.send_time < t2detail.send_time +24*3600
	group by t2detail.chat_id
) t3
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record t5 on t5.id =t3.start_qiwei_record_id
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record t4 on t4.id =t3.next_qiwei_record_id






--装企推荐话术的回复率--企微
select t3.external_userid,t3.profile_custom_id
,t3.start_record_id as "关键字话术id"
,t5.text_content  as "关键字话术"
, from_unixtime(t5.send_time +8*3600) as "关键字话术发送时间"
,t3.next_record_id as "回复话术id"
,t4.text_content as "回复话术"
, from_unixtime(t4.send_time +8*3600) as "回复话术发送时间"
, t4.scene as "发送角色"
from 
(
	select t1.external_userid,t1.profile_custom_id
	,min(wla2.id) as start_record_id
	,case 
        when count(case when wla2.scene = 'IR' then 1 end) > 0 
        then max(case when wla2.scene = 'IR' then wla2.id else null end)
        else 0 
    end as next_record_id
	from 
	(
		select wla.*
		from hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link_all wla
		where 
		wla.text_content like '%activity/research%'
		and wla.create_time >=to_unixtime(cast ('2025-09-29 00:00:0' as timestamp)) - 8*3600 
		and wla.create_time < to_unixtime(cast ('2025-09-30 00:00:0' as timestamp)) - 8*3600 
		--wla.external_userid='wmJiIbDAAATQ5999DIGoLWwqctRsWb5Q'
	) t1
	left join hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link_all wla2 
		on t1.external_userid=wla2.external_userid and t1.profile_custom_id=wla2.profile_custom_id
	where
	t1.external_userid is not null and t1.external_userid !=''
	and t1.id < wla2.id 
	--当天
	and getday(t1.send_time/1000,'yyyy-MM-dd 00:00:00') = getday(wla2.send_time/1000,'yyyy-MM-dd 00:00:00')
	-- 24小时内
	--and t1.send_time/1000  +24*3600 > wla2.send_time/1000
	and wla2.create_time >=to_unixtime(cast ('2025-09-29 00:00:0' as timestamp)) - 8*3600 
	and wla2.create_time < to_unixtime(cast ('2025-09-30 00:00:0' as timestamp)) - 8*3600 
	group by t1.external_userid,t1.profile_custom_id
) t3
left join hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link_all t5 on t5.id =t3.start_record_id
left join hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link_all t4 on t4.id =t3.next_record_id
where 
 t4.create_time >=to_unixtime(cast ('2025-09-29 00:00:0' as timestamp)) - 8*3600 
and t4.create_time < to_unixtime(cast ('2025-09-30 00:00:0' as timestamp)) - 8*3600 
and t5.create_time >=to_unixtime(cast ('2025-09-29 00:00:0' as timestamp)) - 8*3600 
and t5.create_time < to_unixtime(cast ('2025-09-30 00:00:0' as timestamp)) - 8*3600 

--语料的回复率-企微
select t3.external_userid,t3.profile_custom_id
,t3.start_record_id as "关键字话术id"
,t5.text_content  as "关键字话术"
, from_unixtime(t5.send_time +8*3600) as "关键字话术发送时间"
,t3.scend_record_id as "回复话术id"
,t4.text_content as "回复话术"
, from_unixtime(t4.send_time +8*3600) as "回复话术发送时间"
, t4.scene as "发送角色"
from 
(
				select t1.external_userid,t1.profile_custom_id
				,min(t1.id) as start_record_id --语料id
				,min(wla2.id) as scend_record_id --回复id
			    --select *
				from 
				(
					select wla.*
					from hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link wla
					where 
					--wla.text_content like '%activity/research%'
					wla.object_content like '%activity/research%'
					and wla.create_time >=to_unixtime(cast ('2025-11-01 11:00:0' as timestamp)) - 8*3600 
					and wla.create_time < to_unixtime(cast ('2025-11-01 14:00:0' as timestamp)) - 8*3600 
					-- 测试数据
					--and wla.external_userid='wmJiIbDAAATQ5999DIGoLWwqctRsWb5Q'
				) t1
				left join hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link wla2 
					on t1.external_userid=wla2.external_userid and t1.profile_custom_id=wla2.profile_custom_id
				where
				t1.external_userid is not null and t1.external_userid !=''
				and t1.id < wla2.id 
				group by t1.external_userid,t1.profile_custom_id
) t3
left join hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link t5 on t5.id =t3.start_record_id
left join hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link t4 on t4.id =t3.scend_record_id
where 
 t4.create_time >=to_unixtime(cast ('2025-11-01 11:00:0' as timestamp)) - 8*3600 
and t4.create_time < to_unixtime(cast ('2025-11-01 14:00:0' as timestamp)) - 8*3600 
and t5.create_time >=to_unixtime(cast ('2025-11-01 11:00:0' as timestamp)) - 8*3600 
and t5.create_time < to_unixtime(cast ('2025-11-01 14:00:0' as timestamp)) - 8*3600 


----------------------------------------------------------------------------------------------------
---查询工作流核需闭环状态	
	select cr.chat_id ,cr.robot_id 
	,from_unixtime(cr.create_time+8*3600) as "加微时间" 
	, cr.conversation_template_id 
	,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid
	,(
			case when exists(
				select cd.id
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
				where cd.chat_id =cr.chat_id  
				and cd.check_type_code = '7!711!71102!919'
				and cd.reply ='核需完成'
				limit 1
			)  then '核需完成' else '其他' end 
		) as "工作流核需闭环状态"
	,
		(
			case when exists(
				select cb.id
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
				where cb.behavior_status =7 and cb.chat_id =cr.chat_id 
				limit 1
			)  then '暂停托管' else '非暂停托管' end 
		) as "托管类型"
	,${hivevar_transfer_manual_reason} 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
	where cr.deleted =0 and cr.strategy_scene =9
	and cr.create_time >=to_unixtime(cast ('2025-10-27 00:00:0' as timestamp)) - 8*3600 
----------------------------------------------------------------------------------------------------

---是否邀约成功 触发数据	
select cr.chat_id ,cr.robot_id 
,from_unixtime(cr.create_time+8*3600) as "加微时间" 
, cr.conversation_template_id 
,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid
,(
	case when exists(
	        select cd.id
	        from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
	        where cd.chat_id =cr.chat_id  
	        and cd.check_type_code = '7!711!71102!925'
	        and cd.reply ='是'
	        limit 1
	)  then '是' else '其他' end 
) as "是否邀约成功"
,
(
        case when exists(
                select cb.id
                from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
                where cb.behavior_status =7 and cb.chat_id =cr.chat_id 
                limit 1
        )  then '暂停托管' else '非暂停托管' end 
) as "托管类型"
,(
	case when exists (
		 	select cb.id
		 	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		 	where cb.chat_id =cr.chat_id 
		 	and cb.behavior_status in (13, 14)
		 	and cb.extend_info like '%BC类首次对话%'
		 	limit 1
	) then '进入' else '未进入' end 
) as "是否进入BC类首次对话互动环"
,t1.puttime as "首次分派时间"
,utd.invited_measuring_time as "邀约量房时间"
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join 
(
	SELECT 
    td.phone_id,from_unixtime(td.invited_measuring_time  +8*3600) as invited_measuring_time
	FROM hive2.ads.v_kudu2_stg_mid_t8t_mid_uc_uc_trace_demand td
	INNER JOIN (
	    SELECT 
	        phone_id, 
	        MAX(id) AS max_id
	    FROM hive2.ads.v_kudu2_stg_mid_t8t_mid_uc_uc_trace_demand 
	    WHERE user_type IN (3, 4)
	    GROUP BY phone_id
	) t_max ON td.phone_id = t_max.phone_id AND td.id = t_max.max_id
	WHERE td.user_type IN (3, 4)
	--测试
	--and td.phone_id =461168005
) utd on utd.phone_id = cast(json_extract_scalar(cr.extend_info , '$.phone_id') as integer)
left join 
(
	select f1.phone_id, from_unixtime(min(f4.puttime)  +8*3600) as puttime
	from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_contact f1 
	left join hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_project  f2 on f1.id = f2.con_id
	left join hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_demand f3 on f2.proj_id = f3.proj_id
	left join hive2.ads.v_kudu2_stg_crm_t8t_mid_proj_to8to_yuyue_apply_fp f4 on f3.dem_id = f4.yid and f4.gettype not in (33, 45, 48, 54)
	where f1.create_time >=to_unixtime(cast ('2025-11-05 00:00:0' as timestamp)) - 8*3600
	group by f1.phone_id  
) t1 on t1.phone_id =  cast(json_extract_scalar(cr.extend_info , '$.phone_id') as integer)
where cr.deleted =0 and cr.strategy_scene =9
and cr.create_time >=to_unixtime(cast ('2025-11-05 00:00:0' as timestamp)) - 8*3600 

        
        
      
        
        
        











select from_unixtime(cd.create_time+8*3600) as create_time,json_extract_scalar(cr.extend_info , '$.phone_id') as phoneid, cd.role_type 
, cd.check_type_code , sp.property_name ,cd.reply , cd.source_reply , cd.nlp_reply 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cd.chat_id =cr.chat_id 
left join hive2.ads.v_kudu2_stg_scm_t8t_scm_cfg_supply_property sp on cd.check_type_code =sp.whole_code 
where 
cd.reply != ''
and cd.check_type_code ='7!711!71102!852'
and cd.deleted =0
and cr.deleted =0
and cr.create_time >=to_unixtime(cast ('2025-10-20 00:00:0' as timestamp)) - 8*3600 
order by cd.id desc
limit 100















-- 统计每个用户接了多少互动环
select "电话id",chat_id,"机器人模版id","企微id","负责人","托管时间","托管环节","转人工时间时间","转人工原因"
,min(case when "事件类型"='互动环开始托管' then t."事件触发时间" else null end) as "进入互动环时间"
,min(case when "事件类型"='互动环结束托管' then t."事件触发时间" else null end) as "退出互动环时间"
,min(case when "事件类型"='结束托管' then t."事件触发时间" else null end) as "结束托管"
,min(t.puttime) as "首次分派时间"
from 
(
		select 
		cast(json_extract(cr.extend_info, '$.phone_id') as integer) as "电话id"
		,cr.chat_id 
		,cr.conversation_template_id as "机器人模版id"
		, cr.robot_id as "企微id"
		,(case
		            ---全流程测试
		            when cr.robot_id in ('16625270453') then '陈慧娜'
		            when cr.robot_id in ('16625109037') then '丁雄1'
					when cr.robot_id in ('82635937') then '熊壮3' 
					when cr.robot_id in ('24451249') then '杨茜2' 
					when cr.robot_id in ('16625562976') then '温著亮' 
					when cr.robot_id in ('13048861235') then '谢金华1' 
					when cr.robot_id in ('13246767295') then '邓梁健'
					when cr.robot_id in ('17840973392') then '李杜娟'
					when cr.robot_id in ('19146448842') then '谢金洪4'
					when cr.robot_id in ('18664323115') then '刘诗英1'
					when cr.robot_id in ('16625578275') then '马乘风1'
					when cr.robot_id in ('13434482149') then '吴新泽2'
					when cr.robot_id in ('13554705247') then '杨涵6'
					when cr.robot_id in ('699483') then '梁美琪1'
					when cr.robot_id in ('19075692593') then '吴新泽1'
					when cr.robot_id in ('17688798412') then '庄紫华1'
					when cr.robot_id in ('18529580742') then '杜豪杰'
					when cr.robot_id in ('13242001437') then '张秋凤1'
					when cr.robot_id in ('18566728546') then '钟功淏1'
					when cr.robot_id in ('10412106') then '杨涵5'
					when cr.robot_id in ('13249828259') then '丘国诚1'
					when cr.robot_id in ('13148704572') then '丘国诚2'
					when cr.robot_id in ('13554704583') then '钟功淏2'
					when cr.robot_id in ('837754') then '庄紫华2'
					when cr.robot_id in ('18680322157') then '梁美琪2'
					when cr.robot_id in ('18576433050') then '张秋凤2'					
		            --分派前小程序测试
					when cr.robot_id in ('15692452723') then '刘桂花22' 
					when cr.robot_id in ('13554702410') then '李代高2' 
		            when cr.robot_id in ('18126462094') then '杜俊杰2'
		            when cr.robot_id in ('18025377414') then '廖燊1'
					when cr.robot_id in ('13128944752') then '毛淦民1'
					when cr.robot_id in ('17620416642') then '李琪1' 
					when cr.robot_id in ('19076123613') then '谢金洪1' 
					when cr.robot_id in ('13554702410') then '李代高2' 
					when cr.robot_id in ('13168038263') then '叶泳霞7' 
					when cr.robot_id in ('18566766142') then '叶泳霞1' 
					when cr.robot_id in ('15692085226') then '叶泳霞2' 
					when cr.robot_id in ('13147076706') then '叶泳霞3' 
					when cr.robot_id in ('15626521492') then '叶泳霞8' 
					when cr.robot_id in ('17061708243') then '叶泳霞4' 
					when cr.robot_id in ('17061708274') then '叶泳霞5' 
					when cr.robot_id in ('17061708401') then '叶泳霞6' 
					when cr.robot_id in ('17061708004') then '樊毅12'
					when cr.robot_id in ('17061708044') then '樊毅13'
					when cr.robot_id in ('17180669523') then '樊毅14'
					when cr.robot_id in ('17180669514') then '樊毅15'
					when cr.robot_id in ('17061707649') then '樊毅2'
					when cr.robot_id in ('085472') then '陈聪2'
					when cr.robot_id in ('18165747834') then '陈聪5'
					when cr.robot_id in ('19811970735') then '陈聪3'
					when cr.robot_id in ('15946933592') then '陈聪10'
					when cr.robot_id in ('13479426754') then '陈聪8'
					when cr.robot_id in ('82650967') then '陈聪'
					when cr.robot_id in ('18665347660') then '陈聪6'
					when cr.robot_id in ('13237949237') then '黄日归7'
					when cr.robot_id in ('010450746') then '黄日归'
					when cr.robot_id in ('18566235546') then '樊毅7'
					when cr.robot_id in ('19076127294') then '黄日归6'
					when cr.robot_id in ('16625215716') then '樊毅11'
					when cr.robot_id in ('19065031581') then '黄日归5'
					when cr.robot_id in ('13554701934') then '黄日归8'
					when cr.robot_id in ('18512604206') then '林宸威2'
					when cr.robot_id in ('10346305') then '林培烽4'
					when cr.robot_id in ('13554701724') then '韦小宝2'
					when cr.robot_id in ('79081421') then '樊毅5'
					
					--朱伟组
					when cr.robot_id in ('13128719847') then '王迎迎1'
					when cr.robot_id in ('13148704572') then '陈会米'
					when cr.robot_id in ('13169912402') then '王松'
					when cr.robot_id in ('18529580742') then '杜豪杰'
					when cr.robot_id in ('10412106') then '杨涵5'
					when cr.robot_id in ('699483') then '梁美琪1'
					when cr.robot_id in ('19075692593') then '吴新泽1'
					when cr.robot_id in ('837754') then '汤少婷1'
					when cr.robot_id in ('13249828259') then '丘国诚1'
					when cr.robot_id in ('17688798412') then '庄紫华1'
					
					--梁欢组
					when cr.robot_id in ('17665461063') then '江欢1'
					when cr.robot_id in ('13172452820') then '周文倩1'
					when cr.robot_id in ('17675455136') then '陈木旺1'
					when cr.robot_id in ('17811634818') then '谢永利2'
					when cr.robot_id in ('10710392') then '曾丽娴2'
					when cr.robot_id in ('960021') then '李清燕'
					when cr.robot_id in ('18098960441') then '黄诗婷3'
					when cr.robot_id in ('13266858246') then '彭园娣4'
					when cr.robot_id in ('18129976364') then '杨媛1'
					
					--梁欢组
					when cr.robot_id in ('13554702743') then '刘域1'
					when cr.robot_id in ('18620319427') then '陈德斌1'
					when cr.robot_id in ('18033061704') then '钟裕平2'
					when cr.robot_id in ('19075697231') then '周珍妮1'
					when cr.robot_id in ('15692088753') then '谈丽2'
					when cr.robot_id in ('18682261781') then '张颖1'
					when cr.robot_id in ('18594242803') then '陈晓双1'
					when cr.robot_id in ('16675412543') then '罗文慧1'
					when cr.robot_id in ('15361422304') then '陈昊1'
		
		else '未找到' end ) as "负责人"
		,from_unixtime(cr.create_time+8*3600) as "托管时间"
		,json_extract(cb.extend_info, '$.currentSlot') as "托管环节"
		,from_unixtime(cr.staff_service_time +8*3600) as "转人工时间时间"
		, (case  when cr.transfer_manual_reason=0 then '会话中' when cr.transfer_manual_reason=1 then '主动取消' when cr.transfer_manual_reason=2 then '用户开口' when cr.transfer_manual_reason=3 then '用户拉黑删除好友' when cr.transfer_manual_reason=4 then '微联回调消息失败' when cr.transfer_manual_reason=5 then '用户超时无响应' when cr.transfer_manual_reason=6 then '回复内容不识别' when cr.transfer_manual_reason=7 then '话术流程结束' when cr.transfer_manual_reason=8 then '回复非文本内容不识别' when cr.transfer_manual_reason=9 then '调用素材中心接口失败' when cr.transfer_manual_reason=10 then '二次促开口，不满足跟进条件' when cr.transfer_manual_reason=11 then '无法识别用户回复意图' when cr.transfer_manual_reason=12 then '没有匹配到问题' when cr.transfer_manual_reason=13 then '槽位值归一失败' when cr.transfer_manual_reason=14 then '没找到话术调度策略' when cr.transfer_manual_reason=15 then '话术调度策略转人工' when cr.transfer_manual_reason=16 then '查找状态策略表级联超过了10次' when cr.transfer_manual_reason=17 then '转人工意图策略' when cr.transfer_manual_reason=18 then '顾问企微账号不再使用兔小智' when cr.transfer_manual_reason=19 then '项目状态已是已获权以上' when cr.transfer_manual_reason=20 then '模型调用失败' when cr.transfer_manual_reason=21 then '促开口配置错误' when cr.transfer_manual_reason=22 then '账号取消托管' when cr.transfer_manual_reason=23 then '槽位提问超过2次' when cr.transfer_manual_reason=24 then '达到闭环条件' when cr.transfer_manual_reason=25 then '公装' when cr.transfer_manual_reason=26 then '相同话术不允许重复发' when cr.transfer_manual_reason=27 then '待发送话术对应的槽位已经有值' when cr.transfer_manual_reason=28 then '特殊意图超过阈值' when cr.transfer_manual_reason=29 then '项目状态已是已获权以上，且用户开口' when cr.transfer_manual_reason=30 then '用户未开口' when cr.transfer_manual_reason=31 then '用户二次开口' when cr.transfer_manual_reason=32 then '三个月后交房[闭环]' when cr.transfer_manual_reason=33 then '主动取消-话术流程错误' when cr.transfer_manual_reason=34 then '主动取消-话术不恰当' when cr.transfer_manual_reason=35 then '顾问主动要求' when cr.transfer_manual_reason=36 then '顾问抢答或撤回消息' when cr.transfer_manual_reason=37 then '大模型兜底内容无法识别其意图' when cr.transfer_manual_reason=38 then '大模型兜底导致相同内容超过2次' when cr.transfer_manual_reason=39 then '系统未知异常' when cr.transfer_manual_reason=40 then '暂停托管次数超过阈值' when cr.transfer_manual_reason=41 then '无人工响应' when cr.transfer_manual_reason=42 then '暂停托管跟进超时' when cr.transfer_manual_reason=43 then '在职转接删除好友' when cr.transfer_manual_reason=44 then '结束跟进' when cr.transfer_manual_reason=45 then '规则查找超过20次' when cr.transfer_manual_reason=46 then '用户填写小程序卡' when cr.transfer_manual_reason=47 then '话术存在占位符' when cr.transfer_manual_reason=48 then '计算大模型兜底意向量房时间异常' when cr.transfer_manual_reason=49 then '大模型推荐转人工' when cr.transfer_manual_reason=50 then '话术流程结束-ABC闭环' when cr.transfer_manual_reason=51 then '根据话术条件查询失败' when cr.transfer_manual_reason=52 then '话术流程结束-发完姓氏闭环' when cr.transfer_manual_reason=53 then '审核编辑后，项目状态已是已获权以上'  when cr.transfer_manual_reason=54 then '用户超长时间后开口'  when cr.transfer_manual_reason=55 then '不满足大模型兜底条件-未交房'  when cr.transfer_manual_reason=56 then '不满足大模型兜底条件-在外地'  when cr.transfer_manual_reason=57 then '触发过年期间不可约量房时间'  when cr.transfer_manual_reason=58 then '提示语返回异常'  when cr.transfer_manual_reason=59 then '已签约，转人工'  when cr.transfer_manual_reason=101 then '开启会话失败' when cr.transfer_manual_reason=102 then '获取当前槽位失败' when cr.transfer_manual_reason=103 then '静默超时转人工挂机' when cr.transfer_manual_reason=104 then '用户出现负向意图-挂机' when cr.transfer_manual_reason=105 then '用户累计2次中性意图-挂机' when cr.transfer_manual_reason=106 then '用户表达不能操作1-挂机' when cr.transfer_manual_reason=107 then '会话调度流程结束-挂机' when cr.transfer_manual_reason=108 then '找不到对应的话术策略-挂机' when cr.transfer_manual_reason=109 then '加微操作未引导成功-挂机' when cr.transfer_manual_reason=110 then '收不到短信-挂机' when cr.transfer_manual_reason=111 then '短信加微操作未引导成功-挂机' when cr.transfer_manual_reason=112 then '结束语' when cr.transfer_manual_reason=113 then '用户表达不能操作2-挂机' when cr.transfer_manual_reason=114 then '用户辱骂-挂机' when cr.transfer_manual_reason=115 then '加微操作未引导成功1-挂机' when cr.transfer_manual_reason=116 then '用户表达不能操作3-挂机' when cr.transfer_manual_reason=117 then '用户主动挂机' when cr.transfer_manual_reason=108 then '找不到素材信息-挂机' when cr.transfer_manual_reason=119 then '前置话术-联系官网类-挂机' when cr.transfer_manual_reason=120 then '已匹配结束语' when cr.transfer_manual_reason=121 then '未匹配结束语' when cr.transfer_manual_reason=122 then '结束语-已转化' when cr.transfer_manual_reason=123 then '结束语-未转化' when cr.transfer_manual_reason=124 then '后续联系-结束语' else '未知' end )  as "转人工原因"
		, (case when cb.behavior_status = 1 then '请求'  when cb.behavior_status = 2 then '点击'  when cb.behavior_status = 3 then '回复'  when cb.behavior_status = 4 then '点击之后回复的内容'  when cb.behavior_status = 5 then '开始托管'  when cb.behavior_status = 6 then '结束托管'  when cb.behavior_status = 7 then '暂停托管'  when cb.behavior_status = 8 then '恢复托管'  when cb.behavior_status = 9 then '顾问采纳应答策略'  when cb.behavior_status = 10 then '顾问纠错应答策略'  when cb.behavior_status = 11 then '无人工响应'  when cb.behavior_status = 12 then '引用消息'  when cb.behavior_status = 13 then '互动环开始托管'  when cb.behavior_status = 14 then '互动环结束托管' else '其他' end) as "事件类型"
		,from_unixtime(cb.create_time+8*3600) as "事件触发时间"
		,t1.puttime 
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on cb.chat_id =cr.chat_id 
		left join 
		(
			select f1.phone_id, from_unixtime(min(f4.puttime)  +8*3600) as puttime
			from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_contact f1 
			left join hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_project  f2 on f1.id = f2.con_id
			left join hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_demand f3 on f2.proj_id = f3.proj_id
			left join hive2.ads.v_kudu2_stg_crm_t8t_mid_proj_to8to_yuyue_apply_fp f4 on f3.dem_id = f4.yid and f4.gettype not in (33, 45, 48, 54)
			where f1.create_time >=to_unixtime(cast ('2025-11-05 00:00:0' as timestamp)) - 8*3600
			group by f1.phone_id  
		) t1 on t1.phone_id =  cast(json_extract_scalar(cr.extend_info , '$.phone_id') as integer)
		where cr.robot_takeover_type =0
		and cr.strategy_scene =9
		and cr.deleted =0
		and cr.create_time >=to_unixtime(cast ('2025-10-23 21:00:0' as timestamp)) - 8*3600 
		and '' != regexp_extract(cr.extend_info , 'interactiveRingNameList')
		and json_array_length(json_extract(cr.extend_info, '$.interactiveRingNameList')) > 0
) t
group by "电话id",chat_id,"机器人模版id","企微id","负责人","托管时间","托管环节","转人工时间时间","转人工原因"





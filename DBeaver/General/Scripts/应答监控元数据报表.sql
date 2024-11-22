@set hivevar_smart_chat_dt = '20240331'
select ${hivevar_smart_chat_dt}

@set hivevar_array_conversation_template_id = 13, 20, 21, 26,33,35,36,37,38,45
select ${hivevar_array_conversation_template_id}


===========================================================================================================================

-----------------------机器人自闭环口径
select cr.chat_id 
,min(from_unixtime(cd.create_time+8*3600)) as create_time
,json_extract_scalar(min(cr.extend_info) , '$.phone_id') as phoneid
, min(case when cd.check_type_code='7!711!71102!1' then cd.reply end) as TIME1 --装修时间
, min(case when cd.check_type_code='7!711!71102!4' then cd.reply end) as HOUSE_TYPE --房屋类型
, min(case when cd.check_type_code='7!711!71102!3' then cd.reply end) as HOUSE_ADDRESS --小区名称
, min(case when cd.check_type_code='7!711!71102!2' then cd.reply end) as AREA --房屋面积
, min(case when cd.check_type_code='7!711!71102!6' then cd.reply end) as MEASUREMENT_TIME --意向量房时间
, min(case when cd.check_type_code='7!711!71102!22' then cd.reply end) as DECORATION_USE --装修用途
, min(case when cd.check_type_code='7!711!71102!20' then cd.reply end) as "是否交房" 
, min(case when cd.check_type_code='7!711!71102!8' then cd.reply end) as "工程量" 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd on cd.chat_id =cr.chat_id 
where cr.deleted =0
and cr.deleted =0
and cd.id  is not null
and cr.robot_takeover_type =0
--and cr.conversation_template_id =47
and cr.create_time >=to_unixtime(cast ('2024-05-01 00:00:0' as timestamp)) - 8*3600 
and cd.role_type =1
group by cr.chat_id 
;

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

-- 推荐次数  
select count(*) from 
(
	select chat_id,relate_message_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
	where behavior_status =1
	and cb.create_time >=to_unixtime(cast ('2023-12-01 00:00:0' as timestamp)) - 8*3600 
	and cb.create_time <to_unixtime(cast ('2023-12-20 00:00:0' as timestamp)) - 8*3600
	group by cb.chat_id, cb.relate_message_id 
) as temp

--- 点击次数	
select count(*) from 
(
	select chat_id,relate_message_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
	where behavior_status =2
	and cb.create_time >=to_unixtime(cast ('2023-12-01 00:00:0' as timestamp)) - 8*3600 
	and cb.create_time <to_unixtime(cast ('2023-12-20 00:00:0' as timestamp)) - 8*3600
	group by cb.chat_id, cb.relate_message_id 
) as temp

-- 采纳   
select count(*) from 
(
	select chat_id,relate_message_id 
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb
	where behavior_status =3
	and cb.create_time >=to_unixtime(cast ('2023-12-01 00:00:0' as timestamp)) - 8*3600 
	and cb.create_time <to_unixtime(cast ('2023-12-20 00:00:0' as timestamp)) - 8*3600
	group by cb.chat_id, cb.relate_message_id 
) as temp

--- 会话id-用户回复-推荐话术-顾问实际发送
select 
temp.id, temp.chat_id, temp.relate_message_id
, temp.user_reply_id
, temp.user_reply_text_content
, from_unixtime(temp.user_reply_create_time+8*3600) as user_reply_create_time
, temp.recommend_text_content
, from_unixtime(temp.recommend_create_time+8*3600) as recommend_create_time
, temp.weChat_next_id
, weChat_next_detail.text_content as actual_text_content
, from_unixtime(weChat_next_detail.create_time +8*3600) as actual_create_time
, ccr.extend_info 
, weChat_next_detail.id as weChat_next_detail_id
from 
(
	select 
	cb.id, cb1.chat_id, cb1.relate_message_id
	, user_reply.id as user_reply_id
	, user_reply.text_content as user_reply_text_content
	, user_reply.create_time as user_reply_create_time
	, qr.text_content as recommend_text_content
	, qr.create_time  as recommend_create_time
	, min(weChat_next.id) as weChat_next_id
	from 
	---先去除重复的推荐
	(
		select min(id) as id, chat_id,relate_message_id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior 
		where behavior_status =1
		and create_time >=to_unixtime(cast ('2023-12-01 00:00:0' as timestamp)) - 8*3600 
		and create_time <to_unixtime(cast ('2023-12-20 00:00:0' as timestamp)) - 8*3600
		group by chat_id,relate_message_id
	)  as cb
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_smart_chat_counselor_behavior cb1 on cb.id=cb1.id   
	---推荐话术内容
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr on cb1.recommend_message_id = qr.id 
	-- 用户回复的消息
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record user_reply 
	on cb1.relate_message_id = user_reply.answer_relate_message_id and user_reply.direction = 1 and user_reply.answer_relate_message_id !=''
	-- 承接用户回复之后，顾问回复的第一条话术  -- 行转列
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record weChat_next 
	on cb1.chat_id = weChat_next.chat_id and weChat_next.direction = 2 and weChat_next.send_time >= user_reply.send_time
	
	group by cb.id, cb1.chat_id, cb1.relate_message_id, user_reply.id, user_reply.text_content, user_reply.create_time , qr.text_content, qr.create_time 
) as temp
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record weChat_next_detail 
on temp.weChat_next_id = weChat_next_detail.id and weChat_next_detail.id is not null
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr on temp.chat_id = ccr.chat_id and ccr.deleted = 0 


=====================================================================================

-- 根据模板id，查询树形话术（不会级联）
 SELECT ct.id AS temp_id , ct.template_name as temp_name
 , rac.robot_ask_id AS temp_robot_ask_id, 
 (
	CASE cra1.check_type_code
	WHEN '7!711!71102!1' THEN '装修时间'  WHEN '7!711!71102!2' THEN '房屋面积'  WHEN '7!711!71102!3' THEN '小区名称'  WHEN '7!711!71102!4' THEN '房屋类型'  WHEN '7!711!71102!5' THEN '装修风格'  WHEN '7!711!71102!6' THEN '意向量房时间'  WHEN '7!711!71102!7' THEN '居住类型'  WHEN '7!711!71102!8' THEN '工程量'  WHEN '7!711!71102!9' THEN '街道'  WHEN '7!711!71102!10' THEN '区县'  WHEN '7!711!71102!11' THEN '姓氏'  WHEN '7!711!71102!12' THEN '是否全屋定制'  WHEN '7!711!71102!13' THEN '交房时间'  WHEN '7!711!71102!14' THEN '时间'  WHEN '7!711!71102!15' THEN '装修预算'  WHEN '7!711!71102!16' THEN '城市'  WHEN '7!711!71102!17' THEN '电话'  WHEN '7!711!71102!18' THEN '预约全屋定制'  WHEN '7!711!71102!19' THEN '硬装需求'  WHEN '7!711!71102!21' THEN '手机号'  WHEN '7!711!71102!22' THEN '装修用途'  WHEN '7!711!71102!23' THEN '外出回来时间'  WHEN '7!711!71102!24' THEN '工程量-只有局改空间'  WHEN '7!711!71102!25' THEN '工程量-只有局改详情'  WHEN '7!711!71102!26' THEN '工程量-缺少水电'  WHEN '7!711!71102!27' THEN '工程量-只做墙面'  WHEN '7!711!71102!28' THEN '工程量-非局改范围'  WHEN '7!711!71102!29' THEN '工程量-无空间和局改详情'  WHEN '7!711!71102!31' THEN '工程量-只有否定局改空间'  WHEN '7!711!71102!32' THEN '工程量-只有否定局改详情'  WHEN '7!711!71102!33' THEN '工程量-未识别到工程量'  WHEN '7!711!71102!30' THEN '房屋类型-自建房'  WHEN '7!711!71102!34' THEN '装修类型'  WHEN '7!711!71102!35' THEN '装修时间-三个月外'  WHEN '7!711!71102!36' THEN '量房时间-一个月外'  WHEN '7!711!71102!50' THEN '交房时间-三个月后交房'  WHEN '7!711!71102!40' THEN '地址追问-城市'  WHEN '7!711!71102!41' THEN '地址追问-城市澄清问'  WHEN '7!711!71102!42' THEN '地址追问-小区地址-农村自建房'  WHEN '7!711!71102!43' THEN '地址追问-小区地址-非农村自建房'  WHEN '7!711!71102!44' THEN '地址追问-小区地址-模糊楼盘'  WHEN '7!711!71102!45' THEN '地址追问-小区地址-收到户型图'  WHEN '7!711!71102!46' THEN '地址追问-小区地址-回复房屋信息'  WHEN '7!711!71102!47' THEN '地址追问-小区地址-咨询设计方案'  WHEN '7!711!71102!48' THEN '地址追问-小区地址-咨询报价'
	END
 ) AS temp_robot_ask_id_slot 
 , adr.intention_name AS intention, adr.aff_neg_intention_name AS aff_intention, adr.content AS default_reply, adr.relate_robot_ask_id AS relate_robot_ask_id, 
 (
	CASE cra2.check_type_code
	WHEN '7!711!71102!1' THEN '装修时间'  WHEN '7!711!71102!2' THEN '房屋面积'  WHEN '7!711!71102!3' THEN '小区名称'  WHEN '7!711!71102!4' THEN '房屋类型'  WHEN '7!711!71102!5' THEN '装修风格'  WHEN '7!711!71102!6' THEN '意向量房时间'  WHEN '7!711!71102!7' THEN '居住类型'  WHEN '7!711!71102!8' THEN '工程量'  WHEN '7!711!71102!9' THEN '街道'  WHEN '7!711!71102!10' THEN '区县'  WHEN '7!711!71102!11' THEN '姓氏'  WHEN '7!711!71102!12' THEN '是否全屋定制'  WHEN '7!711!71102!13' THEN '交房时间'  WHEN '7!711!71102!14' THEN '时间'  WHEN '7!711!71102!15' THEN '装修预算'  WHEN '7!711!71102!16' THEN '城市'  WHEN '7!711!71102!17' THEN '电话'  WHEN '7!711!71102!18' THEN '预约全屋定制'  WHEN '7!711!71102!19' THEN '硬装需求'  WHEN '7!711!71102!21' THEN '手机号'  WHEN '7!711!71102!22' THEN '装修用途'  WHEN '7!711!71102!23' THEN '外出回来时间'  WHEN '7!711!71102!24' THEN '工程量-只有局改空间'  WHEN '7!711!71102!25' THEN '工程量-只有局改详情'  WHEN '7!711!71102!26' THEN '工程量-缺少水电'  WHEN '7!711!71102!27' THEN '工程量-只做墙面'  WHEN '7!711!71102!28' THEN '工程量-非局改范围'  WHEN '7!711!71102!29' THEN '工程量-无空间和局改详情'  WHEN '7!711!71102!31' THEN '工程量-只有否定局改空间'  WHEN '7!711!71102!32' THEN '工程量-只有否定局改详情'  WHEN '7!711!71102!33' THEN '工程量-未识别到工程量'  WHEN '7!711!71102!30' THEN '房屋类型-自建房'  WHEN '7!711!71102!34' THEN '装修类型'  WHEN '7!711!71102!35' THEN '装修时间-三个月外'  WHEN '7!711!71102!36' THEN '量房时间-一个月外'  WHEN '7!711!71102!50' THEN '交房时间-三个月后交房'  WHEN '7!711!71102!40' THEN '地址追问-城市'  WHEN '7!711!71102!41' THEN '地址追问-城市澄清问'  WHEN '7!711!71102!42' THEN '地址追问-小区地址-农村自建房'  WHEN '7!711!71102!43' THEN '地址追问-小区地址-非农村自建房'  WHEN '7!711!71102!44' THEN '地址追问-小区地址-模糊楼盘'  WHEN '7!711!71102!45' THEN '地址追问-小区地址-收到户型图'  WHEN '7!711!71102!46' THEN '地址追问-小区地址-回复房屋信息'  WHEN '7!711!71102!47' THEN '地址追问-小区地址-咨询设计方案'  WHEN '7!711!71102!48' THEN '地址追问-小区地址-咨询报价'
	END
 ) AS relate_robot_ask_id_slot
 FROM hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_conversation_template ct 
 LEFT JOIN  hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_conversation_robot_ask_config rac ON ct.id=rac.conversation_template_id
 LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra1 ON cra1.id= rac.robot_ask_id
 LEFT JOIN hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr ON adr.robot_ask_id=rac.robot_ask_id
 LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
 WHERE ct.id= 36
 ORDER BY ct.id  DESC , rac.robot_ask_id asc
 ;


----  根据话术模板id，级联查询所有的话术
@set var_relate_template_id = 47

(
	select cra1.id as "话术id"
	,cra1.check_type_code 
	,(
		CASE cra1.check_type_code
		WHEN '7!711!71102!0' THEN '默认填充编码'  WHEN '7!711!71102!1' THEN '装修时间'  WHEN '7!711!71102!2' THEN '房屋面积'  WHEN '7!711!71102!3' THEN '小区名称'  WHEN '7!711!71102!4' THEN '房屋类型'  WHEN '7!711!71102!5' THEN '装修风格'  WHEN '7!711!71102!6' THEN '意向量房时间'  WHEN '7!711!71102!7' THEN '居住类型'  WHEN '7!711!71102!8' THEN '工程量'  WHEN '7!711!71102!9' THEN '街道'  WHEN '7!711!71102!10' THEN '区县'  WHEN '7!711!71102!11' THEN '姓氏'  WHEN '7!711!71102!12' THEN '是否全屋定制'  WHEN '7!711!71102!13' THEN '交房时间'  WHEN '7!711!71102!14' THEN '时间'  WHEN '7!711!71102!15' THEN '装修预算'  WHEN '7!711!71102!16' THEN '城市'  WHEN '7!711!71102!17' THEN '电话'  WHEN '7!711!71102!18' THEN '预约全屋定制'  WHEN '7!711!71102!19' THEN '硬装需求'  WHEN '7!711!71102!21' THEN '手机号'  WHEN '7!711!71102!22' THEN '装修用途'  WHEN '7!711!71102!23' THEN '外出回来时间'  WHEN '7!711!71102!24' THEN '工程量-只有局改空间'  WHEN '7!711!71102!25' THEN '工程量-只有局改详情'  WHEN '7!711!71102!26' THEN '工程量-缺少水电'  WHEN '7!711!71102!27' THEN '工程量-只做墙面'  WHEN '7!711!71102!28' THEN '工程量-非局改范围'  WHEN '7!711!71102!29' THEN '工程量-无空间和局改详情'  WHEN '7!711!71102!31' THEN '工程量-只有否定局改空间'  WHEN '7!711!71102!32' THEN '工程量-只有否定局改详情'  WHEN '7!711!71102!33' THEN '工程量-未识别到工程量'  WHEN '7!711!71102!37' THEN '工程量-已有'  WHEN '7!711!71102!68' THEN '工程量-图核工程量'  WHEN '7!711!71102!70' THEN '工程量-否定意图追问'  WHEN '7!711!71102!34' THEN '装修类型'  WHEN '7!711!71102!35' THEN '装修时间-三个月外'  WHEN '7!711!71102!36' THEN '量房时间-一个月外'  WHEN '7!711!71102!50' THEN '交房时间-三个月后交房'  WHEN '7!711!71102!60' THEN '房屋类型-局改'  WHEN '7!711!71102!30' THEN '房屋类型-自建房'  WHEN '7!711!71102!61' THEN '房屋类型-新房'  WHEN '7!711!71102!62' THEN '房屋类型-精装房'  WHEN '7!711!71102!63' THEN '房屋类型-毛坯出租'  WHEN '7!711!71102!64' THEN '房屋类型-精装'  WHEN '7!711!71102!65' THEN '房屋类型-追问1'  WHEN '7!711!71102!66' THEN '房屋类型-追问2'  WHEN '7!711!71102!67' THEN '房屋类型-澄清槽位值'  WHEN '7!711!71102!73' THEN '反向-房屋类型'  WHEN '7!711!71102!40' THEN '地址追问-城市'  WHEN '7!711!71102!41' THEN '地址追问-城市澄清问'  WHEN '7!711!71102!42' THEN '地址追问-小区地址-农村自建房'  WHEN '7!711!71102!43' THEN '地址追问-小区地址-非农村自建房'  WHEN '7!711!71102!44' THEN '地址追问-小区地址-模糊楼盘'  WHEN '7!711!71102!45' THEN '地址追问-小区地址-收到户型图'  WHEN '7!711!71102!46' THEN '地址追问-小区地址-回复房屋信息'  WHEN '7!711!71102!47' THEN '地址追问-小区地址-咨询设计方案'  WHEN '7!711!71102!48' THEN '地址追问-小区地址-咨询报价'  WHEN '7!711!71102!71' THEN '填充话术-农村自建房-追问小区地址话术'  WHEN '7!711!71102!72' THEN '填充话术-有城市无小区地址-追问小区地址话术'  WHEN '7!711!71102!74' THEN '填充话术-旧房翻新-替换交房时间话术'  WHEN '7!711!71102!77' THEN '填充话术-装修时间-带槽位开场白场景替换话术'  WHEN '7!711!71102!53' THEN '正问装修时间'  WHEN '7!711!71102!51' THEN '反问装修时间'  WHEN '7!711!71102!52' THEN '询问装修时间'  WHEN '7!711!71102!54' THEN '开场白-澄清槽位'  WHEN '7!711!71102!55' THEN '开场白-澄清槽位-房屋类型'  WHEN '7!711!71102!56' THEN '开场白-澄清槽位-城市'  WHEN '7!711!71102!57' THEN '开场白-澄清槽位-房屋面积'  WHEN '7!711!71102!58' THEN '开场白-澄清槽位-装修用途'  WHEN '7!711!71102!59' THEN '开场白-澄清槽位-装修时间'  WHEN '7!711!71102!69' THEN '开场白-澄清槽位-超时促开口话术'  WHEN '7!711!71102!201' THEN '性别'  WHEN '7!711!71102!202' THEN '交房类型'  WHEN '7!711!71102!203' THEN '到店时间'  WHEN '7!711!71102!204' THEN '房屋用途'  WHEN '7!711!71102!212' THEN '量房时间'  WHEN '7!711!71102!214' THEN '小区地址'  WHEN '7!711!71102!300' THEN '同步项目信息'  WHEN '7!711!71102!205' THEN '是否毛坯'  WHEN '7!711!71102!206' THEN '是否精装房'  WHEN '7!711!71102!207' THEN '是否自建房'  WHEN '7!711!71102!208' THEN '工程项'  WHEN '7!711!71102!209' THEN '工程空间'  WHEN '7!711!71102!210' THEN '已做工程项'  WHEN '7!711!71102!211' THEN '待做工程项'  WHEN '7!711!71102!213' THEN '虚拟房屋类型'  
		END
	 )  as "话术槽位" 
	,(
		select array_join(array_agg(cast(dcc.delay_time as varchar) ||'--'||dcc.content order by dcc.delay_time asc), '
		')
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
		where dcc.scene =3 and dcc.relate_id =cra1.id 
		group by dcc.relate_id
	)  as "话术内容：【延迟时间】-【话术内容】" 
	,
	case when exists (
				select dcc.relate_id
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
				left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
				on cra.id =dcc.relate_id
				where dcc.relate_id  = cra1.id
				and dcc.scene =5 
		)
	then  
	(
		select array_join(array_agg(cast(coalesce(dcc.delay_time, 0) as varchar) ||'--'||dcc.content order by dcc.delay_time asc), '
		')
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
		where dcc.scene =5 and dcc.relate_id =cra1.id 
		group by dcc.relate_id
	) 	
	end 
	as "用户超时无响应后的话术：【延迟时间】-【话术内容】" 
	,adr.intention_name as "用户回复文本分类--意图"
	,adr.aff_neg_intention_name  as "用户回复肯否意图"
	,adr.content  as "用户回复内容--归一后的结果"
	,adr.relate_robot_ask_id as "关联话术id"
	,cra2.check_type_code 
	,(
		CASE cra2.check_type_code
		WHEN '7!711!71102!0' THEN '默认填充编码'  WHEN '7!711!71102!1' THEN '装修时间'  WHEN '7!711!71102!2' THEN '房屋面积'  WHEN '7!711!71102!3' THEN '小区名称'  WHEN '7!711!71102!4' THEN '房屋类型'  WHEN '7!711!71102!5' THEN '装修风格'  WHEN '7!711!71102!6' THEN '意向量房时间'  WHEN '7!711!71102!7' THEN '居住类型'  WHEN '7!711!71102!8' THEN '工程量'  WHEN '7!711!71102!9' THEN '街道'  WHEN '7!711!71102!10' THEN '区县'  WHEN '7!711!71102!11' THEN '姓氏'  WHEN '7!711!71102!12' THEN '是否全屋定制'  WHEN '7!711!71102!13' THEN '交房时间'  WHEN '7!711!71102!14' THEN '时间'  WHEN '7!711!71102!15' THEN '装修预算'  WHEN '7!711!71102!16' THEN '城市'  WHEN '7!711!71102!17' THEN '电话'  WHEN '7!711!71102!18' THEN '预约全屋定制'  WHEN '7!711!71102!19' THEN '硬装需求'  WHEN '7!711!71102!21' THEN '手机号'  WHEN '7!711!71102!22' THEN '装修用途'  WHEN '7!711!71102!23' THEN '外出回来时间'  WHEN '7!711!71102!24' THEN '工程量-只有局改空间'  WHEN '7!711!71102!25' THEN '工程量-只有局改详情'  WHEN '7!711!71102!26' THEN '工程量-缺少水电'  WHEN '7!711!71102!27' THEN '工程量-只做墙面'  WHEN '7!711!71102!28' THEN '工程量-非局改范围'  WHEN '7!711!71102!29' THEN '工程量-无空间和局改详情'  WHEN '7!711!71102!31' THEN '工程量-只有否定局改空间'  WHEN '7!711!71102!32' THEN '工程量-只有否定局改详情'  WHEN '7!711!71102!33' THEN '工程量-未识别到工程量'  WHEN '7!711!71102!37' THEN '工程量-已有'  WHEN '7!711!71102!68' THEN '工程量-图核工程量'  WHEN '7!711!71102!70' THEN '工程量-否定意图追问'  WHEN '7!711!71102!34' THEN '装修类型'  WHEN '7!711!71102!35' THEN '装修时间-三个月外'  WHEN '7!711!71102!36' THEN '量房时间-一个月外'  WHEN '7!711!71102!50' THEN '交房时间-三个月后交房'  WHEN '7!711!71102!60' THEN '房屋类型-局改'  WHEN '7!711!71102!30' THEN '房屋类型-自建房'  WHEN '7!711!71102!61' THEN '房屋类型-新房'  WHEN '7!711!71102!62' THEN '房屋类型-精装房'  WHEN '7!711!71102!63' THEN '房屋类型-毛坯出租'  WHEN '7!711!71102!64' THEN '房屋类型-精装'  WHEN '7!711!71102!65' THEN '房屋类型-追问1'  WHEN '7!711!71102!66' THEN '房屋类型-追问2'  WHEN '7!711!71102!67' THEN '房屋类型-澄清槽位值'  WHEN '7!711!71102!73' THEN '反向-房屋类型'  WHEN '7!711!71102!40' THEN '地址追问-城市'  WHEN '7!711!71102!41' THEN '地址追问-城市澄清问'  WHEN '7!711!71102!42' THEN '地址追问-小区地址-农村自建房'  WHEN '7!711!71102!43' THEN '地址追问-小区地址-非农村自建房'  WHEN '7!711!71102!44' THEN '地址追问-小区地址-模糊楼盘'  WHEN '7!711!71102!45' THEN '地址追问-小区地址-收到户型图'  WHEN '7!711!71102!46' THEN '地址追问-小区地址-回复房屋信息'  WHEN '7!711!71102!47' THEN '地址追问-小区地址-咨询设计方案'  WHEN '7!711!71102!48' THEN '地址追问-小区地址-咨询报价'  WHEN '7!711!71102!71' THEN '填充话术-农村自建房-追问小区地址话术'  WHEN '7!711!71102!72' THEN '填充话术-有城市无小区地址-追问小区地址话术'  WHEN '7!711!71102!74' THEN '填充话术-旧房翻新-替换交房时间话术'  WHEN '7!711!71102!77' THEN '填充话术-装修时间-带槽位开场白场景替换话术'  WHEN '7!711!71102!53' THEN '正问装修时间'  WHEN '7!711!71102!51' THEN '反问装修时间'  WHEN '7!711!71102!52' THEN '询问装修时间'  WHEN '7!711!71102!54' THEN '开场白-澄清槽位'  WHEN '7!711!71102!55' THEN '开场白-澄清槽位-房屋类型'  WHEN '7!711!71102!56' THEN '开场白-澄清槽位-城市'  WHEN '7!711!71102!57' THEN '开场白-澄清槽位-房屋面积'  WHEN '7!711!71102!58' THEN '开场白-澄清槽位-装修用途'  WHEN '7!711!71102!59' THEN '开场白-澄清槽位-装修时间'  WHEN '7!711!71102!69' THEN '开场白-澄清槽位-超时促开口话术'  WHEN '7!711!71102!201' THEN '性别'  WHEN '7!711!71102!202' THEN '交房类型'  WHEN '7!711!71102!203' THEN '到店时间'  WHEN '7!711!71102!204' THEN '房屋用途'  WHEN '7!711!71102!212' THEN '量房时间'  WHEN '7!711!71102!214' THEN '小区地址'  WHEN '7!711!71102!300' THEN '同步项目信息'  WHEN '7!711!71102!205' THEN '是否毛坯'  WHEN '7!711!71102!206' THEN '是否精装房'  WHEN '7!711!71102!207' THEN '是否自建房'  WHEN '7!711!71102!208' THEN '工程项'  WHEN '7!711!71102!209' THEN '工程空间'  WHEN '7!711!71102!210' THEN '已做工程项'  WHEN '7!711!71102!211' THEN '待做工程项'  WHEN '7!711!71102!213' THEN '虚拟房屋类型'  
		END
	 )  as "关联槽位"  
	from 
	hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra1
	LEFT JOIN hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr ON cra1.id= adr.robot_ask_id 
	LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
	where cra1.id in 
	(
		select distinct id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
		where cra.relate_template_id =${var_relate_template_id} 
		order by id asc
	)
) 
union 
(
	select cra1.id as "话术id"
	,cra1.check_type_code 
	,(
		CASE cra1.check_type_code
		WHEN '7!711!71102!0' THEN '默认填充编码'  WHEN '7!711!71102!1' THEN '装修时间'  WHEN '7!711!71102!2' THEN '房屋面积'  WHEN '7!711!71102!3' THEN '小区名称'  WHEN '7!711!71102!4' THEN '房屋类型'  WHEN '7!711!71102!5' THEN '装修风格'  WHEN '7!711!71102!6' THEN '意向量房时间'  WHEN '7!711!71102!7' THEN '居住类型'  WHEN '7!711!71102!8' THEN '工程量'  WHEN '7!711!71102!9' THEN '街道'  WHEN '7!711!71102!10' THEN '区县'  WHEN '7!711!71102!11' THEN '姓氏'  WHEN '7!711!71102!12' THEN '是否全屋定制'  WHEN '7!711!71102!13' THEN '交房时间'  WHEN '7!711!71102!14' THEN '时间'  WHEN '7!711!71102!15' THEN '装修预算'  WHEN '7!711!71102!16' THEN '城市'  WHEN '7!711!71102!17' THEN '电话'  WHEN '7!711!71102!18' THEN '预约全屋定制'  WHEN '7!711!71102!19' THEN '硬装需求'  WHEN '7!711!71102!21' THEN '手机号'  WHEN '7!711!71102!22' THEN '装修用途'  WHEN '7!711!71102!23' THEN '外出回来时间'  WHEN '7!711!71102!24' THEN '工程量-只有局改空间'  WHEN '7!711!71102!25' THEN '工程量-只有局改详情'  WHEN '7!711!71102!26' THEN '工程量-缺少水电'  WHEN '7!711!71102!27' THEN '工程量-只做墙面'  WHEN '7!711!71102!28' THEN '工程量-非局改范围'  WHEN '7!711!71102!29' THEN '工程量-无空间和局改详情'  WHEN '7!711!71102!31' THEN '工程量-只有否定局改空间'  WHEN '7!711!71102!32' THEN '工程量-只有否定局改详情'  WHEN '7!711!71102!33' THEN '工程量-未识别到工程量'  WHEN '7!711!71102!37' THEN '工程量-已有'  WHEN '7!711!71102!68' THEN '工程量-图核工程量'  WHEN '7!711!71102!70' THEN '工程量-否定意图追问'  WHEN '7!711!71102!34' THEN '装修类型'  WHEN '7!711!71102!35' THEN '装修时间-三个月外'  WHEN '7!711!71102!36' THEN '量房时间-一个月外'  WHEN '7!711!71102!50' THEN '交房时间-三个月后交房'  WHEN '7!711!71102!60' THEN '房屋类型-局改'  WHEN '7!711!71102!30' THEN '房屋类型-自建房'  WHEN '7!711!71102!61' THEN '房屋类型-新房'  WHEN '7!711!71102!62' THEN '房屋类型-精装房'  WHEN '7!711!71102!63' THEN '房屋类型-毛坯出租'  WHEN '7!711!71102!64' THEN '房屋类型-精装'  WHEN '7!711!71102!65' THEN '房屋类型-追问1'  WHEN '7!711!71102!66' THEN '房屋类型-追问2'  WHEN '7!711!71102!67' THEN '房屋类型-澄清槽位值'  WHEN '7!711!71102!73' THEN '反向-房屋类型'  WHEN '7!711!71102!40' THEN '地址追问-城市'  WHEN '7!711!71102!41' THEN '地址追问-城市澄清问'  WHEN '7!711!71102!42' THEN '地址追问-小区地址-农村自建房'  WHEN '7!711!71102!43' THEN '地址追问-小区地址-非农村自建房'  WHEN '7!711!71102!44' THEN '地址追问-小区地址-模糊楼盘'  WHEN '7!711!71102!45' THEN '地址追问-小区地址-收到户型图'  WHEN '7!711!71102!46' THEN '地址追问-小区地址-回复房屋信息'  WHEN '7!711!71102!47' THEN '地址追问-小区地址-咨询设计方案'  WHEN '7!711!71102!48' THEN '地址追问-小区地址-咨询报价'  WHEN '7!711!71102!71' THEN '填充话术-农村自建房-追问小区地址话术'  WHEN '7!711!71102!72' THEN '填充话术-有城市无小区地址-追问小区地址话术'  WHEN '7!711!71102!74' THEN '填充话术-旧房翻新-替换交房时间话术'  WHEN '7!711!71102!77' THEN '填充话术-装修时间-带槽位开场白场景替换话术'  WHEN '7!711!71102!53' THEN '正问装修时间'  WHEN '7!711!71102!51' THEN '反问装修时间'  WHEN '7!711!71102!52' THEN '询问装修时间'  WHEN '7!711!71102!54' THEN '开场白-澄清槽位'  WHEN '7!711!71102!55' THEN '开场白-澄清槽位-房屋类型'  WHEN '7!711!71102!56' THEN '开场白-澄清槽位-城市'  WHEN '7!711!71102!57' THEN '开场白-澄清槽位-房屋面积'  WHEN '7!711!71102!58' THEN '开场白-澄清槽位-装修用途'  WHEN '7!711!71102!59' THEN '开场白-澄清槽位-装修时间'  WHEN '7!711!71102!69' THEN '开场白-澄清槽位-超时促开口话术'  WHEN '7!711!71102!201' THEN '性别'  WHEN '7!711!71102!202' THEN '交房类型'  WHEN '7!711!71102!203' THEN '到店时间'  WHEN '7!711!71102!204' THEN '房屋用途'  WHEN '7!711!71102!212' THEN '量房时间'  WHEN '7!711!71102!214' THEN '小区地址'  WHEN '7!711!71102!300' THEN '同步项目信息'  WHEN '7!711!71102!205' THEN '是否毛坯'  WHEN '7!711!71102!206' THEN '是否精装房'  WHEN '7!711!71102!207' THEN '是否自建房'  WHEN '7!711!71102!208' THEN '工程项'  WHEN '7!711!71102!209' THEN '工程空间'  WHEN '7!711!71102!210' THEN '已做工程项'  WHEN '7!711!71102!211' THEN '待做工程项'  WHEN '7!711!71102!213' THEN '虚拟房屋类型'  
		END
	 )  as "话术槽位" 
	,(
		select array_join(array_agg(cast(dcc.delay_time as varchar) ||'--'||dcc.content order by dcc.delay_time asc), '
		')
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
		where dcc.scene =3 and dcc.relate_id =cra1.id 
		group by dcc.relate_id
	)  as "话术内容：【延迟时间】-【话术内容】"  
	,'没配置无响应话术' as "用户超时无响应后的话术：【延迟时间】-【话术内容】" 
	,adr.intention_name as "用户回复文本分类--意图"
	,adr.aff_neg_intention_name  as "用户回复肯否意图"
	,adr.content  as "用户回复内容--归一后的结果"
	,adr.relate_robot_ask_id as "关联话术id"
	,cra2.check_type_code 
	,(
		CASE cra2.check_type_code
		WHEN '7!711!71102!0' THEN '默认填充编码'  WHEN '7!711!71102!1' THEN '装修时间'  WHEN '7!711!71102!2' THEN '房屋面积'  WHEN '7!711!71102!3' THEN '小区名称'  WHEN '7!711!71102!4' THEN '房屋类型'  WHEN '7!711!71102!5' THEN '装修风格'  WHEN '7!711!71102!6' THEN '意向量房时间'  WHEN '7!711!71102!7' THEN '居住类型'  WHEN '7!711!71102!8' THEN '工程量'  WHEN '7!711!71102!9' THEN '街道'  WHEN '7!711!71102!10' THEN '区县'  WHEN '7!711!71102!11' THEN '姓氏'  WHEN '7!711!71102!12' THEN '是否全屋定制'  WHEN '7!711!71102!13' THEN '交房时间'  WHEN '7!711!71102!14' THEN '时间'  WHEN '7!711!71102!15' THEN '装修预算'  WHEN '7!711!71102!16' THEN '城市'  WHEN '7!711!71102!17' THEN '电话'  WHEN '7!711!71102!18' THEN '预约全屋定制'  WHEN '7!711!71102!19' THEN '硬装需求'  WHEN '7!711!71102!21' THEN '手机号'  WHEN '7!711!71102!22' THEN '装修用途'  WHEN '7!711!71102!23' THEN '外出回来时间'  WHEN '7!711!71102!24' THEN '工程量-只有局改空间'  WHEN '7!711!71102!25' THEN '工程量-只有局改详情'  WHEN '7!711!71102!26' THEN '工程量-缺少水电'  WHEN '7!711!71102!27' THEN '工程量-只做墙面'  WHEN '7!711!71102!28' THEN '工程量-非局改范围'  WHEN '7!711!71102!29' THEN '工程量-无空间和局改详情'  WHEN '7!711!71102!31' THEN '工程量-只有否定局改空间'  WHEN '7!711!71102!32' THEN '工程量-只有否定局改详情'  WHEN '7!711!71102!33' THEN '工程量-未识别到工程量'  WHEN '7!711!71102!37' THEN '工程量-已有'  WHEN '7!711!71102!68' THEN '工程量-图核工程量'  WHEN '7!711!71102!70' THEN '工程量-否定意图追问'  WHEN '7!711!71102!34' THEN '装修类型'  WHEN '7!711!71102!35' THEN '装修时间-三个月外'  WHEN '7!711!71102!36' THEN '量房时间-一个月外'  WHEN '7!711!71102!50' THEN '交房时间-三个月后交房'  WHEN '7!711!71102!60' THEN '房屋类型-局改'  WHEN '7!711!71102!30' THEN '房屋类型-自建房'  WHEN '7!711!71102!61' THEN '房屋类型-新房'  WHEN '7!711!71102!62' THEN '房屋类型-精装房'  WHEN '7!711!71102!63' THEN '房屋类型-毛坯出租'  WHEN '7!711!71102!64' THEN '房屋类型-精装'  WHEN '7!711!71102!65' THEN '房屋类型-追问1'  WHEN '7!711!71102!66' THEN '房屋类型-追问2'  WHEN '7!711!71102!67' THEN '房屋类型-澄清槽位值'  WHEN '7!711!71102!73' THEN '反向-房屋类型'  WHEN '7!711!71102!40' THEN '地址追问-城市'  WHEN '7!711!71102!41' THEN '地址追问-城市澄清问'  WHEN '7!711!71102!42' THEN '地址追问-小区地址-农村自建房'  WHEN '7!711!71102!43' THEN '地址追问-小区地址-非农村自建房'  WHEN '7!711!71102!44' THEN '地址追问-小区地址-模糊楼盘'  WHEN '7!711!71102!45' THEN '地址追问-小区地址-收到户型图'  WHEN '7!711!71102!46' THEN '地址追问-小区地址-回复房屋信息'  WHEN '7!711!71102!47' THEN '地址追问-小区地址-咨询设计方案'  WHEN '7!711!71102!48' THEN '地址追问-小区地址-咨询报价'  WHEN '7!711!71102!71' THEN '填充话术-农村自建房-追问小区地址话术'  WHEN '7!711!71102!72' THEN '填充话术-有城市无小区地址-追问小区地址话术'  WHEN '7!711!71102!74' THEN '填充话术-旧房翻新-替换交房时间话术'  WHEN '7!711!71102!77' THEN '填充话术-装修时间-带槽位开场白场景替换话术'  WHEN '7!711!71102!53' THEN '正问装修时间'  WHEN '7!711!71102!51' THEN '反问装修时间'  WHEN '7!711!71102!52' THEN '询问装修时间'  WHEN '7!711!71102!54' THEN '开场白-澄清槽位'  WHEN '7!711!71102!55' THEN '开场白-澄清槽位-房屋类型'  WHEN '7!711!71102!56' THEN '开场白-澄清槽位-城市'  WHEN '7!711!71102!57' THEN '开场白-澄清槽位-房屋面积'  WHEN '7!711!71102!58' THEN '开场白-澄清槽位-装修用途'  WHEN '7!711!71102!59' THEN '开场白-澄清槽位-装修时间'  WHEN '7!711!71102!69' THEN '开场白-澄清槽位-超时促开口话术'  WHEN '7!711!71102!201' THEN '性别'  WHEN '7!711!71102!202' THEN '交房类型'  WHEN '7!711!71102!203' THEN '到店时间'  WHEN '7!711!71102!204' THEN '房屋用途'  WHEN '7!711!71102!212' THEN '量房时间'  WHEN '7!711!71102!214' THEN '小区地址'  WHEN '7!711!71102!300' THEN '同步项目信息'  WHEN '7!711!71102!205' THEN '是否毛坯'  WHEN '7!711!71102!206' THEN '是否精装房'  WHEN '7!711!71102!207' THEN '是否自建房'  WHEN '7!711!71102!208' THEN '工程项'  WHEN '7!711!71102!209' THEN '工程空间'  WHEN '7!711!71102!210' THEN '已做工程项'  WHEN '7!711!71102!211' THEN '待做工程项'  WHEN '7!711!71102!213' THEN '虚拟房屋类型'  
		END
	 )  as "关联槽位" 
	from 
	hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra1
	LEFT JOIN hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr ON cra1.id= adr.robot_ask_id 
	LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
	where cra1.relate_template_id = ${var_relate_template_id}
	and cra1.id not in 
	(
				select dcc.relate_id
				from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
				left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
				on cra.id =dcc.relate_id
				where dcc.relate_id  = cra1.id
				and dcc.scene =5 
	)
) 
order by "话术id" asc, "关联话术id" asc;



-- 没有配置无响应话术的话术id
@set var_relate_template_id = 35
	select dcc.relate_id
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
	on cra.id =dcc.relate_id
	where cra.relate_template_id = ${var_relate_template_id}
	and dcc.relate_id not in(
		select dcc.relate_id
		from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
		left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
		on cra.id =dcc.relate_id
		where cra.relate_template_id = ${var_relate_template_id}
		and dcc.scene =5 
	)
	
--- 顾问有效托管信息
===================================
@set hivevar_smart_chat_dt = '20240331'
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
			and (conversation_template_id in (${hivevar_array_conversation_template_id}) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (${hivevar_array_conversation_template_id}))
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
			

		--where create_time >= 1708185600 and create_time <1709049600 -- TODO 就取近期的数据
		where create_time >=to_unixtime(cast ('2024-03-30 00:00:0' as timestamp)) - 8*3600 
		and create_time < to_unixtime(cast ('2024-04-01 00:00:0' as timestamp)) - 8*3600 
		
		
		
		and ccr.uid = 'wmJiIbDAAABBeaG87WdPUslJNJDz6xOA'
		and ccr.robot_id = '19811976159'


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
		and (conversation_template_id in (${hivevar_array_conversation_template_id}) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (${hivevar_array_conversation_template_id}))
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



---------------  基于单个会话维度的报表  TODO  还未完工

select t1.*
, case  
	when t2.fisrt_robot_msg_send_time=0 then 0
	when t1.staff_service_time > t2.fisrt_robot_msg_send_time  then 1 else 0  end  as valid_takeover_total  --1：有效托管 0：无效托管
from 
(-- 总的托管用户基表
			select ccr1.chat_id 
			, ccr1.robot_id 
			, ccr1.uid
			,json_extract_scalar(ccr1.extend_info , '$.phone_id') as phone_id
			,create_time
			, getday(create_time) as format_create_time
			, staff_service_time
			from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
			where ccr1.dt =${hivevar_smart_chat_dt} 
			and ccr1.robot_takeover_type =0 
			and ccr1.deleted =0
			and (conversation_template_id in (${hivevar_array_conversation_template_id}) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (${hivevar_array_conversation_template_id}))
		
) as t1 
left join 
(---- 有效托管数。剔除首问之前取消托管数的托管数(机器人从没发言)
			select owner_wechat, external_userid
			, if(fisrt_robot_msg_send_time is null, 0, fisrt_robot_msg_send_time/1000) as fisrt_robot_msg_send_time
			from 
			(
				select tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
				, min (tb_cwl.send_time) as fisrt_robot_msg_send_time
				from 
				(--  全量好友关系表
					select owner_wechat
					, external_userid
					, uuw.delete_time 
					from hive2.ads.v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat uuw
				) as tb_user_wechat
				left join hive2.ads.v_hive2_ods_mid_t8t_mid_uc_uc_user_we_link as tb_uwl 
					on tb_user_wechat.external_userid = tb_uwl.user_id 
				left join 
				(--机器人发送的消息
				 	select  platform_uid ,profile_custom_id , send_time
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
) t2 on t1.robot_id =t2.owner_wechat and t1.uid =t2.external_userid

----------------------------------------------------

@set hivevar_smart_chat_dt = '20240304'	
		
		
		---转人工前提取到的槽位
	select ccr.phoneid
	, array_join(array_agg(
	case check_type_code
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
		when '7!711!71102!13' then '交房时间'
		else check_type_code
		end
	), '
	') as "转人工前提取到的槽位"
	--select *
	from 
	(
		select json_extract_scalar(extend_info , '$.phone_id') as phoneid
		, chat_id
		from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
		where ccr1.dt =${hivevar_smart_chat_dt} 
		and ccr1.robot_takeover_type =0 
		and (conversation_template_id in (${hivevar_array_conversation_template_id}) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (${hivevar_array_conversation_template_id}))
		and ccr1.deleted =0
		and chat_start_time >=to_unixtime(cast ('2024-02-25 00:00:0' as timestamp)) - 8*3600 
		and chat_start_time < to_unixtime(cast ('2024-03-03 00:00:0' as timestamp)) - 8*3600 
	) as ccr
	left join hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail ccd on ccr.chat_id = ccd.chat_id 
	where ccd.dt =${hivevar_smart_chat_dt}
	and ccd.reply_time >0
	and ccd.deleted =0
	and ccd.check_type_code in ('7!711!71102!4', '7!711!71102!1', '7!711!71102!3', '7!711!71102!2', '7!711!71102!6', '7!711!71102!11', '7!711!71102!13', '7!711!71102!16')
	and ccd.role_type in (1,3,4)
	and ccr.phoneid is not null and ccr.phoneid !='0'
	group by ccr.phoneid 
		
------------------------
	
	-- 每日加粉统计 数据量统计
select t1.ct, count(*)
from 
(
select cast(getday(cd.create_time) as int) as ct
,cd.chat_id 
, cd.strategy_scene 
, cd.extend_info 
, cd.conversation_template_id 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
) t1
where t1.ct>20240201
--and t1.strategy_scene = 8
and (conversation_template_id in (${hivevar_array_conversation_template_id}) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (${hivevar_array_conversation_template_id}))
group by t1.ct
order by t1.ct desc

-----------------------













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
                        where ccr1.dt ='20240331'
                        and ccr1.robot_takeover_type =0 
                        and ccr1.deleted =0
                        and (conversation_template_id in (${hivevar_array_conversation_template_id}) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (${hivevar_array_conversation_template_id}))
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
                                         where t.dt ='20240331'
                                         and  t.direction = 2 and t.scene='IR' --应答发送消息
                                         AND     t.content IS NOT NULL
                                        AND     t.content NOT LIKE '%现在我们可以开始聊天了%'
                                        AND     t.content NOT LIKE '%现在可以开始聊天了%'
                                        AND     t.content NOT LIKE '%以上是打招呼内容%'
                                        AND     t.message_type <> 10000
                                        AND     t.send_message_uid <> '1'
                                 ) as tb_cwl 
                                        on tb_cwl.platform_uid =tb_uwl.platform_uid and tb_user_wechat.owner_wechat = tb_cwl.profile_custom_id 
--                                where tb_user_wechat.owner_wechat='19075699974' and tb_user_wechat.external_userid
--                                in ('wmJiIbDAAAdT3eixbih5fJeFjYZmd7uA')
                                group by tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
                        )
                ) as tb_fisrt_msg_create_time
                        on ccr.robot_id = tb_fisrt_msg_create_time.owner_wechat and ccr.uid = tb_fisrt_msg_create_time.external_userid 
                        

                --where create_time >= 1711728000 and create_time <1711900799 -- TODO 就取近期的数据
                where create_time >=to_unixtime(cast ('2024-03-30 00:00:0' as timestamp)) - 8*3600 
                and create_time < to_unixtime(cast ('2024-04-01 00:00:0' as timestamp)) - 8*3600 
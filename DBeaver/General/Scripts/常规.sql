

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
 WHERE ct.id= 13
 ORDER BY ct.id  DESC , rac.robot_ask_id asc
 ;


=======================================================================================================================
-- 某个模板所有的话术id
select distinct temp_robot_ask_id
from 
(
--模版中的话术和关联话术
	 (
		 select rac.robot_ask_id AS temp_robot_ask_id
		 FROM hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_conversation_template ct 
		 LEFT JOIN  hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_conversation_robot_ask_config rac ON ct.id=rac.conversation_template_id
		 LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra1 ON cra1.id= rac.robot_ask_id
		 LEFT JOIN hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr ON adr.robot_ask_id=rac.robot_ask_id
		 LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
		 WHERE ct.id= 13
	 )
--	 union  --和下一个union同样的效果
--	 (
--		 select adr.relate_robot_ask_id AS temp_robot_ask_id
--		 FROM hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_conversation_template ct 
--		 LEFT JOIN  hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_conversation_robot_ask_config rac ON ct.id=rac.conversation_template_id
--		 LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra1 ON cra1.id= rac.robot_ask_id
--		 LEFT JOIN hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr ON adr.robot_ask_id=rac.robot_ask_id
--		 LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
--		 WHERE ct.id= 13
--	 )
	 ---- 下面的union看情况，可能有2个以上，结束的标志就是没有新的话术id出现
	 union 
	 (
	 	select adr.relate_robot_ask_id AS temp_robot_ask_id
		from 
		hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr
		LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
		where adr.robot_ask_id in (
			--这里的id是上面1个union的结果
		84,85,89,91,92,93,160
		)
		and adr.relate_robot_ask_id > 0
	 )
	 union 
	 (
	 	select adr.relate_robot_ask_id AS temp_robot_ask_id
		from 
		hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr
		LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
		where adr.robot_ask_id in (
			----这里的id是上面2个union 合并的结果
		84,85,86,89,90,91,92,93,96,97,98,99,100,102,103,127,131,136,137,138,139,140,141,142,143,146,147,148,149,151,152,153,154,155,160,162,163,310,313
		)
		and adr.relate_robot_ask_id > 0
	 )
	 union 
	 (
	 	select adr.relate_robot_ask_id AS temp_robot_ask_id
		from 
		hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr
		LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
		where adr.robot_ask_id in (
			----这里的id是上面3个union 合并的结果
		84,85,86,88,89,90,91,92,93,96,97,98,99,100,102,103,127,129,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,159,160,162,163,310,313
		)
		and adr.relate_robot_ask_id > 0
	 )
	 union 
	 (
	 	select adr.relate_robot_ask_id AS temp_robot_ask_id
		from 
		hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr
		LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
		where adr.robot_ask_id in (
			----这里的id是上面4个union 合并的结果
		84,85,86,88,89,90,91,92,93,96,97,98,99,100,102,103,127,129,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,159,160,161,162,163,310,313
		)
		and adr.relate_robot_ask_id > 0
	 )
	 union 
	 (
	 	select adr.relate_robot_ask_id AS temp_robot_ask_id
		from 
		hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr
		LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
		where adr.robot_ask_id in (
			----这里的id是上面5个union 合并的结果
		84,85,86,88,89,90,91,92,93,96,97,98,99,100,102,103,127,129,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,159,160,161,162,163,310,313
		)
		and adr.relate_robot_ask_id > 0
	 )
	 ---上面两个union返回id不在新增新的id，不再union了
) as temp
where temp.temp_robot_ask_id>0



-- 承接上面的sql，查询出来某个模板下面的所有话术id，然后导出详情
select cra1.id as "话术id"
,cra1.check_type_code 
,(
	CASE cra1.check_type_code
	WHEN '7!711!71102!1' THEN '装修时间'  WHEN '7!711!71102!2' THEN '房屋面积'  WHEN '7!711!71102!3' THEN '小区名称'  WHEN '7!711!71102!4' THEN '房屋类型'  WHEN '7!711!71102!5' THEN '装修风格'  WHEN '7!711!71102!6' THEN '意向量房时间'  WHEN '7!711!71102!7' THEN '居住类型'  WHEN '7!711!71102!8' THEN '工程量'  WHEN '7!711!71102!9' THEN '街道'  WHEN '7!711!71102!10' THEN '区县'  WHEN '7!711!71102!11' THEN '姓氏'  WHEN '7!711!71102!12' THEN '是否全屋定制'  WHEN '7!711!71102!13' THEN '交房时间'  WHEN '7!711!71102!14' THEN '时间'  WHEN '7!711!71102!15' THEN '装修预算'  WHEN '7!711!71102!16' THEN '城市'  WHEN '7!711!71102!17' THEN '电话'  WHEN '7!711!71102!18' THEN '预约全屋定制'  WHEN '7!711!71102!19' THEN '硬装需求'  WHEN '7!711!71102!21' THEN '手机号'  WHEN '7!711!71102!22' THEN '装修用途'  WHEN '7!711!71102!23' THEN '外出回来时间'  WHEN '7!711!71102!24' THEN '工程量-只有局改空间'  WHEN '7!711!71102!25' THEN '工程量-只有局改详情'  WHEN '7!711!71102!26' THEN '工程量-缺少水电'  WHEN '7!711!71102!27' THEN '工程量-只做墙面'  WHEN '7!711!71102!28' THEN '工程量-非局改范围'  WHEN '7!711!71102!29' THEN '工程量-无空间和局改详情'  WHEN '7!711!71102!31' THEN '工程量-只有否定局改空间'  WHEN '7!711!71102!32' THEN '工程量-只有否定局改详情'  WHEN '7!711!71102!33' THEN '工程量-未识别到工程量'  WHEN '7!711!71102!30' THEN '房屋类型-自建房'  WHEN '7!711!71102!34' THEN '装修类型'  WHEN '7!711!71102!35' THEN '装修时间-三个月外'  WHEN '7!711!71102!36' THEN '量房时间-一个月外'  WHEN '7!711!71102!50' THEN '交房时间-三个月后交房'  WHEN '7!711!71102!40' THEN '地址追问-城市'  WHEN '7!711!71102!41' THEN '地址追问-城市澄清问'  WHEN '7!711!71102!42' THEN '地址追问-小区地址-农村自建房'  WHEN '7!711!71102!43' THEN '地址追问-小区地址-非农村自建房'  WHEN '7!711!71102!44' THEN '地址追问-小区地址-模糊楼盘'  WHEN '7!711!71102!45' THEN '地址追问-小区地址-收到户型图'  WHEN '7!711!71102!46' THEN '地址追问-小区地址-回复房屋信息'  WHEN '7!711!71102!47' THEN '地址追问-小区地址-咨询设计方案'  WHEN '7!711!71102!48' THEN '地址追问-小区地址-咨询报价'
	END
 )  as "话术槽位" --AS relate_robot_ask_id_slot
,(
	select array_join(array_agg(cast(dcc.delay_time as varchar) ||'--'||dcc.content order by dcc.delay_time asc), '
	')
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
	where dcc.scene =3 and dcc.relate_id =cra1.id 
	group by dcc.relate_id
)  as "话术内容：【延迟时间】-【话术内容】"  --as robotAskContent
,(
	select array_join(array_agg(cast(dcc.delay_time as varchar) ||'--'||dcc.content order by dcc.delay_time asc), '
	')
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
	where dcc.scene =5 and dcc.relate_id =cra1.id 
	group by dcc.relate_id
)  as "用户超时无响应后的话术：【延迟时间】-【话术内容】" --as robotAskContentForNoResponse
,adr.intention_name as "用户回复文本分类--意图"
,adr.aff_neg_intention_name  as "用户回复肯否意图"
,adr.content  as "用户回复内容--归一后的结果"
,adr.relate_robot_ask_id as "关联话术id"
,cra2.check_type_code 
,(
	CASE cra2.check_type_code
	WHEN '7!711!71102!1' THEN '装修时间'  WHEN '7!711!71102!2' THEN '房屋面积'  WHEN '7!711!71102!3' THEN '小区名称'  WHEN '7!711!71102!4' THEN '房屋类型'  WHEN '7!711!71102!5' THEN '装修风格'  WHEN '7!711!71102!6' THEN '意向量房时间'  WHEN '7!711!71102!7' THEN '居住类型'  WHEN '7!711!71102!8' THEN '工程量'  WHEN '7!711!71102!9' THEN '街道'  WHEN '7!711!71102!10' THEN '区县'  WHEN '7!711!71102!11' THEN '姓氏'  WHEN '7!711!71102!12' THEN '是否全屋定制'  WHEN '7!711!71102!13' THEN '交房时间'  WHEN '7!711!71102!14' THEN '时间'  WHEN '7!711!71102!15' THEN '装修预算'  WHEN '7!711!71102!16' THEN '城市'  WHEN '7!711!71102!17' THEN '电话'  WHEN '7!711!71102!18' THEN '预约全屋定制'  WHEN '7!711!71102!19' THEN '硬装需求'  WHEN '7!711!71102!21' THEN '手机号'  WHEN '7!711!71102!22' THEN '装修用途'  WHEN '7!711!71102!23' THEN '外出回来时间'  WHEN '7!711!71102!24' THEN '工程量-只有局改空间'  WHEN '7!711!71102!25' THEN '工程量-只有局改详情'  WHEN '7!711!71102!26' THEN '工程量-缺少水电'  WHEN '7!711!71102!27' THEN '工程量-只做墙面'  WHEN '7!711!71102!28' THEN '工程量-非局改范围'  WHEN '7!711!71102!29' THEN '工程量-无空间和局改详情'  WHEN '7!711!71102!31' THEN '工程量-只有否定局改空间'  WHEN '7!711!71102!32' THEN '工程量-只有否定局改详情'  WHEN '7!711!71102!33' THEN '工程量-未识别到工程量'  WHEN '7!711!71102!30' THEN '房屋类型-自建房'  WHEN '7!711!71102!34' THEN '装修类型'  WHEN '7!711!71102!35' THEN '装修时间-三个月外'  WHEN '7!711!71102!36' THEN '量房时间-一个月外'  WHEN '7!711!71102!50' THEN '交房时间-三个月后交房'  WHEN '7!711!71102!40' THEN '地址追问-城市'  WHEN '7!711!71102!41' THEN '地址追问-城市澄清问'  WHEN '7!711!71102!42' THEN '地址追问-小区地址-农村自建房'  WHEN '7!711!71102!43' THEN '地址追问-小区地址-非农村自建房'  WHEN '7!711!71102!44' THEN '地址追问-小区地址-模糊楼盘'  WHEN '7!711!71102!45' THEN '地址追问-小区地址-收到户型图'  WHEN '7!711!71102!46' THEN '地址追问-小区地址-回复房屋信息'  WHEN '7!711!71102!47' THEN '地址追问-小区地址-咨询设计方案'  WHEN '7!711!71102!48' THEN '地址追问-小区地址-咨询报价'
	END
 )  as "关联槽位"  --AS relate_robot_ask_id_slot
--,adr.stop_robot_msg 
from 
hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr
LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra1 ON cra1.id= adr.robot_ask_id 
LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
where adr.robot_ask_id in (
	84,85,86,88,89,90,91,92,93,96,97,98,99,100,102,103,127,129,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,159,160,161,162,163,310,313
)
order by adr.robot_ask_id asc, adr.relate_robot_ask_id asc;


=====================================================================================




;
select *
from 
hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr 
where adr.relate_robot_ask_id<=0
and 
adr.robot_ask_id in (
	98
)
=======================================================================================================================
select dcc.relate_id
,array_join(array_agg(dcc.content), '
')
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
where dcc.scene =3 and dcc.relate_id =20
group by dcc.relate_id
---------------------------------------------------------------------------------------------------------------------------

select *
from hive2.ads.v_kudu_stg_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link

--select c.profile_custom_id, l.user_id,c.extra     聚合聊天平台消息查询
select *
from hive2.ads.v_kudu_stg_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link c
left join hive2.ads.v_kudu2_stg_mid_t8t_mid_uc_uc_user_we_link l on c.platform_uid = l.platform_uid
WHERE 
c.extra ='WECSMG_RECMSG_64c1e5aecae32d0001ca27fbabcdefgh'
c.profile_custom_id='19811976519' AND l.user_id = 'wmJiIbDAAAGBlTrKiOCrF864ofrhY4IA'
group by c.profile_custom_id, l.user_id,c.extra 


SELECT count(*)
SELECT  *
FROM hive2.ads.v_kudu2_stg_idc_new_t8t_mid_ucchat_uc_wechat_chatdata wc
where wc.from_id ='wmJiIbDAAAGBlTrKiOCrF864ofrhY4IA'
where 
(
	wc.from_id in ('19820812539', '19076158042', '595443', '18813863425', '13509682240', '10412506', '19860846340')
	or wc.tolist  in ('19820812539', '19076158042', '595443', '18813863425', '13509682240', '10412506', '19860846340')
)
and cast(wc.msg_time as bigint)/1000  >=to_unixtime(cast ('2023-05-11 00:00:00' as timestamp)) - 8*3600 
and cast(wc.msg_time as bigint)/1000 < to_unixtime(cast ('2023-05-11 23:59:59' as timestamp)) - 8*3600
;





SELECT *
FROM hive2.ads..v_kudu2_stg_idc_new_t8t_mid_ucchat_uc_wechat_chatdata wc
where 
	wc.from_id = 'wmJiIbDAAAFyRi23wCwCqw74aNkiGI5A'
	or wc.tolist =  'wmJiIbDAAAFyRi23wCwCqw74aNkiGI5A'
	
	MTk4MjA4MTA5NjQjd21KaUliREFBQXNMTW9ac2NCa2NpRnNxaGphTngxRVE=
	
	
	
	
	select * 
	from hive2.ads..v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record t
	where t.uid= 'wmJiIbDAAAsLMoZscBkciFsqhjaNx1EQ'
	
	
	select *
	from hive2.ads..v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail t
	 where t.chat_id='MjUyMzQxNDQjd21KaUliREFBQUtaZERoSXRjOXE4RTRHY0MtYlZNbEE='
	 
	 ;
	 select * 
	 from hive2.ads..v_kudu_stg_mid_t8t_mid_uc_uc_user_wechat t
	 where t.nick_name ='明年'
	
	 
	 
	 select * 
	 from hive2.ads..v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply t
	 where t.

------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM hive2.ads..v_kudu2_stg_idc_new_t8t_mid_ucchat_uc_wechat_chatdata wc
where wc.content  like '%+毛坯%'
limit 20000
==

-- 微联托管状态 聚合聊天 
select * from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_session
where unique_id ='wmJiIbDAAA0u99dVahiqac4Ua8g73ZJQ';

select * 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record cqr
where cqr.direction =1 and cqr.system_type =1
order by cqr.create_time desc

select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record
where chat_id ='MTM1NTQ3MDI1OTYjd21KaUliREFBQVYzaTdIbWRwVFVCUWtTU2lTamhYUlE='

select days,count(days) from (
	SELECT  
	    (cast(to_unixtime(now()) as int) - chat_start_time )/(24*3600) as days, id, chat_id
	FROM hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record
	WHERE conversation_template_id IN ( 12 ) AND check_status = 1 and deleted=0 and chat_start_time < cast(to_unixtime(now()) as int)
	) as b
group by days
order by days asc
------------------------
===========================================================================================================================

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
------------------------------------------------------------------
--trusteeship_status 0：未托管，1托管中，2取消托管
select * 
from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_session iis
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr on iis.wechat = cr.robot_id and iis.unique_id = cr.uid 
where unique_id ='wmJiIbDAAAu3aWzXN6Ne_LQR5QEJstvA' and wechat ='085472' and trusteeship_status= 1



---------------------------------
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

'{"phone_id":367819439}','{"phone_id":367814191}','{"phone_id":367810256}','{"phone_id":284510679}','{"phone_id":367828455}','{"phone_id":367815348}','{"phone_id":367320038}','{"phone_id":367681505}','{"phone_id":367805290}','{"phone_id":335993646}','{"phone_id":367807613}','{"phone_id":367707518}','{"phone_id":367830846}','{"phone_id":367712017}','{"phone_id":280320335}','{"phone_id":113298174}','{"phone_id":333383959}','{"phone_id":367787345}','{"phone_id":367806994}','{"phone_id":367828404}','{"phone_id":367814374}','{"phone_id":367831110}','{"phone_id":367831104}','{"phone_id":367778952}','{"phone_id":367682402}','{"phone_id":367008494}','{"phone_id":111413036}','{"phone_id":14013168}','{"phone_id":367814998}','{"phone_id":367810242}','{"phone_id":367804883}','{"phone_id":367806899}','{"phone_id":262651284}','{"phone_id":367808301}','{"phone_id":367807015}','{"phone_id":3122189}','{"phone_id":367816213}','{"phone_id":367808061}','{"phone_id":279764543}','{"phone_id":367778968}','{"phone_id":367770654}','{"phone_id":340757271}','{"phone_id":13260230}','{"phone_id":367824457}','{"phone_id":367818314}','{"phone_id":367816591}','{"phone_id":265391497}','{"phone_id":3026524}','{"phone_id":13784292}','{"phone_id":367814812}','{"phone_id":8606481}','{"phone_id":367824700}','{"phone_id":367808298}','{"phone_id":337932701}','{"phone_id":14381262}','{"phone_id":367828782}','{"phone_id":367812808}','{"phone_id":367812330}','{"phone_id":367808820}','{"phone_id":367804828}','{"phone_id":367823571}','{"phone_id":367808507}','{"phone_id":367707672}','{"phone_id":335371855}','{"phone_id":367825170}','{"phone_id":367818794}','{"phone_id":367817878}','{"phone_id":367818162}','{"phone_id":367803704}','{"phone_id":109422457}','{"phone_id":12521191}','{"phone_id":367805122}','{"phone_id":367803793}','{"phone_id":16403328}','{"phone_id":367831130}','{"phone_id":367814575}','{"phone_id":367707781}','{"phone_id":367830690}','{"phone_id":367818400}','{"phone_id":367811477}','{"phone_id":367808366}','{"phone_id":367815307}','{"phone_id":367681824}','{"phone_id":367535829}','{"phone_id":339333698}','{"phone_id":334837362}','{"phone_id":367816175}','{"phone_id":366704295}','{"phone_id":364889196}','{"phone_id":20573238}','{"phone_id":367815227}','{"phone_id":367814960}','{"phone_id":367808925}','{"phone_id":367816716}','{"phone_id":367807793}','{"phone_id":6626507}','{"phone_id":367808929}','{"phone_id":367805858}','{"phone_id":241864835}','{"phone_id":367818239}','{"phone_id":367805275}','{"phone_id":364180931}','{"phone_id":363622494}','{"phone_id":367827396}','{"phone_id":367734463}','{"phone_id":185945684}','{"phone_id":13509943}','{"phone_id":367814388}','{"phone_id":367804069}','{"phone_id":366704098}','{"phone_id":15047695}','{"phone_id":367828004}','{"phone_id":367812988}','{"phone_id":367782490}','{"phone_id":367717779}','{"phone_id":367674730}','{"phone_id":3216408}','{"phone_id":367816080}','{"phone_id":367814538}','{"phone_id":367755273}','{"phone_id":367357001}','{"phone_id":367804335}','{"phone_id":367808801}','{"phone_id":367808133}','{"phone_id":367805528}','{"phone_id":367707141}','{"phone_id":367608013}','{"phone_id":367829042}','{"phone_id":367816115}','{"phone_id":367807018}','{"phone_id":367805908}','{"phone_id":367818131}','{"phone_id":367811454}','{"phone_id":332456745}','{"phone_id":7453208}','{"phone_id":367814724}','{"phone_id":367808742}','{"phone_id":367806355}','{"phone_id":367813452}','{"phone_id":367811416}','{"phone_id":367808224}','{"phone_id":367807763}','{"phone_id":367776242}','{"phone_id":365728879}','{"phone_id":311664560}','{"phone_id":304242766}','{"phone_id":9667197}','{"phone_id":367842605}','{"phone_id":367842547}','{"phone_id":320159848}','{"phone_id":367855643}','{"phone_id":367853373}','{"phone_id":367843826}','{"phone_id":367843460}','{"phone_id":367836994}','{"phone_id":367833723}','{"phone_id":333237626}','{"phone_id":187016017}','{"phone_id":367856758}','{"phone_id":367843783}','{"phone_id":367834114}','{"phone_id":367712408}','{"phone_id":173941612}','{"phone_id":367860549}','{"phone_id":367856726}','{"phone_id":367855057}','{"phone_id":367846852}','{"phone_id":367841754}','{"phone_id":367830759}','{"phone_id":187762091}','{"phone_id":170167576}','{"phone_id":367841390}','{"phone_id":367840233}','{"phone_id":367802152}','{"phone_id":24532287}','{"phone_id":23335766}','{"phone_id":367856874}','{"phone_id":367849412}','{"phone_id":367804864}','{"phone_id":342974118}','{"phone_id":16210529}','{"phone_id":367855477}','{"phone_id":366823721}','{"phone_id":204863257}','{"phone_id":367845770}','{"phone_id":367842300}','{"phone_id":367841592}','{"phone_id":367840704}','{"phone_id":367833087}','{"phone_id":366391610}','{"phone_id":24687464}','{"phone_id":367860083}','{"phone_id":367855387}','{"phone_id":367847944}','{"phone_id":367843396}','{"phone_id":367841707}','{"phone_id":367839734}','{"phone_id":367829380}','{"phone_id":367861498}','{"phone_id":367842375}','{"phone_id":367829834}','{"phone_id":336292710}','{"phone_id":335260150}','{"phone_id":86584998}','{"phone_id":367835819}','{"phone_id":318697548}','{"phone_id":151620076}','{"phone_id":367850647}','{"phone_id":367841618}','{"phone_id":363547597}','{"phone_id":367859304}','{"phone_id":367858541}','{"phone_id":367857842}','{"phone_id":367855893}','{"phone_id":367855466}','{"phone_id":367839247}','{"phone_id":364988056}','{"phone_id":210190616}','{"phone_id":135880403}','{"phone_id":367857652}','{"phone_id":367835549}','{"phone_id":367833974}','{"phone_id":367832591}','{"phone_id":367835362}','{"phone_id":367833237}','{"phone_id":367831676}','{"phone_id":367857712}','{"phone_id":367856911}','{"phone_id":367855783}','{"phone_id":367855729}','{"phone_id":367836327}','{"phone_id":366715608}','{"phone_id":11094746}','{"phone_id":367842625}','{"phone_id":367834025}','{"phone_id":367832488}','{"phone_id":366687078}','{"phone_id":363505526}','{"phone_id":339781723}','{"phone_id":367858360}','{"phone_id":367854186}','{"phone_id":367838305}','{"phone_id":367861582}','{"phone_id":367859197}','{"phone_id":367856000}','{"phone_id":367840971}','{"phone_id":367840262}','{"phone_id":367833754}','{"phone_id":367831277}','{"phone_id":340127164}','{"phone_id":367857991}','{"phone_id":367857690}','{"phone_id":367840801}','{"phone_id":367840504}','{"phone_id":367857167}','{"phone_id":367852945}','{"phone_id":367842531}','{"phone_id":367840785}','{"phone_id":367840754}','{"phone_id":367835836}','{"phone_id":367834519}','{"phone_id":367830118}','{"phone_id":367714361}','{"phone_id":343144965}','{"phone_id":335184418}','{"phone_id":73978037}','{"phone_id":367835151}','{"phone_id":367834529}','{"phone_id":367834041}','{"phone_id":367833304}','{"phone_id":367833229}','{"phone_id":367714259}','{"phone_id":367542205}','{"phone_id":367294223}','{"phone_id":367855803}','{"phone_id":367843291}','{"phone_id":367839294}','{"phone_id":367838223}','{"phone_id":367833558}','{"phone_id":367829777}','{"phone_id":318440631}','{"phone_id":240646064}','{"phone_id":72579409}','{"phone_id":12366615}','{"phone_id":367835181}','{"phone_id":367835170}','{"phone_id":367830597}','{"phone_id":367829221}','{"phone_id":362646817}','{"phone_id":3669495}','{"phone_id":367861618}','{"phone_id":367859150}','{"phone_id":367856391}','{"phone_id":367855799}','{"phone_id":367841804}','{"phone_id":367839875}','{"phone_id":367839168}','{"phone_id":362619971}','{"phone_id":320630464}','{"phone_id":257911351}','{"phone_id":367857405}','{"phone_id":367857334}','{"phone_id":367856837}','{"phone_id":367856718}','{"phone_id":367853087}','{"phone_id":367842840}','{"phone_id":367842470}','{"phone_id":367839141}','{"phone_id":367835932}','{"phone_id":367833954}','{"phone_id":367832809}','{"phone_id":333932468}','{"phone_id":127511122}','{"phone_id":15553711}','{"phone_id":367855742}','{"phone_id":367848559}','{"phone_id":367614948}','{"phone_id":7529495}','{"phone_id":367859323}','{"phone_id":367844741}','{"phone_id":367833743}','{"phone_id":367829483}','{"phone_id":367779177}','{"phone_id":361685115}','{"phone_id":34038363}','{"phone_id":367855499}','{"phone_id":367829813}','{"phone_id":367808344}','{"phone_id":362864002}','{"phone_id":302526182}','{"phone_id":8667987}','{"phone_id":367844197}','{"phone_id":367831747}','{"phone_id":340589372}','{"phone_id":34036134}','{"phone_id":3483527}','{"phone_id":367858592}','{"phone_id":367838687}','{"phone_id":367829150}','{"phone_id":360373356}','{"phone_id":11364407}','{"phone_id":367858112}','{"phone_id":367850117}','{"phone_id":367835273}','{"phone_id":342795356}','{"phone_id":367842543}','{"phone_id":367839220}','{"phone_id":367838201}','{"phone_id":367828693}','{"phone_id":367714601}','{"phone_id":366941768}','{"phone_id":8869577}','{"phone_id":5740439}','{"phone_id":367860538}','{"phone_id":367857700}','{"phone_id":367855476}','{"phone_id":367843405}','{"phone_id":367842455}','{"phone_id":367841748}','{"phone_id":367841306}','{"phone_id":367832951}','{"phone_id":363574883}','{"phone_id":340137060}','{"phone_id":3005958}','{"phone_id":367860104}','{"phone_id":299378977}','{"phone_id":10630939}','{"phone_id":367833610}','{"phone_id":367803742}','{"phone_id":361166965}','{"phone_id":336511167}','{"phone_id":367860001}','{"phone_id":367855276}','{"phone_id":367840791}','{"phone_id":367835352}','{"phone_id":367835195}','{"phone_id":367830283}','{"phone_id":367857890}','{"phone_id":367857555}','{"phone_id":367855960}','{"phone_id":367840793}','{"phone_id":367836095}','{"phone_id":367771696}','{"phone_id":339382452}','{"phone_id":317832643}','{"phone_id":367856361}','{"phone_id":367853074}','{"phone_id":367844883}','{"phone_id":367838413}','{"phone_id":367859920}','{"phone_id":367857508}','{"phone_id":367853158}','{"phone_id":367838926}','{"phone_id":367834050}','{"phone_id":367833056}','{"phone_id":367831442}','{"phone_id":367831363}','{"phone_id":367829830}','{"phone_id":317788794}'

)
and cr.deleted =0
and cd.reply !=''
group by cr.chat_id

================================================



select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where qr.chat_id ='ODI2NzEyNzUjd21KaUliREFBQWZWWXNiX1B5NlVmSk5rM1lnS1JkOEE='
order by qr.id asc


select *, from_unixtime(create_time+8*3600) as create_time, from_unixtime(update_time+8*3600) as update_time
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
where 
order by id desc

select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where cr.extend_info like '%371501157%'

select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where cr.robot_takeover_type =0 and cr.check_status =5 and cr.grounded_type =1
order by id desc

select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where cr.robot_takeover_type =0  and cr.grounded_type =1
order by id desc

----------------------------
 select count(*)
select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr
where cr.grounded_type =1
order by id desc


select from_unixtime(cd.create_time+8*3600) as ct
,cd.extend_info 
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
,from_unixtime(cd.staff_service_time +8*3600) as sst
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where cd.chat_id in 
(
'OTU4OTcyI3dtSmlJYkRBQUFsWktZVUxBZnhMd0Nxc0l2M2tORzZB'
)
order by id desc


select ccr.chat_id 
,ccr.transfer_manual_reason 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr
where ccr.chat_id in 


--  电话id查询 会话记录
select from_unixtime(cd.create_time+8*3600) as ct,cd.extend_info 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where cd.extend_info like '%374452250%'
order by id desc



select from_unixtime(cd.create_time+8*3600) as ct, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where cd.robot_takeover_type =0
and cd.check_status =1
and cd.conversation_template_id in (5,6,7,8,9,10,12,13,14,15,16,17,18,  )
and cd.robot_id = '18098960914'
order by id desc


select from_unixtime(qr.create_time+8*3600) as ct,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where 
--qr.chat_id ='MTgxOTQwNjA4MzIjd21KaUliREFBQXBmTjg5WGhUbzJ5NTBCNE0wQUpDckE='
qr.text_content like '%图片%'
order by id desc



select from_unixtime(cd.create_time+8*3600) as ct
,* 
from  hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
where cd.chat_id ='MTkwNzU2OTI5ODMjd21KaUliREFBQVhoLU16V2dPM1NyYms3VXN5YkNzbXc='
order by id desc


select from_unixtime(cd.create_time+8*3600) as ct
,* 
from  hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
where cd.check_type_code in ('7!711!71102!59' )
order by id desc


select *
from 
(
	select 
	qr.chat_id ,
	cd.extend_info ,
	from_unixtime(qr.send_time +8*3600) as createTime
	,qr.text_content
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
	left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd on qr.chat_id = cd.chat_id 
	where
	qr.chat_id in (
	'ODI2NzEyNzUjd21KaUliREFBQWNoZ095Y0xoUHdmbzVQVThTUTVnWUE='
	)
	order by qr.id desc
	--and qr.send_time>1702051200
	group by qr.chat_id
)



select cr.chat_id,cr.robot_id  ,cr.extend_info
,cd.reply , cd.nlp_reply , cd.source_reply 
from  
hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cr 
left join hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd on cr.chat_id =cd.chat_id 
where 
 cr.robot_takeover_type =0 and cd.check_type_code ='7!711!71102!13'
 and cd.reply !=''
order by cd.id  desc

-----
select from_unixtime(cd.create_time+8*3600) as createTime
,cd.transfer_manual_reason 
,cd.chat_id, cd.robot_id, cd.uid, cd.check_status, cd.extend_info ,cd.robot_takeover_type 
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where cd.robot_takeover_type =0
and cd.conversation_template_id =12
and cd.check_status != 5
and cd.deleted =0
--and cd.create_time >= 1702396800
order by id  desc

--------



select 
from_unixtime(ccr.create_time+8*3600) as ct
,ccr.transfer_manual_reason 
, ccr.extend_info 
, *
--count(distinct ccr.robot_id)
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr
where 
ccr.check_status  not in (-1) 
--and 
--json_extract_scalar(ccr.extend_info, '$.transferManualType') ='1'
--(json_extract_scalar(ccr.extend_info, '$.transferManualType') is null or json_extract_scalar(ccr.extend_info, '$.transferManualType') !='1')
--and ccr.robot_id in (
----    '18124145324'
--)
and ccr.conversation_template_id in (12, 13, 20, 21)
and ccr.robot_takeover_type =0
and ccr.deleted =0
--and ccr.staff_service_time > 1701699000
and ccr.create_time >= 1702396800 and ccr.create_time < 1702396800+3600*24
--and ccr.chat_id ='MTgxMjQxNDUzMjQjd21KaUliREFBQXpqaU8tcHgxanNiNVhOS0xoN2hMd1E='
order by id desc





select from_unixtime(ccr.create_time+8*3600) as ct
, from_unixtime(ccr.staff_service_time +8*3600) as staff_service_time_format 
,ccr.extend_info 
,ccr.transfer_manual_reason 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr
where 
--from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr
--where ccr.dt =${hivevar_smart_chat_dt}  and 
ccr.robot_id in (
'10342215','24482178','652638','79081421','52648','19860846045','13554701752','10676302','19128456739','82671275','19075693760','19128323473','085472','13554702790','19076199760','13554705247','18038174915','19065037054','18126269084','18002569934','18165747834','19065033242','19075363641','18128823041','18124145324'
)
and ccr.robot_takeover_type =0
and ccr.create_time between 1701964800 and 1701964800+3600*24
--and ccr.transfer_manual_reason in 
--(
----14,5,10,15,17,23,27,28
--3
--)
order by ccr.id  desc
;


select from_unixtime(ccr.create_time+8*3600) as ct
,ccr.extend_info 
,ccr.transfer_manual_reason 
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr
where 
ccr.chat_id in 
(
'MTgxMjk5NTY0MDcjd21KaUliREFBQTJDZFJNaWNUODNYSTRyWS1ZeHNfV1E='
)
--ccr.robot_id in (
--'19075699072'
--)
order by ccr.id  desc
;


-------------
-- 按电话找联系人id
select id from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_contact where phone_id = 329879559;
-- 按联系人id项目
select proj_id from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_project where con_id = 32212699;
-- 按项目找需求
select dem_id,granted_time,granted_uid from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_demand where proj_id = 67212826;


select dem_id,granted_time,granted_uid from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_demand where proj_id in (
    select proj_id from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_project where con_id = (
        select id from hive2.ads.v_kudu_stg_crm_t8t_mid_proj_cus_contact  where phone_id = 373992463
        )
    );
---------------------------
   
   
   @set hivevar_smart_chat_dt = '20231220'
   
-- 托管账号，顾问抢答:转人工之前，顾问发送的消息数（scene：IM）
select from_unixtime(ccr.create_time+8*3600) as ct
, json_extract_scalar(ccr.extend_info, '$.phone_id') as phone_id
, from_unixtime(cwl.send_time/1000+8*3600) as st
, cwl.text_content 
,ccr.create_time, ccr.chat_id, ccr.robot_id  , *
from 
(
	select --(select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) 
	create_time
	, ccr1.robot_id , ccr1.uid ,ccr1.chat_id ,ccr1.staff_service_time, ccr1.extend_info 
	, ccr1.chat_start_time
	from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr1
	where ccr1.dt =${hivevar_smart_chat_dt} 
	and ccr1.robot_takeover_type =0 
	and ccr1.conversation_template_id in (13, 20, 21)
) as ccr
left join hive2.ads.v_hive2_ods_idc_new_t8t_mid_ucchat_uc_wechat_single_chat_we_link cwl
	on ccr.robot_id =cwl.profile_custom_id  and ccr.uid = cwl.external_userid 
where cwl.dt =${hivevar_smart_chat_dt}
--and cwl.send_time between 1000*${hivevar_smart_chat_start_add_time} and 1000*${hivevar_smart_chat_end_add_time}
and cwl.scene ='RECMSG'
and ccr.chat_start_time * 1000 >= cwl.send_time
and cwl.text_content not like '%现在我们可以开始聊天了%'
and cwl.text_content not like '%现在可以开始聊天了%'
and ccr.chat_start_time > 1687104000




	        
	        
	        
	        
	        
	        
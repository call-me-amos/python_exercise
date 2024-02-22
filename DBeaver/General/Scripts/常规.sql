

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


=======================================================================================================================
-- 注意，sql在presto执行，需要分多次
--		第一个sql内部union的表需要多次级联查询
-- 		第二个sql的id依赖第一个sql的查询结果
-- 【1】某个模板所有的话术id
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
		 WHERE ct.id= 36
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
		720,715,760,756,721,718,717,722
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



-- 【2】承接上面的sql，查询出来某个模板下面的所有话术id，然后导出详情。
-- 注意，这里有个问题，如果话术没有配置无响应时间，就不会导出来。
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
,
case (
	select array_join(array_agg(cast(dcc.delay_time as varchar) ||'--'||dcc.content order by dcc.delay_time asc), '
	')
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
	where dcc.scene =5 and dcc.relate_id =cra1.id 
	group by dcc.relate_id
) is null 
when true then '没配置无响应话术' else 
(
	select array_join(array_agg(cast(dcc.delay_time as varchar) ||'--'||dcc.content order by dcc.delay_time asc), '
	')
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_detail_content_config dcc
	where dcc.scene =5 and dcc.relate_id =cra1.id 
	group by dcc.relate_id
)
end 
as "用户超时无响应后的话术：【延迟时间】-【话术内容】" --as robotAskContentForNoResponse
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
hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra1
LEFT JOIN hive2.ads.v_kudu2_stg_it4_slave_t8t_tbt_tls_tls_smart_chat_robot_ask_default_reply  adr ON cra1.id= adr.robot_ask_id 
LEFT JOIN hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra2 ON cra2.id= adr.relate_robot_ask_id
where cra1.id in 
--级联和直接通过模板查询
--(
--	790
--)
(
	-- 根据话术模板id查询所有的话术--仅适用 话术和话术模板绑定的模板（历史模板不支持了）
	select distinct id
	from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_robot_ask cra
	where cra.relate_template_id =35
	order by id asc
)
order by adr.robot_ask_id asc, adr.relate_robot_ask_id asc;






=====================================================================================

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

------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM hive2.ads..v_kudu2_stg_idc_new_t8t_mid_ucchat_uc_wechat_chatdata wc
where wc.content  like '%+毛坯%'
limit 20000
==

-- 微联托管状态 聚合聊天 
select * from hive2.ads.v_kudu2_stg_idc_new_t8t_wec_im_im_session
where unique_id ='wmJiIbDAAA0u99dVahiqac4Ua8g73ZJQ';



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

)
and cr.deleted =0
and cd.reply !=''
group by cr.chat_id

================================================
select from_unixtime(cd.create_time+8*3600) as ct
,cd.extend_info 
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
,from_unixtime(cd.staff_service_time +8*3600) as sst
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where 
cd.chat_id in 
(
'MTM1NTQ3MDE3NTIjd21KaUliREFBQWREYlB0SmNNbnV5WGtqR1VENlpEaFE='
)
order by id desc

--
select from_unixtime(cd.create_time+8*3600) as ct
,cd.extend_info 
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
,from_unixtime(cd.staff_service_time +8*3600) as sst
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where 
uid = 'wmJiIbDAAA9mW-LcAcoz_AK0QxHZ1Cxg'
order by id desc


--  电话id查询 会话记录
select from_unixtime(cd.create_time+8*3600) as ct,cd.extend_info 
,json_extract_scalar(cd.extend_info , '$.phone_id') as phoneid
, *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where cd.extend_info like '%220047227%'
order by id desc



select *, from_unixtime(create_time+8*3600) as create_time, from_unixtime(update_time+8*3600) as update_time
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
where 
cd.chat_id ='MTk4MjA4MTA3NDMjd21KaUliREFBQXJuNkJFRzJNc2R4NWRRdzJqc3dwZmc='
order by id desc


select from_unixtime(cd.create_time+8*3600) as ct
, from_unixtime(cd.reply_time +8*3600) as rt
,* 
from  hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
where 
cd.chat_id ='MzgxMTIxNzYjd21KaUliREFBQVBfSWxfYWY1TTJwUDdsQVdSU2tvbVE='
order by cd.reply_time  desc


select from_unixtime(cd.create_time+8*3600) as ct
,* 
from  hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail cd
where cd.check_type_code in ('7!711!71102!55' )
order by id desc

select from_unixtime(qr.create_time+8*3600) as ct,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where 
qr.chat_id ='MjQ0NjA0NzAjd21KaUliREFBQXBMSVBzWnRTOTNTVFdGUm9ZVE53LUE='
order by id desc


select *
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_qiwei_record qr
where qr.chat_id ='MTk4NjA4NDYwNDUjd21KaUliREFBQUYxV1hPVTExWmdSNUZJSmJUSU1waGc='
order by qr.id asc


-----
select from_unixtime(cd.create_time+8*3600) as ct
,cd.create_time 
,cd.transfer_manual_reason 
,cd.chat_id, cd.robot_id, cd.uid, cd.check_status, cd.extend_info ,cd.robot_takeover_type 
,*
from hive2.ads.v_kudu2_stg_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record cd
where cd.robot_takeover_type =0
--and cd.deleted =0
--and cd.conversation_template_id =12
--and cd.check_status != 5
--and cd.robot_id in ('17722578189','19065015413','19820810743','18806651721')
and cd.uid in ('wmJiIbDAAAwFzgxMf7ktpBKz2dWmkVXw')
order by id  desc

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
		
		
===================
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
   
				
				
				
				
				
				
========================
-- 统计林培峰 接管的用户里面 核需标签5个以上的占比
select chat_id, count(1)
from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail
where dt = '20240217'
   and create_time >= 1704038400
   and create_time < 1706716800
  and check_type_code in ('7!711!71102!1', '7!711!71102!2', '7!711!71102!3', '7!711!71102!4', '7!711!71102!6', '7!711!71102!11')
  and reply <> ''
  and role_type = 1
  and execute_status = 6
  and chat_id in (select chat_id--, count(1)
                  from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record
                  where dt = '20240217'
                    --and conversation_template_id = 13
                    and (conversation_template_id in (13, 20, 21, 26,33,35,36,37,38) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26,33,35,36,37,38))
                    and robot_takeover_type = 0
--                     and transfer_manual_reason <> 1
                    and robot_id  in ('13554701752','10346305','02194')
                     and chat_start_time >= 1704038400
                     and chat_start_time < 1706716800
                  )
group by chat_id
having count(1) >= 5;

---------------  基于单个会话汇总

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
			and (conversation_template_id in (13, 20, 21, 26,33,35,36,37,38) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13, 20, 21, 26,33,35,36,37,38))
		
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







-------------------------------------
select date_format(from_unixtime(chat_start_time, 'Asia/Shanghai'), '%Y-%m-%d %H') as "接粉日期", uid as "外部联系人id", robot_id as "企微号", conversation_template_id,
       json_extract(extend_info, '$.preTemplateId') as "preTemplateId",
       json_extract(extend_info, '$.phone_id') as "电话id", transfer_manual_reason as "转人工枚举"
from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record
where dt = '20240219'
  and robot_takeover_type = 0
  and robot_id not in ('13683560870','18025436210')
  and (conversation_template_id in (13,20,21,26,33,35,36,37,38) or cast(json_extract(extend_info, '$.preTemplateId') as int) in (13,20,21,26,33,35,36,37,38))
and chat_start_time >= 1708185600








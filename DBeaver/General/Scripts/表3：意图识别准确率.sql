


@set hivevar_smart_chat_dt = '20240221'

select ${hivevar_smart_chat_dt}

-------------------------------------------------------
-- 表3：意图识别准确率
--- 视图：  v_hive_ads_smart_chat_tb_category_content_report
drop table if exists hive2.test.tmp_smart_chat_tb_category_content_report;

create table if not exists hive2.test.tmp_smart_chat_tb_category_content_report as
(

		select tb_temp_fccr.create_time --加微时间
		, tb_temp_fccr.category_result  --意图分类
		,case tb_temp_fccr.marked_source  
		when 1 then 'IM标注'
		when 2 then 'ERP标注'
		else '默认值'
		end as marked_source  --抽检标记来源
		, count(1)   as recognition_num  --意图识别次数
		, sum(tb_temp_fccr.marked_num) as marked_num  --抽检数
		, sum(tb_temp_fccr.marked_error) as marked_error  --抽检标记错误数
		,
		case sum(tb_temp_fccr.marked_num)
		when 0 then 0
		else round(cast((sum(tb_temp_fccr.marked_num) - sum(tb_temp_fccr.marked_error)) as double)/ sum(tb_temp_fccr.marked_num), 2)
		end as  marked_correct_rate   --抽检意图识别准确率
		from 
		(
			select (select to_unixtime(cast (getday(fccr.create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) create_time 
			, fccr.category_result 
			,fccr.marked_status
				, if(fccr.marked_status = 2, 1, 0) as  marked_num
			,fccr.marked_result
				, if(fccr.marked_status = 2 and fccr.marked_result !='' and fccr.category_result !=fccr.marked_result ,1,0) as marked_error
			,fccr.marked_source 
			from hive2.ads.v_hive2_ods_idc_new_t8t_nlp_fls_fls_category_content_record fccr
			where fccr.dt =${hivevar_smart_chat_dt}
			and fccr.bussiness_key ='intelligentPlatform'
			and fccr.session_id <>''
			and fccr.create_time>0
		) tb_temp_fccr
		group by tb_temp_fccr.create_time, tb_temp_fccr.category_result, tb_temp_fccr.marked_source
		
);






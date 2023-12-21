/**
 * 表2：槽位维度的IM数据（开发情况）
 */
--@set hivevar_smart_chat_start_add_time = to_unixtime(cast ('2023-11-21 00:00:00' as timestamp)) - 8*3600
--@set hivevar_smart_chat_end_add_time = to_unixtime(cast ('2023-11-21 23:59:59' as timestamp)) - 8*3600
@set hivevar_smart_chat_dt = '20231220'

select ${hivevar_smart_chat_dt}
---------------------------------------------------------------------------------------------------------------------------------------

-- 视图： v_hive_ads_smart_chat_slot_report

drop table if exists hive2.test.tmp_smart_chat_tb_slot_check;
drop table if exists hive2.test.tmp_smart_chat_tb_slot_send_clollect  ;


---【1】每个槽位的抽检情况--临时表
create table if not exists hive2.test.tmp_smart_chat_tb_slot_check as 
(
	select tb_temp_standard_json_format_sum.create_time
	, sum(tb_temp_standard_json_format_sum.check_num_a1) as check_num_sum_a1
	, sum(tb_temp_standard_json_format_sum.check_num_a2) as check_num_sum_a2
	, sum(tb_temp_standard_json_format_sum.check_num_a3) as check_num_sum_a3
	, sum(tb_temp_standard_json_format_sum.check_num_a4) as check_num_sum_a4
	, sum(tb_temp_standard_json_format_sum.check_num_a5) as check_num_sum_a5
	, sum(tb_temp_standard_json_format_sum.check_num_a6) as check_num_sum_a6
	, sum(tb_temp_standard_json_format_sum.check_num_a7) as check_num_sum_a7
	, sum(tb_temp_standard_json_format_sum.check_num_a8) as check_num_sum_a8
	, sum(tb_temp_standard_json_format_sum.check_num_a9) as check_num_sum_a9
	, sum(tb_temp_standard_json_format_sum.check_num_a10) as check_num_sum_a10
	, sum(tb_temp_standard_json_format_sum.check_num_a11) as check_num_sum_a11
	, sum(tb_temp_standard_json_format_sum.check_num_a12) as check_num_sum_a12
	, sum(tb_temp_standard_json_format_sum.check_num_a13) as check_num_sum_a13
	, sum(tb_temp_standard_json_format_sum.check_num_right_a1) as check_num_right_sum_a1
	, sum(tb_temp_standard_json_format_sum.check_num_right_a2) as check_num_right_sum_a2
	, sum(tb_temp_standard_json_format_sum.check_num_right_a3) as check_num_right_sum_a3
	, sum(tb_temp_standard_json_format_sum.check_num_right_a4) as check_num_right_sum_a4
	, sum(tb_temp_standard_json_format_sum.check_num_right_a5) as check_num_right_sum_a5
	, sum(tb_temp_standard_json_format_sum.check_num_right_a6) as check_num_right_sum_a6
	, sum(tb_temp_standard_json_format_sum.check_num_right_a7) as check_num_right_sum_a7
	, sum(tb_temp_standard_json_format_sum.check_num_right_a8) as check_num_right_sum_a8
	, sum(tb_temp_standard_json_format_sum.check_num_right_a9) as check_num_right_sum_a9
	, sum(tb_temp_standard_json_format_sum.check_num_right_a10) as check_num_right_sum_a10
	, sum(tb_temp_standard_json_format_sum.check_num_right_a11) as check_num_right_sum_a11
	, sum(tb_temp_standard_json_format_sum.check_num_right_a12) as check_num_right_sum_a12
	, sum(tb_temp_standard_json_format_sum.check_num_right_a13) as check_num_right_sum_a13
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a1	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a1	), 2)  as  check_num_right_sum_ratio_1
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a2	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a2	), 2)  as  check_num_right_sum_ratio_2
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a3	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a3	), 2)  as  check_num_right_sum_ratio_3
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a4	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a4	), 2)  as  check_num_right_sum_ratio_4
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a5	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a5	), 2)  as  check_num_right_sum_ratio_5
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a6	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a6	), 2)  as  check_num_right_sum_ratio_6
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a7	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a7	), 2)  as  check_num_right_sum_ratio_7
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a8	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a8	), 2)  as  check_num_right_sum_ratio_8
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a9	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a9	), 2)  as  check_num_right_sum_ratio_9
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a10	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a10	), 2)  as  check_num_right_sum_ratio_10
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a11	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a11	), 2)  as  check_num_right_sum_ratio_11
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a12	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a12	), 2)  as  check_num_right_sum_ratio_12
	, round(cast(sum(tb_temp_standard_json_format_sum.check_num_right_a13	) as double)/sum(tb_temp_standard_json_format_sum.check_num_a13	), 2)  as  check_num_right_sum_ratio_13
	from 
	(--1、汇总每个槽位是否提取到。0-没有提取到 1-提取到了； 2、汇总每个槽位是否识别准确 0-不准确 1-准确
		select tb_temp_standard_json_format.id
		--【1】槽位值识别结果
		, tb_temp_standard_json_format.create_time
		, if(tb_temp_standard_json_format.a1 	is null, if(tb_temp_standard_json_format.b1 	='', 0, 1), 1) as check_num_a1
		, if(tb_temp_standard_json_format.a2 	is null, if(tb_temp_standard_json_format.b2 	='', 0, 1), 1) as check_num_a2
		, if(tb_temp_standard_json_format.a3 	is null, if(tb_temp_standard_json_format.b3 	='', 0, 1), 1) as check_num_a3
		, if(tb_temp_standard_json_format.a4 	is null, if(tb_temp_standard_json_format.b4 	='', 0, 1), 1) as check_num_a4
		, if(tb_temp_standard_json_format.a5 	is null, if(tb_temp_standard_json_format.b5 	='', 0, 1), 1) as check_num_a5
		, if(tb_temp_standard_json_format.a6 	is null, if(tb_temp_standard_json_format.b6 	='', 0, 1), 1) as check_num_a6
		, if(tb_temp_standard_json_format.a7 	is null, if(tb_temp_standard_json_format.b7 	='', 0, 1), 1) as check_num_a7
		, if(tb_temp_standard_json_format.a8 	is null, if(tb_temp_standard_json_format.b8 	='', 0, 1), 1) as check_num_a8
		, if(tb_temp_standard_json_format.a9 	is null, if(tb_temp_standard_json_format.b9 	='', 0, 1), 1) as check_num_a9
		, if(tb_temp_standard_json_format.a10 	is null, if(tb_temp_standard_json_format.b10 	='', 0, 1), 1) as check_num_a10
		, if(tb_temp_standard_json_format.a11 	is null, if(tb_temp_standard_json_format.b11 	='', 0, 1), 1) as check_num_a11
		, if(tb_temp_standard_json_format.a12 	is null, if(tb_temp_standard_json_format.b12 	='', 0, 1), 1) as check_num_a12
		, if(tb_temp_standard_json_format.a13 	is null, if(tb_temp_standard_json_format.b13 	='', 0, 1), 1) as check_num_a13
		-- 【2】标注结果
		, if(tb_temp_standard_json_format.a1	  is null, 0, if(tb_temp_standard_json_format.a1	 = tb_temp_standard_json_format.b1	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a1
		, if(tb_temp_standard_json_format.a2	  is null, 0, if(tb_temp_standard_json_format.a2	 = tb_temp_standard_json_format.b2	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a2
		, if(tb_temp_standard_json_format.a3	  is null, 0, if(tb_temp_standard_json_format.a3	 = tb_temp_standard_json_format.b3	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a3
		, if(tb_temp_standard_json_format.a4	  is null, 0, if(tb_temp_standard_json_format.a4	 = tb_temp_standard_json_format.b4	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a4
		, if(tb_temp_standard_json_format.a5	  is null, 0, if(tb_temp_standard_json_format.a5	 = tb_temp_standard_json_format.b5	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a5
		, if(tb_temp_standard_json_format.a6	  is null, 0, if(tb_temp_standard_json_format.a6	 = tb_temp_standard_json_format.b6	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a6
		, if(tb_temp_standard_json_format.a7	  is null, 0, if(tb_temp_standard_json_format.a7	 = tb_temp_standard_json_format.b7	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a7
		, if(tb_temp_standard_json_format.a8	  is null, 0, if(tb_temp_standard_json_format.a8	 = tb_temp_standard_json_format.b8	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a8
		, if(tb_temp_standard_json_format.a9	  is null, 0, if(tb_temp_standard_json_format.a9	 = tb_temp_standard_json_format.b9	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a9
		, if(tb_temp_standard_json_format.a10	  is null, 0, if(tb_temp_standard_json_format.a10	 = tb_temp_standard_json_format.b10	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a10
		, if(tb_temp_standard_json_format.a11	  is null, 0, if(tb_temp_standard_json_format.a11	 = tb_temp_standard_json_format.b11	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a11
		, if(tb_temp_standard_json_format.a12	  is null, 0, if(tb_temp_standard_json_format.a12	 = tb_temp_standard_json_format.b12	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a12
		, if(tb_temp_standard_json_format.a13	  is null, 0, if(tb_temp_standard_json_format.a13	 = tb_temp_standard_json_format.b13	, 1, if(tb_temp_standard_json_format.marked_result='', 1, 0))) as check_num_right_a13
	
		from 
		( 	-- 拉平了，包含每个槽位的抽检数和抽检准确数 的实际值
				select 
				tb_temp_standard_json.create_time , tb_temp_standard_json.id,  tb_temp_standard_json.marked_result,
				tb_temp_standard_json.a1,
				tb_temp_standard_json.a2,
				tb_temp_standard_json.a3,
				tb_temp_standard_json.a4,
				tb_temp_standard_json.a5,
				tb_temp_standard_json.a6,
				tb_temp_standard_json.a7,
				tb_temp_standard_json.a8,
				tb_temp_standard_json.a9,
				tb_temp_standard_json.a10,
				tb_temp_standard_json.a11,
				tb_temp_standard_json.a12,
				tb_temp_standard_json.a13
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('城市'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('城市'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('城市'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('城市'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('城市'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('城市'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('城市'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('城市'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('城市'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('城市'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('城市'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('城市'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('城市'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('城市'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('城市'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('城市'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b1
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('小区地址'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('小区地址'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('小区地址'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('小区地址'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('小区地址'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('小区地址'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('小区地址'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('小区地址'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('小区地址'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('小区地址'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('小区地址'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('小区地址'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('小区地址'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('小区地址'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('小区地址'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('小区地址'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b2
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('房屋面积'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('房屋面积'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('房屋面积'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('房屋面积'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('房屋面积'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('房屋面积'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('房屋面积'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('房屋面积'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('房屋面积'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('房屋面积'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('房屋面积'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('房屋面积'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('房屋面积'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('房屋面积'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('房屋面积'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('房屋面积'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b3
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('工程量'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('工程量'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('工程量'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('工程量'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('工程量'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('工程量'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('工程量'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('工程量'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('工程量'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('工程量'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('工程量'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('工程量'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('工程量'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('工程量'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('工程量'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('工程量'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b4
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('区县'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('区县'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('区县'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('区县'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('区县'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('区县'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('区县'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('区县'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('区县'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('区县'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('区县'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('区县'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('区县'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('区县'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('区县'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('区县'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b5
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('小区名称'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('小区名称'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('小区名称'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('小区名称'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('小区名称'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('小区名称'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('小区名称'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('小区名称'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('小区名称'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('小区名称'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('小区名称'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('小区名称'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('小区名称'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('小区名称'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('小区名称'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('小区名称'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b6
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('房屋类型'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('房屋类型'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('房屋类型'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('房屋类型'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('房屋类型'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('房屋类型'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('房屋类型'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('房屋类型'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('房屋类型'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('房屋类型'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('房屋类型'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('房屋类型'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('房屋类型'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('房屋类型'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('房屋类型'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('房屋类型'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b7
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('街道'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('街道'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('街道'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('街道'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('街道'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('街道'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('街道'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('街道'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('街道'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('街道'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('街道'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('街道'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('街道'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('街道'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('街道'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('街道'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b8
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('姓氏'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('姓氏'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('姓氏'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('姓氏'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('姓氏'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('姓氏'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('姓氏'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('姓氏'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('姓氏'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('姓氏'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('姓氏'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('姓氏'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('姓氏'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('姓氏'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('姓氏'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('姓氏'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b9
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('时间'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('时间'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('时间'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('时间'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('时间'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('时间'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('时间'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('时间'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('时间'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('时间'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('时间'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('时间'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('时间'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('时间'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('时间'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('时间'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b10
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('手机号'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('手机号'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('手机号'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('手机号'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('手机号'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('手机号'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('手机号'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('手机号'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('手机号'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('手机号'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('手机号'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('手机号'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('手机号'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('手机号'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('手机号'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('手机号'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b11
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('房屋用途'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('房屋用途'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('房屋用途'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('房屋用途'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('房屋用途'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('房屋用途'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('房屋用途'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('房屋用途'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('房屋用途'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('房屋用途'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('房屋用途'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('房屋用途'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('房屋用途'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('房屋用途'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('房屋用途'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('房屋用途'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b12
				,
					case 
						when tb_temp_standard_json.marked_result='' then ''
						when ('装修类型'=tb_temp_standard_json.n1_key) then tb_temp_standard_json.n1_value
						when ('装修类型'=tb_temp_standard_json.n2_key) then tb_temp_standard_json.n2_value
						when ('装修类型'=tb_temp_standard_json.n3_key) then tb_temp_standard_json.n3_value
						when ('装修类型'=tb_temp_standard_json.n4_key) then tb_temp_standard_json.n4_value
						when ('装修类型'=tb_temp_standard_json.n5_key) then tb_temp_standard_json.n5_value
						when ('装修类型'=tb_temp_standard_json.n6_key) then tb_temp_standard_json.n6_value
						when ('装修类型'=tb_temp_standard_json.n7_key) then tb_temp_standard_json.n7_value
						when ('装修类型'=tb_temp_standard_json.n8_key) then tb_temp_standard_json.n8_value
						when ('装修类型'=tb_temp_standard_json.n9_key) then tb_temp_standard_json.n9_value
						when ('装修类型'=tb_temp_standard_json.n10_key) then tb_temp_standard_json.n10_value
						when ('装修类型'=tb_temp_standard_json.n11_key) then tb_temp_standard_json.n11_value
						when ('装修类型'=tb_temp_standard_json.n12_key) then tb_temp_standard_json.n12_value
						when ('装修类型'=tb_temp_standard_json.n13_key) then tb_temp_standard_json.n13_value
						when ('装修类型'=tb_temp_standard_json.n14_key) then tb_temp_standard_json.n14_value
						when ('装修类型'=tb_temp_standard_json.n15_key) then tb_temp_standard_json.n15_value
						when ('装修类型'=tb_temp_standard_json.n16_key) then tb_temp_standard_json.n16_value
						else ''
						end  as b13
			from 
			(
				--- 将数据库中json和json_array格式的数据结构化，拉平
				select  
				(select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as create_time ,
				tcr.id,
				tcr.marked_result,
				json_extract_scalar(tcr.tag_result, '$.城市') as a1,
				json_extract_scalar(tcr.tag_result, '$.小区地址') as a2,
				json_extract_scalar(tcr.tag_result, '$.房屋面积') as a3,
				json_extract_scalar(tcr.tag_result, '$.工程量') as a4,
				json_extract_scalar(tcr.tag_result, '$.区县') as a5,
				json_extract_scalar(tcr.tag_result, '$.小区名称') as a6,
				json_extract_scalar(tcr.tag_result, '$.房屋类型') as a7,
				json_extract_scalar(tcr.tag_result, '$.街道') as a8,
				json_extract_scalar(tcr.tag_result, '$.姓氏') as a9,
				json_extract_scalar(tcr.tag_result, '$.时间') as a10,
				json_extract_scalar(tcr.tag_result, '$.手机号') as a11,
				json_extract_scalar(tcr.tag_result, '$.房屋用途') as a12,
				json_extract_scalar(tcr.tag_result, '$.装修类型') as a13
				--- 先按照顾问最多纠错16个标签计算。后面有需求，再增加
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[0]'), '$.tagName') as n1_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[0]'), '$.tagValue') as n1_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[1]'), '$.tagName') as n2_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[1]'), '$.tagValue') as n2_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[2]'), '$.tagName') as n3_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[2]'), '$.tagValue') as n3_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[3]'), '$.tagName') as n4_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[3]'), '$.tagValue') as n4_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[4]'), '$.tagName') as n5_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[4]'), '$.tagValue') as n5_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[5]'), '$.tagName') as n6_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[5]'), '$.tagValue') as n6_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[6]'), '$.tagName') as n7_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[6]'), '$.tagValue') as n7_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[7]'), '$.tagName') as n8_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[7]'), '$.tagValue') as n8_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[8]'), '$.tagName') as n9_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[8]'), '$.tagValue') as n9_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[9]'), '$.tagName') as n10_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[9]'), '$.tagValue') as n10_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[10]'), '$.tagName') as n11_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[10]'), '$.tagValue') as n11_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[11]'), '$.tagName') as n12_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[11]'), '$.tagValue') as n12_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[12]'), '$.tagName') as n13_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[12]'), '$.tagValue') as n13_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[13]'), '$.tagName') as n14_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[13]'), '$.tagValue') as n14_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[14]'), '$.tagName') as n15_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[14]'), '$.tagValue') as n15_value
				, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[15]'), '$.tagName') as n16_key, json_extract_scalar(JSON_EXTRACT(tcr.marked_result , '$[15]'), '$.tagValue') as n16_value
				from hive2.ads.v_hive2_ods_idc_new_t8t_nlp_fls_nlp_tag_content_record tcr
				where tcr.dt= ${hivevar_smart_chat_dt} 
				and tcr.bussiness_key ='intelligentPlatform'
				and tcr.session_id <> ''
				and tcr.marked_status =2
				-- TODO 测试
				--and tcr.create_time between ${hivevar_smart_chat_start_add_time} and ${hivevar_smart_chat_end_add_time}
				--and tcr.id = 134167  -- TODO  测试数据
			) as tb_temp_standard_json
		) as tb_temp_standard_json_format
	) as tb_temp_standard_json_format_sum
	group by tb_temp_standard_json_format_sum.create_time
)
;


---【2】每个槽位发送+收集情况
create table if not exists hive2.test.tmp_smart_chat_tb_slot_send_clollect as
(
	select tb_base.create_time, tb_base.valid_takeover_total, tb_base.invalid_takeover_total
	,tb_actual_send.check_type_code, tb_actual_send.actual_send_num 
	--,tb_collect.create_time ,tb_collect.check_type_code 
		,tb_collect.collect_num
	, round(cast(tb_collect.collect_num as double)/ tb_actual_send.actual_send_num, 2)  as  collect_rate
	from 
	(		-- 加微时间，总接管数, 有效托管数。    剔除首问之前取消托管数的托管数(机器人从没发言)
			select tb_temp.create_time
			, sum(case when tb_temp.staff_service_time > tb_temp.fisrt_robot_msg_send_time then 1 else 0 end) as valid_takeover_total
			, sum(case when tb_temp.staff_service_time <= tb_temp.fisrt_robot_msg_send_time then 1 else 0 end) as invalid_takeover_total
			from 
			(
				select (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as create_time
				, ccr.staff_service_time, tb_fisrt_msg_create_time.fisrt_robot_msg_send_time
				from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr
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
--						where tb_user_wechat.owner_wechat='19146449816' and tb_user_wechat.external_userid
--						in ('wmJiIbDAAA43RLz7Tkj9xOmyBxcPPkYg')
						group by tb_user_wechat.owner_wechat, tb_user_wechat.external_userid
					)
				) as tb_fisrt_msg_create_time
					on ccr.robot_id = tb_fisrt_msg_create_time.owner_wechat and ccr.uid = tb_fisrt_msg_create_time.external_userid 
				where 
				ccr.dt = ${hivevar_smart_chat_dt} 
				--and ccr.create_time  between ${hivevar_smart_chat_start_add_time} and ${hivevar_smart_chat_end_add_time}
				and tb_fisrt_msg_create_time.fisrt_robot_msg_send_time > 0
				and ccr.staff_service_time > tb_fisrt_msg_create_time.fisrt_robot_msg_send_time
				
				and ccr.robot_takeover_type =0 
				and ccr.conversation_template_id in (13, 20, 21)
				and ccr.transfer_manual_reason <> 1
			) tb_temp
			group by tb_temp.create_time
	) as tb_base
	left join 
	(		--- 单个槽位实际发送数
			select m.create_time, m.check_type_code, count(1) as actual_send_num
			from 
			(
				    select temp_ccr.create_time, ccd.chat_id, ccd.check_type_code, max(ccd.id) as id 
				    from 
				    ( 
					        select distinct chat_id
					        , (select to_unixtime(cast (getday(create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as create_time
					        from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr
					        where ccr.dt = ${hivevar_smart_chat_dt} and conversation_template_id in (13, 20, 21) and robot_takeover_type = 0 and transfer_manual_reason <> 1
				            --and ccr.create_time between ${hivevar_smart_chat_start_add_time} and ${hivevar_smart_chat_end_add_time}
				    ) as temp_ccr 
				    left join hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail ccd on temp_ccr.chat_id = ccd.chat_id 
				    where ccd.dt =  ${hivevar_smart_chat_dt} 
				    --and ccd.create_time  between ${hivevar_smart_chat_start_add_time} and ${hivevar_smart_chat_end_add_time}
				    and ccd.relate_message_id != '' 
				    group by temp_ccr.create_time, ccd.chat_id, ccd.check_type_code
			) m 
			inner join hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail n on m.id = n.id and n.dt =  ${hivevar_smart_chat_dt}
			group by m.create_time, m.check_type_code
	) as tb_actual_send
		on tb_base.create_time = tb_actual_send.create_time
	left join 
	(
		--- 槽位收集数	(机器人核需+小程序卡+项目核需  汇总)
			select tb_temp_detail.create_time, tb_temp_detail.check_type_code, count(tb_temp_detail.role_type) as collect_num
			from 
			(
				select (select to_unixtime(cast (getday(ccr.create_time,'yyyy-MM-dd 00:00:00') as timestamp)) - 8*3600) as create_time
				, ccd.check_type_code, ccd.role_type  , ccd.dt
				from hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_detail ccd
				left join hive2.ads.v_hive2_ods_idc_it4_t8t_tbt_tls_tls_smart_chat_conversation_record ccr
					on ccd.chat_id= ccr.chat_id 
				where ccd.dt = ${hivevar_smart_chat_dt} 
				and ccd.reply_time > 0 
				and ccd.role_type in (1,3,4)
				and ccr.dt = ${hivevar_smart_chat_dt} 
				and ccr.conversation_template_id in (13, 20, 21) 
				and ccr.robot_takeover_type = 0 
				and ccr.transfer_manual_reason <> 1
				--and ccr.create_time between ${hivevar_smart_chat_start_add_time} and ${hivevar_smart_chat_end_add_time}
			) tb_temp_detail
			group by tb_temp_detail.create_time, tb_temp_detail.check_type_code
			--order by tb_temp_detail.check_type_code asc
	) as tb_collect
		on tb_actual_send.create_time = tb_collect.create_time and tb_actual_send.check_type_code = tb_collect.check_type_code
	--order by tb_actual_send.check_type_code asc
)
;
	

drop table if exists hive2.test.tmp_smart_chat_slot_report  ;

create table if not exists hive2.test.tmp_smart_chat_slot_report as
(
	---【3】汇总表
		select 
		ssc.create_time --加微时间
		, ssc.valid_takeover_total --托管项目数
		, ssc.invalid_takeover_total  --无效托管项目数
		, 
		case ssc.check_type_code
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
		else ssc.check_type_code
		end as check_type_code  --槽位
		, ssc.actual_send_num --发送数
		, ssc.collect_num --收集数
		, ssc.collect_rate --收集率
		,tb_tmp_slot_check_union_group.check_num_sum --槽位识别抽检数
		,tb_tmp_slot_check_union_group.check_num_right_sum --槽位识别抽检准确数
		,tb_tmp_slot_check_union_group.check_num_right_sum_ratio  --槽位识别准确率
		from hive2.test.tmp_smart_chat_tb_slot_send_clollect ssc
		left join 
		(
			select tb_tmp_slot_check_union.create_time, tb_tmp_slot_check_union.slot_code
			, min(slot_name) as slot_name
			, sum(check_num_sum) as check_num_sum
			, sum(check_num_right_sum) as check_num_right_sum
			, round(cast(sum(check_num_right_sum) as double)/ sum(check_num_right_sum), 2)  as  check_num_right_sum_ratio
			from 
			(
				--表： tmp_smart_chat_tb_slot_check 开始列转行
				select t1.create_time as create_time, '城市' as slot_name, '7!711!71102!16' as slot_code, t1.check_num_sum_a1 as check_num_sum, t1.check_num_right_sum_a1 as check_num_right_sum, t1.check_num_right_sum_ratio_1	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '小区地址' as slot_name, '7!711!71102!3' as slot_code, t1.check_num_sum_a2 as check_num_sum, t1.check_num_right_sum_a2 as check_num_right_sum, t1.check_num_right_sum_ratio_2	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '房屋面积' as slot_name, '7!711!71102!2' as slot_code, t1.check_num_sum_a3 as check_num_sum, t1.check_num_right_sum_a3 as check_num_right_sum, t1.check_num_right_sum_ratio_3	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '工程量' as slot_name, '7!711!71102!8' as slot_code, t1.check_num_sum_a4 as check_num_sum, t1.check_num_right_sum_a4 as check_num_right_sum, t1.check_num_right_sum_ratio_4	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '区县' as slot_name, '7!711!71102!10' as slot_code, t1.check_num_sum_a5 as check_num_sum, t1.check_num_right_sum_a5 as check_num_right_sum, t1.check_num_right_sum_ratio_5	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '小区名称' as slot_name, '7!711!71102!3' as slot_code, t1.check_num_sum_a6 as check_num_sum, t1.check_num_right_sum_a6 as check_num_right_sum, t1.check_num_right_sum_ratio_6	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '房屋类型' as slot_name, '7!711!71102!4' as slot_code, t1.check_num_sum_a7 as check_num_sum, t1.check_num_right_sum_a7 as check_num_right_sum, t1.check_num_right_sum_ratio_7	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '街道' as slot_name, '7!711!71102!9' as slot_code, t1.check_num_sum_a8 as check_num_sum, t1.check_num_right_sum_a8 as check_num_right_sum, t1.check_num_right_sum_ratio_8	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '姓氏' as slot_name, '7!711!71102!11' as slot_code, t1.check_num_sum_a9 as check_num_sum, t1.check_num_right_sum_a9 as check_num_right_sum, t1.check_num_right_sum_ratio_9	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '时间' as slot_name, '7!711!71102!14' as slot_code, t1.check_num_sum_a10 as check_num_sum, t1.check_num_right_sum_a10 as check_num_right_sum, t1.check_num_right_sum_ratio_10	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '手机号' as slot_name, '7!711!71102!21' as slot_code, t1.check_num_sum_a11 as check_num_sum, t1.check_num_right_sum_a11 as check_num_right_sum, t1.check_num_right_sum_ratio_11	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '房屋用途' as slot_name, '7!711!71102!22' as slot_code, t1.check_num_sum_a12 as check_num_sum, t1.check_num_right_sum_a12 as check_num_right_sum, t1.check_num_right_sum_ratio_12	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				union select t1.create_time as create_time, '装修类型' as slot_name, '7!711!71102!34' as slot_code, t1.check_num_sum_a13 as check_num_sum, t1.check_num_right_sum_a13 as check_num_right_sum, t1.check_num_right_sum_ratio_13	 as check_num_right_sum_ratio  from hive2.test.tmp_smart_chat_tb_slot_check as t1
				--order by slot_code asc
			)as tb_tmp_slot_check_union
			group by tb_tmp_slot_check_union.create_time, tb_tmp_slot_check_union.slot_code
		) as tb_tmp_slot_check_union_group
			on ssc.create_time = tb_tmp_slot_check_union_group.create_time and ssc.check_type_code = tb_tmp_slot_check_union_group.slot_code

)

;

------------------------------------------------


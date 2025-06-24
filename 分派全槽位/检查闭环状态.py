import json
import base64
import re

none_list = ["", None, "None"]
allowed_spaces = {'厨房', '卫生间', '厨卫'}
allowed_details = {'水电', '水', '电'}
name_count = 0

"""
    按照指定的顺序排列
    data1   待排序的集合
    data2  按照这个模板排序
"""
def fun_sorted_by_default_arr(data1, data2):
    # data1 = ["bxx", "axx", "dxx", "foo", "cxx", "exx", "bar"]
    # data2 = ["axx", "bxx", "cxx", "dxx", "exx"]

    # 1. 按 data2 的顺序筛选并排序 data1 中的匹配项
    sorted_matched = [x for x in data2 if x in data1]

    # 2. 找出 data1 中未匹配的项
    unmatched = [x for x in data1 if x not in data2]

    # 3. 合并结果：先按 data2 顺序排列匹配项，再添加未匹配项
    return sorted_matched + unmatched


def main(data1="", data2="", data3="", data4="", data5="",
         data6="", data7="", data8="", data9="", data10="",
         data11="", data12=[], data13="", data14=[]):
    result = {}
    # 是否闭环
    close_flag = fun_close_flag(data1, data2, data3, data4, data5,
                                data6, data7, data8, data9, data10,
                                data11, data12, data13, data14)
    if close_flag:
        result["是否闭环"] = '是'
        result["finish"] = '核需完成'
        result["未收集槽位"] = []
        result["收集但不满足闭环的槽位"] = []
        result["每个槽位的状态"] = {}
        return result

    ## 未闭环，需要统计哪些槽位没有闭环
    result["是否闭环"] = '否'
    result["finish"] = '核需中'
    fun_no_collect_slot(data1, data2, data3, data4, data5,
                        data6, data7, data8, data9, data10,
                        data11, data12, result, data13, data14)

    ## 收集但不满足闭环的槽位
    fun_collect_but_no_close_slot(data1, data2, data3, data4, data5,
                                  data6, data7, data8, data9, data10,
                                  data11, data12, result, data13, data14)

    ## 每个槽位的状态。1-未收集 2-收集但不满足闭环 3-收集并且满足闭环
    fun_status_for_slot(data1, data2, data3, data4, data5,
                        data6, data7, data8, data9, data10,
                        data11, data12, result, data13, data14)

    return result

def fun_close_flag(data1, data2, data3, data4, data5,
                   data6, data7, data8, data9, data10,
                   data11, data12, data13, data14):
    close_flag = (data9 in none_list or data9 == '家装') and data1 == '90天内'
    close_flag = close_flag and all(arg not in none_list for arg in (data3, data4))
    close_flag = close_flag and data5 == '一个月内'
    # 是否交房
    close_flag = close_flag and (data10 == '是' or (data10 == '否' and data11 == '30天内'))

    house_type_is_closed = False
    # 判断房屋类型
    if '毛坯' in data2:
        house_type_is_closed = True
    elif '旧房翻新' in data2:
        # 判断整局改
        if '整改' in data8:
            house_type_is_closed = True
        else:
            # 判断空间和详情
            space_check = any(space in data8 for space in allowed_spaces)
            detail_check = any(detail in data8 for detail in allowed_details)

            house_type_is_closed = space_check and detail_check
    else:
        house_type_is_closed = False
    ## 整合房屋类型
    close_flag = close_flag and house_type_is_closed

    # 问过的问题类别。解析槽位的询问次数。这里只统计姓氏的询问次数
    # 询问过的槽位名
    split_result = []
    for question in data12:
        items = re.split(r'[、，,]', question)
        # 去除每个元素的前后空格并添加到结果
        split_result.extend([item.strip() for item in items if item.strip()])

    # 统计姓氏出现的次数
    name_count = sum(1 for item in split_result if "姓氏" in item)
    # 姓氏
    close_flag = close_flag and (name_count > 0 or data7 != '')
    return close_flag

def fun_collect_but_no_close_slot(data1, data2, data3, data4, data5,
                                  data6, data7, data8, data9, data10,
                                  data11, data12, result, data13, data14):
    collect_but_no_close_slot = []
    if data1 not in none_list and data1 != '90天内':
        collect_but_no_close_slot.append("装修时间")

    if data2 not in none_list:
        if '毛坯' in data2:
            pass
        elif '旧房翻新' in data2:
            if data8 in none_list or '整改' in data8:
                pass
            else:
                space_and_detail_source_str = data8.split('&')
                if len(space_and_detail_source_str) > 1:
                    space_and_detail_list_str = space_and_detail_source_str[1]
                    space_and_detail_list = re.split(r'[;|；]', space_and_detail_list_str)
                    space = ''
                    detail= ''
                    for space_and_detail in space_and_detail_list:
                        space_and_detail = space_and_detail.strip()
                        if space_and_detail.startswith('工程量-局改空间') or space_and_detail.startswith('工程量-否定局改空间'):
                            space = re.split(r'[:|：]', space_and_detail)[1]
                        if space_and_detail.startswith('工程量-局改详情') or space_and_detail.startswith('工程量-否定局改详情'):
                            detail = re.split(r'[:|：]', space_and_detail)[1]

                    if space != '':
                        if any(allowed_space in space for allowed_space in allowed_spaces):
                            pass
                        else:
                            collect_but_no_close_slot.append("工程量-局改空间")

                    if detail != '':
                        if any(allowed_detail in detail for allowed_detail in allowed_details):
                            pass
                        else:
                            collect_but_no_close_slot.append("工程量-局改详情")
                else:
                    collect_but_no_close_slot.append("工程量")
        else:
            collect_but_no_close_slot.append("房屋类型")

    if data5 not in none_list and data5 != '一个月内':
        collect_but_no_close_slot.append("量房时间")
    if data10 == '否':
        if data11 in none_list or data11 != '30天内':
            collect_but_no_close_slot.append("交房时间")

    result["收集但不满足闭环的槽位"] = fun_sorted_by_default_arr(collect_but_no_close_slot, data14)

def fun_status_for_slot(data1, data2, data3, data4, data5,
                        data6, data7, data8, data9, data10,
                        data11, data12, result, data13, data14):
    ## 每个槽位的状态。未收集 收集但不满足闭环
    status_for_slot = {}
    if data1 in none_list:
        status_for_slot["装修时间"] = "未收集"
    elif data1 != '90天内':
        status_for_slot["装修时间"] = "收集但不满足闭环"
    else:
        status_for_slot["装修时间"] = "收集并且满足闭环"

    if '毛坯' in data2:
        status_for_slot["房屋类型"] = "收集并且满足闭环"
    elif '旧房翻新' in data2:
        status_for_slot["房屋类型"] = "收集并且满足闭环"
        if data8 in none_list:
            status_for_slot["工程量"] = "未收集"
        elif '整改' in data8:
            status_for_slot["工程量"] = "收集并且满足闭环"
        else:
            space_and_detail_source_str = data8.split('&')
            if len(space_and_detail_source_str) > 1:
                space_and_detail_list_str = space_and_detail_source_str[1]
                space_and_detail_list = re.split(r'[;|；]', space_and_detail_list_str)
                space = ''
                detail= ''
                for space_and_detail in space_and_detail_list:
                    space_and_detail = space_and_detail.strip()
                    if space_and_detail.startswith('工程量-局改空间') or space_and_detail.startswith('工程量-否定局改空间'):
                        space = re.split(r'[:|：]', space_and_detail)[1]
                    if space_and_detail.startswith('工程量-局改详情') or space_and_detail.startswith('工程量-否定局改详情'):
                        detail = re.split(r'[:|：]', space_and_detail)[1]

                if space == '':
                    status_for_slot["工程量-局改空间"] = "未收集"
                else:
                    if any(allowed_space in space for allowed_space in allowed_spaces):
                        status_for_slot["工程量-局改空间"] = "收集并且满足闭环"
                    else:
                        status_for_slot["工程量-局改空间"] = "收集但不满足闭环"

                if detail == '':
                    status_for_slot["工程量-局改详情"] = "未收集"
                else:
                    if any(allowed_detail in detail for allowed_detail in allowed_details):
                        status_for_slot["工程量-局改详情"] = "收集并且满足闭环"
                    else:
                        status_for_slot["工程量-局改详情"] = "收集但不满足闭环"
            else:
                status_for_slot["工程量-局改空间"] = "未收集"
                status_for_slot["工程量-局改详情"] = "未收集"
    elif '精装房' in data2:
        status_for_slot["房屋类型"] = "收集并且满足闭环"
    else:
        status_for_slot["房屋类型"] = "未收集"

    if data3 in none_list:
        status_for_slot["小区名称"] = "未收集"
    else:
        status_for_slot["小区名称"] = "收集并且满足闭环"

    if data4 in none_list:
        status_for_slot["房屋面积"] = "未收集"
    else:
        status_for_slot["房屋面积"] = "收集并且满足闭环"

    if data5 in none_list:
        status_for_slot["量房时间"] = "未收集"
    elif data5 != '一个月内':
        status_for_slot["量房时间"] = "收集但不满足闭环"
    else:
        status_for_slot["量房时间"] = "收集并且满足闭环"

    if data6 in none_list:
        status_for_slot["装修用途"] = "未收集"
    else:
        status_for_slot["装修用途"] = "收集并且满足闭环"

    if data7 in none_list:
        status_for_slot["姓氏"] = "未收集"
    else:
        status_for_slot["姓氏"] = "收集并且满足闭环"

    if data9 in none_list:
        status_for_slot["装修类型"] = "未收集"
    else:
        status_for_slot["装修类型"] = "收集并且满足闭环"

    if data10 == '否':
        status_for_slot["是否交房"] = "收集并且满足闭环"
        if data11 in none_list:
            status_for_slot["交房时间"] = "未收集"
        elif data11 == '30天内':
            status_for_slot["交房时间"] = "收集并且满足闭环"
        else:
            status_for_slot["交房时间"] = "收集但不满足闭环"
    elif data10 == '是':
        status_for_slot["是否交房"] = "收集并且满足闭环"
    else:
        status_for_slot["是否交房"] = "未收集"

    if data13 in none_list:
        status_for_slot["城市"] = "未收集"
    else:
        status_for_slot["城市"] = "收集并且满足闭环"

    result["每个槽位的状态"] = fun_sorted_by_default_arr(status_for_slot, data14)

def fun_no_collect_slot(data1, data2, data3, data4, data5,
                        data6, data7, data8, data9, data10,
                        data11, data12, result, data13, data14):
    no_collect_slot = []
    # 检查未收集槽位
    if data1 in none_list:
        no_collect_slot.append("装修时间")

    if '毛坯' in data2:
        pass
    elif '旧房翻新' in data2:
        if data8 in none_list:
            no_collect_slot.append("工程量")
        elif '整改' in data8:
            pass
        else:
            space_and_detail_source_str = data8.split('&')
            if len(space_and_detail_source_str) > 1:
                space_and_detail_list_str = space_and_detail_source_str[1]
                space_and_detail_list = re.split(r'[;|；]', space_and_detail_list_str)
                space = ''
                detail= ''
                for space_and_detail in space_and_detail_list:
                    space_and_detail = space_and_detail.strip()
                    if space_and_detail.startswith('工程量-局改空间') or space_and_detail.startswith('工程量-否定局改空间'):
                        space = re.split(r'[:|：]', space_and_detail)[1]
                    if space_and_detail.startswith('工程量-局改详情') or space_and_detail.startswith('工程量-否定局改详情'):
                        detail = re.split(r'[:|：]', space_and_detail)[1]

                if space == '':
                    no_collect_slot.append("工程量-局改空间")

                if detail == '':
                    no_collect_slot.append("工程量-局改详情")
            else:
                no_collect_slot.append("工程量-局改空间")
                no_collect_slot.append("工程量-局改详情")
    else:
        no_collect_slot.append("房屋类型")

    if data3 in none_list:
        no_collect_slot.append("小区名称")
    if data4 in none_list:
        no_collect_slot.append("房屋面积")
    if data5 in none_list:
        no_collect_slot.append("量房时间")
    if data6 in none_list:
        no_collect_slot.append("装修用途")

    if data10 in none_list:
        no_collect_slot.append("是否交房")
    elif data10 == '是':
        pass
    else:
        if data11 in none_list:
            no_collect_slot.append("交房时间")

    if name_count == 0 and data7 == '':
        no_collect_slot.append("姓氏")

    result["未收集槽位"] = fun_sorted_by_default_arr(no_collect_slot, data14)









params = {
    "data1": "90天内",
    "data2": "旧房翻新",
    "data3": "径贝新村100868号",
    "data4": "1000个平",
    "data5": "一个月内",
    "data6": "自",
    "data7": "",
    "data8": "不用&工程量-否定局改空间：厨房，卫生间；工程量-否定局改详情:水电",
    "data9": "",
    "data10": "",
    "data11": "30天内",
    "data12": [
        "开场白、询问用户称呼、询问房屋位置、询问小区名称、询问房屋面积、询问房屋类型、询问房屋用途,询问装修时间,询问是否交房,询问量房时间",
        "开场白、询问用户称呼、询问房屋位置、询"
    ],
    "data13": "深圳",
    "data14": [
        "装修时间","工程量","工程量-局改空间","工程量-局改详情","房屋类型","小区名称","城市","房屋面积","量房时间","装修用途","是否交房","交房时间","姓氏"
    ]
}

if __name__ == '__main__':
    result = main(**params)
    print(json.dumps(result, ensure_ascii=False))
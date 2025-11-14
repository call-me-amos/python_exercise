# -*- coding: utf-8 -*-
import os
import sys
from datetime import datetime, timedelta

from bson import ObjectId

import whole_process.data_analysis.tag_for_history_dialogue as tag_for_history_dialogue
from mongoDB_utils.mongo_client import MongoDBClient

# 添加项目根目录到 Python 路径
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..'))
import whole_process.归因_回测.common as common


def init_config_and_time():
    """初始化配置和时间范围"""
    now = datetime.now()
    # 指定哪一天（凌晨跑前一天的数据）
    base_datetime = datetime.now() - timedelta(days=1)
    base_date_format = base_datetime.strftime("%Y-%m-%d")

    start_time = datetime.strptime(f"{base_date_format} 00:00:00", "%Y-%m-%d %H:%M:%S")
    end_time = datetime.strptime(f"{base_date_format} 12:00:00", "%Y-%m-%d %H:%M:%S")

    return now, start_time, end_time, base_datetime


def save_single_result_to_excel(result_data, data_date, file_name):
    """保存单个结果到Excel文件"""
    if result_data:
        output_file = f"C:/Users/amos.tong/Desktop/归因/数据分析_每天/{file_name}-回测-结果-{data_date.strftime('%Y-%m-%d')}.xlsx"
        common.write_to_excel(result_data, output_file)
        print(f"{file_name}数据处理完成，共处理 {len(result_data)} 条记录")
        return f"{file_name}: 已保存 {len(result_data)} 条记录"
    return f"{file_name}: 无数据需要保存"


def process_data_batches(mongo_client, start_time, end_time):
    api_key, fastgpt_api_url = tag_for_history_dialogue.init_config()

    page_size = 500
    skip_count = 0
    batch_count = 0

    all_results = []  # 改名避免混淆

    while True:
        batch_count += 1
        print(f"正在查询第 {batch_count} 批数据，跳过 {skip_count} 条记录，每页 {page_size} 条...")

        # 测试代码
        # page_size = 20
        if batch_count > 5:
            break

        try:
            # 查询MongoDB数据 - 使用skip/limit分页
            data_list = mongo_client.find_many(
                collection_name="chatitems",
                filter_dict={
                    "appId": ObjectId("68bfbd1d0d3c3dd5b3434fec"),
                    "time": {"$gte": start_time, "$lte": end_time}
                },
                # sort_fields=[("time", 1)],
                skip=skip_count,
                limit=page_size,
                # allow_disk_use=True
            )
        except Exception as mongo_e:
            print("mongodb查询数据异常， {mongo_e}")
            data_list = None

        if not data_list:
            print("数据查询完毕，结束循环")
            break

        print(f"本批查询到 {len(data_list)} 条数据")

        batch_result = tag_for_history_dialogue.process_all_rows(1000, api_key, fastgpt_api_url, data_list)
        print(f"本批结果数量: {len(batch_result)}")

        # 将本批结果添加到总结果中
        all_results.extend(batch_result)

        # 更新skip_count为下一页的起始位置
        skip_count += len(data_list)
        print(f"下次查询将跳过 {skip_count} 条记录")

        # 如果返回的数据少于page_size，说明已经是最后一页
        if len(data_list) < page_size:
            print("已到达最后一页，结束循环")
            break
    return all_results


def task():
    """主任务函数"""
    print("主任务函数")
    today_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"开始时间：{today_date}        task 开始处理。。。。。")
    mongo_client = MongoDBClient()
    try:
        # 连接到MongoDB
        if mongo_client.connect():
            # 初始化时间范围
            now, start_time, end_time, base_datetime = init_config_and_time()

            # 处理数据批次
            results_dict = process_data_batches(mongo_client, start_time, end_time)

            # 将results_dict按照phoneId+fastgpt_message_time排序
            results_dict.sort(key=lambda x: (x.get('phoneId', ''), x.get('fastgpt_message_time', '')))

            # 保存数据到excel
            save_single_result_to_excel(results_dict, base_datetime, '历史数据打标签')

    except Exception as ex:
        print(f"操作过程中发生异常: {ex}")
    finally:
        # 确保在任何情况下都关闭连接
        mongo_client.disconnect()

    today_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"结束时间：{today_date}        over。。。。")


if __name__ == "__main__":
    task()

from mongoDB_utils.mongo_client import MongoDBClient
from bson import ObjectId
from datetime import datetime, timedelta
import time
import sys
import os

# 添加项目根目录到 Python 路径
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..'))
import whole_process.归因_回测.emotional_backtest as emotional_backtest
import whole_process.归因_回测.common as common

def task():
    mongo_client = MongoDBClient()
    try:
        # 连接到MongoDB
        if mongo_client.connect():
            # 初始化配置信息
            api_key, fastgpt_api_url = emotional_backtest.init_config()
            print(f"配置初始化完成，API URL: {fastgpt_api_url}")
            
            # 初始化结果列表
            emotions_result = []
            # 指定时间范围查询 - 当天指定时间段
            now = datetime.now()
            today = now.strftime("%Y-%m-%d %H:%M:%S")
            today_date = now.strftime("%Y-%m-%d")
            start_time = datetime.strptime(f"{today_date} 10:00:00", "%Y-%m-%d %H:%M:%S")
            end_time = datetime.strptime(f"{today_date} 11:00:00", "%Y-%m-%d %H:%M:%S")
            
            page_size = 500
            last_time = start_time  # 记录上次查询的最大时间
            batch_count = 0

            # 1、循环从mongodb中查询数据（每次500条，间隔5秒）
            while True:
                batch_count += 1
                print(f"正在查询第 {batch_count} 批数据，从时间 {last_time} 开始...")
                
                # 查询MongoDB数据 - 使用时间范围查询
                data_list = mongo_client.find_many(
                    collection_name="chatitems",
                    filter_dict={
                        "appId": ObjectId("6892c47a9b3d87c33c3ac78f"),
                        "time": {"$gte": last_time, "$lt": end_time}
                    },
                    sort_fields=[("time", 1)],  # 按时间升序排序
                    skip=0,
                    limit=page_size
                )
                
                # 如果data_list为空，结束循环
                if not data_list:
                    print("数据查询完毕，结束循环")
                    break
                
                print(f"本批查询到 {len(data_list)} 条数据")
                
                # 调用 情绪价值承接-回测.py中process_all_rows方法
                batch_result = emotional_backtest.process_all_rows(1000, api_key, fastgpt_api_url,data_list)
                
                # 将执行结果追加到emotions_result
                emotions_result.extend(batch_result)
                print(f"本批处理完成，累计结果数量: {len(emotions_result)}")
                
                # 更新last_time为当前批次最大的时间值，准备查询下一批
                last_time = data_list[-1]['time']  # 取最后一条数据的时间作为下次查询的起始时间
                print(f"下次查询将从时间 {last_time} 开始")
                
                # 间隔5秒
                print("等待5秒后继续...")
                time.sleep(5)

            # 循环结束后，将emotions_result 保存到excel
            emotions_output_file = f"C:/Users/amos.tong/Desktop/归因_每天/情绪价值承接-回测-结果-{now.strftime('%Y-%m-%d_%H-%M-%S')}.xlsx"
            
            if emotions_result:
                common.write_to_excel(emotions_result, emotions_output_file)
                print(f"所有数据处理完成，共处理 {len(emotions_result)} 条记录")
            else:
                print("没有数据需要保存")

    except Exception as e:
        print(f"操作过程中发生异常: {e}")
    finally:
        # 确保在任何情况下都关闭连接
        mongo_client.disconnect()
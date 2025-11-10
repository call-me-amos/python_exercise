from mongoDB_utils.mongo_client import MongoDBClient
from bson import ObjectId
from datetime import datetime, timedelta
import pandas as pd

# 使用示例
if __name__ == "__main__":
    # 创建MongoDB客户端实例
    mongo_client = MongoDBClient()

    try:
        # 连接到MongoDB
        if mongo_client.connect():
            print("@@@@@@ 通过工作流名称，查询工作流信息 @@@@@@ ")
            result = mongo_client.find_many(
                collection_name="apps",
                filter_dict={
                    "name": "4 收集核心信息-设计类2.0-时间压缩",
                    "tmbId": ObjectId("675660fc47912cc8ae84319a") ## 分组
                },
                sort_fields=[("time", -1)],  # 按时间升序排序，1表示升序
                skip=0,
                limit=4
            )
            # 格式化打印结果，类似excel表格
            if result:
                df = pd.DataFrame(result)
                print("\n工作流信息表格:")
                print(df.to_string(index=False, max_cols=None, max_colwidth=50))
            else:
                print("未找到匹配的工作流信息")
            print("@@@@@@ 通过工作流名称，查询工作流信息 @@@@@@ ")


            # 模拟时间范围查询
            end_time = datetime.now()
            start_time = end_time - timedelta(days=1)  # 查询最近7天的数据

            # 仿照参考代码：根据appId和时间范围查询，按时间升序排序，跳过前0条，限制400条
            complex_docs = mongo_client.find_many(
                collection_name="chatitems",
                filter_dict={
                    "appId": ObjectId("68bfbd1d0d3c3dd5b3434fec"),
                    "time": {"$gte": start_time, "$lt": end_time}
                },
                sort_fields=[("time", -1)],  # 按时间升序排序，1表示升序
                skip=0,
                limit=4
            )
            print(f"复杂查询结果数量: {len(complex_docs)}")

            # 5. 多字段排序示例
            multi_sort_docs = mongo_client.find_many(
                collection_name="chatitems",
                filter_dict={"age": {"$gte": 18}},
                sort_fields=[("age", -1), ("name", 1)],  # 先按年龄降序，再按姓名升序
                limit=20
            )
            print(f"多字段排序结果: {multi_sort_docs}")

            # 6. 分页查询示例
            page_size = 10
            page_num = 2  # 第2页（从1开始计数）
            paginated_docs = mongo_client.find_many(
                collection_name="chatitems",
                filter_dict={},
                sort_fields=[("_id", 1)],
                skip=(page_num - 1) * page_size,
                limit=page_size
            )
            print(f"第{page_num}页数据: {paginated_docs}")
    except Exception as e:
        print(f"操作过程中发生异常: {e}")
    finally:
        # 确保在任何情况下都关闭连接
        mongo_client.disconnect()
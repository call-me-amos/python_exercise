from mongoDB_utils.mongo_client import MongoDBClient
from bson import ObjectId
from datetime import datetime, timedelta

# 使用示例
if __name__ == "__main__":
    # 创建MongoDB客户端实例
    mongo_client = MongoDBClient()

    try:
        # 连接到MongoDB
        if mongo_client.connect():
            # 4. 仿照参考代码的复杂查询示例

            # 模拟时间范围查询
            end_time = datetime.now()
            start_time = end_time - timedelta(days=1)  # 查询最近7天的数据

            # 仿照参考代码：根据appId和时间范围查询，按时间升序排序，跳过前0条，限制400条
            complex_docs = mongo_client.find_many(
                collection_name="openapis",
                #collection_name="chatitems",
                #collection_name="chatitems",
                filter_dict={
                    "apiKey": "fastgpt-hvz4h5dA1VqX8UdOBsqRET7SL6ifTfrwtD7JpFAGC3xe2BmQt3O4"
                },
                #sort_fields=[("time", -1)],  # 按时间升序排序，1表示升序
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
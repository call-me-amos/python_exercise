import pymongo
from pymongo import MongoClient
from typing import Optional, Dict, Any, List
from bson import ObjectId
from datetime import datetime, timedelta

class MongoDBClient:
    def __init__(self,
                 connection_string: str = "mongodb://myusername:mypassword@10.50.1.186:27017/?directConnection=true&authSource=admin",
                 database_name: str = "fastgpt",
                 ):
        """
        初始化MongoDB连接
        
        Args:
            connection_string: MongoDB连接字符串
            database_name: 数据库名称
        """
        self.connection_string = connection_string
        self.database_name = database_name
        self.client: Optional[MongoClient] = None
        self.db = None
        
    def connect(self) -> bool:
        """
        连接到MongoDB
        
        Returns:
            bool: 连接是否成功
        """
        try:
            self.client = MongoClient(self.connection_string)
            # 测试连接
            self.client.admin.command('ping')
            self.db = self.client[self.database_name]
            print(f"成功连接到MongoDB数据库: {self.database_name}")
            return True
        except Exception as e:
            print(f"连接MongoDB失败: {e}")
            return False
    
    def disconnect(self):
        """关闭MongoDB连接"""
        if self.client:
            self.client.close()
            print("MongoDB连接已关闭")
    
    def insert_one(self, collection_name: str, document: Dict[str, Any]) -> Optional[str]:
        """
        插入单个文档
        
        Args:
            collection_name: 集合名称
            document: 要插入的文档
            
        Returns:
            str: 插入文档的ID，失败返回None
        """
        try:
            collection = self.db[collection_name]
            result = collection.insert_one(document)
            return str(result.inserted_id)
        except Exception as e:
            print(f"插入文档失败: {e}")
            return None
    
    def insert_many(self, collection_name: str, documents: List[Dict[str, Any]]) -> List[str]:
        """
        插入多个文档
        
        Args:
            collection_name: 集合名称
            documents: 要插入的文档列表
            
        Returns:
            List[str]: 插入文档的ID列表
        """
        try:
            collection = self.db[collection_name]
            result = collection.insert_many(documents)
            return [str(id) for id in result.inserted_ids]
        except Exception as e:
            print(f"批量插入文档失败: {e}")
            return []
    
    def find_one(self, collection_name: str, filter_dict: Dict[str, Any] = None) -> Optional[Dict[str, Any]]:
        """
        查找单个文档
        
        Args:
            collection_name: 集合名称
            filter_dict: 查询条件
            
        Returns:
            Dict: 查找到的文档，未找到返回None
        """
        try:
            collection = self.db[collection_name]
            return collection.find_one(filter_dict)
        except Exception as e:
            print(f"查找文档失败: {e}")
            return None
    
    def find_many(self, collection_name: str, filter_dict: Dict[str, Any] = None, limit: int = 0, sort_fields: List[tuple] = None, skip: int = 0) -> List[Dict[str, Any]]:
        """
        查找多个文档，支持排序和跳过
        
        Args:
            collection_name: 集合名称
            filter_dict: 查询条件
            limit: 限制返回数量，0表示无限制
            sort_fields: 排序字段列表，格式如 [("field1", 1), ("field2", -1)]，1为升序，-1为降序
            skip: 跳过的文档数量
            
        Returns:
            List[Dict]: 查找到的文档列表
        """
        try:
            collection = self.db[collection_name]
            cursor = collection.find(filter_dict)
            
            if sort_fields:
                cursor = cursor.sort(sort_fields)
            
            if skip > 0:
                cursor = cursor.skip(skip)
                
            if limit > 0:
                cursor = cursor.limit(limit)
                
            return list(cursor)
        except Exception as e:
            print(f"查找文档失败: {e}")
            return []
    
    def update_one(self, collection_name: str, filter_dict: Dict[str, Any], update_dict: Dict[str, Any]) -> bool:
        """
        更新单个文档
        
        Args:
            collection_name: 集合名称
            filter_dict: 查询条件
            update_dict: 更新内容
            
        Returns:
            bool: 更新是否成功
        """
        try:
            collection = self.db[collection_name]
            result = collection.update_one(filter_dict, {"$set": update_dict})
            return result.modified_count > 0
        except Exception as e:
            print(f"更新文档失败: {e}")
            return False
    
    def delete_one(self, collection_name: str, filter_dict: Dict[str, Any]) -> bool:
        """
        删除单个文档
        
        Args:
            collection_name: 集合名称
            filter_dict: 查询条件
            
        Returns:
            bool: 删除是否成功
        """
        try:
            collection = self.db[collection_name]
            result = collection.delete_one(filter_dict)
            return result.deleted_count > 0
        except Exception as e:
            print(f"删除文档失败: {e}")
            return False
    
    def count_documents(self, collection_name: str, filter_dict: Dict[str, Any] = None) -> int:
        """
        统计文档数量
        
        Args:
            collection_name: 集合名称
            filter_dict: 查询条件
            
        Returns:
            int: 文档数量
        """
        try:
            collection = self.db[collection_name]
            return collection.count_documents(filter_dict or {})
        except Exception as e:
            print(f"统计文档失败: {e}")
            return 0


# 使用示例
if __name__ == "__main__":
    # 创建MongoDB客户端实例
    mongo_client = MongoDBClient()
    
    try:
        # 连接到MongoDB
        if mongo_client.connect():
            # 插入文档
            document = {"name": "张三", "age": 25, "city": "北京"}
            doc_id = mongo_client.insert_one("chatitems", document)
            print(f"插入文档ID: {doc_id}")

            # 查找单个文档
            found_doc = mongo_client.find_one("chatitems", {"name": "张三"})
            print(f"查找到的文档: {found_doc}")

            # 查找多个文档 - find_many 示例
            # 1. 查找所有年龄大于20的文档，限制返回5条
            docs = mongo_client.find_many("chatitems", {"age": {"$gt": 20}}, limit=5)
            print(f"年龄大于20的文档: {docs}")

            # 2. 查找所有文档（无条件查询）
            all_docs = mongo_client.find_many("chatitems", limit=10)
            print(f"所有文档（前10条）: {all_docs}")

            # 3. 根据城市查找文档
            beijing_docs = mongo_client.find_many("chatitems", {"city": "北京"})
            print(f"北京的用户: {beijing_docs}")
            
            # 4. 仿照参考代码的复杂查询示例
            
            # 模拟时间范围查询
            end_time = datetime.now()
            start_time = end_time - timedelta(days=7)  # 查询最近7天的数据
            
            # 仿照参考代码：根据appId和时间范围查询，按时间升序排序，跳过前0条，限制400条
            complex_docs = mongo_client.find_many(
                collection_name="chatitems",
                filter_dict={
                    "appId": ObjectId("6892c47a9b3d87c33c3ac78f"),
                    "time": {"$gte": start_time, "$lt": end_time}
                },
                sort_fields=[("time", 1)],  # 按时间升序排序，1表示升序
                skip=0,
                limit=400
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

            # 更新文档
            updated = mongo_client.update_one("chatitems", {"name": "张三"}, {"age": 26})
            print(f"更新成功: {updated}")

            # 统计文档数量
            count = mongo_client.count_documents("chatitems")



    except Exception as e:
        print(f"操作过程中发生异常: {e}")
    finally:
        # 确保在任何情况下都关闭连接
        mongo_client.disconnect()
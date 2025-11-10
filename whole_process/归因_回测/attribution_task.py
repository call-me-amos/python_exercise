from mongoDB_utils.mongo_client import MongoDBClient
from bson import ObjectId
from datetime import datetime, timedelta
import time
import sys
import os

# 添加项目根目录到 Python 路径
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..'))
import whole_process.归因_回测.emotional_backtest as emotional_backtest
import whole_process.归因_回测.new_qa_backtest as new_qa_backtest
import whole_process.归因_回测.fusion_backtest as fusion_backtest
import whole_process.归因_回测.SOP_question_backtest as SOP_question_backtest
import whole_process.归因_回测.professional_advice_backtest as professional_advice_backtest
import whole_process.归因_回测.guide_task_backtest as guide_task_backtest
import whole_process.归因_回测.system_interaction_issues_backtest as system_interaction_issues_backtest
import whole_process.归因_回测.common as common
from concurrent.futures import ThreadPoolExecutor, as_completed
import threading

def init_config_and_time():
    """初始化配置和时间范围"""
    now = datetime.now()
    today_date = now.strftime("%Y-%m-%d")
    start_time = datetime.strptime(f"{today_date} 00:00:00", "%Y-%m-%d %H:%M:%S")
    end_time = datetime.strptime(f"{today_date} 10:30:00", "%Y-%m-%d %H:%M:%S")
    
    return now, start_time, end_time

def process_single_backtest(backtest_module, data_list, result_key):
    """处理单个回测模块"""
    try:
        api_key, fastgpt_api_url = backtest_module.init_config()
        batch_result = backtest_module.process_all_rows(1000, api_key, fastgpt_api_url, data_list)
        print(f"{result_key}本批处理完成，结果数量: {len(batch_result)}")
        return result_key, batch_result
    except Exception as e:
        print(f"{result_key}处理失败: {e}")
        return result_key, []

def process_all_backtests(data_list, results_dict):
    """并行处理所有回测模块"""
    backtest_configs = [
        (emotional_backtest, 'emotions_result'),
        (new_qa_backtest, 'new_qa_result'),
        (fusion_backtest, 'fusion_result'),
        (SOP_question_backtest, 'SOP_question_result'),
        (professional_advice_backtest, 'professional_advice_result'),
        (guide_task_backtest, 'guide_task_result'),
        (system_interaction_issues_backtest, 'system_interaction_issues_result')
    ]
    
    # 使用线程池并行执行
    with ThreadPoolExecutor(max_workers=7) as executor:
        future_to_key = {executor.submit(process_single_backtest, module, data_list, key): key 
                        for module, key in backtest_configs}
        
        for future in as_completed(future_to_key):
            result_key, batch_result = future.result()
            results_dict[result_key].extend(batch_result)
            print(f"{result_key}累计结果数量: {len(results_dict[result_key])}")


def save_single_result_to_excel(result_key, result_data, now, file_name):
    """保存单个结果到Excel文件"""
    if result_data:
        output_file = f"C:/Users/amos.tong/Desktop/归因_每天/{file_name}-回测-结果-{now.strftime('%Y-%m-%d_%H-%M-%S')}.xlsx"
        common.write_to_excel(result_data, output_file)
        print(f"{result_key}数据处理完成，共处理 {len(result_data)} 条记录")
        return f"{result_key}: 已保存 {len(result_data)} 条记录"
    return f"{result_key}: 无数据需要保存"

def save_results_to_excel(results_dict, now):
    """并行保存所有结果到Excel文件"""
    save_tasks = [
        ('emotions_result', results_dict['emotions_result'], '情绪价值承接'),
        ('new_qa_result', results_dict['new_qa_result'], '新版QA'),
        ('fusion_result', results_dict['fusion_result'], '融合'),
        ('SOP_question_result', results_dict['SOP_question_result'], 'SOP-问题'),
        ('professional_advice_result', results_dict['professional_advice_result'], '知识-专业性建议问题'),
        ('guide_task_result', results_dict['guide_task_result'], '引导任务'),
        ('system_interaction_issues_result', results_dict['system_interaction_issues_result'], '系统交互问题')
    ]
    
    with ThreadPoolExecutor(max_workers=7) as executor:
        future_to_key = {executor.submit(save_single_result_to_excel, key, data, now, file_name): key 
                        for key, data, file_name in save_tasks}
        
        for future in as_completed(future_to_key):
            result = future.result()
            print(result)

def process_data_batches(mongo_client, start_time, end_time):
    """处理数据批次循环"""
    results_dict = {
        'emotions_result': [],
        'new_qa_result': [],
        'fusion_result': [],
        'SOP_question_result': [],
        'professional_advice_result': [],
        'guide_task_result': [],
        'system_interaction_issues_result': []
    }
    
    page_size = 500
    last_time = start_time
    batch_count = 0

    while True:
        batch_count += 1
        print(f"正在查询第 {batch_count} 批数据，从时间 {last_time} 开始... 结束时间：{end_time}")
        
        # 查询MongoDB数据
        data_list = mongo_client.find_many(
            collection_name="chatitems",
            filter_dict={
                "appId": ObjectId("68bfbd1d0d3c3dd5b3434fec"),
                "time": {"$gte": last_time, "$lt": end_time}
            },
            sort_fields=[("time", 1)],
            skip=0,
            limit=page_size
        )
        
        if not data_list:
            print("数据查询完毕，结束循环")
            break
        
        print(f"本批查询到 {len(data_list)} 条数据")
        
        # 处理所有回测
        process_all_backtests(data_list, results_dict)
        
        # 更新last_time为当前批次最大的时间值
        last_time = data_list[-1]['time']
        print(f"下次查询将从时间 {last_time} 开始")
        
        # 间隔5秒
        print("等待5秒后继续...")
        time.sleep(5)
    
    return results_dict

def task():
    """主任务函数"""
    mongo_client = MongoDBClient()
    try:
        # 连接到MongoDB
        if mongo_client.connect():
            # 初始化时间范围
            now, start_time, end_time = init_config_and_time()
            
            # 处理数据批次
            results_dict = process_data_batches(mongo_client, start_time, end_time)
            
            # 保存所有结果到Excel
            save_results_to_excel(results_dict, now)

    except Exception as e:
        print(f"操作过程中发生异常: {e}")
    finally:
        # 确保在任何情况下都关闭连接
        mongo_client.disconnect()


if __name__ == "__main__":
    print("task 开始处理。。。。。")
    task()
    print("over。。。。")

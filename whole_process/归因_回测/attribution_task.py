import os
import sys
from datetime import datetime, timedelta

from bson import ObjectId

from mongoDB_utils.mongo_client import MongoDBClient
from whole_process.归因_回测.utils import excel_to_image_pillow, send_post_img_message

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
import os
import pandas as pd


def init_config_and_time():
    """初始化配置和时间范围"""
    now = datetime.now()
    # 指定哪一天（凌晨跑前一天的数据）
    base_datetime = datetime.now() - timedelta(days=1)
    base_date_format = base_datetime.strftime("%Y-%m-%d")

    start_time = datetime.strptime(f"{base_date_format} 00:00:00", "%Y-%m-%d %H:%M:%S")
    end_time = datetime.strptime(f"{base_date_format} 12:00:00", "%Y-%m-%d %H:%M:%S")

    return now, start_time, end_time, base_datetime


def process_single_backtest(backtest_module, data_list, result_key):
    """处理单个回测模块"""
    try:
        api_key, fastgpt_api_url = backtest_module.init_config()
        batch_result = backtest_module.process_all_rows(1000, api_key, fastgpt_api_url, data_list)
        print(f"{result_key}本批处理完成，结果数量: {len(batch_result)}")
        return result_key, batch_result
    except Exception as ex:
        print(f"{result_key}处理失败: {ex}")
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


def save_single_result_to_excel(result_key, result_data, data_date, file_name):
    """保存单个结果到Excel文件"""
    if result_data:
        output_file = f"C:/Users/amos.tong/Desktop/归因/归因_每天/{file_name}-回测-结果-{data_date.strftime('%Y-%m-%d')}.xlsx"
        common.write_to_excel(result_data, output_file)
        print(f"{result_key}数据处理完成，共处理 {len(result_data)} 条记录")
        return f"{result_key}: 已保存 {len(result_data)} 条记录"
    return f"{result_key}: 无数据需要保存"


def save_results_to_excel(results_dict, data_date):
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
        future_to_key = {executor.submit(save_single_result_to_excel, key, data, data_date, file_name): key
                         for key, data, file_name in save_tasks}

        for future in as_completed(future_to_key):
            result = future.result()
            print(f'future.result={result}')


def get_percentage(data_list, column_name, target_value):
    """计算指定列中目标值的占比"""
    if not data_list or len(data_list) == 0:
        return 0
    total = len(data_list)
    count = sum(1 for item in data_list if item.get(column_name) == target_value)
    return round(count / total * 100, 2)


def analyze_single_file(file_path, file_name, date_str):
    """分析单个Excel文件"""
    if not os.path.exists(file_path):
        print(f"文件不存在: {file_path}")
        return None

    try:
        df = pd.read_excel(file_path)
        data_list = df.to_dict('records')

        result = {'date': date_str}

        # 根据不同的文件类型计算不同的统计指标
        if '情绪价值承接' in file_name:
            result['【情绪价值承接】情绪标签是否一致'] = get_percentage(data_list, '情绪标签是否一致', '是')
            result['【情绪价值承接】综合回复是否一致'] = get_percentage(data_list, '综合回复是否一致', '是')

        elif '新版QA' in file_name:
            result['【新版QA】QA回复是否流畅'] = get_percentage(data_list, 'QA回复是否流畅', '是')

        elif '融合' in file_name:
            result['【融合】推荐承接话术不合理'] = get_percentage(data_list, '推荐承接话术不合理', '是')

        elif 'SOP-问题' in file_name:
            result['【SOP-问题】未满足派单标准'] = get_percentage(data_list, '未满足派单标准', '是')
            result['【SOP-问题】用户表达不着急'] = get_percentage(data_list, '用户表达不着急', '是')
            result['【SOP-问题】负向情绪'] = get_percentage(data_list, '负向情绪', '是')
            result['【SOP-问题】询问是否AI'] = get_percentage(data_list, '询问是否AI', '是')
            result['【SOP-问题】用户未回复'] = get_percentage(data_list, '用户未回复', '是')

        elif '知识-专业性建议问题' in file_name:
            result['【知识-专业性建议问题】QA回复话术是否合适'] = get_percentage(data_list, 'QA回复话术是否合适', '否')
            result['【知识-专业性建议问题】专业性建议是否合适'] = get_percentage(data_list, '专业性建议是否合适', '否')

        elif '引导任务' in file_name:
            result['【引导任务】ner提取结果是否一致'] = get_percentage(data_list, 'ner提取结果是否一致', '是')

        elif '系统交互问题' in file_name:
            result['【系统交互问题】提取结果'] = get_percentage(data_list, '提取结果', '失败')

        print(f"分析完成: {file_name}, 日期: {date_str}")
        return result

    except Exception as ex:
        print(f"分析文件失败: {file_path}, 错误: {ex}")
        return None


def analyze_recent_data(now, day_num=4):
    """分析最近4天的数据并生成统计报告"""
    print(f"开始分析最近{day_num}天的数据...")

    # 文件类型配置
    file_types = [
        '情绪价值承接', '新版QA', '融合', 'SOP-问题',
        '知识-专业性建议问题', '引导任务', '系统交互问题'
    ]

    # 获取最近4天的日期
    dates = []
    for i in range(day_num):
        date = now - timedelta(days=i+1)
        dates.append(date.strftime('%Y-%m-%d'))
        print(f"文件的时间：{date.strftime('%Y-%m-%d')}")

    # 收集所有统计数据
    all_stats = []

    # 为每种文件类型收集数据
    for file_type in file_types:
        print(f"正在分析 {file_type} 类型的数据...")

        # 为每个日期分析数据
        for date_str in dates:
            file_path = f"C:/Users/amos.tong/Desktop/归因/归因_每天/{file_type}-回测-结果-{date_str}.xlsx"
            result = analyze_single_file(file_path, file_type, date_str)
            if result:
                all_stats.append(result)

    if all_stats:
        # 将所有统计数据合并到一个DataFrame中
        stats_df = pd.DataFrame(all_stats)

        # 按日期分组，每个指标作为一行
        pivot_data = []
        all_metrics = set()

        # 收集所有指标名称
        for stat in all_stats:
            for key in stat.keys():
                if key != 'date':
                    all_metrics.add(key)

        # 为每个指标创建一行数据
        for metric in sorted(all_metrics):
            row = {'指标': metric}
            for date_str in sorted(dates, reverse=True):  # 日期倒序排列
                # 查找对应日期和指标的数据
                value = None
                for stat in all_stats:
                    if stat.get('date') == date_str and metric in stat:
                        value = stat[metric]
                        break
                row[date_str] = f"{value}%" if value is not None else ""
            pivot_data.append(row)

        # 创建最终的统计表格
        final_df = pd.DataFrame(pivot_data)

        # 保存到单个Excel文件
        output_path = f"C:/Users/amos.tong/Desktop/归因/归因_每天/归因回测统计汇总-{now.strftime('%Y-%m-%d')}.xlsx"

        # 确保目录存在
        os.makedirs(os.path.dirname(output_path), exist_ok=True)

        # 保存到Excel
        with pd.ExcelWriter(output_path, engine='xlsxwriter') as writer:
            final_df.to_excel(writer, index=False, sheet_name='统计汇总')

            # 获取工作表和工作簿对象
            workbook = writer.book
            worksheet = writer.sheets['统计汇总']

            # 设置列宽（不启用文本换行）
            for i, col in enumerate(final_df.columns):
                if i == 0:  # 第一列（指标列）
                    # 设置第一列宽度为100
                    worksheet.set_column(i, i, 40)
                else:  # 其他列
                    # 计算标题宽度
                    header_width = len(str(col)) + 2

                    # 计算该列数据的最大宽度
                    if not final_df.empty:
                        data_width = final_df[col].astype(str).str.len().max()
                        # 取标题和数据宽度的最大值，但限制在合理范围内
                        max_width = min(max(header_width, data_width + 2), 30)  # 最大30字符
                    else:
                        max_width = header_width

                    worksheet.set_column(i, i, max_width)

        output_image = f"C:/Users/amos.tong/Desktop/归因/归因_每天/归因回测统计汇总-{now.strftime('%Y-%m-%d')}.png"
        # excel_to_image_pillow(excel_file=output_path,  output_image=output_image)
        excel_to_image_pillow(excel_file=output_path, output_image=output_image, first_col_width=350)

        print(f"excel文件生成图片， excel文件名={output_path} 图片名={output_image}")
        send_post_img_message(output_image)
        print(f"向企微发送图片，图片名={output_image}")

        print(f"统计报告已保存: {output_path}")
        print(f"共生成 {len(pivot_data)} 项统计指标，覆盖 {len(set(stat['date'] for stat in all_stats))} 个日期")
    else:
        print("没有找到任何有效的数据文件")


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
    skip_count = 0
    batch_count = 0

    while True:
        batch_count += 1
        print(f"正在查询第 {batch_count} 批数据，跳过 {skip_count} 条记录，每页 {page_size} 条...")

        # 测试代码
        # page_size = 20
        # if batch_count > 2:
        #     break

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

        # 处理所有回测
        process_all_backtests(data_list, results_dict)

        # 更新skip_count为下一页的起始位置
        skip_count += len(data_list)
        print(f"下次查询将跳过 {skip_count} 条记录")

        # 如果返回的数据少于page_size，说明已经是最后一页
        if len(data_list) < page_size:
            print("已到达最后一页，结束循环")
            break
    return results_dict


def task():
    """主任务函数"""
    mongo_client = MongoDBClient()
    try:
        # 连接到MongoDB
        if mongo_client.connect():
            # 初始化时间范围
            now, start_time, end_time, base_datetime = init_config_and_time()

            # # 处理数据批次
            # results_dict = process_data_batches(mongo_client, start_time, end_time)
            #
            # # 保存所有结果到Excel - 使用数据实际日期
            # save_results_to_excel(results_dict, base_datetime)

            # 统计分析最近xxx天的数据（默认4天）
            analyze_recent_data(now, 4)

    except Exception as ex:
        print(f"操作过程中发生异常: {ex}")
    finally:
        # 确保在任何情况下都关闭连接
        mongo_client.disconnect()


if __name__ == "__main__":
    today_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"开始时间：{today_date}        task 开始处理。。。。。")
    task()
    today_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"结束时间：{today_date}        over。。。。")

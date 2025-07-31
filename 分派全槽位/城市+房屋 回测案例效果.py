import pandas as pd
import requests
import json
from collections import defaultdict
from openpyxl import Workbook
import os


INPUT_EXCEL = 'C:/Users/amos.tong/Desktop/城市+房屋面积.xlsx'     # 输入文件路径
OUTPUT_EXCEL = 'C:/Users/amos.tong/Desktop/城市+房屋面积-out.xlsx'  # 输出文件路径

# API配置
api_url = 'https://xagent.to8to.com/api/v1/chat/completions'
headers = {
    'Authorization': 'Bearer fastgpt-glzXJfnQv1seaaVy7naaG1GW8q63xZC5i1kVjuSiGTOQHxwB9oEujeB',
    'Content-Type': 'application/json'
}


# 创建输出Excel文件
output_wb = Workbook()
output_ws = output_wb.active
output_ws.append(['chat_id', '城市', '面积', '案例链接', '继续提问话术'])

# 读取Excel文件
df = pd.read_excel(INPUT_EXCEL)
# 按chat_id分组
grouped = df.groupby('chat_id')

# 处理每个chat_id组
for chat_id, group in grouped:
    variables = {
        "面积": "",
        "城市": ""
    }

    # 提取城市和面积信息
    for _, row in group.iterrows():
        property_name = row['property_name']
        reply = row['reply']

        if property_name == '城市':
            variables['城市'] = reply
        elif property_name == '房屋面积':
            variables['面积'] = reply

    # 构造请求数据
    payload = {
        "variables": variables,
        "messages": [
            {
                "role": "user",
                "content": "xxx"  # 这里可以根据需要修改内容
            }
        ]
    }

    # 发送API请求
    try:
        response = requests.post(
            api_url,
            headers=headers,
            data=json.dumps(payload, ensure_ascii=False).encode('utf-8')
        )

        text = json.loads(response.text, strict=False)
        url_list = text['responseData'][-1]['pluginOutput']['案例链接']
        next_question = text['responseData'][-1]['pluginOutput']['继续提问话术']
        print(f"{chat_id}@{variables['城市']}@{variables['面积']}@{url_list}@{next_question}")
        # 写入Excel
        output_ws.append([
            chat_id,
            variables['城市'],
            variables['面积'],
            ', '.join(url_list) if url_list else '',
            next_question
        ])

    except Exception as e:
        print(f"Error processing chat_id {chat_id}: {str(e)}")

# 保存输出文件
output_wb.save(OUTPUT_EXCEL)
print(f"结果已保存到: {os.path.abspath(OUTPUT_EXCEL)}")
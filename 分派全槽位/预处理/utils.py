import requests
import json
from config import API_KEY, URL, MODEL  # 导入 API Key
import yaml
import pytz
from datetime import datetime
import json
from lunarcalendar.converter import Solar, Lunar
from lunarcalendar import Converter
import re


def reformat_time_string(time_str):
    if not time_str:
        return time_str
    # 正则匹配原始格式
    pattern = r"农历：[^年]+年([^()]+)(?:\([^)]*\))?，公历：(\d{4}-\d{2}-\d{2})，([\d:]+)，([^，]+)，([^，]+)"
    match = re.match(pattern, time_str)
    
    if match:
        lunar_date, gregorian_date, time, weekday, period = match.groups()
        return f"{gregorian_date}(农历：{lunar_date})，{weekday}{period}。{time}"
    
    return time_str  # 如果匹配失败，返回原字符串


def transform_time(send_time: str = None):
    """在send_time中加入星期与上下午，并使用中文数字表示农历日期。如果send_time为None，取当前东8区的日期与时间"""
    if send_time is None:
        send_time = datetime.now(pytz.timezone('Asia/Shanghai'))
    else:
        send_time = datetime.strptime(send_time, '%Y-%m-%d %H:%M:%S')
        
    gregorian_date = send_time.strftime('%Y-%m-%d')

    try:
        # 使用 lunarcalendar 进行农历转换
        solar_date = Solar(send_time.year, send_time.month, send_time.day)
        lunar_date = Converter.Solar2Lunar(solar_date)
        
        # 手动转换农历月份和日期格式
        lunar_months = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]
        lunar_days = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
                      "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
                      "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]

        lunar_str = f"农历:{lunar_months[lunar_date.month - 1]}{lunar_days[lunar_date.day - 1]}"
    except Exception as e:
        print(f"农历转换失败: {e}")
        lunar_str = "农历:未知"  # 处理异常情况

    weekday = send_time.strftime('%A').replace('Monday', '周一').replace('Tuesday', '周二').replace('Wednesday', '周三').replace('Thursday', '周四').replace('Friday', '周五').replace('Saturday', '周六').replace('Sunday', '周天')
    period = '上午' if send_time.hour < 12 else '下午' if send_time.hour < 18 else '晚上'
    time_ = send_time.strftime('%H:%M:%S')
    send_time = f"{gregorian_date}({lunar_str}),{weekday}{period},{time_}"
    return send_time


def read_prompt_yaml(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        prompt_data = yaml.safe_load(file)
    return prompt_data


def request_openai_api(prompt, temperature=0.7, top_k=50, top_p=0.9, max_tokens=500):
    """
    请求OpenAI接口协调的方法
    :param model: 使用的模型名称
    :param messages: 消息列表
    :param temperature: 生成的随机性
    :param top_k: 最高k个概率
    :param top_p: 累积概率
    :param max_tokens: 最大生成的token数
    :return: 返回OpenAI接口的响应
    """
    api_endpoint = URL
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {API_KEY}"  # 使用配置文件中的 API Key
    }
    payload = {
        "model": MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": temperature,
        "top_k": top_k,
        "top_p": top_p,
        "max_tokens": max_tokens
    }

    response = requests.post(api_endpoint, headers=headers, data=json.dumps(payload))
    if response.status_code == 200:
        return response.json()["choices"][0]["message"]["content"]
    else:
        response.raise_for_status()



if __name__ == "__main__":
    messages = [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Hello!"}
    ]
    response = request_openai_api(messages)
    print(response)
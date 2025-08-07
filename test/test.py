import datetime
from datetime import timedelta

print(datetime.datetime.now().strftime("%Y-%m-%d"))



# 获取当前时间
now = datetime.datetime.now()
# 计算今天的零点
today_midnight = now.replace(hour=0, minute=0, second=0, microsecond=0)
# 计算第二天的零点
next_day_midnight = today_midnight + datetime.timedelta(days=1)

print("第二天零点:", next_day_midnight.strftime("%Y-%m-%d"))
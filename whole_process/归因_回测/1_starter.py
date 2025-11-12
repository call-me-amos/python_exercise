# 定时任务启动类

from apscheduler.schedulers.blocking import BlockingScheduler
from apscheduler.schedulers.background import BackgroundScheduler
from attribution_task import task
import pytz

# 阻塞式调度器
scheduler = BlockingScheduler()
# 修改为每天凌晨1点执行
scheduler.add_job(task, 'cron', hour=9, minute=52,timezone=pytz.timezone('Asia/Shanghai'))
scheduler.start()

# # 后台调度器
# scheduler = BackgroundScheduler()
# scheduler.add_job(task, 'cron', hour=1, minute=0, timezone=pytz.timezone('Asia/Shanghai'))
# scheduler.start()

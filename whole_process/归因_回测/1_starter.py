# 定时任务启动类

from apscheduler.schedulers.blocking import BlockingScheduler
from apscheduler.schedulers.background import BackgroundScheduler
from attribution_task import task

# # 阻塞式调度器
# scheduler = BlockingScheduler()
# scheduler.add_job(task, 'interval', seconds=30)
# scheduler.start()

# 后台调度器
scheduler = BackgroundScheduler()
scheduler.add_job(task, 'cron', hour=1, minute=0)
scheduler.start()

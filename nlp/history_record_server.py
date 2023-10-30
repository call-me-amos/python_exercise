from fastapi import FastAPI, Query
from pydantic import BaseModel
import log
from typing import List
import common
import os
import history_record_service

app_env = os.environ.get('APP_ENV')
device_id = 0  # 使用gpu

# 定义日志
logger = log.set_log('history_record_server', 'logs', False)
logger.info(f"文本分类服务GPU启动中 app_env:{app_env}......")

app = FastAPI()

text_schema = common.get_text_schema()
zw_schema = text_schema['zw_cls']


class TwoDimensionalArray(BaseModel):
    uid: str = Query(min_length=1)
    record_List: List[List[str]] = Query(min_length=1)


class Text(BaseModel):
    id: str = Query(min_length=1)
    text: List[str] = Query(min_length=1)


class SingleText(BaseModel):
    text: str = Query(min_length=1)


# 通过
@app.post("/classify/import_historyRecord_and_findTagByPhoneId")
def history_record_find_tag_by_phoneId(req: TwoDimensionalArray):
    logger.info(f"开始执行方法 twoDimensionalArray， req ={req}")
    call_import_historyRecord_and_findTagByPhoneId_res = history_record_service.import_historyRecord_and_findTagByPhoneId(req.record_List, req.uid)
    logger.info(f"方法执行结束 twoDimensionalArray， res ={call_import_historyRecord_and_findTagByPhoneId_res}")
    return call_import_historyRecord_and_findTagByPhoneId_res


req_mock = {
    "req": [
        [
            "19820810743",
            "wmJiIbDAAAGcyu8a_2YetfpJ4d3XJE2w",
            "30113407",
            "1",
            "1698485034",
            "text",
            "我已经添加了你，现在我们可以开始聊天了。"
        ],
        [
            "19820810743",
            "wmJiIbDAAAGcyu8a_2YetfpJ4d3XJE2w",
            "30113407",
            "2",
            "1698485034",
            "text",
            "哈喽，我是土巴兔伊白顾问（人工回复时间：早9:00~晚18:30）不是机器人哦~ ①您提供下【贵姓+城市+小区名+房屋面积+毛坯/旧房整改+自住/出租】信息 ②我看到后给您计算装修参考报价，安排设计师出设计方案和报价明细哈【免费】"
        ],
        [
            "19820810743",
            "wmJiIbDAAAGcyu8a_2YetfpJ4d3XJE2w",
            "30113407",
            "1",
            "1698485034",
            "text",
            "乔先生北京市通州区方恒东景建筑面积 83.77 平米旧房整改自住"
        ],
        [
            "19820810743",
            "wmJiIbDAAAGcyu8a_2YetfpJ4d3XJE2w",
            "30113407",
            "2",
            "1698485034",
            "text",
            "好的，咱是全部翻新墙面地面水电整改，重新换个风格一起做嘛？"
        ]
    ]
}
if __name__ == '__main__':
    print("==========")
    record_res = history_record_service.import_historyRecord_and_findTagByPhoneId(req_mock["req"], '5062370')
    print(f"========== record_res={record_res}")

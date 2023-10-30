import os
import logging
from logging.handlers import TimedRotatingFileHandler


def set_log(name='log', log_dir='logs', debug=False):
    os.makedirs(log_dir, exist_ok=True)
    log_file = os.path.join(log_dir, "{}.log".format(name))

    logger = logging.getLogger(log_file)
    logger.setLevel(level=logging.INFO)
    formatLog = logging.Formatter('[%(asctime)s %(levelname)s]: %(message)s')

    # 往屏幕输出
    if debug:
        sh = logging.StreamHandler()
        sh.setFormatter(formatLog)
        logger.addHandler(sh)

    # 写入文件
    th = TimedRotatingFileHandler(filename=log_file, when='D', backupCount=30, encoding='utf-8')
    th.setFormatter(formatLog)
    logger.addHandler(th)
    return logger

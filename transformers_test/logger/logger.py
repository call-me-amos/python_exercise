import os
import logging
import time
from logging import handlers


def logger(**kwargs):
    log_dir = kwargs.pop('dir', None)
    if not log_dir:
        log_dir = os.path.abspath(os.path.curdir)
        # log_dir = os.path.split(log_dir)[0]
        log_dir = os.path.join(log_dir, 'log')

    if not os.path.exists(log_dir):
        os.makedirs(log_dir)

    level = kwargs.pop('level', None)
    service = kwargs.pop('service', 'default.log')
    filename = os.path.join(log_dir, service + '.log')
    date_format = kwargs.pop('date_format', None)
    format = kwargs.pop('format', None)
    if level is None:
        level = logging.DEBUG
    if filename is None:
        filename = 'default.log'
    if date_format is None:
        datefmt = '%Y-%m-%d %H:%M:%S'
    if format is None:
        format = '%(asctime)s [%(module)s] [%(filename)s] [%(funcName)s] %(levelname)s [%(lineno)d] %(message)s'

    log = logging.getLogger(filename)
    format_str = logging.Formatter(format, datefmt)
    # backupCount 保存日志的数量，过期自动删除
    # when 按什么日期格式切分(这里方便测试使用的秒)
    th = handlers.TimedRotatingFileHandler(filename=filename, when='D', backupCount=180, encoding='utf-8')
    th.setFormatter(format_str)
    th.setLevel(logging.INFO)
    log.addHandler(th)
    log.setLevel(level)
    return log


if __name__ == '__main__':
    logger = logger(service='text')
    while True:
        time.sleep(0.1)
        logger.info('123')


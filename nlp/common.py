import log


# 自定义文本纠错混淆集
def get_custom_confusion():
    # 自定义文本纠错混淆集
    custom_confusion = {
        "1": {}, # 完整替换
        "2": {}, # 子串替换
    }
    with open('./custom_text_confusion.txt') as f:
        for line in f.readlines():
            info = line.split()
            custom_confusion[info[2]][info[0]] = info[1]
    return custom_confusion


def get_citys():
    with open('./chinese_citys.txt') as f:
        citys = list(f.readlines())
    return [line.strip() for line in citys]


def get_text_schema():
    text_shcema = {
        'ner': [
            '姓氏', '城市', '房屋面积', '小区地址', '工程量', '时间', '小区名称', '区县', '街道', '房屋类型', '手机号', '装修类型',
            '房屋用途'
        ],
        'zj_cls': [
            '表达拒绝','表达质疑','表达追问','表达在外地','表达非本机','表达犹豫','表达无网络','表达不会操作','开场白','加微动作','其他','表达约量房','表达强引导','表达局部工程量',
            '介绍平台服务','表达不做水电','表达询问房龄','表达确定房龄','表达询问空间是否改动','表达确认空间是否改动'
        ],
        'house_type_cls': ['精装房', '毛坯', '旧房翻新', '新房', '自建房', '其他'],
        'yes_no_cls': ['肯定回答', '否定回答', '中性回答'],
        'zw_cls': ["询问其他","询问意向量房时间","询问装修时间","询问小区地址","询问工程量","询问房屋类型","询问面积","询问姓氏","询问交房时间","询问外出回来时间","询问城市"],
    }
    return text_shcema


# 自定义文本纠错
def custom_correct_text(text, custom_confusion, logger):
    if len(text) <= 0:
        return text

    if text in custom_confusion["1"]:
        new_text = custom_confusion["1"][text]
        logger.info(f"文本纠错1：{text} => {new_text}")
        text = new_text

    for k, v in custom_confusion["2"].items():
        if k in text:
            logger.info(f"文本纠错2：{k} => {v}")
            text = text.replace(k, v)

    return text


if __name__ == '__main__':
    # 定义日志
    logger = log.set_log('common', 'logs', True)

    # 自定义文本纠错混淆集
    custom_confusion = get_custom_confusion()
    logger.info(f"自定义文本纠错混淆集：{custom_confusion}")

    text = "1🈷,2🈷,三惠英剧,三惠英剧3"
    logger.info(f"文本纠错前：{text}")
    text = custom_correct_text(text, custom_confusion, logger)
    logger.info(f"文本纠错后：{text}")
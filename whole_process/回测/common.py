def parse_filed_from_slots(slots_list, search_key_name):
    """
    从slots_list中获取search_key_name集合中指定的键值
    :param slots_list: 包含键值对的JSON对象（字典）
    :param search_key_name: 需要获取值的键名集合
    :return: 包含键值对的字典，键为search_key_name中的元素，值为对应的值或默认空字符串
    """
    result = {}
    for key in search_key_name:
        try:
            # 检查键是否存在，存在则获取值，否则返回空字符串
            result[key] = slots_list.get(key, "") if key in slots_list else ""
        except Exception as e:
            print(f"获取{key}失败: {e}")
            result[key] = ""
    return result
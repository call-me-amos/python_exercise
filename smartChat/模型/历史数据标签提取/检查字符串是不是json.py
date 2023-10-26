import json
"""
    检查字符串是不是json格式
"""


def load_file(file_id):
    data = open("./{}".format(file_id), "r", encoding="utf-8")
    data = [line.strip() for line in data]
    return data


if __name__ == '__main__':
    content = "source_data/20%"
    data_content = load_file(content + ".txt")
    n = len(data_content)
    print(f"总的聊天记录数据：{n}")
    for len_num in range(n):
        try:
            json.loads(data_content[len_num])
            print("正常json字符串")
        except ValueError:
            print(f"不是json,{data_content[len_num]}")

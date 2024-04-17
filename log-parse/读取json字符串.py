import json

# 打开文件并读取内容
with open('test.txt', 'r', encoding='utf-8') as file:
    json_data = file.read()

# 将 JSON 字符串解析成 Python 字典或其他数据结构
data = json.loads(json_data)


if __name__ == '__main__':

    for param in data:
        print(f'{param["_source"]["txt"].split(",")[0]}')

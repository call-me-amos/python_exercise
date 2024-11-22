import json
import re

# 打开文件并读取内容
with open('test.txt', 'r', encoding='utf-8') as file:
    json_data = file.read()

# 将 JSON 字符串解析成 Python 字典或其他数据结构
data = json.loads(json_data)
data = data['responses'][0]["hits"]["hits"]

# 定义多个关键词
keywords = ["param:", ", result:"]

# 创建正则表达式模式，将关键词用管道符 '|' 连接起来
# pattern = '|'.join(map(re.escape, keywords))
pattern = '|'.join(keywords)

if __name__ == '__main__':

    # 表头
    print(f'顾问提问&用户回复&单意图&多意图&NER结果')
    for param in data:
        txt = param["_source"]["txt"]
        # print(f'{txt.split(",")[0]}')
        txt = txt.replace("\\n", " ")
        txtStr = re.split(pattern, txt)
        requestJson = json.loads(txtStr[1])[1]
        resultJson = json.loads(txtStr[2])

        # V1模型没有提问
        if 'question' in requestJson.values():
            question = requestJson["question"]
        else:
            question = ""

        # 单意图
        categoryText = None
        if isinstance(resultJson["data"]["categoryInfoVO"], dict) and not resultJson["data"]["categoryInfoVO"]:
            categoryText = ""
        else:
            categoryText = resultJson["data"]["categoryInfoVO"]["categoryText"]

        # 多意图
        categoryTextList = ""
        if len(resultJson["data"]["categoryInfoList"]) > 0:
            for categoryTextJson in resultJson["data"]["categoryInfoList"]:
                categoryTextList = categoryTextList + "#" + categoryTextJson['categoryText']
        else:
            categoryTextList = ""

        # NER结果
        nlpTagInfoList = ""
        if len(resultJson["data"]["nlpTagInfoVOList"]) > 0:
            for nlpTagInfoJson in resultJson["data"]["nlpTagInfoVOList"]:
                nlpTagInfoList = nlpTagInfoList + "#" + nlpTagInfoJson['tagText'] + ":" + nlpTagInfoJson['tagValue']
        else:
            nlpTagInfoList = ""

        print(f'{question}&{requestJson["content"]}&{categoryText}&{categoryTextList}&{nlpTagInfoList}')


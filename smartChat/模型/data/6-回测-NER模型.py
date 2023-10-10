import json

import requests

'''
    回测-NER模型
'''


def load_file(file_id):
    data = open("./{}".format(file_id), "r", encoding="utf-8")
    data = [line.strip() for line in data]
    return data


def call_http(content):
    # 测试环境
    url = "http://192.168.41.112:40015/nlp/nerAndcategory"
    data = {
        "bussinessKey": "intelligentPlatform",
        "bussinessId": "111111",
        "currentTime": "1111111",
        "content": content
    }
    res = requests.post(url=url, json=data)

    return res.json()


if __name__ == '__main__':
    data_1 = load_file("1-合并后的地址信息.txt")
    data_2 = load_file("2-市名称.txt")
    data_3 = load_file("3-行政区名称.txt")
    data_4 = load_file("4-行政街道名称.txt")
    data_5 = load_file("5-楼盘名.txt")

    n = len(data_1)
    print(f"总的地址数据：{n}")
    for len_num in range(n):
        resJson = call_http(data_1[len_num])
        city = "null"
        town = "null"
        street = "null"
        add = "null"
        nlpTagInfoVOList = resJson["data"]["nlpTagInfoVOList"]
        for ner_result in nlpTagInfoVOList:
            if "城市" == ner_result.get("tagText"):
                city = ner_result.get("tagSourceValue")
                continue
            if "区县" == ner_result.get("tagText"):
                town = ner_result.get("tagSourceValue")
                continue
            if "街道" == ner_result.get("tagText"):
                street = ner_result.get("tagSourceValue")
                continue
            if "小区地址" == ner_result.get("tagText") or "小区名称" == ner_result.get("tagText"):
                add = ner_result.get("tagSourceValue")
                continue

        print(f'完整地址： {data_1[len_num]}，{city}，{town}，{street}，{add}')
        # if len_num > 2:
        #     print("================")
        #     break
    print("============= over!")

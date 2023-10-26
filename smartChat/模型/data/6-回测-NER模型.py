import json

import requests

'''
    回测-NER模型
'''


def load_file(file_id):
    data = open("./{}".format(file_id), "r", encoding="utf-8")
    data = [line.strip() for line in data]
    return data


def data_post_process(content, file_name):
    fp = open("./response/{}".format(file_name), "a+", encoding="utf-8")
    fp.write(content + "\n")
    fp.close()


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
    data_name = "./source_data/1-5-合并后的地址信息"
    data_1 = load_file(data_name + ".txt")
    # data_2 = load_file("2-市名称.txt")
    # data_3 = load_file("3-行政区名称.txt")
    # data_4 = load_file("4-行政街道名称.txt")
    # data_5 = load_file("5-楼盘名.txt")

    fp = open("./response/{}".format(data_name + "-response.txt"), "a+", encoding="utf-8")

    n = len(data_1)
    print(f"总的地址数据：{n}")
    for len_num in range(n):
        if "" == data_1[len_num]:
            print("地址信息为空len_num=" + str(len_num))
            continue
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

        write_content = f'{data_1[len_num]}，{city}，{town}，{street}，{add}'
        print(write_content)
        fp.write(write_content + "\n")

        # if len_num > 2:
        #     print("================")
        #     break
    fp.close()
    print("============= over!")

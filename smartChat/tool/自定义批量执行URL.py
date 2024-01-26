import requests

'''
    自定义批量执行URL
'''

param = {
    "img_url": "https://file.t8tcdn.com/d/flash/2022/04/27/14/20220427142284972001651039333882.jpg?x-oss-process=image/format,jpg/quality,90/resize,w_650,h_650"
}

param_list = [
    param
]


def call_http(param):
    url = "http://192.168.41.112:40015/nlp/nerAndcategory"
    data = {
        "bussinessKey": "intelligentPlatform",
        "bussinessId": "111111",
        "content": param,
        "currentTime": "123"
    }
    res = requests.post(url=url, json=data)

    return res.json()


if __name__ == '__main__':

    for param in param_list:
        print("param=", param)
        resJson = call_http(param)
        print("resJson=", resJson)

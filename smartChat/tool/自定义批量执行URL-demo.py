import requests

'''
    自定义批量执行URL
'''

param_list = [
    "两层不是通着的，是各自一层，各走各的门"
]


def call_http(param):
    url = "http://192.168.11.116:8992/classify/multi_cls"
    # data = {
    #     "bussinessKey": "intelligentPlatform",
    #     "bussinessId": "111111",
    #     "content": param,
    #     "currentTime": "123"
    # }
    data = {
        "id": "1",
        "text": [
            param
        ]
    }
    res = requests.post(url=url, json=data)

    return res.json()


if __name__ == '__main__':

    for param in param_list:
        # print("param=", param)
        resJson = call_http(param)
        if len(resJson['data']['labels']) > 0:
            if len(resJson['data']['labels'][0]['predictions']) == 0:
                print(f"[空意图原文本]{resJson['data']['labels'][0]['text_a']}")
            elif len(resJson['data']['labels'][0]['predictions']) == 1:
                print(f"[单意图原文本]{resJson['data']['labels'][0]['text_a']}[单意图文本分类结果]{resJson['data']['labels'][0]['predictions'][0]['label']}")
            else:
                label_list = []
                for label_obj in resJson['data']['labels'][0]['predictions']:
                    label_list.append(label_obj['label'])
                print(f"[多意图原文本]{resJson['data']['labels'][0]['text_a']}[多意图文本分类结果]{'&&'.join(label_list)}")

import requests


def get_intention(text):
    url = "http://192.168.11.116:8992/classify/zw_v1"
    data_json = {
        "id": "1",
        "text": [text]
    }

    res = requests.post(url=url, json=data_json)
    print(res)
    return res.json()["data"]["labels"][0]["predictions"][0]


if __name__ == '__main__':
    str = "询问其他"
    print(str.split("询问")[1])


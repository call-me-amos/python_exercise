import requests
'''
    手动取消托管
'''
chat_ids = [
"MTU3MzY1NjEjd21Yb29rQ2dBQXRZcC1OQl9YaE41UV9ueE1YLXRrQXc="
]


def call_http(chat_id):
    #url = "https://apigw.to8to.com/cgi/tls/smartChat/weWork/rejectTakeover"
    #url = "https://test-apigw.to8to.com/cgi/tls/smartChat/weWork/rejectTakeover"
    url = "http://10.4.41.68:40121/tls/smartChat/weWork/rejectTakeover"
    data = {
        "chatId": chat_id,
        #"id": ,
        "operateType": 1,
        "transferManualReason": 126
    }
    res = requests.post(url=url, json=data)

    return res.json()


if __name__ == '__main__':
    for chat_id in chat_ids:
        print("chat_id=", chat_id)
        resJson = call_http(chat_id)
        print("resJson=", resJson)

import requests
'''
    手动取消托管
'''
chat_ids = [

]


def call_http(chat_id):
    url = "https://apigw.to8to.com/cgi/tls/smartChat/weWork/rejectTakeover"
    # url = "http://10.4.42.48:40121/tls/smartChat/weWork/rejectTakeover"
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

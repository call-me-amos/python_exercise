import requests
'''
    手动取消托管
'''
chat_ids = [
    'MTgwMjU0MzYyMTAjd21KaUliREFBQWt4TUFuQ0UyYzA2OUIwN0V6QUM1M1E=','MTgwMjU0MzYyMTAjd29KaUliREFBQXBrcWg4TGJHQUt4aEM2RnpEYlc4WFE=','MTgwMjU0MzYyMTAjd21KaUliREFBQWt4TUFuQ0UyYzA2OUIwN0V6QUM1M1E=','MTgwMjU0MzYyMTAjd21KaUliREFBQWxaNmV6dWlTY3dKWDh5MTZFRC1SN0E=','MTgwMjU0MzYyMTAjd21KaUliREFBQXhTS1hIYUl3bzBYS0pZNnlKOFBmU3c=','MTgwMjU0MzYyMTAjd21KaUliREFBQWt4TUFuQ0UyYzA2OUIwN0V6QUM1M1E=','MTgwMjU0MzYyMTAjd21KaUliREFBQWRxZE9aZXdyeGthWjYtZVl4Qzg4Vnc=','MTkwNzYxMjA2MTgjd21KaUliREFBQUZtQ3htX3hacmZZWTlqUlpMaXplUGc=','MTM1MzA1MTQ1NzYjd21KaUliREFBQWRfR0ZaSno2cGZKSWczWlYwbHNyZHc=','MTM1MzA1MTQ1NzYjd21KaUliREFBQTQ1dEdsVnRwbTQySHl6M2lJR1llRnc=','MTM1MzA1MTQ1NzYjd21KaUliREFBQUVuQi1DbE9SeG5wQmxSLVBKdjZNZUE=','ODY4MjU5NzUjd21KaUliREFBQXd6blppRzlFN1Q1OE1RVVc0T3Y2LWc=','MTk5MjQ1MTI2NDEjd21KaUliREFBQWFEQk01RXNacER3YTY2dV9neXMxMGc=','MTk5MjQ1MTI2NDEjd21KaUliREFBQVJEb2dCekpZcTZRTVZXbW9TMllPX3c=','ODY4MjU5NzUjd21KaUliREFBQWhwd1hEWXZ0di1rNFBrcDI0NFBBSFE=','ODY4MjU5NzUjd21KaUliREFBQW5tZTNtc2VFU3Y5QVJpX2dQYU9TS3c='
]


def call_http(chat_id):
    url = "https://apigw.to8to.com/cgi/tls/smartChat/weWork/rejectTakeover"
    data = {
        "chatId": chat_id,
        "operateType": 1
    }
    res = requests.post(url=url, json=data)

    return res.json()


if __name__ == '__main__':
    for chat_id in chat_ids:
        print("chat_id=", chat_id)
        resJson = call_http(chat_id)
        print("resJson=", resJson)

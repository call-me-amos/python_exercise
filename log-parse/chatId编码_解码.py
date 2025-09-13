import base64

data = ["MTkwNzU2OTc4NzIjd21KaUliREFBQWliUnI3bXNsZkdEQVo3QVJsa2V5aHc="]


for chatId in data:
    deChatId = base64.decodebytes(chatId.encode("utf-8")).decode("utf-8")
    print(f"{deChatId.split('#')[0]} -- {deChatId.split('#')[1]}")

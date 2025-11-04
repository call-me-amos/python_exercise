import base64

data = ["MTMyNDk4MjgyNTkjd21KaUliREFBQTZTcXN1UHI5MzdTRWR4aWdycDhZWXc=",
        "MTMxNzc2NTY2NTAjd21KaUliREFBQUItM0d4Z3BQY1U1OHpTNlVlVXItdlE="
        ]

for chatId in data:
    deChatId = base64.decodebytes(chatId.encode("utf-8")).decode("utf-8")
    print(f"{deChatId.split('#')[0]} -- {deChatId.split('#')[1]} --{chatId}")


new_chat_id = base64.b64encode(('18565689273' + '#' + 'wmJiIbDAAAYdcEJkP0fZ8Hz6g-G1dVTQ').encode('utf-8')).decode('utf-8')
print(f"new_chat_id={new_chat_id}")

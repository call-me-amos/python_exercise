"""
    readme： https://wechaty.readthedocs.io/zh-cn/latest/
    wechaty 仓库地址： https://github.com/wechaty/python-wechaty
    官方使用文档： https://docs.wechatpy.org/zh-cn/stable/index.html
"""

from wechaty import Wechaty


class MyBot(Wechaty):
    async def on_message(self, msg):
        from_contact = msg.talker()
        text = msg.text()
        await from_contact.say('Echo: ' + text)


bot = MyBot()
bot.start()

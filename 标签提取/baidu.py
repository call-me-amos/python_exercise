import requests
import json

API_KEY = "tZxh7IpyR92IxP9KgIGVbXoB"
SECRET_KEY = "4aB59aaafGLhmBXxBmEwG1yw1RTOUbaU"

def main():

    url = "https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/completions?access_token=" + get_access_token()


    content ="""你是一个文本提取工具API，能根据提供的对话信息提取关键信息，返回json格式数据。对话内容为 \n\n\n 业主： 我已经添加了你，现在我们可以开始聊天了。
顾问：        王先生，我看到您完善了信息，安徽宣城市广德县新杭镇120m²的毛坯装修，打算使用都可以，2023-04-08装修，2023-04-08可以量房。这些信息没问题的话，我尽快帮您安排，可以吗？
业主：        1400平米
业主：        厂房装修
顾问：        好的，厂房现在已经租下来或者买下来了么
业主：        我自己新厂房
顾问：        嗷嗷好的，请问厂房在新杭镇什么地方，或者什么路多少号呀
业主：        新杭镇上
业主：        很近
顾问：        嗷嗷，那给您安排设计师过去看看，给咱们现场做个判断，免费测量的也不花钱，看看具体怎么设计更好，现场沟通尺寸，到时候也会给你出一份详细的报价清单
顾问：        就按照您填的时间可以么
业主：        图纸我手里有
顾问：        报价和方案需要设计师现场去看看，因为光图纸的话不清楚具体设计思路，细节，还要看看采光，通风这些
顾问：        哈喽，还需要给您预约设计师出方案和报价对比么
\n\n\n请总结上述对话中，业主的房屋信息，按照{'房屋类型':xx,'小区名称'：xx,'装修时间':xx,'量房时间':xx，'房屋面积'：xx,'姓氏'：xx}纯json格式格式输出"""

    data = {
        "messages": [
            {"role":"user","content":content}
        ]
    }

    payload = json.dumps(data)
    headers = {'Content-Type': 'application/json'}

    response = requests.request("POST", url, headers=headers, data=payload)

    print(json.loads(response.text)["result"])


def get_access_token():
    """
    使用 AK，SK 生成鉴权签名（Access Token）
    :return: access_token，或是None(如果错误)
    """
    url = "https://aip.baidubce.com/oauth/2.0/token"
    params = {"grant_type": "client_credentials", "client_id": API_KEY, "client_secret": SECRET_KEY}
    return str(requests.post(url, params=params).json().get("access_token"))


if __name__ == '__main__':
    main()

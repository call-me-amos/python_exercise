import requests


def test_bot():
    url = "http://192.168.11.116:7861/chat/knowledge_base_chat"
    dataJson = {
        "query": "xxxx",
        #"query": "全包和半包的区别是什么？",
        "knowledge_base_name": "smartchat_qa_data_v1",
        "top_k": 1,
        "score_threshold": 0.5,
        "history": [
            {
                "role": "user",
                "content": "你好"
            },
            {
                "role": "assistant",
                "content": "您是毛坯房还是旧房改造，精装房呀？"
            }
        ],
        "stream": False,
        "model_name": "chatglm3-6b",
        "temperature": 0.7,
        "prompt_name": "default"
    }
    res = requests.post(url=url, json=dataJson)
    return res.json()


if __name__ == '__main__':
    print("=========== start")
    print(test_bot())
    print("=========== end")
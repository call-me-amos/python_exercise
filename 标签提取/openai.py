import requests
import json

# 设置请求头
headers = {
    "Authorization": "Bearer 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",
    "Content-Type": "application/json"
}

# 设置请求参数
data = {
    "messages": [
        {
            "role": "user",
            "content": "您的对话内容..."
        }
    ],
    "model": "gpt-3.5-turbo",
    "n": 1,
    "temperature": 0
}

# 发送POST请求
response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, data=json.dumps(data))

# 解析响应
result = response.json()
completion = result["choices"][0]["message"]["content"]

# 输出结果
print(completion)

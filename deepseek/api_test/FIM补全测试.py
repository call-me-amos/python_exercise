import requests
import json

url = "https://api.deepseek.com/beta/completions"

payload = json.dumps({
    "model": "deepseek-chat",
    "prompt": "很久以前，在一座山上, ",
    "echo": False,
    "frequency_penalty": 0,
    "logprobs": 0,
    "max_tokens": 1024,
    "presence_penalty": 0,
    "stop": None,
    "stream": False,
    "stream_options": None,
    "suffix": None,
    "temperature": 1,
    "top_p": 1
})
headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer sk-cb06f70422034143858ab85dcbd2add0'
}

print('@@@ start @@@')
response = requests.request("POST", url, headers=headers, data=payload)

print(response.text)
print('@@@ end  @@@')
import requests

from clint.textui import progress

url = "https://img2.woyaogexing.com/2023/03/13/ab54034e06b40cedd9a235b85d5f23be.jpg"

r = requests.get(url, stream=True)

with open("E:\\python_workspace\\DownloadFileByClint.jpg", "wb") as pyjpg:
    total_length = int(r.headers.get("content-length"))

    for ch in progress.bar(r.iter_content(chunk_size=2391975), expected_size=(total_length / 1024) + 1):
        if ch:
            pyjpg.write(ch)
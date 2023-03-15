import os
import requests
from time import time
from multiprocessing.pool import ThreadPool


def url_response(url):
    path, url = url
    r = requests.get(url, stream=True)
    with open(path, "wb") as f:
        for ch in r:
            f.write(ch)


urls = [("E:\\python_workspace\\download1.png", "https://img2.woyaogexing.com/2023/03/04/84be400dacacc7cca7f55e5a9b6a1601.jpg"),

        ("E:\\python_workspace\\download2.png", "https://img2.woyaogexing.com/2023/03/13/ab54034e06b40cedd9a235b85d5f23be.jpg"),
        ("E:\\python_workspace\\download3.png", "https://img2.woyaogexing.com/2023/03/13/8d4f79918452c134cc7223af43272f68.jpg")]

start = time()
for x in urls:
    url_response(x)

print(f"time to download:{time() - start}")
ThreadPool(1).imap_unordered(url_response, urls)
print(f"time to download:{time() - start}")

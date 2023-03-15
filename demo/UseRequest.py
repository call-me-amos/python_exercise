import requests

url = "https://www.baidu.com/img/flexible/logo/pc/result.png"
myfile = requests.get(url)
open("E:\\python_workspace\\useRequest.png", "wb").write(myfile.content)
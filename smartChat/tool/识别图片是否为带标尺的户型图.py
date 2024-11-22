import json

import requests

'''
    自定义批量执行URL
'''

image_url_list = [
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//885fcbdec996ffbf592e8fe821fc133f.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//0ea9c0151cbbdc19d3350f23c895f789.png",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//2f86aef1c9ac356df0f1b8279b514648.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//7415988c82233da2438f1b82ec8debde.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//728779d5f33ae0925ac5191310585bdb.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//60406ed9b8eebcd9b3269b21bc505171.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//b2626099197b83d4abfabb8b5eb8c9ac.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//5a121670a7f33e7da7effc35156acd91.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//3072decefcfb02884a9184d8b4509d67.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//962e9cfff1156a2cd7c654e782d15735.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//402371f6f821fff9a114fb4698bac359.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//9a996814b037dec4993f302e8f0cf19f.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//1b64403267c37276923a964aadfea5fc.png",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//aaba8295750a10add8570ecad3c3a7f9.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//7b16e392aac99e4d923c1308612c53d9.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//9373967c0a1302c92ede0f0cb59fac2b.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//eb887d11958b598dd04a5aaa1987b982.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//c9ea7cdefb9c31cd02f543bd21c6a4dd.png",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//d2152441b39432b2141ca5469c8304f3.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//f67e4f0fc03bf1c909155e3e39dd66e0.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//8bdb21f4db1fabc3f2d89c7e1f4f246a.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//c46b37da70439864fc16fb6f6a8cc207.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//745400ec395525ccae296af6a009b43a.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//c3ee6ff3e226325111a61d4d957e27e8.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//723dbd4635625248ec83f04a19fe53ba.jpg",
    "http://xxinc-media.oss-cn-shenzhen.aliyuncs.com//bedb5b88241f8901848f8eea9f14bd84.jpg",

]

# 检查户型图是否带有标尺
ocr_url = "http://192.168.11.116:9016/floorplan/num_ocr"
# 图片识别，是否为户型图
image_detection_url = "http://192.168.11.114:9015/floorplan/detection"


def call_http(param_image_url, post_url):
    data = {
        "img_url": param_image_url + "?x-oss-process=image/format,jpg/quality,90/resize,w_650,h_650",
    }
    res = requests.post(url=post_url, json=data)

    return res.json()


if __name__ == '__main__':
    print(f'url  是否带标尺  是否户型图')
    for image_url_str in image_url_list:
        # image_url_json = json.loads(image_url_str)
        # image_url = image_url_json['url']
        image_url = image_url_str
        resJson = call_http(image_url, ocr_url)
        ocr_result = None
        image_result = None
        if len(resJson['data']['num_ocr_result']) > 0:
            ocr_result = True
        else:
            ocr_result = False

        resJson = call_http(image_url, image_detection_url)
        if resJson['data']['type'] == "FloorPlan":
            image_result = True
        else:
            image_result = False
        print(f'{image_url}  {ocr_result}  {image_result}')
        # print(f'{image_url}  {ocr_result}  {image_result}')

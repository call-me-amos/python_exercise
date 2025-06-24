# -- coding:utf-8 --
import copy
import requests

# 执行哪个环境
create_env = "test"
# 新增槽位 OR 新增意图。 slot intention
create_type = "slot"

def createProperty(data):
    if create_env == "test":
        # 需要将cookie内容复制到headers中
        # 测试环境
        url = "https://test-erp.to8to.com/index.php/Scm/property/create"
        headers = {
            "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36",
            "origin": "https://test-erp.to8to.com",
            "referer": "https://test-erp.to8to.com/index.php//Scm/property/index",
            "Cookie": "PHPSESSID=tpms0u0fln1hkdrmmjlmmeon5i; uid=wKgpc2e1gn4SoT6gA4RpAg==; tracker2019jssdkcross=%7B%22distinct_id%22%3A%221951d05e9ed262c-0696d894267959-26011a51-2073600-1951d05e9ee238b%22%2C%22first_id%22%3A%22%22%7D; tracker2019session=%7B%22session%22%3A%221951d05e9ef1523-0a47d12c1822e7-26011a51-2073600-1951d05e9f02655%22%7D; to8tocookieid=1951d05e9ed262c-0696d894267959-26011a51-2073600-1951d05e9ee238b; to8to_cook=OkOcClPzRWV8ZFJlCIF4Ag==; t8t-it-uid=20678; t8t-it-username=amos.tong; t8t-it-ticket=AWAMY52PNGc1k8Nvwm9Al6Rq8ymAnBZ-SvOn26LnXIuvrjgq_E0bGuYqYMQ1asxRMJwEaCU2le4n8SbFTeoiobeLf4Cclu4YiGw4AnXnOwXwJQDg1CE9pjUMEiMmV2q5; to8to_dynamic_first_menu_id=0; t8t-it-certificates=%7B%22crm-pc%22%3A%222b384fde17a3e51ba9a0e3648a797c65%22%2C%22ads%22%3A%22fc5862b5a9fd38234b2e5fef26edf46f%22%2C%22im%22%3A%2281db6f61e61c7d4d882b29f7acea5385%22%2C%22tumax%22%3A%2266b35618f76a6effd9890ab6ba51f4bc%22%2C%22sso-pc%22%3A%22b4f7c6237ec9acffebb8487ebb46d948%22%2C%22rps-pc%22%3A%224d903e314ea2a9f1af55234c47a8fae2%22%7D; to8to_active_first_menu_id=172"
        }
    else:
        # 线上环境
        url = "https://erp.to8to.com/index.php/Scm/property/create"
        headers = {
            "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36",
            "origin": "https://erp.to8to.com",
            "referer": "https://erp.to8to.com/index.php//Scm/property/index",
            "Cookie": "uid=wKgpc2e1gn4SoT6gA4RpAg==; tracker2019jssdkcross=%7B%22distinct_id%22%3A%221951d05e9ed262c-0696d894267959-26011a51-2073600-1951d05e9ee238b%22%2C%22first_id%22%3A%22%22%7D; tracker2019session=%7B%22session%22%3A%221951d05e9ef1523-0a47d12c1822e7-26011a51-2073600-1951d05e9f02655%22%7D; to8tocookieid=1951d05e9ed262c-0696d894267959-26011a51-2073600-1951d05e9ee238b; PHPSESSID=bveuhr63o7qss13mcvb408tec1; to8to_cook=OkOcClPzRWV8ZFJlCIF4Ag==; to8to_active_first_menu_id=172; to8to_dynamic_first_menu_id=172"
        }

    # 请求
    r = requests.post(url, params=data, headers=headers)
    try:
        req = r.json()
        if req['code'] == 0:
            print(f"{data['property_name']}: {req}")
        else:
            print(f"{data['property_name']}: {req}")
    except Exception as e:
        print(str(e))
        print(r.text)


def main(params):
    if create_env == "test":
        if create_type == "slot":
            # 测试环境  槽位
            parent_id = 12430
        else:
            # 测试环境  意图
            parent_id = 13297
    else:
        if create_type == "slot":
            # 线上环境  槽位
            parent_id = 16031
        else:
            # 线上环境  意图
            parent_id = 17741

    for item in params:
        data_tmp = {
            "parent_id": parent_id,
            "property_code": item[0],
            "property_name": item[1],
            "description": item[2]
        }

        createProperty(data_tmp)


if __name__ == '__main__':
    items = [
                ["692", "大模型-装修时间", "SLOT_FOR_RULE_692"],
                ["693", "大模型-交房时间", "SLOT_FOR_RULE_693"],
                ["694", "大模型-意向量房时间", "SLOT_FOR_RULE_694"],
                ["695", "大模型-姓氏", "SLOT_FOR_RULE_695"],
                ["696", "大模型-房屋面积", "SLOT_FOR_RULE_696"],
                ["697", "大模型-房屋类型", "SLOT_FOR_RULE_697"],
                ["698", "大模型-装修类型", "SLOT_FOR_RULE_698"],
                ["699", "大模型-装修用途", "SLOT_FOR_RULE_699"],
                ["700", "大模型-城市", "SLOT_FOR_RULE_700"],
                ["701", "大模型-房屋地址", "SLOT_FOR_RULE_701"],
                ["702", "大模型-工程量", "SLOT_FOR_RULE_702"],
                ["703", "大模型-房屋小区名称", "SLOT_FOR_RULE_703"],
    ]
    main(items)

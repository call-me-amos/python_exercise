# -- coding:utf-8 --
import copy
import requests

# 新增辅助资料模板
add_template = {
    # "parent_id": 17741,  # 分组（类型）id  线上环境id
    "parent_id": 13297,  # 分组（类型）id  测试环境id
    "property_code": None,  # 编码
    "property_name": "",  # 名称
    "description": "",  # 描述
}


def createProperty(data):
    # 需要将cookie内容复制到headers中
    # 测试环境
    url = "https://test-erp.to8to.com/index.php/Scm/property/create"
    headers = {
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36",
        "origin": "https://test-erp.to8to.com",
        "referer": "https://test-erp.to8to.com/index.php//Scm/property/index",
        "Cookie": "PHPSESSID=5cvnd48rj4p7sjohtjkcn67ulb; uid=wKgpc2dOxXEMscZrA9pWAg==; tracker2019jssdkcross=%7B%22distinct_id%22%3A%221938bb3700d20e0-005ced135a0e51-26011851-2073600-1938bb3700e1826%22%2C%22first_id%22%3A%22%22%7D; tracker2019session=%7B%22session%22%3A%221938bb3700f1a15-02f90dbd61c5b5-26011851-2073600-1938bb37010306d%22%7D; to8tocookieid=1938bb3700d20e0-005ced135a0e51-26011851-2073600-1938bb3700e1826; to8to_cook=OkOcClPzRWV8ZFJlCIF4Ag==; t8t-it-uid=13808; t8t-it-username=amos.tong; to8to_dynamic_first_menu_id=6437; t8t-it-ticket=eds5uqLStVvQCjKEveag3RhERGY0WwHyfCkwTzVJU6KpEnu7OxzkVSqgdeMdAw366Q7WtE-qvFoBwMKAP-RDqRd_pzDOaaV1sQVS5CXK2wuKspIyQD_4lwgyzEAJHTpq; t8t-it-certificates=%7B%22crm-pc%22%3A%22ea5f8841a1915547e2d027e85011ece1%22%2C%22ads%22%3A%22262890c76155014493e67b6e0a0efdb6%22%2C%22im%22%3A%226ee4788ce417d46daa45b845ecc992b2%22%2C%22tumax%22%3A%228f679edab415dbaacee92ad08b7b625c%22%2C%22sso-pc%22%3A%22b2b4c134166483094be30ce0bfc3627b%22%2C%22rps-pc%22%3A%22ed66ea93439abe62df9647be700d1eba%22%7D; to8to_active_first_menu_id=15104"
    }

    # 线上环境
    # url = "https://erp.to8to.com/index.php/Scm/property/create"
    # headers = {
    #     "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36",
    #     "origin": "https://erp.to8to.com",
    #     "referer": "https://erp.to8to.com/index.php//Scm/property/index",
    #     "Cookie": "uid=wKgpc2dOxXEMscZrA9pWAg==; tracker2019jssdkcross=%7B%22distinct_id%22%3A%221938bb3700d20e0-005ced135a0e51-26011851-2073600-1938bb3700e1826%22%2C%22first_id%22%3A%22%22%7D; tracker2019session=%7B%22session%22%3A%221938bb3700f1a15-02f90dbd61c5b5-26011851-2073600-1938bb37010306d%22%7D; to8tocookieid=1938bb3700d20e0-005ced135a0e51-26011851-2073600-1938bb3700e1826; PHPSESSID=s13b9dbe0i9jagrm8u1vrglib7; to8to_cook=OkOcClPzRWV8ZFJlCIF4Ag==; t8t-it-uid=13808; t8t-it-username=amos.tong; to8to_dynamic_first_menu_id=6437; t8t-it-ticket=eds5uqLStVvQCjKEveag3RhERGY0WwHyfCkwTzVJU6KpEnu7OxzkVSqgdeMdAw366Q7WtE-qvFoBwMKAP-RDqRd_pzDOaaV1sQVS5CXK2wuKspIyQD_4lwgyzEAJHTpq; t8t-it-certificates=%7B%22crm-pc%22%3A%22ea5f8841a1915547e2d027e85011ece1%22%2C%22ads%22%3A%22262890c76155014493e67b6e0a0efdb6%22%2C%22im%22%3A%226ee4788ce417d46daa45b845ecc992b2%22%2C%22tumax%22%3A%228f679edab415dbaacee92ad08b7b625c%22%2C%22sso-pc%22%3A%22b2b4c134166483094be30ce0bfc3627b%22%2C%22rps-pc%22%3A%22ed66ea93439abe62df9647be700d1eba%22%7D; to8to_active_first_menu_id=172"
    # }

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
    for item in params:
        data_tmp = copy.copy(add_template)
        data_tmp["property_code"] = item[0]
        data_tmp["property_name"] = item[1]
        data_tmp["description"] = item[2]

        createProperty(data_tmp)


if __name__ == '__main__':
    items = [
        ["106", "回复整改", "INTENTION_ROOM_6"],
        ["107", "表达非硬装需求", "INTENTION_ROOM_8"],
        ["108", "表达咨询合作", "INTENTION_ROOM_9"],
        ["109", "表达只要几家公司", "INTENTION_ROOM_10"],
        ["110", "表达设计师自行测量", "INTENTION_ROOM_11"],
        ["111", "表达只要设计", "INTENTION_ROOM_12"],
        ["112", "表达非本人带去测量", "INTENTION_ROOM_13"],
        ["113", "表达二次确认", "INTENTION_ROOM_14"],
        ["114", "表达没有微信", "INTENTION_ROOM_15"],
        ["115", "咨询会话目的", "INTENTION_ROOM_16"],
        ["116", "主动要求测量", "INTENTION_ROOM_17"]
    ]
    main(items)

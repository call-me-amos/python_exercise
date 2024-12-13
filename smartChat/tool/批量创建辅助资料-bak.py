# -- coding:utf-8 --
import copy
import requests

# 新增辅助资料模板
add_template = {
    # "parent_id": 16031,  # 分组（类型）id  线上环境id
    "parent_id": 12430,  # 分组（类型）id  测试环境id
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
        "Cookie": "uid=CgoLDmc0px9YUzebRBNvAg==; to8tocookieid=45d50a451f99b6d9b7747b16b8e01a51603451; to8to_cook=OkOcClPzRWV8ZFJlCIF4Ag==; tracker2019jssdkcross=%7B%22distinct_id%22%3A%2219325aced8dff2-050e20cac1fe4-26011951-2073600-19325aced8e1e63%22%2C%22first_id%22%3A%22%22%7D; tracker2019session=%7B%22session%22%3A%2219325aced902d43-0f6734a24f122-26011951-2073600-19325aced912bb9%22%7D; PHPSESSID=doss50vodjg067s9odfnu3f7ll; t8t-it-uid=13808; t8t-it-username=amos.tong; t8t-it-ticket=eds5uqLStVvQCjKEveag3ac5yfM00nZdYDF0IW5WvsWgKZ1YKgh8g6aj6XrMFkZeSzu-xbCx01E99rOJAwLNkhd_pzDOaaV1sQVS5CXK2wuKspIyQD_4lwgyzEAJHTpq; t8t-it-certificates=%7B%22crm-pc%22%3A%229415fa4edb66139531243e76f597c25e%22%2C%22ads%22%3A%22d6864b9c0473c923bb6e544e50139dba%22%2C%22im%22%3A%22615d0af6db671ba90178a83ebd5fd9dd%22%2C%22tumax%22%3A%2252f2959b443ac3e99edf32bb4a876cd1%22%2C%22sso-pc%22%3A%22718926ab4e44bc321799a4c0172f0822%22%2C%22rps-pc%22%3A%22464c995db6648e7ac056c34228cca8e4%22%7D; to8to_active_first_menu_id=172; to8to_dynamic_first_menu_id=172"
    }

    # 线上环境
    # url = "https://erp.to8to.com/index.php/Scm/property/create"
    # headers = {
    #     "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36",
    #     "origin": "https://erp.to8to.com",
    #     "referer": "https://erp.to8to.com/index.php//Scm/property/index",
    #     "Cookie": "PHPSESSID=ilhqpv81l770ghpc8s9ciuhaga; uid=CgoLDmc0px9YUzebRBNvAg==; uid=CjIBt2c0px8+IQNpyjHYAg==; to8tocookieid=45d50a451f99b6d9b7747b16b8e01a51603451; to8to_cook=OkOcClPzRWV8ZFJlCIF4Ag==; tracker2019jssdkcross=%7B%22distinct_id%22%3A%2219325aced8dff2-050e20cac1fe4-26011951-2073600-19325aced8e1e63%22%2C%22first_id%22%3A%22%22%7D; tracker2019session=%7B%22session%22%3A%2219325aced902d43-0f6734a24f122-26011951-2073600-19325aced912bb9%22%7D; t8t-it-uid=13808; t8t-it-username=amos.tong; t8t-it-ticket=eds5uqLStVvQCjKEveag3ac5yfM00nZdYDF0IW5WvsWgKZ1YKgh8g6aj6XrMFkZeSzu-xbCx01E99rOJAwLNkhd_pzDOaaV1sQVS5CXK2wuKspIyQD_4lwgyzEAJHTpq; t8t-it-certificates=%7B%22crm-pc%22%3A%229415fa4edb66139531243e76f597c25e%22%2C%22ads%22%3A%22d6864b9c0473c923bb6e544e50139dba%22%2C%22im%22%3A%22615d0af6db671ba90178a83ebd5fd9dd%22%2C%22tumax%22%3A%2252f2959b443ac3e99edf32bb4a876cd1%22%2C%22sso-pc%22%3A%22718926ab4e44bc321799a4c0172f0822%22%2C%22rps-pc%22%3A%22464c995db6648e7ac056c34228cca8e4%22%7D; to8to_dynamic_first_menu_id=0; to8to_active_first_menu_id=172"
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
        ["81", "仅加微-挽留话术", "AI_CALL_ADD_WECHAT_RETENTION_WORD"],
        ["82", "仅加微-引导操作加微", "AI_CALL_ADD_WECHAT_GUIDE_OPERATION"],
        ["83", "仅加微-告知平台服务", "AI_CALL_ADD_WECHAT_INFORM_PLATFORM"]
    ]
    main(items)

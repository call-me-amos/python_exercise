# -- coding:utf-8 --
"""
自动创建业务辅助资料

https://erp.to8to.com/index.php//Scm/property/index

property_code=1&property_name=1&description=1&parent_id=4980



【禁用业务辅助资料】（资料id用-分割，单个无需-
https://erp.to8to.com/index.php/Scm/property/disable?ids=11843-17849-17850-17851-17852&type=disable

【启用业务辅助资料】
https://erp.to8to.com/index.php/Scm/property/disable?ids=11843-17849-17850-17851-17852&type=able
"""
import copy
import requests

# 新增辅助资料模板
add_template = {
    "parent_id": 16031,  # 分组（类型）id  线上环境id
    # "parent_id": 12430,  # 分组（类型）id  测试环境id
    "property_code": None,  # 编码
    "property_name": "",  # 名称
    "description": "",  # 描述
}


def createProperty(data):


    # 需要将cookie内容复制到headers中
    # 测试环境
    # url = "https://test-erp.to8to.com/index.php/Scm/property/create"
    # headers = {
    #     "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36",
    #     "origin": "https://test-erp.to8to.com",
    #     "referer": "https://test-erp.to8to.com/index.php//Scm/property/index",
    #     "Cookie": "uid=CgoLHWbEg8tjBtWQP6WLAg==; tracker2019jssdkcross=%7B%22distinct_id%22%3A%221916ff03ed6266-04f84a511f0b44-26001e51-2073600-1916ff03ed712ba%22%2C%22first_id%22%3A%22%22%7D; tracker2019session=%7B%22session%22%3A%221916ff03ed88cc-0fa4462b2174fe-26001e51-2073600-1916ff03ed916d2%22%7D; to8tocookieid=1916ff03ed6266-04f84a511f0b44-26001e51-2073600-1916ff03ed712ba; to8to_dynamic_first_menu_id=6437; PHPSESSID=t43m4ajsoi40bg8ietu5ojs7vp; to8to_cook=OkOcClPzRWV8ZFJlCIF4Ag==; t8t-it-uid=13808; t8t-it-username=amos.tong; t8t-it-ticket=eds5uqLStVvQCjKEveag3QPFTllxd7ruIEVxrCsXPEefmr1eTZxssXxqUyJI1khhF_eL1p8kBqEF6aKpvz4RlRd_pzDOaaV1sQVS5CXK2wuKspIyQD_4lwgyzEAJHTpq; t8t-it-certificates=%7B%22crm-pc%22%3A%2277a7522313b62b31aaf4cc1d1ce76cb3%22%2C%22ads%22%3A%224212323243e46a7d9b26970059ad784b%22%2C%22im%22%3A%2226e34924231daea04065e0e681b2198e%22%2C%22tumax%22%3A%224339be00a48df182421886007c92a8ca%22%2C%22sso-pc%22%3A%221c449acdf835f382ad2fbe62919082e1%22%2C%22rps-pc%22%3A%225cb2a0fffb8098fc17aa4a76eea8309f%22%7D; to8to_active_first_menu_id=442"
    # }

    # 线上环境
    url = "https://erp.to8to.com/index.php/Scm/property/create"
    headers = {
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36",
        "origin": "https://erp.to8to.com",
        "referer": "https://erp.to8to.com/index.php//Scm/property/index",
        "Cookie": "uid=CgoLHWbEg8tjBtWQP6WLAg==; PHPSESSID=g077pi34herstc2henmm5pcku9; tracker2019jssdkcross=%7B%22distinct_id%22%3A%221916ff03ed6266-04f84a511f0b44-26001e51-2073600-1916ff03ed712ba%22%2C%22first_id%22%3A%22%22%7D; tracker2019session=%7B%22session%22%3A%221916ff03ed88cc-0fa4462b2174fe-26001e51-2073600-1916ff03ed916d2%22%7D; to8tocookieid=1916ff03ed6266-04f84a511f0b44-26001e51-2073600-1916ff03ed712ba; to8to_dynamic_first_menu_id=6437; to8to_cook=OkOcClPzRWV8ZFJlCIF4Ag==; t8t-it-uid=13808; t8t-it-username=amos.tong; t8t-it-ticket=eds5uqLStVvQCjKEveag3QPFTllxd7ruIEVxrCsXPEefmr1eTZxssXxqUyJI1khhF_eL1p8kBqEF6aKpvz4RlRd_pzDOaaV1sQVS5CXK2wuKspIyQD_4lwgyzEAJHTpq; t8t-it-certificates=%7B%22crm-pc%22%3A%2277a7522313b62b31aaf4cc1d1ce76cb3%22%2C%22ads%22%3A%224212323243e46a7d9b26970059ad784b%22%2C%22im%22%3A%2226e34924231daea04065e0e681b2198e%22%2C%22tumax%22%3A%224339be00a48df182421886007c92a8ca%22%2C%22sso-pc%22%3A%221c449acdf835f382ad2fbe62919082e1%22%2C%22rps-pc%22%3A%225cb2a0fffb8098fc17aa4a76eea8309f%22%7D; to8to_active_first_menu_id=442"
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
    for key, value in params.items():
        data_tmp = copy.copy(add_template)
        data_tmp["property_code"] = key
        data_tmp["property_name"] = value

        createProperty(data_tmp)


if __name__ == '__main__':
    items = {
        "610":"在当地时间第30天确认",
        "611":"在当地时间下月初确认",
        "612":"在当地时间下月中旬确认",
        "613":"意向量房时间-再当地时间-第30天",
        "614":"意向量房时间-再当地时间-下月1号",
        "615":"意向量房时间-再当地时间-下月初",
        "616":"意向量房时间-再当地时间-下月11号",
        "617":"意向量房时间-再当地时间-下月中",


    }
    main(items)

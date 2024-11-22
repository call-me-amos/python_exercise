import requests
import json
'''
    批量删除和新增规则
'''

templateId = 60

def deleteRule():
    # url = "https://apigw.to8to.com/cgi/tls/smartChat/deleteDiyRuleByTemplateId"
    url = "http://10.4.42.48:40121/tls/smartChat/deleteDiyRuleByTemplateId"
    data = {
        "templateId": templateId
    }
    res = requests.post(url=url, json=data)
    return res.json()

def insertRule(diyRule):
    # url = "https://apigw.to8to.com/cgi/tls/smartChat/insertDiyRule"
    url = "http://10.4.42.48:40121/tls/smartChat/insertDiyRule"
    data = {
        "ruleName": diyRule['ruleName'],
        "ruleDescribe": diyRule['ruleDescribe'],
        "ruleCondition": diyRule['ruleCondition'],
        "nextStrategyType": diyRule['nextStrategyType'],
        "nextAskSlot": diyRule['nextAskSlot'],
        "templateId": diyRule['templateId']
    }
    res = requests.post(url=url, json=data)

    return res.json()


if __name__ == '__main__':
    # 【1】根据模板id删除规则
    # 【2】插入规则
    # 【3】清理规则缓存--手动拨测吧-需要指定java实例，目前没有串联。后面加上获取eureka实例逻辑，再动态更新

    print(f"【1】根据模板id删除规则")
    resJson = deleteRule()
    print(f"根据模板id删除规则结果：{resJson}")

    print(f"【2】插入规则")
    diyRuleList = json.load(open("./data/diyRule.txt", "r", encoding="utf-8"))
    for diyRule in diyRuleList:
        print(f"diyRule={json.dumps(diyRule)}")
        resJson = insertRule(diyRule)
        print("插入完成")

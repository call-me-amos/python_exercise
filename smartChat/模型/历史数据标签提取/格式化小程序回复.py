# -*- coding: utf8 -*-

import re
import json
import time

temps = [
    "#{尊称}，我看到您完善了信息，#{房屋所在省}#{房屋所在市}#{房屋所在区}#{房屋所在小区}#{您的房屋面积}的#{您的装修类型}，打算使用#{您的全半包计划}，#{预计装修时间}装修，#{测量时间}可以量房",
    "#{尊称}，咱们填写的信息是#{房屋所在省}#{房屋所在市}#{房屋所在区}#{房屋所在小区}#{您的房屋面积}的房子要装修房屋类型：#{您的装修类型}全半包计划：#{您的全半包计划}可测量时间：#{测量时间}可装修时间：#{预计装修时间}辛苦补充一下信息",
    "#{尊称}，我看到您完善了信息，#{房屋所在省}#{房屋所在市}#{房屋所在区}#{房屋所在小区}#{您的房屋面积}的#{您的装修类型}，您想要的风格是#{您想要的装修风格}，全半包计划选择#{您的全半包计划}，#{预计装修时间}装修，#{测量时间}可以量房",
    "#{尊称}，我看到您完善了信息，#{房屋所在省}#{房屋所在市}#{房屋所在区}#{房屋所在小区}#{您的房屋面积}的#{您的装修类型}，全半包计划选择#{您的全半包计划}，您想要的风格是#{您想要的装修风格}，#{预计装修时间}装修，#{测量时间}可以量房",
    "#{尊称}，(咱们填写的信息是)?#{房屋所在省}#{房屋所在市}#{房屋所在区}#{房屋所在小区}#{您的房屋面积}的房子要装修房屋类型：#{您的装修类型}全半包计划：#{您的全半包计划}装修风格：#{您想要的装修风格}可测量时间：#{测量时间}可装修时间：#{预计装修时间}辛苦补充一下信息"
]

tempRegIndex = [
    {2: "nickName", 5: "省", 8: "cityStr", 9: "区", 12: "address", 13: "engineeringQuantityStr", 14: "全半包", 15: "decoTime",18: "measureTime"},
    {2: "nickName", 5: "省", 8: "cityStr", 9: "区", 12: "address", 13: "engineeringQuantityStr", 14: "全半包", 15: "decoTime",18: "measureTime"},
    {2: "nickName", 5: "省", 8: "cityStr", 9: "区", 12: "address", 13: "engineeringQuantityStr", 15: "全半包", 16: "decoTime", 19: "measureTime"},
    {2: "nickName", 5: "省", 8: "cityStr", 9: "区", 12: "address", 13: "engineeringQuantityStr", 15: "装修风格", 14: "全半包", 16: "decoTime", 19: "measureTime"},
    {2: "nickName", 6: "省", 9: "cityStr", 10: "区", 13: "address", 14: "engineeringQuantityStr", 16: "全半包", 17: "decoTime",20: "measureTime"}
]

regs = """ {
    "#{尊称}":"((.{1,3})(先生|女士|哥|姐|小姐)?)?",
    "#{房屋所在省}":"((河北|山西|辽宁|吉林|黑龙江|江苏|浙江|安徽|福建|江西|山东|河南|广东|湖南|湖北|海南|四川|贵州|云南|陕西|甘肃|青海|台湾|内蒙古|广西|西藏|宁夏|新疆|北京|天津|上海|重庆|香港|澳门)(壮族|回族|维吾尔)?(省|市|自治区)?)?",
    "#{房屋所在市}":"(北京市|天津市|石家庄市|唐山市|秦皇岛市|邯郸市|邢台市|保定市|张家口市|承德市|沧州市|廊坊市|衡水市|太原市|大同市|阳泉市|长治市|晋城市|朔州市|晋中市|运城市|忻州市|临汾市|吕梁市|呼和浩特市|包头市|乌海市|赤峰市|通辽市|鄂尔多斯市|呼伦贝尔市|巴彦淖尔市|乌兰察布市|兴安盟|锡林郭勒盟|阿拉善盟|沈阳市|大连市|鞍山市|抚顺市|本溪市|丹东市|锦州市|营口市|阜新市|辽阳市|盘锦市|铁岭市|朝阳市|葫芦岛市|长春市|吉林市|四平市|辽源市|通化市|白山市|松原市|白城市|延边朝鲜族自治州|哈尔滨市|齐齐哈尔市|鸡西市|鹤岗市|双鸭山市|大庆市|伊春市|佳木斯市|七台河市|牡丹江市|黑河市|绥化市|大兴安岭地区|上海市|南京市|无锡市|徐州市|常州市|苏州市|南通市|连云港市|淮安市|盐城市|扬州市|镇江市|泰州市|宿迁市|杭州市|宁波市|温州市|嘉兴市|湖州市|绍兴市|金华市|衢州市|舟山市|台州市|丽水市|合肥市|芜湖市|蚌埠市|淮南市|马鞍山市|淮北市|铜陵市|安庆市|黄山市|滁州市|阜阳市|宿州市|六安市|亳州市|池州市|宣城市|福州市|厦门市|莆田市|三明市|泉州市|漳州市|南平市|龙岩市|宁德市|南昌市|景德镇市|萍乡市|九江市|新余市|鹰潭市|赣州市|吉安市|宜春市|抚州市|上饶市|济南市|青岛市|淄博市|枣庄市|东营市|烟台市|潍坊市|济宁市|泰安市|威海市|日照市|临沂市|德州市|聊城市|滨州市|菏泽市|郑州市|开封市|洛阳市|平顶山市|安阳市|鹤壁市|新乡市|焦作市|濮阳市|许昌市|漯河市|三门峡市|南阳市|商丘市|信阳市|周口市|驻马店市|武汉市|黄石市|十堰市|宜昌市|襄阳市|鄂州市|荆门市|孝感市|荆州市|黄冈市|咸宁市|随州市|恩施土家族苗族自治州|长沙市|株洲市|湘潭市|衡阳市|邵阳市|岳阳市|常德市|张家界市|益阳市|郴州市|永州市|怀化市|娄底大市|湘西土家族苗族自治州|广州市|韶关市|深圳市|珠海市|汕头市|佛山市|江门市|湛江市|茂名市|肇庆市|惠州市|梅州市|汕尾市|河源市|阳江市|清远市|东莞市|中山市|潮州市|揭阳市|云浮市|南宁市|柳州市|桂林市|梧州市|北海市|防城港市|钦州市|贵港市|玉林市|百色市|贺州市|河池市|来宾市|崇左市|海口市|三亚市|三沙市|重庆市|成都市|自贡市|攀枝花市|泸州市|德阳市|绵阳市|广元市|遂宁市|内江市|乐山市|南充市|眉山市|宜宾市|广安市|达州市|雅安市|巴中市|资阳市|阿坝藏族羌族自治州|甘孜藏族自治州|凉山彝族自治州|贵阳市|六盘水市|遵义市|安顺市|毕节市|铜仁市|黔西南布依族苗族自治州|黔东南苗族侗族自治州|黔南布依族苗族自治州|昆明市|曲靖市|玉溪市|保山市|昭通市|丽江市|普洱市|临沧市|楚雄彝族自治州|红河哈尼族彝族自治州|文山壮族苗族自治州|西双版纳傣族自治州|大理白族自治州|德宏傣族景颇族自治州|怒江傈僳族自治州|迪庆藏族自治州|拉萨市|阿里地区|西安市|铜川市|宝鸡市|咸阳市|渭南市|延安市|汉中市|榆林市|安康市|商洛市|兰州市|嘉峪关市|金昌市|白银市|天水市|武威市|张掖市|平凉市|酒泉市|庆阳市|定西市|陇南市|临夏回族自治州|甘南藏族自治州|西宁市|海北藏族自治州|黄南藏族自治州|海南藏族自治州|果洛藏族自治州|玉树藏族自治州|海西蒙古族藏族自治州|银川市|石嘴山市|吴忠市|固原市|中卫市|乌鲁木齐市|克拉玛依市|昌吉回族自治州|博尔塔拉蒙古自治州|巴音郭楞蒙古自治州|阿克苏地区|克孜勒苏柯尔克孜自治州|喀什地区|和田地区|伊犁哈萨克自治州|塔城地区|阿勒泰地区|济源市|仙桃市|潜江市|天门市|神农架林区|儋州市|五指山市|琼海市|文昌市|万宁市|东方市|定安县|屯昌县|澄迈县|临高县|白沙黎族自治县|昌江黎族自治县|乐东黎族自治县|陵水黎族自治县|保亭黎族苗族自治县|琼中黎族苗族自治县|日喀则市|昌都市|林芝市|山南市|那曲市|海东市|吐鲁番市|哈密市|石河子市|阿拉尔市|图木舒克市|五家渠市|北屯市|铁门关市|双河市|可克达拉市|昆玉市|台北市|高雄市|新北市|台中市|台南市|桃园市|基隆市|新竹市|嘉义市|新竹县|宜兰县|苗栗县|彰化县|云林县|南投县|嘉义县|屏东县|台东县|花莲县|澎湖县|香港|澳门|胡杨河市)?",
    "#{房屋所在区}":"(.{1,10}(区|县|市|旗))?",
    "#{房屋所在小区}":"((.*)m2)?",
    "#{您的房屋面积}":"",
    "#{您的装修类型}":"(毛坯装修|旧房整改|局部改造|精装房)?",
    "#{您的全半包计划}":"(半包|全包|都可以)?",
    "#{预计装修时间}":"(([0-9]{4}-[0-9]{1,2}-[0-9]{1,2})|([0-9]{1,2}月))?",
    "#{测量时间}":"(([0-9]{4}-[0-9]{1,2}-[0-9]{1,2})|(今天|明天|后天|7天内|15天内|30天内|30天外))?",
    "#{您想要的装修风格}":"(现代简约|复古风|新中式风|田园风|美式经典|欧式豪华|北欧风|日式|地中海|潮流混搭|其他|轻奢风)?"
    } """

reg_list = []

for temp in temps:
    # 解析JSON数据
    reg_data = json.loads(regs)
    # 遍历JSON对象的键和值
    for key, value in reg_data.items():
        # print(key, value)
        temp = temp.replace(key, value)
    print(temp)
    reg_list.append(temp)


def date_pre(rtime,tag):
    if tag == "" or tag == "今天":
        return rtime
    elif tag == "明天" :
        return rtime + 86400
    elif tag == "后天" :
        return rtime + 2*86400
    elif tag == "7天内" :
        return rtime + 3*86400
    elif tag == "15天内" :
        return rtime + 7*86400
    elif tag == "30天内" :
        return rtime + 15*86400
    elif tag == "30天外" :
        return rtime + 31*86400
    elif re.match("(\d+)月", tag):
        return time.mktime(time.strptime(time.strftime("%Y-"+re.match("(\d+)月", tag).group(1), time.localtime(rtime)),"%Y-%m"))
    elif re.match("([0-9]{4}-[0-9]{1,2}-[0-9]{1,2})", tag):
        return time.mktime(time.strptime(tag, "%Y-%m-%d"))


def get_tag(text, row_send_time):
    """
    return com.to8to.tbt.tls.smartChat.consumer.message.ProjectInfoChangeMessage
    """

    text = text.replace("hello", "未知")
    i = 0
    for reg_str in reg_list:
        result = re.match(reg_str, text)
        if result:
            print(i, " ", result.groups())
            tagIndex = tempRegIndex[i]
            res = {}
            for key, value in tagIndex.items():
                tag = result.group(key)
                if value == "address" and tag:
                    temp_address = re.findall("([0-9]+)$", tag)
                    res.setdefault("area", temp_address[0])
                    res.setdefault("address", str(tag).replace(temp_address[0], ""))
                elif (value == "decoTime" or value == "measureTime") and tag:
                    res.setdefault(value, date_pre(row_send_time, tag))
                else:
                    res.setdefault(value, tag)
            return res
        i = i + 1


def test():
    # text = "陈女士，我看到您完善了信息，四川成都市锦江区首航欣程87m2的局部改造，打算使用都可以，7月装修，30天外可以量房。这些信息没问题的话，我尽快帮您安排1-4家公司免费量房出方案和报价，可以吗？"
    # text = "张卓先生，咱们填写的信息是重庆市南岸区悦地购物中心105m2的房子要装修房屋类型：毛坯装修全半包计划：半包可测量时间：2023-08-10可装修时间：2023-10-10辛苦补充一下信息，我给您预约当地的金牌设计师免费服务哦"
    # text = "郭先生，我看到您完善了信息，广东广州市增城一区岸芷汀兰二街2座175m2的旧房整改，您想要的风格是其他，全半包计划选择都可以，2023-10-26装修，2023-10-14可以量房。这些信息没问题的话，我尽快帮您安排1-4家公司免费量房出方案和报价，可以吗"
    # text="千语女士，我看到您完善了信息，浙江杭州市余杭区清合嘉园(东区)87m2的旧房整改，全半包计划选择都可以，您想要的风格是复古风，2025-10-17装修，2023-10-17可以量房。这些信息没问题的话，我尽快帮您安排1-4家公司免费量房出方案和报价，可以吗？"
    #text = "hello，咱们填写的信息是山东枣庄市薛城区的房子要装修房屋类型：毛坯装修全半包计划：可测量时间：2023-06-18可装修时间：2023-07-10辛苦补充一下信息，我给您预约当地的金牌设计师免费服务哦"
    text = "洪果女士，我看到您完善了信息，浙江杭州市萧山区禹洲泊朗廷轩营销中心89m?的毛坯装修，全半包计划选择半包，您想要的风格是现代简约，2023-11-01装修，2024-10-15可以量房。这些信息没问题的话，我尽快帮您安排1-4家公司免费量房出方案和报价，可以吗？"
    print(get_tag(text, 1696382558))


if __name__ == '__main__':
    test()


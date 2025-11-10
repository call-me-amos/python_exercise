
## 用python实现
data1,data2,data3分别为fastGpt AI对话组件返回的string类型数据，里面包含：数据格式为json，请完善下面的python代码

import json

def main(data1, data2, data3):
    # 将字符串数据转换为json对象
    def safe_json_loads(data):
        try:
            return json.loads(data) if data else {}
        except json.JSONDecodeError:
            return {}
    
    json1 = safe_json_loads(data1)
    json2 = safe_json_loads(data2)
    json3 = safe_json_loads(data3)
    
    # 合并三个json对象
    merged_data = {**json1, **json2, **json3}
    
    return {
        "aiReply": merged_data,  ## data1,data2,data3转成json，合并后的结果
    }

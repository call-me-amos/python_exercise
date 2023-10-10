import os
import re
import json
import pandas as pd

input_path = r"D:\temp\槽位归一值失败问题.txt"
output_direct = r"D:\temp"

result_df = pd.DataFrame(columns=['槽位类型', '槽位值'])
n = 0
with open(input_path, mode='r', encoding='UTF-8') as file:
    for f in file.readlines():
        chars = re.match(".*(\[\{.*}])$", f).group(1)
        json_list = json.loads(chars)
        for d in json_list:
            result_df.loc[n] = [d.get("type", "").strip(), d.get("text", "").strip()]
            n += 1
# 去重处理
result_df.drop_duplicates(inplace=True, ignore_index=True)
# 保存值
result_df.to_excel(os.path.join(output_direct,"槽位归一失败提取结果.xlsx"))
print("提取归一值失败完成")

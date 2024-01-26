import matplotlib.pyplot as plt
import pandas as pd
from io import StringIO

# 新数据字符串
new_data_str = """
create_time 抢答率
20231125 19.12%
20231126 33.33%
20231127 24.79%
20231128 20.24%
20231129 25.20%
20231130 27.66%
20231201 28.57%
20231202 21.88%
20231203 13.60%
20231204 25.00%
20231205 20.18%
20231206 23.89%
20231207 21.93%
20231208 18.50%
20231209 18.78%
20231210 21.76%
20231211 22.22%
20231212 21.62%
20231213 31.20%
20231214 21.48%
20231215 24.80%
20231216 20.30%
20231217 23.48%
20231218 19.11%
20231219 25.86%
20231220 28.35%
20231221 35.62%
20231222 25.52%
20231223 25.30%
20231224 19.66%
20231225 19.89%
"""

# 将新数据字符串转换为DataFrame
new_df = pd.read_csv(StringIO(new_data_str), delim_whitespace=True)

# 将百分比转换为小数
new_df['抢答率'] = new_df['抢答率'].str.rstrip('%').astype('float') / 100.0

# 将 create_time 转换为日期格式，并按日期排序
new_df['create_time'] = pd.to_datetime(new_df['create_time'], format='%Y%m%d')
new_df = new_df.sort_values(by='create_time')

# 绘制折线图
plt.figure(figsize=(10, 6))
plt.plot(new_df['create_time'], new_df['抢答率'] * 100, marker='o', color='green', label='抢答率')

# 设置图表标题和标签
plt.title('抢答率随时间变化')
plt.xlabel('日期')
plt.ylabel('抢答率 (%)')
plt.legend()

# 显示图表
plt.show()

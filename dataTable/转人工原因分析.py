import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from matplotlib import rcParams

# 设置中文字体（SimHei 黑体）
rcParams['font.sans-serif'] = ['黑体']  # 用于支持中文
rcParams['axes.unicode_minus'] = False  # 避免负号显示问题

# 示例数据
data = {
    "时间": [
        "10.01~10.03", "10.04~10.10", "10.11~10.17", "10.18~10.24", "10.25~10.31",
        "11.01~11.07", "11.08~11.14", "11.15~11.21", "11.22~11.28", "11.29~12.05",
        "12.06~12.12", "12.13~12.19", "12.20~12.26"
    ],
    "系统闭环计数": [467, 1637, 1284, 1194, 1222, 1156, 1189, 1081, 715, 781, 903, 794, 857],
    "系统闭环占比": [20.08, 19.49, 19.85, 20.83, 20.57, 20.18, 20.79, 20.49, 19.95, 21.67, 21.46, 20.26, 21.37],
    "ABC类闭环计数": [41, 230, 641, 975, 991, 987, 1042, 935, 617, 692, 808, 737, 786],
    "ABC类闭环占比": [1.76, 2.74, 9.91, 17.01, 16.68, 17.23, 18.22, 17.72, 17.22, 19.22, 19.21, 18.79, 19.35]
}

df = pd.DataFrame(data)

# 设置 Seaborn 风格
sns.set_theme(style="whitegrid", font_scale=1.2)

# 创建图表
fig, ax1 = plt.subplots(figsize=(14, 7))

# 柱状图（计数）
bar_width = 0.4
x = range(len(df["时间"]))
ax1.bar(x, df["系统闭环计数"], width=bar_width, label="系统闭环计数", color="#4c78a8", alpha=0.8)
ax1.bar(x, df["ABC类闭环计数"], width=bar_width, label="ABC类闭环计数", color="#f58518", alpha=0.8, bottom=df["系统闭环计数"])

# 设置左侧 Y 轴（计数）
ax1.set_ylabel("计数", fontsize=14, labelpad=10)
ax1.set_xlabel("时间", fontsize=14, labelpad=10)
ax1.set_xticks(x)
ax1.set_xticklabels(df["时间"], rotation=45, ha="right")
ax1.legend(loc="upper left", fontsize=12)

# 折线图（占比）
ax2 = ax1.twinx()
ax2.plot(x, df["系统闭环占比"], label="系统闭环占比", color="#4c78a8", marker="o", linestyle="-", linewidth=2)
ax2.plot(x, df["ABC类闭环占比"], label="ABC类闭环占比", color="#f58518", marker="o", linestyle="-", linewidth=2)

# 设置右侧 Y 轴（占比）
ax2.set_ylabel("占比 (%)", fontsize=14, labelpad=10)
ax2.tick_params(axis="y")
ax2.legend(loc="upper right", fontsize=12)

# 图表标题和布局调整
plt.title("系统闭环和 ABC 类闭环趋势分析", fontsize=16, pad=20)
plt.tight_layout()

# 显示图表
plt.show()

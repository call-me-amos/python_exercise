#拿走不谢
import matplotlib.pyplot as plt
import numpy as np

# 生成心形曲线的数据
t = np.linspace(0, 2 * np.pi, 500)
x = 16 * np.sin(t) ** 3
y = 13 * np.cos(t) - 5 * np.cos(2 * t) - 2 * np.cos(3 * t) - np.cos(4 * t)

# 绘制心形曲线
plt.figure(figsize=(6, 5))
plt.plot(x, y, color='red', linewidth=2)
plt.fill(x, y, color='pink')  # 填充心形

# 添加文本
plt.text(0, 0, '女神节快乐！', fontsize=20, color='purple', ha='center', va='center')
plt.text(0, -5, '永远18，笑容灿烂！', fontsize=12, color='gray', ha='center', va='center')

# 设置坐标轴范围和样式
plt.axis('equal')
plt.axis('off')  # 隐藏坐标轴

# 显示图形
plt.show()
import os

# 指定文件夹路径
folder_path = 'C:\\Users\\amos.tong\\Desktop\\表情包'

# 获取文件夹中的所有文件和文件夹
items = os.listdir(folder_path)

# 过滤出只有文件（不包括文件夹）
files = [f for f in items if os.path.isfile(os.path.join(folder_path, f))]

i = 0
# 打印文件名称
for file in files:
    if "表情包" in file:
        continue
    print(f"{file}&{file.split('_')[1].split('.')[0]}")
    i = i + 1

print(f"文件总数：{i}")
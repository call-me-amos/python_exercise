import pandas as pd
from openpyxl.styles import Alignment

## 通过sql查询到的槽位收集和进入明细表
input_file = 'C:/Users/amos.tong/Desktop/source_data.xlsx'
output_file = "C:/Users/amos.tong/Desktop/槽位的进入和收集数据.xlsx"

# 1. 读取数据
df = pd.read_excel(input_file)

# 2. 创建统计结果
result = pd.DataFrame({
    '槽位': ['装修时间', '房屋类型', '工程量', '装修用途','是否交房','交房时间','意向量房时间','小区名称','房屋面积','姓氏'],
    '项目数量': len(df),
})

# 3. 计算指标
result['槽位进入数'] = [
    df['进入-装修时间'].eq('进入').sum(),
    df['进入-房屋类型'].eq('进入').sum(),
    df['进入-工程量'].eq('进入').sum(),
    df['进入-装修用途'].eq('进入').sum(),
    df['进入-是否交房'].eq('进入').sum(),
    df['进入-交房时间'].eq('进入').sum(),
    df['进入-意向量房时间'].eq('进入').sum(),
    df['进入-小区名称'].eq('进入').sum(),
    df['进入-房屋面积'].eq('进入').sum(),
    df['进入-姓氏'].eq('进入').sum()
]

# 4. 计算比率（保留数值用于格式化和潜在计算）
result['槽位进入率'] = (result['槽位进入数'] / result['项目数量']).apply(lambda x: f"{x:.2%}")

result['槽位收集数'] = [
    df['收集-装修时间'].eq('收集').sum(),
    df['收集-房屋类型'].eq('收集').sum(),
    df['收集-工程量'].eq('收集').sum(),
    df['收集-装修用途'].eq('收集').sum(),
    df['收集-是否交房'].eq('收集').sum(),
    df['收集-交房时间'].eq('收集').sum(),
    df['收集-意向量房时间'].eq('收集').sum(),
    df['收集-小区名称'].eq('收集').sum(),
    df['收集-房屋面积'].eq('收集').sum(),
    df['收集-姓氏'].eq('收集').sum()
]
result['槽位收集率'] = (result['槽位收集数'] / result['项目数量']).apply(lambda x: f"{x:.2%}")

# 5. 输出到Excel并自动调整列宽
with pd.ExcelWriter(output_file, engine='openpyxl') as writer:
    result.to_excel(writer, index=False, sheet_name='统计结果')

    # 获取工作表对象
    worksheet = writer.sheets['统计结果']

    # 设置百分比列右对齐
    right_align = Alignment(horizontal='right')
    for col in ['D', 'F']:  # D列是槽位进入率，F列是槽位收集率
        for cell in worksheet[col]:
            cell.alignment = right_align

    # 自动调整列宽
    for col in worksheet.columns:
        max_length = 0
        column = col[0].column_letter  # 获取列字母

        # 计算列中单元格的最大字符长度
        for cell in col:
            try:
                cell_value = str(cell.value)
                # 中文按2字符宽度计算
                chinese_count = sum(1 for c in cell_value if '\u4e00' <= c <= '\u9fff')
                adjusted_length = len(cell_value) + chinese_count
                if adjusted_length > max_length:
                    max_length = adjusted_length
            except:
                pass

        # 设置列宽（基础宽度+缓冲）
        adjusted_width = (max_length + 2) * 1.2  # 1.2倍系数
        worksheet.column_dimensions[column].width = min(adjusted_width, 50)  # 限制最大列宽50

print(f"处理完成！结果已保存到: {output_file}")
print("统计结果预览：")
print(result)
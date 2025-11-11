import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.table import Table
import numpy as np
import requests
import markdown
import imgkit
import hashlib
import base64
import json
import pandas as pd
from PIL import Image, ImageDraw, ImageFont
import numpy as np
import traceback
from datetime import datetime, time

###########################################################数据转换类##################################################################
#excel转图片
def excel_to_image_pillow(excel_file, sheet_name=0, output_image='excel_table.png'):
    """
    使用Pillow库将Excel表格转换为图片（更好的中文支持）
    """
    # 读取Excel文件
    try:
        df = pd.read_excel(excel_file, sheet_name=sheet_name)
    except Exception as e:
        print(f"读取Excel文件时出错: {e}")
        return False

    # 检查数据框是否为空
    if df.empty:
        print("Excel文件没有数据")
        return False

    # 设置字体
    try:
        # 尝试使用中文字体
        font = ImageFont.truetype("simhei.ttf", 14)  # 黑体
        header_font = ImageFont.truetype("simhei.ttf", 16)  # 黑体加粗
    except:
        # 回退到默认字体
        font = ImageFont.load_default()
        header_font = ImageFont.load_default()

    # 计算图片尺寸
    rows, cols = df.shape
    cell_width = 150
    cell_height = 40
    img_width = cell_width * (cols + 1)
    img_height = cell_height * (rows + 1)

    # 创建图片
    img = Image.new('RGB', (img_width, img_height), color='white')
    draw = ImageDraw.Draw(img)

    # 绘制表头
    for j, col_name in enumerate(df.columns):
        x = j * cell_width + cell_width // 2
        y = cell_height // 2
        draw.rectangle([j * cell_width, 0, (j + 1) * cell_width, cell_height], fill='#40466e')
        draw.text((x, y), str(col_name), fill='white', font=header_font, anchor='mm')

    # 绘制数据行
    for i, row in df.iterrows():
        for j, value in enumerate(row):
            x = j * cell_width + cell_width // 2
            y = (i + 1) * cell_height + cell_height // 2

            # 交替行颜色
            if i % 2 == 0:
                draw.rectangle([j * cell_width, (i + 1) * cell_height,
                                (j + 1) * cell_width, (i + 2) * cell_height],
                               fill='#f2f2f2' if i % 2 == 0 else 'white')

            draw.text((x, y), str(value), fill='black', font=font, anchor='mm')

    # 绘制网格线
    for i in range(rows + 2):
        draw.line([0, i * cell_height, img_width, i * cell_height], fill='black', width=1)
    for j in range(cols + 1):
        draw.line([j * cell_width, 0, j * cell_width, img_height], fill='black', width=1)

    # 保存图片
    img.save(output_image)
    print(f"Excel内容已成功保存为图片: {output_image}")
    return True


def excel_to_image_pillow(
        excel_file,
        sheet_name=0,
        output_image='excel_table.png',
        first_col_width=150  # 新增参数：指定第一列宽度，默认150
):
    """
    使用Pillow库将Excel表格转换为图片（支持指定第一列宽度，更好的中文支持）
    """
    # 读取Excel文件
    try:
        df = pd.read_excel(excel_file, sheet_name=sheet_name)
    except Exception as e:
        print(f"读取Excel文件时出错: {e}")
        return False

    # 检查数据框是否为空
    if df.empty:
        print("Excel文件没有数据")
        return False

    # 设置字体
    try:
        # 尝试使用中文字体
        font = ImageFont.truetype("simhei.ttf", 14)  # 黑体
        header_font = ImageFont.truetype("simhei.ttf", 16)  # 黑体加粗
    except:
        # 回退到默认字体
        font = ImageFont.load_default()
        header_font = ImageFont.load_default()

    # 配置列宽：第一列由参数指定，其他列默认150（可按需修改other_col_width）
    rows, cols = df.shape
    other_col_width = 150  # 其他列默认宽度
    cell_height = 40  # 行高保持不变

    # 计算图片总尺寸
    # 总宽度 = 第一列宽度 + 其他列总宽度（若只有1列，则总宽度=第一列宽度）
    img_width = first_col_width + (cols - 1) * other_col_width if cols > 1 else first_col_width
    img_height = cell_height * (rows + 1)  # 表头+数据行总高度

    # 创建图片
    img = Image.new('RGB', (img_width, img_height), color='white')
    draw = ImageDraw.Draw(img)

    # 绘制表头（区分第一列和其他列）
    for j, col_name in enumerate(df.columns):
        # 确定当前列的宽度和起始x坐标
        if j == 0:  # 第一列
            col_width = first_col_width
            x_start = 0
        else:  # 其他列
            col_width = other_col_width
            x_start = first_col_width + (j - 1) * other_col_width  # 累积前序列宽度

        # 绘制表头背景
        draw.rectangle(
            [x_start, 0, x_start + col_width, cell_height],
            fill='#40466e'
        )
        # 表头文本居中
        text_x = x_start + col_width // 2
        text_y = cell_height // 2
        draw.text(
            (text_x, text_y),
            str(col_name),
            fill='white',
            font=header_font,
            anchor='mm'
        )

    # 绘制数据行（区分第一列和其他列）
    for i, row in df.iterrows():
        row_y_start = (i + 1) * cell_height  # 当前行起始y坐标
        for j, value in enumerate(row):
            # 确定当前列的宽度和起始x坐标
            if j == 0:  # 第一列
                col_width = first_col_width
                x_start = 0
            else:  # 其他列
                col_width = other_col_width
                x_start = first_col_width + (j - 1) * other_col_width

            # 交替行背景色
            if i % 2 == 0:
                draw.rectangle(
                    [x_start, row_y_start, x_start + col_width, row_y_start + cell_height],
                    fill='#f2f2f2'
                )

            # 数据文本居中
            text_x = x_start + col_width // 2
            text_y = row_y_start + cell_height // 2
            draw.text(
                (text_x, text_y),
                str(value),
                fill='black',
                font=font,
                anchor='mm'
            )

    # 绘制网格线
    # 1. 水平网格线（行分隔线）
    for i in range(rows + 1):
        y = i * cell_height
        draw.line([0, y, img_width, y], fill='black', width=1)

    # 2. 垂直网格线（列分隔线）
    # 第一列右侧线
    draw.line([first_col_width, 0, first_col_width, img_height], fill='black', width=1)
    # 其他列右侧线（从第二列开始）
    for j in range(1, cols):
        x = first_col_width + j * other_col_width
        draw.line([x, 0, x, img_height], fill='black', width=1)
    # 最左侧线（可选，若需要边框完整性）
    draw.line([0, 0, 0, img_height], fill='black', width=1)

    # 保存图片
    img.save(output_image)
    print(f"Excel内容已成功保存为图片: {output_image}")
    return True

#表格转markdown
def jsonToMarkdownTable(title,result):
    message = title + "\n"

    num = 0
    line1 = ""
    line2 = ""
    for col in result.columns:
        if num == 0:
            line1 += f"| {col} |"
            line2 += f"| :----- |"
        elif num == len(result.columns) - 1:
            line1 += f" {col} |\n"
            line2 += f" -------: |\n"
        else:
            line1 += f" {col} |"
            line2 += f" :----: |"

        num += 1
    message = message + line1 + line2

    for index, row in result.iterrows():
        lineContent = ""
        for col in result.columns:
            if num == 0:
                lineContent += f"| {row[col]} |"
            elif num == len(result.columns) - 1:
                lineContent += f" {row[col]} |\n"
            else:
                lineContent += f" {row[col]} |"

        message += lineContent
    return message


def markdown_to_image(md_text, output_path="output.png"):
    # Markdown 转 HTML
    html_content = markdown.markdown(md_text,extensions=['tables'])

    print(html_content)

    # 完整 HTML 结构（添加 CSS 样式）
    full_html = f"""
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <style>
        body {{
          font-family: 'Arial', sans-serif;
          line-height: 1.6;
          padding: 20px;
          max-width: 800px;
          margin: 0 auto;
        }}
        pre {{
          background-color: #f5f5f5;
          padding: 10px;
          border-radius: 4px;
        }}
        table {{
            border: 2px solid black;
        }}
         th, td {{
            border: 1px solid black; 
         }}
        code {{ background-color: #f5f5f5; }}
      </style>
    </head>
    <body>{html_content}</body>
    </html>
    """
    # 指定 wkhtmltoimage 路径（根据你的实际安装位置修改）
    config = imgkit.config(wkhtmltoimage=r'D:\Program Files\wkhtmltopdf\bin\wkhtmltoimage.exe')

    # HTML 转图片（添加 config 参数）
    imgkit.from_string(
        full_html,
        output_path,
        config=config,  # 添加这行
        options={"format": "png", "enable-local-file-access": None}
    )
    print(f"图片已保存至: {output_path}")

#####################################################发送通知类#########################################################################
#post请求发送播报数据
def send_post_message(data):

    url = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=ba179f55-ebad-467e-bf73-ae20f62d196c"
    headers = {
        "Content-Type": "application/json"
    }
    data = {
        "msgtype": "markdown_v2",
        "markdown_v2": {
            "content": data
        }
    }
    response = requests.post(url, headers=headers, data=json.dumps(data))
    print(response.text)
    return response.json()

def get_md5_and_base64(file_path):
    # 获取 MD5
    md5_hash = hashlib.md5()

    # 读取文件并计算 MD5
    with open(file_path, "rb") as f:
        while chunk := f.read(8192):
            md5_hash.update(chunk)

    md5_value = md5_hash.hexdigest()

    # 获取 Base64 编码内容
    with open(file_path, "rb") as f:
        base64_data = base64.b64encode(f.read()).decode("utf-8")

    return md5_value, base64_data


#post请求发送播报数据
def send_post_img_message(data):
    md5_value, base64_content = get_md5_and_base64(data)
    # 正式群组
    #url = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=ba179f55-ebad-467e-bf73-ae20f62d196c"
    # 智能应答【ERROR】
    url = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=1e222140-0b10-41d0-b088-1ca37a0694cc"
    headers = {
        "Content-Type": "application/json"
    }
    data = {
        "msgtype": "image",
        "image": {
            "base64": base64_content,
            "md5": md5_value
        }
    }
    response = requests.post(url, headers=headers, data=json.dumps(data))
    print(response.text)
    return response.json()

def send_post_file_message(filepath,type="file"):
    url = "https://qyapi.weixin.qq.com/cgi-bin/webhook/upload_media?key=ba179f55-ebad-467e-bf73-ae20f62d196c&type="+type
    data = {
        "Content-Type": "multipart/form-data"
    }
    files = {
        "file": (filepath, open(filepath, "rb"), "application/vnd.ms-excel"),
    }
    response = requests.post(url,data=data ,files=files)
    print(response.text)
    media_id = response.json()["media_id"]

    url = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=ba179f55-ebad-467e-bf73-ae20f62d196c"
    headers = {
        "Content-Type": "application/json"
    }
    data = {
        "msgtype": "file",
        "file": {
            "media_id": media_id
        }
    }
    response = requests.post(url, headers=headers, data=json.dumps(data))
    print(response.text)
    return response.json()


############################################ 框架类 #############################################################
#输出错误日志
def printErr():
    # 获取完整的异常堆栈
    tb_list = traceback.format_exc().splitlines()

    # 提取关键错误行（通常是倒数第二行）
    if len(tb_list) >= 3:
        error_line = tb_list[-2].strip()
        print(f"异常发生在: {error_line}")

    # 输出完整错误信息
    print("\n完整错误跟踪:")
    print(traceback.format_exc())

#############################################时间处理类################################################################
#判断是否在工作时间（9:00-12:00，13:30-18:30）内
def is_working_hours(check_time_str):
    """
    判断给定时间是否在工作时间内（9:00-12:00，13:30-18:30）

    参数:
    check_time_str: 字符串格式的时间，如 "2025-08-21 18:07:09"

    返回:
    bool: 如果在工作时间内返回True，否则返回False
    """
    # 将字符串转换为datetime对象
    check_time = datetime.strptime(check_time_str, "%Y-%m-%d %H:%M:%S")

    # 定义工作时间段
    morning_start = time(9, 0, 0)
    morning_end = time(12, 0, 0)
    afternoon_start = time(13, 30, 0)
    afternoon_end = time(18, 30, 0)

    # 获取时间部分（去掉日期）
    check_time_only = check_time.time()

    # 判断是否在上午工作时间段内
    in_morning = morning_start <= check_time_only <= morning_end
    # 判断是否在下午工作时间段内
    in_afternoon = afternoon_start <= check_time_only <= afternoon_end

    return in_morning or in_afternoon
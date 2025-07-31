import json


## 本地文件
local_file = 'C:/Users/amos.tong/Desktop/9KUZPZxC6i.json'
new_file = 'C:/Users/amos.tong/Desktop/abc.json'

def process_json(input_file, output_file):
    """
    读取、处理和写入JSON文件的完整流程

    参数:
        input_file (str): 输入的JSON文件路径
        output_file (str): 输出的JSON文件路径
    """
    try:
        # 1. 读取JSON文件
        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)

        # 2. 输出原始JSON内容
        # print("原始JSON内容:")
        # print(json.dumps(data, indent=4, ensure_ascii=False))

        # 3. 处理JSON数据（这里只是示例，你可以添加自己的处理逻辑）
        processed_data = process_data(data)

        # 4. 输出处理后的JSON内容
        # print("\n处理后的JSON内容:")
        # print(json.dumps(processed_data, indent=4, ensure_ascii=False))

        # 5. 写入新的JSON文件
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(processed_data, f, ensure_ascii=False)

        print(f"\n处理后的JSON已成功写入")

    except FileNotFoundError:
        print(f"错误: 文件 {input_file} 未找到")
    except json.JSONDecodeError:
        print("错误: 文件内容不是有效的JSON格式")
    except Exception as e:
        print(f"发生未知错误: {str(e)}")


def process_data(data):
    """
    处理JSON数据，仅保留指定的键，并递归处理非字符串值

    参数:
        data: 原始的JSON数据（可以是字典、列表或其他类型）

    返回:
        处理后的数据，仅包含'diagram', 'elements', 'children', 'title'键
        且会递归处理非字符串的值
    """
    # 定义允许保留的键集合
    allowed_keys = {'diagram', 'elements', 'children', 'title'}

    if isinstance(data, dict):
        # 处理字典类型
        new_dict = {}
        for key, value in data.items():
            if key in allowed_keys:
                if isinstance(value, (str, int, float)):
                    # 如果是字符串直接保留
                    value = (value.replace('&nbsp;', '')
                             .replace('<br>', '').strip())
                    new_dict[key] = value
                else:
                    # 非字符串值递归处理
                    processed_value = process_data(value)
                    # 只有当处理后的值非空时才保留
                    if processed_value is not None and (
                            not isinstance(processed_value, (dict, list)) or processed_value):
                        new_dict[key] = processed_value
        return new_dict if new_dict else None

    elif isinstance(data, list):
        # 处理列表类型
        new_list = []
        for item in data:
            processed_item = process_data(item)
            if processed_item is not None and (not isinstance(processed_item, (dict, list)) or processed_item):
                new_list.append(processed_item)
        return new_list if new_list else None

    else:
        # 其他基本类型（字符串、数字等）直接返回
        print(f"@@@ {data}")
        return data





# 使用示例
if __name__ == "__main__":
    process_json(local_file, new_file)
    print(f"=================================")
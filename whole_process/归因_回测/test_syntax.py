#!/usr/bin/env python
# 测试语法是否正确
import sys
import os

try:
    # 尝试导入并编译主脚本
    import attribution_task
    print("语法检查通过")
except SyntaxError as e:
    print(f"语法错误: {e}")
except Exception as e:
    print(f"其他错误: {e}")
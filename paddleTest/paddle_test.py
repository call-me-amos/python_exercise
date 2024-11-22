import paddle
import paddlenlp
from paddlenlp import Taskflow

print(paddle.__version__)
print(paddlenlp.__version__)


# 创建零样本文本分类任务
zero_shot_cls = Taskflow("zero_shot_text_classification", labels=["正面", "负面", "中性"])

# 进行零样本文本分类
result = zero_shot_cls(["我爱自然语言处理", "这本书很糟糕"])
print(f'进行零样本文本分类{result}')


# 创建文本分类任务
text_cls = Taskflow("text_classification", model="ernie-1.0")
print(f'文本分类{text_cls}')

# 执行分类
result = text_cls(["我爱自然语言处理", "这本书很糟糕", "这届奥运会和拉胯"])
print(result)

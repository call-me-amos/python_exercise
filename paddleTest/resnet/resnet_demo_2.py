import io
import math
import numpy as np
import matplotlib.pyplot as plt
import paddle
import paddle.nn.functional as F
import paddle.vision.transforms as T

from paddle.vision.transforms import Normalize
mean = [0.4914, 0.4822, 0.4465]  # CIFAR-10 的常用均值
std = [0.2023, 0.1994, 0.2010]   # CIFAR-10 的常用标准差
transform = Normalize(mean=mean, std=std)

train_dataset = paddle.vision.datasets.Cifar10(mode='train', transform=transform)
eval_dataset = paddle.vision.datasets.Cifar10(mode='test', transform=T.Normalize(mean=127.5, std=127.5))

print('训练数据集个数：{}'.format(len(train_dataset)))
print('测试数据集格式：{}'.format(len(eval_dataset)))


input_shape = train_dataset[0][0].shape
num_classes = 10
epoch = 200
batch_size = 32

resnet50 = paddle.vision.models.resnet50(num_classes=num_classes)

image = paddle.static.InputSpec(shape=[None, *input_shape], dtype='float32', name='image')
label = paddle.static.InputSpec(shape=[None, 1], dtype='int64', name='label')
model = paddle.Model(resnet50, image, label)

model.summary()
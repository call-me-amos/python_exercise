"""
    https://aistudio.baidu.com/projectdetail/8255643?searchKeyword=resnet&searchTab=PROJECT
"""

import paddle
from paddle import nn
from paddle.vision import transforms
from paddle.vision.datasets import Cifar100
from paddle.io import DataLoader

# 定义Bottleneck模块
class Bottleneck(nn.Layer):
    expansion = 4 # 指定扩张因子为4

    def __init__(self, in_channel, out_channel, stride=1, downsample=None):
        super(Bottleneck, self).__init__()
        # 定义第一个1*1的卷积层，用于压缩通道数
        self.conv1 = nn.Conv2D(in_channels=in_channel, out_channels=out_channel, kernel_size=1, stride=1, bias_attr=False)
        self.bn1 = nn.BatchNorm2D(out_channel)
        self.conv2 = nn.Conv2D(in_channels=out_channel, out_channels=out_channel, kernel_size=3, stride=stride, padding=1, bias_attr=False)
        self.bn2 = nn.BatchNorm2D(out_channel)
        self.conv3 = nn.Conv2D(in_channels=out_channel, out_channels=out_channel*self.expansion, kernel_size=1, stride=1, bias_attr=False)
        self.bn3 = nn.BatchNorm2D(out_channel * self.expansion)
        self.relu = nn.ReLU()
        self.downsample = downsample # 下采样层，如果输入输出尺寸不匹配，会进行下采样

    def forward(self, x):
        identity = x # 保存输入的数据，便于进行残差连接
        if self.downsample is not None:
            identity = self.downsample(x)

        out = self.conv1(x)
        out = self.bn1(out)
        out = self.relu(out)
        out = self.conv2(out)
        out = self.bn2(out)
        out = self.relu(out)
        out = self.conv3(out)
        out = self.bn3(out)

        out += identity
        out = self.relu(out)

        return out

# 定义ResNet-50模型
class ResNet(nn.Layer):
    def __init__(self, block, blocks_num, num_classes=1000, include_top=True):
        super().__init__()
        self.include_top = include_top
        self.in_channel = 64
        self.conv1 = nn.Conv2D(3, self.in_channel, kernel_size=7, stride=2, padding=3, bias_attr=False)
        self.bn1 = nn.BatchNorm2D(self.in_channel)
        self.relu = nn.ReLU()
        self.maxpool = nn.MaxPool2D(kernel_size=3, stride=2, padding=1)
        self.layer1 = self._make_layer(block, 64, blocks_num[0])
        self.layer2 = self._make_layer(block, 128, blocks_num[1], stride=2)
        self.layer3 = self._make_layer(block, 256, blocks_num[2], stride=2)
        self.layer4 = self._make_layer(block, 512, blocks_num[3], stride=2)
        if self.include_top:
            self.avgpool = nn.AdaptiveAvgPool2D((1, 1))
            self.fc = nn.Linear(512*block.expansion, num_classes)

    def _make_layer(self, block, channel, blocks_num, stride=1):
        downsample = None
        if stride != 1 or self.in_channel != channel*block.expansion:
            downsample = nn.Sequential(
                nn.Conv2D(self.in_channel, channel*block.expansion, kernel_size=1, stride=stride, bias_attr=False),
                nn.BatchNorm2D(channel*block.expansion),
            )
        layers = []
        layers.append(block(self.in_channel, channel, downsample=downsample, stride=stride))
        self.in_channel = channel*block.expansion
        for _ in range(1, blocks_num):
            layers.append(block(self.in_channel, channel))
        return nn.Sequential(*layers)

    def forward(self, x):
        x = self.conv1(x)
        x = self.bn1(x)
        x = self.relu(x)
        x = self.maxpool(x)

        x = self.layer1(x)
        x = self.layer2(x)
        x = self.layer3(x)
        x = self.layer4(x)

        if self.include_top:
            x = self.avgpool(x)
            x = paddle.flatten(x, 1)
            x = self.fc(x)

        return x
def resnet50(num_classes=1000):
    return ResNet(Bottleneck, [3, 4, 6, 3], num_classes=num_classes)


# 数据预处理
transform = transforms.Compose([
    transforms.RandomHorizontalFlip(),
    transforms.RandomCrop(32, padding=4),
    transforms.ToTensor(),
    transforms.Normalize([0.4914, 0.4822, 0.4465], [0.2023, 0.1994, 0.2010])
])

# 加载数据集
train_dataset = Cifar100(mode='train', transform=transform)
test_dataset = Cifar100(mode='test', transform=transforms.ToTensor())

train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
test_loader = DataLoader(test_dataset, batch_size=32, shuffle=False)


# 初始化模型
model = resnet50(num_classes=100)

# 使用paddle.summary展示网络结构和参数信息
paddle.summary(model, input_size=(64, 3, 224, 224))

# 定义损失函数和优化器
criterion = nn.CrossEntropyLoss()
optimizer = paddle.optimizer.Adam(parameters=model.parameters(), learning_rate=0.001)


# 训练模型
for epoch in range(1):  # 训练10个epoch
    model.train()
    for batch_id, (images, labels) in enumerate(train_loader):
        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
        optimizer.clear_grad()

        if batch_id % 10 == 0:
            print(f"Epoch [{epoch + 1}/10], Batch [{batch_id}/{len(train_loader)}], Loss: {loss.item()}")

    # 每个epoch后在测试集上评估模型
    model.eval()
    correct = 0
    total = 0
    with paddle.no_grad():
        for images, labels in test_loader:
            outputs = model(images)
            predicted = outputs.argmax(axis=1)
            total += labels.shape[0]
            correct += (predicted == labels).sum().item()

    print(f"Accuracy on test set: {100 * correct / total:.2f}%")


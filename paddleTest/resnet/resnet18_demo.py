import torch
import torchvision
import torchvision.transforms as transforms
from torchvision import models
from PIL import Image
import json
import requests

print("开始。。。")

# 加载预训练的ResNet18模型
model = models.resnet18(pretrained=True)
model.eval()  # 将模型设置为评估模式

# 定义图像预处理步骤
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

# 打开图像并应用预处理
img_path = 'C:\\Users\\amos.tong\\Desktop\\表情包\\img_12.gif'  # 替换为你的图像路径
img = Image.open(img_path).convert('RGB')
img_tensor = preprocess(img)
img_tensor = img_tensor.unsqueeze(0)

# 使用模型进行推理
with torch.no_grad():
    output = model(img_tensor)

# 获取预测的类别标签
_, predicted = torch.max(output.data, 1)

# 加载ImageNet的类别标签
URL_TO_LABELS = "https://raw.githubusercontent.com/anishathalye/imagenet-simple-labels/master/imagenet-simple-labels.json"
labels = json.loads(requests.get(URL_TO_LABELS).text)
predicted_label = labels[predicted.item()]
print(f'Predicted label: {predicted_label}')
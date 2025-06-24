import torch
from transformers import BertTokenizer, BertForNextSentencePrediction, BertConfig
from torch.utils.data import DataLoader, Dataset
import wandb
from datetime import datetime


# 获取当前日期和时间并格式化为字符串
formatted_time = datetime.now().strftime("%Y%m%d-%H-%M-%S")
print("格式化后的当前日期和时间:", formatted_time)

# 使用 API Key 登录 wandb
wandb.login(key="7973092beee9e2288db9cec7fd1e1a4a89e9587a")  # 替换为你的 API Key

# 初始化 wandb（使用在线模式）
wandb.init(project="NSP-Training", name=f"bert-nsp-run-{formatted_time}", mode="online")

learning_rate = 5e-5
batch_size = 16
epochs = 10
max_length = 256

data_path = r"datasets/nsp.train-all.data"

# 记录超参数
wandb.config.update({
    "learning_rate": learning_rate,
    "batch_size": batch_size,
    "epochs": epochs
})


class NSPDataset(Dataset):
    def __init__(self, sentences, tokenizer, max_length=max_length):
        self.tokenizer = tokenizer
        self.max_length = max_length
        self.sentences = sentences

    def __len__(self):
        return len(self.sentences)

    def __getitem__(self, idx):
        sentence_a, sentence_b, label = self.sentences[idx]
        inputs = self.tokenizer(
            sentence_a,
            sentence_b,
            padding='max_length',
            truncation=True,
            max_length=self.max_length,
            return_tensors="pt"
        )

        return {
            'input_ids': inputs['input_ids'].squeeze(0),
            'attention_mask': inputs['attention_mask'].squeeze(0),
            'token_type_ids': inputs['token_type_ids'].squeeze(0),
            'labels': torch.tensor(int(label), dtype=torch.long)
        }


# 数据示例 (A, B, label)，label=1表示B是A的下一句，label=0表示B不是A的下一句

with open(data_path, "r", encoding="utf-8") as f:
    lines = f.readlines()
    data = [i.strip().split("\t") for i in lines[0:]]  # 不跳过表头

print(f"数据长度: {len(data)}")
print(f"第一条数据: {data[0]}")
print(f"是否有可用的GPU: {torch.cuda.is_available()}")

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

model_path = "/data1/amos_test/local_mode/bert-chinese-wwm/"

config = BertConfig.from_json_file(f"{model_path}/bert_config.json")
tokenizer = BertTokenizer(vocab_file=f"{model_path}/vocab.txt")
model = BertForNextSentencePrediction.from_pretrained(model_path, config=config).to(device)

print("数据加载")
train_dataset = NSPDataset(data, tokenizer)
train_dataloader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)

print("训练配置")
optimizer = torch.optim.AdamW(model.parameters(), lr=learning_rate)

best_val_loss = float("inf")  # 记录最优验证损失
best_model_path = "best_model.pth"

model.train()
global_step = 0  # 定义全局 step 变量

for epoch in range(epochs):
    total_loss = 0
    total_val_loss = 0

    # 训练阶段
    for batch in train_dataloader:
        global_step += 1  # 更新全局 step 变量
        optimizer.zero_grad()
        input_ids = batch['input_ids'].to(device)
        attention_mask = batch['attention_mask'].to(device)
        token_type_ids = batch['token_type_ids'].to(device)
        labels = batch['labels'].to(device)

        outputs = model(input_ids, attention_mask=attention_mask, token_type_ids=token_type_ids, labels=labels)
        loss = outputs.loss
        loss.backward()
        optimizer.step()
        total_loss += loss.item()

        # 记录每个 batch 的训练损失
        wandb.log({"train_loss": loss.item(), "epoch": epoch + 1, "global_step": global_step})

        # 打印训练日志
        print(f"Epoch {epoch + 1}, Step {global_step}, Train Loss: {loss.item():.4f}")

    # 计算验证损失
    model.eval()
    with torch.no_grad():
        for eval_step, batch in enumerate(train_dataloader):
            input_ids = batch['input_ids'].to(device)
            attention_mask = batch['attention_mask'].to(device)
            token_type_ids = batch['token_type_ids'].to(device)
            labels = batch['labels'].to(device)

            outputs = model(input_ids, attention_mask=attention_mask, token_type_ids=token_type_ids, labels=labels)
            val_loss = outputs.loss.item()
            total_val_loss += val_loss

            # 记录每个 batch 的验证损失
            wandb.log(
                {"val_loss": val_loss, "epoch": epoch + 1, "eval_step": eval_step + 1, "global_step": global_step})

            # 打印验证日志
            print(f"Epoch {epoch + 1}, Step {global_step}, Validation Loss: {val_loss:.4f}")

    model.train()

    avg_train_loss = total_loss / len(train_dataloader)
    avg_val_loss = total_val_loss / len(train_dataloader)

    # 记录 epoch 级别的损失
    wandb.log({"avg_train_loss": avg_train_loss, "avg_val_loss": avg_val_loss, "epoch": epoch + 1})

    print(
        f"Epoch {epoch + 1} Completed - Avg Train Loss: {avg_train_loss:.4f}, Avg Validation Loss: {avg_val_loss:.4f}")

    # 保存最佳模型
    if avg_val_loss < best_val_loss:
        best_val_loss = avg_val_loss
        torch.save(model.state_dict(), best_model_path)
        print(f"Best model saved with validation loss: {best_val_loss:.4f}")

print("Training complete.")
wandb.finish()
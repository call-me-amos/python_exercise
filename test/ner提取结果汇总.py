import json

with open("./data/ner.txt", "r", encoding="utf-8") as file:
    for line in file:
        nerJsonArray = json.loads(line)
        for index, nerJson in enumerate(nerJsonArray):
            if nerJson['tagText'] == '房屋用途':
                print(f"{nerJson['tagValue']}")


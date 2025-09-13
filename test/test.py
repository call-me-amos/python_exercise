import json


def main(data1):
    times = 0
    for item in data1:
        if item.get("role") == "user":
            times += 1
    return {"times": times}


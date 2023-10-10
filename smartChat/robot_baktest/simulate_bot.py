# coding=utf-8

import time
import uuid
from main import test_bot, single_test_bot
import json


def load_file(file_id):
    """

    :param file_id:
    :return:
    """
    data = open("./data/corpus2.0/{}.txt".format(file_id), "r", encoding="utf-8")
    data = [line.strip().split("||")[0].strip() for line in data]
    return data


def start_chat_set(question_id):
    """

    :return:
    """
    text = ""
    user_name = str(int(time.time())) + "_" + uuid.uuid4().hex
    single_test_bot(user_name, text, question_id)
    start_flag = True

    return user_name, start_flag


def policy_run():
    """
    :return:
    """
    q_list = ["119", "120", "124", "125", "126", "127", "128", "122"]
    q_ans = json.load(open("./data/q2ans.json", "r", encoding="utf-8"))
    q_ids = json.load(open("./data/q2id.json", "r", encoding="utf-8"))
    temp_test_id = q_list[0]
    start_flag = False
    user_name = ""
    for index, question_id in enumerate(q_list):
        if index in [0, 1, 2, 3, 4, 5, 6]:
            continue
        # print(load_file(question_id))
        print(question_id)
        user_name, start_flag = start_chat_set()

        data = load_file(question_id)
        for q in data:
            if not start_flag:
                user_name, start_flag = start_chat_set()
            if index == 0:
                resp = test_bot(user_name, q)
                print(q)
                print(resp)
                data_post_process(question_id, resp, q)
                start_flag = False
            else:
                wait_q_list = q_list[:index]
                for q_id in wait_q_list:
                    print(q_ans[q_id][0])
                    test_bot(user_name, q_ans[q_id][0])
                resp = test_bot(user_name, q)
                print(q)
                print(resp)
                data_post_process(question_id, resp, q, q_ids[question_id])
                start_flag = False


def data_post_process(question_id, resp, text, question):
    """

    :param question_id:
    :param resp:
    :return:
    """
    if resp.get("status", "") != 0:
        return ""
    fp = open("./data/res/6.0/{}.txt".format(question_id), "a+", encoding="utf-8")
    temp = resp.get("data", {})
    state = temp.get("state", {}) if temp.get("state", {}) else {}
    # next_policy = str(state.get("执行下一策略", " "))
    # print("state:", state)
    # print("bot: " + str(temp.get("nextRobotAskContent", "")))
    # print("response:", data)

    state = {k: v for k, v in state.items() if v}
    fp.write(state.get("提问槽位", " ") + "&" + question + "&" + text + "&" + str(temp.get("nextRobotAskContent", " "))
             + "&" + str(state.get("当前槽位值", " ")) + "&" + str(state.get("当前意图", " ")) + "&" + str(
        state.get("执行下一策略", " ")) + "&" + str(state.get("执行下一槽位", " ")) + "&" + str(state) + "\n")
    fp.close()
    end_flag = False

    # if next_policy_id == question_id:
    #     end_flag = True
    # return end_flag


def single_test():
    #q_list = ["119", "120", "121", "123", "124", "125", "126", "127", "128"]
    q_list = ["126"]
    q_ids = json.load(open("./data/q2id2.0.json", "r", encoding="utf-8"))
    for index, question_id in enumerate(q_list):
        # if index in [0, 1, 2, 3, 4, 5, 6]:
        #     continue
        user_name, start_flag = start_chat_set(question_id)

        data = load_file(question_id)
        for q in data:

            if not start_flag:
                user_name, start_flag = start_chat_set(question_id)
            resp = single_test_bot(user_name, q, question_id)
            print("user: ", q)
            data = {k: v for k, v in resp.items() if v}
            print("bot: ", data.get("data", {}).get("nextRobotAskContent", " "))
            print(resp)

            print("---------------------------------------------")
            data_post_process(question_id, resp, q, q_ids[question_id])
            start_flag = False


if __name__ == "__main__":
    # policy_run()
    single_test()

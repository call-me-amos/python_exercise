from http import HTTPStatus
import dashscope

api_key = "sk-a86bb725a3e14d2788315725ecea9845"

def simple_multimodal_conversation_call():
    """Simple single round multimodal conversation call.
    """
    messages = [
        {
            "role": "user",
            "content": [
                {"image": "https://dashscope.oss-cn-beijing.aliyuncs.com/images/dog_and_girl.jpeg"},
                {"text": "这是什么?"}
            ]
        }
    ]
    response = dashscope.MultiModalConversation.call(model='qwen-vl-plus', messages=messages, api_key=api_key)
    # The response status_code is HTTPStatus.OK indicate success,
    # otherwise indicate request is failed, you can get error code
    # and message from code and message.
    if response.status_code == HTTPStatus.OK:
        print(response)
    else:
        print(response.code)  # The error code.
        print(response.message)  # The error message.


if __name__ == '__main__':
    simple_multimodal_conversation_call()

import pandas as pd
import requests
import json
import time
from typing import List, Dict, Any
import logging
from datetime import datetime, timedelta
from zhdate import ZhDate
import re
import copy


# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


#时间戳转日期
def get_date(timestamp):
    try:
        # now = datetime.strptime(time, "%Y-%m-%d %H:%M:%S")
        # 转换为datetime对象
        now = datetime.fromtimestamp(timestamp)
        naive_now = now.replace(tzinfo=None)  # Make 'now' naive for ZhDate compatibility
        gregorian_date = now.strftime('%Y-%m-%d')
        # lunar_date = ZhDate.from_datetime(naive_now).chinese()
        lunar_date = ZhDate.from_datetime(naive_now).chinese().split(" ")[0].split("年")[1].split(" ")[0]
        weekday = now.strftime('%A').replace('Monday', '周一').replace('Tuesday', '周二').replace('Wednesday', '周三').replace('Thursday', '周四').replace('Friday', '周五').replace('Saturday', '周六').replace('Sunday', '周天')
        period = '上午' if now.hour < 12 else '下午' if now.hour < 18 else '晚上'
        time_ = now.strftime('%H:%M:%S')
        send_time = f"{gregorian_date}(农历:{lunar_date}),{weekday}{period},{time_}"
        return send_time
    except Exception as e:
        print('error-time：',time,e)
    return "2025-01-28(农历:十二月二十九),周二," + str(re.sub("\d+-\d+-\d+ ","",time))

class LLMProcessor:
    def __init__(self, excel_path: str, api_url: str, api_key: str = None):
        """
        初始化处理器

        Args:
            excel_path: Excel文件路径
            api_url: API地址
            api_key: API密钥（可选）
        """
        self.excel_path = excel_path
        self.api_url = api_url
        self.api_key = api_key
        self.df = None
        self.results = []
    def get_prompt(self):
        return """\
## 角色定义
你是一位专业的家装顾问，主要工作是在微信上和用户确认用户的装修信息，包括用户的基本信息、房屋的基本信息、用户的装修诉求等。

## 任务要求
给你一段顾问和用户的微信聊天记录，
1、请识别顾问最后一次说话内容，按照下面的**顾问的话术分类**进行分类；
2、请对用户在顾问最后一次说话之后回复的内容，按照下面的**用户回复意图分类**进行分类，如果用户回复多次，将用户回复内容合并之后再进行分类；如果存在多个分类，请使用中文顿号（、）隔开。


## 顾问的话术分类
- 开场白
    - 分类说明：顾问的话术包含：您好/你好/哈喽 等表达打招呼的词汇。
    - 示例：
        1、哈喽，看下咱们这边是重庆市75m²旧房翻新了解下【报价清单】和方案是嘛？我给您算算
        2、您好，我是土巴兔平台-xx ~ 土巴兔是一站式家装平台[愉快]✓成立17年 ✓入驻超14万装修公司 ✓ 服务家庭****万+ 【解决3大核心装修痛点】★ 不知道如何选装修公司? 土巴兔 app 上装企口碑真实可查，已收录18万+真实业主评价★ 担心合同陷阱? 平台推出合同报价审核、装修流程监控★ 担心给了钱，态度就变了? 平台作为第三方监管，验收合格再给钱（质检工地1次验收通过率92.5%）
- 询问装修时间
    - 示例：
        1、是现在对比，找到满意的报价方案， 考虑近两三月就装修了是吗？
- 询问是否交房
    - 示例：
        1、对了，咱房子目前已经交付拿钥匙了对吧？
        2、好呢，目前房子已经收回来了对吧
- 询问交房时间
    - 示例：
        1、咱大概什么时候能交房拿钥匙呢亲~
        2、明白，那房子大概什么时候交房呢？
        3、咱是大概什么时候建好呀亲~[玫瑰]
- 询问量房时间
    - 示例：
        1、这周四可以的对嘛？我们设计师早上9-晚上8点都可以的
        2、帮您安排到9.1号档期的设计师去看看房屋情况，给您出设计方案和报价明细可以吗？【全程不收费】
        3、咱明天方便设计师过去看下房屋具体情况吗？出报价清单/设计图免费的哦
- 询问姓氏
    - 示例：
        1、怎么称呼您？
- 询问房屋面积
    - 示例：
        1、嗯嗯，您房子的小区名和面积也发我一下哦，我给您优先匹配有同楼盘经验的设计师[抱拳]
        2、好的~那房子面积有多大呢？
- 询问房屋类型
    - 示例：
        1、咱们是毛坯房还是旧房整改呀？
        2、大概了解下您的需求哦，咱房子目前是没装修过的毛坯的嘛？
        3、好的，您家是毛坯房还是老房需要改造呀?
- 询问装修工程量
    - 分类说明：区分用户的工程量是整体改造还是局部改造
    - 示例：
        1、好的，局改跟整改的报价不一样哈，您是考虑全屋拆成毛坯包含水电一起整体翻新不？
- 询问装修工程量详情
    - 分类说明：
        1、单独询问用户是否需要改水电，或者询问用户某某空间的水电是否要动；
        2、单独询问用户需要改造的空间；
        3、顾问最后一句话是连续发送两句，其中倒数第二句表达了回复数字即可的意图，倒数第一句是一个url链接；
    - 示例：
        1、好的，局改跟整改的报价不一样哈，您是考虑全屋拆成毛坯包含水电一起整体翻新不？
        2、
        3、
            倒数第二句：您选择一下您的装修要求，图片【回复数据即可】
            倒数第一句：{"uri":"hz-t8t-pic-test.oss-cn-hangzhou.aliyuncs.com/to8toim/image/20250904/304bd10c-a456-469f-b5c7-94364d3ce655.png","url":"http://hz-t8t-pic-test.oss-cn-hangzhou.aliyuncs.com/to8toim/image/20250904/304bd10c-a456-469f-b5c7-94364d3ce655.png"}
- 询问房屋装修用途
    - 示例：
        - 1、你这次装修是打算自己住还是出租呀？(设计和价格不同的哦)
- 询问房屋所在城市
    - 示例：
        1、咱是在哪个城市的房子呀？给您看下这块有没有做过的案例和行情报价先发您参考下呀~[玫瑰]
- 询问房屋地址
    - 示例：
        1、嗯嗯好的，您是准备买哪里的房子呀，我给您发一些当地的一些房屋案例和行情报价
- 询问小区名称
    - 示例：
        1、您房子的小区名也发我一下哦，我给您优先匹配有同楼盘经验的设计师[抱拳]
- 索要户型图
    - 示例：
        1、户型图可以发我看看，这边给您生成效果图参考下
- 向用户确认是不是要案例
    - 示例：
        1、这两天刚好整理了一些同面积/性价比较高的装修案例，也许能给您一些灵感方向，需要给您分享吗 ？
- 向用户确认是不是在外地
    - 示例：
        1、没关系呀只是先让您了解下的不是定下来哦，咱不方便量房是目前在外地不方便 还是 近期没时间呀？    有户型图也可以先发下
- 向用户确认从外地归回时间
    - 示例：
        1、您这边什么时候会回当地呀？我提前对接好
- 向用户发送价值话术
    - 示例：
        1、好的，装修一般都会对比一下。这边是免费安排设计师出1-4套的设计方案和报价明细。可以先让设计师帮咱们把设计和报价做出来参考看看 合适您就做 不合适就当参考
        2、好的，每个人需求选材不同，报价也不同的。我们是可以免费上门量房出装修方案，报价对比，觉得合适可以进一步沟通了解，不合适就当做市场行情的参考，不收费哦
        3、量尺完之后两三天会出来设计 报价方案，里面有包含详细的布局，尺寸，家具摆放等，半小时就可以测量好。全程免费的

## 用户回复意图分类
- 回复顾问的基本信息
- 肯定
- 否定
- 迟疑
- 提问
- 没空/表达此刻不方便

## 聊天记录
{history_conversation}

## 输出json格式示例（请严格按照json格式输出）
{
    "顾问的话术分类":"",
    "用户回复意图分类":"",
}
"""

    def read_excel(self):
        """读取Excel文件"""
        try:
            self.df = pd.read_excel(self.excel_path)
            logging.info(f"成功读取Excel文件，共{len(self.df)}行数据")
            return True
        except Exception as e:
            logging.error(f"读取Excel文件失败: {e}")
            return False

    def call_llm_api(self, messages) -> Dict[str, Any]:
        """
        调用 API

        Args:
            messages: 聊天记录

        Returns:
             API返回结果
        """
        history = ""
        for msg in messages:
            history = history +  ("客服" if msg["direction"] == 2 else "用户") + "[" + str(get_date(msg["sendtime"])) + "]:" + str(msg["content"]) + "\n"

        prompt = self.get_prompt()
        prompt = prompt.replace("{history_conversation}", history)

        # 根据实际的 API格式调整请求体
        payload = {
            "model": "ep-20250609161051-cf6sl",
            "messages": [
              {"role": "system","content": ""},
              {"role": "user","content": prompt}
            ]
        }

        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_key}"
        }

        try:
            response = requests.post(
                self.api_url,
                headers=headers,
                json=payload,
                timeout=30
            )

            if response.status_code == 200:
                return response.json()
            else:
                logging.error(f"API调用失败: {response.status_code} - {response.text}")
                return None

        except requests.exceptions.RequestException as e:
            logging.error(f"API请求异常: {e}")
            return None
        except json.JSONDecodeError as e:
            logging.error(f"JSON解析失败: {e}")
            return None

    def extract_results(self, api_response: Dict[str, Any]) -> Dict[str, Any]:
        """
        从FastGPT API响应中提取所需信息

        Args:
            api_response: API响应数据

        Returns:
            提取的QA分类和承接话术
        """
        if not api_response:
            return {
                "顾问的话术分类": "解析失败",
                "用户回复意图分类": "解析失败"
            }

        # 根据实际的FastGPT API响应结构进行调整
        content_str = api_response.get("choices", [{}])[0].get("message", {}).get("content", "")
        try:

            content = json.loads(content_str, strict=False)

            # 示例响应结构，需要根据实际API响应调整
            assistant_category = content.get("顾问的话术分类", "")
            user_intention = content.get("用户回复意图分类", "")
            return {
                "顾问的话术分类": assistant_category,
                "用户回复意图分类": user_intention
            }

        except Exception as e:
            # 手动移除末尾逗号
            if content_str.endswith(',\n}'):
                fixed_content = content_str[:-3] + '\n}'
                try:
                    content_json = json.loads(fixed_content)
                    assistant_category = content_json.get("顾问的话术分类", "")
                    user_intention = content_json.get("用户回复意图分类", "")
                    return {
                        "顾问的话术分类": assistant_category,
                        "用户回复意图分类": user_intention
                    }
                except json.JSONDecodeError as e2:
                    print(f"修复后仍然错误: {e2}")

            logging.error(f"解析API响应失败: {e}")
            return {
                "顾问的话术分类": "解析失败",
                "用户回复意图分类": "解析失败",
                "模型返回": api_response

            }

    def process_all_rows(self, batch_size: int = 10, start_row=0, end_row=0):
        """
        处理所有行数据

        Args:
            batch_size: 批量处理大小
            start_row: 如果start_row=0，表示从excel第二行开始读取（去除了表头）
            end_row: end_row = 0，读取全量数据
        """
        if self.df is None:
            logging.error("请先读取Excel文件")
            return False

        total_rows = len(self.df)
        self.results = []

        logging.info(f"开始处理{total_rows}行数据...")
        first_sid = ''
        # 根据同一个sid
        messages = []
        for index, row in self.df.iterrows():
            # end_row = 0，读取全量数据
            if end_row != 0:
                if index < start_row or index > end_row:
                    continue

            try:
                message = {
                    "direction": row.get("direction"),
                    "sendtime": row.get("sendtime"),
                    "content": row.get("content"),
                }
                if first_sid == '':
                    first_sid = row.get("sid")
                else:
                    if row.get("sid") != first_sid:
                        messages = []
                        first_sid = row.get("sid")
                # 追加新的消息
                messages.append(message)
                result = {}
                if row.get("direction") == 1 and '开始聊天' not in str(row.get("content", '')):
                    # 调用 API
                    api_response = self.call_llm_api(messages)
                    result = self.extract_results(api_response)

                new_message = message.copy()
                new_message['sid'] = row.get("sid")

                new_message['顾问的话术分类'] = result.get('顾问的话术分类', '')
                new_message['用户回复意图分类'] = result.get('用户回复意图分类', '')
                new_message['模型返回'] = result.get('模型返回', '')
                # 保存结果
                self.results.append(new_message)

                if (index + 1) % batch_size == 0:
                    logging.info(f"已处理{index + 1}/{total_rows}行")

            except Exception as e:
                logging.error(f"处理第{index + 1}行时发生错误: {e}")
                self.results.append({
                    "顾问的话术分类": "处理错误",
                    "用户回复意图分类": f"错误: {str(e)}"
                })

        logging.info("所有行处理完成")
        return True

    def create_output_dataframe(self):
        """创建输出DataFrame"""
        # if not self.results or len(self.results) != len(self.df):
        #     logging.error("结果数据不匹配")
        #     return None

        # 创建新的DataFrame
        output_data = []

        for result in self.results:
            output_row = {
                "sid": result.get("sid", ""),
                "direction": result.get("direction", ""),
                "sendtime": result.get("sendtime", ""),
                "content": result.get("content", ""),
                "顾问的话术分类": result.get("顾问的话术分类", ""),
                "用户回复意图分类": result.get("用户回复意图分类", ""),
                "模型返回": result.get("模型返回", ""),
            }
            output_data.append(output_row)

        return pd.DataFrame(output_data)

    def save_output_excel(self, output_path: str):
        """保存输出Excel文件"""
        output_df = self.create_output_dataframe()
        if output_df is None:
            return False

        try:
            output_df.to_excel(output_path, index=False, engine='openpyxl')
            logging.info(f"成功保存输出文件: {output_path}")
            return True
        except Exception as e:
            logging.error(f"保存输出文件失败: {e}")
            return False

    def process(self, output_path: str, batch_size: int = 10, start_row=0, end_row=1):
        """
        完整的处理流程
        row_size 读取excel行数，如果=0，默认全量
        """
        # 1. 读取Excel
        if not self.read_excel():
            return False

        # 2. 处理所有行
        if not self.process_all_rows(batch_size, start_row, end_row):
            return False

        # 3. 保存输出
        if not self.save_output_excel(output_path):
            return False

        return True


# 使用示例
def main():
    # 配置参数
    EXCEL_PATH = "C:/Users/amos.tong/Desktop/待分析聊天记录.xlsx"  # 替换为你的Excel文件路径
    # EXCEL_PATH = "C:/Users/amos.tong/Desktop/1000聊天记录.xlsx"  # 替换为你的Excel文件路径
    OUTPUT_PATH = f"C:/Users/amos.tong/Desktop/待分析聊天记录-追加顾问提问槽位和用户意图-{time.time()}.xlsx"  # 输出文件路径
    API_URL = "https://ark.cn-beijing.volces.com/api/v3/chat/completions"  # 替换为你的API地址
    # API_KEY = "xx"  # 如果有API密钥的话  火山引擎
    API_KEY = "xx"  # 如果有API密钥的话  火山引擎

    # 创建处理器实例
    processor = LLMProcessor(EXCEL_PATH, API_URL, API_KEY)

    # 执行处理
    success = processor.process(
        output_path=OUTPUT_PATH,
        batch_size=5,  # 每处理5行输出一次日志
        start_row=2073,  # 读取excel行数，如果start_row=0，表示从excel第二行开始读取（去除了表头）
        end_row = 5073
    )

    if success:
        print("处理完成！")
    else:
        print("处理失败！")


if __name__ == "__main__":
    main()
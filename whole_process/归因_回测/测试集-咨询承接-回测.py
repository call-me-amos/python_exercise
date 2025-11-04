import pandas as pd
import requests
import json
import time
from typing import List, Dict, Any
import logging

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


class FastGPTProcessor:
    def __init__(self, excel_path: str, fastgpt_api_url: str, api_key: str = None):
        """
        初始化FastGPT处理器

        Args:
            excel_path: Excel文件路径
            fastgpt_api_url: FastGPT API地址
            api_key: API密钥（可选）
        """
        self.excel_path = excel_path
        self.fastgpt_api_url = fastgpt_api_url
        self.api_key = api_key
        self.df = None
        self.results = []

    def read_excel(self):
        """读取Excel文件"""
        try:
            self.df = pd.read_excel(self.excel_path)
            logging.info(f"成功读取Excel文件，共{len(self.df)}行数据")
            return True
        except Exception as e:
            logging.error(f"读取Excel文件失败: {e}")
            return False

    def call_fastgpt_api(self, user_reply: str, id: int) -> Dict[str, Any]:
        """
        调用FastGPT API

        Args:
            user_reply: 用户回复内容

        Returns:
            FastGPT API返回结果
        """
        # 根据实际的FastGPT API格式调整请求体
        payload = {
            "variables": {
                "用户问题": user_reply
            },
            "messages": [
                {
                    "role": "assistant",
                    "content": f"{id}"
                }
            ]
        }

        headers = {
            "Content-Type": "application/json"
        }

        if self.api_key:
            headers["Authorization"] = f"Bearer {self.api_key}"

        try:
            response = requests.post(
                self.fastgpt_api_url,
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

    def extract_fastgpt_results(self, api_response: Dict[str, Any]) -> Dict[str, Any]:
        """
        从FastGPT API响应中提取所需信息

        Args:
            api_response: API响应数据

        Returns:
            提取的QA分类和承接话术
        """
        if not api_response:
            return {
                "fastgpt预测QA分类": "API调用失败",
                "fastgpt推荐承接话术": "API调用失败"
            }

        # 根据实际的FastGPT API响应结构进行调整
        try:
            content_str = api_response.get("choices", [{}])[0].get("message", {}).get("content", "")
            content = json.loads(content_str, strict=False)

            # 示例响应结构，需要根据实际API响应调整
            qa_category = content.get("qa分类", "")
            recommend = content.get("咨询承接话术", "")
            return {
                "fastgpt预测QA分类": qa_category,
                "fastgpt推荐承接话术": recommend
            }

        except Exception as e:
            logging.error(f"解析API响应失败: {e}")
            return {
                "fastgpt预测QA分类": "解析失败",
                "fastgpt推荐承接话术": "解析失败"
            }

    def process_all_rows(self, batch_size: int = 10, delay: float = 1.0):
        """
        处理所有行数据

        Args:
            batch_size: 批量处理大小
            delay: 每次API调用后的延迟（秒）
        """
        if self.df is None:
            logging.error("请先读取Excel文件")
            return False

        total_rows = len(self.df)
        self.results = []

        logging.info(f"开始处理{total_rows}行数据...")

        for index, row in self.df.iterrows():
            try:
                user_reply = row.get("用户回复", "")
                id = row.get("id", "0")

                if not user_reply or pd.isna(user_reply):
                    logging.warning(f"第{index + 1}行用户回复为空，跳过")
                    result = {
                        "fastgpt预测QA分类": "空输入",
                        "fastgpt推荐承接话术": "空输入"
                    }
                else:
                    # 调用FastGPT API
                    api_response = self.call_fastgpt_api(str(user_reply), int(id))
                    result = self.extract_fastgpt_results(api_response)

                    # 添加延迟以避免API限制
                    # time.sleep(delay)

                # 保存结果
                self.results.append(result)

                if (index + 1) % batch_size == 0:
                    logging.info(f"已处理{index + 1}/{total_rows}行")

            except Exception as e:
                logging.error(f"处理第{index + 1}行时发生错误: {e}")
                self.results.append({
                    "fastgpt预测QA分类": "处理错误",
                    "fastgpt推荐承接话术": f"错误: {str(e)}"
                })

        logging.info("所有行处理完成")
        return True

    def create_output_dataframe(self):
        """创建输出DataFrame"""
        if not self.results or len(self.results) != len(self.df):
            logging.error("结果数据不匹配")
            return None

        # 创建新的DataFrame
        output_data = []

        for index, (_, original_row) in enumerate(self.df.iterrows()):
            fastgpt_result = self.results[index]

            output_row = {
                "id": original_row.get("id", ""),
                "用户回复": original_row.get("用户回复", ""),
                "小模型预测是否QA": original_row.get("小模型预测是否QA", ""),
                "小模型预测置QA类型": original_row.get("小模型预测置QA类型", ""),
                "小模型预测置信度": original_row.get("小模型预测置信度", ""),
                "小模型推荐承接话术": original_row.get("小模型推荐承接话术", ""),
                "fastgpt预测QA分类": fastgpt_result.get("fastgpt预测QA分类", ""),
                "fastgpt推荐承接话术": fastgpt_result.get("fastgpt推荐承接话术", "")
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

    def process(self, output_path: str, batch_size: int = 10, delay: float = 1.0):
        """完整的处理流程"""
        # 1. 读取Excel
        if not self.read_excel():
            return False

        # 2. 处理所有行
        if not self.process_all_rows(batch_size, delay):
            return False

        # 3. 保存输出
        if not self.save_output_excel(output_path):
            return False

        return True


# 使用示例
def main():
    # 配置参数
    EXCEL_PATH = "C:/Users/amos.tong/Desktop/土巴兔QA内容记录-用户咨询小模型回复.xlsx"  # 替换为你的Excel文件路径
    OUTPUT_PATH = "C:/Users/amos.tong/Desktop/土巴兔QA内容记录-用户咨询小模型回复(fastgpt预测).xlsx"  # 输出文件路径
    FASTGPT_API_URL = "https://gpts.to8to.com/api/v1/chat/completions"  # 替换为你的FastGPT API地址
    API_KEY = "xx"  # 如果有API密钥的话  工作流：咨询测试

    # 创建处理器实例
    processor = FastGPTProcessor(EXCEL_PATH, FASTGPT_API_URL, API_KEY)

    # 执行处理
    success = processor.process(
        output_path=OUTPUT_PATH,
        batch_size=5,  # 每处理5行输出一次日志
        delay=0.5  # 每次API调用后延迟0.5秒
    )

    if success:
        print("处理完成！")
    else:
        print("处理失败！")


if __name__ == "__main__":
    main()
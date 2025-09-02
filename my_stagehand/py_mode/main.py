import asyncio
import os
from stagehand import Stagehand, StagehandConfig
from dotenv import load_dotenv

load_dotenv()

async def main():
    config = StagehandConfig(
        env="LOCAL",
        # 替换为 DeepSeek 模型名称（根据 API 文档）
        model_name="deepseek-r1",  # 或其他 DeepSeek 模型如 "deepseek-coder"
        # DeepSeek API 的 Base URL（如果是第三方平台需修改）
        model_api_base="https://api.deepseek.com/v1",  # 替换为实际 API 地址
        model_api_key=os.getenv("DEEP_SEEK_MODEL_API_KEY")   # 环境变量中存储的 API Key
    )

    stagehand = Stagehand(config)

    try:
        await stagehand.init()
        page = stagehand.page

        await page.goto("https://docs.stagehand.dev/")
        await page.act("click the quickstart link")

        result = await page.extract("extract the main heading of the page")
        print(f"Extracted: {result.extraction}")

    finally:
        await stagehand.close()

if __name__ == "__main__":
    asyncio.run(main())
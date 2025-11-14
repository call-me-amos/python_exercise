# -*- coding: utf-8 -*-
"""
根据关键字从Kibana获取信息

代码逻辑描述：
1、调用url，请求参数为 query1，从返回的日志内容中获取每一行的 bsid 字段。
2、调用url，请求参数为 query2，其中 bsid参数为上一步中返回的bsid，从返回内容中获取每一行的 phoneId，输出
{
    "phoneId": xxx,
    "ts": "2025-11-13 16:28:11.547"
}
3、将输出保存到excel中。文件地址：C:/Users/amos.tong/Desktop/test.xlsx
"""

import json
import time
from datetime import datetime, timedelta

import pandas as pd
import requests


class KibanaLogParser:
    def __init__(self):
        self.base_url = "https://kibana.to8to.com/logs/kafka_new/elasticsearch/_msearch"
        self.params = {
            'rest_total_hits_as_int': 'true',
            'ignore_throttled': 'true'
        }

        self.session = requests.Session()
        # 根据fetch请求示例设置完整的请求头
        self.session.headers.update({
            'accept': 'application/json, text/plain, */*',
            'accept-language': 'zh-CN,zh;q=0.9',
            'content-type': 'application/x-ndjson',
            'kbn-version': '6.8.6',
            'priority': 'u=1, i',
            'sec-ch-ua': '"Google Chrome";v="141", "Not?A_Brand";v="8", "Chromium";v="141"',
            'sec-ch-ua-mobile': '?0',
            'sec-ch-ua-platform': '"Windows"',
            'sec-fetch-dest': 'empty',
            'sec-fetch-mode': 'cors',
            'sec-fetch-site': 'same-origin',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36'
        })

        # 查询变量
        self.query1 = 'proj:"t8t-tbt-tls" AND txt:"reActivate 处理完成"'

        print("KibanaLogParser初始化完成")

    def get_timestamp_range(self, hours_ago=12):
        """获取时间戳范围（毫秒）"""
        now = datetime.now()
        start_time = now - timedelta(hours=hours_ago)

        start_timestamp = int(start_time.timestamp() * 1000)
        end_timestamp = int(now.timestamp() * 1000)

        return start_timestamp, end_timestamp

    def build_ndjson_payload(self, query, index="log-java-idc-latest-*", size=500, hours_ago=12):
        """构建NDJSON格式的请求负载"""
        start_ts, end_ts = self.get_timestamp_range(hours_ago)

        # 第一行：索引信息
        index_line = {
            "index": index,
            "ignore_unavailable": True,
            "preference": int(time.time() * 1000)
        }

        # 第二行：查询信息（根据fetch示例调整）
        query_body = {
            "version": True,
            "size": size,
            "sort": [{"@timestamp": {"order": "desc", "unmapped_type": "boolean"}}],
            "_source": {"excludes": []},
            "aggs": {
                "2": {
                    "date_histogram": {
                        "field": "@timestamp",
                        "interval": "10m",  # 改为10m匹配示例
                        "time_zone": "Asia/Shanghai",
                        "min_doc_count": 1
                    }
                }
            },
            "stored_fields": ["*"],
            "script_fields": {},
            "docvalue_fields": [{"field": "@timestamp", "format": "date_time"}],
            "query": {
                "bool": {
                    "must": [
                        {
                            "query_string": {
                                "query": query,
                                "analyze_wildcard": True,
                                "default_field": "*"
                            }
                        },
                        {
                            "range": {
                                "@timestamp": {
                                    "gte": start_ts,
                                    "lte": end_ts,
                                    "format": "epoch_millis"
                                }
                            }
                        }
                    ],
                    "filter": [],
                    "should": [],
                    "must_not": []
                }
            },
            "highlight": {
                "pre_tags": ["@kibana-highlighted-field@"],
                "post_tags": ["@/kibana-highlighted-field@"],
                "fields": {"*": {}},
                "fragment_size": 2147483647
            },
            "timeout": "40000ms"
        }

        # 组合成NDJSON格式
        ndjson_payload = json.dumps(index_line) + '\n' + json.dumps(query_body) + '\n'
        return ndjson_payload

    def send_request(self, ndjson_payload):
        """发送请求到Kibana"""
        try:
            print(f"发送请求到: {self.base_url}")
            print(f"请求体大小: {len(ndjson_payload)} 字符")

            response = self.session.post(
                self.base_url,
                params=self.params,
                data=ndjson_payload.encode('utf-8'),
                timeout=45
            )

            print(f"响应状态码: {response.status_code}")

            if response.status_code == 200:
                print("请求成功")
                return response.json()
            else:
                print(f"请求失败，状态码: {response.status_code}")
                print(f"响应内容: {response.text[:500]}...")
                return None

        except requests.exceptions.RequestException as e:
            print(f"网络请求异常: {e}")
            return None
        except Exception as e:
            print(f"处理响应失败: {e}")
            return None

    def extract_bsids(self, response_data):
        """从响应中提取bsid列表"""
        bsids = []

        if not response_data or 'responses' not in response_data:
            print("响应数据格式错误")
            return bsids

        for response in response_data['responses']:
            if 'error' in response:
                print(f"查询错误: {response['error']}")
                continue

            if 'hits' in response and 'hits' in response['hits']:
                for hit in response['hits']['hits']:
                    source = hit.get('_source', {})
                    bsid = source.get('bsid', '').strip()
                    if bsid:
                        bsids.append(bsid)

        return list(set(bsids))  # 去重

    def extract_phone_info(self, response_data):
        """从响应中提取phoneId和时间戳信息"""
        phone_info = {}

        if not response_data or 'responses' not in response_data:
            return phone_info

        for response in response_data['responses']:
            if 'error' in response:
                print(f"查询错误: {response['error']}")
                continue

            if 'hits' in response and 'hits' in response['hits']:
                for hit in response['hits']['hits']:
                    source = hit.get('_source', {})
                    txt = source.get('txt', '')
                    ts_field = source.get('ts', '')

                    # 从txt字段中提取phoneId。txt='reActivate req={"phoneId":463145089}'
                    phone_id = txt.split('"phoneId":')[-1].split('}')[0]

                    phone_info = {
                        "phoneId": phone_id,
                        "ts": ts_field
                    }

        return phone_info

    def format_timestamp(self, timestamp):
        """格式化时间戳"""
        try:
            if timestamp:
                # 如果是ISO格式时间字符串
                if isinstance(timestamp, str):
                    # 尝试解析不同格式的时间戳
                    if 'T' in timestamp:
                        dt = datetime.fromisoformat(timestamp.replace('Z', '+00:00'))
                    else:
                        # 如果是简单格式，尝试解析
                        dt = datetime.strptime(timestamp, '%Y-%m-%d %H:%M:%S')
                    return dt.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
                # 如果是毫秒时间戳
                elif isinstance(timestamp, (int, float)):
                    dt = datetime.fromtimestamp(timestamp / 1000)
                    return dt.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        except Exception as e:
            print(f"时间戳格式化失败: {e}")

        # 如果解析失败，返回当前时间
        return datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]

    def get_bsids_from_query1(self, limit=100):
        """步骤1：使用query1获取bsid列表"""
        print("\n=== 步骤1：获取bsid列表 ===")

        ndjson_payload = self.build_ndjson_payload(
            query=self.query1,
            size=limit,
            hours_ago=12
        )

        response_data = self.send_request(ndjson_payload)
        if not response_data:
            print("获取bsid失败")
            return []

        bsids = self.extract_bsids(response_data)
        print(f"成功获取到 {len(bsids)} 个bsid")

        if bsids:
            print("前3个bsid示例:")
            for i, bsid in enumerate(bsids[:3], 1):
                print(f"  {i}. {bsid}")

        return bsids

    def get_phone_info_from_query2(self, bsid):
        """步骤2：使用query2和bsid获取phoneId信息"""
        query2 = f'bsid:"{bsid}" AND txt:"reActivate req"'

        ndjson_payload = self.build_ndjson_payload(
            query=query2,
            size=100,
            hours_ago=24 * 7  # 7天范围
        )

        response_data = self.send_request(ndjson_payload)
        if not response_data:
            return []

        phone_info = self.extract_phone_info(response_data)
        return phone_info

    def process_kibana_logs(self):
        """主处理函数"""
        print("开始处理Kibana日志...")

        # 步骤1：获取bsid列表
        bsids = self.get_bsids_from_query1()
        if not bsids:
            print("未获取到任何bsid，程序结束")
            return []

        print(f"\n=== 步骤2：处理 {len(bsids)} 个bsid ===")
        all_phone_infos = []

        # 步骤2：为每个bsid获取phoneId信息
        for i, bsid in enumerate(bsids, 1):
            print(f"\n处理第 {i}/{len(bsids)} 个bsid: {bsid[:50]}...")
            phone_info = self.get_phone_info_from_query2(bsid)
            all_phone_infos.append(phone_info)

            # 避免请求过于频繁
            time.sleep(0.2)

        print(f"\n=== 处理完成 ===")
        print(f"共获取到 {len(all_phone_infos)} 条phoneId信息")
        return all_phone_infos

    def save_to_excel(self, results, filename="test.xlsx"):
        """保存结果到Excel文件"""
        if not results:
            print("没有数据需要保存")
            return

        try:
            df = pd.DataFrame(results)

            # 保存到指定路径
            excel_path = "C:/Users/amos.tong/Desktop/test.xlsx"
            df.to_excel(excel_path, index=False, engine='openpyxl')

            print(f"\n=== 保存结果 ===")
            print(f"✓ 已保存到: {excel_path}")
            print(f"✓ 共保存 {len(results)} 条记录")

            # 输出结果预览
            print(f"\n=== 数据预览 ===")
            print(f"列名: {list(df.columns)}")

            for i, result in enumerate(results[:3]):  # 显示前3条
                output = {
                    "phoneId": result["phoneId"],
                    "ts": result["ts"]
                }
                print(f"{i + 1}. {json.dumps(output, ensure_ascii=False)}")

            if len(results) > 3:
                print(f"... 还有 {len(results) - 3} 条记录")

        except Exception as e:
            print(f"保存Excel文件失败: {e}")


def main():
    """主函数"""
    print("=== Kibana日志解析器 ===")
    print("功能: 从Kibana日志中提取bsid和phoneId信息")

    try:
        parser = KibanaLogParser()

        # 处理日志并获取结果
        results = parser.process_kibana_logs()

        # 保存results到Excel文件
        parser.save_to_excel(results)

        print("\n=== 程序执行完成 ===")

    except Exception as e:
        print(f"程序执行出错: {e}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    main()

import time
import jionlp as jio
import cpca
from Pinyin2Hanzi import DefaultHmmParams
from Pinyin2Hanzi import viterbi
import addressparser

if __name__ == '__main__':
    # hmmparams = DefaultHmmParams()
    #
    # ## 2个候选
    # result = viterbi(hmm_params=hmmparams, observations=('qi'), path_num=1)
    # for item in result:
    #     print(item.score, item.path)

    # location_str = ['安+鹤岗+中海城+112+毛坯']
    # df = cpca.transform(location_str)
    # print(df)
    # res = jio.parse_time('下个月', time_base=time.time())
    # print(res)
    # res = jio.parse_time('这周末', time_base=time.time())
    # print(res)
    # res = jio.parse_time('4-6月份', time_base=time.time())
    # print(res)
    # res = jio.parse_time('下个月中', time_base=time.time())
    # print(res)
    # res = jio.parse_time('后天', time_base=time.time())
    # print(res)
    # res = jio.parse_time('这个月', time_base=time.time())
    # print(res)
    # res = jio.parse_time('2023-06-04 00:00:00', time_base=time.time())
    # print(res)

    res = jio.parse_time('马上装', time_base=time.time())
    print(res)



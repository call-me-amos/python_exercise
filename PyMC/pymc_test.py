
# 案例地址
# https://mp.weixin.qq.com/s?chksm=c1af3538f6d8bc2efa5d5cd20350d87a5b17a4dfb5dafe00002dff7d3ee20284c6dfd635de49&exptype=unsubscribed_card_recommend_article_u2i_mainprocess_coarse_sort_tlfeeds&ranksessionid=1722305575_3&mid=2247487776&sn=bc0739bf34756c081ddba80ebb64d0d9&idx=1&__biz=MzkxODYzMTc5OQ%3D%3D&scene=169&subscene=200&sessionid=1722307084&flutter_pos=26&clicktime=1722307086&enterid=1722307086&finder_biz_enter_id=5&ascene=56&fasttmpl_type=0&fasttmpl_fullversion=7311280-zh_CN-zip&fasttmpl_flag=0&realreporttime=1722307086062&devicetype=android-33&version=4.1.28.6005&nettype=WIFI&abtest_cookie=AAACAA%3D%3D&lang=zh_CN&session_us=gh_bac23b149666&countrycode=CN&exportkey=n_ChQIAhIQbruX9tBqqvAHiIisMXTNTRLxAQIE97dBBAEAAAAAAG9uNJMiu2kAAAAOpnltbLcz9gKNyK89dVj048LIHEmry0raM%2FmZedTwuuXMqKr2pe08rc3WzcQD9o1hPZ4hZOzKE27KFCH%2BK2eZk5u9fuMrQ%2FR0gQzBzwDtfgJX8sgYhrOG5ArkvE%2BO9MudfYBxL9piWphC4vyDdSLuWaiSs04Xyn%2F99wzQcIRt9e5x66b%2Fs4LEjlxjytkRLcAJrbLT3U8TvB7q5EOfY4XxBdntwmogLQ%2BELwBY8X6mue0EU9hgni7WpYoPHaTK1V%2BxSi3SxC89TauMuM0n0QpxHWahLevSaEPbACg%3D&pass_ticket=wufqvuKQvaOqZ4ec1J5jGqq7HjUv2QqkYQvCUgonuslNMQNZx60JnZfC%2BkibW7rd&wx_header=3&platform=win&nwr_flag=1#wechat_redirect

import pymc3 as pm
import numpy as np
import theano.tensor as tt

print(pm.__version__)

# 定义词汇表大小和词汇表
vocab_size = 10000

# 定义词汇表中的单词索引
word_index = np.random.randint(0, vocab_size, size=(100))

# 定义先验分布
a_prior = pm.Dirichlet('a_prior', alpha=np.ones(vocab_size) / vocab_size)
b_prior = pm.Dirichlet('b_prior', alpha=np.ones(vocab_size) / vocab_size)

# 定义模型
with pm.Model() as model:
    # 定义似然函数
    like = pm.Dirichlet('like', a=pm.math.to_ndarray(a_prior) + b_prior[word_index[:-1]], observed=word_index[1:])

    # 进行后验采样
    trace = pm.sample(2000, tune=2000)


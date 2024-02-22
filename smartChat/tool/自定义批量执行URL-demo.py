import json

import requests

'''
    自定义批量执行URL
'''

image_url_list = [
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//68bf2e1d5dc4e7fbd39406e367146803\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//68bf2e1d5dc4e7fbd39406e367146803\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//2c2a0f99100c31108696c617bdb060b2\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//2c2a0f99100c31108696c617bdb060b2\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//dcd087d7520eed224d21a1e0e26fe517\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//dcd087d7520eed224d21a1e0e26fe517\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//c4fcec474a84b87d3840a1aba6d8367a\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//c4fcec474a84b87d3840a1aba6d8367a\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//9f3fd7e3c1ee84dda22466931d07ac74\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//9f3fd7e3c1ee84dda22466931d07ac74\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//b0c60166fdf9443424bcbe15b18d6025\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//b0c60166fdf9443424bcbe15b18d6025\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//61a39b5b3139c76c5ed9ba186ad7ccf7\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//61a39b5b3139c76c5ed9ba186ad7ccf7\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//8f0022771ff832b1afe7d6d627d06ee9\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//8f0022771ff832b1afe7d6d627d06ee9\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//d8934fac6b9da0b2c007586984965dc1\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//d8934fac6b9da0b2c007586984965dc1\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//26c5dbaa66acd240e583b91bc21eaeec\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//26c5dbaa66acd240e583b91bc21eaeec\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//973136834aee3efd8164d896547452f8\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//973136834aee3efd8164d896547452f8\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//ef88c8da61e4a6662f2e3d00db785a07\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//ef88c8da61e4a6662f2e3d00db785a07\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//b0ce30ffebf687e9ac3f0b4b5b71e645\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//b0ce30ffebf687e9ac3f0b4b5b71e645\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//6f99cb5b13ffd7ce73d1ed001f039b1b\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//6f99cb5b13ffd7ce73d1ed001f039b1b\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//f18a6c740b73a73a7c168c620d49bb53\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//f18a6c740b73a73a7c168c620d49bb53\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//1f38f8eeb375e37a9570cb95a5952933\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//1f38f8eeb375e37a9570cb95a5952933\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//95890c0f399768d11081d5b343f652a2\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//95890c0f399768d11081d5b343f652a2\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//081b28a3ab61f517a129f2504b8825d5\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//081b28a3ab61f517a129f2504b8825d5\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//f18e39b3daed08c1dd4cc9dada00fd83\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//f18e39b3daed08c1dd4cc9dada00fd83\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//e84a9f704b36b0fee0b143e9cd51ad6c\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//e84a9f704b36b0fee0b143e9cd51ad6c\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//9314f666c86fc32b9796170abe3c0da9\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//9314f666c86fc32b9796170abe3c0da9\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//f5948d921c470520bca6a83f92af3cc8\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//f5948d921c470520bca6a83f92af3cc8\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//9f49c6febe6cd09ac66a342b66a59e92\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//9f49c6febe6cd09ac66a342b66a59e92\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//40c1e718865545d5242aac2ce7adfcc5\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//40c1e718865545d5242aac2ce7adfcc5\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//970bab6646ebcaae44ce8fd7bfa31119\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//970bab6646ebcaae44ce8fd7bfa31119\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//6c818a437feda364131d81b8b7f540be\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//6c818a437feda364131d81b8b7f540be\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//e4ac8ac037cfb3aaae4ca9405ef84002\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//e4ac8ac037cfb3aaae4ca9405ef84002\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//c0caa97be1e82114bc2d7b7e6f0baf90\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//c0caa97be1e82114bc2d7b7e6f0baf90\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//95d6b19c18a7ede3f5245f705c869175\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//95d6b19c18a7ede3f5245f705c869175\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//f65554c574950860f2fc24851aff638d\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//f65554c574950860f2fc24851aff638d\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//19fcbcbdf7d8cb034abbe66acfbc280a\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//19fcbcbdf7d8cb034abbe66acfbc280a\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//bd26ca537f140b097226419f42ef9143\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//bd26ca537f140b097226419f42ef9143\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//a52b9b4405e89a0a703bd9feb269a53a\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//a52b9b4405e89a0a703bd9feb269a53a\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//dbbb3b297a8a6b1c4c109a3fa3e0026f\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//dbbb3b297a8a6b1c4c109a3fa3e0026f\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//e036f3b1d936ab6f8a5fb44638c68ee7\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//e036f3b1d936ab6f8a5fb44638c68ee7\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//97a5624513667cac9ff398bba0fb4a6c\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//97a5624513667cac9ff398bba0fb4a6c\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//a6ead0b0f5954d4e42e395111579b2dc\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//a6ead0b0f5954d4e42e395111579b2dc\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//6cf2d8cf200214cfe37f8052c3dd2664\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//6cf2d8cf200214cfe37f8052c3dd2664\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//db7723c78cf06f5f4da2efb1e9a31360\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//db7723c78cf06f5f4da2efb1e9a31360\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//c588d99ea1a04845ed0f43484e877366\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//c588d99ea1a04845ed0f43484e877366\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//a28e060056ecdb2dcd92d2031a9a76a1\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//a28e060056ecdb2dcd92d2031a9a76a1\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//d37f258abc6b402450e7d2ec576e6748\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//d37f258abc6b402450e7d2ec576e6748\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//84bc46d996a4e063fd00e5c435544b86\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//84bc46d996a4e063fd00e5c435544b86\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//e98abb632904629b8a41ad0517b4bf89\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//e98abb632904629b8a41ad0517b4bf89\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//ab5e6a822f7bedbbe756b3dd1667c28d\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//ab5e6a822f7bedbbe756b3dd1667c28d\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//098818dab1f06c90cb5ba29a63efb130\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//098818dab1f06c90cb5ba29a63efb130\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//f3e1ef9d8266db2035453f22781af206\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//f3e1ef9d8266db2035453f22781af206\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//2e087ea1155e21abf83995495a8ef10c\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//2e087ea1155e21abf83995495a8ef10c\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//36bc3b02a783051aeef6714aee936440\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//36bc3b02a783051aeef6714aee936440\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//f0f5d800c7e4ff4761b5079b15165a4a\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//f0f5d800c7e4ff4761b5079b15165a4a\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//a733f83cc9241735456f3834ed250b4e\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//a733f83cc9241735456f3834ed250b4e\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//0208404af592534e5c6f5ff1e28e7dcb\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//0208404af592534e5c6f5ff1e28e7dcb\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//8863d2e14e84d8d6012b6780c9c06f97\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//8863d2e14e84d8d6012b6780c9c06f97\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//7d00c63201de84141eee04b5ff860ad7\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//7d00c63201de84141eee04b5ff860ad7\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//81e4da574d98a7e4a1ad25288a32c961\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//81e4da574d98a7e4a1ad25288a32c961\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//8907a48631f4b2d6543c123b317de798\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//8907a48631f4b2d6543c123b317de798\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//7e1ed7c9b5a96187cee025409d451be0\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//7e1ed7c9b5a96187cee025409d451be0\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//9987aafdee41f9124a9801ddae3a83b8\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//9987aafdee41f9124a9801ddae3a83b8\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//3749c36f5b10149e5f8916944eb9e46b\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//3749c36f5b10149e5f8916944eb9e46b\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//fcaa38a80b03d8640ccf5923659b776d\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//fcaa38a80b03d8640ccf5923659b776d\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//206f1332dc99bc7ea48fef43f9c1e108\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//206f1332dc99bc7ea48fef43f9c1e108\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//7dab88e7aa9d8e62d103d39c50132345\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//7dab88e7aa9d8e62d103d39c50132345\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//a03c6be148e47c166aaacdff82c13e37\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//a03c6be148e47c166aaacdff82c13e37\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//47d9070fd2bac8f60ccb48956e23bc3f\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//47d9070fd2bac8f60ccb48956e23bc3f\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//5ce2ea14ade07c16bd60b88cdd39cbd9\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//5ce2ea14ade07c16bd60b88cdd39cbd9\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//1e0536a13c53def9265caea8d1c8e36e\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//1e0536a13c53def9265caea8d1c8e36e\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//2bfba6b2a29ea5b03ec695aa6e4a2d1c\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//2bfba6b2a29ea5b03ec695aa6e4a2d1c\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//3bc114f2b363fe790e11484deb6d457c\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//3bc114f2b363fe790e11484deb6d457c\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//f18b87d9a2578f4c60dffde018dbe79e\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//f18b87d9a2578f4c60dffde018dbe79e\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//500664a5acc3c290204f95b664cc4f65\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//500664a5acc3c290204f95b664cc4f65\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//5783da7cb1fe62496ad9b27a1e73b433\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//5783da7cb1fe62496ad9b27a1e73b433\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//d6965aacb3239fe6e03389e918bd040d\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//d6965aacb3239fe6e03389e918bd040d\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//40e8baf7c2d0564b45f2018855c6f689\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//40e8baf7c2d0564b45f2018855c6f689\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//64771b15756c31644b0a37fb77de00b5\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//64771b15756c31644b0a37fb77de00b5\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//04feeb7632b799775944f2b8d87eb4da\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//04feeb7632b799775944f2b8d87eb4da\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//0f2d0b028e734d284065c5124dca23e9\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//0f2d0b028e734d284065c5124dca23e9\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//22bfe47577f5c8301aed66fb3c051ef7\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//22bfe47577f5c8301aed66fb3c051ef7\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//99812f89f706a7a2cc38d08a900bd556\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//99812f89f706a7a2cc38d08a900bd556\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//869db5e49b3459ef7ddf8c17851f3e31\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//869db5e49b3459ef7ddf8c17851f3e31\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//527d09d0225c84f3a2952c875e2508c5\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//527d09d0225c84f3a2952c875e2508c5\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//fdfcb884abc69e3cc8a22c6302480139\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//fdfcb884abc69e3cc8a22c6302480139\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//606e3f4559ec15befed2ef846e034672\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//606e3f4559ec15befed2ef846e034672\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//5eb30fa07618c20a7613ae3d045134a5\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//5eb30fa07618c20a7613ae3d045134a5\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//665b76ddf680b87a9e8e282db347c23a\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//665b76ddf680b87a9e8e282db347c23a\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//2c15161baecd5785b56098c9ee0c3182\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//2c15161baecd5785b56098c9ee0c3182\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//a2829956c83671b9d2f052506015e0dd\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//a2829956c83671b9d2f052506015e0dd\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//d61c08934b300ff730e1879931747c01\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//d61c08934b300ff730e1879931747c01\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//0b935fca07b9e234a6d3969aa0d9f040\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//0b935fca07b9e234a6d3969aa0d9f040\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//1caa941897f0122e6779151c72f1ede4\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//1caa941897f0122e6779151c72f1ede4\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//6fd949ecada907a375b2ac56768ba74f\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//6fd949ecada907a375b2ac56768ba74f\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//d0569b47c9ba4a65a0da6dbe5b37d126\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//d0569b47c9ba4a65a0da6dbe5b37d126\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//7c29e597817c63a202faff22c71b2261\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//7c29e597817c63a202faff22c71b2261\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//893c03c55df84db8db62b06d4fbf87f8\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//893c03c55df84db8db62b06d4fbf87f8\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//316a99f3348b7a7c2165f2b1cc9e4c52\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//316a99f3348b7a7c2165f2b1cc9e4c52\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//893bcbdc165e1aa171f8fc9fda2f954f\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//893bcbdc165e1aa171f8fc9fda2f954f\"}",
    "{\"uri\":\"xxinc-media.oss-cn-shenzhen.aliyuncs.com//879c8839b4a119a9449119ef89e52c0e\",\"url\":\"https://xxinc-media.oss-cn-shenzhen.aliyuncs.com//879c8839b4a119a9449119ef89e52c0e\"}"
]

# 检查户型图是否带有标尺
ocr_url = "http://192.168.11.116:9016/floorplan/num_ocr"
# 图片识别，是否为户型图
image_detection_url = "http://192.168.11.114:9015/floorplan/detection"


def call_http(param_image_url, post_url):
    data = {
        "img_url": param_image_url + "?x-oss-process=image/format,jpg/quality,90/resize,w_650,h_650",
    }
    res = requests.post(url=post_url, json=data)

    return res.json()


if __name__ == '__main__':
    for image_url_str in image_url_list:
        image_url_json = json.loads(image_url_str)
        image_url = image_url_json['url']
        resJson = call_http(image_url, ocr_url)
        ocr_result = None
        image_result = None
        if len(resJson['data']['num_ocr_result']) > 0:
            ocr_result = True
        else:
            ocr_result = False

        resJson = call_http(image_url, image_detection_url)
        if resJson['data']['type'] == "FloorPlan":
            image_result = True
        else:
            image_result = False
        print(f'{image_url}  {ocr_result}  {image_result}')

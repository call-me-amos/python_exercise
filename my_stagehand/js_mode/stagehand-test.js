import { Stagehand } from "@browserbasehq/stagehand";
import { z } from "zod";

(async () => {
  // 初始化 Stagehand（本地或远程）
  const stagehand = new Stagehand({
    env: "LOCAL", // 或 "BROWSERBASE"
    headless: false, // 显示浏览器界面
  });
  await stagehand.init();

  // 导航到目标页面
  await stagehand.page.goto("http://boss.to8to.com/logs/test/app/kibana#/discover?_g=(refreshInterval:(pause:!t,value:0),time:(from:now-24h,mode:quick,to:now))&_a=(columns:!(lv,txt,bsid,ln,host),filters:!(('$state':(store:appState),meta:(alias:!n,disabled:!f,index:c311fbe0-dbfc-11ec-8c99-4f70e435c9ab,key:txt,negate:!t,params:(query:%E5%BC%80%E5%A7%8B%E5%8A%A0%E8%BD%BD%E8%A7%84%E5%88%99,type:phrase),type:phrase,value:%E5%BC%80%E5%A7%8B%E5%8A%A0%E8%BD%BD%E8%A7%84%E5%88%99),query:(match:(txt:(query:%E5%BC%80%E5%A7%8B%E5%8A%A0%E8%BD%BD%E8%A7%84%E5%88%99,type:phrase))))),index:c311fbe0-dbfc-11ec-8c99-4f70e435c9ab,interval:auto,query:(language:lucene,query:'bsid:%22%20%20%20%09%09%09%09%09%09%09%09%09%09%09%09%09%09%09%09%09%09%09%09%09%09%09%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%09t8t-tbt-tls175514118703574cde4e7-5bf7-4491-8677-41c5f83c3812%20%20%20%20%20%20%20%22'),sort:!('@timestamp',desc))");

  // 执行自然语言指令：点击仓库链接
  await stagehand.page.act({
    action: "统计列表返回了多少条日志",
  });

  // 提取 PR 信息（需定义 Zod Schema）
  const prData = await stagehand.page.extract({
    instruction: "提取日志开始时间和结束时间",
    schema: z.object({
      title: z.string(),
      author: z.string(),
    }),
  });
  console.log(prData); // { title: "...", author: "..." }

  // 获取页面可操作建议
  const actions = await stagehand.page.observe();
  console.log(actions); // [{ selector: "...", description: "Click login button" }, ...]

  // 关闭浏览器
  await stagehand.close();
})();
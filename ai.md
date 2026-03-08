---
id: ai
aliases: []
tags: []
---

<!-- mtoc-start -->

* [ai哲学](#ai哲学)
  * [刘禾](#刘禾)
* [LLM](#llm)
  * [原理](#原理)
  * [使用](#使用)
  * [性能排行榜](#性能排行榜)
  * [项目](#项目)
    * [在线使用](#在线使用)
    * [专门领域项目](#专门领域项目)
  * [RAG和向量数据库](#rag和向量数据库)
    * [框架](#框架)
    * [embedding model（文本嵌入式模型）](#embedding-model文本嵌入式模型)
  * [prompt提示词](#prompt提示词)
    * [数据库](#数据库)
  * [微调](#微调)
  * [有趣的文章、访谈](#有趣的文章访谈)
    * [Sam Altman：Moore's Law for Everything](#sam-altmanmoores-law-for-everything)
    * [OpenAI工程师：模型不是关键，语料才是关键](#openai工程师模型不是关键语料才是关键)
    * [2024年llm总结Things we learned about LLMs in 2024](#2024年llm总结things-we-learned-about-llms-in-2024)
    * [DeepSeek模型作者的访谈](#deepseek模型作者的访谈)
* [ai项目](#ai项目)
  * [命令行相关工具](#命令行相关工具)
    * [llm大模型](#llm大模型)
      * [awesome-chatgpt](#awesome-chatgpt)
      * [ollama](#ollama)
        * [Ollama对比vllm](#ollama对比vllm)
        * [open-webui：ollama web ui](#open-webuiollama-web-ui)
        * [open-coreui:  Rust 语言重写的 Open WebUI，降低了内存和资源消耗，有服务器版和桌面版。](#open-coreui--rust-语言重写的-open-webui降低了内存和资源消耗有服务器版和桌面版)
        * [hollama：ollama web ui](#hollamaollama-web-ui)
        * [oterm：Ollama cli客户端](#otermollama-cli客户端)
        * [MaxKB：ollama web ui，知识库](#maxkbollama-web-ui知识库)
        * [rag-web-ui](#rag-web-ui)
        * [LM Studio：ollama gui版](#lm-studioollama-gui版)
        * [anything-llm：一个gui。支持本地的ollama、也支持在线的（输入api即可），还支持向量数据库](#anything-llm一个gui支持本地的ollama也支持在线的输入api即可还支持向量数据库)
        * [cherry-studio：gui。支持本地的ollama、也支持在线的（输入api即可），还支持向量数据库](#cherry-studiogui支持本地的ollama也支持在线的输入api即可还支持向量数据库)
        * [AionUi: gui管理Free, local, open-source 24/7 Cowork and OpenClaw for Gemini CLI, Claude Code, Codex, OpenCode, Qwen Code, Goose CLI, Auggie, and more | 🌟 Star if you like it!](#aionui-gui管理free-local-open-source-247-cowork-and-openclaw-for-gemini-cli-claude-code-codex-opencode-qwen-code-goose-cli-auggie-and-more---star-if-you-like-it)
        * [cc-switch: gui配置管理。一键切换 Claude Code / Codex / Gemini CLI 的底层模型](#cc-switch-gui配置管理一键切换-claude-code--codex--gemini-cli-的底层模型)
        * [new-api: AI模型聚合管理中转分发系统，一个应用管理您的所有AI模型，支持将多种大模型转为统一格式调用，支持OpenAI、Claude、Gemini等格式，可供个人或者企业内部管理与分发渠道使用。🍥 A Unified AI Model Management & Distribution System. Aggregate all your LLMs into one app and access them via an OpenAI-compatible API, with native support for Claude (Messages) and Gemini formats.](#new-api-ai模型聚合管理中转分发系统一个应用管理您的所有ai模型支持将多种大模型转为统一格式调用支持openaiclaudegemini等格式可供个人或者企业内部管理与分发渠道使用-a-unified-ai-model-management--distribution-system-aggregate-all-your-llms-into-one-app-and-access-them-via-an-openai-compatible-api-with-native-support-for-claude-messages-and-gemini-formats)
      * [shimmy:一个只有 5MB 的单文件程序的ollama的代替品](#shimmy一个只有-5mb-的单文件程序的ollama的代替品)
      * [transformers.js：在浏览器运行大模型（如deepseek-r1）](#transformersjs在浏览器运行大模型如deepseek-r1)
    * [agent客户端](#agent客户端)
    * [rag知识库相关](#rag知识库相关)
    * [其他命令行相关工具](#其他命令行相关工具)
    * [其他应用](#其他应用)
  * [Transformer](#transformer)
  * [ai图片、视频](#ai图片视频)
    * [图片和视频理解](#图片和视频理解)
    * [文字生成图片](#文字生成图片)
    * [文字、图片生成视频](#文字图片生成视频)
    * [抠图、抠视频](#抠图抠视频)
    * [图片、视频质量提升](#图片视频质量提升)
    * [ai视频剪辑](#ai视频剪辑)
    * [ai生图生视频工作流](#ai生图生视频工作流)
  * [ai语音、音乐](#ai语音音乐)
    * [语音转文字](#语音转文字)
    * [文字转语音](#文字转语音)
    * [ai作曲（文字生成音乐、图片生成音乐）](#ai作曲文字生成音乐图片生成音乐)
    * [ai声音克隆（tts），可以实现让电影里的演员的英文配音变成国语](#ai声音克隆tts可以实现让电影里的演员的英文配音变成国语)
  * [ai数字人](#ai数字人)
  * [ai ocr](#ai-ocr)
  * [ai翻译](#ai翻译)
  * [ai编程语言](#ai编程语言)
  * [ai操作系统](#ai操作系统)
  * [ai自动化点击](#ai自动化点击)
    * [OmniParser：微软开发的对屏幕快速截图并转换成结构化数据](#omniparser微软开发的对屏幕快速截图并转换成结构化数据)
    * [ai浏览器](#ai浏览器)
  * [ai搜索](#ai搜索)
  * [ai编程，代码补全](#ai编程代码补全)
  * [ai为github代码仓库生成wiki](#ai为github代码仓库生成wiki)
  * [ai知识库](#ai知识库)
  * [ai编辑器](#ai编辑器)
  * [ai程序员](#ai程序员)
  * [ai终端](#ai终端)
  * [ai数据库终端](#ai数据库终端)
  * [ai爬虫和信息提取](#ai爬虫和信息提取)
  * [ai可视化](#ai可视化)
  * [ai金融模型](#ai金融模型)
  * [ai控制手机](#ai控制手机)
  * [ai agent（智能体）](#ai-agent智能体)
    * [在线使用](#在线使用-1)
  * [MCP](#mcp)
  * [A2A](#a2a)
  * [Claude skill](#claude-skill)
* [在线ai工具](#在线ai工具)
* [获取最新ai新闻](#获取最新ai新闻)
* [类似项目](#类似项目)

<!-- mtoc-end -->

# ai哲学

- [文化纵横：从“半截维特根斯坦”到完整的人：AI 时代文科教育的使命](https://mp.weixin.qq.com/s/e_nYjjax7ArxA82L_s3YKg)

- [（视频）卢菁老师\_北大AI博士后：谁能开启通用人工智能AGI的大门？符号主义、联结主义、行为主义！人工智能技术发展](https://www.bilibili.com/video/BV179fbYiEbK)

- [（视频）公园4004：符号主义 vs 联结主义:人工智能历史背后的哲学之争](https://www.bilibili.com/video/BV1fJ4m1M7Y4)

- [纪要｜【北京论坛·分论坛】数与智：人工智能时代的多学科融合（上）](https://mp.weixin.qq.com/s/MSfKwAgooJ2bY_vnqFSjjg)

## 刘禾

- [“伪人横行”的背后，是一场被精心掩藏的社会性退化](https://mp.weixin.qq.com/s/cpELKpFqf-2ZtCgO0RNKow)

# LLM

## 原理

- [llm-viz：3D 可视化 GPT 大语言模型。](https://bbycroft.net/llm)

- [wolfram作者：What Is ChatGPT Doing … and Why Does It Work?](https://writings.stephenwolfram.com/2023/02/what-is-chatgpt-doing-and-why-does-it-work/)

- [阿里云开发者：AI Coding 长文分享：如何真正把工具用起来，从原理到实践](https://mp.weixin.qq.com/s/MjBVTfo6Kp2RDG6v46_BPA)

## 使用

- [畅游 LLM 的世界（英文）](https://www.bentoml.com/blog/navigating-the-world-of-large-language-models)

  - 如果在家用电脑上安装 LLM（大型语言模型），应该选择哪一个模型？
  - 本文分析并评价了目前最流行的几个 LLM 的基本情况和优缺点。

- [腾讯技术工程：如何与ChatGPT4结对编程提升研发效率](https://www.163.com/dy/article/I13L6MEP0518R7MO.html)

- [腾讯云开发者：GPT4结对编程实战，鹅厂一线研发真实使用感受](https://cloud.tencent.com/developer/article/2285573)

- [腾讯云开发者：我用低代码结合ChatGPT开发，每天多出1小时摸鱼](https://cloud.tencent.com/developer/article/2294350)

- [铭毅天下Elasticsearch：吴恩达 x Open AI ChatGPT ——如何写出好的提示词视频核心笔记](https://mp.weixin.qq.com/s/VkLNKRtN7KR3Gjttk1cpPg)

## 性能排行榜

- [chatbot-arena-leaderboard：传统静态数据测试集榜](https://lmarena.ai/?leaderboard)

- [chinese-llm-benchmark：中文能力](https://github.com/jeinlee1991/chinese-llm-benchmark)

- [ZeroEval：零样本学习能力（直接处理未见过的任务指令或数据）评测榜单](https://huggingface.co/spaces/allenai/ZeroEval)

- [AIME24：数学能力](https://paperswithcode.com/sota/mathematical-reasoning-on-aime24)

- [LiveCodeBench：代码能力](https://livecodebench.github.io/leaderboard.html)

- [LiveBench：Meta 首席 AI 科学家杨立昆（Yann LeCun）联合 Abacus.AI、纽约大学等机构推出的一个极具挑战性的大语言模型（LLM）基准测试项目。它被业界誉为“最难糊弄的 LLMs 评测榜”](https://livebench.ai/#/)

- [BFCL：加州大学伯克利分校等提出的评估准确调用函数或工具方面的测试](https://gorilla.cs.berkeley.edu/leaderboard.html#leaderboard)

## 项目

- 国外

    - [openai/gpt-oss: openai的开源模型](https://github.com/openai/gpt-oss)

    - [llama.cpp：facebook实现的运行llm大模型的项目](https://github.com/ggerganov/llama.cpp)

        - [llama配置要求](http://www.bimant.com/blog/llama-consumer-hardware-requirements/)
        - [Llama2-Chinese：Llama中文社区](https://github.com/LlamaFamily/Llama-Chinese)

    - [llama3：facebook2024年的llm](https://github.com/meta-llama/llama3)

      - [llama3-chinese：以Meta-Llama-3-8B为底座，使用 DORA + LORA+ 的训练方法，在50w高质量中文多轮SFT数据 + 10w英文多轮SFT数据 + 2000单轮自我认知数据训练而来的大模型。](https://github.com/seanzhang-zhichen/llama3-chinese)

    - [Gemma：google的llm](https://github.com/google-deepmind/gemma)

    - [Grok-1：马斯克的 xAI 公司开源的 314B 参数、MoE（混合专家模型）的大型语言模型](https://github.com/xai-org/grok-1)

    - [corenet：苹果手机端大模型](https://github.com/apple/corenet)

- 国产

    - [awesome-LLMs-In-China](https://github.com/wgwang/awesome-LLMs-In-China)

    - [ChatGLM-6B：清华大学的llm](https://github.com/THUDM/ChatGLM-6B)
    - [ChatGLM2-6B：清华大学的llm](https://github.com/THUDM/ChatGLM2-6B)
    - [ChatGLM3：清华大学和智谱合作的llm](https://github.com/THUDM/ChatGLM3)

    - [MiniMax-01（海螺ai）：支持4M token的大模型。deepseek之后最有潜力国产大模型](https://github.com/MiniMax-AI/MiniMax-01)

    - [DeepSeek-V3：在中国大模型市场掀起了第一场价格战，因而被网友称为 AI 界的“拼多多”。](https://github.com/deepseek-ai/DeepSeek-V3)

    - [DeepSeek-R1和DeepSeek-R1 zero：推理模型](https://github.com/deepseek-ai/DeepSeek-R1)

      > DeepSeek-R1 是一个基于强化学习(RL)训练的大型语言模型(LLM), 旨在提高其推理能力 。它通过两个RL阶段和两个监督微调(SFT)阶段进行训练,以发现更好的推理模式并与人类偏好保持一致。

      - DeepSeek-R1-Zero：通过纯强化学习（RL）训练的基础模型，无监督微调（SFT）阶段，探索性强但存在输出不稳定问题。
      - DeepSeek-R1：在 R1-Zero 基础上引入冷启动数据（少量 SFT）优化后的版本，解决输出问题并提升推理能力。
      - DeepSeek-R1-Distill：从 R1 蒸馏到小型开源模型（如 Qwen、Llama）的轻量级推理模型，性能接近原版但更易部署。

      - DeepSeek-R1-Distill 系列的小模型

        - DeepSeek-R1-Distill-Qwen-1.5B
        - DeepSeek-R1-Distill-Qwen-7B
        - DeepSeek-R1-Distill-Llama-8B
        - DeepSeek-R1-Distill-Qwen-14B
        - DeepSeek-R1-Distill-Qwen-32B
        - DeepSeek-R1-Distill-Llama-70B

      - DeepSeek-R1 非蒸馏版模型是671B

        - 国内著名程序员章亦春用8块H200跑DeepSeek-V3满血版和DeepSeek-R1的671B版。结果[V3输出吞吐量有3800tokens/秒](http://m.weibo.cn/status/5131311536668680?)而[R1输出吞吐量只有不到22.8tokens/秒](https://m.weibo.cn/status/5131064928897158?)

      - DeepSeek-R1 671B的满血版可以实现prompt：`用html实现小球在三角形里跳动`

    - [DeepSeek-V3-0324：被评价为与Claude 3.7 Sonnet 同一水平](https://huggingface.co/deepseek-ai/DeepSeek-V3-0324)

        - 模型参数为 6850 亿，较初代 V3 版本的 6710 亿有小幅增长。


    - [Qwen2.5-Omni：阿里的大模型。7B尺寸实现全球最强性能](https://github.com/QwenLM/Qwen2.5-Omni)

    - [open-r1：DeepSeek-R1 的完全开源复现](https://github.com/huggingface/open-r1)


- llm相关项目

    - [ktransformers：清华大学实现的，比llama.cpp要快，可以实现在4090 + 1T内存跑deepseek-r1 671B满血版](https://github.com/kvcache-ai/ktransformers)

    - [ChatPilot：支持Google搜索、文件网址对话（RAG）、代码解释器功能，复现了Kimi Chat(文件，拖进来；网址，发出来)](https://github.com/shibing624/ChatPilot)

    - [LaWGPT：在通用中文基座模型（如 Chinese-LLaMA、ChatGLM 等）的基础上扩充法律领域专有词表、大规模中文法律语料预训练](https://github.com/pengxiao-song/LaWGPT)

    - [DB-GPT（部署数据库交互llm。防止数据隐私上传平台）](https://github.com/eosphoros-ai/DB-GPT)

    - [nanoGPT：是用于训练/微调中等规模 GPT 模型的库。它是对 minGPT 的重写](https://github.com/karpathy/nanoGPT)
    - [llm.c：1k 行的 C 代码就完成了 GPT-2 模型的训练，代码纯手撸、不依赖任何机器学习框架。](https://github.com/karpathy/llm.c)

      - 教学意义大于实用价值

      - 作者曾就职于特斯拉的自动驾驶部门负责人、OpenAI 的创始成员。

### 在线使用

- [huggingface：模型下载](https://huggingface.co/)

    - [（视频）秋芝2046：Huggingface小白AI入门，你必须了解的免费开源模型大超市](https://www.bilibili.com/video/BV1Mr4MewEY5)

- [modelscope（魔塔）：中国版huggingfacce。模型下载](https://modelscope.cn/models)

- [LLM Pricing：AI 模型价格对比和试用链接](https://llmpricecheck.com/)

- 国外

  - [chatgpt](https://chat.openai.com/)

  - [copilot：微软的gpt](https://copilot.microsoft.com/)

  - [gemini：谷歌的gpt](https://gemini.google.com/)

  - [meta.ai：Meta 公司发布自家的 AI 服务，免费使用，基于 Llama 3 模型，可以"文生文"和"文生图"](https://www.meta.ai/)

  - [llama.dev：Meta 公司还有一个专门的 Llama 聊天网站，可以选择该模型的不同版本。](https://llama3.dev/)

  - [DuckDuckGo 推出的免费 AI 聊天，底层是 GPT-3.5 Turbo 和 Claude 1.2](https://duckduckgo.com/?q=DuckDuckGo&ia=chat)

  - [grok：马斯克的gpt](https://grok.com/?referrer=website)

- 国产

    - [秘塔ai：支持搜索、研究（可以调用全网、文库、学术文献）。比deepseek和qwen2.5max要好](https://metaso.cn/)

    - [qwen2.5max：阿里的llm目前排名第6，高于deepseek v3](https://chat.qwenlm.ai/)

    - [deepseek](https://chat.deepseek.com/a/chat/)

        - [国家超算互联网：支持deepsek-r1满血版](https://chat.scnet.cn/#/home)

        - [awesome-deepseek-integration](https://github.com/deepseek-ai/awesome-deepseek-integration)

    - [kimi](https://kimi.moonshot.cn/chat)

    - [MiniMax-01（海螺ai）：支持4M token的大模型。](https://hailuoai.com)

    - [stepfun（阶跃星辰）：deepseek之外最值得关注的大模型](https://yuewen.cn/chats/new)

    - [智谱清言](https://chatglm.cn/main/)

- 多个模型聚合

  - [chathub：支持deepseek-r1和qwen2.5max等。并且支持多窗口多模型回答](https://app.chathub.gg/)

  - [ithy：同时返回 Lllma 3.1、o1-mini、Sonnet 3.5、Grok 2、Gemini 1.5 pro 的生成结果。](https://ithy.com/)

- 第三方api平台

  - [字节跳动的火山引擎：可以免费使用deepseek-r1等大模型](https://console.volcengine.com/ark/region:ark+cn-beijing/experience/chat)

    - [（视频）技术爬爬虾：最快最稳的DeepSeek，榨干微软字节两大厂，解锁知识库，联网搜索等高级功能](https://www.bilibili.com/video/BV1NCNPeZENF)

    - [（视频）沧海九粟：🌋 字节火山引擎 x 🐳 DeepSeek R1 联网搜索赋能实操 🌍](https://www.bilibili.com/video/BV1ZBAVeNEpy)

  - [华为云：可以免费使用deepseek-r1等大模型](https://console.huaweicloud.com/modelarts/?locale=zh-cn&region=cn-southwest-2#/model-studio/deployment)

    - [（视频）华为云：DeepSeek满血版模型上线华为云，简单3步立即体验](https://www.bilibili.com/video/BV17tKjenEdD)

  - [阿里的百炼：可以免费使用deepseek-r1、qwen2.5max（比deepseek-v3要好）等大模型](https://bailian.console.aliyun.com/detail/deepseek-r1#/model-market/detail/deepseek-r1?tabKey=sdk)

    - [教程。DeepSeek满血复活，不一样的部署教程！](https://mp.weixin.qq.com/s/1VSnZ3lRZ9vYAwjrOHHVwA)

  - [百度千帆：可以提供免费使用deepseek-r1等大模型的api](https://console.bce.baidu.com/qianfan/modelcenter/model/buildIn/detail/am-swqeelkc6t2u)

    - [（视频）来真的：百度终于干了件人事！DeepSeek满血版免费白嫖，本地部署详细教程！](https://www.bilibili.com/video/BV1KrNweHE64)

  - [腾讯云：可以提供免费使用deepseek-r1等大模型的api](https://console.cloud.tencent.com/lkeap/index)

    - 使用腾讯云的deepseek-r1的api有隐藏不能超过500token的限制。无法完整实现prompt：`用html实现小球在三角形里跳动`
    - [（视频）神农尝百码Damon：限时免费：腾讯云+deepseek R1满血版](https://www.bilibili.com/video/BV1X5NTe5EVS)

  - [硅基流动：可以提供免费使用deepseek-r1等大模型、还有嵌入模型bge-m3等的api](https://www.siliconflow.com/zh/home)

    - [（视频）技术爬爬虾：DeepSeek R1 满血免费 API，昇腾芯片+DeepSeek国产AI表现如何](https://www.bilibili.com/video/BV1T2FreXETz)

  - [潞晨云](https://cloud.luchentech.com/console/development)

    - [（视频）神农尝百码Damon：潞晨云+Deepseek R1 手把手使用演示](https://www.bilibili.com/video/BV1TGNWeDEQX)

  - [openrouter](https://openrouter.ai/settings/keys)

    - [（视频）技术爬爬虾：DeepSeek R1 满血免费 API，昇腾芯片+DeepSeek国产AI表现如何](https://www.bilibili.com/video/BV1T2FreXETz)

  - 微软的云服务azure：可以免费部署deepseek-r1等大模型：[注册登陆连接：需要visa信用卡](https://azure.microsoft.com/zh-cn/pricing/purchase-options/azure-account/)、[deepseek-r1等ai大模型部署连接](https://ai.azure.com)

    - [（视频）技术爬爬虾：最快最稳的DeepSeek，榨干微软字节两大厂，解锁知识库，联网搜索等高级功能](https://www.bilibili.com/video/BV1NCNPeZENF)

  - [github的model：可以免费使用deepseek-r1等大模型，但我使用deepseek-r1有限制](https://github.com/marketplace/models/azureml-deepseek/DeepSeek-R1/playground)

- 提示生成 App
  - [DeepSeek Coder：基于 DeepSeek V3 模型](https://deepbolt.xyz/)

### 专门领域项目

- [腾讯公众号写文章助手](https://ima.qq.com/)

  - [（视频）秋芝2046：写公众号也有AI外挂了？读、搜、写一条龙服务～](https://www.bilibili.com/video/BV1fvB1YcEtM)
  - 可以导入微信群内文件

- [storm](https://github.com/stanford-oval/storm)这是一个基于 LLM 的应用，可通过搜集网上的内容，从零编写类似维基百科的文章。使用者仅需提出问题，它便会上网收集资料并生成大纲，然后根据大纲和参考文献进行创作，生成的文章质量欠佳，还需要人为修改后才可以发布。

## RAG和向量数据库

- [（视频）秋芝2046：最近开源的AI知识库GraphRAG到底是什么？和普通的RAG有什么区别？【小白科普】](https://www.bilibili.com/video/BV16w4m1a75t)

- [RAG_Techniques：检索增强生成（RAG）教程集合。该项目提供了 20 多种先进的 RAG 技术教程，包含实现指南和示例代码，并定期更新。内容涵盖检索查询、上下文增强、融合检索（Fusion Retrieval）、分层索引、上下文压缩、知识图谱整合等多种 RAG 技术。](https://github.com/NirDiamant/RAG_Techniques)

- [graphrag：微软开发的将文本结构化的知识图谱RAG](https://github.com/microsoft/graphrag)

  - [（视频）黄益贺：GraphRAG：很好，但很贵！](https://www.bilibili.com/video/BV1dZ421K7sz)

- [PageIndex: 非传统rag，采用基于推理树型搜索](https://github.com/VectifyAI/PageIndex)

- [KAG：蚂蚁集团开发的。类似微软的graphrag](https://github.com/OpenSPG/KAG)
  - [（视频）五里墩茶社：【KAG】知识增强式生成 - 比RAG更强大的检索与推理框架](https://www.bilibili.com/video/BV1f9kZYgEnL)

### 框架

- [langchain](https://github.com/langchain-ai/langchain)

  - [（视频）LLM大模型入门：【人工智能】为什么要放弃LangChain? /Octomind资深工程师](https://www.bilibili.com/video/BV1gnWVegENr)

- [llama_index](https://github.com/run-llama/llama_index)

- [faiss：facebook的](https://github.com/facebookresearch/faiss)

- [haystack：Deepset的](https://github.com/deepset-ai/haystack)

- [transformers：huggingface的](https://github.com/huggingface/transformers)

- [semantic-kernel：微软的](https://github.com/microsoft/semantic-kernel)

- [dify](https://github.com/langgenius/dify)

- [refly](https://github.com/refly-ai/refly)

- [ragflow](https://github.com/infiniflow/ragflow)

- [Flowise](https://github.com/FlowiseAI/Flowise)

- [supermemory: 记忆系统。支持url,pdf,文本等，支持mcp调用，把rag抽象为一个可以允许其他应用调用的服务层](https://github.com/supermemoryai/supermemory)

### embedding model（文本嵌入式模型）

- [nomic-embed-text](https://huggingface.co/nomic-ai/nomic-embed-text-v1.5)

- [mxbai-embed-large](https://huggingface.co/mixedbread-ai/mxbai-embed-large-v1)

## prompt提示词

- [poml: 微软开发的提示词标准化语言，类似html](https://github.com/microsoft/poml)-

- [oenpai官方prompt工程](https://platform.openai.com/docs/guides/prompt-engineering)

  - [（视频）LLM大模型入门：【人工智能】如何写好提示词， OpenAI官方提示工程指南！](https://www.bilibili.com/video/BV1TfHKe5Ej9)

- [提示工程指南](https://www.promptingguide.ai/zh)

- [Prompt-Engineering-Guide：全面的提示工程实战指南。这份教程致力于帮助用户掌握与大型语言模型（LLM）沟通的技巧。内容涵盖从基础到高级的提示工程技术，附有详细的实现指南和示例代码。](https://github.com/dair-ai/Prompt-Engineering-Guide)

- [awesome-chatgpt-prompts](https://github.com/f/awesome-chatgpt-prompts)

- [腾讯云开发者：我问了鹅厂程序员：你们工作中怎么用ChatGPT？如何高效Prompt？](https://blog.csdn.net/QcloudCommunity/article/details/130143855)

- [腾讯云开发者：一文掌握Prompt：万能框架+优化技巧+常用指标](https://mp.weixin.qq.com/s/oKB8m_wX6p8SHNMx1R_hzw)

- [腾讯技术工程：大模型Prompt技巧全解析](https://mp.weixin.qq.com/s/u-79q3R0l01oO-7WWUNF2A)

- [deepseek提示库](https://api-docs.deepseek.com/zh-cn/prompt-library/)

- [阿里云开发者：AI联网搜索时的prompt小技巧](https://mp.weixin.qq.com/s/ZTdZY-jsyWwC2ELLF8byoQ)

### 数据库

- [韩锋频道：DeepSeek 会是个好DBA吗？](https://mp.weixin.qq.com/s/xAzHrtZV-pGzyPuv8U2w2w)

- [MySQL数据库联盟：如何通过ChatGPT优化MySQL的SQL语句](https://mp.weixin.qq.com/s?__biz=MzIyOTUzNjgwNg==&mid=2247484892&idx=1&sn=6207963a72bddf9e6c5fa70a57297a64&chksm=e8406095df37e98399b5e2f5347478f6e09061e3c0679e0231e117d0b8c88b1e32d61e622c7f&scene=21#wechat_redirect)

- [MySQL数据库联盟：全网最全MySQL Prompt](https://mp.weixin.qq.com/s?__biz=MzIyOTUzNjgwNg==&mid=2247485114&idx=1&sn=9b09f028e20605ab9d1c561ac8303c7c&chksm=e84063f3df37eae564e6944793d124b28563101600e4727bc4158dff685cc959e54c6951267f&scene=178&cur_album_id=2861367280583032837#rd)

## 微调

- [unsloth：用于微调和优化大型语言模型（LLM）的 Python 工具库。它通过动态量化和显存优化技术，提高了模型微调速度，同时将显存占用降低 70%-80%，并支持多种硬件配置、LLM、超长上下文任务等功能。除此之外，还提供了可直接在线体验的 Jupyter Notebook 示例，降低了大模型微调的门槛。](https://github.com/unslothai/unsloth)

- [ColossalAI：训练工具箱](https://github.com/hpcaitech/ColossalAI)

  - DeepSeek V3/R1 满血 671B LoRA 低成本 SFT 微调
  - 完整的强化学习工具链 PPO、GRPO、DPO、SimPO 等
  - 无缝适配 DeepSeek 系列蒸馏模型在内的 HuggingFace 开源模型
  - 兼容支持英伟达 GPU、华为昇腾 NPU 等多种硬件
  - 支持混合精度训练、gradient checkpoint 等训练加速降低成本
  - 灵活的训练配置接口，支持自定义奖励函数、损失函数等
  - 提供灵活的并行策略配置接口，包括数据并行、模型并行、专家并行、ZeRO 和 Offload 等，以适应不同硬件规模

## 有趣的文章、访谈

### [Sam Altman：Moore's Law for Everything](https://moores.samaltman.com/)

### OpenAI工程师：模型不是关键，语料才是关键

- OpenAI 的工程师，著名“文生图”模型 DALL-E 的第一作者 James Betker 的观点：模型不是关键，语料才是关键。

  - 不需要说，你的模型多新颖、多强大，只需要告诉我，你用什么语料训练模型。

    - 模型完美，但是语料垃圾，一样不行
    - 反之，模型很平常，但是语料足够，那就 OK。

  - 当你谈论 Lambda、ChatGPT、Bard 或Claude 时，指的并不是它们的模型，而是它们的语料集。

  - 这告诉我们两点启示：

    - 1.哪一家公司的语料的数量多、质量好，它的模型就会强于其他公司。
    - 2.开源模型完全可以替代闭源模型，前提是训练语料要足够。

### 2024年llm总结[Things we learned about LLMs in 2024](https://simonwillison.net/2024/Dec/31/llms-in-2024/)

> 作者是英国程序员西蒙·威利森（Simon Willison）最近两年非常出名，他的个人网站有很多文章，介绍 AI 的最新进展。

- 他提到，AI 的发展速度快得难以想象。

- 一年前的2023年底，排名第一的 AI 模型是 OpenAI 公司的 GPT-4，没有其他模型能超过它。

  - 一年过去了，大家猜猜，GPT-4 现在排名多少？答案是第69位，已经有18家公司的大模型超过了它。其中的一些模型，甚至可以在笔记本电脑运行。

  - 短短一年，榜首模型就被大量竞争者轻松超过，家用硬件就能达到它的运行效果。AI 的进化速度就是这么惊人。

- 西蒙·威利森特别提到了来自中国的大模型 DeepSeek V3。

  - DeepSeek V3 是2024年12月25日发布的，来自杭州的量化基金公司幻方量化。一经发布，它就引起了国际范围的轰动。

  - 它在多个参数上，击败了 OpenAI 公司最新的 o1 模型。目前，它在大模型排行榜上排名第7，要知道前十名里面，只有它是开源模型，而且是最少限制的 MIT 许可证，其他都是大公司的专有模型。

- 而且，它的运行效率很高，训练成本估计只有 Meta 公司的 Llama 3.1 405B 模型的11分之一，而后者的效果还不如它。这就是说，DeepSeek 找到了高效使用硬件、提高模型效果的方法。

- 西蒙·威利斯说："DeepSeek V3 的训练成本不足600万美元，是一个极好的迹象，表明 AI 模型的训练成本可以而且应该会继续下降。"

- 西方媒体就非常好奇，DeepSeek 是怎么做到的？

### DeepSeek模型作者的访谈

- [揭秘DeepSeek:一个更极致的中国技术理想主义故事](https://mp.weixin.qq.com/s/r9zZaEgqAa_lml_fOEZmjg)

  - [阮一峰分享他说的几段话](https://www.ruanyifeng.com/blog/2025/01/weekly-issue-332.html)，展示了中国顶级研究者的视野和抱负。

  - 1.我们要做的不是生成式 AI，而是通用人工智能 AGI。前者只是后者的必经之路，AGI 会在我们有生之年实现。

  - 2.任何 AI 公司（短期内）都没有碾压对手的技术优势，因为有 OpenAI 指路，又都基于公开论文和代码，大厂和创业公司都会做出自己的大语言模型。

  - 3.在颠覆性的技术面前，闭源形成的护城河是短暂的。即使 OpenAI 闭源，也无法阻止被别人赶超。我们把价值沉淀在团队上，我们的同事在这个过程中得到成长，积累很多know-how，形成可以创新的组织和文化，就是我们的护城河。

  - 4.我们不会闭源。我们认为先有一个强大的技术生态更重要。

  - 5.当前阶段是技术创新的爆发期，而不是应用的爆发期。大模型应用门槛会越来越低，创业公司在未来20年任何时候下场，也都有机会。

  - 6.过去很多年，很多的中国公司习惯了别人做技术创新，拿过来做应用变现，自己等着摩尔定律从天而降，躺在家里18个月就会出来更好的硬件和软件。我们的出发点，就不是趁机赚一笔，而是走到技术的前沿，去推动整个生态发展。中国也要逐步成为贡献者，而不是一直搭便车。

  - 7.大部分中国公司习惯 follow，而不是创新。中国创新缺的不是资本，而是缺乏信心以及不知道怎么组织高密度的人才。我们没有海外回来的人，都是本土的。前50名顶尖人才可能不在中国，但也许我们能自己打造这样的人。

  - 8.我们每个人对于卡和人的调动是不设上限的。如果有想法，每个人随时可以调用训练集群的卡无需审批。同时因为不存在层级和跨部门，也可以灵活调用所有人，只要对方也有兴趣。

  - 9.我们选人的标准一直都是热爱和好奇心，所以很多人会有一些奇特的经历，很有意思。很多人对做研究的渴望，远超对钱的在意。

  - 10.我们在做最难的事。对顶级人才吸引最大的，肯定是去解决世界上最难的问题。其实，顶尖人才在中国是被低估的。因为整个社会层面的硬核创新太少了，使得他们没有机会被识别出来。我们在做最难的事，对他们就是有吸引力的。

  - 11.中国产业结构的调整，会更依赖硬核技术的创新。很多人发现过去赚快钱很可能来自时代运气，现在赚不到了，就会更愿意俯身去做真正的创新。

  - 12.我是八十年代在广东一个五线城市长大的。我的父亲是小学老师，九十年代，广东赚钱机会很多，当时有不少家长觉得读书没用。但现在回去看，观念都变了。因为钱不好赚了，连开出租车的机会可能都没了。一代人的时间就变了。以后硬核创新会越来越多，因为整个社会群体需要被事实教育。当这个社会让硬核创新的人功成名就，群体性想法就会改变。我们只是还需要一堆事实和一个过程。

- [疯狂的幻方：一家隐形AI巨头的大模型之路](https://mp.weixin.qq.com/s/Cajwfve7f-z2Blk9lnD0hA)

  - 国内拥有超过1万枚GPU的企业不超过5家。而除几家头部大厂外，还包括一家名为幻方的量化基金公司。通常认为，1万枚英伟达A100芯片是做自训大模型的算力门槛。

    - 其实，这家很少被置于人工智能视野打量的公司，早已是一家隐秘的AI巨头：2019年，幻方量化成立AI公司，其自研的深度学习训练平台“萤火一号”总投资近2亿元，搭载了1100块GPU；两年后，“萤火二号”的投入增加到10亿元，搭载了约1万张英伟达A100显卡。

    - 「暗涌」：GPU是这次ChatGPT创业潮的稀缺品，你们在2021年就可以有先见之明，储备了1万枚。为什么？
    - 梁文锋：其实从最早的1张卡，到2015年的100张卡、2019年的1000张卡，再到一万张，这个过程是逐步发生的。几百张卡之前，我们托管在IDC，规模再变大时，托管就没法满足要求了，就开始自建机房。
    - 很多人会以为这里边有一个不为人知的商业逻辑，但其实，主要是好奇心驱动。

    - 「暗涌」：什么样的好奇心？
    - 梁文锋：对 AI 能力边界的好奇。对很多行外人来说，ChatGPT 这波浪潮冲击特别大；但对行内人来说，2012年 AlexNet 带来的冲击已经引领一个新的时代。AlexNet 的错误率远低于当时其他模型，复苏了沉睡几十年的神经网络研究。虽然具体技术方向一直在变，但模型、数据和算力这三者的组合是不变的，特别是当 2020 年 OpenAI 发布 GPT3 后，方向很清楚，需要大量算力；但即便 2021 年，我们投入建设萤火二号时，大部分人还是无法理解。

    - 还在浙江大学攻读人工智能时，梁文锋就无比笃信“人工智能一定会改变世界”，而2008年，这还是一个不被认同的执念。

      - 毕业后，他没有像周围人一样去大厂做个程序员，而是躲在成都的廉价出租屋里，不停接受进入诸多场景中尝试的挫败，最终切入了最复杂场景之一的金融，并成立了幻方。

  - 只是大模型对算力、算法和数据都有强依赖，所以起步就需要5000万美金，训练一次需要上千万美金，非百亿美金公司其实很难持续跟进。各种艰难之下，幻方却很乐观，创始人梁文锋告诉我们：“关键是我们想做这件事，能做这件事，那我们就是最合适的人选之一。”

  - 一家头部量化基金创始人认为，这些年的幻方，始终“没有按照某种约定成俗的道路在走”，而是“按照他们想要的方式 ” ，即便是有点离经叛道或者争议，“也敢大大方方说出来 ，然后按照自己的想法去做”。

    - 「暗涌」：无论如何，一个商业公司去做一种无限投入的研究性探索，都有些疯狂。
    - 梁文锋：如果一定要找一个商业上的理由，它可能是找不到的，因为划不来。
    - 从商业角度来讲，基础研究就是投入回报比很低的。OpenAI早期投资人投钱时，想的一定不是我要拿回多少回报，而是真的想做这个事。
    - 我们现在比较确定的是，既然我们想做这个事，又有这个能力，这个时间点上，我们就是最合适人选之一。

  - 关于幻方的成长奥秘，幻方内部将之归结为“选用了一批没有经验但有潜能的人，以及有一个可以让创新发生的组织架构和企业文化”，他们认为这也将是大模型创业公司可以与大厂竞争的秘密所在。

    - 「暗涌」：为什么经验没那么重要？
    - 梁文锋：不一定是做过这件事的人才能做这件事。幻方招人有条原则是，看能力，而不是看经验。我们的核心技术岗位，基本以应届和毕业一两年的人为主。

    - 「暗涌」：在创新业务上，你觉得经验是阻碍吗？
    - 梁文锋：做一件事，有经验的人会不假思索告诉你，应该这样做，但没有经验的人，会反复摸索、很认真去想应该怎么做，然后找到一个符合当前实际情况的解决办法。

    - 「暗涌」：幻方从一个完全无金融基因的外行，切入到这个行业，几年内做到头部，这条招人法则是其中秘密之一吗？
    - 梁文锋：我们的核心团队，连我自己，一开始都没有量化经验，这一点很特殊。不能说是成功的秘密，但这是幻方的文化之一。我们不会故意回避有经验的人，但更多是看能力。
    - 拿销售这个岗位举个例子。我们的两个主力销售，都是这个行业的素人。一个原来做德国机械品类外贸的，一个是原来在券商做后台写代码。他们进入这个行业时，没有经验，没有资源，没有积累。
    - 而现在我们可能是唯一一家能以直销为主的大私募。做直销意味着不用给中间商分费用，同样规模和业绩下，利润率更高，很多家会试图模仿我们，但并没有成功。

    - 「暗涌」：这次大模型招人，什么是我们必卡的条件？
    - 梁文锋：热爱，扎实的基础能力。其他都没那么重要。

    - 「暗涌」：这种人容易找到吗？
    - 梁文锋：他们的热情通常会表现出来，因为他真的很想做这件事，所以这些人往往同时也在找你。

    - 「暗涌」：你觉得好奇心驱动的疯狂可以一直持续下去吗？
    - 梁文锋：不是所有人都能疯狂一辈子，但大部分人，在他年轻的那些年，可以完全没有功利目的，投入地去做一件事。

    - 「暗涌」：选来合适的人后，用何种方式让他进入状态?
    - 梁文锋：交给他重要的事，并且不干预他。让他自己想办法，自己发挥。
    - 其实，一家公司的基因是很难被模仿的。比如说招没有经验的人，怎么判断他的潜力，招进来之后如何才能让他成长，这些都没法直接模仿。

    - 「暗涌」：这是一种非常规的管理方式，这种情况下你如何确保一个人做事是有效率的，而且在你要的方向上？
    - 梁文锋：招人时确保价值观一致，然后通过企业文化来确保步调一致。当然，我们并没有一个成文的企业文化，因为所有成文东西，又会阻碍创新。更多时候，是管理者的以身示范，遇到一件事，你如何做决策，会成为一种准则。

  - 创新

    - 「暗涌」：你觉得什么是打造一个创新型组织的必要条件？
    - 梁文锋：我们的总结是，创新需要尽可能少的干预和管理，让每个人有自由发挥的空间和试错机会。创新往往都是自己产生的，不是刻意安排的，更不是教出来的。

    - 「暗涌」：大模型可能是一件无休止投入的事，付出的代价会让你们顾虑吗？
    - 梁文锋：创新就是昂贵且低效的，有时候伴随着浪费。所以经济发展到一定程度之后，才能够出现创新。很穷的时候，或者不是创新驱动的行业，成本和效率非常关键。看OpenAI也是烧了很多钱才出来。

    - 「暗涌」：为什么很多家试图模仿你们，却没有成功？
    - 梁文锋：因为仅凭这一点不足以让创新发生。它需要和公司的文化和管理相匹配。

  - 事实上，第一年他们什么都做不出来，第二年才开始有点成绩。但我们的考核标准和一般公司不太一样。我们没有 KPI，也没有所谓的任务。

    - 「暗涌」：那你们的考核标准是？
    - 梁文锋：我们不像一般公司，看重客户下单量，我们的销售卖多少和提成不是一开始就算好的，而会更鼓励销售去发展自己的圈子，认识更多人，产生更大影响力。
    - 因为我们认为，一个让客户信任的正直的销售，可能在短时间内做不到让客户来下单，但可以让你觉得他是个靠谱的人。

  - 「暗涌」：你觉得这波做大模型的竞争中，创业公司更适合创新的组织架构会是和大厂竞争的破局点吗？
  - 梁文锋：按照教科书的方法论来推导创业公司，在当下，他们做的事，都是活不下来的。
  - 但市场是变化的。真正的决定力量往往不是一些现成的规则和条件，而是一种适应和调整变化的能力。
  - 很多大公司的组织结构已经不能快速响应和快速做事，而且他们很容易让之前的经验和惯性成为束缚，而这波AI新浪潮之下，一定会有一批新公司诞生。

# ai项目

## 命令行相关工具

### llm大模型

#### [awesome-chatgpt](https://github.com/sindresorhus/awesome-chatgpt)

#### [ollama](https://github.com/ollama/ollama)

- [公共 Ollama 服务列表](https://freeollama.oneplus1.top/)
    > 其实大部分人部署并不专业，把服务暴漏在公网上。

- [漫谈云原生：最全 Ollama 大模型部署指南](https://mp.weixin.qq.com/s/Esqw0zViQBiq_4VXEXKz_Q)

- [ollama：支持的大模型](https://ollama.com/search)

- 基本命令

    ```sh
    # 启动ollama
    sudo systemctl restart ollama

    # 所有可供下载的模型 https://ollama.com/search
    # 下载并运行deepseek-v3（被称为拼多多版大模型）
    ollama run nezahatkorkmaz/deepseek-v3

    # 从内存中卸载模型
    ollama stop nezahatkorkmaz/deepseek-v3

    # 下载文本嵌入式模型
    ollama pull nomic-embed-text
    # 比nomic更好的文本嵌入式模型
    ollama pull snowflake-arctic-embed2

    # /show parameters 查看参数
    ollama run deepseek-r1:latest
    >>> /show parameters
    Model defined parameters:
    stop                           "<｜begin▁of▁sentence｜>"
    stop                           "<｜end▁of▁sentence｜>"
    stop                           "<｜User｜>"
    stop                           "<｜Assistant｜>"

    # 修改参数。默认情况下，Ollama 上下文窗口大小为 2048，要改成 4096 可以执行
    >>> /set parameter num_ctx 4096
    ```

- 使用[modelscope（魔塔）](https://www.modelscope.cn/models)加速下载大模型文件，比ollama快
    ```sh
    pip install modelscope

    # 下载千问qwq-32B大模型
    modelscope download --model"Qwen/QwQ-32B-GGUF" --local_dir=./QwQ-32B

    # 比较大的模型是拆分多个文件的需要进行使用llama.cpp项目工具合并
    llama.cpp merge <所有gguf文件>

    ```

- Kubernetes 运行 Ollama
    ```sh
    # 配置 Helm Chart
    helm repo add ollama <https://feisky.xyz/ollama-kubernetes>
    helm repo update

    # 部署 Ollama
    helm upgrade --install ollama ollama/ollama \
        --namespace=ollama \
        --create-namespace

    # 开启端口转发
    kubectl -n ollama port-forward \
       service/ollama-webui 8080:80
    ```

- 变量：

    - Ollama 的存储路径为：

        - macOS: `~/.ollama/models`
        - Linux: `/usr/share/ollama/.ollama/models`
        - Windows: `C:\Users\%username%\.ollama\models`

        ```sh
        # 修改存储路径
        export OLLAMA_MODELS=~/ollama-data
        ```

    - 默认情况下，模型会在内存中保留 5 分钟后卸载。如果短时间向 LLM 发送大量请求，这可以提供更快的响应时间。

        ```sh
        # 设置为 1 小时
        export OLLAMA_KEEP_ALIVE=1h
        ```

    - Flash Attention 是大多数现代模型的一项功能，可以在上下文大小增加时显著减少内存使用。

        ```sh
        # 开启Flash Attention
        export OLLAMA_FLASH_ATTENTION=1
        ```

    - 设置 K/V 缓存的量化类型：启用 Flash Attention 时，K/V 上下文缓存可以进行量化，以显著减少内存使用。

        - 缓存量化对模型质量的影响：

            - 通常 GQA 分高的模型（比如 Qwen2）可能比 GQA 分低的模型更容易受到量化对精度影响。

            - 建议你尝试不同的量化类型，通过测试找到内存使用与质量之间最佳平衡点。


        - 要在 Ollama 中使用量化的 K/V 缓存，可以设置 `OLLAMA_KV_CACHE_TYPE` 环境变量：

        - `f16` - 高精度和高内存使用（默认）。
        - `q8_0` - 8 位量化，使用约为 f16 一半的内存，精度损失非常小，这通常对模型质量没有明显影响。
        - `q4_0` - 4 位量化，使用约为 f16 四分之一的内存，在较大上下文大小时会出现精度损失。

- 运行第三方 GGUF 模型

    - GGUF 是 llama.cpp 定义的一种高效存储和交换大模型预训练结果的二进制格式。你可以通过 Modelfile 文件中导入 GGUF 模型。

    - 首先创建一个 Modelfile：

        ```
        FROM <model-path>.gguf
        PARAMETER temperature 1
        PARAMETER num_ctx 4096
        SYSTEM You are Mario from super mario bros, acting as an assistant.
        ```
    - 然后，执行下面的命令加载运行模型：

        ```sh
        # 你可以加上 -q Q4_K_M 对模型量化
        ollama create myllama -f Modelfile
        ollama run myllama
        ```

    - 对于其他格式的模型，你可以通过 llama.cpp 转换为 GGUF 格式再使用。

##### Ollama对比[vllm](https://github.com/vllm-project/vllm)

- Ollama 是一个运行大模型的工具，可以看成是大模型领域的 Docker，可以下载所需的大模型并暴露 Ollama API，极大的简化了大模型的部署。

- vLLM 与 Ollama 类似，也是一个运行大模型的工具，但它针对推理做了很多优化，提高了模型的运行效率和性能，使得在资源有限的情况下也能高效运行大语言模型，另外，它提供兼容 OpenAI 的 API。

- 选择 Ollama 还是 vLLM？

    - Ollama 的特点：个人用户或本地开发环境使用 Ollama 很方便，对各种 GPU 硬件和大模型的兼容性很好，不需要复杂的配置就能跑起来，但性能上不如 vLLM。

    - vLLM 的特点：推理性能更好，也更节约资源，适合部署到服务器供多人使用，还支持多机多卡分布式部署，上限更高，但能适配的 GPU 硬件比 Ollama 少，且需要根据不同 GPU 和大模型来调整 vllm 的启动参数才能跑起来或者获得更好的性能表现。

    - 选型建议：如果有一定的技术能力且愿意折腾，能用 vLLM 成功跑起来更推荐用 vLLM 将大模型部署到 Kubernetes 中，否则就用 Ollama ，两种方式在本文中都有相应的部署示例。

##### [open-webui：ollama web ui](https://github.com/open-webui/open-webui)

##### [open-coreui:  Rust 语言重写的 Open WebUI，降低了内存和资源消耗，有服务器版和桌面版。](https://github.com/xxnuo/open-coreui)

##### [hollama：ollama web ui](https://github.com/fmaclen/hollama)

##### [oterm：Ollama cli客户端](https://github.com/ggozad/oterm)

##### [MaxKB：ollama web ui，知识库](https://github.com/1Panel-dev/MaxKB)

- [（视频）Rontalks：Ollama + deepseek + maxkb 搭建本地个人专属AI机器人，或者叫本地专属问答知识库](https://www.bilibili.com/video/BV15gFbefEYP)

- 自带知识库中的嵌入文本模型maxkb-embedding

##### [rag-web-ui](https://github.com/rag-web-ui/rag-web-ui)

##### [LM Studio：ollama gui版](https://lmstudio.ai/)

- [lms：LM Studio command line](https://github.com/lmstudio-ai/lms)

##### [anything-llm：一个gui。支持本地的ollama、也支持在线的（输入api即可），还支持向量数据库](https://github.com/Mintplex-Labs/anything-llm)

```sh
## linux安装
curl -fsSL https://cdn.useanything.com/latest/installer.sh | sh

## 启动
./AnythingLLMDesktop/start
```

##### [cherry-studio：gui。支持本地的ollama、也支持在线的（输入api即可），还支持向量数据库](https://github.com/CherryHQ/cherry-studio)

##### [AionUi: gui管理Free, local, open-source 24/7 Cowork and OpenClaw for Gemini CLI, Claude Code, Codex, OpenCode, Qwen Code, Goose CLI, Auggie, and more | 🌟 Star if you like it!](https://github.com/iOfficeAI/AionUi)

##### [cc-switch: gui配置管理。一键切换 Claude Code / Codex / Gemini CLI 的底层模型](https://github.com/farion1231/cc-switch)

#####  [new-api: AI模型聚合管理中转分发系统，一个应用管理您的所有AI模型，支持将多种大模型转为统一格式调用，支持OpenAI、Claude、Gemini等格式，可供个人或者企业内部管理与分发渠道使用。🍥 A Unified AI Model Management & Distribution System. Aggregate all your LLMs into one app and access them via an OpenAI-compatible API, with native support for Claude (Messages) and Gemini formats.](https://github.com/QuantumNous/new-api)

#### [shimmy:一个只有 5MB 的单文件程序的ollama的代替品](https://github.com/Michael-A-Kuykendall/shimmy)

- 启动时间＜100ms，秒开！
- 内存只占50MB，后台无感运行
- 基于 Rust 编写，极致优化
- 不需要复杂配置！自动分配端口！
- 自动发现模型源：Hugging Face、Ollama、本地文件夹…通通识别！

#### [transformers.js：在浏览器运行大模型（如deepseek-r1）](https://github.com/huggingface/transformers.js-examples/tree/main/deepseek-r1-webgpu)

- [（视频）五里墩茶社：在浏览器内运行DeepSeek R1 = WebGPU + Transformers.js](https://www.bilibili.com/video/BV1ZbFneCEkr)

- 显卡要支持webgpu：
    - 浏览器开启webgpu：`chrome://flags`下搜索`webgpu`然后启用。

### agent客户端

- [opencode: The open source coding agent.](https://github.com/anomalyco/opencode)

- [agent-studio: AgentX is a GPU-accelerated, cross-platform desktop application that brings AI agents to your workflow. 跨平台、原生 Agent 桌面。](https://github.com/sxhxliang/agent-studio)
- [workany: 开源的 AI Agent 桌面客户端，能够执行任务、操作文件，类似于 Claude Cowork](https://github.com/workany-ai/workany)

- [dexter: 金融相关的](https://github.com/virattt/dexter)

### rag知识库相关

- [qmd: 本地运行的智能知识库搜索工具。这是一款完全本地运行的智能搜索引擎，可用于检索个人文档、知识库、会议记录和 Markdown 文件。它集成了本地运行轻量化模型、BM25 全文检索、向量语义搜索和重排序等功能，开箱即用、无需联网、支持 MCP 协议，可作为 AI 助手和 Agent 工作流中的知识搜索工具。](https://github.com/tobi/qmd)

- [bilibili-rag: B站收藏夹RAG知识库：收藏不吃灰，B 站收藏夹 → 语音转写 → 向量检索 → 对话问答](https://github.com/via007/bilibili-rag)

### 其他命令行相关工具

- [shell_gpt：生成命令行](https://github.com/TheR1D/shell_gpt)

- [reor：ai私人助手](https://github.com/reorproject/reor)

- [reader：将网址放到https://r.jina.ai/便可获取markdown文档的总结](https://github.com/jina-ai/reader)
    - [在线网址](https://jina.ai/reader/)

    ```sh
    curl -H "Accept: text/event-stream" https://r.jina.ai/https://www.bilibili.com/video/BV1bD421n7dg
    ```

- [aider:这是一款运行在终端里的 AI 辅助编码工具，能够将你本地 git 仓库中的代码与 LLMs 结合起来。开发者通过 add 命令引入文件，然后用自然语言描述需求，它就可以对现有的代码进行修改并自动提交，支持接入多种大模型，包括 GPT 3.5、GPT-4 和 Claude 3 Opus 等。](https://github.com/paul-gauthier/aider)

- [exo：组建ai集群](https://github.com/exo-explore/exo)

- [smart-mermaid: 一款基于 AI 技术的 Web 应用程序，可将文本内容智能转换为 Mermaid 格式的代码，并将其渲染成可视化图表。](https://github.com/liujuntao123/smart-mermaid)

- [toon: 这是一种专为 LLM 提示词设计的数据序列化格式，比 JSON 节省 30-60% 的 Token。它融合了 YAML 和 CSV 的特点，紧凑且容易理解。官方提供了 TypeScript SDK 和命令行工具，能够轻松将 JSON 数据转换为 TOON 格式。](https://github.com/toon-format/toon)


- [aichat: All-in-one LLM CLI tool featuring Shell Assistant, Chat-REPL, RAG, AI Tools & Agents, with access to OpenAI, Claude, Gemini, Ollama, Groq, and more.](https://github.com/sigoden/aichat)

- [ai-credit: 开源的命令行工具，统计代码仓库里 AI 的贡献，支持多种 AI 混用的情况。](https://github.com/debugtheworldbot/ai-credit)

### 其他应用

- [auto-paper-digest: 自动从 arXiv 抓取每周的热门 AI 论文，通过 NotebookLM 生成视频讲解，并能发布到抖音。](https://github.com/brianxiadong/auto-paper-digest)

## Transformer

- [transformer-debugger](https://github.com/openai/transformer-debugger)

  - OpenAI 开源了一款用于分析小型语言模型内部行为的工具：Transformer Debugger (TDB)，它将自动可解释性技术与稀疏自动编码器相结合，无需写代码就能快速探索模型。基于 Transformer 的语言模型就像个黑盒，该项目可以解密 Transformer 的内部结构和预测行为。

## ai图片、视频

### 图片和视频理解

- [MiniCPM-V：只需8b参数的模型，就可以实现图片和视频理解，并宣称超越GPT-4V](https://github.com/OpenBMB/MiniCPM-V)

- [DeepSeek-VL2](https://github.com/deepseek-ai/DeepSeek-VL2)

  - 大型混合专家(MoE)视觉语言模型系列,显著改进了其前身DeepSeek-VL。
  - DeepSeek-VL2在各种任务中表现出色,包括但不限于视觉问答、光学字符识别、文档/表格/图表理解和视觉定位。

  - DeepSeek-VL2 没有找到对应的在线体验版本

  - 该模型系列包括三个变体:

    - DeepSeek-VL2-Tiny: 10亿 个激活参数
    - DeepSeek-VL2-Small： 28亿个激活参数
      - 需要80GB GPU内存才能使用
    - DeepSeek-VL2,45亿个激活参数

### 文字生成图片

- 性能

  - [Google Gemini 的图像能力测试](https://blog.roboflow.com/first-impressions-with-google-gemini/)

- [Janus-Pro和Janus-Flow：deepseek的多模态模型。既能理解图片，又能生成图片](https://github.com/deepseek-ai/Janus)

- [HunyuanDiT：腾讯的文生图](https://github.com/Tencent/HunyuanDiT)

- [Z-Image：阿里的](https://github.com/Tongyi-MAI/Z-Image)

- [flux](https://github.com/black-forest-labs/flux)

- 在线使用

    - [即梦：字节的](https://jimeng.jianying.com/ai-tool/home?ref=ai-bot.cn)

### 文字、图片生成视频

- [VBench：视觉模型性能排行榜](https://vchitect.github.io/VBench-project/)

- [（视频）秋芝2046：AI视频技巧集合！一口气全了解【小白速成】](https://www.bilibili.com/video/BV1HN1yY7EKD)
- [Wan2.1：阿里开源的](https://github.com/Wan-Video/Wan2.1)
    - [在线使用](https://tongyi.aliyun.com/wanxiang/videoCreation)

- [Open-Sora：生成图片或视频、图生视频、视频编辑](https://github.com/hpcaitech/Open-Sora)

  - [深入理解Sora技术原理｜得物技术](https://mp.weixin.qq.com/s/e1DqTa1Tgyi4OWpgwrj48Q)

- [混元视频：腾讯开源的](https://github.com/Tencent/HunyuanVideo)

  - [在线使用](https://aivideo.hunyuan.tencent.com)

- [Step-Video-T2V](https://github.com/stepfun-ai/Step-Video-T2V)

- [可灵AI：快手的](https://klingai.kuaishou.com/text-to-video/new)

- [goku：字节的](https://github.com/Saiyan-World/goku)

- [CogVideo：清华大学的](https://github.com/THUDM/CogVideo)

- [pika](https://pika.art/)

### 抠图、抠视频

- [ProPainter：通过ai移除物体（可以很好的去水印）](https://github.com/sczhou/ProPainter)

- SAM：对图片和视频一键抠图

  - [segment-anything：mata的sam](https://github.com/facebookresearch/segment-anything)

  - [segment-anything-2：mata的sam](https://github.com/facebookresearch/segment-anything-2)

### 图片、视频质量提升

- [dandere2x：使用waifu2x提升视频质量](https://github.com/akai-katto/dandere2x)

- [hitpaw：商业软件需要付费，不支持linux](https://www.hitpaw.tw/)

### ai视频剪辑

- [filmora：商业软件需要付费，不支持linux](https://filmora.wondershare.com/)

### ai生图生视频工作流

- [ComfyUI](https://github.com/comfyanonymous/ComfyUI)

## ai语音、音乐

- [UVR5：分离人声和背景音乐](https://github.com/Anjok07/ultimatevocalremovergui)

### 语音转文字

- [whisper：openai的模型](https://github.com/openai/whisper)

### 文字转语音

- [edge-tts：微软的模型](https://github.com/rany2/edge-tts)

- [Step-Audio](https://github.com/stepfun-ai/Step-Audio)

- [Spark-TTS](https://github.com/SparkAudio/Spark-TTS)

- [KrillinAI: 基于AI大模型的视频翻译和配音工具，专业级翻译，一键部署全流程，可以生成适配抖音，小红书，哔哩哔哩，视频号，TikTok，Youtube Shorts等形态的内容](https://github.com/krillinai/KrillinAI)

- [KittenTTS: State-of-the-art TTS model under 25MB 😻](https://github.com/KittenML/KittenTTS)

### ai作曲（文字生成音乐、图片生成音乐）

- [Suno](https://suno.com/)

- [天谱乐：国产版Suno](https://tianpuyue.cn/)

- [YuE：开源的全曲音乐生成模型，类似于 Suno.ai](https://github.com/multimodal-art-projection/YuE)

- [InspireMusic：阿里的](https://github.com/FunAudioLLM/InspireMusic)

- [SongGeneration: 腾讯的](https://github.com/tencent-ailab/SongGeneration)

### ai声音克隆（tts），可以实现让电影里的演员的英文配音变成国语

- [VibeVoice: 微软的](https://github.com/microsoft/VibeVoice)

- [index-tts: b站的模型](https://github.com/index-tts/index-tts)

- [GPT-SoVITS: 1 min voice data can also be used to train a good TTS model! (few shot voice cloning)](https://github.com/RVC-Boss/GPT-SoVITS)
    - [花儿不哭：项目作者](https://space.bilibili.com/5760446?spm_id_from=333.788.upinfo.detail.click)
- [chatterbox: SoTA open-source TTS](https://github.com/resemble-ai/chatterbox)

## ai数字人

- [InfiniteTalk: Unlimited-length talking video generation that supports image-to-video and video-to-video generation](https://github.com/MeiGen-AI/InfiniteTalk)

## ai ocr

- [chandra: OCR model that handles complex tables, forms, handwriting with full layout.](https://github.com/datalab-to/chandra)

- [DeepSeek-OCR: Contexts Optical Compression](https://github.com/deepseek-ai/DeepSeek-OCR)

## ai翻译

- [MTranServer：离线翻译服务器](https://github.com/xxnuo/MTranServer)

- [firefox-translations-models：firefox社区的翻译模型](https://github.com/mozilla/firefox-translations-models)

## ai编程语言

- [Mojo：面向 AI 的编程语言](https://github.com/modularml/mojo)

  - 目标是提供python的易用性，c语言的性能

  - 创始人chris lattner是swift语言和llvm项目的发起者

## ai操作系统

- [AIOS：LLM 代理操作系统](https://github.com/agiresearch/AIOS)
  - 将大语言模型嵌入到操作系统中，使操作系统“有灵魂”。旨在优化资源分配，促进跨代理的上下文切换，实现代理的并发执行，为代理提供工具服务，维护代理的访问控制。

## ai自动化点击

### [OmniParser：微软开发的对屏幕快速截图并转换成结构化数据](https://github.com/microsoft/OmniParser)

- [（视频）AI超元域：🚀本地部署OmniParser v2.0与pyautogui真正实现自动化点击！支持macOS、Windows与Linux！轻松实现自动化操作电脑](https://www.bilibili.com/video/BV1u3AaeqEtm)

- 配合pyautogui可以实现自动化点击

### ai浏览器

- [ChatGPT Atlas：openai 的ai浏览器。基于 Chromium 内核构建，并把 ChatGPT 嵌入了浏览器的主页、侧边栏以及任意输入框中](https://chatgpt.com/zh-Hans-CN/atlas/)

- [Comet Browser: Perplexity AI推出的Comet](https://www.perplexity.ai/comet)

- [（视频）AI超元域：取代ChatGPT Operator！支持DeepSeek+Web UI！Browser Use最强AI驱动的浏览器自动化框架，Roo Code轻松实现MCP](https://www.bilibili.com/video/BV1CXPCecEUk)

- [browser-use：没有ui界面，依靠代码操作浏览器](https://github.com/browser-use/browser-use)

- [web-ui：有ui界面操作浏览器](https://github.com/browser-use/web-ui)

  ```sh
  git clone https://github.com/browser-use/web-ui.git
  cd web-ui
  uv venv --python 3.11
  source .venv/bin/activate
  uv pip install -r requirements.txt
  pip install playwright
  playwright install
  cp .env.example .env
  # 修改.env文件设置api（如deepseek的api）
  # 启动
  python webui.py --ip 127.0.0.1 --port 7788
  ```

- [nanobrowser：一个开源的 Chrome 插件，基于 AI 大模型，使用自然语言操纵浏览器，可以看作 OpenAI Operator 的替代品。](https://github.com/nanobrowser/nanobrowser)

- [BrowserMCP: 用 AI 自动化浏览器](https://browsermcp.io/)

- [dia：原生ai浏览器](https://www.diabrowser.com/)

- [opendia: 浏览器插件，通过大模型控制浏览器。支持本地大模型](https://github.com/aaronjmars/opendia)

- [BrowserOS: 开源的 AI 浏览器。该项目是基于 Chromium 的开源 AI 浏览器，能够在本地浏览器中运行 AI Agents，可作为 ChatGPT Atlas、Perplexity Comet 和 Dia 的开源替代方案。在保留 Chrome 熟悉界面与扩展兼容性的同时，帮助用户实现 AI 驱动的浏览器自动化与智能问答任务，并支持自定义 LLM 服务或本地大模型。](https://github.com/browseros-ai/BrowserOS)

- [vibium: 一个二进制文件通过ai agent和mcp服务器自动化操作浏览器。由著名python项目selenium作者开发](https://github.com/VibiumDev/vibium)

- [Tabbit 浏览器 - AI 智能浏览器](https://www.tabbit-ai.com/)

## ai搜索

- [scira：原名为MiniPerplx](https://github.com/zaidmukaddam/scira)

- 在线使用
  - [perplexity](https://www.perplexity.ai/)

## ai编程，代码补全

- [（视频）技术爬爬虾：Cursor太贵？分享三个免费AI编程方案+使用技巧【如何看待AI编程】](https://www.bilibili.com/video/BV1b5AeeGEFc)

- [CodeGeeX4：清华大学的模型](https://github.com/THUDM/CodeGeeX4)

- [fittencode：清华大学的ai补全](https://code.fittentech.com/)

- [amazon q：支持vscode，不支持neovim](https://aws.amazon.com/cn/q/developer/)

- [阿里的通义灵码：支持Qwen2.5、DeepSeek-V3、DeepSeek-R1模型](https://lingma.aliyun.com/lingma/)

- [marscode：字节的豆包模型](https://www.marscode.com/)

- [augmentcode：微软和谷歌的工程师离职开发的](https://www.augmentcode.com/)

## ai为github代码仓库生成wiki

- [Code Wiki: google的](https://codewiki.google/)

## ai知识库

- [notebooklm：google的。可以在线使用](https://notebooklm.google/)

- [open-notebook: 开源版notebooklm](https://github.com/lfnovo/open-notebook)

- [ima：腾讯的。可以在线使用](https://ima.qq.com/)

## ai编辑器

- [codeium的windsurf](https://codeium.com/windsurf)

- [cursor：基于vscode的ai编辑器](https://github.com/getcursor/cursor)

    - [cursor-tools](https://github.com/eastlondoner/cursor-tools)
    - [cursor-free-vip:免费享受 Pro 版](https://github.com/yeongpin/cursor-free-vip)
- [cline: Autonomous coding agent right in your IDE, capable of creating/editing files, executing commands, using the browser, and more with your permission every step of the way.](https://github.com/cline/cline)

- [void： Cursor 的开源平替](https://github.com/voideditor/void)

- [firebase：谷歌开发的](https://studio.firebase.google.com/?hl=zh-cn)

- [Google Antigravity:谷歌开发的](https://antigravity.google/)

- [aide：ai编辑器](https://github.com/codestoryai/aide)

- [we0](https://github.com/we0-dev/we0)

- [trae：字节跳动的基于vscode的ai编辑器。不支持linux](https://www.trae.ai/)

- [Qoder：阿里的](https://caug.cn/)

## ai程序员

- [devika：Devin 的开源替代品](https://github.com/stitionai/devika)

## ai终端

- [warp：自带ai的termianl](https://github.com/warpdotdev/Warp)

- [codex: openai的](https://github.com/openai/codex?tab=Apache-2.0-1-ov-file)

- [claude-code: 终端里的 Claude 编码助手。该项目是 Claude 官方开源的 AI 编码助手，集成于终端内，能够理解整个代码库，并通过简单的自然语言命令，帮助开发者更高效地完成各类编码任务。](https://github.com/anthropics/claude-code)

    - [Claude-Code-Usage-Monitor: Claude 用量实时监控助手。这是一个用于实时监控和记录开发者在使用 Claude AI 时产生的 Token 用量及费用的工具，支持用量统计、预算告警和套餐设置等功能。](https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor)

    - [claudish: Claude Code. Any Model. The most powerful AI coding agent now speaks every language.](https://github.com/MadAppGang/claudish)
    - [Trellis: Claude Code & Cursor（兼容 Cursor/Opencode）的一个辅助工具，可以注入上下文、开启并行任务等](https://github.com/mindfold-ai/Trellis)

    - [WellAlly-health: 一个基于 Claude Code 的个人医疗数据中心，定义了一组自己的命令和技能，用 AI 分析个人医疗数据（体检报告、影像片子、处方单、出院小结）](https://github.com/huifer/WellAlly-health)

- [gemini-cli: 谷歌 Gemini 命令行工具。该项目是 Gemini 官方开源的命令行工具，将 Google Gemini 的强大能力集成到终端环境。它基于百万级上下文，能够理解大型代码库的架构和逻辑，支持多模态输入输出、Google 搜索以及 MCP 等功能。](https://github.com/google-gemini/gemini-cli)

    - [Gemini CLI extensions](https://geminicli.com/extensions/)

    - [gemini-cli-tips: Gemini CLI 使用指南](https://github.com/addyosmani/gemini-cli-tips)

- [copilot-cli: GitHub Copilot CLI brings the power of Copilot coding agent directly to your terminal.](https://github.com/github/copilot-cli)

- [QwenLM/qwen-code: 阿里的code](https://github.com/QwenLM/qwen-code)

- codebuddy：腾讯的code

    ```sh
    # 安装
    npm install -g @tencent-ai/codebuddy-code
    ```

- [GLM-4.5: 智谱的](https://github.com/zai-org/GLM-4.5)

- [Seed-Coder: 字节的豆包](https://github.com/ByteDance-Seed/Seed-Coder)
    - [国产大模型接入 Claude Code 教程：以 Doubao-Seed-Code 为例](https://mp.weixin.qq.com/s/ptRFIddHT3eLLmQVPzOx_g)

- [iflow-cli: 国产的claude code。还有手机版](https://github.com/iflow-ai/iflow-cli)

- [Chaterm:带有 AI 功能的智能终端工具，可以用自然语言完成命令行操作。 Open source AI terminal and SSH Client for EC2, Database and Kubernetes.](https://github.com/chaterm/Chaterm)

- [crush: The glamourous AI coding agent for your favourite terminal 💘](https://github.com/charmbracelet/crush)
- [vibe-kanban: 集成claude code等终端，可以执行多个任务，因此不需要像claude code那样光等着ai执行，并且每个任务还是在git worktree下执行](https://github.com/BloopAI/vibe-kanban)

- [openclaw: Your own personal AI assistant. Any OS. Any Platform. The lobster way. 🦞](https://github.com/openclaw/openclaw)

- [zeroclaw: rust版openclaw的 Agent 框架](https://github.com/zeroclaw-labs/zeroclaw)
- [openfang: rust版openclaw的 Agent 操作系统。比zeroclaw功能更完善](https://github.com/RightNow-AI/openfang)

- [nanobot: 轻量版OpenClaw](https://github.com/HKUDS/nanobot)

- [openwork: Claude Cowork的平替开源版](https://github.com/different-ai/openwork)
- [GitNexus: 无论是 Cursor 还是 Claude Code，都已经成了不少开发者每天必开的开发利器。然而，用 AI 写代码最怕遇到的是，刚修好了一个 Bug，却在意想不到的角落引爆了三个新 Bug。它能把整个代码库在本地嚼碎，将每一个依赖项、调用链条和工作流程都梳理得明明白白。接着通过极其聪明的检索机制，让 AI 真正读懂底层逻辑，不再漏掉关键上下文。](https://github.com/abhigyanpatwari/GitNexus)

## ai数据库终端

- [aliyun/rdsai-cli: RDSAI CLI is a next-generation, AI-powered RDS CLI that transforms how you interact with the databasea](https://github.com/aliyun/rdsai-cli)
    - [RDSAI-CLI - 用AI重塑数据库终端CLI体验](https://mp.weixin.qq.com/s/5Vn-D52xMMoNwQtNwb_dMg)

- [pg-aiguide: MCP server and Claude plugin for Postgres skills and documentation. Helps AI coding tools generate better PostgreSQL code.](https://github.com/timescale/pg-aiguide)

## ai爬虫和信息提取

- [后裔采集器](https://www.houyicaiji.com/)

- [wiseflow：从网站/公众号/RSS等提取简洁的信息](https://github.com/TeamWiseFlow/wiseflow)

## ai可视化

- [data-formulator：微软的](https://github.com/microsoft/data-formulator)
## ai金融模型

- [Kronos: 清华大学开发的](https://github.com/shiyu-coder/Kronos)

## ai控制手机

- [droidrun：通过大模型，以自然语言操作安卓手机的 APP](https://github.com/droidrun/droidrun)


- [Open-AutoGLM: 智谱的手机端智能助理框架](https://github.com/zai-org/Open-AutoGLM)

## ai agent（智能体）

- [awesome-ai-agents: A list of AI autonomous agents](https://github.com/e2b-dev/awesome-ai-agents)

- [500-AI-Agents-Projects: AI Agent 合集](https://github.com/ashishpatel26/500-AI-Agents-Projects)

- [n8n: 自动化工作流](https://github.com/n8n-io/n8n)

- [n8n-workflows:该项目收集了 2000+ 高质量、开箱即用的 n8n 自动工作流模板，涵盖官方示例、社区精华和用户实用场景。它内置一个基于 FastAPI 的本地搜索服务，支持全文搜索、分类筛选和 Mermaid 可视化展示，可一键下载 JSON 文件，方便导入你的 n8n 实例。](https://github.com/Zie619/n8n-workflows)

- [coze-studio（扣子）: 字节code的开源版](https://github.com/coze-dev/coze-studio)

- [dify: Production-ready platform for agentic workflow development.](https://github.com/langgenius/dify)

- [OpenManus：manus的开源版](https://github.com/mannaandpoem/OpenManus)

- [autogen：微软的智能体框架](https://github.com/microsoft/autogen)

- [langgraph](https://github.com/langchain-ai/langgraph)
  - [agent-service-toolkit：用 Python 快速搭建和运行基于 LangGraph 框架的 AI 代理服务。它结合 FastAPI、Streamlit 和 Pydantic 等技术栈，提供了用户界面、自定义 Agent、流式传输等功能，并集成了内容审核（LlamaGuard）和用户反馈机制（LangSmith），极大地简化了 AI Agent 应用的开发和优化过程。](https://github.com/JoshuaC215/agent-service-toolkit)

- [A2UI：google开发的让agent生成ui来回答](https://github.com/google/A2UI)

### 在线使用

- [Dify](https://cloud.dify.ai/apps)

- [refly](https://refly.ai/)

- [coze（扣子）：国际版。字节跳动的平台，其实就是火山引擎。自定义gpt机器人，可以集成到telegram和discord](https://www.coze.com/home)
- [coze（扣子）：国内版](https://www.coze.cn/home)

- dify vs coze：经过我个人的测试dify的知识库检索质量比coze要好很多

## MCP

- [microsoft/mcp-for-beginners: 微软mcp教程](https://github.com/microsoft/mcp-for-beginners)

- [awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)

- [Claude MCP 服务器目录](https://www.claudemcp.com/zh/servers)

- [git-mcp: 让 AI 理解 GitHub 项目](https://github.com/idosal/git-mcp)

- [chrome-devtools-mcp: AI 与 Chrome 浏览器之间的桥梁。该项目是 Chrome DevTools 团队开源的官方 MCP 服务实现，将 Chrome DevTools 的能力以 MCP 工具的形式提供给 AI 编程助手，支持自动化操作、调试和性能分析。](https://github.com/ChromeDevTools/chrome-devtools-mcp)


## [A2A](https://github.com/google/A2A)

## Claude skill

- [awesome-claude-skills: A curated list of awesome Claude Skills, resources, and tools for customizing Claude AI workflows](https://github.com/ComposioHQ/awesome-claude-skills)

# 在线ai工具

- [chat-pdf](https://damngood.tools/tools/chat-pdf)
- [chatdoc：对pdf、eppub、md文件进行总结](https://chatdoc.com/)

# 获取最新ai新闻

- 阿里云云栖号的一周AI大事件

# 类似项目

- [awesome-vibe-coding: A curated list of vibe coding references, collaborating with AI to write code.](https://github.com/filipecalegario/awesome-vibe-coding)

- [vibe-coding-cn](https://github.com/2025Emma/vibe-coding-cn)

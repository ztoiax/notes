<!-- mtoc-start -->

* [思想](#思想)
* [技术](#技术)
  * [Mojo：面向 AI 的编程语言](#mojo面向-ai-的编程语言)
  * [LLM](#llm)
    * [原理](#原理)
    * [在线模型](#在线模型)
    * [使用](#使用)
    * [商业](#商业)
* [项目](#项目)
  * [LLM](#llm-1)
    * [prompt提示词](#prompt提示词)
    * [RAG框架](#rag框架)
  * [Transformer](#transformer)
  * [ai编程，代码生成和代码补全](#ai编程代码生成和代码补全)
  * [图片与视频等多媒体相关](#图片与视频等多媒体相关)
    * [图片和视频理解](#图片和视频理解)
    * [文生成图片](#文生成图片)
    * [文生成视频](#文生成视频)
  * [SAM](#sam)
  * [图片视频](#图片视频)
  * [语音转文字](#语音转文字)
* [文字传语音](#文字传语音)
  * [操作系统](#操作系统)
  * [ai程序员](#ai程序员)
* [ai测试](#ai测试)
* [在线ai工具](#在线ai工具)

<!-- mtoc-end -->

# 思想

- [Sam Altman：Moore's Law for Everything](https://moores.samaltman.com/)

- [演讲实录 | CAAI常务理事焦李成院士——物理学启发的人工智能：思考与挑战]()

# 技术

## [Mojo：面向 AI 的编程语言](https://github.com/modularml/mojo)

- 目标是提供python的易用性，c语言的性能

- 创始人chris lattner是swift语言和llvm项目的发起者

## LLM

- [chatbot-arena-leaderboard：LLM性能排行](https://lmsys-chatbot-arena-leaderboard.hf.space/)

- [ZeroEval：LLM性能排行](https://github.com/yuchenlin/ZeroEval)

### 原理

- [llm-course](https://github.com/mlabonne/llm-course)

- [llm-viz：3D 可视化 GPT 大语言模型。](https://bbycroft.net/llm)

- [wolfram作者：What Is ChatGPT Doing … and Why Does It Work?](https://writings.stephenwolfram.com/2023/02/what-is-chatgpt-doing-and-why-does-it-work/)

- [腾讯技术工程：一文带你了解大模型——智能体（Agent）](https://mp.weixin.qq.com/s/oMIPPgHjvJDyf98K9yNQbQ)

- [腾讯云开发者：一文搞懂大模型！基础知识、 LLM 应用、 RAG 、 Agent 与未来发展](https://mp.weixin.qq.com/s/groI097gj0w7XMHIy3eERA)

### 在线模型

- [LLM Pricing：AI 模型价格对比和试用链接](https://llmpricecheck.com/)

- [chatgpt](https://chat.openai.com/)

- [copilot：微软的gpt](https://copilot.microsoft.com/)

- [gemini：谷歌的gpt](https://gemini.google.com/)

- [meta.ai：Meta 公司发布自家的 AI 服务，免费使用，基于 Llama 3 模型，可以"文生文"和"文生图"](https://www.meta.ai/)

- [llama.dev：Meta 公司还有一个专门的 Llama 聊天网站，可以选择该模型的不同版本。](https://llama3.dev/)

- [DuckDuckGo 推出的免费 AI 聊天，底层是 GPT-3.5 Turbo 和 Claude 1.2](https://duckduckgo.com/?q=DuckDuckGo&ia=chat)

- [coze：自定义gpt机器人，可以集成到telegram和discord](https://www.coze.com/home)

- 国产
    - [kimi](https://kimi.moonshot.cn/chat)
    - [智谱清言](https://chatglm.cn/main/)

### 使用

- [腾讯技术工程：如何与ChatGPT4结对编程提升研发效率](https://www.163.com/dy/article/I13L6MEP0518R7MO.html)

- [腾讯云开发者：GPT4结对编程实战，鹅厂一线研发真实使用感受](https://cloud.tencent.com/developer/article/2285573)

- [腾讯云开发者：我用低代码结合ChatGPT开发，每天多出1小时摸鱼](https://cloud.tencent.com/developer/article/2294350)

- [铭毅天下Elasticsearch：吴恩达 x Open AI ChatGPT ——如何写出好的提示词视频核心笔记](https://mp.weixin.qq.com/s/VkLNKRtN7KR3Gjttk1cpPg)

### 商业

- [新职业|我用GPT给电子厂带货](https://t.cj.sina.com.cn/articles/view/6286736254/176b7fb7e01901df3u?display=0&retcode=0)

# 项目

## LLM

- OpenAI 的工程师，著名“文生图”模型 DALL-E 的第一作者 James Betker 的观点：模型不是关键，语料才是关键。

    - 不需要说，你的模型多新颖、多强大，只需要告诉我，你用什么语料训练模型。

        - 模型完美，但是语料垃圾，一样不行
        - 反之，模型很平常，但是语料足够，那就 OK。

    - 当你谈论 Lambda、ChatGPT、Bard 或Claude 时，指的并不是它们的模型，而是它们的语料集。

    - 这告诉我们两点启示：

        - 1.哪一家公司的语料的数量多、质量好，它的模型就会强于其他公司。
        - 2.开源模型完全可以替代闭源模型，前提是训练语料要足够。

- [畅游 LLM 的世界（英文）](https://www.bentoml.com/blog/navigating-the-world-of-large-language-models)
    - 如果在家用电脑上安装 LLM（大型语言模型），应该选择哪一个模型？
    - 本文分析并评价了目前最流行的几个 LLM 的基本情况和优缺点。

- [awesome-LLMs-In-China](https://github.com/wgwang/awesome-LLMs-In-China)
- [llama：facebook的llm](https://github.com/ggerganov/llama.cpp)

    - [llama配置要求](http://www.bimant.com/blog/llama-consumer-hardware-requirements/)
    - [Llama2-Chinese：Llama中文社区](https://github.com/LlamaFamily/Llama-Chinese)
- [llama：facebook2024年的llm](https://github.com/meta-llama/llama3)
    - [llama3-chinese：以Meta-Llama-3-8B为底座，使用 DORA + LORA+ 的训练方法，在50w高质量中文多轮SFT数据 + 10w英文多轮SFT数据 + 2000单轮自我认知数据训练而来的大模型。](https://github.com/seanzhang-zhichen/llama3-chinese)

- [Gemma：google的llm](https://github.com/google-deepmind/gemma)

- [ChatGLM-6B：清华大学的llm](https://github.com/THUDM/ChatGLM-6B)
- [ChatGLM2-6B：清华大学的llm](https://github.com/THUDM/ChatGLM2-6B)
- [ChatGLM3：清华大学和智谱合作的llm](https://github.com/THUDM/ChatGLM3)

- [Grok-1：马斯克的 xAI 公司开源的 314B 参数、MoE（混合专家模型）的大型语言模型](https://github.com/xai-org/grok-1)

- [corenet：苹果手机端大模型](https://github.com/apple/corenet)

- [ChatPilot：支持Google搜索、文件网址对话（RAG）、代码解释器功能，复现了Kimi Chat(文件，拖进来；网址，发出来)](https://github.com/shibing624/ChatPilot)


- [LaWGPT：在通用中文基座模型（如 Chinese-LLaMA、ChatGLM 等）的基础上扩充法律领域专有词表、大规模中文法律语料预训练](https://github.com/pengxiao-song/LaWGPT)

- [DB-GPT（部署数据库交互llm。防止数据隐私上传平台）](https://github.com/eosphoros-ai/DB-GPT)

- [llm-course：免费的 LLM 课程，包含面向新手入门 LLM 的基础知识，面向程序员和科学家的 LLMs 产品和部署 LLM 应用的知识和笔记。](https://github.com/mlabonne/llm-course)

- [nanoGPT：是用于训练/微调中等规模 GPT 模型的库。它是对 minGPT 的重写](https://github.com/karpathy/nanoGPT)

- [llm.c：1k 行的 C 代码就完成了 GPT-2 模型的训练，代码纯手撸、不依赖任何机器学习框架。](https://github.com/karpathy/llm.c)

    - 教学意义大于实用价值

    - 作者曾就职于特斯拉的自动驾驶部门负责人、OpenAI 的创始成员。

- [storm](https://github.com/stanford-oval/storm)这是一个基于 LLM 的应用，可通过搜集网上的内容，从零编写类似维基百科的文章。使用者仅需提出问题，它便会上网收集资料并生成大纲，然后根据大纲和参考文献进行创作，生成的文章质量欠佳，还需要人为修改后才可以发布。

### prompt提示词

- [awesome-chatgpt-prompts](https://github.com/f/awesome-chatgpt-prompts)

- [腾讯云开发者：我问了鹅厂程序员：你们工作中怎么用ChatGPT？如何高效Prompt？](https://blog.csdn.net/QcloudCommunity/article/details/130143855)

- [腾讯云开发者：一文掌握Prompt：万能框架+优化技巧+常用指标](https://mp.weixin.qq.com/s/oKB8m_wX6p8SHNMx1R_hzw)

### RAG框架

- [RAG_Techniques：检索增强生成（RAG）教程集合。该项目提供了 20 多种先进的 RAG 技术教程，包含实现指南和示例代码，并定期更新。内容涵盖检索查询、上下文增强、融合检索（Fusion Retrieval）、分层索引、上下文压缩、知识图谱整合等多种 RAG 技术。](https://github.com/NirDiamant/RAG_Techniques)

- [graphrag：微软RAG框架](https://github.com/microsoft/graphrag)

## Transformer

- [transformer-debugger](https://github.com/openai/transformer-debugger)

    - OpenAI 开源了一款用于分析小型语言模型内部行为的工具：Transformer Debugger (TDB)，它将自动可解释性技术与稀疏自动编码器相结合，无需写代码就能快速探索模型。基于 Transformer 的语言模型就像个黑盒，该项目可以解密 Transfomer 的内部结构和预测行为。

## ai编程，代码生成和代码补全

- [CodeGeeX4：清华大学的模型](https://github.com/THUDM/CodeGeeX4)

## 图片与视频等多媒体相关

### 图片和视频理解

- [MiniCPM-V：只需8b参数的模型，就可以实现图片和视频理解，并宣称超越GPT-4V](https://github.com/OpenBMB/MiniCPM-V)

### 文生成图片

- [HunyuanDiT：腾讯的文生图](https://github.com/Tencent/HunyuanDiT)

### 文生成视频

- [Open-Sora：生成图片或视频、图生视频、视频编辑](https://github.com/hpcaitech/Open-Sora)

- [可灵AI：快手的](https://klingai.kuaishou.com/text-to-video/new)

- [CogVideo：清华大学的](https://github.com/THUDM/CogVideo)

## SAM

- 对图片和视频一键抠图

- [segment-anything：mata的sam](https://github.com/facebookresearch/segment-anything)

- [segment-anything-2：mata的sam](https://github.com/facebookresearch/segment-anything-2)

## 图片视频

- [dandere2x：使用waifu2x提升视频质量](https://github.com/akai-katto/dandere2x)

- [ProPainter：通过ai移除物体（可以很好的去水印）](https://github.com/sczhou/ProPainter)

- [UVR5：分离人声和背景音乐](https://github.com/Anjok07/ultimatevocalremovergui)

## 语音转文字

- [whisper：openai的模型](https://github.com/openai/whisper)

# 文字传语音

- [edge-tts：微软的模型](https://github.com/rany2/edge-tts)

## 操作系统

- [AIOS：LLM 代理操作系统](https://github.com/agiresearch/AIOS)
    - 将大语言模型嵌入到操作系统中，使操作系统“有灵魂”。旨在优化资源分配，促进跨代理的上下文切换，实现代理的并发执行，为代理提供工具服务，维护代理的访问控制。

## ai程序员

- [devika：Devin 的开源替代品](https://github.com/stitionai/devika)

# ai测试

- [Google Gemini 的图像能力测试](https://blog.roboflow.com/first-impressions-with-google-gemini/)

# 在线ai工具

- [awesome-chatgpt](https://github.com/sindresorhus/awesome-chatgpt)
- [chat-pdf](https://damngood.tools/tools/chat-pdf)
- [chatdoc：对pdf、eppub、md文件进行总结](https://chatdoc.com/)

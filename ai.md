<!-- mtoc-start -->

* [思想](#思想)
* [技术](#技术)
  * [Mojo：面向 AI 的编程语言](#mojo面向-ai-的编程语言)
  * [LLM](#llm)
    * [原理](#原理)
    * [使用](#使用)
    * [商业](#商业)
    * [项目](#项目)
      * [在线模型](#在线模型)
    * [prompt提示词](#prompt提示词)
    * [RAG框架](#rag框架)
    * [有趣的文章、访谈](#有趣的文章访谈)
      * [OpenAI工程师：模型不是关键，语料才是关键。](#openai工程师模型不是关键语料才是关键)
      * [2024年llm总结Things we learned about LLMs in 2024](#2024年llm总结things-we-learned-about-llms-in-2024)
      * [DeepSeek模型作者的访谈](#deepseek模型作者的访谈)
* [ai项目](#ai项目)
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

### 原理

- [llm-course](https://github.com/mlabonne/llm-course)

- [llm-viz：3D 可视化 GPT 大语言模型。](https://bbycroft.net/llm)

- [wolfram作者：What Is ChatGPT Doing … and Why Does It Work?](https://writings.stephenwolfram.com/2023/02/what-is-chatgpt-doing-and-why-does-it-work/)

- [腾讯技术工程：一文带你了解大模型——智能体（Agent）](https://mp.weixin.qq.com/s/oMIPPgHjvJDyf98K9yNQbQ)

- [腾讯云开发者：一文搞懂大模型！基础知识、 LLM 应用、 RAG 、 Agent 与未来发展](https://mp.weixin.qq.com/s/groI097gj0w7XMHIy3eERA)

### 使用

- [畅游 LLM 的世界（英文）](https://www.bentoml.com/blog/navigating-the-world-of-large-language-models)
    - 如果在家用电脑上安装 LLM（大型语言模型），应该选择哪一个模型？
    - 本文分析并评价了目前最流行的几个 LLM 的基本情况和优缺点。

- [腾讯技术工程：如何与ChatGPT4结对编程提升研发效率](https://www.163.com/dy/article/I13L6MEP0518R7MO.html)

- [腾讯云开发者：GPT4结对编程实战，鹅厂一线研发真实使用感受](https://cloud.tencent.com/developer/article/2285573)

- [腾讯云开发者：我用低代码结合ChatGPT开发，每天多出1小时摸鱼](https://cloud.tencent.com/developer/article/2294350)

- [铭毅天下Elasticsearch：吴恩达 x Open AI ChatGPT ——如何写出好的提示词视频核心笔记](https://mp.weixin.qq.com/s/VkLNKRtN7KR3Gjttk1cpPg)

### 商业

- [新职业|我用GPT给电子厂带货](https://t.cj.sina.com.cn/articles/view/6286736254/176b7fb7e01901df3u?display=0&retcode=0)

### 项目

- LLM性能排行

    - [chatbot-arena-leaderboard](https://lmarena.ai/?leaderboard)

    - [ZeroEval](https://huggingface.co/spaces/allenai/ZeroEval)

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

- [DeepSeek-V3：在中国大模型市场掀起了第一场价格战，因而被网友称为 AI 界的“拼多多”。](https://github.com/deepseek-ai/DeepSeek-V3)

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
#### 在线模型

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

- 多个模型聚合
    - [ithy：同时返回 Lllma 3.1、o1-mini、Sonnet 3.5、Grok 2、Gemini 1.5 pro 的生成结果。](https://ithy.com/)

- 提示生成 App
    - [DeepSeek Coder：基于 DeepSeek V3 模型](https://deepbolt.xyz/)

### prompt提示词

- [awesome-chatgpt-prompts](https://github.com/f/awesome-chatgpt-prompts)

- [腾讯云开发者：我问了鹅厂程序员：你们工作中怎么用ChatGPT？如何高效Prompt？](https://blog.csdn.net/QcloudCommunity/article/details/130143855)

- [腾讯云开发者：一文掌握Prompt：万能框架+优化技巧+常用指标](https://mp.weixin.qq.com/s/oKB8m_wX6p8SHNMx1R_hzw)

### RAG框架

- [RAG_Techniques：检索增强生成（RAG）教程集合。该项目提供了 20 多种先进的 RAG 技术教程，包含实现指南和示例代码，并定期更新。内容涵盖检索查询、上下文增强、融合检索（Fusion Retrieval）、分层索引、上下文压缩、知识图谱整合等多种 RAG 技术。](https://github.com/NirDiamant/RAG_Techniques)

- [graphrag：微软RAG框架](https://github.com/microsoft/graphrag)

### 有趣的文章、访谈

#### OpenAI工程师：模型不是关键，语料才是关键。

- OpenAI 的工程师，著名“文生图”模型 DALL-E 的第一作者 James Betker 的观点：模型不是关键，语料才是关键。

    - 不需要说，你的模型多新颖、多强大，只需要告诉我，你用什么语料训练模型。

        - 模型完美，但是语料垃圾，一样不行
        - 反之，模型很平常，但是语料足够，那就 OK。

    - 当你谈论 Lambda、ChatGPT、Bard 或Claude 时，指的并不是它们的模型，而是它们的语料集。

    - 这告诉我们两点启示：

        - 1.哪一家公司的语料的数量多、质量好，它的模型就会强于其他公司。
        - 2.开源模型完全可以替代闭源模型，前提是训练语料要足够。

#### 2024年llm总结[Things we learned about LLMs in 2024](https://simonwillison.net/2024/Dec/31/llms-in-2024/)

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

#### DeepSeek模型作者的访谈

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

- [深入理解Sora技术原理｜得物技术](https://mp.weixin.qq.com/s/e1DqTa1Tgyi4OWpgwrj48Q)

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

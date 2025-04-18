---
id: architecture
aliases: []
tags: []
---

<!-- mtoc-start -->

* [体系结构](#体系结构)
* [cpu](#cpu)
  * [性能排行榜](#性能排行榜)
  * [RISC-V](#risc-v)
  * [国产cpu](#国产cpu)
* [GPU](#gpu)
  * [原理](#原理)
  * [cuda](#cuda)
* [RDMA](#rdma)
* [FPGA](#fpga)

<!-- mtoc-end -->

# 体系结构

- [两大图灵奖得主力作：计算机架构的新黄金时代](https://zhuanlan.zhihu.com/p/477346109)

- [包云岗：多核之后，CPU 的发展方向是什么？](https://www.zhihu.com/question/20809971/answer/1678502542)

- DSA（Domain-Specific Architectures，特定领域的体系结构）

  - 登纳德缩放定律结束、摩尔定律衰退，而阿姆达尔定律正当其时，这意味着低效性将每年的性能改进限制在几个百分点。
    ![image](./Pictures/architecture/Moore's-law-整型程序的性能提升.avif)

  - DSA 受益于以特定领域语言（DSL）编写的程序，可以实现更高的并行性，更好的利用缓存（程序可以控制运动的存储器层次）

    - DSA例子：

            | DSA                      |
            |--------------------------|
            | GPU                      |
            | 深度学习的神经网络处理器 |
            | 软件定义处理器（SDN）    |

      - 谷歌的TPU 自 2015 年投入生产，它从搜索引擎到语言翻译和图像识别支持着谷歌各种各样的业务，同时也支持着 AlphaGo 和 AlphaZero 等 DeepMind 前沿研究。

      - 微软在其数据中心里部署了现场可编程门阵列器件（FPGA），专用于神经网络应用，对必应（Bing）搜索引擎的文件排名运算进行了硬件加速，得到了高达95%的吞吐量提升。

      - 通用任务的 CPU 通常支持 32 和 64 位整型数和浮点数数据。对于很多机器学习和图像应用来说，这种准确率有点浪费了。例如在深度神经网络中（DNN），推理通常使用 4、8 或 16 位整型数，从而提高数据和计算吞吐量。同样，对于 DNN 训练程序，浮点数很有意义，但 32 位就够了，16 为经常也能用。

    - DSL例子：

            | DSL                             |
            |---------------------------------|
            | 矩阵运算的语言 Matlab           |
            | DNN 编程的数据流语言 TensorFlow |
            | 编程 SDN 的语言 P4              |

- 几个定律：

  - 摩尔定律（Moore's Law）：摩尔（Gordon Moore）在 1965 年的最初预测中，称晶体管密度会每年翻一番；1975 年，他又预计每两年翻一番。

    - 在 2000 年左右开始放缓。到了 2018 年，根据摩尔定律得出的预测与当下实际能力差了 15 倍。根据当前预测，这一差距将持续拉大，因为 CMOS 技术方法已经接近极限。
      ![image](./Pictures/architecture/Moore's-law.avif)

    - 摩尔定律并未死，只是不断放缓。但一个问题是这些晶体管都被充分用起来了吗？最近MIT团队在《Science》上发表了一篇文章《There’s plenty of room at the Top: What will drive computer performance after Moore’s law?》，给出他们的答案：显然没有！
      - MIT团队开展的一个小实验：假设用Python实现一个矩阵乘法的性能是1，那么用C语言重写后性能可以提高50倍，如果再充分挖掘体系结构特性（如循环并行化、访存优化、SIMD等），那么性能甚至可以提高63000倍。然而，真正能如此深入理解体系结构、写出这种极致性能的程序员绝对是凤毛麟角。
        ![image](./Pictures/architecture/Moore's-law-mit团队.avif)

  - 登纳德缩放定律（Dennard scaling）：随着晶体管密度的增加，晶体管不断变小，但芯片的功率密度不变。由于每平方毫米硅芯片的计算能力随着技术的迭代而不断增强，计算机将变得更加节能。然而，登纳德缩放定律从 2007 年开始大幅放缓，2012 年左右接近失效

    - 每个芯片上的晶体管及每平方毫米的能耗。备注：2022年芯片功耗密度约440瓦/平方厘米
      ![image](./Pictures/architecture/Dennard-law.avif)

  - 阿姆达尔定律（Amdahl's Law）：增强（加速）某部分功能处理的措施后可获得的性能改进或执行时间的加速比

    - S=1/(1-a+a/n)

      - s为加速比
      - a为并行计算部分所占比例
      - n为并行处理结点个数

      - 当1-a=0时，(即没有串行，只有并行)最大加速比s=n；当a=0时（即只有串行，没有并行），最小加速比s=1；当n→∞时，极限加速比s→ 1/（1-a），这也就是加速比的上限。例如，若串行代码占整个代码的25%，则并行处理的总体性能不可能超过4。

    - 1986 年至 2002 年间，指令级并行（ILP）是提高性能的主要架构方法。而且随着晶体管速度的提高，其性能每年能提高 50% 左右。登纳德缩放定律的终结意味着工程师必须找到更加高效的并行化利用方法。

      - 然而，多核并不能解决由登纳德缩放定律终结带来的能效计算挑战。一个主要的障碍可以用阿姆达尔定律。如果只有 1% 的时间是串行的，那么 64 核配置可加速大约 39 倍，所需能量与 64 个处理器成正比，因此大约有 45% 的能量被浪费了。
        ![image](./Pictures/architecture/Dennard-law1.avif)

  - 牧本定律（也有称“牧本波动”）：1987 年， 原日立公司总工程师牧本次生(Tsugio Makimoto，也有翻译为牧村次夫，故称为“牧村定律”) 提出，半导体产品发展历程总是在“标准化”与“定制化”之间交替摆动，大概每十年波动一次。牧本定律背后是性能功耗和开发效率之间的平衡。

    - 对于处理器来说，就是专用结构和通用结构之间的平衡。最近这一波开始转向了追求性能功耗，于是专用结构开始更受关注。
      ![image](./Pictures/architecture/Makimoto's-law.avif)

  - 贝尔定律：这是Gordon Bell在1972年提出的一个观察，值得一提的是超级计算机应用最高奖“戈登·贝尔奖”就是以他的名字命名。
    ![image](./Pictures/architecture/贝尔定律.avif)
    - 贝尔定律指明了未来一个新的发展趋势，也就是AIoT时代的到来。这将会是一个处理器需求再度爆发的时代，但同时也会是一个需求碎片化的时代，不同的领域、不同行业对芯片需求会有所不同，比如集成不同的传感器、不同的加速器等等。如何应对碎片化需求？这又将会是一个挑战。

- intel架构演进

  ![image](./Pictures/architecture/intel架构演进.avif)

  - 这些技术之间还存在很多耦合，带来很大的设计复杂度。比如2011年在Sandy Bridge上引入了大页面技术，要实现这个功能，会涉及到超标量、乱序执行、大内存、SSE指令、多核、硬件虚拟化、uOP Fusion等等一系列CPU模块和功能的修改，还涉及操作系统、编译器、函数库等软件层次修改，可谓是牵一发动全身。（经常看到有人说芯片设计很简单，也许是因为还没有接触过CPU芯片的设计，不知道CPU设计的复杂度）

- RISC:

  - 在今天的后 PC 时代，x86 的出货量从 2011 年的顶峰每年都会下降约 10%，而 RISC 处理器芯片出货量已经激增到了 200 亿。

  - DEC 工程师后来表明，更复杂的 CISC ISA 每个程序执行的指令数是 RISC 每个程序的 75%（上式第一项），在使用类似的技术时，CISC 执行每个指令要多消耗 5 到 6 个时钟周期（第二项），使得 RISC 微处理器的速度大约快了 3 倍。

- 处理器内部有非常复杂的状态，其状态变化是由程序驱动的。

  - 也就是说，处理器状态取决于程序行为，而CPU体系结构层次的优化思路就是发现程序行为中的共性特征并进行加速。如何发现程序行为中的共性特征，就是处理器优化的关键点，这需要对程序行为、操作系统、编程与编译、体系结构等多个层次都有很好的理解，这也是计算机体系结构博士的基本要求。这也是为什么很多国外的计算机体系结构方向属于Computer Science系。

    ![image](./Pictures/architecture/处理器状态变化由程序驱动.avif)

  - 发现热点应用和热点代码、并在体系结构层次上优化的例子。

    - 1.是发现在不少领域TCP/IP协议栈五层协议（L5Ps）存在很多大量共性操作，比如加密解密等，于是直接在网卡上实现了一个针对L5Ps的加速器，大幅加速了网络包处理能力。

    - 2.是这次疫情导致云计算数据中心大量算力都用来做视频转码，于是设计了一个硬件加速器专门来加速视频转码，大幅提升了数据中心效率。

      ![image](./Pictures/architecture/体系结构层次上优化的例子.avif)

  - 发现和识别这种热点应用和热点代码并不容易，需要由很强大的基础设施和分析设备。

    - Google在其数据中心内部有一个GWP工具，能对整个数据中心应用在很低的开销下进行监测与统计，找到算力被那些热点程序/代码消耗，当前的CPU哪些部件是瓶颈。比如GWP显示在Google数据中心内部有5%的算力被用来做压缩。正是得益于这些基础工具，Google很早就发现AI应用在数据中心中应用比例越来越高，于是开始专门设计TPU来加速AI应用。

      ![image](./Pictures/architecture/google的热点代码分析设备（GWP工具）.avif)

- 三个方面来介绍体系结构层面的常见优化思路：减少数据移动、降低数据精度、提高处理并行度。

  - 1.如何减少数据移动

    - 1.第一个切入点是指令集——指令集是程序语义的一种表达方式。同一个算法可以用不同粒度的指令集来表达，但执行效率会有很大的差别。一般而言，粒度越大，表达能力变弱，但是执行效率会变高。

            ![image](./Pictures/architecture/如何减少数据移动.avif)

      - 通用指令集为了能覆盖尽可能多的应用，所以往往需要支持上千条指令，导致流水线前端设计（取指、译码、分支预测等）变得很复杂，对性能与功耗都会产生负面影响。

                ![image](./Pictures/architecture/通用指令集的弊端.avif)

      - 针对某一个领域设计专用指令集，则可以大大减少指令数量，并且可以增大操作粒度、融合访存优化，实现数量级提高性能功耗比。下面PPT的这组数据是斯坦福大学团队曾经做过的一项研究，从这个图可以看出，使用了“Magic Instruction”后，性能功耗比大幅提升几十倍。而这种Magic Instruction其实就是一个非常具体的表达式以及对应的电路实现

                ![image](./Pictures/architecture/领域专用指令集优势.avif)

    - 2.减少数据移动的常用方法就是充分发挥缓存的作用

      - 很多人都关注处理器的流水线多宽多深，但其实大多数时候，访存才是对处理器性能影响最大的。

                ![image](./Pictures/architecture/访存优化技术.avif)

      - 最近比较热的内存压缩方向

        - IBM在最新的Z15处理器中增加了一个内存压缩加速模块，比软件压缩效率提高388倍，效果非常突出。

                    ![image](./Pictures/architecture/内存压缩技术1.avif)

        - 英伟达也在研究如何在GPU中通过内存压缩技术来提升片上存储的有效容量，从而提高应用性能。

                    ![image](./Pictures/architecture/内存压缩技术2.avif)

      - Intel在访存优化上很下功夫，可以通过对比两款Intel CPU来一窥究竟。Core 2 Due T9600和Pentium G850两块CPU，工艺差一代，但频率相近，分别是2.8GHz和2.9GHz，但性能差了77%——SPEC CPU分值G850是31.7分，而T9600只有17.9分。频率相当，为何性能会差这么多？

        - 事实上，G850的Cache容量比T9600还要小——6MB L2 vs. 256KB L2 + 3MB L3。如果再仔细对比下去，就会发现这两款处理器最大的区别在于G850适配的内存控制器中引入FMA（Fast Memory Access）优化技术，大幅提高了访存性能。

                ![image](./Pictures/architecture/Intel访存优化技术.avif)

  - 2.降低数据精度

    - 这方面是这几年研究的热点，特别是在深度学习领域，很多研究发现不需要64位浮点，只需要16位甚至8位定点来运算，精度也没有什么损失，但性能却得到数倍提升。

    - 很多AI处理器都在利用这个思路进行优化，包括前段时间日本研制的世界最快的超级计算机“富岳”中的CPU中就采用了不同的运算精度。因此其基于低精度的AI运算能力可以达到1.4EOPS，比64位浮点运算性能（416PFLOPS）要高3.4倍。

      ![image](./Pictures/architecture/降低数据精度.avif)

    - IEEE 754浮点格式的一个弊端是不容易进行不同精度之间的转换。近年来学术界提出一种新的浮点格式——POSIT，更容易实现不同的精度，甚至有一些学者呼吁用POSIT替代IEEE 754（Posit: A Potential Replacement for IEEE 754）。
      - RISC-V社区一直在关注POSIT，也有团队实现了基于POSIT的浮点运算部件FPU，但是也还存在一些争论（David Patterson和POSIT发明人John L. Gustafson之间还有一场精彩的辩论）。
        ![image](./Pictures/architecture/POSIT浮点格式.avif)

  - 并行
    - 除了多核，还有其他不同层次的并行度，比如指令集并行、线程级并行、请求级别并行；除了指令级并行ILP，还有访存级并行MLP。
      ![image](./Pictures/architecture/并行.avif)

- 开发架构：要创建处理器中的「Linux」。开放式架构允许学术界和工业界的所有最佳人才帮助提高安全性

  - RISC-V

  - 英伟达 2017 年还宣布一个免费开放的架构，称之为英伟达深度学习加速器（NVDLA），这是一种可扩展的可配置 DSA，用于机器学习推理

- 敏捷硬件开发。对架构师来说的一个好消息是，当代电子计算机辅助设计（ECAD）工具提高了抽象水平，使得敏捷开发成为可能，而且这种更高水平的抽象增加了设计的重用性。

- 波拉克法则（Pollack's Rule）则提出，同制程工艺下，处理器的性能提升幅度，是芯片面积（晶体管数量）提升的平方根。

- [对开发人员有用的定律、理论、原则和模式](https://github.com/nusr/hacker-laws-zh)

# cpu

## 性能排行榜

- [passmark](https://www.cpubenchmark.net/desktop.html)

## RISC-V

> 要创建处理器中的「Linux」

- RISC-V 是一个模块化指令集。一小部分指令运行完整的开源软件堆栈，然后是可选的标准扩展，设计人员可以根据需要包含或省略。该基础包括 32 位地址和 64 位地址版本。

  | 标准扩展 | 操作            |
  | -------- | --------------- |
  | M        | 整型数乘法/除法 |
  | A        | 原子内存操作    |
  | F/D      | 单/双精度浮点数 |
  | C        | 压缩指令        |

  - 即使架构师不接受新的扩展，软件堆栈仍然运行良好。专有架构通常需要向上的二进制兼容性，这意味着当处理器公司添加新功能时，所有未来的处理器也必须包含它。对于 RISC-V，情况并非如此，所有增强功能都是可选的，如果应用程序不需要，可以删除。

  - RISC-V 的指令少得多。base 中有 50 个指令，与原始 RISC-I 相近。剩余的标准扩展（M、A、F 和 D）增加了 53 条指令，再加上 C 又增加了 34 条，共计 137 条。ARMv8 有超过 500 条指令。

## 国产cpu

- [了不起的云计算：一文读懂：国产芯片四大流派优劣势](https://mp.weixin.qq.com/s/y1VUV3V-YbUa2DTEO0HTXA)

# GPU

- [GPU Specs Database：查看amd、nvidia显卡参数](https://www.techpowerup.com/gpu-specs/)
## 原理

- [RethinkFun：AI 工程师都应该知道的GPU工作原理，TensorCore](https://www.bilibili.com/video/BV1rH4y1c7Zs)

- [腾讯大讲堂：英伟达 GPU 十年架构演进史](https://cloud.tencent.com/developer/article/1891497?areaSource=&traceId=)

- [腾讯技术工程：GPU 性能原理拆解](https://mp.weixin.qq.com/s/1jIxz29z1Uue0Nsu1qdhfg)

- [Tales of the M1 GPU](https://asahilinux.org/2022/11/tales-of-the-m1-gpu/)

- [Which GPU(s) to Get for Deep Learning: My Experience and Advice for Using GPUs in Deep Learning](https://timdettmers.com/2023/01/30/which-gpu-for-deep-learning/)

## cuda

- [infoq：12 人小团队如何成就英伟达万亿市值？CUDA 架构师首次亲述真正的算力“壁垒”形成过程](https://mp.weixin.qq.com/s/fSXQSRDOMMrUZGq9uVqovg)


# RDMA

- [RDMA技术详解（一）：RDMA概述](https://zhuanlan.zhihu.com/p/55142557)

# FPGA

- [FPGA, CPU, GPU, ASIC区别]()

- [HDLBits — Verilog Practice](https://hdlbits.01xz.net/wiki/Main_Page)

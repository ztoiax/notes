<!-- mtoc-start -->

* [CPU](#cpu)
  * [内核态](#内核态)
  * [中断](#中断)
  * [功耗](#功耗)
* [memory（内存）](#memory内存)
  * [物理内存](#物理内存)
    * [内存管理：用户态和内核态](#内存管理用户态和内核态)
    * [热插拔（hotplug）](#热插拔hotplug)
    * [三种内存模型](#三种内存模型)
    * [UMA](#uma)
    * [NUMA（Non-uniform memory access，非一致存储访问结构）](#numanon-uniform-memory-access非一致存储访问结构)
      * [cache一致性](#cache一致性)
  * [虚拟内存](#虚拟内存)
    * [分段](#分段)
    * [分页](#分页)
      * [TLB](#tlb)
      * [段页式内存管理（分段 + 分页）](#段页式内存管理分段--分页)
      * [内存页面置换算法](#内存页面置换算法)
      * [linux实现](#linux实现)
        * [内核空间](#内核空间)
        * [用户空间](#用户空间)
      * [COW(copy-on-write，写时拷贝)](#cowcopy-on-write写时拷贝)
      * [malloc 是如何分配内存的？](#malloc-是如何分配内存的)
      * [内存回收](#内存回收)
        * [用户空间](#用户空间-1)
      * [在 4GB 物理内存的机器上，申请 8G 内存会怎么样？](#在-4gb-物理内存的机器上申请-8g-内存会怎么样)
      * [Andrew Pavlo：警告！不要使用mmap代替数据库的缓冲IO，那Prometheus呢？](#andrew-pavlo警告不要使用mmap代替数据库的缓冲io那prometheus呢)
        * [使用 mmap 的优缺点](#使用-mmap-的优缺点)
        * [Prometheus 如何存储数据？](#prometheus-如何存储数据)
        * [Prometheus 如何保存其数据？](#prometheus-如何保存其数据)
          * [结论：](#结论)
* [Process、Thread(进程、线程)](#processthread进程线程)
  * [进程（Process）](#进程process)
    * [进程的状态](#进程的状态)
    * [进程控制块（process control block，PCB）](#进程控制块process-control-blockpcb)
    * [进程的通信](#进程的通信)
      * [管道](#管道)
    * [消息队列](#消息队列)
    * [共享内存](#共享内存)
    * [信号量](#信号量)
    * [锁](#锁)
      * [读写锁](#读写锁)
      * [乐观锁、悲观锁](#乐观锁悲观锁)
    * [socket](#socket)
    * [init 进程](#init-进程)
  * [线程（Thread）](#线程thread)
  * [调度](#调度)
    * [调度器](#调度器)
    * [调度算法](#调度算法)
    * [鹅厂架构师：EEVDF替代CFS？离在线混部调度器变革解读](#鹅厂架构师eevdf替代cfs离在线混部调度器变革解读)
  * [中断](#中断-1)
    * [硬中断](#硬中断)
    * [软中断](#软中断)
      * [tasklet：动态机制，基于 softirq](#tasklet动态机制基于-softirq)
      * [workqueue：动态机制，运行在进程上下文](#workqueue动态机制运行在进程上下文)
* [磁盘和文件系统](#磁盘和文件系统)
  * [磁盘调度算法](#磁盘调度算法)
  * [文件系统](#文件系统)
    * [文件的存储](#文件的存储)
      * [Linux ext2/3 ](#linux-ext23-)
    * [空闲空间管理](#空闲空间管理)
      * [linux ext2](#linux-ext2)
    * [目录的存储](#目录的存储)
    * [硬链接、软链接](#硬链接软链接)
    * [loop设备](#loop设备)
      * [实验：挂载文件系统](#实验挂载文件系统)
    * [FUFE用户态挂载文件系统](#fufe用户态挂载文件系统)
    * [自制FUFE用户态文件系统](#自制fufe用户态文件系统)
      * [FUSE 原理](#fuse-原理)
      * [FUFE使用](#fufe使用)
* [I/O](#io)
  * [5种I/O模型](#5种io模型)
  * [非直接I/O：使用Page cache](#非直接io使用page-cache)
    * [Page cache的零拷贝技术](#page-cache的零拷贝技术)
  * [直接I/O + 异步I/O 解决大文件传输问题](#直接io--异步io-解决大文件传输问题)
  * [缓冲区共享 (Buffer Sharing)](#缓冲区共享-buffer-sharing)
  * [I/O多路复用（select, poll, epoll）](#io多路复用select-poll-epoll)
    * [select()](#select)
    * [poll()](#poll)
    * [epoll()](#epoll)
      * [腾讯技术工程：十个问题理解 Linux epoll 工作原理](#腾讯技术工程十个问题理解-linux-epoll-工作原理)
    * [进程/线程模型](#进程线程模型)
      * [主进程 (master) + 多个子进程 (worker)](#主进程-master--多个子进程-worker)
      * [多进程模型](#多进程模型)
      * [多线程模型](#多线程模型)
      * [Reactor架构](#reactor架构)
      * [Proactor架构](#proactor架构)
    * [Netty, gnet 等框架](#netty-gnet-等框架)
  * [通用块层](#通用块层)
  * [设备控制器](#设备控制器)

<!-- mtoc-end -->

# CPU

## 内核态

- [朱小厮的博客：科普：进入内核态究竟是什么意思？](https://mp.weixin.qq.com/s/7xzdNbRRUdugDDtrZHmNdg)

- 实模式：早期的DOS这样的操作系统，它其实将要执行的应用程序加载变成了操作系统的一部分

    - 单任务问题：用户程序自己可以访问大部分的硬件设备；用户程序甚至可以随意修改属于操作系统的数据。于是，当时的许多病毒也毫不客气地把自己直接连接到了操作系统的程序里面，一旦执行就永远驻留成为操作系统的一部分。

    - 多任务问题更严重：

        - 没有内存隔离：两个应用程序执意要使用同一个内存地址

        - 不管谁操作外部设备它都是一样响应。这样如果多个应用程序自己直接去操纵硬件设备，就会出现相互冲突
        - 如果应用程序自己把中断响应程序改掉了，整个操作系统都会崩溃

        - 操作系统没有能力在程序崩溃的下，清理这个应用程序使用的资源


- 内核态（保护模式）或者说CPU的特权模式

    - intel CPU每一代产品都会尽量兼容之前的产品，早期的CPU启动时是实模式，后来的CPU为了兼容早期的CPU，启动时也处于实模式，需要引导程序主动进入保护模式

    - X86架构，用户态运行在ring3，内核态运行在ring0，两个特权等级。

        - 1.ring0：一些特权指令，例如填充页表、切换进程环境等，一般在ring0进行。内核态包括了异常向量表（syscall、中断等）、内存管理、调度器、文件系统、网络、虚拟化、驱动等。

        - 2.ring3：只能访问部分寄存器，做协程切换等。可以运行用户程序。用户态lib、服务等。

        - 区别

            - 用户态crash，重启app即可；系统是安全的。内核态crash，整机需要重启。

            - 通过页表做进程隔离，进程之间内存一般不可见（共享内存除外）。而内核态内存全局可见。

        ![image](./Pictures/linux-kernel/内核态和用户态.avif)

## 中断

- [Linux 中断（IRQ/softirq）基础：原理及内核实现（2022）](http://arthurchiao.art/blog/linux-irq-softirq-zh/)

- 中断（IRQ）：希望 CPU 停下手头的工作，优先处理重要的工作

- 硬中断流程：

    - 1.抢占当前任务：内核必须暂停正在执行的进程
    - 2.执行中断处理函数（ISR）：找到对应的中断处理函数，将 CPU 交给它（执行）
        - ISR 位于 Interrupt Vector table，这个 table 位于内存中的固定地址。

    - 3.中断处理完成之后：第 1 步被抢占的进程恢复执行

- 中断类型：

    - 异常（exception）：给被中断的进程发送一个 Unix 信号，以此来唤醒它，这也是为什么内核能如此迅速地处理异常的原因。

    - 外部硬件中断：
        - 1.I/O interrupts（IO 中断）： PCI 总线架构，多个设备共享相同的 IRQ line。
        - 2.Timer interrupts（定时器中断）
        - 3.Interprocessor interrupts（IPI，进程间中断）

```sh
# 最大中断数
dmesg | grep NR_IRQS
[    0.000000] NR_IRQS: 20736, nr_irqs: 1064, preallocated irqs: 16
```

- 软中断（softirq）：软中断是一个内核子系统

    - 每个 CPU 上会初始化一个 ksoftirqd 内核线程，负责处理各种类型的 softirq 中断事件

    ```sh
    systemd-cgls -k | grep softirq # 或者  ps -ef | grep ksoftirqd
    ├─   15 [ksoftirqd/0]
    ├─   24 [ksoftirqd/1]
    ├─   30 [ksoftirqd/2]
    ├─   36 [ksoftirqd/3]
    ├─   42 [ksoftirqd/4]
    ├─   48 [ksoftirqd/5]
    ├─   54 [ksoftirqd/6]
    ├─   60 [ksoftirqd/7]
    ├─   66 [ksoftirqd/8]
    ├─   72 [ksoftirqd/9]
    ├─   78 [ksoftirqd/10]
    ├─   84 [ksoftirqd/11]
    ```

    - 软中断占 CPU 的总开销
    ```sh
    # si 字段就是系统的软中断开销
    top -n1 | head -n3
    top - 23:01:35 up  3:49,  1 user,  load average: 0.84, 1.01, 1.14
    Tasks: 318 total,   1 running, 317 sleeping,   0 stopped,   0 zombie
    %Cpu(s):  2.6 us,  2.6 sy,  0.0 ni, 94.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
    ```

    - 每个软中断会经过下面几个阶段：

        - 1.通过 open_softirq() 注册软中断处理函数
        - 2.通过 raise_softirq() 将一个软中断 标记为 deferred interrupt，这会唤醒该软中断（但还没有开始处理）
        - 3.内核调度器调度到 ksoftirqd 内核线程时，会将所有等待处理的 deferred interrupt （也就是 softirq）拿出来，执行对应的处理方法（softirq handler）

    - 软中断类型
    ```sh
    cat /proc/softirqs
    ```

## 功耗

- 关于CPU功耗管理，有以下几种模式：

    | 值           | 说明                                                                                                               |
    |--------------|--------------------------------------------------------------------------------------------------------------------|
    | performance  | 运行于最大频率                                                                                                     |
    | powersave    | 运行于最小频率                                                                                                     |
    | userspace    | 运行于用户指定的频率                                                                                               |
    | ondemand     | 按需快速动态调整CPU频率， 一有cpu计算量的任务，就会立即达到最                   大频率运行，空闲时间增加就降低频率 |
    | conservative | 按需快速动态调整CPU频率， 比 ondemand 的调整更保守                                                                 |
    | schedutil    | 基于调度程序调整 CPU 频率                                                                                          |

- 查看当前支持模式：

    ```sh
    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
    performance powersave
    ```

- 查看当前使用模式：

    ```sh
    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    performance
    ```

# memory（内存）

## 物理内存

- [小林coding：深入理解 Linux 物理内存管理](https://www.xiaolincoding.com/os/3_memory/linux_mem2.html)

- CPU通过物理内存地址向物理内存读写数据的完整过程：
    ![image](./Pictures/linux-kernel/cpu_to_memory.avif)

### 内存管理：用户态和内核态

- 64位地址空间0x0000,0000,0000,0000。~0x0000, 7fff,ffff,f000为用户态空间地址，0xffff,8800,0000,0000~0xffff,ffff,ffff,ffff为内核态空间地址（除去部分空洞）。
    ![image](./Pictures/linux-kernel/内存管理.avif)

- 用户态部分，有mmap、malloc（实际brk）、不同语言分配接口等分配虚拟内存。read、write等fs相关系统调用也可以直接访问页缓存。

- 内核部分，内存管理由slub子系统（支持小内存分配）和伙伴系统buddy（管理所有分配给内核使用的可见页）组成。功能包括了内存映射（map与缺页异常）、内存分配、内存回收、内存迁移等组成。
    ![image](./Pictures/linux-kernel/内存管理-用户态和内核态.avif)

### 热插拔（hotplug）

- 集群的规模一大，那么物理内存出故障的几率也会大大增加，物理内存的热插拔对提供集群高可用性也是至关重要的。

- 热插拔分为两个阶段：

    - 物理热插拔阶段：物理上将内存硬件插入（hot-add），拔出（hot-remove）主板的过程，其中涉及到硬件和内核的支持。

    - 逻辑热插拔阶段：由内核中的内存管理子系统来负责：

        - 如何动态的上线启用（online）对应的 hot-add 的内存

        - 如何动态下线（offline）对应的 hot-remove 的内存

- 拔出比插入更复杂

    - 拔出的物理内存中可能已经为进程分配了物理页，如何妥善安置这些已经被分配的物理页是一个棘手的问题。

### 三种内存模型

- 为了快速索引到具体的物理内存页，内核为每个物理页 struct page 结构体定义了一个索引编号：PFN（Page Frame Number）。

    - 内核提供了两个宏（page_to_pfn 与 pfn_to_page）：来完成 PFN 与 物理页结构体 struct page 之间的相互转换。

- 物理内存模型：如何组织管理这些物理内存页 struct page 的方式

- FLATMEM（平坦内存模型）：用一个数组来组织这些连续的、固定的物理内存页 struct page 结构，其在数组中对应的下标即为 PFN 。

    - Linux 早期使用的就是这种内存模型，因为在 Linux 发展的早期所需要管理的物理内存通常不大（比如几十 MB）

    ![image](./Pictures/linux-kernel/FLATMEM.avif)

    - 缺点：存在大量不连续的内存地址区间这种情况时，这些不连续的内存地址区间就形成了内存空洞。

        - 为这些空洞而分配的 struct page（每个40Bytes） 将会占用大量的内存空间，导致巨大的浪费。

    ![image](./Pictures/linux-kernel/FLATMEM1.avif)

- DISCONTIGMEM（非连续内存模型）：为了解决FLATMEM的空洞，用node管理连续的物理内存页，每个node还是FLATMEM
    - 缺点：物理内存的热插拔依然会导致node的不连续

    ![image](./Pictures/linux-kernel/DISCONTIGMEM.avif)

- SPARSEMEM（稀疏内存模型）：管理连续内存块的单元被称作 section（内核中用 struct mem_section 结构体表示）。用数组管理section

    - 物理页大小为 4k 的情况下， section 的大小为 128M ，物理页大小为 16k 的情况下， section 的大小为 512M。

    ![image](./Pictures/linux-kernel/SPARSEMEM.avif)

    - 每个 mem_section 都可以在系统运行时改变 offline ，online 状态，以便支持内存的热插拔

        - offline 时：内核会把这部分内存隔离开，使得该部分内存不可再被使用，然后再把 mem_section 中已经分配的内存页迁移到其他 mem_section 的内存上. 。

        ![image](./Pictures/linux-kernel/SPARSEMEM1.avif)

        - 并非所有的物理页都可以迁移：迁移只是物理内存地址的变化，对用户空间的虚拟地址没有问题

            - 但内核空间的虚拟地址中的直接映射区，它的虚拟地址与物理地址是直接映射的关系，虚拟内存地址直接减去一个固定的偏移量（0xC000 0000 ） 就得到了物理内存地址。

            - 解决方法：内存分类：分为不可迁移页，可回收页，可迁移页。将可能会被拔出的内存中只分配那些可迁移的内存页

### UMA

- SMP（Symmetric multiprocessing 对称多处理器）：

    - 一个物理 CPU 可以存在多个物理 Core，而每个 Core 又可以存在多个硬件线程。

    - 例子：1 个 x86 CPU 有 4 个物理 Core，每个 Core 有两个 HT (Hyper Thread)
        - L1 和 L2 Cache 都被两个 HT 共享，且在同一个物理 Core。而 L3 Cache 则在物理 CPU 里，被多个 Core 来共享。
        - 在操作系统看来，就是一个 8 个 CPU 的 SMP 系统。

- SMP 系统的 CPU 和内存的互连方式分为：

    - 1.UMA (一致内存访问)

        ![image](./Pictures/linux-kernel/uma.avif)

        - 所有的 CPU 访问内存都要过总线，并且它们的速度都是一样的。

        - 多路处理器通过 FSB (前端系统总线) 和主板上的内存控制器芯片 (MCH) 相连，DRAM 是以 UMA 方式组织的，延迟并无访问差异，

        - 缺点：总线很快就会成为性能瓶颈，随着 CPU 个数的增多导致每个 CPU 可用带宽会减少

    - 2.NUMA (非一致内存访问)

        ![image](./Pictures/linux-kernel/numa.avif)

        - 内存控制器芯片被集成到处理器内部：多个处理器通过 QPI 链路相连，从此 DRAM 有了远近之分。
        - 片外的 IOH 芯片也集成到了处理器内部：至此，内存控制器和 PCIe Root Complex 全部在处理器内部了。

        - 一个 NUMA 节点通常可以被认为是一个物理 CPU 加上它本地的 DRAM 和 Device 组成。
            - 四路服务器就拥有四个 NUMA 节点。

        - 优点：CPU 在读取自己拥有的内存的时候就会很快；缺点：读取别 U 的内存的时候就会比较慢。

            - 这个技术伴随着服务器 CPU 核心数越来越多，内存总量越来越大的趋势下诞生的，因为传统的模型中不仅带宽不足，而且极易被抢占，效率下降的厉害。

        - Cache：除物理 CPU 有本地的 Cache 的层级结构以外，还存在跨越系统总线 (QPI) 的远程 Cache 命中访问的情况。
            - 远程的 Cache 命中，对发起 Cache 访问的 CPU 来说，还是被记入了 LLC Cache Miss。

        - DRAM：在两路及以上的服务器，远程 DRAM 的访问延迟，远远高于本地 DRAM 的访问延迟，有些系统可以达到 2 倍的差异。
            - 即使服务器 BIOS 里关闭了 NUMA 特性，也只是对 OS 内核屏蔽了这个特性，这种延迟差异还是存在的。

        - Device：对 CPU 访问设备内存，及设备发起 DMA 内存的读写活动而言，存在本地 Device 和远程 Device 的差别，有显著的延迟访问差异。

### NUMA（Non-uniform memory access，非一致存储访问结构）

- NUMA 的内存分配策略

| 内存分配策略      | 策略描述                                                                       |
|-------------------|--------------------------------------------------------------------------------|
| MPOL_BIND         | 必须在绑定的节点进行内存分配，如果内存不足，则进行 swap                        |
| MPOL_INTERLEAVE   | 本地节点和远程节点均可允许分配内存                                             |
| MPOL_PREFERRED    | 优先在指定节点分配内存，当指定节点内存不足时，选择离指定节点最近的节点分配内存 |
| MPOL_LOCAL (默认) | 优先在本地节点分配，当本地节点内存不足时，可以在远程节点分配内存               |

- numa的物理内存模型：

    - node_start_pfn 指向 NUMA node 内的第一个物理页 PFN。每个物理页的 PFN 都是全局唯一的

    - node_present_pages：统计 NUMA node 真正可用的物理页面数量（不包含内存空洞）

    - node_spanned_pages：统计 NUMA node 内所有的内存页（包含内存空洞）

    ![image](./Pictures/linux-kernel/numa-memory-model.avif)

- zone_type除了四大物理内存区域还有两个区域：

    - ZONE_DEVICE 是为支持热插拔设备而分配的非易失性内存（ Non Volatile Memory ），也可用于内核崩溃时保存相关的调试信息。

    - ZONE_MOVABLE：是一个虚拟区域包含这些物理区域（ZONE_DMA，ZONE_NORMAL，ZONE_HIGHMEM）。

        - 该区域的全部物理页都是可迁移的，主要是为了防止内存碎片和支持内存的热插拔。

        ![image](./Pictures/linux-kernel/ZONE_MOVABLE.avif)

    - 只有第一个 NUMA node 可以包含所有的物理内存区域

        ![image](./Pictures/linux-kernel/numa-memory-model1.avif)

    | NUMA node状态   | 内容
    |-----------------|--------------------------------------------|
    | N_NORMAL_MEMORY | 只有 ZONE_NORMAL，没有 ZONE_HIGHMEM        |
    | N_HIGH_MEMORY   | 有 ZONE_NORMAL 或者有 ZONE_HIGHMEM         |
    | N_MEMORY        | 有 ZONE_NORMAL，ZONE_HIGHMEM，ZONE_MOVABLE |
    | N_CPU           | 包含一个或多个 CPU。                       |

    - numa node状态中的热插拔（需要SPARSEMEM 稀疏内存模型）

        | NUMA node状态 | 内容                           |
        |---------------|--------------------------------|
        | N_POSSIBLE    | 在某个时刻可以变为 online 状态 |
        | N_ONLINE      | 当前的状态为 online 状态       |

    ```sh
    # /proc/zoneinfo 维护着vm_stat结构（物理内存使用的统计信息）
    # 查看NUMA node中内存区域的分布情况

    cat /proc/zoneinfo | grep Node
    Node 0, zone      DMA
    Node 0, zone    DMA32
    Node 0, zone   Normal
    Node 0, zone  Movable
    Node 0, zone   Device
    ```

    - struct zone：是内核中用于描述和管理 NUMA node中的物理内存区域的结构体。

        - 由于是一个访问非常频繁的结构体，因此使用了 spinlock_t lock 自旋锁来防止并发错误

        - 内核会为每一个内存区域分配一个伙伴系统用于管理该内存区域下物理内存的分配和释放。

            ![image](./Pictures/linux-kernel/numa-zone.avif)

```sh
# 查看 numa 配置
numactl --hardware

# 查看内存
numactl -s

# 查看node 的内存分配情况
numastat

# --interleave=all内存分配是应该尽量均匀地分布在各个节点上，启动mongodb
numactl --interleave=all mongod --port 27017 --dbpath ~/mongodb
```

- 通过调整 `/proc/sys/vm/zone_reclaim_mode` ：当某个 Node 内存不足时，系统可以从其他 Node 寻找空闲内存，也可以从本地内存中回收内存。

    - 访问远端 Node 的内存比访问本地内存要耗时很多

    ```sh
    cat /proc/sys/vm/zone_reclaim_mode
    0
    ```

    | 值           | 操作                                                                       |
    |--------------|----------------------------------------------------------------------------|
    | 0 （默认值） | 在回收本地内存之前，在其他 Node 寻找空闲内存                               |
    | 1            | 只回收本地内存                                                             |
    | 2            | 只回收本地内存，在本地回收内存时，可以将文件页中的脏页写回硬盘，以回收内存 |
    | 4            | 只回收本地内存，在本地回收内存时，可以用 swap 方式回收内存                 |

#### cache一致性

- [云巅论剑：CPU Cache Line伪共享问题的总结和分析]()

- Cache Line ：是 CPU 和主存之间数据传输的最小单位。当一行 Cache Line 被从内存拷贝到 Cache 里，Cache 里会为这个 Cache Line 创建一个条目。

    - Cache 容量小于主存：多个主存地址可以被映射到同一个 Cache 条目

        - 通常是由内存的虚拟或者物理地址的某几位决定的，取决于 Cache 硬件设计是虚拟地址索引，还是物理地址索引。

            - 一个主存的物理或者虚拟地址，可以被分成三部分：
                - 高地址位当作 Cache 的 Tag，用来比较选中多路 (Way) Cache 中的某一路 (Way)
                - 低地址位可以做 Index，用来选中某一个 Cache Set。
                    - 由于索引位一般设计为低地址位，通常在物理页的页内偏移以内，因此，不论是内存虚拟或者物理地址，都可以拿来判断两个内存地址，是否在同一个 Cache Line 里。

        ```sh
        # 查看cache line的大小
        getconf -a | grep -i cache
        ```

- 在多个处理器的本地 Cache 里存在多份拷贝的可能性，因此就存在数据一致性问题。

    - 处理器都实现了 Cache 一致性 (Cache Coherence）协议。如历史上 x86 曾实现了 MESI 协议以及 MESIF 协议。

    - 假设两个处理器 A 和 B, 都在各自本地 Cache Line 里有同一个变量的拷贝流程：

        - 一：此时该 Cache Line 处于 Shared 状态。

        - 二：处理器 A 在本地修改了变量，除去把本地变量所属的 Cache Line 置为 Modified 状态以外，
            - 还必须在另一个处理器 B 读同一个变量前，对该变量所在的 B 处理器本地 Cache Line 发起 Invaidate 操作，标记 B 处理器的那条 Cache Line 为 Invalidate 状态。

        - 三：处理器 B 在对变量做读写操作时，如果遇到这个标记为 Invalidate 的状态的 Cache Line，即会引发 Cache Miss
            - 从而将内存中最新的数据拷贝到 Cache Line 里，然后处理器 B 再对此 Cache Line 对变量做读写操作

- Cache Line 伪共享：多个 CPU 上的多个线程同时修改自己的变量引发的。

    - 这些变量表面上是不同的变量，但是实际上却存储在同一条 Cache Line 里。

    - 由于 Cache 一致性协议，两个处理器都存储有相同的 Cache Line 拷贝的前提下

        - 本地 CPU 变量的修改会导致本地 Cache Line 变成 Modified 状态，然后在其它共享此 Cache Line 的 CPU 上，导致 Cache Line 变为 Invalidate 状态，从而使 Cache Line 再次被访问时，发生本地 Cache Miss，从而伤害到应用的性能。

        - 多个线程在不同的 CPU 上高频反复访问这种 Cache Line 伪共享的变量，则会因 Cache 颠簸引发严重的性能问题。

- Perf c2c 发现伪共享

    - 当应用在 NUMA 环境中运行，或者应用是多线程的，又或者是多进程间有共享内存，满足其中任意一条，那么这个应用就可能因为 Cache Line 伪共享而性能下降。

    - 要怎样才能知道一个应用是不是受伪共享所害呢？
        - Joe 的 patch 是在 Linux 的著名的 perf 工具上，添加了一些新特性，叫做 c2c，意思是“缓存到缓存” (cache-2-cache)。

    - 此处省略：perf c2c介绍和使用

## 虚拟内存

- [小林coding：深入理解 Linux 虚拟内存管理](https://www.xiaolincoding.com/os/3_memory/linux_mem.html)

- [小林coding：为什么要有虚拟内存？](https://www.xiaolincoding.com/os/3_memory/vmem.html)

- `ps aux`： VSZ 为虚拟内存大小；RSS 为物理内存大小

    ```sh
    ps aux
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root           1  0.0  0.1 169088 13040 ?        Ss   Feb10   0:00 /sbin/init
    ```

### 分段

- 映射机制：

    - 段选择子：保存在段寄存器里面，包含段号用作段表的索引

    - 段表：包含段的基地址、段的界限和特权等级等。分段机制会分成4个段，每个段在段表都有段的基地址。段的基地址加上段内偏移量得到物理内存地址。

        ![image](./Pictures/linux-kernel/virtual-memory.avif)
        ![image](./Pictures/linux-kernel/virtual-memory1.avif)

- 缺点：

    - 没有内部碎片，而有外部碎片（进程之间的间隙）

    - 解决外部碎片的方法（swap效率低）：

        - 1.把音乐程序占用的那 256MB 内存写到swap上

        - 2.然后再从swap上读到紧跟 512MB 内存的后面。这样就能空缺出连续的 256MB 空间。

        ![image](./Pictures/linux-kernel/virtual-memory2.avif)

### 分页

- 解决分段的缺点：在内存交换时只写入少量固定的数据Page（页）。

- 「页表」保存的是虚拟内存地址与物理内存地址的映射关系。把整个虚拟和物理地址切割成固定页（4KB），由cpu集成的硬件MMU（内存管理单元）负责转换

- 进程要访问的虚拟地址，在页表找不到的时候，就会产生**缺页中断**。`Page Fault Handler （缺页中断函数）` 就会分配物理地址，建立虚拟与物理地址的正向映射，更新页表。
    ![image](./Pictures/linux-kernel/缺页异常.avif)

- 页表项中除了物理地址之外，还有一些标记属性的比特，比如控制一个页的读写权限，标记该页是否存在等。在内存访问方面，操作系统提供了更好的安全性。

- 映射机制：

    - 页号：作为页表的索引

    - 页表：包含物理页每页所在物理内存的基地址。基地址加上页内偏移得到物理地址

        ![image](./Pictures/linux-kernel/virtual-memory3.avif)

- 优点：

    - swap效率高：

        - 内存不够时，根据机制把一部分页换出（写入）swap；需要时再换入（读取）

            ![image](./Pictures/linux-kernel/virtual-memory4.avif)

- 缺点：

    - 没有外部碎片，而有内部碎片（进程大小不足一页时，也要分配一页）

    - 页表本身占用很大的内存：

        - 一个页的大小是 4KB（2^12）

        - 在 32 位的环境下虚拟地址空间共有4GB，也就是100万（2^20）个页

        - 一个「页表项」需要 4Bytes，4GB 就需要有 4Bytes * 2^20 = 4MB 的内存来存储页表。

        - 100 个进程的话，就需要 400MB 的内存来存储页。那64 位就更大了

    - 解决方法：多级页表

        - 二级分页：将一级页表分为 1024 个二级页表（4Bytes * 1024 = 4KB），每个二级页表中包含 1024 个「页表项」（4Bytes * 1024 * 1024 = 4MB)

            ![image](./Pictures/linux-kernel/virtual-memory5.avif)

            - 总大小：4KB + 4MB 比之前的一级分页还大4KB

                - 但一级页表就可以覆盖整个 4GB 虚拟地址空间，如果某个一级页表的页表项没有被用到，也就不需要创建这个页表项对应的二级页表了。

                    - 假设只有 20% 的一级页表项被用到：4KB（一级页表） + 20% * 4MB（二级页表）= 0.804MB

        - 64位需要四级分页：

            | 四级分页                                  |
            |-------------------------------------------|
            | 全局页目录项 PGD（Page Global Directory） |
            | 上层页目录项 PUD（Page Upper Directory）  |
            | 中间页目录项 PMD（Page Middle Directory） |
            | 页表项 PTE（Page Table Entry）            |

            ![image](./Pictures/linux-kernel/virtual-memory6.avif)
            ![image](./Pictures/linux-kernel/virtual-memory-32.avif)
            ![image](./Pictures/linux-kernel/virtual-memory-64.avif)

#### TLB

- [TLB原理](https://zhuanlan.zhihu.com/p/108425561)

TLB（Translation Lookaside Buffer）：页表的缓存，集成在cpu内部，根据虚拟地址查找cache

#### 段页式内存管理（分段 + 分页）

段页式内存管理：先分段，每个段再分页

- 段页式地址变换中要得到物理地址须经过三次内存访问：
    - 1.访问段表，得到页表起始地址
    - 2.访问页表，得到物理页号
    - 3.将物理页号与页内位移组合，得到物理地址

    ![image](./Pictures/linux-kernel/virtual-memory7.avif)

#### 内存页面置换算法

- [小林coding：进程调度/页面置换/磁盘调度算法](https://www.xiaolincoding.com/os/5_schedule/schedule.html#%E5%86%85%E5%AD%98%E9%A1%B5%E9%9D%A2%E7%BD%AE%E6%8D%A2%E7%AE%97%E6%B3%95)

- 缺页中断的处理流程

    - 第四步如果内存满了：就需要「页面置换算法」选择一个物理页，如果该物理页有被修改过（脏页），则把它换出到磁盘，然后把该被置换出去的页表项的状态改成`无效的`，最后把正在访问的页面装入到这个物理页中。

    ![image](./Pictures/linux-kernel/memory-algorithm.avif)

    ![image](./Pictures/linux-kernel/memory-algorithm1.avif)

     | 页表项字段 | 内容                                                                                                                                                                                                             |
     |------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
     | 状态位     | 是否在物理内存中                                                                                                                                                                                                 |
     | 访问字段   | 在一段时间被访问的次数                                                                                                                                                                                           |
     | 修改位     | 表示该页在调入内存后是否有被修改过。由于内存中的每一页都在磁盘上保留一份副本，如果没有修改，在置换该页时就不需要将该页写回到磁盘上；如果已经被修改，则将该页重写到磁盘上，以保证磁盘中所保留的始终是最新的副本。 |
     | 硬盘地址   | 用于指出该页在硬盘上的地址，通常是物理块号，供调入该页时使用。                                                                                                                                                   |

- 最佳页面置换算法（OPT）：置换在「未来」最长时间不访问的页面。但是实际系统中无法实现，因为程序访问页面时是动态的，我们是无法预知每个页面在「下一次」访问前的等待时间。

    - 该算法可以衡量你的算法的效率，你的算法效率越接近该算法的效率，那么说明你的算法是高效的。

    ![image](./Pictures/linux-kernel/memory-algorithm2.avif)

- 先进先出（FIFO）：选择在内存驻留时间很长的页面进行中置换

- 最近最久未使用（LRU）：选择最长时间没有被访问的页面进行置换

    - 缺点：开销大。LRU算法需要在内存中维护一个所有页面的链表，最近最多使用的页面在表头，最近最少使用的页面在表尾。在每次访问内存时都必须要更新「整个链表」。在链表中找到一个页面，删除它，然后把新的移动到表头是一个非常费时的操作。

- 时钟页面置换算法（Clock）：把所有的页面都保存在一个类似钟面的「环形链表」中，一个表针指向最老的页面。

    - 如果访问位是 1 就修改为0，并把表针前移一个位置，重复这个过程直到找到了一个访问位为 0 的页面为止
    - 如果它的访问位位是 0 就淘汰该页面，并把新的页面插入这个位置，然后把表针前移一个位置

    ![image](./Pictures/linux-kernel/memory-algorithm3.avif)

- 最不常用算法（LFU）：选择「访问次数」最少的那个页面，并将其淘汰

    - 每个页面加一个计数器就可以实现。但只考虑了频率问题，没考虑时间的问题：比如有些页面在过去时间里访问的频率很高，但是现在已经没有访问了，而当前频繁访问的页面由于没有这些页面访问的次数高，而被置换时淘汰。

        - 因此需要定期减少访问的次数：当发生时间中断时，把过去时间访问的页面的访问次数除以 2，也就说，随着时间的流失，以前的高访问次数的页面会慢慢减少

#### linux实现

- Linux的虚拟地址空间：分为内核空间和用户空间两部分

    - 32位
    ![image](./Pictures/linux-kernel/kernel-memory.avif)

    - 64 位：只使用了 48 位来描述虚拟内存空间，寻址范围为 2^48（256TB）。多出的高 16 位就形成了这个地址空洞（canonical address）。
        - 用户空间高16位全为0；内核空间高16位全为1；空洞地址的高16位不全为0也不全为1
    ![image](./Pictures/linux-kernel/kernel-memory1.avif)

##### 内核空间

- [小林coding：内核虚拟内存空间](https://www.xiaolincoding.com/os/3_memory/linux_mem.html#_7-%E5%86%85%E6%A0%B8%E8%99%9A%E6%8B%9F%E5%86%85%E5%AD%98%E7%A9%BA%E9%97%B4)

    ![image](./Pictures/linux-kernel/kernel-memory2.avif)

    > 自底向上解释每个映射区

    - 1.DMA:在 X86 体系结构下，ISA 总线的 DMA （直接内存存取）控制器，只能对内存的前16M 进行寻址，这就导致了 ISA 设备不能在整个 32 位地址空间中执行 DMA，只能使用物理内存的前 16M 进行 DMA 操作。

    - 2.直接映射区（ZONE_NORMAL）：

        - 一共896MB。前 1M 已经在系统启动的时候被系统占用，1M 之后的物理内存存放的是内核代码段，数据段，BSS 段

        - 在内核运行的过程中，会涉及内核栈的分配，内核会为每个进程分配一个固定大小的内核栈（一般是两个页大小，依赖具体的体系结构），每个进程的整个调用链必须放在自己的内核栈中，内核栈也是分配在直接映射区。

    - 3.vmalloc 动态映射区：将不连续的物理内存映射到连续的虚拟内存上。因此它只能将这些物理内存页一个一个地进行映射，在性能开销上会比直接映射大得多。

        ![image](./Pictures/linux-kernel/kernel-memory3.avif)

    - 4.永久映射区：内核通过 `alloc_pages()` 申请的物理内存页，可以通过调用 kmap 映射到永久映射区
    - 5.固定映射区：在固定映射区中虚拟地址是固定的，而被映射的物理地址是可以改变的
    - 6.临时映射区：临时映射，所以在拷贝完成之后，调用 kunmap_atomic 将这段映射再解除掉。

- 内核内存分配两种方式：

    - 1.当进程请求内核分配内存时，如果此时内存比较充裕，那么进程的请求会被立刻满足，如果此时内存已经比较紧张，内核就需要将一部分不经常使用的内存进行回收，从而腾出一部分内存满足进程的内存分配的请求，在这个回收内存的过程中，进程会一直阻塞等待。

    - 2.进程是不允许阻塞的，内存分配的请求必须马上得到满足，比如执行中断处理程序、执行持有自旋锁等临界区内的代码时，进程就不允许睡眠，因为中断程序无法被重新调度。这需要提前为预留一部分内存，当内存紧张时，可以分配。

- 高位内存区域对低位内存区域进行挤压

    - 当 ZONE_HIGHMEM 区域中的内存不足时，内核可以从 ZONE_NORMAL 进行内存分配

    - ZONE_NORMAL 区域内存不足时可以进一步降级到 ZONE_DMA 区域进行分配

    - 但不允许无限制挤压占用

        - 每个内存区域会给自己预留一定的内存（`lowmem_reserve` 数组）

            ```sh
            # 从左到右： ZONE_DMA，ZONE_DMA32，ZONE_NORMAL，ZONE_MOVABLE，ZONE_DEVICE 物理内存区域的预留内存比例
            # 64位没有ZONE_HIGHMEM
            cat /proc/sys/vm/lowmem_reserve_ratio
            256 256 32  0   0

            # sysctl命令查看lowmem_reserve_ratio
            sysctl vm.lowmem_reserve_ratio
            vm.lowmem_reserve_ratio = 256	256	32	0	0
            ```

            | 物理内存区域 | lowmem_reserve_ratio | 内存区域大小 | 物理内存页个数 |
            |--------------|----------------------|--------------|----------------|
            | ZONE_DMA     | 256                  | 8M           | 2048           |
            | ZONE_NORMAL  | 32                   | 64M          | 16384          |
            | ZONE_HIGHMEM | 0                    | 256M         | 65536          |

        - 预留的物理内存页个数：

            ZONE_DMA 为防止被 ZONE_NORMAL 挤压侵占：16384 / 256 = 64。

            ZONE_DMA 为防止被 ZONE_HIGHMEM 挤压侵占：(65536 + 16384) / 256 = 320。

            ZONE_NORMAL 为防止被 ZONE_HIGHMEM 挤压侵占：65536 / 32 = 2048。



##### 用户空间

![image](./Pictures/linux-kernel/virtual-memory12.avif)

| 用户空间           |                                                                          |
|--------------------|--------------------------------------------------------------------------|
| 代码段（text）     | 二进制可执行代码                                                         |
| 数据段（data）     | 已初始化的静态常量和全局变量                                             |
| BSS 段             | 未初始化的静态变量和全局变量                                             |
| 堆段（heap）       | 动态分配的内存，从低地址开始向上增长                                     |
| 文件映射段（mmap） | 动态库（如glibc）的代码段、数据段、BSS 段，mmap 系统调用映射的共享内存区 |
| 栈段（stack）      | 局部变量、函数调用的上下文等。默认为 8 MB                                |

- 修改栈段（stack）大小：

    ```sh
    # 查看stack大小，默认为8MB
    ulimit -s
    8192

    # 修改为16MB
    ulimit -s 16384
    ```

- 7 个内存段中，堆 `malloc()` 和文件映射段 `mmap()` 的内存是动态分配的。

- 图片的灰色部分是保留区（非法），比如C 的代码里会将无效的指针赋值为 NULL

- 子进程与线程的虚拟内存：

    > 进程和线程之间的本质区别：是否共享地址（mm_struct 结构体）

    - 子进程：`fork()` 函数创建的子进程虚拟内存，是直接父进程的拷贝

    - 线程：`vfork()` 或者 `clone()` 系统调用创建出的子进程会设置 `CLONE_VM 标识` ，父进程和子进程的虚拟内存空间就变成共享的了，并不是一份拷贝。

- 进程的虚拟内存空间包含一段一段的虚拟内存区域（Virtual memory area, 简称 VMA），每个VMA描述虚拟内存空间中一段连续的区域，每个VMA由许多虚拟页组成，即每个VMA包含许多页表项PTE。

    - 在默认fork中，父进程遍历每个VMA，将每个VMA复制到子进程，并自上而下地复制该VMA对应的页表项到子进程，对于64位的系统，使用四级分页目录，每个VMA包括PGD、PUD、PMD、PTE，都将由父进程逐级复制完成。
        - 在Async-fork中，父进程同样遍历每个VMA，但只负责将PGD、PUD这两级页表项复制到子进程。

- 在操作系统中，PTE的修改分为两类：
    - 1.VMA级的修改。例如，创建、合并、删除VMA等操作作用于特定VMA上，VMA级的修改通常会导致大量的PTE修改，因此涉及大量的PMD。
    - 2.PMD级的修改。PMD级的修改仅涉及一个PMD。

- [小林coding：定义虚拟内存区域的访问权限和行为规范](https://www.xiaolincoding.com/os/3_memory/linux_mem.html#_5-4-%E5%AE%9A%E4%B9%89%E8%99%9A%E6%8B%9F%E5%86%85%E5%AD%98%E5%8C%BA%E5%9F%9F%E7%9A%84%E8%AE%BF%E9%97%AE%E6%9D%83%E9%99%90%E5%92%8C%E8%A1%8C%E4%B8%BA%E8%A7%84%E8%8C%83)

    | vm_flags     | 访问权限               |
    |--------------|------------------------|
    | VM_READ      | 可读                   |
    | VM_WRITE     | 可写                   |
    | VM_EXEC      | 可执行                 |
    | VM_SHARD     | 可多进程之间共享       |
    | VM_IO        | 可映射至设备 IO 空间   |
    | VM_RESERVED  | 内存区域不可被换出     |
    | VM_SEQ_READ  | 内存区域可能被顺序访问 |
    | VM_RAND_READ | 内存区域可能被随机访问 |

    | 虚拟内存段           | 可读 | 可写 | 可执行 |
    |----------------------|------|------|--------|
    | 栈                   | yes  | yes  | no     |
    | 文件映射与匿名映射区 | yes  | yes  | yes    |
    | 堆                   | yes  | yes  | yes    |
    | 数据段               | yes  | yes  | no     |
    | 代码段               | yes  | no   | yes    |

    ![image](./Pictures/linux-kernel/virtual-memory10.avif)

- [小林coding：虚拟内存区域在内核中是如何被组织的](https://www.xiaolincoding.com/os/3_memory/linux_mem.html#_5-7-%E8%99%9A%E6%8B%9F%E5%86%85%E5%AD%98%E5%8C%BA%E5%9F%9F%E5%9C%A8%E5%86%85%E6%A0%B8%E4%B8%AD%E6%98%AF%E5%A6%82%E4%BD%95%E8%A2%AB%E7%BB%84%E7%BB%87%E7%9A%84)

    - vm_area_struct 会有两种组织形式：

        - 双向链表获取：`cat /proc/<pid>/maps` 或者 `pmap <pid>` 查看进程的虚拟内存空间布局

        - 红黑树：查找特定的虚拟内存区域时使用

        ![image](./Pictures/linux-kernel/virtual-memory11.avif)

- ELF

    - 磁盘文件中的段 Section；内存中的段 Segment

    - 进程运行之前：磁盘的Section 会加载到内存中并映射到内存中的 Segment。通常是多个 Section 映射到一个 Segment。

    | Section         | Segment              |
    |-----------------|----------------------|
    | .text（只读）   | 代码段（只读可执行） |
    | .rodata（只读） | 代码段（只读可执行） |
    | .data（可读写） | 数据段（可读写）     |
    | .bss （可读写） | BSS 段（可读写）     |

#### COW(copy-on-write，写时拷贝)

- 简单来说就是可以延迟拷贝页

- COW流程：
    - fork出的子进程共享父进程的物理空间，当父子进程有内存写入操作时，
    - 内存管理单元MMU检测到内存页是read-only内存页，于是触发缺页中断异常（page-fault）
    - 处理器会从中断描述符表（IDT）中获取到对应的处理程序。
    - 在中断程序中，内核就会把触发异常的物理内存页复制一份，并重新设置其内存映射关系，将父子进程的内存读写权限设置为可读写，于是父子进程各自持有独立的一份，之后进程才会对内存进行写操作

    ![image](./Pictures/linux-kernel/io-cow.avif)

- 缺点：

    - 只适用于多读少写：其它场景下反而可能造成负优化，因为 COW事件所带来的系统开销要远远高于一次 CPU 拷贝所产生的。

    - 内存页的只读标志 (read-ony) 更改为 (write-only)需要TLB flush

    - 还是会造成父进程出现短时间阻塞，阻塞的时间跟页表的大小有关，页表越大，阻塞的时间也越长。

- 应用例子：redis的 `bgsave` , `bgwriteaof` 命令

#### malloc 是如何分配内存的？

- [小林coding：malloc 是如何分配内存的？](https://www.xiaolincoding.com/os/3_memory/malloc.html)

- malloc的两种分配内存方式：

    - 1.内存小于 128 KB：brk() 系统调用从堆分配内存

        ![image](./Pictures/linux-kernel/malloc.avif)

        - `cat /proc/<pid>/maps` 查看内存分配：有 `[heap]` 的标志

        - `free()` 释放内存后，会缓存在内存池，再次申请 相同的内存时就可以直接复用。减少了系统调用的次数，也减少了缺页中断的次数

            - 为什么不全部使用 `brk()` 来分配？ 堆内将产生越来越多不可用的碎片，导致“内存泄露”。而且无法使用 valgrind的工具 检测出来。

                ![image](./Pictures/linux-kernel/malloc2.avif)


    - 2.内存大于等于 128 KB：mmap() 系统调用在文件映射区域分配内存

        ![image](./Pictures/linux-kernel/malloc1.avif)

        - `cat /proc/<pid>/maps` 查看内存分配：没有 `[heap]` 的标志

        - `free()` 释放内存后，会真正的释放

- malloc分配的是虚拟内存，只有访问虚拟内存时才会触发 `缺页中断`

- malloc(1) 会分配多大的虚拟内存？malloc()会预分配更大的空间作为内存池，与内存管理器有关。

    | 内存管理器 | 实现者                    |
    |------------|---------------------------|
    | dlmalloc   | General purpose allocator |
    | ptmalloc2  | glibc                     |
    | jemalloc   | FreeBSD and Firefox       |
    | tcmalloc   | Google                    |
    | libumem    | Solaris                   |

    - 可以通过`cat /proc/<pid>/maps` 查看：

        ```
        562c319c2000-562c319e3000 rw-p 00000000 00:00 0                          [heap]
        ```

        - ptmalloc的`malloc(1)` 内存分配为：562c319e3000 - 562c319c2000 = 21000（转换为十进制135168 / 2 ^ 10 = 132KB）

- malloc() 返回的起始地址多了 16 字节：这16 字节就是保存了该内存块的描述信息，比如有该内存块的大小。执行 free() 函数时，就能知道释放多大的内存了

    ![image](./Pictures/linux-kernel/malloc3.avif)

#### 内存回收

##### 用户空间

- [小林coding：内存满了，会发生什么？](https://www.xiaolincoding.com/os/3_memory/mem_reclaim.html)

- 发生缺页中断后，缺页中断函数会看是否有空闲的物理内存，如果没有就执行内存回收

- 文件页回收：通过 pflush 内核线程

- 匿名页回收：

    ![image](./Pictures/linux-kernel/memory-not-enough.avif)

    - 后台内存回收（kswapd）：异步的，不会阻塞进程的执行

    - 直接内存回收（direct reclaim）：同步的，会阻塞进程的执行

    - 直接内存回收后还是不够：触发 OOM （Out of Memory）机制：

        - `oom_badness()` 可以被杀掉的进程扫描一遍，并对每个进程打分，得分最高的进程就会被首先杀掉；如果还是不够，找到下一个进程继续杀掉，直到够。得分计算：

            - 1.进程已经使用的物理内存页面数。

            - 2.每个进程的oom_score_adj。可以通过 `/proc/<pid>/oom_score_adj` 来调整的进程被 OOM Kill 的几率，数值为-1000 到 1000 

    - `sar -B 1` 命令，查看后台、直接内存回收的指标

        ![image](./Pictures/linux-kernel/memory-recovery.avif)

        | 指标      | 内容                                                                                                    |
        |-----------|---------------------------------------------------------------------------------------------------------|
        | pgscank/s | kswapd(后台回收线程) 每秒扫描的 page 个数                                                               |
        | pgscand/s | 应用程序在内存申请过程中每秒直接扫描的 page 个数。如果在抖动的时数值很大，那么大概率是**直接内存回收** |
        | pgsteal/s | 扫描的 page 中每秒被回收的个数（pgscank+pgscand）                                                       |

- 什么条件下才能触发 kswapd 内核线程回收内存呢？定义了三个内存阈值（watermark，也称为水位），用来衡量当前剩余内存（pages_free）是否充裕

    ![image](./Pictures/linux-kernel/memory-kswapd.avif)

    - kswapd 会定期扫描内存的使用情况，根据剩余内存（pages_free）的情况来进行内存回收的工作。

         | 剩余内存量               | 操作                                                                                  |
         |--------------------------|---------------------------------------------------------------------------------------|
         | pages_free在图中绿色部分 | 充足                                                                                  |
         | pages_free在图中蓝色部分 | 内存有一定压力，但还可以满足应用程序申请内存的请求                                    |
         | pages_free在图中橙色部分 | 内存压力比较大，剩余内存不多了。触发 kswapd0 执行内存回收，直到回到图中绿色部分为止。 |
         | pages_free在图中红色部分 | 用户可用内存都耗尽了。触发**直接内存回收**                                            |

    - 通过 `/proc/sys/vm/min_free_kbytes` 调整pages_min值，并间接调整其他值：

        ```sh
        # kswapd 的活动空间只有 pages_low 与 pages_min 之间（也就是图中橙色部分）
        cat /proc/sys/vm/min_free_kbytes
        67584
        ```

        - pages_high和pages_low都是根据pages_min计算的：

            ```
            pages_min = min_free_kbytes
            pages_low = pages_min*5/4
            pages_high = pages_min*3/2
            ```

    - 调整`min_free_kbytes`时要考虑应用程序关注什么：如果关注延迟，就增大；如果关注内存的使用量，就调小
        - 增大：会使得系统预留过多的空闲内存，从而在一定程度上降低了应用程序可使用的内存量，这在一定程度上浪费了内存。

        - min_free_kbytes 接近实际物理内存大小时：可能会频繁地导致 OOM 的发生。

- 哪些内存可以被回收？

    - 文件页（File-backed Page）：内核缓存的磁盘数据（Buffer）和内核缓存的文件数据（Cache）都叫作文件页。大部分文件页，都可以直接释放内存，以后有需要时，再从磁盘重新读取就可以了。

        - 而那些被应用程序修改过，并且暂时还没写入磁盘的数据（也就是脏页），就得先写入磁盘，然后才能进行内存释放。所以，回收干净页的方式是直接释放内存，回收脏页的方式是先写回磁盘后再释放内存。

            - 进程可以通过 `fsync()` 系统调用：将指定文件的所有脏页同步回写到磁盘

        - 对性能的影响：干净页直接释放内存，不影响；脏页会先写回到磁盘再释放内存，影响

    - 匿名页（Anonymous Page）：这部分内存没有实际载体，不像文件缓存有硬盘文件这样一个载体，比如堆、栈数据等。

        - 这部分内存很可能还要再次被访问，所以不能直接释放内存，它们回收的方式是通过 Linux 的 Swap 机制，Swap 会把不常访问的内存先写到磁盘中，然后释放这些内存，给其他更需要的进程使用。再次访问这些内存时，重新从磁盘读入内存就可以了。

            ![image](./Pictures/linux-kernel/memory-swap.avif)

        - 对性能的影响：Swap 会影响性能

    - 调整文件页和匿名页的回收倾向

        | 值  | 策略                                                                           |
        |-----|--------------------------------------------------------------------------------|
        | 0   | linux3.5以上：宁愿oom killer也不用swap；linux3.4以下：宁愿swap也不用oom killer |
        | 1   | linux3.5以上：宁愿swap也不用oom killer                                         |
        | 60  | 默认值                                                                         |
        | 100 | 操作系统主动使用swap                                                           |

        ```sh
        # 数值为0-100（默认为60）。越大越积极回收匿名页；越小越积极回收文件页，因此一般建议设置为0，但是并不代表不会回收匿名页。
        cat /proc/sys/vm/swappiness
        60
        ```

        ```sh
        # 查看swap的使用量
        free -h

        # 实时查看swap的使用。si和so表示swap in swap on
        dstat --vmstat 1
        # 或者
        vmstat 1

        # 查看进程 swap 换出的虚拟内存大小，它保存在 /proc/pid/status 的 Vmswap 字段中
        # 查看redis进程的swap使用情况，求和可以得出总的swap量
        cat /proc/$(pidof redis-server)/smaps | grep -i swap

        # 找出当前系统中 swap 占用最大的几个进程，并列出它们的进程号、进程名和 swap  大小。-k 3 表示按第三列进行排序，即按照交换空间大小排序
        for file in /proc/*/status;
            do awk '/VmSwap|Name|^Pid/{printf $2 " " $3}END{ print ""}' $file;
        done | sort -k 3 -n -r | head

        # 如果 swap 过高导致告警。可以关闭swap
        swapoff -a

        # 查看是否已经关闭，如果输出为空则表示 swap 成功关闭。
        cat /proc/swaps
        # 为了下一次重启机器后 swap 还是关闭状态我们还要编辑 /etc/fstab 文件，将其中关于 swap 的配置注释掉或者删除掉。
        ```

    - 文件页、匿名页都是根据LRU算法进行回收，维护着 active 和 inactive 两个双向链表：

        - 1.active_list 活跃内存页链表，这里存放的是最近被访问过（活跃）的内存页

        - 2.inactive_list 不活跃内存页链表，这里存放的是很少被访问（非活跃）的内存页

        ```sh
        # 查看两个链表内的文件页、匿名页
        cat /proc/meminfo | grep -i active | sort

        Active:          1173476 kB
        Active(anon):      22620 kB
        Active(file):    1150856 kB
        Inactive:        5501408 kB
        Inactive(anon):  4441512 kB
        Inactive(file):  1059896 kB
        ```

    - 为何要设置有两个链表？

        - [小林coding：如何避免预读失效和缓存污染的问题？](https://www.xiaolincoding.com/os/3_memory/cache_lru.html)

        - linux有预读机制。read 系统调动读取 4KB 数据，实际上内核使用预读机制（ReadaHead） 机制完成了 16KB 数据的读取，也就是通过一次磁盘顺序读将多个 Page 数据装入 Page Cache。

        - 如果预读失效，传统的LRU单链表就可能淘汰了热点数据，降低缓冲命中率。因此加入双链表。

            - inactive：存放预读的页

            - active：inactive预读的页成功的访问后，在从inactive中升级到active头部；而active末尾的页，降级inactive的头部

            ![image](./Pictures/linux-kernel/active_inactive.avif)

            - MySQL Innodb也有相应的机制：分为old、young，在同一个链表内young的比例为7，old为3

                ![image](./Pictures/linux-kernel/mysql-lru.avif)
                ![image](./Pictures/linux-kernel/mysql-lru1.avif)

        - 缓存污染：大量的预读页只访问一次就进active、young，淘汰到可能是热点的页。如果以后都不访问，就导致缓存污染。

            - 解决方法：提高门槛

                - Linux：在内存页被访问第二次的时候，才将页从 inactive list 升级到 active list 里。

                - MySQL Innodb：在内存页被访问第二次访问的时候，以及第二次访问与第一次的间隔时间：

                    - 1 秒内（默认值）：不会升级

                    - 超过 1 秒：升级

#### 在 4GB 物理内存的机器上，申请 8G 内存会怎么样？

- [小林coding：在 4GB 物理内存的机器上，申请 8G 内存会怎么样？](https://www.xiaolincoding.com/os/3_memory/alloc_mem.html)

- 3G内存，申请8G内存：

    - 32 位：进程最多只能申请 3 GB 大小的虚拟内存空间，所以进程申请 8GB 内存的话，在申请虚拟内存阶段就会失败

    - 64位：进程申请 8GB 内存是没问题的，只要不读写这个虚拟内存，操作系统就不会分配物理内存。

- 64位，2G内存，申请4G内存：

    - `/proc/sys/vm/overcommit_memory` 调整申请内存是否允许overcommit

        | 值          | 操作                                                                                                                                                                                                                                                                                                                                     |
        |-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
        | 0（默认值） | Heuristic overcommit handling，它允许overcommit，但过于明目张胆的overcommit会被拒绝，比如malloc一次性申请的内存大小就超过了系统总内存。Heuristic的意思是“试探式的”，内核利用某种算法猜测你的内存申请是否合理，大概可以理解为单次申请不能超过free memory + free swap + pagecache的大小 + SLAB中可回收的部分 ，超过了就会拒绝overcommit。 |
        | 1           | Always overcommit. 允许overcommit，对内存申请来者不拒。                                                                                                                                                                                                                                                                                  |
        | 2           | Don’t overcommit. 禁止overcommit。                                                                                                                                                                                                                                                                                                       |

    - `overcommit_memory`为0时：Cannot allocate memory 错误

    - `overcommit_memory`为1时：成功

- 64位，2G内存，`overcommit_memory` 设置为1，，申请128T内存：

    - 关闭swap：触发oom后被kill掉。因为申请虚拟内存过程中本身需要内存，2G内存不够。

    - 开启swap：成功申请

#### [Andrew Pavlo：警告！不要使用mmap代替数据库的缓冲IO，那Prometheus呢？](https://mp.weixin.qq.com/s/5Omxs3KfkJdAJle7j97uLQ)

- 最近读了 Andrew Pavlo 的一篇文章[1]，警告年轻的开发人员不要使用 mmap 来替代 DBMS 中的缓冲 IO（pread/pwrite）。

    - 他的论点本质上是，使用 mmap 来管理 DMBS 中的文件 I/O 是错误的。这立即让我想起了 Prometheus，它使用 mmap 将其数据块从磁盘映射到内存。

    - Prometheus 的 TSDB 使用到了 mmap，因为它继承了 levelDB 和 RocksDB 的思想。

- mmap 是如何出现的？

    - 在 20 世纪 80 年代末，一台典型的计算机有 128 KB RAM，典型的计算机内存既稀缺又昂贵。接着在操作系统领域，SunOS 4.0 中出现了将文件映射到内存的巧妙想法：内核将库文件加载到物理内存中一次，并在不同进程之间共享它们，这样内核就不必为每个进程单独加载库文件到物理内存中，进而可以重用物理内存。

##### 使用 mmap 的优缺点

- 使用 mmap 的优点

    - 1.避免系统调用

        - 系统调用可以防止用户程序跳转到内存中的任意位置并执行操作系统代码，如果用户程序需要调用内核代码，只能通过预定义的接口将控制权安全地移交给内核代码。当用户程序执行系统调用时，就会发生"环境切换"。

        - 当我们使用 mmap 将文件映射到虚拟地址空间时，只需要一个系统调用：mmap(2) 。相反，如果我们使用 pread/pwrite 进行文件 I/O，则程序必须为每个读/写操作进行环境切换。这是为什么 mmap 应该提供更好的性能的原因。

    - 2.不需要用户缓冲区

        - 在进行读/写操作时，默认情况下，内核实际上并不从磁盘读取或写入磁盘，而只是在用户空间的缓冲区和内核空间的页缓存之间复制数据。
            - pread 需要用到 Linux 用户手册 read(2) 显示需要一个名为 buf 的用户空间缓冲区，这是数据复制到的用户空间缓冲区。

        - Linux 需要用户空间缓冲区的原因与处理器需要 L1 和 L2 缓存的原因相同：从文件系统读取（无论是通过网络（例如 NFS）还是本地磁盘）与从内存读取相比非常慢。
            - 如果数据库执行大量 I/O 密集型操作，那么使用 mmap 会更快，因为不涉及用户缓冲区，因此无需将数据从内核缓冲区高速缓存复制到用户缓冲区。这也有助于节省计算机内存。

    - 3.便于使用

- 使用 mmap 的缺点

    - 正如前面提到的，mmap 是由 SunOS 人员引入 Unix 的，目的是在进程之间共享库对象文件。当多个进程共享底层相同的库对象时，数据一致性就成为一个问题，这当然可以通过被称为 private sharing(copy-on-write and demand paging) 的方法来解决。但是当涉及到 DBMS 时，我们仍然可以简单地使用 copy-on-write mmap 并假装操作系统已经神奇地为我们解决了所有问题吗？答案是不。


- 操作系统提供了三种地址空间操作：mmap 和 munmap 系统调用（统称为“内存映射操作”）和页面错误。

    - 1.`mmap` 创建内存映射区域并将它们添加到区域树中。
    - 2.`munmap` 从树中删除区域并使硬件页表结构中的条目无效。
    - 3.`页错误`在进程的区域树中查找导致页错误的虚拟地址，如果虚拟地址已映射，则在页表中添加一条虚拟地址-物理地址的映射并恢复应用程序。

- Andy 在论文中提到了几个主要问题：

    - 1.事务安全
    - 2.I/O 停顿
        - 没有异步IO接口。
        - IO 停顿是不可预测的，因为页面驱逐取决于操作系统。
    - 3.错误处理
    - 4.性能问题
        - 页表争用
        - 单线程页面驱逐
        - TLB 被击落

    - 前几个问题可以总结为 DBMS 失去了对页面错误和驱逐的控制，下面我们重点关注性能问题。针对性能问题 Andy 的论文中并没有给到清楚的说明，由于 Prometheus 是单写入模式，因此我们不关注事务安全。

- 1.页表争用
    - 省略...

- 2.单线程页面驱逐

    - 虽然使用 mmap 给我们带来了不使用用户空间缓冲池的好处，但它仍然依赖于页面缓存。Linux 内核维护一组最近最少使用 (LRU) 列表来跟踪页面缓存。因此，对于依赖 mmap 的数据库来说，它也依赖于 kswapd 高效执行。kswapd 是内核线程，负责在内存不足时将页面从内存逐出到磁盘。由于磁盘比内存慢得多，更是远远慢于CPU，因此 Linux 的作者并没有将 kswapd 设计为多线程的，也就是说 Linux 的页驱逐是单线程作业的。

    - Andy 指责这种单线程的 kswapd 是 mmap 输掉了“fio 与 mmap 顺序读取之战”的原因。这里需要补充的背景信息是常见的关系型数据库例如 MySQL 跟 PostgreSQL 使用 Direct IO, 因此他们在进行文件读写的时候可以绕过页面缓存，因此不会受到单线程页面驱逐的影响。另外就是，Linux 中的 LRU 链表受到 LRU 锁的保护。虽然 Andy 没有提到但是我想这也可能是另一个影响因素。

- 3.TLB 被击落

    - 一台计算机有多个核心，但它们都共享一个物理内存。在共享内存架构中，每个处理器都包含一个名为翻译后备缓冲区（TLB）的缓存，正如我们之前提到的。TLB 使虚拟地址转换变得快速，这对于数据库应用程序性能至关重要。

    - 当内存映射发生变化时，例如标签 0x001 指向物理页号 0x0011，之后又指向 0x0012，必须保证处理器之间的一致性。由于 CPU 没有硬件机制来确保 TLB 一致性，所以这项工作就留给了操作系统。为了确保 TLB 一致性，操作系统会执行 TLB 射落，这是一种使其他内核上的远程 TLB 记录无效的机制。

    - TLB 射落可以由修改页表项的各种内存操作触发，其中一个操作是 `munmap` : 它会删除指定地址范围的映射，并导致引用该范围内的地址的操作产生无效的内存引用。另一方面，当进程调用 mmap 并且操作系统在进程的虚拟地址空间中创建新记录时，操作系统不需要刷新 TLB，因为此时没有旧的 TLB 记录。

##### Prometheus 如何存储数据？

- 内存映射的内容

    - 在运行 `umon`（集成了 Prometheus 的 DMP 组件）的机器上，运行 `cat /proc/{pid of umon}/maps`，你能观察到 Prometheus 使用的连续虚拟内存区域。下面的表格列出了来自我的 DMP 环境的输出（去掉了未使用的虚拟内存或着由共享对象文件使用的虚拟地址）。

    ```sh
    00400000-044e3000 r-xp 00000000 fd:01 675313727                          /opt/umon/bin/umon
    046e2000-047ae000 rw-p 040e2000 fd:01 675313727                          /opt/umon/bin/umon
    7fcf9136d000-7fcf9936d000 r--s 00000000 fd:01 834677674                  /opt/umon/prometheus-data/chunks_head/000061
    7fcf9936d000-7fcf9f1ea000 r--s 00000000 fd:01 268448993                  /opt/umon/prometheus-data/01GRFAGZGWZPMMEC1RZ3KRR8PD/chunks/000001
    7fcfa69c8000-7fcfac3e0000 r--s 00000000 fd:01 180719137                  /opt/umon/prometheus-data/01GRN3XKJBFGP68Z19KSR6H2TQ/chunks/000001
    7fcfaf0dd000-7fcfb70dd000 r--s 00000000 fd:01 834677679                  /opt/umon/prometheus-data/chunks_head/000060
    7fcfb70dd000-7fcfb75a6000 r--s 00000000 fd:01 177000146                  /opt/umon/prometheus-data/01GRN3XKJBFGP68Z19KSR6H2TQ/index
    7fcfb75a6000-7fcfb790f000 r--s 00000000 fd:01 151420465                  /opt/umon/prometheus-data/01GRN3XHFNBSEJ57MSP7106R2Q/chunks/000001
    7fcfb790f000-7fcfb7c84000 r--s 00000000 fd:01 134347049                  /opt/umon/prometheus-data/01GRMX1T82JHV2HC7YFGYYPVJN/chunks/000001
    7fcfc82d0000-7fcfc87aa000 r--s 00000000 fd:01 264251793                  /opt/umon/prometheus-data/01GRFAGZGWZPMMEC1RZ3KRR8PD/index
    7fcfc87aa000-7fcfc887d000 r--s 00000000 fd:01 398511374                  /opt/umon/prometheus-data/01GR9H4AK312ZTDC81ZBHVMARH/index
    7fcfc887d000-7fcfc8c69000 r--s 00000000 fd:01 402839492                  /opt/umon/prometheus-data/01GR9H4AK312ZTDC81ZBHVMARH/chunks/000001
    7fcfc8d5f000-7fcfc8e2a000 r--s 00000000 fd:01 255988632                  /opt/umon/prometheus-data/01GRNHMXNS52464DJX5WRYSZ6A/index
    7fcfc8e2a000-7fcfc8ef5000 r--s 00000000 fd:01 146873066                  /opt/umon/prometheus-data/01GRN3XHFNBSEJ57MSP7106R2Q/index
    7fcfc8ef5000-7fcfc8fc0000 r--s 00000000 fd:01 130031109                  /opt/umon/prometheus-data/01GRMX1T82JHV2HC7YFGYYPVJN/index
    7fcfc9040000-7fcfc93c3000 r--s 00000000 fd:01 260059119                  /opt/umon/prometheus-data/01GRNHMXNS52464DJX5WRYSZ6A/chunks/000001
    7fcfc93c3000-7fcfc948e000 r--s 00000000 fd:01 234981699                  /opt/umon/prometheus-data/01GRNAS8RDR82J0X9V7H352736/index
    7fcfc948e000-7fcfc97fb000 r--s 00000000 fd:01 239093592                  /opt/umon/prometheus-data/01GRNAS8RDR82J0X9V7H352736/chunks/000001
    7fd020346000-7fd02034b000 rw-s 00000000 fd:01 826468484                  /opt/umon/prometheus-data/queries.active
    ```

    - 共享的对象文件是内存映射的，因此可以快速 fork 子进程，并且可以节省内存，因为进程不必将重复的代码复制到其文本段中，这对于几十年前的计算机是至关重要的。

- 在进一步讨论之前，我们需要知道一个名为 `vm_area_struct` 的结构体，它描述了一个连续的虚拟内存区域，来自进程的每个用户空间的 mmap 系统调用都会创建一个 `vm_area_struct`，它存储在每个进程的 task_struct 内核维护中。`cat /proc/pid/maps` 的输出列出了 `vm_area_struct` 的一部分，让我们选择一行输出并说明该结构的一些重要字段：

    ```sh
    7fcf9136d000-7fcf9936d000 r--s 00000000 fd:01 834677674                  /opt/umon/prometheus-data/chunks_head/000061
    ```

- 该行有六个字段，其中两个不是 `vm_area_struct` 的一部分：设备号（fd：01）和 inode 号（834677674）。

    | vm_area_struct字段 | 说明                                                                                                                                                                                                                                                 |
    |--------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
    | vm_start           | vm_end 7fcf9136d000是内存区域的起始地址，7fcf9936d000 是内存区域的结束地址。                                                                                                                                                                         |
    | vm_file            | /opt/umon/prometheus-data/chunks_head/000061 是指向关联文件结构的指针。                                                                                                                                                                              |
    | vm_pgoff           | 00000000 是该区域在文件内的偏移量。                                                                                                                                                                                                                  |
    | pgprot_t           | r--s 定义内存区域的访问权限。后缀 s 表示该区域是“共享的”。这意味着对该区域的更改将被写回文件并对所有进程可见。r-- 表示该区域是只读的，这里第二个占位符代表 w（写入），第三个 id 代表 x（执行）。该权限表明此 Prometheus 内存映射文件是只读且共享的。 |
    | vm_flags           | 一组标志，未在输出中显示。                                                                                                                                                                                                                           |
    | vm_ops             | 该区域的一组工作函数，未在输出中显示                                                                                                                                                                                                                 |
    | vm_next            | vm_prev umon 的内存区域通过列表结构链接起来，未在输出中显示。                                                                                                                                                                                        |

- 到目前为止，我们已经了解到 Prometheus 在 prometheus-data 文件夹下映射了多个文件，这些文件是什么以及为什么要进行内存映射？为了解释它，需要解释一些基本的 Prometheus 101 知识。

##### Prometheus 如何保存其数据？

- Prometheus 的 TSDB 是一个时间序列数据库，其数据可以被视为点流。

    ```
    Series_A -> (t0,A0), (t1, A1), (t2, A2), (t3, A3)...
    Series_B -> (t0,B0), (t1, B1), (t2, B2), (t3, B3)...
    Series_C -> (t0,C0), (t1, C1), (t2, C2), (t3, C3)...
    ```


- 问题：对于一个监控系统来说，每秒可能有数百万个数据点，Prometheus 可以直接将所有内容写入存储设备吗？

    - 想想看：对于传统磁盘来说，随机写入是一场灾难，因为磁头需要时间寻道，盘需要时间旋转。对于SSD，写入非空块是通过首先写入空块然后将数据移回来完成的。这称为“写入放大”，会显着缩短 SSD 的使用寿命。

    - 解决方法：因此，Prometheus除了使用缓冲区批量写入之外别无选择。否则，性能惩罚会很大。

- Prometheus 中的内存缓冲区在哪里？

    - 答案是“头块”。更准确地说，它实际上是 head chunk 中的一个 32KB 的页面。该行为与 InnoDB 引擎类似，InnoDB 引擎也不在行上工作，而是在页面上工作。但与 InnoDB 不同的是，Prometheus 没有自己的缓冲池，它只有一个页面用于写入。一旦该缓冲区页满了，就会将其刷新到 WAL 内的文件（也称为段）中。

    - WAL文件夹的布局是这样的：

        ```sh
        17728 -rw-r--r-- 1 actiontech-universe actiontech 18153472 2月   9 03:00 00000076
        17728 -rw-r--r-- 1 actiontech-universe actiontech 18153472 2月   9 05:00 00000077
        17728 -rw-r--r-- 1 actiontech-universe actiontech 18153472 2月   9 07:00 00000078
        4032  -rw-r--r-- 1 actiontech-universe actiontech  3621996 2月   9 07:24 00000079
        0     drwxr-xr-x 2 actiontech-universe actiontech       22 2月   9 05:00 checkpoint.00000075
        ```

        - 你可能想知道为什么这个文件夹叫 WAL，为什么有一个名为 checkpoint.xxxxxxxx 的文件？更令人困惑的是，为什么 00000076 之前的段都没有了？

            - 这时就需要提到预写日志记录 (WAL) 和检查点(checkpoint)了。WAL 是几乎所有 DBMS 的必经之路，以确保数据完整性（搜索 ARIES 进一步阅读相关概念）。这里的核心概念是，在向数据文件写入任何内容之前，必须记录操作，以防系统崩溃或计算机关闭。当 Prometheus 从崩溃中恢复时，它首先从 chunks_head 中读取数据，然后再从 WAL 中读取数据。


    - InnoDB 的重做日志（Redo Log）。
        - 重做日志是崩溃恢复期间使用的基于磁盘的数据结构。上面列出的文件与重做日志具有类似的用途，它们为头块提供持久性（所有其他块已经保存在磁盘上，只有可写入的头块在内存中）。这也是为什么所有这些文件都有顺序名称：WAL 中的每个日志记录都有一个全局唯一的日志序列号 (LSN)。

    - 检查点是 DBMS 中的另一个概念，总是与 WAL 一起出现。如果没有检查点，WAL 日志将永远增长。如果 DBMS 使用 WAL，那么它还必须在将 WAL 缓冲区刷新到磁盘后定期获取检查点。否则，在崩溃后，普罗米修斯将需要一段漫长而痛苦的启动时间。这也是为什么多年来 Prometheus 开发人员做出了一些决定，例如 减少 WAL 大小[8]（从 6 小时数据减少到 3 小时）并在头块满后将其刷新到磁盘。

###### 结论：

- 因为 chunkRange 默认为 2h，因此 head 每 3 小时可压缩一次。

    - 由于 Prometheus 默认每 15 秒抓取一次数据，又由于每个 chunk 最多可以容纳 120 个样本（prometheus#11219[10] 提到这个数字可能应该增加），因此，我们可以很容易地得出结论，单个 Prometheus chunk 默认情况下最多可以保存 30 分钟的数据。

    - 另外，我们刚刚发现 Prometheus 的 head chunk 最多可以保存 3 小时的数据。因此，我们可以得出结论，Prometheus 的 chunks_head 最多可以有 6 个 chunk，并且最多将其中 5 个刷新到磁盘并进行内存映射。由于 Prometheus 采用单写入模式，因此始终只有一个块可以写入，并且不会刷新到磁盘和内存映射。

    - 实验过程，省略...

- 到这里我们已经弄清楚了 Prometheus 中数据是如何流动的，新数据不断写入 Prometheus 的 head chunk，并且定期压缩到磁盘中，而 head chunk 确实是缓冲在内存中的，不是内存映射的。因此 Andy 在论文中提到的使用 mmap 的缺点并不会影响到 Prometheus 的性能。

- Prometheus 的 TSDB 的工作原理类似于日志结构的合并树。与 MySQL、PostgreSQL 等关系型数据库不同，Prometheus 的工作负载是重写的，新数据不断写入 Prometheus 的 head chunk，而 head chunk 确实是缓冲的，不是内存映射的，损害 mmap 的性能问题与此无关。

- Andy 的论文引用了 VictoriaMetrics 的技术文章“mmap 可能会减慢你的 Go 应用程序”，并试图表明 mmap 是 VictoriaMetrics 的一个问题。然而，事实并非如此，VictoriaMetrics 仍然默认使用 mmap 进行文件 IO。
# Process、Thread(进程、线程)

- [小林coding：进程、线程基础知识](https://www.xiaolincoding.com/os/4_process/process_base.html)

## 进程（Process）

- 并发：当进程执行磁盘io操作时，cpu会阻塞，此时cpu可以执行其它进程；完成磁盘io操作后，再发送一个中断通知cpu，cpu切换回来继续执行这个进程

    ![image](./Pictures/linux-kernel/process-concurrency.avif)

### 进程的状态

- 3种基本状态

    | 基本状态            | 内容                                                                                                          |
    |---------------------|---------------------------------------------------------------------------------------------------------------|
    | 运行状态（Running） | 该时刻进程占用 CPU                                                                                            |
    | 就绪状态（Ready）   | 可运行，由于其他进程处于运行状态而暂时停止运行                                                                |
    | 阻塞状态（Blocked） | 该进程正在等待某一事件发生（如等待输入/输出操作的完成）而暂时停止运行，这时，即使给它CPU控制权，它也无法运行 |

    ![image](./Pictures/linux-kernel/process-state.avif)

- 另外2种基本状态

    | 基本状态         | 内容                         |
    |------------------|------------------------------|
    | 创建状态（new）  | 进程正在被创建时的状态       |
    | 结束状态（Exit） | 进程正在从系统中消失时的状态 |

    ![image](./Pictures/linux-kernel/process-state1.avif)

- 2种挂起状态：有没有占用实际的物理内存空间的情况，通常会把阻塞状态的进程的换出(swap out)，等再次运行的时候，再swap in（换入）

    - 按<kbd>Ctrl+Z</kbd>可以主动挂起

    | 挂起状态     | 内容                                             |
    |--------------|--------------------------------------------------|
    | 阻塞挂起状态 | 进程在外存（硬盘）并等待某个事件的出现           |
    | 就绪挂起状态 | 进程在外存（硬盘），但只要进入内存，即刻立刻运行 |

    ![image](./Pictures/linux-kernel/process-state2.avif)

- 状态的变迁：

    | 状态的变迁           | 过程                                                       |
    |----------------------|------------------------------------------------------------|
    | NULL -> 创建状态     | 新进程被创建时的第一个状态                                 |
    | 创建状态 -> 就绪状态 | 当进程被创建完成并初始化后，变为就绪状态，这个过程是很快的 |
    | 就绪态 -> 运行状态   | 被调度器选中后，就分配给 CPU 正式运行该进程                |
    | 运行状态 -> 结束状态 | 当进程已经运行完成或出错时                                 |
    | 运行状态 -> 就绪状态 | 时间片用完了，调度器接着从就绪状态中，选另外一个进程运行   |
    | 运行状态 -> 阻塞状态 | 当进程请求某个事件且必须等待时，例如请求 I/O 事件          |
    | 阻塞状态 -> 就绪状态 | 当进程要等待的事件完成时，它从阻塞状态变到就绪状态         |

- 终止进程的2种情况：

    - 子进程被终止时：在父进程处继承的资源应当还给父进程。
    - 父进程被终止时：子进程就变为孤儿进程，会被1号进程收养，并由1号进程对它们完成状态收集工作。

### 进程控制块（process control block，PCB）

- 操作系统用PCB数据结构来描述进程

    - PCB 是进程存在的唯一标识，有则意味着进程存在；进程消失了，那么 PCB 也会随之消失。


    | PCB                                 | 内容                                                         |
    |-------------------------------------|--------------------------------------------------------------|
    | pid(Process Number)                 | 进程唯一标识符                                               |
    | uid                                 | 用户标识符                                                   |
    | 状态(state)                         | 当前状态(运行/就绪/等待)                                     |
    | 优先级(priority)                    | 相对 于其他进程的优先级别                                    |
    | 程序计数器(program counter)         | 即将被执行的下一条程序指令的地址                             |
    | 内存指针(memory pointers)           | 包括指向程序代码、相关数据和共享内存的指针                   |
    | 寄存器(CPU Registers)               | 进程被中断时处理器寄存器中的数据                             |
    | l/O状态信息(I/0 status information) | 包括显示I/O请求、分配给进程的I/O设备、被解除使用的文件列表等 |
    | 记帐信息(accounting information)    | 包括占用处理器时间、时钟数总和、时间限制、账号等             |

- PCB通过链表的方式进行组织，把具有相同状态的进程链在一起，组成各种队列

    ![image](./Pictures/linux-kernel/process-PCB.avif)

### 进程的通信

- [小林coding：进程间有哪些通信方式？](https://www.xiaolincoding.com/os/4_process/process_commu.html)

#### 管道

- 管道传输数据是单向的。遵循先进先出原则

- `|` 管道

    ![image](./Pictures/linux-kernel/process-pipe.avif)

    shell创建ps和grep子进程

    ```sh
    ps auxf | grep nvim
    ```

- 命名管道

    ```sh
    # 创建管道文件
    mkfifo pipe_file

    # 向管道文件写入数据。此时会卡住
    echo 'hello' > pipe_file

    # 读取管道文件的数据
    cat < pipe_file
    ```

### 消息队列

- A 进程要给 B 进程发送消息，A 进程把数据放在对应的消息队列后就可以正常返回了，B 进程需要的时候再去读取数据就可以了。

    - 如果没有释放消息队列或者没有关闭操作系统，消息队列会一直存在。不像管道`|`那样用完即毁

- 消息队列是保存在内核中的消息链表，在发送数据时，会分成一个一个消息体（数据块），用户可以自定义消息体，每个消息体都是固定大小的存储块

    - 消息队列不适合比较大数据的传输：在 Linux 内核中 `MSGMAX` 和 `MSGMNB`两个宏，它们以字节为单位，分别定义了一条消息的最大长度和一个队列的最大长度。

- 存在用户态与内核态之间的数据拷贝开销：

    - 进程写入数据到内核中的消息队列时，会发生从用户态拷贝数据到内核态的过程
    - 进程读取内核中的消息数据时，会发生从内核态拷贝数据到用户态的过程

### 共享内存

- 共享内存的机制，就是拿出一块虚拟地址空间来，映射到相同的物理内存中

    - 解决了消息队列中用户态与内核态切换的开销

    ![image](./Pictures/linux-kernel/process-share_memory.avif)

- 问题：多个进程同时修改同一个共享内存，那先写的那个进程会发现内容被别人覆盖了

### 信号量

- 共享的资源，在任意时刻只能被一个进程访问

    - 解决共享内存多进程冲突的问题

- 信号量是一个整型的计数器

    - P 操作：会把信号量减去 1

        - 如果信号量 < 0，则表明资源已被占用，进程需阻塞等待
        - 如果信号量 >= 0，则表明还有资源可使用，进程可正常继续执行

    - V 操作：会把信号量加上 1

        - 如果信号量 <= 0，则表明当前有阻塞中的进程，于是会将该进程唤醒运行
        - 如果信号量 > 0，则表明当前没有阻塞中的进程

    - P 操作是用在进入共享资源之前，V 操作是用在离开共享资源之后，这两个操作是必须成对出现的。


- 互诉信号量：初始化信号量为 1

    - 互斥信号量的值仅取 1、0 和 -1 三个值

        - 互斥信号量为 1：表示没有线程进入临界区
        - 互斥信号量为 0：表示有一个线程进入临界区
        - 互斥信号量为 -1：表示一个线程进入临界区：另一个线程等待进入

    - 进程 A 在访问共享内存前，先执行了 P 操作信号量变为 0，表示共享资源可用，于是进程 A 就可以访问共享内存。

    - 若此时，进程 B 也想访问共享内存，执行了 P 操作，结果信号量变为了 -1，这就意味着临界资源已被占用，因此进程 B 被阻塞。

    - 直到进程 A 访问完共享内存，才会执行 V 操作，使得信号量恢复为 0，接着就会唤醒阻塞中的线程 B，使得进程 B 可以访问共享内存，最后完成共享内存的访问后，执行 V 操作，使信号量恢复到初始值 1。

    ![image](./Pictures/linux-kernel/process-mutex.avif)

- 同步信号量：初始化信号量为 0

    - 进程 A 是负责生产数据，而进程 B 是负责读取数据

    - 如果进程 B 比进程 A 先执行了，那么执行到 P 操作时，信号量会变为 -1，表示进程 A 还没生产数据，于是进程 B 就阻塞等待

    - 接着，当进程 A 生产完数据后，执行了 V 操作，就会使得信号量变为 0，于是就会唤醒阻塞在 P 操作的进程 B

    - 最后，进程 B 被唤醒后，意味着进程 A 已经生产了数据，于是进程 B 就可以正常读取数据了。

### 锁

- [小林coding：什么是悲观锁、乐观锁？](https://www.xiaolincoding.com/os/4_process/pessim_and_optimi_lock.html)

- 自旋锁（spin lock）：加锁失败后，线程就会一直 while 循环，直到它拿到锁

- 互斥锁：加锁失败后，线程会释放 CPU ，给其他线程；

    - 由内核实现。当加锁失败时，内核会将线程置为「睡眠」状态，等到锁被释放后，内核会在合适的时机唤醒线程
        - 开销：互斥锁加锁失败时，会从用户态陷入到内核态；并且有两次线程上下文切换的成本（一次线程上下文切换大概几十纳秒到几微秒之间）

            - 1.加锁失败时，内核会把线程设置为「睡眠」状态，然后把 CPU 切换给其他线程运行

            - 2.当锁被释放时，线程变为「就绪」状态，然后内核会在合适的时间，把 CPU 切换给该线程运行

            - 因此如果你能确定，被锁住的代码执行时间比线程上下文切换还短，就不应该用互斥锁，而应该选用自旋锁，否则使用互斥锁。

        ![image](./Pictures/linux-kernel/process-mutex1.avif)

- 无等待锁：当没获取到锁的时候，就把当前线程放入到锁的等待队列

- [小林coding：怎么避免死锁？](https://www.xiaolincoding.com/os/4_process/deadlock.html)

    - 死锁：使用不当两个互斥锁，导致两个线程都在等待对方释放锁

    - 死锁的必须满足的4个条件：

        - 1.互斥条件：指多个线程不能同时使用同一个资源

        - 2.持有并等待条件：线程 A 在等待资源 2 的同时并不会释放自己已经持有的资源 1

        - 3.不可剥夺条件：当线程已经持有了资源 ，在自己使用完之前不能被其他线程获取，线程 B 如果也想使用此资源，则只能在线程 A 使用完并释放后才能获取

        - 4.环路等待条件：线程 A 已经持有资源 2，而想请求资源 1， 线程 B 已经获取了资源 1，而想请求资源 2

        - 破坏其中一个条件，就能解决死锁：

            - 资源有序分配法（避免环路）：线程 A 和 线程 B 总是以相同的顺序申请自己想要的资源。

#### 读写锁

读锁：可以有多个线程持有，因此是共享锁

写锁：只能有一个线程持有，因此是互斥锁

- 优先算法

    - 读优先：线程A获取读锁后，接着线程B获取写锁时会阻塞，此时线程C也想获取读锁，即使在有线程B被阻塞的情况依然获取读锁

    ![image](./Pictures/linux-kernel/process-read_lock.avif)

    - 写优先：线程 C 获取读锁时会阻塞，而不是读优先的可以获取

    ![image](./Pictures/linux-kernel/process-write_lock.avif)

    - 不管是读优先、写优先都有另一方被饿死的情况

#### 乐观锁、悲观锁

悲观锁：互斥锁、自旋锁、读写锁

- 乐观锁：先修改完共享资源，再验证这段时间内有没有发生冲突，如果没有其他线程在修改资源，那么操作完成，如果发现有其他线程已经修改过这个资源，就放弃本次操作。

    - 乐观锁虽然去除了加锁解锁的操作，但是一旦发生冲突，重试的成本非常高，所以只有在冲突概率非常低，且加锁成本非常高的场景时，才考虑使用乐观锁。

    - 通过`版本号`检验冲突：带上原始版本号，服务器收到后将它与当前版本号进行比较，如果版本号不一致则提交失败，如果版本号一致则修改成功，然后服务端版本号更新到最新的版本号。

- 例子：

    - 在线编辑文档

    - SVN 和 Git 也是用了乐观锁的思想，先让用户编辑代码，然后提交的时候，通过版本号来判断是否产生了冲突，发生了冲突的地方，需要我们自己修改后，再重新提交。

### socket

- 可以跨网，也可以在同一主机下通信

### init 进程

- linux 进程在树中排序。每个进程都可以产生子进程，并且除了最顶层的进程之外，每个进程都有一个父进程。

- 一旦我们启动了多个进程，那么容器里就会出现一个 pid 1，也就是我们常说的 1 号进程或者 init 进程，然后由这个进程创建出其他的子进程。接下来，我带你梳理一下 init 进程是怎么来的。

    - 一个 Linux 操作系统，在系统打开电源，执行 BIOS/boot-loader 之后，就会由 boot-loader 负责加载 Linux 内核。Linux 内核执行文件一般会放在 /boot 目录下，文件名类似 vmlinuz*。在内核完成了操作系统的各种初始化之后，这个程序需要执行的第一个用户态程就是 init 进程。

    - 内核代码启动 1 号进程的时候，在没有外面参数指定程序路径的情况下，一般会从几个缺省路径尝试执行 1 号进程的代码。这几个路径都是 Unix 常用的可执行代码路径。

    - 系统启动的时候先是执行内核态的代码，然后在内核中调用 1 号进程的代码，从内核态切换到用户态。

    - 目前主流的 Linux 发行版，无论是 RedHat 系的还是 Debian 系的，都会把 /sbin/init 作为符号链接指向 Systemd。Systemd 是目前最流行的 Linux init 进程，在它之前还有 SysVinit、UpStart 等 Linux init 进程。

- PID 1在处理kill信号的特别之处

    > 与其他进程不同的是：

    - PID 1它会忽略具有默认操作的任何信号。因此除非经过编码，否则应用没有监听 SIGTERM 信号，或者应用中没有实现处理 SIGTERM 信号的逻辑，应用就不会停止。比如默认的Bash与C语言的程序，是没有注册SIGTERM 信号的handler；

    - PID 1永远不会响应 SIGKILL 和 SIGSTOP 这两个特权信号；

    - 对于其他的信号，如果用户自己注册了 handler，1 号进程可以响应。

## 线程（Thread）

- 对比进程：

    - 优点：

        - 创建和终止时间更快
        - 线程切换更快。不像进程那样需要切换页表
        - 线程之间的通信效率更高。**用户线程**在数据传递的时候，就不需要经过内核

    - 缺点：

        - 当进程中的一个线程崩溃时，会导致其所属进程的所有线程崩溃

            - [小林coding：线程崩溃了，进程也会崩溃吗？](https://www.xiaolincoding.com/os/4_process/thread_crash.html)

            - 线程崩溃后，内核会发送kill信号让进程退出

            - 如果进程没有注册自己的信号处理函数，那么操作系统会执行默认的信号处理程序（一般最后会让进程退出）

                - JVM 自己定义了信号处理函数，这样当发送 kill pid 命令（默认会传 15 也就是 SIGTERM）后，JVM 就可以在信号处理函数中执行一些资源清理之后再调用 exit 退出。

- TCB（Thread Control Block, 线程控制块）

- 3种线程：

    - 用户线程（User Thread）： TCB是在库里面来实现的，对于操作系统而言是看不到这个 TCB 的，它只能看到整个进程的 PCB。

        - 优点：

            - 用户线程切换也是由线程库函数来完成的，无需用户态与内核态的切换，所以速度特别快

        - 缺点：

            - 除非它主动地交出 CPU 的使用权，否则它所在的进程当中的其他线程无法运行

            - 由于时间片分配给进程，故与其他进程比，在多线程执行时，每个线程得到的时间片较少

    - 内核线程（Kernel Thread）：TCB 放在操作系统里的，操作系统负责线程的创建、终止和管理

        - 优点：某个内核线程发起系统调用而被阻塞，并不会影响其他内核线程的运行
        - 缺点：线程的创建、终止和切换都是通过系统调用的方式来进行，开销更大

    - 轻量级线程（LightWeight Process, LWP）：内核中来支持用户线程

- 不同线程的对应关系：

    | 用户线程和内核线程的对应关系 |                                                |
    |------------------------------|------------------------------------------------|
    | 多对一：                     | ![image](./Pictures/linux-kernel/thread.avif)  |
    | 一对一：                     | ![image](./Pictures/linux-kernel/thread1.avif) |
    | 多对多：                     | ![image](./Pictures/linux-kernel/thread2.avif) |

    - LWP 和内核线程是：一对一

    - 用户线程和LWP的对应关系跟内核线程一样，有3种对应关系：

        ![image](./Pictures/linux-kernel/thread3.avif)

        - 一对一模式（图片上的进程4）：一个用户线程 -> 一个 LWP -> 一个内核线程

            - 优点：当一个 LWP 阻塞，不会影响其他 LWP
            - 缺点：每一个用户线程，就产生一个内核线程，创建线程的开销较大。

        - 多对一模式（图片上的进程2）：

            - 优点：用户线程要开几个都没问题，且上下文切换发生用户空间，切换的效率较高
            - 缺点：一个用户线程如果阻塞了，则整个进程都将会阻塞，另外在多核 CPU 中，是没办法充分利用 CPU 的。

        - 多对多模式（图片上的进程3）：

            - 优点：综合了前两种优点，大部分的线程上下文发生在用户空间，且多个线程又可以充分利用多核 CPU 的资源。

        - 组合模式（图片上的进程5）：综合了一对一，多对多。开发人员可以针对不同的应用特点调节内核线程的数目来达到物理并行性和逻辑并行性的最佳方案。

- [小林coding：一个进程最多可以创建多少个线程？](https://www.xiaolincoding.com/os/4_process/create_thread_max.html)

- 32位：用户内存为3G
- 64位：用户内存128T

- 查看进程创建线程时默认分配的栈空间大小

    ```sh
    # 为8M
    ulimit -a | grep 'stack size'
    -s: stack size (kbytes)             8192
    ```

    - 32位只有3G，假设一个线程需要占用 10M 虚拟内存，最多大概能创建300 个（3G/10M）左右的线程
        ```sh
        # 可以缩小为512K，从而创造更多的线程
        ulimit -s 512
        ```

- 64为的用户空间有128T,根本用不完。可创建线程还会受以下参数影响

    ```sh
    # 最大线程数
    cat /proc/sys/kernel/threads-max
    63059

    # pid、tid的数量。超过这个数就不能创建进程和线程
    cat /proc/sys/kernel/pid_max
    4194304

    # 一个进程可以拥有的最大虚拟内存区域数量。如果它的值很小，也会导致创建线程失败
    cat /proc/sys/vm/max_map_count
    65530
    ```

## 调度

- 非抢占式调度算法：

    ```mermaid
    flowchart LR
        直到进程被阻塞或者直到该进程退出 ==> 才会调用另外一个进程
    ```

- 抢占式调度算法：只运行某段时间，如果在该时段结束时，该进程仍然在运行时，则会把它挂起，接着从就绪队列挑选另外一个进程：

    ```mermaid
    flowchart LR
        进程 == 只运行某段时间 ==> 挂起.接着从就绪队列挑选另外一个进程
    ```

| 调度指标   |                                                                                                                                               |
|------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| CPU 利用率 | 程序发生了 I/O 事件的请求，那 CPU 使用率必然会很低，调度程序需要从就绪队列中选择一个进程来运行                                                |
| 系统吞吐量 | 单位时间内 CPU 完成进程的数量，长作业的进程会占用较长的 CPU 资源，因此会降低吞吐量，相反，短作业的进程会提升系统吞吐量                       |
| 周转时间   | 周转时间是进程运行+阻塞时间+等待时间的总和，如果进程的等待时间很长而运行时间很短，那周转时间就很长，一个进程的周转时间越小越好               |
| 等待时间   | 进程处于就绪队列的时间，等待的时间越长，用户越不满意                                                                                          |
| 响应时间   | 用户提交请求到系统第一次产生响应所花费的时间，对于鼠标、键盘这种交互式比较强的应用，我们当然希望它的响应时间越快越好，否则就会影响用户体验了 |

### 调度器

- 调度器由调度类（例如cfs、rt、stop、deadline、idle等，都是调度类）与通用调度模块组成（主要在core.c）。

- 调度完整运行，需要抢占、切换机制的支持，需要有调度的上下文进程/线程。

- 首选可以通过clone、fork、execv等创建进程。抢占包括设置抢占标志need_schded、执行抢占两部分。设置抢占标志一般由调度类支持，例如cfs分配的quota到期，设置抢占标志；更高优先级的进程到来，设置抢占标志。

- 抢占，分为用户态抢占和内核态抢占

    - 一般只打开用户态抢占，只有实时性要求非常高的场景，考虑打开内核态抢占。

    - 用户态抢占：在用户态运行时，由syscall、中断、缺页异常等陷入内核，再返回用户态时（entry_64.S），会判断是否有need_sched抢占标志，如果有，则执行抢占，通过schedule()选择新进程执行。

        - 在schedule()完成进程上下文切换，进程A切换到进程B，进程A->schedule()->进程B，保存进程A的寄存器上下文，恢复进程B的寄存器上下文，从而完成切换。

    - 内核态抢占：则是在内核态运行时，触发异常后，执行抢占，例如中断、tick等到来可以执行抢占。

- 调度类按照优先级，包括stop（主要用于核间通信等）、deadline、RT、cfs、idle等。

    ![image](./Pictures/linux-kernel/process-调度器.avif)

### 调度算法

- 非抢占式的先来先服务（First Come First Serve, FCFS）：从就绪队列选择最先进入队列的进程，然后一直运行，直到进程退出或被阻塞

    - 对长作业有利，不利于短作业。适用于 CPU 繁忙型作业的系统，而不适用于 I/O 繁忙型作业的系统

    ![image](./Pictures/linux-kernel/process-FCFS.avif)

- 最短作业优先（Shortest Job First, SJF）：优先选择运行时间最短的进程来运行，这有助于提高系统的吞吐量。

    - 缺点：会使得长作业不断的往后推，周转时间变长，致使长作业长期不会被运行

    ![image](./Pictures/linux-kernel/process-SJF.avif)

- 高响应比优先调度算法 （Highest Response Ratio Next, HRRN）：权衡了短作业和长作业

    - 调度时先计算「响应比优先级」，然后把「响应比优先级」最高的进程投入运行

        $$响应比优先级 = {等待时间 + 要求服务时间 \over 要求服务时间}$$

        - 「等待时间」相同时，「要求的服务时间」越短，「响应比」就越高。短作业会被选中
        - 「要求的服务时间」相同时，「等待时间」越长，「响应比」就越高。长作业会被选中

    - 但由于进程「要求的服务时间」无法预知。这只是个理性算法

- 时间片轮转（Round Robin, RR）：每个进程被分配一个时间片，时间片用完，进程还在运行，并把 CPU 分配给另外一个进程

    - 时间片长度：一般为 `20ms~50ms`

        - 太短：导致过多的进程上下文切换，降低了 CPU 效率
        - 太长：又可能引起对短作业进程的响应时间变长

- 最高优先级（Highest Priority First，HPF）：

    - 两种优先级

        - 静态优先级：创建进程时候，就已经确定了优先级了，然后整个运行时间优先级都不会变化；
        - 动态优先级：根据进程的动态变化调整优先级，比如如果进程运行时间增加，则降低其优先级，如果进程等待时间（就绪队列的等待时间）增加，则升高其优先级

    - 该算法也有两种处理优先级高的方法，非抢占式和抢占式：

        - 非抢占式：当就绪队列中出现优先级高的进程，运行完当前进程，再选择优先级高的进程。
        - 抢占式：当就绪队列中出现优先级高的进程，当前进程挂起，调度优先级高的进程运行。

    - 缺点：低优先级的进程永远不会运行

- 多级反馈队列（Multilevel Feedback Queue，MFQ）：综合「时间片轮转算法」和「最高优先级算法」

    ![image](./Pictures/linux-kernel/process-MFQ.avif)

    - 「多级」表示有多个队列，每个队列优先级从高到低，同时优先级越高时间片越短

        - 如果在第一级队列规定的时间片没运行完成，则将其转入到第二级队列的末尾，以此类推，直至完成

    - 「反馈」如果进程运行时，有新进程进入较高优先级的队列，则停止当前运行的进程并将其移入到原队列末尾，接着让较高优先级的进程运行

    - 顾了长短作业，同时有较好的响应时间

### [鹅厂架构师：EEVDF替代CFS？离在线混部调度器变革解读](https://zhuanlan.zhihu.com/p/692778655)

- CFS（Completely Fair Scheduler，完全公平调度器)

    - CFS用于Linux系统中普通进程的调度。它给cfs_rq（cfs的run queue）中的每一个进程设置一个虚拟时钟，vruntime。

        - 如果一个进程得以执行，随着时间的增长（一个个tick的到来），其vruntime将不断增大。没有得到执行的进程vruntime不变。

        - 调度器总是选择vruntime跑得最慢的那个进程来执行。这就是所谓的“完全公平”。

        - 为了区别不同优先级的进程，优先级高的进程vruntime增长得慢，以至于它可能得到更多的运行机会。

    - CFS不区分具体的cpu算力消耗型进程，还是io消耗型进程，统一采用红黑树算法来管理所有的调度实体sched_entity，算法效率为O(log(n))。

    - 缺点：

        - CFS 主要着眼于以权重方式将 CPU 时间公平分配，但对延迟要求的处理却不够完善。
            - 例子：有些任务的性质上并不需要大量的 CPU 时间，但一旦有需求时，则期望可以尽快获得之。
            - 例子：反之，有些任务虽然对 CPU 需求很大，但必要的时候可以等待。

        - 而 CFS 中的 nice 值仅能赋予任务更多 CPU 时间，却无法表达任务对获得 CPU 资源之延迟的期待。
            - 即便在 CFS 中针对延迟敏感的任务是可以选择 realtime class(rt_sched_class)，但后者是属于 privileged 的选项，意味着过度的使用之反而会造成系统其他部分的不良影响。

- EEVDF: Earliest Eligible Virtual Deadline First:

    - EEVDF 的设计源自于 Earliest Eligible Virtual Deadline First：[A Flexible and Accurate Mechanism for Proportional Share Resource Allocation](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=805acf7726282721504c8f00575d91ebfd750564) 这篇论文。

    - 让我们简单理解 EEVDF 的想法：
        - 想象有 5 个 process 共享一个 CPU 的情境，那么 CPU 时间根据 nice value 按照对应的比例分配，这点与 CFS 的想法相同。
        - 假设 process 的 nice 值相同，那么经过 1 秒钟后，理想情况下每个 process 预期都各自使用了 200ms。
            - 不过实际上因为各种原因，每个 process 得到的时间可能多少偏移 200ms 一点。对此 EEVDF 计算实际得到之时间和 200ms 的差距，这个差异值称为 "lag"。
                - 借此，EEVDF 知道 lag 值为正的 process 与其他人相比得到的 CPU 时间更少，那么之后它将比起 lag 为负的 process 被更早的调度。


    - 只有一个 process 计算得到的 lag 大于或等于零时，才被视为符合资格，反之，任何 lag 为负者都没有资格运行。

        - 对于不符资格的 process，因为要随着时间前进，其有权获得的时间才会变多，要等到其有权获得的时间时赶上实际获得的时间后，它才能再次获得资格。这段时间差被称为 "eligible time"。
            - 综上所述，如何正确且精准地计算 lag 即为 EEVDF 算法中的一大关键。

    - 另一个 EEVDF 中的重要之处是 "virtual deadline" 的概念。这代表着 process 可以获得应得的 CPU 的最早时间，可以通过将 process 分配到的 time slice 加上 eligible time 来得到。而 EEVDF 的精神即是挑选 virtual deadline 最早的 process。

        - 在这个框架下，调度器在分配 time slice 考虑 latency-nice 值：
            - latency-nice 较低的 process 表示对于延迟要求严格，会获得较少的 time slice
            - 而对延迟较不关心的 process 的 latency-nice 较高，并得到较长的 time slice。
            - 注意到两个 process 得到的 CPU 时间是相同的，只是 latency-nice 低的是以多个短的 time slice 来得到这个总量，latency-nice 高者则是以少但是长的 time slice 取得。

- 对比CFS, EEVDF不仅考虑了任务的权重（nice value）, 还考虑了任务的请求时长(lnice), 对延迟敏感的任务slice值设置低，从而获得比较早的deadline 时间， 也因此获得更早的调度机会。

## 中断

### 硬中断

- 中断处理流程：
    - 1.抢占当前任务：内核必须暂停正在执行的进程
    - 2.执行中断处理函数（ISR）：找到对应的中断处理函数，将 CPU 交给它（执行）
    - 3.中断处理完成之后，处理器恢复执行被中断的进程

| 外部硬件中断                                 |
|----------------------------------------------|
| I/O interrupts（IO 中断）                    |
| Timer interrupts（定时器中断）               |
| Interprocessor interrupts（IPI，进程间中断） |

```sh
# 最大硬中断数量。有 16 个是预分配的 IRQs
sudo dmesg | grep NR_IRQS
[    0.000000] NR_IRQS: 20736, nr_irqs: 1096, preallocated irqs: 16
```

### 软中断

- 每个 CPU 上会初始化一个 ksoftirqd 内核线程，负责处理各种类型的 softirq 中断事件

    ```sh
    # 查看ksoftirqd
    systemd-cgls -k | grep softirq 
    ```

    ```sh
    # 软中断的cpu开销
    top | grep -i si
    ```

- softirqs 是在 Linux 内核编译时就确定好的。一共 9 种 softirq。如果想加一种新 softirq 类型，就需要修改并重新编译内核
    ```c
    // include/linux/interrupt.h

    enum {
        HI_SOFTIRQ=0,          // tasklet
        TIMER_SOFTIRQ,         // timer
        NET_TX_SOFTIRQ,        // networking
        NET_RX_SOFTIRQ,        // networking
        BLOCK_SOFTIRQ,         // IO
        IRQ_POLL_SOFTIRQ,
        TASKLET_SOFTIRQ,       // tasklet
        SCHED_SOFTIRQ,         // schedule
        HRTIMER_SOFTIRQ,       // timer
        RCU_SOFTIRQ,           // lock
        NR_SOFTIRQS
    };
    ```
    ```sh
    # 等同于上面的类型
    cat /proc/softirqs
                  CPU0     CPU1
          HI:        2        0
       TIMER:   443727   467971
      NET_TX:    57919    65998
      NET_RX:    28728  5262341
       BLOCK:      261     1564
    IRQ_POLL:        0        0
     TASKLET:       98      207
       SCHED:  1854427  1124268
     HRTIMER:    12224    68926
         RCU:  1469356   972856
    ```

#### tasklet：动态机制，基于 softirq

- 可以在运行时（runtime）创建和初始化的 softirq

- 永远运行在指定 CPU

#### workqueue：动态机制，运行在进程上下文

- softirq 和 tasklet 依赖软中断子系统，运行在软中断上下文中

- workqueue 不依赖软中断子系统，运行在内核进程上下文中

    - 不能像 tasklet 那样是原子

- Workqueue工作队列是利用内核线程来异步执行工作任务的通用机制

```sh
systemd-cgls -k | grep kworker
```

# 磁盘和文件系统

![image](./Pictures/linux-kernel/io-layer.avif)
![image](./Pictures/linux-kernel/io-layer1.avif)
![image](./Pictures/linux-kernel/io-layer2.avif)

## 磁盘调度算法

- [小林coding：进程调度/页面置换/磁盘调度算法](https://www.xiaolincoding.com/os/5_schedule/schedule.html#%E7%A3%81%E7%9B%98%E8%B0%83%E5%BA%A6%E7%AE%97%E6%B3%95)

![image](./Pictures/linux-kernel/disk.avif)

- 寻道的时间是磁盘访问最耗时的部分，如果请求顺序优化的得当，必然可以节省一些不必要的寻道时间，从而提高磁盘的访问性能。

- 假设初始磁头当前的位置是在第 53 磁道。有下面一个请求序列，每个数字代表磁道的位置：98，183，37，122，14，124，65，67

- 先来先服务（First-Come，First-Served，FCFS）：先到来的请求，先被服务

    - 总共移动了 640 个磁道的距离

    - 缺点：如果大量进程竞争使用磁盘，请求访问的磁道可能会很分散，在性能上就会显得很差，因为寻道时间过长。

    ![image](./Pictures/linux-kernel/disk-algorithm.avif)

- 最短寻道时间优先（Shortest Seek First，SSF）：优先选择从当前磁头位置所需寻道时间最短的请求

    - 那么请求的顺序变为：65，67，37，14，98，122，124，183

    - 总共移动了总 236 个磁道

    - 缺点：有饥饿问题。磁头有可能再一个小区域内来回得移动。

    ![image](./Pictures/linux-kernel/disk-algorithm1.avif)

- 扫描算法（Scan）：也叫电梯算法。按一个方向移动，直到在那个方向上没有请求为止，然后改变方向。

    - 先朝磁道号减少的方向移动，那么请求的顺序变为：37，14，0，65，67，98，122，124，183

    - 缺点：虽不会产生饥饿现象，但是存在这样的问题，中间部分的磁道会比较占便宜，中间部分相比其他部分响应的频率会比较多，也就是说每个磁道的响应频率存在差异。

    ![image](./Pictures/linux-kernel/disk-algorithm2.avif)

- 循环扫描（Circular Scan, CSCAN ）：按一个方向移动，直到在那个方向上没有请求为止，返回时直接快速移动至最靠边缘的磁道，但中途不处理任何请求

    - 对比扫描算法，对于各个位置磁道响应频率相对比较平均

    ![image](./Pictures/linux-kernel/disk-algorithm3.avif)

- LOOK 与 C-LOOK算法： SCAN 算法的优化。移动到最远的请求位置，然后立即反向移动，而不需要移动到磁盘的最始端或最末端

    LOOK
    ![image](./Pictures/linux-kernel/disk-algorithm4.avif)

    C-LOOK
    ![image](./Pictures/linux-kernel/disk-algorithm5.avif)


## 文件系统

![image](./Pictures/linux-kernel/fs架构.avif)

- 一切皆文件：每个文件有两个数据结构

    - inode（索引节点）：索引节点是文件的唯一标识，也会被存储在硬盘中。记录文件的元信息，比如 inode 编号、文件大小、访问权限、创建时间、修改时间、数据在磁盘的位置等等。

    - dentry（目录项）：记录文件的名字。由内核维护的一个数据结构，不存放于磁盘，而是缓存在内存。

        - 查询目录频繁从磁盘读，效率会很低，所以内核会把已经读过的目录用目录项这个数据结构缓存在内存

- 文件系统格式化时，分成三个存储区域

    - 超级块：用来存储文件系统的详细信息，比如块个数、块大小、空闲块等等
        - 当文件系统挂载时进入内存

    - 索引节点区：用来存储索引节点
        - 当文件被访问时进入内存

    - 数据块区：用来存储文件或目录数据

    ![image](./Pictures/linux-kernel/fs.avif)

- VFS对用户提供统一的接口，这样程序员不需要了解文件系统的工作原理

    ![image](./Pictures/linux-kernel/fs-vfs.avif)

- 操作系统为每个进程维护一个打开文件表，文件表里的每一项代表「文件描述符」

    | 文件表维护的信息 | 内容                                                                |
    |------------------|---------------------------------------------------------------------|
    | 文件指针         | 上次读写位置作为当前文件位置指针                                    |
    | 文件打开计数器   | 多个进程可能打开同一个文件，当该计数为 0 时才会关闭文件，删除该条目 |
    | 文件磁盘位置     | 该信息保存在内存中，以免每个操作都从磁盘中读取                      |
    | 访问权限         | 创建、只读、读写、添加等                                            |

- 文件系统的基本操作单位是数据块：用户习惯以字节的方式读写文件，而操作系统则是以数据块来读写文件，那屏蔽掉这种差异的工作就是文件系统了。

    - 用户进程从文件读取时：文件系统则需要获取字节所在的数据块，再返回数据块对应的用户进程所需的数据部分。

    - 用户进程写数据进文件时：文件系统则找到需要写入数据的数据块的位置，然后修改数据块中对应的部分，最后再把数据块写回磁盘。

- [无聊的闪客：你管这破玩意叫文件系统](https://mp.weixin.qq.com/s/q6OjwCXSk05TvX_BIu1M0g)

### 文件的存储

- 连续空间存放方式

    - 文件存放在磁盘「连续的」物理空间中，但必须先知道一个文件的大小

    - inode（文件头）里需要指定「起始块的位置」和「长度」

    ![image](./Pictures/linux-kernel/fs-file-save.avif)

    - 优点：读写效率高

    - 缺点：

        - 1.磁盘空间碎片
            ![image](./Pictures/linux-kernel/fs-file-save1.avif)

        - 2.文件长度不易扩展

            - 例如上图中的文件 A 要想扩大一下，需要更多的磁盘空间，唯一的办法就只能是挪动的方式

- 非连续空间存放方式

    - 优点：消除磁盘碎片，文件的长度可以动态扩展

    - 链表方式

        - 隐式链表：inode（文件头）要包含「第一块」和「最后一块」的位置，并且每个数据块里面留出一个指针空间，用来存放下一个数据块的位置

            - 缺点：

                - 无法直接访问数据块，只能通过指针顺序访问文件，以及数据块指针消耗了一定的存储空间

                - 如果软件或者硬件错误导致链表中的指针丢失或损坏，会导致文件数据的丢失。

            ![image](./Pictures/linux-kernel/fs-file-save2.avif)

        - 显式链接：把用于链接文件各数据块的指针，显式地存放在内存的一张文件分配表（File Allocation Table，FAT）

            - 缺点：整个表都存放在内存中的关系，不适用于大磁盘。

                - 对于 200GB 的磁盘和 1KB 大小的块，这张表需要有 2 亿项，每一项对应于这 2 亿个磁盘块中的一个块，每项如果需要 4 个字节，那这张表要占用 800MB 内存

    - 索引方式：

        - 为每个文件创建一个「索引数据块」（相当于书的目录），里面存放的是指向文件数据块的指针列表

        - 优点：

            - 文件的创建、增大、缩小很方便
            - 不会有碎片的问题
            - 支持顺序读写和随机读写

        - 缺点：

            - 需要额外分配一块来存放索引数据

        ![image](./Pictures/linux-kernel/fs-file-save3.avif)


        - 如果文件大到一个索引数据块放不下时的两种解决方法：

            - 1.链式索引块（链表 + 索引）：在索引数据块留出一个存放下一个索引数据块的指针，于是当一个索引数据块的索引信息用完了，就可以通过指针的方式，找到下一个索引数据块的信息。

                ![image](./Pictures/linux-kernel/fs-file-save4.avif)

            - 2.多级索引块（索引 + 索引）：通过一个索引块来存放多个索引数据块

                ![image](./Pictures/linux-kernel/fs-file-save5.avif)

####  Linux ext2/3 

- 组合了前面的文件存放方式的优点

    | 根据文件的大小的存放方式                                   | inode（文件头）包含 13 个指针 |
    |------------------------------------------------------------|-------------------------------|
    | 如果存放文件所需的数据块小于 10 块，则采用直接查找的方式   | 10 个指向数据块的指针         |
    | 如果存放文件所需的数据块超过 10 块，则采用一级间接索引方式 | 第 11 个指向索引块的指针      |
    | 如果前面两种方式都不够存放大文件，则采用二级间接索引方式   | 第 12 个指向二级索引块的指针  |
    | 如果二级间接索引也不够存放大文件，这采用三级间接索引方式   | 第 13 个指向三级索引块的指针  |

    ![image](./Pictures/linux-kernel/fs-file-save6.avif)

- 但是对于大文件的访问，需要大量的查询，效率比较低。ext4 做了一定的改变

### 空闲空间管理

- 效率太低：保存一个数据块，我应该放在硬盘上的哪个位置呢？难道需要将所有的块扫描一遍

- 空闲表法：

    - 当请求分配磁盘空间时：系统依次扫描空闲表里的内容，直到找到一个合适的空闲区域为止。

    - 当用户撤销一个文件时：系统回收文件空间时，也需顺序扫描空闲表，寻找一个空闲表条目并将释放空间的第一个物理块号及它占用的块数填到这个条目中。

    - 适用于建立连续文件

    ![image](./Pictures/linux-kernel/fs-file-free.avif)

- 空闲链表法：

    - 每一个空闲块里有一个指针指向下一个空闲块

    - 缺点：
        - 不能随机访问
        - 每当在链上增加或移动空闲块时需要做很多 I/O 操作
        - 指向数据块的指针消耗了一定的存储空间。

    ![image](./Pictures/linux-kernel/fs-file-free1.avif)

- 位图法：

    - 所有的盘块都有一个二进制位与之对应。当值为 0 时，表示对应的盘块空闲，值为 1 时，表示对应的盘块已分配。

    ```
    1111110011111110001110110111111100111 ...
    ```

#### linux ext2

- 采用位图法。不仅用于数据空闲块的管理，还用于 inode 空闲块的管理

    - 位图是放在磁盘块里的，一个块 4K 可以存放 `4 * 1024 * 8 = 2^15` 个数据块，大小为 `2^15 * 4 * 1024 = 2^27` 个 byte，也就是 128M。

    | 块组                  | 存储的信息                                                                                                             |
    |-----------------------|------------------------------------------------------------------------------------------------------------------------|
    | 引导块                | 在系统启动时用于启用引导                                                                                               |
    | 超级块                | 包含的是文件系统的重要信息，比如 inode 总个数、块总个数、每个块组的 inode 个数、每个块组的块个数等等                   |
    | 块组描述符            | 包含文件系统中各个块组的状态，比如块组中空闲块和 inode 的数目等，每个块组都包含了文件系统中「所有块组的组描述符信息」 |
    | 数据位图和 inode 位图 | 用于表示对应的数据块或 inode 是空闲的，还是被使用中                                                                    |
    | inode 列表            | 包含了块组中所有的 inode，inode 用于保存文件系统中与各个文件和目录相关的所有元数据                                     |
    | 数据块                | 包含文件的有用数据                                                                                                     |

    ![image](./Pictures/linux-kernel/fs-file-free2.avif)

    - Ext2 的后续版本采用了稀疏技术。该做法是，超级块和块组描述符表不再存储到文件系统的每个块组中，而是只写入到块组 0、块组 1 和其他 ID 可以表示为 3、 5、7 的幂的块组中。

### 目录的存储

- 列表保存格式：一项一项地将目录下的文件信息（如文件名、文件 inode、文件类型等）

    ![image](./Pictures/linux-kernel/fs-dir-save.avif)

- 如果一个目录有超级多的文件，保存目录的格式改成哈希表

- 为了减少 I/O 操作，会把当前使用的文件目录缓存在内存

### 硬链接、软链接

- 硬链接（Hard Link） 是不可用于跨文件系统的。由于多个目录项都是指向一个 inode，那么只有删除文件的所有硬链接以及源文件时，系统才会彻底删除该文件。

    ![image](./Pictures/linux-kernel/fs-hard_link-save.avif)

- 软链接（Symbolic Link）相当于重新创建一个文件，这个文件有独立的 inode，但是这个文件的内容是另外一个文件的路径，所以访问软链接的时候，实际上相当于访问到了另外一个文件

    - 软链接是可以跨文件系统的，甚至目标文件被删除了，链接文件还是在的，只不过指向的文件找不到了而已。

    ![image](./Pictures/linux-kernel/fs-symbolic_link-save.avif)

### loop设备

- [Linux 式套娃，把“文件系统”安装在一个“文件”上？](https://mp.weixin.qq.com/s/UqJ7h3PSCF-bBj_aqxOSzw)

- loop 设备的典型应用有哪些？

    - 系统模拟和测试：可以使用 loop 设备来模拟不同的存储配置，无需使用物理硬件，就可以进行软件测试或系统配置实验。
    - 文件系统开发：开发者可以使用 loop 设备来挂载文件系统，从而方便地测试和调试新的文件系统。
    - ISO 映像挂载：Loop 设备还常用于挂载 ISO 文件，无需刻录到物理介质上，使其内容可直接访问。
    - 加密磁盘：loop 设备还能和一些加密技术（如dm-crypt）结合，因为 loop 设备可以绑定几乎任意类型的文件，这就给了人们无限的想象空间。我们可以创建一个加密的磁盘镜像，增强数据安全。
    - 其实，Linux 的套娃还远不止这些。举个例子，loop 设备绑定的文件，它可能也是抽象出来的一个文件，比如是一个网络文件系统抽象出来的文件。那这条 I/O 链路就更长了。只要你敢想，在 Linux 中，存在无限套娃的可能。

- loop 设备的原理

    - loop 就是一种特殊的块设备驱动。loop 设备是一种 Linux 虚拟的伪设备，它和真实的块设备不同，它并不代表一种特定的硬件设备，而仅仅是满足 Linux 块设备接口的一个虚拟设备。它的作用就是把一个文件模拟成一个块设备。


- loop 设备它是怎么模拟的块设备？

    - loop 设备的代码位于 Linux 的 drivers/block/loop.c 中。在这个文件中，它定义了块设备驱动的接口。

    - 块设备驱动的编程范式：

        - 1.首先，要分配并初始化一个 `gendisk` 结构体，这是内核代表块设备的核心结构体。它包含了与磁盘相关的信息，loop 设备作为一种特殊的块设备驱动，这个自然是不能少的。
        - 2.然后，初始化一个请求队列。块设备使用请求队列来管理对设备的 I/O 请求。文件系统调用 `submit_bio` 的调用时，最终就是把请求投递到驱动的队列中。
        - 3.然后，请求处理函数。这个很容易理解，队列里的请求总是要处理的，每个块设备驱动都可以自定义处理方式。
        - 4.最后，块设备操作表（block_device_operations），这个将包含对设备的操作方法，比如打开，读写控制等。

- loop 设备如何关联到后端“文件” ？

    - 用户态的处理（ `losetup` 或 `mount` ）

        - 打开后端“文件”，拿到文件描述符。
        - 打开 loop 设备文件，拿到 loop 设备的描述符。
        - 调用 ioctl 把这两个关联起来`ioctl(dev_fd, LOOP_CONFIGURE, &lc->config)`

    - 内核的处理

        - ioctl 的系统调用对应调用 loop 中的 `lo_ioctl` 函数。
        - 对应了 `block_device_operations` 的 ioctl 方法。
        - 当设置参数为 `LOOP_CONFIGURE` 的时候，会调用 `loop_configure` 来分配和初始化 loop 设备。

        - `loop_configure`
            - 获取到后端“文件”的句柄，也就是 `struct file*` 结构。获取到之后，会做一些校验工作。然后初始化 loop 设备相关的结构体，队列等。

            - 最关键的当然还是把 loop 设备和后端“文件”的句柄关联起来：`lo->lo_backing_file = file;` 这样的话，等到读写 loop 设备的时候，就可以把请求转发过去。

#### 实验：挂载文件系统

- “文件”在文件系统之中，这是人人理解的概念。但“文件”之上还有一个文件系统？那岂不是成套娃了。但这个其实是可以的。这个就涉及到今天我们要讲的 loop 设备。

- 很多童鞋在学习 Linux 的文件系统时，涉及到对磁盘设备的格式化，挂载等操作，但苦于没有一个真实的硬盘，一时不知道如何实践。这种时候就可以使用一个文件来模拟块设备。这就是 loop 设备的作用。我们借助 loop 设备，可以让一个文件被当做一个块设备来访问。

- 举个例子，我们在 ext4 的文件系统目录下创建了一个 minix_test.img 文件，把它当作一个块设备，在上面格式化 minix 的文件系统，并挂载到 /mnt/minix 上。

    > 应用程序 -> 系统调用 -> vfs -> minix 文件系统 -> 块层 -> loop 设备 -> 绑定的文件 ->  vfs -> ext4 -> ...

    ![image](./Pictures/linux-kernel/loop设备.avif)

- 这种方式有两个很明显好处：

    - 不需要真实的硬盘，就可以格式化、挂载、测试文件系统。
    - 可以近距离的观察文件系统对块设备的使用，比如如何划分 inode 区域、数据区域、位图区域等。这些都将反馈到文件上。

- 如何使用 loop 设备？

    - 创建img文件，并格式化

        ```sh
        # 创建一个 1GiB 的文件
        dd if=/dev/zero of=./minix_test.img bs=1M count=1024
        # 格式化
        mkfs.minix ./minix_test.img
        ```

    - 1.直接 `mount -o loop` 的参数。这种省去了显式创建 loop 设备的过程，步骤简单。

        ```sh
        # 用 loop 设备的方式进行挂载
        mount -o loop ./minix_test.img /mnt/minix/
        ```

    - 2.先显式的创建 loop 设备，该 loop 设备绑定一个文件，并提供了块设备的对外接口。我们就可以把这个 loop 设备当作一个普通的块设备文件，进行格式化，然后挂载到目录上。

        ```sh
        # 方式一：假定 /dev/loop5 是空闲可用的 loop 设备，下面把 /dev/loop5 和 minix_test.img 关联起来
        losetup /dev/loop5 ./minix_test.img

        # 方式二：可以简单一点，让 losetup 命令自动找到一个空闲的 loop 设备，然后进行关联
        losetup --find --show ./minix_test.img

        # 假设上一个步骤创建的是 /dev/loop5
        mount /dev/loop5 /mnt/minix
        ```

- 测试

    ```sh
    # 在/mnt/minix上创建文件
    echo "hello world" >> /mnt/minix/hello.txt

    # 查看 minix_test.img 的内容
    hexdump -C ./minix_test.img
    ```

### FUFE用户态挂载文件系统

- [奇伢云存储：用户态文件系统挂载的两种方式](https://mp.weixin.qq.com/s/whOFPXyozrTXK8dg2Aluiw)

- 用户态文件系统的挂载本质上是：为了建立用户态的守护进程、内核fuse文件系统、挂载点这三者之间的关联。

    - 串联这三者之间的桥梁就是 `/dev/fuse` 设备文件。构建关联之后，在应用程序发出的I/O请求，就能够传递到对应的守护进程中处理。

    ![image](./Pictures/linux-kernel/fuse文件系统.avif)

- 用户态文件系统挂载，最关键的就是对`/dev/fuse`的处理而已。描述如：

    - 1.打开 `/dev/fuse` 设备，获得一个文件描述符。假设 fd=7。
    - 2.以此文件描述符（fd=7），构造内核fuse文件系统专用的参数，调用Mount系统调用进行挂载。
    - 3.挂载完成之后，守护进程就可以作为一个服务端，监听这个文件描述符（fd=7）的可读数据，然后进行处理。

    - 也就是说，挂载的最关键的是对 `/dev/fuse` 设备文件的处理。

- 挂载的两种方式

    - 对于上述的挂载过程，通常是由FUSE公共库来完成，最出名的就是C语言的libfuse库，这也是官方的FUSE库。

    - 但FUSE机制用户态的实现是不限制编程语言的，在Go语言，我们也可以挂载和实现用户态文件系统。

        - 对于Go语言的FUSE库来说，通常来讲，有两种方式进行挂载：

            - 1.使用Mount系统调用：直接处理 `/dev/fuse` 的细节，直接进行挂载。

                - 优点：是更部署更简单，不需要第三方的工具依赖。
                - 缺点：是实现稍复杂，需要显式的处理/dev/fuse，针对性构造fuse文件系统需要的挂载参数，相对要复杂一些。对FUSE底层原理要熟悉。

            - 2.使用`fusermount`挂载工具：先用fusermount进行挂载，然后通过UNIX域套接字回传 /dev/fuse的文件描述符。

                - 优点：是使用更简单，fusermount帮我们屏蔽了对/dev/fuse设备和Mount参数构造的显式处理。
                - 缺点：但它部署的时候，对fusermount工具就有了依赖，要求Linux上必须安装fusermount工具。

            - 以上省去代码...

### 自制FUFE用户态文件系统

- [奇伢云存储：自制文件系统 — 02 FUSE 框架，开发者的福音](https://mp.weixin.qq.com/s/sLKGhy3iI0jnjXE6iDPi-g)

- 查看内核支持的文件系统
    ```sh
    # 直接去看内核模块
    ls /lib/modules/${kernel_version}/kernel/fs/
    ```

    - `.ko` 模块的知识：

        - ko 其实是 kernel object 的缩写，这类文件存在的意义其实和用户态的 `.so` 库类似，都是为了模块化的编程实践。内核把核心主干框架之外的功能拆解成模块，需要的时候就加载 ko 模块，不需要的时候卸载即可。这样带来的好处就是方便开发和使用，保持内核的核心代码极度精炼。

- 为什么文件系统的开发大家会觉得非常难？
    - 原因其实不在于实现，而在于调试和排障，因为早期文件系统的开发只能在内核之中，这个带来了非常高的门槛。
    - 内核模块的开发之所以艰难就是难在调试和排障，用户态的程序你可以随意 debug，出问题最多也就是 panic，coredump，内核态的程序出了文件就是宕机，所有现场都丢失，你只能通过日志，kdump 等手段来排查。并且内核态程序的编写是要注意非常多的规范的，比如内存分配，比用户态的要谨慎的多。

    ![image](./Pictures/linux-kernel/fs-内核文件系统请求和响应.gif)

- FUSE文件系统

    - 把 IO 路径导向用户态，由用户态程序捕获到 IO ，从而实现文件的存储，这个机制就叫 FUSE 机制。

    ![image](./Pictures/linux-kernel/fs-fufe文件系统请求和响应.gif)

- FUSE 是一个用来实现用户态文件系统的框架，这套 FUSE 框架包含 3 个组件：

    - 1.内核模块 `fuse.ko` ：用来接收 vfs 传递下来的 IO 请求，并且把这个 IO 封装之后通过管道发送到用户态；

    - 2.用户态 lib 库 `libfuse` ：解析内核态转发出来的协议包，拆解成常规的 IO 请求；

    - 3.mount 工具 `fusermount` ；

    - 这 3 个组件只为了完成一件事：让 IO 在内核态和用户态之间自由穿梭。

#### FUSE 原理

- `ls -l /tmp/fuse` 命令的演示图：

    ![image](./Pictures/linux-kernel/fs-fufe原理.avif)

    - 1.背景：一个用户态文件系统，挂载点为 /tmp/fuse ，用户二进制程序文件为 ./hello ；

    - 2.当执行 `ls -l /tmp/fuse` 命令的时候，流程如下：
        - 1.IO 请求先进内核，经 vfs 传递给内核 FUSE 文件系统模块；
        - 2.内核 FUSE 模块把请求发给到用户态，由 ./hello 程序- 2.接收并且处理。处理完成之后，响应原路返回；

    ![image](./Pictures/linux-kernel/fs-fufe原理动画.gif)

    - 通过这两张图，对 FUSE IO 的流程应该就清晰了，内核 FUSE 模块在内核态中间做协议包装和协议解析的工作，承接 vfs 下来的请求并按照 FUSE 协议转发到用户态，然后接收用户态的响应，回复给用户。

- 内核态的 `fuse.ko` 模块，用户态的 `libfuse` 库，是配套使用的，最核心的功能是协议封装和解析，当然还有运输。

    - 内核 `fuse.ko` 用于承接 vfs 下来的 io 请求，然后封装成 FUSE 数据包，转发给用户态。
    - 用户态文件系统收到这个 FUSE 数据包，它如果想要看懂这个数据包，就必须实现一套 FUSE 协议的代码，这套代码是公开透明的，属于 FUSE 框架的公共的代码，这种代码不能够让所有的用户文件系统都重复实现一遍，于是 `libfuse` 用户库就诞生了。

- `/dev/fuse`是内核态和用户态的纽带
    - 用户的 io 通过正常的系统调用进来，走到内核文件系统 fuse
    - fuse 文件系统把这个 io 请求封装起来，打包成特定的格式，通过 /dev/fuse 这个管道传递到用户态。在此之前有守护进程监听这个管道，看到有消息出来之后，立马读出来，然后利用 libfuse 库解析协议，之后就是用户文件系统的代码逻辑了。
    - 以下动画省略了拆解包的步骤
    ![image](./Pictures/linux-kernel/fs-fufe原理动画1.gif)

#### FUFE使用

- 1.判断 Linux 内核是否支持 fuse

    ```sh
    # 没有则会报错，什么都不显示表示支持fuse
    modprobe fuse

    # 或者查看内核模块目录是否有fuse
    ls /lib/modules/${kernel_version}/kernel/fs/fuse/
    ```

- 2.挂载 fuse 内核文件系统，便于管理
    - fuse 这个内核文件系统其实是可以挂载，也可以不挂载，挂载了主要是方便管理多个用户系统而已，fuse 内核文件系统的 Type 名称为 fusectl

    ```sh
    # 挂载
    mount -t fusectl none /sys/fs/fuse/connections

    # 查看
    df -aT|grep -i fusectl
    fusectl        -                   -     -     -    - /sys/fs/fuse/connections
    none           fusectl             0     0     0    - /sys/fs/fuse/connections

    # 查看所有实现的用户文件系统。对应两个目录，目录名为 Unique ID，能够唯一标识一个用户文件系统。这里表示内核 fuse 模块通过 /dev/fuse 设备文件，建立了两个通信管道，分别对应了两个用户文件系统
    ls -l /sys/fs/fuse/connections/
    # 查看有2个fuse文件系统
    df -aT|grep -i fuse
    fusectl        -                   -     -     -    - /sys/fs/fuse/connections
    /dev/nvme0n1p4 fuseblk           61G   27G   34G  44% /mnt/D
    /dev/nvme0n1p3 fuseblk           80G   47G   34G  59% /mnt/C
    gvfsd-fuse     fuse.gvfsd-fuse     0     0     0    - /run/user/1000/gvfs
    none           fusectl             0     0     0    - /sys/fs/fuse/connections

    # waiting 文件：cat 一下就能获取到当前正在处理的 IO 请求数；
    # abort 文件：该文件写入任何字符串，都会终止这个用户文件系统和上面所有的请求；
    ls -l /sys/fs/fuse/connections/58
    /sys/fs/fuse/connections/58:
    total 0
    --w------- 1 tz tz 0 Jan  2 14:04 abort
    -rw------- 1 tz tz 0 Jan  2 14:04 congestion_threshold
    -rw------- 1 tz tz 0 Jan  2 14:04 max_background
    -r-------- 1 tz tz 0 Jan  2 14:04 waiting
    ```

- 3.用户文件系统怎么挂载
    ```sh
    # ??失败率
    fusermount -o fsname=none,subtype=fusectl -- /mnt/myfs/
    fusermount: old style mounting not supported
    ```

- 以下省略文章。自制文件系统 — 03、04、05

# I/O

- [小林coding：文件系统全家桶](https://www.xiaolincoding.com/os/6_file_system/file_system.html)

- [微信：你管这破玩意叫 IO 多路复用？](https://mp.weixin.qq.com/s?src=11&timestamp=1677635997&ver=4379&signature=FHMv9hT1cgc95fpEElGCyKw3ZTIzTE*L*ZacfLz41IPLk*8iB2Kt1X6Hqk7KxIoFcQHbuX53vi6KgaZxgc-tEOBjw2ji7nDM5QIQaRqrSphcOKejfeVUZBtkGWhIVhfs&new=1)

- I/O：在计算机内存与外部设备之间拷贝数据的过程。

- 程序通过CPU向外部设备发出读指令，数据从外部设备拷贝至内存需要一段时间，这段时间CPU就没事情做了，程序就会两种选择：

    - 1.让出CPU资源，让其干其他事情
    - 2.继续让CPU不停地查询数据是否拷贝完成
    - 到底采取何种选择就是I/O模型需要解决的事情了。

- 以网络数据读取为例来分析，会涉及两个对象，一个是调用这个I/O操作的用户线程，另一个是操作系统内核。

- 当用户线程发起 I/O 调用后，网络数据读取操作会经历两个步骤：

    - 数据准备阶段：用户线程等待内核将数据从网卡拷贝到内核空间。
    - 数据拷贝阶段：内核将数据从内核空间拷贝到用户空间（应用进程的缓冲区）。

## 5种I/O模型

- Linux 系统下的 I/O 模型有 5 种：

    - 1.同步阻塞I/O（bloking I/O）
    - 2.同步非阻塞I/O（non-blocking I/O）
    - 3.I/O多路复用（multiplexing I/O）
    - 4.信号驱动式I/O（signal-driven I/O）
    - 5.异步I/O（asynchronous I/O）

    ![image](./Pictures/linux-kernel/io模型.avif)
    ![image](./Pictures/linux-kernel/io模型对比.avif)

- I/O模型的简单比喻

    - 1.阻塞 I/O 好比，你去饭堂吃饭，但是饭堂的菜还没做好，然后你就一直在那里等啊等，等了好长一段时间终于等到饭堂阿姨把菜端了出来（数据准备的过程），但是你还得继续等阿姨把菜（内核空间）打到你的饭盒里（用户空间），经历完这两个过程，你才可以离开。

    - 2.非阻塞 I/O 好比，你去了饭堂，问阿姨菜做好了没有，阿姨告诉你没，你就离开了，过几十分钟，你又来饭堂问阿姨（轮询），阿姨说做好了，于是阿姨帮你把菜打到你的饭盒里，这个过程你是得等待的。

    - 3.基于I/O 多路复用好比，你去饭堂吃饭，发现有一排窗口，饭堂阿姨告诉你这些窗口都还没做好菜，等做好了再通知你，于是等啊等（select 调用中。此过程是阻塞的，所以说多路复用IO也是阻塞IO模型），过了一会阿姨通知你菜做好了，但是不知道哪个窗口的菜做好了，你自己看吧。于是你只能一个一个窗口去确认，后面发现 5 号窗口菜做好了，于是你让 5 号窗口的阿姨帮你打菜到饭盒里，这个打菜的过程你是要等待的，虽然时间不长。打完菜后，你自然就可以离开了。

    - 4.异步 I/O 好比，你让饭堂阿姨将菜做好并把菜打到饭盒里后，把饭盒送到你面前，整个过程你都不需要任何等待。

- 缓冲与非缓冲 I/O

    - 缓冲 I/O：利用的是标准库的缓存实现文件的加速访问，而标准库再通过系统调用访问文件。

        - 标准库暂时缓存，可以减少系统调用的次数

    - 非缓冲 I/O：直接通过系统调用访问文件，不经过标准库缓存。

- 直接与非直接 I/O

    - 页缓存（page cache）：在系统调用后，会把用户数据拷贝到内核中的内存

    - `open()` 设置 `O_DIRECT` 标志：表示直接 I/O；如果没有设置过，默认使用的是非直接 I/O。

    - 直接 I/O：绕过page cache（页缓存），直接让用户态和块IO层对接

        - 自缓存应用程序（ self-caching applications ）：对于某些应用程序来说，它会有它自己的数据缓存机制。数据库就是这样的程序。

        ![image](./Pictures/linux-kernel/io-direct.avif)

    - 非直接 I/O：使用页缓存（page cache）

        | 什么情况下内核会把缓存刷到磁盘？                    |
        |-----------------------------------------------------|
        | 在调用 write 的最后，当发现内核缓存的数据太多的时候 |
        | 用户主动调用 sync，                                 |
        | 当内存十分紧张，无法再分配页面时                    |
        | 内核缓存的数据的缓存时间超过某个时间时              |

- 阻塞与非阻塞 I/O VS 同步与异步 I/O

    - socket 设置 `O_NONBLOCK` 标志，表示非阻塞 I/O ；默认是阻塞 I/O。

    - 阻塞 I/O：

        - 应用进程执行系统调用时被阻塞，直到数据从内核缓冲区复制到应用进程缓冲区中才返回。

            - 阻塞不意味着整个操作系统都被阻塞，在阻塞的过程中，其它应用进程还可以执行，所以阻塞本身不消耗 CPU 时间，这种模型的 CPU 利用率会比较高。

        - 阻塞式 I/O 工作流程翻译为简单的伪代码。

            ```py
            while True:
                # 阻塞等待客户端连接
                connection, client_address = sock.accept()
                try:
                    while True:
                        # 阻塞等待数据
                        # 读取数据
                        data = connection.recv(16)
                        # 执行其他操作
            ```

        - 服务端的线程阻塞在了两个地方：`accept()` , `read()`
        ![image](./Pictures/linux-kernel/io-blocking.gif)

        - `read()`阻塞等待的是：「内核数据准备好」和「数据从内核态拷贝到用户态」这两个过程
        ![image](./Pictures/linux-kernel/io-blocking1.gif)
        ![image](./Pictures/linux-kernel/io-blocking2.avif)

    - 非阻塞 I/O：调用 `read` 时：不断轮询，直到数据准备好

        - 数据还未到达网卡，或者到达网卡但还没有拷贝到内核缓冲区之前，这个阶段是非阻塞的
            - 应用进程执行系统调用时，内核直接返回一个错误码，然后应用进程可以继续向下运行，但是需要不断的执行系统调用来获取 I/O 操作是否完成，也称为轮询（polling）。

        - 最后一步的「数据从内核缓冲区拷贝到用户缓冲区」依然是阻塞

        - 由于 CPU 要处理更多的系统调用，因此这种模型的 CPU 利用率比较低。

        ![image](./Pictures/linux-kernel/io-Non-blocking.gif)

        ![image](./Pictures/linux-kernel/io-Non-blocking1.avif)

        - 非阻塞式 I/O 工作流程翻译为简单的伪代码。
            ```py
            while True:
                try:
                    # 内核直接返回一个错误吗
                    connection, client_address = sock.accept()
                    # 继续向下执行
                    connection.setblocking(0)
                except BlockingIOError:
                    # 处理错误
                    ...

                try:
                    # 读取数据
                    data = connection.recv(16)
                    # 执行其他操作
                    ...
                except BlockingIOError:
                    # 处理错误
                    ...
            ```

        - 方法1：每次都创建一个新的进程或线程，去调用 read 函数

            ```c
            while(1) {
              connfd = accept(listenfd);  // 阻塞建立连接
              pthread_create（doWork);  // 创建一个新的线程
            }
            void doWork() {
              int n = read(connfd, buf);  // 阻塞读数据
              doSomeThing(buf);  // 利用读到的数据做些什么
              close(connfd);     // 关闭连接，循环等待下一个连接
            }
            ```

        - 方法2：一个线程处理了多个客户端连接

            - 每 accept 一个客户端连接后，将对应的文件描述符放到一个数组里fdlist。之后使用一个的线程去不断遍历这个数组

            - 缺点：依然是用户层，需要不断系统调用

            ```c
            while(1) {
              for(fd <-- fdlist) {
                if(read(fd) != -1) {
                  doSomeThing();
                }
              }
            }
            ```

            ![image](./Pictures/linux-kernel/io-Non-blocking2.gif)

    - I/O 多路复用（`select`, `poll`, `epoll`）：将一批文件描述符通过一次系统调用传给内核，由内核层去遍历

        - 当内核数据准备好时，再以事件通知应用程序进行操作。如果没有事件发生，那么当前线程就会发生阻塞，这时 CPU 会切换其他线程执行任务

        - 这种模型可以让单个 进程/线程 具有处理多个 I/O 事件的能力，也称为事件驱动 I/O。
            - 如果一个 Web Server 没有 I/O 多路复用，那么每一个 Socket 连接都需要创建一个线程去处理，如果同时有几万个连接，那么就需要创建相同数量的线程 (可能导致的后果就是操作系统直接崩溃)，相比之下，I/O 多路复用不需要多个进程/线程创建、上下文切换的开销，系统负载更小。

        ![image](./Pictures/linux-kernel/io-multiplexing.avif)

        - I/O 多路复用 工作流程翻译为简单的伪代码。
            ```py
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server_address = ('localhost', 8080)

            ...

            inputs = [sock]
            outputs = []

            while inputs:
                # 阻塞等待套接字就绪
                readable, writable, exceptional = select.select(inputs, outputs, inputs)

                # 获取到已经就绪的套接字
                # 遍历处理读事件
                for s in readable:
                    ...

                # 遍历处理写事件
                for s in writable:
                    ...

                # 遍历处理其他事件
                for s in exceptional:
                    ...
            ```

    - 信号驱动IO模型

        ![image](./Pictures/linux-kernel/io-信号驱动模型.avif)

        - 信号驱动IO不再用主动询问的方式去确认数据是否就绪，而是向内核发送一个信号（调用sigaction的时候建立一个SIGIO的信号），然后应用用户进程可以去做别的事，不用阻塞。

        - 当内核数据准备好后，再通过SIGIO信号通知应用进程，数据准备好后的可读状态。在信号处理程序中执行系统调用`recvfrom`，将数据从内核空间 (缓冲区) 复制数据到用户空间 (进程)

        - 采用这种方式，CPU的利用率很高。不过这种模式下，在大量IO操作的情况下可能造成信号队列溢出导致信号丢失，造成灾难性后果。

        - 工作流程翻译为简单的伪代码。
            ```py
            # 信号回调函数
            def handler(signum, frame):
                # 读取数据
                data, addr = sock.recvfrom(1024)
                # 执行其他操作
                ...

            # 初始化 socket
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.bind(('localhost', 8080))

            ...

            # 注册信号回调函数
            signal.signal(signal.SIGIO, handler)

            ...

            while True:
                # 等待信号通知
                signal.pause()
            ```

    - 2.6版本的异步 I/O `aio`：「内核数据准备好」和「数据从内核态拷贝到用户态」这两个过程都不用等待。

        > 异步 I/O 与信号驱动 I/O 的区别在于，异步 I/O 的信号是通知应用进程 I/O (数据复制) 已经完成，而信号驱动 I/O 的信号是通知应用进程可以开始 I/O (数据复制) 。

        - 调用 `aio_read` 之后，就立即返回，内核自动将数据从内核空间拷贝到应用程序空间，这个拷贝过程同样是异步的，内核自动完成的

        ![image](./Pictures/linux-kernel/io-aio.avif)

        - 工作流程翻译为简单的伪代码。

            ```py
            # 异步回调函数
            # 通知应用进程 I/O (数据复制) 已经完成
            async def handle_client(reader, writer):
                while True:
                    # 直接读取数据即可
                    data = await reader.read(100)

                    # 执行其他操作
                    ...

                writer.close()

            async def main():
                # 监听端口并注册异步回调函数
                server = await asyncio.start_server(handle_client, 'localhost', 10000)
            ```


    - 5.1版本的真正异步 I/O `io_uring` ：

        - [[译] Linux 异步 I/O 框架 io_uring：基本原理、程序示例与性能压测（2020）](http://arthurchiao.art/blog/intro-to-io-uring-zh/)

        - 就是借助mmap技术，在应用程序和内核之间共享环形缓冲（ring buffer），使两者可以基于该共享内存进行交互，从而达到最小化系统调用频次（以及由此导致的系统上下文切换）的目的

        - 相比 linux-aio 提升5%左右

        - 应用：

            - Netty框架的io_uring实现目前已正在孵化阶段，而根据其作者在0.0.1.Final版本基于一个简单的echo-server的benchmarking数据来看，io_uring实现的QPS是epoll实现的3倍左右

            - Redis团队也正在考虑未来将io_uring技术整合至Redis（注14）

            - ceph已经支持io_uring了
                ```sh
                ceph config show osd.16 | grep ioring
                ```

## 非直接I/O：使用Page cache

- [小林coding：进程写文件时，进程发生了崩溃，已写入的数据会丢失吗？](https://www.xiaolincoding.com/os/6_file_system/pagecache.html)

- 进程写文件时，进程发生了崩溃，已写入的数据会丢失吗？
    - 不会。因为进程在执行 write （使用缓冲 IO）系统调用的时候，实际上是将文件数据写到了内核的 page cache，它是文件系统中用于缓存文件数据的缓冲，所以即使进程崩溃了，文件数据还是保留在内核的 page cache，我们读数据的时候，也是从内核的 page cache 读取，因此还是依然读的进程崩溃前写入的数据。

- 通过 mmap 以及 buffered I/O 将文件读取到内存空间实际上都是读取到 Page Cache 中

    ![image](./Pictures/linux-kernel/io-page_cache.avif)

- Page Cache 与 buffer cache 的共同目的都是加速数据 I/O

    - 当内存不够用时也会用 LRU 等算法淘汰缓存页

    - linux2.4之前：两者分离。Page Cache 用于缓存文件的页数据，buffer cache 用于缓存块设备（如磁盘）的块数据。

        ```sh
        # cached 为Page Cache；buffers 为buffer cache

        free -h
                       total        used        free      shared     buffers       cache   available
        Mem:           7.7Gi       4.0Gi       1.5Gi       259Mi       112Mi       2.1Gi       3.3Gi
        Swap:          2.0Gi       0.0Ki       2.0Gi
        ```

    - linux2.4之后：两者合并。如果一个文件的页加载到了 Page Cache，那么同时 buffer cache 只需要维护块指向页的指针就可以了。现在提起 Page Cache，基本上都同时指 Page Cache 和 buffer cache 两者

        - 只有那些没有文件表示的块，或者绕过了文件系统直接操作（如dd命令）的块，才会真正放到 buffer cache 里。

- Page Cache 包含： `SwapCached（匿名页）` 和 `File-backed page（文件页）`

    - `Active(file) + Inactive(file) + Shmem + SwapCached = Buffers + Cached + SwapCached`

    - `Page Cache = Buffers + Cached + SwapCached`

    ```sh
    # 查看 page cache
    cat /proc/meminfo
    ```

- Page Cache 中的每个文件都是一棵基数树（radix tree）。page 为 4KB 大小，Page Cache 由多个 page 构成，则为 4KB 的整数倍

    ![image](./Pictures/linux-kernel/io-page_cache1.avif)

- 预读机制（PAGE_READAHEAD）：read 系统调动读取 4KB 数据，实际上内核使用 readahead 机制完成了 16KB 数据的读取

    ![image](./Pictures/linux-kernel/io-page_cache2.avif)

- 文件持久化的一致性的两种方法：

    - Write Through（写穿）：write操作将数据拷贝到Page Cache后立即和下层进行同步的写操作，完成下层的更新后才返回

        - `open()`文件时，传入 `O_SYNC` flag，实现写穿

        - 优缺点：以牺牲系统 I/O 吞吐量作为代价，一旦写入不会丢失

    - Write back（写回）（默认）：写完Page Cache就可以返回了。Page Cache中被修改的内存页称之为脏页（Dirty Page），脏页在特定的时候被一个叫做pdflush(Page Dirty Flush)的内核线程写入磁盘

        - 满足以下三个条件之一就会flush

            - 当空闲内存低于一个特定的阈值时，内核必须将脏页写回磁盘，以便释放内存。
            - 当脏页在内存中驻留时间超过一个特定的阈值时，内核必须将超时的脏页写回磁盘。
            - 用户进程调用sync、fsync、fdatasync系统调用时，内核会执行相应的写回操作。

            ```sh
            # 每隔5秒一次flush
            sysctl vm.dirty_writeback_centisecs
            500

            # 超过30秒，就flush
            sysctl vm.dirty_expire_centisecs
            vm.dirty_expire_centisecs = 3000

            # 若脏页占总物理内存10％以上，就flush
            sysctl vm.dirty_background_ratio
            vm.dirty_background_ratio = 10
            ```

        - 优缺点：系统发生宕机的情况下无法确保数据已经落盘，因此存在数据丢失的问题。不过，在程序挂了，例如被 kill -9，Page Cache 中的数据操作系统还是会确保落盘

        - 一个管理线程和多个刷新线程（每个持久存储设备对应一个刷新线程）

            - 管理线程：监控设备上的脏页面情况

                - 若设备一段时间内没有产生脏页面，就销毁设备上的刷新线程

                - 若监测到设备上有脏页面，并且该设备没有创建刷新线程，那么创建刷新线程处理脏页面回写

            - 刷新线程：刷新设备上脏页面

                - 每个设备保存脏文件链表，保存的是该设备上存储的脏文件的 inode 节点。所谓的回写文件脏页面即回写该 inode 链表上的某些文件的脏页面

    | 系统调用          | 操作                                                                                                                                                                                       |
    |-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
    | fsync(intfd)      | fsync(fd)：将 fd 代表的文件的脏数据和脏元数据全部刷新至磁盘中。                                                                                                                            |
    | fdatasync(int fd) | fdatasync(fd)：将 fd 代表的文件的脏数据刷新至磁盘，同时对必要的元数据刷新至磁盘中，这里所说的必要的概念是指：对接下来访问文件有关键作用的信息，如文件大小，而文件修改时间等不属于必要信息 |
    | sync()            | sync()：则是对系统中所有的脏的文件数据元数据刷新至磁盘中                                                                                                                                   |

### Page cache的零拷贝技术

- [腾讯技术工程：从Linux零拷贝深入了解Linux-I/O](https://cloud.tencent.com/developer/article/2190176)

- [小林coding：什么是零拷贝？](https://www.xiaolincoding.com/os/8_network_system/zero_copy.html)

- 指CPU拷贝的次数为0

- 零拷贝实现思想，利用了虚拟内存这个点：多个虚拟内存可以指向同一个物理地址，可以把内核空间和用户空间的虚拟地址映射到同一个物理地址
    ![image](./Pictures/linux-kernel/io-zero-copy6.avif)

- DMA（Direct Memory Access，直接内存访问）技术

    - 没有DMA的`read()`：需要 CPU 亲自参与搬运数据
    ![image](./Pictures/linux-kernel/io-dma1.avif)

    - 有DMA的`read()`：由 DMA 控制器负责数据拷贝到内核缓冲区（Page cache）中，之后cpu再拷贝到用户缓冲区
    ![image](./Pictures/linux-kernel/io-dma2.avif)


- 没有零拷贝的数据传输过程：

    ![image](./Pictures/linux-kernel/io-zero-copy4.avif)
    ![image](./Pictures/linux-kernel/io-zero-copy.avif)

    - 1.需要4次用户态与内核态的上下文切换：一共read()和write()2次系统调用，而每次系统调用都得先从用户态切换到内核态，等内核完成任务后，再从内核态切换回用户态。

    - 2.有4次数据拷贝：2次DMA，1次cpu从内核Page Cache拷贝到用户缓冲区，1次从用户缓冲区拷贝到 Socket 缓冲区

    - 结论：需要减少「用户态与内核态的上下文切换」和「内存拷贝」的次数

- 零拷贝解决方法的演化过程：

    - 1.`mmap()` 代替 `read()`：`mmap()` 系统调用会把内核缓冲区**映射**到用户缓冲区。变成了4次上下文切换 + 3次数据拷贝（2次DMA拷贝和1次CPU拷贝）。

        - mmap使用了虚拟内存，可以把内核空间和用户空间的虚拟地址映射到同一个物理地址，从而减少数据拷贝次数

        ```c
        void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);

        // addr：指定映射的虚拟内存地址
        // length：映射的长度
        // prot：映射内存的保护模式
        // flags：指定映射的类型
        // fd:进行映射的文件句柄
        // offset:文件偏移量
        ```

        - 1.用户进程通过mmap方法向操作系统内核发起IO调用，上下文从用户态切换为内核态。
        - 2.CPU利用DMA控制器，把数据从硬盘中拷贝到内核缓冲区。
        - 3.上下文从内核态切换回用户态，mmap方法返回。
        - 4.用户进程通过write方法向操作系统内核发起IO调用，上下文从用户态切换为内核态。
        - 5.CPU将内核缓冲区的数据拷贝到的socket缓冲区。
        - 6.CPU利用DMA控制器，把数据从socket缓冲区拷贝到网卡，上下文从内核态切换回用户态，write调用返回。

        ![image](./Pictures/linux-kernel/io-zero-copy1.avif)

    - 2.`sendfile()` 代替 `read()` 和 `write()` 。变成了只有2次上下文切换 + 3次数据拷贝（2次DMA拷贝和1次CPU拷贝）

        - sendfile是Linux2.1内核版本后引入的一个系统调用函数

        ```c
        ssize_t sendfile(int out_fd, int in_fd, off_t *offset, size_t count);

        // out_fd:为待写入内容的文件描述符，一个socket描述符。，
        // in_fd:为待读出内容的文件描述符，必须是真实的文件，不能是socket和管道。
        // offset：指定从读入文件的哪个位置开始读，如果为NULL，表示文件的默认起始位置。
        // count：指定在fdout和fdin之间传输的字节数。
        ```

        - 1.用户进程发起sendfile系统调用，上下文（切换1）从用户态转向内核态
        - 2.DMA控制器，把数据从硬盘中拷贝到内核缓冲区。
        - 3.CPU将读缓冲区中数据拷贝到socket缓冲区
        - 4.DMA控制器，异步把数据从socket缓冲区拷贝到网卡，
        - 5.上下文（切换2）从内核态切换回用户态，sendfile调用返回。

        ![image](./Pictures/linux-kernel/io-zero-copy2.avif)

    - 3.在`sendfile()` 基础之上，如果网卡支持SG-DMA：可以在减少1次 CPU 把内核缓冲区里的数据拷贝到 socket 缓冲区的过程。变成了2次上下文切换 + 2次数据拷贝。

        - linux 2.4版本之后，对sendfile做了优化升级，引入SG-DMA技术，其实就是对DMA拷贝加入了scatter/gather操作，它可以直接从内核空间缓冲区中将数据读取到网卡。

        - 这就是所谓的零拷贝技术，全程没有cpu参与

        - 1.用户进程发起sendfile系统调用，上下文（切换1）从用户态转向内核态
        - 2.DMA控制器，把数据从硬盘中拷贝到内核缓冲区。
        - 3.CPU把内核缓冲区中的文件描述符信息（包括内核缓冲区的内存地址和偏移量）发送到socket缓冲区
        - 4.DMA控制器根据文件描述符信息，直接把数据从内核缓冲区拷贝到网卡
        - 5.上下文（切换2）从内核态切换回用户态，sendfile调用返回。

        ```sh
        # 查看网卡是否开启SG-DMA
        ethtool -k eth0 | grep scatter-gather

        # 临时开启SG-DMA
        ethtool -K eth0 scatter-gather-fraglist on
        ```

        ![image](./Pictures/linux-kernel/io-zero-copy3.avif)

    - 4.`splice()`的步骤过程：和 sendfile 不同的是，splice 不需要硬件支持。在 Linux 2.6.23 版本中， sendfile 机制的实现已经没有了，API 及相应的功能是利用了 splice 机制来实现的。

        - 1.用户进程调用 `pipe()` 创建匿名单向管道：1次系统调用，2次上下文切换
        - 2.用户进程调用 `splice()` DMA 控制器将数据从硬盘拷贝到内核缓冲区，从管道的写入端"拷贝"进管道：1次系统调用，2次上下文切换
        - 3.用户进程再次调用 splice()内核把数据从管道的读取端拷贝到socket缓冲区，DMA 控制器将数据从socket缓冲区拷贝到网卡：1次系统调用，2次上下文切换

        ![image](./Pictures/linux-kernel/io-zero-copy5.avif)

    | 方法                          | CPU 拷贝 | DMA 拷贝 | 系统调用   | 上下文切换 | 硬件依赖 | 支持任意类型输入/输出描述符 |
    |-------------------------------|----------|----------|------------|------------|----------|-----------------------------|
    | 传统方法                      | 2        | 2        | read/write | 4          | 否       | 是                          |
    | 内存映射                      | 1        | 2        | mmap/write | 4          | 否       | 是                          |
    | sendfile                      | 1        | 2        | sendfile   | 2          | 否       | 否                          |
    | sendfile(scatter/gather copy) | 0        | 2        | sendfile   | 2          | 是       | 否                          |
    | splice                        | 0        | 2        | splice     | 2          | 否       | 是                          |

- 零拷贝技术的应用

    - kafka的文件传输代码，调用了 Java NIO 库里的 `transferTo()`——实际上它最终调用`sendfile`。缩短 65% 的时间
    ![image](./Pictures/linux-kernel/io-zero-copy-transferTo().avif)

    - nginx
        ```nginx
        http {
        ...
            sendfile on
        ...
        }
        ```

## 直接I/O + 异步I/O 解决大文件传输问题

- 大文件传输 不使用Page cache零拷贝技术：Page cache 由于长时间被大文件占据，其他「热点」的小文件可能就无法充分使用到 Page cache，于是这样磁盘读写的性能就会下降了

- 使用绕开Page cache的直接I/O + aio（异步I/O）：

    ![image](./Pictures/linux-kernel/io-aio1.avif)

- 因为使用了直接I/O，无法享受page cache的2个优点：
    - 缓存到page cache后，合并成一个更大的I/O请求再发送给磁盘
    - page cache的预读

- 内存对齐通常是内核来处理的，而`O_DIRECT`绕过了内核空间，直接获取DMA的数据，因此需要自己对齐，必须是扇区（512字节）的倍数。

    ```sh
    blockdev --getpbsz /dev/sda
    512
    ```

## 缓冲区共享 (Buffer Sharing)

- 目前大多数的实现都还处于实验阶段

- 需要新的 API

- 使用一个 fbuf 缓冲区作为数据传输的最小单位，用户区和内核区、内核区之间的数据都必须严格地在 fbufs 这个体系下进行通信。

- fbufs 为每一个用户进程分配一个 buffer pool，里面会储存预分配 (也可以使用的时候再分配) 好的 buffers，这些 buffers 会被同时映射到用户内存空间和内核内存空间。fbufs 只需通过一次虚拟内存映射操作即可创建缓冲区，有效地消除那些由存储一致性维护所引发的大多数性能损耗。

## I/O多路复用（select, poll, epoll）

![image](./Pictures/linux-kernel/io-multiplexing-性能图.avif)

- [洋芋编程：I/O 多路复用模型](https://mp.weixin.qq.com/s/P7P8m5tmHjEIJ0k2KxZaUQ)

- [小林coding：I/O 多路复用：select/poll/epoll](https://www.xiaolincoding.com/os/8_network_system/selete_poll_epoll.html#%E5%A6%82%E4%BD%95%E6%9C%8D%E5%8A%A1%E6%9B%B4%E5%A4%9A%E7%9A%84%E7%94%A8%E6%88%B7)

- 最基础的 TCP 的 Socket 编程，它是阻塞 I/O 模型，基本上只能一对一通信

- C10K（单机同时处理 1 万个请求）模型：

    - 1.多进程模型：主进程负责监听客户的连接，一旦与客户端连接完成，accept() 函数就会返回一个「已连接 Socket」，这时就通过 fork() 函数创建一个子进程（把父进程所有相关的东西都复制一份）。因为子进程会复制父进程的文件描述符，于是就可以直接使用「已连接 Socket 」和客户端通信了

        - 缺点：在应对 100 个客户端还是可行的，但是当客户端数量高达一万时，肯定扛不住的，因为每产生一个进程，必会占据一定的系统资源，而且进程间上下文切换的“包袱”是很重的，性能会大打折扣。

        ![image](./Pictures/linux-kernel/io-multiplexing1.avif)

    - 2.多线程模型：相比于多进程模式，线程上下文切换的开销要比进程小得多。

        - 方案1：一个连接对应一个线程

            - 缺点：运行完后销毁线程，虽说线程切换的上写文开销不大，但是如果频繁创建和销毁线程，系统开销也是不小的。

            - 优点：没有数据可读时，那么线程会阻塞在 read 操作上（ socket 默认情况是阻塞 I/O），不过这种阻塞方式并不影响其他线程。

        - 方案2：线程池

            ![image](./Pictures/linux-kernel/io-multiplexing2.avif)

            - 新连接建立时将这个已连接的 Socket 放入到一个队列里，然后线程池里的线程负责从队列中取出「已连接 Socket 」进行处理。

            - 优点：避免线程运行完后销毁线程

            - 缺点：

                - socket队列是全局的，需要加锁

                - 如果遇到没有数据可读，就会发生阻塞，那么线程就没办法继续处理其他连接的业务。

                    - 最简单解决方法是将 socket 改成非阻塞，然后线程不断地轮询调用 read 操作来判断是否有数据。但轮询是要消耗 CPU

    - 3.I/O多路复用：当连接上有数据的时候，线程才去发起读请求

        ![image](./Pictures/linux-kernel/io-multiplexing3.avif)

        - 把我们要关心的连接传给内核，再由内核检测

            - 没有事件发生时：线程只需阻塞，无需像线程池方案那样轮询

            - 有事件发生时：内核会返回产生了事件的连接，线程就会从阻塞状态返回，然后在用户态中再处理这些连接对应的业务即可。

        - 进程可以通过一个系统调用函数从内核中获取多个事件

            - 一个进程虽然任一时刻只能处理一个请求，但是处理每个请求的事件时，耗时控制在 1 毫秒以内，这样 1 秒内就可以处理上千个请求

### select()

- `select()`：是最早的一种 I/O 多路复用机制，允许应用程序监视多个fd（文件描述符），等待它们变为可读、可写或有错误发生。在select函数监控的fd中，只要有任何一个数据状态准备就绪了，select函数就会返回可读状态。这时应用进程再发起recvfrom请求去读取数据。

    ![image](./Pictures/linux-kernel/io-multiplexing-select.gif)

    ![image](./Pictures/linux-kernel/io-multiplexing-select2.avif)

- 步骤：

    ![image](./Pictures/linux-kernel/io-multiplexing-select1.avif)

    - 1.将已连接的 Socket 都放到一个文件描述符集合

    - 2.然后调用 select() 将文件描述符集合拷贝到内核里，让内核来检查是否有网络事件产生
        - 内核检查的方式很粗暴，就是通过遍历文件描述符集合的方式，当检查到有事件产生后，将此 Socket 标记为可读或可写

    - 3.接着再把整个文件描述符集合拷贝回用户态里，然后用户态还需要再通过遍历的方法找到可读或可写的 Socket，然后再对其处理。

    ![image](./Pictures/linux-kernel/io-multiplexing-select3.avif)

- select 使用固定长度的 Bitsmap，表示文件描述符集合。集合长度由内核中的 FD_SETSIZE 限制， 默认最大值为 1024，只能监听 0~1023 的文件描述符。

- 优点：可移植性强，几乎在所有操作系统上都能使用 (包括 Windows)

- 缺点：性能取决于文件描述符数量，因为每次调用都需要遍历整个文件描述符集合。总共2次遍历（内核+用户）每次的时间复杂度为 O(n)，2次拷贝文件描述符（从用户->内核，在从内核->用户）

- select 底层维护一个类似 `Set` 的数据结构，用于存放 (套接字对应的) 文件描述符

- 将 select 工作流程翻译为简单的伪代码。
    ```py
    # 初始化文件描述符集
    read_fds = set()
    write_fds = set()
    error_fds = set()

    # 添加文件描述符到集合中
    read_fds.add(socket1)
    read_fds.add(socket2)

    ...

    # 超时时间为 5 秒
    timeout = 5
    # 调用 select 系统调用
    # 每次调用时需要重新初始化文件描述符集合
    # 否则就无法区分状态是之前的，还是重新获取后的
    # 内核会将就绪的 文件描述符 设置为 OK, 然后返回给用户空间
    # 总共经过 2 次上下文切换和数据拷贝
    #   1. 将文件描述符集合从用户空间拷贝到内核空间
    #   2. 将文件描述符集合从内核空间拷贝到用户空间
    ready_read, ready_write, ready_error = select(read_fds, write_fds, error_fds, timeout)

    # 处理就绪的文件描述符
    for fd in ready_read:
        if fd == socket1:
            handle_socket1_read()
        elif fd == socket2:
            handle_socket2_read()

    for fd in ready_write:
        if fd == socket1:
            handle_socket1_write()
        elif fd == socket2:
            handle_socket2_write()

    for fd in ready_error:
        handle_error(fd)
    ```

### poll()

- `poll()`：与 `select()` 无本质区别。而是用链表代替bitsmap，突破了select的最大长度，但还是会受系统文件描述符的限制。

- 此外，select 和 poll 还有下面的一些微小的差异:

    - select 的可移植性最好，而且 timeout 超时参数为微妙，而 poll 为毫秒，因此实时性可以更高一些
    - poll 没有最大描述符数量的限制，如果系统对实时性没有严格要求，应该使用 poll 替代 select

- 下面将 poll 工作流程翻译为简单的伪代码。

    ```py
    # 初始化 pollfd 结构体
    # 这里使用数组模拟 poll 的链表
    poll_fds = [
        {'fd': socket1, 'events': POLLIN},
        {'fd': socket2, 'events': POLLIN}
    ]

    # 调用 poll 系统调用
    timeout = 5000  # 超时时间为 5秒
    ready_fds = poll(poll_fds, timeout)

    # 处理就绪的文件描述符
    # 和 select 一样，依然会经过 2 次上下文切换和数据拷贝
    for pfd in ready_fds:
        if pfd['revents'] & POLLIN:
            if pfd['fd'] == socket1:
                handle_socket1_read()
            elif pfd['fd'] == socket2:
                handle_socket2_read()
        if pfd['revents'] & POLLOUT:
            if pfd['fd'] == socket1:
                handle_socket1_write()
            elif pfd['fd'] == socket2:
                handle_socket2_write()
        if pfd['revents'] & POLLERR:
            handle_error(pfd['fd'])
    ```

### epoll()

![image](./Pictures/linux-kernel/io-multiplexing-select、poll、epoll的模式区别.avif)

- select 和 poll 存在的性能问题:

    - 1.底层数据结构，select 和 poll 采用的都是时间复杂度为 O(N) 的数据结构，所以遍历时只能采用轮询方式，这从根本上决定了性能会随着文件描述符数量变多而降低

    - 2.复制方式，select 和 poll 在 (套接字对应的) 文件描述符状态发生变化后，没有对应的事件回调机制，需要调用方主动 (轮询) 将文件描述符集合从用户空间复制到内核空间，内核修改完成后，再从内核空间复制到用户空间，两次的上下文切换会带来不小的开销

- epoll解决方法：

    - 在文件描述符复制方面，相比于 select, poll 每次系统调用时复制全部的文件描述符的开销，epoll 虽然同样会发生系统调用，但是复制的是 已经就绪 的文件描述符，其量级要远远小于全部的。

    - 在事件 (文件描述符) 管理方面，相比于 select, poll 不断轮询所有文件描述符的方式 (时间复杂度 `O(N)`)，epoll 只需要调用 epoll_wait 检测和遍历 就绪事件链表 即可 (时间复杂度 `O(1)`)。

    - 可以想象一下，假如文件描述符有 10000 个，平均每次就绪事件为 10 个:

        - select、poll 每次主动遍历所有文件描述符，一共 10000 次操作
        - epoll 只需要判断 就绪事件链表 是否为空 (1 次操作)，然后遍历链表 (10 次操作)，一共 11 次操作

        - 从图中可以看到，如果文件描述符数量在 1000 个以内，三者之间几乎没有性能差异。
        ![image](./Pictures/linux-kernel/io-multiplexing-select、poll、epoll的性能差异.avif)

    - epoll 的实现主要使用到了2种数据结构:

        - 1.红黑树：管理内核中的 所有文件描述符，因为红黑树插入、更新、删除操作时间复杂度都是 O(log N), 避免了轮询遍历时的 O(N) 复杂度

        - 2.双向链表：存储 就绪事件

- 必须要使用 epoll 吗 ?

    - 在大量并发连接的场景中 (例如 Web Server)，毫无疑问的首选方案是 epoll, 那么 select 和 poll 是不是就一无是处呢？

    - 当然不是，简单来说:
        - select, poll 适合连接数量很少，但是每个连接都很活跃的场景
        - epoll 适合连接数量很多，但是活跃连接很少的场景，毕竟 epoll 的事件通知、回调机制也会带来系统开销

- epoll 主要的几个函数:

    - epoll_create(): 创建一个 epoll 文件描述符，这是一个内核对象，用于管理所有被监听的文件描述符 (套接字)
    - epoll_ctl(): 添加、删除、修改某个具体的文件描述符 (操作的是 红黑树数据结构)
    - epoll_wait(): 等待已经就绪事件的文件描述符 (操作的是 双向链表数据结构)，如果没有文件描述符就绪，调用线程会进入挂起等待，直到有文件描述符变为 就绪或超时

    - 应用程序系统调用 epoll_ctl 时采用事件通知回调方式，例如调用 add 操作时，不仅将文件描述符加入到内核的红黑树中 (树中节点以文件描述符 fd 对象进行对比，所以重复添加也没什么影响)，同时事件还向内核注册了对应的回调函数，这样在某个事件就绪时，主动调用回调函数，然后回调函数会把该事件加入到 `就绪事件链表` 中。

    ```c
    int s = socket(AF_INET, SOCK_STREAM, 0);
    bind(s, ...);
    listen(s, ...)

    int epfd = epoll_create(100) //创建epoll实例（红黑树数据结构），预计监听100个fd
    epoll_ctl(epfd, ...); //将所有需要监听的socket添加到epoll对象的管理中

    while(1) {
        int n = epoll_wait(...); //等待监听socket连接的事件
        for(接收到数据的socket){
            //处理
        }
    }
    ```

- epoll 工作流程翻译为简单的伪代码。

    ```py
    # 初始化，创建一个 epoll 文件描述符实例
    epoll_fd = epoll_create()

    # 添加要监听的文件描述符到 epoll 实例
    epoll_ctl(epoll_fd, ADD, listen_sock, READ_EVENT)

    # 主循环
    while True:
      # 等待事件发生
      events = epoll_wait(epoll_fd)

      # 遍历返回的就绪事件链表
      for event in events:
          if event.fd == listen_sock:
              # 新的客户端连接
              conn_sock = accept(listen_sock)
              # 将连接对应的文件描述符添加到红黑树
              epoll_ctl(epoll_fd, ADD, conn_sock, READ_EVENT)
          else:
              # 处理现有连接的事件
              if event.type == READ_EVENT:
                  data = read(event.fd)
                  if data:
                      # 处理读取到的数据
                      process(data)
                  else:
                      # 将连接对应的文件描述符从红黑树中删除
                      epoll_ctl(epoll_fd, REMOVE, event.fd)
                      # 连接关闭
                      close(event.fd)
    ```

- 使用事件驱动的机制，内核里维护了一个链表来记录就绪事件

    - 当某个 socket 有事件发生时，通过回调函数，内核会将其加入到这个就绪事件列表中，当用户调用 epoll_wait() 函数时，只会返回有事件发生的文件描述符的个数，不需要像 select/poll 那样轮询扫描整个 socket 集合，大大提高了检测的效率。

    ![image](./Pictures/linux-kernel/io-multiplexing-epoll.gif)

    ![image](./Pictures/linux-kernel/io-multiplexing-epoll.avif)

- 两种事件触发机制：

    - 边缘触发（edge-triggered，ET）：**内核只会通知一次**。当 epoll_wait 检测到描述符事件发生并将此事件通知应用程序，应用程序必须立即处理该事件。如果不处理，下次调用 epoll_wait 时，不会再次响应应用程序并通知此事件。

        - 程序会一直执行 I/O 操作，直到系统调用（如 read 和 write）返回错误，错误类型为 EAGAIN 或 EWOULDBLOCK。

        - 你的快递被放到了一个快递箱里，如果快递箱只会通过短信通知你一次，即使你一直没有去取，它也不会再发送第二条短信提醒你

    - 水平触发（level-triggered，LT）（默认）：**内核会通知多次**。当 epoll_wait 检测到描述符事件发生并将此事件通知应用程序，应用程序可以不立即处理该事件。下次调用 epoll_wait 时，会再次响应应用程序并通知此事件，直到应用程序处理完成为止。

        - 如果快递箱发现你的快递没有被取出，它就会不停地发短信通知你，直到你取出了快递，它才消停

    - 边缘触发（ET）相比水平触发（LT），效率更高，减少 `epoll_wait` 的系统调用次数

        - select/poll 只有水平触发模式，epoll 默认是水平触发

    - [大佬的实验](https://github.com/cheerfuldustin/test_epoll_lt_and_et)： 客户端都是输入 “abcdefgh” 8 个字符，服务端每次接收 2 个字符。

        - 水平触发：服务端 4 次循环每次都能取到 2 个字符，直到 8 个字符全部读完。
        ![image](./Pictures/linux-kernel/io-multiplexing-epoll-lt.avif)

        - 边缘触发：读到 2 个字符后这个读就绪事件就没有了。等客户端再输入一个字符串后，服务端关注到了数据的 “变化” 继续从缓冲区读接下来的 2 个字符 “c” 和”d”。
        ![image](./Pictures/linux-kernel/io-multiplexing-epoll-et.avif)

#### [腾讯技术工程：十个问题理解 Linux epoll 工作原理](https://cloud.tencent.com/developer/article/1831360?areaSource=103001.1&traceId=BvF3fKyDKtNgcpPoiZcYP)

![image](./Pictures/linux-kernel/io-multiplexing-epoll1.avif)

- 那什么样的 fd 才可以被 epoll 监视呢？

    - 底层驱动实现了 `file_operations` 中 poll 函数的文件类型才可以被 epoll 监视！socket 类型的文件驱动是实现了 poll 函数的，因此才可以被 epoll 监视。

- ep->wq 的作用是什么？

    - wq 是一个等待队列，保存对某一个 epoll 实例调用 epoll_wait() 的所有进程。一个进程调用 epoll_wait() 后，如果没有事件发生，就会放到 ep->wq 里；当 epoll 实例监视的文件上有事件发生后，在唤醒wq队列上的进程

- ep->poll_wait 的作用是什么？

    - epoll 也是一种文件类型。也实现了 file_operations 中的 poll 函数，因此 epoll 类型的 fd 可以被其他 epoll 实例监视。

    - ep->poll_wait 也是一个等待队列。当被监视的文件是一个 **epoll 类型** 时，需要用这个等待队列来处理递归唤醒。

    - 一个 epoll 实例监视了另一个 epoll 就会出现递归
        - epollfd1 监视了 2 个 “非 epoll” 类型的 fd
        - epollfd2 监视了 epollfd1 和 2 个 “非 epoll” 类型的 fd

        ![image](./Pictures/linux-kernel/io-multiplexing-epoll-poll_wait.avif)

- ep->rdllist 的作用是什么？

    - rdlist是就绪事件的 fd 组成的链表

    - 扫描 ep->rdllist 链表，内核可以轻松获取当前有事件触发的 fd。而不是像 select()/poll() 那样全量扫描所有被监视的 fd，再从中找出有事件就绪的。

- 事件就绪的 fd 会 “主动” 跑到 rdllist 中去，而不用全量扫描就能找到它们呢？

    - 调用 epoll_ctl 新增一个被监视的 fd 时，都会注册一下这个 fd 的回调函数 ep_poll_callback

    - 当网卡收到数据包会触发一个中断，中断处理函数再回调 ep_poll_callback 将这个 fd 所属的 “epitem” 添加至 epoll 实例中的 rdllist 中。

- ep->ovflist 的作用是什么？

    - 由于 rdllist 链表业务非常繁忙，所以在复制数据到用户空间时，加了一个 ep->mtx 互斥锁来保护 epoll 自身数据结构线程安全

    - 但加锁期间很可能有新事件源源不断地产生，新触发的事件需要一个地方来收集，不然就丢事件了。这个用来临时收集新事件的链表就是 ovflist。

- txlist 链表是什么？

    - 这个链表用来最后向用户态复制数据，rdllist 要先把自己的数据全部转移到 txlist，然后 rdllist 自己被清空。ep_send_events_proc 遍历 txlist 处理向用户空间复制，复制成功后如果是水平触发 (LT) 还要把这个事件还回 rdllist，等待下一次 epoll_wait 来获取它。ovflist 上的 fd 会合入 rdllist 上等待下一次扫描

    ![image](./Pictures/linux-kernel/io-multiplexing-epoll-list.avif)

- epmutex、ep->mtx、ep->lock 3 把锁的区别是？

    - epmutex 全局互斥锁，只有 3 个地方用到这把锁：
        - ep_free() 销毁一个 epoll 实例时
        - eventpoll_release_file() 清理从 epoll 中已经关闭的文件时
        - epoll_ctl() 时避免 epoll 间嵌套调用时形成死锁

    - ep->mtx 内部的互斥锁，涉及对 epoll 实例中 rdllist 或红黑树的访问的锁
        - ep_scan_ready_list() 扫描就绪列表
        - eventpoll_release_file() 中执行 ep_remove() 删除一个被监视文件
        - ep_loop_check_proc() 检查 epoll 是否有循环嵌套或过深嵌套
        - epoll_ctl() 操作被监视文件增删改等处有使用

    - ep->lock 内部的自旋锁，用来保护 ep->rdllist 的线程安全

        - 自旋锁的特点是得不到锁时不会引起进程休眠，所以在 ep_poll_callback 中只能使用 ep->lock，否则就会丢事件。

- epoll、epitem、和红黑树间的组织关系

    ![image](./Pictures/linux-kernel/io-multiplexing-epoll-rdllist.avif)


### 进程/线程模型

#### 主进程 (master) + 多个子进程 (worker)

- 主进程 (master) + 多个子进程 (worker)

    ![image](./Pictures/linux-kernel/io-multiplexing-主进程+子进程模型.avif)

    - 主进程执行 bind() + listen()，创建多个子进程
    - 每个子进程中，都通过 accept() 或 epoll_wait() 处理连接

- 优点：
    - 主进程负责事件分发，子进程负责事件处理
- 缺点：
    - 需要额外的进程通信开销、主进程可能成为瓶颈
    - 有惊群问题。什么是 epoll 惊群？多个进程/线程等待在 ep->wq 上，事件触发后所有进程/线程都被唤醒，但只有其中 1 个进程/线程能够成功继续执行的现象。其他被白白唤起的进程，导致开销

        - 解决方法：

            - 内核提供了 `EPOLLEXCLUSIVE` 选项和 `SO_REUSEPORT` 选项

                - `EPOLLEXCLUSIVE`：只唤起排在队列最前面的 1 个进程
                - `SO_REUSEPORT`：每个进程自己都有一个独立的 epoll 实例，内核来决策把连接分配给哪个 epoll

            - nginx的解决方法：配置加入`accept_mutex`（全局锁）。worker 进程首先需要竞争到锁，只有竞争到锁的进程，才会加入到 epoll 中，这样就确保只有一个 worker 子进程被唤醒。

#### 多进程模型

![image](./Pictures/linux-kernel/io-multiplexing-多进程模型.avif)

所有的进程都监听相同的端口，并且开启 `SO_REUSEPORT` 选项，内核负责对请求进行负载均衡，分配到具体的监听进程，内核确保只有一个进程被唤醒，所以不会出现惊群问题。

多个进程之间通常通过共享监听套接字来处理客户端请求，具体的负载均衡工作交给操作系统，新连接到达后，操作系统会自动分配给一个空闲的工作进程。

由于每个工作进程都是独立的，不会共享内存，避免了进程间通信带来的开销。当然，为了高性能，这种模型依然要依赖底层提供的 IO 多路复用机制、并且以事件驱动的方式来处理具体操作，所以本质上和下文中的 Reactor 模型是一样的 (唯一的区别在于多进程还是多线程)。

- 下面是 Nginx 的多进程监听相同端口示例图。
![image](./Pictures/linux-kernel/io-multiplexing-nginx多进程模型.avif)

#### 多线程模型

![image](./Pictures/linux-kernel/io-multiplexing-多线程模型.avif)

每个连接由一个单独的线程处理，虽然线程的开销远远小于进程，但是需要处理线程之间的数据同步和共享问题，以及更麻烦的数据竞争和锁 (线程安全性)。

其次，线程开销少只是相对进程来说，当面对海量连接时，`one thread per connection` 的模式注定无法处理。

#### Reactor架构

- 通常由一个主线程监听 I/O 事件，并在事件到达后，分发给相应的事件处理 (回调函数)。

- Reactor 模型是事件驱动的 I/O 多路复用模型的典型代表，通常由以下几个部分组成：

    - 事件多路复用器：如 select、poll、epoll 等，用于监听 I/O 事件变化 (内核实现)
    - 事件分发器：负责将 I/O 事件分发给相应的事件处理器 (框架开发者来实现)
    - 事件处理器：处理具体的 I/O 事件 (应用开发者来实现)

- Reactor 模型主要有三类处理事件：即连接事件、写事件、读事件
    - 三个关键角色：即 reactor、acceptor、handler。
        - acceptor：负责连接事件
        - handler：负责读写事件
        - reactor：负责事件监听和事件分发。

- 这种模型实现相对复杂，尤其是线程安全性方面，但是该模型可以支持高并发处理 (主要通过复用来最小化创建、销毁 进程/线程带来的开销)，并且架构核心的多路复用和事件分发/处理是解耦的，所以扩展性和可维护性很好，这也是大多数主流网络编程框架，使用该模型作为实现的主要原因。

- [小林coding：高性能网络模式：Reactor 和 Proactor](https://www.xiaolincoding.com/os/8_network_system/reactor.html)

- 主流中间件的网络模型

    ![image](./Pictures/linux-kernel/io-multiplexing-example.avif)

- Reactor 是非阻塞同步网络模式

    - 主动调用 read 方法来完成数据的读取，也就是要应用进程主动将 socket 接收缓存中的数据读到应用进程内存中，这个过程是同步的，读取完数据后应用进程才能处理数据。

- Reactor：使用面向对象思想编写I/O 多路复用

    - 因为使用过程式编写 I/O 多路复用，效率不高

    - 也叫Dispatcher 模式：收到事件后，根据事件类型分配（Dispatch）给某个进程 / 线程

- 两部分（Reactor 和处理资源池）组成：

    - Reactor 负责监听和分发事件，事件类型包含连接事件、读写事件

    - 处理资源池负责处理事件，如 read -> 业务逻辑 -> send

- Reactor 的数量可以只有一个，也可以有多个；处理资源池可以是单个进程 / 线程，也可以是多个进程 /线程
    - 单 Reactor 单进程 / 线程
    - 单 Reactor 多进程 / 线程
    - 多 Reactor 单进程 / 线程
    - 多 Reactor 多进程 / 线程

- 单 Reactor 单进程：

    - Reactor：通过select 监听，收到事件后，根据事件类型通过 dispatch 分发给 Acceptor， Handler

    - Acceptor：accept 方法建立连接，并创建一个 Handler 对象来处理后续的响应事件

        - 如果不是连接建立事件， 则交由当前连接对应的 Handler 对象来进行响应

    - Handler：如果是读写事件reactor 将事件分发给 handler 进行处理。通过 read -> 业务处理 -> send 的流程来完成完整的业务流程

    ![image](./Pictures/linux-kernel/reactor.avif)

    - 不适用计算机密集型的场景，只适用于业务处理非常快速的场景

        - 架构应用：Redis 6.0 之前的版本

    - 缺点：

        - 1.因为只有一个进程，无法充分利用 多核 CPU 的性能

        - 2.Handler 对象在业务处理时，整个进程是无法处理其他连接的事件的，如果业务处理耗时比较长，那么就造成响应的延迟

- 单 Reactor 多线程 / 多进程

    - 该模型中，reactor、acceptor 和 handler 的功能由一个线程来执行，与此同时，会有一个线程池，由若干 worker 线程组成。

    - 在监听客户端事件、连接事件处理方面，这个类型和单 rector 单线程是相同的，但是不同之处在于，在单 reactor 多线程类型中，handler 只负责读取请求和写回结果，而具体的业务处理由 Processor 对象的worker线程来完成。

    - Handler 对象不再负责业务处理，只负责数据的接收和发送，Handler 对象通过 read 读取到数据后，会将数据发给子线程里的 Processor 对象进行业务处理

        - 子线程里的 Processor 对象就进行业务处理，处理完后，将结果发给主线程中的 Handler 对象，接着由 Handler 通过 send 方法将响应结果发送给 client


    - 引入多线程：

        - 优点：充分利用多核 CPU

        - 缺点：操作共享资源前加上互斥锁

    ![image](./Pictures/linux-kernel/reactor1.avif)

- 多 Reactor 多进程 / 线程（主从 Reactor 多线程）

    - 有一个主 reactor 线程、多个子 reactor 线程和多个 worker 线程组成的一个线程池。


    - MainReactor（主Reactor）：负责监听客户端事件，后通过 Acceptor 对象中的 accept 获取连接。一旦连接建立后，主 reactor 会把连接分发给子 reactor 线程，由子 reactor 负责这个连接上的后续事件处理。

    - SubReactor（子Reactor）：子 reactor 会监听客户端连接上的后续事件，有读写事件发生时，它会让在同一个线程中的 handler 读取请求和返回结果，而和单 reactor 多线程类似，具体业务处理，它还是会让线程池中的 worker 线程处理。

        - 如果有新的事件发生时，调用当前连接对应的 Handler 对象来进行响应。

    - Handler（和之前一样）： 通过 read -> 业务处理 -> send 的流程来完成完整的业务流程。

    - 优点：看似复杂，但实现起来比前两个方案简单

        - 主线程和子线程分工明确，主线程只负责接收新连接，子线程负责完成后续的业务处理。

        - 主线程和子线程的交互很简单，主线程只需要把新连接传给子线程，子线程无须返回数据，直接就可以在子线程将处理结果发送给客户端。

    - 架构应用：

        - Java 语言一般使用线程：比如 Netty
        - C 语言使用进程和线程都可以：例如 Nginx 使用的是进程，Memcache 使用的是线程

    ![image](./Pictures/linux-kernel/reactor2.avif)

#### Proactor架构

- Proactor 是异步网络模式

    - 不需要像 Reactor 那样还需要应用进程主动发起 read/write 来读写数据

- Proactor架构：

    - Proactor Initiator 负责创建 Proactor 和 Handler 对象，并将 Proactor 和 Handler 都通过 Asynchronous Operation Processor 注册到内核

    - Asynchronous Operation Processor：负责处理注册请求，并处理 I/O 操作

    - Asynchronous Operation Processor：完成 I/O 操作后通知 Proactor

    - Proactor：根据不同的事件类型回调不同的 Handler 进行业务处理

    - Handler：完成业务处理

    ![image](./Pictures/linux-kernel/proactor.avif)


- Linux 下的异步 I/O 是不完善的

    - aio 系列函数是由 POSIX 定义的异步操作接口，不是真正的操作系统级别支持的，而是在用户空间模拟出来的异步，并且仅仅支持基于本地文件的 aio 异步操作，网络编程中的 socket 是不支持的，这也使得基于 Linux 的高性能网络程序都是使用 Reactor 方案。

    - 而 Windows 里实现了一套完整的支持 socket 的异步编程接口，这套接口就是 IOCP，是由操作系统级别实现的异步 I/O，真正意义上异步 I/O，因此在 Windows 里实现高性能网络程序可以使用效率更高的 Proactor 方案。

### Netty, gnet 等框架

- [洋芋编程：既然有 epoll ，为什么又折腾出 Netty, gnet 等框架 ？](https://mp.weixin.qq.com/s/WVyxhbFknTuVT-Uu3OmOqg)

- 问题：既然 Linux 提供了 epoll 这样的 I/O 多路复用机制，接近内核且高性能，为什么开发者不直接使用 epoll 进行编程？而是在应用层折腾出了类似 Netty (Java), gnet (Golang) 这样的网络编程框架呢？
    - 毕竟，每多一层封装，系统的整体性能就会有 (主要是数据复制带来的) 损耗。

- 答案其实和简单，总结出来无非是 3 点:
    - 简化复杂的网络编程
    - 自定义功能和扩展性
    - 降低开发成本、提升代码可维护性

- 1.简化复杂的网络编程

    - 编程框架可以屏蔽细节，简化并统一 API，使应用开发者可以专注处理业务逻辑，降低心智负担，提高交付效率和质量。

    - 直接使用 epoll 提供的 API 进行编程时，(Socket) 文件描述符的相关操作的简化图，除此之外，开发者还需要其他的各种底层操作:

        ![image](./Pictures/linux-kernel/io-multiplexing-网络框架.avif)

        - Reactor 模型的实现 (为了有效管理)
        - I/O 事件处理
        - 各类网络协议解析
        - 多线程实现 (为了高性能)
        - ...

    - 但是有了编程框架之后，就完全不一样了: 框架会处理好所有底层的这些 “脏活累活”，以 TCP 协议为例，最终传递到应用开发者的就是事件名称以及对应的应用数据，应用开发者只需要重复三板斧操作就可以了:

        ![image](./Pictures/linux-kernel/io-multiplexing-网络框架1.avif)

        - 读数据
        - 处理业务逻辑
        - 写数据

    - 所以网络编程框架，本质上可以看作是应用层的 TCP/IP 协议栈，只不过处理的 I/O 事件没有内核层的 TCP/IP 协议栈那么多而已。

    - 提升性能和并发处理
        - 虽然 epoll 提供了高效的 I/O 事件通知机制，但是面对大量并发网络连接时，如何调度事件、充分利用多线程的同时避免竞争条件等问题，epoll 并不负责。这时就需要一个网络编程框架来把这些必要的基础性工作完成，例如封装 Reactor 模型。

        - 此外，框架内部通常实现了很多性能优化，比如常见的 内存池、零拷贝、缓冲区、减少上下文切换的无锁编程 等机制，这些优化细节大大提高了网络应用的性能。

    - 解析复杂的网路协议

        - 一个系统的通信往往由多种网络协议组成:

            - 面向 C 端的 HTTP、WebSocket
            - 面向 B 端的 TCP、UDP
            - 系统内部众多服务之间互相调用的 RPC
            - ...
        - 应用开发者不可能逐个去实现解析各种网络协议，代码质量难以得到保证，且属于重复性造轮子。

        - 网络编程框架把解析的活儿干完，应用开发者可以专注于 “一把梭” 就可以了。

            - 毕竟，对于大多数项目来说，最复杂的地方就是去实现一套绝对灵活的 “极品” 业务逻辑规则，而不是相对固定的网络协议解析。

    - 网络编程不同于单机编程，除了程序外，整个通信链路中容易出现问题的地方也很多，下面的错误是不是似曾相识:

        - connection timed out
        - connection refused
        - no route to host
        - broken pipe
        - address already in use
        - network is unreachable
        - host unreachable
        - ...

        - 如果这些错误全部交给应用开发者处理，那么在开始编写业务逻辑之前，代码可能已经变成了这个样子:
        ![image](./Pictures/linux-kernel/io-multiplexing-网络框架2.avif)

    - 解决跨平台问题
        - Linux 的 epoll 仅仅是众多平台 I/O 多路复用实现机制其中的一种，如果开发者的系统需要运行在多个不同平台上，就要针对每个平台编写一套系统。

        - 网络编程框架可以根据运行平台环境，(例如通过条件编译) 自动选择对应的 I/O 多路复用机制，真正做到代码 “一次编写，随地运行”。

- 2.自定义功能和扩展性

    - 既然是业务系统，那就说明每个模块、功能必要有优先级排序，几个重要且明显的需求就出来了:

        - 优先运行系统的核心功能
        - 紧急任务可以临时加塞到任务队列
        - 可以根据系统运行环境，自定义不同的配置参数
        - ...
        - 而这些需求，不可能直接和 epoll API 的调用代码堆叠到一起，此时，就需要借助网络编程框架来进行一个优雅且合理的代码实现分层。
        ![image](./Pictures/linux-kernel/io-multiplexing-网络框架3.avif)

    - 技术性扩展功能
        - 现代服务端网络程序中，一些基础组件是必备的，这时就可以直接借助框架来无缝集成，

        - 最常见的也是最必要的就是 应用层的心跳检测机制 了，这一点无需解释太多。此外还有:

            - SSL/TLS 安全层扩展集成
            - 传输数据压缩
            - 自动重连/断开
            - 负载均衡
            - 网络连接统计、状态上报
            - 针对 TCP 的粘包/拆包问题 的 编码器/解码器
            - ...

- 3.降低开发成本和提升代码可维护性
    - epoll 实现在内核中，提供的 API[11] 自然是 C/C++ 语言版本。
    - 即使现在 AI 已经可以写代码了，可以编写优秀的 C/C++ 程序的程序员相对较为稀缺，且开发周期较长。相反，使用 Java/Go 直接编写业务代码的程序员有足够的市场供应，这样就可以降低招聘成本和周期，快速迭代产品，投入市场进行验证。毕竟对于一个公司/项目来说，活下去最重要，而活下去靠的是什么？赚钱的业务。

    - 通过网络编程框架，让技术水平一般的程序员，快速写出可以投入生产环境的 “及格代码”。

## 通用块层

- 通过一个统一的通用块层，来管理不同的块设备，提供一个框架来管理这些设备的驱动程序

    - 处于文件系统和磁盘驱动之间

- I/O 调度：通用层还会给文件系统和应用程序发来的 I/O 请求排队，接着会对队列重新排序、请求合并等方式

- linux的 5 种 I/O 调度算法

    - 1.没有调度算法（NOOP）：不对文件系统和应用程序的 I/O 做任何处理

        - 应用场景：
            - 1.虚拟机 I/O 中，此时磁盘 I/O 调度算法交由物理机系统负责。
            - 2.SSD。SSD不存在机械磁盘中的局部问题
            - 3.带有缓存的RAID控制器，与SSD一样

    - 2.先入先出调度算法：先进入 I/O 调度队列的 I/O 请求先发生。

    - 3.完全公平调度算法（CFS）（默认）：它为每个进程维护了一个 I/O 调度队列，并按照时间片来均匀分布每个进程的 I/O 请求。

    - 4.优先级调度算法（DEADLINE）：在CFS的基础上分为读、写两个FIFO队列

        - 读队列：最大等待时间为500ms

        - 写队列：最大等待时间为5s

        - 优先级：FIFO(Read) > FIFO(Write) > CFQ

        - 最适合磁盘密集型的数据库

        - 应用场景：非虚拟机的物理机

    - 5.最终期限调度算法（ANTICIPATORY）：DEADLINE没有对顺序读做优化。为此在DEADLINE的基础上，为每个读IO都设置了6ms的等待时间窗口。如果在这6ms内OS收到了相邻位置的读IO请求，就可以立即满足。

        - 多个随机的小写入流合并成一个大写入流(相当于给随机读写变顺序读写)

            - 延时换取吞吐量

- 磁盘io调度器
    ```sh
    # 查看sda磁盘的io调度器为mq-deadline
    cat /sys/block/sda/queue/scheduler
    [mq-deadline] kyber bfq none
    ```

## 设备控制器

- [小林coding：键盘敲入 A 字母时，操作系统期间发生了什么？](https://www.xiaolincoding.com/os/7_device/device.html)

- 设备控制器里有芯片，它可执行自己的逻辑，也有自己的寄存器，用来与 CPU 进行通信

| 三种控制寄存器                 | 与cpu的通信操作                                                                                                                                                                            |
|--------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 数据寄存器（Data Register）    | CPU 向 I/O 设备写入需要传输的数据，比如要打印的内容是「Hello」，CPU 就要先发送一个 H 字符给到对应的 I/O 设备。                                                                            |
| 命令寄存器（Command Register） | CPU 发送一个命令，告诉 I/O 设备，要进行输入/输出操作，于是就会交给 I/O 设备去工作，任务完成后，会把状态寄存器里面的状态标记为完成。                                                       |
| 状态寄存器（Status Register）  | 目的是告诉 CPU ，现在已经在工作或工作已经完成，如果已经在工作状态，CPU 再发送数据或者命令过来，都是没有用的，直到前面的工作已经完成，状态寄存标记成已完成，CPU 才能发送下一个字符和命令。 |

- 两种设备

    - 块设备（Block Device）：把数据存储在固定大小的块中，每个块有自己的地址

        - 硬盘、USB设备

        - 块设备通常传输的数据量会非常大，于是控制器设立了一个可读写的数据缓冲区：

            - CPU 写入数据到控制器的缓冲区时，当缓冲区的数据囤够了一部分，才会发给设备。
            - CPU 从控制器的缓冲区读取数据时，也需要缓冲区囤够了一部分，才拷贝到内存。

    - 字符设备（Character Device）：以字符为单位发送或接收一个字符流，字符设备是不可寻址的，也没有任何寻道操作

        - 鼠标

- CPU 两种方法通信：

    - 端口 I/O：每个控制寄存器被分配一个 I/O 端口，可以通过特殊的汇编指令操作这些寄存器，比如 in/out 类似的指令。

    - 内存映射 I/O：将所有控制寄存器映射到内存空间中，这样就可以像读写内存一样读写数据缓冲区。

- 设备控制器完成任务后，如何通知 CPU

    - 轮询等待：CPU 一直查寄存器的状态，直到状态标记为完成
    - 硬中断：当设备完成任务后触发中断到中断控制器通知 CPU
    - 软中断：例如代码调用 INT 指令触发

    - DMA（Direct Memory Access）：设备在 CPU 不参与的情况下，能够自行完成把设备 I/O 数据放入到内存。那要实现 DMA 功能要有 「DMA 控制器」硬件的支持。

        - 可以避免中断导致的CPU 被经常打断，会占用 CPU 大量的时间。

    - 步骤：

        - 1.CPU 需对 DMA 控制器下发指令，告诉它想读取多少数据，读完的数据放在内存的某个地方就可以了；

        - 2.接下来，DMA 控制器会向磁盘控制器发出指令，通知它从磁盘读数据到其内部的缓冲区中，接着磁盘控制器将缓冲区的数据传输到内存；

        - 3.当磁盘控制器把数据传输到内存的操作完成后，磁盘控制器在总线上发出一个确认成功的信号到 DMA 控制器；
        - 4.DMA 控制器收到信号后，DMA 控制器发中断通知 CPU 指令完成，CPU 就可以直接用内存里面现成的数据了；

        ![image](./Pictures/linux-kernel/io-dma.avif)

- 设备驱动

    - 操作系统的内核代码可以像本地调用代码一样使用设备驱动程序的接口，而设备驱动程序是面向设备控制器的代码，它发出操控设备控制器的指令后，才可以操作设备控制器。

    - 设备驱动程序初始化的时候，要先注册一个该设备的中断处理函数

        ![image](./Pictures/linux-kernel/io-drive.avif)


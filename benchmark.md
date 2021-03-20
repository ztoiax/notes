<!-- vim-markdown-toc GFM -->

* [基本说明](#基本说明)
* [all-have 综合](#all-have-综合)
    * [bcc](#bcc)
        * [stackcount](#stackcount)
    * [perf-tool](#perf-tool)
        * [perf list](#perf-list)
        * [perf stat](#perf-stat)
        * [perf record](#perf-record)
        * [perf sched](#perf-sched)
        * [perf other](#perf-other)
    * [enhance pstree (进程树)](#enhance-pstree-进程树)
    * [sysbench](#sysbench)
    * [vmstat](#vmstat)
    * [dstat](#dstat)
    * [sar(sysstat)](#sarsysstat)
    * [sadf(sysstat)](#sadfsysstat)
    * [nmon](#nmon)
    * [sysbench](#sysbench-1)
* [CPU](#cpu)
    * [cpu info](#cpu-info)
    * [strace](#strace)
    * [mpstat(sysstat)](#mpstatsysstat)
    * [获取保留两位小数的 CPU 占用率：](#获取保留两位小数的-cpu-占用率)
    * [taskset (进程绑定 cpu)](#taskset-进程绑定-cpu)
* [Memory](#memory)
    * [hugepage(巨型页)](#hugepage巨型页)
    * [KSM](#ksm)
    * [base](#base)
    * [pmap](#pmap)
    * [slabtop](#slabtop)
* [Net](#net)
    * [TCP/UDP](#tcpudp)
        * [tplist(bcc)](#tplistbcc)
    * [IP](#ip)
        * [nstat(iproute2)](#nstatiproute2)
    * [iperf3](#iperf3)
    * [masscan](#masscan)
    * [iftop](#iftop)
    * [mtr](#mtr)
    * [nethogs](#nethogs)
    * [bmon](#bmon)
    * [speedometer](#speedometer)
    * [httpstat](#httpstat)
* [Web](#web)
    * [ab](#ab)
    * [httperf](#httperf)
* [File](#file)
    * [VFS](#vfs)
        * [cache](#cache)
            * [cachetop(bcc)](#cachetopbcc)
            * [cachestat(bcc)](#cachestatbcc)
            * [pcstat](#pcstat)
            * [hcache](#hcache)
        * [opensnoop(bcc)](#opensnoopbcc)
        * [fileslower(bcc)](#fileslowerbcc)
    * [File system](#file-system)
    * [Block devices interface](#block-devices-interface)
        * [iostat(sysstat)](#iostatsysstat)
        * [biosnoop(bcc)](#biosnoopbcc)
* [Disk](#disk)
    * [inotify-tools](#inotify-tools)
    * [blktrace](#blktrace)
    * [btrace](#btrace)
    * [dd](#dd)
    * [hdparm](#hdparm)
    * [agedu](#agedu)
        * [只统计.conf 文件](#只统计conf-文件)
* [Process](#process)
    * [htop](#htop)
    * [bpytop](#bpytop)
    * [Procmon](#procmon)
    * [SysMonTask](#sysmontask)
    * [pidstat](#pidstat)
* [开机](#开机)
    * [bootchart](#bootchart)
* [Special file system](#special-file-system)
    * [proc](#proc)
    * [sys](#sys)
        * [cgroup(进程组资源限制)](#cgroup进程组资源限制)
        * [debugfs](#debugfs)
        * [查看 `cpu` 的缓存](#查看-cpu-的缓存)
        * [查看 `I/O Scheduler(调度器)` 的缓存](#查看-io-scheduler调度器-的缓存)
* [GPU](#gpu)
    * [nvidia-smi](#nvidia-smi)
    * [nvtop](#nvtop)
    * [gpustat](#gpustat)
    * [gmonitor](#gmonitor)
* [reference](#reference)

<!-- vim-markdown-toc -->

# 基本说明

image from brendangregg:
![image](./Pictures/benchmark/benchmark-base.png)

data from brendangregg book: [Systems Performance](http://www.brendangregg.com/systems-performance-2nd-edition-book.html)

| 事件                        | 延时     | 相对时间比例 1s |
| --------------------------- | -------- | --------------- |
| 1 个 CPU 周期               | 0.3ns    | 1s              |
| L1 缓存访问                 | 0.9ns    | 3s              |
| L2 缓存访问                 | 2.8ns    | 9s              |
| L3 缓存访问                 | 12.9ns   | 43s             |
| 主存访问（从 CPU 访问 DRAM) | 120ns    | 6 分            |
| 固态硬盘 I/O（闪存）        | 50-150μs | 2-6 天          |
| 旋转磁盘 V/0                | 1-10ms   | 1-12 月         |
| 互联网：从旧金山到纽约      | 40ms     | 4 年            |
| 互联网：从旧金山到英国      | 81ms     | 8 年            |
| 互联网：从旧金山到澳大利亚  | 183ms    | 19 年           |
| TCP 包重传                  | 1-3s     | 105-317 年      |
| OS 虚拟化系统重启           | 4s       | 423 年          |
| SCSI 命令超时               | 30s      | 3 千年          |
| 硬件處担化系统典鞋！        | 40s      | 4 千年          |
| 物理系统重启                | 5m       | 32 千年         |

以下表示: sar 命令是 `sysstat` 包,biosnoop 是 `bcc` 包

- sar(sysstat)
- biosnoop(bcc)

计数器:几乎没有开销,在内核默认就是开启的,一般在 `/proc` 上进行读取

- sar
- vmstat
- iostat
- netstat

追踪:类似调试器,开销大

- perf
- bcc
- tcpdump
- strace

# all-have 综合

## [bcc](https://github.com/iovisor/bcc)

- [BPF-tools](https://github.com/brendangregg/BPF-tools)

- 配合[FlameGraph](http://www.brendangregg.com/flamegraphs.html)

通过 `cpu stack(堆栈)` 可生成:

- 冰柱图
- 火焰图
- 太阳图

- `eBRF` 和 `perf` 都是 linux kernel 代码的一部分,

- `eBPF` 比 `perf` 更容易地在内核执行,效率更高,开销更低

![image](./Pictures/benchmark/perf_vs_brf.png)

bcc 安装后加入`$PATH`:

```bash
export PATH="/usr/share/bcc/tools:$PATH"
```

### stackcount

追踪 nvim 的使用 ` malloc()` 的次数:

```bash
# -U 只跟踪用户层堆栈
stackcount -p $(pgrep -of nvim) -U c:malloc > out.stacks

# 使用flame graph工具,输出火焰图
stackcollapse.pl < out.stacks | flamegraph.pl --color=mem \
    --title="malloc() Flame Graph" --countname="calls" > out.svg
```

追踪 `page falut(缺页)`:

```bash
stackcount 't:exceptions:page_fault_*' > out.stacks

# 使用flame graph工具,输出火焰图
stackcollapse.pl < out.stacks | flamegraph.pl --color=mem \
    --title="malloc() Flame Graph" --countname="calls" > out.svg
```

![image](./Pictures/benchmark/stackcount.gif)

**reference:**

- [Memory Leak (and Growth) Flame Graphs](http://www.brendangregg.com/FlameGraphs/memoryflamegraphs.html)

## [perf-tool](http://www.brendangregg.com/perf.html)

查看追踪点(image from brendangregg):
![image](./Pictures/benchmark/perf_events_map.png)

from brendangregg:

| 子命令    | 操作                                                                       |
| --------- | -------------------------------------------------------------------------- |
| annotate  | 描述读取 perf.data（由 perfrecord 创建）并显示注释过的代码                 |
| diff      | 读取两个 perf.data 文件并显示两份剖析信息之间的差异                        |
| evlist    | 列出一个 perf.data 文件里的事件名称                                        |
| inject    | 过滤以加强事件流，在其中加入额外的信息                                     |
| kmem      | 跟踪/测量内核内存（slab）属性的工具 kvm 跟踪/测量 kvm 客户机操作系统的工具 |
| list      | 列出所有的符号事件类型                                                     |
| lock      | 分析锁事件                                                                 |
| probe     | 定义新的动态跟踪点                                                         |
| record    | 运行一个命令，并把剖析信息记录在 perf.data 中                              |
| report    | 读取 perf.data（由 perf record 创建）并显示剖析信息                        |
| sched     | 跟踪/测量调度器属性（延时）的工具                                          |
| script    | 读取 perf.data（由 perf record 创建）并显示跟踪输出                        |
| stat      | 运行一个命令并收集性能计数器统计信息                                       |
| timechart | 可视化某一个负载期间系统总体性能的工具                                     |
| top       | 系统剖析工具下面演示了如何使用一些关键命令                                 |

### perf list

```bash
# 网络追踪
perf list 'tcp:*' 'sock:inet*'

# sched
perf list 'sched:*'

# 硬件追踪
perf list | grep -i hardware

# 软件追踪
perf list | grep -i "software event"
```

### perf stat

> CPU 性能计数器

- 性能开销比 perf record 小

| 参数  | 操作                    |
| ----- | ----------------------- |
| -h    | 显示参数内容            |
| -d    | 详细信息                |
| -a    | 追踪整个系统            |
| -p    | 追踪指定 pid            |
| -e    | 追踪指定事件`perf list` |
| sleep | 持续时间                |

- [linux syscall list](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#x86_64-64_bit)

```bash
# 追踪 ls 命令
perf stat ls

# 追踪 ls 命令,详细信息
perf stat -d ls

# 追踪 nvim 进程
perf stat -p $(pgrep -of nvim)

# 追踪整个系统 5 秒
perf stat -a sleep 5

# 只追踪 ls 命令,L1缓存相关的事件
perf stat -e L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores ls

# 只追踪整个系统的 ext4 事件,持续10秒
perf stat -e 'ext4:*' -a sleep 10

# 追踪并统计 ls 的syscall(性能比strace -c ls 要好)
perf stat -e 'syscalls:sys_enter_*' ls 2>&1 | awk '$1 != 0'
```

### perf record

- 性能开销取决于追踪的事件

参数和以上`perf stat`基本相同,以下列出不同的部分:

| 参数               | 操作                                                                     |
| ------------------ | ------------------------------------------------------------------------ |
| -F                 | 指定频率收集                                                             |
| -a                 | 追踪所有 cpu                                                             |
| -b                 | 追踪 cpu 分支                                                            |
| -o                 | 指定输出文件                                                             |
| -c                 | 每过多少次事件,才收集 1 次 stack                                         |
| --call-graph dwarf | 使用 dwarf:解决用户堆栈中缺少帧指针(软件编译缺少帧指针,symbols 会不完整) |
| --call-graph lbr   | 使用 lbr(cpu 处理器硬件特性):解决 symbols 不完整                         |

record 会保存为 `perf.data` 文件, 使用 perf report 命令显示:

```bash
perf record -g ls
perf report
# 树形文本显示
perf report --stdio
```

配合[FlameGraph](http://www.brendangregg.com/flamegraphs.html) 可生成火焰图.以下的 record 同理:

from brendangregg:

```bash
perf record -F 99 -g ls
# 生成火焰图
perf script | stackcollapse-perf.pl | flamegraph.pl > perf.svg

# grep过滤后,生成火焰图
perf script | stackcollapse-perf.pl > out.perf-folded
grep -v cpu_idle out.perf-folded | flamegraph.pl > nonidle.svg
grep ext4 out.perf-folded | flamegraph.pl > ext4internals.svg
egrep 'system_call.*sys_(read|write)' out.perf-folded | flamegraph.pl > rw.svg
```

```bash
# 指定 99hz 频率收集,运行的 ls 命令
# 选择99赫兹，而不是100赫兹，是为了避免周期性产生偏差的结果
perf record -F 99 ls

# 指定 99hz 频率收集,运行的 nvim,持续10秒
perf record -F 99 -p $(pgrep -of nvim) sleep 10

# 收集 CPU 内核指令,持续5秒
perf record -e cycles:k -a -- sleep 5

# 收集 CPU 用户指令,持续5秒
perf record -e cycles:u -a -- sleep 5

# 收集 sched 调度器
perf sched record

# 收集 lock 锁
perf lock record

# 指定 49hz 频率实时显示
perf top -F 49 -ns comm,dso
```

```bash
# 指定 99hz 频率,使用 dwarf 收集整个系统
perf record -F 99 -a --call-graph dwarf

# 指定 99hz 频率,使用 lbr 收集整个系统
perf record -F 99 -a --call-graph lbr
```

静态追踪:

```bash
# page-faults(缺页)
perf record -e page-faults -p $(pgrep -of nvim) -g -- sleep 120

# context-switches(上下文切换)
perf record -e context-switches -p $(pgrep -of nvim) -g -- sleep 5

# 追踪谁发出了磁盘I/O(sync reads & writes)
perf record -e block:block_rq_insert -ag -- sleep 60

# 追踪 minor faults (RSS growth)
perf record -e minor-faults -ag

# 追踪统计新启动的进程
perf record -e sched:sched_process_exec -a

# 追踪统计进程启动的网络连接
perf record -e syscalls:sys_enter_connect -ag
perf report --stdio
```

动态追踪:

> 动态追踪使用不稳定的 kernel api,应优先使用静态追踪

```bash
# 显示当前动态追踪
perf probe -l

# 添加tcp_sendmsg追踪点
perf probe --add tcp_sendmsg

# 追踪tcp_sendmsg
perf record -e probe:tcp_sendmsg

# 删除tcp_sendmsg追踪点
perf probe -d tcp_sendmsg
```

```bash
# malloc
perf probe -x /lib/x86_64-linux-gnu/libc-2.15.so --add malloc
perf record -e probe_libc:malloc -a
```

### perf sched

统计进程在 cpu 上的调度:

```bash
perf sched record -- sleep 1
perf script --header

# 显示延迟
perf sched latency

# 显示每个的cpu的当前执行和上下文切换
perf sched map

# 显示等待时间,唤醒后的调度延迟(sch delay)
perf sched timehist

# 显示cpu可视化等
perf sched timehist -MVw
```

### perf other

perf trace 使用 buffer tracing 性能比`strace`好:

```bash
perf trace ls
```

## enhance pstree (进程树)

![image](./Pictures/benchmark/pstree.png)

- [Colony Graphs: Visualizing the Cloud](http://www.brendangregg.com/ColonyGraphs/cloud.html#Implementation)

## sysbench

cpu:

```bash
# 设置10个线程,计算1000000个质数
sysbench --num-threads=10 --test=cpu --cpu-max-prime=10000 run
```

## vmstat

建议使用 `dstat`

| 选项 | 操作                     |
| ---- | ------------------------ |
| si   | 匿名页换入内存           |
| so   | 匿名页换出交换设备       |
| pi   | 所有类型的页换入内存     |
| po   | 所有类型的页换出交换设备 |

```bash
vmstat 1

# MB显示
vmstat 1 -Sm
```

## [dstat](http://dag.wiee.rs/home-made/dstat/)

| 参数          | 监控选项                     |
| ------------- | ---------------------------- |
| --list        | 列出监控选项                 |
| -c            | cpu                          |
| -n            | net                          |
| -d            | disk                         |
| -m            | memory                       |
| -p            | process                      |
| -g            | page                         |
| -l            | load 等同于 uptime           |
| -t            | time                         |
| --top-cpu     | cpu 使用率最高的进程         |
| --top-io      | io 使用率最高的进程          |
| --top-bio     | bio 使用率最高的进程         |
| --top-memory  | memory 使用率最高的进程      |
| --top-latency | 延迟最高的进程               |
| --top-cpu-adv | 进程的 cpu 使用率,read,write |
| --float       | 小数显示                     |
| --output      | 输出                         |
| -D            | 选择硬盘                     |
| -N            | 选择网卡                     |

```bash
# 以 vmstat 格式显示
dstat --vmstat

# 显示cpu,硬盘,网络,cpu使用率最高的进程,memory使用率最高的进程
dstat -cdn --top-cpu --top-mem

# 小数显示
dstat -cdn --top-cpu --top-mem --float

# 每 2 秒(默认是 1 秒)输出, 一共 5 次
dstat -cdn --top-cpu --top-mem --float 2 5

# 显示 5 次,输出time,load,保存为 csv 文件
dstat --time --load --output report.csv 1 5
```

```bash
# 选择 sda1 硬盘
dstat -d -D sda1
```

## sar(sysstat)

image from brendangregg:
![image](./Pictures/benchmark/benchmark-sar.png)

| 参数 | 操作           |
| ---- | -------------- |
| -u   | 使用率         |
| -P   | 核心           |
| -b   | IO             |
| -B   | 内存速率       |
| -W   | 交换分区速率   |
| -r   | 内存和交换分区 |
| -d   | 硬盘(块设备)   |
| -I   | 中断           |
| -n   | 网络           |
| -x   | 进程(pid)      |
| -q   | 进程负载       |

from brendangregg:

| 参数 | 统计内容  | 描述                                                                                   | 单位      |
| ---- | --------- | -------------------------------------------------------------------------------------- | --------- |
| -B   | pgpgin/s  | 页面换入单位                                                                           | 千字节/秒 |
| -B   | pgpgout/s | 页面换出                                                                               | 千字节/秒 |
| -B   | fault/s   | 严重及轻微缺页                                                                         | 次数/秒   |
| -B   | majflt/s  | 严重缺页                                                                               | 次数/秒   |
| -B   | pgfree/s  | 页面加入空闲链表                                                                       | 次数/秒   |
| -B   | pgscank/s | 被后台页面换出守护进程扫描过的页面（kswapd）                                           | 次数/秒   |
| -B   | pgscand/s | 直接页面扫描                                                                           | 次数/秒   |
| -B   | pgsteal/s | 页面及交换高速缓存回收                                                                 | 次数/秒   |
| -B   | %vmeff    | 页面盗取/页面扫描比率，显示页面回收的效率                                              | 百分比    |
| -H   | hbhugfree | 空闲巨型页面存储器（大页面尺寸）                                                       | 千字节    |
| -H   | hbhugused | 占用的巨型页面存储器                                                                   | 千字节    |
| -r   | kbmemfree | 空闲存储器                                                                             | 千字节    |
| -r   | kbmemused | 占用存储器（不包括内核）                                                               | 千字节    |
| -r   | kbbuffers | 缓冲高速缓存尺寸                                                                       | 千字节    |
| -r   | kbcached  | 页面高速缓存尺寸                                                                       | 千字节    |
| -r   | kbcommit  | 提交的主存储器：服务当前工作负载需要量的估计                                           | 千字节    |
| -r   | %commit   | 为当前工作负载提交的主存储器，估计值                                                   | 百分比    |
| -r   | kbactive  | 活动列表存储器尺寸                                                                     | 千字节    |
| -r   | kbinact   | 非活动列表存储器尺寸                                                                   | 千字节    |
| -R   | frpg/s    | 释放的存储器页面，负值表明分配                                                         | 页面/秒   |
| -R   | bufpg/s   | 缓冲高速缓存增加值（增长）                                                             | 页面/秒   |
| -R   | campg/    | 页面 高速缓存增加值（增长）                                                            | 页面/秒   |
| -S   | kbswpfree | 释放交换空间                                                                           | 千字节    |
| -S   | kbswpused | 占用交换空间                                                                           | 千字节    |
| -S   | kbswpcad  | 高速缓存的交换空间：它同时保存在主存储器和交换设备中，因此不需要磁盘 VO 就能被页面换出 | 千字节    |
| -W   | pswpin/s  | 页面换人（Linux 换人）                                                                 | 页面/秒   |
| -W   | pswpout/s | 页面换出（Linux 换出）                                                                 | 页面/秒   |

- 1 间隔时间
- 10 次数

```bash
# cpu使用率
sar -u 1 10
# 网络统计数据
sar -n DEV 1 10
sar -n EDEV 1 10
```

```bash
# 打印 cpu 序号为 5,7,1,3 核心的 cpu 使用率
sar -P 5,7,1,3 1

# 打印每个核心的cpu使用率
sar -P ALL 1 10

# 打印 idle 小于 10 的 cpu 核心
sar -P ALL 1 | tail -n+3 | awk '$NF<10 {print $0}'

# 打印所有中断的统计数据
sar -I ALL 1 10
```

## sadf(sysstat)

多种方式显示 sar 数据

- [官方文档](http://sebastien.godard.pagesperso-orange.fr/man_sadf.html)

```bash
# 生成svg图片
sadf -g > test.svg
```

## nmon

![image](./Pictures/benchmark/nmon.png)

## sysbench

```bash
# cpu测试,计算素数到某个最大值的时间
sysbench --test=cpu --cpu-max-prime=20000 run

# 文件I/O
sysbench --test=fileio --file-total-size=5G prepare
```

# CPU

## cpu info

| 系统自带命令       | 操作内容            |
| ------------------ | ------------------- |
| more /proc/cpuinfo | 查看每个 cpu 的信息 |
| lscpu              | 查看简短 cpu 信息   |
| numactl --hardware | 查看 numa 信息      |

| 第三方命令   | 操作内容          |
| ------------ | ----------------- |
| cpuid        | 查看 cpu 指令集   |
| x86info -a   | 查看寄存器        |
| cpupower-gui | 查看设置 cpu 频率 |
| lstopo       | 如下图            |

lstopo:
![image](./Pictures/benchmark/lstopo.png)

| 硬件技术 | 内容                                                                                                     |
| -------- | -------------------------------------------------------------------------------------------------------- |
| NX       | 对内存里的指令存储和数据存储,进行标志区分(可防止缓冲区溢出攻击)                                          |
| SMEP     | CR3 寄存器 20 位(第 21 位)为 1 表示开启.cpl < 3 的程序不能访问用户模式(cpl=3)的内存指令,否则会发生 fault |
| SMAP     | SMEP 是禁止执行,SMAP 进一步补充,禁止读写                                                                 |
| AVX      | simd 单指令多数据                                                                                        |
| XSAVE    | guest 虚拟机动态迁移时,保存 AVX 寄存器的状态                                                             |

```bash
# 查看是否支持某项技术(这里列举nx,其他技术同理)
grep nx /proc/cpuinfo
```

## strace

> 连接程序,在系统调用是暂停,类似调试器,开销大

## mpstat(sysstat)

| 参数    | 内容                               |
| ------- | ---------------------------------- |
| %usr    | 用户态时间                         |
| %sys    | 系统态时间（内核）                 |
| %nice   | 以 nice 优先级运行的进程用户态时间 |
| %iowait | I/O 等待                           |
| %irq    | 硬件中断 CPU 用量                  |
| %soft   | 软件中断 CPU 用量                  |
| %steal  | 耗费在服务其他租户的时间           |
| %guest  | 花在访客虚拟机的时间               |
| %idle   | 空闲                               |

```bash
# 每秒显示1次
mpstat 1

# 每秒显示1次,只显示10次
mpstat 1 10

# 指定显示的cpu0,cpu1
mpstat -P 0,1 1

# 显示的所有cpu0
mpstat -P ALL 1
```

## 获取保留两位小数的 CPU 占用率：

top -b -n1 | grep ^%Cpu | awk '{printf("Current CPU Utilization is : %.2f%"), 100-\$8}'

## taskset (进程绑定 cpu)

```bash
# 设置只能在cpu7-10上运行
taskset -pc 7-10 <pid>
```

设置 cpu 组,并分配进程

```bash
# 挂着cpuset
mkdir /dev/cpuset
mount -t cpuset cpuset /dev/cpuset
df /dev/cpuset

# 创建cpu组,名为nginx
mkdir /dev/cpuset/nginx
cd /dev/cpuset/nginx

# 绑定cpu7 到 10
echo 7-10 > cpus
echo 1 > cpu exclusive

# 分配进程
echo <pid> > tasks
```

# Memory

- [内存的基本知识](https://blog.heroix.com/blog/linux-memory-use)

| 概念                    | 内容                                                                               |
| ----------------------- | ---------------------------------------------------------------------------------- |
| major fault             | 要从磁盘载入内存页面(可能是由于读取已写入交换文件的内存页而导致的)                 |
| minor fault             | 不需要从磁盘读取其他数据到内存(可能是在多个进程之间共享内存页)                     |
| VSZ(虚拟内存)           | 不是真实内存,(包括共享内存,交换分区)                                               |
| RSS(常驻内存)           | 真实内存,当前映射到进程中的页面总数(包含共享内存,不包含交换内存)                   |
| PSS(比例内存)           | 进程内共享内存占总内存的比例                                                       |
| USS(独占内存)           | 进程独自占用的物理内存（不包含共享库占用的内存）                                   |
| 匿名内存                | 没有系统数据,文件路径名的内存                                                      |
| copy-on-write(写时复制) | 子进程被创建后,会共享父进程的全部内存,当子进程想要修改的时候,再单独分配一块新内存  |
| KSM(内存同页合并)       | ksmd 守护进程扫描内存,将相同的内存页合并为一页,当进程想要修改时,进行 copy-on-write |

查看进程内存的文件 `/proc/pid/smaps`

统计程序的 `RSS`:

```bash
awk '/Rss:/{ sum += $2 } END { print sum " KB" }' /proc/pid/smaps
```

## hugepage(巨型页)

- 配置 `/sys/kernel/mm/hugepages/`

- 缺点:

  - 未分配的巨型页,会占用内存

  - 不能被 swap out

- 透明巨页

  - 优点:

    - 对于所有程序都是透明

    - 可以 swap out,会分割为普通的 4k 页

  - 缺点:
    - 只支持匿名内存

```bash
查看巨型页 分配
grep -i huge /proc/meminfo

# 查看巨型页 大小
ls /sys/kernel/mm/hugepages

# 查看巨型页 pool(池)
cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

# 查看巨型页 空闲pool(池)
cat /sys/kernel/mm/hugepages/hugepages-2048kB/free_hugepages
```

THP(透明巨型页)

```bash
grep -i AnonHugePages /proc/meminfo
```

创建巨型页挂载点(我这里是 2M,1G 也是一样)

```bash
# 分配池后会立即减少内存
echo 1000 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

# 挂载
mkdir /mnt/2M-hugepage
mount -t hugetlbfs -o pagesize=2M,size=2G,min_size=1G nodv /mnt/2M-hugepage

# 查看未分配的(总数减去刚才min_size)的pool
cat /sys/kernel/mm/hugepages/hugepages-2048kB/resv_hugepages
```

## KSM

- 配置 `/sys/kernel/mm/ksm/`
  - `pages_sharing`的值越大越好

```bash
# 激活ksmd
echo 1 > /sys/kernel/mm/ksm/run

# 修改每次扫描内存页的数量
echo 1200 > /sys/kernel/mm/ksm/pages_to_scan

# ksmd扫描的时间间隔
echo 10 > /sys/kernel/mm/ksm/sleep_millisecs
```

`ksmtuned` 动态调整 ksm 的后台服务

- 配置文件 /etc/ksmtuned.conf

```bash
yum install ksmtuned

systemctl enable ksmtuned.service
systemctl start ksmtuned.service
```

## base

```bash
ps -aux | sort -k4nr | head -K
ps aux --sort -rss | head
top -c -b -o +%MEM | head -n 20 | tail -15
```

## pmap

```bash
# 查看 nvim 的内存映射
pmap -x $(pgrep -of nvim)
```

## slabtop

# Net

## TCP/UDP

### tplist(bcc)

```bash
# 显示tcp tracepoints(追踪点)
tplist -v 'tcp*' | grep ^tcp
```

| tracepoints               | 操作                                                              |
| ------------------------- | ----------------------------------------------------------------- |
| tcp:tcp_retransmit_skb    | 追踪重传                                                          |
| tcp:tcp_retransmit_synack | 追踪 SYN 和 SYN/ACK 重传,可以显示服务器饱和(listen backlog drops) |
| tcp:tcp_destroy_sock      | 追踪 TCP session,可以知道 session 什么时候关闭                    |
| tcp:tcp_send_reset        | 追踪在 socket 期间的 RST send(重置发送)                           |
| tcp:tcp_receive_reset     | 追踪 RST receive(重置接受)                                        |
| tcp:tcp_probe             | 追踪 TCP 窗口拥塞                                                 |
| sock:inet_sock_set_state  | 可以做很多时,比如实现 tcplife,tcpconnect,tcpaccept,这些 bcc 功能  |

reference:

- [tcp-tracepoints](http://www.brendangregg.com/blog/2018-03-22/tcp-tracepoints.html)

## IP

### nstat(iproute2)

```bash
nstat -a
# 所有包括值为0的
nstat -a --zero
```

## iperf3

服务端:

```bash
iperf3 -s
```

客户端:

```bash
iperf3 -c
```

## [masscan](https://github.com/robertdavidgraham/masscan)

- [1.4 万 Star！迄今为止速度最快的端口扫描器](https://mp.weixin.qq.com/s?src=11&timestamp=1607576697&ver=2757&signature=EZccuiVphxpLvYprZNgS7xjfuXqW2kgBwRLM35AWvstT-obGhkL-6e9aFmxHBdGU3oE5R7WyeVEgUfHY1jQqO6v0xsfDna4fqFrbyK1VxRgBX4zD60M5wB6hAZm6EV*B&new=1)

```bash
masscan 0.0.0.0/4 -p80 --rate 100000000 --router-mac 66-55-44-33-22-11

# 保存文件
masscan -p80,8000-8100 192.168.1.0/24 --echo > /tmp/xxx.conf
# 执行文件
masscan -c /tmp/xxx.conf --rate 1000
```

## iftop

![image](./Pictures/benchmark/iftop.png)

## [mtr](https://mp.weixin.qq.com/s?__biz=MzAxODI5ODMwOA==&mid=2666545753&idx=1&sn=2bf5b7f1c814371335a5f1b51798f3c7&chksm=80dc86f2b7ab0fe4cb14bdc1d1285ddff878c3a1355a1f469a21c3a7148b24d1f0b608bbd148&scene=21#wechat_redirect)

![image](./Pictures/benchmark/mtr.png)

## nethogs

![image](./Pictures/benchmark/1.png)

## bmon

![image](./Pictures/benchmark/3.png)

## speedometer

**useage** `speedometer -rx eth0`
![image](./Pictures/benchmark/4.png)

## [httpstat](https://github.com/reorx/httpstat)

[使用教程](https://linux.cn/article-8039-1.html)

![image](./Pictures/benchmark/httpstat.png)

# Web

## ab

web 压力测试
安装包`apache-tools`

- `-c` 并发次数(模拟多少个客户端)
- `-n` 请求次数

`ab -c 1 -n 10000 https://127.0.0.1/index.html`

> ```bash
> # 摘取重要的输出
> # 每秒8906次
> Requests per second:    8906.78 [#/sec] (mean)
>
> # 平均每次0.112ms
> Time per request:       0.112 [ms] (mean)
>
> # 带宽速率
> Transfer rate:          7593.38 [Kbytes/sec] received
> ```

## httperf

- `--num-conns` 次数
- `--wsess` 模拟会话请求

`httperf --hog --server=127.0.0.1 --uri=index.html --num-conns=10000`

> ```bash
> # 摘取重要的输出
> # 每秒建立14398次链接
> Connection rate: 14398.2 conn/s (0.1 ms/conn, <=1 concurrent connections)
>
> # 最长链接,平均链接的时间
> Connection time [ms]: min 0.0 avg 0.1 max 18.0 median 0.5 stddev 0.2
>
> # 返回请求统计
> Reply status: 1xx=0 2xx=0 3xx=0 4xx=10000 5xx=0
> # 性能
> CPU time [s]: user 0.11 system 0.41 (user 16.3% system 58.6% total 74.9%)
> Net I/O: 5343.1 KB/s (43.8*10^6 bps)
>
> # 失败的请求(这里是0)
> Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0
> ```

```bash
# --wsess=10,10,0.1 表示10个会话，每个会话10次请求，每次请求1秒
httperf --hog --server=127.0.0.1 --uri=index.html --num-conns=10000 --wsess=10,10,0.1
```

# File

用户在用户空间中处理的内容，不会直接写入磁盘。它们首先写入 VFS 页缓存，从中有各种 I/O 调度程序，设备驱动程序将与磁盘交互以写入数据。

## VFS

### cache

#### cachetop(bcc)

#### cachestat(bcc)

#### [pcstat](https://github.com/tobert/pcstat)

```bash
pcstat *
```

#### [hcache](https://github.com/silenceshell/hcache)

```bash
hcache --top 10
```

### opensnoop(bcc)

FD:
| FD | 操作 |
|------|------|
| 0x3 | 读取 |
| 0x1b | 写入 |

```bash
opensnoop -p $(pgrep -of nvim)
```

### fileslower(bcc)

检查 page fault

```bash
# 延迟大于 1 ms(毫秒)的文件
fileslower 1
```

## File system

## Block devices interface

### iostat(sysstat)

**局限性:**

- 错误 I/O

```bash
# -p 指定刷新秒数，每秒刷新
iostat -p 1

# 每秒刷新,一共刷新5次
iostat -p 1 5

# -p 指定 sda 分区,每秒刷新
iostat -p sda 1
```

| 列                   | 操作                          |
| -------------------- | ----------------------------- |
| tps                  | 每秒事务数（IOPS）            |
| kB_read/s、kB-wztn/s | 每秒读取 KB 数,每秒写入 KB 数 |
| kBread、kB-wrtn      | 总共读取和写入的 KB 数        |

```bash
# -x 更多参数
iostat -x -p sda 1

# -z 不显示0值
iostat -xkdz -p sda 1
```

| 列       | 操作                                                               |
| -------- | ------------------------------------------------------------------ |
| rrqm/s   | 每秒合并放入驱动请求队列的读请求数                                 |
| wrqm/s   | 每秒合并放入驱动请求队列的写请求数                                 |
| r/s      | 每秒发给磁盘设备的读请求数                                         |
| w/s      | 每秒发给磁盘设备的写请求数                                         |
| rkB/s    | 每秒从磁盘设备读取的 KB 数                                         |
| wkB/s    | 每秒向磁盘设备写人的 KB 数                                         |
| avgrq-sz | 平均请求大小，单位为扇区（512B）                                   |
| avgqu-sz | 在驱动请求队列和在设备中活跃的平均请求数                           |
| await    | 平均 I/O 响应时间,包括在驱动请求队列里等待和设备的 IO 响应时间(ms) |
| r_await  | 和 await 一样，不过只针对读（ms）                                  |
| w_await  | 和 await 一样，不过只针对写（ms）                                  |
| svctm    | （推断）磁盘设备的 IO 平均响应时间（ms）                           |
| %util    | 设备忙处理 I/O 请求的百分比（使用率）                              |

### biosnoop(bcc)

查看进程 I/O 延迟

```bash
# -Q 显示包括队列的时间
biosnoop -Q
```

# Disk

## [inotify-tools](https://github.com/inotify-tools/inotify-tools)

监控 `/tmp` 目录下的文件操作

```bash
sudo inotifywait -mrq --timefmt '%Y/%m/%d-%H:%M:%S' --format '%T %w %f' \
 -e modify,delete,create,move,attrib .
```

## blktrace

```bash
blktrace /dev/sda

blktrace -d /dev/sda -o -|blkparse -i -

# 统计30秒每个cpu的io事件
blktrace -w 30 -d /dev/sda -o io-debugging
# 查看io-debugging.blktrace.0文件的事件
blkparse io-debugging.blktrace.0
# seekwatcher 图形化
seekwatcher -t io-debugging.blktrace.0 -o seek.png
seekwatcher -t io-debugging.blktrace.0 -o seekmoving.mpg --movie
```

## btrace

| 列  | 操作                                                                              |
| --- | --------------------------------------------------------------------------------- |
| 1   | 设备主要、次要编号                                                                |
| 2   | CPU ID                                                                            |
| 3   | 序号                                                                              |
| 4   | 活动时间,以秒为单位                                                               |
| 5   | 进程 ID                                                                           |
| 6   | 活动标识符(见下)                                                                  |
| 7   | RWBS 描述:可能包括了 R(读)、W(写)、D(块丢弃)、B(屏障操作)、s(同步)                |
| 8   | 184773879+8[cksum]意味着一个位于块地址 184773879 大小为 8(扇区)、cksum 进程的 I/O |

| 第 6 列标识符 | 操作                                  |
| ------------- | ------------------------------------- |
| A             | Io was remapped to a different device |
| B             | IO bounced                            |
| C             | IO completion                         |
| D             | IO issued to driver                   |
| F             | IO front merged with request on queue |
| G             | Get request                           |
| I             | IO inserted onto request queue        |
| M             | IO back merged with request on queue  |
| P             | Plug request                          |
| Q             | IO handled by request queue code      |
| S             | Sleep request                         |
| T             | Unplug due to timeout                 |
| U             | Unplug request                        |
| X             | Split                                 |

```bash
btrace /dev/nvme0n1

# 只追踪issue事件,第 6 列标识符为D
btrace -a issue /dev/nvme0n1p5
```

## dd

```bash
# iflag=direct oflag=direct绕过内核缓存并显著提高性能

# 备份/dev/nvme0n1p5,包含日期年月日的文件名
dd if=/dev/nvme0n1p5 of=/tmp/centos8-$(date +"%Y-%m-%d").gz

# 通过 pv 命令显示速度
dd if=/dev/nvme0n1p5 | pv | dd of=/tmp/centos8-$(date +"%Y-%m-%d").gz

# gzip压缩
dd if=/dev/nvme0n1p5 | gzip > /tmp/centos8.gz
# 还原
gzip -dc /tmp/centos8.gz | dd of=/dev/nvme0n1p5

# xz压缩
dd if=/dev/nvme0n1p5 | xz > /tmp/centos8.xz
# 还原
xz -dc /tmp/centos8.xz | dd of=/dev/nvme0n1p5
```

```bash
# 可以清离缓存后，多次运行dd测试
echo 3 > /proc/sys/vm/drop_caches
```

- `conv=fdatasync` 保证写入硬盘

---

`dd if=/dev/zero of=/tmp/iotest bs=1M count=1024 conv=fdatasync`

> ```bash
> # output
> 记录了1024+0 的读入
> 记录了1024+0 的写出
> 1073741824字节（1.1 GB，1.0 GiB）已复制，0.433301 s，2.5 GB/s
> ```

## hdparm

`hdparm -t /dev/sda`

> ```bash
> # output
> /dev/sda:
>  Timing buffered disk reads: 306 MB in  3.00 seconds = 101.89 MB/sec
> ```

```bash
# 内存速度
hdparm -T /dev/sda
```

> ```bash
> # output
> /dev/sda:
> Timing cached reads:   17800 MB in  2.00 seconds = 8912.51 MB/sec
> ```

## agedu

```bash
# 扫描根目录
agedu -s /

# 对刚才扫描的结果,在网页显示
agedu -w

# 只查看过去12个月或更长时间内未被访问的旧文件。
agedu -t /home/tz -a 12m
```

### 只统计.conf 文件

```bash
sudo agedu -s / --exclude "*" --include "*.conf"
agedu -w
```

![image](./Pictures/benchmark/2.png)

# Process

## [htop](https://github.com/hishamhm/htop)

![image](./Pictures/benchmark/htop.png)

## [bpytop](https://github.com/aristocratos/bpytop)

> instead bashtop

## [Procmon](https://github.com/Sysinternals/ProcMon-for-Linux)

> Sysinternals Process Monitor cli for Linux

## [SysMonTask](https://github.com/KrispyCamel4u/SysMonTask)

> windows process monitor for linux

## pidstat

> 监控单个进程的 CPU,MEM,I/O,上下文切换

![image](./Pictures/benchmark/bpytop.png)

```bash
# 每秒输出
pidstat 1

# 每秒输出十次
pidstat 1 10

# --human 自动转换单位
pidstat --human 1

# -C 指定程序名
pidstat -C nvim 1

# -t 显示线程
pidstat -t -C nvim 1

# -l show command line
pidstat -l -C nvim  1

# -p 指定pid
pidstat -p 1234 1

# 监控CPU,MEM,I/O,上下文切换
pidstat --human -udrw -C nvim 1
```

`-u` cpu(default option):

```bash
# %usr    - 用户的百分比
# %system - 内核的百分比
# %guest  - 虚拟程序的百分比
# %wait   - 等待的CPU百分比
# %CPU    - 总CPU用时
# CPU     - 程序运行具体的CPU number*
```

`-d` I/O:

```bash
# kB_rd/s - 任务从硬盘上的读取速度（kb）
# kB_wr/s - 任务向硬盘中的写入速度（kb）
# kB_ccwr/s - 任务写入磁盘被取消的速率（kb）

# 监控指定程序I/O
pidstat -d -C nvim 1
# 或者
pidstat -d -p $(pgrep nvim) 1
```

`-r` memory:

```bash
# 监控指定程序mem
pidstat -r -C nvim 1
```

`-w` 上下文切换:

```bash
# cswch/s   - 每秒自愿的上下文切换
# nvcswch/s - 每秒非自愿的上下文切换

# 监控指定程序switch
pidstat -w -C nvim 1
```

# 开机

## bootchart

```bash
sudo bootchartd
```

![image](./Pictures/benchmark/5.png)

# Special file system

## proc

- [linux proc 文档](https://mjmwired.net/kernel/Documentation/filesystems/proc.txt)

  | 目录      | 内容                                          |
  | --------- | --------------------------------------------- |
  | limits    | 实际的资源限制                                |
  | maps      | 映射的内存区域                                |
  | sched     | CPU 调度器的各种统计                          |
  | schedstat | CPU 运行时间、延时和时间分片                  |
  | smaps     | 映射内存区域的使用统计                        |
  | stat      | 进程状态和统计，包括总的 CPU 和内存的使用情况 |
  | statm     | 以页为单位的内存使用总结                      |
  | status    | stat 和 statm 的信息，用户可读                |
  | task      | 每个任务的统计目录                            |

```bash
# 可以清离缓存后，多次运行dd测试
echo 3 > /proc/sys/vm/drop_caches
```

## sys

### cgroup(进程组资源限制)

```bash
# 查看cgroup
mount -t cgroup

cd /sys/fs/cgroup/blkio
# 创建不同 I/O 优先级
mkdir high_prio
mkdir low_prio

# 查看
ls high_prio/

# 分配weight(权重),取值100-1000
echo 1000 > high_prio/blkio.bfq.weight
echo 100 > low_prio/blkio.bfq.weight

# 分配进程
echo $(pgrep -of nvim) > high_prio/cgroup.procs

# 查看cgroup的进程
cat high_prio/tasks
```

```bash
查看资源使用情况
systemd-cgtop
```

### debugfs

内核开发人员向用户空间提供信息的一种方法

```bash
mount -t debugfs debugfs /sys/kernel/debug
```

### 查看 `cpu` 的缓存

```bash
# 查看 cpu0 的缓存
grep . /sys/devices/system/cpu/cpu0/cache/index*/level
grep . /sys/devices/system/cpu/cpu0/cache/index*/size
```

### 查看 `I/O Scheduler(调度器)` 的缓存

```bash
cat /sys/block/sda/queue/scheduler

# 获取可用的调度器
grep "" /sys/block/*/queue/scheduler

# 修改调度器
echo bfq > /sys/block/sda/queue/scheduler
```

# GPU

## [nvidia-smi]()

```bash
# monitor process gpu usage
nvidia-smi pmon -i 0 -s u -o T
```

## [nvtop](https://github.com/Syllo/nvtop)

![image](./Pictures/benchmark/nvtop.png)

## [gpustat](https://github.com/wookayin/gpustat)

![image](./Pictures/benchmark/gpustat.png)

## [gmonitor](https://github.com/mountassir/gmonitor)

![image](./Pictures/benchmark/gmonitor.png)

# reference

- [当 Linux 内核遭遇鲨鱼—kernelshark](https://mp.weixin.qq.com/s?__biz=MzI3NzA5MzUxNA==&mid=2664608433&idx=1&sn=e19f0b6e311e12c4cbfda284c35b04c4&chksm=f04d9f54c73a1642b557617f2048fc74c924c53f633d735b4f89fa68013bcceb1f1fac02f30c&mpshare=1&scene=1&srcid=10093X7r15gdQX99G0DTR42o&sharer_sharetime=1602206243755&sharer_shareid=5dbb730cd6722d0343328086d9ad7dce#rd)
- [LinuxCast.net 每日播客](https://study.163.com/course/courseMain.htm?courseId=221001)
- [又一波你可能不知道的 Linux 命令行网络监控工具](https://linux.cn/article-5461-1.html)
- [Linux 性能优化：CPU 篇](https://zhuanlan.zhihu.com/p/180402964)
- [Linux 统计/监控工具 SAR 详细介绍](https://www.jianshu.com/p/08cc9a39a265)
- [Linux 统计/监控工具 SAR 详细介绍](https://www.jianshu.com/p/08cc9a39a265)

- [Unix System Monitoring and Diagnostic CLI Tools](https://monadical.com/posts/system-monitoring-tools.html)

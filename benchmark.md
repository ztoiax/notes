<!-- vim-markdown-toc GFM -->

* [all-have 综合](#all-have-综合)
    * [perf-tool](#perf-tool)
    * [vmstat](#vmstat)
    * [dstat](#dstat)
    * [sar(sysstat)](#sarsysstat)
* [CPU](#cpu)
    * [获取保留两位小数的 CPU 占用率：](#获取保留两位小数的-cpu-占用率)
    * [taskset (进程绑定 cpu)](#taskset-进程绑定-cpu)
* [memory](#memory)
* [File](#file)
    * [inotify-tools](#inotify-tools)
* [Net](#net)
    * [iperf3](#iperf3)
    * [mtr](#mtr)
    * [nethogs](#nethogs)
    * [bmon](#bmon)
    * [speedometer](#speedometer)
    * [httpstat](#httpstat)
* [Web](#web)
    * [ab](#ab)
    * [httperf](#httperf)
* [IO](#io)
    * [dd](#dd)
    * [hdparm](#hdparm)
* [disk](#disk)
    * [agedu](#agedu)
        * [只统计.conf 文件](#只统计conf-文件)
* [开机](#开机)
    * [bootchart](#bootchart)
* [FileSystem (文件)](#filesystem-文件)
    * [proc](#proc)
    * [sys](#sys)
        * [查看 `cpu` 的缓存](#查看-cpu-的缓存)
* [reference](#reference)

<!-- vim-markdown-toc -->

# all-have 综合

## [perf-tool](http://www.brendangregg.com/dtrace.html)

## vmstat

建议使用 `dstat`

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

# 显示5次time,load,保存为 csv 文件
dstat --time --load --output report.csv 1 5
```

```bash
# 选择 sda1 硬盘
dstat -d -D sda1
```

## sar(sysstat)

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

# CPU

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

# memory

ps -aux | sort -k4nr | head -K
ps aux --sort -rss | head
top -c -b -o +%MEM | head -n 20 | tail -15

# File

## [inotify-tools](https://github.com/inotify-tools/inotify-tools)

监控 `/tmp` 目录下的文件操作

```bash
sudo inotifywait -mrq --timefmt '%Y/%m/%d-%H:%M:%S' --format '%T %w %f' \
 -e modify,delete,create,move,attrib /tmp/
```

# Net

## iperf3

服务端:

```bash
iperf3 -s
```

客户端:

```bash
iperf3 -c
```

## [mtr](https://mp.weixin.qq.com/s?__biz=MzAxODI5ODMwOA==&mid=2666545753&idx=1&sn=2bf5b7f1c814371335a5f1b51798f3c7&chksm=80dc86f2b7ab0fe4cb14bdc1d1285ddff878c3a1355a1f469a21c3a7148b24d1f0b608bbd148&scene=21#wechat_redirect)

![avatar](/Pictures/benchmark/mtr.png)

## nethogs

![avatar](/Pictures/benchmark/1.png)

## bmon

![avatar](/Pictures/benchmark/3.png)

## speedometer

**useage** `speedometer -rx eth0`
![avatar](/Pictures/benchmark/4.png)

## [httpstat](https://github.com/reorx/httpstat)

[使用教程](https://linux.cn/article-8039-1.html)

![avatar](/Pictures/benchmark/httpstat.png)

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

# IO

```bash
# 可以清离缓存后，多次运行dd测试
echo 3 > /proc/sys/vm/drop_caches
```

## dd

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

# disk

## agedu

```bash
# 扫描根目录
agedu -s /

# 对刚才扫描的结果,在网页显示
agedu -w
```

### 只统计.conf 文件

```bash
sudo agedu -s / --exclude "*" --include "*.conf"
agedu -w
```

![avatar](/Pictures/benchmark/2.png)

# 开机

## bootchart

```bash
sudo bootchartd
```

![avatar](/Pictures/benchmark/5.png)

# FileSystem (文件)

## proc

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

### 查看 `cpu` 的缓存

```bash
# 查看 cpu0 的缓存
grep . /sys/devices/system/cpu/cpu0/cache/index*/level
grep . /sys/devices/system/cpu/cpu0/cache/index*/size
```

# reference

- [当 Linux 内核遭遇鲨鱼—kernelshark](https://mp.weixin.qq.com/s?__biz=MzI3NzA5MzUxNA==&mid=2664608433&idx=1&sn=e19f0b6e311e12c4cbfda284c35b04c4&chksm=f04d9f54c73a1642b557617f2048fc74c924c53f633d735b4f89fa68013bcceb1f1fac02f30c&mpshare=1&scene=1&srcid=10093X7r15gdQX99G0DTR42o&sharer_sharetime=1602206243755&sharer_shareid=5dbb730cd6722d0343328086d9ad7dce#rd)
- [LinuxCast.net 每日播客](https://study.163.com/course/courseMain.htm?courseId=221001)
- [又一波你可能不知道的 Linux 命令行网络监控工具](https://linux.cn/article-5461-1.html)
- [Linux 性能优化：CPU 篇](https://zhuanlan.zhihu.com/p/180402964)
- [Linux 统计/监控工具 SAR 详细介绍](https://www.jianshu.com/p/08cc9a39a265)
- [Linux 统计/监控工具 SAR 详细介绍](https://www.jianshu.com/p/08cc9a39a265)

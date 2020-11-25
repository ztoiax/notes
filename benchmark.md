<!-- vim-markdown-toc GFM -->

* [Web](#web)
    * [ab](#ab)
    * [httperf](#httperf)
* [Net](#net)
    * [mtr](#mtr)
    * [nethogs](#nethogs)
    * [bmon](#bmon)
    * [speedometer](#speedometer)
    * [httpstat](#httpstat)
* [综合](#综合)
    * [perf-tool](#perf-tool)
    * [sar(sysstat)](#sarsysstat)
    * [dstat](#dstat)
        * [每 2 秒(默认是 1 秒)输出 cpu 信息,一共 5 次](#每-2-秒默认是-1-秒输出-cpu-信息一共-5-次)
* [CPU](#cpu)
    * [获取保留两位小数的 CPU 占用率：](#获取保留两位小数的-cpu-占用率)
    * [perf](#perf)
* [memory](#memory)
* [IO](#io)
    * [dd](#dd)
    * [hdparm](#hdparm)
* [disk](#disk)
    * [agedu](#agedu)
        * [只统计.conf 文件](#只统计conf-文件)
* [开机](#开机)
    * [bootchart](#bootchart)
* [reference](#reference)

<!-- vim-markdown-toc -->

# Web

## ab

web 压力测试
安装包`apache-tools`

- `-c` 并发次数(模拟多少个客户端)
- `-n` 请求次数

`ab -c 1 -n 10000 https://127.0.0.1/index.html`

> ```sh
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

> ```sh
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

```sh
# --wsess=10,10,0.1 表示10个会话，每个会话10次请求，每次请求1秒
httperf --hog --server=127.0.0.1 --uri=index.html --num-conns=10000 --wsess=10,10,0.1
```

# Net

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

# 综合
## [perf-tool](http://www.brendangregg.com/dtrace.html)

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

```sh
# cpu使用率
sar -u 1 10
# 网络统计数据
sar -n DEV 1 10
sar -n EDEV 1 10
```

```sh
# 打印 cpu 序号为 5,7,1,3 核心的 cpu 使用率
sar -P 5,7,1,3 1

# 打印每个核心的cpu使用率
sar -P ALL 1 10

# 打印 idle 小于 10 的 cpu 核心
sar -P ALL 1 | tail -n+3 | awk '$NF<10 {print $0}'

# 打印所有中断的统计数据
sar -I ALL 1 10
```

## dstat

| 参数   | 操作         |
| ------ | ------------ |
| -c     | cpu          |
| --list | 列出监控选项 |

### 每 2 秒(默认是 1 秒)输出 cpu 信息,一共 5 次

```sh
dstat -c 2 5
```

# CPU

## 获取保留两位小数的 CPU 占用率：

top -b -n1 | grep ^%Cpu | awk '{printf("Current CPU Utilization is : %.2f%"), 100-\$8}'

## perf

# memory

ps -aux | sort -k4nr | head -K
ps aux --sort -rss | head
top -c -b -o +%MEM | head -n 20 | tail -15

# IO

```sh
# 可以清离缓存后，多次运行dd测试
echo 3 > /proc/sys/vm/drop_caches
```

## dd

- `conv=fdatasync` 保证写入硬盘

---

`dd if=/dev/zero of=/tmp/iotest bs=1M count=1024 conv=fdatasync`

> ```sh
> # output
> 记录了1024+0 的读入
> 记录了1024+0 的写出
> 1073741824字节（1.1 GB，1.0 GiB）已复制，0.433301 s，2.5 GB/s
> ```

## hdparm

`hdparm -t /dev/sda`

> ```sh
> # output
> /dev/sda:
>  Timing buffered disk reads: 306 MB in  3.00 seconds = 101.89 MB/sec
> ```

```sh
# 内存速度
hdparm -T /dev/sda
```

> ```sh
> # output
> /dev/sda:
> Timing cached reads:   17800 MB in  2.00 seconds = 8912.51 MB/sec
> ```

# disk

## agedu

```sh
# 扫描根目录
agedu -s /

# 对刚才扫描的结果,在网页显示
agedu -w
```

### 只统计.conf 文件

```sh
sudo agedu -s / --exclude "*" --include "*.conf"
agedu -w
```

![avatar](/Pictures/benchmark/2.png)

# 开机

## bootchart

```sh
sudo bootchartd
```

![avatar](/Pictures/benchmark/5.png)

# reference

- [当 Linux 内核遭遇鲨鱼—kernelshark](https://mp.weixin.qq.com/s?__biz=MzI3NzA5MzUxNA==&mid=2664608433&idx=1&sn=e19f0b6e311e12c4cbfda284c35b04c4&chksm=f04d9f54c73a1642b557617f2048fc74c924c53f633d735b4f89fa68013bcceb1f1fac02f30c&mpshare=1&scene=1&srcid=10093X7r15gdQX99G0DTR42o&sharer_sharetime=1602206243755&sharer_shareid=5dbb730cd6722d0343328086d9ad7dce#rd)
- [LinuxCast.net 每日播客](https://study.163.com/course/courseMain.htm?courseId=221001)
- [又一波你可能不知道的 Linux 命令行网络监控工具](https://linux.cn/article-5461-1.html)
- [Linux 性能优化：CPU 篇](https://zhuanlan.zhihu.com/p/180402964)
- [Linux 统计/监控工具 SAR 详细介绍](https://www.jianshu.com/p/08cc9a39a265)
- [Linux统计/监控工具SAR详细介绍](https://www.jianshu.com/p/08cc9a39a265)


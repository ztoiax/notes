<!-- vim-markdown-toc GFM -->

* [Web](#web)
    * [ab](#ab)
    * [httperf](#httperf)
* [Net](#net)
    * [nethogs](#nethogs)
    * [bmon](#bmon)
    * [speedometer](#speedometer)
* [综合](#综合)
    * [dstat](#dstat)
        * [每 2 秒(默认是 1 秒)输出 cpu 信息,一共 5 次](#每-2-秒默认是-1-秒输出-cpu-信息一共-5-次)
* [IO](#io)
    * [dd](#dd)
    * [hdparm](#hdparm)
* [disk](#disk)
    * [agedu](#agedu)
        * [只统计.conf 文件](#只统计conf-文件)
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

## nethogs

![avatar](/Pictures/benchmark/1.png)

## bmon

![avatar](/Pictures/benchmark/3.png)
## speedometer
**useage** `speedometer -rx eth0`
![avatar](/Pictures/benchmark/4.png)
# 综合

## dstat

| 参数   | 操作         |
| ------ | ------------ |
| -c     | cpu          |
| --list | 列出监控选项 |

### 每 2 秒(默认是 1 秒)输出 cpu 信息,一共 5 次

```sh
dstat -c 2 5
```

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

# reference

- [LinuxCast.net 每日播客](https://study.163.com/course/courseMain.htm?courseId=221001)
- [又一波你可能不知道的 Linux 命令行网络监控工具](https://linux.cn/article-5461-1.html)
- [Linux性能优化：CPU篇](https://zhuanlan.zhihu.com/p/180402964)

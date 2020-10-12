<!-- vim-markdown-toc GFM -->

* [Net](#net)
    * [ip](#ip)
        * [ip 别名(创建子接口)](#ip-别名创建子接口)
    * [ethtool](#ethtool)
    * [nmcli](#nmcli)
        * [交互模式](#交互模式)
    * [traceroute](#traceroute)
    * [tcptraceroute](#tcptraceroute)
    * [mtr](#mtr)
    * [tcpdump](#tcpdump)
        * [捕抓 192.168.1.1 的包](#捕抓-19216811-的包)
        * [捕抓 eth0 源端口是 80 的 10 个数据包,保存至 packets.pcap](#捕抓-eth0-源端口是-80-的-10-个数据包保存至-packetspcap)
        * [捕抓源是 192.168.1.1 的 icmp 协议](#捕抓源是-19216811-的-icmp-协议)
        * [捕抓 1-1024 端口(不包含 443 端口),并且包大于 1000 字节的流量](#捕抓-1-1024-端口不包含-443-端口并且包大于-1000-字节的流量)
        * [捕抓目标端口 80 的数据流量](#捕抓目标端口-80-的数据流量)
    * [arp](#arp)
    * [netstat](#netstat)
        * [统计 tcp 数量](#统计-tcp-数量)
        * [显示 LISTEM 状态 tcp](#显示-listem-状态-tcp)
        * [不解析地址(提高速度)](#不解析地址提高速度)
        * [显示所有 LISTEM 状态 tcp,udp 进程](#显示所有-listem-状态-tcpudp-进程)
        * [统计本地 tcp 链接数量](#统计本地-tcp-链接数量)
* [reference](#reference)

<!-- vim-markdown-toc -->

# Net

## ip

- `ip a` 查看 interface
- `ip route show` 查看默认路由
- `sudo ip link set eth1 up` 开启`eth0`接口
- `sudo ip link set eth1 down` 关闭`eth0`接口

### ip 别名(创建子接口)

`ip addr add 1.1.1.1/24 dev eth0 label eth0:0` 新增 ip 为`1.1.1.1` 的子接口

```sh
# 永久修改
cat > /etc/sysconfig/network-scripts/ifcfg-eth0:0 << 'EOF'
DEVICE=eth0:0
IPADDR=1.1.1.1
PREFIX=24
ONPARENT=yes
EOF
```

## ethtool

- `ethtool eth0` 显示`eth0`接口的详细信息
- `ethtool -i eth0`显示`eth0`接口的驱动信息
- `ethtool -a eth0`显示`eth0`接口的自动协商的详细信息
- `ethtool -S etho`显示`eth0`接口的状态

## nmcli

```sh
# 显示连接
nmcli connection show

# 显示活跃连接
nmcli connection show --active

# 添加eth2新连接
nmcli connection add type ethernet ifname eth2

# 开启，关闭
nmcli connection up eth0
nmcli connection down eth0

# 修改ip
nmcli connection modify eth0 ipv4.method manual
nmcli connection modify eth0 ipv4.address 192.168.100.2/24

# 修改为dhcp
nmcli connection modify eth0 ipv4.method auto

#
nmcli device show
```

### 交互模式

```sh
# 进入交互模式
nmcli connection edit eth0

# 修改ip
goto ipv4
set ipv4.address 192.168.100.2/24
save
```


## traceroute

它通过在一系列数据包中设置数据包头的 TTL（生存时间）字段来捕获数据包所经过的路径，以及数据包从一跳到下一跳需要的时间。

## tcptraceroute

tcptraceroute 命令与 traceroute 基本上是一样的，只是它能够绕过最常见的防火墙的过滤。正如该命令的手册页所述，tcptraceroute 发送 TCP SYN 数据包而不是 UDP 或 ICMP ECHO 数据包，所以其不易被阻塞。

## mtr

`mtr --report www.baidu.com` trace www.baidu.com

## tcpdump

| 参数 | 操作                                           |
| ---- | ---------------------------------------------- |
| -D   | 显示可捕抓的接口                               |
| -i   | 指定接口                                       |
| -c   | 只抓多少个包                                   |
| -w   | 写入文件                                       |
| -r   | 读取文件                                       |
| -v   | 包的细节——越多的 v，越详细(一般 3 个 v 就足够) |
| -A   | 以 ascii 显示内容                              |
| -X   | 以 ascii 和 16 进制显示内容                    |
| -n   | 不解析域名                                     |

**可通过逻辑门组合**

- and
- or
- not

| 参数      | 操作                       |
| --------- | -------------------------- |
| tcp       | tcp                        |
| udp       | udp                        |
| port      | 端口                       |
| portrange | 端口范围                   |
| host      | 指定地址                   |
| src       | 源                         |
| dst       | 目标                       |
| greater   | 只捕抓大于指定字节的流量   |
| less      | 只捕抓小于于指定字节的流量 |

### 捕抓 192.168.1.1 的包

```sh
sudo tcpdump -vv host 192.168.1.1
```

- [termshark](https://github.com/gcla/termshark)
- [wireshark](https://github.com/wireshark/wireshark)

### 捕抓 eth0 源端口是 80 的 10 个数据包,保存至 packets.pcap

```sh
sudo tcpdump -c 10 -i eth0 src port 80 -w packets.pcap
```

### 捕抓源是 192.168.1.1 的 icmp 协议

```sh
sudo tcpdump icmp -n and src 192.168.1.1
```

### 捕抓 1-1024 端口(不包含 443 端口),并且包大于 1000 字节的流量

```sh
sudo tcpdump -n not port 443 and portrange 1-1024 and greater 1000
```

### 捕抓目标端口 80 的数据流量

```sh
tcpdump -ni eth0 dst port 80
```

## arp

`arp -a` 显示`mac`地址

## netstat

| 参数 | 操作                 |
| ---- | -------------------- |
| -a   | 所有                 |
| -t   | tcp                  |
| -u   | udp                  |
| -n   | 不解析域名(提高速度) |
| -p   | 进程                 |
| -c   | 实时监控             |
| -l   | LISTEN               |

### 统计 tcp 数量

```sh
netstat -t | wc -l
````

### 显示 LISTEM 状态 tcp

```sh
netstat -lt
```

### 不解析地址(提高速度)

```sh
netstat -lnt
```

### 显示所有 LISTEM 状态 tcp,udp 进程

```sh
netstat -tunlp
```

### 统计本地 tcp 链接数量

```sh
netstat -tn | awk '{print $4}' | awk -F ":" '{print $1}' | sort | uniq -c
```

# reference

- [linux china](https://linux.cn/article-9358-1.html)
- [LinuxCast.net 每日播客](https://study.163.com/course/courseMain.htm?courseId=221001)
- [在命令行中使用 nmcli 来管理网络连接 | Linux 中国](https://mp.weixin.qq.com/s?__biz=MjM5NjQ4MjYwMQ==&mid=2664623350&idx=3&sn=0e4f7ff89170be816daf7b94c0c777d0&chksm=bdced7b08ab95ea6085718176a1325dfb7c09a1ad9abe33c58d35b2bd2ec0f5a5043ca125f8a&mpshare=1&scene=1&srcid=1012v37rkYRVe9EamFSHzoqv&sharer_sharetime=1602496258631&sharer_shareid=5dbb730cd6722d0343328086d9ad7dce#rd)

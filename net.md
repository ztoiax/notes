<!-- vim-markdown-toc GFM -->

* [Net](#net)
    * [ip](#ip)
    * [ethtool](#ethtool)
    * [traceroute](#traceroute)
    * [tcptraceroute](#tcptraceroute)
    * [mtr](#mtr)
    * [tcpdump](#tcpdump)
    * [arp](#arp)
* [reference](#reference)

<!-- vim-markdown-toc -->

# Net

## ip

- `ip a` 查看 interface
- `ip route show` 查看默认路由
- `sudo ip link set eth1 up` 开启`eth0`接口
- `sudo ip link set eth1 down` 关闭`eth0`接口

## ethtool

- `ethtool eth0` 显示`eth0`接口的详细信息
- `ethtool -i eth0`i 显示`eth0`接口的驱动信息
- `ethtool -a eth0`i 显示`eth0`接口的自动协商的详细信息

## traceroute

它通过在一系列数据包中设置数据包头的 TTL（生存时间）字段来捕获数据包所经过的路径，以及数据包从一跳到下一跳需要的时间。

## tcptraceroute

tcptraceroute 命令与 traceroute 基本上是一样的，只是它能够绕过最常见的防火墙的过滤。正如该命令的手册页所述，tcptraceroute 发送 TCP SYN 数据包而不是 UDP 或 ICMP ECHO 数据包，所以其不易被阻塞。

## mtr

`mtr --report www.baidu.com` trace www.baidu.com

## tcpdump

- `tcpdump -D` 显示可捕抓的接口
- `sudo tcpdump -vv host 192.168.1.1` `-v` 选项控制你看到的细节程度——越多的 v，越详细
- `sudo tcpdump -c 11 -i eth0 src 192.168.1.1 -w packets.pcap` 捕获来自特定主机和 eth0 上的 11 个数据包。-w 选项标识保存捕获包的文件

## arp

`arp -a` 显示`mac`地址

# reference

[linux china](https://linux.cn/article-9358-1.html)

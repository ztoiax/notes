<!-- vim-markdown-toc GFM -->

* [Net](#net)
    * [ip(iproute2)](#ipiproute2)
    * [ipcalc(ip二进制显示)](#ipcalcip二进制显示)
    * [ethtool](#ethtool)
    * [nmcli](#nmcli)
        * [交互模式](#交互模式)
    * [ssh](#ssh)
        * [代理(agent)](#代理agent)
    * [frp: 反向代理(内网穿透)](#frp-反向代理内网穿透)
        * [端口](#端口)
        * [sock](#sock)
        * [文件服务器](#文件服务器)
        * [http转https](#http转https)
        * [tls](#tls)
    * [traceroute](#traceroute)
    * [tcptraceroute](#tcptraceroute)
    * [nping(代替 ping)](#nping代替-ping)
    * [hping](#hping)
    * [mtr](#mtr)
    * [tcpdump](#tcpdump)
        * [基本命令](#基本命令)
        * [捕抓 TCP SYN，ACK 和 FIN 包](#捕抓-tcp-synack-和-fin-包)
    * [http抓包的gui](#http抓包的gui)
    * [arp](#arp)
    * [arpwatch](#arpwatch)
    * [netstat](#netstat)
        * [统计 tcp 数量](#统计-tcp-数量)
        * [显示 LISTEM 状态 tcp](#显示-listem-状态-tcp)
        * [不解析地址(提高速度)](#不解析地址提高速度)
        * [显示所有 LISTEM 状态 tcp,udp 进程](#显示所有-listem-状态-tcpudp-进程)
        * [显示所有 tcp,udp 进程](#显示所有-tcpudp-进程)
        * [统计本地 tcp 链接数量](#统计本地-tcp-链接数量)
        * [查看本地unix socket的连接](#查看本地unix-socket的连接)
    * [ss (iproute2)](#ss-iproute2)
    * [nc](#nc)
    * [nmap](#nmap)
        * [基本命令](#基本命令-1)
        * [显示本机网络，路由信息](#显示本机网络路由信息)
        * [扫描文件内的 ip 地址](#扫描文件内的-ip-地址)
        * [使用 tmp 扫描](#使用-tmp-扫描)
    * [zmap](#zmap)
    * [tc(traffic control)](#tctraffic-control)
    * [socat](#socat)
    * [ngrep](#ngrep)
    * [whois(查看域名注册信息)](#whois查看域名注册信息)
    * [curl](#curl)
        * [基本命令](#基本命令-2)
            * [POST PATCH DELETE](#post-patch-delete)
        * [webhook](#webhook)
    * [httpie](#httpie)
    * [testssl(测试网站是否支持ssl/tls，以及检测漏洞)](#testssl测试网站是否支持ssltls以及检测漏洞)
    * [nghttp](#nghttp)
    * [h2spec](#h2spec)
    * [wrk: http benchmark](#wrk-http-benchmark)
    * [wrk2: wrp的变种](#wrk2-wrp的变种)
    * [dnspeep](#dnspeep)
    * [lighthouse(chrome 网页性能测试)](#lighthousechrome-网页性能测试)
    * [mitmproxy(代理http, 并抓包)](#mitmproxy代理http-并抓包)
    * [websocat:创建websocat](#websocat创建websocat)
    * [websocketd:创建websocket服务执行命令](#websocketd创建websocket服务执行命令)
    * [nali(ip地址离线数据库)](#naliip地址离线数据库)
* [reference](#reference)
* [优秀文章](#优秀文章)
* [在线工具](#在线工具)

<!-- vim-markdown-toc -->

# Net

- [ ] net-tools

  > 使用 `ioctl` 系统调用,和通过 `/proc` 目录读取数据

- [x] iproute2(推荐)
  > 使用 `netlink` 内核接口获取数据,比 `ioctl` 要好

| net-tools        | iproute2                |
| ---------------- | ----------------------- |
| ifconfig         | ip addr, ip link, ip -s |
| route            | ip route                |
| arp              | ip neigh                |
| iptunnel         | ip tunnel               |
| nameif, ifrename | ip link set name        |
| ipmaddr          | ip maddr                |
| netstat          | ip -s, ss, ip route     |
| brctl            | bridge                  |
|                  | tc(qos)                 |

- 重启网卡

```sh
systemctl restart NetworkManager.service
```

## ip(iproute2)

| 参数    | 简写 | 内容     |
| ------- | ---- | -------- |
| link    | l    | 接口     |
| address | a    | 地址     |
| route   | r    | 路由     |
| neigh   | n    | arp      |
| netns   |      | 命名空间 |

```bash
# 只查看ip地址
ip -brief -c address

# 只查看mac地址
ip -br -c link
```

- ip address

```bash
# 查看 interface
ip address
# 或者
ip a

# 查看eth0
ip a show dev eth0

# -s 查看详细信息,类似ifconfig
ip -s a

# 以json格式显示
ip --json addr show

# jq命令过滤, 查看ip地址
ip --json addr show | jq '.[].addr_info[].local'

# watch命令每秒监控
watch -d -n 1 ip -s a

# 新增 ip 为 1.1.1.1
ip a add 1.1.1.1/24 dev eth0

# 新增 ip 为 2.2.2.2 并添加标签eth0:0
ip a add 2.2.2.2/24 dev eth0 label eth0:0

# 删除刚才新增的ip
ip a del 2.2.2.2/24 dev eth0:0
ip a del 1.1.1.1/24 dev eth0
```

- ip route

```bash
# 查看默认路由
ip route

# 新增路由
ip route add 1.1.1.0/24 via 192.168.1.1

# 新增 eth0设备的路由
ip route add 1.1.1.0/24 via 192.168.1.1 dev eth0

# 新增 eth0设备的默认路由
ip route add default via 192.168.1.1 dev eth0

# 删除路由
ip route del 1.1.1.0/24

# 删除默认路由
ip route del default
```

- ip link

```bash
# 开启/关闭接口
ip link set eth0 up
ip link set eth0 down

# 开启/关闭组播
ip link set dev eth0 multicast on
ip link set dev eth0 multicast off

# 开启/关闭arp解析
ip link set dev eth0 arp on
ip link set dev eth0 arp off

# 修改 mtu 为9000
ip link set mtu 9000 dev eth0
```

- ip neigh(arp 表)

```bash
# 可以先用 nmap 扫描网段,在执行
ip neigh

# -s 详细信息
ip -s neigh

# flush删除192.168.1.101的arp条目
ip -s -s neigh flush 192.168.1.101
# 或者
ip -s -s n f 192.168.1.101
```

- ip netns(命名空间)

path: `/var/run/netns`

```bash
# 新建enp1
ip netns add enp1

# 查看命名空间
ip netns list
```

永久修改 ip

```bash
cat > /etc/sysconfig/network-scripts/ifcfg-eth0:0 << 'EOF'
DEVICE=eth0:0
IPADDR=1.1.1.1
PREFIX=24
ONPARENT=yes
EOF
```

## ipcalc(ip二进制显示)

- [教程](https://www.linux.com/topic/networking/how-calculate-network-addresses-ipcalc/)

## ethtool

- `ethtool eth0` 显示`eth0`接口的详细信息
- `ethtool -i eth0`显示`eth0`接口的驱动信息
- `ethtool -a eth0`显示`eth0`接口的自动协商的详细信息
- `ethtool -S etho`显示`eth0`接口的状态

```sh
# 显示eth0的速度
ethtool eth0
Settings for eth0:
    Speed: 10000Mb/s
```

## nmcli

```bash
# 显示连接
nmcli connection show

# 显示活跃连接
nmcli connection show --active

# 添加eth2新连接
nmcli connection add type ethernet ifname eth2

# 开启，关闭 "Wired Connection"为 device name
nmcli connection down "Wired Connection"
nmcli connection up "Wired Connection"

# 修改ip 需要重启网卡.电脑重启依然生效
nmcli connection modify "Wired Connection" ipv4.method manual
nmcli connection modify "Wired Connection" ipv4.address 192.168.100.2/24

# 修改为dhcp
nmcli connection modify "Wired Connection" ipv4.method auto

# 修改dns
nmcli connection modify "Wired Connection" ipv4.dns "114.114.114.114 223.5.5.5"

# 查看网卡配置
nmcli device show
```

### 交互模式

```bash
# 进入交互模式
nmcli connection edit eth0

# 修改ip
goto ipv4
set ipv4.address 192.168.100.2/24
save
```

## ssh

- [arch文档](https://wiki.archlinux.org/title/OpenSSH#Forwarding_other_ports)

- 配置文件:

 | 文件内容     | 路径                 |
 |--------------|----------------------|
 | 配置文件     | /etc/ssh/sshd_config |
 | 存放公钥私钥 | /etc/ssh             |

 - 关闭密码登陆, 强制密钥登陆
 ```
 PasswordAuthentication no
 AuthenticationMethods publickey
 ```

 - 运行root用户登陆(默认是关闭)
 ```
 PermitRootLogin yes
 ```

 - 大多数情况下关闭root用户登陆, 但有些命令需要root权限. 可以在`/root/.ssh/authorized_keys` 文件的密钥前面加入
 ```
 command="/usr/lib/rsync/rrsync -ro /" ssh-rsa …
 ```
 - 配置文件
 ```
 PermitRootLogin forced-commands-only
 ```

 - 对root用户执行的命令, 都需要密钥验证(相比上一条方案, 限制低一些)
 ```
 PermitRootLogin prohibit-password
 ```

 - 开启gzip压缩(默认是关闭)
 ```
 Compression yes
 ```

```sh
# 查看连接会话
netstat -tnpa | grep sshd
# or
ps aux | grep sshd
```

```sh
# -f 连接后, 执行命令
ssh -f 127.0.0.1 ls
```

- `sshguard` 软件可以防止暴力破解

### 代理(agent)
- [韦易笑: SSH 命令的三种代理功能（-L/-R/-D）](https://www.skywind.me/blog/archives/2546#more-2546)

| 参数 | 操作       |
|------|------------|
| -L   | 正向代理   |
| -R   | 反向代理   |
| -D   | socks5代理 |

```sh
# -L 端口转发. 将9900转发到5900(vnc端口), 实现更安全的vnc连接
ssh 127.0.0.1 -L 9900:127.0.0.1:5900

# 正向代理. 将9900转发到5900(vnc端口), 实现更安全的vnc连接
ssh 127.0.0.1 -L 8080:192.168.100.208:80 root@192.168.100.208
ssh -L 127.0.0.1:8080:192.168.100.208:80 root@192.168.100.208
```

## [frp: 反向代理(内网穿透)](https://github.com/fatedier/frp/blob/dev/README_zh.md)


- web monitor

```ini
# frps.ini
[common]
bind_port = 7000

dashboard_port = 7500
# dashboard's username and password are both optional
dashboard_user = admin
dashboard_pwd = admin
```


- 开启加密和压缩
```ini
# frpc.ini
[ssh]
type = tcp
local_port = 22
remote_port = 6000

use_encryption = true
use_compression = true
```

### 端口

- 将8081的流量, 通过服务器的7000端口, 转发到8080

- server
```ini
# frps.ini
[common]
bind_port = 7000
```

- client
```ini
# frpc.ini
[common]
server_addr = 127.0.0.1
server_port = 7000

[web]
type = tcp
local_ip = 127.0.0.1
local_port = 8080
remote_port = 8081
```

```sh
# 启动server
frps -c frps.ini

# 启动client
frpc -c frpc.ini
```

### sock

- client
```ini
# frpc.ini
[common]
server_addr = 127.0.0.1
server_port = 7000

[unix_domain_socket]
type = tcp
remote_port = 8081
plugin = unix_domain_socket
plugin_unix_path = /var/run/docker.sock
```

```sh
curl http://127.0.0.1:8081/version
```

### 文件服务器

- client
```ini
# frpc.ini
[common]
server_addr = 127.0.0.1
server_port = 7000

[test_static_file]
type = tcp
remote_port = 8081
plugin = static_file
plugin_local_path = /tmp/dir
plugin_strip_prefix = dir
plugin_http_user = abc
plugin_http_passwd = abc
```

```sh
xdg-open http://127.0.0.1:8081/dir/
```

### http转https

- 生成ssl证书

```sh
openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out server.crt \
            -keyout server.key
```

- client
```ini
# frpc.ini
[common]
server_addr = 127.0.0.1
server_port = 7000

[web]
type = tcp
local_ip = 127.0.0.1
remote_port = 8081

plugin = https2http
plugin_local_addr = 127.0.0.1:8080
plugin_crt_path = ./server.crt
plugin_key_path = ./server.key
plugin_host_header_rewrite = 127.0.0.1
plugin_header_X-From-Where = frp
```

```sh
curl https://127.0.0.1:8081
```

### tls

- [生成tls密钥](https://github.com/fatedier/frp#tls)

- server
```ini
# frps.ini
[common]
bind_port = 7000

tls_only = true
tls_enable = true
tls_cert_file = server.crt
tls_key_file = server.key
tls_trusted_ca_file = ca.crt
```

- client
```ini
# frpc.ini
[common]
server_addr = 127.0.0.1
server_port = 7000

tls_enable = true
tls_cert_file = client.crt
tls_key_file = client.key
tls_trusted_ca_file = ca.crt

[web]
type = tcp
local_ip = 127.0.0.1
local_port = 8080
remote_port = 8081
```

```sh
xdg-open http://127.0.0.1:8081/dir/
```

## traceroute

原理是向目的主机发送ICMP报文，发送第一个报文时，设置TTL为0，TTL即Time to Live，是报文的生存时间，由于它是0，所以下一个路由器由到这个报文后，不会再继续转发了，会给源主机发送ICMP出错的报文，就可以知道第一个路由的IP地址，同理，设置TTL为1，就可以知道第二个路由的IP地址，依次类推。

## tcptraceroute

tcptraceroute 命令与 traceroute 基本上是一样的，只是它能够绕过最常见的防火墙的过滤。正如该命令的手册页所述，tcptraceroute 发送 TCP SYN 数据包而不是 UDP 或 ICMP ECHO 数据包，所以其不易被阻塞。

## nping(代替 ping)

| 参数 | 操作       |
| ---- | ---------- |
| -c   | 发送多少次 |

```bash
# icmp echo request(等同于ping)
nping --icmp -c 3 www.baidu.com

# tcp连接(三次握手)
nping --tcp-connect -c 3 -p 80,443 baidu.com

# tcp syn
nping --tcp -c 2 --flags syn -p 80 baidu.com

# --ttl 设置ttl
nping --tcp -c 2 --flags syn --ttl 10 -p 80 baidu.com

# --win指定tcp窗口大小
nping --tcp -c 2 --win 1600 -p 80 baidu.com
```

## [hping](http://www.hping.org/)

- [Hping Tips and Tricks](https://iphelix.medium.com/hping-tips-and-tricks-85698751179f)


- tcp

| tcp flag | 操作              |
|----------|-------------------|
| -S       | syn flags=s SYN   |
| -A       | ack flags=a ACK   |
| -R       | rst flags=r RST   |
| -F       | fin flags=f FIN   |
| -P       | push flags=p PUSH |
| -U       | urg flags=u URG   |
| -X       | xmas flags=x Xmas |
| -Y       | ymas flags=y Tmas |


```sh
# -c 表示只发送一次syn.返回的flags=SA, 即包含syn,ack
hping3 -S www.baidu.com -p 80 -c 1

# 从50端口开始递增，每个端口都发送(扫描)
hping3 -S www.baidu.com -p ++50

# 模拟SYN flood攻击
hping3 -S -p 80 --flood 127.0.0.1
```

- udp

```sh
hping3 -2 127.0.0.1 -p 80 -c 1
```

- 扫描网段
```sh
hping3 -1 192.168.1.x --rand-dest -I enp27s0
```

- icmp ping

```sh
# -1 icmp模式
hping3 --traceroute -V -1 www.baidu.com
```

## mtr

```sh
# 查看连接baidu的丢包率，默认用icmp包
mtr --report www.baidu.com

# 使用udp包
mtr -u -r www.baidu.com
```

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

- [termshark](https://github.com/gcla/termshark)
- [wireshark](https://github.com/wireshark/wireshark)

### 基本命令

```bash
# 捕抓 192.168.1.1 的包
sudo tcpdump -vv host 192.168.1.1

# 捕抓 eth0 网卡的 icmp 流量
sudo tcpdump -ni eth0 icmp

# 捕抓源是 192.168.1.1 的 icmp 流量
sudo tcpdump -ni eth0 icmp -n and src 192.168.1.1

# 捕抓 eth0 源端口是 80 的 10 个数据包,保存至 packets.pcap
sudo tcpdump -c 10 -i eth0 src port 80 -w packets.pcap

# 捕抓目标端口 80 的数据流量
tcpdump -ni eth0 dst port 80

# 捕抓目标ip 192.168.1.1 端口 22 的数据流量
tcpdump -ni eth0 dst 192.168.1.1 and port 22

# 捕抓 1-1024 端口(不包含 443 端口),并且包大于 1000 字节的流量
sudo tcpdump -n not port 443 and portrange 1-1024 and greater 1000
```

### 捕抓 TCP SYN，ACK 和 FIN 包

```bash
# 只捕抓TCP syn包：
tcpdump -i eth0 "tcp[tcpflags] & (tcp-syn) != 0"

# 只捕抓目标是百度的TCP syn包：
tcpdump -ni eth0 dst www.baidu.com and "tcp[tcpflags] & (tcp-syn) != 0"

# 只捕抓TCP ack包：
tcpdump -i eth0 "tcp[tcpflags] & (tcp-ack) != 0"

# 只捕抓TCP FIN包：
tcpdump -i eth0 "tcp[tcpflags] & (tcp-fin) != 0"

# 只捕抓TCP SYN或ACK包：
tcpdump -i eth0 "tcp[tcpflags] & (tcp-syn|tcp-ack) != 0"

# 只捕抓TCP SYN或ACK包(不包含22端口)：
tcpdump -i eth0 not port 22 and "tcp[tcpflags] & (tcp-syn|tcp-ack) != 0"

# 只捕抓TCP SYN或ACK包(不包含22,80端口)：
tcpdump -i ens3 not port 22 and not port 80 and "tcp[tcpflags] & (tcp-syn|tcp-ack) != 0"
```

## [http抓包的gui](https://github.com/avwo/whistle)


## arp

```bash
arp -a

# 不解析域名
arp -n

# 删除192.168.1.1条目
arp -d 192.168.1.1
```

## arpwatch

监听网络上 ARP 的记录

```bash
arpwatch -i enp27s0 -f arpwatch.log
```

## netstat

- 建议使用 `ss` 参数差不多,更快,信息更全
- 建议开启 `sudo` 不然不会显示端口对应的程序命令

| 参数   | 操作                  |
| ----   | --------------------- |
| -a     | 所有                  |
| -t     | tcp                   |
| -u     | udp                   |
| -n     | 不解析域名(提高速度)  |
| -p     | 进程                  |
| -c     | 实时监控              |
| -l     | LISTEN                |
| -s     | 查看 TCP/UDP 状态     |
| -i     | 查看 每个接口的包统计 |
| -s     |显示网络统计信息       |
| --unix | unix sockets          |

### 统计 tcp 数量

```bash
netstat -t | wc -l
```

### 显示 LISTEM 状态 tcp

```bash
netstat -lt
```

### 不解析地址(提高速度)

```bash
netstat -lnt
```

### 显示所有 LISTEM 状态 tcp,udp 进程

进程显示 `-` 表示该连接为内核处理

```bash
netstat -tunlp
```

### 显示所有 tcp,udp 进程

```bash
netstat -tunap
#or
netstat -ap | grep -v unix
```

### 统计本地 tcp 链接数量

```bash
netstat -tn | awk '{print $4}' | awk -F ":" '{print $1}' | sort | uniq -c
```

### 查看本地unix socket的连接

```sh
netstat -a -p --unix
```

## ss (iproute2)

> 基本等同于 `netstat` 工作在 `socket` 层,没有 `-n` 选项,因此不能显示域名

| 参数 | 操作                      |
|------|-----------------------|
| -l   | listening状态的socket |
| -t   | 只显示tcp socket      |

```bash
# 显示所有 LISTEM 状态 tcp,udp 进程
ss -tulp

# 显示所有 tcp,udp 进程
ss -tuap

# 查看ESTABLISHED状态的连接
ss -tuap state ESTABLISHED

# 查看目标ip的cwnd、rtt、rto等网络参数
ss -itmpn dst 104.18.3.111
```

## nc

服务端开启 1234 端口传送文件:

```bash
nc -l 1234 > file
```

客户端接受文件

```bash
nc <server ip> 1234 < file
```

```bash
while true;do
    date | nc -l 1234
done
```

## nmap

- zenmap(gui版nmap)

端口状态:

| STATE      | 内容         |
| ---------- | ------------ |
| open       | 开启         |
| closed     | 关闭         |
| filtered   | 被防火墙屏蔽 |
| unfiltered | 不确定状态   |

### 基本命令

```bash
# 扫描指定ip端口
nmap 127.0.0.1

# 详细扫描
nmap -v 127.0.0.1

# 扫描系统消息
nmap -A 127.0.0.1

# 扫描整个192.168.1.0网段的主机
nmap -sn "192.168.1.*"
# 或者
nmap -sn 192.168.1.0/24

# 扫描整个192.168.1.0网段的端口
nmap "192.168.1.*"

# 扫描192.168.1.0网段,排除192.168.1.1
nmap "192.168.1.*" --exclude 192.168.1.1

# 扫描192.168.1.200-254
nmap 192.168.1.200-254

# 扫描特定端口
nmap -p 80 127.0.0.1
```

### 显示本机网络，路由信息

```bash
nmap --iflist
```

### 扫描文件内的 ip 地址

```bash
cat > nmapfile << 'EOF'
127.0.0.1
192.168.1.1
192.168.100.208
EOF

nmap -iL nmapfile
```

### 使用 tmp 扫描

```bash
# TCP connect scan
nmap -sT 192.168.1.1

# TCP SYN
nmap -sS 192.168.1.1

# UDP
nmap -sU 192.168.1.1

# TCP ACK
nmap -PA 192.168.1.1
```

## [zmap](https://github.com/zmap/zmap)

- 比nmap速度要快 [ZMap 为什么能在一个小时内就扫描整个互联网？](https://www.zhihu.com/question/21505586/answer/18443313)

## tc(traffic control)

qdisc:

```bash
# 查看队列
tc -d qdisc

# 查看队列流量
tc -s qdisc

# 设置根队列 1000 MBit/s
tc qdisc add dev ens3 root handle 1: \
    cbq avpkt 1000 bandwidth 1000Mbit

# 分别设置3类,1M,10M,100M
tc class add dev ens3 parent 1: classid 1:1 \
    cbq rate 1Mbit allot 1500 bounded

tc class add dev ens3 parent 1: classid 1:2 \
    cbq rate 10Mbit allot 1500 bounded

tc class add dev ens3 parent 1: classid 1:3 \
    cbq rate 100Mbit allot 1500 bounded

# 过滤5001目标端口
tc filter add dev ens3 parent 1: \
    protocol ip u32 match ip dport 5001 0xffff flowid 1:1

tc filter add dev ens3 parent 1: \
    protocol ip u32 match ip protocol 6 0xff \
    match ip dport 5001 0xffff flowid 1:2

tc filter add dev ens3 parent 1: \
    protocol ipv6 u32 match ip6 protocol 6 0xff \
    match ip6 dport 5001 0xffff flowid 1:3
```

## socat

- [韦一笑](https://www.zhihu.com/people/tzxiao)

```bash
# 测试两台机器的tcp连接
socat - TCP-LISTEN:8080    # server listen
socat - TCP:localhost:8080 # client connect

# 允许多条连接
socat - TCP-LISTEN:8080,fork,reuseaddr

# 连接后执行命令
socat TCP-LISTEN:8081,fork,reuseaddr  EXEC:/usr/bin/ls
socat TCP-LISTEN:8080,fork,reuseaddr  EXEC:/usr/bin/bash

# 远程登陆
socat TCP-LISTEN:8080,fork,reuseaddr  EXEC:/usr/bin/bash,pty,stderr # server
socat file:`tty`,raw,echo=0 TCP:localhost:8080 # client

# 8080端口转发到80
socat TCP-LISTEN:8080,fork,reuseaddr  TCP:127.0.0.1:80

# sock代理,将1234流量,通过127.0.0.1:10808,连接到google.com:80
socat TCP-LISTEN:1234,fork SOCKS4A:127.0.0.1:google.com:80,socksport=10808
# http代理
socat TCP-LISTEN:1234,fork PROXY:127.0.0.1:google.com:80,socksport=10808

# 文件下载
socat /etc/fstab TCP4-LISTEN:8080,reuseaddr
# fork允许多条连接
socat /etc/fstab TCP4-LISTEN:8080,fork,reuseaddr

# 服务端接收文件
socat -u TCP-LISTEN:8080 open:FILE_NAME,create
# 客户端发送文件
socat -u open:FILE_NAME TCP:localhost:8080

# 测试两台机器的udp连接
socat - UDP-LISTEN:8080
socat - UDP:localhost:8080
socat - UDP-LISTEN:8080,fork,reuseaddr
```

- socket 抓包

```sh
# 抓mysql
sudo mv /run/mysqld/mysqld.sock /run/mysqld/mysqld.sock.original
sudo socat -t100 -x -v UNIX-LISTEN:/run/mysqld/mysqld.sock,mode=777,reuseaddr,fork UNIX-CONNECT:mysqld.sock.original
```

## ngrep

```bash
# icmp(ping)包
ngrep -q '.' 'icmp'

# 包含百度的
ngrep -q '.' 'host www.baidu.com'

# http1.0 or 1.1
ngrep -q 'HTTP/1.[01]'

# http1.0 or 1.1的get请求
ngrep -q '^GET .* HTTP/1.[01]'

# 22端口
ngrep port 22

# 在80端口,任何包含"error"信息
ngrep -d any 'error' port 80

# -W byline 文本友好显示
ngrep -W byline port 80

# -t 显示时间
ngrep -t -W byline port 80
```

## whois(查看域名注册信息)

## curl

- [curl book](https://everything.curl.dev/)

### 基本命令

注意 url 目录后要有`/`

```bash
# 错误
curl http://tzlog.com:8081/zrlog

# 正确
curl http://tzlog.com:8081/zrlog/
```

```bash
# 包含响应头部
curl -i www.baidu.com

# 只显示响应头部
curl -I www.baidu.com

# 查看请求过程
curl -v www.baidu.com

# 显示2进制报文
curl --trace - www.baidu.com

# 发送用户名:tz 密码:12345
curl -u 'tz:12345' 127.0.0.1:80

# 指定 HTTP 请求的代理。如果没有指定代理协议，默认为 HTTP。
curl -x socks5://james:cats@myproxy.com:8080 https://www.example.com

# 下载回应文件(类似于wget)
curl -O https://st.suckless.org/patches/font2/st-font2-20190416-ba72400.diff

# 查看 TTFB(首字节延迟)
curl -o /dev/null \
     -H 'Cache-Control: no-cache' \
     -s \
     -w "Connect: %{time_connect} TTFB: %{time_starttransfer} Total time: %{time_total} \n" \
     https://www.baidu.com

# 查看 包含tls的请求过程,和是否支持http2
curl -vso /dev/null --http2 https://www.bilibili.com

# 范围请求206
curl http://www.example.com -i -H "Range: bytes=0-50, 100-150"
curl http://i.imgur.com/z4d4kWk.jpg -i -H "Range: bytes=0-1023"
```

- [可以curl的在线服务](https://github.com/chubin/awesome-console-services)

```py
# 查看ip
curl l2.io/ip

# 查看定位
curl ip-api.com

# 查看新冠疫情
curl https://corona-stats.online
```

#### POST PATCH DELETE

- `POST`

```sh
curl -d "param1=value1&param2=value2" -X POST http://localhost:3000/data

# restful 测试
curl -d "userId=100&title=post test" -X POST 'https://jsonplaceholder.typicode.com/todos'

# post 当前目录下的json文件
curl -d "@./file.json" -X POST 'https://jsonplaceholder.typicode.com/todos'
```

- `PATCH`

```sh
curl -d "title=patch test" -X PATCH 'https://jsonplaceholder.typicode.com/todos/123'
```

- `DELETE`

```sh
curl -X DELETE 'https://jsonplaceholder.typicode.com/todos/321'
```

### webhook
[企业微信群机器人配置说明](https://work.weixin.qq.com/api/doc/90000/90136/91770)

```sh
curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=693axxx6-7aoc-4bc4-97a0-0ec2sifa5aaa' \
   -H 'Content-Type: application/json' \
   -d '
   {
        "msgtype": "text",
        "text": {
            "content": "此消息由达哥发送"
        }
   }'

# markdown格式
curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=841b95e2-12d6-4bff-af35-4a67c3c8ca59' \
   -H 'Content-Type: application/json' \
   -d '
{
    "msgtype": "markdown",
    "markdown": {
        "content": "# 标题1
        ## 标题2
        > 引用

        - 圆点
        **粗体**, `代码段（暂不支持跨行）`,
        [连接](https://work.weixin.qq.com/api/doc/90000/90136/91770)"
    }
}'
```

## httpie

```sh
# 获取头部
http --header www.baidu.com
```

## [testssl(测试网站是否支持ssl/tls，以及检测漏洞)](https://github.com/drwetter/testssl.sh)

```bash
testssl --parallel https://www.tsinghua.edu.cn/
```

## nghttp

> 测试网站是否支持 http2

在线测试网站:

- [ssltest](https://www.ssllabs.com/ssltest/)

```bash
nghttp -nva https://www.bilibili.com

# -t timeout
nghttp -nva -t 1 https://www.bilibili.com
```

## [h2spec](https://github.com/summerwind/h2spec)

测试服务器 http2 一致性

```bash
h2spec -t -S -h www.bilibili.com -p 443
```

## [wrk: http benchmark](https://github.com/wg/wrk)

| 参数 | 操作     |
|------|----------|
| -t   | 线程数   |
| -c   | 连接数   |
| -d   | 压测时间 |

```sh
wrk -t 6 -c 30000 -d 60s https://127.0.0.1:80
```

## [wrk2: wrp的变种](https://github.com/giltene/wrk2)

## [dnspeep](https://github.com/jvns/dnspeep)

> 记录程序的dns请求,响应

## [lighthouse(chrome 网页性能测试)](https://github.com/GoogleChrome/lighthouse)

## [mitmproxy(代理http, 并抓包)](https://docs.mitmproxy.org/stable/overview-getting-started/)

```sh
# 启动mitmproxy(默认为8080端口)
mitmproxy
# 以socks5代理, 启动mitmproxy(默认为8080端口)
mitmproxy --mode socks5

# 使用8080代理访问百度
curl --proxy http://127.0.0.1:8080 www.baidu.com
# socks5
curl --proxy socks5://127.0.0.1:8080 www.baidu.com

# ~/.mitmproxy目录下有虚拟的CA证书
curl --proxy http://127.0.0.1:8080 --cacert ~/.mitmproxy/mitmproxy-ca-cert.pem www.baidu.com
```

## [websocat:创建websocat](https://github.com/vi/websocat)

```sh
# 连接ws服务器，
websocat ws://ws.vi-server.org/mirror

# 创建客户端-服务器通信服务
websocat -s 1234
# 连接刚才创建的服务，输入字符服务器可以收到
websocat ws://127.0.0.1:1234

# 创建客户端-客户端通信服务
websocat -t ws-l:127.0.0.1:1234 broadcast:mirror:
# 客户端A、B连接服务后，可以互相通信
websocat ws://127.0.0.1:1234

# 代理
websocat --oneshot -b ws-l:127.0.0.1:1234 tcp:127.0.0.1:22&
websocat --oneshot -b tcp-l:127.0.0.1:1236 ws://127.0.0.1:1234/&
```

## [websocketd:创建websocket服务执行命令](https://github.com/joewalnes/websocketd)

```sh
# 创建websocket服务，客户端连接就执行ls命令
websocketd --port=1234 ls

# 使用websocat连接
websocat ws://127.0.0.1:1234
```

## [nali(ip地址离线数据库)](https://github.com/zu1k/nali)

```sh
# 查询ip
nali 8.8.8.8
nali 8.8.8.8 114.114.114.114

# 更新数据库
nali update
```

# reference

- [linux china](https://linux.cn/article-9358-1.html)
- [LinuxCast.net 每日播客](https://study.163.com/course/courseMain.htm?courseId=221001)
- [在命令行中使用 nmcli 来管理网络连接 | Linux 中国](https://mp.weixin.qq.com/s?__biz=MjM5NjQ4MjYwMQ==&mid=2664623350&idx=3&sn=0e4f7ff89170be816daf7b94c0c777d0&chksm=bdced7b08ab95ea6085718176a1325dfb7c09a1ad9abe33c58d35b2bd2ec0f5a5043ca125f8a&mpshare=1&scene=1&srcid=1012v37rkYRVe9EamFSHzoqv&sharer_sharetime=1602496258631&sharer_shareid=5dbb730cd6722d0343328086d9ad7dce#rd)
- [如何使用 tcpdump 来捕获 TCP SYN，ACK 和 FIN 包](https://linux.cn/article-3967-1.html)
- [给 Linux 系统/网络管理员的 nmap 的 29 个实用例子](https://linux.cn/article-2561-3.html?pr)
- [curl 的用法指南](http://www.ruanyifeng.com/blog/2019/09/curl-reference.html)

- [nping](https://netbeez.net/blog/how-to-use-nping/)

# 优秀文章

- [unix domain sockets vs. internet sockets](https://lists.freebsd.org/pipermail/freebsd-performance/2005-February/001143.html)

    > unix socket is better

# 在线工具

- [可以画网络拓扑图](https://www.cloudcraft.co/)

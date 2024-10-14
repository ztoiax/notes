
<!-- mtoc-start -->

* [OSI 7层](#osi-7层)
  * [综合工具](#综合工具)
    * [nmcli](#nmcli)
      * [交互模式](#交互模式)
    * [netstat](#netstat)
    * [ss (iproute2)](#ss-iproute2)
    * [nc（连接服务器）](#nc连接服务器)
    * [frp: 反向代理(内网穿透)](#frp-反向代理内网穿透)
      * [端口](#端口)
      * [sock](#sock)
      * [文件服务器](#文件服务器)
      * [http转https](#http转https)
      * [tls](#tls)
    * [mtr](#mtr)
    * [ngrep（抓包）](#ngrep抓包)
    * [mitmproxy(代理http, 并抓包)](#mitmproxy代理http-并抓包)
    * [socat](#socat)
    * [tc(traffic control队列控制)](#tctraffic-control队列控制)
    * [tailscale：WireGuard vpn](#tailscalewireguard-vpn)
  * [应用层](#应用层)
    * [http](#http)
      * [curl](#curl)
        * [其他协议](#其他协议)
        * [发送/上传数据 POST PATCH DELETE](#发送上传数据-post-patch-delete)
        * [.curlrc配置文件](#curlrc配置文件)
        * [格式化输出和变量](#格式化输出和变量)
      * [trurl：curl作者的新作品](#trurlcurl作者的新作品)
      * [posting：tui版的postman](#postingtui版的postman)
      * [webhook（微信机器人）](#webhook微信机器人)
      * [httpie](#httpie)
        * [nghttp（测试是否支持 http2）](#nghttp测试是否支持-http2)
      * [h2spec：测试服务器 http2 一致性](#h2spec测试服务器-http2-一致性)
      * [grpcurl：类似 cURL 但用于 gRPC 的工具](#grpcurl类似-curl-但用于-grpc-的工具)
    * [websocket](#websocket)
      * [wscat](#wscat)
      * [websocat:创建websocat](#websocat创建websocat)
      * [websocketd:创建websocket服务执行命令](#websocketd创建websocket服务执行命令)
    * [dns](#dns)
      * [whois(查看域名注册信息)](#whois查看域名注册信息)
      * [dnspeep：记录程序的dns请求,响应](#dnspeep记录程序的dns请求响应)
      * [dns-detector（从 DNS 服务器获取某个网站的所有 IP 地址，逐一进行延迟测试）](#dns-detector从-dns-服务器获取某个网站的所有-ip-地址逐一进行延迟测试)
    * [socks](#socks)
      * [tun2socks：将tcp/udp等流量转换为socks](#tun2socks将tcpudp等流量转换为socks)
  * [表示层](#表示层)
    * [testssl(测试网站是否支持ssl/tls，以及检测漏洞)](#testssl测试网站是否支持ssltls以及检测漏洞)
  * [传输层](#传输层)
    * [tcpdump：抓包](#tcpdump抓包)
      * [基本命令](#基本命令)
      * [捕抓 TCP SYN，ACK 和 FIN 包](#捕抓-tcp-synack-和-fin-包)
    * [tshark、editcap、capinfos：抓包](#tsharkeditcapcapinfos抓包)
    * [ptcpdump：抓包](#ptcpdump抓包)
    * [nmap](#nmap)
    * [zmap](#zmap)
    * [RustScan：端口扫描](#rustscan端口扫描)
    * [vmessping：可以ping vmess://的地址](#vmessping可以ping-vmess的地址)
    * [nping(代替 ping)](#nping代替-ping)
    * [hping](#hping)
    * [ngrok：内网穿透（端口转发）](#ngrok内网穿透端口转发)
    * [portr：python写的ngrok代替品](#portrpython写的ngrok代替品)
  * [网络层](#网络层)
    * [ifconfig(net-tools)](#ifconfignet-tools)
    * [ip(iproute2)](#ipiproute2)
    * [ipcalc(ip二进制显示)](#ipcalcip二进制显示)
    * [nali(ip地址离线数据库)](#naliip地址离线数据库)
    * [traceroute](#traceroute)
    * [tcptraceroute](#tcptraceroute)
    * [防火墙](#防火墙)
      * [iptables](#iptables)
        * [基本命令](#基本命令-1)
        * [过滤命令](#过滤命令)
        * [通过iptables实现nat功能](#通过iptables实现nat功能)
      * [nftables](#nftables)
        * [iptables 转换成 nftables](#iptables-转换成-nftables)
      * [firewalld](#firewalld)
        * [基本命令](#基本命令-2)
        * [复杂规则](#复杂规则)
    * [ethtool](#ethtool)
    * [arp](#arp)
    * [arpwatch](#arpwatch)
* [性能监控](#性能监控)
  * [观察工具](#观察工具)
    * [查看吞吐率，PPS（Packet Per Second 包 / 秒）](#查看吞吐率ppspacket-per-second-包--秒)
    * [wondershaper：Linux 限制网络带宽的工具](#wondershaperlinux-限制网络带宽的工具)
  * [压力测试](#压力测试)
    * [wrk](#wrk)
    * [wrk2: wrp的变种](#wrk2-wrp的变种)
    * [lighthouse(chrome 网页性能测试)](#lighthousechrome-网页性能测试)
* [优秀文章](#优秀文章)
* [在线工具](#在线工具)

<!-- mtoc-end -->

# OSI 7层

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

## 综合工具

### nmcli

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

#### 交互模式

```bash
# 进入交互模式
nmcli connection edit eth0

# 修改ip
goto ipv4
set ipv4.address 192.168.100.2/24
save
```

### netstat

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

```sh
# 统计 tcp 数量
netstat -t | wc -l

# 显示 LISTEM 状态 tcp
netstat -lt

# 不解析地址(提高速度)
netstat -lnt

# 显示所有 LISTEM 状态 tcp,udp 进程。 进程显示 `-` 表示该连接为内核处理
netstat -tunlp

# 显示所有 tcp,udp 进程
netstat -tunap
#or
netstat -ap | grep -v unix

# 统计本地 tcp 链接数量
netstat -tn | awk '{print $4}' | awk -F ":" '{print $1}' | sort | uniq -c

# 查看本地unix socket的连接
netstat -a -p --unix
```

- 查看统计信息

    ```sh
    # 比ss -s输出的信息更丰富
    netstat -s
    ```

    | ss -s没有的统计信息         |       内容             |
    |-----------------------------|--------------------|
    | active connections openings | TCP 协议的主动连接 |
    | passive connection openings | 被动连接           |
    | failed connection attempts  | 失败重试           |
    | segments send out           | 发送分段的数量     |
    | segments received           | 接收分段的数量     |

### ss (iproute2)

> 基本等同于 `netstat` 工作在 `socket` 层,没有 `-n` 选项,因此不能显示域名

| 参数 | 操作                      |
|------|-----------------------|
| -l   | listening状态的socket |
| -t   | 只显示tcp socket      |

- 接收队列（Recv-Q）和发送队列（Send-Q），在不同的 socket 状态有所不同

    - 在LISTEN状态下的Recv-Q：当前全连接队列的大小，也就是当前已完成三次握手并等待server端 accept() 的 TCP 连接

    - 在LISTEN状态下的Send-Q：当前全连接最大队列长度：`net.core.somaxconn`的值或`nginx backlog`的值（nginx backlog默认为511）

    - 在Established状态下的Recv-Q：已收到但未被应用进程读取的字节数

    - 在Established状态下的Send-Q：已发送但未收到确认的字节数

```bash
# 显示所有 LISTEM 状态 tcp,udp 进程
ss -tulp

# 显示所有 tcp,udp 进程
ss -tuap

# 查看ESTABLISHED状态的连接
ss -tuap state ESTABLISHED

# 查看目标ip的cwnd、rtt、rto等网络参数
ss -itmpn dst 104.18.3.111

# 查看统计信息。比netstat -s要少
ss -s
```

### nc（连接服务器）

- 连接服务器
```sh
nc 0.0.0.0 38359
```

- 文件传输
```sh
# 接受文件
nc -l -p 1234 > received_file

# 发送文件:端口为1234
nc 127.0.0.1 1234 < file_to_send
```

### [frp: 反向代理(内网穿透)](https://github.com/fatedier/frp/blob/dev/README_zh.md)


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

#### 端口

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

#### sock

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

#### 文件服务器

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

#### http转https

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

#### tls

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

### mtr

```sh
# 查看连接baidu的丢包率，默认用icmp包
mtr --report www.baidu.com

# 使用udp包
mtr -u -r www.baidu.com
```

### ngrep（抓包）

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

### [mitmproxy(代理http, 并抓包)](https://docs.mitmproxy.org/stable/overview-getting-started/)

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

### socat

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


### tc(traffic control队列控制)

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

### [tailscale：WireGuard vpn](https://github.com/tailscale/tailscale)

```sh
# 发送文件
sudo tailscale file cp filename ip:

# 设置接受文件的目录
sudo tailscale file get .
```

## 应用层

### http

#### curl

- [各种curl命令](https://www.httpbin.org/)

- [curl book](https://everything.curl.dev/)

- [奇妙的Linux世界：10 个你不知道的高级 cURL 实用技巧](https://mp.weixin.qq.com/s/mvHlLi3KabNIyvsyROZ2aw)

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

- 测试与故障排除
    ```sh
    # 使用指定网络接口
    curl --interface wlan0 https://example.com

    # 使用指定dns
    curl --dns-ipv4-addr 1.1.1.1 https://example.com
    ```

- 可以测试超时并捕获退出代码（退出代码）：

    ```sh
    curl --connect-timeout 30 --silent --output /dev/null \
      --show-error -w '总时间: %{time_total}s\n' http://baidu.com/ || EXIT_CODE=$?

    if [ $EXIT_CODE = 28 ]
    then
      echo "无法连接（超时）。"
    else
      echo "可以连接。"
    fi
    ```

- 正则表达式

    ```sh
    # 用一个 curl 命令发出多个请求

    # 对 .../users/1、.../users/2 和 .../users/3 的请求
    curl -s "https://jsonplaceholder.typicode.com/users/[1-3]" | jq -s .

    # 使用步长选项，产生 2、4、6、8 和 10 的请求
    curl -s "https://jsonplaceholder.typicode.com/users/[0-10:2]" | jq -s .

    # 使用了特定数字的列表而不是范围，这也适用于字符和单词
    curl -s "https://jsonplaceholder.typicode.com/photos/{1,6,35}" | jq -s .

    # 文件名中的 #1 变量指的是范围 [1-3]。这将生成 file_1.json、file_2.json 和 file_3.json
    curl -s "https://jsonplaceholder.typicode.com/users/[1-3]" -o "file_#1.json"
    ```

- `--parallel` 并行请求

    > curl 将打开最多 50 个并行连接

    ```sh
    curl -I --parallel --parallel-immediate --parallel-max 3 www.baidu.com www.bilibili.com www.example.com
    ```

    - `websites.txt`文件
        ```
        url = "www.baidu.com"
        url = "www.bilibili.com"
        url = "www.example.com"
        ```

        ```sh
        curl -I --parallel --parallel-immediate --parallel-max 3 --config websites.txt
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

##### 其他协议

- 通常我们只会使用 HTTP 或 HTTPS，但 curl 支持 很多协议。

- 如果你在一台没有安装也不能安装 telnet 的服务器/机器上怎么办？只需使用 curl
    ```sh
    # 同 telnet example.com 1234
    curl telnet://example.com:1234
    ```

- 电子邮件的 IMAP、POP3 和 SMTP，这意味着你可以使用 curl 阅读和发送电子邮件。

    ```sh
    # 阅读
    curl --url "imaps://imap.gmail.com:993/Inbox;UID=1" --user "[email protected]:PASSWORD"

    # 发送。这里的 message.txt 是实际的电子邮件，需要遵循[特定格式](https://everything.curl.dev/usingcurl/smtp.html)
    curl smtp://mail.example.com \
      --mail-from [email protected] \
      --mail-rcpt [email protected] \
      --upload-file message.txt \
      -u "[email protected]:PASSWORD"
    ```

##### 发送/上传数据 POST PATCH DELETE

- `POST`

```sh
curl -d "param1=value1&param2=value2" -X POST http://localhost:3000/data

# restful 测试
curl -d "userId=100&title=post test" -X POST 'https://jsonplaceholder.typicode.com/todos'

# post 当前目录下的json文件
curl -d "@./file.json" -X POST 'https://jsonplaceholder.typicode.com/todos'

# 发送json数据，但这样发送 JSON，需要在单引号和双引号之间切换
curl -X POST "https://httpbin.org/post" -H "accept: application/json" --json '{"key": "value"}'

# 更好的发送json数据的方法
jo -p key=value | curl -X POST "https://httpbin.org/post" -H "accept: application/json" --json @-
```

- `PATCH`

```sh
curl -d "title=patch test" -X PATCH 'https://jsonplaceholder.typicode.com/todos/123'
```

- `DELETE`

```sh
curl -X DELETE 'https://jsonplaceholder.typicode.com/todos/321'
```

##### .curlrc配置文件

- `~/.curlrc`

    ```
    # ~/.curlrc

    # 一些头信息
    -H "Upgrade-Insecure-Requests: 1"
    -H "Accept-Language: en-US,en;q=0.8"

    # 跟随重定向
    --location
    ```

    ```sh
    curl -K .curlrc https://www.baidu.com
    ```

- `.netrc`

    ```
    # ~/.netrc
    machine https://authenticationtest.com/HTTPAuth/
    login user
    password pass
    ```

    ```sh
    curl --netrc-file .netrc https://authenticationtest.com/HTTPAuth/
    ```

##### 格式化输出和变量

- curl 可以输出很多东西，有时会让人不知所措、冗长且不必要。幸运的是，我们可以使用输出格式化只打印我们感兴趣的内容：

- `-w` 选项并传递一个格式文件来实现这一点

    - 每个变量都用 `%{...}` 包围。它们可以是简单变量，如 `response_code`，也可以是 `url.<NAME>` 的一部分，指的是 URL 组件，如主机或端口。

    ```
    # format.txt
    类型: %{content_type}\n代码: %{response_code}\n\n

    从 8.1.0:\n\n

    协议: %{url.scheme}\n
    主机: %{url.host}\n
    端口: %{url.port}\n

    读取头信息内容 (v7.83.0):\n
    %header{date}
    ```

    ```sh
    curl --silent --output /dev/null --show-error -w @format.txt http://example.com/

    # format.txt类型: text/html; charset=UTF-8
    代码: 200

    从 8.1.0:

    协议: http
    主机: example.com
    端口: 80
    读取头信息内容 (v7.83.0):
    Wed, 07 Aug 2024 01:14:58 GMT%
    ```

- 格式化的一个很好的用途是测量请求/响应时间，可以用以下格式来实现：

    ```
    # format.txt
         域名解析时间:  %{time_namelookup}s\n
            连接时间:  %{time_connect}s\n
         应用连接时间:  %{time_appconnect}s\n
           预传输时间:  %{time_pretransfer}s\n
           重定向时间:  %{time_redirect}s\n
          开始传输时间: %{time_starttransfer}s\n
                    ----------\n
              总时间:  %{time_total}s\n

    # 输出:
         域名解析时间:  0.000765s
            连接时间:  0.111908s
         应用连接时间:  0.000000s
           预传输时间:  0.111967s
           重定向时间:  0.000000s
         开始传输时间:  0.223373s
                    ----------
              总时间:  0.223992s
    ```

#### [trurl：curl作者的新作品](https://github.com/curl/trurl)

- trurl 是一个用于解析 URL 的专用工具

```sh
# 提取 URL 组件，这里是路径，但也可以是如 url、scheme、user、password、options 或 host 等。
trurl --url https://example.com/some/path/to/file.html --get '{path}'
/some/path/to/file.html

# 使用 append 功能，向 URL 添加查询参数
trurl --url "https://example.com/?name=hello" --append query=key=value
https://example.com/?name=hello&key=value

# 解析为 JSON：
trurl --url "https://example.com/?name=hello" --json
[
  {
    "url": "https://example.com/?name=hello",
    "parts": {
      "scheme": "https",
      "host": "example.com",
      "path": "/",
      "query": "name=hello"
    },
    "params": [
      {
        "key": "name",
        "value": "hello"
      }
    ]
  }
]
```

#### [posting：tui版的postman](https://github.com/darrenburns/posting)

![image](./Pictures/net-tools/posting.avif)

#### webhook（微信机器人）

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

#### httpie

```sh
# 获取头部
http --header www.baidu.com
```

##### nghttp（测试是否支持 http2）

在线测试网站:

- [ssltest](https://www.ssllabs.com/ssltest/)

```bash
nghttp -nva https://www.bilibili.com

# -t timeout
nghttp -nva -t 1 https://www.bilibili.com
```

#### [h2spec：测试服务器 http2 一致性](https://github.com/summerwind/h2spec)

```bash
h2spec -t -S -h www.bilibili.com -p 443
```

#### [grpcurl：类似 cURL 但用于 gRPC 的工具](https://github.com/fullstorydev/grpcurl)

```sh
grpcurl grpc.server.com:443 my.custom.server.Service/Method
```

### websocket

#### [wscat](https://github.com/websockets/wscat)

```sh
wscat --connect ws://127.0.0.1
```

#### [websocat:创建websocat](https://github.com/vi/websocat)

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

#### [websocketd:创建websocket服务执行命令](https://github.com/joewalnes/websocketd)

```sh
# 创建websocket服务，客户端连接就执行ls命令
websocketd --port=1234 ls

# 使用websocat连接
websocat ws://127.0.0.1:1234
```

### dns

```sh
# 查看本地dns
cat /etc/resolv.conf

# 如果使用NetworkManager
nmcli dev show | grep 'IP4.DNS'

# nslookup中的Server
nslookup www.baidu.com

# dig命令中的SERVER
dig
```

#### whois(查看域名注册信息)

#### [dnspeep：记录程序的dns请求,响应](https://github.com/jvns/dnspeep)


#### [dns-detector（从 DNS 服务器获取某个网站的所有 IP 地址，逐一进行延迟测试）](https://github.com/sun0day/dns-detector)

### socks

#### [tun2socks：将tcp/udp等流量转换为socks](https://github.com/xjasonlyu/tun2socks)

## 表示层

### [testssl(测试网站是否支持ssl/tls，以及检测漏洞)](https://github.com/drwetter/testssl.sh)

```bash
testssl --parallel https://www.tsinghua.edu.cn/
```

## 传输层

### tcpdump：抓包

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

#### 基本命令

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

#### 捕抓 TCP SYN，ACK 和 FIN 包

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

### tshark、editcap、capinfos：抓包

- [一文读懂网络报文分析神器Tshark： 100+张图、100+个示例轻松掌握原创](https://cloud.tencent.com/developer/article/2312883)

- capinfos：查看被抓包的文件信息
```sh
# 可以看到包的数量、平均包大小、抓包的时间段
capinfos test.pcapng

# 获取文件中数据包的个数
total=$(capinfos -c -M src.pcap | awk 'NR==2 {print $NF}')
```

- editcap将pcap文件切割成多个小文件
```sh
# 过滤出特定时间段的数据包
editcap -A "2024-04-06 11:58:00" -B "2024-04-06 11:58:10" src.pcap -F pcap dst.pcap
# 查看时间段进行确认
capinfos dst.pcap

# 把抓包切小，每个文件20万个包，保证wireshark打开不太慢
editcap -c 200000 src.pcap dst.pcap
```

- tshark：wireshark命令行版
```sh
# 读取test.pcapng文件
tshark -r test.pcapng
# -n禁止域名解析
tshark -n -r test.pcapng
# -V显示完整报文
tshark -n -r test.pcapng -V -Y 'tcp.flags.syn==1&&tcp.flags.ack==0&&frame.number<=5'
# -w保存报文
tshark -n -r test.pcapng -V -Y 'tcp.flags.syn==1&&tcp.flags.ack==0&&frame.number<=5' -w test1.pcapng

# 通过正则来拿到我们想要的直播流URL：
tshark -n -r test.pcapng -Y 'http.request.method eq GET' -V | grep -Po '(?<=Full request URI:\s).*m3u8(?=])' |& sort -u

# 输出成json格式
tshark -r test.pcapng -T json
# 输出成ek格式。Elasticsearch bulk，代表批量写入Elasticsearch的格式。
tshark -r test.pcapng -T ek

# -e输出报文指定字段
tshark -n -r test.pcapng -e 'frame.number' -e 'ip.addr' -e 'tcp.port' -e tcp -T json

# -Y过滤报文
# 只保留http host为某个值的包
tshark -n -r test.pcapng -Y 'http.host == "web-server1"'
# 只保留TCP重传、快速重传、DUP ACK的包
tshark -n -r test.pcapng -Y 'tcp.stream eq 2 && ( tcp.analysis.retransmission or tcp.analysis.fast_retransmission or tcp.analysis.duplicate_ack )' -t d

# 只保留第一次握手的请求
tshark -n -r test.pcapng -Y 'tcp.flags.syn==1&&tcp.flags.ack==0'

# 统计重传数据包的个数
tshark -n -r test.pcapng -Y "tcp.analysis.retransmission" -T fields -e tcp.stream | wc -l

# 统计分析报文（-z）
# 查看支持的统计分析选项。
tshark -z help

# 会话统计需要用到'conv,'作为前缀，表示的是conversation。
tshark -n -r test.pcapng -z 'conv,ip'
# -q参数来让它只输出统计结果，不显示报文
tshark -q -n -r test.pcapng -z 'conv,ip'
# ipv6
tshark -q -n -r test.pcapng -z 'conv,ipv6'

# conv,ip 统计IP层，那么conv,tcp则统计tcp头部
tshark -n -q -r test.pcapng -z conv,tcp
# 也支持过滤选项：
tshark -n -q -r test.pcapng -z conv,tcp,tcp.port==443
# 只统计第一条流的结果
tshark -n -q -r test.pcapng -z conv,ip,tcp.stream==0
# 只想要第三个的流的统计数据
tshark -n -q -r test.pcapng -z conv,ip,tcp.stream==2
tshark -n -q -r test.pcapng -z conv,tcp,'tcp.stream eq 2'

# 统计udp
tshark -n -q -r test.pcapng -z conv,udp
# 过滤规则如果有多条或者空格，可以通过单引号引起来：
tshark -n -q -r test.pcapng -z conv,udp,'udp.port in {8000,8803}'

# 统计分析DNS层次结构
tshark -n -q -r test.pcapng -z dns,tree
# 过滤选项
tshark -n -q -r test.pcapng -z dns,tree,dns.'qry.name == baidu.com'

# 统计分析UDP端点数据
tshark -n -q -r test.pcapng -z endpoints,udp
================================================================================
UDP Endpoints
Filter:<No Filter>
                       |  Port  ||  Packets  | |  Bytes  | | Tx Packets | | Tx Bytes | | Rx Packets | | Rx Bytes |
101.226.4.6                  53        112         13905         56            9425          56            4480
192.168.1.222             22000          9           666          9             666           0               0
198.211.120.59             3478          9           666          0               0           9             666

# 指定过滤规则，只过滤涉及到DNS的数据：
tshark -n -q -r test.pcapng -z endpoints,udp,dns

# 对应wireshark的专家信息功能
tshark -n -q -r test.pcapng -z expert
# 只分析第3个流
tshark -n -q -r test.pcapng -z expert,'tcp.stream==2'

# 对应wireshark的Flow Graph功能，即流量图显示功能，可以把整个通信过程画出一个通信图出来，在wireshark上的显示如下：
tshark -q -n -r test.pcapng -z flow,tcp,network
tshark -q -2 -n -r test.pcapng -z flow,icmp,network
tshark -q -2 -n -r test.pcapng -z flow,icmp,network,icmp.seq==3

# 以“十六进制”格式显示第一个TCP流的内容
tshark -q -n -r test.pcapng -z "follow,tcp,hex,0"
# 在第一个TCP连接中显示第一个HTTP的内容
tshark -q -n -r test.pcapng -z "follow,http,hex,0,1"
# 第一个HTTP为GET，那么第二个HTTP为response：
tshark -q -n -r test.pcapng -z "follow,http,hex,0,2"

# 统计分析HTTP的状态码以及请求方法
tshark -q -n -r test.pcapng -z http,stat
# 统计分析HTTP树状结构
tshark -q -n -r test.pcapng -z http,tree
# http2协议
tshark -q -n -r test.pcapng -z http2,tree
# 只会统计请求涉及到的URI资源路径，不关注响应
tshark -q -n -r test.pcapng -z http_req,tree
# 只过滤第一条TCP连接的数据：
tshark -q -n -r test.pcapng -z http_req,tree,'tcp.stream==0'
# 和http_req,tree的区别是，它会自动补齐请求的服务器，以URL路径方式呈现出来
tshark -q -n -r test.pcapng -z http_seq,tree
# 对于HTTP request，显示的值是目的端服务器IP地址和服务器主机名。对于HTTP response，显示的值是目的端服务器IP地址及状态：
tshark -q -n -r test.pcapng -z http_srv,tree

# 统计ICMP回显请求总数、回复、丢失和丢失百分比，以及ping返回的最小、最大、平均、中值和样本标准差SRT统计信息。
tshark -q -n -r test.pcapng -z icmp,srt
# 过滤某个ip
tshark -q -n -r test.pcapng -z icmp,srt,'ip.addr==xxx'
# icmpv6
tshark -q -n -r test.pcapng -z icmpv6,srt

# 统计协议层次结构及包量（io,phs）
tshark -q -n -r test.pcapng -z io,phs
===================================================================
Protocol Hierarchy Statistics
Filter:

eth                                      frames:1782 bytes:1021701
  ip                                     frames:1775 bytes:1020512
    tcp                                  frames:1648 bytes:1004942
      tls                                frames:390 bytes:396690
        tcp.segments                     frames:110 bytes:185541
          tls                            frames:83 bytes:150929
    udp                                  frames:126 bytes:15516
      dns                                frames:112 bytes:13905
      data                               frames:2 bytes:476
      stun                               frames:9 bytes:666
      mdns                               frames:3 bytes:469
    igmp                                 frames:1 bytes:54
  ipv6                                   frames:6 bytes:1147
    udp                                  frames:6 bytes:1147
      mdns                               frames:4 bytes:631
      data                               frames:2 bytes:516
  arp                                    frames:1 bytes:42
===================================================================
# 只统计第一条TCP流
tshark -q -n -r test.pcapng -z io,phs,'tcp.stream==0'
# 统计分析包量和字节大小
tshark -q -n -r test.pcapng -z io,stat,0
# 如果想指定间隔为10s统计一次，且只统计第一条TCP流则可以是：
tshark -q -n -r test.pcapng -z io,stat,10,'tcp.stream==0'

# 统计分析某个字段的最大最小平均值等。io,stat,interval,"COUNT|SUM|MIN|MAX|AVG|LOAD(field)filter"
tshark -q -n -r test.pcapng -z io,stat,0,'MAX(icmp.data_time_relative)icmp.data_time_relative,'ip.addr==192.168.1.1''
# 统计第一条TCP连接中，距离它上一个包间隔时间最长的为：
tshark -q -n -r test.pcapng -z io,stat,0,'MAX(tcp.time_delta)tcp.time_delta,tcp.stream==0'
# 统计第一条TCP流中，HTTP响应时间的平均值和最大值，分别为：
tshark -q -n -r test.pcapng -z io,stat,0,'AVG(http.time)http.time,tcp.stream==0'
tshark -q -n -r test.pcapng -z io,stat,0,'MAX(http.time)http.time,tcp.stream==0'
# 只统计返回了200 OK状态码的http最大响应时间
tshark -q -n -r test.pcapng -z io,stat,0,'MAX(http.time)http.time and http.response.code == 200'

# 统计IP地址占比
tshark -q -n -r test.pcapng -z ip_hosts,tree

# 统计源地址和目标地址占比
tshark -q -n -r test.pcapng -z ip_srcdst,tree
```

### [ptcpdump：抓包](https://github.com/mozillazg/ptcpdump)

- [奇妙的Linux世界：ptcpdump: 新一代抓包神器，可捕获任何进程、容器或 Pod 的网络流量](https://mp.weixin.qq.com/s/CbOyeQ42D776XuCOTj4Pow)

- 可捕获任何进程、容器或 Pod 的网络流量

- 基于ebpf

### nmap

- zenmap(gui版nmap)

端口状态:

| STATE      | 内容         |
| ---------- | ------------ |
| open       | 开启         |
| closed     | 关闭         |
| filtered   | 被防火墙屏蔽 |
| unfiltered | 不确定状态   |

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

# 显示本机网络，路由信息
nmap --iflist

# 扫描文件内的 ip 地址
cat > nmapfile << 'EOF'
127.0.0.1
192.168.1.1
192.168.100.208
EOF

nmap -iL nmapfile
```

- 使用 tmp 扫描

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

### [zmap](https://github.com/zmap/zmap)

- 比nmap速度要快 [ZMap 为什么能在一个小时内就扫描整个互联网？](https://www.zhihu.com/question/21505586/answer/18443313)

### [RustScan：端口扫描](https://github.com/RustScan/RustScan)

### [vmessping：可以ping vmess://的地址](https://github.com/v2fly/vmessping)

### nping(代替 ping)

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

### [hping](http://www.hping.org/)

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

### [ngrok：内网穿透（端口转发）](https://github.com/inconshreveable/ngrok)

### [portr：python写的ngrok代替品](https://github.com/amalshaji/portr)

## 网络层

### ifconfig(net-tools)

- 以下这些指标不为 0 时，则说明网络发送或者接收出问题了

    | 字段       | 表示                                                                                                                                                            |
    |------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
    | errors     | 发生错误的数据包数，比如校验错误、帧同步错误等                                                                                                                  |
    | dropped    | 丢弃的数据包数，即数据包已经收到了 Ring Buffer（这个缓冲区是在内核内存中，更具体一点是在网卡驱动程序里），但因为系统内存不足等原因而发生的丢包                  |
    | overruns   | 超限数据包数，即网络接收/发送速度过快，导致 Ring Buffer 中的数据包来不及处理，而导致的丢包，因为过多的数据包挤压在 Ring Buffer，这样 Ring Buffer 很容易就溢出了 |
    | carrier    | 发生 carrirer 错误的数据包数，比如双工模式不匹配、物理电缆出现问题等                                                                                            |
    | collisions | 冲突、碰撞数据包数                                                                                                                                              |

### ip(iproute2)

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

### ipcalc(ip二进制显示)

- [教程](https://www.linux.com/topic/networking/how-calculate-network-addresses-ipcalc/)

### [nali(ip地址离线数据库)](https://github.com/zu1k/nali)

```sh
# 查询ip
nali 8.8.8.8
nali 8.8.8.8 114.114.114.114

# 更新数据库
nali update
```

### traceroute

原理是向目的主机发送ICMP报文，发送第一个报文时，设置TTL为0，TTL即Time to Live，是报文的生存时间，由于它是0，所以下一个路由器由到这个报文后，不会再继续转发了，会给源主机发送ICMP出错的报文，就可以知道第一个路由的IP地址，同理，设置TTL为1，就可以知道第二个路由的IP地址，依次类推。

### tcptraceroute

tcptraceroute 命令与 traceroute 基本上是一样的，只是它能够绕过最常见的防火墙的过滤。正如该命令的手册页所述，tcptraceroute 发送 TCP SYN 数据包而不是 UDP 或 ICMP ECHO 数据包，所以其不易被阻塞。

### 防火墙

- `ip_rcv()` 中会处理 netfilter 和 iptable 过滤，如果你有很多或者很复杂的 netfilter 或iptables 规则，这些规则都是在软中断的上下⽂中执⾏的，会加⼤⽹络延迟。

#### iptables

> `iptables` 已经落后了，建议使用 [nftables](https://wiki.nftables.org/wiki-nftables/index.php/Why_nftables%3F_) 一个替换现有{ip,ip6,arp,eb}tables 的框架。[Main differences with iptables](https://wiki.nftables.org/wiki-nftables/index.php/Main_differences_with_iptables)

---

- [技术蛋老师：iptables核心运作原理和数据包过滤方法](https://www.bilibili.com/list/watchlater?bvid=BV1Jz4y1u7Lz)

> [iptables 转换为 nftables 的命令](#nftables)

- iptables 和 netfilter 的关系

`iptables` 只是防火墙的管理工具，真正实现防火墙功能的是 `netfilter`，由内核 hook 构成。每个进入网络系统的包（接收或发送）在经过协议栈时都会触发这些 hook，程序可以通过注册 hook 函数的方式在一些关键路径上处理网络流量。

- iptables 传输数据包的过程

    - ① 当一个数据包进入网卡时，它首先进入 PREROUTING 链，内核根据数据包目的 IP 判断是否需要转送出去。
    - ② 如果数据包就是进入本机的，它就会沿着图向下移动，到达 INPUT 链。数据包到了 INPUT 链后，任何进程都会收到它。本机上运行的程序可以发送数据包，这些数据包会经过 OUTPUT 链，然后到达 POSTROUTING 链输出。
    - ③ 如果数据包是要转发出去的，且内核允许转发，数据包就会如图所示向右移动，经过 FORWARD 链，然后到达 POSTROUTING 链输出。

    - ①->② 
    - ①->③

    ![image](./Pictures/net-tools/iptable.avif)

- netfilter 提供了 5 个 hook 点

    | 链          | 规则                       |
    |-------------|----------------------------|
    | PREROUTING  | 进入协议栈后，路由前的包   |
    | INPUT       | 路由判断是本机的包         |
    | FORWARD     | 路由判断是其他主机的包     |
    | OUTPUT      | 进入协议栈前，本机发送的包 |
    | POSTROUTING | 路由后的本机发送的包       |

- iptables 的表和链：

    - 表的优先顺序：Raw —> mangle —> nat —> filter
    - 链的优先顺序：PREROUTING -> INPUT -> FORWARD -> OUTPUT -> POSTROUTING

    | table（表）            | 内容                                                                  | 链                                              |
    |------------------------|-----------------------------------------------------------------------|-------------------------------------------------|
    | filter (过滤数据包)    | 判断是否允许一个包通过                                                | INPUT、FORWARD、OUTPUT                          |
    | Nat (网络地址转换)     | 是否以及如何修改包的源/目的地址                                       | PREROUTING、POSTROUTING、OUTPUT                 |
    | Mangle (修改ip包的头） | 服务类型、TTL、并且可以配置路由实现 QOS 内核模块)                     | PREROUTING、POSTROUTING、INPUT、OUTPUT、FORWARD |
    | Raw (conntrack 相关)   | iptables 防火墙是有状态，对每个包进行判断的时候是依赖已经判断过的包。 | OUTPUT、PREROUTING                              |
    | security               | 给包打上 SELinux 标记                                                 | INPUT、FORWARD、OUTPUT                          |

    ![image](./Pictures/net-tools/iptable1.avif)

- 参数

    | 参数 | 操作                            |
    | ---- | ------------------------------- |
    | -L   | 查看规则                        |
    | -I   | 在首行添加规则                  |
    | -A   | 在末尾添加规则                  |
    | -D   | 删除规则,可按规则序号和内容删除 |
    | -F   | 删除所有规则                    |
    | -j   | 动作                            |
    | -s   | 源地址                          |
    | -d   | 目标地址                        |
    | -i   | 源接口                          |
    | -o   | 目标接口                        |
    | -p   | 协议                            |

- 规则：

    - 注意：要把允许规则放在前面(-I)，拒绝规则放在后面(-A)

    | -j(动作) | 操作                                                                 |
    | -------- | -------------------------------------------------------------------- |
    | ACCEPT   | 允许数据包通过                                                       |
    | DROP     | 直接丢弃数据包，不给任何回应信息                                     |
    | REJECT   | 拒绝数据包通过，必要时会给数据发送端一个响应的信息。                 |
    | LOG      | 在/var/log/messages 文件中记录日志信息，然后将数据包传递给下一条规则 |

    ![image](./Pictures/net-tools/iptable2.avif)

##### 基本命令

```sh
# 创建 INPUT 链的第2条规则
iptables -I INPUT 2

# 查看 INPUT 链的第2条规则
iptables -L INPUT 2

# 删除 INPUT 链的第2条规则
iptables -D INPUT 2

# 查看规则
iptables -L

# 查看INPUT表的规则
iptables -L INPUT

# 查看详细规则
iptables -nvL --line-numbers

# 最近一次启动后所记录的数据包
journalctl -k | grep "IN=.*OUT=.*" | less
```

- 保存规则：

| 发行版 | 默认保存目录            |
| ------ | ----------------------- |
| centos | /etc/sysconfig/iptables |
| arch   | /etc/iptables           |

```sh
iptables-save > /etc/iptables/iptables.bak
# 只备份filter
iptables-save -t filter > filter.bak

# 重新加载配置文件
iptables-restore < /etc/iptables/iptables.bak
```

- 重置规则：

```sh
iptables -F #刷新chain
iptables -X #删除非默认chain
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X
iptables -t security -F
iptables -t security -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
```

##### 过滤命令

- 注意`ACCEPT`,`DROP`必须要大写

- 注意：要把拒绝规则放在允许规则后面

- 端口过滤：

```sh
# 只允许 tcp 协议,访问 80 端口
iptables -I INPUT -p tcp --dport 80 -j ACCEPT

# 只允许 tcp 以外的协议,访问 80 端口
iptables -I INPUT -p ! tcp --dport 80 -j ACCEPT

# 只允许在 9:00 到 18:00 这段时间的 tcp 协议,访问 80 端口
iptables -I INPUT -p tcp --dport 80 -m time --timestart 9:00 --timestop 18:00 -j ACCEPT

# 只允许 192.168.1.0/24 网段使用 SSH
# 注意要把拒绝规则放在后面
iptables -I INPUT -p tcp --dport 22 -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP

# mysql
iptables -I INPUT -p tcp --dport 3306 -s 127.0.0.1 -j ACCEPT
iptables -I INPUT -p tcp --dport 3306 -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j DROP
```

- ip地址过滤

```sh
# 禁止用户访问 www.baidu.com 的网站。
iptables -A OUTPUT -d www.baidu.com -j DROP

# 禁止 从 192.168.1.0/24 到 10.1.1.0/24 的流量
iptables -I FORWARD -s 192.168.1.0/24 -d 10.1.1.0/24 -j DROP
```

- mac地址过滤

```sh
# 禁止转发来自 MAC 地址为 00：0C：29：27：55：3F 的和主机的数据包
iptables -I FORWARD -m mac --mac-source 00:0c:29:27:55:3F -j DROP
```

##### 通过iptables实现nat功能

- [[译] NAT - 网络地址转换（2016）](http://arthurchiao.art/blog/nat-zh/)

| -j 动作    | 只适用的chain      | 操作                                                                                                                                                                    |
|------------|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| MASQUERADE | POSTROUTING        | 修改源 IP 为动态新 IP（动态获取网络接口 IP）。如果接口 的 IP 地址发送了变化，MASQUERADE 规则不受影响，可以正常工作；而对于 SNAT 就必须重新调整规则。                    |
| SNAT       | POSTROUTING        | 发送方的地址会被静态地修改。与 `MASQUERADE` 的区别在于，SNAT必须显式指定转换后的 IP。 如果路由器配置的是静态 IP 地址，那 SNAT 是最合适的选择，因为它比 MASQUERADE 更 快 |
| DNAT       | PREROUTING、OUTPUT | 修改目的 IP                                                                                                                                                             |
| REDIRECT   | PREROUTING、OUTPUT | 包被重定向到路由器的另一个本地端口                                                                                                                                      |

- NAT假设路由器的本地网络走 eth0 端口，到公网的网络走 eth1 端口。
    ```sh
    # 匹配成功后的动作是 MASQUERADE （伪装）数据包
    iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
    ```

- 基本命令
    ```sh
    # 将目标端口是 80 的流量,跳转到 192.168.1.1
    iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-dest 192.168.1.1

    # 将出口为 80 端口的流量,跳转到 192.168.1.1:8080 端口
    iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-dest 192.168.1.1:8080

    # 伪装 192.168.100.1 为 1.1.1.1
    iptables -t nat -A POSTROUTING -s 192.168.100.1 -j SNAT --to-source 1.1.1.1
    # 通过 nat 隐藏源 ip 地址
    iptables -t nat -A POSTROUTING -j SNAT --to-source 1.2.3.4

    # 从 80 端口进来的流量，重定向到 8080 端口
    iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-ports 8080
    # 将 5000 端口 进来的流量重定向到本机的 22 端口（SSH）
    iptables -t nat -A PREROUTING -p tcp --dport 5000 -j REDIRECT --to-ports 22
    ```

- 通过跳板机111.111.111.111的 5001 端口，连接机器 123.123.123.123 的 110 （POP3）端口
    ```sh
    # 在跳板机111.111.111.111上配置
    iptables -t nat -A PREROUTING -p tcp --dport 5001 \
    -j DNAT --to-destination 123.123.123.123:110
       
    iptables -t nat -A POSTROUTING -p tcp --dport 110 \
    -j MASQUERADE
    ```

    ![image](./Pictures/net-tools/iptable3.avif)

- 通过公网 IP 123.123.123.123 的 80 端口访问 192.168.1.2 的 HTTP 服务
    - NAT 路由器的地址是 192.168.1.1
    - http服务器在192.168.1.2
    - 公网 IP 123.123.123.123
    ```sh
    iptables -t nat -A PREROUTING -p tcp -i eth1 --dport 80 -j DNAT --to 192.168.1.2
    ```

#### nftables

和`iptables`不同，`nftables` 不包含内置表

<span id="nftables"></span>

##### iptables 转换成 nftables

```sh
iptables-save > save.txt
iptables-restore-translate -f save.txt > ruleset.nft
nft -f ruleset.nft
nft list ruleset
```

| **nftables 簇** | **iptables 实用程序**  |
| --------------- | ---------------------- |
| ip              | iptables               |
| ip6             | ip6tables              |
| inet            | iiptables and p6tables |
| arp             | arptables              |
| bridge          | ebtables               |

- 基础命令

```sh
# 列出所有表
nft list ruleset
# 保存规则
nft list ruleset > ruleset.nft
# 读取规则文件
nft -f ruleset.nft

# 永久保存规则
nft list ruleset > /etc/nftables.conf

# 删除fliter表
nft delete table ip fliter

# 删除所有规则
nft flush ruleset
```

- 禁止访问 baidu

```sh
# 创建一个名为filter的表
nft add table ip filter

# 在filter表创建OUTPUT规则
nft 'add chain ip filter OUTPUT { type filter hook output priority 0; policy accept; }'

# 添加规则
nft add rule ip filter OUTPUT ip daddr 182.61.200.7 counter drop
nft add rule ip filter OUTPUT ip daddr 182.61.200.6 counter drop
```

- monitor模式

```sh
# 追踪nft
nft monitor

# 只追踪新规则
nft monitor new rules
```

#### firewalld

- 从centos7开始，默认没有`iptables`。而是使用firewalld动态防火墙工具
- firewalld与iptables的关系：
    - firewalld提供了一个daemon和service，还有命令行和图形界面，仅仅代替iptables service的部分，底层还是`iptables`作为防火墙规则管理入口。
    - firewalld使用python开发，在新版本已经计划用c++重写daemon部分

- 静态防火墙：哪怕只修改一条规则，也需要将所有规则重新加载的模式

    - `iptables`是用户将新规则添加进`/etc/sysconfig/iptables`配置文件中。在执行`service iptables reload`使规则生效。
        - 整个过程需要对旧规则进行清空，然后重新完整加载新规则。如果配置了需要重新加载的内核模块，则还包含相关内核模块的卸载和加载

- 动态防火墙：`firewalld`不需要对整个规则重新加载，只需变更部分的iptables就可以

- firewalld将网卡划分为不同的区域（zone），默认有9个：

    - 不同区域之间的差异是对待数据包的默认行为不同。centos7中默认为public

    - block（限制）：传入的网络连接被拒绝。并带有ipv4的icmp-host-prohibited信息和ipv6的icmp6-adm-prohibited
        - 仅允许由该系统发起的网络连接。
    - dmz（非军事区）：适用于非军事区内可公开访问的计算机，但对内部网络的访问受限。
        - 仅接受某些入站连接。
    - drop（丢弃）：传入的网络连接都被丢弃，并且不发送任何响应。
        - 只允许传出网络连接。
    public（公共）：用于公共区域。
    - external（外部）：为路由器启用了伪装功能的外部网络。
        - 不信任来自网络其他计算机。仅接受某些类型的入站连接。
        - 基本信任来自网络其他计算机。仅接受某些类型的入站连接。
    internal（内部）：用于内部网络。
        - 基本信任来自网络其他计算机。仅接受某些类型的入站连接。
    - home（家庭）：用于家庭网络。
    - work（工作）：用于工作区。
        - 基本信任来自网络其他计算机。仅接受某些类型的入站连接。
        - 不信任来自网络其他计算机。仅接受某些类型的入站连接。
    - trusted（信任）：可接受所有的网络连接

    ```sh
    # 查看支持的所有区域
    firewall-cmd --get-zones

    # 查看默认区域
    firewall-cmd --get-default-zone
    # 设置默认区域为home
    firewall-cmd --set-default-zone=home

    # 查看活动区域和分配给它们的网络接口
    firewall-cmd --get-active-zones
    # 修改网络接口
    firewall-cmd --zone=public --change-interface=enp1s0
    # 添加新的网络接口
    firewall-cmd --zone=public --add-interface=eth0

    # 查看所有区域的所有规则
    firewall-cmd --list-all-zone
    # 查看public区域的所有规则
    firewall-cmd --zone=public --list-all
    ```

##### 基本命令

- 基本使用

    ```sh
    # 查看状态
    systemctl status firewalld
    firewall-cmd --state

    # 重启防火墙。并不中断用户连接，即不丢弃状态信息
    firewall-cmd --reload
    # 重启防火墙。中断用户连接，即丢弃状态信息
    firewall-cmd --complete-reload

    # 将当前防火墙的规则永久保存
    firewall-cmd --runtime-to-permanent

    # 检查配置正确性
    firewall-cmd --check-config
    ```

- 日志

    ```sh
    # 获取记录被拒绝的日志。默认为off
    firewall-cmd --get-log-denied

    # 设置记录被拒绝的日志，只能为 'all','unicast','broadcast','multicast','off' 其中的一个
    firewall-cmd --set-log-denied=all
    ```

- 断网和连网

    ```sh
    # 启用应急模式，阻断所有网络连接。防止出现紧急情况
    firewall-cmd --panic-on

    # 查看应急模式
    firewall-cmd --query-panic

    # 禁用应急模式
    firewall-cmd --panic-off
    ```

- firewalld service（服务）
    - 保存在`/usr/lib/firewalld/services/`目录（请勿修改）；每个文件对应一项具体的网络服务（如ssh服务），文件为`xml`类型
    - 如果默认的service不够用，需要把自定义的配置文件放进`/etc/firewalld/services/`目录（可以修改）
    - 每加载一项service，相当于开放了对应的端口

    ```sh
    # 查看所有支持的sevice
    firewall-cmd --get-services

    # 查看所有支持的icmp类型的sevice
    firewall-cmd --get-icmptypes

    # 查看--permanent的service。表示重启后也生效的service
    firewall-cmd --get-services --permanent
    firewall-cmd --get-icmptypes --permanent

    # 查看当前zone（区域）加载的service
    firewall-cmd --list-services

    # 查看service的配置文件
    cat /usr/lib/firewalld/services/mysql.xml
    cat /usr/lib/firewalld/services/http.xml

    # 查看service
    firewall-cmd --query-service=http

    # 开启service
    firewall-cmd --add-service=http
    # 只在pubilic区域开启
    firewall-cmd --zone=public --add-service=http

    # 关闭service
    firewall-cmd --remove-service=http

    # --permanent参数。即使在重新启动后，Firewalld 也会自动加载它。
    firewall-cmd --zone=public --add-service=http --permanent
    firewall-cmd --query-service=http --permanent
    firewall-cmd --remove-service=http --permanent
    ```

- 开启/关闭端口：

    ```sh
    # 查看redis的端口6379是否开启。no表示没有开启
    firewall-cmd --query-port=6379/tcp

    # 查看public的配置文件。可以看到新的记录
    cat /etc/firewalld/zones/public.xml
    # 开启端口后，需要重启防火墙
    firewall-cmd --reload

    # 查看port是否有对应的端口
    firewall-cmd --list-ports

    # 关闭端口。如果需要将规则保存至zone配置文件中，重启后也会自动加载，需要加入参数--permanent
    firewall-cmd --reload

    # --permanent参数，重启后也会自动加载
    firewall-cmd --add-port=6379/tcp --permanent
    firewall-cmd --list-ports --permanent
    firewall-cmd --remove-port=6379/tcp --permanent
    ```

- 端口转发

    ```sh
    # 开启端口转发。将80端口的流量转发到192.168.110.5
    firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toaddr=192.168.110.5

    # 开启端口转发。将80端口的流量转发到8080端口
    firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toport=8080

    # 开启端口转发。将80端口的流量转发到192.168.110.5的8080端口
    firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toaddr=192.168.110.5:toport=8080

    # 查看端口转发。
    firewall-cmd --zone=public --query-forward-port=port=80:proto=tcp:toaddr=192.168.110.5

    # 关闭端口转发。
    firewall-cmd --zone=public --remove-forward-port=port=80:proto=tcp:toaddr=192.168.110.5
   ```

- 开启ip伪装：常用于路由器。由于内核限制仅可用于ipv4。

    - 私有网络的地址将会别隐藏并映射到一个共有ip，这是地址转换的一种形式

    ```sh
    # 开启ip伪装
    firewall-cmd --add-masquerade
    # 查询ip伪装
    firewall-cmd --query-masquerade
    # 关闭ip伪装
    firewall-cmd --remove-masquerade
    ```

- 开启icmp阻塞：会对icmp报文进行阻塞。icmp类似可以是请求信息、响应的应答报文、错误的应答报文

    ```sh
    # 开启icmp阻塞。echo-reply为响应的应答报文
    firewall-cmd --add-icmp-block=echo-reply
    # 查询icmp阻塞
    firewall-cmd --query-icmp-block=echo-reply
    # 关闭icmp阻塞
    firewall-cmd --remove-icmp-block=echo-reply
    ```

##### 复杂规则

- 基本使用

```sh
# mysql服务器从 IP 地址 192.168.1.69 侦听端口 3306
firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="192.168.1.69" port port=3306 protocol=tcp accept'

# 查看
firewall-cmd --zone=public --list-rich-rules

# 删除规则
firewall-cmd --zone=public --remove-rich-rule 'rule family="ipv4" source address="192.168.1.69" port port="3306" protocol="tcp" accept'

# --permanent 重启后依然生效
firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="192.168.1.69" port port=3306 protocol=tcp accept' --permanent
firewall-cmd --zone=public --list-rich-rules --permanent
firewall-cmd --zone=public --remove-rich-rule 'rule family="ipv4" source address="192.168.1.69" port port="3306" protocol="tcp" accept' --permanent
```

- 各种规则
```sh
# mysql服务器从 IP 地址 192.168.1.69 侦听端口 3306
firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="192.168.1.69" port port=3306 protocol=tcp accept'

# 与上一条命令相反。阻止从 IP 地址 192.168.1.69 访问 MySQL 服务器
firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="192.168.1.69" port port="3306" protocol="tcp" reject'

# 将所有入站流量从端口 80 重定向到主机 192.168.1.200
firewall-cmd --zone=public --add-rich-rule 'rule family=ipv4 forward-port port=80 protocol=tcp to-port=8080 to-addr=192.168.1.200'
```

### ethtool

- 这个命令之所以能查看⽹卡收发包统计、能修改⽹卡⾃适应模式、能调整 RX 队列的数量和⼤⼩，是因为 ethtool 命令最终调⽤到了⽹卡驱动的相应⽅法，⽽不是 ethtool 本身有这个超能⼒

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

### arp

```bash
arp -a

# 不解析域名
arp -n

# 删除192.168.1.1条目
arp -d 192.168.1.1
```

### arpwatch

监听网络上 ARP 的记录

```bash
arpwatch -i enp27s0 -f arpwatch.log
```

# 性能监控
## 观察工具

### 查看吞吐率，PPS（Packet Per Second 包 / 秒）

```sh

# 每1秒输出，每个虚拟网卡的信息
# rxpck/s 和 txpck/s 分别是接收和发送的 PPS，单位为包 / 秒。
# rxkB/s 和 txkB/s 分别是接收和发送的吞吐率，单位是 KB/ 秒。
# rxcmp/s 和 txcmp/s 分别是接收和发送的压缩数据包数，单位是包 / 秒。
sar -n DEV 1

# 显示关于网络错误的统计数据
sar -n EDEV 1

# 显示 TCP 的统计数据
sar -n TCP 1
```

### [wondershaper：Linux 限制网络带宽的工具](https://github.com/magnific0/wondershaper)
## 压力测试

### [wrk](https://github.com/wg/wrk)

| 参数 | 操作     |
|------|----------|
| -t   | 线程数   |
| -c   | 连接数   |
| -d   | 压测时间 |

```sh
wrk -t 6 -c 30000 -d 60s https://127.0.0.1:80
```

### [wrk2: wrp的变种](https://github.com/giltene/wrk2)

### [lighthouse(chrome 网页性能测试)](https://github.com/GoogleChrome/lighthouse)


# 优秀文章

- [unix domain sockets vs. internet sockets](https://lists.freebsd.org/pipermail/freebsd-performance/2005-February/001143.html)

    > unix socket is better

# 在线工具

- [可以画网络拓扑图](https://www.cloudcraft.co/)

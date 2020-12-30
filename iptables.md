<!-- vim-markdown-toc GFM -->

* [防火墙](#防火墙)
    * [iptables](#iptables)
        * [iptables 和 netfilter 的关系](#iptables-和-netfilter-的关系)
        * [iptables 传输数据包的过程](#iptables-传输数据包的过程)
        * [iptables 的表和链](#iptables-的表和链)
            * [链的优先顺序](#链的优先顺序)
        * [参数](#参数)
            * [规则的优先顺序](#规则的优先顺序)
        * [基本命令](#基本命令)
        * [重置规则](#重置规则)
        * [基本命令](#基本命令-1)
            * [只允许 tcp 协议,访问 80 端口](#只允许-tcp-协议访问-80-端口)
            * [只允许 tcp 以外的协议,访问 80 端口](#只允许-tcp-以外的协议访问-80-端口)
            * [只允许在 9:00 到 18:00 这段时间的 tcp 协议,访问 80 端口](#只允许在-900-到-1800-这段时间的-tcp-协议访问-80-端口)
            * [只允许 192.168.1.0/24 网段使用 SSH](#只允许-1921681024-网段使用-ssh)
            * [禁止用户访问 www.baidu.com 的网站。](#禁止用户访问-wwwbaiducom-的网站)
            * [禁止 从 192.168.1.0/24 到 10.1.1.0/24 的流量](#禁止-从-1921681024-到-1011024-的流量)
            * [禁止转发来自 MAC 地址为 00：0C：29：27：55：3F 的和主机的数据包](#禁止转发来自-mac-地址为-000c2927553f-的和主机的数据包)
        * [Nat](#nat)
            * [将目标端口是 80 的流量,跳转到 192.168.1.1](#将目标端口是-80-的流量跳转到-19216811)
            * [将出口为 80 端口的流量,跳转到 192.168.1.1:8080 端口](#将出口为-80-端口的流量跳转到-192168118080-端口)
            * [伪装 192.168.100.1 为 1.1.1.1](#伪装-1921681001-为-1111)
            * [将所有内部地址,伪装成一个外部公网地址](#将所有内部地址伪装成一个外部公网地址)
            * [通过 nat 隐藏源 ip 地址](#通过-nat-隐藏源-ip-地址)
        * [保存规则](#保存规则)
        * [最近一次启动后所记录的数据包](#最近一次启动后所记录的数据包)
    * [nftables](#nftables)
        * [iptables 转换成 nftables](#iptables-转换成-nftables)
        * [基础命令](#基础命令)
        * [禁止访问 baidu](#禁止访问-baidu)
        * [monitor](#monitor)
* [reference](#reference)

<!-- vim-markdown-toc -->

# 防火墙

## iptables

> `iptables` 已经落后了，建议使用 [nftables](https://wiki.nftables.org/wiki-nftables/index.php/Why_nftables%3F_) 一个替换现有{ip,ip6,arp,eb}tables 的框架。[Main differences with iptables](https://wiki.nftables.org/wiki-nftables/index.php/Main_differences_with_iptables)

---

> [iptables 转换为 nftables 的命令](#nftables)

### iptables 和 netfilter 的关系

`iptables` 只是防火墙的管理工具，真正实现防火墙功能的是 `netfilter`，它是 Linux 内核中实现包过滤的内部结构

### iptables 传输数据包的过程

> - ① 当一个数据包进入网卡时，它首先进入 PREROUTING 链，内核根据数据包目的 IP 判断是否需要转送出去。
> - ② 如果数据包就是进入本机的，它就会沿着图向下移动，到达 INPUT 链。数据包到了 INPUT 链后，任何进程都会收到它。本机上运行的程序可以发送数据包，这些数据包会经过 OUTPUT 链，然后到达 POSTROUTING 链输出。
> - ③ 如果数据包是要转发出去的，且内核允许转发，数据包就会如图所示向右移动，经过 FORWARD 链，然后到达 POSTROUTING 链输出。
>   ![image](./Pictures/iptables/1.png)

> ①->②
> ①->③

### iptables 的表和链

| 表                                                                    | 链                                              |
| --------------------------------------------------------------------- | ----------------------------------------------- |
| filter (过滤数据包)                                                   | INPUT、FORWARD、OUTPUT                          |
| Nat (网络地址转换)                                                    | PREROUTING、POSTROUTING、OUTPUT                 |
| Mangle (修改数据包的服务类型、TTL、并且可以配置路由实现 QOS 内核模块) | PREROUTING、POSTROUTING、INPUT、OUTPUT、FORWARD |
| Raw (决定数据包是否被状态跟踪机制处理)                                | OUTPUT、PREROUTING                              |

| 链          | 规则           |
| ----------- | -------------- |
| INPUT       | 进来的数据包   |
| OUTPUT      | 出去的数据包   |
| PREROUTING  | 路由前的数据包 |
| POSTROUTING | 路由后的数据包 |

![image](./Pictures/iptables/2.png)

#### 链的优先顺序

Raw—>mangle—>nat—>filter

### 参数

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

#### 规则的优先顺序

iptables 按规则顺序检查，条件满足则执行，否则检查下一条规则

**注意**

- 允许规则放在前面(-I)
- 拒绝规则放在后面(-A)

| -j(动作) | 操作                                                                 |
| -------- | -------------------------------------------------------------------- |
| ACCEPT   | 允许数据包通过                                                       |
| DROP     | 直接丢弃数据包，不给任何回应信息                                     |
| REJECT   | 拒绝数据包通过，必要时会给数据发送端一个响应的信息。                 |
| LOG      | 在/var/log/messages 文件中记录日志信息，然后将数据包传递给下一条规则 |

![image](./Pictures/iptables/3.png)

### 基本命令

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
```

### 重置规则

```
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

### 基本命令

- 注意`ACCEPT`,`DROP`必须要大写

#### 只允许 tcp 协议,访问 80 端口

```sh
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
```

#### 只允许 tcp 以外的协议,访问 80 端口

```sh
iptables -I INPUT -p ! tcp --dport 80 -j ACCEPT
```

#### 只允许在 9:00 到 18:00 这段时间的 tcp 协议,访问 80 端口

```sh
iptables -I INPUT -p tcp --dport 80 -m time --timestart 9:00 --timestop 18:00 -j ACCEPT
```

#### 只允许 192.168.1.0/24 网段使用 SSH

```sh
iptables -I INPUT -p tcp --dport 22 -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP
#注意要把拒绝规则放在后面

# mysql
iptables -I INPUT -p tcp --dport 3306 -s 127.0.0.1 -j ACCEPT
iptables -I INPUT -p tcp --dport 3306 -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j DROP
```

#### 禁止用户访问 www.baidu.com 的网站。

```sh
iptables -A OUTPUT -d www.baidu.com -j DROP
```

#### 禁止 从 192.168.1.0/24 到 10.1.1.0/24 的流量

```sh
iptables -I FORWARD -s 192.168.1.0/24 -d 10.1.1.0/24 -j DROP
```

#### 禁止转发来自 MAC 地址为 00：0C：29：27：55：3F 的和主机的数据包

```sh
iptables -I FORWARD -m mac --mac-source 00:0c:29:27:55:3F -j DROP
```

### Nat

#### 将目标端口是 80 的流量,跳转到 192.168.1.1

```sh
iptables -t nat -I PREROUTING -p tcp --dport 80 -j DNAT --to-dest 192.168.1.1
```

#### 将出口为 80 端口的流量,跳转到 192.168.1.1:8080 端口

```sh
iptables -t nat -I OUTPUT -p tcp --dport 80 -j DNAT --to-dest 192.168.1.1:8080
```

#### 伪装 192.168.100.1 为 1.1.1.1

```sh
iptables -t nat -I POSTROUTING -s 192.168.100.1 -j SNAT --to-source 1.1.1.1
```

使用 tcpdump 抓包测试

![image](./Pictures/iptables/4.png)

#### 将所有内部地址,伪装成一个外部公网地址

```sh
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
```

#### 通过 nat 隐藏源 ip 地址

```sh
iptables -t nat -I POSTROUTING -j SNAT --to-source 1.2.3.4
```

### 保存规则

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
systemctl reload iptables
```

### 最近一次启动后所记录的数据包

```sh
journalctl -k | grep "IN=.*OUT=.*" | less
```

## nftables

和`iptables`不同，`nftables` 不包含内置表

<span id="nftables"></span>

### iptables 转换成 nftables

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

### 基础命令

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

### 禁止访问 baidu

```sh
# 创建一个名为filter的表
nft add table ip filter


# 在filter表创建OUTPUT规则
nft 'add chain ip filter OUTPUT { type filter hook output priority 0; policy accept; }'

# 添加规则
nft add rule ip filter OUTPUT ip daddr 182.61.200.7 counter drop
nft add rule ip filter OUTPUT ip daddr 182.61.200.6 counter drop
```

### monitor

```sh
# 追踪nft
nft monitor

# 只追踪新规则
nft monitor new rules
```

# reference

- [Linux 高级系统管理](https://study.163.com/course/courseMain.htm?courseId=232008)
- [iptables 详解](https://www.jianshu.com/p/8b0642cf8d34?utm_campaign=hugo)
- [Moving from iptables to nftables](https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables)

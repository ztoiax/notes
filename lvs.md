# 负载均衡

- 四层负载均衡：也就是主要通过报文中的目标地址和端口
- 七层负载均衡：也称为“内容交换”，也就是主要通过报文中的真正有意义的应用层内容。

- 对于一般的应用来说，有了Nginx就够了。Nginx可以用于七层负载均衡。但是对于一些大的网站，一般会采用DNS+四层负载+七层负载的方式进行多层次负载均衡。

- 目前关于网站架构一般比较合理流行的架构方案：
    - Web 前端采用 Nginx/HAProxy+Keepalived 作负载均衡器
    - 后端采用 MySQL数据库一主多从和读写分离，采用 LVS+Keepalived 的架构。

# lvs

- LVS 是 Linux Virtual Server 的简称，也就是 Linux 虚拟服务器。

- 现在 LVS 已经是 Linux 标准内核的一部分，从 Linux2.4 内核以后，已经完全内置了 LVS 的各个功能模块，无需给内核打任何补丁，可以直接使用 LVS 提供的各种功能。

- LVS 是四层负载均衡：支持 TCP/UDP 的负载均衡

    - 因此它相对于其它高层负载均衡的解决办法，比如 DNS 域名轮流解析、应用层负载的调度、客户端的调度等，它的效率是非常高的。

    - LVS 不像 HAProxy 等七层软负载面向的是 HTTP 包，所以七层负载可以做的 URL 解析等工作，LVS 无法完成。

- LVS 架设的服务器集群系统有三个部分组成：

    ![image](./Pictures/lvs/lvs集群系统.avif)

    - 1.最前端的负载均衡层，用 Load Balancer 表示

        - 有一台或者多台负载调度器（Director Server）组成，LVS模块就安装在Director Server上，而Director的主要作用类似于一个路由器，它含有完成LVS功能所设定的路由表，通过这些路由表把用户的请求分发给Server Array层的应用服务器（Real Server）上。

        - 同时，在Director Server上还要安装对Real Server服务的监控模块Ldirectord，此模块用于监测各个Real Server服务的健康状况。在Real Server不可用时把它从LVS路由表中剔除，恢复时重新加入。

    - 2.中间的服务器集群层，用 Server Array 表示

        - 由一组实际运行应用服务的机器组成，Real Server可以是Web服务器、Mail服务器、FTP服务器、DNS服务器、视频服务器中的一个或者多个，每个Real Server之间通过高速的LAN或分布在各地的WAN相连接。在实际的应用中，Director Server也可以同时兼任Real Server的角色。

    - 3.最底端的数据共享存储层，用 Shared Storage 表示

        - 是为所有Real Server提供共享存储空间和内容一致性的存储区域，在物理上一般由磁盘阵列设备组成，为了提供内容的一致性，一般可以通过NFS网络文件系统共享数据，但NFS在繁忙的业务系统中，性能并不是很好，此时可以采用集群文件系统，例如Red hat的GFS文件系统、Oracle提供的OCFS2文件系统等。

- LVS 的优点

    - 抗负载能力强、是工作在传输层上仅作分发之用，没有流量的产生，这个特点也决定了它在负载均衡软件里的性能最强的，对内存和 cpu 资源消耗比较低。
    - 配置性比较低，这是一个缺点也是一个优点，因为没有可太多配置的东西，所以并不需要太多接触，大大减少了人为出错的几率。
    - 工作稳定，因为其本身抗负载能力很强，自身有完整的双机热备方案，如 LVS + Keepalived。
    - 无流量，LVS 只分发请求，而流量并不从它本身出去，这点保证了均衡器 IO 的性能不会受到大流量的影响。
    - 应用范围比较广，因为 LVS 工作在传输层，所以它几乎可以对所有应用做负载均衡，包括 http、数据库、在线聊天室等等。

- LVS 的缺点

    - 软件本身不支持正则表达式处理，不能做动静分离；而现在许多网站在这方面都有较强的需求，这个是 Nginx、HAProxy + Keepalived 的优势所在。

    - 如果是网站应用比较庞大的话，LVS/DR + Keepalived 实施起来就比较复杂了，相对而言，Nginx / HAProxy + Keepalived 就简单多了。

## NAT 模式：网络地址转换

- NAT（Network Address Translation）是一种外网和内网地址映射的技术。

- NAT 模式下，网络数据报的进出都要经过 LVS 的处理。LVS 需要作为 RS（真实服务器）的网关。

    - 当包到达 LVS 时，LVS 做目标地址转换（DNAT），将目标 IP 改为 RS 的 IP。
    - RS 接收到包以后，仿佛是客户端直接发给它的一样。
    - RS 处理完，返回响应时，源 IP 是 RS IP，目标 IP 是客户端的 IP。
    - 这时 RS 的包通过网关（LVS）中转，LVS 会做源地址转换（SNAT），将包的源地址改为 VIP，这样，这个包对客户端看起来就仿佛是 LVS 直接返回给它的。

![image](./Pictures/lvs/lvs-nat模式.avif)

## DR 模式：直接路由

- DR 模式下需要 LVS 和 RS 集群绑定同一个 VIP（RS 通过将 VIP 绑定在 loopback 实现）

    - 与 NAT 的不同点在于：请求由 LVS 接受，由真实提供服务的服务器（RealServer，RS）直接返回给用户，返回的时候不经过 LVS。

    ![image](./Pictures/lvs/lvs-dr模式.avif)

- 流程：

    - 一个请求过来时，LVS 只需要将网络帧的 MAC 地址修改为某一台 RS 的 MAC，该包就会被转发到相应的 RS 处理
        - 注意此时的源 IP 和目标 IP 都没变，LVS 只是做了一下移花接木。

    - RS 收到 LVS 转发来的包时，链路层发现 MAC 是自己的，到上面的网络层，发现 IP 也是自己的，于是这个包被合法地接受，RS 感知不到前面有 LVS 的存在。而当 RS 返回响应时，只要直接向源 IP（即用户的 IP）返回即可，不再经过 LVS。

- DR 负载均衡模式数据分发过程中不修改 IP 地址，只修改 mac 地址，由于实际处理请求的真实物理 IP 地址和数据请求目的 IP 地址一致，所以不需要通过负载均衡服务器进行地址转换，可将响应数据包直接返回给用户浏览器，避免负载均衡服务器网卡带宽成为瓶颈。

    - 因此，DR 模式具有较好的性能，也是目前大型网站使用最广泛的一种负载均衡手段。

## ipvs

```bash
# 添加模块
modprobe ip_vs
```

# nginx

- Nginx 的缺点

    - Nginx 仅能支 持http、https 、tcp、 Email等协议，这样就在适用范围上面小些，这个是它的缺点；

    - 对后端服务器的健康检查，只支持通过端口来检测，不支持通过 ur l来检测。不支持 Session 的直接保持，但能通过 ip_hash 来解决；

# HAProxy

- HAProxy 支持两种代理模式 TCP（四层）和HTTP（七层），也是支持虚拟主机的。

    - HAProxy 支持 TCP 协议的负载均衡转发，可以对 MySQL 读进行负载均衡，对后端的 MySQL 节点进行检测和负载均衡，大家可以用 LVS+Keepalived 对 MySQL 主从做负载均衡。

- HAProxy 的优点：

    - 能够补充 Nginx 的一些缺点，比如支持 Session 的保持，Cookie 的引导；同时支持通过获取指定的 url 来检测后端服务器的状态。

    - HAProxy 跟 LVS 类似，本身就只是一款负载均衡软件；单纯从效率上来讲 HAProxy 会比 Nginx 有更出色的负载均衡速度，在并发处理上也是优于 Nginx 的。

## HAProxy 负载均衡策略

- 静态负载均衡算法包括：轮询、比率、优先权。

- 动态负载均衡算法包括：最少连接数、最快响应速度、观察方法、预测法、动态性能分配、动态服务器补充、服务质量、服务类型、规则模式。

- 轮询（Round Robin）：顺序循环将请求一次顺序循环地连接每个服务器。

    - 当其中某个服务器发生第二到第7 层的故障，BIG-IP 就把其从顺序循环队列中拿出，不参加下一次的轮询，直到其恢复正常。

    - 以轮询的方式依次请求调度不同的服务器；实现时，一般为服务器带上权重；这样有两个好处：

        - 针对服务器的性能差异可分配不同的负载；
        - 当需要将某个结点剔除时，只需要将其权重设置为0即可；

    - 优点：实现简单、高效；易水平扩展
    - 缺点：请求到目的结点的不确定，造成其无法适用于有写的场景（缓存，数据库写）
    - 应用场景：数据库或应用服务层中只有读的场景

- 随机方式：请求随机分布到各个结点；在数据足够大的场景能达到一个均衡分布；

    - 优点：实现简单、易水平扩展
    - 缺点：同轮询（Round Robin），无法用于有写的场景
    - 应用场景：数据库负载均衡，也是只有读的场景

- 哈希方式：根据key来计算需要落在的结点上，可以保证一个同一个键一定落在相同的服务器上；

    - 优点：相同key一定落在同一个结点上，这样就可用于有写有读的缓存场景
    - 缺点：在某个结点故障后，会导致哈希键重新分布，造成命中率大幅度下降
    - 解决：一致性哈希 or 使用keepalived保证任何一个结点的高可用性，故障后会有其它结点顶上来

    - 应用场景：缓存，有读有写

- 一致性哈希：在服务器一个结点出现故障时，受影响的只有这个结点上的key，最大程度的保证命中率；如twemproxy中的ketama方案；生产实现中还可以规划指定子key哈希，从而保证局部相似特征的键能分布在同一个服务器上；

    - 优点：结点故障后命中率下降有限
    - 应用场景：缓存

- 根据键的范围来负载：根据键的范围来负载，前1亿个键都存放到第一个服务器，1~2亿在第二个结点。

    - 优点：水平扩展容易，存储不够用时，加服务器存放后续新增数据
    - 缺点：负载不均；数据库的分布不均衡

        - 数据有冷热区分，一般最近注册的用户更加活跃，这样造成后续的服务器非常繁忙，而前期的结点空闲很多

    - 适用场景：数据库分片负载均衡

- 根据键对服务器结点数取模来负载：比如有4台服务器，key取模为0的落在第一个结点，1落在第二个结点上。

    - 优点：数据冷热分布均衡，数据库结点负载均衡分布；
    - 缺点：水平扩展较难；
    - 适用场景：数据库分片负载均衡

- 纯动态结点负载均衡：根据CPU、IO、网络的处理能力来决策接下来的请求如何调度。

    - 优点：充分利用服务器的资源，保证个结点上负载处理均衡
    - 缺点：实现起来复杂，真实使用较少

- 不用主动负载均衡：使用消息队列转为异步模型，将负载均衡的问题消灭；负载均衡是一种推模型，一直向你发数据，那么将所有的用户请求发到消息队列中，所有的下游结点谁空闲，谁上来取数据处理；转为拉模型之后，消除了对下行结点负载的问题。

    - 优点：通过消息队列的缓冲，保护后端系统，请求剧增时不会冲垮后端服务器；水平扩展容易，加入新结点后，直接取queue即可；
    - 缺点：不具有实时性；

    - 应用场景：不需要实时返回的场景；
        - 比如，12036下订单后，立刻返回提示信息：您的订单进去排队了...等处理完毕后，再异步通知；

# [keepalived](https://github.com/acassen/keepalived)

> 是 lvs 的拓展项目
> 最初是服务器状态检测,后来加入 ipvs 模块实现负载均衡

## install(安装)

```bash
# 安装编译需要的工具
yum install -y gcc openssl openssl-devel

# 下载
curl -LO https://www.keepalived.org/software/keepalived-2.2.1.tar.gz
tar zxvf keepalived-2.2.1.tar.gz
cd keepalived-2.2.1

# 安装配置
# --sysconfdir 安装目录
./configure --sysconfdir=/usr/local

# 编译安装
make -j$(nproc) && make install
```

## 基本

- [参数介绍(官方文档)](https://www.keepalived.org/manpage.html)

- 配置文件 `/usr/local/keepalived/keepalived.conf`
  > 注意:keepalived 并不检查配置文件是否正确,要保证语法正确

配置可分为三类:

| 配置分类          | 内容                |
| ----------------- | ------------------- |
| global(全局配置)  | global_defs         |
| vrrpd(虚拟路由器) | vrrp_instance,group |
| lvs               | virtual_server      |

### global

```bash
   # 严格遵守VRRP协议，这一项最好关闭（加感叹号），若不关闭，可用vip无法被ping通
   ! vrrp_strict
```

### vrrp_instance

```bash
vrrp_instance VI_1 {
    ...
    # MASTER必须大于BACKUP
    priority 150

    # 虚拟ip,可以有多个
    virtual_ipaddress {
        192.168.100.100/24 dev virbr0
    }

    # 进入master状态时,执行脚本
    notify_master "/etc/keepalived/notify.sh master"

    # 进入backup状态时,执行脚本
    notify_backup "/etc/keepalived/notify.sh backup"

    # 进入fault状态时,执行脚本
    notify_fault "/etc/keepalived/notify.sh fault"

    # 非抢占模式
    nopreempt

    # 延迟抢占(在此时间内发生的故障不会切换)
    preempt_delay  300
}
```

<span id="notify.sh"></span>

#### notify 脚本

```bash
#!/bin/bash
# Author: hgzerowzh
# Description: An notify script
#
contact='root@localhost'

notify() {
        mailsubject="$(hostname) to be $1: vip floating"
        mailbody="$(date +'%F %H:%M:%S'): vrrp transition, $(hostname) changed to be $1"
        # echo $mailbody | mail -s "$mailsubject" $contact
        echo $mailbody > /var/log/keepalived.log
}

case $1 in
    master)
    notify master
    exit 0
    ;;
    backup)
    notify backup
    exit 0
    ;;
    fault)
    notify fault
    exit 0
    ;;
    *)
    echo "Usage: $(basename $0) {master|backup|fault}"
    exit 1
    ;;
esac
```

### vrrp_group

```
 # vrrp同步组(任何一个instance出现问题,都会进行主备切换)
 vrrp_sync_group  NAME  {
    group {
        VI_1
        VI_2
        VI_3
    }

    # 进入master状态时,执行脚本
    notify_master "/etc/keepalived/notify.sh master"

    # 进入backup状态时,执行脚本
    notify_backup "/etc/keepalived/notify.sh backup"

    # 进入fault状态时,执行脚本
    notify_fault "/etc/keepalived/notify.sh fault"
 }
```

### virtual_server

| lb_algo (算法) | 操作 |
| -------------- | ---- |
| rr(常用)       |      |
| wrr            |      |
| lc             |      |
| wlc(常用)      |      |
| lblc           |      |
| sh             |      |
| dh             |      |

| lb_kind (负载均衡机制) | 操作 |
| ---------------------- | ---- |
| NAT                    |      |
| TUN                    |      |
| DR                     |      |

```bash
virtual_server 192.168.100.1 80 {
    ...

    # 健康检查时间
    delay_loop 6

    # 调度算法
    lb_algo rr

    # 负载均衡机制
    lb_kind NAT
}
```

#### real_server

- 在 `virtual_server` 函数里

- ip 是后端服务器

```bash
real_server 192.168.100.208 80 {
    ...
    # 权重(性能高主机的设置高,低的设置低)
    weight <INT>

    # 后端层健康状态检测（web后端层检测）
    HTTP_GET | SSL_GET {
        url {
            # 路径
            path /etc/html/index.html
            # 使用genhash -s 192.168.100.208 -p 80 -u /etc/html/index.html
            digest 640205b7b0fc66c1ea91c463fac6334c
        }

        # 超时时间
        connect_timeout 3

        # 重连次数
        retry 3

        # 重连时间
        delay_before_retry 3
    }

    # 传输层健康状态检测（tcp协议层）
    TCP_CHECK {
        # tcp端口
        connect_port 80

        # ack超时时间
        connect_timeout 3

        # 重试次数
        nb_get_retry 3

        # 重试时间间隔
        delay_before_retry 3
    }

    # 外部脚本检查
    MISC_CHECK {

        # 脚本路径
        misc_path /bin/test.sh

        # 脚本超时时间
        misc_timeout 5

        # 是否动态调整real server的weight
        ! misc_dynamic
    }

    # 上线执行脚本
    notify_up

    # 下线执行脚本
    notify_down
}
```

## 负载均衡服务器配置

设置虚拟 ip

```
ip a add 192.168.100.100/24 dev virbr0 label virbr0:0
```

## 后端服务器配置

禁用 arp 对虚拟 ip 的响应

```bash
cat >> /etc/sysctl.conf << 'EOF'
net.ipv4.conf.eth0.arp_announce = 2
net.ipv4.conf.eth0.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
EOF

sysctl -p
```

设置 lo 接口地址为虚拟 ip

```bash
ip a add 192.168.100.100/24 dev lo
```

## 自定义脚本监控

```
# 定义监控函数
vrrp_script check_nginx {
    # 发送信号0判断,进程是否存在
    script "killall -0 nginx"

    # 监控时间间隔2秒
    interval 2

    # 最大失败次数
    fall 2

    # 请求次数,判断节点是否正常
    rise 1
}

vrrp_script check_nginx_1 {
    # 通过pid文件判断,进程是否存在
    script "if [ -f /var/run/nginx.pid ];then exit 0; else exit 1;fi"

    interval 2
    fall 2
    rise 1
}

# 调用vrrp_script对集群进行监控
track_script {
    # 监控函数
    check_nginx
}
```

## 配置 1

- archlinux: priority 150 为 `master`

- centos: priority 100 为 `backup`

**视频步骤:**

- 1.当 archlinux 开启 keepalived 时

  - archlinux 为 `master`

  - 可查看虚拟 ip

- 2.当 centos 开启 keepalived

  - centos 最开始为`backup`

- 3.而 archlinux 关闭 keepalived

  - centos 转为 `master`

  - 虚拟 ip 也移动到 centos

    ![image](./Pictures/lvs/config1.webm)

- 4.当 archlinux 再次,启动 keepalived(以上视频并未录制,请看以下图片)

  - archlinux 会进入 `master` 状态(nopreempt 非抢占,并没有生效)

  - centos 转为 `backup`

  - 可查看虚拟 ip

  ![image](./Pictures/lvs/config1.avif)

**配置:**

```
! Configuration File for keepalived

global_defs {
   notification_email {
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   router_id LVS_DEVEL
   vrrp_skip_check_adv_addr

   ! vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance VI_1 {
    # centos为BACKUP
    state MASTER

    interface virbr0
    virtual_router_id 51

    # centos为100
    priority 150
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    # 虚拟ip,可以有多个
    virtual_ipaddress {
        192.168.100.100/24 dev virbr0
    }
    nopreempt

    preempt_delay  300

    notify_master "/var/lib/keepalived/notify.sh master"
    notify_backup "/var/lib/keepalived/notify.sh backup"
    notify_fault "/var/lib/keepalived/notify.sh fault"
}

vrrp_script check_nginx {
    # 发送信号0判断,进程是否存在
    script "killall -0 nginx"

    # 监控时间间隔2秒
    interval 2

    # 最大失败次数
    fall 2

    # 请求次数,判断节点是否正常
    rise 1
}

track_script {
    # 监控函数
    check_nginx
}
```

[notify.sh](#notify.sh)脚本

## 优秀文章

- [参数介绍(官方文档)](https://www.keepalived.org/manpage.html)

# [爱奇艺的dpvs：基于DPDK的四层负载均衡](https://github.com/iqiyi/dpvs)

# 携程的TDLB

- [干货 | 携程基于DPDK的高性能四层负载均衡实践](https://cloud.tencent.com/developer/article/1958201)

- TDLB作为以DPVS基础框架完成的高性能四层负载均衡软件，推进了四层负载均衡服务与私有云的接入

- TDLB主要使用fullnat模式，为了避免core与core之间的资源竞争，设计了percore的会话，作为有状态的四层负载均衡必须保证入向流量与出向流量分配至同一个core
    - 入向流量可以利用RSS将数据包散列至各个队列，而每个core绑定对应的队列，对于相同的数据包 (sip,sport,dip,dport) RSS会被分配至同一core。
    - 为了保证出向回程流量还经过原先的core可以为每个core分配不同的SNAT IP
    - 在fullnat模式中，client IP会被转化成SNAT IP，到达server后，server回应报文的目的ip就是原先的SNAT IP，此时可以借助网卡的FDIR (Flow Director) 技术来匹配SNAT IP，将回程报文分配至对应的core

- 用户源IP透传：在FNAT模式中，后端服务器需要获取真实客户端IP

    - 1.TOA：在TCP建连完成后传递的第一个数据包中，加入带有客户端信息的TCP Option字段，以此传递用户源IP，后端服务可以在无感知的情况下获取用户源IP，但是需要在服务器上挂载TOA相应的kernel module。

    - 2.ProxyProtocol：在TCP建连完成后传递的第一个数据包的数据前，加入ProxyProtocol对应的报文，其中包含客户端信息，这部分报文通过单独的一个数据包发送，避免分片的产生，ProxyProtocol可以同时支持TCP及UDP，但是需要在服务的应用层提供ProxyProtocol的支持。

    - 爱奇艺的DPVS沿用LVS中的TOA（TCP Option Address）的方式传递用户源IP
        - TDLB在DPVS的基础上增加了对ProxyProtocol的支持，以此满足不同服务场景的需求。

- 日志异步写入

    - 在DPDK原日志存储机制中，当有大量日志需要记录时，单个文件I/O锁带来的耗时将影响各个CPU的数据包处理，严重时将影响控制平面流量并导致BGP连接断开。

        - DPVS在此基础上加入消息处理机制，各个核产生的日志将进入消息队列，由日志处理的核单独处理，保证I/O不会受到锁的影响。

- 集群会话同步

    - 问题：在集群多活模式下，服务器的扩缩容会导致路由路径的重新分配，没有会话同步功能支持的情况下，已有的连接会失效并导致应用层超时。
        - 这对长连接的应用影响更加明显，影响集群的可用性，无法灵活的扩缩容应对业务高峰。

    - 解决方法：为了做到多台服务器核与核间的信息交互，为每个核单独分配一个内网IP地址（FDIR），用于转发数据包至后端服务器的同时（SNAT IP），用于会话信息同步的Source Address及Dest Address。

        ![image](./Pictures/lvs/携程TDLB集群为cpu核分配ip.avif)
        - 在此基础上，TDLB集群使用的SNAT Pool需要一个连续的网段，
        - 每台TDLB服务器分配一个同等大小的子网，同时会利用BGP同时宣告三个子网掩码不同的SNAT Pool网段路由：
            - 网卡对应CPU分配的子网段 (32-log(n/2))
            - 服务器分配的子网段 (32-log(n))
            - TDLB集群的SNAT Pool网段 (32-log(n*m))

        - 1.服务器正常情况
            - 当Client（CIP: 1.1.1.0, CPort: 5000）请求服务（VIP: 1.1.1.1, VPort: 80）时
            - 路由到TDLB 0并通过SNAT IP（LIP: 10.0.0.0, LPort: 6000）转发给RealServer（RIP: 10.0.1.0, RPort: 8080）
            - 其中这个TDLB集群对应的SNAT Pool是10.0.0.0/24。
            ![image](./Pictures/lvs/携程TDLB集群-服务器正常情况.avif)

        - 2.服务器异常情况
            - 当TDLB 0拉出集群（停止BGP宣告路由）时，Client的请求被重新路由到了TDLB 3，由于查询到了同步的会话信息，因此使用相同的SNAT IP（10.0.0.0）转发给相同的RealServer（10.0.1.0）
            - RealServer回复请求时被重新路由到了TDLB 1再转发给Client。
            ![image](./Pictures/lvs/携程TDLB集群-服务器异常情况.avif)

        - 3.服务器恢复工作
            - 当TDLB 0拉入集群恢复工作后，原本属于TDLB 0的会话会被重新分配给TDLB 0。
            ![image](./Pictures/lvs/携程TDLB集群-服务器恢复.avif)

    - 会话同步
        - 增量同步：在新的连接建立时进行，并随着数据的传输保持连接的状态同步
        - 全量同步：在新的服务器加入集群时，需要全量同步会话信息

- 资源隔离

    - 1.CORE与CORE之间的数据隔离
        - 利用网卡的RSS，FDIR等流控技术，将数据流分配至同一core，保证了core处理数据流时不需要用到全局资源，避免了资源竞争带来锁的问题。
        - 处理数据流需要使用的相关资源可以在初始化时，为每个core单独分配资源，利用消息处理机制保证core与core之间的信息同步。

    - 2.NUMA架构下CPU数据隔离
        - CPU与CPU之间跨NUMA访问数据在一定程度上限制了应用的性能

        - 根据NUMA架构中CPU的数量各分配独立的硬件网卡资源即可

    - 3.控制平面与数据平面流量隔离
        - 控制平面流量：BGP、健康检测及二层信息交互
        - 数据平面流量：负载均衡服务

        - 问题：控制平面流量需要通过数据平面的相关cpu核处理后进入KNI队列中，当业务负载超出阈值时将影响到BGP及健康检测服务
            - 且混杂的流量增加了系统的复杂度，使控制平面的流量难以定位。

        - 解决方法：对原先的RSS配置进行修改，隔离出一个单独的队列，同时结合FDIR将控制平面流量导入隔离的队列中，实现控制平面与数据平面流量的隔离。
        ![image](./Pictures/lvs/TDLB控制平面与数据平面流量隔离.avif)

- 集群配置管理

    - 在硬件设备以及LVS的集群管理中，都是通过API的方式与设备交互，进行配置的管理。
        - 被动的配置更新无法保证服务器进入集群提供服务时配置的一致性，且每台服务器独立的API鉴权增加了控制的复杂度。
        - 在k8s中的controller及reconcile机制提供了解决方案。

    - 使用etcd存储集群配置，每台TDLB服务器都会启动operator监听相关配置更新产生的事件，并通过etcd的证书鉴权保证配置的有效性。

        ![image](./Pictures/lvs/TDLB通过etcd进行配置管理.avif)

        - 流程：
            - 在更新配置前，API开始监听配置对应key prefix的事件，开启监听后更新etcd中的集群配置
            - 配置更新产生事件，TDLB服务器上的operator捕获事件后进行相应的配置更新操作
            - 更新操作成功完成后，将配置版本回写至etcd相应的key中
            - 配置版本回写产生事件，API监听到事件后进行统计，当集群所有服务器都更新完成，则操作完成

        - 每当TDLB服务启动后，都会与etcd进行配置同步，保证进入集群提供服务时配置的一致性。

        - 集群水平扩容服务器时，新进入集群的服务器通过这种同步机制即可完成配置的下发，与服务部署的自动化保证了水平扩缩容的效率，应对业务流量的增长。

- 网卡健康检测策略
    - 问题：当一台负载均衡设备上存在多块网卡时，如果仅从一块网卡发起健康检测，当该网卡线路出现故障时，将影响到整台设备的服务，即网卡线路层面的故障升级到服务器层面。
    - 解决方法：在同一时间，从每块网卡发起健康检测，并且将服务的部分配置按网卡进行分隔，当一条网卡的线路出现故障，仅影响线路对应的服务配置，其他网卡线路依旧正常工作，这样更好地保证了服务器剩余的工作能力。

- 多维度监控

    - 在多活模式的集群中，需要从不同维度进行监控，提高故障的响应效率及定位效率：
        - 1.集群维度：监控集群整体服务状态
        - 2.服务器维度：监控单台服务器的服务状态以及集群中服务器间的差异
        - 3.服务维度：监控每个服务的状态，便于用户对于服务状态的感知
        - 4.CORE维度：监控每个CORE的工作状态，便于集群容量的评估

    - 基于DPDK latency stats设计了CORE与CORE独立的metric计算与存储，从而高效的获取处理数据包耗时以及工作周期耗时的数据，监控单台机器以及整个集群的服务工作状态。

    - 监控数据接入prometheus及grafana，设置了各个维度的监控告警，帮助快速定位故障点。


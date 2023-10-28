# lvs

## ipvs

```bash
# 添加模块
modprobe ip_vs
```

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

# [爱奇艺的dpvs](https://github.com/iqiyi/dpvs)

- 基于DPDK的四层负载均衡

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


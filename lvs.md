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
    HTTP_GET {
            ...

            # 超时时间
            connect_timeout 3

            # 重连次数
            retry 3

            # 重连时间
            delay_before_retry 3
    }

    # 传输层健康状态检测（tcp协议层）
    TCP_CHECK {
            ...
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

## 优秀文章

- [参数介绍(官方文档)](https://www.keepalived.org/manpage.html)

- [Keepalived 服务详解](https://mp.weixin.qq.com/s?src=11&timestamp=1612060965&ver=2861&signature=EJDqi25HIiZJQrXjvrlkWaEnM-nTuKdFALmUW6mdrbmA9dwGoqzzk4ovU4l0*z6W4OHKJk6*FdudC7v69dYeGRS-8zU0QHlpoe6vGnDdhOJmLxLsYeo805EM-5-VB-Qr&new=1)

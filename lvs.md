
<!-- mtoc-start -->

* [负载均衡](#负载均衡)
* [lvs](#lvs)
  * [NAT 模式：网络地址转换](#nat-模式网络地址转换)
  * [DR 模式：直接路由（默认模式）](#dr-模式直接路由默认模式)
  * [TUN 模式](#tun-模式)
  * [ipvsadm命令](#ipvsadm命令)
  * [实战：DR模式](#实战dr模式)
* [nginx](#nginx)
* [HAProxy](#haproxy)
  * [HAProxy 负载均衡策略](#haproxy-负载均衡策略)
  * [实战](#实战)
* [keepalived](#keepalived)
  * [vrrp原理](#vrrp原理)
  * [install(安装)](#install安装)
  * [配置文件keepalived.conf](#配置文件keepalivedconf)
    * [vrrp_script自定义监控函数](#vrrp_script自定义监控函数)
    * [notify 脚本](#notify-脚本)
  * [实战：lvs+keepalived双机热备](#实战lvskeepalived双机热备)
    * [配置文件](#配置文件)
    * [ansible安装](#ansible安装)
    * [测试](#测试)
  * [实战：nginx+keepalived双机热备](#实战nginxkeepalived双机热备)
    * [配置文件](#配置文件-1)
    * [ansible安装](#ansible安装-1)
    * [测试](#测试-1)
  * [实战：nginx+keepalived双主架构](#实战nginxkeepalived双主架构)
    * [配置文件](#配置文件-2)
    * [测试](#测试-2)
  * [实战：haproxy+keepalived双机热备](#实战haproxykeepalived双机热备)
    * [配置文件](#配置文件-3)
    * [ansible安装](#ansible安装-2)
    * [测试](#测试-3)
  * [实战：redis+keepalived双机热备](#实战rediskeepalived双机热备)
    * [配置文件](#配置文件-4)
    * [ansible安装](#ansible安装-3)
    * [测试](#测试-4)
  * [实战：archlinux和centos7两台主机（这个实战有点旧了，简单看一下就好了）](#实战archlinux和centos7两台主机这个实战有点旧了简单看一下就好了)
    * [配置文件](#配置文件-5)
    * [测试](#测试-5)
  * [reference](#reference)
* [爱奇艺的dpvs：基于DPDK的四层负载均衡](#爱奇艺的dpvs基于dpdk的四层负载均衡)
* [携程的TDLB](#携程的tdlb)

<!-- mtoc-end -->

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

- lvs工作模式：
    - 1.NAT：修改请求报文的目标ip，多目标ip的DNAT
    - 2.DR（默认模式）：操作封装新的mac地址
    - 3.TUN：在原请求IP报文之外添加一个ip首部
    - 4.FULLNAT：修改请求报文的源和目标ip

## NAT 模式：网络地址转换

- NAT（Network Address Translation）是一种外网和内网地址映射的技术。

- NAT模式
    - RIP和DIP应在同一个IP网络，且应使用私网地址，RealServer的网关要指向DIP
    - 请求报文和响应报文都必须经由lvs转发，所以lvs容易成为瓶颈
    - 支持端口映射，可修改请求报文的目标port
    - lvs必须是linux系统，RealServer可以是任意系统

- NAT 模式下，网络数据报的进出都要经过 LVS 的处理。LVS 需要作为 RS（真实服务器）的网关。

    ![image](./Pictures/lvs/lvs-nat模式.avif)

    - 1.客户端发送请求到lvs
    - 2.当包到达 LVS 时，LVS 做目标地址转换（DNAT），将目标 IP 改为 RealServer 的 IP（RIP)。
    - 3.Realserver 接收到包以后，仿佛是客户端直接发给它的一样。
    - 4.Realserver 处理完，返回响应时
        - 源 IP 是 Realserver 的IP
        - 目标 IP 是 client 的 IP(CIP)
    - 5.这时 Realserver 的包通过网关（LVS）中转，LVS 会做源地址转换（SNAT），将包的源地址改为 VIP
        - 这样这个包对客户端看起来就仿佛是 LVS 直接返回给它的。

    - 6.lvs返回响应给客户端

- 访问流量说明：

    ![image](./Pictures/lvs/lvs-nat模式1.avif)

    - iptables简单介绍：PREROUTING : 路由前INPUT : 数据包流入口FORWARD : 转发管卡OUTPUT : 数据包出口POSTROUTING : 路由后

    - 1.当用户请求到达LVS，此时请求的数据报文会先到内核空间的PREROUTING链。
        - 此时报文的源IP为CIP，目标IP为VIP。

    - 2.PREROUTING检查发现数据包的目标IP是本机，将数据包送至INPUT链。
    - 3.LVS比对数据包请求的服务是否为集群服务，若是，修改数据包的目标IP地址为后端服务器IP，然后将数据包发至POSTROUTING链。
        - 此时报文的源IP为CIP，目标IP为RIP。

    - 5.POSTROUTING链通过选路，将数据包发送给RSRS比对发现目标为自己的IP，开始构建响应报文发回给LVS。
        - 此时报文的源IP为RIP，目标IP为CIP。

    - 6.LVS在响应客户端前，此时会将源IP地址修改为自己的VIP地址，然后响应给客户端。
        - 此时报文的源IP为VIP，目标IP为CIP。

## DR 模式：直接路由（默认模式）

- DR 模式下需要 LVS 和 RS 集群绑定同一个 VIP（RS 通过将 VIP 绑定在 loopback 实现）

    - 与 NAT 的不同点在于：请求由 LVS 接受，由真实提供服务的服务器（RealServer，RS）直接返回给用户，返回的时候不经过 LVS。

    ![image](./Pictures/lvs/lvs-dr模式.avif)

- DR模式：
    - RealServer的RIP可以使用私网地址，也可以是公网地址，RIP与DIR在同一IP网络，RIP的网关不能指向DIP，以确保响应报文不会经由director(lvs服务器)
    - RealServer和lvs要在同一个物理网络请求报文要经由lvs，但响应报文不经由lvs，而由RealServer直接发往client不支持端口映射(端口不能修改)无需开启ip_forward。
    - RealServer可以是任意系统

- 流程：

    - 一个请求过来时，LVS 只需要将网络帧的 MAC 地址修改为某一台 RealServer 的 MAC，该包就会被转发到相应的 RealServer 处理
        - 注意此时的源 IP 和目标 IP 都没变，LVS 只是做了一下移花接木。

    - RealServer 收到 LVS 转发来的包时，链路层发现 MAC 是自己的，到上面的网络层，发现 IP 也是自己的，于是这个包被合法地接受，RealServer 感知不到前面有 LVS 的存在。而当 RealServer 返回响应时，只要直接向源 IP（即用户的 IP）返回即可，不再经过 LVS。

- DR 负载均衡模式数据分发过程中不修改 IP 地址，只修改 mac 地址

    - 由于实际处理请求的真实物理 IP 地址和数据请求目的 IP 地址一致，所以不需要通过负载均衡服务器进行地址转换，可将响应数据包直接返回给用户浏览器，避免负载均衡服务器网卡带宽成为瓶颈。

    - 因此，DR 模式具有较好的性能，也是目前大型网站使用最广泛的一种负载均衡手段。

- 访问流量说明：

    ![image](./Pictures/lvs/lvs-dr模式1.avif)

    - 1.首先用户用CIP请求VIP。
    - 2.不管是lvs还是RealServer上都需要配置相同的VIP
        - 1.那么当用户请求到达我们的集群网络的前端路由器的时候,请求数据包的源地址为CIP目标地址为VIP
        - 2.路由器会发广播问谁是VIP,那么我们集群中所有的节点都配置有VIP
        - 3.问题：谁先响应路由器那么路由器就会将用户请求发给谁,这样一来我们的集群系统是不是没有意义了
        - 4.解决方法：那我们可以在网关路由器上配置静态路由指定VIP就是lvs,或者使用一种机制不让RealServer 接收来自网络中的ARP地址解析请求,这样一来用户的请求数据包都会经过lvs。

    - 3.当用户请求到达lvs，此时请求的数据报文会先到内核空间的PREROUTING链。
        - 此时报文的源IP为CIP，目标IP为VIP。

    - 4.PREROUTING检查发现数据包的目标IP是本机，将数据包送至INPUT链。
        - IPVS比对数据包请求的服务是否为集群服务，如果是：
            - 将请求报文中的源MAC地址修改为DIP的MAC地址
            - 将目标MAC地址修改RIP的MAC地址，然后将数据包发至POSTROUTING链。
            - 此时的源IP和目的IP均未修改，仅修改了源MAC地址为DIP的MAC地址，目标MAC地址为RIP的MAC地址

    - 5.由于DS和RealServer在同一个网络中，所以是通过二层来传输。POSTROUTING链检查目标MAC地址为RIP的MAC地址，那么此时数据包将会发至RealServer。

    - 6.RealServer发现请求报文的MAC地址是自己的MAC地址，就接收此报文。
        - 处理完成之后，将响应报文通过lo接口传送给eth0网卡然后向外发出。 此时的源IP地址为VIP，目标IP为CIP9.响应报文最终送达至客户端。

## TUN 模式

- 流程：
    - 1.不修改报文IP首部(源IP为CIP，目标IP为VIP)
    - 2.而在原IP报文之外在封装一个IP首部(源IP为DIP，目标IP为RIP)
    - 3.将报文发往挑选出的目标RS，RS直接响应给客户端(源IP为VIP，目标IP为CIP)

- TUN 模式

    - RIP和DIP可以不处在同一物理网络中，RealServer的网关一般不能指向DIP，且RIP可以和公网通信
        - 也就是说集群节点可以跨互联网实现，DIP、VIP、RIP可以是公网地址

    - RealServer的tun接口上需要配置VIP，以便接收lvs转发过来的数据包，以及作为响应报文源ip

    - lvs转发给RealServer时需要借助隧道：隧道外层IP头部的源IP是DIP，目标IP是RIP
        - 而RealServer响应给客户端的IP头部是根据隧道内层的IP头分析得到的：源IP是VIP，目标IP是CIP

    - 请求报文要经由lvs，但响应不经由lvs，响应有RealServer自己完成

    - 不支持端口映射RealServer系统需要支持隧道功能

- 访问流量说明：

    ![image](./Pictures/lvs/lvs-tun模式.avif)

    - 1.当用户请求到达Director Server，此时请求的数据报文会先到内核空间的PREROUTING链。
        - 此时报文的源IP为CIP，目标IP为VIP 。

    - 2.PREROUTING检查发现数据包的目标IP是本机，将数据包送至INPUT链。

    - 3.IPVS比对数据包请求的服务是否为集群服务，若是，在请求报文的首部再次封装一层IP报文，封装源IP为为DIP，目标IP为RIP。然后发至POSTROUTING链。
        - 此时源IP为DIP，目标IP为RIP。

    - 4.POSTROUTING链根据最新封装的IP报文，将数据包发至RS（因为在外层封装多了一层IP首部，所以可以理解为此时通过隧道传输）。
        - 此时源IP为DIP，目标IP为RIP。

    - 5.RealServer接收到报文后发现是自己的IP地址，就将报文接收下来，拆除掉最外层的IP后，会发现里面还有一层IP首部，而且目标是自己的lo接口VIP，那么此时RealServer开始处理此请求，处理完成之后，通过lo接口送给eth0网卡，然后向外传递。
        - 此时的源IP地址为VIP，目标IP为CIP

## ipvsadm命令

```sh
# 安装lvs
yum install ipvsadm
```

| 常用参数 | 说明                                   |
|----------|----------------------------------------|
| -A       | 添加一条新的虚拟服务                   |
| -E       | 编辑虚拟服务                           |
| -D       | 删除虚拟服务                           |
| -C       | 清除所有虚拟服务                       |
| -R       | 恢复虚拟服务规则                       |
| -S       | 保存虚拟服务规则                       |
| -a       | 在一个虚拟服务中添加一个新的真实服务   |
| -e       | 编辑某个真实服务                       |
| -d       | 删除某个真实服务                       |
| -L       | 显示内核中的虚拟服务规则               |
| -Z       | 将准发消息的统计清零                   |
| -h       | 显示帮助信息                           |
| -t       | TCP协议的虚拟服务                      |
| -u       | UDP协议的虚拟服务                      |
| -f       | 说明是经过iptables标记过的服务类型     |
| -s       | 使用的调度算法                         |
| -p       | 持久稳固的服务                         |
| -M       | 指定客户地址的子网掩码                 |
| -r       | 真是的服务器                           |
| -g       | 指定LVS的工作模式为DR                  |
| -i       | 指定LVS的工作模式为TUN                 |
| -m       | 指定LVS的工作模式为NAT                 |
| -w       | 真实服务器的权值                       |
| -c       | 显示ipvs中目前存在的连接               |
| -6:      | 如果fwmark用的是ipv6地址需要指定此选项 |

- 常用案例

```sh
# 添加一个虚拟服务，使用轮询算法：
ipvsadm -A -t 192.168.110.110:80 -s rr

# 修改虚拟服务的算法为加权轮询：
ipvsadm -E -t 192.168.110.110:80 -s wrr

# 删除一个虚拟服务：
ipvsadm -D -t 192.168.110.110:80

# 添加一个真实服务器，使用DR模式，设置权重为2：
ipvsadm -a -t 192.168.110.110:80 -r 192.168.110.6:80 -g -w 2

# 修改真实服务器的权重为5：
ipvsadm -e -t 192.168.110.110:80 -r 192.168.110.6:80 -g -w 5

# 删除一个真实服务器：
ipvsadm -d -t 192.168.110.110:80 -r 192.168.110.6:80

# 查看当前虚拟服务和各RS的权重信息：
ipvsadm -Ln

# 查看当前ipvs模块中记录的链路信息：
ipvsadm -lnc

# 查看当前ipvs模块中的转发情况：
ipvsadm -Ln --stats
```

## 实战：DR模式

| 主机名 | IP                                  | 用途          |
|--------|-------------------------------------|---------------|
| lvs    | 192.168.110.4、VIP：192.168.110.110 | 调度器lvs     |
| rs1    | 192.168.110.6                       | 后端服务器RS1 |
| rs2    | 192.168.110.7                       | 后端服务器RS2 |

| ipvsadm参数 | 说明                                                             |
|-------------|------------------------------------------------------------------|
| -A          | 添加一个虚拟服务，使用ip地址、端口号、协议来唯一定义一个虚拟服务 |
| -t          | 使用TCP服务，该参数后需加主机与端口信息                          |
| -s          | 指定lvs的调度算法                                                |
| rr          | 轮询算法                                                         |
| -a          | 添加一台真实服务器                                               |
| -r          | 设置真实服务器IP与端口                                           |
| -g          | 设置lvs工作模式为DR直连路由                                      |
| -w          | 指定真实服务器权重                                               |

- 以下的lvs服务器和rs1和rs2的安装命令我写入了[install-lvs.yml](./ansible配置/playbook/centos/lvs/install-lvs.yml)。可以直接使用ansible安装

- lvs服务器上执行

```sh
# 安装lvs
yum install ipvsadm

# 新建vip：192.168.110.110
ifconfig eth0:0 192.168.110.110 broadcast 192.168.110.110 netmask 255.255.255.255 up

# 设置路由
route add -host 192.168.110.110 dev eth0:0

# 开启转发
echo "1" >/proc/sys/net/ipv4/ip_forward

# 添加转发规则
# 设置轮询算法
ipvsadm -A -t 192.168.110.110:80 -s rr
# 设置dr模式，权重为1
ipvsadm -a -t 192.168.110.110:80 -r 192.168.110.6:80 -g -w 1
# 设置dr模式，权重为1
ipvsadm -a -t 192.168.110.110:80 -r 192.168.110.7:80 -g -w 1

# 查看当前规则
ipvsadm
```

- rs1和rs2服务器上执行

```sh
# 新建vip：192.168.110.110
ifconfig lo:0 192.168.110.110 broadcast 192.168.110.110 netmask 255.255.255.255 up

# 设置路由
route add -host 192.168.110.110 dev lo:0

# 关闭arp解析
echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
```

- 测试

```sh
# 在lvs服务器上运行
root@centos7-2 ~# ipvsadm
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  centos7-2:http rr
  -> centos7-4:http               Route   1      1          0
  -> centos7-1:http               Route   1      1          0

# 在rs服务器上运行
root@centos7-4 ~# ipvsadm
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
```

```sh
# 在192.168.110.6和192.168.110.7开启nginx服务后。执行
curl 192.168.110.110:80
```

# nginx

- Nginx 的缺点

    - Nginx 仅能支 持http、https 、tcp、 Email等协议，这样就在适用范围上面小些，这个是它的缺点；

    - 对后端服务器的健康检查，只支持通过端口来检测，不支持通过 ur l来检测。不支持 Session 的直接保持，但能通过 ip_hash 来解决；

# HAProxy

- HAProxy 支持两种代理模式 TCP（四层）和HTTP（七层），也是支持虚拟主机的。

    - HAProxy 支持 TCP 协议的负载均衡转发，可以对 MySQL 读进行负载均衡，对后端的 MySQL 节点进行检测和负载均衡

    - LVS+Keepalived 对 MySQL 主从做负载均衡。

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

## 实战

- 1台haproxy服务器监听80端口，负责转发到后端2台nginx服务器
    - haproxy服务器的ip为：`192.168.110.4`
    - nginx服务器1的ip为：`192.168.110.6`
    - nginx服务器2的ip为：`192.168.110.7`

    ![image](./Pictures/lvs/haproxy实战.avif)

- `/etc/haproxy/haproxy.cfg`配置文件

```
#---------------------------------------------------------------------
# Example configuration.  See the full configuration manual online.
#
#   http://www.haproxy.org/download/2.5/doc/configuration.txt
#
#---------------------------------------------------------------------

##### 全局配置信息 ######
global
    # 默认最大连接数
    maxconn     20000
    log         127.0.0.1 local0
    # 运行用户
    user        haproxy
    group       haproxy
    # chroot运行路径
    chroot      /usr/share/haproxy
    # pid文件存放路径
    pidfile     /run/haproxy.pid
    # 以后台形式运行daemon
    daemon
    # ulimit的数量限制
    ulimit-n 65535
    # 开启套接子socket
    # stats socket /var/lib/haproxy/stats

##### 默认的全局配置 ######
# 这些参数可以被配置到frontend、backend、listen组建
defaults
    # http 7层模式
    mode                    http
    # 应用全局的log配置
    log                     global
    # 启用http的log
    option                  httplog
    option                  dontlognull
    option http-server-close
    # 如果后端服务器需要获得客户端真实ip需要配置的参数。可以从http header中获得客户端ip
    option forwardfor       except 127.0.0.0/8
    # serverid对应的服务器挂掉后，强制定向到其他健康服务器
    option                  redispatch
    # 3次连接就认为服务不可用，也可以通过后面设置
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    # 心跳检测超时
    timeout check           10s
    # 默认最大连接数
    maxconn                 20000
    # 连接超时
    contimeout              5000
    # 服务器超时
    srvtimeout              50000

##### frontend配置 #####
frontend  main
    # 监听端口。即haproxy提供web服务的端口
    bind :80
    # http 7层模式
    mode                 http
    # 应用全局的log配置
    log                  global
    # 启用http的log
    option               httplog
    option               dontlognull
    # 如果后端服务器需要获得客户端真实ip需要配置的参数。可以从http header中获得客户端ip
    option forwardfor    except 127.0.0.0/8
    maxconn              8000
    timeout              client  30s

    ##### acl策略配置 #####
    acl url_static       path_beg       -i /static /images /javascript /stylesheets
    acl url_static       path_end       -i .jpg .gif .png .css .js

    # 当满足url_static时使用app的后端
    use_backend app          if url_static
    default_backend          app

##### backend配置 #####
backend app
    # http 7层模式
    mode        http
    # 负载均衡算法，roundrobin为平均算法
    balance     roundrobin
    timeout     connect 5s
    timeout     server  5s
    # 服务器定义。cookie web1表示serveid为web 1；rise 3是3次正确认为服务器可用；weight为权重
    server      web1 192.168.110.6:80 cookie web1 check inter 1500 rise 3 weight 1
    server      web2 192.168.110.7:80 cookie web2 check inter 1500 rise 3 weight 2
```

- 启动以上配置文件

```sh
# 由于设置了haproxy监听80端口。因此需要关闭80端口的服务
systemctl stop nginx

# 开启haproxy
systemctl start haproxy
```

- 测试
```sh
curl 192.168.110.4:80

# 进入192.168.110.6后关闭nginx。测试负载均衡
systemctl stop nginx

# 再次测试
curl 192.168.110.4:80
```

# [keepalived](https://github.com/acassen/keepalived)

- keepalivved软件有2种功能：
    - 1.监控检查
    - 2.VRRP冗余

- keepalived的作用是：检测web服务器的状态
    - 1.如果一台web服务器或mysql服务器宕机或工作出现故障，keepalived检测到后，会将有故障的服务器从系统中剔除
    - 2.当服务器工作正常后keepalived自动将其入服务器群

    - 这些工作都是自动完成。人工需要做的是修复故障的web和mysql服务器

- keepalived在不同tcp/ip层，有不同的工作模式：

    - 网络层（第3层）：根据ip地址是否有效作为服务器的工作是否正常。
        - 定期向服务器集群发送icmp数据包，如果某台服务器无法ping通。则报告这台服务器失效，从集群中剔除。

    - 传输层（第4层）：根据tcp端口状态决定服务器工作是否正常。
        - keepalived检测80端口没有启动，则报告这台服务器失效，从集群中剔除。

    - 应用层（第7层）：根据用户的设定检查服务器程序的运行是否正常
        - 如果与用户设定不符，则报告这台服务器失效，从集群中剔除。

- keepalived是模块化设计，不同模块复制不同的功能

    - 1.core：keepalived的核心，负责主进程的启动和维护，全局配置文件的加载解析等

    - 2.check：负责healthecker（健康检查），包含各种健康检查方式
        - 以及对应配置解析，包括lvs配置解析

    - 3.Vrrp：vrrpd子进程，用来实现vrrp
    - 4.libipfwc：iptables库，配置lvs会用到
    - 5.libipvs：虚拟服务集群，配置lvs会使用

- 生产环境使用keepalived正常与性能，需要启动3个进程：父进程（监控子进程）、VRRP子进程、Checkers子进程

    - 两个子进程都被系统watchlog看管，各自负责自己的工作。
    - healthecheck子进程检查各自服务器的健康状况，如果healthecheck子进程检查各自服务器的健康情况，如果查到master服务不可用，就会通知本机上的vrrp子进程，让它删除通告，并去掉虚拟IP，转换为BACKUP状态

## vrrp原理

- vrrp虚拟路由冗余协议：可以将2台物理主机当成路由器，组成一个虚拟路由集群。

    - 一台Master路由器复制路由工作，其他都是Backup

    - master主机产生VIP，该VIP负责转发用户发起的ip包或者负责处理用户的请求。不管谁是master，对外都是相同的MAC地址和VIP
        - 例子：nginx+keepalived组合，用户请求访问keepalived VIP地址，然后访问master相应的服务和端口

    - master会一直发送VRRP组播包，bakcup不会抢占master，除非它的优先级（priority）更高。
        - VRRP组播包使用加密协议进行
        - 当master不可用（Backup收不到组播包），堕胎Backup中优先级最高的会抢占成为master（过程非常快速）。


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

## 配置文件keepalived.conf

- [参数介绍(官方文档)](https://www.keepalived.org/manpage.html)

- 包管理安装的配置文件路径：`/etc/keepalived/keepalived.conf`
- 编译安装的配置文件路径：`/usr/local/keepalived/keepalived.conf`

- 注意:keepalived 并不检查配置文件是否正确,要保证语法正确

- 可以通过在开头，加`!`注销配置行

- 配置可分为三类:

    | 配置分类          | 内容                |
    | ----------------- | ------------------- |
    | global(全局配置)  | global_defs         |
    | vrrpd(虚拟路由器) | vrrp_instance,group |
    | lvs               | virtual_server      |

- 配置文件解析
```
! Configuration File for keepalived

# 全局配置
global_defs {

   # 指定keepalived发生切换时发送email
   notification_email {
     name1@163.com
     name2@163.com
   }
   # 指定发件人
   notification_email_from name1@163.com

   # smtp服务器地址
   smtp_server 192.168.200.1
   # smtp超时时间
   smtp_connect_timeout 30
   # 运行keepalived机器的标识
   router_id LVS_DEVEL

   vrrp_skip_check_adv_addr

   # 严格遵守VRRP协议，这一项最好关闭，若不关闭，可用vip无法被ping通
   ! vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

# vrrp同步组(任何一个instance出现问题,都会进行主备切换)
vrrp_sync_group  NAME  {
    group {
        # 实例名
        VI_1
        VI_2
    }

    # 进入master状态时,执行脚本
    notify_master "/etc/keepalived/notify.sh master"

    # 进入backup状态时,执行脚本
    notify_backup "/etc/keepalived/notify.sh backup"

    # 进入fault状态时,执行脚本
    notify_fault "/etc/keepalived/notify.sh fault"

    # 发生任何状态切换时,执行脚本
    notify "/etc/keepalived/notify.sh fault"

    # 使用global_defs中的提供邮件地址和SMTP服务器发送邮件通知
    smtp_alert
}

vrrp_instance VI_1 {
    # 设置主机状态
    state MASTER

    # 对外提供服务的网络接口
    interface eth0

    # VRID标记，路由ID
    virtual_router_id 50

    # 优先级。优先级高的成为master
    priority 100

    # 非抢占模式
    nopreempt

    # 延迟抢占(在此时间内发生的故障不会切换)
    preempt_delay  300

    # 检查间隔。默认为1秒
    advert_int 5

    # 设置认证
    authentication {
        auth_type PASS # 认证方式
        auth_pass 1111 # 认证密码
    }

    # 设置VIP，可以有多个
    virtual_ipaddress {
        192.168.200.16
        192.168.100.100/24 dev virbr0
    }
}

# 这里的ip为vip
virtual_server 192.168.200.16 443 {
    # 健康检查时间间隔
    delay_loop 6
    # 调度算法rr wrr lc wlc lblc sh dh
    lb_algo rr
    # 负载均衡转发规则NAT DR TUN
    lb_kind NAT
    # 会话保持时间
    persistence_timeout 5
    # 使用协议
    protocol TCP

    # 这里ip为后端服务器ip
    real_server 192.168.201.100 443 {

        # 权重(性能高主机的设置高,低的设置低) 。默认为1，0为失效
        weight 1

        # 后端层健康状态检测（web后端层检测）
        HTTP_GET | SSL_GET {
            # 检查url，可写多个
            url {
                # 路径
                path /index.html
                # 检查校验码。校验码获取命令：genhash -s <ip> -p -u http://<ip>/index.html

                # 使用genhash -s 192.168.100.208 -p 80 -u /etc/html/index.html
                digest ff20ad2481f97b1754ef3e12ecd3a9cc
                # 返回http状态码
                status_code 200
            }
            url {
                path /mrtg/
                digest 9b3a0c85a887a256d6939da88aabd8cd
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
}
```

### vrrp_script自定义监控函数

- 在 `vrrp_instance` 中通过定义 `track_script` 来追踪脚本执行过程
- 在keepalived.conf配置文件，可以通过`vrrp_script`自定义监控函数

```
# track_script在vrrp_instance中定义
vrrp_instance VI_1 {
    # 调用vrrp_script对集群进行监控
    track_script {
        # 使用监控函数1
        check_nginx1
    }
}

# 可以自定义监控函数
# 定义监控函数1
vrrp_script check_nginx1 {
    # 通过pgrep判断进程是否存在（0表示不存在，1表示存在）。不存在就systemctl stop keepalived。如果使用killall keepalived，需要安装psmisc包
    # script "if [ `pgrep nginx | wc -l` -eq 0 ];then systemctl stop keepalived fi"

    # 监控时间间隔2秒
    interval 2
    # 最大失败次数
    fall 2
    # 请求次数,判断节点是否正常
    rise 1
    # 当脚本执行成立，那么把当前服务器优先级改为-20
    weight -20
}

# 定义监控函数2
vrrp_script check_nginx2 {
    # 通过pid文件判断,进程是否存在。需要在nginx.conf里定义nginx.pid的路径
    script "if [ -f /var/run/nginx.pid ];then exit 0; else systemctl stop keepalived;fi"

    interval 2
    fall 2
    rise 1
    weight -20
}

# 定义监控函数3
vrrp_script check_nginx3 {
    # 也可以放进sh脚本
    script "/data/sh/check_nginx.sh"

    interval 2
    fall 2
    rise 1
    weight -20
}
```

### notify 脚本

```bash
#!/bin/bash
# Author: hgzerowzh
# Description: An notify script

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

## 实战：lvs+keepalived双机热备

- [蜀道运维：解密LVS：构建高可用、高性能的负载均衡架构](https://mp.weixin.qq.com/s/zx2G5A4XP5koqPuebAyveA)

| 主机名     | IP             | 用途            |
|------------|----------------|-----------------|
| lvs-master | 192.168.59.130 | lvs、keepalived |
| lvs-backup | 192.168.59.134 | lvs、keepalived |
| rs1        | 192.168.59.131 | 后端服务器RS1   |
| rs2        | 192.168.59.132 | 后端服务器RS2   |

### 配置文件

- MASTER主机：192.168.110.4的`/etc/keepalived/keepalived.conf`

    ```
    ! Configuration File for keepalived

    # 全局配置
    global_defs {

       # 运行keepalived机器的标识
       router_id LVS_DEVEL
    }

    # VI_1
    vrrp_instance VI_1 {
        # 设置主机状态
        state MASTER

        # 对外提供服务的网络接口
        interface eth0

        # VRID标记，路由ID
        virtual_router_id 50

        # 优先级。优先级高的成为master
        priority 100

        # 非抢占模式
        nopreempt

        # 检查间隔。默认为1秒
        advert_int 1
        # 设置认证
        authentication {
            auth_type PASS # 认证方式
            auth_pass 1111 # 认证密码
        }

        # 设置VIP，可以有多个
        virtual_ipaddress {
            192.168.110.110
        }
    }

    # LB 配置
    virtual_server 192.168.110.110 80 {
      delay_loop 3                   # 设置健康状态检查时间
      lb_algo wrr                    # 调度算法，这里用了 wrr 轮询算法
      lb_kind DR                     # 这里测试用了 Direct Route 模式
      protocol TCP
      persistence_timeout 50 # 会话保持时间，这段时间内，同一ip发起的请求将被转发到同一个realserver
      real_server 192.168.110.6 80 {
          weight 1
          TCP_CHECK {
              connect_timeout 3
              retry 3　　　　　　     # 旧版本为 nb_get_retry
              delay_before_retry 3　　　
              connect_port 80
          }
      }
      real_server 192.168.110.7 80 {
          weight 1
          TCP_CHECK {
              connect_timeout 3
              retry 3
              delay_before_retry 3
              connect_port 80
          }
      }
    }
    ```

- BACKUP主机：192.168.110.5的`/etc/keepalived/keepalived.conf`

    ``` ! Configuration File for keepalived

    # 全局配置
    global_defs {

       # 运行keepalived机器的标识
       router_id LVS_DEVEL
    }

    # VI_1
    vrrp_instance VI_1 {
        # 设置主机状态
        state BACKUP

        # 对外提供服务的网络接口
        interface eth0

        # VRID标记，路由ID
        virtual_router_id 50

        # 优先级。优先级高的成为master
        priority 90

        # 非抢占模式
        nopreempt

        # 检查间隔。默认为1秒
        advert_int 1

        # 设置认证
        authentication {
            auth_type PASS # 认证方式
            auth_pass 1111 # 认证密码
        }

        # 设置VIP，可以有多个
        virtual_ipaddress {
            192.168.110.110
        }
    }

    # LB 配置
    virtual_server 192.168.110.110 80 {
      delay_loop 3                   # 设置健康状态检查时间
      lb_algo wrr                    # 调度算法，这里用了 wrr 轮询算法
      lb_kind DR                     # 这里测试用了 Direct Route 模式
      protocol TCP
      persistence_timeout 50 # 会话保持时间，这段时间内，同一ip发起的请求将被转发到同一个realserver
      real_server 192.168.110.6 80 {
          weight 1
          TCP_CHECK {
              connect_timeout 3
              retry 3　　　　　　     # 旧版本为 nb_get_retry
              delay_before_retry 3　　　
              connect_port 80
          }
      }
      real_server 192.168.110.7 80 {
          weight 1
          TCP_CHECK {
              connect_timeout 3
              retry 3
              delay_before_retry 3
              connect_port 80
          }
      }
    }
    ```

### ansible安装

- ansible文件`install-keepalived-双机热备.yml`配置

```yml
# MASTER
- hosts: 192.168.110.4
  remote_user: root

  tasks:
    - name: install keepalived
      yum: name=keepalived

    - name: copy config file
      copy: src=./keepalived-lvs-MASTER.conf  dest=/etc/keepalived/keepalived.conf backup=yes

    - name: start keepalived service
      service: name=keepalived state=started enabled=yes

# BACKUP
- hosts: 192.168.110.5
  remote_user: root

  tasks:
    - name: install keepalived
      yum: name=keepalived

    - name: copy config file
      copy: src=./keepalived-lvs-BACKUP.conf  dest=/etc/keepalived/keepalived.conf backup=yes

    - name: start keepalived service
      service: name=keepalived state=started enabled=yes
```

### 测试

```sh
# MASTER主机上，有192.168.110.110
root@centos7-3 ~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:9d:20:17 brd ff:ff:ff:ff:ff:ff
    inet 192.168.110.5/24 brd 192.168.110.255 scope global noprefixroute dynamic eth0
       valid_lft 3457sec preferred_lft 3457sec
    inet 192.168.110.110/32 brd 192.168.110.110 scope global eth0:0
       valid_lft forever preferred_lft forever
    inet 192.168.110.100/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::4e8b:c94c:c4dd:3902/64 scope link noprefixroute
       valid_lft forever preferred_lft forever

# BACKUP主机上，没有192.168.110.110
root@centos7-2 ~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:a0:db:94 brd ff:ff:ff:ff:ff:ff
    inet 192.168.110.4/24 brd 192.168.110.255 scope global noprefixroute dynamic eth0
       valid_lft 3270sec preferred_lft 3270sec
    inet 192.168.110.100/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::a530:2dd3:a173:41c2/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

```sh
curl http://192.168.110.110

# 手动模拟故障，在Master上关闭keepalived，实现ip漂移
systemctl stop keepalived

# 再次测试。
curl http://192.168.110.110
```


## 实战：nginx+keepalived双机热备

- 当主 nginx 服务器宕机之后，切换到备份的 nginx 服务器

- 同样的架构除了对nginx使用外，还可以对redis、mysql等使用

### 配置文件

- 主机1：192.168.110.4的`/etc/keepalived/keepalived.conf`

    ```
    ! Configuration File for keepalived

    # 全局配置
    global_defs {

       # 指定keepalived发生切换时发送email
       notification_email {
         name@163.com
       }
       # 指定发件人
       notification_email_from name@163.com

       # smtp服务器地址
       smtp_server 127.0.0.1
       # smtp超时时间
       smtp_connect_timeout 30
       # 运行keepalived机器的标识
       router_id LVS_DEVEL

       vrrp_skip_check_adv_addr
       # 严格遵守VRRP协议，这一项最好关闭，若不关闭，可用vip无法被ping通
       ! vrrp_strict
       vrrp_garp_interval 0
       vrrp_gna_interval 0
    }

    # VI_1
    vrrp_instance VI_1 {
        # 设置主机状态
        state MASTER

        # 对外提供服务的网络接口
        interface eth0

        # VRID标记，路由ID
        virtual_router_id 50

        # 优先级。优先级高的成为master
        priority 100

        # 非抢占模式
        nopreempt

        # 检查间隔。默认为1秒
        advert_int 5

        # 设置认证
        authentication {
            auth_type PASS # 认证方式
            auth_pass 1111 # 认证密码
        }

        # 设置VIP，可以有多个
        virtual_ipaddress {
            192.168.110.100
        }

        # 调用vrrp_script对集群进行监控
        track_script {
            # 使用监控函数1
            check_nginx
        }
    }

    # 定义监控函数
    vrrp_script check_nginx {

        # 通过pgrep判断进程是否存在（0表示不存在，1表示存在）。不存在就systemctl stop keepalived。如果使用killall keepalived，需要安装psmisc包
        # script "if [ `pgrep nginx | wc -l` -eq 0 ];then systemctl stop keepalived fi"
        # 判断进程是否存在。如果不存在就关闭keepalived。好让vip漂移到备份节点
        script "/etc/keepalived/nginx_check.sh"

        # 监控时间间隔2秒
        interval 2
        # 最大失败次数
        fall 2
        # 请求次数,判断节点是否正常
        rise 1
        # 当脚本执行成立，那么把当前服务器优先级改为-20
        weight -20
    }
    ```

- 主机2：192.168.110.5的`/etc/keepalived/keepalived.conf`

    ```
    ! Configuration File for keepalived

    # 全局配置
    global_defs {

       # 指定keepalived发生切换时发送email
       notification_email {
         name@163.com
       }
       # 指定发件人
       notification_email_from name@163.com

       # smtp服务器地址
       smtp_server 127.0.0.1
       # smtp超时时间
       smtp_connect_timeout 30
       # 运行keepalived机器的标识
       router_id LVS_DEVEL

       vrrp_skip_check_adv_addr
       # 严格遵守VRRP协议，这一项最好关闭，若不关闭，可用vip无法被ping通
       ! vrrp_strict
       vrrp_garp_interval 0
       vrrp_gna_interval 0
    }

    # VI_1
    vrrp_instance VI_1 {
        # 设置主机状态
        state BACKUP

        # 对外提供服务的网络接口
        interface eth0

        # VRID标记，路由ID
        virtual_router_id 50

        # 优先级。优先级高的成为master
        priority 90

        # 非抢占模式
        nopreempt

        # 检查间隔。默认为1秒
        advert_int 5

        # 设置认证
        authentication {
            auth_type PASS # 认证方式
            auth_pass 1111 # 认证密码
        }

        # 设置VIP，可以有多个
        virtual_ipaddress {
            192.168.110.100
        }

        # 调用vrrp_script对集群进行监控
        track_script {
            # 使用监控函数1
            check_nginx
        }
    }

    # 定义监控函数
    vrrp_script check_nginx {
        # 通过pgrep判断进程是否存在（0表示不存在，1表示存在）。不存在就systemctl stop keepalived。如果使用killall keepalived，需要安装psmisc包
        # script "if [ `pgrep nginx | wc -l` -eq 0 ];then systemctl stop keepalived fi"
        # 判断进程是否存在。如果不存在就关闭keepalived。好让vip漂移到备份节点
        script "/etc/keepalived/nginx_check.sh"

        # 监控时间间隔2秒
        interval 2
        # 最大失败次数
        fall 2
        # 请求次数,判断节点是否正常
        rise 1
        # 当脚本执行成立，那么把当前服务器优先级改为-20
        weight -20
        }
    ```

- `nginx_check.sh`
    ```sh
    #!/bin/bash

    # 方法1：判断进程是否存在，不存在尝试重启nginx，无法重启再杀死keepalived

    # if [ `pgrep nginx | wc -l` -eq 0 ];then
    #     /usr/sbin/nginx # 尝试重新启动nginx
    #     sleep 2         # 睡眠2秒
    #     if [ `pgrep nginx | wc -l` -eq 0 ];then
    #         # 启动失败，将keepalived服务杀死。将vip漂移到其它备份节点
    #         systemctl stop keepalived
              # 或者使用killall。如果使用killall命令，需要安装psmisc包
              # killall keepalived
    #     fi
    # fi

    # 方法2：判断进程是否存在，不存在直接杀死keepalived
    if [ `pgrep nginx | wc -l` -eq 0 ];then
        # 启动失败，将keepalived服务杀死。将vip漂移到其它备份节点
        systemctl stop keepalived
        # 或者使用killall。如果使用killall命令，需要安装psmisc包
        # killall keepalived
    fi
    ```

### ansible安装

- ansible文件`install-keepalived-双机热备.yml`配置

```yml
# MASTER
- hosts: 192.168.110.4
  remote_user: root

  tasks:
    - name: install keepalived
      yum: name=keepalived

    - name: copy config file
      copy: src=./keepalived-nginx-MASTER.conf  dest=/etc/keepalived/keepalived.conf backup=yes

    - name: copy nginx_check.sh
      copy: src=./nginx_check.sh  dest=/etc/keepalived/nginx_check.sh backup=yes

    - name: start keepalived service
      service: name=keepalived state=started enabled=yes

# BACKUP
- hosts: 192.168.110.5
  remote_user: root

  tasks:
    - name: install keepalived
      yum: name=keepalived

    - name: copy config file
      copy: src=./keepalived-nginx-BACKUP.conf  dest=/etc/keepalived/keepalived.conf backup=yes

    - name: copy nginx_check.sh
      copy: src=./nginx_check.sh  dest=/etc/keepalived/nginx_check.sh backup=yes

    - name: start keepalived service
      service: name=keepalived state=started enabled=yes
```

### 测试

```sh
# 记得关闭防火墙
curl http://192.168.110.100
# 进入主机1关闭nginx。??失败了。不管是killall keepalived还是systemctl stop keepalived命令在虚拟机上手动输入可以关闭keepalived。但在script和shell脚本里则无法关闭
systemctl stop nginx

# 关闭nginx后，再次测试。
curl http://192.168.110.100
```

## 实战：nginx+keepalived双主架构

- 双主架构：设置有2个vip地址，同时接受用户请求

    - 比主备架构的优势：主备架构始终有1台服务器处于空闲状态。无法更好将2太服务器利用起来

    ![image](./Pictures/lvs/nginx+keepalived双主架构.avif)

### 配置文件

- 两台主机都是设置一样的配置

- `/etc/keepalived/keepalived.conf`

```
! Configuration File for keepalived

# 全局配置
global_defs {

   # 指定keepalived发生切换时发送email
   notification_email {
     name@163.com
   }
   # 指定发件人
   notification_email_from name@163.com

   # smtp服务器地址
   smtp_server 127.0.0.1
   # smtp超时时间
   smtp_connect_timeout 30
   # 运行keepalived机器的标识
   router_id LVS_DEVEL

   vrrp_skip_check_adv_addr
   # 严格遵守VRRP协议，这一项最好关闭，若不关闭，可用vip无法被ping通
   ! vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

# VI_1
vrrp_instance VI_1 {
    # 设置主机状态
    state MASTER

    # 对外提供服务的网络接口
    interface eth0

    # VRID标记，路由ID
    virtual_router_id 50

    # 优先级。优先级高的成为master
    priority 100

    # 非抢占模式
    nopreempt

    # 检查间隔。默认为1秒
    advert_int 5

    # 设置认证
    authentication {
        auth_type PASS # 认证方式
        auth_pass 1111 # 认证密码
    }

    # 设置VIP，可以有多个
    virtual_ipaddress {
        192.168.110.100
    }

    # 调用vrrp_script对集群进行监控
    track_script {
        # 使用监控函数1
        check_nginx
    }
}


# VI_1
vrrp_instance VI_1 {
    # 设置主机状态
    state BACKUP

    # 对外提供服务的网络接口
    interface eth0

    # VRID标记，路由ID
    virtual_router_id 51

    # 优先级。优先级高的成为master
    priority 90

    # 非抢占模式
    nopreempt

    # 设置认证
    authentication {
        auth_type PASS # 认证方式
        auth_pass 2222 # 认证密码
    }

    # 设置VIP，可以有多个
    virtual_ipaddress {
        192.168.110.101
    }

    # 调用vrrp_script对集群进行监控
    track_script {
        # 使用监控函数1
        check_nginx
    }
}


# 定义监控函数
vrrp_script check_nginx {
    # 通过pgrep判断进程是否存在（0表示不存在，1表示存在）。不存在就systemctl stop keepalived。如果使用killall keepalived，需要安装psmisc包
    # script "if [ `pgrep nginx | wc -l` -eq 0 ];then systemctl stop keepalived fi"
    # 判断进程是否存在。如果不存在就关闭keepalived。好让vip漂移到备份节点
    script "/etc/keepalived/nginx_check.sh"

    # 监控时间间隔2秒
    interval 2
    # 最大失败次数
    fall 2
    # 请求次数,判断节点是否正常
    rise 1
}
```

### 测试

- 在主机1查看ip
```sh
root@centos7-2 ~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:a9:8e:e7 brd ff:ff:ff:ff:ff:ff
    inet 192.168.110.4/24 brd 192.168.110.255 scope global noprefixroute dynamic eth0
       valid_lft 3537sec preferred_lft 3537sec
    inet 192.168.110.101/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet 192.168.110.100/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::f7fa:3877:953c:64b5/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

- 在主机2查看ip
```
root@centos7-2 ~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:a0:db:94 brd ff:ff:ff:ff:ff:ff
    inet 192.168.110.5/24 brd 192.168.110.255 scope global noprefixroute dynamic eth0
       valid_lft 3050sec preferred_lft 3050sec
    inet 192.168.110.101/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet 192.168.110.100/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::a530:2dd3:a173:41c2/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

- 开启nginx后

```
curl http://192.168.110.100
curl http://192.168.110.101
```

## 实战：haproxy+keepalived双机热备

- 当主 haproxy 服务器宕机之后，切换到备份的 haproxy 服务器

### 配置文件

- 主机1：192.168.110.4的`/etc/keepalived/keepalived.conf`

    ```
    ! Configuration File for keepalived

    # 全局配置
    global_defs {

       # 指定keepalived发生切换时发送email
       notification_email {
         name@163.com
       }
       # 指定发件人
       notification_email_from name@163.com

       # smtp服务器地址
       smtp_server 127.0.0.1
       # smtp超时时间
       smtp_connect_timeout 30
       # 运行keepalived机器的标识
       router_id LVS_DEVEL

       vrrp_skip_check_adv_addr
       # 严格遵守VRRP协议，这一项最好关闭，若不关闭，可用vip无法被ping通
       ! vrrp_strict
       vrrp_garp_interval 0
       vrrp_gna_interval 0
    }

    # VI_1
    vrrp_instance VI_1 {
        # 设置主机状态
        state MASTER

        # 对外提供服务的网络接口
        interface eth0

        # VRID标记，路由ID
        virtual_router_id 50

        # 优先级。优先级高的成为master
        priority 100

        # 非抢占模式
        nopreempt

        # 检查间隔。默认为1秒
        advert_int 5

        # 设置认证
        authentication {
            auth_type PASS # 认证方式
            auth_pass 1111 # 认证密码
        }

        # 设置VIP，可以有多个
        virtual_ipaddress {
            192.168.110.100
        }

        # 调用vrrp_script对集群进行监控
        track_script {
            # 使用监控函数1
            check_haproxy
        }
    }

    # 定义监控函数
    vrrp_script check_haproxy {
        # 通过pgrep判断进程是否存在（0表示不存在，1表示存在）。不存在就systemctl stop keepalived。如果使用killall keepalived，需要安装psmisc包
        # script "if [ `pgrep nginx | wc -l` -eq 0 ];then systemctl stop keepalived fi"
        # 判断进程是否存在。如果不存在就关闭keepalived。好让vip漂移到备份节点
        script "/etc/keepalived/haproxy_check.sh"

        # 监控时间间隔2秒
        interval 2
        # 最大失败次数
        fall 2
        # 请求次数,判断节点是否正常
        rise 1
        # 当脚本执行成立，那么把当前服务器优先级改为-20
        weight -20
    }
    ```

- 主机2：192.168.110.5的`/etc/keepalived/keepalived.conf`

    ```
    ! Configuration File for keepalived

    # 全局配置
    global_defs {

       # 指定keepalived发生切换时发送email
       notification_email {
         name@163.com
       }
       # 指定发件人
       notification_email_from name@163.com

       # smtp服务器地址
       smtp_server 127.0.0.1
       # smtp超时时间
       smtp_connect_timeout 30
       # 运行keepalived机器的标识
       router_id LVS_DEVEL

       vrrp_skip_check_adv_addr
       # 严格遵守VRRP协议，这一项最好关闭，若不关闭，可用vip无法被ping通
       ! vrrp_strict
       vrrp_garp_interval 0
       vrrp_gna_interval 0
    }

    # VI_1
    vrrp_instance VI_1 {
        # 设置主机状态
        state BACKUP

        # 对外提供服务的网络接口
        interface eth0

        # VRID标记，路由ID
        virtual_router_id 50

        # 优先级。优先级高的成为master
        priority 90

        # 非抢占模式
        nopreempt

        # 检查间隔。默认为1秒
        advert_int 5

        # 设置认证
        authentication {
            auth_type PASS # 认证方式
            auth_pass 1111 # 认证密码
        }

        # 设置VIP，可以有多个
        virtual_ipaddress {
            192.168.110.100
        }

        # 调用vrrp_script对集群进行监控
        track_script {
            # 使用监控函数1
            check_haproxy
        }
    }

    # 定义监控函数
    vrrp_script check_haproxy {
        # 通过pgrep判断进程是否存在（0表示不存在，1表示存在）。不存在就systemctl stop keepalived。如果使用killall keepalived，需要安装psmisc包
        # script "if [ `pgrep nginx | wc -l` -eq 0 ];then systemctl stop keepalived fi"
        # 判断进程是否存在。如果不存在就关闭keepalived。好让vip漂移到备份节点
        script "/etc/keepalived/haproxy_check.sh"

        # 监控时间间隔2秒
        interval 2
        # 最大失败次数
        fall 2
        # 请求次数,判断节点是否正常
        rise 1
        # 当脚本执行成立，那么把当前服务器优先级改为-20
        weight -20
        }
    ```

- `haproxy_check.sh`
    ```sh
    #!/bin/bash

    # 方法1：判断进程是否存在，不存在尝试重启haproxy，无法重启再杀死keepalived

    # if [ `pgrep haproxy | wc -l` -eq 0 ];then
    #     /usr/sbin/haproxy # 尝试重新启动haproxy
    #     sleep 2         # 睡眠2秒
    #     if [ `pgrep haproxy | wc -l` -eq 0 ];then
    #         # 启动失败，将keepalived服务杀死。将vip漂移到其它备份节点
    #         systemctl stop keepalived
              # 或者使用killall。如果使用killall命令，需要安装psmisc包
              # killall keepalived
    #     fi
    # fi

    # 方法2：判断进程是否存在，不存在直接杀死keepalived
    if [ `pgrep haproxy | wc -l` -eq 0 ];then
        # 启动失败，将keepalived服务杀死。将vip漂移到其它备份节点
        systemctl stop keepalived
        # 或者使用killall。如果使用killall命令，需要安装psmisc包
        # killall keepalived
    fi
    ```

### ansible安装

- ansible文件`install-keepalived-双机热备.yml`配置

```yml
# MASTER
- hosts: 192.168.110.4
  remote_user: root

  tasks:
    - name: install keepalived
      yum: name=keepalived

    - name: copy config file
      copy: src=./keepalived-haproxy-MASTER.conf  dest=/etc/keepalived/keepalived.conf backup=yes

    - name: copy haproxy_check.sh
      copy: src=./haproxy_check.sh  dest=/etc/keepalived/haproxy_check.sh backup=yes

    - name: start keepalived service
      service: name=keepalived state=started enabled=yes

# BACKUP
- hosts: 192.168.110.5
  remote_user: root

  tasks:
    - name: install keepalived
      yum: name=keepalived

    - name: copy config file
      copy: src=./.keepalived-haproxy-BACKUP.conf  dest=/etc/keepalived/keepalived.conf backup=yes

    - name: copy haproxy_check.sh
      copy: src=./haproxy_check.sh  dest=/etc/keepalived/haproxy_check.sh backup=yes

    - name: start keepalived service
      service: name=keepalived state=started enabled=yes
```

### 测试

- 测试
```sh
curl http://192.168.110.100:80

# 进入主机1关闭haproxy。??失败了。不管是killall keepalived还是systemctl stop keepalived命令在虚拟机上手动输入可以关闭keepalived。但在script和shell脚本里则无法关闭
systemctl stop haproxy

# 再次测试
curl http://192.168.110.100:80
```

## 实战：redis+keepalived双机热备

- 当主 redis 服务器宕机之后，切换到备份的 redis 服务器

### 配置文件

- 主机1：192.168.110.4的`/etc/keepalived/keepalived.conf`

    ```
    ! Configuration File for keepalived

    # 全局配置
    global_defs {

       # 指定keepalived发生切换时发送email
       notification_email {
         name@163.com
       }
       # 指定发件人
       notification_email_from name@163.com

       # smtp服务器地址
       smtp_server 127.0.0.1
       # smtp超时时间
       smtp_connect_timeout 30
       # 运行keepalived机器的标识
       router_id LVS_DEVEL

       vrrp_skip_check_adv_addr
       # 严格遵守VRRP协议，这一项最好关闭，若不关闭，可用vip无法被ping通
       ! vrrp_strict
       vrrp_garp_interval 0
       vrrp_gna_interval 0
    }

    # VI_1
    vrrp_instance VI_1 {
        # 设置主机状态
        state MASTER

        # 对外提供服务的网络接口
        interface eth0

        # VRID标记，路由ID
        virtual_router_id 50

        # 优先级。优先级高的成为master
        priority 100

        # 非抢占模式
        nopreempt

        # 检查间隔。默认为1秒
        advert_int 5

        # 设置认证
        authentication {
            auth_type PASS # 认证方式
            auth_pass 1111 # 认证密码
        }

        # 设置VIP，可以有多个
        virtual_ipaddress {
            192.168.110.100
        }

        # 调用vrrp_script对集群进行监控
        track_script {
            # 使用监控函数1
            check_redis
        }
    }

    # 定义监控函数
    vrrp_script check_redis {
        # 通过pgrep判断进程是否存在（0表示不存在，1表示存在）。不存在就systemctl stop keepalived。如果使用killall keepalived，需要安装psmisc包
        # script "if [ `pgrep nginx | wc -l` -eq 0 ];then systemctl stop keepalived fi"
        # 判断进程是否存在。如果不存在就关闭keepalived。好让vip漂移到备份节点
        script "/etc/keepalived/redis_check.sh"

        # 监控时间间隔2秒
        interval 2
        # 最大失败次数
        fall 2
        # 请求次数,判断节点是否正常
        rise 1
        # 当脚本执行成立，那么把当前服务器优先级改为-20
        weight -20
    }
    ```

- 主机2：192.168.110.5的`/etc/keepalived/keepalived.conf`

    ```
    ! Configuration File for keepalived

    # 全局配置
    global_defs {

       # 指定keepalived发生切换时发送email
       notification_email {
         name@163.com
       }
       # 指定发件人
       notification_email_from name@163.com

       # smtp服务器地址
       smtp_server 127.0.0.1
       # smtp超时时间
       smtp_connect_timeout 30
       # 运行keepalived机器的标识
       router_id LVS_DEVEL

       vrrp_skip_check_adv_addr
       # 严格遵守VRRP协议，这一项最好关闭，若不关闭，可用vip无法被ping通
       ! vrrp_strict
       vrrp_garp_interval 0
       vrrp_gna_interval 0
    }

    # VI_1
    vrrp_instance VI_1 {
        # 设置主机状态
        state BACKUP

        # 对外提供服务的网络接口
        interface eth0

        # VRID标记，路由ID
        virtual_router_id 50

        # 优先级。优先级高的成为master
        priority 90

        # 非抢占模式
        nopreempt

        # 检查间隔。默认为1秒
        advert_int 5

        # 设置认证
        authentication {
            auth_type PASS # 认证方式
            auth_pass 1111 # 认证密码
        }

        # 设置VIP，可以有多个
        virtual_ipaddress {
            192.168.110.100
        }

        # 调用vrrp_script对集群进行监控
        track_script {
            # 使用监控函数1
            check_redis
        }
    }

    # 定义监控函数
    vrrp_script check_redis {
        # 通过pgrep判断进程是否存在（0表示不存在，1表示存在）。不存在就systemctl stop keepalived。如果使用killall keepalived，需要安装psmisc包
        # script "if [ `pgrep nginx | wc -l` -eq 0 ];then systemctl stop keepalived fi"
        # 判断进程是否存在。如果不存在就关闭keepalived。好让vip漂移到备份节点
        script "/etc/keepalived/redis_check.sh"

        # 监控时间间隔2秒
        interval 2
        # 最大失败次数
        fall 2
        # 请求次数,判断节点是否正常
        rise 1
        # 当脚本执行成立，那么把当前服务器优先级改为-20
        weight -20
        }
    ```

- `redis_check.sh`
    ```sh
    #!/bin/bash

    # 方法1：判断进程是否存在，不存在尝试重启redis，无法重启再杀死keepalived

    # if [ `pgrep redis | wc -l` -eq 0 ];then
    #     /usr/sbin/redis # 尝试重新启动redis
    #     sleep 2         # 睡眠2秒
    #     if [ `pgrep redis | wc -l` -eq 0 ];then
    #         # 启动失败，将keepalived服务杀死。将vip漂移到其它备份节点
    #         systemctl stop keepalived
              # 或者使用killall。如果使用killall命令，需要安装psmisc包
              # killall keepalived
    #     fi
    # fi

    # 方法2：判断进程是否存在，不存在直接杀死keepalived
    if [ `pgrep redis | wc -l` -eq 0 ];then
        # 启动失败，将keepalived服务杀死。将vip漂移到其它备份节点
        systemctl stop keepalived
        # 或者使用killall。如果使用killall命令，需要安装psmisc包
        # killall keepalived
    fi
    ```

### ansible安装

- ansible文件`install-keepalived-双机热备.yml`配置

```yml
# MASTER
- hosts: 192.168.110.4
  remote_user: root

  tasks:
    - name: install keepalived
      yum: name=keepalived

    - name: copy config file
      copy: src=./keepalived-redis-MASTER.conf  dest=/etc/keepalived/keepalived.conf backup=yes

    - name: copy redis_check.sh
      copy: src=./redis_check.sh  dest=/etc/keepalived/redis_check.sh backup=yes

    - name: start keepalived service
      service: name=keepalived state=started enabled=yes

# BACKUP
- hosts: 192.168.110.5
  remote_user: root

  tasks:
    - name: install keepalived
      yum: name=keepalived

    - name: copy config file
      copy: src=./.keepalived-redis-BACKUP.conf  dest=/etc/keepalived/keepalived.conf backup=yes

    - name: copy redis_check.sh
      copy: src=./redis_check.sh  dest=/etc/keepalived/redis_check.sh backup=yes

    - name: start keepalived service
      service: name=keepalived state=started enabled=yes
```

### 测试

- 在centos上如果是新安装的redis。需要做2步准备工作，才能远程连接redis

    - 1.redis配置文件`/etc/redis.conf`：需要设置`bind *`，不然只允许本机访问

        ```
        bind *
        ```

    - 2.防火墙需要开启6379端口

        ```sh
        # 查看redis的端口6379是否开启。no表示没有开启。
        firewall-cmd --query-port=6379/tcp

        # 开启端口。如果需要将规则保存至zone配置文件中，重启后也会自动加载，需要加入参数--permanent
        firewall-cmd --add-port=6379/tcp --permanent

        # 添加规则后需要重启防火墙
        firewall-cmd --reload
        ```

- 测试
```sh
# 连接redis
redis-cli 192.168.110.100

# 进入主机1关闭redis。??失败了。不管是killall keepalived还是systemctl stop keepalived命令在虚拟机上手动输入可以关闭keepalived。但在script和shell脚本里则无法关闭
systemctl stop redis

# 再次连接redis
redis-cli 192.168.110.100
```

## 实战：archlinux和centos7两台主机（这个实战有点旧了，简单看一下就好了）

- 负载均衡服务器配置

    ```sh
    # 设置vip
    ip a add 192.168.100.100/24 dev virbr0 label virbr0:0
    ```

- 后端服务器配置

    - 禁用 arp 对虚拟 ip 的响应

        ```bash
        cat >> /etc/sysctl.conf << 'EOF'
        net.ipv4.conf.eth0.arp_announce = 2
        net.ipv4.conf.eth0.arp_ignore = 1
        net.ipv4.conf.all.arp_announce = 2
        net.ipv4.conf.all.arp_ignore = 1
        EOF

        sysctl -p
        ```

    - 设置 lo 接口地址为虚拟 ip

        ```bash
        ip a add 192.168.100.100/24 dev lo
        ```

### 配置文件

- `/etc/keepalived/keepalived.conf`

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

# 可以自定义监控函数
# 定义监控函数1
vrrp_script check_nginx1 {
    # 通过pgrep判断进程是否存在（0表示不存在，1表示存在）。不存在就systemctl stop keepalived。如果使用killall keepalived，需要安装psmisc包
    script "if [ `pgrep nginx | wc -l` -eq 0 ];then systemctl stop keepalived fi"

    # 监控时间间隔2秒
    interval 2
    # 最大失败次数
    fall 2
    # 请求次数,判断节点是否正常
    rise 1
}

# 定义监控函数2
vrrp_script check_nginx2 {
    # 通过pid文件判断,进程是否存在
    script "if [ -f /var/run/nginx.pid ];then exit 0; else exit 1;fi"

    interval 2
    fall 2
    rise 1
}

# 定义监控函数3
vrrp_script check_nginx3 {
    # 也可以放进sh脚本
    script "/data/sh/check_nginx.sh"

    interval 2
    fall 2
    rise 1
}


# 调用vrrp_script对集群进行监控
track_script {
    # 使用监控函数1
    check_nginx1
}
```

### 测试

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

## reference

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


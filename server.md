<!-- vim-markdown-toc GFM -->

* [server(服务配置)](#server服务配置)
    * [系统优化](#系统优化)
        * [trim(统一文件系统与ssd删除)](#trim统一文件系统与ssd删除)
        * [irqbalance(中断分配多cpu)](#irqbalance中断分配多cpu)
        * [关闭按Control-Alt-Delete就重启](#关闭按control-alt-delete就重启)
    * [su, sudo](#su-sudo)
    * [openssh](#openssh)
        * [基本配置](#基本配置)
        * [使用ssh-agent 管理私钥, 自动进行远程连接](#使用ssh-agent-管理私钥-自动进行远程连接)
        * [快速连接](#快速连接)
        * [用户管理](#用户管理)
        * [pdsh(ssh 并行管理)](#pdshssh-并行管理)
        * [pssh](#pssh)
    * [服务(server)](#服务server)
        * [DNS](#dns)
            * [systemd-resolved (DNS over tls,cache server,LLMNR)](#systemd-resolved-dns-over-tlscache-serverllmnr)
        * [nfs](#nfs)
        * [proxy(代理)服务器](#proxy代理服务器)
            * [squid](#squid)
            * [stunnel](#stunnel)
        * [VPN](#vpn)
            * [openvpn](#openvpn)
            * [wireguard](#wireguard)
    * [安全(security)](#安全security)
        * [思路](#思路)
            * [以redis为例的服务检查](#以redis为例的服务检查)
            * [ssh](#ssh)
            * [重要文件加锁chattr -i](#重要文件加锁chattr--i)
            * [ntp(同步时间服务)](#ntp同步时间服务)
        * [关闭 core dump](#关闭-core-dump)
        * [selinux](#selinux)
        * [tcp_wrappers: 第二层防火墙](#tcp_wrappers-第二层防火墙)
        * [aide：保存当前文件的状态（新增的文件、修改时间、权限、文件哈希值），日后可以对比](#aide保存当前文件的状态新增的文件修改时间权限文件哈希值日后可以对比)
        * [metasploit](#metasploit)
        * [rkhunter: 检查 rookit](#rkhunter-检查-rookit)
        * [clamav: 病毒扫描](#clamav-病毒扫描)
        * [sqlmap: 自动检测和利用 SQL 注入漏洞，获得数据库服务器的权限。](#sqlmap-自动检测和利用-sql-注入漏洞获得数据库服务器的权限)
        * [beef: web渗透测试](#beef-web渗透测试)
        * [lynis（安全审计以及加固工具）](#lynis安全审计以及加固工具)
    * [系统监控](#系统监控)
        * [cockpit(系统监控的webui)](#cockpit系统监控的webui)
    * [自动化任务](#自动化任务)
        * [cron](#cron)
        * [anacron](#anacron)
        * [jenkins](#jenkins)
            * [jenkins-cli](#jenkins-cli)
            * [插件](#插件)
        * [Gitlab-CI](#gitlab-ci)
    * [Gitlab-CE](#gitlab-ce)
            * [安装](#安装)
    * [日志软件](#日志软件)
        * [logrotate（自带的日志分割工具）](#logrotate自带的日志分割工具)
        * [rsyslog](#rsyslog)

<!-- vim-markdown-toc -->

# server(服务配置)

## 系统优化

### trim(统一文件系统与ssd删除)

- 方法1: 修改`/etc/fstab`
```sh
# 在<options>, 加入discard
UUID=3453g54-6628-2346-8123435f  /home  xfs  defaults,discard   0 0
```

- 方法2: systemctl启动fstrim服务. 如果之前使用了方法1, 记得删除discard

```sh
# 每周一0点, 清理一次
systemctl enable fstrim.timer
systemctl start fstrim.timer
```

### irqbalance(中断分配多cpu)

- centos的默认中断分配服务

- 会根据系统的负载情况, 将中断分配到不同的cpu

```sh
systemctl status irqbalance
```

### 关闭按Control-Alt-Delete就重启

```sh
# 删除以下文件
rm /usr/lib/systemd/system/ctrl-alt-del.target

# 重新加载配置文件
init q
```

## su, sudo

- `/etc/sudoers` 

```
# sudo无需输入密码
tz ALL = NOPASSWD: ALL

# sudo cat /etc/shadow 此命令无需输入密码
tz ALL = NOPASSWD: /bin/cat /etc/shadow
```


- 禁止 wheel 组以外的用户使用 `su - root` 命令 
    ```sh
    # 在/etc/pam.d/su文件下配置
    auth sufficient pam_rootok.so
    auth required pam_wheel.so group=wheel
    ```
- 设置口令最大的出错次数 5 次，系统锁定后的解锁时间为 180 秒： 在`/etc/pam.d/system-auth` 和 `/etc/pam.d/password-auth` 文件中添加
    ```sh
    auth required pam_faillock.so preauth audit silent deny=5 unlock_time=180
    auth [success=1 default=bad] pam_unix.so
    auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=180
    auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=180
    ```

    - 测试
    ```sh
    # ssh登陆时输错密码

    # 查看锁定
    faillock

    # 解锁用户
    faillock --user username --reset
    ```


- 修改密码有效期

    - 相同的配置下 `/etc/shadow` 文件的优先级高于 `/etc/login.defs`

    | 参数          | 内容                       | 建议设置值 |
    |---------------|----------------------------|------------|
    | PASS_MAX_DAYS | 口令最大有效期             | 90         |
    | PASS_MIN_DAYS | 两次修改口令的最小间隔时间 | 10         |
    | PASS_WARN_AGE | 口令过期前开始提示天数     | 7          |

    ```sh
    # 在/etc/login.defs文件下修改

    # 修改前
    PASS_MAX_DAYS	99999
    PASS_MIN_DAYS	0
    PASS_MIN_LEN	5
    PASS_WARN_AGE	7

    # 修改后
    PASS_MAX_DAYS	90
    PASS_MIN_DAYS	10
    PASS_MIN_LEN	5
    PASS_WARN_AGE	7
    ```

- 设置密码复杂度：

    | 参数         | 内容                      |
    |--------------|---------------------------|
    | minlen = 8   | 口令长度至少包含 8 个字符 |
    | dcredit = -1 | 口令包含N个数字           |
    | ucredit = -1 | 口令包含N大写字母         |
    | ocredit = -1 | 口令包含N个特殊字符       |
    | lcredit = -1 | 口令包含N个小写字母       |

    - 在`/etc/pam.d/password-auth` 和`/etc/pam.d/system-auth` 未配置 minlen、dcredit、ucredit、ocredit、lcredit 时，`/etc/security/pwquality.conf` 文件设置才会生效
    ```sh
    cat >>/etc/security/pwquality.conf << EOF
    minlen = 8
    dcredit = -1
    ucredit = -1
    ocredit = -1
    lcredit = -1
    EOF
    ```


## openssh

> 默认为22端口, 安全起见可更改为其它端口.如8022

### 基本配置

- 服务器公钥保存路径: `~/.ssh/authorized_keys`

- 注意:服务端`authorized_keys`和客户端`私钥文件`权限必须是**600**

```sh
# 生成密钥
ssh-keygen -t rsa

# 添加公钥到远程服务器
ssh user@ip 'mkdir -p .ssh && cat >> .ssh/authorized_keys' < ~/.ssh/id_rsa.pub
# or 使用ssh-copy-id -i
sudo ssh-copy-id -i ~/.ssh/id_rsa.pub ip
```

### 使用ssh-agent 管理私钥, 自动进行远程连接

```sh
# 启动ssh-agent
eval `ssh-agent -s`

# 添加私钥
ssh-add /tmp/id_rsa

# 查看私钥
ssh-add -L
```

### 快速连接

- 配置`~/.ssh/config`文件:

| ssh option   | 内容                       |
|--------------|----------------------------|
| IdentityFile | 私钥路径                   |
| Compression  | 启动压缩(会对性能产生影响) |

```sh
Host centos7
  HostName 192.168.100.208
  User root
  Port 22
  IdentityFile ~/.ssh/id_rsa
  Compression yes

Host opensuse
  HostName 192.168.100.71
  User root
  Port 22
  IdentityFile ~/.ssh/id_rsa
  Compression yes
```

- 配置好后,即可`ssh Host`连接:

```sh
ssh centos7
ssh opensuse
```

### 用户管理

- 配置`/etc/ssh/sshd_config`文件:

```
AllowUsers user1 user2
```

### [pdsh(ssh 并行管理)](https://github.com/chaos/pdsh)

- 支持正则表达式

- 复制文件到多个 ssh 的主机时,需要两边都安装 pdsh(因此建议使用 pssh)

```bash
git clone https://github.com/chaos/pdsh.git
cd pdsh

# 配置
# 自动将主机信息写入/etc/pdsh/machines
# 开启分组管理
./configure --with-machines=/etc/pdsh/machines \
            --with-dshgroups

# 编译,安装
make -j$(nproc) && make install
```

```bash
# 设置变量
centos7="root@192.168.100.208"
opensuse="root@192.168.100.71"

# -w 指定主机,运行 uptime 命令
pdsh -w $centos7,$opensuse "uptime"

# 效果同上,[71,208]指定71和208
pdsh -w "root@192.168.100.[71,208]" "uptime"

# [1-254]指定整个子网
pdsh -w "root@192.168.100.[1-254]" "uptime"

# 进入交互模式
pdsh -R ssh -w $centos7
```

### [pssh](https://github.com/robinbowes/pssh)

- 需要将 ssh 主机写入文件,才能并行执行命令

```bash
# 设置变量
centos7="root@192.168.100.208"
opensuse="root@192.168.100.71"

# centos7上执行uptime
pssh -H $centos7 -P uptime

# 生成ssh主机的文件
echo $centos7 > /etc/pssh/hosts
echo $opensuse >> /etc/pssh/hosts

# 通过文件,执行命令
pssh -i -h /etc/pssh/hosts "uptime"
# -O "StrictHostKeyChecking=no" 不需要每次手动输入yes
pssh -i -O "StrictHostKeyChecking=no" -h /etc/pssh/hosts "uptime"

# prsync将当前file文件,复制到tmp目录(等同于rsync)
prsync -h /etc/pssh/hosts -l opsuser -a -r file /tmp

# pslurp将远程主机的/tmp/file文件,复制到家目录并改名为newname
pslurp -h /etc/pssh/hosts -r -L ~ \
/tmp/file newname

# pnuke杀掉nginx进程(类似于pkill)
pnuke -h /etc/pssh/hosts nginx
```

- [wishlist: tui](https://github.com/charmbracelet/wishlist)

## 服务(server)

### DNS

#### systemd-resolved (DNS over tls,cache server,LLMNR)

- [arch wiki](https://wiki.archlinux.org/index.php/Systemd-resolved)

- 配置文件 `/etc/systemd/resolved.conf`

```bash
# 启动
systemctl enable systemd-resolved.service
systemctl start systemd-resolved.service

# 查看状态
resolvectl status

# 测试是否开启DNSSEC
resolvectl query sigok.verteiltesysteme.net

# 查找baidu.com的ip(类似于nslookup)
resolvectl query baidu.com

# 查看统计数据(缓存)
systemd-resolve --statistics

# 测试是否开启dns over tls
ngrep port 853
```

### nfs

两端安装 nfs

```bash
yum install -y nfs-utils
```

- server:

只允许 `192.168.100.0/24` 访问

```bash
cat >> /etc/exports <<'EOF'
root/test      192.168.100.0/24(rw,sync)
EOF

# 更新
exportfs -arv

# 更新nfs
systemctl reload nfs
```

- clinent:

```bash
mount 192.168.100.208:/root/test test
```

### proxy(代理)服务器

#### squid

- [教程文档](https://phoenixnap.com/kb/setup-install-squid-proxy-server-ubuntu)

- 配置文件：`/etc/squid/squid.conf`

```
# 设置代理端口8080
http_port 8080
```

- 启动squid服务
```sh
systemctl start squid
```

- 测试
```sh
curl --proxy http://127.0.0.1:8080 www.baidu.com
```

#### stunnel

- [教程文档](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-ssl-tunnel-using-stunnel-on-ubuntu)

- server端配置文件:`/etc/stunnel/stunnel.conf`

```
# client = no并非必要，只是stunnel默认为server模式
client = no

# ssl证书路径
cert = /etc/stunnel/stunnel.pem

[squid]
# 监听端口
accept = 8888

# squid端口
connect = 127.0.0.1:8081
```

- client端配置文件:`/etc/stunnel/stunnel-client.conf`

```
client = yes

# ssl证书路径
cert = /etc/stunnel/stunnel.pem

[squid]
# stunnel client监听端口
accept = 127.0.0.1:1234

# stunnel server端口
connect = 127.0.0.1:8888
```

- 生成ssl证书
```sh
# 创建私钥
openssl genrsa -out key.pem 2048

# 使用私钥生成证书
openssl req -new -x509 -key key.pem -out cert.pem -days 1095

# 合并私钥和证书为stunnel.pem
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
```

- 测试
```sh
# 启动stunnel server
systemctl start stunnel

# 启动 squid
systemctl start squid

# 启动stunnel client
stunnel /etc/stunnel/stunnel-client.conf

# 测试
curl --proxy http://127.0.0.1:1234 www.baidu.com
```

### VPN

#### openvpn

```sh
cp /usr/share/openvpn/examples/server.conf /etc/openvpn/server/server.conf
```

- 安装easyrsa
```sh
pacman -S easy-rsa

# 初始化pki
easyrsa init-pki

# 生成ca
easyrsa build-ca
cp pki/ca.crt /etc/openvpn/server

# 生成servername.req servername.key
easyrsa gen-req servername nopass
cp pki/private/servername.key /etc/openvpn/server

# 生成Diffie-Hellman（DH）参数文件
openssl dhparam -out /etc/openvpn/server/dh.pem 2048

# 生成HMAC(哈希消息认证码)密钥
openvpn --genkey secret /etc/openvpn/server/ta.key
```

#### wireguard

- [Getting Started with WireGuard](https://miguelmota.com/blog/getting-started-with-wireguard/)

- 从 2020 年 1 月开始，它已经并入了 Linux 内核的 5.6 版本

- wireguard是组网的『乐高积木』，就像 ZFS 是构建文件系统的『乐高积木』一样。

- Linus Torvalds在邮件中称其为一件艺术品：work of art

    > Can I just once again state my love for it and hope it gets merged soon? Maybe the code isn't perfect, but I've skimmed it, and compared to the horrors that are OpenVPN and IPSec, it's a work of art.
    > 我能再说一次我非常喜欢它并且希望它能尽快并入内核么？或许代码不是最完美的，但是我大致浏览了一下，和OpenVPN、IPSec的恐怖相比，它就是一件艺术品。

-  OpenVPN：大约有 10 万行代码；WireGuard 只有大概 4000 行代码
![image](./Pictures/server/wireguard.avif)

- 服务端（server）：

    - 安装
    ```sh
    yum install -y wireguard-tools
    ```

    - 生成公私钥
    ```sh
    mkdir /etc/wireguard/keys
    cd /etc/wireguard/keys
    umask 077

    # 同时生成公私钥
    wg genkey | tee privatekey | wg pubkey > publickey
    ```

    - 配置文件
    ```sh
    # ini格式
    touch /etc/wireguard/wg0.conf

    [Interface]
    PrivateKey = <server private key>
    Address = 10.0.0.1/24
    ListenPort = 51820

    ; NAT则需要设置iptables
    PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

    PublicKey = <client public key>
    AllowedIPs = 10.0.0.2/32
    ```

    - 开启转发ip数据包
    ```sh
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    sysctl -p
    ```

    - 配置网卡 + 启动wireguard
    ```sh
    # 新建wireguard网卡, kernel必须大于5.6
    ip link add wg0 type wireguard
    wg setconf wg0 /dev/fd/63
    ip -4 address add 10.0.0.1/24 dev wg0
    ip link set mtu 8921 up dev wg0
    iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

    # 启动wireguard
    wg-quick up wg0

    # 开机自启动
    systemctl enable wg-quick@wg0.service
    ```

- 客户端（client）：
    - 安装
    ```sh
    pacman -S wireguard-tools wireguard-dkms
    ```

    - 生成公私钥（和服务端一样）
    ```sh
    mkdir /etc/wireguard/keys
    cd /etc/wireguard/keys
    umask 077

    # 同时生成公私钥
    wg genkey | tee privatekey | wg pubkey > publickey
    ```

    - 配置文件
    ```sh
    touch /etc/wireguard/wg0.conf

    [Interface]
    Address = 10.0.0.2/32
    PrivateKey = <client private key>
    DNS = 1.1.1.1

    [Peer]
    PublicKey = <server public key>
    Endpoint = <server public ip>:51820
    AllowedIPs = 0.0.0.0/0

    ; 如果服务端开启了NAT，不能访问公共ip，则需要开启PersistentKeepalive（定期的心跳机制）
    PersistentKeepalive = 25
    ```

    - 启动wireguard
    ```sh
    wg-quick up wg0
    ```

## 安全(security)

### 思路

#### 以redis为例的服务检查

- 检查端口是否有暴露

```sh
# 查看本不应该对外暴露的服务redis, 是否监听0.0.0.0
netstat -antlp
# 查看INPUT链是否有暴露端口
iptables -L -n

# 扫描redis端口6379
nmap -A -p 6379 -script redis-info 127.0.0.1
```

- 使用普通用户, 而不是root启动redis

- redis配置文件加入密码验证

    ```
    # redis.conf
    requirepass password
    ```

#### ssh

- 修改密钥权限
```sh
# 设置为只读
chmod 400 ~/.ssh/authorized_keys

# 加入i特殊权限, 即使是root用户也无法修改和删除
chattr +i ~/.ssh/authorized_keys
```

- 修改`/etc/ssh/sshd_config`
```
# 修改默认端口
Port 22221

# 禁止root登陆
PermitRootLogin no

# 不使用dns反查, 提高ssh连接速度
UseDNS no
```

#### 重要文件加锁chattr -i

- `chattr -i` 不能修改和删除文件
```sh
chattr -i /etc/sudoers
chattr -i /etc/shadow
chattr -i /etc/passwd
chattr -i /etc/grub.conf
```

- `chattr -a` 只能添加内容
```sh
# 适用于日志
chattr -i /var/log/lastlog
```

#### ntp(同步时间服务)

- 如果超过100台服务器, 建议搭建一台ntp服务器

- 如果少则可以, 通过cron计划任务同步
    ```sh
    # 每小时同步1次. 写入日志, 并将系统时间同步到硬件时间
    10 * * * * /usr/sbin/ntpdate ntp1.aliyun.com >> /var/log/ntp.log 2>&1; /sbin/hwclock -w
    ```

```sh
systemctl enable ntpd
```

### 关闭 core dump

```sh
echo -e "\n* soft core 0" >> /etc/security/limits.conf 
echo -e "\n* hard core 0" >> /etc/security/limits.conf 
```

### selinux

- 三种状态:
    - enforcing: 开启
    - permissive: 提醒
    - disabled: 关闭

```sh
# 查看selinux状态
sestatus

# 临时关闭selinux
setenforce 0
```

- 永久关闭selinux 修改配置文件`/etc/selinux/config`

```
SELINUX=disabled
```

### tcp_wrappers: 第二层防火墙

> tcp_wrappers 为第二层防火墙, iptables 为第一层防火墙

- 两个配置文件 `/etc/hosts.allow` `/etc/hosts.deny` 


    - 先检查`/etc/hosts.allow`如果条件满足, 就不会去检查`/etc/hosts.deny`

```
# sshd服务允许/拒绝192.168.1.1
sshd: 192.168.1.1

# sshd服务允许/拒绝所有主机
sshd: ALL

# ALL表示所有服务
ALL: 192.168.1.1

# ALL EXCEPT表示除了192.168.1.1之外
ALL:ALL EXCEPT 192.168.1.1
```

- 可以配置好`/etc/hosts.allow`后, 配置`/etc/hosts.deny`
    ```
    # /etc/hosts.deny
    sshd:ALL
    ```


### aide：保存当前文件的状态（新增的文件、修改时间、权限、文件哈希值），日后可以对比

```sh
# 生成数据库，时间比较长
aide -i

# 改名
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

# 把现在的文件对比之前保存的状态，时间比较长
aide -C
```

### [metasploit](https://github.com/rapid7/metasploit-framework)

```sh
# 启动控制台
msfconsole

# 查看模块
show exploits

# 查看辅助模块
show auxiliary

# 搜索kvm模块
search kvm

# 查看当前模块负载
show payloads
```

### rkhunter: 检查 rookit

> 检测基本的文件, 文件的权限, 内核模块等

- [archwiki](https://wiki.archlinux.org/index.php/Rkhunter)

- rookit

    - 1.文件级别rookit:

        - 通过软件漏洞, 从而替换命令文件. 比方说/bin/login命令, 每个用户登陆都会执行该命令, 替换后从而获取密码

    - 2.内核级别rookit:

        - 可以修改内核, 从而劫持api, 使本是执行a程序, 变为执行b程序

```bash
# 更新数据库
sudo rkhunter --update

# 检查
sudo rkhunter --check
```

### clamav: 病毒扫描

```sh
# 更新病毒库
sudo freshclam

# 扫描根目录, 发现病毒就响动
clamscan -r --bell -i /

# 扫描根目录, 并删除感染文件
clamscan -r --remove /
```

### [sqlmap: 自动检测和利用 SQL 注入漏洞，获得数据库服务器的权限。](https://github.com/sqlmapproject/sqlmap)

### [beef: web渗透测试](https://github.com/beefproject/beef)

### lynis（安全审计以及加固工具）

```sh
# 扫描系统
lynis audit system
```

## 系统监控

### cockpit(系统监控的webui)

- port: 9090

```sh
systemctl enable cockpit.socket
systemctl start cockpit.socket

# 防火墙设置
firewall-cmd --add-service=cockpit --permanent
```

## 自动化任务

### cron

- 查看任务

```sh
sudo cat /var/spool/cron/root
```

```bash
# 开启服务
systemctl start cronie.service
```

- [在线计算工具](https://tool.lu/crontab/)

```bash
# .---------------- 分 (0 - 59)
# |  .------------- 时 (0 - 23)
# |  |  .---------- 日 (1 - 31)
# |  |  |  .------- 月 (1 - 12)
# |  |  |  |  .---- 星期 (0 - 7) (星期日可为0或7)
# |  |  |  |  |
# *  *  *  *  * 执行的命令
```

- `sudo crontab -e` #编辑 root 的任务
- `crontab -e` #编辑当前用户的任务
- `crontab -l` #显示任务
- `crontab -r` #删除所有任务

```
* * * * * COMMAND      # 每分钟
*/5 * * * * COMMAND    # 每5分钟

0 * * * * COMMAND      # 每小时
0,5,10 * * * * COMMAND # 每小时运行三次，分别在第 0、 5 和 10 分钟运行

0 0 * * * COMMAND      # 每日凌晨0点执行
0 3 * * * COMMAND      # 每日凌晨3点执行

0 0 1 * * COMMAND      # 每月1号0点执行
0 3 1-10 * * COMMAND   # 每月1日到10日凌晨3点执行

0 0 * * 1 COMMAND      # 每周一0点执行
```

### anacron

- 配置文件: `/etc/anacrontab`

| cron                         | anacron                                                              |
| ---------------------------- | -------------------------------------------------------------------- |
| 它是守护进程                 | 它不是守护进程                                                       |
| 适合服务器                   | 适合桌面/笔记本电脑                                                  |
| 可以让你以分钟级运行计划任务 | 只能让你以天为基础来运行计划任务                                     |
| 关机时不会执行计划任务       | 如果计划任务到期，机器是关机的，那么它会在机器下次开机后执行计划任务 |
| 普通用户和 root 用户         | 只有 root 用户可以使用（使用特定的配置启动普通任务）                 |

```
7	5	cron.weekly	/bin/bash /home/user/.mybin/logs.sh
```

```bash
# 测试配置
anacron -T

# 启动
anacron -d
```

### jenkins

- 默认端口: `http://127.0.0.1:8090/`

- 项目路径: `/var/lib/jenkins/workspace/项目名`

#### jenkins-cli

```sh
# 下载jenkins-cli.jar
curl -LO http://127.0.0.1:8090/jnlpJars/jenkins-cli.jar

# 执行help命令
java -jar jenkins-cli.jar -s http://127.0.0.1:8090/ -webSocket -auth user:passwd help

# 启动名为test的任务
java -jar jenkins-cli.jar -s http://127.0.0.1:8090/ -webSocket -auth user:passwd enable-job test

# 获取test任务的xml
java -jar jenkins-cli.jar -s http://127.0.0.1:8090/ -webSocket -auth user:passwd get-job test
```

#### 插件

- [插件搜索](https://plugins.jenkins.io/)

### Gitlab-CI

- [岁寒博客：初创公司 CI 系统终极解决方案：gitlab-ci]()

- Continuous Integration，持续集成，本意是指编写大量的单元测试和集成测试，在尽量小的代码变更粒度上进行 提交 -> 测试 -> 自动部署 的完整流程。

    - 因为测试很难覆盖所有业务场景特别是前端场景，而且测试只会在最重要的地方存在，因为写测试理论上讲比写业务逻辑更费时间，而且枯燥。

    - 所以，中国互联网界的 CI 多数只有两个目的：① 跑测试保证核心模块质量顺便消灭低级错误 ② APP 打包。

- CI 基本原理
    - 检测到 git 有新的代码提交（定时检测或主动触发），生成任务
    - agent（真正干活的进程，可以分布在多台机器） 领取任务，拉取代码，运行一段脚本（无论是单元测试还是 APP 打包，都可以用脚本完成）
    - 展示结果：成功与否、测试覆盖率、apk ipa 下载链接等

- Gitlab-CI

    - 优点：

        - Gitlab-CI 是 Gitlab 自带的持续集成引擎，免去了第三方 CI 服务器只能定时检测 git 仓库带来的延迟和对 git server 造成的性能压力。我司弃用 oschina 的原因就是 CI 服务器一分钟检测一次，压力太大导致仓库被封。

        - 触发成本低，系统已经提供了完善的触发功能
        - 结果直接展示在 Gitlab 页面上的多个地方：成功/失败，测试覆盖率等
        - 无需复杂配置。（Jenkins 的页面逻辑太落后了，极其的复杂。TeamCity 我本以为配置算简单的，直到我用上了 Gitlab-CI）
            - yaml 语言描述的 CI 配置，很容易读懂

    - 缺点：

        - 资源消耗过高。它需要 2G 内存机器，而且在 pull 或 push 的瞬间磁盘 IO 相当高，部署在阿里云会直接导致虚拟机假死，只适合内存大，磁盘强的物理机部署。

        - 必须使用 Gitlab

## Gitlab-CE

- [hellogitlab：GitLab的安装和配置](https://hellogitlab.com/CI/gitlab/)

- GitLab Runner：如果有多台服务器的话，不建议将GitLab Runner安装在GitLab服务器上，运行GitLab Runner可能消耗大量内存。

#### 安装

- yum安装

- 新建一个gitlab的repo
    ```sh
    cat > /etc/yum.repos.d/gitlab-ce.repo << EOF
    [gitlab-ce]
    name=Gitlab CE Repository
    # 清华源
    baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el\$releasever/
    gpgcheck=0
    enabled=1
    EOF
    ```

    ```sh
    # 查找yum源中gitlab-ce的版本
    yum list gitlab-ce --showduplicates

    # 安装需要的版本
    yum install -y gitlab-ce-16.8.1
    ```

- 手动下载安装

    ```sh
    # 下载
    wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-16.8.1-ce.0.el7.x86_64.rpm

    # 安装
    rpm -ivh gitlab-ce-16.8.1-ce.0.el7.x86_64.rpm
    ```

- 配置文件：`/etc/gitlab/gitlab.rb`
    ```sh
    # 先备份配置文件
    cp /etc/gitlab/gitlab.rb /etc/gitlab/gitlab.rb.bak
    ```

    ```
    # gitlab访问地址。内网主机的 ip 地址
    external_url 'http://gitlab.example.com'

    # 设置为tcp,而不是unix
    gitlab_workhorse['listen_network'] = "tcp"

    # ip和端口
    gitlab_workhorse['listen_addr'] = "127.0.0.1:8181"

    # 将IP子网段添加到可信代理中
    gitlab_rails['trusted_proxies'] = ['127.0.0.1']

    # git仓库路径。记得mkdir /root/gitlab-gitdir
    git_data_dirs({
      "default" => {
        "path" => "/root/gitlab-gitdir"
       }
    })

    # 设置时区为上海
    gitlab_rails['time_zone'] = 'Asia/Shanghai'

    # 设置邮箱
    gitlab_rails['gitlab_email_enabled'] = true
    # 设置自己的邮箱
    gitlab_rails['gitlab_email_from'] = 'mzh_love_linux@163.com'
    gitlab_rails['gitlab_email_display_name'] = 'Example'
    # 设置自己的邮箱
    gitlab_rails['gitlab_email_reply_to'] = 'mzh_love_linux@163.com'
    gitlab_rails['gitlab_email_subject_suffix'] = '[GitLab]'

    # 设置smtp
    gitlab_rails['smtp_enable'] = true
    gitlab_rails['smtp_address'] = "smtp.163.com"
    gitlab_rails['smtp_port'] = 465
    gitlab_rails['smtp_user_name'] = "mzh_love_linux@163.com"
    gitlab_rails['smtp_password'] = "authCode"  # <--- 说明：先在邮箱设置中开启客户端授权码，防止密码泄露，此处填写网易邮箱的授权码，不要填写真实密码
    gitlab_rails['smtp_domain'] = "163.com"
    gitlab_rails['smtp_authentication'] = "login"
    gitlab_rails['smtp_enable_starttls_auto'] = true
    gitlab_rails['smtp_tls'] = true

    # 禁止用户修改用户名
    gitlab_rails['gitlab_username_changing_enabled'] = true

    # Git用户和组信息
    user['username'] = "git"
    user['group'] = "git"
    user['home'] = "/home/git"
    user['git_user_name'] = "GitLab"
    user['git_user_email'] = "mzh_love_linux@163.com"

    # web服务器
    web_server['external_users'] = ['nginx', 'root']
    web_server['username'] = 'nginx'
    web_server['group'] = 'nginx'

    # 默认自带了nginx，不需要手动配置。以下为禁用gitlab自带的nginx
    nginx['enable'] = false
    ```

- 配置nginx集成gitlab

- 启动gitlab和nginx
    ```sh
    # 加载配置
    systemctl start gitlab-runsvdir
    gitlab-ctl reconfigure

    # 启动gitlab
    gitlab-ctl start

    # 启动nginx
    systemctl start nginx
    ```

## 日志软件

- [小米技术：Linux日志服务初识]()

- [Linux开源日志分析](https://cloud.tencent.com/developer/inventory/116450)

| 路径             | 描述                                                                                                                         |
|------------------|------------------------------------------------------------------------------------------------------------------------------|
| /var/log/message | 核心系统日志文件，包含系统启动引导，系统运行状态和大部分错误信息等都会记录到这个文件，因此这个日志是故障诊断的首要查看对象。 |
| /var/log/dmesg   | 核心启动日志，系统启动时会在屏幕显示与硬件有关的信息，这些信息会保存在这个文件里面。                                         |
| /var/log/secure  | 验证，授权和安全日志，常见的用户登录验证相关日志就存放在这里。                                                               |
| /var/log/spooler | UUCP和news设备相关的日志信息                                                                                                 |
| /var/log/cron    | 与定时任务相关的日志信息                                                                                                     |
| /var/log/maillog | 记录每一个发送至系统或者从系统发出的邮件活动                                                                                 |
| /var/log/boot    | 系统引导日志                                                                                                                 |

### logrotate（自带的日志分割工具）

- 默认配置`/etc/logrotate.conf`
```
# 按周轮训
weekly

# 保留4周日志备份
rotate 4

# 标记分割日志并创建当前日志
create

# 使用时间作为后缀
dateext

# 对 logrotate.d 目录下面的日志种类使用
include /etc/logrotate.d

# 对于wtmp 和 btmp 日志处理在这里进行设置
/var/log/wtmp {
    monthly
    create 0664 root utmp
 minsize 1M
    rotate 1
}
/var/log/btmp {
    missingok
    monthly
    create 0600 root utmp
    rotate 1
}
```
### rsyslog

- [前端日志展示工具 loganalyzer，其利用的工具有 httpd，php和mysql。](https://github.com/rsyslog/loganalyzer)

- rsyslog 是syslog 的升级版

- 两种配置模式：

    - 1.客户端-服务器：客户端发送日志到服务器

    - 2.服务器-远程服务器：服务器在网络收集主机的日志，发送到远程服务器

- 客户端-服务器模式：

    - 服务器配置：
        ```sh
        # 取消这2行注释，开启udp514端口
        $ModLoad imudp
        $UDPServerRun 514

        # 在$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat下面添加这5行
        # 根据客户端的IP单独存放主机日志在不同目录，设置远程日志存放路径及文件名格式
        $template Remote,"/var/log/syslog/%fromhost-ip%/%fromhost-ip%_%$YEAR%-%$MONTH%-%$DAY%.log"

        # 排除本地主机IP日志记录，只记录远程主机日志
        :fromhost-ip, !isequal, "127.0.0.1" ?Remote
        ```

    - 客户端配置：
        ```sh
        # 取消这5行注释
        $ActionQueueFileName fwdRule1
        $ActionQueueMaxDiskSpace 1g
        $ActionQueueSaveOnShutdown on
        $ActionQueueType LinkedList
        $ActionResumeRetryCount -1

        # 在最后一行添加服务器IP地址。@表示使用udp
        *.* @192.168.31.80
        ```


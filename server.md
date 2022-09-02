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
        * [openvpn](#openvpn)
    * [安全(security)](#安全security)
        * [思路](#思路)
            * [以redis为例的服务检查](#以redis为例的服务检查)
            * [ssh](#ssh)
            * [重要文件加锁chattr -i](#重要文件加锁chattr--i)
            * [ntp(同步时间服务)](#ntp同步时间服务)
        * [selinux](#selinux)
        * [tcp_wrappers: 第二层防火墙](#tcp_wrappers-第二层防火墙)
        * [metasploit](#metasploit)
        * [rkhunter: 检查 rookit](#rkhunter-检查-rookit)
        * [clamav: 病毒扫描](#clamav-病毒扫描)
        * [sqlmap: sql注入](#sqlmap-sql注入)
        * [beef: web渗透测试](#beef-web渗透测试)
    * [系统监控](#系统监控)
        * [cockpit(系统监控的webui)](#cockpit系统监控的webui)
    * [自动化任务](#自动化任务)
        * [cron](#cron)
        * [anacron](#anacron)
        * [jenkins](#jenkins)
            * [jenkins-cli](#jenkins-cli)
            * [插件](#插件)

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

### openvpn

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

### [sqlmap: sql注入](https://github.com/sqlmapproject/sqlmap)

### [beef: web渗透测试](https://github.com/beefproject/beef)

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

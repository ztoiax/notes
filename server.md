<!-- vim-markdown-toc GFM -->

* [server(服务配置)](#server服务配置)
    * [openssh](#openssh)
        * [基本配置](#基本配置)
        * [使用ssh-agent 管理私钥, 自动进行远程连接](#使用ssh-agent-管理私钥-自动进行远程连接)
        * [快速连接](#快速连接)
    * [pdsh(ssh 并行管理)](#pdshssh-并行管理)
    * [pssh](#pssh)
    * [DNS](#dns)
        * [systemd-resolved (DNS over tls,cache server,LLMNR)](#systemd-resolved-dns-over-tlscache-serverllmnr)
    * [rkhunter(rookit 检查)](#rkhunterrookit-检查)
    * [nfs](#nfs)
    * [cron](#cron)
    * [anacron](#anacron)

<!-- vim-markdown-toc -->

# server(服务配置)

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


## [pdsh(ssh 并行管理)](https://github.com/chaos/pdsh)

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

## [pssh](https://github.com/robinbowes/pssh)

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

## DNS

### systemd-resolved (DNS over tls,cache server,LLMNR)

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

## rkhunter(rookit 检查)

- [archwiki](https://wiki.archlinux.org/index.php/Rkhunter)

```bash
sudo rkhunter --check
```

## nfs

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

## cron

开启服务

```bash
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

## anacron

- 配置文件: `/etc/anacrontab`

| cron                         | anacron                                                              |
| ---------------------------- | -------------------------------------------------------------------- |
| 它是守护进程                 | 它不是守护进程                                                       |
| 适合服务器                   | 适合桌面/笔记本电脑                                                  |
| 可以让你以分钟级运行计划任务 | 只能让你以天为基础来运行计划任务                                     |
| 关机时不会执行计划任务       | 如果计划任务到期，机器是关机的，那么它会在机器下次开机后执行计划任务 |
| 普通用户和 root 用户         | 只有 root 用户可以使用（使用特定的配置启动普通任务）                 |

```
7	5	cron.weekly	/bin/bash /home/tz/.mybin/logs.sh
```

```bash
# 测试配置
anacron -T

# 启动
anacron -d
```

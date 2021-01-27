<!-- vim-markdown-toc GFM -->

* [server(服务配置)](#server服务配置)
    * [pdsh(ssh 并行管理)](#pdshssh-并行管理)
    * [pssh](#pssh)
    * [DNS](#dns)
        * [systemd-resolved (DNS over tls,cache server,LLMNR)](#systemd-resolved-dns-over-tlscache-serverllmnr)
    * [rkhunter(rookit 检查)](#rkhunterrookit-检查)

<!-- vim-markdown-toc -->

# server(服务配置)

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

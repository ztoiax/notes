# Systemd

<!-- vim-markdown-toc GFM -->

    * [systemd](#systemd)
        * [查看启动时间](#查看启动时间)
        * [列出每个 units 启动时间](#列出每个-units-启动时间)
        * [查看瀑布状的启动过程流](#查看瀑布状的启动过程流)
        * [可视化每个 units 的启动时间](#可视化每个-units-的启动时间)
        * [管理开机启动脚本](#管理开机启动脚本)
    * [systemctl](#systemctl)
        * [查看 `units`](#查看-units)
        * [查看不同类型](#查看不同类型)
        * [查看 `units的所有状态`](#查看-units的所有状态)
        * [查看 `依赖关系`](#查看-依赖关系)
        * [查看`cgroup树` (units 执行的脚本或文件)](#查看cgroup树-units-执行的脚本或文件)
        * [重新加载配置文件](#重新加载配置文件)
        * [重启所有的守护进程](#重启所有的守护进程)
        * [查看是不是引导启动](#查看是不是引导启动)
        * [unmask](#unmask)
        * [判断状态，执行命令脚本](#判断状态执行命令脚本)
    * [journalctl](#journalctl)
        * [读取日志](#读取日志)
        * [读取实时日志](#读取实时日志)
        * [读取实时错误日志](#读取实时错误日志)
        * [读取日志 size](#读取日志-size)
        * [实战调试](#实战调试)
            * [查看错误](#查看错误)
            * [解决办法](#解决办法)
* [referece](#referece)

<!-- vim-markdown-toc -->

## systemd

- systemd 通过`cgroup`(控制组)来追踪进程，而不是 PID
- systemd 执行的第一个目标是 `default.target`但实际上 `default.target` 是指向 `graphical.target` 的软链接

```
systemctl get-default
#output
graphical.target
```

```sh
grep Requires= /usr/lib/systemd/system/graphical.target
#output
Requires=multi-user.target
```

- `multi-user.target` 为多用户支持设定系统环境。非 root 用户会在这个阶段的引导过程中启用。防火墙相关的服务也会在这个阶段启动。

```sh
ls /etc/systemd/system/multi-user.target.wants
# output
libvirtd.service    NetworkManager.service  remote-fs.target  v2ray.service
lm_sensors.service  privoxy.service         sysstat.service

```

- `multi-user.target`会将控制权交给另一层`basic.target`。

```sh
grep Requires= /usr/lib/systemd/system/multi-user.target
# output
Requires=basic.targe
```

- `basic.target`单元用于启动普通服务特别是图形管理服务。它通过`/etc/systemd/system/basic.target.wants` 目录来决定哪些服务会被启动，`basic.target`之后将控制权交给`sysinit.target`.

```sh
grep Requires= /usr/lib/systemd/system/basic.target
#output
Requires=sysinit.target
```

- `sysinit.target` 会启动重要的系统服务例如系统挂载，内存交换空间和设备，内核补充选项等等。`sysinit.target` 在启动过程中会传递给 `local-fs.target`

```sh
 cat /usr/lib/systemd/system/sysinit.target
[Unit]
Description=System Initialization
Documentation=man:systemd.special(7)
Conflicts=emergency.service emergency.target
Wants=local-fs.target swap.target
After=local-fs.target swap.target emergency.service emergency.target

Requires=sysinit.target
```

- `local-fs.target`不会启动用户相关的服务，它只处理底层核心服务,它会根据`/etc/fstab`和`/etc/inittab`来执行相关操作。

---

- `default.target-> multi-user.target-> sysinit.target-> local-fs.target`

### 查看启动时间

```sh
systemd-analyze time
```

### 列出每个 units 启动时间

```sh
systemd-analyze blame
```

### 查看瀑布状的启动过程流

```sh
systemd-analyze critical-chain
```

### 可视化每个 units 的启动时间

```sh
systemd-analyze plot > boot.svg
google-chrome-stable boot.svg #用浏览器打开
```

![image](/Pictures/systemd/1.avif)

### 管理开机启动脚本

传统上，/etc/rc.local 文件是在切换到多用户运行级别的过程结束时，在所有正常的计算机服务启动之后执行的。

```sh
#运行脚本
echo "#!/bin/sh" > /home/tz/.mybin/fcitx5.sh #如果没有会报错(code=exited, status=203/EXEC)
echo "fcitx5 &" > /home/tz/.mybin/fcitx5.sh

#把执行的命令或脚本加入到文件
echo "/home/tz/.mybin/fcitx5.sh" >> /etc/rc.local
chmod +x /home/tz/.mybin/fcitx5.sh #设置权限
chmod +x /etc/rc.local
```

units 文件存放在这两个目录

- /etc/systemd/system/
- /usr/lib/systemd/system/

- 随机mac地址

```sh
cat > /etc/systemd/system/macspoof.service << 'EOF'
[Unit]
Description=Custom mac address
After=multi-user.target

[Service]
ExecStart=/usr/bin/macchanger -e enp27s0

[Install]
WantedBy=multi-user.target
EOF
```

- 设置开机启用服务:

```sh
systemctl enable macspoof.service
```

- 如果开机失败,就需要启动其它linux系统`chroot`后执行:

```sh
systemctl disable macspoof.service
```

## systemctl

`Unit` 一共分成 12 种。

- `Service Unit`: 系统服务
- `Target Unit`: 多个 Unit 构成的一个组
- `Device Unit`: 硬件设备
- `Mount Unit`: 文件系统的挂载点
- `Automount Unit`: 自动挂载点
- `Path Unit`: 文件或路径
- `Scope Unit`: 不是由 Systemd 启动的外部进程
- `Slice Unit`: 进程组
- `Snapshot Unit`: Systemd 快照，可以切回某个快照
- `Socket Unit`: 进程间通信的 socket
- `Swap Unit`: swap 文件
- `Timer Unit`: 定时器

### 查看 `units`

```sh
systemctl                        # 列出正在运行的 Unit
systemctl --all                  # 列出所有Unit，包括没有找到配置文件的或者启动失败的
systemctl --all --state=inactive # 列出所有没有运行的 Unit
systemctl --failed               # 列出所有加载失败的 Unit
```

### 查看不同类型

```sh
systemctl --type target
```

### 查看 `units的所有状态`

```sh
systemctl list-unit-files
systemctl list-unit-files --user #只查看user
```

### 查看 `依赖关系`

```sh
systemctl list-dependencies graphical.target

```

### 查看`cgroup树` (units 执行的脚本或文件)

```sh
systemd-cgls
#使用ps命令查看cgroup树
ps xawf -eo pid,user,cgroup,args
```

### 重新加载配置文件

```sh
systemctl reload sshd #service name
```

### 重启所有的守护进程

```sh
systemctl daemon-reload
```

### 查看是不是引导启动

```sh
systemctl is-enabled sshd.service
```

### unmask

systemd 支持 mask 操作，如果一个服务被 mask 了，那么它无法被手动启动或者被其他服务所启动，也无法被设置为开机启动。

```sh
systemctl unmask httpd.service
```

### 判断状态，执行命令脚本
```sh
systemctl is-active --quiet name.service && sudo systemctl stop name.service
```

## journalctl

`/etc/systemd/system.conf` 设置的默认值(关机等待进程时间...)

### 读取日志

```sh
journalctl
```

- `journalctl -b` 查看引导日志
- `journalctl -b -1` 查看前一次启动
- `journalctl -b -2` 查看倒数第 2 次启动
- `journalctl _PID=1` 查看进程 1 的日志
- `journalctl $(which libvirtd) #进程路径`通过程序路径查看日志

### 读取实时日志

```sh
journalctl -f
```

### 读取实时错误日志

```sh
journalctl -fp err
```

### 读取日志 size

```sh
sudo journalctl --disk-usage

```

### 实战调试

#### 查看错误

输入`journalctl -fp err`

```sh
#output
-- Logs begin at Wed 2020-08-12 10:25:59 CST. --
Aug 18 00:04:13 tz-pc libvirtd[599]: 内部错误：自动启动化存储池 'kvm2' 失败：cannot open directory '/run/media/root/vm/kvm': 没有那个文件或目录
-- Reboot --
Aug 18 09:33:17 tz-pc systemd-modules-load[311]: Failed to find module 'v4l2loopback-dc'
Aug 18 09:33:17 tz-pc kernel: sp5100-tco sp5100-tco: Watchdog hardware is disabled
Aug 18 09:33:20 tz-pc libvirtd[514]: cannot open directory '/run/media/root/vm/kvm': 没有那个文件或目录
Aug 18 09:33:20 tz-pc libvirtd[514]: 内部错误：自动启动化存储池 'kvm2' 失败：cannot open directory '/run/media/root/vm/kvm': 没有那个文件或目录
-- Reboot --
Aug 18 14:12:03 tz-pc systemd-modules-load[310]: Failed to find module 'v4l2loopback-dc'
Aug 18 14:12:03 tz-pc kernel: sp5100-tco sp5100-tco: Watchdog hardware is disabled
Aug 18 14:12:06 tz-pc libvirtd[522]: cannot open directory '/run/media/root/vm/kvm': 没有那个文件或目录
Aug 18 14:12:06 tz-pc libvirtd[522]: 内部错误：自动启动化存储池 'kvm2' 失败：cannot open directory '/run/media/root/vm/kvm': 没有那个文件或目录
Aug 18 14:39:08 tz-pc libvirtd[76205]: 操作失败: 池 ‘default’ 已存在 uuid 57c3df65-c90a-45a0-999d-5c5d4f02ccbd
```

#### 解决办法

```bash
# 缺少内核v4l2loopback模块
#Aug 18 09:33:17 tz-pc systemd-modules-load[311]: Failed to find module 'v4l2loopback-dc'

# 以dkms(动态加载内核的方式)安装v4l2loopback
sudo pacman -S v4l2loopback-dkms
```

```bash
#Aug 18 09:33:17 tz-pc kernel: sp5100-tco sp5100-tco: Watchdog hardware is disabled
#上网查了一下这是所有amd处理器的问题
#直接屏蔽这个模块
sudo echo "blacklist sp5100_tco" > /etc/modprobe.d/sp5100_tco.conf
```

kvm 是因为存储池里有之前临时挂载 vm，现在没有挂载也就读取错误
解决办法取消存储池错误的 vm 即可

# referece

- [ruanyif](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
- [linux china](https://linux.cn/article-4505-1.html)
- [linux china2](https://linux.cn/article-5457-1.html)

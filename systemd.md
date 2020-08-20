# 系统管理

<!-- vim-markdown-toc GFM -->

* [systemd](#systemd)
    * [查看启动时间](#查看启动时间)
    * [列出每个进程启动时间](#列出每个进程启动时间)
* [systemctl](#systemctl)
    * [查看 `units`](#查看-units)
    * [查看 `target`](#查看-target)
    * [查看 `所有units`](#查看-所有units)
    * [重新配置文件](#重新配置文件)
    * [查看是不是引导启动](#查看是不是引导启动)
* [journalctl](#journalctl)
    * [读取日志](#读取日志)
    * [读取实时日志](#读取实时日志)
    * [读取实时错误日志](#读取实时错误日志)
* [实战调试](#实战调试)
    * [查看错误](#查看错误)
    * [解决办法](#解决办法)

<!-- vim-markdown-toc -->

## systemd

### 查看启动时间

```sh
systemd-analyze time
```

### 列出每个进程启动时间

```sh
systemd-analyze blame
```

## systemctl

### 查看 `units`

```sh
systemd
```

### 查看 `target`

```sh
systemd --type target
```

### 查看 `所有units`

```sh
systemd --all
```

### 重新配置文件

```sh
systemd reload sshd#service name
```

### 查看是不是引导启动

```sh
systemctl is-enabled sshd.service
```

## journalctl

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

## 实战调试

### 查看错误

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

### 解决办法

```sh
#Aug 18 09:33:17 tz-pc systemd-modules-load[311]: Failed to find module 'v4l2loopback-dc'
#这里显示找不到模块loopback，但我用ifconfig却能显示loopback接口。不知道是什么原因
#安装后就不会报错了
sudo pacman -S v4l2loopback-dkms
```

```sh
#Aug 18 09:33:17 tz-pc kernel: sp5100-tco sp5100-tco: Watchdog hardware is disabled
#上网查了一下这是所有amd处理器的问题
#直接屏蔽这个模块
sudo echo "blacklist sp5100_tco" > /etc/modprobe.d/sp5100_tco.conf
```

kvm 是因为存储池里有之前临时挂载 vm，现在没有挂载也就读取错误
解决办法取消存储池错误的 vm 即可

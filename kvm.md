
<!-- mtoc-start -->

* [虚拟化](#虚拟化)
  * [kvm: 内核模块](#kvm-内核模块)
  * [qemu: 硬件模拟器](#qemu-硬件模拟器)
    * [qemu-img(查看镜像信息)](#qemu-img查看镜像信息)
    * [qemu-system-x86_64 安装](#qemu-system-x86_64-安装)
    * [qemu monitor](#qemu-monitor)
      * [virtio](#virtio)
      * [hugepage](#hugepage)
  * [libvirt: 虚拟机管理接口](#libvirt-虚拟机管理接口)
    * [普通用户连接 qemu:///system](#普通用户连接-qemusystem)
    * [vnc打开虚拟机](#vnc打开虚拟机)
    * [virsh](#virsh)
      * [基本命令](#基本命令)
      * [快照snapshot](#快照snapshot)
      * [网络](#网络)
        * [通过修改dhcp配置文件default，自定义ip地址](#通过修改dhcp配置文件default自定义ip地址)
    * [克隆虚拟机](#克隆虚拟机)
  * [KSM(Kernel Samepage Merging)](#ksmkernel-samepage-merging)
  * [gpu虚拟化](#gpu虚拟化)
* [第三方软件资源](#第三方软件资源)
* [优秀文章](#优秀文章)

<!-- mtoc-end -->

# 虚拟化

- guest(虚拟机) 运行在 `guest mode`

- 一般异常/中断指令会触发`VM-EXIT`

  - 一次 `VM-EXIT` 代价大(成百上千周期)

    ![image](./Pictures/kvm/guest.avif)

- EPT: GVA(guest 虚拟地址) -> GPA(guest 物理地址) -> HPA(host 物理地址)

  - GVA 通过 CR3 -> GPA 通过 EPT -> HPA

  - 在 guest 虚拟机中的 `CR3` 寄存器,只是虚拟机的物理地址,并不是 host 的物理地址
    ![image](./Pictures/kvm/ept.avif)

- SR-IOV: PF(单个设备)派生 VF(多个设备),使 I/O 数据传输,绕过 hypervistor
  ![image](./Pictures/kvm/sr-iov.avif)
  ![image](./Pictures/kvm/sr-iov1.avif)

  查看虚拟化硬件技术的支持:

```bash
# 查看是否开启硬件虚拟化
egrep '(vmx|svm)' /proc/cpuinfo

# 查看是否支持SR-IOV(pci虚拟化)
lspci -s 03:00.0 -vvv | grep -i sr-iov

# 查看是否开启kvm-clock
dmesg | grep kvm-clock
```

- kvm-clock
  ![image](./Pictures/kvm/kvm-clock.avif)

- install(安装)

```bash
yum install -y qemu kvm libvirt virt-install virt-viewer libguestfs virt-manager
```

## kvm: 内核模块

- 初始化cpu, 内存

## qemu: 硬件模拟器

- [qemu 详细文档](https://qemu.readthedocs.io/en/latest/index.html)

- 模拟硬件设备: 网卡, 显卡, 声卡, 显卡, 键盘...

- 每个 guest 都是 qemu 的进程

  - 而每个 vcpu 是 qemu 进程的线程(cpu 可以过载分配 over-commit)

  - 当 guest 请求更多内存时,kvm 才会分配(memory 可以过载分配 over-commit,通过交换分区满足,如交换分区也不能满足,可能会被 kill)

- 配置文件`/etc/libvirt/qemu/`

### qemu-img(查看镜像信息)

| 镜像格式                                         | 内容                          |
| ------------------------------------------------ | ----------------------------- |
| raw(默认)                                        | 性能最好                      |
| qcow2                                            | zlib 压缩,AES 加密,能使用快照 |
| vmdk                                             | VMware 格式                   |
| vhdx                                             | hyper-V 格式                  |
| vdi                                              | virtualbox 格式               |
| [sheepdog](https://github.com/sheepdog/sheepdog) | 分布式存储(见下图)            |

![image](./Pictures/kvm/sheepdog.avif)

- `qemu-img` 命令不能查看已启动的镜像, 以下为报错信息: 无法获取共享锁
    ```
    qemu-img: Could not open 'centos7.0.qcow2': Failed to get shared "write" lock
    Is another process using the image [centos7.0.qcow2]?
    ```

```bash
# 查看是否有错误
qemu-img check file.img

# 查看镜像信息(包含快照信息)
qemu-img info file.img
qemu-img info file.qcow2

# 格式转换
qemu-img convert -O raw file.qcow file.img
qemu-img convert -O qcow2 file.vmdk file.qcow2

# 加密现有镜像
qemu-img convert -o encryption -O qcow2 file.qcow2 file_encryption.qcow2

# 查看快照
qemu-img snapshot -l centos7.0.qcow2
```

- `-f` 创建镜像:

```bash
# 随着使用逐渐增大
qemu-img create -f qcow2 arch.qcow2 10G

# -o preallocation=full 一开始便占用10G
qemu-img create -f qcow2 -o preallocation=full arch.qcow2 10G

# encryption加密
qemu-img create -f qcow2 -o encryption arch.qcow2 1G

# 增加10G
qemu-img resize arch.qcow2 +10G
```

### qemu-system-x86_64 安装

| 参数              | 操作                  |
| ----------------- | --------------------- |
| -m                | 内存                  |
| -smp              | cpu                   |
| -daemonize        | 后台运行              |
| -maxcpus=         | 最多,多少个 cpu       |
| -boot once=d      | 首次启动顺序为光驱    |
| -cdrom            | 分配 guest 光驱       |
| -enable-kvm       | 开启 kvm 硬件加速     |
| -usb              | 分配 usb 总线         |
| -gdb tcp::1234 -S | 调试                  |
| -d                | 保存日志/tmp/qemu.log |

- 参数解析：

    ```sh
    # 安装虚拟机.2G内存,4个cpu,首次启动顺序为光驱
    qemu-system-x86_64 \
        -enable-kvm \
        -m 2G \
        -smp 4
        -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso /mnt/Z/kvm/arch.qcow2

    # -smp 4,maxcpus=$(nproc) 分配4个cpu,最多能有所有cpu
    qemu-system-x86_64 \
        -enable-kvm \
        -m 2G \
        -smp 4,maxcpus=$(nproc) \
        -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso /mnt/Z/kvm/arch.qcow2

    # -net nic表示为虚拟机创建虚拟机网卡。hostfwd=tcp::2222-:22表示将虚拟机22端口转发到宿主机的2222端口
    qemu-system-x86_64 \
        -enable-kvm \
        -m 2G \
        -smp 4,maxcpus=$(nproc) \
        -net nic \
        -net user,hostfwd=tcp::2222-:22 \
        -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso /mnt/Z/kvm/arch.qcow2
    # ssh连接虚拟机
    ssh root@localhost -p 2222

    # 设置samba共享目录, samba配置文件/tmp/qemu-smb.VAEJD1/smb.conf。??失败了
    qemu-system-x86_64 \
        -enable-kvm \
        -m 2G \
        -smp 4,maxcpus=$(nproc) \
        -net nic \
        -net user,hostfwd=tcp::2222-:22,smb=/tmp/share_qemu \
        /mnt/virt/centos7-1.qcow2
        -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso /mnt/Z/kvm/arch.qcow2
    ```

- 1.创建镜像
    ```sh
    qemu-img create -f qcow2 arch.qcow2 10G
    ```

- 2.安装

     ```bash
     # 自动开启ssh。
     qemu-system-x86_64 -enable-kvm -m 2G -smp 4,maxcpus=$(nproc) \
         -net nic \
         -net user,hostfwd=tcp::2222-:22 \
         -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso /mnt/Z/kvm/arch.qcow2

     # 可以对安装好的虚拟机开启
     qemu-system-x86_64 -enable-kvm -m 2G -smp 4,maxcpus=$(nproc) \
         -net nic \
         -net user,hostfwd=tcp::2222-:22 \
         /mnt/Z/kvm/arch.qcow2

     # 使用ssh连接虚拟机
     ssh -p 2222 root@localhost
     ```

- 3.可以执行换源。安装必要软件，再安装openssh配置好后允许root登陆，和密钥登陆后。可以关闭虚拟机

- 4.添加进virt进行管理，这样就可以在virt-manager图形界面和virsh list命令进行管理
    ```sh
    # --os-variant的值，可以通过virt-install --osinfo list查看。我这里为archlinux可以是centos7、centos8
    virt-install --name archlinux --ram 2048 --disk path=arch.qcow2,format=qcow2 --import --os-variant=archlinux --network network=default --noautoconsole

    # 启动dhcp服务。不然会出现error starting domain:Requeted operation is not calid:network 'default' is not active
    virsh net-start default

    # 启动刚才添加的虚拟机
    virsh start archlinux

    # 进入虚拟机查看ip
    ip a
    ```

- 5.在第3步安装好ssh服务并开启后。就可以使用普通的ssh登陆了
    ```sh
    ssh root@192.168.122.38
    ```

- guest（虚拟机）:

    ```bash
    # 查看cpu模型
    grep 'model name' /proc/cpuinfo
    ```

### qemu monitor

- <kbd>ctrl + alt + 2</kbd> 可切换 `qemu monitor` 模式(qemu)

- <kbd>ctrl + alt + 2</kbd> 切换回去

- <kbd>ctrl + alt + g</kbd> guest 和 host 之间的切换

  ![image](./Pictures/kvm/qemu-monitor.avif)

```sh
# 开启monitor
qemu-system-x86_64 -monitor unix:/tmp/monitor.sock,server,nowait

# 连接
socat - UNIX-CONNECT:/tmp/monitor.sock
```

```qemu
# 查看cpu
info cpus

# 查看网络
info network

# 查看寄存器
info registers

# 查看设备
info qtree
```

#### virtio

- 在 guest 上安装前端驱动,提升性能

  - 允许多条队列

- host 上为后端驱动,两者之间有个 virtio-ring(环形缓冲区)

  - virtio-ring 保存前端的多次请求,再提交给后端处理

- guest 知道自己运行在虚拟环境当中(半虚拟化)
  - 配合 kvm 的全虚拟化,实现混合虚拟化

| virtio 参数                                       | 操作                                                                   |
| ------------------------------------------------- | ---------------------------------------------------------------------- |
| -ballon virtio(失败)                              | 分配 virtio balloon(控制 guest 的内存)                                 |
| -net nic,model=virtio                             | 分配 virtio_net                                                        |
| file=path.qcow2,format=qcow2,if=virtio,media=disk | 分配 virtio_blk                                                        |
| -netdevtap,id=vnet0,vhost=on,queues=2             | vhost_net 后端内核处理程序,网卡多队列                                  |
| -cpu host                                         | vhost-user 一种用户态的协议,建立两个进程的共享虚拟队列,减少上下文切换, |

```bash
# 分配virtio_net网卡
qemu-system-x86_64 -enable-kvm -m 2G -smp 4 -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso /mnt/Z/kvm/arch.qcow2 -net nic,model=virtio

# 分配virtio_blk快设备i/o
qemu-system-x86_64 -enable-kvm -m 2G -smp 4 -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso -drive file=/mnt/Z/kvm/arch.qcow2,format=qcow2,if=virtio,media=disk

# vhost-user
qemu-system-x86_64 -enable-kvm -m 2G -smp 4 -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso /mnt/Z/kvm/arch.qcow2 -cpu host

# -balloon virtio(失败)
qemu-system-x86_64 -enable-kvm -m 2G -smp 4 -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso /mnt/Z/kvm/arch.qcow2 -balloon virtio

# 分配vhost后端,队列为2(失败)
qemu-system-x86_64 -enable-kvm -m 2G -smp 4 -net nic,model=virtio -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso /mnt/Z/kvm/arch.qcow2 -netdevtap,id=vnet0,vhost=on,queues=2
```

**host:**

```bash
# 查看内核是否安装virtio
find /lib/modules/5.10.6/ -name "virtio*.ko"

# 查看是否支持kvm_clock(更精确的中断)
grep constant_tsc /proc/cpuinfo
```

**guest:**

```bash
# 查看是否加载virtio模块
lsmod | grep virtio

# 查看virtio设备
lspci | grep -i virtio

# 查看设备详情
lspci -s <设备地址> -vvv

# 查看网卡是否为virtio_net
ethtool -i ens3

# 查看是否存在vda,表示加载virtio_blk
fdisk -l
```

- virtio_net
  ![image](./Pictures/kvm/virtio_net.avif)
- virtio_blk
  ![image](./Pictures/kvm/virtio_blk.avif)

#### hugepage

[开启 hugepage](https://github.com/ztoiax/notes/blob/master/benchmark.md#hugepage)

| virtio 参数   | 操作                                   |
| ------------- | -------------------------------------- |
| -mem-path     | 指定内存路径                           |
| -mem-prealloc | 预先分配所有内存,必须有`-mem-path`参数 |

```bash
# -m 的大小必须小于巨型页的分区大小
qemu-system-x86_64 -enable-kvm -m 2G -smp 4 -boot once=d -cdrom archlinux-2020.11.01-x86_64.iso /mnt/Z/kvm/arch.qcow2 -mem-path /mnt/2M-hugepage -mem-prealloc
```

## libvirt: 虚拟机管理接口

- libvirt是虚拟机管理接口

    - 实现:创建, 暂停, 迁移等; cpu, 内存, 网卡等设备的热添加

    - 使用libvirt进行管理的软件有: virsh, openstack, cloudstack, opennebula

- `libvirt` 为用户提供 api, 对 `qemu` 和 `kvm` 的操作

  - 1.守护进程 libvirtd `libvirtd.service`

  - 2.应用程序接口 `virsh`(命令行) 和 `virt-manager`(图形界面)

  - 3.以上两者为`C/S`架构

连接:

```bash
# root用户
virsh -c qemu:///system
# 图形界面
virt-manager -c qemu:///system

# 当前用户
virsh -c qemu:///session

# ssh通道连接,远程root用户
virsh -c qemu+ssh:/user@ip//system

# tls通道连接,远程root用户(需要设置ca证书)
virsh -c qemu/user@ip//system

# tcp通道连接,远程root用户(非加密)
virsh -c qemu/user@ip//system
```

| 配置文件                   | 内容                    |
| -------------------------- | ----------------------- |
| /etc/libvirt/              | 配置文件目录            |
| /etc/libvirt/libvirt.conf  | libvirt 连接的别名      |
| /etc/libvirt/libvirtd.conf | libvirtd 守护进程的配置 |
| /etc/libvirt/qemu.conf     | qemu 进程的配置         |
| /etc/libvirt/qemu/         | guest 配置 和 网络配置  |

guest 的配置 `/etc/libvirt/qemu/arch.xml`

- cpuset 表示只允许调度 cpu1,2,4,6

- current 表示启动时只给 4 个 cpu,最多可以 32 个

```xml
<vcpu placement='static' cpuset="1-4,^3,6" current='4'>32</vcpu>
```

- features 标签表示要打开的硬件特性
  - acpi
  - apic

```xml
  <features>
    <acpi/>
    <apic/>
    <vmport state='off'/>
  </features>
```

- devices 设备
  - graphics 图形连接
  - sound 声卡
  - video 显卡

```xml
<devces>
    <graphics type='vnc' port='-1' autoport='yes'/>
    <sound>
    </sound>
    <video>
    </video>
<devces>
```

- cpu mode

  | cpu mode         | 内容                                      |
  | ---------------- | ----------------------------------------- |
  | custom           | 基础模型                                  |
  | host-model(默认) | 根据 cpu 物理特性,选择最接近标准 cpu 型号 |
  | host-passthrough | 直接暴露物理 cpu                          |

```xml
<cpu mode='host-model' check='partial'/>
```

### 普通用户连接 qemu:///system

```bash
# 将用户添加到libvirt组
sudo usermod -a -G libvirt $USER

# 修改配置文件
sudo vim /etc/libvirt/libvirtd.conf

unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"

# 重启(可能需要重新登陆)
sudo systemctl restart libvirtd.service

virsh -c qemu:///system
virt-manager -c qemu:///system
```

### vnc打开虚拟机

- virt-manager在虚拟机后, 按open无法显示画面, 并出现以下错误

> Error connecting to graphical console:
could not get a reference to type class

![image](./Pictures/kvm/vnc.avif)

- 默认的显示协议是spice协议, 我们可以改为vnc(需要关闭虚拟机)

    - 在图形界面修改

    ![image](./Pictures/kvm/vnc1.avif)

    - 也可以修改`/etc/libvirt/qemu/`目录下对应的虚拟机xml文件(两者一样)
    ```xml
    <graphics type='vnc' port='5900' autoport='no'>
      <listen type='address'/>
    </graphics>
    ```

```py
# 安装vnc客户端(我这里是archlinux下的tigervnc)
pacman -S tigervnc

# 连接刚才设置的vnc端口
vncviewer 127.0.0.1:5900
```

### virsh

#### 基本命令

```sh
# 非ssh连接虚拟机
virsh console centos7

# 需要开启serial console
systemctl enable serial-getty@ttyS0.service
systemctl start serial-getty@ttyS0.service
```

```bash
# 查看虚拟机状态
virsh list --all

# 开启/关闭
virsh start opensuse15.2
virsh shutdown opensuse15.2

# 强制关闭电源
virsh destroy opensuse15.2

# 开机自启
virsh autostart opensuse15.2

# 暂停/恢复
virsh suspend opensuse15.2
virsh resume opensuse15.2

# 查看cpu信息
vitsh vcpuinfo opensuse15.2

# 编辑xml配置文件
virsh edit centos7

# 备份xml文件
virsh dumpxml centos7 > centos7-bak.xml

# 删除虚拟机(只是删除配置文件, 并没有删除磁盘文件)
virsh undefine centos7.xml

# 重新添加虚拟机
mv centos7-bak.xml centos7.xml
virsh define centos7.xml
```

#### 快照snapshot

```sh
# 创建快照
virsh snapshot-create-as centos7-2 snapshot0 --description "first snapshot"

# 查看所有快照
virsh snapshot-list centos7-2

# 查看指定快照
virsh snapshot-info centos7-2 snapshot0

# 恢复快照
virsh snapshot-revert centos7-2 --current

# 删除快照
virsh snapshot-delete centos7-2 snapshot0
```

#### 网络

```sh
# 查看网络
virsh net-list --all

# 查看当前使用dhcp配置文件default的所有虚拟机的ip
virsh net-dhcp-leases --network default

# 修改centos7-1。可以修改mac地址
virsh edit centos7-1

# 通过配置文件。查看虚拟机的mac地址
virsh dumpxml centos7 | grep -i '<mac'

# 查看dhcp配置文件default
virsh net-dumpxml default

# 修改dhcp配置文件的ip、mac。配置文件目录/etc/libvirt/qemu/networks
virsh net-edit default
# 修改后需要重启dhcp服务
virsh net-destroy default
virsh net-start default
# 开机自动启动，而不需要每次宿主机重启都要执行一遍 virsh net-start default
virsh net-autostart default

# 查看运行中的虚拟机ip,mac
virsh domifaddr opensuse15.2_1
```

##### 通过修改dhcp配置文件default，自定义ip地址

- 1.查看centos7-1的mac地址
    ```sh
    virsh dumpxml centos7-1 | grep -i '<mac'
          <mac address='52:54:00:a9:8e:e7'/>
    ```

- 2.方法1：`virsh net-update`命令修改
    ```sh
    # 修改虚拟机ip地址.如虚拟机运行,需要重启
    virsh net-update default add ip-dhcp-host \
          "<host mac='52:54:00:a9:8e:e7' name='centos7-1' ip='192.168.110.4'/>" \
           --live --config
    ```

- 2.方法2：`virsh net-edit default`修改配置文件。并且可以修改网段
    ```sh
    # 修改default配置文件
    virsh net-edit default

      <ip address='192.168.110.1' netmask='255.255.255.0'>
        <dhcp>
          <range start='192.168.110.2' end='192.168.110.254'/>
          <host mac='52:54:00:a9:8e:e7' name='centos7-1' ip='192.168.110.3'/>
        </dhcp>
      </ip>
    ```

- 3.重启
    ```sh
    # 修改后需要重启dhcp服务
    virsh net-destroy default
    virsh net-start default

    # 重启虚拟机后。查看
    virsh domifaddr centos7-1

     Name       MAC address          Protocol     Address
    -------------------------------------------------------------------------------
     vnet5      52:54:00:a9:8e:e7    ipv4         192.168.110.3/24
    ```

### 克隆虚拟机

opensuse15.2 -> opensuse15.2_1

```bash
# 关机opensuse15.2
sudo virsh shutdown opensuse15.2

# 克隆qcow2镜像
sudo virt-clone --original opensuse15.2 \
--name opensuse15.2_1 \
--file ./opensuse15.2_1.qcow2

# 克隆后的opensuse15.2_1.qcow2会自动修改mac地址。
sudo grep mac /etc/libvirt/qemu/opensuse15.2.xml
sudo grep mac /etc/libvirt/qemu/opensuse15.2_1.xml

# 如果是dhcp。则修改dhcp配置文件default。根据上一条命令输出的mac，自定义ip
sudo virsh net-update default add ip-dhcp-host \
      "<host mac='52:54:00:9d:20:17' name='opensuse15.2_1' ip='192.168.110.6'/>" \
       --live --config
# 上一条命令，也可以通过修改dhcp配置文件default。实现
sudo virsh net-edit default\n

# 重启dhcp配置文件default
sudo virsh net-destroy default
sudo virsh net-start default

# 连接
virsh start opensuse15.2_1
ssh user@ip

# 修改新的uuid
uuidgen eth0

# 如果不是dhcp，而是静态ip,则需要修改
vim /etc/sysconfig/network/ifcfg-eth0
systemctl restart network.service
```

## KSM(Kernel Samepage Merging)

- 通过共享多个虚拟机的页面, 从而减少内存

```sh
systemctl enable ksmtuned
systemctl start ksmtuned
```

## gpu虚拟化

- [了不起的云计算：一文读懂GPU虚拟化：除了直通、全虚拟化 (vGPU)，还有谁？](https://mp.weixin.qq.com/s/WVAs9Tren91Q3ouXxsZn9Q)

- GPU虚拟化大类上一般分为三种：
    - 软件模拟
    - 直通独占(类似网卡独占、显卡独占)
    - 直通共享（如vGPU、MIG）

- 1.软件模拟（eg sGPU）， 又被叫半虚拟化。

    - 这种方式主要通过软件模拟来完成，也就是大部分的KVM在用，主要原理就是在Host操作系统层面上建立一些比较底层的API，让Guest看上去好像就是真的硬件一样。

    - 优点：是比较灵活，而且并不需要有实体GPU
    - 缺点：
        - 模拟出来的东西运行比较慢。
        - 没有官方研发，因此产品质量肯参差不齐。

    - 结论：几乎没法用在生产环境，毕竟性能损失太多。

- 2.直通独占 (pGPU)

    - 直通是最早出现，即技术上最简单和成熟的方案。直通主要是利用PCIe Pass-through技术

    - 将物理主机上的整块GPU显卡直通挂载到虚拟机上使用，与市场网卡直通的原理类似，但是这种方式需要主机支持IOMMU。

    - 优点：
        - 性能损耗最小
        - 没有对GPU功能性做阉割
        - 硬件驱动无需修改

    - 缺点：
        - 是一张GPU卡不能同时直通给多个虚拟机使用，相当于虚拟机独占了GPU卡。
            - 如果多个虚拟机需要同时使用GPU，需要在服务器中安装多块GPU卡，分别直通给不同的虚拟机使用。
        - 直通GPU的虚拟机不支持在线迁移。

    - 为了应对GPU直通不能共享GPU的限制，第三种方式直通共享的虚拟化方式出现了。直通共享在技术上分类叫全虚拟化 。实现原理是物理GPU虚拟化为多个虚拟机GPU，每个虚拟GPU直接分配给虚拟机使用，通过软件调度的方式在Host与计算机的Guest之间提供一个中间设备来允许Guest虚拟机访问Host中的物理GPU。

- 3.GPU全虚拟化技术先后有SR-IOV(开源技术) ，API转发、MPS还有vGPU 、MIG等

    - 1.PCIe SR-IOV(Single Root Input/Output Virtualization)：是一种更高级的虚拟化技术，允许一个PCIe设备在多个虚拟机之间共享，同时保持较高的性能。

        ![image](./Pictures/kvm/GPU全虚拟化-PCIe_SR-IOV.avif)

        - PCIe SR-IOV通过在物理设备(Physical Functions，PF)上创建多个虚拟功能(Virtual Functions，VF)来实现的，每个虚拟功能可以被分配给一个虚拟机，让虚拟机直接访问和控制这些虚拟功能，从而实现高效的I/O虚拟化。
        - 基于PCIe SR-IOV的GPU虚拟化方案，本质是把一个物理GPU显卡设备(PF)拆分成多份虚拟(VF)的显卡设备，而且VF 依然是符合 PCIe 规范的设备。

        - 优点：就是真正实现了真正实现了1：N，一个PCIe设备提供给多个VM使用
        - 缺点：
            - 是灵活性较差，无法进行更细粒度的分割与调度
            - 不支持热迁移。

    - 2.API转发

        - 在苦等PCIe SR-IOV期间，业界出现了基于API转发的GPU虚拟化方案。
        - API转发分为被调方和调用方，两方对外提供同样的接口(API)：
            - 被调方API实现是真实的渲染、计算处理逻辑
            - 调用方API实现仅仅是转发，转发给被调方。

        - 在GPU API层的转发，业界有针对OpenGL的AWS Elastic GPU，OrionX，有针对CUDA的腾讯vCUDA，瓦伦西亚理工大学rCUDA；在GPU驱动层的转发，有针对CUDA的阿里云cGPU和腾讯云pGPU。

        ![image](./Pictures/kvm/GPU全虚拟化-API转发.avif)

        - 优点：
            - API转发方案的优点是实现了1：N，并且N是可以自行设定，灵活性高。
            - 不依赖GPU硬件厂商。

        - 缺点：
            - 复杂度极高：同一功能有多套 API(渲染的 DirectX 和 OpenGL)，同一套 API 还有不同版本(如 DirectX 9 和 DirectX 11)，兼容性非常复杂。
            - 并且功能不完整：如不支持媒体编解码，并且，编解码甚至还不存在业界公用的 API。

    - 3.MPS方案

        - MPS基于C/S架构，配置成MPS模式的GPU上运行的所有进程，会动态的将其启动的内核发送给MPS server，MPS Server借助CUDA stream，实现多个内核同时启动执行。除此之外，MPS还可配置各个进程对GPU的使用占比。

        - 优点：该方案和PCIe SR-IOV方案相比，配置很灵活，并且和docker适配良好。
        - 缺点：各个服务进程依赖MPS，一旦MPS进程出现问题，所有在该GPU上的进程直接受影响，需要使用Nvidia-smi重置GPU 的方式才能恢复。

    - 4.MIG技术

        - MIG是Nvidia 搞出的新技术，可将单个 GPU 分区为最多7个完全的隔离vGPU实例，每个实例均完全独立于各自的高带宽显存、缓存和计算核心。

        - 优点：减少资源争抢的延时，提高物理 GPU 利用率。
        - 缺点：
            - 由于MIG 是基于 NVIDIA Ampere GPU 架构引入的，仅有 Ampere 架构的 GPU 型号才能使用 MIG 方式。
                - 但可惜目前仅昂贵和国内禁售的NVIDIA A100 GPU支持。

- 4.Time-sliced GPU

    - 这种方式是把本来再空间上并行（时间独占）的成百上千的GPU流水线进行的时间维度的分割和共享。各个GPU厂家都有类似的技术。Time-sliced 切分方式是按时间切分 GPU，每个 vGPU 对应物理 GPU 一段时间内的使用权。
    - 在此方式下，vGPU 上运行的进程被调度为串行运行，当有进程在某个 vGPU 上运行时，此 vGPU 会独占 GPU 引擎，其他 vGPU 都会等待。所有支持 vGPU 技术 GPU 卡都能支持 Time-sliced 的切分方式。

# 第三方软件资源

- [kvmtop](https://github.com/cha87de/kvmtop)

- [kvm management with wei ui](https://github.com/kimchi-project/kimchi)

# 优秀文章

- [博客](http://terenceli.github.io/)

- [QEMU KVM 学习笔记](https://yifengyou.gitbooks.io/learn-kvm/content/)

- [learn-kvm](https://github.com/yifengyou/learn-kvm)

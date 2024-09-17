<!-- vim-markdown-toc GFM -->

* [编译内核](#编译内核)
    * [General setup](#general-setup)
        * [Kernel compression mode (内核压缩算法)](#kernel-compression-mode-内核压缩算法)
        * [preemption model (线程抢占模型)](#preemption-model-线程抢占模型)
    * [Power management and ACPI options](#power-management-and-acpi-options)
        * [CPU Frequency scaling](#cpu-frequency-scaling)
    * [reference](#reference)
* [modprobe(模块)](#modprobe模块)
    * [基本命令](#基本命令)
    * [rmmod](#rmmod)
    * [lsmod](#lsmod)
    * [modinfo](#modinfo)
    * [reference](#reference-1)
* [fs(文件系统)](#fs文件系统)
* [core dump](#core-dump)
    * [crash命令](#crash命令)
        * [一次kernel core dump使用crash分析的案例](#一次kernel-core-dump使用crash分析的案例)

<!-- vim-markdown-toc -->

# 编译内核

- 内核模块路径 `/usr/lib/modules/kernel_release` 目录下的具有 .ko（内核对象）扩展名的文件

- 查看当前运行的`linux config`

    ```bash
    zcat /proc/config.gz
    ```

- 1.下载 `kernel`

```bash
# 下载内核
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.6.tar.xz
# 国内镜像下载
wget http://mirrors.163.com/kernel/v5.x/linux-5.10.6.tar.xz

# 解压
tar xvf linux-5.10.6.tar.xz
# 如果安装了pixz(多线程xz解压缩)
tar -I pixz -xvkf linux-5.10.6.tar.xz

# 设置config
cd linux-5.10.6
```

- 2.编译安装

```bash
# 查看make
make help

# 配置内核
make nconfig
# 或者
make menuconfig

# 注意如果配置成M(模块),日后需要用命令加载
morprobe <module_name>
lsmod | grep -i <module_name>

# 编译
sudo make -j$(nproc)
sudo make modules_install

# 复制到boot分区
sudo make install
```

或者手动复制到 boot 分区(等同于 sudo make install):

```bash
# 将内核,复制到boot分区
sudo cp -v arch/x86/boot/bzImage /boot/vmlinuz-linux5.10.6

# 将symbol文件,复制到boot分区
sudo cp System.map /boot/System.map-vmlinuz-linux5.10.6
ln -sf /boot/System.map-vmlinuz-linux5.10.6 /boot/System.map

# 生成initramfs
sudo cp /etc/mkinitcpio.d/linux.preset /etc/mkinitcpio.d/linux5.10.6.preset
sudo sed -i 's/linux/linux5.10.6/g' /etc/mkinitcpio.d/linux5.10.6.preset

# 不同发行版命令不一样,我这里是archlinux
sudo mkinitcpio -p linux5.10.6
```

- 3.最后

```bash
# 重新配置grub引导
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 如果使用nvidia私有驱动,需要重新安装,不然会进不了图形界面
pacman -S nvidia-dkms

# 重启
reboot

# 查看内核
uname -a
```

## General setup

### [Kernel compression mode (内核压缩算法)](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/init/Kconfig?id=aefcf2f4b58155d27340ba5f9ddbe9513da8286d#n200)

![image](./Pictures/kernel/compression.avif)

- 压缩速度只影响编译内核
- 解压速度只影响每次开机
- 压缩大小只影响磁盘空间

  1.对于大多数情况下解压速度才是第一优先考虑

  - [x] `LZ4`

    2.综合解压,压缩比

  - [x] `zstd`

    3.对于小磁盘空间

  - [x] `xz`

[详情](https://lwn.net/Articles/817134/)

### [preemption model (线程抢占模型)](https://devarea.com/understanding-linux-kernel-preemption/)

![image](./Pictures/kernel/preemption.avif)

1.如果是服务器选择不强制抢占,减少切换上下文

- [x] `No Forced Preemption`

[实时强制抢占内核补丁](https://rt.wiki.kernel.org/index.php/Main_Page)

## Power management and ACPI options

### CPU Frequency scaling

## reference

- [戴文的 Linux 内核专题：12 配置内核(8)](https://linux.cn/article-2386-1.html)

# modprobe(模块)

## 基本命令

```sh
# 加载ath9k模块
modprobe ath9k

# 查看系统可用模块
modprobe -c

# 查看系统可用模块数
modprobe -c | wc -l
```

## rmmod

```sh
# 卸载ath9k模块
rmmod ath9k
```

## lsmod

查看正在运行的模块
```sh
# 统计正在运行的模块
lsmod | wc -l
```

## modinfo

查看模块细节

## reference

- [如何装载/卸载 Linux 内核模块](https://linux.cn/article-9750-1.html)

- [kernel官方文档](https://www.kernel.org/doc/html/latest/index.html)

# fs(文件系统)

- [Linux debugfs Hack: Undelete Files](https://www.cyberciti.biz/tips/linux-ext3-ext4-deleted-files-recovery-howto.html)

   - 按照教程, 但失败了??

# core dump

- [卫sir说：Linux 崩溃了，你能做什么？](https://mp.weixin.qq.com/s/lMn0RqzwO3x13JkmtXvHjQ)

- 当Linux内核崩溃时，kdump工具捕获当时内存等状态信息，生成转储文件（vmcore），保留现场证据，然后才重启。

- kdump：

    - 安装kdump工具、修改内核启动参数、修改kdump配置文件参数、启动kdump服务功能。

    - 装了kdump，Linux崩溃重启后，你会在/var/crash目录发现vmcore文件

- crash：分析core dump文件的工具

    > 是RedHat公司提供的一个开源的内核分析工具，它在gdb的基础上实现了解析内核的功能。

    - 你还需要安装Linux内核相应版本的debuginfo包，这个包安装好后会在操作系统上生成一个vmlinux文件，该文件包含完整的符号信息，用于提供调试信息。

- 安装crash工具和debuginfo包

    ```sh
    # 安装crash工具
    yum install crash

    # 安装debuginfo包
    debuginfo-install kernel-debuginfo-common-2.6.32-754.35.1.el6.x86_64.rpm


    # 然后运行crash工具，分析故障服务器的vmcore文件
    crash /usr/lib/debug/lib/modules/2.6.32-754.35.1.el6.x86_64/vmlinux  /var/crash/vmcore
    ```

## crash命令

| 命令      | 作用                               |
|-----------|------------------------------------|
| log命令   | 用于显示内核日志信息               |
| sys命令   | 用于显示内核崩溃基本信息           |
| bt命令    | 用于查看调用栈信息                 |
| ps命令    | 用于查看进程状态                   |
| kmem命令  | 用于查看内存使用情况               |
| task命令  | 用于查看进程的task_struct数据结构  |
| sym命令   | 用于显示虚拟内存地址对应的代码符号 |
| mod命令   | 用于查看加载的内核模块信息         |
| files命令 | 用于查看文件系统信息               |

### 一次kernel core dump使用crash分析的案例

- crash打开vmcore文件

    ```sh
    # vmlinux，是调试所需的内核镜像；vmcore，就是core dump。
    crash /usr/lib/debug/lib/modules/2.6.32-754.35.1.el6.x86_64/vmlinux  /var/crash/vmcore
    ```

- 1.`sys`命令：分析vmcore文件的第一步，是使用sys命令来直观查看系统的基本信息和宕机的原因。

    ```sh
    crash> sys
    第1行       KERNEL:/usr/lib/debug/lib/modules/2.6.32-754.35.1.el6.x86_64/vmlinux
    第2行     DUMPFILE: vmcore  [PARTIAL DUMP]
    第3行         CPUS:4
    第4行         DATE:********
    第5行       UPTIME:143 days,09:21:23
    第6行 LOAD AVERAGE:0.04,0.03,0.00
    第7行        TASKS:344
    第8行     NODENAME: b*****mal02001
    第9行      RELEASE:2.6.32-754.35.1.el6.x86_64
    第10行     VERSION:#1 SMP Wed Sep 16 06:48:01 EDT 2020
    第11行     MACHINE: x86_64  (2294Mhz)
    第12行      MEMORY:16 GB
    第13行       PANIC: "BUG: unable to handle kernel paging request at ffffffffa0395070"
    ```

    ```
    第1行显示我们安装debuginfo包后，Linux内核映像文件vmlinux的位置。
    第2行显示正在分析的vmcore文件。
    第3行显示CPU数量为4。
    第4行显示dump文件生成的日期。
    第5行显示故障发生前已经持续开机143天。
    第6行显示系统负载平均值。
    第7行显示系统中的进程数量。
    第8行显示主机名。
    第9行显示系统内核版本。
    第10行显示该版本Linux内核的发布时间。
    第11行显示操作系统架构。
    第12行显示内存大小。
    第13行显示导致系统崩溃的报错信息。
    ```

    - 最后显示的报错信息非常重要，"BUG: unable to handle kernel paging request at ffffffffa0395070"：这是内核分页请求报错。

        - 可能的原因是：错误的内存访问、内存不足、硬件故障等等。

        - 当然最可能的是：错误的内存访问。


- 2.`bt`命令看看内核崩溃的调用栈信息：谁触发了异常

    > 所谓调用栈，就是谁调用了谁，谁又进一步调用了谁。

    ```sh
    crash> bt
    第1行   PID: 177488  TASK: ffff880435b92ab0  CPU: 2   COMMAND: "ss"
    第2行   #0 [ffff880437c0b7e0] machine_kexec at ffffffff8104179b
    第3行   #1 [ffff880437c0b840] crash_kexec at ffffffff810d7a52
    第4行   #2 [ffff880437c0b910] oops_end at ffffffff81560310
    ……
    第10行   #8 [ffff880437c0bb40] page_fault at ffffffff8155f265
    第11行      [exception RIP: strnlen+9]
    第12行      RIP: ffffffff812ae3a9  RSP: ffff880437c0bbf8  RFLAGS: 00010286
    ……
    第25行  #15 [ffff880437c0be70] proc_reg_read at ffffffff8120faf0
    第26行  #16 [ffff880437c0bec0] vfs_read at ffffffff811a3447
    第27行  #17 [ffff880437c0bf00] sys_read at ffffffff811a3791
    第28行  #18 [ffff880437c0bf50] system_call_fastpath at ffffffff81566391
    ```

    - 崩溃就是“ss”这个程序引起的。ss命令是 netstat命令的替代品，通常比netstat更加高效和快速。

    - 调用是从下往上调用，从第28行开始，ss调用了system_call_fastpath、然后是sys_read（第27行）、然后是我这里省略了的一连串调用，然后是第10行令人胆战心惊的page_fault，然后是oops_end（哦，要完蛋了，第4行）、crash_kexec（准备kdump，第3行）、machine_kexec（调起一个新内核采集信息，第1行），然后kdump就生成了core dump文件：vmcore。

    - 注意第25行，可以看出ss干了一件事，调用了proc_reg_read，这表明它读了proc文件系统。ss读proc文件是正常的，因为要读取一些内核层面的信息，但正是这个读，导致了崩溃。

- 3.`ps`命令查看内核崩溃前所有进程的状态信息：崩溃前谁在干活

    ```sh
    crash> ps
    PID    PPID    CPU        TASK           ST  %MEM  VSZ  RSS    COMM
    ...
    177488 64302    1  ffff880436662ab0   RU   0.0  6280  568     ss
    ...
    ```

    - 当然，崩溃时的进程有很多了，这里只显示ss进程，可以看到它的进程号为177488。

    - 有了ss的进程信息，现在我们看看ss到底调用了哪个文件。

- 4.`files`命令查看进程访问了哪个文件

    - ps命令查到ss的进程地址为ffff880436662ab0，用它作为struct file的输入参数。

        ```sh
        crash> struct file.f_path ffff880436662ab0
          f_path = {
            mnt = 0xffff880432adbe80,
            dentry = 0xffff880101cae5c0
          }
        ```

        - 该命令显示了ss进程访问文件路径的结构信息，mnt表示文件所在的挂载点，dentry表示文件名在地址ffff880101cae5c0。

    - 使用files命令来解析这个dentry地址。

        ```sh
        crash> files -d 0xffff880101cae5c0
             DENTRY           INODE           SUPERBLK     TYPE      PATH
        ffff880101cae5c0 ffff880101c1d598 ffff88043a23e800 REG  /proc/slabinfo
        ```

    - 此时可以得知，故障时，ss进程访问的文件是/proc/slabinfo。

        > 注：/proc/slabinfo文件包含了当前内核中所有slab内存的详细信息。


- 5.`sym`命令看故障相关源码：从源码找到异常

    - 从前面bt命令的调用栈信息看到，异常报错位置为[exception RIP: strnlen+9]（第11行），RIP指向异常调用地址为ffffffff812ae3a9（第12行）。

    ```sh
    crash> sym ffffffff812ae3a9
    ffffffff812ae3a9 (T) strnlen+9 /usr/src/debug/kernel-2.6.32-754.35.1.el6/ linux-2.6.32-754.35.1.el6.x86_64/lib/string.c: 407
    ```

    - 这个命令很牛，它告诉我们，这个异常地址，对应的源码（string.c）和行号（第407行）都告诉我们了。

    - 对，就这么牛，kdump很牛，debuginfo也很牛，一个用于调试，一个提供调试信息，程序员不会亏待自己的。

    - 这段完整代码如下：

        ```c
        size_t strlen(const char *s) {
            const char *sc;
            for (sc = s; *sc != '\0'; ++sc)/*这就是那个第407行*/;
            return sc - s;
        }
        ```

        - 这段代码通过for循环，从输入字符串初始字符s开始，遍历其所指的内容，循环直到遇到字符串结尾的空字符'\0'，最后返回字符串长度。

        - 那个*sc就是读sc这个地址里的内容。

        - 但是，读着读着，就崩溃了，因为读到翔了。

- 6.`log`命令查更多的内容：到底谁是元凶

    ```sh
    crash> log
    ...
    VMAGENTMOD: 3846: init_module: get into init_module, syshook_enable:1
    VMAGENTMOD: 177350: cleanup_module: get into cleanup_modulel
    ...
    ```

    - 可以看出，内核崩溃前，有加载和卸载某个驱动模块的动作。相关的进程号是3846和177350。

    - 经查询，这2个进程号都属于防病毒工具的进程。它调用的cleanup_module是内核函数，用于卸载驱动模块。

    - 用crash的mod -t命令，显示内核模块加载的详细信息：

        > mod的-t选项，是显示taints信息。所谓taints（污点），是内核运行时的一个标志，用来指示内核在运行过程中遇到了某些潜在问题或非标准情况。如果taints是U，表明该模块是未经签名的，是用户开发的。

        ```sh
        crash> mod -t
        NAME           TAINTS
        syshook_linux  (U)
        vmsecmod       (U)
        ```

    - 在log命令的输出中，还可以看到“[last unloaded: vmsecmod]”，这说明，内核最后卸载的驱动模块就是vmsecmod。

    - 另外，防病毒工具的本地日志也显示，服务器重启前刚刚执行了停止防病毒进程的操作。

    - 这些信息都告诉我们，这次崩溃的发生，防病毒工具有相当的嫌疑。

- 7.回到sys命令

    - 我们最开始使用sys命令查到有如下的报错信息：

        ```sh
        BUG: unable to handle kernel paging request at ffffffffa0395070
        ```

    - 用sym命令看看这个地方到底是何方神圣。

        ```sh
        crash> sym ffffffffa0395070
        ffffffffa0395070 (r) hash_info_mempool_name [vmsecmod]
        ```

    - 可以看到，这个地址来自vmsecmod驱动，对应的源码是hash_info_mempool_name。

    - 现在基本可以判断出来是怎么回事：

        - 防病毒工具申请并使用了slab分配器提供的内存，相关信息记录在/proc/slabinfo中，ss进程会去查询slabinfo，获取必要的信息。就是在访问slabinfo时，造成了内核崩溃。

        - 有人在崩溃前卸载了防病毒的驱动，停止了防病毒服务，按道理，防病毒申请的slab内存应该也释放掉，slabinfo中也不会有对应信息。但是，ss进程居然还在访问这块数据，说明防病毒进程申请的slab内存未正常释放!

            > 知识普及：slab主要用于内核态中的内存分配，可高效分配和管理小块内存。在/proc/slabinfo这个虚拟文件中，记录了系统中所有slab内存块的信息，如对象数量和内存使用量等。ss读取/proc/slabinfo，获取与网络套接字相关的内存使用和分配信息，提供详细的网络连接状态。

- 8.原来是防病毒工具的bug

    - 把上述信息给到防病毒厂商，他们的研发工程师分析确认，确实是防病毒客户端有bug，导致了这次重启。

    - bug很简单，就是在卸载vmsecmod驱动时，应该同步释放所申请的slab内存区，但程序员没有这么做。

    - 在重启的服务器上，有服务器管理工具，它会定期调用ss命令，ss会读取slabinfo，防病毒没有释放slab内存，所以ss仍然可以读取slabinfo中的指针，该指针却指向了已经释放了内存区（vmsecmod驱动曾经用过的地方）。

    - 由于指针指向的内存已经释放，所以这就是访问非法地址，其实就是分页机制无法将该地址映射到物理地址，此时处理器就会向操作系统发出一个“page fault”错误，如果处理器此时处于超级用户模式，系统就会产生一个Oops，哦，完蛋了。

    - 注：如果在用户态访问了非法地址，那么，你大概会得到一个经典的Segmentation fault（初级程序员的噩梦）。

- 9.当时发生了什么？

    - 那天，某个工程师做了一件事，更新防病毒工具的许可，这个防病毒工具是企业版的，有一个管理端，还有运行在若干台服务器上的防病毒客户端。

    - 他先在防病毒管理端导入软件许可，接着管理端将软件许可分发给每台服务器上的客户端，由客户端本地更新许可文件。

    - 在客户端更新许可文件时，会先停止防病毒客户端进程（更新完许可文件后，再启动进程），停止进程会导致vmsecmod驱动模块的卸载，由于有bug，清理动作不完善，残留了无主的slab内存。

    - 而服务器上部署的自动化工具，会定时执行ss命令，ss遍历slabinfo信息时，读取了在野的指针，引发page fault，内核崩溃。


# memory（内存）

## 物理内存

- [小林coding：深入理解 Linux 物理内存管理](https://www.xiaolincoding.com/os/3_memory/linux_mem2.html)

- CPU通过物理内存地址向物理内存读写数据的完整过程：
    ![image](./Pictures/linux-kernel/cpu_to_memory.avif)

### 热插拔（hotplug）

- 集群的规模一大，那么物理内存出故障的几率也会大大增加，物理内存的热插拔对提供集群高可用性也是至关重要的。

- 热插拔分为两个阶段：

    - 物理热插拔阶段：物理上将内存硬件插入（hot-add），拔出（hot-remove）主板的过程，其中涉及到硬件和内核的支持。

    - 逻辑热插拔阶段：由内核中的内存管理子系统来负责：

        - 如何动态的上线启用（online）对应的 hot-add 的内存

        - 如何动态下线（offline）对应的 hot-remove 的内存

- 拔出比插入更复杂

    - 拔出的物理内存中可能已经为进程分配了物理页，如何妥善安置这些已经被分配的物理页是一个棘手的问题。

### 三种内存模型

- 为了快速索引到具体的物理内存页，内核为每个物理页 struct page 结构体定义了一个索引编号：PFN（Page Frame Number）。

    - 内核提供了两个宏（page_to_pfn 与 pfn_to_page）：来完成 PFN 与 物理页结构体 struct page 之间的相互转换。

- 物理内存模型：如何组织管理这些物理内存页 struct page 的方式

- FLATMEM（平坦内存模型）：用一个数组来组织这些连续的、固定的物理内存页 struct page 结构，其在数组中对应的下标即为 PFN 。

    - Linux 早期使用的就是这种内存模型，因为在 Linux 发展的早期所需要管理的物理内存通常不大（比如几十 MB）

    ![image](./Pictures/linux-kernel/FLATMEM.avif)

    - 缺点：存在大量不连续的内存地址区间这种情况时，这些不连续的内存地址区间就形成了内存空洞。

        - 为这些空洞而分配的 struct page（每个40Bytes） 将会占用大量的内存空间，导致巨大的浪费。

    ![image](./Pictures/linux-kernel/FLATMEM1.avif)

- DISCONTIGMEM（非连续内存模型）：为了解决FLATMEM的空洞，用node管理连续的物理内存页，每个node还是FLATMEM
    - 缺点：物理内存的热插拔依然会导致node的不连续

    ![image](./Pictures/linux-kernel/DISCONTIGMEM.avif)

- SPARSEMEM（稀疏内存模型）：管理连续内存块的单元被称作 section（内核中用 struct mem_section 结构体表示）。用数组管理section

    - 物理页大小为 4k 的情况下， section 的大小为 128M ，物理页大小为 16k 的情况下， section 的大小为 512M。

    ![image](./Pictures/linux-kernel/SPARSEMEM.avif)

    - 每个 mem_section 都可以在系统运行时改变 offline ，online 状态，以便支持内存的热插拔

        - offline 时：内核会把这部分内存隔离开，使得该部分内存不可再被使用，然后再把 mem_section 中已经分配的内存页迁移到其他 mem_section 的内存上. 。

        ![image](./Pictures/linux-kernel/SPARSEMEM1.avif)

        - 并非所有的物理页都可以迁移：迁移只是物理内存地址的变化，对用户空间的虚拟地址没有问题

            - 但内核空间的虚拟地址中的直接映射区，它的虚拟地址与物理地址是直接映射的关系，虚拟内存地址直接减去一个固定的偏移量（0xC000 0000 ） 就得到了物理内存地址。

            - 解决方法：内存分类：分为不可迁移页，可回收页，可迁移页。将可能会被拔出的内存中只分配那些可迁移的内存页

### UMA

- SMP（Symmetric multiprocessing 对称多处理器）：所有的 CPU 访问内存都要过总线，并且它们的速度都是一样的。

    ![image](./Pictures/linux-kernel/uma.avif)

- 缺点：总线很快就会成为性能瓶颈，随着 CPU 个数的增多导致每个 CPU 可用带宽会减少

### NUMA（Non-uniform memory access，非一致存储访问结构）

- 为了解决UMA的总线瓶颈。NUMA 架构将每个 CPU 进行了分组，一个 Node 可能包含多个 CPU 。Node 之间可以通过互联模块总线（QPI）进行通信，这就导致了远程内存访问比本地访问多了额外的延迟开销

![image](./Pictures/linux-kernel/numa.avif)

- NUMA 的内存分配策略

| 内存分配策略      | 策略描述                                                                       |
|-------------------|--------------------------------------------------------------------------------|
| MPOL_BIND         | 必须在绑定的节点进行内存分配，如果内存不足，则进行 swap                        |
| MPOL_INTERLEAVE   | 本地节点和远程节点均可允许分配内存                                             |
| MPOL_PREFERRED    | 优先在指定节点分配内存，当指定节点内存不足时，选择离指定节点最近的节点分配内存 |
| MPOL_LOCAL (默认) | 优先在本地节点分配，当本地节点内存不足时，可以在远程节点分配内存               |

- numa的物理内存模型：

    - node_start_pfn 指向 NUMA node 内的第一个物理页 PFN。每个物理页的 PFN 都是全局唯一的

    - node_present_pages：统计 NUMA node 真正可用的物理页面数量（不包含内存空洞）

    - node_spanned_pages：统计 NUMA node 内所有的内存页（包含内存空洞）

    ![image](./Pictures/linux-kernel/numa-memory-model.avif)

- zone_type除了四大物理内存区域还有两个区域：

    - ZONE_DEVICE 是为支持热插拔设备而分配的非易失性内存（ Non Volatile Memory ），也可用于内核崩溃时保存相关的调试信息。

    - ZONE_MOVABLE：是一个虚拟区域包含这些物理区域（ZONE_DMA，ZONE_NORMAL，ZONE_HIGHMEM）。

        - 该区域的全部物理页都是可迁移的，主要是为了防止内存碎片和支持内存的热插拔。

        ![image](./Pictures/linux-kernel/ZONE_MOVABLE.avif)

    - 只有第一个 NUMA node 可以包含所有的物理内存区域

        ![image](./Pictures/linux-kernel/numa-memory-model1.avif)

    | NUMA node状态   | 内容
    |-----------------|--------------------------------------------|
    | N_NORMAL_MEMORY | 只有 ZONE_NORMAL，没有 ZONE_HIGHMEM        |
    | N_HIGH_MEMORY   | 有 ZONE_NORMAL 或者有 ZONE_HIGHMEM         |
    | N_MEMORY        | 有 ZONE_NORMAL，ZONE_HIGHMEM，ZONE_MOVABLE |
    | N_CPU           | 包含一个或多个 CPU。                       |

    - numa node状态中的热插拔（需要SPARSEMEM 稀疏内存模型）

        | NUMA node状态 | 内容                           |
        |---------------|--------------------------------|
        | N_POSSIBLE    | 在某个时刻可以变为 online 状态 |
        | N_ONLINE      | 当前的状态为 online 状态       |

    ```sh
    # /proc/zoneinfo 维护着vm_stat结构（物理内存使用的统计信息）
    # 查看NUMA node中内存区域的分布情况

    cat /proc/zoneinfo | grep Node
    Node 0, zone      DMA
    Node 0, zone    DMA32
    Node 0, zone   Normal
    Node 0, zone  Movable
    Node 0, zone   Device
    ```

    - struct zone：是内核中用于描述和管理 NUMA node中的物理内存区域的结构体。

        - 由于是一个访问非常频繁的结构体，因此使用了 spinlock_t lock 自旋锁来防止并发错误

        - 内核会为每一个内存区域分配一个伙伴系统用于管理该内存区域下物理内存的分配和释放。

            ![image](./Pictures/linux-kernel/numa-zone.avif)

```sh
# 查看 numa 配置
numactl --hardware

# 查看内存
numactl -s

# 查看node 的内存分配情况
numastat
```

- 通过调整 `/proc/sys/vm/zone_reclaim_mode` ：当某个 Node 内存不足时，系统可以从其他 Node 寻找空闲内存，也可以从本地内存中回收内存。

    - 访问远端 Node 的内存比访问本地内存要耗时很多

    ```sh
    cat /proc/sys/vm/zone_reclaim_mode
    0
    ```

    | 值           | 操作                                                                       |
    |--------------|----------------------------------------------------------------------------|
    | 0 （默认值） | 在回收本地内存之前，在其他 Node 寻找空闲内存                               |
    | 1            | 只回收本地内存                                                             |
    | 2            | 只回收本地内存，在本地回收内存时，可以将文件页中的脏页写回硬盘，以回收内存 |
    | 4            | 只回收本地内存，在本地回收内存时，可以用 swap 方式回收内存                 |

## 虚拟内存

- [小林coding：深入理解 Linux 虚拟内存管理](https://www.xiaolincoding.com/os/3_memory/linux_mem.html)

- [小林coding：为什么要有虚拟内存？](https://www.xiaolincoding.com/os/3_memory/vmem.html)

- `ps aux`： VSZ 为虚拟内存大小；RSS 为物理内存大小

    ```sh
    ps aux
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root           1  0.0  0.1 169088 13040 ?        Ss   Feb10   0:00 /sbin/init
    ```

### 分段

- 映射机制：

    - 段选择子：保存在段寄存器里面，包含段号用作段表的索引

    - 段表：包含段的基地址、段的界限和特权等级等。分段机制会分成4个段，每个段在段表都有段的基地址。段的基地址加上段内偏移量得到物理内存地址。

        ![image](./Pictures/linux-kernel/virtual-memory.avif)
        ![image](./Pictures/linux-kernel/virtual-memory1.avif)

- 缺点：

    - 没有内部碎片，而有外部碎片（进程之间的间隙）

    - 解决外部碎片的方法（swap效率低）：

        - 1.把音乐程序占用的那 256MB 内存写到swap上

        - 2.然后再从swap上读到紧跟 512MB 内存的后面。这样就能空缺出连续的 256MB 空间。

        ![image](./Pictures/linux-kernel/virtual-memory2.avif)

### 分页

- 解决分段的缺点：在内存交换时只写入少量固定的数据（页）。

- 把整个虚拟和物理地址切割成固定页（4KB），虚拟地址和物理地址通过页表进行映射，由cpu集成的硬件MMU（内存管理单元）负责转换

- 进程要访问的虚拟地址，在页表找不到的时候，就会产生**缺页中断**。`Page Fault Handler （缺页中断函数）` 就会分配物理地址，建立虚拟与物理地址的正向映射，更新页表。

- 页表项中除了物理地址之外，还有一些标记属性的比特，比如控制一个页的读写权限，标记该页是否存在等。在内存访问方面，操作系统提供了更好的安全性。

- 映射机制：

    - 页号：作为页表的索引

    - 页表：包含物理页每页所在物理内存的基地址。基地址加上页内偏移得到物理地址

        ![image](./Pictures/linux-kernel/virtual-memory3.avif)

- 优点：

    - swap效率高：

        - 内存不够时，根据机制把一部分页换出（写入）swap；需要时再换入（读取）

            ![image](./Pictures/linux-kernel/virtual-memory4.avif)

- 缺点：

    - 没有外部碎片，而有内部碎片（进程大小不足一页时，也要分配一页）

    - 页表本身占用很大的内存：

        - 一个页的大小是 4KB（2^12）

        - 在 32 位的环境下虚拟地址空间共有 4GB（2^20）个页，大概一百万个页

        - 一个「页表项」需要 4Bytes，4GB 就需要有 4Bytes * 2^20 = 4MB 的内存来存储页表。

        - 100 个进程的话，就需要 400MB 的内存来存储页。那64 位就更大了

    - 解决方法多级页表：

        - 二级分页：将一级页表分为 1024 个二级页表（4Bytes * 1024 = 4KB），每个二级页表中包含 1024 个「页表项」（4Bytes * 1024 * 1024 = 4MB)

            ![image](./Pictures/linux-kernel/virtual-memory5.avif)

            - 总大小：4KB + 4MB 比之前的一级分页还大4KB

                - 但一级页表就可以覆盖整个 4GB 虚拟地址空间，如果某个一级页表的页表项没有被用到，也就不需要创建这个页表项对应的二级页表了。

                    - 假设只有 20% 的一级页表项被用到：4KB（一级页表） + 20% * 4MB（二级页表）= 0.804MB

        - 64位需要四级分页：

            | 四级分页                                  |
            |-------------------------------------------|
            | 全局页目录项 PGD（Page Global Directory） |
            | 上层页目录项 PUD（Page Upper Directory）  |
            | 中间页目录项 PMD（Page Middle Directory） |
            | 页表项 PTE（Page Table Entry）            |

            ![image](./Pictures/linux-kernel/virtual-memory6.avif)
            ![image](./Pictures/linux-kernel/virtual-memory-32.avif)
            ![image](./Pictures/linux-kernel/virtual-memory-64.avif)

#### TLB

TLB（Translation Lookaside Buffer）：页表的缓存，集成在cpu内部

### 段页式内存管理（分段 + 分页）

段页式内存管理：先分段，每个段再分页

- 段页式地址变换中要得到物理地址须经过三次内存访问：
    - 1.访问段表，得到页表起始地址
    - 2.访问页表，得到物理页号
    - 3.将物理页号与页内位移组合，得到物理地址

    ![image](./Pictures/linux-kernel/virtual-memory7.avif)

#### linux实现

- Linux的虚拟地址空间：分为内核空间和用户空间两部分

    - 32位
    ![image](./Pictures/linux-kernel/kernel-memory.avif)

    - 64 位：只使用了 48 位来描述虚拟内存空间，寻址范围为 2^48（256TB）。多出的高 16 位就形成了这个地址空洞（canonical address）。
        - 用户空间高16位全为0；内核空间高16位全为1；空洞地址的高16位不全为0也不全为1
    ![image](./Pictures/linux-kernel/kernel-memory1.avif)

##### 内核空间

- [小林coding：内核虚拟内存空间](https://www.xiaolincoding.com/os/3_memory/linux_mem.html#_7-%E5%86%85%E6%A0%B8%E8%99%9A%E6%8B%9F%E5%86%85%E5%AD%98%E7%A9%BA%E9%97%B4)

    ![image](./Pictures/linux-kernel/kernel-memory2.avif)

    > 自底向上解释每个映射区

    - 1.DMA:在 X86 体系结构下，ISA 总线的 DMA （直接内存存取）控制器，只能对内存的前16M 进行寻址，这就导致了 ISA 设备不能在整个 32 位地址空间中执行 DMA，只能使用物理内存的前 16M 进行 DMA 操作。

    - 2.直接映射区（ZONE_NORMAL）：

        - 一共896MB。前 1M 已经在系统启动的时候被系统占用，1M 之后的物理内存存放的是内核代码段，数据段，BSS 段

        - 在内核运行的过程中，会涉及内核栈的分配，内核会为每个进程分配一个固定大小的内核栈（一般是两个页大小，依赖具体的体系结构），每个进程的整个调用链必须放在自己的内核栈中，内核栈也是分配在直接映射区。

    - 3.vmalloc 动态映射区：将不连续的物理内存映射到连续的虚拟内存上。因此它只能将这些物理内存页一个一个地进行映射，在性能开销上会比直接映射大得多。

        ![image](./Pictures/linux-kernel/kernel-memory3.avif)

    - 4.永久映射区：内核通过 `alloc_pages()` 申请的物理内存页，可以通过调用 kmap 映射到永久映射区
    - 5.固定映射区：在固定映射区中虚拟地址是固定的，而被映射的物理地址是可以改变的
    - 6.临时映射区：临时映射，所以在拷贝完成之后，调用 kunmap_atomic 将这段映射再解除掉。

- 内核内存分配两种方式：

    - 1.当进程请求内核分配内存时，如果此时内存比较充裕，那么进程的请求会被立刻满足，如果此时内存已经比较紧张，内核就需要将一部分不经常使用的内存进行回收，从而腾出一部分内存满足进程的内存分配的请求，在这个回收内存的过程中，进程会一直阻塞等待。

    - 2.进程是不允许阻塞的，内存分配的请求必须马上得到满足，比如执行中断处理程序、执行持有自旋锁等临界区内的代码时，进程就不允许睡眠，因为中断程序无法被重新调度。这需要提前为预留一部分内存，当内存紧张时，可以分配。

- 高位内存区域对低位内存区域进行挤压

    - 当 ZONE_HIGHMEM 区域中的内存不足时，内核可以从 ZONE_NORMAL 进行内存分配

    - ZONE_NORMAL 区域内存不足时可以进一步降级到 ZONE_DMA 区域进行分配

    - 但不允许无限制挤压占用

        - 每个内存区域会给自己预留一定的内存（`lowmem_reserve` 数组）

            ```sh
            # 从左到右： ZONE_DMA，ZONE_DMA32，ZONE_NORMAL，ZONE_MOVABLE，ZONE_DEVICE 物理内存区域的预留内存比例
            # 64位没有ZONE_HIGHMEM
            cat /proc/sys/vm/lowmem_reserve_ratio
            256 256 32  0   0

            # sysctl命令查看lowmem_reserve_ratio
            sysctl vm.lowmem_reserve_ratio
            vm.lowmem_reserve_ratio = 256	256	32	0	0
            ```

            | 物理内存区域 | lowmem_reserve_ratio | 内存区域大小 | 物理内存页个数 |
            |--------------|----------------------|--------------|----------------|
            | ZONE_DMA     | 256                  | 8M           | 2048           |
            | ZONE_NORMAL  | 32                   | 64M          | 16384          |
            | ZONE_HIGHMEM | 0                    | 256M         | 65536          |

        - 预留的物理内存页个数：

            ZONE_DMA 为防止被 ZONE_NORMAL 挤压侵占：16384 / 256 = 64。

            ZONE_DMA 为防止被 ZONE_HIGHMEM 挤压侵占：(65536 + 16384) / 256 = 320。

            ZONE_NORMAL 为防止被 ZONE_HIGHMEM 挤压侵占：65536 / 32 = 2048。



##### 用户空间

![image](./Pictures/linux-kernel/virtual-memory12.avif)

| 用户空间           |                                                                          |
|--------------------|--------------------------------------------------------------------------|
| 代码段（text）     | 二进制可执行代码                                                         |
| 数据段（data）     | 已初始化的静态常量和全局变量                                             |
| BSS 段             | 未初始化的静态变量和全局变量                                             |
| 堆段（heap）       | 动态分配的内存，从低地址开始向上增长                                     |
| 文件映射段（mmap） | 动态库（如glibc）的代码段、数据段、BSS 段，mmap 系统调用映射的共享内存区 |
| 栈段（stack）      | 局部变量、函数调用的上下文等。默认为 8 MB                                |

- 修改栈段（stack）大小：

    ```sh
    # 查看stack大小，默认为8MB
    ulimit -s
    8192

    # 修改为16MB
    ulimit -s 16384
    ```

- 7 个内存段中，堆 `malloc()` 和文件映射段 `mmap()` 的内存是动态分配的。

- 图片的灰色部分是保留区（非法），比如C 的代码里会将无效的指针赋值为 NULL

- 子进程与线程的虚拟内存：

    > 进程和线程之间的本质区别：是否共享地址（mm_struct 结构体）

    - 子进程：`fork()` 函数创建的子进程虚拟内存，是直接父进程的拷贝

    - 线程：`vfork()` 或者 `clone()` 系统调用创建出的子进程会设置 `CLONE_VM 标识` ，父进程和子进程的虚拟内存空间就变成共享的了，并不是一份拷贝。

- [小林coding：定义虚拟内存区域的访问权限和行为规范](https://www.xiaolincoding.com/os/3_memory/linux_mem.html#_5-4-%E5%AE%9A%E4%B9%89%E8%99%9A%E6%8B%9F%E5%86%85%E5%AD%98%E5%8C%BA%E5%9F%9F%E7%9A%84%E8%AE%BF%E9%97%AE%E6%9D%83%E9%99%90%E5%92%8C%E8%A1%8C%E4%B8%BA%E8%A7%84%E8%8C%83)

    | vm_flags     | 访问权限               |
    |--------------|------------------------|
    | VM_READ      | 可读                   |
    | VM_WRITE     | 可写                   |
    | VM_EXEC      | 可执行                 |
    | VM_SHARD     | 可多进程之间共享       |
    | VM_IO        | 可映射至设备 IO 空间   |
    | VM_RESERVED  | 内存区域不可被换出     |
    | VM_SEQ_READ  | 内存区域可能被顺序访问 |
    | VM_RAND_READ | 内存区域可能被随机访问 |

    | 虚拟内存段           | 可读 | 可写 | 可执行 |
    |----------------------|------|------|--------|
    | 栈                   | yes  | yes  | no     |
    | 文件映射与匿名映射区 | yes  | yes  | yes    |
    | 堆                   | yes  | yes  | yes    |
    | 数据段               | yes  | yes  | no     |
    | 代码段               | yes  | no   | yes    |

    ![image](./Pictures/linux-kernel/virtual-memory10.avif)

- [小林coding：虚拟内存区域在内核中是如何被组织的](https://www.xiaolincoding.com/os/3_memory/linux_mem.html#_5-7-%E8%99%9A%E6%8B%9F%E5%86%85%E5%AD%98%E5%8C%BA%E5%9F%9F%E5%9C%A8%E5%86%85%E6%A0%B8%E4%B8%AD%E6%98%AF%E5%A6%82%E4%BD%95%E8%A2%AB%E7%BB%84%E7%BB%87%E7%9A%84)

    - vm_area_struct 会有两种组织形式：

        - 双向链表获取：`cat /proc/<pid>/maps` 或者 `pmap <pid>` 查看进程的虚拟内存空间布局

        - 红黑树：查找特定的虚拟内存区域时使用

        ![image](./Pictures/linux-kernel/virtual-memory11.avif)

- ELF

    - 磁盘文件中的段 Section；内存中的段 Segment

    - 进程运行之前：磁盘的Section 会加载到内存中并映射到内存中的 Segment。通常是多个 Section 映射到一个 Segment。

    | Section         | Segment              |
    |-----------------|----------------------|
    | .text（只读）   | 代码段（只读可执行） |
    | .rodata（只读） | 代码段（只读可执行） |
    | .data（可读写） | 数据段（可读写）     |
    | .bss （可读写） | BSS 段（可读写）     |

#### malloc 是如何分配内存的？

- [小林coding：malloc 是如何分配内存的？](https://www.xiaolincoding.com/os/3_memory/malloc.html)

- malloc的两种分配内存方式：

    - 1.内存小于 128 KB：brk() 系统调用从堆分配内存

        ![image](./Pictures/linux-kernel/malloc.avif)

        - `cat /proc/<pid>/maps` 查看内存分配：有 `[heap]` 的标志

        - `free()` 释放内存后，会缓存在内存池，再次申请 相同的内存时就可以直接复用。减少了系统调用的次数，也减少了缺页中断的次数

            - 为什么不全部使用 `brk()` 来分配？ 堆内将产生越来越多不可用的碎片，导致“内存泄露”。而且无法使用 valgrind的工具 检测出来。

                ![image](./Pictures/linux-kernel/malloc2.avif)


    - 2.内存大于等于 128 KB：mmap() 系统调用在文件映射区域分配内存

        ![image](./Pictures/linux-kernel/malloc1.avif)

        - `cat /proc/<pid>/maps` 查看内存分配：没有 `[heap]` 的标志

        - `free()` 释放内存后，会真正的释放

- malloc分配的是虚拟内存，只有访问虚拟内存时才会触发 `缺页中断`

- malloc(1) 会分配多大的虚拟内存？malloc()会预分配更大的空间作为内存池，与内存管理器有关。

    | 内存管理器 | 实现者                    |
    |------------|---------------------------|
    | dlmalloc   | General purpose allocator |
    | ptmalloc2  | glibc                     |
    | jemalloc   | FreeBSD and Firefox       |
    | tcmalloc   | Google                    |
    | libumem    | Solaris                   |

    - 可以通过`cat /proc/<pid>/maps` 查看：

        ```
        562c319c2000-562c319e3000 rw-p 00000000 00:00 0                          [heap]
        ```

        - ptmalloc的`malloc(1)` 内存分配为：562c319e3000 - 562c319c2000 = 21000（转换为十进制135168 / 2 ^ 10 = 132KB）

- malloc() 返回的起始地址多了 16 字节：这16 字节就是保存了该内存块的描述信息，比如有该内存块的大小。执行 free() 函数时，就能知道释放多大的内存了

    ![image](./Pictures/linux-kernel/malloc3.avif)

#### 内存回收

##### 用户空间

- [小林coding：内存满了，会发生什么？](https://www.xiaolincoding.com/os/3_memory/mem_reclaim.html)

- 发生缺页中断后，缺页中断函数会看是否有空闲的物理内存，如果没有就执行内存回收

- 文件页回收：通过 pflush 内核线程

- 匿名页回收：

    ![image](./Pictures/linux-kernel/memory-not-enough.avif)

    - 后台内存回收（kswapd）：异步的，不会阻塞进程的执行

    - 直接内存回收（direct reclaim）：同步的，会阻塞进程的执行

    - 直接内存回收后还是不够：触发 OOM （Out of Memory）机制：

        - `oom_badness()` 可以被杀掉的进程扫描一遍，并对每个进程打分，得分最高的进程就会被首先杀掉；如果还是不够，找到下一个进程继续杀掉，直到够。得分计算：

            - 1.进程已经使用的物理内存页面数。

            - 2.每个进程的oom_score_adj。可以通过 `/proc/<pid>/oom_score_adj` 来调整的进程被 OOM Kill 的几率，数值为-1000 到 1000 

    - `sar -B 1` 命令，查看后台、直接内存回收的指标

        ![image](./Pictures/linux-kernel/memory-recovery.avif)

        | 指标      | 内容                                                                                                    |
        |-----------|---------------------------------------------------------------------------------------------------------|
        | pgscank/s | kswapd(后台回收线程) 每秒扫描的 page 个数                                                               |
        | pgscand/s | 应用程序在内存申请过程中每秒直接扫描的 page 个数。如果在抖动的时数值很大，那么大概率是**直接内存回收** |
        | pgsteal/s | 扫描的 page 中每秒被回收的个数（pgscank+pgscand）                                                       |

- 什么条件下才能触发 kswapd 内核线程回收内存呢？定义了三个内存阈值（watermark，也称为水位），用来衡量当前剩余内存（pages_free）是否充裕

    ![image](./Pictures/linux-kernel/memory-kswapd.avif)

    - kswapd 会定期扫描内存的使用情况，根据剩余内存（pages_free）的情况来进行内存回收的工作。

         | 剩余内存量               | 操作                                                                                  |
         |--------------------------|---------------------------------------------------------------------------------------|
         | pages_free在图中绿色部分 | 充足                                                                                  |
         | pages_free在图中蓝色部分 | 内存有一定压力，但还可以满足应用程序申请内存的请求                                    |
         | pages_free在图中橙色部分 | 内存压力比较大，剩余内存不多了。触发 kswapd0 执行内存回收，直到回到图中绿色部分为止。 |
         | pages_free在图中红色部分 | 用户可用内存都耗尽了。触发**直接内存回收**                                            |

    - 通过 `/proc/sys/vm/min_free_kbytes` 调整pages_min值，并间接调整其他值：

        ```sh
        # kswapd 的活动空间只有 pages_low 与 pages_min 之间（也就是图中橙色部分）
        cat /proc/sys/vm/min_free_kbytes
        67584
        ```

        - pages_high和pages_low都是根据pages_min计算的：

            ```
            pages_min = min_free_kbytes
            pages_low = pages_min*5/4
            pages_high = pages_min*3/2
            ```

    - 调整`min_free_kbytes`时要考虑应用程序关注什么：如果关注延迟，就增大；如果关注内存的使用量，就调小
        - 增大：会使得系统预留过多的空闲内存，从而在一定程度上降低了应用程序可使用的内存量，这在一定程度上浪费了内存。

        - min_free_kbytes 接近实际物理内存大小时：可能会频繁地导致 OOM 的发生。

- 哪些内存可以被回收？

    - 文件页（File-backed Page）：内核缓存的磁盘数据（Buffer）和内核缓存的文件数据（Cache）都叫作文件页。大部分文件页，都可以直接释放内存，以后有需要时，再从磁盘重新读取就可以了。

        - 而那些被应用程序修改过，并且暂时还没写入磁盘的数据（也就是脏页），就得先写入磁盘，然后才能进行内存释放。所以，回收干净页的方式是直接释放内存，回收脏页的方式是先写回磁盘后再释放内存。

            - 进程可以通过 `fsync()` 系统调用：将指定文件的所有脏页同步回写到磁盘

        - 对性能的影响：干净页直接释放内存，不影响；脏页会先写回到磁盘再释放内存，影响

    - 匿名页（Anonymous Page）：这部分内存没有实际载体，不像文件缓存有硬盘文件这样一个载体，比如堆、栈数据等。

        - 这部分内存很可能还要再次被访问，所以不能直接释放内存，它们回收的方式是通过 Linux 的 Swap 机制，Swap 会把不常访问的内存先写到磁盘中，然后释放这些内存，给其他更需要的进程使用。再次访问这些内存时，重新从磁盘读入内存就可以了。

        - 对性能的影响：Swap 会影响性能

    - 调整文件页和匿名页的回收倾向

        ```sh
        # 数值为0-100（默认为60）。越大越积极回收匿名页；越小越积极回收文件页，因此一般建议设置为0，但是并不代表不会回收匿名页。
        cat /proc/sys/vm/swappiness
        60
        ```

    - 文件页、匿名页都是根据LRU算法进行回收，维护着 active 和 inactive 两个双向链表：

        - 1.active_list 活跃内存页链表，这里存放的是最近被访问过（活跃）的内存页

        - 2.inactive_list 不活跃内存页链表，这里存放的是很少被访问（非活跃）的内存页

        ```sh
        # 查看两个链表内的文件页、匿名页
        cat /proc/meminfo | grep -i active | sort

        Active:          1173476 kB
        Active(anon):      22620 kB
        Active(file):    1150856 kB
        Inactive:        5501408 kB
        Inactive(anon):  4441512 kB
        Inactive(file):  1059896 kB
        ```

    - 为何要设置有两个链表？

        - [小林coding：如何避免预读失效和缓存污染的问题？](https://www.xiaolincoding.com/os/3_memory/cache_lru.html)

        - linux有预读机制。read 系统调动读取 4KB 数据，实际上内核使用预读机制（ReadaHead） 机制完成了 16KB 数据的读取，也就是通过一次磁盘顺序读将多个 Page 数据装入 Page Cache。

        - 如果预读失效，传统的LRU单链表就可能淘汰了热点数据，降低缓冲命中率。因此加入双链表。

            - inactive：存放预读的页

            - active：inactive预读的页成功的访问后，在从inactive中升级到active头部；而active末尾的页，降级inactive的头部

            ![image](./Pictures/linux-kernel/active_inactive.avif)

            - MySQL Innodb也有相应的机制：分为old、young，在同一个链表内young的比例为7，old为3

                ![image](./Pictures/linux-kernel/mysql-lru.avif)
                ![image](./Pictures/linux-kernel/mysql-lru1.avif)

        - 缓存污染：大量的预读页只访问一次就进active、young，淘汰到可能是热点的页。如果以后都不访问，就导致缓存污染。

            - 解决方法：提高门槛

                - Linux：在内存页被访问第二次的时候，才将页从 inactive list 升级到 active list 里。

                - MySQL Innodb：在内存页被访问第二次访问的时候，以及第二次访问与第一次的间隔时间：

                    - 1 秒内（默认值）：不会升级

                    - 超过 1 秒：升级

#### 在 4GB 物理内存的机器上，申请 8G 内存会怎么样？

- [小林coding：在 4GB 物理内存的机器上，申请 8G 内存会怎么样？](https://www.xiaolincoding.com/os/3_memory/alloc_mem.html)

- 3G内存，申请8G内存：

    - 32 位：进程最多只能申请 3 GB 大小的虚拟内存空间，所以进程申请 8GB 内存的话，在申请虚拟内存阶段就会失败

    - 64位：进程申请 8GB 内存是没问题的，只要不读写这个虚拟内存，操作系统就不会分配物理内存。

- 64位，2G内存，申请4G内存：

    - `/proc/sys/vm/overcommit_memory` 调整申请内存是否允许overcommit

        | 值          | 操作                                                                                                                                                                                                                                                                                                                                     |
        |-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
        | 0（默认值） | Heuristic overcommit handling，它允许overcommit，但过于明目张胆的overcommit会被拒绝，比如malloc一次性申请的内存大小就超过了系统总内存。Heuristic的意思是“试探式的”，内核利用某种算法猜测你的内存申请是否合理，大概可以理解为单次申请不能超过free memory + free swap + pagecache的大小 + SLAB中可回收的部分 ，超过了就会拒绝overcommit。 |
        | 1           | Always overcommit. 允许overcommit，对内存申请来者不拒。                                                                                                                                                                                                                                                                                  |
        | 2           | Don’t overcommit. 禁止overcommit。                                                                                                                                                                                                                                                                                                       |

    - `overcommit_memory`为0时：Cannot allocate memory 错误

    - `overcommit_memory`为1时：成功

- 64位，2G内存，`overcommit_memory` 设置为1，，申请128T内存：

    - 关闭swap：触发oom后被kill掉。因为申请虚拟内存过程中本身需要内存，2G内存不够。

    - 开启swap：成功申请

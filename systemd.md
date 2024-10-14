
<!-- mtoc-start -->

* [systemd](#systemd)
  * [all in one（非unix）哲学](#all-in-one非unix哲学)
  * [init](#init)
  * [systemd](#systemd-1)
    * [基本使用](#基本使用)
    * [创建systemd unit 服务](#创建systemd-unit-服务)
    * [咸鱼运维杂谈：运维排查 | Systemd 之服务停止后状态为 failed](#咸鱼运维杂谈运维排查--systemd-之服务停止后状态为-failed)
  * [systemctl](#systemctl)
    * [unmask](#unmask)
    * [常见启动问题](#常见启动问题)
      * [爱可生开源社区：故障分析 | MySQL 通过 systemd 启动时 hang 住了……](#爱可生开源社区故障分析--mysql-通过-systemd-启动时-hang-住了)
  * [hostnamectl, localectl, timedatectl, loginctl命令](#hostnamectl-localectl-timedatectl-loginctl命令)
  * [journalctl（日志）](#journalctl日志)
    * [systemd-journald的进程服务](#systemd-journald的进程服务)
    * [持久化存储or内存存储](#持久化存储or内存存储)
    * [速率限制](#速率限制)
    * [日志接收和转发](#日志接收和转发)
      * [rsyslog](#rsyslog)
      * [kmsg](#kmsg)
      * [console](#console)
      * [wall](#wall)
    * [基本使用](#基本使用-1)
    * [实战调试](#实战调试)
      * [查看错误](#查看错误)
      * [解决办法](#解决办法)
  * [Timers（定时器）](#timers定时器)
* [referece](#referece)

<!-- mtoc-end -->

# systemd

## all in one（非unix）哲学

- [《The Tragedy of systemd（systemd的悲剧）》视频演讲](https://www.bilibili.com/video/BV1oo4y1x7Nw)

    - bsd一直遵循着unix哲学，也就是一个程序只做好一件事。因此bsd的用户排斥什么都做的systemd，并对使用着systemd的其他unix系统用户说：“我们永远也不会改变（使用sysmtemd）赶快加入我们吧”。即认为没有systemd是一种幸运，而演讲者则认为这非但不是幸运，反而是bsd的一种缺失。演讲者是freebsd的开发者，演讲的题目是《systemd的悲剧》看起来似乎是嘲讽systemd的主题演讲，但实际恰恰相反演讲者指出systemd的一些理念和优点，它和windows和macos/ios的服务管理是类似的哲学，它解决了特定的问题，并认为遵循unix的人们应该要作出change（改变）。伟大的领导者是能改变人们使用习惯的人。

    - systemd是依赖于linux的，就像launch依赖与macos/ios一样

    ![image](./Pictures/systemd/systemd.gif)

## init

- init 程序的发展分为三个阶段：`sysvinit`->`upstart`->`systemd`

    - sysvinit：以脚本串行的方式启动服务。下一个进程的启动，必须等待上一个进程启动完成。

    - upstart：在sysvinit的基础上，对没有关联依赖的进程并行启动。

    - systemd：使用socket激活机制，无论有没有关联依赖都并行启动。

        - 1.一个进程启动另一个进程时，一般是执行系统调用 `exec()`，systemd 在调用 exec()来启动服务之前，先创建与该服务关联的监听套接字并激活，然后在 exec()启动服务期间把套接字传递给它

        - 2.systemd 为所有的服务创建socket，即使一个服务需要依赖于另一个服务，但由于socket已经准备好，服务之间可以直接进行连接并继续执行启动

            - 如果遇到了需要同步的请求，不得不等待阻塞的情况，那阻塞的也将只会是一个服务，并且只是一个服务的一个请求，不会影响其他服务的启动

            - linux提供了socket缓冲区功能：如果遇到服务启动比较慢时，客户端向服务发送请求消息， 消息会发送到对应服务的socket缓冲区，只要缓冲区未满，客户端就不需要等待并继续往下执行

    ```sh
    # 第一个进程init实际是systemd
    ps 1
    # output
        PID TTY      STAT   TIME COMMAND
          1 ?        Ss     0:00 /sbin/init

    ls -ld /sbin/init
    # output
    lrwxrwxrwx 22 root  3 May 14:41 /sbin/init -> ../lib/systemd/systemd
    ```

## systemd

- systemd 的启动顺序：`default.target-> multi-user.target-> basic.target-> sysinit.target-> local-fs.target`

    - 1.`default.target`：是执行的第一个目标。但实际上 `default.target` 是指向 `graphical.target` 的软链接

        ```sh
        systemctl get-default
        #output
        graphical.target
        ```

        ```sh
        grep Requires= /usr/lib/systemd/system/graphical.target
        #output
        Requires=multi-user.target
        ```

    - 2.`multi-user.target`：为多用户支持设定系统环境。非 root 用户会在这个阶段的引导过程中启用。防火墙相关的服务也会在这个阶段启动。

        ```sh
        ls /etc/systemd/system/multi-user.target.wants
        #output
        libvirtd.service    NetworkManager.service  remote-fs.target  v2ray.service
        lm_sensors.service  privoxy.service         sysstat.service
        ```

    - `multi-user.target`会将控制权交给另一层`basic.target`。

        ```sh
        grep Requires= /usr/lib/systemd/system/multi-user.target
        #output
        Requires=basic.targe
        ```

    - 3.`basic.target`：用于启动普通服务特别是图形管理服务。它通过`/etc/systemd/system/basic.target.wants` 目录来决定哪些服务会被启动。`basic.target`之后将控制权交给`sysinit.target`.

        ```sh
        grep Requires= /usr/lib/systemd/system/basic.target
        #output
        Requires=sysinit.target
        ```

    - 4.`sysinit.target`：会启动重要的系统服务例如系统挂载，内存交换空间和设备，内核补充选项等等。`sysinit.target` 在启动过程中会传递给 `local-fs.target`

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

    - 5.`local-fs.target`：不会启动用户相关的服务，它只处理底层核心服务,它会根据`/etc/fstab`和`/etc/inittab`来执行相关操作。

### 基本使用

```sh
# 查看启动时间
systemd-analyze time

# 列出每个 units 启动时间
systemd-analyze blame

# 查看瀑布状的启动过程流
systemd-analyze critical-chain
```

- 可视化每个 units 的启动时间

```sh
systemd-analyze plot > boot.svg
google-chrome-stable boot.svg #用浏览器打开
```

![image](./Pictures/systemd/1.avif)

### 创建systemd unit 服务

- [unit配置的官方文档](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)

- [ruanyifeng：Systemd 入门教程：实战篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)

- `[Unit]`- ：通常是第一个区块，定义与其它unit的关系

    | [Unit]字段    | 内容                                                                   |
    |---------------|------------------------------------------------------------------------|
    | Description   | 简短描述                                                               |
    | Documentation | 文档地址                                                               |
    | Requires      | 当前 Unit 依赖的其他 Unit，如果它们没有运行，当前 Unit 会启动失败      |
    | Wants         | 与当前 Unit 配合的其他 Unit，如果它们没有运行，当前 Unit 不会启动失败 |
    | BindsTo       | 与Requires类似，它指定的 Unit 如果退出，会导致当前 Unit 停止运行       |
    | Before        | 如果该字段指定的 Unit 也要启动，那么必须在当前 Unit 之后启动           |
    | After         | 如果该字段指定的 Unit 也要启动，那么必须在当前 Unit 之前启动           |
    | Conflicts     | 这里指定的 Unit 不能与当前 Unit 同时运行                               |
    | Condition...  | 当前 Unit 运行必须满足的条件，否则不会运行                             |
    | Assert...     | 当前 Unit 运行必须满足的条件，否则会报启动失败                         |

    - `After`和`Before`字段只涉及启动和关闭顺序，不涉及依赖关系。
        - 某 Web 应用需要 postgresql 数据库储存数据。在配置文件中，它只定义要在 postgresql 之后启动，而没有定义依赖 postgresql 。上线后，由于某种原因，postgresql 需要重新启动，在停止服务期间，该 Web 应用就会无法建立数据库连接。

    - `Wants`和`Requires`字段，有依赖关系

        - `Wants`：表示sshd.service与sshd-keygen.service之间存在"弱依赖"关系，即如果"sshd-keygen.service"启动失败或停止运行，不影响sshd.service继续执行。

        - `Requires`：则表示"强依赖"关系，即如果该服务启动失败或异常退出，那么sshd.service也必须退出。

    - `Conflicts`字段：定义与其它unit有冲突关系。其中一个start时，另一个会stop

    - 例子：

        - [systemd-by-example-part-2-dependencies](https://seb.jambor.dev/posts/systemd-by-example-part-2-dependencies/)

        ![image](./Pictures/systemd/all-requirement-dependencies.avif)

        - 1.当启动`d.service`时：`e.service`也会被启动（start）。但由于没有定义启动顺序，两者是并行启动
        - 2.当启动`a.service`时：
            - `b.service` 和 `c.service` 都会被并行启动。
            - 由于`c.service`和`e.service`是Conflicts关系，而且`e.service`被`d.service` Requires。所以`e.service`和`d.service`会被关闭（stop），并且是并行关闭。

        - 3.当`b.service`启动失败时（fail）：由于被`a.service`Requires，所以`a.service`会关闭。

- `[Service]`只有service类型，才有的区块

    | [Service]字段 | 内容                                                                                                                                |
    |---------------|-------------------------------------------------------------------------------------------------------------------------------------|
    | ExecStart     | 启动当前服务的命令                                                                                                                  |
    | ExecStartPre  | 启动当前服务之前执行的命令                                                                                                          |
    | ExecStartPost | 启动当前服务之后执行的命令                                                                                                          |
    | ExecReload    | 重启当前服务时执行的命令                                                                                                            |
    | ExecStop      | 停止当前服务时执行的命令                                                                                                            |
    | ExecStopPost  | 停止当其服务之后执行的命令                                                                                                          |
    | RestartSec    | 自动重启当前服务间隔的秒数                                                                                                          |
    | Restart       | 定义何种情况 Systemd 会自动重启当前服务，可能的值包括always（总是重启）、on-success、on-failure、on-abnormal、on-abort、on-watchdog |
    | TimeoutSec    | 定义 Systemd 停止当前服务之前等待的秒数                                                                                             |
    | Environment   | 指定环境变量                                                                                                                        |

    - `-`：表示"抑制错误"，即发生错误的时候，不影响其他命令的执行。比如：`EnvironmentFile=-/etc/sysconfig/sshd`

    - `Type`字段：表示启动类型

        | TYPE字段类型     | 内容                                                                                                                |
        |------------------|---------------------------------------------------------------------------------------------------------------------|
        | simple（默认值） | ExecStart字段启动的进程为主进程                                                                                     |
        | forking          | ExecStart字段将以fork()方式启动，此时父进程将会退出，子进程将成为主进程                                             |
        | oneshot          | 类似于simple，但只执行一次，Systemd 会等它执行完，才启动其他服务                                                    |
        | dbus             | 类似于simple，但会等待 D-Bus 信号后启动                                                                             |
        | notify           | 类似于simple，启动结束后会发出通知信号，然后 Systemd 再启动其他服务                                                 |
        | idle             | 类似于simple，但是要等到其他任务都执行完，才会启动该服务。一种使用场合是为让该服务的输出，不与其他服务的输出相混合 |

        - `oneshot`的例子：笔记本电脑启动时，要把触摸板关掉
            ```systemd
            [Unit]
            Description=Switch-off Touchpad

            [Service]
            Type=oneshot
            ExecStart=/usr/bin/touchpad-off

            [Install]
            WantedBy=multi-user.target
            ```

            - 上面的触控板例子的配置文件，启动类型设为oneshot，就表明这个服务只要运行一次就够了，不需要长期运行。如果关闭以后，将来某个时候还想打开，配置文件修改如下。

                - `RemainAfterExit`字段设为yes，表示进程退出以后，服务仍然保持执行。这样的话，一旦使用systemctl stop命令停止服务，ExecStop指定的命令就会执行，从而重新开启触摸板。

                ```systemd
                [Unit]
                Description=Switch-off Touchpad

                [Service]
                Type=oneshot
                ExecStart=/usr/bin/touchpad-off start
                ExecStop=/usr/bin/touchpad-off stop
                RemainAfterExit=yes

                [Install]
                WantedBy=multi-user.target
                ```

    - `KillMode`：如何停止服务
        | KillMode字段            | 内容                                               |
        |-------------------------|----------------------------------------------------|
        | control-group（默认值） | 当前控制组里面的所有子进程，都会被杀掉             |
        | process                 | 只杀主进程                                         |
        | mixed                   | 主进程将收到 SIGTERM 信号，子进程收到 SIGKILL 信号 |
        | none                    | 没有进程会被杀掉，只是执行服务的 stop 命令。       |

    - `Restart`：如何重启服务
        | Restart字段  | 内容                                                          |
        |--------------|---------------------------------------------------------------|
        | no（默认值） | 退出后不会重启                                                |
        | on-success   | 只有正常退出时（退出状态码为0），才会重启                     |
        | on-failure   | 非正常退出时（退出状态码非0），包括被信号终止和超时，才会重启 |
        | on-abnormal  | 只有被信号终止和超时，才会重启                                |
        | on-abort     | 只有在收到没有捕捉到的信号终止时，才会重启                    |
        | on-watchdog  | 超时退出，才会重启                                            |
        | always       | 不管是什么退出原因，总是重启                                  |

        - 对于守护进程，推荐设为`on-failure`。对于那些允许发生错误退出的服务，可以设为`on-abnormal`

    - `RestartSec`：重启服务之前，需要等待的秒数。

- `[Install]`：通常是配置文件的最后一个区块，用来定义如何启动，以及是否开机启动

    | [Install]字段 | 内容                                                                                                                                  |
    |---------------|---------------------------------------------------------------------------------------------------------------------------------------|
    | WantedBy      | 它的值是一个或多个 Target，当前 Unit 激活时（enable）符号链接会放入/etc/systemd/system目录下面以 Target 名 + .wants后缀构成的子目录中 |
    | RequiredBy    | 它的值是一个或多个 Target，当前 Unit 激活时，符号链接会放入/etc/systemd/system目录下面以 Target 名 + .required后缀构成的子目录中     |
    | Alias         | 当前 Unit 可用于启动的别名                                                                                                            |
    | Also          | 当前 Unit 激活（enable）时，会被同时激活的其他 Unit                                                                                   |

    - Target 的含义是服务组，表示一组服务。`WantedBy=multi-user.target`指的是，kafka 和 zookeeper 所在的 Target 是 multi-user.target。

        ```sh
        systemctl get-default
        multi-user.target
        ```

        - 这个设置非常重要，因为执行systemctl enable 命令时，zookeeper .service 的一个符号链接，就会放在/etc/systemd/system目录下面的multi-user.target.wants子目录之中。

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

### [咸鱼运维杂谈：运维排查 | Systemd 之服务停止后状态为 failed](https://mp.weixin.qq.com/s/l30kvYhga3YZO__ac0-cWg)

- zookeeper 是通过源码编译来安装，为了方便管理，决定改成通过 systemd 来管理。

    ```sh
    # zookeeper
    [Unit]
    Description=Zookeeper
    After=network.target

    [Service]
    Type=forking
    ExecStart=/opt/zookeeper/bin/zkServer.sh start
    ExecStop=/opt/zookeeper/bin/zkServer.sh stop
    PIDFile=/var/lib/zookeeper/zookeeper_server.pid

    [Install]
    WantedBy=multi-user.target
    ```

- 问题：
    - ` systemctl start zookeeper.service`启动没有问题。
    - `systemctl stop zookeeper.service` 命令停止 zookeeper 的时候，问题出现了：zookeeper 服务在停止后并不是 inactive ，而是 failed 状态，最后两行输出里有 Unit zookeeper.service entered failed state./zookeeper.service failed 字段

- 问题定位

    - 在设置了 Type=forking 后，服务在启动或关闭时执行对应的脚本会开启一个进程，并且两个进程都成功执行了（返回状态码为 0 ）。但是主进程退出时返回的状态码却是 143，而不是状态码 0。

        ```sh
        Process: 61183 ExecStop=/opt/zookeeper/bin/zkServer.sh stop (code=exited, status=0/SUCCESS)
        Process: 61116 ExecStart=/opt/zookeeper/bin/zkServer.sh start (code=exited, status=0/SUCCESS)
        Main PID: 61132 (code=exited, status=143)
        ```

    - 接着看下 zookeeper 进程还在不在：明明 zookeeper 进程已经成功退出了，但是 systemd 却说它退出失败。


    - 接着我们注释掉 ExecStop 字段，采用 systemd 默认的方式来停止服务。还是一样的问题，zookeeper 已经成功退出但是却显示 failed 状态，状态码是 143。

        - 默认情况下，systemd 将向进程发送 `SIGTERM` 信号（相当于 kill -15命令发送的终止信号），等待一段时间后，如果服务进程未正常退出，则发送 `SIGKILL` 信号（相当于 kill -9 命令发送的强制终止信号）强制终止服务进程。

        - 而根据 POSIX 规范：【因接收到信号而终止的命令的退出状态应报告为大于 128】，所以被信号中断的进程退出时会返回 128 加上信号数值作为退出状态码。
            - 也就是说，当 zookeeper 进程收到 SIGTERM 信号时，会返回 128 + 15 也就是 143 作为退出状态码，这也就是为什么进程在成功退出后 systemctl  显示为 failed 状态。

- 解决方法：

    - 既然知道了进程在退出时的状态码是 143 但是 systemd 不会解释为成功，因为预期的退出状态码为 0，那么我们只需要让 systemd 把状态码 143 也解释为成功就行。

    - 所以在 zookeeper 的 service 文件中添加下面的配置：表示当服务进程以状态码 143 正常退出时，systemd 将其视为成功退出而不是异常退出。

        ```
        [Service]
        ...
        SuccessExitStatus=143
        ...
        ```

## systemctl

- systemd 通过`cgroup`(控制组)来追踪进程，而不是 PID

    - 当一个进程创建了子进程，子进程会继承父进程的 cgroup

- systemd通过`unit`配置文件管理服务。根据其后缀名分为12种不同的类型：

    | Unit      | 类型                                                                                                                                                                                                                                                                    |
    |-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
    | service   | daemon程序。是最常用的一类，可以启动、停止、重新启动、重新加载                                                                                                                                                                                                          |
    | socket    | 在文件系统或互联网上封装了一个socket。支持流、数据报和顺序包类型的 AF_INET、AF_INET6、AF_UNIX 套接字。还支持经典的 FIFO 作为传输。每个套接字单元都有一个匹配的服务单元，相应的服务在第一个连接进入套接字时就会启动，例如：nscd.socket 在传入连接上启动 nscd.service。 |
    | device    | 如果设备通过 udev 规则为此标记，它将在 systemd 中作为设备单元公开。使用 udev 设置的属性可用作配置源来设置设备单元的依赖关系。                                                                                                                                           |
    | mount     | systemd 会将/etc/fstab 中的条目都转换为挂载点，并在开机时处理。                                                                                                                                                                                                         |
    | automount | 自动挂载单元都有一个匹配的挂载单元，当该自动挂载点被访问时，systemd 就会执行挂载点中定义的挂载行为。                                                                                                                                                                   |
    | target    | 一组unit                                                                                                                                                                                                                                                                |
    | snapshot  | 快照可用于保存或回滚 init 系统的所有服务和单元的状态。比如允许用户临时进入特定状态，例如“紧急外壳”，终止当前服务，并提供一种简单的方法返回之前的状态。                                                                                                                  |
    | swap      | 和挂载配置单元类似，交换配置单元用来管理交换分区。                                                                                                                                                                                                                      |
    | timer     | 定时器的服务激活，这类配置单元取代了 atd、crond 等传统的定时服务。                                                                                                                                                                                                      |
    | path      | 监控指定目录或者文件的变化，根据变化触发其他配置单元服务的运行。                                                                                                                                                                                                        |
    | scope     | 从 systemd 外部创建的进程。                                                                                                                                                                                                                                             |
    | slice     | 通过在 cgroup 中创建一个节点实现资源的控制，一般包含 scope 与 service 单元。                                                                                                                                                                                            |
    - Unit 文件主要的存储目录：

        | system                |
        |-----------------------|
        | /etc/systemd/system/* |
        | /run/systemd/system/* |
        | /lib/systemd/system/* |

        | user                          |
        |-------------------------------|
        | ~/.config/systemd/user/*      |
        | /etc/systemd/user/*           |
        | /usr/lib/systemd/user/*       |
        | /run/systemd/user/*           |
        | ~/.local/share/systemd/user/* |

- 查看 `units`

```sh
systemctl                        # 列出正在运行的 Unit
systemctl --all                  # 列出所有Unit，包括没有找到配置文件的或者启动失败的
systemctl --all --state=inactive # 列出所有没有运行的 Unit
systemctl --failed               # 列出所有加载失败的 Unit
systemctl list-units --type=service # 列出所有正在运行的、类型为 service 的 Unit

# 查看依赖关系
systemctl list-dependencies sshd.target
# 查看依赖关系，并展开target
systemctl list-dependencies -all sshd.target

# 查看target
systemctl list-units --type=target

# 查看 units的所有状态
systemctl list-unit-files
systemctl list-unit-files --user #只查看user

# 查看timers
systemctl list-timers
```

- 基本使用

```sh
# 启动服务
systemctl start sshd.service
# 停止服务
systemctl stop sshd.service
# 重启服务
systemctl restart sshd.service
# kill服务
systemctl kill sshd.service

# 查看服务
systemctl status sshd.service
# 查看远程主机的服务
systemctl -H root@192.168.100.208 status sshd.service

# 设置开机启动
systemctl enabled sshd.service
# 关闭开机启动
systemctl disable sshd.service

# 修改/usr/lib/systemd/system/目录下的配置文件
systemctl edit --full sshd.service
# 还原为最初的版本
systemctl revert sshd.service

# 重新加载配置文件
systemctl reload sshd.service

# 重新加载所有修改过的配置文件服务
systemctl daemon-reload

# 查看配置文件
systemctl cat sshd.service

# 是否正在运行
systemctl is-active sshd.service
# 判断状态，执行命令脚本
systemctl is-active --quiet sshd.service && sudo systemctl stop sshd.service
# 是否处于启动失败状态
systemctl is-failed sshd.service
# 是否开机启动
systemctl is-enabled sshd.service

# 显示服务的属性值。默认值配置文件：/etc/systemd/system.conf
systemctl show sshd.service
# 显示指定属性值
systemctl show -p CPUShares sshd.service
# 设置指定属性值
systemctl set-property sshd.service CPUShares=500
```

- 查看`cgroup树` (units 执行的脚本或文件)

```sh
systemd-cgls
#使用ps命令查看cgroup树
ps xawf -eo pid,user,cgroup,args
```

- 管理系统

```sh
# 关机
systemctl poweroff
# 重启
systemctl reboot

# cpu停止工作
systemctl halt

# 暂停系统
systemctl suspend

# 进入冬眠状态
systemctl hibernate

# 让系统进入交互式休眠状态
systemctl hybrid-sleep

# 启动进入救援状态（单用户状态）
systemctl rescue
```

- 修改`runlevel`，当前有效，不会影响下次开机

| SysV Runlevel | systemd Target                                         | Notes                                                                                              |
|---------------|--------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| 0             | runlevel0.target  poweroff.target                      | Halt the system.                                                                                   |
| 1,s,single    | runlevel1.target  rescue.target                        | Single user mode.                                                                                  |
| 2,4           | runlevel2.target   runlevel4.target  multi-user.target | User-defined/Site-specific runlevels. By default identical to 3.
| 3             | runlevel3.target  multi-user.target                    | Multi-user        non-graphical. Users can usually login via multiple consoles or via the network. |
| 5             | runlevel5.target  graphical.target                     | Multi-user        graphical. Usually has all the services of runlevel 3 plus a graphical login.    |
| 6             | runlevel6.target  reboot.target                        | Reboot                                                                                             |
| emergency     | emergency.target                                       |

```sh
# init3
systemctl isolate muti-user.target

# init5
systemctl isolate graphical.target

# 获取当前的runlevel
systemctl get-default
# 设置runlevel
systemctl set-default graphical.target
```

- 查看当前用户的服务
```sh
# --user：指定操作应用于当前用户的用户级别 systemd 实例
systemctl --user enable --now pipewire-pulse.service
systemctl --user restart --now pipewire-pulse.service
systemctl --user status --now pipewire-pulse.service
```

### unmask

systemd 支持 mask 操作，如果一个服务被 mask 了，那么它无法被手动启动或者被其他服务所启动，也无法被设置为开机启动。

```sh
systemctl unmask httpd.service
```

### 常见启动问题

#### [爱可生开源社区：故障分析 | MySQL 通过 systemd 启动时 hang 住了……](https://mp.weixin.qq.com/s/vNA9Hny9wmF5ZFCAJfEXXQ)

- 问题：正如题目所述，在自动化测试场景下，通过 systemd 无法启动 MySQL。连续 kill -9 结束实例进程，检测 mysqld 在退出后是否会被正确拉起。

- 原因：

    - systemd 启动 mysqld 的过程中，会先根据 service 模板中的配置，执行：
        - 1.ExecStart（启动 mysqld）
        - 2.mysqld 启动创建 pid 文件
        - 3.ExecStartPost（自定义的一些后置脚本：调整权限、将 pid 写入 cgroup 等）

        - 在 步骤 2-3 的中间态，也就是 pid 文件刚创建出来时，主机上接收到了自动化测试下发的命令：`sudo -S kill -9 $(cat /opt/mysql/data/11690/mysqld.pid)`

        - 由于这个 pid 文件和 pid 进程确实存在（如果不存在 kill 命令或 cat 会报错）
            - 自动化的 CASE 认为 kill 操作已成功结束。
            - 但由于 mysqld.pid 这个文件是由 MySQL 自身维护的，在 systemd 的视角中，还需要继续等待 步骤 3 完成，才认为启动成功。

        - 在 systemd 使用 forking 模式时，会根据子进程的 PID 值判断服务是否成功启动。

            - 如果子进程成功启动，并且没有发生意外退出，则 systemd 会认为服务已启动，并将子进程的 PID 作为 MAIN PID。
            - 而如果子进程启动失败或意外退出，则 systemd 会认为服务未能成功启动。

    - 总结：在执行 ExecStartPost 时，由于子进程 ID 31036 已经被 kill 掉，后置 shell 缺少了启动参数，但 ExecStart 步骤已完成，导致 MAIN PID 31036 成为了只存在于 systemd 里的 僵尸进程。

- 排除过程和复现过程（省略...）
- 解决方法：

    - 先 kill 掉 hang 住的 systemctl start 命令，执行 systemctl stop mysqld_11690.service，这可以让 systemd 主动结束僵尸进程，虽然 stop 命令可能会报错但这并不影响。

    - 等待 stop 执行完成后再次使用 start 命令启动，恢复正常。

- 虽然文章跟 MySQL 没太大关系，但重要的是分析偶发故障的思考过程 :)
## hostnamectl, localectl, timedatectl, loginctl命令

- `hostnamectl`
```sh
# 查看主机信息
hostnamectl
# output
 Static hostname: tz-pc
       Icon name: computer-desktop
         Chassis: desktop 🖥️
      Machine ID: c571bebab04ca267ffe5ec875f22a566
         Boot ID: ae5fe9fc75f1450abd39c294a9020222
Operating System: Arch Linux
          Kernel: Linux 6.1.27-1-lts
    Architecture: x86-64
 Hardware Vendor: Micro-Star International Co., Ltd.
  Hardware Model: MS-7B84
Firmware Version: 2.30
   Firmware Date: Fri 2018-11-02

# 修改hostname
hostnamectl set-hostname tz
```

- `localectl`
```sh
# 查看本地化设置
localectl
# output
System Locale: LANG=en_US.UTF-8
    VC Keymap: (unset)
   X11 Layout: (unset)

# 设置本地化参数。
localectl set-locale LANG=en_GB.utf8
localectl set-keymap en_GB
```

- `timedatectl`
```sh
# 查看当前时区
timedatectl

# 查看可选的时区
timedatectl list-timezones

# 设置当前时区
timedatectl set-timezone America/New_York
timedatectl set-time YYYY-MM-DD
timedatectl set-time HH:MM:SS
```

- `loginctl`
```sh
# 查看当前session
loginctl list-sessions

# 查看当前登陆用户
loginctl list-users

# 查看指定用户
loginctl show-user tz
```

## journalctl（日志）

- [鹅厂架构师：走进systemd | 日志服务解析](https://zhuanlan.zhihu.com/p/702242748)

### systemd-journald的进程服务

- `systemd-journald.service`，是systemd的核心日志服务，作为系统日志的记录者，在系统启动时会第一个启动，这样如果后面服务出现问题，也会被记录在案。它只保存在内存上。

    ![image](./Pictures/systemd/systemd-journald.avif)

- `systemd-journal-flush.service`：将内存中的日志数据刷新到磁盘上，确保日志数据的持久化存储。

    - 如果创建了 `/var/log/journal` 目录，该服务会在系统启动时启动，执行 `journalctl --flush` 命令。将 journal 切换到 persistent 也就是持久化模式。


    - 这个服务会在`systemd-journald.service`服务After后启动

        ```sh
        systemctl cat systemd-journal-flush.service | grep -i After=
        # output
        After=systemd-journald.service systemd-remount-fs.service
        ```

- systemd-journal-remote.service 、systemd-journal-gatewayd.service 和 systemd-journal-upload.service

    - 这三个服务之间的关系，可以理解为：
        - systemd-journal-remote.service 是服务器
        - systemd-journal-gatewayd.service 是类似网关的存在，可以将获取到的日志打包成网络传输格式
        - systemd-journal-upload.service 则是本地的一个客户端，会采集本地的日本，上传至指定url（remote或者gatewayd）。

- systemd-journal-catalog-update.service

    - 用于更新systemd日志目录，这是一种包含预定义消息的数据库，可以用来增强日志消息的可读性和有用性。

    - 很多包会包含自己的catalog文件，例如dbus-broker

        ```sh
        [root@linux ~]# rpm -ql dbus-broker | grep catalog
        /usr/lib/systemd/catalog/dbus-broker-launch.catalog
        /usr/lib/systemd/catalog/dbus-broker.catalog
        ```

        - `catalog` 文件中包含了消息的标识符、主题、文档链接、以及消息背景等信息

- systemd-journald-audit.socket 和 systemd-journald-dev-log.socket

    - 专门用于接收来自 `auditd` 和 `/dev/log` 的日志消息，通过直接监听 `/dev/log` 以及内核审计系统接受日志。

    ```sh
    ListenDatagram=/run/systemd/journal/dev-log
    PassCredentials=yes
    PassSecurity=yes
    Service=systemd-journald.service
    SocketMode=0666
    Symlinks=/dev/log
    ```

### 持久化存储or内存存储

- journald默认使用`violatile`也就是内存存储。

    - 如果想要切换到持久化存储需要以下几个条件：

        - `/var/log/journal`被创建
        - `journalctl --flush`命令被执行（给journald发送 SIGUSR1 信号）

        - 然后，每次系统启动时，`systemd-journal-flush.service`服务会在启动时候判断是否存在`/var/log/journal`目录，如果存在，就执行`journalctl --flush`给journald刷到`persistent`模式。

- 存储大小以及转储

    - journald有几个配置项用来控制存储的日志大小。

        ```
        SystemMaxUse=, SystemKeepFree=, SystemMaxFileSize=, SystemMaxFiles=, RuntimeMaxUse=, RuntimeKeepFree=, RuntimeMaxFileSize=, RuntimeMaxFiles=
        ```

        - System 开头的用来限制持久化的日志
        - Runtime 开头的用来限制内存存储的日志。
        - MaxUse：用来控制的是journal日志可以占用的最大空间，默认是10%（磁盘）、15%（内存），但是有一个最大上限 4G。
        - KeepFree：用来控制需要留下多少空间
        - MaxFileSize：用来控制每个journal日志文件大小，默认为1/8的MaxUse，上限为128M 
        - MaxFiles：用来控制最多保存的journal日志个数，只有打包（压缩）的日志会被删除，正在活动的日志文件不会删除，默认值为100。

    - 还有其他一些选项也可以控制日志转储：
        - MaxFileSec：控制每个日志文件中条目跨越的最大时间，例如10day，就是开始到结束不能超过10天
        - MaxRetentionSec：控制所有日志文件的时间跨度，同上

    - 同时也可以直接通过命令转储journalctl --rotate配合下面几个选项控制转储的条件

        ```
        --vacuum-size=, --vacuum-time=, --vacuum-files=
        ```

### 速率限制

- 因为journal接受的是系统中所有服务的日志，所以有时候面临打日志速度太快的问题，对磁盘以及内存的压力会非常大。因此，journal也支持对日志速率进行限制。

- 这两个就是常用的限制速率的配置：

    - `RateLimitIntervalSec=`：控制时间
    - `RateLimitBurst=`：控制数量

- 两者相结合就是控制一定时间内记录的日志条目。 如果日志速率超过了这个限制，则会直接被丢弃，并且，在日志中会打印一条提示

    ```
    Suppressed XXX messages from XXX
    ```

    - 这和rsyslog中的速率限制机制类似，在rsyslog中，会看到这样的提示

        ```
        XXX messages lost due to rate-limiting (20000 allowed within 600 seconds)
        ```
### 日志接收和转发

- 一图总结：几个系统级别日志概念的联系

    - dmesg、/var/log/message、 journal、rsyslog(syslog) 等这几个都是系统中常用的日志，它们之间的关系如下图所示。

    ![image](./Pictures/systemd/journal的日志接受和转发.avif)

- 日志接收

    - journal日志主要来自于以下几个地方：

        - 内核日志，通过kmsg
        - libc 的 syslog 接口
        - 本地 journal 接口，sd_journal_print等
        - 服务的标准输出和错误
        - 内核 audit 子系统

- 日志转发

    - journald可以将日志转发到 syslog、kmsg、console、wall这些最终日志呈现端口。

    - 下面几个选项控制着是否将日志转发给他们。

        ```
        ForwardToSyslog=, ForwardToKMsg=, ForwardToConsole=, ForwardToWall=
        ```

    - 以及控制转发的最大的等级日志：

        ```
        MaxLevelStore=, MaxLevelSyslog=, MaxLevelKMsg=, MaxLevelConsole=, MaxLevelWall=
        ```

#### rsyslog

- 如果设置了 `ForwardToSyslog=` （默认开启），则journald会将从/dev/log接收到的日志转发给rsyslog

- 需要注意的是，虽然rsyslog支持直接从/dev/log中读取日志，但是当前上游以及发行版都关闭了此选项，默认从journal获取日志，防止与journal争夺/dev/log的所有权。

- rsyslog采用了模块式的功能，可以灵活控制其中模块能力的启用和关闭，这里与journal的对接也进行了模块化，见如下`/etc/rsyslog.conf`配置：

    ```
    module(load="imuxsock"    # provides support for local system logging (e.g. via logger command)
           SysSock.Use="off") # Turn off message reception via local log socket; 
                              # local messages are retrieved through imjournal now.
    module(load="imjournal"             # provides access to the systemd journal
           StateFile="imjournal.state") # File to store the position in the journal
    ```

#### kmsg

- kmsg 相比于 rsyslog 稍微简单一点，因为他是一个独立的缓冲区，内核代码中 printk 的内容就输出到这里。 例如，在 `/dev/kmsg` 里面的一条内核日志

    ```sh
    lsof /dev/kmsg
    COMMAND      PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    systemd        1 root    3w   CHR   1,11      0t0   10 /dev/kmsg
    systemd-j 705019 root   23w   CHR   1,11      0t0   10 /dev/kmsg
    systemd-j 705019 root   25u   CHR   1,11      0t0   10 /dev/kmsg
    ```

#### console

- 当我们用 ssh 或者 vnc 这类软件连接到一个服务器，出现的一个可以键盘输入的地方，就是俗话说的 终端。 /dev/console 是一个虚拟设备，他需要与终端设备进行映射，我们在系统启动时的启动参数中，一般会将 tty0 和 ttyS0 与其进行映射。

    ```sh
    cat /proc/cmdline  | grep console
    ... console=ttyS0,115200 console=tty0 console=ttyS0,115200....
    ```

- 可以通过/proc/consoles查看当前与console映射的串口。

    ```sh
    cat /proc/consoles 
    ttyS0                -W- (EC p a)    4:64
    tty0                 -WU (E  p  )    4:1
    ```

- 当我们向 tty0 中输入字符时，控制台也会打印相同的字符
    ```sh
    echo 123 > /dev/tty0
    ```

    - 这里 systemd-journal 其实也是相同的操作，将需要打印到控制台的日志写入 /dev/console，内容就会在控制台显示。

        ```
        fd = open_terminal(tty, O_WRONLY|O_NOCTTY|O_CLOEXEC);
        if (writev(fd, iovec, n) < 0)
        ```

#### wall

- 如果有使用过 wall 这个命令，那就应该对 wall 有所了解，这个 wall 其实指的是 write to all， 也就是向所有人通知的意思，他被经常用来作为管理员向系统中的所有其他用户发送通知消息。

- 同理，systemd的代码中的也是类似的实现，通过从`utmp`文件中逐条读取当前系统中有哪些用户，他们的终端是哪个，然后向对应的终端写入消息来完成。

- utmp就是`/var/run/utmp`文件，可以通过`utmpdump`工具读取，可以看到，utmp文件记录的就是登录的用户、终端、ip、时间等信息。

    ```sh
    utmpdump /var/run/utmp 
    Utmp dump of /var/run/utmp
    [2] [00000] [~~  ] [reboot  ] [~           ] [6.1.41-2303.1.1.ocs23.x86_64] [0.0.0.0        ] [2023-08-24T04:50:27,580823+00:00]
    [1] [00053] [~~  ] [runlevel] [~           ] [6.1.41-2303.1.1.ocs23.x86_64] [0.0.0.0        ] [2023-08-24T04:51:29,999747+00:00]
    [6] [01697] [tyS0] [LOGIN   ] [ttyS0       ] [                    ] [0.0.0.0        ] [2023-08-24T04:51:30,006922+00:00]
    [7] [3316382] [tty1] [root    ] [tty1        ] [                    ] [0.0.0.0        ] [2024-05-30T11:10:27,607175+00:00]
    ...
    ```

### 基本使用

```sh
# 查看日志
journalctl

# 查看最新10行
journalctl -n
# 查看最新20行
journalctl -n 20

# 查看实时日志
journalctl -f

# 查看实时错误日志
journalctl -fp err

# 读取日志 size
sudo journalctl --disk-usage
# 设置日志最大为1G
sudo journalctl --vacuum-size=1G
# 设置日志保存时间为1年
sudo journalctl --vacuum-time=1years

# 进程路径通过程序路径查看日志
journalctl $(which libvirtd)

# 查看进程 1 的日志
journalctl _PID=1

# 显示指定用户
journalctl _UID=33 --since today
```

```sh
# 查看指定服务
journalctl -u nginx.service

# 指定时间
journalctl -u nginx.service --since today

# 多个服务
journalctl -u nginx.service -u redis.service --since today

# 实时滚动
journalctl -u nginx.service -f
```

```sh
# 查看引导日志
journalctl -b

# 查看前一次启动
journalctl -b -1

# 查看倒数第 2 次启动
journalctl -b -2
```

- 查看指定时间的日志
```sh
journalctl --since="2023-6-1 8:00"

journalctl --since "20 min ago"

journalctl --since yesterday

journalctl --since "2015-01-10" --until "2015-01-11 03:00"

journalctl --since 09:00 --until "1 hour ago"
```

- 查看指定优先级（及其以上级别）的日志，共有8级

```sh
# 0: emerg
# 1: alert
# 2: crit
# 3: err
# 4: warning
# 5: notice
# 6: info
# 7: debug

journalctl -p err -b
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

## Timers（定时器）

- [arch文档](https://wiki.archlinux.org/title/Systemd/Timers)

- 可以代替cron。并且有日志管理；可以设置cpu，内存额度；可以依赖其它systemd unit

- 瞬间计算器
```sh
# 30秒后运行命令
systemd-run --on-active=30 /bin/touch /tmp/foo

# 12小时30分钟后启动某个服务
systemd-run --on-active="12h 30m" --unit someunit.service
```

- 在`/usr/lib/systemd/system`目录下，新建一个`mytimer.timer`文件

    - [timers官方文档](https://www.freedesktop.org/software/systemd/man/systemd.time.html)

    | [Timer]字段       | 内容                                                             |
    |-------------------|------------------------------------------------------------------|
    | OnActiveSec       | 定时器生效后，多少时间开始执行任务                               |
    | OnBootSec         | 系统启动后，多少时间开始执行任务                                 |
    | OnStartupSec      | Systemd 进程启动后，多少时间开始执行任务                         |
    | OnUnitActiveSec   | 该单元上次执行后，等多少时间再次执行                             |
    | OnUnitInactiveSec | 定时器上次关闭后多少时间，再次执行                               |
    | OnCalendar        | 基于绝对时间，而不是相对时间执行                                 |
    | AccuracySec       | 如果因为各种原因，任务必须推迟执行，推迟的最大秒数，默认是60秒   |
    | Unit              | 真正要执行的任务，默认是同名的带有.service后缀的单元             |
    | Persistent        | 如果设置了该字段，即使定时器到时没有启动，也会自动执行相应的单元 |
    | WakeSystem        | 如果系统休眠，是否自动唤醒系统                                   |

    - `OnUnitActiveSec=Mon *-*-* 02:00:00`：表示每周一凌晨两点

    - `OnUnitActiveSec=1h`：表示每小时执行一次
        ```systemd
        [Unit]
        Description=Runs mytimer every hour

        [Timer]
        OnUnitActiveSec=1h
        Unit=mytimer.service

        [Install]
        WantedBy=multi-user.target
        ```

    - 基本命令
    ```sh
    # 查看当前timers
    systemctl list-timers
    ```

# referece
- [systemd教程和在线测试](https://systemd-by-example.com/)
- [ruanyifeng：Systemd 入门教程：命令篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
- [arch文档](https://wiki.archlinux.org/title/Systemd)

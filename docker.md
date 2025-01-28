
<!-- mtoc-start -->

* [docker](#docker)
  * [容器与虚拟机对比](#容器与虚拟机对比)
  * [容器与其他进程不同](#容器与其他进程不同)
  * [基本概念](#基本概念)
  * [深入docker内部运行逻辑](#深入docker内部运行逻辑)
  * [without sudo](#without-sudo)
  * [换源](#换源)
  * [基本命令](#基本命令)
  * [docker run创建容器](#docker-run创建容器)
    * [--link 连接容器](#--link-连接容器)
    * [--gpus](#--gpus)
    * [--cap-add。Capability](#--cap-addcapability)
  * [数据卷(Volume)](#数据卷volume)
    * [匿名卷](#匿名卷)
    * [具名卷](#具名卷)
    * [本机的目录映射到容器](#本机的目录映射到容器)
    * [docker run --volumes-from 会递归容器引用的数据卷](#docker-run---volumes-from-会递归容器引用的数据卷)
  * [Docker的底层技术](#docker的底层技术)
    * [cgroup(资源限制)](#cgroup资源限制)
      * [docker run cgourp相关命令](#docker-run-cgourp相关命令)
      * [通过操作cgroup目录下的文件，限制进程cpu使用率、内存等等](#通过操作cgroup目录下的文件限制进程cpu使用率内存等等)
      * [go语言 cgroup相关代码](#go语言-cgroup相关代码)
    * [namespaces（命名空间）实现资源隔离](#namespaces命名空间实现资源隔离)
      * [unshare namespace相关命令](#unshare-namespace相关命令)
      * [docker run namespace相关命令](#docker-run-namespace相关命令)
      * [go语言 namespace相关代码](#go语言-namespace相关代码)
    * [UnionFS（联合文件系统）](#unionfs联合文件系统)
      * [OverlayFS](#overlayfs)
      * [rootfs（根文件系统）](#rootfs根文件系统)
  * [import/export](#importexport)
    * [镜像导入导出](#镜像导入导出)
    * [容器导入导出](#容器导入导出)
    * [容器数据卷之间的备份恢复](#容器数据卷之间的备份恢复)
  * [containerd](#containerd)
  * [runc管理容器](#runc管理容器)
  * [network网络](#network网络)
    * [Docker的网络架构CNM](#docker的网络架构cnm)
      * [网络模式（网络驱动）](#网络模式网络驱动)
        * [网桥（Bridge）](#网桥bridge)
        * [Overlay](#overlay)
        * [host](#host)
        * [none](#none)
        * [container](#container)
    * [容器之间的网络连通性](#容器之间的网络连通性)
    * [容器之间的网络隔离](#容器之间的网络隔离)
    * [容器与宿主机同一网段](#容器与宿主机同一网段)
      * [方法 1: 使用第三方工具 pipework](#方法-1-使用第三方工具-pipework)
      * [方法 2: 手动设置](#方法-2-手动设置)
  * [docker中的init进程](#docker中的init进程)
    * [把Bash当作PID 1呢？](#把bash当作pid-1呢)
    * [tini当作PID 1](#tini当作pid-1)
    * [为什么docker中会有僵尸进程？](#为什么docker中会有僵尸进程)
  * [Dockerfile 创建容器镜像](#dockerfile-创建容器镜像)
    * [Dockerfile命令](#dockerfile命令)
    * [Dockerfile优化](#dockerfile优化)
      * [未读](#未读)
    * [构建属于自己的 centos 容器](#构建属于自己的-centos-容器)
    * [hadolint：自动检查您的Dockerfile是否存在任何问题](#hadolint自动检查您的dockerfile是否存在任何问题)
  * [registry仓库](#registry仓库)
  * [Docker Compose定义和运行多容器](#docker-compose定义和运行多容器)
    * [docker-compose.yml示例](#docker-composeyml示例)
    * [Docker Compose的常用命令](#docker-compose的常用命令)
  * [Docker Swarm集群](#docker-swarm集群)
    * [Swarm服务](#swarm服务)
    * [Swarm节点管理](#swarm节点管理)
    * [Swarm网络](#swarm网络)
    * [Swarm存储](#swarm存储)
    * [高级主题](#高级主题)
  * [监控](#监控)
  * [不同应用是否适合docker，以及性能对比](#不同应用是否适合docker以及性能对比)
    * [nosql](#nosql)
    * [关系型数据库](#关系型数据库)
  * [与裸机性能对比](#与裸机性能对比)
* [第三方软件](#第三方软件)
  * [服务端](#服务端)
  * [客户端](#客户端)
* [reference article(优秀文章)](#reference-article优秀文章)
* [podman](#podman)
  * [Podman Desktop：一个管理容器的gui。兼容docker引擎](#podman-desktop一个管理容器的gui兼容docker引擎)

<!-- mtoc-end -->

# [docker](https://github.com/moby/moby)

![image](./Pictures/docker/docker.avif)

## 容器与虚拟机对比

![image](./Pictures/docker/docker_vs_虚拟机.avif)

- 同一台机器上的所有容器，都共享宿主机操作系统的内核。
    - 如果你的应用程序需要配置内核参数、加载额外的内核模块，以及跟内核进行直接的交互，你就需要注意了，这些操作和依赖的对象，都是宿主机操作系统的内核，它对于该机器上的所有容器来说是一个“全局变量”，牵一发而动全身。

    - 这也是容器相比于虚拟机的主要缺陷之一，毕竟后者不仅有模拟出来的硬件机器充当沙盒，而且每个沙盒里还运行着一个完整的 Guest OS 给应用随便折腾。

- 如果底层操作系统不同，比如有些是 ubuntu，有些是 centos，部署应用的时候就会有各种环境问题。docker可以让软件轻松跑在各类操作系统上

- 将软件和操作系统一起打包成虚拟机部署，运行一个完整的虚拟机，太重了。只打包软件和系统依赖库加配置就好了，也就是容器。

- docker除了有ubuntu、centos等操作系统镜像，还有nginx、httpd应用镜像。

## 容器与其他进程不同

- 容器使用 namespace,cgroup 等技术,为进程创造出资源隔离,限制的环境

    - 容器和进程是共享 host(宿主机)内核

        - 也就是在 windows,macos 上的 docker,无法使用 centos,opensuse 这些依赖 linux 内核的容器

## 基本概念

- 配置文件 `/var/lib/docker`

  | 内容                                                 | 目录                           |
  |------------------------------------------------------|--------------------------------|
  | volumes                                              | /var/lib/docker/volumes        |
  | image                                                | /var/lib/docker/image/overlay2 |
  | ---------------------------------------------------- | ------------------------------ |
  | 仓库(镜像名和 hash 值)                               | repositories.json              |
  | 镜像元数据(docker 版本,创建时间)                     | imagedb                        |
  | 容器层 元数据                                        | layerdb/mounts                 |
  | 镜像层(layer) 元数据(没有 parent 的镜像层为子镜像层) | layerdb/sha256                 |

  | container         | /var/lib/docker/containers    |
  | ----------------- | ----------------------------- |
  | volume 的具体情况 | <container_id>/config.v2.json |

- Capability 对 root 权限,分成多个子权限

    - 对容器授予某些子权限,而不是整个 root 权限,以此实现安全

    - 通过 `capsh --print` 命令查看权限
    ![image](./Pictures/docker/capability.avif)

## 深入docker内部运行逻辑

- [鹅厂架构师：【后台技术】Docker基础篇](https://zhuanlan.zhihu.com/p/683330478)

- docker引擎 采用 `c/s` 架构。分别是`docker(cli)/dockerd(daemon)`

    ![image](./Pictures/docker/docker引擎.avif)

    - Docker容器架构经过几次演进，随着OCI规范的制定和老的架构问题，现在Docker的架构如上图
        - 1.Docker Client主要是命令行，比如在终端上执行`docker ps -a`；
        - 2.Daemon接收CURD指令，主要是与Containerd交互；
        - 3.Containerd是容器的生命周期管理，主要功能：
            - 管理容器的生命周期（从创建容器到销毁容器）
            - 拉取/推送容器镜像
            - 存储管理（管理镜像及容器数据的存储）
            - 调用runc运行容器（与runc等容器运行时交互）
            - 管理容器网络接口及网络
        - 4.containerd-shim是runc启动的中间层；
        - 5.runc是OCI容器运行时的规范参考实现，runc是从Docker的 libcontainer中迁移而来的，实现了容器启停、资源隔离等功能；

    - client 使用 `REST API` 通过 `unix socket` 与 daemon 进行通信

        - REST API 最简单的例子是浏览器:通过 url 使用不同的动作(get,push)请求资源(可以是图片,文字,视频),而服务器会对请求返回不同的状态(200,404)

          ![image](./Pictures/docker/cs1.avif)
          ![image](./Pictures/docker/cs.svg)

- 容器创建流程

    - 1.Docker容器启动时候，Docker Daemon并不能直接创建，而是请求 containerd来创建容器；

    - 2.当containerd收到请求后，也不会直接去操作容器，而是创建containerd-shim的进程，让这个进程去操作容器，指定容器进程是需要一个父进程来做状态收集、维持stdin等fd打开等工作的，假如这个父进程就是containerd，那如果containerd挂掉的话，整个宿主机上所有的容器都得退出，而引入containerd-shim中间层规避这个问题；

    - 3.创建容器需要做一些namespaces和cgroups的配置，以及挂载root文件系统等操作，runc就可以按照OCI文档来创建一个符合规范的容器；

    - 4.真正启动容器是通过containerd-shim去调用runc来启动容器的，runc启动完容器后本身会直接退出，containerd-shim则会成为容器进程的父进程, 负责收集容器进程的状态, 上报给containerd, 并在容器中pid=1的进程退出后接管容器中的子进程进行清理, 确保不会出现僵尸进程；

    - 尝试执行命令 `docker container run --name test -it alpine:latest sh` ，进入容器：

    ```sh
    [root@VM-16-16-centos ~]# docker container run --name test -it alpine:latest sh
    Unable to find image 'alpine:latest' locally
    latest: Pulling from library/alpine
    7264a8db6415: Pull complete
    Digest: sha256:7144f7bab3d4c2648d7e59409f15ec52a18006a128c733fcff20d3a4a54ba44a
    Status: Downloaded newer image for alpine:latest
    ```

## without sudo

> 普通用户使用 docker,出现以下权限错误

`Got permission denied ... /var/run/docker.sock: connect: permission denied`

修复:

```bash
# 将用户添加到docker组
sudo usermod -aG docker $USER

# 重启docker
sudo systemctl restart docker

# 重新登陆
logout
```

## 换源

- 新闻：[国内多个Docker hub镜像加速器被下架](https://mp.weixin.qq.com/s/o9OwEkNzR3gzFBI_ruY8tQ)

- 解决方法1：

    - 修改`/etc/docker/daemon.json`

        ```json
        {
          "registry-mirrors": [
            "https://hub-mirror.c.163.com",
            "https://registry.cn-hangzhou.aliyuncs.com",
            "https://docker.m.daocloud.io",
            "https://docker.1panel.live"
          ]
        }
        ```

    - 重启docker

        ```sh
        systemctl daemon-reload
        systemctl restart docker
        ```

- 解决方法2：在`docker.io`前面加上`m.daocloud.io`

    ```sh
    docker pull m.daocloud.io/docker.io/library/nginx:latest
    ```

## 基本命令

- 容器的生命周期

    - 容器有一个PID为1的进程，这个进程是容器的主进程，主进程挂掉，整个容器也会退出
    - 容器的退出，可以使用`docker stop <Container ID>`，但是容器退出有时候需要保留容器内运行的文件
        - 在Linux下，docker stop是先向容器的PID 1进程发送SIGTERM的信号，如果10s内进程没有终止，就会发送SIGKILL的信号
    - 容器的删除，可以使用`docker rm <Container ID>`，不过删除之前可以先停止容器
    - 容器在整个生命周期的数据是安全的，即使容器被删除，容器的数据存储在卷中，这些数据也会保存下来
    - 容器自动重启策略包括--restart always，--restart unless-stopped和--restart on-failed，分别表示如下：
        - `--restart always`是容器被kill掉后会自动重启或者是Docker daemon重启的时候也会重启
        - `--restart unless-stopped`是容器被kill掉后会自动重启，但是Docker daemon重启的时候不会重启
        - `--restart on-failed`是容器退出时返回不为0则重启

![image](./Pictures/docker/cmd_logic.avif)

```bash
# 查看docker信息
docker info

# 查看容器详细信息
docker inspect CONTAINER_ID

# 查看容器写入层的diff(类似git diff)
docker diff CONTAINER_ID

# 查看容器镜像构建信息
docker history IMAGE_ID

# 查看运行的容器
docker ps

# 重新启动正在运行的容器
docker restart CONTAINER_ID

# 暂停运行容器
docker stop CONTAINER_ID

# 查看所有容器包含被stop（暂停）的
docker ps -a

# 启用一个暂停的容器
docker start CONTAINER_ID

# 查看端口映射
docker ps -l

# 查看容器端口映射
docker port CONTAINER_ID

# 查看网络
docker network ls

# 查看网络接口,包含使用该接口的容器信息
docker network inspect NETWORK_NAME

# 将容器加入到网络接口,一个容器可以有多个网络
docker network connect NETWORK_NAME CONTAINER_ID

# 性能监控
docker stats

# 调用stats API监控
echo -e "GET /containers/<container_name>/stats HTTP/1.0\r\n" | nc -U /var/run/docker.sock

# 查看容器里的程序(pid是以本地命名空间)
docker top CONTAINER_ID

# 搜索容器
docker serch opensuse

# 搜索容器
docker rename CONTAINER_ID New_name

# 查看容器ip
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' CONTAINER_ID

# 查看容器的日志
docker logs nginx

# 从容器Copy到宿主机
docker cp nginx:/etc/nginx/nginx.conf .

# 从宿主机Copy到容器
docker cp test nginx:/opt
```

## docker run创建容器

- [docker run 官方文档](https://docs.docker.com/engine/reference/commandline/run/)

| 参数           | 简写           | 操作               |
| -------------- | -------------- | ------------------ |
| --interactive  | -i             | 开启 STDIN         |
| --tty          | -t             | 分配一个伪 tty     |
| --detach       | -d             | daemon 后台运行    |
| -v             | -v             | 卷挂载(目录映射)   |
| --volumes-from | --volumes-from | 加入其它容器的卷   |
| --publish      | -p             | 端口映射           |
| --publish-all  | -P             | 所有端口           |
| --hostname     | -h             | 设置容器 hostname  |
| --link         | --link         | 连接其他容器       |
| --rm           | --rm           | 退出时自动删除容器 |
| --expose       | --expose       | 暴露端口           |
| --workdir      | -w             | 修改工作目录       |
| --name         |                | 设置容器名字       |

---

```bash
# 运行容器opensuse,并命名为opensuse_1
docker run --name opensuse_1 \
    -it opensuse /bin/bash

# -it 默认是/bin/bash
docker run --name opensuse_1 \
    -it opensuse

# -d 后台运行
docker run -d --name opensuse_1 \
    -it opensuse

# --rm 退出后自动删除容器
docker run --rm \
    --name opensuse_1 \
    -it opensuse

# -v 创建数据卷(如果目录不存在,会自动创建)
docker run -v /tmp/test \
    --rm --name opensuse_1 -it opensuse
# 目录映射
docker run -v /tmp/test:/tmp/test \
    --rm --name opensuse_1  -it opensuse

# 容器内只读
docker run -v /tmp/test:/tmp/test:ro \
    --rm --name opensuse_1  -it opensuse

# -p 端口映射
docker run -p 8080:80 \
    --rm -it nginx

# 指定回环ip(默认是0.0.0.0)
docker run -p 127.0.0.1:8080:80 \
    --rm -it nginx

# 指定回环ip,但本地端口随机分配
docker run -p 127.0.0.1::80 \
    --rm -it nginx
```

```bash
# -d 后台运行命令
docker exec -d opensuse_1 \
    touch /tmp/test

# 创建一个新的 bash 会话
docker exec opensuse_1 -it bash

# 在容器里,查看环境变量
cat /etc/hosts
env

# 附着opensuse_1,(注意附着退出后,容器也会退出)
docker attach opensuse_1

# 查看attach后的命令输出
docker logs opensuse_1
# -f 跟踪
docker logs -f opensuse_1

# 使用syslog,代替docker log
docker run --log-driver="syslog"\
    --name opensuse_1 -it opensuse /bin/bash
```

### --link 连接容器

**注意:**

- 1.link 是不能递归连接容器的

  - a->b->c

  - 以上 b 容器 link c, 但 a 容器只会 link b,

- 2.link 是根据 ip 地址,进行连接

  - 连接容器 ip 的改变,会使连接失效

- 3.link 只能 link,运行的容器

  - 假设容器 stop,连接失效

```bash
# 启动redis数据库容器
docker run --name data \
    -itd redis

# 连接redis
docker run --link data:db \
    -it centos
```

新的网络模型的 `link` 不需要启动源容器,也能 link

- 并不会在/etc/hosts 下,查找到 link 容器的信息

- 实现容器相互 link

```bash
# 创建网络
docker network create test

docker run --net test \
    -it --rm --name=new_link \
    --link container:c1 busybox

docker run --net test \
    -itd --rm --name=container busybox

# 在new_link容器里,ping c1进行通信测试
ping c1
```

### --gpus

- `--gpus`：需要安装`nvidia-container-toolkit`和`nvidia-docker`

```sh
# 运行dandere2x视频提升质量的ai项目
docker run --rm -it --gpus all -v $PWD:/host akaikatto/dandere2x -p singleprocess -ws . -i 123.mp4 -o 123new.mp4
```

### --cap-add。Capability

```bash
docker run --cap-add=ALL --cap-drop=MKNOD \
    --rm -it opensuse
```

## 数据卷(Volume)

- [云原生运维圈：你必须知道的Docker数据卷(Volume)](https://mp.weixin.qq.com/s/v9e5j5o56MnOehoJ_Wp5Ew)

数据卷(Volume)：使用docker容器的时候，会产生一系列的数据文件，这些数据文件在删除docker容器时是会消失的，程序员希望在运行过程钟产生的部分数据是可以持久化的的，而且容器之间我们希望能够实现数据共享。数据卷是一个可供一个或多个容器使用的特殊目录，它将主机操作系统目录直接映射进容器。

- 数据卷的特点
    - 1.持久性：数据卷独立于容器的生命周期，容器删除后数据卷仍然存在，可以被其他容器挂载和使用。
    - 2.共享性：多个容器可以共享同一个数据卷，实现数据在容器之间的共享和传递。
    - 3.数据卷可以提供外部数据：可以将主机文件系统的目录或文件挂载为数据卷，容器可以直接访问主机上的数据。
    - 4.容器之间隔离：即使多个容器共享同一个数据卷，它们之间的操作仍然是相互隔离的，不会相互影响。
    - 5.高性能：与将数据存储在容器内部相比，使用数据卷通常具有更高的性能，因为数据卷可以利用主机文件系统的优势。
    - 6.可备份和恢复：可以轻松备份和恢复数据卷中的数据，方便进行数据管理和迁移。

```sh
# 列出所有卷
docker volume ls
DRIVER    VOLUME NAME
local     ec56e4ef1cd8d70873d1b9c130326bbdd52cb6ebd302d85899d822f085568e1f
local     minikube

# 数据卷对应/var/lib/docker/volumes/中的目录
ls -l /var/lib/docker/volumes/
brw------- 1 root root 259, 3 Mar 30 10:41 backingFsBlockDev
drwx-----x 3 root root   4096 Mar 26  2022 ec56e4ef1cd8d70873d1b9c130326bbdd52cb6ebd302d85899d822f085568e1f
-rwxrwxrwx 1 root root  65536 Mar 30 10:41 metadata.db
drwx-----x 3 root root   4096 Jan 17 13:32 minikube

# 创建卷
docker volume create test

# 查询数据卷详情
docker volume inspect test
[
    {
        "CreatedAt": "2024-03-30T10:47:01+08:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/test/_data",
        "Name": "test",
        "Options": null,
        "Scope": "local"
    }
]

# 删除卷
docker volume rm test

# 移除无用卷
docker volume prune
```

### 匿名卷

```sh
# 创建匿名卷，并保存容器 /usr/share/nginx/html 下面的内容
docker run -d --name nginx -P -v /usr/share/nginx/html nginx

# 查看容器
docker inspect nginx
 "Mounts": [
            {
                "Type": "volume",
                "Name": "eed5af324ff6a4af2f02cf3dd2ed0da51be01b6e34abcf578c179ccde3bc3992",
                "Source": "/var/lib/docker/volumes/eed5af324ff6a4af2f02cf3dd2ed0da51be01b6e34abcf578c179ccde3bc3992/_data",
                "Destination": "/usr/share/nginx/html",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""
            }
        ],

# 列出所有卷。可以看到多出来了ec56e4ef1cd8d70873d1b9c130326bbdd52cb6ebd302d85899d822f085568e1f
docker volume ls
DRIVER    VOLUME NAME
local     ec56e4ef1cd8d70873d1b9c130326bbdd52cb6ebd302d85899d822f085568e1f
local     eed5af324ff6a4af2f02cf3dd2ed0da51be01b6e34abcf578c179ccde3bc3992
local     minikube

# 可以看到Labels中有anonymous（匿名）。并且可以看到对应的宿主机挂载点目录
docker volume inspect eed5af324ff6a4af2f02cf3dd2ed0da51be01b6e34abcf578c179ccde3bc3992
[
    {
        "CreatedAt": "2024-03-30T11:03:16+08:00",
        "Driver": "local",
        "Labels": {
            "com.docker.volume.anonymous": ""
        },
        "Mountpoint": "/var/lib/docker/volumes/eed5af324ff6a4af2f02cf3dd2ed0da51be01b6e34abcf578c179ccde3bc3992/_data",
        "Name": "eed5af324ff6a4af2f02cf3dd2ed0da51be01b6e34abcf578c179ccde3bc3992",
        "Options": null,
        "Scope": "local"
    }
]

# 进入容器
docker exec -it nginx sh

# 进入匿名卷的目录
cd /usr/share/nginx/html/

# 可以看到nginx镜像，在这个目录默认有2个文件。
ls
50x.html  index.html

# 创建一个文件
touch test

# 退出容器
exit

# 测试持久化。查看nginx容器的匿名卷挂载点，是否能看到刚才创建的test文件
ls /var/lib/docker/volumes/eed5af324ff6a4af2f02cf3dd2ed0da51be01b6e34abcf578c179ccde3bc3992/_data
50x.html  index.html  test
```

### 具名卷

```sh
# 创建一个名为nginx的数据卷
docker volume create nginx
# 查看数据卷详情。可以看到与匿名卷不同的是，Labels是空值，没有anonymous（匿名）
docker volume inspect nginx
[
    {
        "CreatedAt": "2024-03-30T11:16:11+08:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/nginx/_data",
        "Name": "nginx",
        "Options": null,
        "Scope": "local"
    }
]

# 使用具名卷映射
docker run -d --name nginx -P -v nginx:/usr/share/nginx/html nginx

# 查看容器详细信息
docker inspect nginx
 "Mounts": [
            {
                "Type": "volume",
                "Name": "nginx",
                "Source": "/var/lib/docker/volumes/nginx/_data",
                "Destination": "/usr/share/nginx/html",
                "Driver": "local",
                "Mode": "z",
                "RW": true,
                "Propagation": ""
            }
        ],

# 进入容器
docker exec -it nginx sh

# 进入匿名卷的目录
cd /usr/share/nginx/html/

# 可以看到nginx镜像，在这个目录默认有2个文件。
ls
50x.html  index.html

# 创建一个文件
touch test

# 退出容器
exit

# 测试持久化。查看nginx容器的匿名卷挂载点，是否能看到刚才创建的test文件
ls /var/lib/docker/volumes/nginx/_data
50x.html  index.html  test

# 删除容器重新创建
docker rm -f nginx
docker run -d --name nginx -P -v nginx:/usr/share/nginx/html nginx

# 进入容器
docker exec -it nginx sh
# 再次查看有之前创建test文件。持久化成功
ls /usr/share/nginx/html
50x.html  index.html  test
```

### 本机的目录映射到容器

```sh
# 将本机的/tmp/nginx目录，映射到容器的/usr/share/nginx/html
# 使用 bind 方式做数据卷的映射时，首次 docker run -v 运行，如果本机的文件夹是没有内容的，docker容器中的文件夹是有内容的，则本机的会覆盖dokcer容器中的，也就是容器中原本有内容的也会没有内容
# 如果本机的文件夹是有内容的，docker容器中的文件夹是有内容的，则本机的会覆盖dokcer容器中的 由于宿主机上 /tmp/nginx 这个目录底下没有文件，所以容器内的数据会被主机目录覆盖清空。
docker run -d --name nginx -P -v /tmp/nginx:/usr/share/nginx/html nginx

# 查看容器详情
docker inspect nginx
 "Mounts": [
            {
                "Type": "bind",
                "Source": "/tmp/nginx",
                "Destination": "/usr/share/nginx/html",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }
        ],

# 列出数据卷。并没有多出来volume name
docker volume ls
DRIVER    VOLUME NAME
local     ec56e4ef1cd8d70873d1b9c130326bbdd52cb6ebd302d85899d822f085568e1f
local     eed5af324ff6a4af2f02cf3dd2ed0da51be01b6e34abcf578c179ccde3bc3992
local     minikube
local     nginx

# 查看目录，什么也没有
ls /tmp/nginx

# 进入映射目录
cd /usr/share/nginx/html/
# 查看目录，什么也没有。因为会/tmp/nginx目录覆盖，而/tmp/nginx什么文件也没有。
ls

# 创建一个新文件
touch test

# 退出容器
exit

# 查看宿主机的映射目录
ls /tmp/nginx
test

# 删除容器重新创建
docker rm -f nginx
docker run -d --name nginx -P -v /tmp/nginx:/usr/share/nginx/html nginx

# 持久化成功
ls /usr/share/nginx/html
test
```

### docker run --volumes-from 会递归容器引用的数据卷

opensuse_data2(data2) -> opensuse_data1(data1) -> opensuse_data(data)

```bash
docker run -v /data \
    --name opensuse_data \
    -itd opensuse

docker run --volumes-from=opensuse_data \
    -v /data1 --name opensuse_data1 \
    -itd opensuse

docker run --volumes-from=opensuse_data1 \
    -v /data2 --name opensuse_data2 \
    -it opensuse
```

![image](./Pictures/docker/volumes-from.avif)

- 1.此时如果 `rm -v` 删除 `opensuse_data1` 容器

  - 数据卷 `data1` 并不会删除

- 2.而如果在重新创建 opensuse_data1

  ```bash
  docker run --volumes-from=opensuse_data \
      -v /data1 --name opensuse_data1 \
      -itd opensuse
  ```

  - 容器数据卷名字虽然也是 data1,但并不是原来的数据卷

    - 左边为新创建的 `opensuse_data1`

    - 右边为 `opensuse_data2`

      ![image](./Pictures/docker/volumes-from1.avif)


## Docker的底层技术

### cgroup(资源限制)

- [knowclub：探究Docker三板斧NameSpace、Cgroups、UnionFS](https://mp.weixin.qq.com/s?__biz=Mzk0OTI3MDg5MA==&mid=2247486995&idx=1&sn=5d3950b305882aa2028e8bf8526d39e6&chksm=c35bae16f42c2700578d4d9d8b6612ab620dd15ff6199485baba5e1811cb4de73add9d37bd91&token=1480493907&lang=zh_CN&scene=21#wechat_redirect)

- Linux Cgroup全称Linux Control Group， 是Linux内核的一个功能，用来限制，控制与分离一个进程组群的资源（如CPU、内存、磁盘输入输出等）。

- Linux Cgroup可让您为系统中所运行任务（进程）的用户定义组群分配资源 — 比如 CPU 时间、系统内存、网络带宽或者这些资源的组合。
    - 您可以监控您配置的 cgroup，拒绝 cgroup 访问某些资源，甚至在运行的系统中动态配置您的 cgroup。


- 主要功能:

    - 限制资源使用，比如内存使用上限以及文件系统的缓存限制。
    - 优先级控制，CPU利用和磁盘IO吞吐。
    - 一些审计或一些统计，主要目的是为了计费。
    - 挂起进程，恢复执行进程。

- 相关概念：

    - task: 在cgroups中，任务就是系统的一个进程。
    - control group: 控制组，指明了资源的配额限制。进程可以加入到某个控制组，也可以迁移到另一个控制组。
    - hierarchy: 层级结构，控制组有层级结构，子节点的控制组继承父节点控制组的属性(资源配额、限制等)
    - subsystem: 子系统，一个子系统其实就是一种资源的控制器，比如memory子系统可以控制进程内存的使用。子系统需要加入到某个层级，然后该层级的所有控制组，均受到这个子系统的控制。

- 相互关系
    - 每次在系统中创建新层级时，该系统中的所有任务都是那个层级的默认cgroup（root cgroup，此cgroup在创建层级时自动创建，后面在该层级中创建的cgroup都是此cgroup的后代）的初始成员。
    - 一个子系统最多只能附加到一个层级
    - 一个层级可以附加多个子系统
    - 一个任务可以是多个cgroup的成员，但是这些cgroup必须在不同的层级
    - 系统中的进程（任务）创建子进程（任务）时，该子任务自动成为其父进程所在cgroup的成员。然后可根据需要将该子任务移动到不同的cgroup中，但开始时它总是继承其父任务的cgroup。

![image](./Pictures/docker/cgroup3.avif)

- 当你的cgroup 关联了哪些subsystem ，那这个cgroup 目录下就会有对应subsystem 的参数配置文件，可以通过这些文件对对应的资源进行限制

- cgroup目录下的tasks文件里面可以添加你想要进行资源限制管理的进程的PID


- 子系统
    - cpu 子系统，主要限制进程的 cpu 使用率。
    - cpuacct 子系统，可以统计 cgroups 中的进程的 cpu 使用报告。
    - cpuset 子系统，可以为 cgroups 中的进程分配单独的 cpu 节点或者内存节点。
    - memory 子系统，可以限制进程的 memory 使用量。
    - blkio 子系统，可以限制进程的块设备 io。
    - devices 子系统，可以控制进程能够访问某些设备。
    - net_cls 子系统，可以标记 cgroups 中进程的网络数据包，然后可以使用 tc 模块（traffic control）对数据包进行控制。
    - net_prio — 这个子系统用来设计网络流量的优先级
    - freezer 子系统，可以挂起或者恢复 cgroups 中的进程。
    - ns 子系统，可以使不同 cgroups 下面的进程使用不同的 namespace
    - hugetlb — 这个子系统主要针对于HugeTLB系统进行限制，这是一个大页文件系统。

- CPU子系统

    - cpu子系统限制对CPU的访问，每个参数独立存在于cgroups虚拟文件系统的伪文件系中，参数如 下：

    - cpu.shares: cgroup对时间的分配。比如cgroup A设置的是1，cgroup B设置的是2，那么B中的任务获取cpu的时间，是A中任务的2倍。
    - cpu.cfs_period_us: 完全公平调度器的调整时间配额的周期。
    - cpu.cfs_quota_us: 完全公平调度器的周期当中可以占用的时间。
    - cpu.stat 统计值
        - nr_periods 进入周期的次数
        - nr_throttled 运行时间被调整的次数
        - throttled_time 用于调整的时间

    - cpuacct子系统：生成cgroup任务所使用的CPU资源报告，不做资源限制功能。
        ```sh
        cpuacct.usage # 该cgroup中所有任务总共使用的CPU时间（ns纳秒）
        cpuacct.stat # 该cgroup中所有任务总共使用的CPU时间，区分user和system时间。
        cpuacct.usage_percpu # 该cgroup中所有任务使用各个CPU核数的时间。
        ```

    - cpuset子系统

        - 适用于分配独立的CPU节点和Mem节点，比如将进程绑定在指定的CPU或者内存节点上运行，各 参数解释如下
        ```
        cpuset.cpus # 可以使用的cpu节点
        cpuset.mems # 可以使用的mem节点
        cpuset.memory_migrate # 内存节点改变是否要迁移？
        cpuset.cpu_exclusive # 此cgroup里的任务是否独享cpu？
        cpuset.mem_exclusive # 此cgroup里的任务是否独享mem节点？
        cpuset.mem_hardwall # 限制内核内存分配的节点（mems是用户态的分配）
        cpuset.memory_pressure # 计算换页的压力。
        cpuset.memory_spread_page # 将page cache分配到各个节点中，而不是当前内存节点。
        cpuset.memory_spread_slab # 将slab对象(inode和dentry)分散到节点中。
        cpuset.sched_load_balance # 打开cpu set中的cpu的负载均衡。
        cpuset.sched_relax_domain_level # 迁移任务的搜索范围the searching range when migrating tasks
        cpuset.memory_pressure_enabled # 是否需要计算 memory_pressure?
        ```

- memory子系统：memory子系统主要涉及内存一些的限制和操作，主要有以下参数：

    ```
    memory.usage_in_bytes # 当前内存中的使用量
    memory.memsw.usage_in_bytes # 当前内存和交换空间中的使用量
    memory.limit_in_bytes # 设置or查看内存使用量
    memory.memsw.limit_in_bytes # 设置or查看 内存加交换空间使用量
    memory.failcnt # 查看内存使用量被限制的次数
    memory.memsw.failcnt # - 查看内存和交换空间使用量被限制的次数
    memory.max_usage_in_bytes # 查看内存最大使用量
    memory.memsw.max_usage_in_bytes # 查看最大内存和交换空间使用量
    memory.soft_limit_in_bytes # 设置or查看内存的soft limit
    memory.stat # 统计信息
    memory.use_hierarchy # 设置or查看层级统计的功能
    memory.force_empty # 触发强制page回收
    memory.pressure_level # 设置内存压力通知
    memory.swappiness # 设置or查看vmscan swappiness 参数
    memory.move_charge_at_immigrate # 设置or查看 controls of moving charges?
    memory.oom_control # 设置or查看内存超限控制信息(OOM killer)
    memory.numa_stat # 每个numa节点的内存使用数量
    memory.kmem.limit_in_bytes # 设置or查看 内核内存限制的硬限
    memory.kmem.usage_in_bytes # 读取当前内核内存的分配
    memory.kmem.failcnt # 读取当前内核内存分配受限的次数
    memory.kmem.max_usage_in_bytes # 读取最大内核内存使用量
    memory.kmem.tcp.limit_in_bytes # 设置tcp 缓存内存的hard limit
    memory.kmem.tcp.usage_in_bytes # 读取tcp 缓存内存的使用量
    memory.kmem.tcp.failcnt # tcp 缓存内存分配的受限次数
    memory.kmem.tcp.max_usage_in_bytes # tcp 缓存内存的最大使用量
    ```

- blkio子系统：主要用于控制设备IO的访问。

    - 有两种限制方式：权重和上限
        - 权重是给不同的应用一个权重值，按百分比使用IO资源
        - 上限是控制应用读写速率的最大值。

    - 按权重分配IO资源：
        ```
        blkio.weight：填写 100-1000 的一个整数值，作为相对权重比率，作为通用的设备分配比。
        blkio.weight_device：针对特定设备的权重比，写入格式为 device_types:node_numbers weight，空格前的参数段指定设备，weight参数与blkio.weight相同并覆盖原有的通用分配比。
        ```

    - 按上限限制读写速度：
        ```
        blkio.throttle.read_bps_device：按每秒读取块设备的数据量设定上限，格式device_types:node_numbers bytes_per_second。
        blkio.throttle.write_bps_device：按每秒写入块设备的数据量设定上限，格式device_types:node_numbers bytes_per_second。
        blkio.throttle.read_iops_device：按每秒读操作次数设定上限，格式device_types:node_numbers operations_per_second。
        blkio.throttle.write_iops_device：按每秒写操作次数设定上限，格式device_types:node_numbers operations_per_second
        ```

    - 针对特定操作 (read, write, sync, 或 async) 设定读写速度上限
        ```
        blkio.throttle.io_serviced：针对特定操作按每秒操作次数设定上限，格式device_types:node_numbers operation operations_per_second
        blkio.throttle.io_service_bytes：针对特定操作按每秒数据量设定上限，格式device_types:node_numbers operation bytes_per_second
        ```

#### docker run cgourp相关命令

- docker 在每个 cgroup 子系统目录下,都有自己的控制组

    - 每个控制组下有对应的容器`/sys/fs/cgroup/cpu/docker/<container-id>`

| cgroup 相关参数 | 简写          | 操作             |
| --------------- | ------------- | ---------------- |
| --memory        | -m            | 限制内存         |
| --cpu-shares    | -c            | 限制 cpu 使用率  |
| --name          | --name        | 自定义命名       |
| --cpuset-cpus   | --cpuset-cpus | 指定 cpu         |
| --read-only     | --read-only   | 只读             |
| --device        | --device      | 运行访问指定设备 |
| --privileged    | --privileged  | root 身份        |

---

`-c` 代表相对权限(限制 cpu 使用率)

- 1.刚才开始权限为 0

- 2.此时开启 opensuse 容器

  - 总权限为 512

  - 而 opensuse 容器的 cpu 使用率 100%

```bash
docker run -c 512 \
    --rm -it opensuse
```

- 3.再次开启一个 1024 相对权限的 centos 容器

  - 总权限为 1024+512

  - 那么 opensuse 使用率为 33%

  - 而 centos 为 66%

```bash
docker run -c 1024 \
    --rm -it centos
```

- 4.注意:相对权限是在负载的情况下生效
  - 假设 centos 没有负载,那么 opensuse 使用率可达 100%

```bash
# --cpuset-cpus 指定cpu(减少上下文切换的开销)
docker run --cpuset-cpus=0,4,6 \
    --rm -it opensuse

# -m 限制内存
docker run -m 300M \
    --rm -it opensuse

# --device 运行访问指定设备
docker run --device=/dev/sda1 \
    --rm -it opensuse

# --privileged 运行访问所有设备
docker run --privileged \
    --rm -it opensuse
```

- 其他资源限制

| 相关参数      | 功能实现        | 操作     |
| ------------- | --------------- | -------- |
| --storage-opt | filesystem 实现 | 磁盘配额 |
| --ulimit      | UID 实现        | 进程限制 |

```bash
# --storage-opt 磁盘配额
docker run --storage-opt size=10G \
    -it opensuse

# --ulimit 对docker_limit用户,进行进程限制
docker run -u docker_limit --ulimit nproc=3 \
    -it opensuse

docker run -u tz --ulimit nproc=3 \
    -it busybox top
```

#### 通过操作cgroup目录下的文件，限制进程cpu使用率、内存等等

- 不同发行版的cgroup并不一样

    ```sh
    # 这是centos7
    mount -t cgroup
    cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
    cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,cpuacct,cpu)
    cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,pids)
    cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,net_prio,net_cls)
    cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,memory)
    cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,freezer)
    cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,blkio)
    cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,perf_event)
    cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,hugetlb)
    cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,devices)
    cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,cpuset)

    # 这是archlinux。archlinux没有mount -t cgroup
    mount -t cgroup2
    cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,nsdelegate,memory_recursiveprot)
    ```

- cpu消耗限制

    - 创建一个死循环脚本

        ```sh
        #/bin/sh
        a=1
        while (( 1 ))
        do
         let a++
        done
        ```

        ```sh
        # 运行脚本后，使用top命令查看
        top
        top - 21:11:17 up 6 min,  1 user,  load average: 0.68, 0.58, 0.34
        Tasks: 211 total,   3 running, 203 sleeping,   0 stopped,   5 zombie
        %Cpu(s): 28.4 us,  2.4 sy,  0.0 ni, 69.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
        KiB Mem :  3875640 total,   601128 free,  2540740 used,   733772 buff/cache
        KiB Swap:  2621436 total,  2621436 free,        0 used.   986168 avail Mem

          PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
        18608 root      20   0  113284   1188   1008 R 100.0  0.0   0:35.18 bash
        ```

    ```sh
    # 不同发行版的/sys/fs/cgroup/目录下的文件并不一样。我这里为centos7
    cd /sys/fs/cgroup/cpu

    # 在原有的/sys/fs/cgroup/cpu下面创建一个新的cgroup为cpu_t
    mkdir cpu_t

    # 创建cpu_t目录后，会自动生成以下文件
    ls cpu_t
    cgroup.clone_children  cpuacct.stat          cpu.cfs_period_us  cpu.rt_runtime_us  notify_on_release
    cgroup.event_control   cpuacct.usage         cpu.cfs_quota_us   cpu.shares         tasks
    cgroup.procs           cpuacct.usage_percpu  cpu.rt_period_us   cpu.stat

    # 将该cgroup的cpu消耗限制为20%  1000 1%  20*1000 20%
    echo 20000 > /sys/fs/cgroup/cpu/cpu_t/cpu.cfs_quota_us
    # 将死循环脚本进程的pid，纳入该cgroup限制管理
    echo 18608 >> /sys/fs/cgroup/cpu/cpu_t/tasks

    # 再用top命令查看。就会发现这个shell脚本进程的cpu消耗变成了20%，限制起了作用
    top - 21:16:43 up 12 min,  1 user,  load average: 0.98, 0.97, 0.59
    Tasks: 224 total,   3 running, 216 sleeping,   0 stopped,   5 zombie
    %Cpu(s): 11.1 us,  1.4 sy,  0.2 ni, 87.4 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
    KiB Mem :  3875640 total,   360680 free,  2656752 used,   858208 buff/cache
    KiB Swap:  2621436 total,  2621436 free,        0 used.   866636 avail Mem

      PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
    18608 root      20   0  113284   1188   1008 R  19.9  0.0   5:51.78 bash
    ```

- 内存限制
    ```sh
    # memory subsystem 默认的 hierarchy 就在 /sys/fs/cgroup/memory 目录
    mount | grep memory
    cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,memory)
    ```

    ```sh
    cd /sys/fs/cgroup/memory
    mkdir hello

    # 创建hello目录后，会自动生成以下文件
    ls hello
    cgroup.clone_children           memory.kmem.tcp.max_usage_in_bytes  memory.oom_control
    cgroup.event_control            memory.kmem.tcp.usage_in_bytes      memory.pressure_level
    cgroup.procs                    memory.kmem.usage_in_bytes          memory.soft_limit_in_bytes
    memory.failcnt                  memory.limit_in_bytes               memory.stat
    memory.force_empty              memory.max_usage_in_bytes           memory.swappiness
    memory.kmem.failcnt             memory.memsw.failcnt                memory.usage_in_bytes
    memory.kmem.limit_in_bytes      memory.memsw.limit_in_bytes         memory.use_hierarchy
    memory.kmem.max_usage_in_bytes  memory.memsw.max_usage_in_bytes     notify_on_release
    memory.kmem.slabinfo            memory.memsw.usage_in_bytes         tasks
    memory.kmem.tcp.failcnt         memory.move_charge_at_immigrate
    memory.kmem.tcp.limit_in_bytes  memory.numa_stat
    ```

    | 文件名                          | 功能                                                                                                                                                                                                                                                                                                     |
    |---------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
    | tasks                           | cgroup 中运行的进程（ PID）列表。将 PID 写入一个 cgroup 的 tasks 文件，可将此进程移至该 cgroup                                                                                                                                                                                                           |
    | cgroup.procs                    | cgroup 中运行的线程群组列表（ TGID ）。将 TGID 写入 cgroup 的 cgroup.procs 文件，可将此线程组群移至该 cgroup                                                                                                                                                                                            |
    | cgroup.event_control            | event_fd() 的接口。允许 cgroup 的变更状态通知被发送                                                                                                                                                                                                                                                      |
    | notify_on_release               | 用于自动移除空 cgroup 。默认为禁用状态（0）。设定为启用状态（1）时，当 cgroup 不再包含任何任务时（即，cgroup 的 tasks 文件包含 PID，而 PID 被移除，致使文件变空），kernel 会执行 release_agent 文件（仅在 root cgroup 出现）的内容，并且提供通向被清空 cgroup 的相关路径（与 root cgroup 相关）作为参数 |
    | memory.usage_in_bytes           | 显示 cgroup 中进程当前所用的内存总量（以字节为单位）                                                                                                                                                                                                                                                     |
    | memory.memsw.usage_in_bytes     | 显示 cgroup 中进程当前所用的内存量和 swap 空间总和（以字节为单位）                                                                                                                                                                                                                                       |
    | memory.max_usage_in_bytes       | 显示 cgroup 中进程所用的最大内存量（以字节为单位）                                                                                                                                                                                                                                                       |
    | memory.memsw.max_usage_in_bytes | 显示 cgroup 中进程的最大内存用量和最大 swap 空间用量（以字节为单位）                                                                                                                                                                                                                                     |
    | memory.limit_in_bytes           | 设定用户内存（包括文件缓存）的最大用量                                                                                                                                                                                                                                                                   |
    | memory.memsw.limit_in_bytes     | 设定内存与 swap 用量之和的最大值                                                                                                                                                                                                                                                                         |
    | memory.failcnt                  | 显示内存达到 memory.limit_in_bytes 设定的限制值的次数                                                                                                                                                                                                                                                    |
    | memory.memsw.failcnt            | 显示内存和 swap 空间总和达到 memory.memsw.limit_in_bytes 设定的限制值的次数                                                                                                                                                                                                                              |
    | memory.oom_control              | 可以为 cgroup 启用或者禁用“内存不足”（Out of Memory，OOM） 终止程序。默认为启用状态（0），尝试消耗超过其允许内存的任务会被 OOM 终止程序立即终止。设定为禁用状态（1）时，尝试使用超过其允许内存的任务会被暂停，直到有额外内存可用。                                                                       |

    - [更多文件的功能说明可以查看 kernel 文档中的 cgroup-v1/memory[4]](https://www.kernel.org/doc/Documentation/cgroup-v1/memory.txt)

    ```sh
    # 开启一个bash
    bash
    cd /sys/fs/cgroup/memory/hello

    # 在这个 hello cgroup 节点中，我们想限制某些进程的内存资源，只需将对应的进程 pid 写入到 tasks 文件，并把内存最大用量设定到 memory.limit_in_bytes 文件即可。

    # 这时候memory.usage_in_bytes还是0
    cat memory.usage_in_bytes
    0

    # 将当前bash添加
    echo $$ > tasks

    # 再次查看。可以看到当前内存使用量
    cat memory.usage_in_bytes
    380928

    # 设置内存最大用量
    echo 100M > memory.limit_in_bytes
    # 查看
    cat memory.limit_in_bytes
    104857600

    # hello cgroup 节点默认启用了 OOM 终止程序，因此，当有进程尝试使用超过可用内存时会被立即终止。查询 memory.failcnt 可知，目前还没有进程内存达到过设定的最大内存限制值。
    cat memory.failcnt
    0
    ```

    - 使用 [memtester](http://pyropus.ca/software/memtester/)工具来测试 100M 的最大内存限制是否生效：
        ```sh
        # 下载并安装
        curl -LO https://pyropus.ca./software/memtester/old-versions/memtester-4.6.0.tar.gz
        tar -zxvf memtester-4.6.0.tar.gz
        cd memtester-4.6.0/
        make && make install

        # 申请50M的内存成功
        memtester 50M 1
        cat memory.failcnt
        0

        # 申请100M，失败了
        memtester 100M 1
        pagesize is 4096
        pagesizemask is 0xfffffffffffff000
        want 100MB (104857600 bytes)
        got  100MB (104857600 bytes), trying mlock ...Killed

        # memory.failcnt 报告显示内存达到 memory.limit_in_bytes 设定的限制值（100M）的次数为 2793次。
        cat memory.failcnt
        2793
        ```

    - 删除
        ```sh
        rmdir /sys/fs/cgroup/memory/hello

        ```
#### go语言 cgroup相关代码

- 内存限制

    ```go
    //go:build linux
    // +build linux

    package main

    import (
     "fmt"
     "io/ioutil"
     "os"
     "os/exec"
     "path/filepath"
     "strconv"
     "syscall"
    )

    func main() {
     switch os.Args[1] {
     case "run":
      run()
     case "child":
      child()
     default:
      panic("help")
     }
    }

    func run() {
     fmt.Println("[main]", "pid:", os.Getpid())
     cmd := exec.Command("/proc/self/exe", append([]string{"child"}, os.Args[2:]...)...)
     cmd.Stdin = os.Stdin
     cmd.Stdout = os.Stdout
     cmd.Stderr = os.Stderr
     cmd.SysProcAttr = &syscall.SysProcAttr{
      Cloneflags: syscall.CLONE_NEWUTS |
       syscall.CLONE_NEWPID |
       syscall.CLONE_NEWNS,
      Unshareflags: syscall.CLONE_NEWNS,
     }
     must(cmd.Run())
    }

    func child() {
     fmt.Println("[exe]", "pid:", os.Getpid())
     cg()
     must(syscall.Sethostname([]byte("mycontainer")))
     must(os.Chdir("/"))
     must(syscall.Mount("proc", "proc", "proc", 0, ""))
     cmd := exec.Command(os.Args[2], os.Args[3:]...)
     cmd.Stdin = os.Stdin
     cmd.Stdout = os.Stdout
     cmd.Stderr = os.Stderr
     must(cmd.Run())
     must(syscall.Unmount("proc", 0))
    }

    func cg() {
     mycontainer_memory_cgroups := "/sys/fs/cgroup/memory/mycontainer"
     os.Mkdir(mycontainer_memory_cgroups, 0755)
     must(ioutil.WriteFile(filepath.Join(mycontainer_memory_cgroups, "memory.limit_in_bytes"), []byte("100M"), 0700))
     must(ioutil.WriteFile(filepath.Join(mycontainer_memory_cgroups, "notify_on_release"), []byte("1"), 0700))
     must(ioutil.WriteFile(filepath.Join(mycontainer_memory_cgroups, "tasks"), []byte(strconv.Itoa(os.Getpid())), 0700))
    }

    func must(err error) {
     if err != nil {
      panic(err)
     }
    }
    ```

    ```sh
    go run main.go run /bin/bash
    [main] pid: 31699
    [exe] pid: 1
    [root@mycontainer /]# ps
      PID TTY          TIME CMD
        1 pts/0    00:00:00 exe
        6 pts/0    00:00:00 bash
       17 pts/0    00:00:00 ps
    [root@mycontainer /]# cat /sys/fs/cgroup/memory/mycontainer/tasks
    1
    6
    18
    [root@mycontainer /]# cat /sys/fs/cgroup/memory/mycontainer/notify_on_release
    1

    # 最大内存使用量为100M
    [root@mycontainer /]# cat /sys/fs/cgroup/memory/mycontainer/memory.limit_in_bytes
    104857600

    # 使用前面安装好的memtester命令后。申请100M内存
    [root@mycontainer /]# memtester 100M 1
    pagesize is 4096
    pagesizemask is 0xfffffffffffff000
    want 100MB (104857600 bytes)
    got  100MB (104857600 bytes), trying mlock ...已杀死
    ```

### namespaces（命名空间）实现资源隔离

- namespaces（命名空间）是 Linux 为我们提供的用于分离进程树、网络接口、挂载点以及进程间通信等资源的方法。

- namespace是在内核级别以一种抽象的形式来封装系统资源，通过将系统资源放在不同的Namespace中，来实现资源隔离的目的。不同的Namespace程序，可以享有一份独立的系统资源。

- Linux 的命名空间机制提供了以下8种不同的命名空间，包括 :

    - 通过这八个选项, 我们能在创建新的进程时, 设置新进程应该在哪些资源上与宿主机器进行隔离。具体如下：

    | Namespace | Flag            | Page               | Isolates                                                                                                                       |
    |-----------|-----------------|--------------------|--------------------------------------------------------------------------------------------------------------------------------|
    | Cgroup    | CLONE_NEWCGROUP | cgroup_namespaces  | Cgroup root directory，Cgroup 信息隔离。用于隐藏进程所属的控制组的身份，使命名空间中的 cgroup 视图始终以根形式来呈现，保障安全 |
    | IPC       | CLONE_NEWIPC    | ipc_namespaces     | System V IPC                                                                                                                   | POSIX message queues ， 进程 IPC 通信隔离。让只有相同 IPC 命名空间的进程之间才可以共享内存、信号量、消息队列通信 |
    | Network   | CLONE_NEWNET    | network_namespaces | Network devices                                                                                                                | stacks                                                                                                           | ports | etc.网络隔离。使每个 net 命名空间有独立的网络设备，IP 地址，路由表，/proc/net 目录等网络资源 |
    | Mount     | CLONE_NEWNS     | mount_namespaces   | Mount points ，文件目录挂载隔离。用于隔离各个进程看到的挂载点视图                                                              |
    | PID       | CLONE_NEWPID    | pid_namespaces     | Process IDs ，进程 ID 隔离。使每个命名空间都有自己的初始化进程，PID 为 1，作为所有进程的父进程                                 |
    | Time      | CLONE_NEWTIME   | time_namespaces    | Boot and monotonic clocks，系统时间隔离。允许不同进程查看到不同的系统时间                                                     |
    | User      | CLONE_NEWUSER   | user_namespaces    | User and group IDs ，用户 UID 和组 GID 隔离。例如每个命名空间都可以有自己的 root 用户                                         |
    | UTS       | CLONE_NEWUTS    | uts_namespaces     | Hostname and NIS domain name ，主机名或域名隔离。使其在网络上可以被视作一个独立的节点而非主机上的一个进程                     |

- namespace将全局系统资源封装在抽象中，使命名空间内的进程看起来拥有自己的全局资源单独实例。对全局资源的更改对属于命名空间成员的其他进程可见，但对其他进程不可见。

    ![image](./Pictures/docker/namespace1.avif)

- 查看进程的Namespace

    - 每个进程都有一个独立的`/proc/[pid]/ns/`子目录
        - 其中包含了每个被支持操作的命名空间的条目，每个条目都是一个符号链接，其指向为对应namespace的文件的iNode ID，可以通过readlink命令查看这两个进程是否属于同一个命名空间，如果inode ID相同，则他们所属的相同的命名空间。

    ```sh
    # 查看进程的Namespace
    ls -l /proc/1010/ns
    lrwxrwxrwx - tz 29 Mar 17:11 cgroup -> cgroup:[4026531835]
    lrwxrwxrwx - tz 29 Mar 17:11 ipc -> ipc:[4026531839]
    lrwxrwxrwx - tz 29 Mar 17:11 mnt -> mnt:[4026531841]
    lrwxrwxrwx - tz 29 Mar 17:11 net -> net:[4026531840]
    lrwxrwxrwx - tz 29 Mar 17:11 pid -> pid:[4026531836]
    lrwxrwxrwx - tz 29 Mar 17:11 pid_for_children -> pid:[4026531836]
    lrwxrwxrwx - tz 29 Mar 17:11 time -> time:[4026531834]
    lrwxrwxrwx - tz 29 Mar 17:11 time_for_children -> time:[4026531834]
    lrwxrwxrwx - tz 29 Mar 17:11 user -> user:[4026531837]
    lrwxrwxrwx - tz 29 Mar 17:11 uts -> uts:[4026531838]

    # 查看pid为1010和2020的namespace是否相同。结果是相同
    readlink /proc/1010/ns/uts
    uts:[4026531838]

    readlink /proc/2020/ns/uts
    uts:[4026531838]

    # 运行最小化linux的alpine，并进入shell
    docker run -it --rm alpine /bin/sh

    / #     ls -l /proc/$$/ns
    total 0
    lrwxrwxrwx    1 root     root             0 Mar 29 09:16 cgroup -> cgroup:[4026533361]
    lrwxrwxrwx    1 root     root             0 Mar 29 09:16 ipc -> ipc:[4026532936]
    lrwxrwxrwx    1 root     root             0 Mar 29 09:16 mnt -> mnt:[4026532932]
    lrwxrwxrwx    1 root     root             0 Mar 29 09:16 net -> net:[4026532938]
    lrwxrwxrwx    1 root     root             0 Mar 29 09:16 pid -> pid:[4026532937]
    lrwxrwxrwx    1 root     root             0 Mar 29 09:16 pid_for_children -> pid:[4026532937]
    lrwxrwxrwx    1 root     root             0 Mar 29 09:16 time -> time:[4026531834]
    lrwxrwxrwx    1 root     root             0 Mar 29 09:16 time_for_children -> time:[4026531834]
    lrwxrwxrwx    1 root     root             0 Mar 29 09:16 user -> user:[4026531837]
    lrwxrwxrwx    1 root     root             0 Mar 29 09:16 uts -> uts:[4026532935]

    / # readlink /proc/$$/ns/uts
    uts:[4026532935]
    ```

#### unshare namespace相关命令

- `unshare`命令是 util-linux 工具包中的一个工具，CentOS 7 系统默认已经集成了该工具，使用 `unshare` 命令可以实现创建并访问不同类型的 Namespace。执行命令后，当前命令行窗口加入了新创建的namespace。

- 1.`PID Namespace`：用来隔离进程ID。在不同的 PID Namespace 中，进程可以拥有相同的 PID 号，利用 PID Namespace 可以实现每个容器的主进程为 1 号进程，而容器内的进程在主机上却拥有不同的PID。

    ```sh
    # 在当前主机上创建了一个新的 PID Namespace，并且当前命令行窗口加入了新创建的 PID Namespace
    unshare --fork --pid --mount-proc /bin/bash

    # 通过ps -ef，可以看到PID的1号进程和Host OS的1号进程不一致。而且我们也看不到主机上的其他进程信息
    ps -ef
    UID          PID    PPID  C STIME TTY          TIME CMD
    root           1       0  0 17:18 pts/3    00:00:00 /bin/bash
    root           3       1  0 17:18 pts/3    00:00:00 ps -ef
    ```

    - 除了 pid, mnt Namespace 的 ID 值不一样外，其他Namespace 的 ID 值均一致。
        ```sh
        # 在新的pid namespace下，查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        total
        lrwxrwxrwx cgroup -> cgroup:[4026531835]
        lrwxrwxrwx ipc -> ipc:[4026531839]
        lrwxrwxrwx mnt -> mnt:[4026532926]
        lrwxrwxrwx net -> net:[4026531840]
        lrwxrwxrwx pid -> pid:[4026532927]
        lrwxrwxrwx pid_for_children -> pid:[4026532927]
        lrwxrwxrwx time -> time:[4026531834]
        lrwxrwxrwx time_for_children -> time:[4026531834]
        lrwxrwxrwx user -> user:[4026531837]
        lrwxrwxrwx uts -> uts:[4026531838]

        # 退出新的pid namespace
        exit

        # 在本机查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        lrwxrwxrwx cgroup:[4026531835]
        lrwxrwxrwx ipc:[4026531839]
        lrwxrwxrwx mnt:[4026531841]
        lrwxrwxrwx net:[4026531840]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx user:[4026531837]
        lrwxrwxrwx uts:[4026531838]
        ```

- 2.`Mount Namespace`：用来隔离不同的进程或者进程组看到的挂载点。在容器内的挂载操作不会影响主机的挂载目录。
    ```sh
    # 创建新的Mount Namespace.
    unshare --mount --fork /bin/bash

    # 独立的 Mount Namespace 中执行 mount 操作并不会影响主机。
    mkdir /tmp/mnt
    mount -t tmpfs -o size=1m tmpfs /tmp/mnt
    df -h|grep mnt
    ```

    - 除了 mnt Namespace 的 ID 值不一样外，其他Namespace 的 ID 值均一致。
        ```sh
        # 在新的mount namespace下，查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        total 0
        lrwxrwxrwx 1 root root 0 Mar 29 17:25 cgroup -> 'cgroup:[4026531835]'
        lrwxrwxrwx 1 root root 0 Mar 29 17:25 ipc -> 'ipc:[4026531839]'
        lrwxrwxrwx 1 root root 0 Mar 29 17:25 mnt -> 'mnt:[4026532926]'
        lrwxrwxrwx 1 root root 0 Mar 29 17:25 net -> 'net:[4026531840]'
        lrwxrwxrwx 1 root root 0 Mar 29 17:25 pid -> 'pid:[4026531836]'
        lrwxrwxrwx 1 root root 0 Mar 29 17:25 pid_for_children -> 'pid:[4026531836]'
        lrwxrwxrwx 1 root root 0 Mar 29 17:25 time -> 'time:[4026531834]'
        lrwxrwxrwx 1 root root 0 Mar 29 17:25 time_for_children -> 'time:[4026531834]'
        lrwxrwxrwx 1 root root 0 Mar 29 17:25 user -> 'user:[4026531837]'
        lrwxrwxrwx 1 root root 0 Mar 29 17:25 uts -> 'uts:[4026531838]'

        # 退出新的mount namespace
        exit

        # 在本机查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        lrwxrwxrwx cgroup:[4026531835]
        lrwxrwxrwx ipc:[4026531839]
        lrwxrwxrwx mnt:[4026531841]
        lrwxrwxrwx net:[4026531840]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx user:[4026531837]
        lrwxrwxrwx uts:[4026531838]
        ```

- 3.`IPC Namespace`：用来隔离进程间通信的。
    - 例如 PID Namespace 和 IPC Namespace 一起使用。可以实现同一 IPC Namespace 内的进程彼此可以通信，不同 IPC Namespace 的进程却不能通信。
    ```sh
    # 创建新的ipc Namespace.
    unshare --fork --ipc /bin/bash

    # 使用ipcs -q 命令查看当前IPC Namespace下的系统通信队列列表，可以看到当前为空
    ipcs -q
    ------ Message Queues --------
    key        msqid      owner      perms      used-bytes   messages

    # 创建一个系统通信队列
    ipcmk -Q

    # 再次查看
    ipcs -q
    ------ Message Queues --------
    key        msqid      owner      perms      used-bytes   messages
    0x26d94c97 0          root       644        0            0
    ```

    - 除了 ipc Namespace 的 ID 值不一样外，其他Namespace 的 ID 值均一致。

        ```sh
        # 在新的ipc namespace下，查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        total
        lrwxrwxrwx cgroup -> cgroup:[4026531835]
        lrwxrwxrwx ipc -> ipc:[4026532926]
        lrwxrwxrwx mnt -> mnt:[4026531841]
        lrwxrwxrwx net -> net:[4026531840]
        lrwxrwxrwx pid -> pid:[4026531836]
        lrwxrwxrwx pid_for_children -> pid:[4026531836]
        lrwxrwxrwx time -> time:[4026531834]
        lrwxrwxrwx time_for_children -> time:[4026531834]
        lrwxrwxrwx user -> user:[4026531837]
        lrwxrwxrwx uts -> uts:[4026531838]

        # 退出新的ipc namespace
        exit

        # 在本机查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        lrwxrwxrwx cgroup:[4026531835]
        lrwxrwxrwx ipc:[4026531839]
        lrwxrwxrwx mnt:[4026531841]
        lrwxrwxrwx net:[4026531840]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx user:[4026531837]
        lrwxrwxrwx uts:[4026531838]
        ```

- 4.`UTS Namespace`：用来隔离主机名。
    ```sh
    # 创建新的uts Namespace.
    unshare --fork --uts /bin/bash

    # 修改主机名为docker
    hostname docker
    # 查看主机名，可以看到已经被修改为docker
    hostname
    docker
    ```

    - 除了 uts Namespace 的 ID 值不一样外，其他Namespace 的 ID 值均一致。

        ```sh
        # 在新的uts namespace下，查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        total
        lrwxrwxrwx cgroup -> cgroup:[4026531835]
        lrwxrwxrwx ipc -> ipc:[4026531839]
        lrwxrwxrwx mnt -> mnt:[4026531841]
        lrwxrwxrwx net -> net:[4026531840]
        lrwxrwxrwx pid -> pid:[4026531836]
        lrwxrwxrwx pid_for_children -> pid:[4026531836]
        lrwxrwxrwx time -> time:[4026531834]
        lrwxrwxrwx time_for_children -> time:[4026531834]
        lrwxrwxrwx user -> user:[4026531837]
        lrwxrwxrwx uts -> uts:[4026532927]

        # 退出新的uts namespace
        exit

        # 在本机查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        lrwxrwxrwx cgroup:[4026531835]
        lrwxrwxrwx ipc:[4026531839]
        lrwxrwxrwx mnt:[4026531841]
        lrwxrwxrwx net:[4026531840]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx user:[4026531837]
        lrwxrwxrwx uts:[4026531838]
        ```

- 5.`User Namespace`：用来隔离用户和用户组的。
    - 一个比较典型的应用场景就是在主机上以非 root 用户运行的进程可以在一个单独的 User Namespace 中映射成 root 用户。

    - 使用 User Namespace 可以实现进程在容器内拥有 root 权限，而在主机上却只是普通用户。

    - CentOS7 默认允许创建的 User Namespace 为 0，如果执行unshare命令失败（ unshare 命令返回的错误为 unshare: unshare failed: Invalid argument ），需要使用以下命令修改系统允许创建的 User Namespace 数量，命令为：`echo 65535 > /proc/sys/user/max_user_namespaces`，然后再次尝试创建 User Namespace。

    ```sh
    # 新建test用户
    useradd test
    passwd test
    # 切换test用户
    su - test

    # 创建新的user Namespace.
    unshare --user -r /bin/bash

    # 执行id命令，可以发现我们用户已经变成了root,uid, gid都变成0了。
    id
    uid=0(root) gid=0(root) groups=0(root)

    # 但是在执行root用户才能执行的命令时，并没有root权限
    mkdir /root/test
    mkdir: cannot create directory ‘/root/test’: Permission denied
    ```

    - 除了 user Namespace 的 ID 值不一样外，其他Namespace 的 ID 值均一致。
        ```sh
        # 在新的user namespace下，查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        total
        lrwxrwxrwx cgroup -> cgroup:[4026531835]
        lrwxrwxrwx ipc -> ipc:[4026531839]
        lrwxrwxrwx mnt -> mnt:[4026531841]
        lrwxrwxrwx net -> net:[4026531840]
        lrwxrwxrwx pid -> pid:[4026531836]
        lrwxrwxrwx pid_for_children -> pid:[4026531836]
        lrwxrwxrwx time -> time:[4026531834]
        lrwxrwxrwx time_for_children -> time:[4026531834]
        lrwxrwxrwx user -> user:[4026532919]
        lrwxrwxrwx uts -> uts:[4026531838]

        # 退出新的user namespace
        exit

        # 在本机查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        lrwxrwxrwx cgroup:[4026531835]
        lrwxrwxrwx ipc:[4026531839]
        lrwxrwxrwx mnt:[4026531841]
        lrwxrwxrwx net:[4026531840]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx user:[4026531837]
        lrwxrwxrwx uts:[4026531838]
        ```

- 6.`Net Namespace`：用来隔离网络设备、IP 地址和端口等信息的。
    ```sh
    # 创建新的net Namespace.
    unshare --net --fork /bin/bash

    # 查看主机的网络配置相关的信息
    ip a
    ```

    - 除了 net Namespace 的 ID 值不一样外，其他Namespace 的 ID 值均一致。
        ```sh
        # 在新的net namespace下，查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        total
        lrwxrwxrwx cgroup -> cgroup:[4026531835]
        lrwxrwxrwx ipc -> ipc:[4026531839]
        lrwxrwxrwx mnt -> mnt:[4026531841]
        lrwxrwxrwx net -> net:[4026532928]
        lrwxrwxrwx pid -> pid:[4026531836]
        lrwxrwxrwx pid_for_children -> pid:[4026531836]
        lrwxrwxrwx time -> time:[4026531834]
        lrwxrwxrwx time_for_children -> time:[4026531834]
        lrwxrwxrwx user -> user:[4026531837]
        lrwxrwxrwx uts -> uts:[4026531838]

        # 退出新的net namespace
        exit

        # 在本机查看进程namespace
        ls -l /proc/$$/ns | awk '{print $1, $9, $10, $11}'
        lrwxrwxrwx cgroup:[4026531835]
        lrwxrwxrwx ipc:[4026531839]
        lrwxrwxrwx mnt:[4026531841]
        lrwxrwxrwx net:[4026531840]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx pid:[4026531836]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx time:[4026531834]
        lrwxrwxrwx user:[4026531837]
        lrwxrwxrwx uts:[4026531838]
        ```

- 7.`Cgroup Namespace`：对进程的cgroup视图虚拟化。每个 cgroup 命名空间都有自己的一组 cgroup 根目录。Linux 4.6开始支持。

    - cgroup 命名空间提供的虚拟化有多种用途：
        - 防止信息泄漏。否则容器外的cgroup 目录路径对容器中的进程可见。
        - 简化了容器迁移等任务。
        - 允许更好地限制容器化进程。可以挂载容器的 cgroup 文件系统，这样容器无需访问主机 cgroup 目录。

- 8.`Time Namespace`：虚拟化两个系统时钟名称空间，用于隔离时间。linux 5.7内核开始支持

#### docker run namespace相关命令

| 命名空间相关参数 | 操作         |
| ---------------- | ------------ |
| --net            | 指定网卡     |
| `--net=none`     | 不指定网卡   |
| --pid            | pid          |
| --user           | 指定用户和组 |


`host` 表示与本地主机同一命名空间

```bash
docker run --pid=host \
    --rm -it opensuse

docker run --net=host \
    --rm -it opensuse

# 绕过部分sysctls
docker run --ipc=host \
    --rm -it opensuse
```

设置同一 `ipc` ,方便共享内存

```bash
docker run --name opensuse_c1 \
    --rm -it opensuse

docker run --ipc=container:opensuse_c1 \
    --name centos_c1 \
    --rm -it centos
```

指定 user

```bash
docker run -u=1000 \
    --rm -it centos
```

#### go语言 namespace相关代码

![image](./Pictures/docker/namespace-go.avif)

- `clone()`：用于创建新进程，通过传入一个或多个系统调用参数（ flags 参数）可以创建出不同类型的 NameSpace ，并且子进程也将会成为这些 NameSpace 的成员。

    ```go
    int clone(int (*fn)(void *), void *stack, int flags, void *arg, ...
                     /* pid_t *parent_tid, void *tls, pid_t *child_tid */ );
    ```

- `setns()`：用于将进程加入到一个现有的 Namespace 中。其中 fd 为文件描述符，引用 /proc/[pid]/ns/ 目录里对应的文件，nstype 代表 NameSpace 类型。

    ```go
    int setns(int fd, int nstype);
    ```

- `unshare()`：用于将进程移出原本的 NameSpace ，并加入到新创建的 NameSpace 中。同样是通过传入一个或多个系统调用参数（ flags 参数）来创建新的 NameSpace 。
    ```go
    int unshare(int flags);
    ```

- `ioctl()`：用于发现有关 NameSpace 的信息。

    ```go
    int ioctl(int fd, unsigned long request, ...);
    ```

- 上面的这些系统调用函数，我们可以直接用 C 语言调用，创建出各种类型的 NameSpace ，对于 Go 语言，其内部已经帮我们封装好了这些函数操作，可以更方便地直接使用，降低心智负担。

- 创建`main.go`文件
    ```go
    package main

    import (
     "os"
     "os/exec"
    )

    func main() {
     switch os.Args[1] {
     case "run":
      run()
     default:
      panic("help")
     }
    }

    func run() {
     cmd := exec.Command(os.Args[2], os.Args[3:]...)
     cmd.Stdin = os.Stdin
     cmd.Stdout = os.Stdout
     cmd.Stderr = os.Stderr
     must(cmd.Run())
    }

    func must(err error) {
     if err != nil {
      panic(err)
     }
    }
    ```

    ```sh
    # 执行main.go代码。会创建出 main 进程， main 进程内执行 echo hello 命令创建出一个新的 echo 进程，最后随着 echo 进程的执行完毕，main 进程也随之结束并退出。
    go run main.go run echo hello

    go run main.go run /bin/bash
    [tz@tz-pc tmp]$ ps
        PID TTY          TIME CMD
       8356 pts/2    00:00:00 zsh
       9073 pts/2    00:00:00 go
       9180 pts/2    00:00:00 main
       9185 pts/2    00:00:00 bash
       9213 pts/2    00:00:00 ps
    ```

- UTS隔离

    - 要想实现资源隔离，在 run() 函数增加 SysProcAttr 配置，先从最简单的 UTS 隔离开始，传入对应的 CLONE_NEWUTS 系统调用参数，并通过 syscall.Sethostname 设置主机名：

    - 但是这样做是修改的main进程的主机，所以需要/proc/self/exe

    ```go
    package main

    import (
     "os"
     "os/exec"
     "syscall"
    )

    func main() {
     switch os.Args[1] {
     case "run":
      run()
     case "child":
      child()
     default:
      panic("help")
     }
    }

    func run() {
     cmd := exec.Command("/proc/self/exe", append([]string{"child"}, os.Args[2:]...)...)
     cmd.Stdin = os.Stdin
     cmd.Stdout = os.Stdout
     cmd.Stderr = os.Stderr
     cmd.SysProcAttr = &syscall.SysProcAttr{
      Cloneflags: syscall.CLONE_NEWUTS,
     }
     must(cmd.Run())
    }

    func child() {
     must(syscall.Sethostname([]byte("mycontainer")))
     cmd := exec.Command(os.Args[2], os.Args[3:]...)
     cmd.Stdin = os.Stdin
     cmd.Stdout = os.Stdout
     cmd.Stderr = os.Stderr
     must(cmd.Run())
    }

    func must(err error) {
     if err != nil {
      panic(err)
     }
    }
    ```

    - 总结一下就是， main 进程创建了 exe 进程（exe 进程已经进行 UTS 隔离，exe 进程更改主机名不会影响到 main 进程）， 接着 exe 进程内执行 echo hello 命令创建出一个新的 echo 进程，最后随着 echo 进程的执行完毕，exe 进程随之结束，exe 进程结束后， main 进程再结束并退出。

    ```sh
    sudo go run main.go run echo hello

    sudo go run main.go run /bin/bash

    [root@mycontainer k8s]# hostname
    mycontainer

    [root@mycontainer tmp]# ps
        PID TTY          TIME CMD
      10893 pts/3    00:00:00 sudo
      10894 pts/3    00:00:00 go
      10994 pts/3    00:00:00 main
      10999 pts/3    00:00:00 exe
      11004 pts/3    00:00:00 bash
      11125 pts/3    00:00:00 ps
    ```

- PID隔离

    - Cloneflags 参数新增了 CLONE_NEWPID 和 CLONE_NEWNS 分别隔离进程 pid 和文件目录挂载点视图，Unshareflags: syscall.CLONE_NEWNS 则是用于禁用挂载传播。

    - 当我们创建 PID Namespace 时，exe 进程包括其创建出来的子进程的 pid 已经和 main 进程隔离了，这一点可以通过打印 os.Getpid() 结果或执行 echo $$ 命令得到验证。但此时还不能使用 ps 命令查看，因为 ps 和 top 等命令会使用 /proc 的内容，所以我们才继续引入了 Mount Namespace ，并在 exe 进程挂载 /proc 目录。

    ```go
    package main

    import (
     "fmt"
     "os"
     "os/exec"
     "syscall"
    )

    func main() {
     switch os.Args[1] {
     case "run":
      run()
     case "child":
      child()
     default:
      panic("help")
     }
    }

    func run() {
     fmt.Println("[main]", "pid:", os.Getpid())
     cmd := exec.Command("/proc/self/exe", append([]string{"child"}, os.Args[2:]...)...)
     cmd.Stdin = os.Stdin
     cmd.Stdout = os.Stdout
     cmd.Stderr = os.Stderr
     cmd.SysProcAttr = &syscall.SysProcAttr{
      Cloneflags: syscall.CLONE_NEWUTS |
       syscall.CLONE_NEWPID |
       syscall.CLONE_NEWNS,
      Unshareflags: syscall.CLONE_NEWNS,
     }
     must(cmd.Run())
    }

    func child() {
     fmt.Println("[exe]", "pid:", os.Getpid())
     must(syscall.Sethostname([]byte("mycontainer")))
     must(os.Chdir("/"))
     must(syscall.Mount("proc", "proc", "proc", 0, ""))
     cmd := exec.Command(os.Args[2], os.Args[3:]...)
     cmd.Stdin = os.Stdin
     cmd.Stdout = os.Stdout
     cmd.Stderr = os.Stderr
     must(cmd.Run())
     must(syscall.Unmount("proc", 0))
    }

    func must(err error) {
     if err != nil {
      panic(err)
     }
    }
    ```

    ```sh
    sudo go run main.go run /bin/bash
    [main] pid: 11829
    [exe] pid: 1

    # exe 作为初始化进程，pid 为 1 ，创建出了 pid 6 的 bash 子进程，而且已经看不到 main 进程了
    [root@mycontainer /]# ps
        PID TTY          TIME CMD
          1 pts/3    00:00:00 exe
          6 pts/3    00:00:00 bash
          8 pts/3    00:00:00 ps
    ```

### UnionFS（联合文件系统）

- [knowclub：探究Docker三板斧之联合文件系统 UnionFS](https://mp.weixin.qq.com/s?__biz=Mzk0OTI3MDg5MA==&mid=2247487039&idx=1&sn=ad9b717096fbb345b6f21be5775ab589&chksm=c35bae3af42c272c510ddc63f5faef3dbade509ff20f175ff494ff6a9819f8a80a25963e8e23&token=641505571&lang=zh_CN&scene=21#wechat_redirect)

- UnionFS 全称 Union File System （联合文件系统）：是为 Linux、FreeBSD 和 NetBSD 操作系统设计的一种分层、轻量级并且高性能的文件系统，可以 **把多个目录内容联合挂载到同一个目录下** ，而目录的物理位置是分开的，并且对文件系统的修改是类似于 git 的 commit 一样 **作为一次提交来一层层的叠加的 。**

- 在 Docker 中，镜像相当于是容器的模板，一个镜像可以衍生出多个容器。
    - 镜像利用 UnionFS 技术来实现，就可以利用其 分层的特性 来进行镜像的继承，基于基础镜像，制作出各种具体的应用镜像，不同容器就可以直接 共享基础的文件系统层 ，同时再加上自己独有的改动层，大大提高了存储的效率。
    ![image](./Pictures/docker/UnionFS.avif)

- 以下面dockerfile为例，介绍UnionFS原理

    ```dockerfile
    FROM ubuntu:18.04
    LABEL org.opencontainers.image.authors="org@example.com"
    COPY . /app
    RUN make /app
    RUN rm -r $HOME/.cache
    CMD python /app/app.py
    ```

    - 1.`FROM` 语句从 ubuntu:18.04 镜像创建一个层 【1】
    - 2.`LABEL` 命令仅修改镜像的元数据，不会生成新镜像层
    - 3.`COPY` 命令会把当前目录中的文件添加到镜像中的 /app 目录下，在层【1】的基础上生成了层【2】。
    - 4.第一个 `RUN` 命令使用 make 构建应用程序，并将结果写入新层【3】
    - 5.第二个 `RUN` 命令删除缓存目录，并将结果写入新层【4】。
    - 6.最后，CMD 指令指定在容器内运行什么命令，只修改了镜像的元数据，也不会产生镜像层。

    - 这【4】个层（layer）相互堆叠在一起就是一个镜像。

    - 当创建一个新容器时，会在 镜像层（image layers） 上面再添加一个新的可写层，称为 容器层（container layer） 。对正在运行的容器所做的所有更改，例如写入新文件、修改现有文件和删除文件，都会写入到这个可写容器层。

        - 多个容器运行时,如果未修改镜像内容,会**共享镜像层**(layer)

          - 容器启动时,在只读的镜像层上添加 自己的**可写覆盖层**

          - 容器运行过程中修改镜像时,会将修改的内容写入 可写覆盖层(copy on wirte)

            ![image](./Pictures/docker/fs1.avif)

        - 对于相同的镜像层，每一个容器都会有自己的可写**容器层**，并且所有的变化都存储在这个**容器层**中，所以多个容器可以共享对同一个底层镜像的访问，并且拥有自己的数据状态。而当容器被删除时，其可写容器层也会被删除。

        - 如果用户需要持久化容器里的数据，就需要使用 Volume 挂载到宿主机目录。

- Docker 支持的 UnionFS 有以下几种类型：

    | 联合文件系统  | 存储驱动       | 说明                                                                                                                                                         |
    |---------------|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
    | OverlayFS     | overlay2       | 当前所有受支持的 Linux 发行版的 首选 存储驱动程序，并且不需要任何额外的配置                                                                                 |
    | OverlayFS     | fuse-overlayfs | 仅在不提供对 rootless 支持的主机上运行 Rootless Docker 时才首选                                                                                              |
    | Btrfs 和 ZFS  | btrfs 和 zfs   | 允许使用高级选项，例如创建快照，但需要更多的维护和设置                                                                                                       |
    | VFS           | vfs            | 旨在用于测试目的，以及无法使用写时复制文件系统的情况下使用。此存储驱动程序性能较差，一般不建议用于生产用途                                                   |
    | AUFS          | aufs           | Docker 18.06 和更早版本的首选存储驱动程序。但是在没有 overlay2 驱动的机器上仍然会使用 aufs 作为 Docker 的默认驱动                                           |
    | Device Mapper | devicemapper   | RHEL （旧内核版本不支持 overlay2，最新版本已支持）的 Docker Engine 的默认存储驱动，有两种配置模式：loop-lvm（零配置但性能差） 和 direct-lvm（生产环境推荐） |
    | OverlayFS     | overlay        | 推荐使用 overlay2 存储驱动                                                                                                                                   |

    - AUFS 目前并未被合并到 Linux 内核主线，因此只有 Ubuntu 和 Debian 等少数操作系统支持 AUFS。如果你想要在 CentOS 等操作系统下使用 AUFS，需要单独安装 AUFS 模块（生产环境不推荐）。

        ```sh
        # 查看是否支持 AUFS
        grep aufs /proc/filesystems
        nodev   aufs
        ```

#### OverlayFS

- OverlayFS 的发展分为两个阶段：
    - 1.第一版的overlay文件系统存在很多弊端（例如运行一段时间后Docker 会报 "too many links problem" 的错误）
    - 2.Linux 内核在 4.0 版本对overlay做了很多必要的改进，此时的 OverlayFS 被称之为overlay2。
    - 因此，在 Docker 中 OverlayFS 文件驱动被分为了两种
        - 一种是早期的overlay，不推荐在生产环境中使用
        - 另一种是更新和更稳定的overlay2，推荐在生产环境中使用

- 使用 overlay2 的先决条件

    - 条件限制
        - 1.Docker 版本必须高于 17.06.02
        - 2.如果你的操作系统是 RHEL 或 CentOS，Linux 内核版本必须使用 3.10.0-514 或者更高版本，其他 Linux 发行版的内核版本必须高于 4.0（例如 Ubuntu 或 Debian），你可以使用uname -a查看当前系统的内核版本。

    - overlay2最好搭配 xfs 文件系统使用，并且使用 xfs 作为底层文件系统时，d_type必须开启

        ```sh
        # 验证 d_type 是否开启
        xfs_info /var/lib/docker | grep ftype
        naming   =version 2              bsize=4096   ascii-ci=0 ftype=1

        # 以上命令输出结果中有 ftype=1 时，表示 d_type 已经开启。如果你的输出结果为 ftype=0，则需要重新格式化磁盘目录，命令如下：
        sudo mkfs.xfs -f -n ftype=1 /path/to/disk
        ```

        - 写入到 `/etc/fstab`

            ```
            UUID /var/lib/docker xfs defaults,pquota 0 0
            ```

- 如何在 Docker 中配置 overlay2？

    ```sh
    # 默认就是overlay2
    docker info | grep -i  "Storage Driver"
    Storage Driver: overlay2
    ```

    - 也可以在 /etc/docker 目录下创建 daemon.json 文件，如果该文件已经存在，则修改配置为以下内容

        - overlay2.size 参数表示限制每个容器根目录大小为 20G。
            - 限制每个容器的磁盘空间大小是通过 xfs 的 pquota 特性实现
            - overlay2.size 可以根据不同的生产环境来设置这个值的大小。
            - 我推荐你在生产环境中开启此参数，防止某个容器写入文件过大，导致整个 Docker 目录空间溢出。

        ```json
        {
          "storage-driver": "overlay2",
          "storage-opts": [
            "overlay2.size=20G",
            "overlay2.override_kernel_check=true"
          ]
        }
        ```

- overlay2 工作原理

    - overlay2 由四个结构组成，其中：
        - lowerdir ：表示较为底层的目录，对应 Docker 中的只读镜像层
        - upperdir ：表示较为上层的目录，对应 Docker 中的可写容器层
        - workdir ：表示工作层（中间层）的目录，在使用过程中对用户不可见
        - merged ：所有目录合并后的联合挂载点，给用户暴露的统一目录视图，对应 Docker 中用户实际看到的容器内的目录视图

    - overlay2 将所有目录称之为层（layer），overlay2 的目录是镜像和容器分层的基础，而把这些层统一展现到同一的目录下的过程称为联合挂载（union mount）。overlay2 把目录的下一层叫作lowerdir，上一层叫作upperdir，联合挂载后的结果叫作merged。

        ![image](./Pictures/docker/overlay2架构图.avif)

    - overlay2 文件系统最多支持 128 个层数叠加，也就是说你的 Dockerfile 最多只能写 128 行，不过这在日常使用中足够了。

    ```sh
    # 查看alpine镜像
    docker image inspect alpine
        "GraphDriver": {
            "Data": {
                "MergedDir": "/var/lib/docker/overlay2/45c4d745bc72a9358d014f4a11b9db4966f24dd164900a01da8faf5a27e6d3d8/merged",
                "UpperDir": "/var/lib/docker/overlay2/45c4d745bc72a9358d014f4a11b9db4966f24dd164900a01da8faf5a27e6d3d8/diff",
                "WorkDir": "/var/lib/docker/overlay2/45c4d745bc72a9358d014f4a11b9db4966f24dd164900a01da8faf5a27e6d3d8/work"
            },
            "Name": "overlay2"
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:8d3ac3489996423f53d6087c81180006263b79f206d3fdec9e66f0e27ceb8759"
            ]
        },

    docker run --name=al -d alpine sleep 3600

    # 查看一下容器的工作目录。MergedDir 后面的内容即为容器层的工作目录，LowerDir 为容器所依赖的镜像层目录。
    docker inspect al
    "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/e317fdbf5c0bfecee7e756cceca8b26e05ab0cf6ac8f975b38734d51d44aeec5-init/diff:/var/lib/docker/overlay2/45c4d745bc72a9358d014f4a11b9db4966f24dd164900a01da8faf5a27e6d3d8/diff",
                "MergedDir": "/var/lib/docker/overlay2/e317fdbf5c0bfecee7e756cceca8b26e05ab0cf6ac8f975b38734d51d44aeec5/merged",
                "UpperDir": "/var/lib/docker/overlay2/e317fdbf5c0bfecee7e756cceca8b26e05ab0cf6ac8f975b38734d51d44aeec5/diff",
                "WorkDir": "/var/lib/docker/overlay2/e317fdbf5c0bfecee7e756cceca8b26e05ab0cf6ac8f975b38734d51d44aeec5/work"
            },
            "Name": "overlay2"
        },

    # 查看一下容器层下的内容
    # link 文件内容为该容器层的短 ID，lower 文件为该层的所有父层镜像的短 ID 。diff 目录为容器的读写层，容器内修改的文件都会在 diff 中出现，merged 目录为分层文件联合挂载后的结果，也是容器内的工作目录。
    ls /var/lib/docker/overlay2/e317fdbf5c0bfecee7e756cceca8b26e05ab0cf6ac8f975b38734d51d44aeec5
    diff  link  lower  merged  work
    ```

    - 总体来说，overlay2 是这样储存文件的：overlay2将镜像层和容器层都放在单独的目录，并且有唯一 ID，每一层仅存储发生变化的文件，最终使用联合挂载技术将容器层和镜像层的所有文件统一挂载到容器中，使得容器中看到完整的系统文件。

- overlay2 如何读取、修改文件？

    - 对于读的情况：
        - 文件在 upperdir ，直接读取
        - 文件不在 upperdir ，从 lowerdir 读取，会产生非常小的性能开销
        - 文件同时存在 upperdir 和 lowerdir 中，从 upperdir 读取（upperdir 中的文件隐藏了 lowerdir 中的同名文件）

    - 对于写的情况：

        - 创建一个新文件，文件在 upperdir 和 lowerdir 中都不存在，则直接在 upperdir 创建
        - 修改文件，如果该文件在 upperdir 中存在，则直接修改
        - 修改文件，如果该文件在 upperdir 中不存在，将执行 copy_up 操作，把文件从 lowerdir 复制到 upperdir ，后续对该文件的写入操作将对已经复制到 upperdir 的副本文件进行操作。这就是 写时复制（copy-on-write）
        - 删除文件，如果文件只在 upperdir 存在，则直接删除
        - 删除文件，如果文件只在 lowerdir 存在，会在 upperdir 中创建一个同名的空白文件（whiteout file），lowerdir 中的文件不会被删除，因为他们是只读的，但 whiteout file 会阻止它们继续显示
        - 删除文件，如果文件在 upperdir 和 lowerdir 中都存在，则先将 upperdir 中的文件删除，再创建一个同名的空白文件（whiteout file）
        - 删除目录和删除文件是一致的，会在 upperdir 中创建一个同名的不透明的目录（opaque directory），和 whiteout file 原理一样，opaque directory 会阻止用户继续访问，即便 lowerdir 内的目录仍然存在

    - 这里面没有涉及到workdir，但其实 workdir 的作用不可忽视。想象一下，在删除文件（或目录）的场景下（文件或目录在 upperdir 和 lowerdir 中都存在）对于 lowerdir 而言，倒没什么，毕竟只读，不需要理会，但是对于 upperdir 来讲就不同了。在 upperdir 中，我们要先删除对应的文件，然后才可以创建同名的 whiteout file ，如何保证这两步必须都执行，这就涉及到了原子性操作了。

    - workdir 是用来进行一些中间操作的，其中就包括了原子性保证。在上面的问题中，完全可以先在 workdir 创建一个同名的 whiteout file ，然后再在 upperdir 上执行两步操作，成功之后，再删除掉 workdir 中的 whiteout file 即可。

    - 而当修改文件时，workdir 也在充当着中间层的作用，当对 upperdir 里面的副本进行修改时，会先放到 workdir ，然后再从 workdir 移到 upperdir 里面去。

#### rootfs（根文件系统）

- rootfs（根文件系统）：包括如下所示的一些目录和文件，比如 /bin，/etc，/proc 等等。

    - 而你进入容器之后执行的 /bin/bash，就是 /bin 目录下的可执行文件，与宿主机的 /bin/bash 完全不同。

- rootfs 只是一个操作系统所包含的文件、配置和目录，并不包括操作系统内核。

## import/export

### 镜像导入导出

```bash
# 导出
docker save centos > centos.tar
docker save centos | gzip > centos.tar.gz
```

镜像内:
![image](./Pictures/docker/save.avif)

- 其中`layer.tar` 为镜像根目录的打包,可以使用以下命令直接获取

```bash
mkdir centos
docker export $(docker create centos) | tar -C centos -xvf -
```

```
# 导入
docker load < centos.tar
docker load < centos.tar.gz
```

### 容器导入导出

**导出:**

```bash
docker run --name centos_export \
    --rm -it centos

# 导出
docker export centos_export > centos_export.tar

# 导出并压缩(推荐)
docker export centos_export | gzip > centos_export.tar.gz
```

**导入:**

```bash
cat centos_export.tar | sudo docker import - centos_import

# gz
zcat centos_export.tar.gz | sudo docker import - centos_import
```

### 容器数据卷之间的备份恢复

- 1.将 opensuse 容器备份到 centos 容器
  > opensuse -> centos
- 2.先用 `busybox` 备份到本地
- 3.再用 `busybox` 恢复到 centos

**备份:**

创建 opensuse 的容器,并包含/data 数据卷(假设重要数据保存在 data)

```bash
docker run -v /data \
    --name opensuse_data -itd opensuse
```

加入刚才的数据卷(opensuse_data),并使用 tar 命令打包压缩到当前目录下的 backup($(pwd)/backup)

```
docker run --volumes-from=opensuse_data \
    -v $(pwd)/backup:/backup \
    busybox tar -zcpvf /backup/backup.tar.gz /data
```

**恢复:**

- 注意本地`backup`目录下的权限,不然`tar`会显示找不到 `/backup/backup.tar.gz`

创建 centos 的容器

```bash
docker run -v /data \
    --name centos_data -itd centos
```

加入刚才的数据卷(centos_data),并使用 tar 命令当前目录下的 backup($(pwd)/backup)恢复到/data

```bash
# 使用 busybox 进行备份
docker run --volumes-from=centos_data \
    -v $(pwd)/backup:/backup \
    busybox tar xvzf /backup/backup.tar.gz -C /data
```

## containerd

已被分离出 docker,能独立运行 [ctr containerd 的命令行工具](https://github.com/projectatomic/containerd/blob/master/docs/cli.md)

> 容器中间层,runc 之上,cli 客户端之下

![image](./Pictures/docker/containerd.avif)

![image](./Pictures/docker/containerd1.avif)

- 管理容器的生命周期

  - start

  - stop

  - delete

- 管理容器的分发

  - pull

  - push

## runc管理容器

- dockercli 通过 runc 管理容器

  - runc 是 `libcontainer`的一层的壳

  - 真正管理容器的是 libcontainer

  - 也就是说 dockercli 是 runc 的抽象,runc 是 libcontainer 的抽象

- [深入理解 DOCKER 容器引擎 RUNC 执行框架](http://www.sel.zju.edu.cn/blog/2018/05/10/%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3docker%E5%AE%B9%E5%99%A8%E5%BC%95%E6%93%8Erunc%E6%89%A7%E8%A1%8C%E6%A1%86%E6%9E%B6/)
  创建 busybox 容器

```bash
mkdir rootfs

# 导出busybox的根目录
docker export $(docker create busybox) | tar -C rootfs -xvf -\n

# 创建config.json配置文件
sudo runc spec

# 运行busybox容器
sudo runc run rootfs

# 查看容器列表
sudo runc list
```

- `runc run`命令包含

  - `runc create`创建

  - `runc start`启动

  - `runc delete`退出后删除

![image](./Pictures/docker/runc.avif)

## network网络

- [（视频）技术蛋老师：【入门篇】Docker网络模式Linux - Bridge | Host | None](https://www.bilibili.com/video/BV1Aj411r71b)

- [洋芋编程：Docker 网络原理概述](https://mp.weixin.qq.com/s/U6cnU6ReOyUL62qY995Hkw)

### Docker的网络架构CNM

- [鹅厂架构师：【后台技术】Docker网络篇](https://zhuanlan.zhihu.com/p/683336819)
- [洋芋编程： Docker 网络原理概述](https://mp.weixin.qq.com/s/U6cnU6ReOyUL62qY995Hkw)

- Docker 原生网络是基于 Linux 的 网络命名空间（`net namespace`） 和 虚拟网络设备（`veth pair`）实现的。

- 网络模式（网络驱动）

    > Docker 的网络子系统支持插拔式的驱动程序，默认存在多个驱动程序，并提供核心网络功能。

    - 1.网桥（Bridge）：Docker默认的容器网络驱动，容器通过一对veth pair连接到docker0网桥上，由Docker为容器动态分配IP及配置路由、防火墙规则等

    - 2.Host：容器不会获得一个独立的网络命名空间（Network Namespace），而是和宿主机共用一个，共享同一套网络协议栈，容器不会虚拟出自己的网卡，配置自己的IP、路由表及iptables规则等等，而是直接使用宿宿主机的。

        - 但是容器的其他方面，如文件系统、进程列表等还是和宿宿主机隔离的，容器对外界是完全开放的，能够访问到宿主机，就能访问到容器。

        - 执行`docker run --net=host centos:7 python -m SimpleHTTPServer 8081`，然后查看看网络情况`netstat -tunpl` :

        ```sh
        [root@VM-16-16-centos ~]# netstat -tunpl
        Active Internet connections (only servers)
        Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
        tcp        0      0 0.0.0.0:8081            0.0.0.0:*               LISTEN      1409899/python
        ```

        - 可以看出host模型下，和主机上启动一个端口没有差别，也不会做端口映射，所以不同的服务在主机端口范围内不能冲突；

    - 3.Overlay：将多个容器连接，并使集群服务能够相互通信。主要通过使用Linux bridge和vxlan隧道实现，底层通过类似于etcd或consul的KV存储系统实现多机的信息同步

    - 4.Remote：Docker网络插件的实现，可以借助Libnetwork实现网络自己的网络插件；
    - 5.ipvlan	使用户可以完全控制 IPv4 和 IPv6 寻址
    - 6.macvlan	可以为容器分配 MAC 地址
    - 7.None：容器拥有自己的 Network Namespace，但是并不进行任何网络配置。Docker容器完全隔离，无法访问外部网络，容器中只有 lo 这个 loopback（回环网络）网卡用于进程通信。该容器没有网卡、IP、路由等信息，需要手动为容器添加网卡、配置 IP 等，也无法与其他容器和主机通信
        - 可以尝试执行`docker run --net=none centos:7 python -m SimpleHTTPServer 8081`，然后`curl xxx.com`应该是无法访问的。

    - 8.其他第三方网络插件

- Docker daemon 通过调用 `libnetwork` 提供的 API 完成网络的创建和管理等功能。`libnetwork` 中使用了 `CNM` 来完成网络功能

    ![image](./Pictures/docker/docker_网络架构1.avif)

    - 1.CNM规定了基本组成要素：主要有3种组件

        ![image](./Pictures/docker/cnm网络架构.avif)

        - 1.sandbox(沙盒)：一个沙盒包含了一个容器网络栈的信息。可以对以太网接口，端口，路由以及DNS配置

            - 一个 sandbox 可以有多个 endpoint 和 多个网络
            - sandbox实现：linux通过 namespace ；FreeBSD 通过Jail

        - 2.endpoint(端点)：虚拟网络接口，负责创建连接，将沙盒连接到网络

            - 一个端点可以加入一个沙盒和一个网络。一个端点只属于一个网络和一个沙盒
            - endpoint的实现：通过 veth pair、Open vSwitch 内部端口或者相似的设备

        - 3.网络：

            - 一个网络可以有多个端点
            - 实现：通过 bridge、vlan

    - 2.Libnetwork

        - Libnetwork是CNM的标准实现，支持跨平台，3个标准的组件和服务发现，基于Ingress的容器负载均衡，以及网络控制层和管理层的功能。

        ![image](./Pictures/docker/Libnetwork.avif)

#### 网络模式（网络驱动）

- Docker中最常用的两种网络是：网桥（Bridge）和Overlay
    - 1.网桥（Bridge）：是解决主机内多容器通讯
    - 2.Overlay：是解决跨主机多子网网络

- 当需要多个容器在同一台宿主机上进行通信时，使用 bridge
- 当网络栈不应该与宿主机隔离，但是希望容器的其他方面被隔离时，使用 host
- 当需要在不同宿主机上运行的容器进行通信时，使用 overlay
- 当从虚拟机迁移或需要使容器看起来像物理宿主机时，使用 Macvlan, 每个容器都有一个唯一的 MAC 地址
- 当需要将 Docker 与专门的网络栈集成，使用 Third-party

##### 网桥（Bridge）

- 网桥（Bridge）：默认的网络模式

- 网桥是什么？同tap/tun、veth-pair一样，网桥是一种虚拟网络设备，所以具备虚拟网络设备的所有特性，比如可以配置IP、MAC等，除此之外，网桥还是一个二层交换机，具有交换机所有的功能。
    - 使用该模式的所有容器都是连接到 docker0 这个网桥

- 1.创建

    - 当 Docker 进程启动时，会在宿主机上创建一个名称为 `docker0` 的 虚拟网桥，在该宿主机上启动的 Docker 容器会连接到这个虚拟网桥上。

        ```sh
        ifconfig
        docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
                inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
                ether 02:42:16:37:44:c4  txqueuelen 0  (Ethernet)
                RX packets 0  bytes 0 (0.0 B)
                RX errors 0  dropped 0  overruns 0  frame 0
                TX packets 0  bytes 0 (0.0 B)
                TX errors 0  dropped 5 overruns 0  carrier 0  collisions 0
        ```

    - 虚拟网桥的工作方式和物理交换机类似，宿主机上所有的容器通过虚拟网桥连接在一个二层网络中。
        - 从 `docker0` 子网中分配一个 IP 给容器使用，并设置 `docker0` 的 IP 地址为容器的默认网关。在宿主机上创建一对虚拟网卡 `veth pair` 设备， Docker 将 `veth pair` 设备的一端放在新创建的容器中，并命名为 `eth0`（容器的网卡）， 另一端放在宿主机中，以 vethxxx 类似的名字命名， 并将这个网络设备连接到 `docker0` 网桥中。

        - Docker 会自动配置 iptables 规则和配置 NAT，便于连通宿主机上的 `docker0` 网桥，完成这些操作之后，容器就可以使用它的 `eth0` 虚拟网卡，来连接其他容器和访问外部网络
            - 虚拟网桥 docker0 通过 iptables 配置与宿主机器上的网卡相连，符合条件的请求都会通过 iptables 转发到 docker0, 然后分发给对应的容器。

            ```sh
            # 查看 docker 的 iptables 配置
            iptables -t nat -L
            Chain POSTROUTING (policy ACCEPT)
            target     prot opt source               destination
            MASQUERADE  all  --  172.17.0.0/16        anywhere
            ```

        - Docker 中的网络接口默认都是虚拟的接口，Linux 在内核中通过 `数据复制` 实现接口之间的数据传输，可以充分发挥数据在不同 Docker 容器或容器与宿主机之间的转发效率， 发送接口发送缓存中的数据包，将直接复制到接收接口的缓存中，**无需通过物理网络设备进行交换**。

        ```sh
        # 查看主机上 veth 设备
        ifconfig | grep veth
        ```

    ![image](./Pictures/docker/网络-网桥Bridge.avif)

- 2.查看网桥

    ```sh
    docker network ls
    NETWORK ID     NAME              DRIVER    SCOPE
    839c78d16e66   bridge            bridge    local
    7865e8dc7489   host              host      local
    e904b639a46d   k3d-k3d-private   bridge    local
    e6e4904ea322   none              null      local
    ```

- 3.查看网桥的详细信息

    ```sh
    # 先执行
    docker run -d --name busybox-1 busybox echo "1"
    docker run -d --name busybox-2 busybox echo "2"

    # 再执行，可以看到输出网桥IPv4Address，MacAddress和EndpointID等：
    docker inspect bridge
    "Containers": {
        "bbd7d0775081dd9a9d026ca4c8e3ec2e1a4b19bead122eac94cd58f1fa118827": {
            "Name": "busybox-2",
            "EndpointID": "a82be8a01e25f5267fd6286c10eb1c72a1dd1c1933dcc84a82b286162767923c",
            "MacAddress": "02:42:ac:11:00:03",
            "IPv4Address": "172.17.0.3/16",
            "IPv6Address": ""
        },
        "fa14fa3e167d17922a94153c0e0eb83e244ef7b20f9fc04d05db2589828e747c": {
            "Name": "busybox-1",
            "EndpointID": "90f614cc4b2e4c5d2baa75facfa8e493d287cbb9ae39edaecb3ec67915d2df2b",
            "MacAddress": "02:42:ac:11:00:02",
            "IPv4Address": "172.17.0.2/16",
            "IPv6Address": ""
        }
    }

    # 查看其中一个容器其网络类型和配置。可以看到，虚拟网桥 的 IP 地址就是 bridge 网络类型的容器的网关地址。
    docker inspect 容器ID
    ```

- 4.检查网桥是否正常

    - 可以进入busybox-2容器，执行ping 172.17.0.2，输出（可见是可以通的）：

    ```sh
    PING 172.17.0.2 (172.17.0.2): 56 data bytes
    64 bytes from 172.17.0.2: seq=0 ttl=64 time=0.115 ms
    64 bytes from 172.17.0.2: seq=1 ttl=64 time=0.079 ms
    64 bytes from 172.17.0.2: seq=2 ttl=64 time=0.051 ms
    64 bytes from 172.17.0.2: seq=3 ttl=64 time=0.066 ms
    64 bytes from 172.17.0.2: seq=4 ttl=64 time=0.051 ms
    ^C
    --- 172.17.0.2 ping statistics ---
    5 packets transmitted, 5 packets received, 0% packet loss
    round-trip min/avg/max = 0.051/0.072/0.115 ms
    ```

- 5.端口映射

    - 可以看出这里是借助iptables实现的。

    ```sh
    # 先建立映射关系
    docker run -d -p 8000:8000 centos:7 python -m SimpleHTTPServer

    # 再查看 iptables
    iptables -t nat -nvL
    Chain DOCKER (2 references)
     pkts bytes target     prot opt in     out     source               destination
        0     0 RETURN     0    --  docker0 *       0.0.0.0/0            0.0.0.0/0
        0     0 DNAT       6    --  !docker0 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:8000 to:172.17.0.2:8000
    ```

- 6.网桥模式下的Docker网络流程

    - 容器与容器之前通讯是通过Network Namespace, bridge和veth pair这三个虚拟设备实现一个简单的二层网络，不同的namespace实现了不同容器的网络隔离让他们分别有自己的ip，通过veth pair连接到docker0网桥上实现了容器间和宿主机的互通；

    - 容器与外部或者主机通过端口映射通讯是借助iptables，通过路由转发到docker0，容器通过查询CAM表，或者UDP广播获得指定目标地址的MAC地址，最后将数据包通过指定目标地址的连接在docker0上的veth pair设备，发送到容器内部的eth0网卡上；

    - 容器与外部或者主机通过端口映射通讯对应的限制是相同的端口不能在主机下重复映射；

##### Overlay

- Overlay

    - 在云原生下集群通讯是必须的，当然Docker提供多种方式，包括借助Macvlan接入VLAN网络，另一种是Overlay。
    - 那什么是Overlay呢？指的就是在物理网络层上再搭建一层网络，通过某种技术再构建一张相同的逻辑网络。
    ![image](./Pictures/docker/网络-overlay.avif)

- 1.什么VXLAN网络？VXLAN全称是Visual eXtensible Local Area Network

    - 本质上是一种隧道封装技术，它使用封装/解封装技术，将L2的以太网帧（Ethernet frames）封装成L4的UDP数据报（datagrams），然后在L3的网络中传输，效果就像L2的以太网帧在一个广播域中传输一样，实际上是跨越了L3网络，但却感知不到L3网络的存在。 那么容器B发送请求给容器A（ping）的具体流程是怎样的？

    ![image](./Pictures/docker/网络-vxlan.avif)

    - 1.容器B执行ping，流量通过BridgeA的veth接口发送出去，但是这个时候BridgeB并不知道要发送到哪里（BridgeB没有MAC与容器A的IP映射表），所以BridgeB将通过VTEP解析ARP协议，确定MAC和IP以后，将真正的数据包转发给VTEP，带上VTEP的MAC地址
    - 2.VTEP-B收到数据包，通过Swarm的集群的网络信息中知道目标IP是容器B
    - 3.VTEP-B将数据包封装为VXLAN格式（数据包中存储了VXLAN的ID，记录其映射关系）
    - 4.实际底层VTEP-B将数据包通过主机B的UDP物理通道将VXLAN数据包封装为UDP发送出去
    - 5-6.通过隧道传输（UDP端口：4789），数据包到达VTEP-A，VTEP-A解析数据包读取其中的VXLAN的ID，确定发送到哪个网桥
    - 7.VTEP-A继续解包和封包，将数据从UDP中拆解出来，重新组装网络协议包，发送给BridgeA
    - 8.BridgeA收到数据，通过veth发给容器A，回包的过程就是反向处理

- 2.创建
    ```sh
    docker swarm init

    # 创建test-net
    docker network create --subnet=10.1.1.0/24 --subnet=11.1.1.0/24 -d overlay test-net

    # 查看
    docker network ls
    NETWORK ID     NAME              DRIVER    SCOPE
    dfd2f3cef3d9   bridge            bridge    local
    6da75632cc82   docker_gwbridge   bridge    local
    ba41f6cef47f   host              host      local
    ivia1zri4tdw   ingress           overlay   swarm
    78f8aa199af8   none              null      local
    smlwbn2yjjlm   test-net          overlay   swarm
    ```

- 3.查看网络详情

    ```sh
    # 创建一个sevice，replicas等于2来看看网络情况
    docker service create --name test --network test-net --replicas 2 centos:7 sleep infinity

    # 查看运行情况
    docker ps -a
    CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS                      PORTS                                       NAMES
    c8e4063ed9b2   centos:7        "sleep infinity"         3 minutes ago    Up 3 minutes                                                            test.1.o6c8up8jykjzv4qtav8kylb18
    15a9b4eedaea   centos:7        "sleep infinity"         3 minutes ago    Up 3 minutes                                                            test.2.iiozzdyksf2a2i82uos8j7a8n

    # 查看test-net详情
    docker network inspect test-net
    [
        {
            "Name": "test-net",
            "Id": "smlwbn2yjjlmb7s76k5cep94h",
            "Created": "2024-06-09T14:32:00.247463459+08:00",
            "Scope": "swarm",
            "Driver": "overlay",
            "EnableIPv6": false,
            "IPAM": {
                "Driver": "default",
                "Options": null,
                "Config": [
                    {
                        "Subnet": "11.1.1.0/24",
                        "Gateway": "11.1.1.1"
                    },
                    {
                        "Subnet": "10.1.1.0/24",
                        "Gateway": "10.1.1.1"
                    }
                ]
            },
            "Internal": false,
            "Attachable": false,
            "Ingress": false,
            "ConfigFrom": {
                "Network": ""
            },
            "ConfigOnly": false,
            "Containers": {
                "15a9b4eedaeaeea710658ec4ff5611978b0f419863f620f68044105956e05fd6": {
                    "Name": "test.2.iiozzdyksf2a2i82uos8j7a8n",
                    "EndpointID": "a804dec0ceeedfd5874b99033f44b1d77ebd1eff9d31c26e50f8375cea54adfb",
                    "MacAddress": "02:42:0b:01:01:03",
                    "IPv4Address": "11.1.1.3/24",
                    "IPv6Address": ""
                },
                "c8e4063ed9b2d331d6c86477ba920c8b1f8d84b55810191b3a0696a2d71a939d": {
                    "Name": "test.1.o6c8up8jykjzv4qtav8kylb18",
                    "EndpointID": "465f6d1aa9d5acee53ae97dab00a2f148221326e820b1bb2af987319852c46fc",
                    "MacAddress": "02:42:0b:01:01:04",
                    "IPv4Address": "11.1.1.4/24",
                    "IPv6Address": ""
                },
                "lb-test-net": {
                    "Name": "test-net-endpoint",
                    "EndpointID": "66ca707443c103c7bf03dada893f413fae53cceb61b00cc9948698cd4e75250c",
                    "MacAddress": "02:42:0b:01:01:05",
                    "IPv4Address": "11.1.1.5/24",
                    "IPv6Address": ""
                }
            },
            "Options": {
                "com.docker.network.driver.overlay.vxlanid_list": "4097,4098"
            },
            "Labels": {},
            "Peers": [
                {
                    "Name": "499dc7333f68",
                    "IP": "192.168.1.222"
                }
            ]
        }
    ]

    # 停止test服务，并删除
    docker service scale test=0
    docker service rm test
    ```

##### host

- Host：容器不会获得一个独立的网络命名空间（Network Namespace），而是和宿主机共用一个，共享同一套网络协议栈，容器不会虚拟出自己的网卡，配置自己的IP、路由表及iptables规则等等，而是直接使用宿宿主机的。

    - 但是容器的其他方面，如文件系统、进程列表等还是和宿宿主机隔离的，容器对外界是完全开放的，能够访问到宿主机，就能访问到容器。

- host 模式降低了容器与容器之间、容器与宿主机之间网络层面的隔离性，虽然有性能上的优势，但是引发了网络资源的竞争与冲突，因此适用于容器集群规模较小的场景。

```sh
# 启动一个网络类型为 host 的 Nginx 容器：
docker run -d --net host nginx

# 查看网络类型为 host 的容器列表：
docker network inspect host

# 查看 Nginx 容器网络类型和配置：
# Nginx 容器使用的网络类型是 host，没有独立的 IP。
docker inspect <容器-id>
```

- Nginx 容器内部并没有独立的 IP，而是使用了宿主机的 IP。
```sh
# 查看 Nginx 容器 IP 地址：

# 进入容器内部 shell
docker exec -it <容器-id> /bin/bash

# 安装 ip 命令
apt update && apt install -y iproute2

# 查看 IP 地址
ip a

# 退出容器，查看宿主机 IP 地址
exit
ip a

# 查看宿主机的端口监听状态：监听 80 端口的进程为 nginx, 而不是 docker-proxy。
sudo netstat -ntpl
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      8550/nginx: master
```

##### none

- None：容器拥有自己的 Network Namespace，但是并不进行任何网络配置。Docker容器完全隔离，无法访问外部网络，容器中只有 lo 这个 loopback（回环网络）网卡用于进程通信。该容器没有网卡、IP、路由等信息，需要手动为容器添加网卡、配置 IP 等，也无法与其他容器和主机通信

- none 模式为容器做了最少的网络设置，在没有网络配置的情况下，通过自定义配置容器的网络，提供了最高的灵活性。

```sh
# 启动一个网络类型为 host 的 Nginx 容器：
docker run -d --net none nginx

# 查看网络类型为 none 的容器列表：
docker network inspect none

# 查看 Nginx 容器网络类型和配置：
docker inspect <容器-id>
```

- 查看 Nginx 容器 IP 地址：

```sh
# 进入容器内部 shell
docker exec -it <容器-id> /bin/bash

# 访问公网链接
curl -I "https://www.docker.com"
curl: (6) Could not resolve host: www.docker.com

# 为什么会报错呢？ 这是因为当前容器没有网卡、IP、路由等信息，是完全独立的运行环境，所以没有办法访问公网链接。

# 查看 IP 地址。没有任何输出，该容器没有 IP 地址
hostname -I
```

- 查看宿主机的端口监听状态：

```sh
# 没有任何输出
docker port <容器-id>

# 没有任何输出，Nginx 进程运行在容器中，端口没有映射到宿主机
sudo netstat -ntpl | grep :80
```

##### container

- 与 host 模式类似，容器与指定的容器共享网络命名空间。这两个容器之间不存在网络隔离，但它们与宿主机以及其他的容器存在网络隔离。该模式下的容器可以通过 localhost 来访问同一网络命名空间下的其他容器，传输效率较高，且节约了一定的网络资源。在一些特殊的场景中非常有用，例如 k8s 的 Pod。

### 容器之间的网络连通性

- 实验：下图 3 个容器的连通性:

    - 左边和右边能和中间 ping 通

    - 左边与右边不通

    ![image](./Pictures/docker/cnm-model.avif)

- 创建网络网桥

    ```bash
    # 创建两个网络网桥
    docker network create backend
    docker network create frontend

    # 也可以指定网段
    docker network create --subnet=172.18.0.0/16 backend

    # 查看网络
    docker network ls
    ```

    通过 `ip a` 命令,查看刚才创建的网络的 ip 地址
    ![image](./Pictures/docker/cnm.avif)

- 启动3个容器，并配置图片上的网络

    ```bash
    docker run --net backend \
     -h backend1 --name backend1 --rm -it centos

    docker run --net frontend \
     -h frontend1 --name frontend1 --rm -it centos

    docker run --net backend \
     -h middle --name middle --rm -it centos

    # 将容器 middle 加入到 frontend
    docker network connect frontend middle

    # 也可以指定ip
    docker run --net backend --ip "172.18.0.10" \
     -h backend1 --name backend1 --rm -it centos
    ```

- 此时再次通过 `ip a` 命令查看。发现一共多出 4 个 `veth` 的网络接口

    - veth 是 namespace 之间的互联的虚拟网络设备,会**成对的出现**,宿主机一个,namespace 一个

    - btrctl 相当与交换机,而 veth 设备 相当于交换机的端口

    - veth 设备工作在第二层,因此没有 ip 地址

    - 当一方 down 后,链接关闭

    - 下图为 `ip link | grep veth` 命令的结果,比 `ip a` 更直观
    ![image](./Pictures/docker/cnm1.avif)

### 容器之间的网络隔离

- 要设置两个容器之间可以通信,但与其它容器隔离

**步骤:**

- 1.分别为两容器设置命名空间

- 2.用 `veth` 使两命名空间想连接

```bash
# 创建 enp1 网络命名空间
ip netns add enp1

# 查看
ip netns list

# 尝试使用enp1启动bash
ip netns exec enp1 bash

# 查看 ip
ip a

# 退出
exit

# 启动两个容器,网络设置none
docker run --net=none \
    -it --name net1 centos bash

docker run --net=none \
    -it --name net2 centos bash

# 设置变量,分别为两容器的pid
pid1=$(docker inspect -f '{{.State.Pid}}' net1)
pid2=$(docker inspect -f '{{.State.Pid}}' net2)

# 创建软连接到netns(命名空间)
ln -s /proc/$pid1/ns/net /var/run/netns/$pid1
ln -s /proc/$pid2/ns/net /var/run/netns/$pid2

# 创建veth
ip link add veth1 type veth peer name veth2

# 将veth1放入容器1,veth2放入容器2
ip link set veth1 netns $pid1
ip link set veth2 netns $pid2

# 设置ip(此时在容器内,可用ip a查看)
ip netns exec $pid1 ip addr add 10.1.1.1/32 dev veth1
ip netns exec $pid2 ip addr add 10.1.1.2/32 dev veth2

# 启动
ip netns exec $pid1 ip link set veth1 up
ip netns exec $pid2 ip link set veth2 up

# 设置路由
ip netns exec $pid1 ip route add 10.1.1.2/32 dev veth1
ip netns exec $pid2 ip route add 10.1.1.1/32 dev veth2
```

### 容器与宿主机同一网段

- 宿主机 ip 为: `192.168.1.221/24`

- 网关 ip 为: `192.168.1.1/24`

- 设置容器 ip 为: `192.168.1.233/24`

#### 方法 1: 使用第三方工具 [pipework](https://github.com/jpetazzo/pipework)

- 注意:此方法重启后失效

```bash
# 启动none网络容器
docker run --net=none \
    --name ip_test \
    --rm -it centos

# 下载pipework
git clone https://github.com/jpetazzo/pipework.git
cd pipework

# 创建网桥使用veth进行通信
./pipework br0 ip_test 192.168.1.233/24@192.168.1.1/24
```

在 eth0 上,创建虚拟网卡,不使用 veth 通信:

```bash
# 自定义ip
./pipework eth0 ip_test 192.168.1.233/24@192.168.1.1/24

# 使用dhcp(主机需要安装dhcp客户端)
./pipework eth0 ip_test dhcp
```

#### 方法 2: 手动设置

- 注意:此方法重启后失效

**网络拓扑:**

- 将主机和容器的网卡,连接到虚拟网桥 br0(类似于交换机)

  - eth0 为主机 -> 外网的接口

  - veth1 为主机 -> 容器的接口

  - veth2 为容器 -> 主机的接口

> **步骤:**

- 1.容器设置

```bash
# 启动none网络容器
docker run --net=none \
    --name ip_test \
    --rm -it centos

# 将容器添加到namespace
pid=$(docker inspect --format '{{ .State.Pid }}' ip_test)
ln -s /proc/$pid/ns/net /var/run/netns/$pid
```

- 2.创建虚拟网桥 br0

  - 将主机的 eth0 桥接到 br0

```bash
# 创建虚拟网桥br0
brctl addbr br0
ip link set br0 up

# 将eth0的设备,ip桥接到br0(此时网络会断开)
ip addr add 192.168.1.221/24 dev br0
ip addr del 192.168.1.221/24 dev eth0

brctl addif br0 eth0
ip route del default
ip route add default via 192.168.1.1 dev br0
```

- 3.创建 一对 veth

  - 将 veth1 添加到网桥 br0

  - 将容器加入到 veth2 中,并自定义 ip,route

```bash
# 创建veth
ip link add veth1 type veth peer name veth2

# 将veth1 添加到br0
brctl addif br0 veth1
ip link set veth1 up

# 将veth2放到容器的namespace,并重命名为eth0
ip link set veth2 netns $pid
ip netns exec $pid ip link set dev veth2 name eth0
ip netns exec $pid ip link set eth0 up

# 设置ip,route
ip netns exec $pid ip addr add 192.168.1.233/24 dev eth0
ip netns exec $pid ip route add default via 192.168.1.1
```

## docker中的init进程

- [运维开发故事：容器中的一号进程](https://mp.weixin.qq.com/s/FwgbPIz6N_NnSkKqu2CNRg)

- 在 Linux 上有了容器的概念之后，一旦容器建立了自己的 Pid Namespace（进程命名空间），这个 Namespace 里的进程号也是从 1 开始标记的。所以，容器的 init 进程也被称为 1 号进程。你只需要记住：1 号进程是第一个用户态的进程，由它直接或者间接创建了 Namespace 中的其他进程。

    - 每个Docker容器都是一个PID命名空间，这意味着容器中的进程与主机上的其他进程是隔离的。PID命名空间是一棵树，从PID 1开始，通常称为init。

    - 注意：当你运行一个Docker容器时，镜像的ENTRYPOINT就是你的根进程，即PID 1（如果你没有ENTRYPOINT，那么CMD就会作为根进程，你可能配置了一个shell脚本，或其他的可执行程序，容器的根进程具体是什么，完全取决于你的配置）。

### 把Bash当作PID 1呢？

- 每个基础镜像都有这个是Bash 。Bash 正确地收割了采用的子进程。Bash 可以运行任何东西。所以在你的Dockerfile中，你肯定会用这个：

    ```dockerfile
    CMD ["/bin/bash", "-c", "/path-to-your-app"]
    ```

- Bash默认不会处理SIGTERM信号，因此这将会导致如下的问题：

    - 1.如果将Bash作为PID 1运行，那么发送到Docker容器docker stop的信号，最终都是将 SIGTERM信号发送到Bash，但是Bash默认不会处理SIGTERM信号，也不会将它们转发到任何地方（除非您自己编写代码实现）。

        - docker stop命令执行后，容器会有一个关闭的时限，默认为10秒，超过十秒则用kill强制关闭。换句话说，给 Bash发送SIGTERM信号终止时，会等待十秒钟，然后被内核强制终止包含所有进程的整个容器。

            - 这些进程通过 SIGKILL 信号不正常地终止。SIGKILL是特权信号，无法被捕获，因此进程无法干净地终止。假设服务正在运行的应用程序正忙于写入文件；如果应用程序在写入过程中不干净地终止，文件可能会损坏。不干净的终止是不好的。这几乎就像从服务器上拔下电源插头一样。

    - 2.一旦进程退出，Bash也会继续退出。如果程序出了bug退出了，Bash会退出，退出代码为0，而进程实际上崩溃了（但0表示“一切正常”；这将导致Docker或者k8s上重启策略不符合预期）。因为真正想要的可能是Bash返回与的进程相同的退出代码。

- 请注意，我们对bash进行修改，编写一个 EXIT 处理程序，它只是向子进程发送信号：

    ```sh
    #!/bin/bash
    function cleanup()
    {
        local pids=`jobs -p`
        if [[ "$pids" != "" ]]; then
            kill $pids >/dev/null 2>/dev/null
        fi
    }

    trap cleanup EXIT
    /path-to-your-app
    ```

    - 不幸的是，这并不能解决问题。向子进程发送信号是不够的：init 进程还必须等待子进程终止，然后才能终止自己。如果 init 进程过早终止，那么所有子进程都会被内核不干净地终止。

- 很明显，需要一个更复杂的解决方案，但是像 Upstart、Systemd 和 SysV init 这样的完整 init 系统对于轻量级 Docker 容器来说太过分了。幸运的是，我们有很多在容器中使用的init程序。我们这里推荐使用简单的tini。

### tini当作PID 1

- 我们在容器中启动一个init 系统有很多种，这里推荐使用 tini，它是专用于容器的轻量级 init 系统，使用方法也很简单：

    ```dockerfile
    FROM openjdk8:8u201-jdk-alpine3.9
    RUN apk add --no-cache tini wget \
        && mkdir -p /opt/arthas \
        && cd /opt/arthas \
        && wget https://arthas.aliyun.com/arthas-boot.jar
    ENTRYPOINT ["/sbin/tini", "--"]
    ```

- 请注意，Tini中还有一些额外的功能，在Bash或Java中很难实现（例如，Tini可以注册为“子收割者”，因此它实际上不需要作为PID 1运行来完成“僵尸进程”收割工作），但是这些功能对于一些高级应用场景来说非常有用。

### 为什么docker中会有僵尸进程？

- 使用容器的理想境界是一个容器只启动一个进程，但这在现实应用中有时是做不到的。

    - 比如说，在一个容器中除了主进程之外，我们可能还会启动辅助进程，做监控或者 rotate logs；再比如说，我们需要把原来运行在虚拟机（VM）的程序移到容器里，这些原来跑在虚拟机上的程序本身就是多进程的。

- 一旦我们启动了多个进程，那么容器里就会出现一个 pid 1，也就是我们常说的 1 号进程或者 init 进程，然后由这个进程创建出其他的子进程。比如我们在部署java服务的时候，我们需要部署一个Arthas（阿尔萨斯），来做为java程序的诊断工具。

## Dockerfile 创建容器镜像

![image](./Pictures/docker/Docker镜像的构建流程.avif)

- [告别手写烦恼！一键生成Dockerfile，轻松搞定容器化部署！](https://mp.weixin.qq.com/s/ZkfR7zfHIiygyjXYbPOl_A)

    - 需要安装docker desktop。不然会显示`docker: 'init' is not a docker command.`
    - 快速生成 .dockerignore Dockerfile compose.yaml README.Docker.md
    ```sh
    docker init
    ```

- 通过 commit,修改过的容器,创建新的镜像(**不推荐**)

    ```sh
    docker commit CONTAINER_ID tz/opensuse
    ```

### Dockerfile命令

- [云原生云维圈：万字长文带你看全网最详细Dockerfile教程](https://mp.weixin.qq.com/s?__biz=MzUxNTg5NTQ0NA==&mid=2247484540&idx=1&sn=06106c2301c0954827bc787b82f43068&chksm=f9aefd87ced974919413fe6b2a6dd894826a808b6b01437f57e3310ee1f79d03ba145d1178bb&cur_album_id=2200317766446923776&scene=190&poc_token=HJThB2aj_sy_LFapN6zLthL1fTyOtkO6ycKZGa-K)

| Dockerfile 指令 | 说明                                                                 |
|-----------------|----------------------------------------------------------------------|
| FROM            | 指定基础镜像，用于后续的指令构建。                                   |
| MAINTAINER      | 指定Dockerfile的作者/维护者。                                        |
| LABEL           | 添加镜像的元数据，使用键值对的形式。                                 |
| RUN             | 在构建过程中在镜像中执行命令。                                       |
| CMD             | 指定容器创建时的默认命令。（可以被覆盖）                             |
| ENTRYPOINT      | 设置容器创建时的主要命令。（不可被覆盖）                             |
| EXPOSE          | 声明容器运行时监听的特定网络端口。                                   |
| ENV             | 在容器内部设置环境变量。                                             |
| ADD             | 将文件、目录或远程URL复制到镜像中。                                  |
| COPY            | 将文件或目录复制到镜像中。                                           |
| VOLUME          | 为容器创建挂载点或声明卷。                                           |
| WORKDIR         | 设置后续指令的工作目录。                                             |
| USER            | 指定后续指令的用户上下文。                                           |
| ARG             | 定义在构建过程中传递给构建器的变量，可使用 "docker build" 命令设置。 |
| ONBUILD         | 当该镜像被用作另一个构建过程的基础时，添加触发器。                   |
| STOPSIGNAL      | 设置发送给容器以退出的系统调用信号。                                 |
| HEALTHCHECK     | 定义周期性检查容器健康状态的命令。                                   |
| SHELL           | 覆盖Docker中默认的shell，用于RUN、CMD和ENTRYPOINT指令。              |

| 命令       | 操作     | 能否被覆盖       |
| ---------- | -------- | ---------------- |
| ENV        | 环境变量 | run --env        |
| ENTRYPOINT | 入口命令 | run --entrypoint |
| WORKDIR    | 工作目录 | run -w           |
| USER       | 用户     | run -u           |

- ADD, COPY 的区别

  - ADD, COPY 路径是以 Dockerfile 下的目录开始

  - ADD 命令可以通过 url 进行远程复制

  - ADD 命令复制 tar 文件时,会自动解压

  - 尽可能用 COPY

- CMD, ENTRYPOINT 的区别

  - ENTRYPOINT 只有在最后一条命令有效

  - CMD 可以为 ENTRYPOINT 提供参数
    ```
    ENTRYPOINT [“echo”, “Hello”]
    CMD [“World”]
    ```

- 在容器里的 linux 使用变量

    ```dockerfile
    FROM alpine

    RUN  a="$(date)"
    RUN  echo "$a"
    ```

- 构建镜像：docker build命令
    ```sh
    # 根据Dockerfile的内容，逐条执行其中的指令，并创建一个新的镜像。
    docker build -t my_image .

    # --build-arg 指定构建参数的值
    docker build --build-arg APP_VERSION=2.0 -t my_app .
    ```

### Dockerfile优化

- 最小化镜像大小：可以减少网络传输和存储开销，加快镜像的下载和部署速度。
    - 1.使用轻量的基础镜像：选择合适的基础镜像，可以避免不必要的依赖和组件，例如Alpine Linux镜像比Ubuntu镜像更轻量。
    - 2.单独安装软件包：将软件包的安装命令合并到一条RUN指令中，并在安装完成后清理缓存和临时文件，以减少镜像大小。
    - 3.删除不必要的文件：在复制文件或目录到镜像时，只复制必要的文件，并在复制后删除不需要的文件和目录。
    - 4.使用特定的构建工具：对于特定的编程语言和应用程序，使用专门优化过的构建工具可以减少构建中的不必要依赖。

- 多阶段构建：在一个Dockerfile中使用多个FROM指令，每个FROM指令都代表一个构建阶段。

    - 每个构建阶段都可以从之前的阶段复制所需的文件，并执行特定的构建操作。使用多阶段构建可以使得最终生成的镜像只包含运行应用程序所必需的文件和依赖，而不包含构建过程中产生的不必要文件和依赖。

    - 在下面的例子中，我们使用两个构建阶段。
        - 第一个构建阶段使用Golang基础镜像来编译应用程序
        - 第二个构建阶段使用Alpine Linux基础镜像，仅复制编译后的应用程序，并设置容器启动时的命令。

    ```dockerfile
    # 构建阶段1
    FROM golang:1.17 AS builder

    WORKDIR /app
    COPY . .

    # 编译应用程序
    RUN go build -o myapp

    # 构建阶段2
    FROM alpine:latest

    # 复制编译后的应用程序
    COPY --from=builder /app/myapp /usr/local/bin/

    # 设置工作目录
    WORKDIR /usr/local/bin

    # 容器启动时运行的命令
    CMD ["myapp"]
    ```

- 有效使用缓存

    - Docker在构建镜像时会缓存每个指令的结果，以便在下次构建相同的指令时直接使用缓存，加快构建速度。
    - 常变化的指令在后面，不变的指令在前面，这样可以最大程度地利用Docker的缓存机制。
        - 例如，将不经常修改的基础依赖安装放在前面的指令，并将频繁修改的应用程序代码放在后面的指令。

- 每个RUN指令会产生一个新的镜像层，而每个镜像层都会占用额外的存储空间。为了优化多层镜像构建，可以使用&&操作符将多个命令合并成一个RUN指令，避免产生额外的镜像层。

    ```dockerfile
    RUN apt-get update && apt-get install -y \
        package1 \
        package2 \
        package3
    ```

#### 未读

- [运维开发故事：关于Dockerfile的最佳实践技巧](https://mp.weixin.qq.com/s/_VMcrepMdgzPU9V6W8ZhgA)

### 构建属于自己的 centos 容器

- 构建属于自己的 centos 容器:

  - 更换 ali 源

  - 安装基本软件

步骤:

- 1.将以下内容保存为`dockerfile`

```docker
FROM centos
# opensuse
# FROM opensuse

ARG pkg=yum
ENV install="$pkg install -y"

# 安装epel源,并修改为ali源
COPY source.sh /root

RUN chmod 755 /root/source.sh && \
    /root/source.sh $pkg

# 安装基本软件
RUN $install fish neovim
```

- 2.下载[更换源脚本](https://github.com/ztoiax/userfulscripts/blob/master/source.sh) 到 dockerfile 文件的目录

```bash
curl -LO https://github.com/ztoiax/userfulscripts/blob/master/source.sh
```

- 3.构建

```bash
docker build -t tz/centos .

# 查看镜像构建信息
docker history tz/centos
```

### [hadolint：自动检查您的Dockerfile是否存在任何问题](https://github.com/hadolint/hadolint)

```sh
hadolint Dockerfile
Dockerfile:1 DL3006 warning: Always tag the version of an image explicitly
Dockerfile:7 DL3020 error: Use COPY instead of ADD for files and folders
```

## registry仓库

- 类似于 github 代码仓库，只不过registry是docker镜像仓库
- 有官方的registry仓库dockerhub，我们也可以搭建私人的仓库

创建本地 `registry`

```bash
# 下载镜像
docker pull registry

# 启动
docker run -p 5000:5000 registry

# 打上tag标签
docker tag IMAGE_ID localhost:5000/tz/opensuse

# 查看
docker image ls

# 推送到本地registry
docker push localhost:5000/tz/opensuse

# 运行
docker run -it localhost:5000/tz/opensuse /bin/bash
```

容器启动后立即退出解决方法:

```bash
docker container create -it --name opensuse_1 opensuse
docker container start opensuse_1
docker container exec -it opensuse_1 bash
```

## Docker Compose定义和运行多容器

- [docker官方的各种compose文件例子](https://github.com/docker/awesome-compose)

- [喵叔写技术：《Docker极简教程》--Docker的高级特性--Docker Compose的使用](https://mp.weixin.qq.com/s/mw_GiIJDehUvGwvztEMu8Q)

- 通过YAML文件来定义应用程序的服务、网络和卷等资源，并使用单个命令来启动、停止和管理整个应用程序的容器。

    - 1.定义多容器应用程序：通过一个单独的文件来定义整个应用程序的服务组件，包括Web服务器、数据库、消息队列等。

        - 这些服务可以相互通信，共同组成一个完整的应用程序。

    - 2.简化开发环境配置：在本地创建与生产环境相似的开发环境。通过在Compose文件中定义应用程序的组件和配置，开发人员可以轻松地在不同的环境之间进行切换，从而加快开发和测试周期。

    - 3.一键启动和停止：通过简单的命令，如docker-compose up和docker-compose down，你可以轻松地启动和停止整个应用程序。这使得在开发、测试和部署过程中快速迭代成为可能。

    - 4.依赖管理：Docker Compose允许你定义服务之间的依赖关系，以确保它们在启动时以正确的顺序启动。

    - 5.可扩展性和灵活性：可以定义网络配置、卷挂载、环境变量等，以满足不同场景下的需求。

- Docker Compose基础概念

    - 服务（Services）：是指一个定义了容器运行方式的配置。一个服务可以包括一个或多个容器，通常用于运行一个特定的应用程序或服务组件。

    - 容器（Containers）：是指通过Docker镜像启动的运行实例。每个容器都是一个独立的、轻量级的虚拟环境，其中包含了一个完整的应用程序以及其运行所需的所有依赖项。

    - 网络（Networks）：是指用于连接多个容器的虚拟网络。通过网络，容器可以相互通信，实现数据交换和服务之间的连接。

    - 卷（Volumes）：是一种用于持久化存储数据的机制，它允许容器之间或容器与主机之间共享数据，并且数据会在容器被删除时保持不变。

### docker-compose.yml示例

- 以下内容保存为`docker-compose.yml`

    - 这将会启动nginx服务和MySQL服务，并将它们连接到默认的网络中，使得它们可以相互通信。

    ```yml
    version: '3.8'

    services:
      web:
        image: nginx:latest
        ports:
          - "8080:80"

      db:
        image: mysql:latest
        environment:
          MYSQL_ROOT_PASSWORD: password
    ```

    - `version: '3.8'` 指定了Compose文件的版本。
    - `services` 是一个包含了两个服务的字典。
    - `web` 是一个服务定义，它使用nginx:latest镜像，并将容器内部的80端口映射到主机的8080端口。
    - `db` 是另一个服务定义，它使用mysql:latest镜像，并通过环境变量设置了MySQL的root密码为password。

- 下面是一个示例的Docker Compose文件，用于配置一个包含多个容器的应用程序，其中包括Web服务、数据库服务和消息队列服务

    - 这将会启动nginx、MySQL和Redis服务，并将它们连接到默认的网络中，从而使得它们可以相互通信。

    ```yml
    version: '3.8'

    services:
      web:
        image: nginx:latest
        ports:
          - "8080:80"
        depends_on:
          - db

      db:
        image: mysql:latest
        environment:
          MYSQL_ROOT_PASSWORD: password
        volumes:
          - db_data:/var/lib/mysql

      redis:
        image: redis:latest

    volumes:
      db_data:
    ```

    - `version: '3.8'` 指定了Compose文件的版本。
    - `services` 是一个包含了三个服务的字典，分别是web、db和redis。
    - `web` 是一个服务定义，它使用nginx:latest镜像，并将容器内部的80端口映射到主机的8080端口。它还通过depends_on字段指定了依赖于db服务，表示web服务依赖于db服务的启动。
    - `db` 是一个服务定义，它使用mysql:latest镜像，并通过环境变量设置了MySQL的root密码为password。此外，通过volumes字段将数据库的数据持久化到名为db_data的卷中。
    - `redis` 是另一个服务定义，它使用redis:latest镜像。
    - `volumes` 定义db_data的卷，用于持久化存储MySQL数据库的数据。

- 结合dockerfile使用

    - Dockerfile文件

        ```dockerfile
        FROM nginx:latest
        COPY ./html /usr/share/nginx/html
        ```

    - docker-compose.yml 文件
        - 这个Compose文件定义了一个名为 web 的服务，它使用当前目录下的Dockerfile构建Nginx镜像，并将容器内的80端口映射到主机的8080端口。

        ```yml
        version: '3.8'

        services:
          web:
            build: .
            ports:
              - "8080:80"
        ```

    - 构建和启动应用程序：

        ```sh
        # 这将会构建Nginx镜像并启动容器，你的Web应用程序将在 http://localhost:8080 上可用。
        docker-compose up -d
        ```

### Docker Compose的常用命令

- `docker-compose up`启动相关命令

    ```sh
    # 在当前目录下寻找 docker-compose.yml 文件，并根据其中定义的服务启动应用程序。
    docker-compose up

    # 使用 -f 选项可以指定要使用的 Compose 文件，默认情况下是 docker-compose.yml
    docker-compose -f docker-compose.prod.yml up

    # 后台启动
    docker-compose up -d

    # 指定要启动的服务名称，而不是启动所有服务。可以同时指定多个服务，用空格分隔。
    docker-compose up service_name

    # 重新构建镜像。在启动容器之前重新构建服务的镜像。
    docker-compose up --build

    # 重新创建容器。强制重新创建所有容器，即使它们已经存在。
    docker-compose up --force-recreate

    # 强制重新创建容器并构建镜像
    docker-compose up --force-recreate --build
    ```

- `docker-compose down`停止移除相关命令

    ```sh
    # 这会停止并移除通过 docker-compose up 启动的所有容器，并移除相关的网络和卷。
    docker-compose down

    # 使用 -f 选项可以指定要使用的 Compose 文件，默认情况下是 docker-compose.yml
    docker-compose -f docker-compose.prod.yml down

    # 使用 --volumes 选项可以同时移除相关的卷。这会删除所有定义在 docker-compose.yml 中的 volumes 字段中的卷。
    docker-compose down --volumes

    # 使用 --stop 选项可以停止容器，但不移除它们。这意味着容器会停止运行，但仍然保留在系统中，可以使用 docker-compose up 再次启动。
    docker-compose down --stop

    # 指定要停止和移除的特定服务，而不是停止和移除所有服务。可以同时指定多个服务，用空格分隔。
    docker-compose down service_name

    # 移除网络。移除未在 docker-compose.yml 文件中定义的服务的网络。这些服务称为 "孤儿" 服务。
    docker-compose down --remove-orphans

    # 结合使用 --volumes 和 --remove-orphans 选项可以停止并移除所有容器，相关的网络和卷，以及未定义的孤儿服务的网络。
    docker-compose down --volumes --remove-orphans
    ```

- `docker-compose ps` 容器状态相关命令

    ```sh
    # 显示所有容器的状态信息，包括容器名称、运行状态、关联端口等
    docker-compose ps

    # 使用 -f 选项可以指定要使用的 Compose 文件，默认情况下是 docker-compose.yml
    docker-compose -f docker-compose.prod.yml ps

    # 只显示服务的名称
    docker-compose ps --services

    # 显示详细信息：包括容器ID、端口映射、命令等。
    docker-compose ps --verbose

    # 只显示停止的容器。--filter 选项可以根据容器的状态进行过滤。在这个示例中，status=exited 表示只显示已停止的容器。
    docker-compose ps --filter "status=exited"

    # 显示指定服务的容器
    docker-compose ps service_name
    ```

- 其他常用命令

    ```sh
    # 启动已定义的服务，但不会重新构建容器或镜像。
    docker-compose start

    # 停止已启动的服务，但容器和网络保留。
    docker-compose stop

    # 重启已启动的服务，会重新构建容器。
    docker-compose restart

    # 暂停已启动的服务，暂停后容器继续存在，但不再接收流量。
    docker-compose pause

    # 恢复被暂停的服务，使其重新接收流量。
    docker-compose unpause

    # 根据 docker-compose.yml 中的配置重新构建服务的容器镜像。
    docker-compose build

    # 查看服务日志
    docker-compose logs

    # 进入服务容器。在特定的服务容器中执行命令，service_name 为服务名称，command 为要执行的命令。
    docker-compose exec service_name command

    # 列出所有在 docker-compose.yml 文件中定义的服务名称。
    docker-compose config --services

    # 查看Compose文件配置。检查并验证 docker-compose.yml 文件的配置。
    docker-compose config
    ```

## Docker Swarm集群

- Docker Swarm是Docker官方提供的容器编排工具，旨在简化容器化应用程序的部署、管理和扩展。

    - 它允许将多个Docker主机组成一个集群，统一管理这些主机上运行的容器。

- Swarm集群：采用主-从架构，其中包括管理节点（manager nodes）和工作节点（worker nodes）。

    - 管理节点：

        - 管理节点是Swarm集群的核心，负责集群的管理、调度和控制。
        - 管理节点维护着整个集群的状态，并负责决定在哪些工作节点上运行容器以及如何分配资源。
        - 管理节点还负责处理用户的命令和请求，执行集群管理操作，如创建、更新、扩展和删除服务。

        - 通常一个Swarm集群会有多个管理节点，以确保高可用性和容错性。

        - 管理节点使用Raft协议来保持集群的一致性，确保对集群状态的更改在所有节点之间得到正确地复制和传播。

    - 工作节点：
        - 工作节点是实际运行容器的节点，它们接收来自管理节点的指令，并负责执行这些指令以运行容器。
        - 工作节点负责监视和维护在其上运行的容器，并根据需要调整资源的分配。

    - 通过Swarm集群，用户可以轻松地将容器化应用程序部署到多个节点上，并利用集群的自动负载平衡、故障恢复和扩展性能，实现高度可靠和可扩展的应用程序部署和管理。

### Swarm服务

- 1.创建服务：在Docker Swarm中，服务是定义和管理容器化应用程序的方式，是部署和运行容器的第一步。

    - 这个服务将根据定义的配置，在集群中的工作节点上运行一个或多个容器实例，以提供所需的应用程序功能。步骤如下

        - 确认服务已经成功创建并且在集群中运行。
        - 可以通过访问服务的暴露端口或者查看服务日志来验证服务是否正常运行。
        - 可以使用`docker service ls`命令来查看所有服务的状态和信息，包括运行中的服务数量、所在节点等信息。
        - 使用`docker service ps <service-name>`命令可以查看特定服务的详细信息，包括每个服务实例的状态、节点等信息。
        - Swarm管理节点接收到创建服务的请求后，会在集群中选择适当的工作节点来运行服务的实例。
        - 然后，Swarm会启动并运行服务的容器实例，根据配置在工作节点上创建容器。
        - 使用`docker service create`命令创建服务，指定服务的名称以及服务的配置参数。
        - 示例命令：`docker service create --name my_service my_image:tag`
        - 定义服务的配置，包括容器镜像、端口映射、环境变量、挂载的数据卷等。
        - 可以使用Docker Compose文件或直接使用命令行来定义服务的配置。
        - 定义服务配置：
        - 执行创建服务命令：
        - 等待服务部署：
        - 监视服务状态：
        - 验证服务运行：

- 2.扩展服务：在Docker Swarm中，扩展服务是指增加服务的副本数量，以提高应用程序的可用性和性能。以下是扩展服务的步骤：

     - 查看当前服务副本数量： 使用以下命令查看当前服务的副本数量：

        ```sh
        docker service ls
        ```

    - 扩展服务： 使用以下命令扩展服务的副本数量：

        ```sh
        docker service scale <service-name>=<number-of-replicas>

        # 例如，要将名为my_service的服务扩展到5个副本，可以运行：
        docker service scale my_service=5
        ```

    - 等待副本部署： Swarm管理节点接收到扩展服务的请求后，会根据当前集群的资源情况，在适当的工作节点上创建新的容器副本。

    - 监视服务状态： 使用`docker service ls`命令来查看服务的状态，确保新的副本已经部署并处于运行状态。

    - 验证服务扩展： 确认服务已经成功扩展并且新的副本已经运行。可以通过访问服务的暴露端口或者查看服务日志来验证新的副本是否正常运行。

- 3.更新服务更新服务是在Docker Swarm中管理容器化应用程序的重要操作，可以用于更新服务的镜像版本、配置等。以下是更新服务的步骤：

    - 查看当前服务信息： 使用以下命令查看当前服务的信息，包括服务名称、镜像版本、副本数量等：

        ```sh
        docker service ls
        ```

    - 更新服务： 使用docker service update命令更新服务的配置，例如更新镜像版本或其他配置参数：
        ```sh
        docker service update --image <new-image>:<tag> <service-name>

        # 例如，要将名为my_service的服务更新到新的镜像版本，可以运行：
        docker service update --image my_image:new_tag my_service
        ```

    - 等待服务更新： Swarm管理节点接收到更新服务的请求后，会在集群中逐步更新服务的实例，将它们替换为新的容器实例。

    - 监视服务更新进度： 使用docker service ps <service-name>命令查看服务的详细信息，以监视更新进度。
        ```sh
        docker service ps <service-name>
        ```

    - 验证服务更新： 确认服务已经成功更新并且新的容器实例已经在运行。可以通过访问服务的暴露端口或者查看服务日志来验证更新后的服务是否正常运行。

- 4.删除服务要在Docker Swarm中删除服务，你可以按照以下步骤操作：

    - 查看当前服务列表： 运行以下命令以查看当前在Swarm集群中运行的服务列表：
        ```sh
        docker service ls
        ```

    - 删除服务： 使用docker service rm命令删除指定的服务。例如，要删除名为my_service的服务，可以运行：
        ```sh
        # 这将从Swarm集群中移除该服务，并停止与之关联的所有容器。
        docker service rm my_service
        ```

    - 等待服务删除： Swarm管理节点接收到删除服务的请求后，会停止该服务的所有容器实例，并从集群中删除该服务。

    - 验证服务已删除： 使用`docker service ls`命令再次检查服务列表，确保已删除的服务不再显示在列表中。

    - 清理服务相关资源（可选）： 如果需要，你可以手动清理与删除的服务相关的其他资源，如网络或数据卷。可以使用`docker network rm`和`docker volume rm`命令来清理不再使用的网络和数据卷。

### Swarm节点管理

- 1.添加节点到Swarm集群

    - 1.准备新节点： 在要添加到Swarm集群的新节点上，确保已经安装了Docker引擎，并且网络连接正常。你还需要确保新节点可以与现有Swarm集群的管理节点通信。

    - 2.加入Swarm集群： 在新节点上运行以下命令，使用docker swarm join命令将新节点加入到Swarm集群：
        ```sh
        # 其中，<SWMTKN>是集群加入令牌，你可以在管理节点上生成。<MANAGER_IP>和<MANAGER_PORT>是Swarm管理节点的IP地址和端口号。
        docker swarm join --token <SWMTKN> <MANAGER_IP>:<MANAGER_PORT>
        ```

    - 3.验证节点加入： 在管理节点上运行以下命令，查看新节点是否成功加入到Swarm集群：
        ```sh
        docker node ls
        ```

    - 4.标记节点（可选）： 根据需要，你可以为新节点添加标签，以便更好地管理和组织节点。例如，你可以使用标签来指定节点的角色或用途。

- 2.移除节点

    - 1.准备移除节点： 在移除节点之前，确保你已经决定了要移除的节点，并且可以在不影响生产环境的情况下进行操作。确保节点上没有运行重要的服务或数据，并且可以承受一段时间的停机时间。

    - 2.标记节点为不可调度状态： 在开始移除节点之前，你可以将要移除的节点标记为不可调度状态，这样新的任务就不会在该节点上调度。你可以使用以下命令将节点标记为不可调度状态：
        ```sh
        # 其中，<NODE_ID>是要移除的节点的ID，你可以使用docker node ls命令获取节点ID。
        docker node update --availability drain <NODE_ID>
        ```

    - 3.移除节点：请确保在移除节点之前，节点已经被标记为不可调度状态。
        ```sh
        docker node rm <NODE_ID>
        ```

    - 4.等待节点移除： Swarm管理节点接收到移除节点的请求后，会停止该节点上的所有服务，并从集群中移除该节点。这个过程可能需要一些时间，具体时间取决于节点上运行的服务数量和状态。

    - 5.验证节点已移除： 在管理节点上运行以下命令，检查节点是否已从Swarm集群中移除：
        ```sh
        docker node ls
        ```

- 3.节点健康状态监控

- 1.使用docker node ls命令： 运行以下命令可以列出Swarm集群中所有节点的健康状态以及其他相关信息：

    ```sh
    # 在输出中，你将看到每个节点的状态列，其中包括活动状态和状态描述。状态描述可能包括 "Ready"（节点处于正常状态）、"Down"（节点不可用）等信息。
    docker node ls
    ```


    - 2.查看特定节点的详细信息，包括节点的健康状态。
        ```sh
        # 要查看节点node1的详细信息，可以运行
        # 在输出中，你将看到有关节点健康状态的信息，包括健康检查的结果和最近的健康状态变更时间。
        docker node inspect node1
        ```


    - 3.设置健康检查： 你可以在创建或更新服务时配置健康检查选项，以定期检查服务运行在节点上的健康状态。如果服务的健康状态不佳，Swarm将自动重新调度服务到其他健康的节点上。 你可以在创建服务时使用--health-cmd和--health-interval等选项来定义健康检查命令和检查间隔。

    - 4.使用监控工具： 你还可以使用第三方监控工具，如Prometheus、Grafana等，来监控节点的健康状态，并设置警报以及执行自动化操作以应对节点健康问题。

### Swarm网络

- 1.Overlay网络

    - 创建Overlay网络在Docker Swarm中，Overlay网络是一种用于跨多个节点连接容器的网络模型，它允许在Swarm集群中的不同节点上运行的容器之间进行通信。创建Overlay网络是在Swarm集群中部署分布式应用程序的关键步骤之一。以下是创建Overlay网络的步骤：

    - 创建Overlay网络：

        ```sh
        # 需要指定网络的驱动程序为overlay，并可以选择性地指定其他配置选项，如子网、IP范围、子网掩码等
        docker network create --driver overlay <network-name>

        # 例如，要创建名为my_overlay_network的Overlay网络，可以运行以下命令：
        docker network create --driver overlay my_overlay_network
        ```

    - 配置网络（可选）： 你可以选择性地配置Overlay网络，如设置子网、网关、IP范围等。这些配置选项可以在创建网络时通过命令行参数指定，也可以在创建网络后使用docker network update命令进行修改。

    - 验证网络创建： 使用docker network ls命令查看所有网络列表，确保新创建的Overlay网络已经添加到集群中：
        ```sh
        docker network ls
        ```

- 2.连接服务到Overlay网络

    - 创建服务并连接到Overlay网络

        ```sh
        docker service create --name <service-name> --network <network-name> <image>

        # 例如，要将名为my_service的服务连接到名为my_overlay_network的Overlay网络，可以运行以下命令：
        docker service create --name my_service --network my_overlay_network nginx
        ```

    - 更新服务并添加网络（可选）： 如果服务已经创建，你也可以使用docker service update命令更新服务并添加连接到Overlay网络。

        ```sh
        docker service update --network-add <network-name> <service-name>

        # 例如，要将名为my_service的服务添加到名为my_overlay_network的Overlay网络，可以运行以下命令：
        docker service update --network-add my_overlay_network my_service
        ```

    - 验证服务连接： 使用docker service inspect命令检查服务的详细信息，以确保服务已连接到Overlay网络：
        ```sh
        ocker service inspect <service-name>
        ```

- 3.路由Mesh

    - Swarm中的路由Mesh是一种功能强大的网络模型，用于自动路由来自Swarm集群中的任何节点的请求到正确的目标服务。

    - 这种自动化的路由机制使得跨多个节点的容器间通信变得非常简单。 要启用路由Mesh，你只需要将服务连接到Overlay网络，并且不需要进行额外的配置。一旦服务连接到Overlay网络，Swarm会自动处理路由和负载均衡。

    - 路由Mesh的工作原理如下：
        - 1.自动服务发现：当服务连接到Overlay网络时，Swarm会自动检测服务的实例，并维护有关服务的信息，包括IP地址和端口。
        - 2.动态路由：一旦服务连接到Overlay网络，Swarm会根据服务的名称和端口号，动态地将来自集群中任何节点的请求路由到正确的服务实例。无需手动配置路由规则。
        - 3.负载均衡：Swarm会自动负载均衡来自客户端的请求，将它们分发到连接到Overlay网络的不同服务实例上。这样，即使服务实例在不同的节点上运行，也能够实现负载均衡。

- 4.网络插件

    - 用于扩展Docker Swarm网络功能的第三方插件

    - 常见网络插件：
        - Calico：提供高级的网络功能，如网络策略、安全性增强和跨云网络连接。
        - Weave：提供高性能、跨主机的容器通信，支持多种云平台和混合云场景。
        - Flannel：提供简单易用的网络插件，适用于需要快速搭建网络的场景。
        - VXLAN：提供基于VXLAN技术的网络插件，支持多租户网络和跨主机通信。
        - Overlay2：提供Docker原生的Overlay网络功能，支持容器之间的跨主机通信。

    - 安装和配置： 要使用网络插件，需要在Swarm集群中安装和配置相应的插件。通常，每个网络插件都有特定的安装和配置方法，可以参考插件的文档进行操作。

    - 使用网络插件： 安装和配置网络插件后，可以在创建或更新服务时，通过--network选项指定要使用的网络插件。服务将连接到所选的网络插件提供的网络上，从而实现特定的网络功能。

### Swarm存储

- 1.存储驱动程序

    - 存储驱动程序是用于管理容器数据卷的后端组件。它负责在主机上创建、管理和维护容器数据卷，并提供了与底层存储后端的交互。

    - 常见存储驱动程序：
        - local：本地存储驱动程序，用于在主机的本地文件系统上创建和管理数据卷。
        - nfs：支持通过网络文件系统（NFS）挂载远程存储。
        - vfs：提供简单的存储驱动程序，适用于开发和测试环境。
        - ceph：与Ceph分布式存储集成，提供高可用性和可扩展性的存储解决方案。

    - 安装和配置： 要使用特定的存储驱动程序，你需要在Docker Swarm集群中安装和配置相应的驱动程序。通常情况下，你可以在Docker引擎的配置文件中指定所需的存储驱动程序。
    - 使用存储驱动程序： 安装和配置存储驱动程序后，你可以在创建或更新服务时，通过--mount选项将数据卷挂载到容器中。可以指定数据卷的名称、驱动程序和其他配置选项。
    - 多节点存储： 对于Swarm集群中跨多个节点的存储需求，你可以选择支持多节点存储的存储驱动程序，如Ceph等。这些驱动程序提供了高可用性和可扩展性的存储解决方案，可以满足分布式应用程序的需求。

- 2.使用存储：通过以下步骤实现

    - 1.选择合适的存储驱动程序： 首先，你需要选择适合你需求的存储驱动程序。根据你的需求和环境，选择一个或多个适当的存储驱动程序，如本地存储、网络文件系统（NFS）、Ceph等。
    - 2.在Swarm集群中安装和配置存储驱动程序： 在Swarm集群的每个节点上安装和配置所选的存储驱动程序。根据存储驱动程序的要求，可能需要进行特定的安装和配置步骤。确保每个节点都正确配置了所需的存储驱动程序。
    - 3.创建存储卷： 使用所选的存储驱动程序，在Swarm集群中创建存储卷。你可以使用docker volume create命令创建存储卷，并选择指定所需的存储驱动程序和其他配置选项。
    - 4.将存储卷挂载到服务： 在创建或更新服务时，通过--mount选项将存储卷挂载到服务中。指定存储卷的名称和所选的存储驱动程序。这样，服务中的容器就可以访问并使用挂载的存储卷。
    - 5.使用存储卷： 容器内的应用程序可以通过挂载到服务的存储卷来访问和操作数据。使用存储卷可以实现容器之间的数据共享和持久化存储，从而满足应用程序的需求。

### 高级主题

- 1.Swarm模式

    - Swarm模式是Docker Swarm的一种高级配置，它提供了一些额外的功能和特性，使得在生产环境中部署和管理容器化应用程序更加灵活和可靠。

    - 1.集群管理： Swarm模式提供了集群管理的功能，使得在生产环境中轻松管理多个Docker主机。你可以使用Swarm模式来创建和管理一个由多个Docker节点组成的集群，统一管理和调度容器。
    - 2.服务发现和负载均衡： Swarm模式自动提供了服务发现和负载均衡的功能。当你创建服务并将其连接到Swarm网络时，Swarm会自动处理服务的路由和负载均衡，确保来自客户端的请求被正确路由到服务实例上。
    - 3.高可用性： Swarm模式提供了高可用性的容器部署和管理功能。通过在集群中运行多个副本，Swarm可以实现容器服务的自动故障恢复和容错处理，确保应用程序的可用性。
    - 4.滚动更新： Swarm模式支持滚动更新，可以实现无缝的应用程序更新和版本管理。通过逐步替换服务的实例，Swarm可以确保在进行应用程序更新时不会导致服务中断或数据丢失。
    - 5.安全性增强： Swarm模式提供了一些安全性增强功能，如TLS加密通信、角色基于访问控制和秘密管理等。这些功能可以帮助你保护集群和容器中的数据安全。
    - 6.弹性伸缩： 通过Swarm模式，你可以轻松地实现应用程序的弹性伸缩。通过调整服务的副本数量，Swarm可以根据负载情况自动扩展或缩减服务的实例数量，以满足不同的性能需求。

- 2.Swarm部署策略

    - 部署策略指定了如何在集群中调度和管理服务的实例。通过选择适当的部署策略，你可以控制服务的副本在集群中的分布方式，实现负载均衡、高可用性和资源利用的优化。以下是一些常见的Swarm部署策略：

    - 1.Replicated部署： Replicated部署策略是最常见的部署策略之一，它用于在集群中运行多个服务副本。你可以指定服务的副本数量，并且Swarm会自动在集群中的不同节点上创建并管理这些副本。
    - 2.Global部署： Global部署策略用于在集群中的每个节点上运行一个服务副本。这种策略适用于需要在每个节点上运行单个实例的服务，例如监控代理或日志收集器。
    - 3.Placement Constraints： 使用Placement Constraints可以根据节点的属性或标签，将服务实例部署到特定的节点上。这可以帮助你实现特定的部署需求，如将服务部署到特定的硬件、区域或数据中心。
    - 4.资源限制： 你可以使用资源限制来限制服务实例使用的CPU、内存或其他资源的数量。这可以确保服务实例在集群中的资源利用合理，避免资源竞争和性能问题。
    - 5.滚动更新： 滚动更新策略用于实现无缝的应用程序更新和版本管理。通过逐步替换服务的实例，Swarm可以确保在进行应用程序更新时不会导致服务中断或数据丢失。
    - 6.弹性伸缩： 弹性伸缩策略允许根据负载情况自动扩展或缩减服务的实例数量。你可以设置自动伸缩的触发条件，并根据需要调整服务的副本数量，以满足不同的性能需求。

- 3.Swarm故障恢复

    - 1.自动故障检测： Swarm集群会定期检测节点和服务的健康状态。如果某个节点或服务出现故障，Swarm会自动检测并尝试恢复。对于节点故障，Swarm会重新调度受影响的服务到其他健康的节点上。
    - 2.滚动更新： 在进行服务更新或升级时，Swarm可以使用滚动更新策略，逐步替换服务的实例，确保在更新过程中不会导致服务中断或数据丢失。如果某个服务实例出现故障，Swarm会尝试启动新的实例来替换。
    - 3.自动容错： Swarm集群具有一定的自动容错能力，可以在节点或服务故障时自动恢复。通过在集群中运行多个副本，并使用负载均衡机制来分发请求，Swarm可以实现容器服务的高可用性和容错处理。
    - 4.节点替换： 如果某个节点出现故障或失联，Swarm会自动将受影响的服务重新调度到其他健康的节点上。如果需要，Swarm还可以自动替换故障节点，以确保集群的稳定性和可用性。
    - 5.监控和警报： 通过监控集群的健康状态和性能指标，可以及时发现并响应节点或服务的故障。使用警报系统可以及时通知运维人员，并采取适当的措施来处理故障情况。

## 监控

- 容器监控：
    - 容器监控是指监视 Docker 容器本身的运行状况和资源使用情况。
    - 关注容器内的进程、资源利用率（如 CPU、内存、磁盘、网络）、日志输出等指标。
    - 容器监控可以帮助我们了解单个容器的性能特征和运行状况，有助于快速发现和解决容器级别的问题。
    - 常见的容器监控工具包括 cAdvisor、Prometheus、Docker 自带的 Stats API 等。

- 主机监控：
    - 主机监控是指监视 Docker 宿主机的整体运行状态和资源利用情况。
    - 包括监视宿主机的 CPU 利用率、内存使用、磁盘空间、网络负载等指标。
    - 主机监控可以帮助我们了解 Docker 宿主机的整体健康状况，以及宿主机上运行的所有容器的总体性能。
    - 常见的主机监控工具包括 Prometheus、Grafana、Sysdig、Datadog 等。

- 监控指标：

    - CPU 利用率：
        - 用于度量 CPU 的使用情况，包括整个 Docker 主机或单个容器的 CPU 使用率。
        - 高 CPU 利用率可能表示需要增加计算资源，或者存在 CPU 密集型的任务或进程。
    - 内存利用率：
        - 衡量系统内存的使用情况，包括 Docker 容器和宿主机的内存使用率。
        - 高内存利用率可能导致性能下降和容器的意外终止，可能需要增加内存或优化容器内存使用。
    - 磁盘 I/O：
        - 衡量磁盘读写操作的速率和负载。
        - 高磁盘 I/O 可能表示存储子系统存在瓶颈，可能需要优化容器的数据管理方式或增加存储容量。
    - 网络流量：
        - 监控容器和宿主机的网络传输速率和流量。
        - 高网络流量可能表示网络带宽不足或网络配置问题，需要进一步调查和优化。
    - 容器运行状态：
        - 包括容器的健康状态、启动次数、重启次数等。
        - 异常频繁的容器重启可能表示容器配置问题或应用程序错误，需要检查日志以解决问题。
    - 容器日志：
        - 监控容器的日志输出，包括错误日志、警告日志以及应用程序日志。
        - 日志监控有助于及时发现和诊断容器中的问题，可以使用日志聚合工具对日志进行集中管理和分析。

- 容器运行状态指标
    - 容器启动次数：容器启动次数指示容器启动的频率。频繁的容器启动可能表示容器经常出现故障或崩溃，需要进一步调查和解决问题。
    - 容器健康状态：容器健康状态表示容器的整体健康状况，通常以健康或不健康状态表示。
    - 容器监控工具可以定期检查容器的健康状态，并在容器出现异常时触发警报或自动响应机制。
    - 容器重启次数：容器重启次数指示容器被重新启动的次数。频繁的容器重启可能表示容器配置不稳定或应用程序错误，需要进一步调查原因。
    - 容器日志：
        - 容器日志记录了容器的运行日志，包括应用程序输出、错误日志、警告信息等。
        - 监控容器日志有助于及时发现容器中的问题，并快速诊断和解决。

- 集群管理指标

    - 集群节点状态：
        - 监控集群中所有节点的状态，包括节点的可用性、健康状况和负载情况。
        - 可以检查节点的 CPU、内存、磁盘和网络利用率，以及节点的运行时间和负载均衡情况。
        - 通过监控节点状态，可以及时发现节点故障或性能问题，并采取措施确保集群的稳定性和高可用性。
    - 容器部署状态：
        - 监控容器在集群中的部署状态，包括容器的数量、位置、运行状况和健康状态。
        - 可以检查容器的部署位置和分布情况，以及容器的运行时间和重启次数。
        - 通过监控容器部署状态，可以及时发现容器的异常运行或部署问题，并进行相应的调整和优化。
    - 资源分配情况：
        - 监控集群中资源的分配情况，包括 CPU、内存、磁盘和网络等资源的使用情况和分配情况。
        - 可以检查集群中资源的分配比例和平衡性，以及是否存在资源不足或过度分配的情况。
        - 通过监控资源分配情况，可以优化资源利用，避免资源浪费和性能瓶颈。

## 不同应用是否适合docker，以及性能对比

### nosql

- 对于生产环境的无状态应用，甚至一些带有衍生状态的不甚重要衍生数据系统（譬如Redis缓存），Docker也是一个不错的选择。

### 关系型数据库

- [非法加冯：把数据库放入Docker是一个好主意吗？](https://mp.weixin.qq.com/s/kFftay1IokBDqyMuArqOpg)

- Docker的核心权衡可能就是牺牲可靠性换取可维护性。

    - 对于无状态的应用服务而言，容器是一个相当完美的开发运维解决方案。然而对于带持久状态的服务 —— 数据库来说，事情就没有那么简单了。

    - 生产环境的数据库是否应当放入容器中，仍然是一个充满争议的问题。

        - 站在DBA的立场上，我认为就目前而言，将生产环境数据库放入Docker / K8S 中仍然是一个馊主意。

- 以下讨论仅限于生产环境数据库。对于开发测试而言，尽管有基于Vagrant的虚拟机沙箱，但我也支持使用Docker —— 毕竟不是所有的开发人员都知道怎么配置本地测试数据库环境，使用Docker交付环境显然要比一堆手册简单明了得多。

    - 1.docker最初是针对无状态的应用而设计的

        - 在逻辑上，容器内应用产生的临时数据也属于该容器的一部分。用容器创建起一个服务，用完之后销毁它。这些应用本身没有状态，状态通常保存在容器外部的数据库里，这是经典的架构与用法，也是容器的设计哲学。

        - 数据库是有状态的，为了维持这个状态不随容器停止而销毁，数据库容器需要在容器上打一个洞，与底层操作系统上的数据卷相联通。这样的容器，不再是一个能够随意创建，销毁，搬运，转移的对象，而是与底层环境相绑定的对象。因此，传统应用使用容器的诸多优势，对于数据库容器来说都不复存在。

    - 2.docker不提供可靠性：

        - 这是数据库最重要的属性。可靠性是系统在困境（adversity）（硬件故障、软件故障、人为错误）中仍可正常工作

        - 相反，引入Docker会因为引入了额外的组件，额外的复杂度，额外的失效点，导致系统整体可靠性下降。
            - dockerd守护进程崩了怎么办，数据库进程就直接歇菜了。尽管这种事情发生的概率并不高，但它们在裸机上 —— 压根不会发生。
            - 一个额外组件引入的失效点可能并不止一个：Docker产生的问题并不仅仅是Docker本身的问题。当故障发生时，可能是单纯Docker的问题，或者是Docker与数据库相互作用产生的问题，还可能是Docker与操作系统，编排系统，虚拟机，网络，磁盘相互作用产生的问题。

    - 3.docker运行数据库增加了复杂度
        - 当数据库出现问题时需要数据库专家来解决；当容器出现问题时需要容器专家来看问题；然而当你把数据库放入 Kubernetes 时，单独的数据库专家和 K8S 专家的智力带宽是很难叠加的 —— 你需要一个双料专家才能解决问题。而同时精通这两者的软件肯定要比单独的数据库专家少得多。

    - 4.隔离性：docker提供了进程级别的隔离性

        - 应用看不见别的进程，自然也不会有很多相互作用导致的问题，进而提高了系统的可靠性。

        - 但隔离性对于数据库而言不一定完全是好事。
            - 例子：在同一个数据目录上启动两个PostgreSQL实例，或者在宿主机和容器内同时启动了两个数据库实例。在裸机上第二次启动尝试会失败，因为PostgreSQL能意识到另一个实例的存在而拒绝启动；但在使用Docker的情况下因其隔离性，第二个实例无法意识到宿主机或其他数据库容器中的另一个实例。如果没有配置合理的Fencing机制（例如通过宿主机端口互斥，pid文件互斥），两个运行在同一数据目录上的数据库进程能把数据文件搅成一团浆糊。

        - 数据库需不需要隔离性？当然需要， 但不是这种隔离性。数据库的性能很重要，因此往往是独占物理机部署。除了数据库进程和必要的工具，不会有其他应用。
            - 即使放在容器中，也往往采用独占绑定物理机的模式运行。因此Docker提供的隔离性对于这种数据库部署方案而言并没有什么意义；不过对云数据库厂商来说，这倒真是一个实用的Feature，用来搞多租户超卖妙用无穷。

    - 5.数据库工具主要针对裸机设计

        - 数据库需要工具来维护，包括各式各样的运维脚本，部署，备份，归档，故障切换，大小版本升级，插件安装，连接池，性能分析，监控，调优，巡检，修复。

        - 按照Docker的实践原则，用户需要在镜像层次进行这个变更，否则下次容器重启时这个扩展就没了。因而需要修改Dockerfile，重新构建新镜像并推送到服务器上，最后重启数据库容器，毫无疑问，要麻烦得多。

        - 包管理是操作系统发行版的核心问题。然而 Docker 搅乱了这一切，例如，许多 PostgreSQL 不再以 RPM/DEB 包的形式发布二进制，而是以加装扩展的 Postgres Docker 镜像分发。这就会立即产生一个显著的问题，如果我想同时使用两种，三种，或者PG生态的一百多种扩展，那么应该如何把这些散碎的镜像整合到一起呢？相比可靠的操作系统包管理，构建Docker镜像总是需要耗费更多时间与精力才能正常起效。

    - 6.监控
        - 在传统的裸机部署模式下，机器的各项指标是数据库指标的重要组成部分。容器中的监控与裸机上的监控有很多微妙的区别。不注意可能会掉到坑里。
            - 例子：CPU各种模式的时长之和，在裸机上始终会是100%，但这样的假设在容器中就不一定总是成立了。
            - 例子：依赖/proc文件系统的监控程序可能在容器中获得与裸机上涵义完全不同的指标。虽然

    - 7.环境配置

        - Docker最大的优点是什么，那也许就是环境配置的标准化了。标准化的环境有助于交付变更，交流问题，复现Bug。使用二进制镜像（本质是物化了的Dockerfile安装脚本）相比执行安装脚本而言更为快捷，管理更方便。一些编译复杂，依赖如山的扩展也不用每次都重新构建了，这些都是很不错的特性。

            - 不幸的是，数据库并不像通常的业务应用一样来来去去更新频繁，创建新实例或者交付环境本身是一个极低频的操作。同时DBA们通常都会积累下各种安装配置维护脚本，一键配置环境也并不会比Docker慢多少。

        - 通常来说，数据库初始化之后连续运行几个月几年也并不稀奇。占据数据库管理工作主要内容的并不是创建新实例与交付环境，主要还是日常运维的部分 —— Day2 Operation。不幸的是，在这一点上Docker并没有什么优势，反而会产生不少的额外麻烦。

    - 8.版本升级
        - Docker喜欢讲的例子是软件版本升级：例如用Docker升级数据库小版本，只要简单地修改Dockerfile里的版本号，重新构建镜像然后重启数据库容器就可以了。没错，至少对于无状态的应用来说这是成立的。但当需要进行数据库原地大版本升级时问题就来了，用户还需要同时修改数据库状态。在裸机上一行bash命令就可以解决的问题

    - 9.扩容

        - docker很容易进行扩容，至少对于无状态的应用而言是这样：一键拉起起几个新容器，随意调度到哪个节点都无所谓。

        - 但数据库不一样，作为一个有状态的应用，数据库并不能像普通AppServer一样随意创建，销毁，水平扩展。譬如，用户创建一个新从库，即使使用容器，也得从主库上重新拉取基础备份。生产环境中动辄几TB的数据库，创建副本也需要个把钟头才能完成，也需要人工介入与检查，并逐渐放量预热缓存才能上线承载流量。相比之下，在同样的操作系统初始环境下，运行现成的拉从库脚本与跑docker run在本质上又能有什么区别 —— 时间都花在拖从库上了。

        - 通常来说设置一个新PostgreSQL从库的流程是，先通过pg_baseback建立本地的数据目录副本，然后再在本地数据目录上启动postmaster进程。
            - 然而容器是和进程绑定的，一旦进程退出容器也随之停止。因此为了在Docker中扩容一个新从库：要么需要先后启动pg_baseback容器拉取数据目录，再在同一个数据卷上启动postgres两个容器；要么需要在创建容器的过程中就指定定好复制目标并等待几个小时的复制完成；要么在postgres容器中再使用pg_basebackup偷天换日替换数据目录。无论哪一种方案都是既不优雅也不简洁。

    - 10.性能
        - 从性能的角度来看，数据库的基本部署原则当然是离硬件越近越好，额外的隔离与抽象不利于数据库的性能
        - 对于追求性能的场景，一些数据库选择绕开操作系统的页面管理机制直接操作磁盘，而一些数据库甚至会使用FPGA甚至GPU加速查询处理。

## 与裸机性能对比

- [NGINX开源社区：比较裸机和虚拟环境中的 NGINX 性能]()

    - 两个关键指标：

        - 每秒请求数（RPS）：Kubernetes约为裸机值的 80%。 Kubernetes 环境中使用的底层容器网络堆栈，因此在 Kubernetes 中运行 NGINX Ingress Controller 会导致这种网络密集型操作的性能大幅下降。

        - 每秒SSL/TLS 事务数 (TPS)：几乎无甚差异

# 第三方软件

- [awesome-docker：包含 docker 相关的文档资源和项目](https://github.com/veggiemonk/awesome-docker)

## 服务端

- [dockge：Docker Compose web管理平台。用于管理 docker-compose.yaml 文件。](https://github.com/louislam/dockge)

    - 支持交互式编辑 compose.yaml 文件
    - 更新 docker 镜像，以及启动、停止、重启、删除 docker 等操作。

- [pipework：容器自定义网络工具](https://github.com/jpetazzo/pipework)

- [hub-tool：管理 docker hub 的 cli 工具](https://github.com/docker/hub-tool)

- [自动更新 docker 镜像](https://github.com/containrrr/watchtower)

```bash
docker run -d \
    --name watchtower \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower
```

- [trivy：容器镜像安全漏洞扫描](https://github.com/aquasecurity/trivy)
    - [云原生运维圈：容器镜像安全漏洞扫描-Trivy](https://mp.weixin.qq.com/s?__biz=MzUxNTg5NTQ0NA==&mid=2247483780&idx=1&sn=e3e14b8d6754f95073e25a1880df4f7d&chksm=f9aef87fced9716914995a9b1334ed73b9ba91251b7ea7a79e1910ab02ec6ee00eb2138fc20d&cur_album_id=2200317766446923776&scene=190#rd)

- [Dedockify：Docker镜像逆向生成Dockerfile](https://github.com/mrhavens/Dedockify)
    - [如何基于Docker镜像逆向生成Dockerfile](https://mp.weixin.qq.com/s/yUuo1IjeXY78_5u4QpkuTA)

- [slim：优化docker容器体积](https://github.com/slimtoolkit/slim)

    - 允许开发人员使用 xray , lint , build , debug , run , images , merge , registry , vulnerability （以及其他）命令来检查、优化和调试他们的容器。

    - Slim 不但可以优化容器镜像大小，它还能帮助你理解和编写更好的容器镜像。

- [Dive：探索 Docker 镜像、层内容，并发现缩小 Docker/OCI 镜像大小的方法的工具](https://github.com/wagoodman/dive)

- [dockerc：将 Docker 镜像编译为独立可执行文件的工具。该项目能将 Docker 镜像转化为二进制可执行文件，无需配置 Docker 环境或安装依赖，简化了软件的分发和运行流程。](https://github.com/NilsIrl/dockerc)

## 客户端

- [Docker Desktop：官方的gui客户端](https://www.docker.com/products/docker-desktop/)

    ```sh
    # 启动
    systemctl --user start docker-desktop
    # 关闭
    systemctl --user stop docker-desktop
    ```

- [cAdvisor](https://github.com/google/cadvisor)
  ![image](./Pictures/docker/cadvisor.avif)

```bash
docker run \
 --volume=/:/rootfs:ro \
 --volume=/var/run:/var/run:ro \
 --volume=/sys:/sys:ro \
 --volume=/var/lib/docker/:/var/lib/docker:ro \
 --volume=/dev/disk/:/dev/disk:ro \
 --publish=5002:8080 \
 --detach=true \
 --name=cadvisor \
 --privileged \
 --device=/dev/kmsg \
 google/cadvisor:latest
```

- [k3s-rancher](https://github.com/rancher/rancher)
  ![image](./Pictures/docker/rancher.avif)

```bash
docker run -d \
    --restart=unless-stopped \
    -p 80:80 -p 443:443 \
    --privileged \
    rancher/rancher
```

- [beszel：轻量级高颜值的 Docker 监控平台。这是一个轻量级的服务器监控平台，包括 Docker 统计、历史数据和警报功能。它拥有友好的 Web 界面，配置简单、开箱即用，支持自动备份、多用户、OAuth 认证和 API 访问等功能。](https://github.com/henrygd/beszel)
  ![image](./Pictures/docker/beszel.avif)

- [docker-ui](https://github.com/kevana/ui-for-docker)
  ![image](./Pictures/docker/ui.avif)

```bash
docker run -d -p 9000:9000 \
    --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock \
    uifd/ui-for-docker
```

- [ctop](https://github.com/bcicen/ctop)
  ![image](./Pictures/docker/ctop.avif)

```bash
docker run --rm -ti \
    --name=ctop \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    quay.io/vektorlab/ctop:latest
```

- [lazydocker](https://github.com/jesseduffield/lazydocker)
  ![image](./Pictures/docker/lazydocker.avif)

- [dpanel：轻量级的 Docker 可视化管理面板。这是一款专为国内用户设计的 Docker 可视化管理面板，采用全中文界面。](https://github.com/donknap/dpanel)
  ![image](./Pictures/docker/dpanel.avif)

- [trivy容器安全检测](https://github.com/aquasecurity/trivy)

    ```sh
    # 检测容器安全
    trivy image redislabs/redismod
    ```

- [dive：查看docker文件系统的每一层（tui）](https://github.com/wagoodman/dive)
  ![image](./Pictures/docker/dive.avif)

- [dozzle：Docker 日志查看工具](https://github.com/amir20/dozzle)

- [buildg：交互式的 Dockerfile 调试工具。](https://github.com/ktock/buildg)
    - 该项是基于 BuildKit 的交互式调试 Dockerfile 的工具，支持设置断点、单步执行和非 root 模式，并且可以在 VSCode、neovim、emacs 等编辑器中使用。

- [cdebug：容器调试工具。支持Docker 容器、Kubernetes Pod，还是其他类型的容器](https://github.com/iximiuz/cdebug)

    - [奇妙的Linux世界：cdebug: 容器调试界的瑞士军刀，5 个超能力让你成为调试大师](https://mp.weixin.qq.com/s/i-C3ZIcGpXKYFWZzQD0Cfw)

- [trayce：查看docker容器http通信](https://trayce.dev/)

- find-container-process：根据你输入的进程 ID (PID)，找到对应的 Docker 容器

    ```sh
    # 启动find-container-process
    docker run --rm -it --name find-container-process -v /var/run/docker.sock:/var/run/docker.sock --pid=host --net=host --privileged 80imike/find-container-process
    ```

- [runlike：自动生成对应的docker run命令](https://github.com/lavie/runlike)

    ```sh
    runlike -p redis

    docker run \
        --name=redis \
        -e "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
        -e "REDIS_VERSION=2.8.9" \
        -e "REDIS_DOWNLOAD_URL=http://download.redis.io/releases/redis-2.8.9.tar.gz" \
        -e "REDIS_DOWNLOAD_SHA1=003ccdc175816e0a751919cf508f1318e54aac1e" \
        -p 0.0.0.0:6379:6379/tcp \
        --detach=true \
        myrepo/redis:7860c450dbee9878d5215595b390b9be8fa94c89 \
        redis-server --slaveof 172.31.17.84 6379
    ```

- [imgx：将本地镜像文件推送至远程主机](https://github.com/devzhi/imgx)

# reference article(优秀文章)

- [docker 官方文档](https://docs.docker.com/engine/reference/run/)

- [docker 从入门到实践](https://github.com/yeasy/docker_practice)

- [dockerlabs：该教程的内容分为初、中、高三个级别，适合所有阶段的 Docker。内含 500 个动手实验，以及 Docker 和 Docker Compose 小抄](https://github.com/collabnix/dockerlabs)

- [docker-cheat-sheet](https://github.com/wsargent/docker-cheat-sheet)

- [Dockerfile 安全最佳实践](https://cloudberry.engineering/article/dockerfile-security-best-practices/)

- [gvistor 对比普通容器和 aliuk](https://mp.weixin.qq.com/s?src=11&timestamp=1613134736&ver=2886&signature=6e*T4ylvJCA--fGa-tb*ttJq3JArF7z-Wzs5eAPzlY813SG154AK1YyEgLv2MQSiIgP-pWSXHI2l*Fwri21PvvVMnlRoFkCEoiew-uvj8AFuYyM*dD5l83dQ2G5TriVb&new=1)

# podman

- Podman 是一个 RedHat 公司发布的开源容器管理工具，初衷就是 Docker 的替代品，在使用上与 Docker 的相似，但又有着很大的不同。

- podman 与 Docker 的最大区别是架构
    - Docker 是以 C/S 架构运行的，我们平时使用的 docker 命令只是一个命令行前端，它需要调用 dockerd 来完成实际的操作，而 dockerd 默认是一个有 root 权限的守护进程。
    - Podman 不需要守护进程，直接通过 fork/exec 的形式启动容器，不需要 root 权限。

- podman与docker的命令基本兼容，都包括容器运行时（run/start/kill/ps/inspect），本地镜像（images/rmi/build）、镜像仓库（login/pull/push）等几个方面。
    - 因此podman的命令行工具与docker类似，比如构建镜像、启停容器等。甚至可以通过`alias docker=podman`可以进行替换。因此，即便使用了podman，仍然可以使用docker.io作为镜像仓库，这也是兼容性最关键的部分。


- 三个主要的配置文件是`container.conf`、`storage.conf`、`registries.conf`

    ```sh
    cat /usr/share/containers/containers.conf
    cat /etc/containers/containers.conf
    cat ~/.config/containers/containers.conf  //优先级最高
    ```


- 添加以下内容到`/etc/containers/registries.conf`。不然无法`podman pull`
    ```toml
    [registries.search]
    # 这个是查找，从这三个地方查找，如果只留一个，则只在一个源里查找
    registries = ['registry.access.redhat.com', 'registry.redhat.io', 'docker.io']
    unqualified-search-registries = ["registry.fedoraproject.org", "registry.access.redhat.com", "registry.centos.org", "docker.io"]
    ```

- 在普通用户环境中使用Podman时，建议使用`fuse-overlayfs`而不是VFS文件系统，至少需要版本0.7.6。现在新版本默认就是了。

    ```sh
    # 安装slirp4netns和fuse-overlayfs
    yum -y install slirp4netns
    yum -y install fuse-overlayfs
    ```

    在配置文件`/etc/containers/storage.conf`
    ```
    mount_program = "/usr/bin/fuse-overlayfs"     //取消注释
    ```

- 容器命令

    ```sh
    podman run         # 创建并启动容器
    podman start       # 启动容器
    podman ps          # 查看容器
    podman stop        # 终止容器
    podman restart     # 重启容器
    podman attach      # 进入容器
    podman exec        # 进入容器
    podman export      # 导出容器
    podman import      # 导入容器快照
    podman rm          # 删除容器
    podman logs        # 查看日志
    ```

- 镜像命令
    ```sh
    podman search             # 检索镜像
    docke pull                # 获取镜像
    podman images             # 列出镜像
    podman image Is           # 列出镜像
    podman rmi                # 删除镜像
    podman image rm           # 删除镜像
    podman save               # 导出镜像
    podman load               # 导入镜像
    podmanfile                # 定制镜像（三个）
     podman build              # 构建镜像
        podman run              # 运行镜像
        podmanfile              # 常用指令（四个）
         COPY                    # 复制文件
            ADD                     # 高级复制
            CMD                     # 容器启动命令
            ENV                     # 环境变量
            EXPOSE                  # 暴露端口
    ```

```sh
# 运行nginx容器
podman run -d --name nginx docker.io/library/nginx

# 查看镜像
podman images

# 查看运行的容器
podman ps

# 查看ip地址
podman inspect -l | grep -i 'IPAddress'
              "IPAddress": "10.88.0.2",
                        "IPAddress": "10.88.0.2",

# 获取nginx的index.html
curl 10.88.0.2

# 查看运行中容器的日志
podman logs --latest

# top
podman top nginx
USER        PID         PPID        %CPU        ELAPSED           TTY         TIME        COMMAND
root        1           0           0.000       21m40.989145709s  ?           0s          nginx: master process nginx -g daemon off;

# 停止一个运行中的容器
podman stop --latest

# 删除一个容器
podman rm --latest
```

## [Podman Desktop：一个管理容器的gui。兼容docker引擎](https://podman-desktop.io/)

![image](./Pictures/docker/podman-desktop.avif)

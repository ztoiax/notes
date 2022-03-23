# [docker](https://github.com/moby/moby)

- 容器和其它进程的不同之处在于,容器使用 namespace,cgroup 等技术,为进程创造出资源隔离,限制的环境

  > 容器和进程是共享 host(宿主机)内核

  > 也就是在 windows,macos 上的 docker,无法使用 centos,opensuse 这些依赖 linux 内核的容器

  ![image](./Pictures/kubernetes-docker/docker.png)

- 通过 `namespace` 实现资源**隔离**(isolate)

  - 我们所熟知的 `chroot` 命令,就是切换挂载点,实现文件系统的隔离

  - namespace 有 8 项隔离
    | namespace | 内容 |
    | -------- | ------------------------------------ |
    | Cgroup | Cgroup root directory |
    | IPC | System V IPC, POSIX message queues,Shared memory |
    | Network | Network devices, stacks, ports, etc. |
    | Mount | Mount points |
    | PID | Process IDs |
    | Time | Boot and monotonic, clocks |
    | User | User and group IDs |
    | UTS | Hostname and NIS, domain name |

  - `/proc/pid/ns` 目录下查看不同的 namespace(以编号区分)

  - `lsns` 命令查看所有 namespace

  - `pgrep --ns 4026532713 -a ` 命令,传递 namespace 编号,查看此 namespace 下的进程

    ![image](./Pictures/kubernetes-docker/namespace.png)

- 通过 `cgroup` 实现资源**限制**(limit) 和 监控容器的统计信息

  - `mount -t cgroup` 查看 cgroup 子系统

    ![image](./Pictures/kubernetes-docker/cgroup.png)

  - docker 在每个 cgroup 子系统目录下,都有自己的控制组

    - 每个控制组下有对应的容器`/sys/fs/cgroup/cpu/docker/<container-id>`

      ![image](./Pictures/kubernetes-docker/cgroup1.png)
      ![image](./Pictures/kubernetes-docker/cgroup2.png)

- Capability 对 root 权限,分成多个子权限 [详细文档](https://man7.org/linux/man-pages/man7/capabilities.7.html)

  - 对容器授予某些子权限,而不是整个 root 权限,以此实现安全

  - 通过 `capsh --print` 命令查看权限
    ![image](./Pictures/kubernetes-docker/capability.png)

- docker 采用 `client/server` 结构进行通信交互 [官方文档](https://docs.docker.com/get-started/overview/#docker-architecture)

  > docker(cli)/dockerd(daemon). 它们都是 docker engine(docker 开源容器技术) 的组成部分

  - client 使用 `REST API` 通过 `unix socket` 与 daemon 进行通信

    - REST API 最简单的例子是浏览器:通过 url 使用不同的动作(get,push)请求资源(可以是图片,文字,视频),而服务器会对请求返回不同的状态(200,404)

      ![image](./Pictures/kubernetes-docker/cs1.jpg)
      ![image](./Pictures/kubernetes-docker/cs.svg)

- docker 镜像使用分层的文件系统(union fs),联合挂载(union mount)会进行整合,让我们看上去为一层

  - 修改容器内的某个文件时,会在最顶层记录修改的内容,不会覆盖下层的内容(类似于 git diff),以此实现共享镜像层

    ![image](./Pictures/kubernetes-docker/fs.png)

- 多个容器运行时,如果未修改镜像内容,会**共享镜像层**(layer)

  - 容器启动时,在只读的镜像层上添加 自己的**可写覆盖层**

  - 容器运行过程中修改镜像时,会将修改的内容写入 可写覆盖层(copy on wirte)
    ![image](./Pictures/kubernetes-docker/fs1.png)

- 配置文件 `/var/lib/docker`

  | 内容    | 目录                    |
  | ------- | ----------------------- |
  | volumes | /var/lib/docker/volumes |

  | image                                                | /var/lib/docker/image/overlay2 |
  | ---------------------------------------------------- | ------------------------------ |
  | 仓库(镜像名和 hash 值)                               | repositories.json              |
  | 镜像元数据(docker 版本,创建时间)                     | imagedb                        |
  | 容器层 元数据                                        | layerdb/mounts                 |
  | 镜像层(layer) 元数据(没有 parent 的镜像层为子镜像层) | layerdb/sha256                 |

  | container         | /var/lib/docker/containers    |
  | ----------------- | ----------------------------- |
  | volume 的具体情况 | <container_id>/config.v2.json |

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

## 基本命令

![image](./Pictures/kubernetes-docker/cmd_logic.png)

```bash
# 查看docker信息
docker info

# 查看容器运行信息
docker inspect CONTAINER_ID

# 查看容器写入层的diff(类似git diff)
docker diff CONTAINER_ID

# 查看容器镜像构建信息
docker history IMAGE_ID

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
```

## docker run

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

### --volumes-from 会递归容器引用的数据卷

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

![image](./Pictures/kubernetes-docker/volumes-from.png)

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

      ![image](./Pictures/kubernetes-docker/volumes-from1.png)

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

### cgroup(资源限制)

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

### 其他资源限制

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

### namespace(命名空间)

| 命名空间相关参数 | 操作         |
| ---------------- | ------------ |
| --net            | 指定网卡     |
| `--net=none`     | 不指定网卡   |
| --pid            | pid          |
| --user           | 指定用户和组 |

---

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

## Capability

```bash
docker run --cap-add=ALL --cap-drop=MKNOD \
    --rm -it opensuse
```

## import/export

### 镜像导入导出

```bash
# 导出
docker save centos > centos.tar
docker save centos | gzip > centos.tar.gz
```

镜像内:
![image](./Pictures/kubernetes-docker/save.png)

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

![image](./Pictures/kubernetes-docker/containerd.png)

![image](./Pictures/kubernetes-docker/containerd1.png)

- 管理容器的生命周期

  - start

  - stop

  - delete

- 管理容器的分发

  - pull

  - push

## runc

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

![image](./Pictures/kubernetes-docker/runc.png)

## network

### cnm model(容器网络模型)

- sandbox(沙盒),通过 namespace 实现

  - 一个 sandbox 可以有多个 endpoint 和 网络

- endpoint(端点),通过 veth 实现

- 网络,通过 brictl,vlan 实现

  - 一个网络可以有多个端点

下图 3 个容器的连通性:

- 左边和右边能和中间 ping 通

- 左边与右边不通

![image](./Pictures/kubernetes-docker/cnm-model.png)

```bash
# 创建两个btrctl网络
docker network create backend
docker network create frontend

# 也可以指定网段
docker network create --subnet=172.18.0.0/16 backend

# 查看网络
docker network ls
```

通过 `ip a` 命令,查看刚才创建的网络的 ip 地址
![image](./Pictures/kubernetes-docker/cnm.png)

```bash
# 启动3个容器,并配置图片上的网络

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

此时再次通过 `ip a` 命令查看

发现一共多出 4 个 `veth` 的网络接口

- veth 是 namespace 之间的互联的虚拟网络设备,会**成对的出现**,宿主机一个,namespace 一个

- btrctl 相当与交换机,而 veth 设备 相当于交换机的端口

- veth 设备工作在第二层,因此没有 ip 地址

- 当一方 down 后,链接关闭

  下图为 `ip link | grep veth` 命令的结果,比 `ip a` 更直观
  ![image](./Pictures/kubernetes-docker/cnm1.png)

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

## Dockerfile 创建容器镜像

通过 commit,修改过的容器,创建新的镜像(**不推荐**)

```bash
docker commit CONTAINER_ID tz/opensuse
```

Dockerfile:

- 为了有效利用缓存,尽量将文件相关的命令放在前面

- RUN 命令会让镜像分层,不要担心层数过多,而将命令放在一个 RUN 下

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

在容器里的 linux 使用变量

```docker
FROM alpine

RUN  a="$(date)"
RUN  echo "$a"
```

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

[docker hub 基于 github 自动构建](https://docs.docker.com/docker-hub/builds/link-source/)

## registry

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

## other item(第三方项目)

- [awesome-docker](https://github.com/veggiemonk/awesome-docker)

  > 包含 docker 相关的文档资源和项目

- [pipework](https://github.com/jpetazzo/pipework)

  > 容器自定义网络工具

- [hub-tool](https://github.com/docker/hub-tool)

  > 管理 docker hub 的 cli 工具

- [自动更新 docker 镜像](https://github.com/containrrr/watchtower)

```bash
docker run -d \
    --name watchtower \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower
```

- [cAdvisor](https://github.com/google/cadvisor)
  ![image](./Pictures/kubernetes-docker/cadvisor.png)

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
  ![image](./Pictures/kubernetes-docker/rancher.png)

```bash
docker run -d \
    --restart=unless-stopped \
    -p 80:80 -p 443:443 \
    --privileged \
    rancher/rancher
```

- [docker-ui](https://github.com/kevana/ui-for-docker)
  ![image](./Pictures/kubernetes-docker/ui.png)

```bash
docker run -d -p 9000:9000 \
    --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock \
    uifd/ui-for-docker
```

- [ctop](https://github.com/bcicen/ctop)
  ![image](./Pictures/kubernetes-docker/ctop.png)

```bash
docker run --rm -ti \
    --name=ctop \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    quay.io/vektorlab/ctop:latest
```

- [lazydocker](https://github.com/jesseduffield/lazydocker)
  ![image](./Pictures/kubernetes-docker/lazydocker.png)

## reference article(优秀文章)

- [docker 官方文档](https://docs.docker.com/engine/reference/run/)

- [docker 从入门到实践](https://github.com/yeasy/docker_practice)

- [docker-cheat-sheet](https://github.com/wsargent/docker-cheat-sheet)

- [Dockerfile 安全最佳实践](https://cloudberry.engineering/article/dockerfile-security-best-practices/)

- [gvistor 对比普通容器和 aliuk](https://mp.weixin.qq.com/s?src=11&timestamp=1613134736&ver=2886&signature=6e*T4ylvJCA--fGa-tb*ttJq3JArF7z-Wzs5eAPzlY813SG154AK1YyEgLv2MQSiIgP-pWSXHI2l*Fwri21PvvVMnlRoFkCEoiew-uvj8AFuYyM*dD5l83dQ2G5TriVb&new=1)

# Kubernetes 是希腊语中的船长(captain)

## 第三方软件资源

- [minikube 单机运行k8s集群](https://github.com/kubernetes/minikube)

- [pixie 性能监控](https://github.com/pixie-io/pixie)

- [kubesphere](https://github.com/kubesphere/kubesphere)

- [kube-shell](https://github.com/cloudnativelabs/kube-shell)

- [lazykube](https://github.com/TNK-Studio/lazykube)

- [lazykube 替换墙外镜像的下载地址](https://github.com/joyme123/lazykube)

- [helm 包管理器](https://github.com/helm/helm)

- [k0s](https://github.com/k0sproject/k0s)
  > k0s 是一个包含所有功能的单一二进制 Kubernetes 发行版，它预先配置了所有所需的 bell 和 whistle，使构建 Kubernetes 集群只需将可执行文件复制到每个主机并运行它即可。

## 优秀文章

- [Kubernetes纪录片](https://www.bilibili.com/video/BV13q4y1h7QR)

- [图解儿童 Kubernetes 指南](https://www.cncf.io/the-childrens-illustrated-guide-to-kubernetes/)
- [关于 kubernetes 失败的故事](https://k8s.af/)

- [Unikernel(VM 容器融合技术),或许是下一代云技术](https://zhuanlan.zhihu.com/p/29053035)

- 目前可以使用 linuxkit 进行构建

- [mirageos](https://mirage.io/)

- [gvistor](https://mp.weixin.qq.com/s?src=11&timestamp=1613136113&ver=2886&signature=6e*T4ylvJCA--fGa-tb*ttJq3JArF7z-Wzs5eAPzlY813SG154AK1YyEgLv2MQSi7BUW8muQyHQnOl3arAu2m9qK8bCk2fgGLOv4-VYvAyWDfMUcBrvB8oZ9csaoQ-aI&new=1)

# [rust重写的云原生的项目](https://rust-cloud-native.github.io/)


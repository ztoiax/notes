<!-- vim-markdown-toc GFM -->

* [LNMP](#lnmp)
* [nginx](#nginx)
    * [安装nginx](#安装nginx)
        * [源码安装](#源码安装)
        * [yum安装](#yum安装)
        * [安装第三方模块，以echo模块为例子](#安装第三方模块以echo模块为例子)
        * [Nginx版本热升级](#nginx版本热升级)
    * [基本命令](#基本命令)
    * [架构](#架构)
        * [master进程](#master进程)
        * [worker进程](#worker进程)
        * [模块](#模块)
    * [基本配置](#基本配置)
        * [main块配置](#main块配置)
            * [worker配置](#worker配置)
        * [events块配置](#events块配置)
        * [http块配置](#http块配置)
            * [压缩](#压缩)
                * [gzip压缩](#gzip压缩)
                * [Brotli压缩](#brotli压缩)
        * [server块配置](#server块配置)
            * [server_name、location、root、alias、listen](#server_namelocationrootaliaslisten)
            * [重写规则。比较 return、rewrite 和 try_files 指令](#重写规则比较-returnrewrite-和-try_files-指令)
                * [break指令：不再匹配后面的重写规则](#break指令不再匹配后面的重写规则)
                * [例子：如果客户端请求的文件不存在，NGINX 会提供默认的 GIF 文件](#例子如果客户端请求的文件不存在nginx-会提供默认的-gif-文件)
                * [例子：将所有流量重定向到正确的域名](#例子将所有流量重定向到正确的域名)
                * [例子：强制所有请求使用 SSL/TLS](#例子强制所有请求使用-ssltls)
                * [例子：为 WordPress 网站启用 Pretty Permalinks](#例子为-wordpress-网站启用-pretty-permalinks)
                * [例子：丢弃对不支持的文件扩展名的请求](#例子丢弃对不支持的文件扩展名的请求)
                * [例子：配置自定义重路由](#例子配置自定义重路由)
            * [if指令](#if指令)
            * [set指令：设置变量](#set指令设置变量)
            * [aio（异步io）](#aio异步io)
        * [内置变量](#内置变量)
        * [正向代理和反向代理](#正向代理和反向代理)
            * [proxy相关指令](#proxy相关指令)
        * [静态页面](#静态页面)
        * [tomcat](#tomcat)
            * [安装（不需要编译，解压后mv到指定目录即可）](#安装不需要编译解压后mv到指定目录即可)
            * [nginx配置tomcat](#nginx配置tomcat)
            * [后台管理配置](#后台管理配置)
            * [性能优化](#性能优化)
                * [connector（连接器）和I/O模型](#connector连接器和io模型)
                * [线程池的并发调优](#线程池的并发调优)
                * [SpringBoot中调整Tomcat参数](#springboot中调整tomcat参数)
                * [监控Tomcat的性能](#监控tomcat的性能)
                    * [通过 JConsole 监控 Tomcat](#通过-jconsole-监控-tomcat)
                    * [命令行查看 Tomcat 指标](#命令行查看-tomcat-指标)
            * [zrlog使用java开发的博客](#zrlog使用java开发的博客)
                * [nginx 反向代理 zrlog](#nginx-反向代理-zrlog)
        * [php-fpm](#php-fpm)
            * [nginx配置fastcgi](#nginx配置fastcgi)
        * [cgit](#cgit)
        * [负载均衡](#负载均衡)
            * [stream：4层负载均衡](#stream4层负载均衡)
            * [upstream：7层负载均衡](#upstream7层负载均衡)
            * [7层负载均衡策略](#7层负载均衡策略)
            * [7层负载均衡基本配置](#7层负载均衡基本配置)
            * [多tomcat的7层负载均衡](#多tomcat的7层负载均衡)
        * [缓存](#缓存)
            * [服务端缓存](#服务端缓存)
                * [配置缓存](#配置缓存)
                    * [缓存相关指令](#缓存相关指令)
                    * [缓存配置综合例子](#缓存配置综合例子)
                    * [例子：配置缓存](#例子配置缓存)
                    * [例子：负载均衡配置缓存](#例子负载均衡配置缓存)
        * [https](#https)
            * [bugstack虫洞栈：爽了！免费的SSL，还能自动续期！??失败了](#bugstack虫洞栈爽了免费的ssl还能自动续期失败了)
            * [使用acme.sh生成证书。??失败了](#使用acmesh生成证书失败了)
            * [httpsok： 一行命令，轻松搞定SSL证书自动续期。??失败了](#httpsok-一行命令轻松搞定ssl证书自动续期失败了)
            * [ssltest：验证tls，并且有评分](#ssltest验证tls并且有评分)
            * [http2](#http2)
            * [http3](#http3)
            * [websocket](#websocket)
        * [autoindex模块： 用户请求以 `/` 结尾时，列出目录结构，可以用于快速搭建静态资源下载网站。](#autoindex模块-用户请求以--结尾时列出目录结构可以用于快速搭建静态资源下载网站)
        * [配置跨域 CORS](#配置跨域-cors)
        * [跨域请求头部配置](#跨域请求头部配置)
        * [图片防盗链](#图片防盗链)
        * [适配 PC 或移动设备](#适配-pc-或移动设备)
        * [单页面项目history路由配置](#单页面项目history路由配置)
    * [log (日志)](#log-日志)
        * [access log:](#access-log)
        * [开启gzip日志](#开启gzip日志)
        * [linux命令统计日志](#linux命令统计日志)
        * [日志切割](#日志切割)
        * [error log](#error-log)
        * [open_log_file_cache 日志缓存](#open_log_file_cache-日志缓存)
    * [第三方模块](#第三方模块)
        * [echo模块：可以 echo 变量](#echo模块可以-echo-变量)
        * [开发第三方模块](#开发第三方模块)
    * [管理](#管理)
        * [auth_basic模块：对访问资源加密，需要用户权限认证](#auth_basic模块对访问资源加密需要用户权限认证)
        * [Stub Status模块：输出nginx的基本状态信息指标。](#stub-status模块输出nginx的基本状态信息指标)
        * [请求过滤](#请求过滤)
            * [根据请求类型过滤](#根据请求类型过滤)
            * [根据状态码过滤](#根据状态码过滤)
            * [根据 URL 名称过滤](#根据-url-名称过滤)
        * [对 ua 进行限制](#对-ua-进行限制)
        * [http方法和ip访问控制](#http方法和ip访问控制)
        * [请求限制：限制同一IP的连接数和并发数](#请求限制限制同一ip的连接数和并发数)
            * [limit_conn_module模块：限制连接数](#limit_conn_module模块限制连接数)
            * [limit_req_module模块：限制并发的连接数](#limit_req_module模块限制并发的连接数)
        * [limit_rate模块：限制客户端响应传输速率](#limit_rate模块限制客户端响应传输速率)
    * [常见错误与性能优化](#常见错误与性能优化)
        * [每个 worker 没有足够的文件描述符：](#每个-worker-没有足够的文件描述符)
        * [未启用与上游服务器的 keepalive 连接](#未启用与上游服务器的-keepalive-连接)
        * [假定只有一台服务器（因此没有必要使用`upstream`负载均衡命令）。然而`upstream`可以提升性能](#假定只有一台服务器因此没有必要使用upstream负载均衡命令然而upstream可以提升性能)
        * [NGINX 默认启用代理缓冲（`proxy_buffering off` 指令）](#nginx-默认启用代理缓冲proxy_buffering-off-指令)
        * [过多的健康检查](#过多的健康检查)
    * [第三方软件](#第三方软件)
        * [服务端](#服务端)
            * [njs：是 JavaScript 语言的一个子集，它允许扩展 nginx 的功能](#njs是-javascript-语言的一个子集它允许扩展-nginx-的功能)
        * [客户端](#客户端)
            * [ngxtop 日志监控](#ngxtop-日志监控)
            * [goaccess 日志监控](#goaccess-日志监控)
            * [rhit:日志浏览器](#rhit日志浏览器)
    * [在线工具](#在线工具)
    * [第三方nginx](#第三方nginx)
        * [Openresty](#openresty)
        * [tengine](#tengine)
        * [Kong](#kong)
    * [reference](#reference)

<!-- vim-markdown-toc -->

# LNMP

- [LNMP 一键安装包](https://github.com/licess/lnmp)

- [DNMP(docker) 一键安装包](https://github.com/yeszao/dnmp)

- [不同 web 服务器份额](https://news.netcraft.com/archives/2020/10/21/october-2020-web-server-survey.html)

# [nginx](http://nginx.org/en/docs/)

- [技术蛋老师：Nginx入门必须懂3大功能配置 - Web服务器/反向代理/负载均衡](https://www.bilibili.com/video/BV1TZ421b7SD)

## [安装nginx](http://nginx.org/en/linux_packages.html)

### 源码安装

- [源码下载（官网）](https://nginx.org/download/)
- [源码下载(搜狗镜像)](http://mirrors.sohu.com/nginx/?C=M&O=D)

```sh
# 下载源码
curl -LO http://mirrors.sohu.com/nginx/nginx-1.25.3.tar.gz
tar -xzvf nginx-1.25.3.tar.gz
cd nginx-1.25.3

# 配置检查
./configure

# 发现有报错。检查中发现一些依赖库没有找到，这时候需要先安装 nginx 的一些依赖库
yum -y install pcre* #安装使nginx支持rewrite
yum -y install gcc-c++
yum -y install zlib*
yum -y install openssl openssl-devel

# 再次进行检查操作 ./configure 没发现报错显示，接下来进行编译并安装的操作。
# 查看configure参数的官网http://nginx.org/en/docs/configure.html
# 检查模块支持
./configure --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_auth_request_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_degradation_module \
    --with-http_slice_module \
    --with-http_stub_status_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_realip_module \
    --with-stream_ssl_preread_module \
    --with-threads \
    --with-file-aio \
    --with-stream  \

# 可以自定义是否以www用户启动。如果设置了以下选项，则需要新建www用户，不然启动nginx时会报错：nginx: [emerg] getpwnam("www") failed
./configure --prefix=/usr/local/nginx \
    --user=www \
    --group=www
# 新建www用户（如果添加了以上选项则）
useradd www

# auto 目录中有一个 options 文件，这个文件里面保存的就是 nginx 编译过程中的所有选项配置。
grep YES auto/options

# 编译。make后的nginx二进制文件在objs目录
make -j$(nproc)
# 安装。会生成/usr/local/nginx 目录
make install

# 查看 nginx 安装后在的目录，可以看到已经安装到 /usr/local/nginx 目录
whereis nginx
nginx: /etc/nginx /usr/local/nginx /usr/share/man/man8/nginx.8.gz

# 启动nginx
/usr/local/nginx/sbin/nginx

# 添加PATH路径
export PATH=$PATH:/usr/local/nginx/sbin

# 或者。创建硬连接
sudo ln /usr/local/nginx/sbin/nginx /bin/nginx
```

### yum安装

- 安装nginx前的准备工作
```sh
# 安装pcre库
yum install -y pcre-devel zlib-devel
yum install -y yum-utils
```

- 两种方法使用yum安装nginx

    - 1.配置epel仓库

    - 2.配置nginx官方仓库

        ```sh
        cat > /etc/yum.repos.d/nginx.repo << EOF
        [nginx-stable]
        name=nginx stable repo
        baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
        gpgcheck=1
        enabled=1
        gpgkey=https://nginx.org/keys/nginx_signing.key
        module_hotfixes=true

        [nginx-mainline]
        name=nginx mainline repo
        baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
        gpgcheck=1
        enabled=0
        gpgkey=https://nginx.org/keys/nginx_signing.key
        module_hotfixes=true
        EOF

        # 默认安装stable的nginx。如果需要mainline版则执行
        yum-config-manager --enable nginx-mainline

        # 安装nginx
        yum install -y nginx
        ```

- 安装nginx后

    ```sh
    # 关闭selinux系统安全规则
    setenforce 0

    # 开启防火墙80端口对外允许访问
    firewalld-cmd --add-port=80/tcp --permanent
    systemctl restart firewalld.service
    ```

### 安装第三方模块，以echo模块为例子
<span id="echo"></span>

```sh
# 下载最新的稳定版1.18(使用搜狗镜像)
wget http://mirrors.sohu.com/nginx/nginx-1.18.0.tar.gz
tar xvzf nginx-1.18.0.tar.gz
cd nginx-1.18.0

# 新建一个module目录
mkdir module
cd module

# 安装echo模块(由国人章亦春开发)
git clone https://github.com/openresty/echo-nginx-module.git module/echo-nginx-module
# 国内下载地址
git clone https://gitee.com/mirrors/echo-nginx-module.git module/echo-nginx-module

# 模块
# ssl
--with-http_ssl_module
# regex正则表达式
--with-pcre
# 状态页面
--with-http_stub_status_module

# 设置安装目录 和 安装模块
./configure --prefix=/usr/local/nginx \
    --add-module=./module/echo-nginx-module \
    --with-http_ssl_module \
    --with-pcre \
    --with-http_stub_status_module \
    --with-debug

# 编译
make -j$(nproc)
# 安装。会生成/usr/local/nginx 目录
make install

# 设置硬连接到 /bin 目录
sudo ln /usr/local/nginx/sbin/nginx /bin/nginx

# 启动nginx
sudo nginx
```

生成的 `ngx_modules.c` 文件里的 `mgx_modules` 数组表示 nginx 每个模块的优先级,对于`HTTP过滤模块`则相反，越后越优先

### Nginx版本热升级

- [Se7en的架构笔记：Nginx 平滑升级](https://mp.weixin.qq.com/s/zvcZ6uihFPi_xlA33z9vug)

- 然而线上业务大多是 7*24 小时不间断运行的，我们需要在升级的时候保证不影响在线用户的访问。Nginx 的热升级功能可以解决上述问题，它允许新老版本灰度地平滑过渡，这受益于 Nginx 的多进程架构。

- 热升级-程序热更

    ![image](./Pictures/nginx/nginx架构-master进程-热升级.avif)

    - 具体流程如下：
        - 1.将旧Nginx文件换成新Nginx文件（注意备份旧的nginx二进制文件，配置文件）
        - 2.向master(old)进程发送USR2信号，为了新的 Master 使用 pid.bin 这个文件名，master(old)会把老的 pid 文件改为 pid.oldbin。
        - 3.master进程用新Nginx文件启动master(new)进程。到现在为止，会出现两个 Master 进程：Master(Old) 和 Master (New)
            - 这里新的 Master (New) 进程是怎么样启动的呢？它其实是老的 Master(Old) 进程的子进程，不过这个子进程是使用了新的 binary 文件带入来启动的。

        - 4.向master(old)发送WINCH信号，关闭旧worker进程，观察新worker进程工作情况。
            - 若升级成功，则向老master进程发送QUIT信号，关闭老master进程
            - 若升级失败，则需要回滚，向老master发送HUP信号（重读配置文件），向新master发送QUIT信号，关闭新master及worker。

            - 在一个父进程退出，而它的一个或多个子进程还在运行时，那么这些子进程将成为孤儿进程。孤儿进程将被 init 进程(进程号为1)所收养，并由 init 进程对它们完成状态收集工作。所以老 Master(Old) 进程退出后，新的 Master(Old) 进程并不会退出。

    - 如果想回滚，就需要再走一次热升级流程，用备份好的老 Nginx 文件作为新的热升级文件（因此建议备份旧的 Nginx 文件）。

- 热升级主要用到了 USR2 和 WINCH/QUIT 信号。
    ![image](./Pictures/nginx/nginx热升级用到的信号.avif)

- 1.备份：直接备份整个目录（包括nginx二进制运行文件），可以剔除日志文件不备份

    ```sh
    # 打包压缩
    tar -zcvf nginx1.11.1.tar-gz nginx1.11.1/
    ```

- 2.查看原有的 nginx 编译参数。如--prefix
    ```sh
    ./nginx -V
    ```

- 3.对新版本的源码包进行编译

    ```sh
    ./configure --prefix=

    # make完之后就不要再make install，没有必要，如果make install，但--prefix又没改路径，那就gg了，覆盖了原来的安装环境，所以备份也很重要
    make
    # 或者使用全部cpu线程编译
    make -j$(nproc)
    ```

- 4.复制新的nginx源码包中二进制文件，覆盖原来的文件

    ```sh
    # make后的nginx二进制文件在objs目录
    cd objs

    # 覆盖原来的文件
    cp nginx /bin/nginx
    ```

- 5.最关键的步骤：
    - 通过 kill 命令向老 master 进程发送 USR2 信号，让老 master 生成新的子进程（新 master 进程），同时用 exec 函数载入新版本的 Nginx 二进制文件。
        - 新 master 进程和新 worker 进程会继承老 master 进程的资源，因此它们也能监听 80 端口。
    ```sh
    # 新编译的 nginx, 替换旧 nginx(生成/usr/local/nginx/logs/nginx.pid.oldbin)
    kill -s SIGUSR2 <nginx master pid>
    # ps 查看 新旧两个版本的 nginx 都在运行
    ps -ef | grep nginx
    ```

- 6.向老 master 进程发送 QUIT 信号，当它的 worker 子进程退出后，老 master 进程也会自行退出。

    ```sh
    # kill掉旧版本
    kill -s SIGQUIT <nginx master old pid>
    ```

- 7.验证nginx升级是否成功

    ```sh
    # 查看nginx版本
    ./nginx -v
    ```

- 回滚
    - 通过上述方式升级以后，只保留了新的 master 进程，这时如果需要从新版本回滚到老版本，就得重新执行一次“升级”。

## 基本命令

```sh
# 查看当前 Nginx 最终的配置
nginx -T

# 备份配置
nginx -T > /tmp/nginx.conf.bak

# -t 检查配置是否正确
nginx -t

# -c 指定加载配置文件
nginx -c  /etc/nginx/nginx.conf

# 检查配置是否有问题，如果已经在配置目录，则不需要 -c
nginx -t -c <配置路径>

# -v 查看版本
nginx -v

# -V 查看预编译的参数。
nginx -V

# -qt 静默模式测试nginx，如果测试成功，不返回测试结果
nginx -qt

# -g 执行全局命令。不可与配置文件中的指令重复
# 关闭后台运行
nginx -g "daemon off;"
```

- `-s` 发送signal (类似于systemctl)

    - master进程支持的信号

        | 信号      | 说明                                                                                        |
        |-----------|---------------------------------------------------------------------------------------------|
        | TERM，INT | 立刻退出，相当于 nginx -s stop。                                                            |
        | QUIT      | 等待工作进程结束后再退出，优雅地退出，相当于 nginx -s quit。                                |
        | HUP       | 重新加载配置文件，使用新的配置启动工作进程，并逐步关闭旧进程。相当于 nginx -s reload 命令。 |
        | USR1      | 重新打开日志文件，相当于 nginx -s reopen。                                                  |
        | USR2      | 启动新的主进程，实现热升级。                                                                |
        | WINCH     | 逐步关闭工作进程                                                                            |

    - worker进程支持的信号

        | 信号      | 说明                     |
        |-----------|--------------------------|
        | TERM，INT | 立刻退出                 |
        | QUIT      | 等待请求处理结束后再退出 |
        | USR1      | 重新打开日志文件         |

```sh
# 关闭(立即退出)
nginx -s stop
kill -s SIGINT <nginx master pid>
kill -s SIGTERM <nginx master pid>

# 退出(完成当前连接,关闭监听端口,停止接受新连接后退出)
nginx -s quit
kill -s SIGQUIT <nginx master pid>

# 重新加载配置文件
nginx -s reload
kill -s SIGHUP <nginx master pid>

# 重新打开日志文件
nginx -s reopen
kill -s SIGUSR1 <nginx master pid>

# 关闭某个 worker 进程
kill -s SIGWINCH <nginx worker pid>

# 新编译的 nginx, 替换旧 nginx(生成/usr/local/nginx/logs/nginx.pid.oldbin)
kill -s SIGUSR2 <nginx master pid>
# ps 查看 新旧两个版本的 nginx 都在运行 (kill掉旧版本)
kill -s SIGQUIT <nginx master old pid>
```

- systemd 关于 nginx 的常用命令：

```sh
systemctl start nginx    # 启动 Nginx
systemctl stop nginx     # 停止 Nginx
systemctl restart nginx  # 重启 Nginx
systemctl reload nginx   # 重新加载 Nginx，用于修改配置后
systemctl enable nginx   # 设置开机启动 Nginx
systemctl disable nginx  # 关闭开机启动 Nginx
systemctl status nginx   # 查看 Nginx 运行状态
```

## 架构

- [腾讯云开发者：一文看懂Nginx架构](https://mp.weixin.qq.com/s/o_OlJJdUz-t7znqXvIXwqg)

- Nginx由内核和一系列模块组成，内核提供web服务的基本功能，如启用网络协议，创建运行环境，接收和分配客户端请求，处理模块之间的交互。

    - Nginx的各种功能和操作都由模块来实现。Nginx的模块从结构上分为核心模块、基础模块和第三方模块。

    - 这样的设计使Nginx方便开发和扩展，也正因此才使得Nginx功能如此强大。

- nginx进程模型

    - Master进程：负责管理worker进程：Master 进程用于接收来自外界的信号，并向各 Worker 进程发送信号，同时监控 Worker 进程的工作状态。当 Worker 进程退出后(异常情况下)，Master 进程也会自动重新启动新的 Worker 进程。

    - worker进程：负责处理网络事件。

        - 多个 Worker 进程之间是对等的，他们同等竞争来自客户端的请求，各进程互相之间是独立的。一个请求，只可能在一个 Worker 进程中处理，一个 Worker 进程不可能处理其它进程的请求。

    - 缓存加载器进程（Cache Loader ）：Nginx服务启动一段时间后由主进程生成，在缓存元数据重建完成后就自动退出。

    - 缓存管理器进程（Cache Manager）：一般存在于主进程的整个生命周期，负责对缓存索引进行管理。通过缓存机制，可以提高对请求的响应效率，进一步降低网络压力。

    - 所有的进程的都是单线程（即只有一个主线程）的，进程之间通信主要是通过共享内存机制实现的。

    - 整个框架被设计为一种依赖事件驱动、异步、非阻塞的模式。

    - 优点：
        - 可以充分利用多核机器，增强并发处理能力。
        - 多worker间可以实现负载均衡。
        - Master监控并统一管理worker行为。在worker异常后，可以主动拉起worker进程，从而提升了系统的可靠性。并且由Master进程控制服务运行中的程序升级、配置项修改等操作，从而增强了整体的动态可扩展与热更的能力。

    ![image](./Pictures/nginx/nginx架构.avif)

- 为什么不采用多线程模型管理连接？
    - 无状态服务，无需共享进程内存
    - 采用独立的进程，可以让互相之间不会影响。一个进程异常崩溃，其他进程的服务不会中断，提升了架构的可靠性。
    - 进程之间不共享资源，不需要加锁，所以省掉了锁带来的开销。

- 为什么不采用多线程处理逻辑业务？
    - 进程数已经等于核心数，再新建线程处理任务，只会抢占现有进程，增加切换代价。
    - 作为接入层，基本上都是数据转发业务，网络IO任务的等待耗时部分，已经被处理为非阻塞/全异步/事件驱动模式，在没有更多CPU的情况下，再利用多线程处理，意义不大。并且如果进程中有阻塞的处理逻辑，应该由各个业务进行解决，比如openResty中利用了Lua协程，对阻塞业务进行了优化。

### master进程

- Master进程的主逻辑在ngx_master_process_cycle，核心关注源码：

    ```c
    ngx_master_process_cycle(ngx_cycle_t *cycle)
    {
        ...
        ngx_start_worker_processes(cycle, ccf->worker_processes,
                                            NGX_PROCESS_RESPAWN);
        ...


        for ( ;; ) {
            if (delay) {...}

            ngx_log_debug0(NGX_LOG_DEBUG_EVENT, cycle->log, 0, "sigsuspend");
            sigsuspend(&set);

            ngx_time_update();

            ngx_log_debug1(NGX_LOG_DEBUG_EVENT, cycle->log, 0,
                                 "wake up, sigio %i", sigio);

            if (ngx_reap) {
                ngx_reap = 0;
                ngx_log_debug0(NGX_LOG_DEBUG_EVENT, cycle->log, 0, "reap children");
                live = ngx_reap_children(cycle);
            }

            if (!live && (ngx_terminate || ngx_quit)) {...}

            if (ngx_terminate) {...}

            if (ngx_quit) {...}

            if (ngx_reconfigure) {...}

            if (ngx_restart) {...}

            if (ngx_reopen) {...}

            if (ngx_change_binary) {...}

            if (ngx_noaccept) {
                ngx_noaccept = 0;
                ngx_noaccepting = 1;
                ngx_signal_worker_processes(cycle,

    ngx_signal_value(NGX_SHUTDOWN_SIGNAL));
            }
        }
     }
    ```

- 具体包括如下4个主要功能：

    - 1.接受来自外界的信号。其中master循环中的各项标志位就对应着各种信号，如：ngx_quit代表QUIT信号，表示优雅的关闭整个服务。

    - 2.向各个worker进程发送信。比如ngx_noaccept代表WINCH信号，表示所有子进程不再接受处理新的连接，由master向所有的子进程发送QUIT信号量。

    - 3.监控worker进程的运行状态。比如ngx_reap代表CHILD信号，表示有子进程意外结束，这时需要监控所有子进程的运行状态，主要由ngx_reap_children完成。

    - 4.当woker进程退出后（异常情况下），会自动重新启动新的woker进程。主要也是在ngx_reap_children。

- 热更

    - 1.热重载-配置热更

        ![image](./Pictures/nginx/nginx架构-master进程-热重载.avif)

        - 具体流程如下：
            - 更新nginx.conf配置文件，向master发送SIGHUP信号（`kill -s SIGHUP <nginx master pid>`
）或执行`nginx -s reload`
            - Master进程使用新配置，启动新的worker进程，并向所有老的 Worker 进程发送信号，告诉他们可以光荣退休了。
            - 新的 Worker 在启动后，就开始接收新的请求，而老的 Worker 在收到来自 Master 的信号后就不再接收新的请求，并且在当前进程中的所有未处理完的请求处理完成后再退出。

### worker进程

- Worker进程的主逻辑在ngx_worker_process_cycle，核心关注源码：

    ```c
    ngx_worker_process_cycle(ngx_cycle_t *cycle, void *data)
    {
        ngx_int_t worker = (intptr_t) data;


        ngx_process = NGX_PROCESS_WORKER;
        ngx_worker = worker;


        ngx_worker_process_init(cycle, worker);


        ngx_setproctitle("worker process");


        for ( ;; ) {


            if (ngx_exiting) {...}


            ngx_log_debug0(NGX_LOG_DEBUG_EVENT, cycle->log, 0, "worker cycle");


            ngx_process_events_and_timers(cycle);


            if (ngx_terminate) {...}


            if (ngx_quit) {...}


            if (ngx_reopen) {...}
        }
    }
    ```

- worker进程主要在处理网络事件，通过`ngx_process_events_and_timers`方法实现，其中事件主要包括：网络事件、定时器事件。

- Worker进程在处理网络事件时，依靠epoll模型，来管理并发连接，实现了事件驱动、异步、非阻塞等特性。

    - 通常海量并发连接过程中，每一时刻（相对较短的一段时间），往往只需要处理一小部分有事件的连接即活跃连接。

- 每个 Worker 进程都是从 Master 进程fork过来，在 Master 进程里面，先建立好需要 listen 的 socket（listenfd）之后，然后再 fork 出多个 Worker 进程。

    - 所有 Worker 进程的 listenfd 会在新连接到来时变得可读，为保证只有一个进程处理该连接（也就是惊群问题），所有 Worker 进程在注册 listenfd 读事件前抢互斥锁accept_mutex，抢到互斥锁的那个进程注册 listenfd 读事件，在读事件里调用 accept 接受该连接。

    - 一个 Worker 进程在 accept 这个连接之后，就开始读取、解析、处理请求，在产生数据后再返回给客户端，最后才断开连接，这样一个完整的请求就是这样的了。我们可以看到，一个请求完全由 Worker 进程来处理，而且只在一个 Worker 进程中处理。

    ```c
    void ngx_process_events_and_timers(ngx_cycle_t *cycle){
        //这里面会对监听socket处理
        ...

        if (ngx_accept_disabled > 0) {
                ngx_accept_disabled--;
        } else {
            //获得锁则加入wait集合,
            if (ngx_trylock_accept_mutex(cycle) == NGX_ERROR) {
                return;
            }
            ...
            //设置网络读写事件延迟处理标志，即在释放锁后处理
            if (ngx_accept_mutex_held) {
                flags |= NGX_POST_EVENTS;
            }
        }
        ...
        //这里面epollwait等待网络事件
        //网络连接事件，放入ngx_posted_accept_events队列
        //网络读写事件，放入ngx_posted_events队列
        (void) ngx_process_events(cycle, timer, flags);
        ...
        //先处理网络连接事件，只有获取到锁，这里才会有连接事件
        ngx_event_process_posted(cycle, &ngx_posted_accept_events);
        //释放锁，让其他进程也能够拿到
        if (ngx_accept_mutex_held) {
            ngx_shmtx_unlock(&ngx_accept_mutex);
        }
        //处理网络读写事件
        ngx_event_process_posted(cycle, &ngx_posted_events);
    }
    ```

- 负载均衡

    - Worker间的负载关键在于各自接入了多少连接，其中接入连接抢锁的前置条件是`ngx_accept_disabled > 0`
        - 所以ngx_accept_disabled就是负载均衡机制实现的关键阈值。

        ```nginx
        ngx_int_t             ngx_accept_disabled;
        ngx_accept_disabled = ngx_cycle->connection_n / 8 - ngx_cycle->free_connection_n;
        ```

    - 因此，在nginx启动时，ngx_accept_disabled的值就是一个负数，其值为连接总数的7/8。当该进程的连接数达到总连接数的7/8时，该进程就不会再处理新的连接了。

    - 同时每次调用`ngx_process_events_and_timers`时，将ngx_accept_disabled减1，直到其值低于阈值时，才试图重新处理新的连接。

    - 因此，nginx各worker子进程间的负载均衡仅在某个worker进程处理的连接数达到它最大处理总数的7/8时才会触发，其负载均衡并不是在任意条件都满足。

### 模块

- 大量的第三方模块，质量参差不齐，它们严重依赖NGINX的API。NGINX是20年前的软件，当时的服务器架构跟如今已经不可同日而语。软件需要进化，就要做重构，但是API不能轻易改。关注NGINX社区的人知道，Igor亲自设计了另一个跟NGINX不同的软件Unit，这软件不会再支持模块化了，这是他们的选择。

- 每个模块就是一个功能模块，只负责自身的功能，模块之间严格遵循“高内聚，低耦合”的原则。

- 模块从结构上分为：
    - 核心模块：nginx 最基本最核心的服务，如进程管理、权限控制、日志记录
    - 基础模块nginx 服务器的标准 HTTP 功能
    - 可选 HTTP 模块：处理特殊的 HTTP 请求
    - 邮件服务模块：邮件服务
    - 第三方模块： HTTP Upstream Request Hash模块、Notice模块和HTTP Access Key模块

- 模块从功能上还可以分为以下几种：

    - Handlers（处理器模块）：此类模块直接处理请求，并进行输出内容和修改 headers 信息等操作。
        - Handlers 处理器模块一般只能有一个。

    - Filters（过滤器模块）：此类模块主要对其他处理器模块输出的内容进行修改操作，最后由 Nginx 输出。

    - Proxies（代理类模块）：此类模块是 Nginx 的 HTTP Upstream 之类的模块，这些模块主要与后端一些服务比如FastCGI 等进行交互，实现服务代理和负载均衡等功能。

    - Nginx（内核）本身做的工作实际很少，当它接到一个 HTTP 请求时，它仅仅是通过查找配置文件将此次请求映射到一个 location block，而此 location 中所配置的各个指令则会启动不同的模块去完成工作，因此模块可以看做 Nginx 真正的劳动工作者。

        ![image](./Pictures/nginx/nginx工作原理.avif)

        - 通常一个 location 中的指令会涉及一个 Handler 模块和多个 Filter 模块（当然，多个location可以复用同一个模块）。
        - Handler模块负责处理请求，完成响应内容的生成，而 Filter 模块对响应内容进行处理。

| 核心模块       |
|----------------|
| ngx_core       |
| ngx_errlog     |
| ngx_conf       |
| ngx_events     |
| ngx_event_core |
| ngx_epll       |
| ngx_regex      |


| 基础 HTTP 模块                                                                                                           |
|--------------------------------------------------------------------------------------------------------------------------|
| ngx_http                                                                                                                 |
| ngx_http_core #配置端口，URI 分析，服务器相应错误处理，别名控制 (alias) 等                                               |
| ngx_http_log #自定义 access 日志                                                                                         |
| ngx_http_upstream #定义一组服务器，可以接受来自 proxy                                                                    | Fastcgi | Memcache 的重定向；主要用作负载均衡 |
| ngx_http_static                                                                                                          |
| ngx_http_autoindex #自动生成目录列表                                                                                     |
| ngx_http_index #处理以/结尾的请求，如果没有找到 index 页，则看是否开启了 random_index；如开启，则用之，否则用 autoindex |
| ngx_http_auth_basic #基于 http 的身份认证 (auth_basic)                                                                   |
| ngx_http_access #基于 IP 地址的访问控制 (deny                                                                            | allow)  |
| ngx_http_limit_conn #限制来自客户端的连接的响应和处理速率                                                                |
| ngx_http_limit_req #限制来自客户端的请求的响应和处理速率                                                                 |
| ngx_http_geo                                                                                                             |
| ngx_http_map #创建任意的键值对变量                                                                                       |
| ngx_http_split_clients                                                                                                   |
| ngx_http_referer #过滤 HTTP 头中 Referer 为空的对象                                                                      |
| ngx_http_rewrite #通过正则表达式重定向请求                                                                               |
| ngx_http_proxy                                                                                                           |
| ngx_http_fastcgi #支持 fastcgi                                                                                           |
| ngx_http_uwsgi                                                                                                           |
| ngx_http_scgi                                                                                                            |
| ngx_http_memcached                                                                                                       |
| ngx_http_empty_gif #从内存创建一个 1×1 的透明 gif 图片，可以快速调用                                                     |
| ngx_http_browser #解析 http 请求头部的 User-Agent 值                                                                     |
| ngx_http_charset #指定网页编码                                                                                           |
| ngx_http_upstream_ip_hash                                                                                                |
| ngx_http_upstream_least_conn                                                                                             |
| ngx_http_upstream_keepalive                                                                                              |
| ngx_http_write_filter                                                                                                    |
| ngx_http_header_filter                                                                                                   |
| ngx_http_chunked_filter                                                                                                  |
| ngx_http_range_header                                                                                                    |
| ngx_http_gzip_filter                                                                                                     |
| ngx_http_postpone_filter                                                                                                 |
| ngx_http_ssi_filter                                                                                                      |
| ngx_http_charset_filter                                                                                                  |
| ngx_http_userid_filter                                                                                                   |
| ngx_http_headers_filter #设置 http 响应头                                                                                |
| ngx_http_copy_filter                                                                                                     |
| ngx_http_range_body_filter                                                                                               |
| ngx_http_not_modified_filter                                                                                             |

| 可选 HTTP 模块                                                                              |
|---------------------------------------------------------------------------------------------|
| ngx_http_addition #在响应请求的页面开始或者结尾添加文本信息                                 |
| ngx_http_degradation #在低内存的情况下允许服务器返回 444 或者 204 错误                      |
| ngx_http_perl                                                                               |
| ngx_http_flv #支持将 Flash 多媒体信息按照流文件传输，可以根据客户端指定的开始位置返回 Flash |
| ngx_http_geoip #支持解析基于 GeoIP 数据库的客户端请求                                       |
| ngx_google_perftools                                                                        |
| ngx_http_gzip #gzip 压缩请求的响应                                                          |
| ngx_http_gzip_static #搜索并使用预压缩的以.gz 为后缀的文件代替一般文件响应客户端请求        |
| ngx_http_image_filter #支持改变 png，jpeg，gif 图片的尺寸和旋转方向                         |
| ngx_http_mp4 #支持.mp4                                                                      | .m4v | .m4a 等多媒体信息按照流文件传输，常与 ngx_http_flv 一起使用 |
| ngx_http_random_index #当收到 / 结尾的请求时，在指定目录下随机选择一个文件作为 index        |
| ngx_http_secure_link #支持对请求链接的有效性检查                                            |
| ngx_http_ssl #支持 https                                                                    |
| ngx_http_stub_status                                                                        |
| ngx_http_sub_module #使用指定的字符串替换响应中的信息                                       |
| ngx_http_dav #支持 HTTP 和 WebDAV 协议中的 PUT/DELETE/MKCOL/COPY/MOVE 方法                  |
| ngx_http_xslt #将 XML 响应信息使用 XSLT 进行转换                                            |

| 邮件服务模块       |
|--------------------|
| ngx_mail_core      |
| ngx_mail_pop3      |
| ngx_mail_imap      |
| ngx_mail_smtp      |
| ngx_mail_auth_http |
| ngx_mail_proxy     |
| ngx_mail_ssl       |

| 第三方模块                                                                          |
|-------------------------------------------------------------------------------------|
| echo-nginx-module #支持在 nginx 配置文件中使用 echo/sleep/time/exec 等类 Shell 命令 |
| memc-nginx-module                                                                   |
| rds-json-nginx-module #使 nginx 支持 json 数据的处理                                |
| lua-nginx-module                                                                    |

## 基本配置

- 配置文件在`/usr/local/nginx/conf/nginx.conf`

- 配置的基本结构

    ```sh
    main        # 全局配置，对全局生效
    ├── events  # 配置影响 nginx 服务器或与用户的网络连接
    ├── http    # 配置代理，缓存，日志定义等绝大多数功能和第三方模块的配置
    │   ├── upstream # 配置后端服务器具体地址，负载均衡配置不可或缺的部分
    │   ├── server   # 配置虚拟主机的相关参数，一个 http 块中可以有多个 server 块
    │   ├── server
    │   │   ├── location  # server 块可以包含多个 location 块，location 指令用于匹配 uri
    │   │   ├── location
    │   │   └── ...
    │   └── ...
    └── ...
    ```

- NGINX 指令是向下继承的；但是，当父上下文及其子上下文中包含相同的指令时，这些值不会相加 —— 相反，子上下文中的值会覆盖父上下文中的值。

    - http{} 上下文中的所有 server{} 和 location{} 块都继承了包含在 http 级别的指令的值
    - server{} 块中的指令被它的所有子 location{} 块继承。

- 配置文件的5个部分：
    - main{}：部分指令影响其他所有设置
    - events{}：指定nginx的工作模式和连接数上限的网络连接
    - http{}：
        - 可以嵌套多个server{}
        - 配置使用最频繁的部分，代理、缓存、日志定义等绝大多数功能和第三方模块。
    - server{}：虚拟主机的相关参数
    - location{}： 配置请求的的处理规则以及各种页面的处理情况

- nginx.conf 配置文件的语法规则
    - 配置文件由指令与指令块构成
    - 每条指令以 “;” 分号结尾，指令与参数间以空格符号分隔
    - 指令块以 {} 大括号将多条指令组织在一起
    - include 语句允许组合多个配置文件以提升可维护性
    - 通过 # 符号添加注释，提高可读性
    - 通过 $ 符号使用变量
    - 部分指令的参数支持正则表达式，例如常用的 location 指令
    - 括号内有其他指令,则称为 context(上下文),如 events, http, server, and location
    - 内层块会继承外层块的设置，如果有冲突以内层块为主
        - 例子：**http 块** 设置 `gzip on` 而 **location 块** 设置 `gzip off` 结果为 **off**

### main块配置

- [官方文档：各种指令解释](http://nginx.org/en/docs/ngx_core_module.html)

```nginx
# 运行用户，默认即是 Nginx，可以不进行设置。这里设置为：用户是 Nginx；组是 lion
user nginx lion;

# master主进程的的 pid 存放在 nginx.pid 的文件。默认值为logs/nginx.pid;
pid logs/nginx.pid;

# 是否后台运行模式。默认值on，
daemon on;

# 是否打开负载均衡互斥锁。默认值为off。这里推荐打开
accept_mutex on;

# nginx使用锁定机制来实现accept_tmutex并串行化对共享内存的访问。默认值logs/nginx.lock;
lock_file logs/nginx.lock;

# Nginx 的错误日志存放目录。默认值为logs/error.log error;
error_log  /var/log/nginx/error.log warn;

# 定义用于多线程读取和发送文件而不阻塞工作进程的线程池的名称和参数
thread_pool default threads=32 max_queue=65536;

# 加载动态模块
# load_module modules/ngx_mail_module.so;

# ssl硬件加速卡，可通过(openssl engine -t查看)
# ssl_engine device;
```

#### worker配置

- Nginx 启动的 worker 子进程数量。一般设置auto

    ```nginx
    # Nginx 启动的 worker 子进程数量
    worker_processes auto; # 默认为1。auto表示等同于cpu线程数-1（这个1为master进程）

    # 4个 worker 子进程
    worker_processes 4;
    worker_cpu_affinity 1000 0100 0010 0001; # 设置亲和性绑定cpu
    ```

    - 开启`worker_processes auto;`后。查看master和worker进程

        ```sh
        # 1个master + 11个worker = 12。我的cpu线程正好12个
        ps aux | grep nginx
        root        3045  0.0  0.0  14040  7536 ?        Ss   21:26   0:00 nginx: master process /usr/local/nginx/sbin/nginx
        www         8680  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        www         8681  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        www         8682  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        www         8683  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        www         8684  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        www         8685  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        www         8686  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        www         8687  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        www         8688  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        www         8689  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        www         8690  0.0  0.0  14476  4304 ?        S    22:44   0:00 nginx: worker process
        www         8691  0.0  0.0  14476  4432 ?        S    22:44   0:00 nginx: worker process
        ```

- 其他worker相关配置

    ```nginx
    # 每个 worker 子进程的最大连接数量（可以打开的最大文件句柄数）。
    worker_rlimit_nofile_number 20480

    # worker 子进程异常终止后的 core 文件
    worker_rlimit_core 50M; # 存放大小限制
    working_directory /opt/nginx/tmp; # 存放目录

    # worker 子进程的 nice 值，以调整运行 Nginx 的优先级，通常设定为负值，以优先调用 Nginx。
    # Linux 默认进程的优先级值是 120，值越小越优先；nice 定范围为 -20 到 +19 。
    worker_priority -10; # 120-10=110，110 就是最终的优先级

    # worker 子进程优雅退出时的超时时间。
    worker_shutdown_timeout 5s;

    # 在 Linux 系统中，用户需要获取计时器时需要向操作系统内核发送请求，有请求就必然会有开销，因此这个间隔越大开销就越小。
    # worker 子进程内部使用的计时器精度，调整时间间隔越大，系统调用越少，有利于性能提升；反之，系统调用越多，性能下降。
    timer_resolution 100ms;
    ```

### events块配置

```nginx
events {
    # Nginx 使用何种事件驱动模型。不推荐配置它，让 Nginx 自己选择。method 可选值为：select、poll、kqueue、epoll、/dev/poll、eventport
    use epoll;

    # worker 子进程能够处理的最大并发连接数。默认值为512
    worker_connections  1024;

    # 尽可能多的接受请求。默认值为off
    multi_accept on;
}
```

### http块配置

- [官方文档：各种指令解释](http://nginx.org/en/docs/http/ngx_http_core_module.html)

- 以下一些指令，除了在http块设置外，也可以在server块和location块设置

```nginx
http {
    # 实现对配置文件所包含的文件的设定
    include mime.types;

    # 引用其他目录的nginx配置
    include /etc/nginx/conf.d/*.conf;

    # 设置日志模式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    # Nginx 访问日志存放位置
    access_log  logs/access/access.log main;

    # on 表示开启零拷贝技术，使用 sendfile() 系统调用传输文件：2 次上下文切换，和 2 次数据拷贝
    # off 使用 read() + write() 传统方式进行传输文件：4 次上下文切换，和 4 次数据拷贝
    sendfile            on;

    # 限制单个sendfile（）调用中可以传输的数据量。默认值2m
    sendfile_max_chunk 2m;

    # 减少网络报文段的数量。在sendfile on后 将响应包头放到一个 TCP 包中发送
    tcp_nopush          on;
    tcp_nodelay         on;


    # 默认值为1000
    keepalive_requests 1000;

    # 请求的最长时间。默认值为1h
    keepalive_time 1h;

    # timeout时间，单位秒。默认值为75s
    keepalive_timeout 75s;

    # 定义MIME类型哈希表中条目的最大大小。
    types_hash_max_size 2048;

    # nginx用哈希表存储服务器名字，设置哈希表的内存大小。默认值512
    server_names_hash_max_size 512;
    # 哈希桶的大小。可选值为 32|64|128
    server_names_hash_bucket_size 128;

    # 这里设定的默认类型为二进制流。也就是当文件类型未定义时使用这种方式。例如在没有配置php环境时，nginx是不予解析的，此时用浏览器访问php文件就会出现下载窗口
    default_type        application/octet-stream;

    # 子请求的缓冲区大小。可选值4k|8k
    subrequest_output_buffer_size 8k;

    # 请求头的大小不能超过8k
    large_client_header_buffers 4 8k;

    # 客户端请求头的缓冲区大小。对于大多数请求1KB就足够了。如果自定义了消息头或有更大的cookie可以设置为32k
    client_header_buffer_size 1k;

    # 客户端请求体的缓冲区大小
    client_body_buffer_size 8k;

    # 客户端请求的最大的单个文件字节数
    client_max_body_size 1m;

    # 可以存储打开了的文件描述符，它们的大小和修改时间。max表示最大数量，溢出时会使用lru算法移除。inactive表示在一定时间内没有访问就移除。默认为（60s）
    open_file_cache          max=1000 inactive=20s;
    open_file_cache_valid    30s;
    open_file_cache_min_uses 2;
    # 启用文件查找错误的缓存
    open_file_cache_errors   on;

    # 设置内核在处理文件时的预读量
    read_ahead 0;

    # 解析超时时间。默认为30s
    resolver_timeout 30s;

    # 设置向客户端传输响应的超时。超时仅在两个连续写操作之间设置，不用于传输整个响应。如果客户端在此时间内没有收到任何消息，则连接将关闭。默认60s
    send_timeout 60s;

    # server配置
    server {}
}
```

- 网络相关的配置

```nginx
# 连接超时后 发送 RST 直接重置连接，避免4次挥手的 TCP 连接
reset_timeout_connection off

# 开启 lingering_close 并超过 client_max_body_size 大小返回413后, 客户端仍再发送时，超过 30s 后关闭连接
lingering_time 30s
```

#### 压缩

- HTML/CSS/JS：对于这类纯文本格式数据，我们在进行压缩时通常会去除其中多余的空格、换行和注释等元素。尽管压缩后的文本可能看起来比较混乱，对人类可读性较差，但这对计算机并不影响流畅阅读。

    - 针对 HTTP 报文里的 body 的压缩方式，对于 header 的压缩在 HTTP/1 里是没有的（HTTP/2 才有）。
    - 不过我们可以采取一些手段来减少 header 的大小，不必要的字段就尽量不发（例如 User-Agent、Server、X-Powered-By）

- JPG/JPEG/PNG：对于这类图片格式数据，虽然它本身已经被压缩过了，不能被 gzip、brotli 处理，但仍然有优化的空间。

##### gzip压缩

- 目前绝大多数的网站都在使用 GZIP 传输 HTML、CSS、JavaScript 等资源文件。

    - 对于文本文件，GZiP 的效果非常明显，开启后传输所需流量大约会降至 1/4~1/3 。

```nginx
http {
    # 默认 off，是否开启 gzip
    gzip on;

    # 要采用 gzip 压缩的 MIME 文件类型，其中 text/html 被系统强制启用；
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

    # ---- 以上两个参数开启就可以支持 Gzip 压缩了 ---- #

    # 默认 off，该模块启用后，Nginx 首先检查是否存在请求静态文件的 gz 结尾的文件，如果有则直接返回该 .gz 文件内容；
    gzip_static on;

    # 默认 off，Nginx 做为反向代理时启用，用于设置启用或禁用从代理服务器上收到相应内容 gzip 压缩；
    gzip_proxied any;  # gzip_proxied expired no-cache no-store private auth;

    # 用于在响应消息头中添加 Vary：Accept-Encoding，使代理服务器根据请求头中的 Accept-Encoding 识别是否启用 gzip 压缩；
    gzip_vary on;

    # gzip 压缩比，压缩级别从低到高1-9，值越大越消耗cpu。建议 4-6；
    gzip_comp_level 6;

    # 获取多少内存用于缓存压缩结果，16 8k 表示以 8k*16 为单位获得；
    gzip_buffers 16 8k;

    # 允许压缩的页面最小字节数，页面字节数从 header 头中的 Content-Length 中进行获取。默认值是 0，不管页面多大都压缩。建议设置成大于 1k 的字节数，小于 1k 可能会越压越大；
    # gzip_min_length 1k;

    # 默认 1.1，启用 gzip 所需的 HTTP 最低版本；
    gzip_http_version 1.1;

    # 指定哪些不需要 gzip 压缩的浏览器
    gzip_disable "MSIE [1-6]\.";

    server {
        # 省略
    }
}
```

- gzip_static：普遍是结合前端打包的时候打包成 gzip 文件后部署到服务器上，这样服务器就可以直接使用 gzip 的文件了，并且可以把压缩比例提高，这样 nginx 就不用压缩，也就不会影响速度。一般不追求极致的情况下，前端不用做任何配置就可以使用啦~

    - 附前端 webpack 开启 gzip 压缩配置，在 vue-cli3 的 vue.config.js 配置文件中：

    ```js
    const CompressionWebpackPlugin = require('compression-webpack-plugin')

    module.exports = {
      // gzip 配置
      configureWebpack: config => {
        if (process.env.NODE_ENV === 'production') {
          // 生产环境
          return {
            plugins: [new CompressionWebpackPlugin({
              test: /\.js$|\.html$|\.css/,    // 匹配文件名
              threshold: 1024,               // 文件压缩阈值，对超过 1k 的进行压缩
              deleteOriginalAssets: false     // 是否删除源文件
            })]
          }
        }
      },
      ...
    }
    ```

##### Brotli压缩

- [Brotli](https://github.com/google/ngx_brotli)是Google推出的开源压缩算法，通过变种的LZ77算法、Huffman编码以及二阶文本建模等方式进行数据压缩，与其他压缩算法相比，它有着更高的压缩效率，性能也比我们目前常见的Gzip高17-25%

- 浏览器支持情况
    - Mozilla Firefox >= 44
    - Google Chrome > 49
    - Opera >= 38

- 下载Brotli模块
    ```sh
    mkdir module && cd module

    git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli
    cd ngx_brotli/deps/brotli
    mkdir out && cd out
    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_C_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_CXX_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_INSTALL_PREFIX=./installed ..
    cmake --build . --config Release --target brotlienc
    ```

- 1.nginx安装编译，添加brotli模块（Statically compiled）
    ```sh
    cd nginx-1.x.x
    # 检查模块支持。记得加入之前编译的选项，不然启动nginx时，nginx.conf会报错
    ./configure --prefix=/usr/local/nginx \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_auth_request_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_realip_module \
        --with-stream_ssl_preread_module \
        --with-threads \
        --with-file-aio \
        --with-stream  \
        --add-module=/home/tz/Downloads/Programs/nginx-1.25.4/module/ngx_brotli \

    # 编译。make后的nginx二进制文件在objs目录
    make -j$(nproc)
    # 安装。会生成/usr/local/nginx 目录
    make install

    # 创建硬连接
    sudo ln /usr/local/nginx/sbin/nginx /bin/nginx

    # 查看是否成功安装brotli模块
    nginx -V | grep -i brotli
    ```

- 2.Dynamically loaded

    - 如果不选择以上的Statically compiled。可以选择这个
    ```sh
    cd nginx-1.x.x
    ./configure --with-compat --add-dynamic-module=/path/to/ngx_brotli

    make modules
    ```

    - nginx.conf配置
    ```nginx
    load_module modules/ngx_http_brotli_filter_module.so;
    load_module modules/ngx_http_brotli_static_module.so;
    http {
          ...
    }
    ```

- nginx配置

    - brotli和gzip可以共存

    ```nginx
    http {
        brotli on;              # 启用
        brotli_comp_level 6;    # 压缩等级，默认6，最高11，太高的压缩水平可能需要更多的CPU
        brotli_buffers 16 8k;   # 请求缓冲区的数量和大小
        brotli_min_length 20;   # 指定压缩数据的最小长度，只有大于或等于最小长度才会对其压缩。这里指定20字节
        brotli_types text/plain text/css text/xml text/javascript application/json application/x-javascript application/xml application/xml+rss application/javascript application/font-woff application/vnd.ms-fontobject application/vnd.apple.mpegurl image/svg+xml image/x-icon image/jpeg image/gif image/png image/bmp; # 指定允许进行压缩类型
        brotli_static always;   # 是否允许查找预处理好的、以.br结尾的压缩文件，可选值为on、off、always
        brotli_window 512k;     # 窗口值，默认值为512k

        server {
        }
    }
    ```

- 重启nginx
    ```sh
    nginx -s reload
    ```

- 测试

    - 方法1.在chrome浏览器打开127.0.0.1。按F12，选择`Network`，点击具体文件查看`Headers`中的`Response Headers`中的是否为`Content-Encoding: br`

    - 方法2
        ```sh
        # -I查看响应头部
        curl -I 127.0.0.1
        ```

### server块配置

```nginx
    server {
     listen       80;       # 配置监听的端口
     server_name  localhost;    # 配置的域名

     # location段配置信息
     location / {
      root   /usr/local/nginx/html;  # 网站根目录
      index  index.html index.htm;   # 默认首页文件
      deny 172.168.22.11;   # 禁止访问的 ip 地址，可以为 all
      allow 172.168.33.44;  # 允许访问的 ip 地址，可以为 all
     }

     error_page 500 502 503 504 /50x.html;  # 自定义 50x 对应的访问页面
     error_page 400 404 error.html;   # 自定义400 404页面
    }
```

#### server_name、location、root、alias、listen

- `server_name`指令：指定虚拟主机域名。

    ```nginx
    # 格式：
    # server_name name1 name2 name3

    server_name nginx.com *.nginx.com www.nginx.* ~^www\d+\.example\.com$;
    ```

    - 域名匹配的四种写法：

        - 匹配优先级：精确匹配 > 左侧通配符匹配 > 右侧通配符匹配 > 正则表达式匹配

        - 精确匹配：`server_name www.nginx.com ;`
        - 左侧通配：`server_name *.nginx.com ;`
        - 右侧统配：`server_name www.nginx.* ;`
        - 正则匹配：`server_name ~^www\.nginx\.*$ ;`


    - server_name指令的参数，可以通过配置本地`/etc/hosts`测试

        ```nginx
        # 添加如下内容，其中 121.42.11.34 是阿里云服务器 IP 地址
        121.42.11.34 www.nginx-test.com
        121.42.11.34 mail.nginx-test.com
        121.42.11.34 www.nginx-test.org
        121.42.11.34 doc.nginx-test.com
        121.42.11.34 www.nginx-test.cn
        121.42.11.34 fe.nginx-test.club
        ```

    - 泛域名路径分离

        - 这是一个非常实用的技能，经常有时候我们可能需要配置一些二级或者三级域名，希望通过 nginx 自动指向对应目录，比如：

        - test1.doc.test.club 自动指向 /usr/local/html/doc/test1 服务器地址；
        - test2.doc.test.club 自动指向 /usr/local/html/doc/test2 服务器地址；

        ```nginx
        server {
            listen       80;
            server_name  ~^([\w-]+)\.doc\.test\.club$;

            root /usr/local/html/doc/$1;
        }
        ```

    - 泛域名转发

        - 和之前的功能类似，有时候我们希望把二级或者三级域名链接重写到我们希望的路径，让后端就可以根据路由解析不同的规则：

        - test1.serv.test.club/api?name=a 自动转发到 127.0.0.1:8080/test1/api?name=a
        - test2.serv.test.club/api?name=a 自动转发到 127.0.0.1:8080/test2/api?name=a

        ```nginx
        server {
            listen       80;
            server_name ~^([\w-]+)\.serv\.test\.club$;

            location / {
                proxy_set_header        X-Real-IP $remote_addr;
                proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header        Host $http_host;
                proxy_set_header        X-NginX-Proxy true;
                proxy_pass              http://127.0.0.1:8080/$1$request_uri;
            }
        }
        ```

- `location`指令：配置路径

    - [Se7en的架构笔记：Nginx Location 匹配规则](https://mp.weixin.qq.com/s/Wq_z0eKPGq8b2pU4cxuyxA)

    - 匹配规则：

        - 匹配优先级：= > ^~ > ~ > ~* > ^~ > 普通匹配

        - `=` 精确匹配；
            - 使用 `=` 精确匹配可以加快查找的顺序。
        - `^~` 前缀匹配：匹配到即停止查找；

        - `~` 正则匹配，区分大小写；
        - `~*` 正则匹配，不区分大小写；
        - `!~` 表示正则区分大小写不匹配。
        - `!~*` 表示正则不区分大小写不匹配。

        ![image](./Pictures/nginx/location匹配过程.avif)

    - 语法：

        ```nginx
        Syntax:	location [ = | ~ | ~* | ^~ ] uri { ... }
        location @name { ... }
        Default:	—
        Context:	server, location
        ```

    - location匹配例子

        ```nginx
        location = / {
            [ configuration A ]
        }

        location / {
            [ configuration B ]
        }

        location /documents/ {
            [ configuration C ]
        }

        location ^~ /images/ {
            [ configuration D ]
        }

        location ~* \.(gif|jpg|jpeg)$ {
            [ configuration E ]
        }
        ```

        - 请求 / 精准匹配A，不再往下查找。
        - 请求 /index.html 匹配 B。首先查找匹配的前缀字符，找到最长匹配是配置 B，接着又按照顺序查找匹配的正则。结果没有找到，因此使用先前标记的最长匹配，即配置 B。
        - 请求 /documents/document.html 匹配 C。首先找到最长匹配 C，由于后面没有匹配的正则，所以使用最长匹配 C。
        - 请求 /images/1.gif匹配 D。首先进行前缀字符的查找，找到最长匹配 D。但是，特殊的是它使用了 ^~ 修饰符，不再进行接下来的正则的匹配查找，因此使用 D。这里，如果没有前面的修饰符，其实最终的通过正则匹配的是 E。
        - 请求 /documents/1.jpg 匹配 E。首先进行前缀字符的查找，找到最长匹配项 C，继续进行正则查找，找到匹配项 E。

    - location 中的`@`：

        - `@` 用来定义一个命名 location。主要用于内部重定向，不能用来处理正常的请求。其用法如下：

            ```nginx
            location / {
                try_files $uri $uri/ @redirectUri
            }
            location @redirectUri {
                # ...do something
            }
            ```

        - 上例中，当尝试访问 url 找不到对应的文件就重定向到我们自定义的命名 location（此处为 @redirectUri）。命名 location 中不能再嵌套其它的命名 location。

    - location 中的反斜线`/`：

        ```nginx
        location /test {
         ...
        }

        location /test/ {
         ...
        }
        ```

        - 1.不带 / 的情况：Nginx 会找是否有 test 文件。
        - 2.带 / 的情况：Nginx 会找是否有 test 目录，如果有则找 test 目录下的 html文件（不一定是index.html）

            - 返回301 Moved Permanently
            ```sh
            curl 127.0.0.1/test
            ```
            - 可以匹配的路径，会成功返回。
            ```sh
            curl 127.0.0.1/test/
            curl 127.0.0.1/test/index.html
            curl 127.0.0.1/testasd/
            curl 127.0.0.1/test/app/index.html
            ```

        - 可以看到带 / 容易会暴露服务器不公开的文件。如果要使uri和文件路径完全一对一建议使用 `=` 的意义
            ```nginx
            location = /test/ {
             ...
            }
            ```

            ```sh
            # 返回404
            curl 127.0.0.1/test/

            # 成功
            curl 127.0.0.1/test/index.html
            ```

        - 但 `=` 有时又不太灵活，可以使用 `~` 正则表达式
            ```nginx
            location ~ /test/index[0-9].html {
             ...
            }
            ```

- `root`指令：指定静态资源目录位置，它可以写在 http、server、location 等配置中。
    ```nginx
    # 当用户访问 www.test.com/image/1.png 时，实际在服务器找的路径是 /opt/nginx/static/image/1.png
    location /image {
     root /opt/nginx/static;
    }
    ```

- `alias`指令：也是指定静态资源目录位置，它只能写在 location 中。

    - root 会将定义路径与 URI 叠加，alias 则只取定义路径。
    - 使用 alias 末尾一定要添加 `/`

    ```nginx
    # 当用户访问 www.test.com/image/1.png 时，实际在服务器找的路径是 /opt/nginx/static/image/1.png
    location /image {
        alias /opt/nginx/static/image/;
    }

    # 当用户访问 www.test.com/i/1.png 时，实际在服务器找的路径是 /opt/nginx/static/image/1.png
    location /i/ {
        alias /opt/nginx/static/image/;
    }
    ```

- listen指令

    ```nginx
    listen 127.0.0.1:8000;
    listen 127.0.0.1;
    listen 8000;
    listen *:8000;
    listen localhost:8000;

    # IPv6
    listen [::]:8000;
    listen [::1];

    # UNIX-domain sockets
    listen unix:/var/run/nginx.sock;
    ```

#### 重写规则。比较 return、rewrite 和 try_files 指令

- [创建 NGINX 重写规则](https://mp.weixin.qq.com/s/N_SNlAu8katrZRIc1g0Jrg)

- 重写规则会改变客户端请求中的部分或全部 URL，通常出于以下两个目的：

    - 1.告知客户端其请求的资源目前位于其他位置。例如：您网站的域名已更改；或是您希望客户端采用规范的 URL 格式（无论是否带有 www 前缀），又或是您希望发现并更正域名的常见拼写错误。在这些场景下，`return` 和 `rewrite` 指令都可以适用。

    - 2.控制 NGINX 和 NGINX Plus 内部的处理流，例如，当需要动态生成内容时，将请求转发到应用服务器。`try_files` 指令通常用于此类情形。

- 两个通用的 NGINX 重写指令是 return 和 rewrite，而try_files 指令是将请求定向到应用服务器的便捷方法。

- return 指令：是两个通用指令中较为简单的一个，因此我们建议尽可能使用该指令，而非 rewrite（稍后会详细说明原因和使用场景）。

    - 您可以将 return 添加到 server 或 location 上下文（指定要重写的URL）中，它定义了客户端在后续资源请求中使用的 rewrite 重写后的 URL。

    - 下面的简单示例显示了如何将客户端重定向到新域名：

            ```nginx
            server {
                listen 80;
                listen 443 ssl;
                server_name www.old-name.com;
                return 301 $scheme://www.new-name.com$request_uri;
            }
            ```

            - return 指令告知 NGINX 停止处理请求，并立即将 301响应码 (Moved Permanently) 和指定的已重写的 URL 发送至客户端。

            - 重写的 URL 使用两个 NGINX 变量来延用原始请求 URL 中的值
                - $scheme 表示协议（http 或 https）
                - $request_uri 表示包含参数的完整 URI。

    - 在某些情况下，您可能希望返回比文本字符串更复杂或更精细的响应。使用 `error_page` 指令，您可为每个 HTTP 代码返回一个完整的自定义 HTML 页面，并更改响应代码或执行重定向。

    - 对于 3xx 响应码，url 参数用以定义新（重写）的 URL。

        ```nginx
        # 格式：return (301 | 302 | 303 | 307) url;

        location / {
         return 301 https://www.baidu.com ; # 返回重定向地址
        }
        ```

    - 对于其他响应码，您可以选择自定义出现在响应正文中的文本字符串（404 Not Found 等 HTTP 代码的标准文本仍包含在响应头中）。该文本可包含 NGINX 变量。

        ```nginx
        # 格式return (1xx | 2xx | 4xx | 5xx) ["text"];

        # 例子：在拒绝不具备有效身份验证令牌的请求时，该指令可能适用：
        return 401 "Access denied because token is expired or invalid";
        ```

- rewrite 指令

    - 若要测试 URL 之间更复杂的差异、捕获原始 URL 中没有相应 NGINX 变量的元素或者更改（或添加）路径中的元素，该怎么办呢？在这种情况下，您可以使用 rewrite 指令。

    - 与 return 指令一样，在需要重写的 URL 的 server 或 location 上下文中添加 rewrite 指令。这两个指令虽然非常相似，但多有不同，而且正确使用 rewrite 指令的难度可能更大。它的语法很简单：

        ```nginx
        rewrite regex URL [flag];
        ```

        | flag      | 说明                                                                  |
        |-----------|-----------------------------------------------------------------------|
        | last      | 重写后的 URL 发起新请求，再次进入 server 段，重试 location 的中的匹配 |
        | break     | 直接使用重写后的 URL ，不再匹配其它 location 中语句                   |
        | redirect  | 返回 302 临时重定向                                                   |
        | permanent | 返回 301 永久重定向                                                   |


        - 第一个参数 regex：与指定的正则表达式相匹配（除了匹配 server 或 location 指令以外）时才会重写 URL。

        - 第二个区别是 rewrite 指令只能返回 301 或 302响应码。若要返回其他响应码，您需要在 rewrite 指令后添加一个 return 指令

        - 最后，rewrite 指令不一定会像 return 指令那样停止 NGINX 对请求的处理，也未必向客户端发送重定向。除非您明确表明（使用标记或 URL 语法）希望 NGINX 停止处理或发送重定向，否则它会在整个配置中查找 rewrite 模块中定义的指令（break、if、return、rewrite 及 set），并依次对其进行处理。

            - 如果重写的 URL 与rewrite模块中的后续指令相匹配，NGINX 将对重写的 URL 执行指定的操作（通常会再次重写）。

            - 例如，如果原始 location 块和其中的 NGINX 重写规则与重写的 URL 相匹配，NGINX 就会进入循环，重复地应用重写，直至达到 10 次内置上限。如前所述，我们建议您尽可能使用 return 指令。

    - 例子：

        ```nginx
        server{
          listen 80;
          server_name fe.lion.club; # 要在本地 hosts 文件进行配置
          root html;

          location /search {
           rewrite ^/(.*) https://www.baidu.com redirect;
          }

          location /images {
           rewrite /images/(.*) /pics/$1;
          }

          location /pics {
           rewrite /pics/(.*) /photos/$1;
          }

          location /photos {

          }
        }
        ```

        - 当访问 fe.lion.club/search 时：会自动帮我们重定向到 https://www.baidu.com。

        - 当访问 fe.lion.club/images/1.jpg 时
            - 第一步重写 URL 为 fe.lion.club/pics/1.jpg，找到 pics 的 location
            - 继续重写 URL 为 fe.lion.club/photos/1.jpg，找到 /photos 的 location 后，去 html/photos 目录下寻找 1.jpg 静态资源。

    - 例子：匹配以字符串 /download 开头且在路径靠后位置包含 /media/ 或 /audio/ 目录的 URL，并用 /mp3/ 替换这些元素和添加相应的文件扩展名 .mp3 或 .ra。

        ```nginx
        server {

         # ...

         rewrite ^(/download/.*)/media/(\w+)\.?.*$ $1/mp3/$2.mp3 last;
         rewrite ^(/download/.*)/audio/(\w+)\.?.*$ $1/mp3/$2.ra last;
         return 403;

         # ...

        }
        ```

        - $1 和 $2 变量捕获未更改的路径元素。
            - 例如，/download/cdn-west/media/file1 变为 /download/cdn-west/mp3/file1.mp3。

        - 可以在 rewrite 指令中添加标记，以控制处理流。本例中的 last 标记就是其中之一：它指示 NGINX 跳过当前 server 或 location 块中的任何后续 rewrite 模块指令，并开始搜索与重写的 URL 相匹配的新 location。

        - 在本例中，最后的 return 指令表示，如果 URL 与任一 rewrite 指令均不匹配，则会向客户端返回 403 响应码。


- try_files 指令

    - 与 return 和 rewrite 指令一样，将 try_files 指令添加到 server 或 location 块中。作为参数，它需要一个包含一个或多个文件和目录的列表以及一个最终的 URI：

        ```nginx
        location /images/ {
            try_files $uri /images/default.gif;
        }

        location = /images/default.gif {
            expires 30s;
        }
        ```

        ```nginx
        location / {
            try_files $uri $uri/ @drupal;
        }

        location ~ \.php$ {
            try_files $uri @drupal;

            fastcgi_pass ...;

            fastcgi_param SCRIPT_FILENAME /path/to$fastcgi_script_name;
            fastcgi_param SCRIPT_NAME     $fastcgi_script_name;
            fastcgi_param QUERY_STRING    $args;

            ... other fastcgi_param's
        }

        location @drupal {
            fastcgi_pass ...;

            fastcgi_param SCRIPT_FILENAME /path/to/index.php;
            fastcgi_param SCRIPT_NAME     /index.php;
            fastcgi_param QUERY_STRING    q=$uri&$args;

            ... other fastcgi_param's
        }
        ```

    - NGINX 依次检查文件和目录是否存在（通过 root 和 alias 指令的设置构建每个文件的完整路径），并提供它找到的第一个文件和目录。若要表示一个目录，在元素名称的末尾添加斜杠即可。

        - 如果不存在任何文件或目录，NGINX 会执行内部重定向到最后一个元素 (uri) 定义的 URI。


##### break指令：不再匹配后面的重写规则

```nginx
server {
    listen 80;
    server_name www.tz.com;

    if ($host != 'www.tz.com') {
        rewrite ^/(.*)$ http://www.tz.com/error.txt;
        break;
        rewrite ^/(.*)$ http://www.tz.com/$1 permanent;
    }
}
```

##### 例子：如果客户端请求的文件不存在，NGINX 会提供默认的 GIF 文件

    - 当客户端请求（例如）http://www.domain.com/images/image1.gif 时，NGINX 会先在适用于该位置的 root 或 alias 指令指定的本地目录中查找 image1.gif（示例代码中未显示）。

    - 如果查找不到，它就会重定向到 /images/default.gif。该值与第二个 location 指令完全匹配，因此处理停止，NGINX 提供此文件，并将其标记为缓存 30 秒。

    ```nginx
    location /images/ {
     try_files $uri $uri/ /images/default.gif;
    }

    location = /images/default.gif {
     expires 30s;
    }
    ```


    ```nginx
    # add 'www'
    server {
        listen 80;
        listen 443 ssl;
        server_name domain.com;
        return 301 $scheme://www.domain.com$request_uri;
    }

    # remove 'www'
    server {
        listen 80;
        listen 443 ssl;
        server_name www.domain.com;
        return 301 $scheme://domain.com$request_uri;
    }
    ```

- rewrite 需要解释正则表达式 ^(.*)$，并创建一个自定义变量 ($1) —— 实际上相当于 $request_uri 固定变量。

    ```nginx
    # NOT RECOMMENDED
    rewrite ^(.*)$ $scheme://www.domain.com$1 permanent;
    ```

##### 例子：将所有流量重定向到正确的域名

- 当请求 URL 与任何 server 和 location 块都不匹配时（可能是因为域名拼写错误），便会将传入流量重定向到网站的主页。

    - 它的工作原理是在 listen 指令中使用 default_server 参数，并在 server_name 指令中将下划线用作参数。

    - server_name 指令中将下划线用作参数可避免无意中匹配真实域名

    - 不过，与配置中其他任何 server 块都不匹配的请求会重定向到此处，并且 listen 指令中的 default_server 参数将指示 NGINX 使用该块处理这些请求。

    - 最好从rewrite的 URL 中删除 $request_uri 变量，从而将所有请求重定向到主页，因为带有错误域名的请求很可能会使用网站上不存在的 URI。

```nginx
server {
    listen 80 default_server;
    listen 443 ssl default_server;
    server_name _;
    return 301 $scheme://www.domain.com;
}
```

##### 例子：强制所有请求使用 SSL/TLS

- return 指令

    ```nginx
    server {
        listen 80;
        server_name www.domain.com;
        return 301 https://www.domain.com$request_uri;
    }
    ```


- rewrite指令

    - 但这种方法需要执行额外的处理，因为 NGINX 必须评估 if 条件并处理 rewrite 指令中的正则表达式。

    ```nginx
    # NOT RECOMMENDED
    if ($scheme != "https") {
        rewrite ^ https://www.mydomain.com$uri permanent;
    }
    ```

##### 例子：为 WordPress 网站启用 Pretty Permalinks

- 对于使用 WordPress 的网站而言，NGINX 和 NGINX Plus 是常用的应用交付平台。

- try_files 指令指示 NGINX 依次检查文件 $uri 和目录 $uri/ 是否存在。如果文件和目录都不存在，NGINX 将返回一个重定向到 /index.php，并传递查询字符串参数（通过 $args 参数捕获）。

    ```nginx
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
    ```

##### 例子：丢弃对不支持的文件扩展名的请求

- 由于各种原因，您的网站可能会收到以文件扩展名（对应于未运行的应用服务器）结尾的请求 URL。在将动态资产请求传递给应用的 server 块中，此 location 指令会在非 Rails 文件类型的请求进入 Rails 队列之前将其丢弃。

- 响应代码 410 (Gone) 适用于以下情况：请求的资源曾在此 URL 上提供，但现已不复存在，而且服务器不知道其当前位置（如有）。
    - 较之响应代码 404，它的优点是，明确表明该资源永久不可用，这样客户端不会再次发送请求。

    ```nginx
    location ~ .(aspx|php|jsp|cgi)$ {
        return 410;
    }
    ```

- 响应码 403 暗示请求的资源存在：您可能希望通过返回响应代码 403 (Forbidden) 和诸如 "Server handles only Ruby requests” 之类的说明作为文本字符串，向客户端更准确地指明失败原因。作为替代方法，deny all 指令返回响应码 403 而不作任何解释

    ```nginx
    location ~ .(aspx|php|jsp|cgi)$ {
        deny all;
    }
    ```

- 如果您希望通过向客户端提供尽可能少的信息来实现“隐晦式安全”，代码 404 可能是更好的选择。其缺点是，客户端可能会反复重试请求，因为代码 404 并未表明失败是暂时的还是永久的。

##### 例子：配置自定义重路由

- 在 MODXCloud 的这个示例中，有一个资源充当一组 URL 的控制器。您的用户可使用更易读的名称来命名资源，您能够对其进行重写（而非重定向），以便 listing.html 上的控制器执行处理。

- 例如，用户友好型 URL http://mysite.com/listings/123 被重写为由 listing.html 控制器处理的 URL http://mysite.com/listing.html?listing=123。

```nginx
rewrite ^/listings/(.*)$ /listing.html?listing=$1 last;
```

#### if指令

- 往往需要和nginx的内置变量配合使用

- if 指令使用起来很棘手，尤其是在 location{} 块中。它通常不会按照预期执行，甚至还会导致出现段错误。

    - 通常，在 if{} 块中，您可以一直安全使用的指令只有 `return` 和 `rewrite`。

- 语法：if (condition) {...}。 上下文：server、location

    ```nginx
    if($http_user_agent ~ Chrome){
      rewrite /(.*)/browser/$1 break;
    }
    ```

    - condition 判断条件：
        - $variable 仅为变量时，值为空或以 0 开头字符串都会被当做 false 处理；
        - = 或 != 相等或不等；
        - ~ 正则匹配；
        - ! ~ 非正则匹配；
        - ~* 正则匹配，不区分大小写；
        - -f 或 ! -f 检测文件存在或不存在；
        - -d 或 ! -d 检测目录存在或不存在；
        - -e 或 ! -e 检测文件、目录、符号链接等存在或不存在；
        - -x 或 ! -x 检测文件可以执行或不可执行；

- 例子：当访问 localhost:8080/images/ 时，会进入 if 判断里面执行 rewrite 命令。

    ```nginx
    server {
      listen 8080;
      server_name localhost;
      root html;

      location / {
       if ( $uri = "/images/" ){
         rewrite (.*) /pics/ break;
        }
      }
    }
    ```

- 错误例子：使用 if 来检测包含 X‑Test  http消息头的请求

    - NGINX 返回 430 (Request Header Fields Too Large) 错误，在指定的位置 @error_430 进行拦截并将请求代理到名为 b 的上游 group。

    ```nginx
    location / {

        error_page 430 = @error_430;

        if ($http_x_test) {
            return 430;
        }

        proxy_pass http://a;

    }

    location @error_430 {
        proxy_pass b;
    }
    ```

    - 代替方案：对于 if 的这个用途及许多其他用途，通常可以完全避免使用该指令。在以下示例中，当请求包含 X‑Test 标头时，map{} 块将 $upstream_name 变量设置为 b，并且请求被代理到以 b 命名的上游 group。

        ```nginx
        map $http_x_test $upstream_name {
            default "b";
            ""      "a";
        }

        # ...

        location / {
            proxy_pass http://$upstream_name;
        }
        ```

#### set指令：设置变量

- nginx 的配置文件使用的是一门微型的编程语言

- 在 nginx 配置中，变量只能存放字符串类型

```nginx
set $name "chroot";
```

- 变量嵌入到字符串常量中以构造出新的字符串

```nginx
server {
  listen       80;
  server_name  test.com;

  location / {
     set $temp hello;
     return "$temp world";
  }
}
```

- 当引用的变量名之后紧跟着变量名的构成字符时（比如后跟字母、数字以及下划线），我们就需要使用特别的记法来消除歧义，例如：

```nginx
server {
  listen       80;
  server_name  test.com;

  location / {
     set $temp "hello ";
     return "${temp}world";
  }
}
```

- 若是想输出 $ 符号本身
    - 用到了标准模块 ngx_geo 提供的配置指令 geo 来为变量 $dollar 赋予字符串 "$" ，这样，这里的返回值就是 "hello world: $" 了。

```nginx
geo $dollar {
    default "$";
}
server {
    listen       80;
    server_name  test.com;

    location / {
        set $temp "hello ";
        return "${temp}world: $dollar";
    }
}
```

#### aio（异步io）

- nginx安装编译需要加入aio选项。不然会报错`nginx: [emerg] "aio on" is unsupported on this platform in /usr/local/nginx/conf/nginx.conf:176`

```sh
# 编译需要加入aio选项。
./configure --prefix=/usr/local/nginx \
    --with-file-aio \
```

- aio需要linux2.6.22以上的版本

```nginx

    # 使用 O_DIRECT 读取文件 和 sendfile 互诉
    # directio_aligment size

```

- 启用aio

    ```nginx
    location /video/ {
        aio            on;
        directio       512; # 需要启用directio，否则读取将阻塞
        output_buffers 1 128k;
    }
    ```

- 大于等于directio时：使用aio；小于directio时使用sendfile
```nginx
location /video/ {
    sendfile on;
    aio on;
    directio 8m;
}
```

- 使用多线程读取和发送文件
```nginx
location /video/ {
    sendfile       on;
    aio            threads;
}
```

### 内置变量

- 可以在配置中随意使用

| TCP              | UDP                                                          |
|------------------|--------------------------------------------------------------|
| $host            | 请求信息中的Host，如果请求中没有Host行，则等于设置的服务器名 |
| $request_method  | 客户端请求类型，如GET、POST                                  |
| $remote_addr     | 客户端的IP地址                                               |
| $remote_port     | 客户端的端口                                                 |
| $server_protocol | 请求使用的协议，如HTTP/1.1                                   |
| $server_addr     | 服务器地址                                                   |
| $server_name     | 服务器名称                                                   |
| $server_port     | 服务器的端口号                                               |
| $args            | 请求中的参数                                                 |
| $content_length  | 请求头中的Content-length字段                                 |
| $http_user_agent | 客户端agent 信息                                             |
| $http_cookie     | 客户端cookie信息                                             |

- 例子

    ```nginx
    server {
        listen 8081;
        server_name example.com;
        root /usr/local/nginx/html;

        location / {
            return 200 "
            remote_addr: $remote_addr
            remote_port: $remote_port
            server_addr: $server_addr
            server_port: $server_port
            server_protocol: $server_protocol
            binary_remote_addr: $binary_remote_addr
            connection: $connection
            uri: $uri
            request_uri: $request_uri
            scheme: $scheme
            request_method: $request_method
            request_length: $request_length
            args: $args
            arg_pid: $arg_pid
            is_args: $is_args
            query_string: $query_string
            host: $host
            http_user_agent: $http_user_agent
            http_referer: $http_referer
            http_via: $http_via
            request_time: $request_time
            https: $https
            request_filename: $request_filename
            document_root: $document_root
            ";
         }
    }
    ```

    - 测试：打开浏览器访问`http://127.0.0.1:8081`。由于 Nginx 中写了 return 方法，会下载download文件，内容包含变量的具体值

### 正向代理和反向代理

- 正向代理在客户端侧，反向代理在服务端侧

  ![image](./Pictures/nginx/正向代理和反向代理.avif)

    - 正向代理：客户端无法主动或者不打算主动去向某服务器发起请求，而是委托了 Nginx 代理服务器去向服务器发起请求，并且获得处理结果，返回给客户端。(类似于中介)

        - 客户端可以察觉。(360，火绒可能也是正向代理)

        ```nginx
        # 正向代理配置

        # resolver是配置正向代理的DNS服务器，listen 是正向代理的端口，配置好了就可以在浏览器上面或者其他代理插件上面使用服务器ip+端口号进行代理了。
        resolver 114.114.114.114 8.8.8.8;
        server {
	        resolver_timeout 5s;
	        listen 81;
	        location / {
		        proxy_pass http://$host$request_uri;
	        }
        }
        ```

    - 反向代理：后将请求转发给内部网络上的服务器，并将从服务器上得到的结果返回给 internet 上请求连接的客户端。

        - 简单来说：访问不同的路径，就去不同的端口

        - 客户端无法察觉。隐藏真实服务器

        ```nginx
        server {
              listen      80;
              server_name  localhost;
              location / {
                  proxy_pass http://www.google.com;

                  proxy_set_header Host $http_host;
                  proxy_set_header X-Real-IP $remote_addr; #获取客户端真实IP
              }
          }
        ```

- `proxy_pass` 指令: 让 **80** 端口代理 **8080** 端口的流量

    - 添加一个新的 **server** 块，监听 **8080** 端口:

    ```nginx
    server {
        listen 8080;
        server_name  localhost;

        location / {
            # 设置代理为 80 端口
            proxy_pass http://localhost:80/;
        }

        location /url/ {
            # 当客户端访问http://localhost:8080/uri/iivey.html会被重定向到http://localhost:80/uri/iivey.html
            proxy_pass http://localhost:80/;
        }
    }
    ```

    - 1.静态主页测试: 在浏览器里输入`127.0.0.1:8080`:
      ![image](./Pictures/nginx/proxy.avif)

    - 2.图片测试: 在浏览器里输入`127.0.0.1:8080/YouPictureName.png`:
      ![image](./Pictures/nginx/proxy1.avif)

- `proxy_pass`指令两种用法的区别就是带 / 和不带 / ，在配置代理时它们的区别可大了：

    - 不带 / 意味着 Nginx 不会修改用户 URL，而是直接透传给上游的应用服务器

        ```nginx
        location /bbs/{
          proxy_pass http://127.0.0.1:8080;
        }
        ```

        - 用户请求 URL：/bbs/abc/test.html
        - 请求到达 Nginx 的 URL：/bbs/abc/test.html
        - 请求到达上游应用服务器的 URL ：/bbs/abc/test.html

    - 带 / 意味着 Nginx 会修改用户 URL ，修改方法是将 location 后的 URL 从用户 URL 中删除

        ```nginx
        location /bbs/{
          proxy_pass http://127.0.0.1:8080/;
        }
        ```

        - 用户请求 URL：/bbs/abc/test.html
        - 请求到达 Nginx 的 URL：/bbs/abc/test.html
        - 请求到达上游应用服务器的 URL：/abc/test.html

    - 并没有拼接上 /bbs，这点和 root与 alias 之间的区别是保持一致的。

- 子目录

    ```nginx
    server {
        listen 8080;
        server_name  localhost;

        location / {
        # 设置代理为 80 端口
            proxy_pass http://localhost:80/;
        }

        location /baidu {
            # 设置为baidu
            proxy_pass https://www.baidu.com/;
        }

        location /github {
            # 设置为baidu
            proxy_pass https://www.github.com/;
        }
    }
    ```

    - 测试：在浏览器里输入`http://127.0.0.1:8080/baidu`和`http://127.0.0.1:8080/github`

- 配置反向代理

    - 两台云服务器，它们的公网 IP 分别是：121.42.11.34 与 121.5.180.193。

    - 121.42.11.34 服务器作为上游服务器，做如下配置

        ```nginx
        # /etc/nginx/conf.d/proxy.conf
        server{
          listen 8080;
          server_name localhost;

          location /proxy/ {
            root /usr/share/nginx/html/proxy;
            index index.html;
          }
        }

        # /usr/share/nginx/html/proxy/index.html
        <h1> 121.42.11.34 proxy html </h1>
        ```

    - 121.5.180.193 服务器作为代理服务器

        ```nginx
        # /etc/nginx/conf.d/proxy.conf
        upstream back_end {
          server 121.42.11.34:8080 weight=2 max_conns=1000 fail_timeout=10s max_fails=3;
          keepalive 32;
          keepalive_requests 80;
          keepalive_timeout 20s;
        }

        server {
          listen 80;
          server_name proxy.lion.club;
          location /proxy {
           proxy_pass http://back_end/proxy;
          }
        }
        ```

    - /etc/hosts文件添加`121.5.180.193 proxy.lion.club`

    - 流程：
        - 当访问 proxy.lion.club/proxy 时通过 upstream 的配置找到 121.42.11.34:8080；
        - 因此访问地址变为 http://121.42.11.34:8080/proxy；
        - 连接到 121.42.11.34 服务器，找到 8080 端口提供的 server；
        - 通过 server 找到 /usr/share/nginx/html/proxy/index.html 资源，最终展示出来。

#### proxy相关指令

- [官方文档：proxy相关指令解释](http://nginx.org/en/docs/http/ngx_http_proxy_module.html)

```nginx
server {
    listen 8080;
    server_name  localhost;

    location / {
        # 设置代理为 80 端口
        proxy_pass http://localhost:80/;

        proxy_redirect off;

        # 传递代理服务器的头部
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # 与代理服务器建立连接的超时时间。默认值60s
        proxy_connect_timeout = 90s;

        # 请求传输到代理服务器的超时。默认值60s
        proxy_send_timeout = 90s;

        # 从代理服务器读取响应的超时。默认值60s
        proxy_read_timeout = 90s;

        # 读取响应头部的缓冲区大小。默认情况下，缓冲区大小等于一个内存页（4K或8K）。
        proxy_buffer_size 4k;

        # 读取单个连接的响应的缓冲区的数量和大小。默认值为 8 4k|8k。缓冲区大小等于一个内存页（4K或8K）
        proxy_buffers 4 32k;

        # 默认情况下，大小受proxy_buffer_size和proxy_buffer指令设置的两个缓冲区的大小限制。
        proxy_busy_buffers_size 64k;

        # 限制一次写入临时文件的数据大小
        proxy_temp_file_write_size 64k;
    }
}
```

### 静态页面

- 静态页面的配置

    ```nginx
    # 静态页面的配置
    server {
        listen       80;
        server_name  localhost;
        # 省略...
        location / {
            root   html;
            index  index.html index.htm;
            expires     10h; # 设置过期时间为10小时。用户在 10 小时内请求的时候，都只会访问浏览器中的缓存，而不会去请求 nginx 。
        }
        # 省略...
    }
    ```

    - 以上综合来说就是: 在 `localhost(127.0.0.1)` 的 `80` 端口下匹配`/usr/local/nginx/html/`目录下的 `index.html` 和 `index.htm` 文件

- 把 html 目录下的 **index.html** 的标题改为 **tz-pc** 进行测试:

    ```html
    <h1>Welcome to tz-pc!</h1>
    ```

    - 1.测试: 在浏览器里输入 `localhost` 或者 `127.0.0.1`

      (等同于 `localhost/index.html`)

      (等同于 `127.0.0.1/index.html`)

      ![image](./Pictures/nginx/static.avif)

    - 2.测试: `curl` 命令

        ```sh
        curl localhost
        # 或者
        curl 127.0.0.1
        ```

- 设置图片的目录(通过正则表达式匹配 gif,png,jpg):

    ```nginx
    location / {
        root   html;
        index  index.html index.htm;
    }

    # 添加如下配置,我这里的目录为(/home/tz./Pictures/)
    location ~\.(gif|png|jpg)$ {
        root   /home/tz./Pictures/;

        # 假设找不到对应的文件则返回/home/tz./Pictures/404.png
        error_page 404 = /404.png;
    }
    ```

    - 修改后重新加载配置:

        ```sh
        sudo nginx -s reload
        ```

    - 1.测试: 在浏览器里输入`127.0.0.1/YouPictureName`
      ![image](./Pictures/nginx/static1.avif)

    - 2.测试: curl 后通过重定向下载

        ```sh
        curl 127.0.0.1/YouPictureName > /tmp/YouPictureName.png
        ```

### tomcat

- 动静分离：

    ![image](./Pictures/nginx/动静分离.avif)

- apache软件基金会下属的jakarta项目开发的一个servlet容器，安装sun公司提供的技术规范，实现了对servlet和JSP（java server page）的支持

- 如果是包管理安装：目录在`/usr/share/tomcat10`，配置文件目录除了在`/usr/share/tomcat10/conf`，还在`/etc/tomcat10/`

    | /usr/share/tomcat10目录 | 说明                                                        |
    |-------------------------|-------------------------------------------------------------|
    | bin                     | 可执行文件。如startup.sh和shutdown.sh                       |
    | conf                    | 配置文件，如核心配置文件server.xml和应用默认部署文件web.xml |
    | lib                     | 运行时需要的jar包                                           |
    | logs                    | 日志                                                        |
    | webapps                 | 存放默认的web应用部署目录                                   |
    | work                    | 存放web应用代码生成和编译文件的临时目录                     |

- `tomcat`的配置文件是`xml` 格式

- 默认端口

    - 8080 是 Tomcat 提供 web 服务的端口
    - 8009 是 AJP 端口（第三方的应用连接这个端口，和 Tomcat 结合起来）
    - 8005 shutdown（管理端口）

    ```sh
    # 将8080修改为8088端口
    sed -i 's/port="8080"/port="8088"/' /usr/local/tomcat/conf/server.xml

    # 查看端口
    netstat -tunlp | grep 8088
    ```

- 配置文件`/usr/local/tomcat/conf/server.xml`

    - name 定义域名
    - appBase 定义默认应用目录
    - unpackWARs=”true” 是否自动解压；(也是就是说，当我们往站点目录里面直接上传一个 war 的包，它会自动解压)
    - docBase，这个参数用来定义网站的文件存放路径，如果不定义，默认是在 appBase/ROOT 下面，定义了 docBase 就以该目录为主了，其中 appBase 和 docBase 可以一样。在这一步操作过程中,可能会遇到过访问 404 的问题，其实就是 docBase 没有定义对。

- 日志

    - catalina 开头的日志为 Tomcat 的综合日志，它记录 Tomcat 服务相关信息，也会记录错误日志。
    - catalina.2017-xx-xx.log 和 catalina.out 内容相同，前者会每天生成一个新的日志。
    - host-manager 和 manager 为管理相关的日志，其中 host-manager 为虚拟主机的管理日志。
    - localhost 和 localhost_access 为虚拟主机相关日志，其中带 access 字样的日志为访问日志，不带 access 字样的为默认虚拟主机的错误日志。

#### 安装（不需要编译，解压后mv到指定目录即可）

- [官方网站](https://tomcat.apache.org/)

```sh
# 下载
curl -LO https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz
tar xzfv apache-tomcat-10.1.18.tar.gz

# 复制到指定目录
mv apache-tomcat-10.1.18 /usr/local/tomcat
```

```sh
# 启动tomcat
sudo /usr/local/tomcat/bin/startup.sh

# 关闭tomcat
sudo /usr/local/tomcat/bin/shutdown.sh
```

#### nginx配置tomcat

- 配置nginx动静分离。方式主要有两种：

    - 1.把静态文件独立成单独的域名，放在独立的服务器上，也是目前主流推崇的方案
    - 2.动态跟静态文件混合在一起发布， 通过 nginx 配置来分开

        ```nginx
        # 所有静态请求都由nginx处理，存放目录为 html
        location ~* \.(gif|jpg|jpeg|png|webp|avif|bmp|swf|fly|wma|asf|mp3|mmf|zip|rar)$ {
            root    /usr/local/resource;
            expires     10h; # 设置过期时间为10小时。用户在 10 小时内请求的时候，都只会访问浏览器中的缓存，而不会去请求 nginx 。
        }

        # 所有动态请求都转发给 tomcat 处理。tomcat默认使用8080端口，如果nginx配置了8080端口的server记得注销代码，然后nginx -s reload重新加载配置后，在启动tomcat
        location ~ \.(jsp|do)$ {
            proxy_pass  http://127.0.0.1:8080;

            # 传递代理服务器的头部
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            # 自动故障转移。遇到500、502、503、504、执行超时等错误，nginx会将请求转发到upstream负载均衡组中的另一台服务器
            proxy_next_upstream http_500 http_502 http_503 http_504 error timeout invalid_header;
        }

        error_page  500 502 503 504  /50x.html;
        location = /50x.html {
            root  /root/website/;
        }
        ```

- nginx重新加载配置
    ```sh
    nginx -s reload
    ```

- 测试：`curl http://127.0.0.1/index.jsp`

- 创建jsp测试代码：`/usr/local/tomcat/webapps/www/index.jsp`。（其实也可以不创建，使用默认的目录和index.jsp）

    ```sh
    # 创建自定义的目录。这里为www
    mkdir /usr/local/tomcat/webapps/www
    ```

    ```html
    <html>
        <body>
            <h1>JSP Test Page</h1>
            <%=new java.util.Date() %>
        </body>
    </html>
    ```

    - 修改`/usr/local/tomcat/conf/server.xml`。在末尾`</Host>`前添加以下代码

        ```xml
        <Context path="/" docBase="/usr/local/tomcat/webapps/www" reloadable="true"/>
        ```

- 重启tomcat

    ```sh
    # 关闭tomcat
    sudo /usr/local/tomcat/bin/shutdown.sh
    # 启动tomcat
    sudo /usr/local/tomcat/bin/startup.sh
    ```

- 测试
    ```sh
    curl http://127.0.0.1/index.jsp
    ```

#### 后台管理配置

- 添加以下内容到`/usr/local/tomcat/conf/tomcat-users.xml`
```xml
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<user username="tz" password="12345678" roles="manager-gui,manager-script,manager-jmx,manager-status"/>
```

`/usr/local/tomcat/webapps/manager/META-INF/context.xml`
```xml
  <!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve" -->
  <!--        allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->

```

- 重启tomcat

    ```sh
    # 关闭tomcat
    sudo /usr/local/tomcat/bin/shutdown.sh
    # 启动tomcat
    sudo /usr/local/tomcat/bin/startup.sh
    ```

- 打开`127.0.0.1:8080/manager/html`
![image](./Pictures/nginx/tomcat-manager.avif)

#### 性能优化

- [knowclub：深入理解Tomcat的I/O模型及性能调优策略](https://mp.weixin.qq.com/s/GlSuSCTuDtOsbCk-606lOw)

- 修改配置文件`/usr/local/tomcat/conf/server.xml`

    ```xml
    <!-- 修改Connector -->
    <Connector port="8080" protocol="org.apache.coyote.http11.Http11NioProtocol"
               connectionTimeout="20000"
               redirectPort="8443"
               maxParameterCount="5000"
               minSpareThreads="20"
               acceptCount="10000"
               disableUploadTimeout="true"
               enbaleLookups="false"
               URIEncoding="UTF-8"
               />
    ```

- 优化jvm内存参数。修改`/usr/local/tomcat/bin/catalina.sh`

- [Tomcat9参数配置](https://tomcat.apache.org/tomcat-9.0-doc/)

- 1.连接器参数：
    - maxThreads：Tomcat 服务器能够创建的最大工作线程数。
    - minSpareThreads：Tomcat 服务器保持的最小空闲工作线程数。
    - acceptCount：在拒绝连接之前，连接器所允许的最大连接数。
    - maxConnections：允许的最大连接数。
    - connectionTimeout：等待客户端请求的超时时间。
- 2.NIO 连接器参数（可选）：
    - maxThreads：最大线程数。
    - minSpareThreads：最小空闲线程数。
    - selectorTimeout：选择器超时时间。
    - acceptorThreadCount：接收线程数。
- 3.HTTP 头部配置参数：
    - compression：启用 HTTP 响应内容的压缩。
    - compressionMinSize：启用压缩的最小字节阈值。
    - compressableMimeType：需要进行压缩的 MIME 类型。
    - useSendfile：是否使用 sendfile() 系统调用来传输文件。
- 4.JVM 参数：
    - 内存参数：-Xmx（最大堆内存）、-Xms（初始堆内存）、-XX:MaxPermSize（永久代最大内存）等。
    - 垃圾收集器参数：-XX:+UseConcMarkSweepGC、-XX:+UseG1GC 等。
    - 线程栈大小：-Xss。
- 5.数据库连接池参数（如果使用）：
    - maxActive：最大活动连接数。
    - maxIdle：最大空闲连接数。
    - minIdle：最小空闲连接数。
    - maxWait：获取连接的最大等待时间。
    - validationQuery：连接验证查询。
- 6.应用程序配置参数：
    - 缓存策略：控制静态资源的缓存时间。
    - 日志级别：限制日志输出的详细程度。
    - 调试模式：是否启用调试模式以进行详细的日志记录。
- 7.操作系统参数：
    - 文件描述符限制：调整操作系统的文件描述符限制以容纳更多的连接。
    - 网络参数：调整 TCP 缓冲区大小、调整 TCP 连接超时时间等。
- 8.监控和调优工具：
    - JConsole、VisualVM、Glowroot 等用于监控 Tomcat 的工具，用于收集关键指标并进行性能调优。

- 这些是常见的 Tomcat 性能调优参数，但实际配置可能因具体情况而异。在进行调优时，建议根据应用程序的特点、负载情况、硬件资源和操作系统环境等因素进行适当调整

##### connector（连接器）和I/O模型

Tomcat 支持的 I/O 模型有：

| IO模型              | 描述                                                                                                                                                                                                                                                                                             |
|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| BIO （JIoEndpoint） | 同步阻塞式IO，即Tomcat使用传统的java.io进行操作。该模式下每个请求都会创建一个线程，对性能开销大，不适合高并发场景。优点是稳定，适合连接数目小且固定架构。Tomcat8.5.x开始移除BIO。                                                                                                               |
| NIO（NioEndpoint）  | 同步非阻塞式IO，jdk1.4 之后实现的新IO。该模式基于多路复用选择器监测连接状态再同步通知线程处理，从而达到非阻塞的目的。比传统BIO能更好的支持并发性能。Tomcat 8.0之后默认采用该模式。NIO方式适用于连接数目多且连接比较短（轻操作） 的架构， 比如聊天服务器， 弹幕系统， 服务器间通讯，编程比较复杂 |
| AIO (Nio2Endpoint)  | 异步非阻塞式IO，jdk1.7后之支持 。与nio不同在于不需要多路复用选择器，而是请求处理线程执行完成进行回调通知，继续执行后续操作。Tomcat 8之后支持。一般适用于连接数较多且连接时间较长的应用                                                                                                         |
| APR（AprEndpoint）  | 全称是 Apache Portable Runtime/Apache可移植运行库)，是Apache HTTP服务器的支持库。AprEndpoint 是通过 JNI 调用 APR 本地库而实现非阻塞 I/O 的。使用需要编译安装APR 库                                                                                                                               |

注意：Linux 内核没有很完善地支持异步 I/O 模型，因此 JVM 并没有采用原生的 Linux 异步 I/O，而是在应用层面通过 epoll 模拟了异步 I/O 模型。因此在 Linux 平台上，Java NIO 和 Java NIO2 底层都是通过 epoll 来实现的，但是 Java NIO 更加简单高效。

- 在 Tomcat 中，EndPoint 组件的主要工作就是处理 I/O
    - NioEndpoint 利用 Java NIO API 实现了多路复用 I/O 模型。
    - Tomcat的NioEndpoint 是基于主从Reactor多线程模型设计的
    ![image](./Pictures/nginx/tomcat-NioEndPoint.avif)
    - LimitLatch 是连接控制器，它负责控制最大连接数，NIO 模式下默认是 10000(tomcat9中8192)，当连接数到达最大时阻塞线程，直到后续组件处理完一个连接后将连接数减 1。注意到达最大连接数后操作系统底层还是会接收客户端连接，但用户层已经不再接收。
    - Acceptor 跑在一个单独的线程里，它在一个死循环里调用 accept 方法来接收新连接，一旦有新的连接请求到来，accept 方法返回一个 Channel 对象，接着把 Channel 对象交给 Poller 去处理。

- NIO 和 NIO2 最大的区别是，一个是同步一个是异步。异步最大的特点是，应用程序不需要自己去触发数据从内核空间到用户空间的拷贝。

    ![image](./Pictures/nginx/tomcat-Nio2EndPoint.avif)

    - Nio2Endpoint 中没有 Poller 组件，也就是没有 Selector。在异步 I/O 模式下，Selector 的工作交给内核来做了。

- 如何选I/O模型：

    - I/O 调优实际上是连接器类型的选择，一般情况下默认都是 NIO，在绝大多数情况下都是够用的，除非你的 Web 应用用到了 TLS 加密传输，而且对性能要求极高，这个时候可以考虑 APR，因为 APR 通过 OpenSSL 来处理 TLS 握手和加密 / 解密。OpenSSL 本身用 C 语言实现，它还对 TLS 通信做了优化，所以性能比 Java 要高。

    - 如果你的 Tomcat 跑在 Windows 平台上，并且 HTTP 请求的数据量比较大，可以考虑 NIO2，这是因为 Windows 从操作系统层面实现了真正意义上的异步 I/O，如果传输的数据量比较大，异步 I/O 的效果就能显现出来。
        ```
        <!-- 修改protocol属性, 使用NIO2 -->
        <Connector port="8080" protocol="org.apache.coyote.http11.Http11Nio2Protocol"
                   connectionTimeout="20000"
                   redirectPort="8443" />
        ```

- tomcat connector（连接器）有3种运行模式：

    - BIO（阻塞式I/O）：使用传统的java I/O操作（即java.io包及其子包）
        - 默认值，性能最差

    - NIO（非阻塞式I/O）：java SE1.4后提供的一种新I/O操作（即java.nio包及其子包）

        - java nio基于一个缓冲区。有更好的并发性能

        - 让tomcat以NIO模式运行，修改配置文件`/usr/local/tomcat/conf/server.xml`
            ```xml
            # 原值
            <Connector port="8080" protocol="HTTP/1.1"
                       connectionTimeout="20000"
                       redirectPort="8443"
                       maxParameterCount="1000"
                       />
            # 修改protocol的值为org.apache.coyote.http11.Http11NioProtocol
            <Connector port="8080" protocol="org.apache.coyote.http11.Http11NioProtocol"
                       connectionTimeout="20000"
                       redirectPort="8443"
                       maxParameterCount="1000"
                       />
            ```

    - APR（apache可移植运行时库）：以JNI的形式调用apache http服务器的核心动态链接库处理文件读取或网络传输操作，从而大大提高tomcat对静态文件的处理性能，从操作系统级别解决异步I/O问题

        - 是运行高并发的首选

        - 安装tomcat-native

            ```sh
            # 必须安装APR和tomcat-native
            yum install -y apr apr-devel

            # 只有源码安装才有tomcat-native.tar.gz文件。archlinux的包管理器安装则没有
            cd /usr/local/tomcat/bin/
            tar xzfv tomcat-native.tar.gz
            cd tomcat-native-2.0.6-src/native

            # 编译选项
            ./configure --with-apr=/usr/bin/apr-1-config
            # 编译
            make -j$(nproc)
            # 安装
            make install
            ```

        - 设置环境变量
            ```sh
            export CATALINA_OPTS=-Djava.library.path=/usr/local/apr/lib
            ```

        - 让tomcat以APR模式运行，修改配置文件`/usr/local/tomcat/conf/server.xml`
            ```xml
            # 原值
            <Connector port="8080" protocol="HTTP/1.1"
                       connectionTimeout="20000"
                       redirectPort="8443"
                       maxParameterCount="1000"
                       />
            # 修改protocol的值为org.apache.coyote.http11.Http11NioProtocol
            <Connector port="8080" protocol="org.apache.coyote.http11.Http11NioProtocol"
                       connectionTimeout="20000"
                       redirectPort="8443"
                       maxParameterCount="1000"
                       />
            ```

##### 线程池的并发调优

- 线程池调优指的是给 Tomcat 的线程池设置合适的参数，使得 Tomcat 能够又快又好地处理请求。

![image](./Pictures/nginx/tomcat-线程池.avif)

- `/usr/local/tomcat/conf/server.xml`配置线程池
    ```xml
    <!--
    namePrefix: 线程前缀
    maxThreads: 最大线程数，默认设置 200，一般建议在 500 ~ 1000，根据硬件设施和业务来判断
    minSpareThreads: 核心线程数，默认设置 25
    prestartminSpareThreads: 在 Tomcat 初始化的时候就初始化核心线程
    maxQueueSize: 最大的等待队列数，超过则拒绝请求 ，默认 Integer.MAX_VALUE
    maxIdleTime: 线程空闲时间，超过该时间，线程会被销毁，单位毫秒
    className: 线程实现类,默认org.apache.catalina.core.StandardThreadExecutor
    -->
    <Executor name="tomcatThreadPool" namePrefix="catalina-exec-Fox"
              prestartminSpareThreads="true"
              maxThreads="500" minSpareThreads="10"  maxIdleTime="10000"/>
              
    <Connector port="8080" protocol="HTTP/1.1"  executor="tomcatThreadPool"
               connectionTimeout="20000"
               redirectPort="8443" URIEncoding="UTF-8"/>
    ```

- 这里面最核心的就是如何确定 maxThreads 的值，如果这个参数设置小了，Tomcat 会发生线程饥饿，并且请求的处理会在队列中排队等待，导致响应时间变长；如果 maxThreads 参数值过大，同样也会有问题，因为服务器的 CPU 的核数有限，线程数太多会导致线程在 CPU 上来回切换，耗费大量的切换开销。

- 理论上我们可以通过公式 线程数 = CPU 核心数 *（1+平均等待时间/平均工作时间），计算出一个理想值，这个值只具有指导意义，因为它受到各种资源的限制，实际场景中，我们需要在理想值的基础上进行压测，来获得最佳线程数。

##### SpringBoot中调整Tomcat参数

- 方式1：yml中配置 （属性配置类：ServerProperties）

    ```yml
    server:
      tomcat:
        threads:
          min-spare: 20
          max: 500
        connection-timeout: 5000ms
    ```

- SpringBoot中的TomcatConnectorCustomizer类可用于对Connector进行定制化修改。

    ```java
    @Configuration
    public class MyTomcatCustomizer implements
            WebServerFactoryCustomizer<TomcatServletWebServerFactory> {
     
        @Override
        public void customize(TomcatServletWebServerFactory factory) {
            factory.setPort(8090);
            factory.setProtocol("org.apache.coyote.http11.Http11NioProtocol");
            factory.addConnectorCustomizers(connectorCustomizer());
        }
     
        @Bean
        public TomcatConnectorCustomizer connectorCustomizer(){
            return new TomcatConnectorCustomizer() {
                @Override
                public void customize(Connector connector) {
                    Http11NioProtocol protocol = (Http11NioProtocol) connector.getProtocolHandler();
                    protocol.setMaxThreads(500);
                    protocol.setMinSpareThreads(20);
                    protocol.setConnectionTimeout(5000);
                }
            };
        }
     
    }
    ```

##### 监控Tomcat的性能

- Tomcat 的关键指标：吞吐量、响应时间、错误数、线程池、CPU 以及 JVM 内存。
    - 前三个指标是我们最关心的业务指标，Tomcat 作为服务器，就是要能够又快有好地处理请求，因此吞吐量要大、响应时间要短，并且错误数要少。
    - 后面三个指标是跟系统资源有关的，当某个资源出现瓶颈就会影响前面的业务指标，比如线程池中的线程数量不足会影响吞吐量和响应时间
        - 但是线程数太多会耗费大量 CPU，也会影响吞吐量；当内存不足时会触发频繁地 GC，耗费 CPU，最后也会反映到业务指标上来。

###### 通过 JConsole 监控 Tomcat

- 1.开启 JMX 的远程监听端口

    - 我们可以在 Tomcat 的 bin 目录`/usr/local/tomcat/bin/`下新建一个名为setenv.sh的文件（或者setenv.bat，根据你的操作系统类型），然后输入下面的内容：
    ```sh
    export JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote"
    export JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.port=8011"
    export JAVA_OPTS="${JAVA_OPTS} -Djava.rmi.server.hostname=x.x.x.x"
    export JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.ssl=false"
    export JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.authenticate=false"
    ```

- 2.重启 Tomcat，这样 JMX 的监听tomcat端口（我这里为8080）就开启了，接下来通过 JConsole 来连接这个端口。
    ```sh
    # 启动jconsole监听tomcat。选择Local Process：选项
    jconsole 127.0.0.1:8080
    ```
    ![image](./Pictures/nginx/jconsole.avif)

- 在`MBeans`标签页：有Tomcat的统计信息。
    ![image](./Pictures/nginx/jconsole-MBeans标签页.avif)

- 在`Threads`标签页：可以看到当前 Tomcat 进程中有多少线程
    ![image](./Pictures/nginx/jconsole-Threads标签页.avif)

- 在`Memory`标签页：能看到 Tomcat 进程的 JVM 内存使用情况
    ![image](./Pictures/nginx/jconsole-Memory标签页.avif)

###### 命令行查看 Tomcat 指标

- 极端情况下如果 Web 应用占用过多 CPU 或者内存，又或者程序中发生了死锁，导致 Web 应用对外没有响应，监控系统上看不到数据，这个时候需要我们登陆到目标机器，通过命令行来查看各种指标。

```sh
# ps 命令找到 Tomcat 进程，拿到进程 ID
ps -ef|grep tomcat

# 查看tomcat进程状态的大致信息。（我这里的tomcat进程pid为20316）
cat /proc/20316/status

# 监控进程的 CPU 和内存资源使用情况
top -p 20316
# or
htop -p 20316

# 查看 Tomcat 的网络连接，比如 Tomcat 在 8080 端口上监听连接请求
netstat -na | grep 8080

# 统计ESTAB、TIME_WAIT状态的连接数
netstat -na | grep ESTAB | grep 8080 | wc -l
netstat -na | grep TIME_WAIT | grep 8080 | wc -l

# 通过 ifstat 来查看网络流量，大致可以看出 Tomcat 当前的请求数和负载状况。
ifstat
```


#### zrlog使用java开发的博客

```sh
# 安装
wget http://dl.zrlog.com/release/zrlog.war /usr/share/tomcat7/webapps

# 访问
http://127.0.0.1:8080/zrlog/install
```

![image](./Pictures/nginx/zrlog.avif)

- zrlog 连接 mysql

```sh
mariadb -uroot -h127.0.0.1 -pYouPassward
# 创建
create database zrlog;
# 密码
grant all on zrlog.* to 'zrlog'@127.0.0.1 identified by 'YouPassward'
quit

# 登录
mariadb -uzrlog -h127.0.0.1 -pYouPassward
# 查看数据
show databases;
# 显示成功后即可连接
quit
```

![image](./Pictures/nginx/zrlog1.avif)

##### nginx 反向代理 zrlog

```sh
server
{
    listem 80;
    server_name example.com;

    location / {
        proxy_pass http://example.com:8081/zrlog/;
        proxy_set_header HOST $host;
        proxy_set_header X-Real_IP $remote_addr;
        proxy_set_header X-Forwared-For $proxy_add_x_forwarded_for;
    }

    access_log /var/log/nginx/zrlog-access.log;
    error_log  /var/log/nginx/zrlog-error.log;
}
```


### php-fpm

- cgi公共网关接口：是http服务器与本机或其他机器上的程序通信工具
    - cgi可以使用任何一种语言编写。
    - 缺点：性能很差：每次http服务器遇到动态请求都需要重新启动脚本解析器，然后将结果返回http服务器

- fastcgi：从cgi发展而来。
    - 采用C/S架构，将http服务器与脚本服务器分开；同时脚本服务器启动一个或多个脚本守护程序
    - 脚本服务器每次遇到动态请求时，直接交付给fastcgi进程执行，然后将得到的结果返回浏览器
    - fastcgi只是一个协议，将cgi解释器进程保持在内存中。

- nginx无法直接处理动态请求，也无法直接调用php。要让nginx和php协同工作需要php-fpm

    - nginx提供一个fastcgi模块来将http请求映射为对应的fastcgi请求。——这样就可以将请求发送给php-fpm了

    - php-fpm(PHP FastCGI Process Manager)：php-fpm实现fastcgi进程叫php-cgi。是第三方的 FastCGI 进程管理器。最初作为第三方补丁，现在已经集成到php源码中。

        - 安装指定`--enable-fpm`

    - php-fpm管理的进程包含
        - master进程：只有一个。负责监听端口，接受web server的请求
        - worker进程：一般有多个。每个进程内部都嵌入一个php解释器，是php代码真正执行的地方

- 安装编译php

    ```sh
    # 官网https://www.php.net/
    # 下载源码
    curl -LO https://www.php.net/distributions/php-8.3.2.tar.gz
    tar zxvf php-8.3.2.tar.gz
    cd php-8.3.2

    # 编译设置
    ./configure --prefix=/usr/local/php8 \
        --enable-fpm \
        --with-pdo-mysql=mysqlnd \
        --with-zlib \
        --with-curl \
        --with-gd \
        --with-jpeg-dir \
        --with-png-dir \
        --with-freetype-dir \
        --with-openssl \
        --enable-mbstring \
        --enable-xml \
        --enable-session \
        --enable-ftp \
        --enable-pdo -enable-tokenizer \
        --enable-zip \
        --with-fpm-user=www \
        --with-fpm-group=www \

    # --enalbe-fpm启用php-fpm功能
    # --with-pdo-mysql=mysqlnd 表示使用mysqlnd驱动。pdo的api可以无缝切换数据库，比如从oracle到mysql，仅仅需要修改很少的代码。类似于jdbc、odbc、dbi之类接口。这里的--pdo-mysql表示与mysql进行连接的方式。mysqlnd是php官方的mysql驱动代码，代替就得libmysql驱动（mysql官方的驱动）

    # --with-fpm-user=www 指定以www用户启动。因此需要新建用户
    useradd www

    # 编译
    make -j$(nproc)
    # 安装
    make install

    # 复制
    cp php.ini-production /usr/local/php8/lib/php.ini
    cp sapi/fpm/php-fpm.service /usr/lib/systemd/system/

    # 创建二进制文件的硬连接
    ln /usr/local/php8/bin/php /bin/php
    ```

- 启动php-fpm

    ```sh
    # 复制php-fpm配置文件
    cp /usr/local/php8/etc/php-fpm.conf.default /usr/local/php8/etc/php-fpm.conf
    cp /usr/local/php8/etc/php-fpm.d/www.conf.default /usr/local/php8/etc/php-fpm.d/www.conf

    # 之前已经把service复制到system里了。直接启动
    systemctl enable php-fpm
    systemctl start php-fpm
    systemctl status php-fpm
    ```


- 以下为优化php-fpm。如果php-fpm可以启动，则php的配置已经完成，只需在nginx配置fastcgi即可


    - 可配置多个`pool`（默认配置：1个）

        - 如果 nginx 有多个站点，都使用一个 pool，则会有单点错误。因此建议每个站点都配置一个 pool

    - php-fpm.conf

        ```sh
        pid = /var/log/php-fpm/php-fpm.pid
        include=/etc/php/php-fpm.d/*.conf
        ```

    - 配置文件`/etc/php/php-fpm.d/www.conf`

        | 参数                 | 内容                                                                                                                                           |
        | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
        | pm = dynamic         | 动态管理                                                                                                                                       |
        | pm.max_children      | 静态方式下开启的 php-fpm 进程数量，在动态方式下他限定 php-fpm 的最大进程数（这里要注意 pm.max_spare_servers 的值只能小于等于 pm.max_children） |
        | pm.start_servers     | 动态方式下的起始 php-fpm 进程数量                                                                                                              |
        | pm.min_spare_servers | 动态方式空闲状态下的最小 php-fpm 进程数量                                                                                                      |
        | pm.max_spare_servers | 动态方式空闲状态下的最大 php-fpm 进程数量                                                                                                      |

        ```sh
        # 慢执行日志配置
        request_slowlog_timeout = 1
        slowlog = /var/log/php-fpm/www-slow.log
        ```

    - php.ini

        ```sh
        # 设置errors日志
        error_log = /var/log/php-fpm/php_errors.log
        ```

        **sed** 快速设置 errors 日志

        ```sh
        sed -i "/;error_log = php_errors.log/cerror_log = /var/log/php-fpm/php_errors.log" /etc/php/php.ini
        # 需要自己创建文件
        sudo mkdir /var/log/php-fpm
        touch /var/log/php-fpm/php_errors.log
        ```

#### nginx配置fastcgi

- C/C++ FastCGI常用apache的`mod_fastcgi`模块，PHP常用`spawn-fcgi`和`PHP-FPM`。

- 现在更多是用nginx的反向代理功能，把HTTP请求转发到后端的trpc服务直接处理。这里的trpc服务就有点FastCGI的感觉，但不用与nginx部署在一起了。

- 配置`php-fpm`：

```nginx
server {
    listen 80;
    server_name localhost;

    location ~ \.php$ {
        root html;

        # php-fpm的监听端口为9000
        fastcgi_pass  localhost:9000; # 也可以是unix_sock fastcgi_pass  unix:/var/run/php-fpm/php80fpm.sock;

        fastcgi_index index.php;

        # $document_root 与 root 指令的值是一样的，变量 $fastcgi_script_name 的值为请求URI，即 /index.php。
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param QUERY_STRING    $query_string;
    }
}
```

- 测试

    ```sh
    # 创建php文件。输出phpinfo
    echo "<?php phpinfo(); ?>" > /usr/local/nginx/html/tz.php

    # 客户端测试
    curl http://127.0.0.1/tz.php | php
    ```

### cgit

- [arch文档](https://wiki.archlinux.org/title/Cgit)

- 使用fcgiwrap

```sh
# 安装并启动fcgiwrap
systemctl restart fcgiwrap.socket
```

```nginx
  server {
    listen                8086;
    server_name           localhost;
    root                  /usr/share/webapps/cgit;
    try_files             $uri @cgit;

    location @cgit {
      include             fastcgi_params;
      fastcgi_param       SCRIPT_FILENAME $document_root/cgit.cgi;
      fastcgi_param       PATH_INFO       $uri;
      fastcgi_param       QUERY_STRING    $args;
      fastcgi_param       HTTP_HOST       $server_name;
      fastcgi_pass        unix:/run/fcgiwrap.sock;
    }
  }
```

- 使用uwsgi

```nginx
server {
  listen                8086;
  server_name           localhost;
  root /usr/share/webapps/cgit;

  # Serve static files with nginx
  location ~* ^.+(cgit.(css|png)|favicon.ico|robots.txt) {
    root /usr/share/webapps/cgit;
    expires 30d;
  }
  location / {
    try_files $uri @cgit;
  }
  location @cgit {
    gzip off;
    include uwsgi_params;
    uwsgi_modifier1 9;
    uwsgi_pass unix:/run/uwsgi/cgit.sock;
  }
}
```

### 负载均衡

- 负载均衡：分摊到多个操作单元上进行执行，例如：Web服务器、FTP服务器、企业关键应用服务器和其它关键任务服务器等，从而共同完成工作任务。

    - 简单而言就是当有2台或以上服务器时，根据规则将请求分发到指定的服务器上处理，负载均衡配置一般都需要同时配置反向代理，通过反向代理跳转到负载均衡。

![image](./Pictures/nginx/负载均衡.avif)

- 7层负载均衡：upstream模块
- 4层负载均衡：stream模块

#### stream：4层负载均衡

- [官方文档：各种指令解释](http://nginx.org/en/docs/stream/ngx_stream_core_module.html)

- nginx1.9版本后才有stream模块，可以支持四层负载均衡

- nginx安装编译需要加入选项。

    ```sh
    # 编译需要加入stream选项。
    ./configure --prefix=/usr/local/nginx \
         --with-stream  \
    ```

- nginx配置

    ```nginx
    events {}

    # stream不在http块里面
    stream {
        upstream backend {
            # 转发到80端口
            server 127.0.0.1:80;
        }
        server {
            # 监听90端口
            listen 90;
            proxy_pass backend;
        }
    }

    http {}
    ```

- 测试：`curl http://127.0.0.1:90`

#### upstream：7层负载均衡

- upstream指令设置负载均衡：

    - 在 upstream 内可使用的指令：
        - server 定义上游服务器地址；
        - zone 定义共享内存，用于跨 worker 子进程；
        - keepalive 对上游服务启用长连接；
        - keepalive_requests 一个长连接最多请求 HTTP 的个数；
        - keepalive_timeout 空闲情形下，一个长连接的超时时长；
        - hash 哈希负载均衡算法；
        - ip_hash 依据 IP 进行哈希计算的负载均衡算法；
        - least_conn 最少连接数负载均衡算法；
        - least_time 最短响应时间负载均衡算法；
        - random 随机负载均衡算法；

    ```nginx
    http {
        upstream backend-servers {
            server x1.google.com;    # 可以是域名
            server x2.google.com;
            # server 106.xx.xx.xxx;        可以是ip
            # server 106.xx.xx.xxx:8080;   可以带端口号
            # server unix:/tmp/xxx;        支出socket方式

            # server x3.google.com
                                    # down                不参与负载均衡
                                    # weight=5;           权重，越高分配越多
                                    # backup;             预留的备份服务器
                                    # max_fails=number    允许失败的次数
                                    # fail_timeout=time   超过失败次数后，服务暂停时间
                                    # max_coons=number    限制上游服务器的最大的接受的连接数
                                    # 根据服务器性能不同，配置适合的参数
        }

        server {
            location / {
                proxy_pass  http://backend-servers;
            }
        }
    }
    ```

#### 7层负载均衡策略

- nginx 目前支持自带 4 种负载均衡策略，还有 2 种常用的第三方策略。

- 1:轮询（默认）：每个请求按时间顺序逐一分配到不同的后端服务器，如果有后端服务器挂掉，能自动剔除。
    - 但是如果其中某一台服务器压力太大，出现延迟，会影响所有分配在这台服务器下的用户。

    ```nginx
    http {
        upstream test.com {
            server 192.168.1.12:8887;
            server 192.168.1.13:8888;
        }
        server {
            location /api {
                proxy_pass  http://test.com;
            }
        }
    }
    ```

- 2:weight（权重）：可以给不同的后端服务器设置一个权重值（weight），用于调整不同的服务器上请求的分配率。权重数据越大，被分配到请求的几率越大；该权重值，主要是针对实际工作环境中不同的后端服务器硬件配置进行调整的。

    ```nginx
    http {
        # 10 次请求中大概 1 次访问到 8888 端口，9 次访问到 8887 端口：
        upstream test.com {
            server 192.168.1.12:8887 weight=9;
            server 192.168.1.13:8888 weight=1;
        }
        server {
            location /api {
                proxy_pass  http://test.com;
            }
        }
    }
    ```

- 3:ip_hash（客户端 ip 绑定）：每个请求按照访问 Ip（即 Nginx 的前置服务器或客户端 IP）的 hash 结果分配。来自同一个 ip 的请求永远只分配一台服务器。
    - 需要一个客户只访问一个服务器，那么就需要用 ip_hash 了
    - 解决 session 一致问题：比如把登录信息保存到了 session 中，那么跳转到另外一台服务器的时候就需要重新登录了。

    ```nginx
    http {
        upstream test.com {
         ip_hash;
            server 192.168.1.12:8887;
            server 192.168.1.13:8888;
        }
        server {
            location /api {
                proxy_pass  http://test.com;
            }
        }
    }
    ```

    - 常见错误：每个客户端的前三个八位字节都是相同的（都为 10.10.20），因此它们的哈希值也都是相同的，没法将流量分配到不同服务器。

        - 默认的哈希键是 IPv4 地址或整个 IPv6 地址的前三个八位字节

        ```nginx
        http {
            upstream {
                ip_hash;
                server 10.10.20.105:8080;
                server 10.10.20.106:8080;
                server 10.10.20.108:8080;
            }

            server {# …}
        }
        ```

        - 解决方法：是在哈希算法中使用 $binary_remote_addr 变量作为哈希键。该变量捕获完整的客户端地址，将其转换为二进制表示，IPv4 地址为 4 个字节，IPv6 地址为 16 个字节。
            - 我们还添加了 `consistent` 参数以使用 ketama 哈希方法而不是默认值。这大大减少了在服务器集更改时重新映射到不同上游服务器的键的数量，为缓存服务器带来了更高的缓存命中率。

            ```nginx
            http {
                upstream {
                    hash $binary_remote_addr consistent;
                    server 10.10.20.105:8080;
                    server 10.10.20.106:8080;
                    server 10.10.20.108:8080;
                }

                server {# …}
            }
            ```

- 4.least_conn（最小连接数策略）：将请求优先分配给压力较小的服务器，它可以平衡每个队列的长度，并避免向压力大的服务器添加更多的请求。

    ```nginx
    http {
        upstream test.com {
         least_conn;
            server 192.168.1.12:8887;
            server 192.168.1.13:8888;
        }
        server {
            location /api {
                proxy_pass  http://test.com;
            }
        }
    }
    ```

- 5:fair最快响应时间策略（需要安装 upstream_fair 模块）：公平地按照后端服务器的响应时间（rt）来分配请求。响应时间短处理效率高的服务器分配到请求的概率高，响应时间长处理效率低的服务器分配到的请求少。

    ```nginx
    http {
        upstream test.com {
         fair;
            server 192.168.1.12:8887;
            server 192.168.1.13:8888;
        }
        server {
            location /api {
                proxy_pass  http://test.com;
            }
        }
    }
    ```

- 6:url_hash（需要安装 Nginx 的 upstream_hash 模块）：与 ip_hash 类似，但是按照访问 url 的 hash 结果来分配请求，使得每个 url 定向到同一个后端服务器，主要应用于后端服务器为缓存的场景下。

    - 采用 HAproxy 的 loadbalance uri 或者 nginx 的 upstream_hash 模块，都可以做到针对 url 进行哈希算法式的负载均衡转发。

    ```nginx
    http {
        upstream test.com {
         hash $request_uri;
         hash_method crc32;
         server 192.168.1.12:8887;
         server 192.168.1.13:8888;
        }
        server {
            location /api {
                proxy_pass  http://test.com;
            }
        }
    }
    ```

#### 7层负载均衡基本配置

- 配置负载均衡

    - 121.42.11.34 服务器作为上游服务
        ```nginx
        server{
          listen 8020;
          location / {
           return 200 'return 8020 \n';
          }
        }

        server{
          listen 8030;
          location / {
           return 200 'return 8030 \n';
          }
        }

        server{
          listen 8040;
          location / {
           return 200 'return 8040 \n';
          }
        }
        ```

    - 121.5.180.193 服务器作为代理服务器

        ```nginx
        upstream demo_server {
          server 121.42.11.34:8020;
          server 121.42.11.34:8030;
          server 121.42.11.34:8040;
        }

        server {
          listen 80;
          server_name balance.lion.club;

          location /balance/ {
           proxy_pass http://demo_server;

           # 自动故障转移。遇到500、502、503、504、执行超时等错误，nginx会将请求转发到upstream负载均衡组中的另一台服务器
           proxy_next_upstream http_500 http_502 http_503 http_504 error timeout invalid_header;

           # 可以使用include指令，把独立的proxy相关的配置加载进来
           include /usr/local/nginx/conf/proxy.conf
          }
        }
        ```

    - /etc/hosts文件添加`121.5.180.193 balance.lion.club`

    - 测试：执行多次`curl http://balance.lion.club/balance/`

#### 多tomcat的7层负载均衡

```nginx
# 3台tomcat
upstream mytomcats {
    server 121.42.11.34:8080;
    server 121.42.11.35:8080;
    server 121.42.11.36:8080;
}

server {
    listen 80;
    server_name localhost;

    # 所有静态请求都由nginx处理
    location ~* \.(gif|jpg|jpeg|png|webp|avif|bmp|swf|fly|wma|asf|mp3|mmf|zip|rar)$ {
        root    /usr/local/resource;
        expires     10h; # 设置过期时间为10小时。用户在 10 小时内请求的时候，都只会访问浏览器中的缓存，而不会去请求 nginx 。
    }

    # tomcat
    location / {
        proxy_pass http://mytomcats;

        # 传递代理服务器的头部
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # 自动故障转移。遇到500、502、503、504、执行超时等错误，nginx会将请求转发到upstream负载均衡组中的另一台服务器
        proxy_next_upstream http_500 http_502 http_503 http_504 error timeout invalid_header;
    }
}
```

### 缓存

- 缓存对于Web服务至关重要，尤其对于大型高负载Web站点。缓存作为性能优化的一个重要手段，可以在极大程度上减轻后端服务器的负载。通常对于静态资源，即不经常更新的资源，如图片，CSS或JS等进行缓存，而不用每次都向服务器请求，这样就可以减轻服务器的压力。

- 缓存可以分为客户端缓存和服务端缓存。

    - 1.客户端缓存指的是浏览器缓存, 浏览器缓存是最快的缓存, 因为它直接从本地获取(但有可能需要发送一个协商缓存的请求), 它的优势是可以减少网络流量, 加快请求速度。

    - 2.服务端缓存指的是反向代理服务器或CDN的缓存, 他的作用是用于减轻后端实际的Web Server的压力。

- [客户端缓存（浏览器缓存）](https://github.com/ztoiax/notes/blob/master/net-kernel.md#客户端缓存（浏览器缓存）)

#### 服务端缓存

- [Se7en的架构笔记：Nginx缓存详解（二）之服务端缓存](https://mp.weixin.qq.com/s/MqH0PhK0fYdcTPySNqKzMg)

- proxy cache属于服务端缓存，主要实现 nginx 服务器对客户端数据请求的快速响应。

- nginx 服务器在接收到被代理服务器的响应数据之后
    - 一方面将数据传递给客户端
    - 另一方面根据proxy cache的配置将这些数据缓存到本地硬盘上。

    - 当客户端再次访问相同的数据时，nginx服务器直接从硬盘检索到相应的数据返回给用户，从而减少与被代理服务器交互的时间。

![image](./Pictures/nginx/缓存-服务端缓存.avif)

##### 配置缓存

- 缓存状态`$upstream_cache_status`变量：它存储了缓存是否命中的信息，会设置在响应头信息中，在调试中非常有用。

    | 状态        | 说明                                                                         |
    |-------------|------------------------------------------------------------------------------|
    | MISS        | 未命中缓存，请求被传送到后端服务器。                                         |
    | HIT         | 命中缓存，使用缓存响应客户端。                                               |
    | EXPIRED     | 缓存已经过期，请求被传送到后端。                                             |
    | UPDATING    | 正在更新缓存，nginx使用过期缓存的响应客户端。                                |
    | STALE       | 当后端服务器出错时，nginx用缓存响应客户端。                                  |
    | BYPASS      | 缓存被绕过了，请求被传送到后端服务器。                                       |
    | REVALIDATED | nginx通过过期缓存中的Etag和Last-Modified字段的值向被代理服务器发起验证请求。 |

- 缓存多久

    | 参数（优先级从高到低） | 位置         |
    |------------------------|--------------|
    | inactive               | 代理服务器   |
    | X-Accel-Expires        | 被代理服务器 |
    | Cache-Control          | 被代理服务器 |
    | expires                | 被代理服务器 |
    | proxy_cache_valid      | 代理服务器   |

###### 缓存相关指令

- 指令

    - proxy_cache：可以直接从代理服务器获得，从而减少上游服务器的压力

        ```nginx
        语法：proxy_cache zone | off ; # zone 是共享内存的名称

        默认值：proxy_cache off;

        上下文：http、server、location
        ```

    - proxy_cache_path：缓存文件的存放路径

        ```nginx
        语法：proxy_cache_path path [level=levels] ...可选参数省略，下面会详细列举

        默认值：proxy_cache_path off

        上下文：http
        ```

        - path 缓存文件的存放路径；
        - level path 的目录层级；
        - keys_zone 设置共享内存；
        - inactive 在指定时间内没有被访问，缓存会被清理，默认10分钟；

- 指令：影响缓存的HTTP 响应

    - proxy_cache_valid：配置什么状态码可以被缓存，以及缓存时长，可以配置多条。

        ```nginx
        语法：proxy_cache_valid [code...] time;

        上下文：http、server、location

        配置示例：proxy_cache_valid 200 304 2m;; # 说明对于状态为 200 和 304 的缓存文件的缓存时间是 2 分钟
        ```

- 指令：通过nginx变量限制是否使用缓存

    - proxy_no_cache：定义相应保存到缓存的条件，如果字符串参数的至少一个值不为空且不等于“ 0”，则将不保存该响应到缓存。

        ```nginx
        语法：proxy_no_cache string;

        上下文：http、server、location

        示例：proxy_no_cache $http_pragma    $http_authorization;
        ```

    - proxy_cache_bypass：该参数设定，什么情况下的请求不读取cache而是直接从后端的服务器上获取资源。这里的string通常为nginx的的一些内置变量或者自己定义的变量。

        ```nginx
        语法：proxy_cache_bypass string;

        上下文：http、server、location

        示例：proxy_cache_bypass $http_pragma    $http_authorization;
        ```

        - 当客户端访问请求中带有nocache或者comment参数时，不使用缓存数据。
        ```sh
        ❯ curl http://192.168.1.134/cache/?nocache=1  -I
        HTTP/1.1 200 OK
        Server: nginx/1.14.2
        Date: Sun, 10 Jan 2021 05:38:25 GMT
        Content-Type: text/html
        Content-Length: 26065
        Connection: keep-alive
        Last-Modified: Wed, 21 Oct 2020 14:17:08 GMT
        ETag: "5f9042e4-65d1"
        Cache-Control: max-age=10
        cache: BYPASS
        Accept-Ranges: bytes

        ❯ curl http://192.168.1.134/cache/?comment=3  -I
        HTTP/1.1 200 OK
        Server: nginx/1.14.2
        Date: Sun, 10 Jan 2021 05:38:29 GMT
        Content-Type: text/html
        Content-Length: 26065
        Connection: keep-alive
        Last-Modified: Wed, 21 Oct 2020 14:17:08 GMT
        ETag: "5f9042e4-65d1"
        Cache-Control: max-age=10
        cache: BYPASS
        Accept-Ranges: bytes
        ```

- 指令：定义缓存与请求间匹配的关键字

    - proxy_cache_key：设置nginx服务器在共享内存中为缓存数据建立索引时使用的关键字。

        ```nginx
        语法：proxy_cache_key

        默认值：proxy_cache_key $scheme$proxy_host$request_uri;

        上下文：http、server、location
        ```

        ![image](./Pictures/nginx/缓存-proxy_cache_key指令.avif)

- 指令：影响缓存的HTTP method

    - proxy_cache_methods：设置可以缓存的HTTP请求方法。

        ```nginx
        Syntax:  proxy_cache_methods GET | HEAD | POST ...;
        Default: proxy_cache_methods GET HEAD;
        Context: http, server, location
        This directive appeared in version 0.7.59.
        ```

    - proxy_cache_convert_head：当客户端一次使用HEAD方法请求时，nginx会通过GET方法向上游请求完整的header和body，只返回header给客户端。当客户端下次使用GET方法请求时，nginx会把缓存好的body返回给客户端，就不用去请求上游了。

        ```nginx
        Syntax:  proxy_cache_convert_head on | off;
        Default: proxy_cache_convert_head on;
        Context: http, server, location
        This directive appeared in version 1.9.7.
        ```

- 指令：影响缓存的HTTP header

    - proxy_ignore_headers：当被代理服务器的响应存在以下头部时，nginx不会缓存：

        - Set-Cookie
        - Cache-Control中存在以下项之一：
            - private
            - no-cache
            - no-store

    - 可以设置忽略被代理服务器的响应头。

        ```nginx
        Syntax:  proxy_ignore_headers field ...;
        Default: —
        Context: http, server, location

        示例：proxy_ignore_headers Set-Cookie Cache-Control;
        ```

- 指令：缓存请求次数

    - proxy_cache_min_uses：当客户端请求发送的次数达到设置次数后才会缓存该请求的响应数据，如果不想缓存低频请求可以设置此项。

    ```nginx
    Syntax:  proxy_cache_min_uses number;
    Default: proxy_cache_min_uses 1;
    Context: http, server, location
    ```

- 指令：缓冲区大小

    - proxy_buffering：默认是开启状态，当关闭时，nginx将不会对任何响应做缓存。

        ```nginx
        Syntax:  proxy_buffering on | off;
        Default: proxy_buffering on;
        Context: http, server, location
        ```

    - proxy_buffers：

        - 在内存中设置缓冲区存储被代理服务器响应的body所占用的buffer个数和每个buffer大小，默认情况下buffer size等于一个memory page，32为操作系统为4k,64位为8k。当buffer大小（内存）无法容纳被代理服务器响应数据时，会将响应数据存放在proxy_temp_path中定义的临时目录（硬盘）中。

        ```nginx
        Syntax:  proxy_buffers number size;
        Default: proxy_buffers 8 4k|8k;
        Context: http, server, location
        ```

- proxy_buffer_size

    - proxy_buffer_size 用来接受被代理服务器响应头，如果响应头超过了这个长度，nginx会报upstream sent too big header错误，然后client收到的是502。

    ```nginx
    Syntax:  proxy_buffer_size size;
    Default: proxy_buffer_size 4k|8k;
    Context: http, server, location
    ```

- proxy_busy_buffers_size

    - nginx将会尽可能的读取被代理服务器的数据到buffer，直到proxy_buffers设置的所有buffer被写满或者数据被读取完，此时nginx开始向客户端传输数据。如果数据很大的话，nginx会接收并把他们写入到temp_file里去，大小由proxy_max_temp_file_size 控制。当数据没有完全读完的时候,nginx同时向客户端传送的buffer大小不能超过 proxy_busy_buffers_size。

    ```nginx
    Syntax:  proxy_busy_buffers_size size;
    Default: proxy_busy_buffers_size 8k|16k;
    Context: http, server, location
    ```

- proxy_temp_path：定义proxy的临时文件存在目录以及目录的层级。

    ```nginx
    Syntax:  proxy_temp_path path [level1 [level2 [level3]]];
    Default: proxy_temp_path proxy_temp;
    Context: http, server, location
    ```

    - 例如：

        ```nginx
        proxy_temp_path /spool/nginx/proxy_temp 1 2;

        那么临时文件将会类似：
        /spool/nginx/proxy_temp/7/45/00000123457
        ```

    - proxy_temp_file_write_size：设置一次写入临时文件的数据的最大的大小。

        ```nginx
        Syntax:  proxy_temp_file_write_size size;
        Default: proxy_temp_file_write_size 8k|16k;
        Context: http, server, location
        ```

    - proxy_max_temp_file_size：设置临时文件的最大的大小。

        ```nginx
        Syntax:  proxy_max_temp_file_size size;
        Default: proxy_max_temp_file_size 1024m;
        Context: http, server, location
        ```

- 指令：超时时间

    - proxy_connect_timeout：设置和被代理服务器建立连接超时时间。

        ```nginx
        Syntax:  proxy_connect_timeout time;
        Default: proxy_connect_timeout 60s;
        Context: http, server, location
        ```

    - proxy_read_timeout：设置从被代理服务器读取响应的时间。

        ```nginx
        Syntax:  proxy_read_timeout time;
        Default: proxy_read_timeout 60s;
        Context: http, server, location
        ```

    - proxy_send_timeout：设置发送请求给被代理服务器的超时时间。
        ```nginx
        Syntax:  proxy_send_timeout time;
        Default: proxy_send_timeout 60s;
        Context: http, server, location
        ```

- 指令：并发回源请求

    - proxy_cache_lock：针对同一个key，仅允许一个请求回源去更新缓存，用于锁住并发回源请求。
        ```nginx
        Syntax:  proxy_cache_lock on | off;
        Default: proxy_cache_lock off;
        Context: http, server, location
        This directive appeared in version 1.1.12.
        ```

    - proxy_cache_lock_timeout：锁住请求的最长等待时间，超时后直接回源，但不会以此响应更新缓存。
        ```nginx
        Syntax:  proxy_cache_lock_timeout time;
        Default: proxy_cache_lock_timeout 5s;
        Context: http, server, location
        This directive appeared in version 1.1.12.
        ```

    - proxy_cache_lock_age：更新缓存的回源请求最大超时时间，超时后放行其他请求更新缓存。
        ```nginx
        Syntax:  proxy_cache_lock_age time;
        Default: proxy_cache_lock_age 5s;
        Context: http, server, location
        This directive appeared in version 1.7.8.
        ```

- 指令：历史缓存

    - proxy_cache_use_stale

        - 如果nginx在访问被代理服务器过程中出现被代理服务器无法访问或者访问出错等现象时，nginx服务器可以使用历史缓存响应客户端的请求，这些数据不一定和被代理服务器上最新的数据相一致，但对于更新频率不高的后端服务器来说，nginx服务器的该功能在一定程度上能够为客户端提供不间断访问。该指令用来设置一些状态，当被代理服务器处于这些状态时，nginx服务器启用该功能。

        ```nginx
        Syntax:  proxy_cache_use_stale error | timeout | invalid_header | updating | http_500 | http_502 | http_503 | http_504 | http_403 | http_404 | http_429 | off ...;
        Default: proxy_cache_use_stale off;
        Context: http, server, location
        ```

    - 例如：配置当被代理服务器返回404 HTTP响应码时，nginx可以使用历史缓存来响应客户端。

        ```nginx
        proxy_cache_use_stale http_404;
        ```

    - 客户端访问测试：

        ```sh
        ❯ curl http://192.168.1.134/cache/index.html  -I
        HTTP/1.1 200 OK
        Server: nginx/1.14.2
        Date: Mon, 11 Jan 2021 06:00:58 GMT
        Content-Type: text/html
        Content-Length: 26065
        Connection: keep-alive
        Last-Modified: Wed, 21 Oct 2020 14:17:08 GMT
        ETag: "5f9042e4-65d1"
        Expires: Mon, 11 Jan 2021 06:01:07 GMT
        Cache-Control: max-age=10
        cache: MISS  #第一次请求没有缓存
        Accept-Ranges: bytes

        ❯ curl http://192.168.1.134/cache/index.html  -I
        HTTP/1.1 200 OK
        Server: nginx/1.14.2
        Date: Mon, 11 Jan 2021 06:01:01 GMT
        Content-Type: text/html
        Content-Length: 26065
        Connection: keep-alive
        Last-Modified: Wed, 21 Oct 2020 14:17:08 GMT
        ETag: "5f9042e4-65d1"
        Expires: Mon, 11 Jan 2021 06:01:07 GMT
        Cache-Control: max-age=10
        cache: HIT #第二次请求nginx使用缓存响应
        Accept-Ranges: bytes

        ❯ curl http://192.168.1.134/cache/index.html  -I
        HTTP/1.1 200 OK
        Server: nginx/1.14.2
        Date: Mon, 11 Jan 2021 06:01:29 GMT
        Content-Type: text/html
        Content-Length: 26065
        Connection: keep-alive
        Last-Modified: Wed, 21 Oct 2020 14:17:08 GMT
        ETag: "5f9042e4-65d1"
        Expires: Mon, 11 Jan 2021 06:01:07 GMT
        Cache-Control: max-age=10
        cache: STALE #第三次请求之前先将被代理服务器上的index.html文件删除，nginx使用历史缓存响应
        Accept-Ranges: bytes
        ```

- 指令：过期缓存

    - proxy_cache_revalidate

        - 当缓存过期时，当nginx构造上游请求时，添加If-Modified-Since和If-None-Match头部，值为过期缓存中的Last-Modified值和Etag值。

        ```nginx
        Syntax:  proxy_cache_revalidate on | off;
        Default: proxy_cache_revalidate off;
        Context: http, server, location
        This directive appeared in version 1.5.7.
        ```

        - 当接收到被代理服务器的304响应时，且打开了proxy_cache_revalidate功能，则用缓存来响应客户端，并且更新缓存状态。

            ```sh
            ❯ curl http://192.168.1.134/cache/  -I
            HTTP/1.1 200 OK
            Server: nginx/1.14.2
            Date: Sun, 10 Jan 2021 08:11:37 GMT
            Content-Type: text/html
            Content-Length: 26065
            Connection: keep-alive
            Last-Modified: Wed, 21 Oct 2020 14:17:08 GMT
            ETag: "5f9042e4-65d1"
            Expires: Sun, 10 Jan 2021 08:11:36 GMT
            Cache-Control: max-age=10
            cache: REVALIDATED  #表示nginx通过过期缓存中的Etag和Last-Modified字段的值向被代理服务器发起验证请求，并且被代理服务器返回了304
            Accept-Ranges: bytes

            ❯ curl http://192.168.1.134/cache/  -I
            HTTP/1.1 200 OK
            Server: nginx/1.14.2
            Date: Sun, 10 Jan 2021 08:11:38 GMT
            Content-Type: text/html
            Content-Length: 26065
            Connection: keep-alive
            Last-Modified: Wed, 21 Oct 2020 14:17:08 GMT
            ETag: "5f9042e4-65d1"
            Expires: Sun, 10 Jan 2021 08:11:36 GMT
            Cache-Control: max-age=10
            cache: HIT
            Accept-Ranges: bytes
            ```

###### 缓存配置综合例子

```nginx
user nginx;
events{
 worker_connections 1024;
}
http {
    #设置缓存路径和相关参数（必选）
    proxy_cache_path  /tmp/nginx/cache levels=1:2  keys_zone=mycache:10m max_size=10g;
    server {
        listen 80;
        location /cache  {
            proxy_pass http://192.168.1.135:8080;

            #引用缓存配置（必选）
            proxy_cache mycache;

            #对响应状态码为200 302的响应缓存100s
            proxy_cache_valid 200 302 100s;
            #对响应状态码为404的响应缓存200
            proxy_cache_valid 404 200s;

            #请求参数带有nocache或者comment时不使用缓存
            proxy_cache_bypass $arg_nocache $arg_comment;

            #忽略被代理服务器设置的"Cache-Control"头信息
            proxy_ignore_headers "Cache-Control";

            #对GET HEAD POST方法进行缓存
            proxy_cache_methods GET HEAD POST;

            #当缓存过期时，当构造上游请求时，添加If-Modified-Since和If-None-Match头部，值为过期缓存中的Last-Modified值和Etag值。
            proxy_cache_revalidate on;

            #当被代理服务器返回403时，nginx可以使用历史缓存来响应客户端，该功能在一定程度上能能够为客户端提供不间断访问
            proxy_cache_use_stale http_403;

            #默认开启，开启代理缓冲区（内存）
            proxy_buffering on;
            #设置响应头的缓冲区设为8k
            proxy_buffer_size 8k;
            #设置网页内容缓冲区个数为8，单个大小为8k
            proxy_buffers 8 8k;
            #设置当nginx还在读取被代理服务器的数据响应的同时间一次性向客户端响应的数据的最大为16k
            proxy_busy_buffers_size 16k;
            #临时文件最大为1024m
            proxy_max_temp_file_size 1024m;
            #设置一次往临时文件的大小最大为16k
            proxy_temp_file_write_size 16k;
            #设置临时文件存放目录
            proxy_temp_path /tmp/proxy_temp;

            #设置和被代理服务器连接的超时时间为60s
            proxy_connect_timeout 60;
            #设置向被代理服务器发送请求的超时时间为60s
            proxy_send_timeout 60;
            #设置从被代理服务器读取响应的超时时间为60s
            proxy_read_timeout 60;

            #添加缓存状态参数，方便测试是否命中缓存
            add_header cache $upstream_cache_status;
        }
    }
}
```

###### 例子：配置缓存

- 被代理服务器配置

    - 被代理服务器上需要通知代理服务器缓存内容的时间，否则代理服务器不会对内容进行缓存
    - 通过X-Accel-Expires，expires，Cache-Control "max-age="其中一个参数指定时间。
    - 如果代理服务器上配置了proxy_cache_valid的时间，那么被代理服务器可以不指定缓存内容的时间。

    ```nginx
    server {
      listen 8080;
      location /cache {
        alias /www/html/docs/ ;

        add_header X-Accel-Expires 100; #通知代理服务器缓存100s
        # expires 50;   #通知代理服务器缓存50s
        # add_header Cache-Control "max-age=50"; #通知代理服务器缓存50s
      }
    }
    ```

- 反向代理nginx配置

    ```nginx
    http {
      proxy_cache_path /tmp/nginx/cache levels=1:2 inactive=60s keys_zone=mycache:10m max_size=10g;
      server {
        listen 80;
        location /cache {
          proxy_pass http://192.168.1.135:8080;
          #proxy_cache_valid 200 302 80s; #代理服务器本身设置对200 302响应缓存80s
          proxy_cache mycache; #引用前面定义的proxy_cache_path
          add_header cache $upstream_cache_status; #这个不是必须的，只是方便我们测试的时候查看是否命中缓存
        }
      }
    }
    ```

- 验证
    - 客户端连续两次去访问代理服务器，可以看到第一次请求未命中缓存，第二次请求命中缓存。
    ```sh
    ❯ curl http://192.168.1.134/cache/  -I
    HTTP/1.1 200 OK
    Server: nginx/1.14.2
    Date: Sat, 09 Jan 2021 16:09:38 GMT
    Content-Type: text/html
    Content-Length: 26065
    Connection: keep-alive
    Last-Modified: Wed, 21 Oct 2020 14:17:08 GMT
    ETag: "5f9042e4-65d1"
    Expires: Sat, 09 Jan 2021 16:10:27 GMT
    Cache-Control: max-age=50
    cache: MISS  #第一次请求未命中缓存
    Accept-Ranges: bytes

    ❯ curl http://192.168.1.134/cache/  -I
    HTTP/1.1 200 OK
    Server: nginx/1.14.2
    Date: Sat, 09 Jan 2021 16:09:39 GMT
    Content-Type: text/html
    Content-Length: 26065
    Connection: keep-alive
    Last-Modified: Wed, 21 Oct 2020 14:17:08 GMT
    ETag: "5f9042e4-65d1"
    Expires: Sat, 09 Jan 2021 16:10:27 GMT
    Cache-Control: max-age=50
    cache: HIT  #第二次请求命中缓存
    Accept-Ranges: bytes
    ```

###### 例子：负载均衡配置缓存

- 121.42.11.34 服务器作为上游服务器

    ```nginx
    server {
      listen 1010;
      root /usr/share/nginx/html/1010;
      location / {
       index index.html;
      }
    }

    server {
      listen 1020;
      root /usr/share/nginx/html/1020;
      location / {
       index index.html;
      }
    }
    ```

- 121.5.180.193 服务器作为代理服务器

    ```nginx
    # 可以在 /etc/nginx/cache_temp 路径下找到相应的缓存文件。
    proxy_cache_path /etc/nginx/cache_temp levels=2:2 keys_zone=cache_zone:30m max_size=2g inactive=60m use_temp_path=off;

    upstream cache_server{
      server 121.42.11.34:1010;
      server 121.42.11.34:1020;
    }

    server {
      listen 80;
      server_name cache.lion.club;
      location / {
        proxy_cache cache_zone; # 设置缓存内存。cache_zone为上面proxy_cache_path定义好的
        proxy_cache_valid 200 5m; # 缓存状态为 200 的请求，缓存时长为 5 分钟
        proxy_cache_key $request_uri; # 缓存文件的 key 为请求的URI
        add_header Nginx-Cache-Status $upstream_cache_status # 把缓存状态设置为头部信息，响应给客户端
        proxy_pass http://cache_server; # 代理转发
      }
    }
    ```

    - 实时性要求非常高的页面或数据来说，就不应该去设置缓存

        ```nginx
        server {
          listen 80;
          server_name cache.lion.club;

          # URI 中后缀为 .txt 或 .text 的设置变量值为 "no cache"
          if ($request_uri ~ \.(txt|text)$) {
           set $cache_name "no cache"
          }

          location / {
            proxy_no_cache $cache_name; # 判断该变量是否有值，如果有值则不进行缓存，如果没有值则进行缓存
            proxy_cache cache_zone; # 设置缓存内存
            proxy_cache_valid 200 5m; # 缓存状态为  200的请求，缓存时长为 5 分钟
            proxy_cache_key $request_uri; # 缓存文件的 key 为请求的 URI
            add_header Nginx-Cache-Status $upstream_cache_status # 把缓存状态设置为头部信息，响应给客户端
            proxy_pass http://cache_server; # 代理转发
          }
        }
        ```

### https

- ssl证书的功能
    - 1.加密
    - 2.身份认证

- 市面上的ssl证书都是通过第三方ssl证书机构颁发的，常见的可靠的第三方ssl颁发机构有：DigiCert、GeoTrust、GlobalSign、Comodo等

- 根据不同的使用环境，ssl证书可分为：
    - 企业级别：EV（Extended Validation）、OV（Organization Validation）
    - 个人级别：IV（Identity Validation）、DV（Domain Validation）
    - 其中EV、OV、IV需要付费。
    - 企业用户建议使用EV或OV证书。
    - 个人用户建议使用IV。DV证书虽然免费，但是最低端的ssl证书。不显示单位名称，也不能证明网站的真实身份，只能验证域名所有权，仅起到加密信息的左右，适用于个人网站或非电商网站

- HTTPS 工作流程
    - 客户端（浏览器）访问 https://www.baidu.com 百度网站；
    - 百度服务器返回 HTTPS 使用的 CA 证书；
    - 浏览器验证 CA 证书是否为合法证书；
    - 验证通过，证书合法，生成一串随机数并使用公钥（证书中提供的）进行加密；
    - 发送公钥加密后的随机数给百度服务器；
    - 百度服务器拿到密文，通过私钥进行解密，获取到随机数（公钥加密，私钥解密，反之也可以）；
    - 百度服务器把要发送给浏览器的内容，使用随机数进行加密后传输给浏览器；
    - 此时浏览器可以使用随机数进行解密，获取到服务器的真实传输内容。

- 配置https需要2个文件：
    - 1个私钥文件（.key结尾）
        - 和证书里的公钥配对使用。公钥加密，私钥解密
    - 1个证书文件（.crt结尾）
        - 证书文件是有第三方证书颁发机构签发的。因此，还需要给他们提供一个证书签署请求文件（.csr结尾）包含：
            - 申请者的标识名（Distinguished Name，DN）
            - 公钥
        - 第三方证书颁发机构拿到csr文件后，会用其根证书私钥对证书进行加密，并生成crt证书

- 证书有两种

    - 1.ECC 证书（内置公钥是 ECDSA 公钥）
    - 2.RSA 证书（内置 RSA 公钥）

    - 简单来说，同等长度 ECC 比 RSA 更安全,也就是说在具有同样安全性的情况下，ECC 的密钥长度比 RSA 短得多（加密解密会更快）。
        - 但问题是 ECC 的兼容性会差一些，Android 4.x 以下和 Windows XP 不支持。只要您的设备不是非常老的老古董，建议使用 ECC 证书。

- [Nginx 安装 SSL 配置 HTTPS 超详细完整教程全过程](https://developer.aliyun.com/article/766958)

- [nginx ssl 配置](https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=intermediate&openssl=1.1.1d&guideline=5.6)

- [购买阿里云ssl证书](https://www.aliyun.com/product/cas)

- nginx安装编译需要加入ssl选项
    ```sh
    # 设置ssl模块
    ./configure --prefix=/usr/local/nginx \
        --with-http_ssl_module
        --add-module=./module/echo-nginx-module \
    ```

- 公钥、私钥常见扩展名
    - 公钥：`.pub` `.pem` `ca.crt`
    - 私钥：`.prv` `.pem` `ca.key` `.key`

- 生成文件（快速方法）

    ```sh
    openssl req -newkey rsa:2048 -nodes -keyout example.key -x509 -days 365 -out example.crt
    # 以下信息自行添加，可以随意
    ```

- 生成文件

    ```sh
    # 生成ca.crt ca.key
    openssl req -newkey rsa:2048 \
        -new -nodes -x509 \
        -days 365 \
        -out ca.crt \
        -keyout ca.key \
        -subj "/C=CN/ST=beijing/L=beijing/O=example Inc./OU=Web Security/CN=example.com"

    # 生成example.key
    openssl genrsa -out example.key 2048

    # 生成example.csr
    openssl req -new -key example.key -days 365 -out example.csr \
        -subj "/C=CN/ST=Beijing/L=Haidian/O=CoolShell/OU=Test/CN=example.com"

    # 生成extfile.cnf
    echo "subjectAltName=DNS:example.com" > extfile.cnf

    # 使用ca给example签名，生成example.crt
    openssl x509 -req -in example.csr -extfile extfile.cnf -CA ca.crt -CAkey ca.key -days 365 -sha256 -CAcreateserial -out example.crt

    # 删除extfile.cnf
    rm extfile.cnf
    ```

- 查看crt信息

    ```sh
    cat example.crt | openssl x509 -text
    ```

    ![image](./Pictures/nginx/openssl-crt.avif)

- 配置nginx

    ```sh
    server {
        listen 443;
        server_name test.example.com;

        # root /usr/local/nginx/html/;
        # index index.html index.htm index.php;

        # 默认会放在/usr/local/nginx/conf/
        ssl_certificate      example.crt;
        ssl_certificate_key  example.key;
        # 指定目录
        # ssl_certificate /etc/letsencrypt/live/example.com/fullchain.crt;
        # ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.key;

        # 缓存有效期
        ssl_session_timeout  5m;

        # 使用服务器端的首选算法
        ssl_prefer_server_ciphers  on;

        # 安全链接可选的加密协议
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

        # 加密算法
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305;

        # 增强安全性选项，减少点击劫持
        add_header X-Frame-Options DENY;
        # 增强安全性选项，禁止服务器自动解析资源类型
        add_header X-Conntent-Type-Options nosniff;
        # 增强安全性选项，防止XSS攻击
        add_header X-Xss-Protection 1;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }
    ```

- 配置`/etc/hosts`
    ```
    127.0.0.1 test.example.com
    ```

- 测试：

    ```sh
    openssl s_client -connect 127.0.0.1:443
    curl --tlsv1.2 https://127.0.0.1
    curl http://127.0.0.1:443
    curl test.example.com
    ```

    - 浏览器测试

    - 使用[myssl网站](https://myssl.com/)和[Qualys SSL Labs网站](https://www.ssllabs.com/ssltest/)进行在线测试.可以更详细地测试ssl证书的状态、安全性、兼容性等各方面

- 其他重定向配置

    - 以下配置选择自己需要的一条即可，不用全部加。

    ```sh
    server {
        listen      80;
        server_name example.com www.example.com;

        # 单域名重定向
        if ($host = 'www.sherlocked93.club'){
            return 301 https://www.sherlocked93.club$request_uri;
        }

        # 全局非 https 协议时重定向
        if ($scheme != 'https') {
            return 301 https://$server_name$request_uri;
        }

        # 或者全部重定向
        return 301 https://$server_name$request_uri;
    }
    ```

#### [bugstack虫洞栈：爽了！免费的SSL，还能自动续期！](https://mp.weixin.qq.com/s/ehitnClHcvstxFY-0oAoyw)??失败了

#### 使用acme.sh生成证书。??失败了

- [官网](https://github.com/acmesh-official/acme.sh)

- 安装

```sh
git clone https://github.com/acmesh-official/acme.sh.git
cd ./acme.sh
# 输入自己的邮箱
./acme.sh --install -m my@example.com
```

```sh
# 生成key和csr文件。会创建example.com的目录
acme.sh --issue -d example.com -w .

# 生成证书。然而并没有成功
acme.sh --install-cert -d example.com \
--key-file       ./key.pem  \
--fullchain-file ./cert.pem \
```

#### [httpsok： 一行命令，轻松搞定SSL证书自动续期。](https://github.com/httpsok/httpsok)??失败了

#### [ssltest：验证tls，并且有评分](https://www.ssllabs.com/ssltest/index.html)

#### http2

- [官方配置](http://nginx.org/en/docs/http/ngx_http_v2_module.html)

```nginx
server {
    listen 443 ssl;

    http2 on;

    ssl_certificate server.crt;
    ssl_certificate_key server.key;
}
```

#### http3

- [编译选项](http://nginx.org/en/docs/quic.html)

    - 不建议使用openssl。建议使用BoringSSL，LibreSSL，or QuicTLS

    ```sh
    # boringssl编译选项
    ./configure
    --with-debug
    --with-http_v3_module
    --with-cc-opt="-I../boringssl/include"
    --with-ld-opt="-L../boringssl/build/ssl
                   -L../boringssl/build/crypto"
    ```


- [官方配置](http://nginx.org/en/docs/http/ngx_http_v3_module.html)

```nginx
http {
    log_format quic '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent" "$http3"';

    access_log logs/access.log quic;

    server {
        # for better compatibility it's recommended
        # to use the same port for http/3 and https
        listen 8443 quic reuseport;
        listen 8443 ssl;

        ssl_certificate     certs/example.com.crt;
        ssl_certificate_key certs/example.com.key;

        location / {
            # used to advertise the availability of HTTP/3
            add_header Alt-Svc 'h3=":8443"; ma=86400';
        }
    }
}
```

#### websocket

- [Se7en的架构笔记:Nginx Websocket 配置](https://mp.weixin.qq.com/s/aN3-JHd-iPhHjUKQlc_Rzw)

Nginx 监听 80 端口用于 Http 和 ws 服务，监听 443 端口用于 Https 和 wss 服务。wss 就是加密的 ws 服务。

- nginx配置（失败了??）
```nginx
http {
    upstream websocket {
        server 192.168.1.141:80; # 后端服务器地址
    }

    server {
      listen 443 ssl;

      # websocket相关配置
      location / {
             proxy_pass http://websocket;
             # 添加 WebSocket 协议升级 Http 头部
             proxy_set_header Upgrade $http_upgrade;
             proxy_set_header Connection "upgrade";
      }

      # ssl 相关配置
      ssl_certificate      example.crt;
      ssl_certificate_key  example.key;

      # 安全链接可选的加密协议
      ssl_protocols TLSv1 TLSv1.1 TLSv1.2 SSLv3 SSlv2;
   }
    server {
        listen 80;
        location / {
            proxy_pass http://websocket;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
        }
    }
}
```

- 测试（失败了??）

    ```sh
    wscat --connect ws://192.168.1.13
    Connected (press CTRL+C to quit)
    < Websocket Send: Hello World
    > send hello
    ```

    ```sh
    curl -i \
         --header "Upgrade: websocket" \
         --header "Sec-WebSocket-Key: MlRAR6bQZi07587UD4H8oA==" \
         --header "Sec-WebSocket-Version: 13" \
         http://192.168.1.134
    HTTP/1.1 101 Switching Protocols
    Server: nginx/1.14.2
    Date: Thu, 25 Mar 2021 08:18:48 GMT
    Connection: upgrade
    Upgrade: websocket
    Sec-WebSocket-Accept: iURIl3uIT+tsPMmZ0x1IVH7EL98=

    # wss 连接，由于是自签名证书需要 -k 参数，表示不检验证书
    curl -i \
         --header "Upgrade: websocket" \
         --header "Sec-WebSocket-Key: MlRAR6bQZi07587UD4H8oA==" \
         --header "Sec-WebSocket-Version: 13" \
         https://192.168.1.134 -k
    HTTP/1.1 101 Switching Protocols
    Server: nginx/1.14.2
    Date: Thu, 25 Mar 2021 08:20:20 GMT
    Connection: upgrade
    Upgrade: websocket
    Sec-WebSocket-Accept: iURIl3uIT+tsPMmZ0x1IVH7EL98=
    ```

### autoindex模块： 用户请求以 `/` 结尾时，列出目录结构，可以用于快速搭建静态资源下载网站。

```nginx
server {
  listen 80;
  server_name fe.lion-test.club;

  location /tz/ {
    root /home; # /home/tz/下的文件

    autoindex on; # 打开 autoindex，，可选参数有 on | off
    autoindex_exact_size on; # 修改为 off，以 KB、MB、GB 显示文件大小，默认为 on，以 bytes 显示出⽂件的确切⼤⼩
    autoindex_format html; # 以 html 的方式进行格式化，可选参数有 html | json | xml
    autoindex_localtime off; # 显示的⽂件时间为⽂件的服务器时间。默认为 off，显示的⽂件时间为GMT时间
  }
}
```

- 测试：浏览器打开`http://127.0.0.1:80/tz/`。可以对文件进行下载
  ![image](./Pictures/nginx/autoindex.avif)


### 配置跨域 CORS

- 同源：如果两个页面的协议，端口（如果有指定）和域名都相同，则两个页面具有相同的源。

    - 例子：与 URL http://store.company.com/dir/page.html 的源进行对比的

        ```
        http://store.company.com/dir2/other.html 同源
        https://store.company.com/secure.html 不同源，协议不同
        http://store.company.com:81/dir/etc.html 不同源，端口不同
        http://news.company.com/dir/other.html 不同源，主机不同
        ```

    - 不同源会有如下限制：
        - Web 数据层面：同源策略限制了不同源的站点读取当前站点的 Cookie、IndexDB、LocalStorage 等数据。
        - DOM 层面：同源策略限制了来自不同源的 JavaScript 脚本对当前 DOM 对象读和写的操作。
        - 网络层面：同源策略限制了通过 XMLHttpRequest 等方式将站点的数据发送给不同源的站点。

- 跨域：同源策略限制了从同一个源加载的文档或脚本如何与来自另一个源的资源进行交互。

    - 这是一个用于隔离潜在恶意文件的重要安全机制。通常不允许不同源间的读操作。

- Nginx 解决跨域的原理：

    - 前端的域名为：fe.server.com
    - 后端的域名为：dev.server.com
    - 现在我在 fe.server.com 对 dev.server.com 发起请求一定会出现跨域。

    - 将 server_name 设置为 fe.server.com 然后设置相应的 location 以拦截前端需要跨域的请求，最后将请求代理回 dev.server.com

        - 这样可以完美绕过浏览器的同源策略：fe.server.com 访问 Nginx 的 fe.server.com 属于同源访问，而 Nginx 对服务端转发的请求不会触发浏览器的同源策略。

        ```nginx
        server {
         listen      80;
         server_name  fe.server.com;
         location / {
          proxy_pass dev.server.com;
         }
        }
        ```

### 跨域请求头部配置

```nginx
location / {

     if ($request_method = 'OPTIONS') {

        add_header 'Access-Control-Allow-Origin' '*';

        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';

        add_header 'Access-Control-Max-Age' 1728000;

        add_header 'Content-Type' 'text/plain; charset=utf-8';

        add_header 'Content-Length' 0;

        return 204;

     }

     add_header 'Access-Control-Allow-Origin' '*';

     add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, PUT, DELETE';

     add_header 'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range';

     add_header 'Access-Control-Expose-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range';

}
```

### 图片防盗链

- 防盗链：是网站内容本身不再自己公司的服务器上，使用技术手段直接调用其其他公司的服务器网站数据，并向最终用户提供
    - 一些小网站盗链高访问量网站的音乐、图片、软件连接，然后放置在自己的网站中
    - 通过这种方法盗取高访问量网站的空间和流量

- 如果没有配置防盗链，别人就能轻而易举地在其他网站上引用页面

```nginx
server {
    listen       80;
    server_name  *.test;

    # 图片防盗链
    location ~* \.(gif|jpg|jpeg|png|bmp|swf)$ {

        # 只允许本机 IP 外链引用，将百度和谷歌也加入白名单有利于 SEO
        valid_referers none blocked server_names ~\.google\. ~\.baidu\. *.qq.com;

        # 
        valid_referers none blocked example.com *.example.com;

        root   /home/tz/Pictures/;

        if ($invalid_referer){
            return 403;
        }
    }
}
```

- 测试：找另一台测试服务器，调用example.com/file.jpg访问图片，由于设置了防盗链，所以无法访问。

### 适配 PC 或移动设备

- 根据用户设备不同返回不同样式的站点，以前经常使用的是纯前端的自适应布局，但是复杂的网站并不适合响应式，无论是复杂性和易用性上面还是不如分开编写的好，比如我们常见的淘宝、京东。

- 根据用户请求的 user-agent 来判断是返回 PC 还是 H5 站点：

```nginx
server {
    listen 80;
    server_name test.com;

    location / {
     root  /usr/local/app/pc; # pc 的 html 路径
        if ($http_user_agent ~* '(Android|webOS|iPhone|iPod|BlackBerry)') {
            root /usr/local/app/mobile; # mobile 的 html 路径
        }
        index index.html;
    }
}
```

### 单页面项目history路由配置

- vue-router 官网只有一句话 `try_files $uri $uri/ /index.html;`，而上面做了一些重定向处理。

```nginx
server {
    listen       80;
    server_name  fe.sherlocked93.club;

    location / {
        root       /usr/local/app/dist;  # vue 打包后的文件夹
        index      index.html index.htm;
        try_files  $uri $uri/ /index.html @rewrites; # 默认目录下的 index.html，如果都不存在则重定向

        expires -1;                          # 首页一般没有强制缓存
        add_header Cache-Control no-cache;
    }

    location @rewrites { // 重定向设置
        rewrite ^(.+)$ /index.html break;
    }
}
```

## log (日志)

- [ngx_http_log_module 模块指定日志格式等](https://github.com/DocsHome/nginx-docs/blob/master/%E6%A8%A1%E5%9D%97%E5%8F%82%E8%80%83/http/ngx_http_log_module.md)

### access log:

```nginx
http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$request_time"';

    access_log  logs/access.log  main;
}
```

```sh
# 新建 access 目录
mkdir /usr/local/nginx/logs/access
```

添加 3 个 access 日志:

- **http:** access.log

- **server 80:** 80.access.log

- **server 8080:** 8080.access.log

```nginx
http {
    # 省略...

    # 添加 access.log 日志
    access_log  logs/access/access.log;

    server {
        listen       80;
        server_name  localhost;

        # 省略...

        # 添加 80.access.log 日志
        access_log  logs/access/80.access.log;

        location / {
        # 省略...
        }
    }
    server {
        listen 8080;
        server_name  localhost;

        # 添加 8080.access.log 日志
        access_log  logs/access/8080.access.log;

        location / {
            proxy_pass http://localhost:80/;
        # 省略...
        }
    }
}
```

- 第 1 行: 浏览器访问 主页
- 第 2 行: 浏览器访问 tz.png 图片
- 第 3 行: curl 访问 主页
- 第 4 行: curl 访问 tz.png 图片
  ![image](./Pictures/nginx/access_log.avif)

### 开启gzip日志

- 使用 `gzip` 压缩日志，日志将会是**二进制格式**

    ```nginx
    access_log  logs/access/80.access.log combined gzip flush=5m;
    ```

- 重启日志:

    ```sh
    sudo nginx -s reload
    sudo nginx -s reopen
    ```

    ![image](./Pictures/nginx/access_log1.avif)

- 开启gz的日志，可通过 `zcat` 查看

    ```sh
    cd /usr/local/nginx/logs/access
    zcat 80.access.log
    ```

### linux命令统计日志

- 或者直接使用ngxtop、 goaccess等日志监控客户端

```sh
# 统计ip的访问次数
awk '{print $1}' /usr/local/nginx/logs/access/80.access.log | sort -r | uniq -c

# 访问资源的次数
awk '{print $7}' /usr/local/nginx/logs/access/80.access.log | sort -r | uniq -c

# 统计以下状态码的ip和次数
awk '{if ($9 ~ "404|500|501|502|503|504") print $1, $9}' /usr/local/nginx/logs/access/80.access.log | sort | uniq -c

# 统计出现以下状态大于20次的ip
awk '{if ($9 ~ "404|500|501|502|503|504") print $1, $9}' /usr/local/nginx/logs/access/80.access.log | sort | uniq -c | sort -nr | awk '{if($1>20) print $2}'

# 统计请求时间超过5s的url
awk '{if ($NF>5) print $NF, $7, $1}' /usr/local/nginx/logs/access/80.access.log | sort -nr | more
```

### 日志切割

- nginx每天都会产生大量的访问日志，不会自动切割。日积月累会导致access.log日志非常庞大

- 使用shell脚本配合crontab进行切割

- 写入`/var/spool/cron/root`文件，实现每天凌晨自动切割日志

    ```
    0 0 * * * /bin/sh /usr/local/nginx/auto_nginx_log.sh >> /tmp/nginx_cut.log 2>&1
    ```

- 脚本1

```sh
#!/bin/bash
# auto mv nginx log shell
# by author jfedu.net
# auto_nginx_log.sh

# 日志文件
S_LOG=/usr/local/nginx/logs/access.log
# 备份目录格式为2024-01-27
D_LOG=/home/tz/nginx/log/backup/`date +%Y-%m-%d`

echo Please wait start cut nginx access.log
sleep 2

# 如果不存在创建备份目录
if [ ! -d $D_LOG ];then
    mkdir -p $D_LOG
fi

# 将access.log移动到备份目录
mv $S_LOG $D_LOG

# 发送信号重新打开日志文件
kill -USR1 'cat /usr/local/nginx/logs/nginx.pid'
echo "---------------------"
echo "The nginx log Cutting successfully"
echo "You can access backup nginx log $D_LOG/access.log files"
```

### error log

高等级会输出包含比自己低等级的日志:

| 日志等级 |
| -------- |
| debug    |
| info     |
| notice   |
| warn     |
| error    |
| crit     |
| alert    |
| emerg    |

```nginx
# 默认是 error:
error_log logs/error.log error;

# 设置为 debug 会输出所有日志:
error_log  logs/error.log debug;
```

- `debug_connection` 指定客户端输出 debug 等级:

    ```nginx
    events {
        # 只有192.168.100.1 和 192.168.100.0/24 客户端才会输出debug等级
        debug_connection 192.168.100.1;
        debug_connection 192.168.100.0/24;
    }
    ```

- 禁用错误日志记录

    ```nginx
    # 我们不建议禁用错误日志，因为它是调试 NGINX 任何问题时的重要信息来源。但是，如果存储空间非常有限，记录的数据可能足以耗尽可用的磁盘空间，此时禁用错误日志记录可能有意义。
    error_log /dev/null emerg;
    ```

- 常见错误：认为 `error_log off` 指令会禁用日志记录。事实上，与 access_log 指令不同，error_log 不包含 off 参数。如果在配置中添加了 `error_log off` 指令，则 NGINX 会在 NGINX 配置文件的默认目录（通常是 /etc/nginx）中创建一个名为 off 的错误日志文件。

### open_log_file_cache 日志缓存

| 参数     | 内容                   |
| -------- | ---------------------- |
| max      | 最大字节数量           |
| inactive | 设置时间 默认是 10s    |
| min_uses | 日志写入指定次数后压缩 |
| valid    | 设置检查频率，默认 60s |

```sh
open_log_file_cache max=1000 inactive=20s valid=1m min_uses=2;
```

## 第三方模块

- [官方收录的第三方模块列表](https://www.nginx.com/resources/wiki/modules/)

### echo模块：可以 echo 变量

[跳转至 echo 模块安装](#echo)

- 在 80 端口的 server 下加入:

    ```nginx
    location /echo {
        set $a 'tz';
        set $b 'i\'m $a';
        echo "$b";
        echo "Here is $a nginx tutorial";
    }
    ```

- 测试：http://127.0.0.1/echo

### 开发第三方模块

- [Se7en的架构笔记：Nginx 第三方模块使用与开发](https://mp.weixin.qq.com/s/u1O6LyhFivHr1QclJhABGg)

## 管理

### auth_basic模块：对访问资源加密，需要用户权限认证

```sh
yum install -y httpd-tools

# 生成认证文件。用户为tz
htpasswd -c /usr/local/nginx/conf/auth.passwd tz
```

- 配置nginx
```nginx
location /auth {
    auth_basic "User Auth";
    auth_basic_user_file /usr/local/nginx/conf/auth.passwd;

    alias  /usr/local/nginx/html/;
    index  index.html index.htm;
}
```

- 使用curl进行测试
```sh
curl -u 'tz:12345' 127.0.0.1:80/auth    # 密码12345
```

### Stub Status模块：输出nginx的基本状态信息指标。

```sh
# 编译需要加入选项。
./configure --prefix=/usr/local/nginx \
    --with-http_stub_status_module \
```

- 通过在 server{} 或 location{} 块中分别包含 `stub_status`  指令来启用指标收集，您随后可以通过访问 URL 来查看这些指标。

    - 对于 NGINX Plus，使用`api` 收集更广泛的指标集。

- nginx配置

    ```nginx
    # stub_status模块
    location = /basic_status {
       stub_status;
    }
    ```

- 测试

    ```sh
    curl 127.0.0.1/basic_status
    Active connections: 1
    server accepts handled requests
     13 13 16
    Reading: 0 Writing: 1 Waiting: 0
    ```

    | 指标               | 说明                                         |
    |--------------------|----------------------------------------------|
    | Active connections | 当前活动连接数                               |
    | accepts            | 统计总值，已经接受的客户端请求连接数         |
    | handled            | 统计总值，已经处理完成的客户端请求的总数     |
    | requests           | 统计总值，客户端发来的请求数                 |
    | Reading            | 当前状态，正在读取客户端请求报文首部的连接数 |
    | Writing            | 当前状态，正在向客户端发送报文过程中的连接数 |
    | Waiting            | 当前状态，正在等待客户端发出请求的空闲连接数 |

- 其中一些指标是敏感信息，可被用来攻击你的网站或nginx代理的应用

    - 问题：通过以下配置，互联网上的任何人都可以访问 http://example.com/basic_status 上的指标。

        ```nginx
        server {
           listen 80;
           server_name example.com;

           location = /basic_status {
               stub_status;
           }

           location @health_check_c {
               health_check;
               proxy_connect_timeout 2s;
               proxy_read_timeout   3s;
               proxy_set_header   Host api.example.com;
               proxy_pass   http://c;

           }

           location /api {
               api write=on;
               # directives   limiting access to the API (see 'Mistake 8' below)

           }

           location = /dashboard.html {
               root   /usr/share/nginx/html;
           }
        }
        ```

    - 解决方法1：使用 HTTP 基本身份验证保护指标。采用 HTTP 基本身份验证相关的方式为指标添加密码保护，包含 `auth_basic` 和 `auth_basic_user_file` 指令。

        - 文件（此处为 .htpasswd）列出了可以登录查看指标的客户端的用户名和密码：

        ```nginx
        server {
            listen 80;
            server_name example.com;

            location = /basic_status {
                auth_basic “closed   site”;
                auth_basic_user_file   conf.d/.htpasswd;
                stub_status;
            }
        }
        ```

    - 解决方法2：使用 allow 和 deny 指令保护指标

        - 如果您不希望强制授权用户登录，并且您知道他们用于访问指标的 IP 地址，另一个选项是使用 allow 指令。您可以指定单独的 IPv4 和 IPv6 地址以及 CIDR 范围。deny all 指令将阻止来自任何其他地址的访问。

        ```nginx
        server {
            listen 80;
            server_name example.com;
            location = /basic_status {
                allow 192.168.1.0/24;
                allow 10.1.1.0/16;
                allow 2001:0db8::/32;
                allow 96.1.2.23/32;
                deny    all;
                stub_status;
            }
        }
        ```

    - 解决方法3：两种方法相结合。可以允许客户端在没有密码的情况下从特定地址访问指标，但来自不同地址的客户端仍然需要登录。

        - 为此，我们使用 satisfy any 指令。它告诉 NGINX 允许使用 HTTP 基本身份验证凭证登录或使用预批准的 IP 地址登录的客户端访问。为了提高安全性，您可以将 satisfy 设置为 all，要求来自特定地址的人登录。

        ```nginx
        server {
            listen 80;
            server_name monitor.example.com;

            location = /basic_status {
                satisfy any;
                auth_basic “closed   site”;
                auth_basic_user_file   conf.d/.htpasswd;
                allow 192.168.1.0/24;
                allow 10.1.1.0/16;
                allow 2001:0db8::/32;
                allow 96.1.2.23/32;
                deny    all;
                stub_status;
            }
        }
        ```

### 请求过滤

#### 根据请求类型过滤

```nginx
# 非指定请求全返回 403
if ( $request_method !~ ^(GET|POST|HEAD)$ ) {
    return 403;
}
```

#### 根据状态码过滤

- 这样实际上是一个内部跳转，当访问出现 502、503 的时候就能返回 50x.html 中的内容，这里需要注意是否可以找到 50x.html 页面，所以加了个 location 保证找到你自定义的 50x 页面。

```nginx
error_page 502 503 /50x.html;
location = /50x.html {
    root /usr/share/nginx/html;
}
```

#### 根据 URL 名称过滤

```nginx
if ($host = zy.com' ) {
     #其中 $1是取自regex部分()里的内容,匹配成功后跳转到的URL。
     rewrite ^/(.*)$  http://www.zy.com/$1  permanent；
}

location /test {
    // /test 全部重定向到首页
    rewrite  ^(.*)$ /index.html  redirect;
}
```

### 对 ua 进行限制

- 禁止指定的浏览器和爬虫框架访问
```sh
server
{
    # http_user_agent 为浏览器标识。~*表示不区分大小写匹配
    if ($http_user_agent ~* 'Mozilla|AppleWebKit|Chrome|Safari|curl')
    {
        return 404;
    }

    # 禁止 user_agent 为baidu、360和sohu
    if ($http_user_agent ~* 'baidu|360|sohu') {
        return 404;
    }

    # 禁止 Scrapy 等工具的抓取
    if ($http_user_agent ~* (Scrapy|Curl|HttpClient)) {
        return 403;
    }
```

### http方法和ip访问控制

| http request methods | 内容                                                                  |
|----------------------|-----------------------------------------------------------------------|
| GET                  | 请求资源，返回实体,不会改变服务器状态(额外参数在url内),因此比post安全 |
| HEAD                 | 请求获取响应头，但不返回实体                                          |
| POST                 | 用于提交数据请求处理，(额外参数在请求体内),会改变服务器状态           |
| PUT                  | 请求上传数据                                                          |
| DELETE               | 请求删除指定资源                                                      |
| MKCOL                |                                                                       |
| COPY                 |                                                                       |
| MOVE                 |                                                                       |
| OPTIONS              | 请求返回该资源所支持的所有 HTTP 请求方法                              |
| PROPFIND             |                                                                       |
| PROPPATCH            |                                                                       |
| LOCK                 |                                                                       |
| UNLOCK               |                                                                       |
| PATCH                | 类似 PUT,用于部分更新,当资源不存在，会创建一个新的资源                |


- 从上到下的顺序，匹配到了便跳出，可以按你的需求设置。

- 表示禁止 192.168.1.1 和 192.168.1.2 两个 ip 访问，其它全部允许。
    ```nginx
    server {
       # 匹配 index.html 页面 除了 127.0.0.1 以外都可以访问
       location ~ ^/index.html {
           deny 192.168.1.1;
           deny 192.168.1.2;
           allow all;
     }
    }
    ```

- 除了 192.168.100.0/24 **以外** ，其他只能使用 `get` 和 `head` (get 包含 head) 方法:

    ```nginx
    server {
       location ~ ^/index.html {
            limit_except GET {
                allow 192.168.100.0/24;
                deny all;
            }
     }
    }
    ```

### 请求限制：限制同一IP的连接数和并发数

- 对于大流量恶意的访问，会造成带宽的浪费，给服务器增加压力。合理的控制还可以用来防止 DDos 和 CC 攻击。

- 关于请求限制主要使用 nginx 默认集成的 2 个模块：

    - limit_conn_module 连接频率限制模块
    - limit_req_module 请求频率限制模块

#### limit_conn_module模块：限制连接数

- 如果共享内存空间被耗尽，服务器将会对后续所有的请求返回 503 (Service Temporarily Unavailable) 错误。

- 限制每个ip最多建立5个连接

    ```nginx
    http{
        limit_conn_zone $binary_remote_addr zone=perip:10m; # 设置共享内存空间大
        server{
            location /{
                limit_conn perip 5;
            }
        }
    }
    ```

- 限制每个域名最多建立5个连接

    ```nginx
    http{
        limit_conn_zone $server_name zone=perserver:10m; # 设置共享内存空间大
        server{
            location /{
                limit_conn perserver 5;
            }
        }
    }
    ```


- 限制每个ip和域名最多建立5个连接

    ```nginx
    http{
        limit_conn_zone $binary_remote_addr zone=perip:10m; # 设置共享内存空间大
        limit_conn_zone $server_name zone=perserver:10m; # 设置共享内存空间大
        server{
            location /{
                limit_conn perserver 5;
                limit_conn perip 5;
            }
        }
    }
    ```

#### limit_req_module模块：限制并发的连接数

- 通过 limit_req_zone 限制并发连接数

    ```nginx
    limit_req_zone $binary_remote_addr zone=creq:10 mrate=10r/s;
    server{
        location /{
            # 限制平均每秒不超过一个请求，同时允许超过频率限制的请求数不多于 5 个。
            limit_req zone=creq burst=5;
        }
    }
    ```

    - 如果不希望超过的请求被延迟，可以用 nodelay 参数
        ```nginx
        limit_req zone=creq burst=5 nodelay;
        ```

### limit_rate模块：限制客户端响应传输速率

- 该限制针对每个请求设置的：如果客户端同时打开2个连接，则总体速率将是指定限制的2倍

```nginx
location / {
    # 速度限制为10kb/s
    limit_rate 10k;

    root   html;
    index  index.html index.htm;
}

location / {
    # 下载15MB之后，速度限制10kb/s
    limit_rate_after 15m;
    limit_rate 10k;

    root   html;
    index  index.html index.htm;
}
```

## 常见错误与性能优化

### 每个 worker 没有足够的文件描述符：

- 使用FD的场景

    - 当充当 Web 服务器时：每个客户端连接使用一个 FD，每个服务的文件使用一个 FD，这样每个客户端至少需两个 FD（但大多数网页是由许多文件构建的）

    - 当充当代理服务器时：NGINX 分别使用一个 FD 连接客户端和上游（后端）服务器（一共2个），并可能用到第三个 FD 给用于临时存储服务器响应的文件。作为缓存服务器时，NGINX 的行为类似于缓存响应的 Web 服务器，如果缓存为空或过期，则类似于代理服务器。

    - NGINX 为每个日志文件使用一个 FD，并会用几个 FD 与主进程通信，但与用于连接和文件的 FD 数量相比，这些数量通常很少。

- `worker_connections` 指令用于设置 NGINX worker 进程可以打开的最大并发连接数（默认为 512）
- 操作系统对分配给每个进程的文件描述符 (file descriptor，即FD) 最大数量的限制。在现代 UNIX 发行版中，默认限制为 1024。

### 未启用与上游服务器的 keepalive 连接

- 问题：当连接关闭时，Linux 套接字会处于 TIME‑WAIT 状态两分钟，在流量高峰期时这会增加可用源端口池耗尽的可能性。如果发生这种情况，NGINX 将无法打开与上游服务器的新连接。

- 解决方法：是在 NGINX 和上游服务器之间启用 keepalive 连接 —— 该连接不会在请求完成时关闭，而是保持打开状态以用于其他请求。这样做既降低了源端口耗尽的可能性，又提高了性能。

    - 1.在每个 upstream{} 块中包含 keepalive 指令，以设置保存在每个 worker 进程缓存中的到上游服务器的空闲 keepalive 连接数。
            - 建议将该参数设置为 upstream{} 块中列出的服务器数量的两倍。
            - 请注意，keepalive 指令不限制 NGINX worker 进程可以打开的上游服务器的连接总数 —— 这一点经常被误解。所以 keepalive 的参数不需要像您想象的那么大。
            - 另请注意，当您在 upstream{} 块中指定负载均衡算法时 —— 使用 hash、ip_hash、least_conn、least_time 或 random 指令 —— 该指令必须位于 keepalive 指令之前。通常，在 NGINX 配置中，指令顺序并不重要，而这是少数例外之一。

            ```nginx
            http {
                upstream node_backend {
                    server 127.0.0.1:3000 max_fails=1   fail_timeout=2s;
                    server 127.0.0.1:4000 max_fails=1   fail_timeout=2s;
                    keepalive 4;
                }

                server {
                    listen 80;
                    server_name example.com;

                    location / {
                        proxy_set_header Host $host;
                        proxy_pass http://node_backend/;
                        proxy_next_upstream error timeout   http_500;
                    }
                }
            }
            ```

        - 大多数情况下，keepalive_requests = 100也够用，但是对于 QPS 较高的场景，非常有必要加大这个参数，以避免出现大量连接被生成再抛弃的情况，减少TIME_WAIT。
            - QPS=10000 时，客户端每秒发送 10000 个请求 (通常建立有多个长连接)，每个连接只能最多跑 100 次请求，意味着平均每秒钟就会有 100 个长连接因此被 nginx 关闭。同样意味着为了保持 QPS，客户端不得不每秒中重新新建 100 个连接。

    - 2.在将请求转发到上游 group 的 location{} 块中，添加以下指令以及 proxy_pass 指令：
        ```nginx
        # proxy_http_version 指令告知 NGINX 使用 HTTP/1.1，proxy_set_header 指令将从 Connection 标头中删除 close 值。
        proxy_http_version 1.1;
        proxy_set_header   "Connection" "";
        ```

        - NGINX 默认使用 HTTP/1.0 连接上游服务器，并相应地将 Connection: close 标头添加到它所转发到服务器的请求中。这样尽管 upstream{} 块中包含了keepalive 指令，但每个连接仍然会在请求完成时关闭。


### 假定只有一台服务器（因此没有必要使用`upstream`负载均衡命令）。然而`upstream`可以提升性能

- 假设您在最简单的用例中使用 NGINX，作为监听端口 3000的单个基于 NodeJS 的后端应用的反向代理。常见的配置可能如下所示：

    ```nginx
    http {
        server {
            listen 80;
            server_name example.com;

            location / {
                proxy_set_header Host $host;
                proxy_pass   http://localhost:3000/;
            }
        }
    }
    ```

- `upstream`提升性能

    - zone 指令建立一个共享内存区，主机上的所有 NGINX worker 进程都可以访问有关上游服务器的配置和状态信息。几个上游组 可以共享该内存区。

        - 对于 NGINX Plus，该区域还支持您使用 NGINX Plus API 更改上游组中的服务器和单个服务器的设置，而无需重启 NGINX。

    - keepalive 指令设置每个 worker 进程缓存中保留的上游服务器的空闲 keepalive 连接的数量。

    - server 指令有几个参数可用来调整服务器行为。在本示例中，我们改变了 NGINX 用以确定服务器不健康，因此没有资格接受请求的条件。此处，只要通信尝试在每个 2 秒期间失败一次（而不是默认的在 10 秒期间失败一次），就会认为服务器不健康。

        - 结合使用此设置与 proxy_next_upstream 指令，配置在什么情况下 NGINX 会认为通信尝试失败，在这种情况下，它将请求传递到上游组中的下一个服务器。

        - 在默认错误和超时条件中，我们添加了 http_500，以便 NGINX 认为来自上游服务器的 HTTP 500 (Internal Server Error) 代码表示尝试失败。

    ```nginx
    http {
        upstream node_backend {
            zone upstreams 64K;
            server 127.0.0.1:3000 max_fails=1   fail_timeout=2s;
            keepalive 2;
        }

        server {
            listen 80;
            server_name example.com;

            location / {
                proxy_set_header Host $host;
                proxy_pass http://node_backend/;
                proxy_next_upstream error timeout   http_500;
            }
        }
    }
    ```

### NGINX 默认启用代理缓冲（`proxy_buffering off` 指令）

- 代理缓冲意味着 NGINX 将来自服务器的响应存储在内部缓冲区中，并且在整个响应被缓冲之后才开始向客户端发送数据。

- 如果代理缓冲被禁用，则 NGINX 只会在默认为一个内存页大小（4 KB 或 8 KB，具体取决于操作系统）的缓冲区内缓存服务器响应的开头部分后就开始向客户端传输。通常，这个缓存空间只够缓存响应http消息头。NGINX 收到响应后会同步发送给客户端，迫使服务器处于空闲状态，直到 NGINX 可以接受下一个响应段为止。

- 只有在少数情况下，禁用代理缓冲可能有意义（例如长轮询），因此我们强烈建议不要更改默认设置。

    - 对于经常在 NGINX 配置中看到 proxy_buffering off 指令的情况，我们感到非常惊讶。也许这样做是为了减少客户端延迟，但其影响可以忽略不计，而关闭后的副作用却很多：代理缓冲被禁用后，速率限制和缓存即便配置了也不起作用，性能也会受影响等等。

### 过多的健康检查

- 配置多个虚拟服务器将请求代理到同一个上游组十分常见（换句话说，在多个 server{} 块中包含相同的 proxy_pass 指令）。

- 这里的错误是在每个 server{} 块中都添加一个 health_check 指令。这样做只会增加上游服务器的负载，而不会产生任何额外信息。

- 解决方法是每个 upstream{} 块只定义一个健康检查。此处，我们在一个指定位置为名为 b 的上游 group 定义了健康检查，并进行了适当的超时和http消息头设置。

    ```nginx
    location / {
        proxy_set_header Host $host;
        proxy_set_header "Connection"   "";
        proxy_http_version 1.1;
        proxy_pass http://b;
    }

    location @health_check {
        health_check;
        proxy_connect_timeout 2s;
        proxy_read_timeout 3s;
        proxy_set_header Host example.com;
        proxy_pass http://b;
    }
    ```

- 在复杂的配置中，它可以进一步简化管理，将所有健康检查位置以及 NGINX Plus API 仪表盘分组到单个虚拟服务器中，如本例所示。
    ```nginx
    server {
       listen 8080;
       location / {
           # …
      }

       location @health_check_b {
           health_check;
           proxy_connect_timeout 2s;
           proxy_read_timeout   3s;
           proxy_set_header   Host example.com;
           proxy_pass   http://b;

       }

       location @health_check_c {
           health_check;
           proxy_connect_timeout 2s;
           proxy_read_timeout   3s;
           proxy_set_header   Host api.example.com;
           proxy_pass   http://c;

       }

       location /api {
           api write=on;
           # directives   limiting access to the API (see 'Mistake 8' below)
       }

       location = /dashboard.html {
           root   /usr/share/nginx/html;
       }
    }
    ```

## 第三方软件

### 服务端

#### [njs：是 JavaScript 语言的一个子集，它允许扩展 nginx 的功能](http:#//nginx.org/en/docs/njs/)

### 客户端

#### [ngxtop 日志监控](https://github.com/lebinh/ngxtop)

```sh
sudo ngxtop -l /usr/local/nginx/logs/access/80.access.log
```

![image](./Pictures/nginx/ngxtop.gif)

统计客户端 ip 访问次数:

```sh
ngxtop top remote_addr -l /usr/local/nginx/logs/access/80.access.log
```

![image](./Pictures/nginx/ngxtop1.gif)

#### [goaccess 日志监控](https://goaccess.io/)

cli(命令行监控):

```sh
sudo goaccess /usr/local/nginx/logs/access/80.access.log
```

![image](./Pictures/nginx/goaccess.gif)

输出 静态 html 页面:

```sh
sudo goaccess /usr/local/nginx/logs/access/80.access.log  -o /tmp/report.html --log-format=COMBINED

chrome /tmp/report.html
```

![image](./Pictures/nginx/goaccess.avif)

输出 实时 html 页面:

```sh
sudo goaccess /usr/local/nginx/logs/access/80.access.log -o /tmp/report.html --log-format=COMBINED --real-time-html
```

![image](./Pictures/nginx/goaccess1.gif)

#### [rhit:日志浏览器](https://github.com/Canop/rhit)

## 在线工具

- [自动生成 nginx.conf](https://www.digitalocean.com/community/tools/nginx)

- [测试网站是否支持 http2 和 alpn](https://tools.keycdn.com/http2-test)

## 第三方nginx

### Openresty

- 由章宜春开发的，最大特点是引入了 ngx_lua 模块，支持使用 Lua 开发插件，并且集合了很多丰富的模块，以及 Lua 库。

- 严格来说，OpenResty里的Lua不能叫Lua。它是LuaJIT，以Lua5.1语法为主的另一个分支，而且看着没有跟进官方Lua的计划。Lua5.1以后的版本在语法上有了不少的改进，类似位运算，性能更是如此。对单纯使用Lua而言，非常推荐Lua5.4。

- OpenResty让很多开发者大幅提升了开发生产力，并且在它上面衍生了不少开源软件，尤其在API方面，比如Kong和APISIX。很多公司也有内部的自研尝试。

### tengine

- 主要是淘宝团队开发。特点是融入了因淘宝自身的一些业务带来的新功能。

### Kong

- OpenResty 的基础上迭代发布了一个新网关

- 通过插件化的方式来支持网关功能的扩展，并提供了 60 多种插件。

- 现在随着微服务的发展，服务被拆的非常零散，降低了耦合度的同时也给服务的统一管理增加了难度。

    - 例如服务发现。在 Nginx 中，所有的后端服务都是以静态配置文件的形式记录的。每当后端服务的 IP 发生变化的时候，需要重新修改配置文件。

    - 但在微服务时代，后端都是用容器部署的，每次版本发布都会导致 IP 的变化。而且微服务时代还需要动态的扩缩容，都会导致后端服务 IP 的变化。传统的修改配置文件才能重新分配流量的方式显然已经无法满足需要。

    - 除了服务发现以外，微服务时代对网关还有其他一些新的需求，例如限流、协议转换、身份验证、安全防护等功能，都需要在网关中能够支持。

    ![image](./Pictures/nginx/kong.avif)

- kong 的环境配起来还是有一点点小复杂的。它需要 Postgres 或者 Cassandra 等数据库来管理路由配置，服务配置，upstream 配置等信息。还需要安装 konga（最好的 kong 的管理程序）。

- 在腾讯云上的微服务引擎中，已经集成了 kong 网关，可以一键配置，非常的方便。

## reference

- [HelloGitHub：全面了解 Nginx](https://mp.weixin.qq.com/s/9Qh2FzizHL4jQDMShByMJg)

- [腾讯技术工程：Nginx 最全操作总结](https://cloud.tencent.com/developer/article/1839486)

- [Dropbox 正在用 Envoy 替换 Nginx，这还是我第一次看到讨论 Nginx 作为 Web 服务器的缺点 --ruanyif](https://dropbox.tech/infrastructure/how-we-migrated-dropbox-from-nginx-to-envoy)

- [官方教程中文](https://github.com/DocsHome/nginx-docs/blob/master/SUMMARY.md)

- [Nginx 开发从入门到精通(淘宝内部的书)](http://tengine.taobao.org/book/index.html)

- [nginx books](http://nginx.org/en/books.html)

- [章亦春又名春哥的 nginx 教程](http://openresty.org/download/agentzh-nginx-tutorials-zhcn.html);
  [章亦春 nginx core 的 memleak(内存泄漏)火焰图](http://agentzh.org/misc/flamegraph/nginx-memleak-2013-08-05.svg)

- [NSM 管理 kubernetes 容器流量](https://www.nginx.com/blog/introducing-nginx-service-mesh/)

- [开发内功修炼：万字多图，搞懂 Nginx 高性能网络工作原理！](https://mp.weixin.qq.com/s/AX6Fval8RwkgzptdjlU5kg)


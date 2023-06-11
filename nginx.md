<!-- vim-markdown-toc GFM -->

* [LNMP](#lnmp)
* [nginx](#nginx)
    * [基本命令](#基本命令)
    * [基本配置](#基本配置)
        * [Static Server (静态页面)](#static-server-静态页面)
        * [Proxy Server (代理服务器)](#proxy-server-代理服务器)
        * [fastcgi](#fastcgi)
        * [echo 模块](#echo-模块)
        * [allow deny limit_except](#allow-deny-limit_except)
        * [跨域请求头部配置](#跨域请求头部配置)
    * [log (日志)](#log-日志)
        * [access log:](#access-log)
        * [error log](#error-log)
        * [open_log_file_cache 日志缓存](#open_log_file_cache-日志缓存)
    * [用户密码认证](#用户密码认证)
    * [对 ua 进行限制](#对-ua-进行限制)
    * [ssl](#ssl)
    * [负载均衡](#负载均衡)
        * [upstream](#upstream)
        * [echo 变量](#echo-变量)
    * [更多配置](#更多配置)
        * [性能相关的配置](#性能相关的配置)
        * [网络相关的配置](#网络相关的配置)
        * [文件相关的配置](#文件相关的配置)
    * [pcre 正则表达式](#pcre-正则表达式)
    * [njs](#njs)
    * [NSM 管理 kubernetes 容器流量](#nsm-管理-kubernetes-容器流量)
    * [install 安装](#install-安装)
    * [pcre 正则表达式](#pcre-正则表达式-1)
    * [njs](#njs-1)
    * [NSM 管理 kubernetes 容器流量](#nsm-管理-kubernetes-容器流量-1)
    * [install 安装](#install-安装-1)
    * [reference](#reference)
    * [第三方高效软件](#第三方高效软件)
    * [书籍 or 教程](#书籍-or-教程)
    * [项目资源](#项目资源)
        * [cgit](#cgit)
* [TOMCAT](#tomcat)
    * [基本命令](#基本命令-1)
    * [zrlog](#zrlog)
    * [mysql zrlog](#mysql-zrlog)
        * [zrlog 连接 mysql](#zrlog-连接-mysql)
        * [nginx 反向代理 tomcat](#nginx-反向代理-tomcat)
* [php-fpm](#php-fpm)
    * [php-fpm.conf](#php-fpmconf)
    * [php-fpm 进程池](#php-fpm-进程池)
    * [php.ini](#phpini)
* [reference](#reference-1)

<!-- vim-markdown-toc -->

# LNMP

- [LNMP 一键安装包](https://github.com/licess/lnmp)

- [DNMP(docker) 一键安装包](https://github.com/yeszao/dnmp)

- [不同 web 服务器份额](https://news.netcraft.com/archives/2020/10/21/october-2020-web-server-survey.html)

# [nginx](http://nginx.org/en/docs/)

由 一个`main` 和 多个`worker` 进程，通过事件驱动和操作系统机制进行分配

- main: 读取检查 conf 配置文件,管理 worker 进程

- [worker](http://nginx.org/en/docs/ngx_core_module.html#worker_processes): 处理实际请求,数量由 CPU 核心数决定.worker 进程之间共享内存,原子操作等.几乎不会进入睡眠状态,请求数却决于内存大小

```nginx
# 在配置文件,可以设置为auto (默认为1)
worker_processes auto;

# 也可以指定数量和对应的cpu
worker_processes 4;
worker_cpu_affinity 1000 0100 0010 0001;
```

## 基本命令

```sh
# -t 检查配置是否正确
nginx -t

# -c 指定加载配置文件
nginx -c  /etc/nginx/nginx.conf

# -v 查看版本
nginx -v

# -V 查看模块安装
nginx -V

# -s 发送signal (类似于systemctl)

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

## 基本配置

配置文件:
[官方教程(英文)](http://nginx.org/en/docs/beginners_guide.html);
[中文](https://github.com/DocsHome/nginx-docs/blob/master/%E4%BB%8B%E7%BB%8D/%E5%88%9D%E5%AD%A6%E8%80%85%E6%8C%87%E5%8D%97.md)

[官方配置例子](https://www.nginx.com/resources/wiki/start/topics/examples/full/)

- directives(指令)模块可以是一个指令,指令以 `;` 结尾

- block directives(块指令)`{}` 将一组指令包起来

- `#` 可注释指令

- block directives 括号内有其他指令,则称为 context(上下文),如 events, http, server, and location

- 内层块会继承外层块的设置，如果有冲突以内层块为主， **http 块** 设置 `gzip on` 而 **location 块** 设置 `gzip off` 结果为 **off**

### Static Server (静态页面)

配置文件: nginx 安装路径下的 **conf** 目录(/usr/local/nginx/conf/nginx.conf)

```nginx
# 静态页面的配置
server {
    listen       80;
    server_name  localhost;
    # 省略...
    location / {
        root   html;
        index  index.html index.htm;
    }
    # 省略...
}
```

[**nginx** 使用的正则表达式与 **Perl** 编程语言 `PCRE` 使用的正则表达式**兼容**](https://github.com/DocsHome/nginx-docs/blob/master/%E4%BB%8B%E7%BB%8D/%E6%9C%8D%E5%8A%A1%E5%99%A8%E5%90%8D%E7%A7%B0.md)

- server_name: 定义服务器名称，确定使用哪个 `server 块` 进行请求

- location: 表示匹配的请求, `/` 表示匹配所有

- root: 表示路径 (这里为 nginx 安装路径 的相对目录 **html** `/usr/local/nginx/html/`)

- 以上综合来说就是: 在 `localhost(127.0.0.1)` 的 `80` 端口下匹配`/usr/local/nginx/html/`目录下的 `index.html` 和 `index.htm` 文件

我们把 html 目录下的 **index.html** 的标题改为 **tz-pc** 进行测试:

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

设置图片的目录(通过正则表达式匹配 gif,png,jpg):

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

修改后重新加载配置:

```sh
sudo nginx -s reload
```

- 1.测试: 在浏览器里输入`127.0.0.1/YouPictureName`
  ![image](./Pictures/nginx/static1.avif)

- 2.测试: curl 后通过重定向下载

```sh
curl 127.0.0.1/YouPictureName > /tmp/YouPictureName.png
```

### Proxy Server (代理服务器)

- 正向代理:用户可以察觉.(360,火绒等防火墙)

  ![image](./Pictures/nginx/proxy2.avif)

- 反向代理:一般在内网无法察觉(类似于中介)

  ![image](./Pictures/nginx/proxy3.avif)

proxy_pass 指令: 让 **80** 端口代理 **8080** 端口的流量

添加一个新的 **server** 块，监听 **8080** 端口:

```nginx
    server {
        listen 8080;
        server_name  localhost;

        location / {
        # 设置代理为 80 端口
            proxy_pass http://localhost:80/;
        }
    }
```

- 1.静态主页测试: 在浏览器里输入`127.0.0.1:8080`:
  ![image](./Pictures/nginx/proxy.avif)

- 2.图片测试: 在浏览器里输入`127.0.0.1:8080/YouPictureName.png`:
  ![image](./Pictures/nginx/proxy1.avif)

### fastcgi

```nginx
location /\.php$ {
    fastcgi_pass  localhost:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param QUERY_STRING    $query_string;
}

$document_root 与 root 指令的值是一样的，变量 $fastcgi_script_name 的值为请求URI，即 /index.php。
```

### echo 模块

[跳转至 echo 模块安装](#echo)

在 80 端口的 server 下加入:

```nginx
location /echo {
    set $a 'tz';
    set $b 'i\'m $a';
    echo "$b";
    echo "Here is $a nginx tutorial";
}
```

测试:
http://127.0.0.1/echo

因为刚才设置了代理，所以 8080 也是可以的:
http://127.0.0.1:8080/echo

### allow deny limit_except

limit_except: http request methods (请求方法)限制

| http request methods | 内容                                                   |
| -------------------- | ------------------------------------------------------ |
| GET                  | 请求资源，返回实体,不会改变服务器状态(额外参数在url内),因此比post安全                    |
| HEAD                 | 请求获取响应头，但不返回实体                           |
| POST                 | 用于提交数据请求处理，(额外参数在请求体内),会改变服务器状态             |
| PUT                  | 请求上传数据                                           |
| DELETE               | 请求删除指定资源                                       |
| MKCOL                |                                                        |
| COPY                 |                                                        |
| MOVE                 |                                                        |
| OPTIONS              | 请求返回该资源所支持的所有 HTTP 请求方法               |
| PROPFIND             |                                                        |
| PROPPATCH            |                                                        |
| LOCK                 |                                                        |
| UNLOCK               |                                                        |
| PATCH                | 类似 PUT,用于部分更新,当资源不存在，会创建一个新的资源 |

除了 192.168.100.0/24 **以外** ，其他只能使用 `get` 和 `head` (get 包含 head) 方法:

```nginx
# in location
limit_except GET {
    allow 192.168.100.0/24;
    deny all;
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

## log (日志)

- [ngx_http_log_module 模块指定日志格式等](https://github.com/DocsHome/nginx-docs/blob/master/%E6%A8%A1%E5%9D%97%E5%8F%82%E8%80%83/http/ngx_http_log_module.md)

### access log:

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

使用 `gzip` 压缩日志，日志将会是**二进制格式**

```nginx
access_log  logs/access/80.access.log combined gzip flush=5m;
```

重启日志:

```sh
sudo nginx -s reload
sudo nginx -s reopen
```

![image](./Pictures/nginx/access_log1.avif)
可通过 `zcat` 查看

```sh
zcat 80.access.log
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

默认是 error:

> error_log logs/error.log error;

设置为 debug 会输出所有日志:

```nginx
error_log  logs/error.log debug;
```

`debug_connection` 指定客户端输出 debug 等级:

```nginx
events {
    # 只有192.168.100.1 和 192.168.100.0/24 客户端才会输出debug等级
    debug_connection 192.168.100.1;
    debug_connection 192.168.100.0/24;
}
```

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

## 用户密码认证

Nginx 用户认证也需要用到 apache 密码生成命令

```sh
# 在/etc/nginx下创建密码文件
htpasswd -c /etc/nginx/htpasswd tz # 用户tz

# 在location函数下
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        #加入以下3行
        #auth setting
        auth_basic "Auth";
        auth_basic_user_file /etc/nginx/htpasswd;
    }

# 使用curl进行测试
curl -u 'tz:12345' 127.0.0.1:80    # 密码12345
```

## 对 ua 进行限制

```sh
server
{
    #ua setting
    if ($http_user_agent ~ 'Mozilla|AppleWebKit|Chrome|Safari|curl')
    {
        return 403;
    }
}
```

## ssl

```sh
# 下载解压后进入目录
cd nginx-1.18.0

# 安装ssl模块
./configure --prefix=/etc/nginx --with-http_ssl_module
make

# 查看
nginx -V
```

```sh
# 生成私钥
openssl genrsa -des3 -out tz.key 2048

# 转换私钥(因为生成私钥每次浏览器https访问都需要密码)
openssl rsa -in tz.key -out tz2.key

# 生成tz2.csr证书
openssl req -new -key tz2.key -out tz2.csr

# 生成tz2.crt公钥
openssl x509 -req -days 365 -in tz2.csr -signkey tz2.key -out tz2.crt
```

在 server 函数下的设置

```sh
server
{
    listen 443 ssl;
    server_name tz.com;
    root /etc/nginx;
    index index.html index.htm;

    #ssl setting
    ssl_certificate tz2.crt;
    ssl_certificate_key tz2.key;
    #缓存有效期
    ssl_session_timeout  5m;
    #加密算法
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    #安全链接可选的加密协议
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    #使用服务器端的首选算法
    ssl_prefer_server_ciphers on;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

## 负载均衡

### upstream

代理两台或者多台设备就是负载均衡

- 1:轮询
  轮询是 upstream 的默认分配方式，即每个请求按照时间顺序轮流分配到不同的后端服务器，如果某个后端服务器 down 掉后，能自动剔除。

- 2:weight（权重）
  轮询的加强版，既可以指定轮询比率，weight 和访问几率成正比，主要应用于后端服务器异质的场景下。

- 3:ip_hash
  每个请求按照访问 Ip（即 Nginx 的前置服务器或客户端 IP）的 hash 结果分配，这样每个访客会固定访问一个后端服务器，可以解决 session 一致问题。

- 4:fair
  fair 顾名思义，公平地按照后端服务器的响应时间（rt）来分配请求，响应时间（rt）小的后端服务器优先分配请求。
- 5:url_hash
  与 ip_hash 类似，但是按照访问 url 的 hash 结果来分配请求，使得每个 url 定向到同一个后端服务器，主要应用于后端服务器为缓存的场景下。

```sh
upstream baidu.com
{
    # ip of baidu.com
    ip_hash;
    server 182.61.200.6:80;
    server 182.61.200.7:80;
}
server
{
    listen 8080;
    server_name www.baidu.com;
    location / {
        proxy_pass http://baidu.com;
        proxy_set_header HOST $host;
        proxy_set_header X-Real_IP $remote_addr;
        proxy_set_header X-Forwared-For $proxy_add_x_forwarded_for;
    }
}

# 使用curl进行测试
curl -x 127.0.0.1:8080 www.baidu.com
```

### echo 变量

```sh
# 安装 echo 模块
./configure --prefix=/etc/nginx --add-module=/etc/nginx/echo-nginx-module
make

# 配置
location /test {
    set $test tz;
    echo "foo: $test";
}

# 测试
curl 127.0.0.1:80/test
```

## 更多配置

- [ngx_http_core_module 模块参数](http://nginx.org/en/docs/http/ngx_http_core_module.html)

### 性能相关的配置

```nginx
# ssl硬件加速卡，可通过(openssl engine -t查看)
ssl_engine device;

# 设置 worker 进程的静态优先级-20 ~ +19(默认是0)
worker_priority 0;

# http头 超过 1k 时，才写入磁盘
client_header_buffer_size 1k;

# http头 超过 4k,8k 时，行超过返回414,头超过返回400
large_client_header_buffers 4 8k;

# http头 超过 4k,8k 时，返回414,400
large_client_header_buffers 4 8k;

# http包体 超过 8k,16k 时，才写入磁盘
client_body_buffer_size 8k 16k;

# http的头部Content_Length 超过 1m 时返回413
client_max_body_size 1m;
```

### 网络相关的配置

```nginx
# 连接超时后 发送 RST 直接重置连接，避免4次挥手的 TCP 连接
reset_timeout_connection off

# 开启 lingering_close 并超过 client_max_body_size 大小返回413后, 客户端仍再发送时，超过 30s 后关闭连接
lingering_time 30s
```

### 文件相关的配置

```nginx
# on 表示开启零拷贝技术，使用 sendfile() 系统调用传输文件：2 次上下文切换，和 2 次数据拷贝
# off 使用 read() + write() 传统方式进行传输文件：4 次上下文切换，和 4 次数据拷贝
sendfile on

# 在sendfile on后 将响应包头放到一个 TCP 包中发送
tcp_nopush off

# aio (异步I/O)
aio on

# 使用 O_DIRECT 读取文件 和 sendfile 互诉
directio_aligment size

# 文件缓存(默认off)
open_file_cache max=1000 inactive=20s
```

- 当文件大小大于 `directio` 值后，使用「异步 I/O + 直接 I/O」，否则使用零拷贝技术（sendfile)

```nginx
location /video/ { 
    sendfile on; 
    aio on; 
    directio 1024m; 
}
```

## pcre 正则表达式

## [njs](http://nginx.org/en/docs/njs/)

njs 是 JavaScript 语言的一个子集，它允许扩展 nginx 的功能

## [NSM 管理 kubernetes 容器流量](https://www.nginx.com/blog/introducing-nginx-service-mesh/)

## [install 安装](http://nginx.org/en/linux_packages.html)

- [菜鸟教程](https://www.runoob.com/linux/nginx-install-setup.html)

- [源码下载(搜狗镜像)](http://mirrors.sohu.com/nginx/?C=M&O=D)

## pcre 正则表达式

## [njs](http://nginx.org/en/docs/njs/)

njs 是 JavaScript 语言的一个子集，它允许扩展 nginx 的功能

## [NSM 管理 kubernetes 容器流量](https://www.nginx.com/blog/introducing-nginx-service-mesh/)

## [install 安装](http://nginx.org/en/linux_packages.html)

- [菜鸟教程](https://www.runoob.com/linux/nginx-install-setup.html)

- [源码下载(搜狗镜像)](http://mirrors.sohu.com/nginx/?C=M&O=D)

[安装配置](http://nginx.org/en/docs/configure.html):

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
sudo make && sudo make install

# 设置硬连接到 /bin 目录
sudo ln /usr/local/nginx/sbin/nginx /bin/nginx

# 启动nginx
sudo nginx
```

生成的 `ngx_modules.c` 文件里的 `mgx_modules` 数组表示 nginx 每个模块的优先级,对于`HTTP过滤模块`则相反，越后越优先

## reference

- [Nginx 安装 SSL 配置 HTTPS 超详细完整教程全过程](https://developer.aliyun.com/article/766958)

- [Nginx 教程的连载计划](https://developer.aliyun.com/article/244524?spm=a2c6h.14164896.0.0.32ff7f61TT5mAL)

- [Dropbox 正在用 Envoy 替换 Nginx，这还是我第一次看到讨论 Nginx 作为 Web 服务器的缺点 --ruanyif](https://dropbox.tech/infrastructure/how-we-migrated-dropbox-from-nginx-to-envoy)

## 第三方高效软件

- [ngxtop 日志监控](https://github.com/lebinh/ngxtop)

```sh
sudo ngxtop -l /usr/local/nginx/logs/access/80.access.log
```

![image](./Pictures/nginx/ngxtop.gif)

统计客户端 ip 访问次数:

```sh
ngxtop top remote_addr -l /usr/local/nginx/logs/access/80.access.log
```

![image](./Pictures/nginx/ngxtop1.gif)

- [goaccess 日志监控](https://goaccess.io/)

cli(命令行监控):

```sh
sudo goaccess /usr/local/nginx/logs/access/80.access.log
```

![image](./Pictures/nginx/goaccess.gif)

输出 静态 html 页面:

```sh
sudo goaccess /usr/local/nginx/logs/access/80.access.log  -o /tmp/report.html --log-format=COMBINED

# 打开html
chrome /tmp/report.html
```

![image](./Pictures/nginx/goaccess.avif)

输出 实时 html 页面:

```sh
sudo goaccess /usr/local/nginx/logs/access/80.access.log -o /tmp/report.html --log-format=COMBINED --real-time-html
```

![image](./Pictures/nginx/goaccess1.gif)

- [rhit:A nginx log explorer](https://github.com/Canop/rhit)

## 书籍 or 教程

- [官方教程中文](https://github.com/DocsHome/nginx-docs/blob/master/SUMMARY.md)

- [Nginx 开发从入门到精通(淘宝内部的书)](http://tengine.taobao.org/book/index.html)

- [nginx books](http://nginx.org/en/books.html)

- [章亦春又名春哥的 nginx 教程](http://openresty.org/download/agentzh-nginx-tutorials-zhcn.html);
  [章亦春 nginx core 的 memleak(内存泄漏)火焰图](http://agentzh.org/misc/flamegraph/nginx-memleak-2013-08-05.svg)

## 项目资源

- [自动生成 nginx.conf](https://www.digitalocean.com/community/tools/nginx)

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

# TOMCAT

- 虽然 Tomcat 也可以认为是 HTTP 服务器，但通常它仍然会和 Nginx 配合在一起使用：动静态资源分离——运用 Nginx 的反向代理功能分发请求：所有动态资源的请求交给 Tomcat，而静态资源的请求（例如图片、视频、CSS、JavaScript 文件等）则直接由 Nginx 返回到浏览器，这样能大大减轻 Tomcat 的压力。

- 负载均衡，当业务压力增大时，可能一个 Tomcat 的实例不足以处理，那么这时可以启动多个 Tomcat 实例进行水平扩展，而 Nginx 的负载均衡功能可以把请求通过算法分发到各个不同的实例进行处理

其实 `Tomcat` 只是一个中间件，真正起作用的是已经安装的 `jdk`。
![image](./Pictures/nginx/1.avif)
`tomcat`的配置文件是`xml` 格式

## 基本命令

```sh
# 虚拟主机配置在server.xml下
<Host name="tzlog.com"  appBase="webapps"
    unpackWARs="true" autoDeploy="true">
...
</HOST>
```

- name 定义域名
- appBase 定义默认应用目录
- unpackWARs=”true” 是否自动解压；(也是就是说，当我们往站点目录里面直接上传一个 war 的包，它会自动解压)
- docBase，这个参数用来定义网站的文件存放路径，如果不定义，默认是在 appBase/ROOT 下面，定义了 docBase 就以该目录为主了，其中 appBase 和 docBase 可以一样。在这一步操作过程中,可能会遇到过访问 404 的问题，其实就是 docBase 没有定义对。

---

默认端口

- 8080 是 Tomcat 提供 web 服务的端口
- 8009 是 AJP 端口（第三方的应用连接这个端口，和 Tomcat 结合起来）
- 8005 shutdown（管理端口）

```sh
# 将8080修改为80端口
sed -i 's/port="8080"/port="80"/' /etc/tomcat/server.xml

# 查看端口
netstat -tunlp | grep 80
```

---

日志

- catalina 开头的日志为 Tomcat 的综合日志，它记录 Tomcat 服务相关信息，也会记录错误日志。
- catalina.2017-xx-xx.log 和 catalina.out 内容相同，前者会每天生成一个新的日志。
- host-manager 和 manager 为管理相关的日志，其中 host-manager 为虚拟主机的管理日志。
- localhost 和 localhost_access 为虚拟主机相关日志，其中带 access 字样的日志为访问日志，不带 access 字样的为默认虚拟主机的错误日志。

## zrlog

```sh
# 安装
wget http://dl.zrlog.com/release/zrlog.war /usr/share/tomcat7/webapps

# 访问
http://127.0.0.1:8080/zrlog/install
```

![image](./Pictures/nginx/2.avif)

## mysql zrlog

### zrlog 连接 mysql

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

![image](./Pictures/nginx/3.avif)

### nginx 反向代理 tomcat

将域名加入`/etc/hosts`

```sh
echo "127.0.0.1 tzlog.com" >> /etc/hosts
```

```sh
server
{
        server_name  tzlog.com;
    location / {
        proxy_pass http://tzlog.com:8081/zrlog/;
        proxy_set_header HOST $host;
        proxy_set_header X-Real_IP $remote_addr;
        proxy_set_header X-Forwared-For $proxy_add_x_forwarded_for;
    }

        access_log /var/log/nginx/zrlog-access.log;
        error_log  /var/log/nginx/zrlog-error.log;
}
```

# php-fpm

- PHP-FPM(PHP FastCGI Process Manager)意：PHP FastCGI 进程管理器，用于管理 PHP 进程池的软件，用于接受 web 服务器的请求。
- PHP-FPM 提供了更好的 PHP 进程管理方式，可以有效控制内存和进程、可以平滑重载 PHP 配置

```sh
# 服务端192.168.100.208
echo "<?php echo phpinfo(); ?>" > /usr/share/nginx/html/tz.php

# 客户端测试
curl -x 192.168.100.208:80 tz.com/tz.php | php
```

## php-fpm.conf

- 可配置多个`pool`

> 默认配置了一个`www` pool
> 如果 nginx 有多个站点，都使用一个 pool，则会有单点错误
> 因此要每个站点都配置一个 pool

```sh
pid = /var/log/php-fpm/php-fpm.pid
include=/etc/php/php-fpm.d/*.conf
```

## php-fpm 进程池

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

## php.ini

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

# reference
- [nginx ssl 配置](https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=intermediate&openssl=1.1.1d&guideline=5.6)

- [测试网站是否支持 http2 和 alpn](https://tools.keycdn.com/http2-test)

- [朱小厮的博客：原创 | Nginx 架构原理科普]()
- [朱小厮的博客：OpenResty 概要及原理科普]()
- [朱小厮的博客：原创 | 微服务网关 Kong 科普]()

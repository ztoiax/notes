<!-- vim-markdown-toc GFM -->

* [LNMP](#lnmp)
* [nginx](#nginx)
    * [基本命令](#基本命令)
    * [日志](#日志)
    * [用户密码认证](#用户密码认证)
    * [只允许特定 ip 访问](#只允许特定-ip-访问)
    * [对 ua 进行限制](#对-ua-进行限制)
    * [ssl](#ssl)
    * [负载均衡](#负载均衡)
        * [upstream](#upstream)
        * [echo 变量](#echo-变量)
* [`TOMCAT`](#tomcat)
    * [基本命令](#基本命令-1)
    * [zrlog](#zrlog)
    * [mysql](#mysql)
        * [Centos 7 安装 MySQL](#centos-7-安装-mysql)
        * [zrlog 连接 mysql](#zrlog-连接-mysql)
* [reference](#reference)
* [其它文章](#其它文章)

<!-- vim-markdown-toc -->

# LNMP

# nginx

## 基本命令

```sh
# 启动关闭重载
nginx -s reload
nginx -s start
nginx -s stop

# 检查配置是否正确
nginx -t

# 指定加载配置文件
nginx -c  /etc/nginx/nginx.conf

# 查看模块安装
nginx -V
```

## 日志

`log_format` 是访问日志的格式

```sh
在server下加入这行
server
{
        #log setting
        access_log /var/log/nginx/tz-access.log;
        error_log  /var/log/nginx/tz-error.log;
}
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

## 只允许特定 ip 访问

```sh
server
{
    location / {
        #ip setting
        allow 127.0.0.1;
        allow 192.168.0.1;
        deny all;
    }
}
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

# `TOMCAT`

- 虽然 Tomcat 也可以认为是 HTTP 服务器，但通常它仍然会和 Nginx 配合在一起使用：动静态资源分离——运用 Nginx 的反向代理功能分发请求：所有动态资源的请求交给 Tomcat，而静态资源的请求（例如图片、视频、CSS、JavaScript 文件等）则直接由 Nginx 返回到浏览器，这样能大大减轻 Tomcat 的压力。

- 负载均衡，当业务压力增大时，可能一个 Tomcat 的实例不足以处理，那么这时可以启动多个 Tomcat 实例进行水平扩展，而 Nginx 的负载均衡功能可以把请求通过算法分发到各个不同的实例进行处理

其实 `Tomcat` 只是一个中间件，真正起作用的是已经安装的 `jdk`。
![avatar](/Pictures/nginx/1.png)
`tomcat`的配置文件是`xml` 格式

## 基本命令

```sh
# 虚拟主机配置在server.xml下
<Host name="localhost"  appBase="webapps"
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

![avatar](/Pictures/nginx/2.png)

## mysql

从 CentOS 7 开始，`yum` 安装 `MySQL` 默认安装的会是 `MariaDB`

### Centos 7 安装 MySQL

整个过程需要科学上网

```sh
# 下载
wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm

# 安装源
rpm -Uvh mysql80-community-release-el7-3.noarch.rpm

# 查看安装是否成功
yum repolist enabled | grep "mysql.*-community.*"

# 查看当前MySQL Yum Repository中所有MySQL版本（每个版本在不同的子仓库中）
yum repolist all | grep mysql

# 切换版本
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community

# 安装
yum install mysql-community-server
```

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

![avatar](/Pictures/nginx/3.png)

# reference

- [Nginx 安装 SSL 配置 HTTPS 超详细完整教程全过程](https://developer.aliyun.com/article/766958)
- [Nginx 教程的连载计划](https://developer.aliyun.com/article/244524?spm=a2c6h.14164896.0.0.32ff7f61TT5mAL)
- [tomcat 与 nginx，apache 的区别是什么？](https://www.zhihu.com/question/32212996/answer/87524617)
- [你还记得 Tomcat 的工作原理么](https://zhuanlan.zhihu.com/p/248426114)
- [CentOS 安装 MySQL 详解](https://juejin.im/post/6844903870053761037)
- [Tomcat 基础架构——jdk、java、zrlog](https://my.oschina.net/u/3851633/blog/1858422)

# 其它文章

- [Dropbox 正在用 Envoy 替换 Nginx，这还是我第一次看到讨论 Nginx 作为 Web 服务器的缺点 --ruanyif](https://dropbox.tech/infrastructure/how-we-migrated-dropbox-from-nginx-to-envoy)

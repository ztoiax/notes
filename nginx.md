<!-- vim-markdown-toc GFM -->

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
* [reference](#reference)
* [其它文章](#其它文章)

<!-- vim-markdown-toc -->

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
upstream qq_com
{
    # ip of qq.com
    ip_hash;
    server 125.39.52.26:80;
    server 58.247.214.47:80;
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


# reference
- [Nginx 安装 SSL 配置 HTTPS 超详细完整教程全过程](https://developer.aliyun.com/article/766958)
- [Nginx 教程的连载计划](https://developer.aliyun.com/article/244524?spm=a2c6h.14164896.0.0.32ff7f61TT5mAL)

# 其它文章
- [Dropbox 正在用 Envoy 替换 Nginx，这还是我第一次看到讨论 Nginx 作为 Web 服务器的缺点 --ruanyif](https://dropbox.tech/infrastructure/how-we-migrated-dropbox-from-nginx-to-envoy)

<!-- vim-markdown-toc GFM -->

* [nginx](#nginx)
    * [日志](#日志)
    * [用户密码认证](#用户密码认证)
    * [只允许特定 ip 访问](#只允许特定-ip-访问)
    * [对 ua 进行限制](#对-ua-进行限制)
    * [ssl](#ssl)

<!-- vim-markdown-toc -->

# nginx

## 日志

`log_format` 是访问日志的格式

```sh
在server下加入这行
server{
access_log /var/log/nginx/tz.log;
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
    # 加入以下两行
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
    if ($http_user_agent ~ 'Mozilla|AppleWebKit|Chrome|Safari|curl')
    {
        return 403;
    }
}
```

## ssl

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

在 server 函数下加入

```sh
server
{
    ssl on;
    ssl_certificate tz2.crt;
    ssl_certificate_key tz2.key;
    ssl_protocols TLSV1 TLSV1.1 TLSV1.2;
}
```

# zabbix

- zabbix-server 服务端(默认端口 10051)
- zabbix-agent 客户端 (默认端口 10050)
- zabbix-proxy
- web
- 数据存储

## [centos7 安装](https://www.zabbix.com/download?zabbix=5.0&os_distribution=centos&os_version=7&db=mysql&ws=nginx)

```sh
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5
.0-1.el7.noarch.rpm
# 更换阿里云
sed -i 's/repo.zabbix.com/mirrors.aliyun.com\/zabbix/g' /etc/yum.repos.d/zabbix.repo
yum clean all
yum install centos-release-scl
yum install zabbix-web-mysql-scl zabbix-nginx-conf-scl
yum install zabbix-server-mysql zabbix-agent
yum install zabbix-get zabbix-web zabb-x-web-mysql

```

### mysql 设置

```sh
# 创建数据库
create database zabbix character set utf8 collate utf8_bin;

# 创建zabbix用户(8以下的版本)
grant all on zabbix.* to zabbix@'127.0.0.1' identified by 'YouPassword';

# 创建zabbix用户(8以上的版本)
create user 'zabbix'@'127.0.0.1' identified by 'YouPassword';
grant all privileges on zabbix.* to 'zabbix'@'127.0.0.1';

# 刷新权限
flush privileges;

quit;
```

### 导入 zabbix 初始数据

```sh
# 一共166 rows,过程比较慢
zcat /usr/share/doc/zabbix-server-mysql-5.0.4/create.sql.gz | mysql -uroot -pYouPassword zabbix
```

### 配置

```sh
# 配置zabbix-server
sed -i 's/# DBHost=localhost/DBHost=127.0.0.1/' /etc/zabbix/zabbix_server.conf
sed -i 's/# DBPassword=/DBPassword=YouPassword/' /etc/zabbix/zabbix_server.conf

# 配置 /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
sed -i 's/listen.acl_users = apache/listen.acl_users = apache,nginx/' /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf


# 配置 /etc/opt/rh/rh-nginx116/nginx/conf.d/zabbix.conf, uncomment
listen 80;
server_name example.com;

# 重启服务
systemctl restart zabbix-server zabbix-agent rh-nginx116-nginx rh-php72-php-fpm
systemctl enable zabbix-server zabbix-agent rh-nginx116-nginx rh-php72-php-fpm
```

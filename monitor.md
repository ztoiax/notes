# Prometheus

- [腾讯技术工程：一文带你了解 Prometheus](https://cloud.tencent.com/developer/article/1999843)

- [腾讯技术工程：开源监控系统 Prometheus 最佳实践](https://cloud.tencent.com/developer/article/1902184)

# Grafana

- [腾讯技术工程：上手开源数据可视化工具 Grafana](https://view.inews.qq.com/a/20221014A06MAQ00)

# OpenTelemetry

# OpenFalcon

- [小米技术：小米监控系列: 浅谈持久化]()

    - 小米监控的诞生，缘于我们对监控系统的高度依赖，Zabbix 使用中遇到无法突破的性能瓶颈，以及我们对构建全生命周期自动化运维平台的渴望。2014 年，我们结合小米各运维系统，研发我们自己的监控系统

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

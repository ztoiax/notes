<!-- vim-markdown-toc GFM -->

* [mysql](#mysql)
    * [Centos 7 安装 MySQL](#centos-7-安装-mysql)
    * [从 CentOS 7 开始，`yum` 安装 `MySQL` 默认安装的会是 `MariaDB`](#从-centos-7-开始yum-安装-mysql-默认安装的会是-mariadb)
    * [基本命令](#基本命令)
        * [连接](#连接)
        * [mysql 基本操作](#mysql-基本操作)
    * [mysqldump 备份和恢复](#mysqldump-备份和恢复)
        * [备份](#备份)
        * [恢复](#恢复)
        * [主从备份](#主从备份)
            * [主服务器配置](#主服务器配置)
            * [从服务器配置](#从服务器配置)
        * [测试](#测试)
    * [错误修复](#错误修复)
        * [登录错误](#登录错误)
        * [忘记密码](#忘记密码)

<!-- vim-markdown-toc -->

# mysql

## Centos 7 安装 MySQL

## 从 CentOS 7 开始，`yum` 安装 `MySQL` 默认安装的会是 `MariaDB`

- 整个过程需要科学上网

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

## 基本命令

### 连接

```sh
# 连接
mysql -uroot -p'201997102'

# 远程连接
mysql -uroot -p'201997102' -h192.168.100.208 -P3306

# 使用socket连接(mysql不仅监听3306端口，还监听mysql.sock)
mysql -uroot -p'201997102' -S/tmp/mysql.sock

# 连接后执行命令
mysql -uroot -p'201997102' -e "show databases"
```

### mysql 基本操作

- 注意命令后面要加;

```sh
# 创建名为tz的数据库
create database tz;

# 查看数据库
show databases;

# 使用tz数据库
use tz;

# 创建名为links的表，第一个字段是id，第二个字段是name
create table links(`id` int (4), `name` char(50)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# 查看当前使用哪个数据库
select database();

# 查看表
show tables;

# 查看当前登录用户
select user();

# 查看数据库版本
select version();

# 查看数据库状态
show status;

# 查看数据库队列
show processlist;
```

```sh
# 查看links表里的字段
desc links;
mysql> desc links;
+-------+----------+------+-----+---------+-------+
| Field | Type     | Null | Key | Default | Extra |
+-------+----------+------+-----+---------+-------+
| id    | int      | YES  |     | NULL    |       |
| name  | char(50) | YES  |     | NULL    |       |
+-------+----------+------+-----+---------+-------+
2 rows in set (0.00 sec)
```

```sh
# 查看tz表是如何创建
show create table links\G;

mysql> show create table links\G;
*************************** 1. row ***************************
       Table: links
Create Table: CREATE TABLE `links` (
  `id` int DEFAULT NULL,
  `name` char(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

ERROR:
No query specified

```

```sh
# 查看配置
show variables;
# 查看前面是max_connect的配置(通配符%)
show variables like 'max_connect%';

mysql> show variables like 'max_connect%';
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| max_connect_errors | 100   |
| max_connections    | 151   |
+--------------------+-------+
2 rows in set (0.01 sec)

# 配置(重启后失效)
set global max_connect_errors=1000;
# 永久保存,要写入/etc/my.cnf
echo "max_connect_errors=1000" >> /etc/my.cnf
```

```sh
# 删除links表
drop tables links;

# 删除tz数据库
drop database tz;
```

## mysqldump 备份和恢复

### 备份

```sh
# 备份tz数据库
mysqldump -uroot -pYouPassward tz > tz.sql

# 备份links表
mysqldump -uroot -pYouPassward tz links > links-tables.sql

# 备份所有数据库
mysqldump -uroot -pYouPassward -A > mysqlbak.sql

# 只备份所有数据库表结构(不包含表数据)
mysqldump -uroot -pYouPassward -d -A > mysqlbak-structure.sql

```

### 恢复

```sh
# 恢复数据库到tz数据库
mysql -uroot -pYouPassward tz < tz.sql
```

### 主从备份

#### 主服务器配置

```sh
[mysqld]
server-id=129
log_bin=centos7

binlog-do-db=tz          # 同步指定库tz
binlog-ignore-db=tzblock # 忽略指定库tzblock
```

```sh
# 备份tz数据库
mysqldump -uroot -pYouPassward tz > /root/tz.sql
```

```sh
show master status;

mysql> show master status;
ERROR 2006 (HY000): MySQL server has gone away
No connection. Trying to reconnect...
Connection id:    7
Current database: tz

+----------------+----------+--------------+------------------+-------------------+
| File           | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+----------------+----------+--------------+------------------+-------------------+
| centos7.000001 |      156 |              |                  |                   |
+----------------+----------+--------------+------------------+-------------------+
1 row in set (0.02 sec)
# 日志目录 /var/lib/mysql/centos7.000001
```

#### 从服务器配置

```sh
[mysqld]
server-id=128
```

```sh
# 复制主服务器的tz.sql备份文件
scp -r "root@192.168.100.208:/root/tz.sql" /tmp/mybak
# 创建tz数据库
mysql -uroot -p
create database tz;
# 恢复tz数据库
mysql -uroot -p tz < /tmp/mybak/tz.sql
```

```sh
#
stop slave;

# 开启同步功能
CHANGE MASTER TO MASTER_HOST = '192.168.100.208', MASTER_USER = 'root', MASTER_PASSWORD = '201997102',MASTER_LOG_FILE='centos7.000001', MASTER_LOG_POS=6501;

start slave;
# 恢复主服务器写操作
unlocak talbes;
```

```sh
MariaDB [tz]> show slave status\G;
*************************** 1. row ***************************
                Slave_IO_State: Connecting to master
                   Master_Host: 192.168.100.208
                   Master_User: root
                   Master_Port: 3306
                 Connect_Retry: 60
               Master_Log_File: centos7.000001
           Read_Master_Log_Pos: 6501
                Relay_Log_File: tz-pc-relay-bin.000001
                 Relay_Log_Pos: 4
         Relay_Master_Log_File: centos7.000001
              Slave_IO_Running: Connecting
             Slave_SQL_Running: Yes
```

### 测试

```sh
[mysql]
```

## 错误修复

### 登录错误

```sh
mysql -uroot -p
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
```

修复

```sh
# 在[mysqld]后添加skip-grant-tables（登录时跳过权限检查）
echo "skip-grant-tables" >> /etc/my.cnf
```

### 忘记密码

```sh
# 在[mysqld]后添加skip-grant-tables（登录时跳过权限检查）
echo "skip-grant" >> /etc/my.cnf
```

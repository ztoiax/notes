<!-- vim-markdown-toc GFM -->

* [mysql](#mysql)
    * [基本命令](#基本命令)
        * [连接数据库](#连接数据库)
        * [mysql 基本操作](#mysql-基本操作)
    * [表操作](#表操作)
        * [临时表](#临时表)
        * [复制表](#复制表)
    * [以下练习需下载数据库](#以下练习需下载数据库)
    * [字段数据操作](#字段数据操作)
        * [select](#select)
            * [union](#union)
            * [连接](#连接)
                * [INNER JOIN](#inner-join)
                * [LEFT JOIN](#left-join)
                * [RIGHT JOIN](#right-join)
        * [SQL FUNCTION](#sql-function)
            * [显示函数](#显示函数)
            * [取值函数](#取值函数)
        * [insert](#insert)
        * [delete](#delete)
        * [alter](#alter)
    * [事务](#事务)
    * [INDEX](#index)
    * [mysqldump 备份和恢复](#mysqldump-备份和恢复)
        * [备份](#备份)
        * [主从备份](#主从备份)
            * [主服务器配置](#主服务器配置)
            * [从服务器配置](#从服务器配置)
    * [高效强大的 mysql 软件](#高效强大的-mysql-软件)
        * [mycli](#mycli)
        * [mydumper](#mydumper)
    * [Centos 7 安装 MySQL](#centos-7-安装-mysql)
    * [常见错误](#常见错误)
        * [登录错误](#登录错误)
            * [修复](#修复)
                * [修改密码成功后](#修改密码成功后)
                * [如果出现以下报错(密码不满足策略安全)](#如果出现以下报错密码不满足策略安全)
                    * [修复](#修复-1)
    * [存储组件](#存储组件)
* [reference](#reference)
* [优秀教程](#优秀教程)
* [reference items](#reference-items)
* [online tools](#online-tools)

<!-- vim-markdown-toc -->

# mysql

吐嘈一下`Mysql`排版比`MariaDB`更好

- MariaDB

![avatar](/Pictures/mysql/mariadb.png)

- Mysql

![avatar](/Pictures/mysql/mysql.png)

## 基本命令

### 连接数据库

```sh
# 连接
mysql -uroot -p'newpassword'

# 远程连接
mysql -uroot -p'newpassword' -h192.168.100.208 -P3306

# 使用socket连接(mysql不仅监听3306端口，还监听mysql.sock)
mysql -uroot -p'newpassword' -S/tmp/mysql.sock

# 连接后执行命令
mysql -uroot -p'newpassword' -e "show databases"
```

### mysql 基本操作

- 注意命令后面要加`;`

```sql
# 创建名为tz的数据库
create database tz;

# 查看数据库
show databases;

# 使用tz数据库
use tz;

# 查看数据库状态
show status;

# 查看数据库队列
show processlist;

# 查看数据库保存目录
show variables like 'data%';

# 创建用户
create user 'tz'@'127.0.0.1' identified by 'YouPassword';
# 授予权限
grant all privileges on tz.* to 'tz'@'127.0.0.1';
# 刷新权限
FLUSH PRIVILEGES;
# 删除用户
drop user 'tz'@'127.0.0.1';
```

```sql
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

## 表操作

`字段`

- AUTO_INCREMENT 增量

```sql
# 创建名为links的表，第一个字段是id，第二个字段是name
create table links(`id` int (4), `name` char(50)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# 创建tz数据库主键为id
create table tz(`id` int (8), `name` varchar(50), `date` DATE, primary key (`id`));
```

```sql
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

```sql
# 查看所有表
show tables;

# 查看tz表详细信息
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

### 临时表

- 断开与数据库的连接后，临时表就会自动被销毁

```sql
CREATE TEMPORARY TABLE temp (id int);
```

### 复制表

```sql
# 创建表
create table clone (`id` int (8), `name` varchar(50), `date` DATE, primary key (`id`));

# 复制数据
INSERT INTO clone (id,name,date) SELECT id,name FROM tz;

# 删除重复数据
CREATE TABLE tmp SELECT id, name, date FROM tz  GROUP BY (id, name, date);
DROP TABLE tz;
ALTER TABLE tmp RENAME TO tz;
```

## 以下练习需下载数据库

```sql
# 创建china数据库
create database china;
```

```sh
# 下载2019年中国数据库进行练习
git clone https://github.com/kakuilan/china_area_mysql.git
cd china_area_mysql

# 导入表到china库
mysql -uroot -pYouPassward china < china_area_mysql.sql
```

## 字段数据操作

### select

对`值(values)`的操作

- having
- where
- is null
- is not null

对`字段`的操作

- order by
- group by

```sql
use china;

# 从表 cnarea_2019 选取 name 列的数据
select name from cnarea_2019;

# 从表 cnarea_2019 选取 name 和 id 列的数据
select id,name from cnarea_2019;

# 选取所有列，但只显示第1行
select * from cnarea_2019 limit 1;

#  结果集中会自动去重复数据
select distinct name from cnarea_2019;

# 选取id=174909的数据
select * from cnarea_2019 where id=174909 limit 1;

# 查看id=174909的name数据
select name from cnarea_2019 where id=174909 limit 1;

# 选取name='陆庄村村委会'的数据
select * from cnarea_2019 where name='陆庄村村委会' limit 1;

# 选取id10和id20的
select * from cnarea_2019 where id in (10,20);

# 选取id大于10的
select * from cnarea_2019 where id > 10

# 选取10<=id<=30的
select * from cnarea_2019 where id<=30 and id>=10;

# 选取非空小于10的
select * from ca where id is not null and id < 10;

# 选取id<=10,按level字段进行排序
select * from cnarea_2019 where id<=10 order by level;
# level降序
select * from cnarea_2019 where id<=10 order by level desc;
# level降序,再以id顺序显示
select * from cnarea_2019 where id<=10 order by level desc,id ASC;

# regexp(正则表达式)
select * from cnarea_2019 where id regexp '^1';

# 表别名ca
select * from cnarea_2019 as ca;

# 选取level字段,过滤重复的数据
select distinct level from ca;
```

#### union

多个表显示

```sql
select id,name from cnarea_2019 where id<10 union select id,name from tz;
MariaDB [china]> select id,name from cnarea_2019 where id<10 union select id,name from tz;
+----+--------------------------+
| id | name                     |
+----+--------------------------+
|  1 | 北京市                   |
|  2 | 直辖区                   |
|  3 | 东城区                   |
|  4 | 东华门街道               |
|  5 | 多福巷社区居委会         |
|  6 | 银闸社区居委会           |
|  7 | 东厂社区居委会           |
|  8 | 智德社区居委会           |
|  9 | 南池子社区居委会         |
|  1 | tz                       |
+----+--------------------------+

select id from cnarea_2019 where id<10 union select id from ca where id<10;
# 选取包含重复(all)
select id from cnarea_2019 where id<10 union all select id from ca where id<10;
```

#### 连接

##### INNER JOIN

```sql
SELECT a.id, a.name, b.pinyin FROM cnarea_2019 a INNER JOIN ca b ON a.id = b.id;
# 或者
SELECT a.id, a.name, b.pinyin FROM cnarea_2019 a, ca b WHERE a.id = b.id;
```

##### LEFT JOIN

```sql
SELECT a.id, a.name, b.pinyin FROM cnarea_2019 a LEFT JOIN ca b ON a.id = b.id;
```

##### RIGHT JOIN

```sql
SELECT a.id, a.name, b.pinyin FROM cnarea_2019 a RIGHT JOIN ca b ON a.id = b.id;
```

### SQL FUNCTION

#### 显示函数

```sql
# 查看当前使用哪个数据库
select database();

# 查看当前登录用户
select user();

# 查看数据库版本
select version();
```

#### 取值函数

```sql
# 查看总列数
select count(1) as name from cnarea_2019;

# 统计level的个数
select count(distinct level) from cnarea_2019;

# 对level重复数据的进行统计
select level, count(*) as totals from cnarea_2019 group by level;

# 选取id的最大值
select max(id) as max from cnarea_2019;

# 选取id的最小值
select min(id) as max from cnarea_2019;

# 选取id的平均值
select avg(id) from ca;

# 选取id的总值
select sum(id) from ca;

# 对不同的level，选取id的平均值
select level,avg(id) from ca group by level;
MariaDB [china]> select level,avg(id) from ca group by level;
+-------+-------------+
| level | avg(id)     |
+-------+-------------+
|     0 | 400487.0909 |
|     1 | 419231.0432 |
|     2 | 409585.0334 |
|     3 | 611843.9998 |
|     4 | 350573.3046 |
+-------+-------------+

# 对不同的level，选取id的平均值大于400000
select level,avg(id) from ca group by level having avg(id) > 400000;
MariaDB [china]> select level,avg(id) from ca group by level having avg(id) > 400000;
+-------+-------------+
| level | avg(id)     |
+-------+-------------+
|     0 | 400487.0909 |
|     1 | 419231.0432 |
|     2 | 409585.0334 |
|     3 | 611843.9998 |
+-------+-------------+
```

### insert

```sql
# 新建新数据
insert into cnarea_2019 (id, level) values (783563, 4);

# 查看
MariaDB [china]> select * from cnarea_2019 where id=783563\G;
*************************** 1. row ***************************
         id: 783563
      level: 4
parent_code: 0
  area_code: 0
   zip_code: 000000
  city_code:
       name:
 short_name:
merger_name:
     pinyin:
        lng: 0.000000
        lat: 0.000000
1 row in set (0.000 sec)

# 从link字段导入进links3.注意:(表是区分大小的)
create table links3 (`id` int(4), `name` char(50));
insert into links (id, name) values (1, 'tz');
insert into links3 (id,name) select id,name from links where id=1;
```

### delete

```sql
# 删除id1
delete from ca where id=1;
# 删除id2,3
delete from ca where id in (2,3);

# 修改id=1的city_code字段为111
update ca set city_code=111 where id=1;

# 对每个id-3,填回刚才删除的id1,2,3
update ca set id=(id-3) where id>2;

# 对小于level平均值进行加1
update ca set level=(level+1) where level<=(select avg(level) from ca);
# 检查
select level, count(*) as totals from cn group by level;

# 删除表
delete from cnarea_2019;
# 删除表(无法回退)
truncate table cnarea_2019;
# 删除数据库
drop database china;
```

### alter

```sql
# 重命名表
alter table cnarea_2019 rename ca;

# 将列name改名为mingzi,类型改为char(50)
alter table ca change name mingzi char(50);

# 删除字段
ALTER TABLE tz DROP id;

# 添加字段
ALTER TABLE tz ADD id INT FIRST;

# 重命名id字段为number(bigint类型)
ALTER TABLE tz CHANGE id number BIGINT;
# 修改number为int类型
ALTER TABLE tz MODIFY number INT;
# 或者
ALTER TABLE tz CHANGE number number INT;

# 修改tz表id字段默认值1000
ALTER TABLE tz MODIFY id BIGINT NOT NULL DEFAULT 1000;
# 或者
ALTER TABLE tz ALTER id SET DEFAULT 1000;

# 修改ca表的存储引擎
ALTER TABLE ca ENGINE = MYISAM;

# 添加主键，确保该主键默认不为空（NOT NULL）
ALTER TABLE ca MODIFY id INT NOT NULL;
ALTER TABLE ca ADD PRIMARY KEY (id);
# 删除主键
ALTER TABLE ca DROP PRIMARY KEY;
```

## 事务

- `BEGIN` 开始一个事务
- `ROLLBACK` 事务回滚
- `COMMIT` 事务确认

- `SAVEPOINT savepoint_name;` 声明一个
- `ROLLBACK TO savepoint_name;` 回滚到
- `RELEASE SAVEPOINT savepoint_name;` // 删除指定保留点

## INDEX

```sql
# 显示索引
SHOW INDEX FROM ca;

# 添加索引id
CREATE INDEX id_index ON ca (id);
# 删除索引
DROP INDEX id_index ON ca;

# 添加索引id
ALTER table ca ADD INDEX indexName(id);
# 删除索引
ALTER table ca DROP INDEX indexName;
```

## mysqldump 备份和恢复

> [建议使用更快更强大的 mydumper](#mydumper)

### 备份

```sql
# 导出tz表
SELECT * FROM tz INTO OUTFILE '/tmp/tz.txt';

# 导出tz表csv格式
SELECT * FROM tz INTO OUTFILE '/tmp/tz.csv'
    FIELDS TERMINATED BY ',' ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n';

# 备份tz数据库
mysqldump -uroot -pYouPassward tz > tz.sql

# 备份links表
mysqldump -uroot -pYouPassward tz links > links-tables.sql

# 备份所有数据库
mysqldump -uroot -pYouPassward -A > mysqlbak.sql

# 只备份所有数据库表结构(不包含表数据)
mysqldump -uroot -pYouPassward -d -A > mysqlbak-structure.sql

# 恢复

# 恢复数据库到tz数据库
mysql -uroot -pYouPassward tz < tz.sql

MariaDB [tz] < source tz.sql
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

```sql
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
```

```sql
create database tz;
# 恢复tz数据库
mysql -uroot -p tz < /tmp/mybak/tz.sql
```

```sql
# 关闭同步
stop slave;

# 开启同步功能
CHANGE MASTER TO MASTER_HOST = '192.168.100.208', MASTER_USER = 'root', MASTER_PASSWORD = 'newpassword',MASTER_LOG_FILE='centos7.000001', MASTER_LOG_POS=6501;

start slave;
# 恢复主服务器写操作
unlocak talbes;
```

```sql
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

## 高效强大的 mysql 软件

### [mycli](https://github.com/dbcli/mycli)

更友好的 mysql 命令行
![avatar](/Pictures/mysql/1.png)

### [mydumper](https://github.com/maxbube/mydumper)

<span id="mydumper"></span>
Mydumper 是 MySQL 数据库服务器备份工具，它比 MySQL 自带的 mysqldump 快很多

```sh
# 带压缩备份--compress(gz)
mydumper \
--database=china \
--user=root \
--password=YouPassword \
--outputdir=/tmp/china.sql \
--rows=500000 \
--compress \
--build-empty-files \
--threads=10 \
--compress-protocol
```

![avatar](/Pictures/mysql/2.png)

```sh
# 不带压缩备份,最后再用7z压缩
mydumper \
--database=china \
--user=root \
--password=YouPassword \
--outputdir=/tmp/china.sql \
--rows=500000 \
--build-empty-files \
--threads=10 \
--compress-protocol
```

![avatar](/Pictures/mysql/3.png)

```sh
# 恢复
myloader \
--database=china \
--directory=/tmp/china.sql \
--queries-per-transaction=50000 \
--threads=10 \
--compress-protocol \
--verbose=3
```

## Centos 7 安装 MySQL

从 CentOS 7 开始，`yum` 安装 `MySQL` 默认安装的会是 `MariaDB`

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

## 常见错误

### 登录错误

```sh
mysql -uroot -p
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
```

#### 修复

```sh
# 在[mysqld]后添加skip-grant-tables（登录时跳过权限检查）
echo "skip-grant-tables" >> /etc/my.cnf
```

```sql
# 连接数据库
mysql -uroot -p
use mysql;

# 刷新权限
flush privileges;

# 修改密码(8以下的版本)
update mysql.user set password=PASSWORD('newpassword') where User='root';
# 修改密码(8以上的版本)
alter user 'root'@'localhost' identified by 'newpassword';
```

##### 修改密码成功后

```sh
# 删除刚才添加skip-grant-tables
sed -i '/skip-grant-tables/d' /etc/my.cnf

# 重新连接
mysql -uroot -p
```

##### 如果出现以下报错(密码不满足策略安全)

```sql
mysql> alter user 'root'@'localhost' identified by 'newpassword';
ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
```

###### 修复

```sql
# 查看密码策略
SHOW VARIABLES LIKE 'validate_password%';

mysql> SHOW VARIABLES LIKE 'validate_password%';
+--------------------------------------+--------+
| Variable_name                        | Value  |
+--------------------------------------+--------+
| validate_password.check_user_name    | ON     |
| validate_password.dictionary_file    |        |
| validate_password.length             | 8      |
| validate_password.mixed_case_count   | 1      |
| validate_password.number_count       | 1      |
| validate_password.policy             | MEDIUM |
| validate_password.special_char_count | 1      |
+--------------------------------------+--------+

# 设置策略为LOW
set global validate_password.policy='LOW';

# 密码修改成功
mysql> alter user 'root'@'localhost' identified by 'newpassword';
Query OK, 0 rows affected (0.52 sec)
```

## 存储组件

[mysql 索引结构是在存储引擎层面实现的](http://www.ruanyifeng.com/blog/2014/07/database_implementation.html)

- MyIsam: 速度更快,因为 MyISAM 内部维护了一个计数器，可以直接调取,使用 b+树索引
- InnoDB: 事务更好,使用 b+树索引

```sql
# 查看支持的存储引擎
show engines;

# 查看目前使用的存储引擎
show variables like 'storage_engine';

# 查看links表所使用的存储引擎
show create table links;

# 查看索引包含主键
show index from ca;
```

# reference

- [厉害了，3 万字的 MySQL 精华总结 + 面试 100 问！](https://mp.weixin.qq.com/s?src=11&timestamp=1603207279&ver=2656&signature=PlP1Ta3EiPbja*mclBpkiUWyCM93jx7G0DnE4LwwlzEvW-Fd9hxgIGq1*5ctVid5AZTssRaeDRSKRPlOGOXJfLcS4VUlru*NYhh4BrhZU4k91nsfqzJueeX8kEptSmfc&new=1)
- [21 分钟 MySQL 基础入门](https://github.com/jaywcjlove/mysql-tutorial/blob/master/21-minutes-MySQL-basic-entry.md#%E5%A2%9E%E5%88%A0%E6%94%B9%E6%9F%A5)
- [数据库的最简单实现](http://www.ruanyifeng.com/blog/2014/07/database_implementation.html)
- [Mydumper - MySQL 数据库备份工具](https://linux.cn/article-5330-1.html)

# 优秀教程

- [MySQL 入门教程](https://github.com/jaywcjlove/mysql-tutorial)
- [sql 语句教程](https://www.1keydata.com/cn/sql/)
- [W3cSchool SQL 教程](https://www.w3school.com.cn/sql/index.asp)
- [SQL Exercises(英文)](https://en.wikibooks.org/wiki/SQL_Exercises/The_computer_store)
- [MySQL 教程](https://www.runoob.com/mysql/mysql-tutorial.html)

# reference items

- [MySQL 资源大全中文版](https://github.com/jobbole/awesome-mysql-cn)

# online tools

- [创建数据库的实体-关系图的工具 dbdiagram](https://dbdiagram.io)
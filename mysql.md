<!-- vim-markdown-toc GFM -->

* [mysql SQL 命令入门教程](#mysql-sql-命令入门教程)
    * [基本命令](#基本命令)
        * [连接数据库](#连接数据库)
        * [常用 SQL 命令](#常用-sql-命令)
    * [下载数据库进行 SQL 语句 学习](#下载数据库进行-sql-语句-学习)
    * [DQL（查询）](#dql查询)
        * [SELECT](#select)
            * [where (条件选取)](#where-条件选取)
            * [Order by (排序)](#order-by-排序)
            * [Group by (分组)](#group-by-分组)
            * [regexp (正则表达式)](#regexp-正则表达式)
        * [UNION (多个表显示,以 行 为单位)](#union-多个表显示以-行-为单位)
        * [JOIN (多个表显示,以 列 为单位)](#join-多个表显示以-列-为单位)
        * [SQL FUNCTION](#sql-function)
            * [加密函数](#加密函数)
    * [DML (增删改操作)](#dml-增删改操作)
        * [CREATE(创建)](#create创建)
        * [Insert](#insert)
            * [选取另一个表的数据,导入进新表](#选取另一个表的数据导入进新表)
        * [Update](#update)
        * [Delete and Drop (删除)](#delete-and-drop-删除)
            * [删除重复的数据](#删除重复的数据)
    * [FOREIGN KEY(外键)](#foreign-key外键)
    * [VIEW (视图)](#view-视图)
    * [Stored Procedure and Function (自定义存储过程 和 函数)](#stored-procedure-and-function-自定义存储过程-和-函数)
        * [Stored Procedure (自定义存储过程）](#stored-procedure-自定义存储过程)
        * [ALTER](#alter)
    * [Multiple-Column Indexes (多行索引)](#multiple-column-indexes-多行索引)
        * [B-tree](#b-tree)
        * [explain](#explain)
        * [索引速度测试](#索引速度测试)
    * [DCL](#dcl)
        * [帮助文档](#帮助文档)
        * [用户权限设置](#用户权限设置)
            * [revoke (撤销):](#revoke-撤销)
            * [授予权限,远程登陆](#授予权限远程登陆)
        * [配置(varibles)操作](#配置varibles操作)
    * [mysqldump 备份和恢复](#mysqldump-备份和恢复)
        * [主从同步 (Master Slave Replication )](#主从同步-master-slave-replication-)
            * [主服务器配置](#主服务器配置)
            * [从服务器配置](#从服务器配置)
        * [docker 主从复制](#docker-主从复制)
    * [高效强大的 mysql 软件](#高效强大的-mysql-软件)
        * [mycli](#mycli)
        * [mitzasql](#mitzasql)
        * [mydumper](#mydumper)
        * [percona-toolkit 运维监控工具](#percona-toolkit-运维监控工具)
        * [innotop](#innotop)
        * [sysbench](#sysbench)
        * [dbatool](#dbatool)
        * [undrop-for-innodb(\*数据恢复)](#undrop-for-innodb数据恢复)
* [安装 MySql](#安装-mysql)
    * [Centos 7 安装 MySQL](#centos-7-安装-mysql)
    * [docker 安装](#docker-安装)
    * [常见错误](#常见错误)
        * [登录错误](#登录错误)
            * [修复](#修复)
                * [修改密码成功后](#修改密码成功后)
                * [如果出现以下报错(密码不满足策略安全)](#如果出现以下报错密码不满足策略安全)
                    * [修复](#修复-1)
        * [ERROR 2013 (HY000): Lost connection to MySQL server during query(导致无法 stop slave;)](#error-2013-hy000-lost-connection-to-mysql-server-during-query导致无法-stop-slave)
        * [ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (111)(连接不了数据库)](#error-2002-hy000-cant-connect-to-local-mysql-server-through-socket-varrunmysqldmysqldsock-111连接不了数据库)
        * [ERROR 1075 (42000): Incorrect table definition; there can be only one auto column and it must be defined](#error-1075-42000-incorrect-table-definition-there-can-be-only-one-auto-column-and-it-must-be-defined)
    * [Storage Engine (存储引擎)](#storage-engine-存储引擎)
        * [锁](#锁)
        * [MyISAM](#myisam)
        * [InnoDB](#innodb)
            * [REDO LOG (重做日志)](#redo-log-重做日志)
            * [UNDO LOG](#undo-log)
            * [TRANSACTION (事务)](#transaction-事务)
            * [autocommit](#autocommit)
            * [线程](#线程)
            * [锁](#锁-1)
        * [dictionary(字典)](#dictionary字典)
            * [informantion_schema](#informantion_schema)
            * [performance_schema](#performance_schema)
    * [极限值测试](#极限值测试)
    * [日志](#日志)
* [reference](#reference)
* [优秀文章](#优秀文章)
* [新闻资源](#新闻资源)
* [online tools](#online-tools)

<!-- vim-markdown-toc -->

# mysql SQL 命令入门教程

吐嘈一下`Mysql`排版比`MariaDB`更好

- MariaDB

![avatar](/Pictures/mysql/mariadb.png)

- Mysql

![avatar](/Pictures/mysql/mysql.png)

[Centos7 安装 Mysql](#install)

## 基本命令

### 连接数据库

| 参数 | 内容                 |
| ---- | -------------------- |
| -u   | 用户                 |
| -p   | 密码                 |
| -S   | 使用 socks 进行连接  |
| -h   | 连接指定 ip 的数据库 |
| -e   | 执行 shell 命令      |
| -P   | 连接端口             |

```sh
# 首先要连接进数据库
mysql -uroot -pYouPassword

# -h 连接192.168.100.208主机的数据库
mysql -uroot -pYouPassword -h192.168.100.208 -P3306

# -S 使用socket连接(mysql不仅监听3306端口，还监听mysql.sock)
mysql -uroot -pYouPassword -S/tmp/mysql.sock

# -e 可以执行 sql 命令(这里是show databases;)
mysql -uroot -pYouPassword -e "show databases"
```

[如需,连接远程 server 的数据库 (可跳转至用户权限设置)](#user)

### 常用 SQL 命令

在 `linux` 终端输入的命令是 `shell` 命令

而 `SQL` 命令指进入数据库里的命令

- **注意:** SQL 命令后面要加 `;`

- SQL 命令**大小写不敏感** `CREATE` 或 `create` 都可以
- 而表(table)是要**区分大小写**的

```sql
# 创建名为 tz 的数据库
create database tz;

# 查看数据库
show databases;

# 使用tz数据库
use tz;

# 查看tz数据库里的表
show tables;

# 查看 information_scema 数据库里的表
show tables from information_scema;

# 查看数据库状态
show status;

# 查看mysql的插入次数;
show status like "com_insert%";

# 查看mysql的删除次数;
show status like "com_delete%";

# 查看mysql的查询次数;
show status like "com_select%";

# 查看mysql服务器运行时间
show status like "uptime";

# 查看mysql连接次数
show status like 'connections';

# 查看数据库队列
# 查看数据库状态
show status;

# 查看mysql的插入次数;
show status like "com_insert%";

# 查看mysql的删除次数;
show status like "com_delete%";

# 查看mysql的查询次数;
show status like "com_select%";

# 查看mysql服务器运行时间
show status like "uptime";

# 查看mysql连接次数
show status like 'connections';

# 查看数据库队列
show processlist;

# 查看数据库保存目录
show variables like 'data%';

# SQL FUNCTION
# 查看当前使用哪个数据库
select database();

# 查看当前登录用户
select user();

# 查看数据库版本
select version();
```

## 下载数据库进行 SQL 语句 学习

```sql
# 连接数据库后,创建china数据库
create database china;
```

```sh
# 下载2019年中国地区表,一共有 783562 条数据
git clone https://github.com/kakuilan/china_area_mysql.git
# 如果网速太慢，使用这条国内通道
git clone https://gitee.com/qfzya/china_area_mysql.git

# 导入表到 china 库
cd china_area_mysql
mysql -uroot -pYouPassward china < cnarea20191031.sql
```

## DQL（查询）

### SELECT

对 `值(values)` 的操作

- regexp
- having
- is null
- is not null

对 `字段` 的操作

- order by
- group by
- distinct
- where

---

**语法:**

> ```sql
> SELECT 列名称 FROM 表名称
> ```

---

```sql
# 连接数据库后,进入 china 数据库
use china;

# 查看表 cnarea_2019 的字段(列)
desc cnarea_2019

# 将 cnarea_2019 表改名为 ca ,方便输入
alter table cnarea_2019 rename ca;
# 改回来
alter table ca rename cnarea_2019;

# 从表 cnarea_2019 选取所有列(*表示所有列)
select *
from cnarea_2019;

# 如果刚才将表改成 ca 名，就是以下命令
select *
from ca;

# 从表 cnarea_2019 选取 name 列
select name
from cnarea_2019;

# 从表 cnarea_2019 选取 name 和 id 列
select id,name
from cnarea_2019;

# 选取所有列，但只显示前2行
select *
from cnarea_2019
limit 2;

# 选取 level 列,用 distinct 过滤重复的数据
select distinct level
from cnarea_2019;

# 选取所有列，但只显示100到70000行
select * from cnarea_2019
limit 100,70000;
```

#### where (条件选取)

**语法:**

> ```sql
> SELECT 列名称 FROM 表名称 WHERE 列名称 条件
> ```

---

以条件从表中选取数据

```sql
# 选取 id=1 的数据
select * from cnarea_2019
where id=1;

MariaDB [china]> select * from cnarea_2019 where id=1;
+----+-------+-------------+--------------+----------+-----------+-----------+------------+-------------+---------+------------+-----------+
| id | level | parent_code | area_code    | zip_code | city_code | name      | short_name | merger_name | pinyin  | lng        | lat       |
+----+-------+-------------+--------------+----------+-----------+-----------+------------+-------------+---------+------------+-----------+
|  1 |     0 |           0 | 110000000000 |   000000 |           | 北京市    | 北京       | 北京        | BeiJing | 116.407526 | 39.904030 |
+----+-------+-------------+--------------+----------+-----------+-----------+------------+-------------+---------+------------+-----------+
```

```sql
# 结尾处加入 \G 以列的方式显示
select * from cnarea_2019 where id=1\G;

MariaDB [china]> select * from cnarea_2019 where id=1\G;
*************************** 1. row ***************************
         id: 1
      level: 0
parent_code: 0
  area_code: 110000000000
   zip_code: 000000
  city_code:
       name: 北京市
 short_name: 北京
merger_name: 北京
     pinyin: BeiJing
        lng: 116.407526
        lat: 39.904030
```

```sql
# 选取 id 小于10的数据
select * from cnarea_2019
where id < 10;

# 选取 10<=id<=30 的数据
select * from cnarea_2019
where id<=30 and id>=10;

# 选取 id 等于10 和 id等于20 的数据
select * from cnarea_2019
where id in (10,20);

# 选取 not null(非空) 和 id 小于 10 的数据
select * from ca
where id is not null
and id < 10;
```

有个说法是: where 加 limit 查询比 limit 更快.但我的测试结果不是这样
[测试结果](/mysql-problem.md)

```sql
select * from cnarea_2019
where id > 100
limit 70000;

select * from cnarea_2019
limit 100,70000;
```

#### Order by (排序)

**语法:**

> ```sql
> SELECT 列名称 FROM 表名称 ORDER BY 列名称
> # or
> SELECT 列名称 FROM 表名称 WHERE 列名称 条件 ORDER BY 列名称
> ```

---

```sql
# 以 level 字段进行排序
select * from cnarea_2019
order by level;

# 选取 id<=10 ,以 level 字段进行排序
select * from cnarea_2019
where id<=10
order by level;

# desc 降序
select * from cnarea_2019
where id<=10
order by level desc;

# level 降序,再以 id 顺序显示
select * from cnarea_2019
where id<=10
order by level desc,
id ASC;
```

#### Group by (分组)

```sql
# 以 level 进行分组
select level from cnarea_2019
group by level;

# 结果和select distinct level from cnarea_2019;一样
+-------+
| level |
+-------+
|     0 |
|     1 |
|     2 |
|     3 |
|     4 |
+-------+

# 以 level 进行分组，再以 降序 选取
select level from cnarea_2019
group by level
order by level desc;

+-------+
| level |
+-------+
|     4 |
|     3 |
|     2 |
|     1 |
|     0 |
+-------+
```

#### regexp (正则表达式)

```sql
# 选取以 '广州' 开头的 name 字段
select name from cnarea_2019
where name regexp '^广州';

# 选取包含 '广州' 的name 字段
select name from cnarea_2019
where name regexp '.*广州';
```

### UNION (多个表显示,以 行 为单位)

**语法：**

> ```sql
> SELECT 列名称 FROM 表名称
> UNION
> SELECT 列名称 FROM 表名称
> ```

```sql
# 创建名为 tz 的数据库作实验
create table union_test (
`id` int (8),
`name` varchar(50),
`date` DATE);

# 插入 2 条数据
insert into union_test (id,name,date) values
(1,'tz','2020-10-24');

insert into union_test (id,name,date) values
(100,'tz','2020-10-24');


# 从 union_test 表和 cnarea_2019 表,选取 id,name 列
select id,name from cnarea_2019 where id<10
union select id,name from union_test;

MariaDB [china]> select id,name from cnarea_2019 where id<10 union select id,name from union_test;
+------+--------------------------+
| id   | name                     |
+------+--------------------------+
|    1 | 北京市                   |
|    2 | 直辖区                   |
|    3 | 东城区                   |
|    4 | 东华门街道               |
|    5 | 多福巷社区居委会         |
|    6 | 银闸社区居委会           |
|    7 | 东厂社区居委会           |
|    8 | 智德社区居委会           |
|    9 | 南池子社区居委会         |
|    1 | tz                       |
|  100 | tz                       |
+------+--------------------------+

# 选取列,不包含重复数据
select id from cnarea_2019 where id<10
union select id from union_test;

+------+
| id   |
+------+
|    1 |
|    2 |
|    3 |
|    4 |
|    5 |
|    6 |
|    7 |
|    8 |
|    9 |
|  100 |
+------+

# 选取列,包含重复数据(all)
select id from cnarea_2019 where id<10
union all select id from union_test;

+------+
| id   |
+------+
|    1 |
|    2 |
|    3 |
|    4 |
|    5 |
|    6 |
|    7 |
|    8 |
|    9 |
|    1 |
|  100 |
+------+

# 选取以 深圳市 和 北京市 开头的数据
select id,name from cnarea_2019
where name regexp '^深圳市'
union select id,name from cnarea_2019
where name regexp '^北京市';

+--------+-----------------------------------------+
| id     | name                                    |
+--------+-----------------------------------------+
| 482024 | 深圳市                                  |
| 482546 | 深圳市宝安国际机场                      |
| 482547 | 深圳市宝安国际机场虚拟社区              |
| 482884 | 深圳市大工业区                          |
| 482885 | 深圳市大工业区虚拟社区                  |
|      1 | 北京市                                  |
| 150315 | 北京市双河农场                          |
+--------+-----------------------------------------+
```

### JOIN (多个表显示,以 列 为单位)

从两个或更多的表中获取结果.[图解 SQL 里的各种 JOIN](https://zhuanlan.zhihu.com/p/29234064)

- 只返回两张表匹配的记录，这叫内连接（inner join）。
- 返回匹配的记录，以及表 A 多余的记录，这叫左连接（left join）。
- 返回匹配的记录，以及表 B 多余的记录，这叫右连接（right join）。
- 返回匹配的记录，以及表 A 和表 B 各自的多余记录，这叫全连接（full join）。

![avatar](/Pictures/mysql/join.png)

![avatar](/Pictures/mysql/join1.png)
**语法：**

> ```sql
> SELECT 列名称
> FROM 表名称1
> INNER JOIN 表名称2
> ON 表名称1.列名称=表名称2.列名称
> ```

---

```sql
# 创建表 join__test 等下实验要用
CREATE TABLE j(
`id` int (8),
`name` varchar(50) NOT NULL UNIQUE,
`date` DATE);

# 插入数据
insert into j (id,name,date) values
(1,'tz1','2020-10-24'),
(10,'tz2','2020-10-24'),
(100,'tz3','2020-10-24');

# 查看结果
select * from j;
+------+------+------------+
| id   | name | date       |
+------+------+------------+
|    1 | tz1  | 2020-10-24 |
|   10 | tz2  | 2020-10-24 |
|  100 | tz3  | 2020-10-24 |
+------+------+------------+
```

**INNER JOIN**

```sql
# 选取 j 表的 id,name,date 字段以及 cnarea_2019 表的 name 字段
select j.id,j.date,cnarea_2019.name
from j,cnarea_2019
where cnarea_2019.id=j.id;

# 或者
select j.id,j.name,j.date,cnarea_2019.name
from j inner join  cnarea_2019
on cnarea_2019.id=j.id;

+------+------+------------+--------------------------+
| id   | name | date       | name                     |
+------+------+------------+--------------------------+
|    1 | tz1  | 2020-10-24 | 北京市                   |
|   10 | tz2  | 2020-10-24 | 黄图岗社区居委会         |
|  100 | tz3  | 2020-10-24 | 安德路社区居委会         |
+------+------+------------+--------------------------+
```

STRAIGHT_JOIN:

- 和 `inner join` 语法,结果相同,只是左表总是在右表之前读取

- 因为 `Nest Loop Join` 的算法,用更小的数据表驱动更大数据表，**更快**.

```sql
# 先读取 j 再读取 cnarea_2019 或者说 驱动表是j 被驱动表是cnarea_2019.
# 因为 j 表的数据更小所以更快
select j.id,j.name,j.date,cnarea_2019.name
from j straight_join cnarea_2019
on j.id=cnarea_2019.id;
```

**LEFT JOIN**

```sql
# 左连接，以左表(j)id 字段个数进行选取.所以结果与inner join一样
select j.id,j.name,j.date,cnarea_2019.name
from j left join  cnarea_2019
on cnarea_2019.id=j.id;

+------+------+------------+--------------------------+
| id   | name | date       | name                     |
+------+------+------------+--------------------------+
|    1 | tz1  | 2020-10-24 | 北京市                   |
|   10 | tz2  | 2020-10-24 | 黄图岗社区居委会         |
|  100 | tz3  | 2020-10-24 | 安德路社区居委会         |
+------+------+------------+--------------------------+

# 插入一条高于 cnarea_2019表id最大值 的数据
insert into j (id,name,date) value
(10000000,'tz一百万','2020-10-24');

# 再次左连接，因为 cnarea_2019 没有id 10000000(一百万)的数据，所以这里显示为 null

select j.id,j.name,j.date,cnarea_2019.name
from j left join cnarea_2019
on j.id = cnarea_2019.id;

+----------+-------------+------------+--------------------------+
| id       | name        | date       | name                     |
+----------+-------------+------------+--------------------------+
|        1 | tz1         | 2020-10-24 | 北京市                   |
|       10 | tz2         | 2020-10-24 | 黄图岗社区居委会         |
|      100 | tz3         | 2020-10-24 | 安德路社区居委会         |
| 10000000 | tz一百万    | 2020-10-24 | NULL                     |
+----------+-------------+------------+--------------------------+
```

---

**RIGHT JOIN**

```sql
# 右连接，以右表(cnarea_2019)id字段个数进行选取.左表id没有的数据为null.因为cnarea_2019表数据量太多这里limit 10

select j.id,j.date,cnarea_2019.name,cnarea_2019.pinyin
from j right join cnarea_2019
on j.id=cnarea_2019.id
limit 10;

+------+------------+--------------------------+-------------+
| id   | date       | name                     | pinyin      |
+------+------------+--------------------------+-------------+
|    1 | 2020-10-24 | 北京市                   | BeiJing     |
|   10 | 2020-10-24 | 黄图岗社区居委会         | HuangTuGang |
|  100 | 2020-10-24 | 安德路社区居委会         | AnDeLu      |
| NULL | NULL       | 直辖区                   | BeiJing     |
| NULL | NULL       | 东城区                   | DongCheng   |
| NULL | NULL       | 东华门街道               | DongHuaMen  |
| NULL | NULL       | 多福巷社区居委会         | DuoFuXiang  |
| NULL | NULL       | 银闸社区居委会           | YinZha      |
| NULL | NULL       | 东厂社区居委会           | DongChang   |
| NULL | NULL       | 智德社区居委会           | ZhiDe       |
+------+------------+--------------------------+-------------+
```

---

**FULL OUTER JOIN**

```sql
# 如果mysql不支持 full outer,可以使用 union
SELECT * FROM new LEFT JOIN cnarea_2019 ON new.id = cnarea_2019.id

UNION

SELECT * FROM new RIGHT JOIN cnarea_2019 ON new.id =cnarea_2019.id;
```

### SQL FUNCTION

**语法**

> ```sql
> SELECT function(列名称) FROM 表名称
> ```

```sql
# 选取 id 的最大值和 level 的最小值
select max(id),min(level) as max from cnarea_2019;

# 选取 level 的平均值和 id 的总值
select sum(id),avg(level) from ca;

# 查看总列数
select count(1) as name from cnarea_2019;

# 统计 level 的个数
select count(distinct level) as totals from cnarea_2019;

# 对 level 重复数据的进行统计
select level, count(1) as totals from cnarea_2019
group by level;

# 对不同的 level，选取 id 的平均值
select level,avg(id) from cnarea_2019
group by level;

MariaDB [china]> select level,avg(id) from cnarea_2019 group by level;
+-------+-------------+
| level | avg(id)     |
+-------+-------------+
|     0 | 388711.0000 |
|     1 | 418104.0377 |
|     2 | 409478.6649 |
|     3 | 611846.9998 |
|     4 | 350576.9638 |
+-------+-------------+

# 对不同的 level，选取 id 的平均值大于400000
select level,avg(id) from cnarea_2019
group by level
having avg(id) > 400000;

MariaDB [china]> select level,avg(id) from cnarea_2019 group by level having avg(id) > 400000;
+-------+-------------+
| level | avg(id)     |
+-------+-------------+
|     1 | 418104.0377 |
|     2 | 409478.6649 |
|     3 | 611846.9998 |
+-------+-------------+
```

#### 加密函数

```sql
select md5('123');

# 保留两位小数
select format(111.111,2);

# 加锁函数
select get_lock('lockname',10);
select is_free_lock('lockname');
select release_lock('lockname');
```

## DML (增删改操作)

- 有的地方把 DML 语句（增删改）和 DQL 语句（查询）统称为 DML 语句

### CREATE(创建)

**语法：**

> ```sql
> CREATE TABLE 表名称
> # 注意：列属性可添加和不添加，并且不区分大小写
> (
> 列名称1 数据类型 列属性,
> 列名称2 数据类型 列属性,
> 列名称3 数据类型 列属性,
> ....
> )
> ```

**索引：** 列(字段)相当于一本书，创建 **索引** 就相当于建立 **书目录**,可提高查询速度. [跳转至索引部分](#index)

- **UNIQUE** 唯一性索引

  > - 列(字段) 内的数据不能出现重复

- **PRIMARY KEY** ( `列名称` ) 设置主键
  > - 和 UNIQUE(唯一性索引) 一样。列(字段) 内的数据不能出现重复
  >
  > - 主键一定是唯一性索引，唯一性索引并不一定就是主键。
  >
  > - 主键列不允许空值，而唯一性索引列允许空值。
- 拓展知识: [Clusered Index](https://dev.mysql.com/doc/refman/8.0/en/innodb-index-types.html) and [Secondary Indexes](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_secondary_index)
  > - 主健在 InnoDB 中也叫做 **Clusered Index**(聚焦索引) 除了它以外的主健索引叫 Secondary Indexes(二级索引 或 辅助索引)
  >
  > - 如果表没有 Primary key 或 Unique，InnoDB 会在包含行 ID 值的合成列上生成 GEN_CLUST_INDEX 的隐藏聚集索引
  >
  > - Clusered Index 搜索非常的快，指向包含所有行数据的 Page(页)，如果表非常大，会分为多个 Page 页
  >
  > - Secondary Indexes 可以有 0 个或多个，只满足索引列中的值的查询
- 拓展知识 2:[Fast Index Creation](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_fast_index_creation) 它通过避免完全重写表来加速 Secondary Indexes 的创建和删除

  > [先创建 Clustered Index 表,然后在创建 Secondary Indexes:](https://docs.huihoo.com/mysql/innodb-plugin-1.0-en/innodb-create-index.html)
  >
  > ```sql
  > CREATE TABLE T1(A INT PRIMARY KEY, B INT, C CHAR(1));
  > INSERT INTO T1 VALUES
  > (1,2,'a'), (2,3,'b'), (3,2,'c'), (4,3,'d'), (5,2,'e');
  > COMMIT;
  > ALTER TABLE T1 ADD INDEX (B), ADD UNIQUE INDEX (C);
  > ```
  >
  > 而不是直接创建 Clustered Index 和 Secondary Indexes 表:
  >
  > ```sql
  > CREATE TABLE T1(A INT PRIMARY KEY, B INT unique, C CHAR(1) unique);
  > ```

```sql
# 创建 new 数据库设置 id 为主键,不能为空,自动增量
CREATE TABLE new(
`id` int (8) AUTO_INCREMENT,        # AUTO_INCREMENT 自动增量(每条新记录递增 1)
`name` varchar(50) NOT NULL UNIQUE, # NOT NULL 设置不能为空 # UNIQUE 设置唯一性索引
`date` DATE,
primary key (`id`))                 # 设置主健为 id 字段(列)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# 注意:编码要使用 utf8mb4 因为utf-8,不是真正的utf-8 显示 emoj 会报错
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
# 而不是
ENGINE=InnoDB DEFAULT CHARSET=utf8;

# 这里的int(8),varchar(50),括号里的数字,表示的是最大显示宽度

# 查看 new 表里的字段
desc new;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| id    | int(8)      | NO   | PRI | NULL    | auto_increment |
| name  | varchar(50) | NO   | UNI | NULL    |                |
| date  | date        | YES  |     | NULL    |                |
+-------+-------------+------+-----+---------+----------------+


# 查看 new 表详细信息
show create table new\G;
*************************** 1. row ***************************
       Table: new
Create Table: CREATE TABLE `new` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
1 row in set (0.000 sec)

![avatar](/Pictures/mysql/MySQL-Data-Types.jpg)

# 创建临时表(断开与数据库的连接后，临时表就会自动销毁)
CREATE TEMPORARY TABLE temp (`id` int);
```

### Insert

**语法**

> ```sql
> INSERT INTO 表名称 (列1, 列2,...) VALUES (值1, 值2,....)
> ```

```sql
# 设置初始值为100
ALTER TABLE new AUTO_INCREMENT=100;

# 插入一条数据
insert into new (name,date) values
('tz','2020-10-24');

# 插入多条数据
insert into new (name,date) values
('tz1','2020-10-24'),
('tz2','2020-10-24'),
('tz3','2020-10-24');

# 查看
select * from new;

# 可以看到 id 字段自动增量
MariaDB [china]> select * from new;
+-----+------+------------+
| id  | name | date       |
+-----+------+------------+
| 100 | tz   | 2020-10-24 |
| 102 | tz1  | 2020-10-24 |
| 103 | tz2  | 2020-10-24 |
| 104 | tz3  | 2020-10-24 |
+-----+------+------------+
```

#### 选取另一个表的数据,导入进新表

- 把 cnarea_2019 表里的字段,导入进 newcn 表.
  **语法：**
  > ```sql
  > INSERT INTO 新表名称 (列1, 列2,...) SELECT (列1, 列2,....) FROM 旧表名称;
  > ```

```sql

# 创建名为 newcn 数据库
create table newcn (
id int(4) unique auto_increment,
name varchar(50));

# 导入 1 条数据
insert into newcn (id,name)
select id,name from cnarea_2019
where id=1;

# 可多次导入
insert into newcn (id,name)
select id,name from cnarea_2019
where id >= 2 and id <=10 ;

# 查看结果
select * from newcn;
+------+--------------------------+
| id   | name                     |
+------+--------------------------+
|    1 | 北京市                   |
|    2 | 直辖区                   |
|    3 | 东城区                   |
|    4 | 东华门街道               |
|    5 | 多福巷社区居委会         |
|    6 | 银闸社区居委会           |
|    7 | 东厂社区居委会           |
|    8 | 智德社区居委会           |
|    9 | 南池子社区居委会         |
|   10 | 黄图岗社区居委会         |
+------+--------------------------+

# 插入包含 广州 的数据
insert into newcn (id,name)
select id,name from cnarea_2019
where name regexp '广州.*';
```

### Update

**语法：**

> ```sql
> UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值
> ```

```sql
# 修改 id=1 的 city_code 字段为111
update cnarea_2019
set city_code=111 where id=1;

# 对每个 id-3 填回刚才删除的 id1,2,3
update cnarea_2019
set id=(id-3) where id>2;

# 对小于level平均值进行加1
update cnarea_2019 set level=(level+1)
where level<=(select avg(level) from cnarea_2019);

# 把 广州 修改为 北京,replace() 修改列的某一部分值
update cnarea_2019
set name=replace(name,'广州','北京')
where name regexp '广州.*';

# 把以 北京 和 深圳 开头的数据，修改为 广州
update cnarea_2019
set name=replace(name,'深圳','广州'),
name=replace(name,'北京','广州')
where name regexp '^深圳' or name regexp '^北京';
```

### Delete and Drop (删除)

**语法：**

> ```sql
> # 删除特定的值
> DELETE FROM 表名称 WHERE 列名称 = 值;
> ```

```sql
# 删除 id1
delete from cnarea_2019
where id=1;
# 删除 id2和4
delete from cnarea_2019
where id in (2,4);

# 查看结果
select level, count(*) as totals from cnarea_2019
group by level;

# 删除表
delete from cnarea_2019;

# 删除表(无法回退)
truncate table cnarea_2019;

# 这两者的区别简单理解就是 drop 语句删除表之后，可以通过日志进行回复，而 truncate 删除表之后永远恢复不了，所以，一般不使用 truncate 进行表的删除。
```

**语法：**

> ```sql
> # 删除数据库，表，函数，存储过程
> DROP 类型 名称;
> # 或者 先判断是否存在后,再删除
> DROP 类型 if exists 名称;
> ```

| 类型      |
| --------- |
| TABLE     |
| DATABASE  |
| FUNCTION  |
| PROCEDURE |

```sql
# 删除 cnarea_2019 表
drop table cnarea_2019;

# 先判断 cnarea_2019 表是否存在，如存在则删除
drop table if exists cnarea_2019;

# 删除 china 数据库
drop database china;

# 先判断 chinaa 数据库是否存在，如存在则删除
drop table if exists china;

# 删除后，可以这样恢复数据库
create database china;
mysql -uroot -pYouPassward china < china_area_mysql.sql
```

#### 删除重复的数据

```sql
# 创建表
create table clone (
`id` int (8),
`name` varchar(50),
`date` DATE);

# 插入数据
insert into clone (id,name,date) values
(1,'tz','2020-10-24'),
(2,'tz','2020-10-24'),
(2,'tz','2020-10-24'),
(2,'tz1','2020-10-24'),
(2,'tz1','2020-10-24');

# 通过 ALTER IGNORE 加入 主健(PRIMARY KEY) 删除重复的数据
ALTER IGNORE TABLE clone
ADD PRIMARY KEY (id, name);
# 或者 ALTER IGNORE 加入 唯一性索引(UNIQUE)
ALTER IGNORE TABLE clone
ADD UNIQUE KEY (id, name);

select * from clone;
+----+------+------------+
| id | name | date       |
+----+------+------------+
|  1 | tz   | 2020-10-24 |
|  2 | tz   | 2020-10-24 |
|  2 | tz1  | 2020-10-24 |
+----+------+------------+

# 成功后可以删除 (这是主健)
alter table ca drop primary key;

# 成功后可以删除 (这是unique)
alter table clone drop index id;
alter table clone drop index name;
```

[误删数据进行回滚，跳转至**事务**](#transaction)

## [FOREIGN KEY(外键)](https://www.mysqltutorial.org/mysql-foreign-key/)

- 1.父表和子表必须使用相同的存储引擎

- 2.外键必须建立索引

- 3.外键和引用键中的对应列必须具有相似的数据类型。整数类型的大小和符号必须相同。字符串类型的长度不必相同。

```sql
# 创建 a,b 两表
CREATE TABLE a(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
) ENGINE=INNODB;

CREATE TABLE b(
    id INT AUTO_INCREMENT PRIMARY KEY,
    a_id INT NOT NULL,
    CONSTRAINT fk_a
    FOREIGN KEY (a_id)
    REFERENCES a(id)
) ENGINE=INNODB;

# 插入a 表 id 为1
insert into a (id,name) value
(1,'in a');

# 插入b 表 外键a_id 必须和刚才插入 a 表的 id 值一样
insert into b (id,a_id) value
(10,1);

# 尝试插入b 表新数据
insert into b (id,a_id) value
(20,2);

# 因为a表没有id为2的数据,所以报错
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`china`.`b`, CONSTRAINT `b_ibfk_1` FOREIGN KEY (`a_id`) REFERENCES `a` (`id`))
```

b 表:

```sql
# 尝试修改b 表的 外键a_id 值
update b set a_id = 2
where id = 1;
```

虽然没有报错，但 a_id 并没有修改:

![avatar](/Pictures/mysql/foreign.png)

delete 也一样:

```sql
delete from b
where id =1;
```

![avatar](/Pictures/mysql/foreign1.png)

a 表:

```sql
# 因为没有权限，修改失败
update a set id = 2 where id = 1;
ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`china`.`b`, CONSTRAINT `fk_a` FOREIGN KEY (`a_id`) REFERENCES `a` (`id`))
```

添加权限:

```sql
# 删除外键
ALTER TABLE b DROP FOREIGN KEY fk_a;

# 重新添加外键，并授予权限
ALTER TABLE b
    ADD CONSTRAINT a_id
    FOREIGN KEY (a_id)
    REFERENCES a (id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

# 修改a 表
update a set id = 2
where id = 1;

# 查看结果
select * from b;
```

![avatar](/Pictures/mysql/foreign2.png)

又或者删除 b 表后重新新建,并授予权限:
![avatar](/Pictures/mysql/foreign3.png)

删除 a 表 刚才的数据:

```sql
delete from a
where id = 2;

# 查看结果
select * from b;
```

此时 a 表的数据删除，b 表对应的数据也会删除:
![avatar](/Pictures/mysql/foreign4.png)

如果创建外键表时，没有指定 CONSTRAINT ，系统会自动生成(我这里为 b_ibfk_1):

```sql
# 查看CONSTRAINT
show create table b\G;
*************************** 1. row ***************************
       Table: b
Create Table: CREATE TABLE `b` (
  `id` int(11) DEFAULT NULL,
  `a_id` int(11) DEFAULT NULL,
  KEY `a_id_index` (`a_id`),
  CONSTRAINT `b_ibfk_1` FOREIGN KEY (`a_id`) REFERENCES `a` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
1 row in set (0.000 sec)
```

## VIEW (视图)

视图（view）是一种虚拟存在的表，是一个逻辑表，本身并不包含数据。作为一个 select 语句保存在数据字典中的。

基表：用来创建视图的表叫做基表。

性能：从数据库视图查询数据可能会很慢，特别是如果视图是基于其他视图创建的。

表依赖关系：将根据数据库的基础表创建一个视图。每当更改与其相关联的表的结构时，都必须更改视图。

**语法：**

> ```sql
> CREATE VIEW 视图名 (字段名) AS SELECT '值1' UNION SELECT '值2'...;
> # 基表视图
> CREATE VIEW 视图名 AS SELECT 字段名 FROM 表名...;
> ```

```sql
# 查看当前数据下的视图
show full tables where table_type = 'view';

# 创建视图
create view v (day) as select '1' union select '2';

# 查看视图
select * from v;
+-----+
| day |
+-----+
| 1   |
| 2   |
+-----+
# 删除视图
drop view v;

# 以 clone表 为基表,创建视图名为 v
create view v as select * from clone;

# 查看视图信息
show create view v\G;

# 嵌套 v视图 名为 vv,并且 id <= 2
create view vv as select * from v where id <= 2;

# 此时如果把 id 改为 3.注意这里 v 视图 和 clone 表的数据也会被更改
update vv set id = 3 where id = 1;

# 因为 vv视图有where id <= 2的限制, 所以不满足条件的值不显示
select * from vv;
+----+------+------------+
| id | name | date |
+----+------+------------+
|  2 | tz   | 2020-10-24 |
|  2 | tz1  | 2020-10-24 |
+----+------+------------+

# 对vv视图修改的值,在v视图的也被修改
select * from v;
+----+------+------------+
| id | name | date       |
+----+------+------------+
|  3 | tz   | 2020-10-24 |
|  2 | tz   | 2020-10-24 |
|  2 | tz1  | 2020-10-24 |
+----+------+------------+

# 和刚才的 vv视图 一样 这次 vvv视图 加入with check option;
create view vvv as select * from v where id <= 2 with check option;

# 此时对不满足条件的值,进行修改会报错
update vvv set id = 3 where id = 2;
ERROR 1369 (44000): CHECK OPTION failed `china`.`vvv`
```

可以看到 视图信息 多数为空 (**NULL**)

```sql
show table status like '名称'\G;
```

![avatar](/Pictures/mysql/view.png)
![avatar](/Pictures/mysql/view1.png)

## Stored Procedure and Function (自定义存储过程 和 函数)

**区别：**

| Procedure                | Function                  |
| ------------------------ | ------------------------- |
| 可以执行函数             | 不能执行存储过程          |
| 不能在 select 语句下执行 | 只能在 select 语句下执行  |
| 支持 Transactions(事务)  | 不支持 Transactions(事务) |
| 可以不有返回值           | 必须要有返回值            |
| 能返回多个值             | 只能返回一个值            |

**Procedure:**

注意:procedure 是和数据库相关链接的，如果数据库被删除，procedure 也会被删除

delimiter 是分隔符 默认是： `;`

```sql
delimiter #

CREATE PROCEDURE hello (IN s VARCHAR(50))
BEGIN
   SELECT CONCAT('Hello, ', s, '!');
END #

delimiter ;

# 执行
call hello('World');

# 查看所有存储过程
show procedure status;

# 查看 hello 存储过程
show create procedure hello\G;
```

**Function:**

```sql
CREATE FUNCTION hello (s VARCHAR(50))
   RETURNS VARCHAR(50) DETERMINISTIC
   RETURN CONCAT('Hello, ',s,'!');

# 执行
select hello('world');
select hello(name) from ca limit 1;

# 查看所有自定义函数
show function status;

# 查看 hello 函数
show create function hello\G;
```

### Stored Procedure (自定义存储过程）

**语法：**

> ```sql
> delimiter #
> create procedure 过程名([IN 参数名 数据类型,OUT 参数名 数据类型... ])
>
> begin
>
> sql语句;
>
> end;
> delimiter ;
> ```

先创建表:

```sql
drop table if exists foo;
create table foo
(
id int unique auto_increment,
val int not null default 0
);

# 插入一些数据
insert into foo (val) values (1);
insert into foo (val) values (2);
insert into foo (val) values (3);
insert into foo (val) values (4);
insert into foo (val) values (5);

# 查看结果
select * from foo;
```

![avatar](/Pictures/mysql/procedure.png)

循环 5 次， val 字段设置为 0 :

```sql
# 检测过程是否存在，如存在则删除
drop procedure if exists zero;

# 过程体要包含在delimiter里
delimiter #
-- 创建 zero 过程，并设置传递的变量为 int 类型的 v
-- 返回变量为 int 类型的 n
create procedure zero(IN v INT,OUT n INT)
begin

-- 变量i 代表 id 字段的值
declare i int default 1;
-- 变量s 代表循环次数
declare s int default 6;

    while i < s do
    -- 把 val 字段的值设置为 参数v
    update foo set val = v where id = i;
    set i = i + 1;
    end while;
    -- 设置返回变量 n 的值为 i
    set n = i;

end #
delimiter ;

# 设置 传递参数v 为0
set @v = 0;
# 执行 zero 过程
call zero(@v,@n);
# 查看 返回参数n 的值
select @n;

# 查看过程结果
select * from foo;
```

![avatar](/Pictures/mysql/procedure1.png)

循环 1000 次，val 字段插入随机数:

```sql
drop procedure if exists foo_rand;

delimiter #
create procedure foo_rand()
begin

-- 循环次数1000次
declare v_max int unsigned default 1000;
declare v_counter int unsigned default 0;

-- 删除 foo表 的数据
  truncate table foo;
  start transaction;
  while v_counter < v_max do
  -- 插入随机数据
    insert into foo (val) values ( floor(rand() * 65535) );
    set v_counter=v_counter+1;
  end while;
  commit;
end #

delimiter ;

call foo_rand();

select * from foo order by id;
```

![avatar](/Pictures/mysql/procedure2.png)

创建 10 个表

### ALTER

**语法：**

> ```sql
> ALTER TABLE table_name
> 动作 column_name 内容
> ```

| 动作   | 内容             |
| ------ | ---------------- |
| ADD    | 添加列           |
| DROP   | 删除列           |
| RENAME | 修改表名         |
| CHANGE | 修改列名         |
| MODIFY | 修改列的数据类型 |
| ENGINE | 修改存储引擎     |

```sql
# 重命名表
ALTER TABLE cnarea_2019 RENAME ca;

# 将列 name 改名为 mingzi ,类型改为 char(50)
ALTER TABLE ca change name mingzi char(50);

# 删除 id 列
ALTER TABLE ca DROP id;

# 添加 id 列
ALTER TABLE ca ADD id INT FIRST;

# 重命名 id 列为 number(bigint类型)
ALTER TABLE ca CHANGE id number BIGINT;

# 修改 city_code 列,为 char(50) 类型
ALTER TABLE ca MODIFY city_code char(50);
# 或者
ALTER TABLE ca CHANGE city_code city_code char(50);

# 修改 ca 表 id 列默认值1000
ALTER TABLE ca MODIFY id BIGINT NOT NULL DEFAULT 1000;
# 或者
ALTER TABLE ca ALTER id SET DEFAULT 1000;

# 添加主键，确保该主键默认不为空（NOT NULL）
ALTER TABLE ca MODIFY id INT NOT NULL;
ALTER TABLE ca ADD PRIMARY KEY (id);

# 删除主键
ALTER TABLE ca DROP PRIMARY KEY;

# 删除唯一性索引(unique)的 id 字段
ALTER TABLE ca DROP index id;

# 修改 ca 表的存储引擎
ALTER TABLE ca ENGINE = MYISAM;
```

<span id="index"></span>

## [Multiple-Column Indexes (多行索引)](https://dev.mysql.com/doc/refman/8.0/en/multiple-column-indexes.html)

- Multiple-Column Indexes 最多可以**16**个列

- 如果 col1 和 col2 上有单独的单列索引，那么优化器将尝试使用[索引合并优化](https://dev.mysql.com/doc/refman/8.0/en/index-merge-optimization.html)

- 如果表有多列索引，则索引搜索只包含最左边的列。例如，索引 3 列(col1、col2、col3)，那么在(col1)、(col1、col2)和(col1、col2、col3)上就有索引搜索功能, 而(col2) and (col2, col3)是没有索引搜索的。

**语法：**

> ```sql
> CREATE INDEX 索引名
> ON 表名 (列1, 列2,...)
> # 降序
> CREATE INDEX 索引名
> ON 表名 (列1, 列2,... DESC)
> ```

```sql
# 显示索引
SHOW INDEX FROM ca;

# 添加索引id
CREATE INDEX name ON ca (id);

# 添加索引id,name
CREATE INDEX name ON ca (id,name);

# 添加索引降序id,name
CREATE INDEX name ON ca (id,name desc);

# 删除索引
DROP INDEX name ON ca;

# 添加索引id
ALTER table ca ADD INDEX name(id);
# 删除索引
ALTER table ca DROP INDEX name;
```

[handler_read:](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html#statvar_Handler_read_next)

```sql
# 清空缓存和状态
flush tables;
flush status;
# 清空后全是0
SHOW STATUS LIKE 'handler_read%';
```

![avatar](/Pictures/mysql/handler_read.png)

此时 name 字段,还没有索引:

```sql
select name from cnarea_2019_innodb;
SHOW STATUS LIKE 'handler_read%';
```

![avatar](/Pictures/mysql/handler_read1.png)
建立索引后在查询:

```sql
create index idx_name on cnarea_2019_innodb(name);
flush tables;
flush status;

select name from cnarea_2019_innodb;
SHOW STATUS LIKE 'handler_read%';
```

![avatar](/Pictures/mysql/handler_read2.png)

### B-tree

```sql
应该这样:
SELECT * FROM tbl_name WHERE key_col LIKE 'Patrick%';

不应该这样:
SELECT * FROM tbl_name WHERE key_col LIKE '%Patrick%';
```

### explain

- [全网最全 | MySQL EXPLAIN 完全解读](https://mp.weixin.qq.com/s?src=11&timestamp=1604040197&ver=2675&signature=Z8aIcWG-fnvP28oOueCvgCBE5BteW5cun0c3SfGtBHKG3cjAB9*aQ4*PZ6CgY81iT5TxRdWYHz7k5RsvNWSyXZupOOJ7YlcRUFlz8i7QVftJFbRrccNIi5o1daoS90Hk&new=1)

### 索引速度测试

```sql
# 测试效果
select name,pinyin,short_name,merger_name from  cnarea_2019;
```

> **结果:** `783562 rows in set (0.264 sec)`

```sql
# 添加索引
CREATE INDEX short_name_index ON cnarea_2019 (short_name);
CREATE INDEX name_index ON cnarea_2019 (name);
CREATE INDEX merger_name_index ON cnarea_2019 (merger_name);
```

> **结果:** `783562 rows in set (0.223 sec)`

## DCL

DCL (语句主要是管理数据库权限的时候使用)

### 帮助文档

```sql
# 按照层次查询
? contents;
? Account Management
# 数据类型
? Data Types
? VARCHAR
? SHOW
```

### 用户权限设置

> ```sql
> # 创建用户
> CREATE USER 'username'@'host' IDENTIFIED BY 'password';
>
> # 授权
> GRANT privileges ON databasename.tablename TO 'username'@'host'
>
> # 撤销权限
> REVOKE privileges ON databasename.tablename FROM 'username'@'host'
> ```

[更多用户权限详情](https://blog.csdn.net/lu1171901273/article/details/91635417?utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~all~sobaiduend~default-1-91635417.nonecase&utm_term=mysql%20%E7%BB%99%E7%94%A8%E6%88%B7%E5%88%86%E9%85%8D%E8%A7%86%E5%9B%BE%E6%9D%83%E9%99%90&spm=1000.2123.3001.4430)

create and grant (创建和授权):

```sql
# 查看所有用户
SELECT user,host FROM mysql.user;

# 详细查看所有用户
SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';')
AS query FROM mysql.user;

# 创建用户名为tz的用户
create user 'tz'@'127.0.0.1'
identified by 'YouPassword';

# 当前用户修改密码的命令
SET PASSWORD = PASSWORD("NewPassword");

# 修改密码
SET PASSWORD FOR 'tz'@'127.0.0.1' = PASSWORD('NewPassword');

# grant (授权)
# 只能 select china.cnarea_2019
grant select on china.cnarea_2019 to 'tz'@'127.0.0.1';

# 添加 insert 和 china所有表的权限
grant select,insert on china.* to 'tz'@'127.0.0.1';

# 添加所有数据库和表的权限
grant all PRIVILEGES on *.* to 'tz'@'127.0.0.1';

# 允许tz 用户授权于别的用户
grant all on *.* to 'tz'@'127.0.0.1' with grant option;

# 刷新权限
flush privileges;

# 查看用户权限
show grants for 'tz'@'127.0.0.1';

+-------------------------------------------------------------------+
| Grants for tz@127.0.0.1                                           |
+-------------------------------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO `tz`@`127.0.0.1` WITH GRANT OPTION   |
| GRANT SELECT, INSERT ON `china`.* TO `tz`@`127.0.0.1`              |
| GRANT SELECT ON `china`.`cnarea_2019` TO `tz`@`127.0.0.1`         |
+-------------------------------------------------------------------+
```

#### revoke (撤销):

```sql
revoke all privileges on *.* from 'tz'@'127.0.0.1';
revoke grant option on *.* from 'tz'@'127.0.0.1';

+-----------------------------------------------------------+
| Grants for tz@127.0.0.1                                   |
+-----------------------------------------------------------+
| GRANT USAGE ON *.* TO `tz`@`127.0.0.1`                    |
| GRANT SELECT, INSERT ON `china`.* TO `tz`@`127.0.0.1`     |
| GRANT SELECT ON `china`.`cnarea_2019` TO `tz`@`127.0.0.1` |
+-----------------------------------------------------------+

revoke select, insert on china.* from 'tz'@'127.0.0.1';

+-----------------------------------------------------------+
| Grants for tz@127.0.0.1                                   |
+-----------------------------------------------------------+
| GRANT USAGE ON *.* TO `tz`@`127.0.0.1`                    |
| GRANT SELECT ON `china`.`cnarea_2019` TO `tz`@`127.0.0.1` |
+-----------------------------------------------------------+

revoke select on china.cnarea_2019 from 'tz'@'127.0.0.1';

+----------------------------------------+
| Grants for tz@127.0.0.1                |
+----------------------------------------+
| GRANT USAGE ON *.* TO `tz`@`127.0.0.1` |
+----------------------------------------+

# 刷新权限
FLUSH PRIVILEGES;

# 删除用户
drop user 'tz'@'127.0.0.1';
```

<span id="user"></span>

#### 授予权限,远程登陆

**语法：**

> ```sql
> GRANT PRIVILEGES ON 数据库名.表名 TO '用户名'@'IP地址' IDENTIFIED BY 'YouPassword' WITH GRANT OPTION;
> ```

```sql

# 允许root从'192.168.100.208'主机china库下的所有表(WITH GRANT OPTION表示有修改权限的权限）
grant all PRIVILEGES on china.* to
'root'@'192.168.100.208'
identified by 'YouPassword'
WITH GRANT OPTION;

# 允许root从'192.168.100.208'主机china库下的cnarea_2019表
grant all PRIVILEGES on china.cnarea_2019 to
'root'@'%'
identified by 'YouPassword'
WITH GRANT OPTION;

# 允许所有用户连接所有库下的所有表(%:表示通配符)
grant all PRIVILEGES on *.* to
'root'@'%' identified by 'YouPassword'
WITH GRANT OPTION;

# 刷新权限
FLUSH PRIVILEGES;
```

```sh
# 记得在服务器里关闭防火墙
iptables -F

# 连接远程数据库(我这里是192.168.100.208)
mysql -u root -p 'YouPassword' -h 192.168.100.208
```

### 配置(varibles)操作

- 注意`variables` 的修改，永久保存要写入`/etc/my.cnf`
  [详细配置说明](https://github.com/jaywcjlove/mysql-tutorial/blob/master/chapter2/2.6.md#%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E5%86%85%E5%AE%B9)

```sql
# 查看配置(变量)
show variables;
# 查看字段前面包含max_connect的配置(通配符%)
show variables like 'max_connect%';

show variables like 'max_connect%';
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| max_connect_errors | 100   |
| max_connections    | 151   |
+--------------------+-------+
2 rows in set (0.01 sec)

# 设置自定义变量(重启后失效)
set @val = 1;
# 查看刚才的变量
select @val;

# 修改会话变量,该值将在会话内保持有效(重启后失效)
set session sql_mode = 'TRADITIONAL';

# 通过 select 查看
select @@session.sql_mode;
# 或者
show variables like 'sql_mode';

# 修改全局变量, 仅影响更改后连接的客户端的相应会话值.(重启后失效)
set global max_connect_errors=1000;

# 通过 select 查看
select @@global.max_connect_errors;
# 或者
show variables like 'max_connect_errors';

# 永久保存,要写入/etc/my.cnf
echo "max_connect_errors=1000" >> /etc/my.cnf
```

[mysql 的 sql_mode 合理设置](http://xstarcd.github.io/wiki/MySQL/MySQL-sql-mode.html)

## mysqldump 备份和恢复

> [建议使用更快更强大的 mydumper](#mydumper)

- 先创建一个数据表

```sql
use china;
create table tz (`id` int (8), `name` varchar(50), `date` DATE);
insert into tz (id,name,date) values (1,'tz','2020-10-24');
```

- 1.使用 `mysqlimport` 导入(不推荐)

  > 因为 `mysqlimport` 是把数据**导入新增**进去表里，而非恢复

```sql
# 导出tz表. 注意：路径要加''
SELECT * FROM tz INTO OUTFILE '/tmp/tz.txt';

# 删除表和表的数据
drop table tz;

# 导入前要创建一个新的表
create table tz (`id` int (8), `name` varchar(50), `date` DATE);
```

回到终端使用 `mysqlimport` 进行数据导入:

```sh
mysqlimport china /tmp/tz.txt
```

导出 tz 表 `csv` 格式,但**不能使用**`mysqlimport` 进行导入

```sql
SELECT * FROM tz INTO OUTFILE '/tmp/tz.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';
```

- 2.使用 `mysqldump` 备份

```sql
# 备份 china 数据库

mysqldump -uroot -pYouPassward china > china.sql

# 备份 china 数据库里的 tz 表

mysqldump -uroot -pYouPassward china tz > tz-tables.sql

# 备份所有数据库

mysqldump -uroot -pYouPassward --all-databases > all.sql

# -d 只备份所有数据库表结构(不包含表数据)

mysqldump -uroot -pYouPassward -d --all-databases > mysqlbak-structure.sql

# 恢复到 china 数据库

mysql -uroot -pYouPassward china < china.sql

# 恢复所有数据库

mysql -uroot -pYouPassward < all.sql
```

### 主从同步 (Master Slave Replication )

#### 主服务器配置

- `/etc/my.cnf` 文件配置

```sh
[mysqld]
server-id=129            # 默认是 1 ,这个数字必须是唯一的
log_bin=centos7

binlog-do-db=tz          # 同步指定库tz
binlog-ignore-db=tzblock # 忽略指定库tzblock
```

```sh
# 备份

# 进入数据库后给数据库加上一把锁，阻止对数据库进行任何的写操作
flush tables with read lock;

# 备份tz数据库
mysqldump -uroot -pYouPassward tz > /root/tz.sql

# 对数据库解锁，恢复对主数据库的操作
unlock tables;
```

```sql
# 启用slave权限
grant PRIVILEGES SLAVE on *.* to  'root'@'%';

# 或者启用所有权限
grant all on *.* to  'root'@'%';
```

查看主服务状态

```sql
# 日志目录 /var/lib/mysql/centos7.000001

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
```

#### 从服务器配置

- `/etc/my.cnf` 文件配置

```sh
[mysqld]
server-id=128

replicate-do-db = tz     #只同步abc库
slave-skip-errors = all   #忽略因复制出现的所有错误
```

```sh
# 复制主服务器的tz.sql备份文件
scp -r "root@192.168.100.208:/root/tz.sql" /tmp/
# 创建tz数据库
mysql -uroot -p
```

恢复 tz 数据库

```sql
# 先创建 tz 数据库
create database tz;

# 导入
mysql -uroot -p tz < /tmp/tz.sql

# 如果出现以下核对错误
ERROR 1273 (HY000) at line 47: Unknown collation: 'utf8mb4_0900_ai_ci'
# 通过修改编码修复
sed -i 's/utf8mb4_0900_ai_ci/utf8mb4_unicode_ci/g' /tmp/tz.sql
# 再次运行
mysql -uroot -p tz < /tmp/tz.sql
```

```sql
# 关闭同步
stop slave;

# 开启同步功能
CHANGE MASTER TO
MASTER_HOST = '192.168.100.208',
MASTER_USER = 'root',
MASTER_PASSWORD = 'YouPassword',
MASTER_LOG_FILE='centos7.000001',
MASTER_LOG_POS=156;

# 开启同步
start slave;
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

```sh
# 测试能不能连接主服务器
mysql -uroot -p -h 192.168.100.208 -P3306
```

### docker 主从复制

[docker 安装 mysql 教程](#docker)

启动两个 mysql:

```sh
docker run -itd --name mysql-tz -p 3306:3306 -e MYSQL_ROOT_PASSWORD=YouPassword mysql

docker run -itd --name mysql-slave -p 3307:3306 -e MYSQL_ROOT_PASSWORD=YouPassword mysql
```

进入 docker 修改 `my.cnf` 配置文件

```sh
docker exec -it mysql-tz /bin/bash
echo "server-id=1" >> /etc/mysql/my.cnf
echo "log-bin=bin.log" >> /etc/mysql/my.cnf
echo "bind-address=0.0.0.0" >> /etc/mysql/my.cnf

docker exec -it mysql-slave /bin/bash
echo "server-id=2" >> /etc/mysql/my.cnf
echo "log-bin=bin.log" >> /etc/mysql/my.cnf

退出docker后，重启mysql
docker container restart mysql-slave
docker container restart mysql-tz
```

进入 master(主服务器) 创建 backup 用户，并添加权限:

```sql
mysql -uroot -pYouPassword -h 127.0.0.1 -P3306

create user 'backup'@'%' identified by 'YouPassword';
GRANT replication slave ON *.* TO 'backup'@'%';
FLUSH PRIVILEGES;
```

查看 master 的 ip:

```sh
sudo docker exec -it mysql-tz cat '/etc/hosts'
```

我这里为 `172.17.0.2`

![avatar](/Pictures/mysql/docker-replication.png)

开启 **slave**:

```sql
# MASTER_HOST 填刚才查询的ip

mysql -uroot -pYouPassword -h 127.0.0.1 -P3307
CHANGE MASTER TO
MASTER_HOST = '172.17.0.2',
MASTER_USER = 'backup',
MASTER_PASSWORD = 'YouPassword';
start slave;
```

docker 主从复制测试:

- 左为 3307 从服务器
- 右为 3306 主服务器

在主服务器**新建数据库 tz,hello 表**,并插入 1 条数据.可以看到从服务器可以 select hello 表;在主服务器删除 tz 数据库，从服务器也跟着删除.

![avatar](/Pictures/mysql/docker-replication.gif)

## 高效强大的 mysql 软件

- [MySQL 常用工具选型和建议](https://zhuanlan.zhihu.com/p/86846532)

### [mycli](https://github.com/dbcli/mycli)

- 更友好的 mysql 命令行
- 目前发现不能,修改和查看用户权限

```sql
mysql root@localhost:(none)> SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysq
                          -> l.user;
(1142, "SELECT command denied to user 'root'@'localhost' for table 'user'")
```

![avatar](/Pictures/mysql/mycli.png)

### [mitzasql](https://github.com/vladbalmos/mitzasql)

- 一个使用`vim`快捷键的 `mysql-tui`

![avatar](/Pictures/mysql/mysql-tui.png)
![avatar](/Pictures/mysql/mysql-tui1.png)

<span id="mydumper"></span>

### [mydumper](https://github.com/maxbube/mydumper)

Mydumper 是 MySQL 数据库服务器备份工具，它比 MySQL 自带的 mysqldump 快很多.[详细参数](https://linux.cn/article-5330-1.html)

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

![avatar](/Pictures/mysql/du.png)

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

![avatar](/Pictures/mysql/du1.png)

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

### [percona-toolkit 运维监控工具](https://www.percona.com/doc/percona-toolkit/LATEST/index.html)

[percona-toolkit 工具的使用](https://www.cnblogs.com/chenpingzhao/p/4850420.html)

> centos7 安装:
>
> ```sh
> # 安装依赖
> yum install perl-DBI perl-DBD-MySQL perl-Time-HiRes perl-IO-Socket-SSL
> # 需要科学上网
> wget https://www.percona.com/downloads/percona-toolkit/3.2.1/binary/redhat/7/x86_64/percona-toolkit-3.2.1-1.el7.x86_64.rpm
> ```

```sh
# 分析slow log
pt-query-digest  --type=slowlog /var/log/mysql/mysql_slow.log > /tmp/pt_slow.log
cat /tmp/pt_slow.log

# 分析general log
pt-query-digest  --type=genlog /var/log/mysql/mysql_general.log > /tmp/pt_general.log
cat /tmp/pt_general.log
```

### [innotop](https://github.com/innotop/innotop)

- [MySQL 监控-innotop](https://www.jianshu.com/p/b8508fe10b8e)

这是在用 `mysqlslap` 进行压力测试下的监控

![avatar](/Pictures/mysql/innotop.png)
![avatar](/Pictures/mysql/mysqlslap.png)

### [sysbench](https://github.com/akopytov/sysbench)

- [sysbench 安装、使用和测试](https://www.cnblogs.com/zhoujinyi/archive/2013/04/19/3029134.html)

<span id="install"></span>

### [dbatool](https://github.com/xiepaup/dbatools)

监控以及查询工具

![avatar](/Pictures/mysql/dbatools.png)

### undrop-for-innodb(\*数据恢复)

安装
[MySQL · 数据恢复 · undrop-for-innodb](http://mysql.taobao.org/monthly/2017/11/01/)
[undrop-for-innodb 实测（一）-- 表结构恢复](https://yq.aliyun.com/articles/684377)

```sh
git clone https://github.com/twindb/undrop-for-innodb.git
cd undrop-for-innodb
sudo make install
```

```sh
# 注意：目前还是在undrop-for-innodb
# 生成pages-ibdata1目录,目录下按照每个页为一个文件
stream_parser -f /var/lib/mysql/ibdata1
mkdir -p dumps/default

sudo mysql -uroot -p -e "create database dictionary"
sudo mysql -uroot -p dictionary < dictionary/*.sql

sudo ./sys_parser -uroot -p -d dictionary sakila/actor
```

# 安装 MySql

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

<span id="docker"></span>

## [docker 安装](https://www.runoob.com/docker/docker-install-mysql.html)

```sh
# 下载镜像
docker pull mysql:latest

# 查看本地镜像
docker images

# -p端口映射
docker run -itd --name mysql-tz -p 3306:3306 -e MYSQL_ROOT_PASSWORD=YouPassword mysql

# 查看运行镜像
docker ps

#进入容器
docker exec -it mysql-tz bash

#登录 mysql
mysql -uroot -pYouPassword -h 127.0.0.1 -P3306
```

## 常见错误

- 日志目录`/var/lib/mysql`

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

### ERROR 2013 (HY000): Lost connection to MySQL server during query(导致无法 stop slave;)

**修复:**

```sql
[mysqld]
skip-name-resolve
```

### ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (111)(连接不了数据库)

- `systemctl restart mysql` 重启配置没问题
- `ps aux | grep mysql` 进程存在
- 内存不足

### ERROR 1075 (42000): Incorrect table definition; there can be only one auto column and it must be defined

```sql
# 要先删除 auto_incrment 属性,才能删除主健(我这里的主健是 id 字段)
alter table test modify id int(10);
alter table test drop primary key;
```

## Storage Engine (存储引擎)

[mysql 索引结构是在存储引擎层面实现的](http://www.ruanyifeng.com/blog/2014/07/database_implementation.html)

修改默认存储引擎 `engine`:

> ```sh
> [mysqld]
> default_storage_engine=INNODB
> ```

- MyIsam: 速度更快,因为 MyISAM 内部维护了一个计数器，可以直接调取,使用 b+树索引

  > 表锁(对表的锁)
  >
  > 不支持事务
  >
  > 缓冲池只缓存索引文件，不缓冲数据文件
  >
  > 由 MYD 和 MYI 文件组成，MYD 用来存放数据文件，MYI 用来存放索引文件

- InnoDB: 事务更好,使用 b+树索引

  > 行锁(对行的锁),表锁(对表的锁)
  >
  > 支持事务
  >
  > 自动灾难恢复

```sql
# 查看支持的存储引擎
show engines;

# 查看目前使用的存储引擎
show variables like 'storage_engine';

# 查看 cnarea_2019表 的存储引擎
show create table cnarea_2019\G;

# 修改ca表的存储引擎为MYISAM
ALTER TABLE ca ENGINE = MYISAM;
```

### 锁

Mysql 锁分为**共享锁**和**排他锁**，也叫做 **读锁** 和 **写锁**:

- 写锁: 是排他的，它会阻塞其他的写锁和读锁。从颗粒度来区分，可以分为 **表锁** 和 **行锁** 两种。

- 表锁: 会锁定整张表并且阻塞其他用户对该表的所有读写操作，比如 alter 修改表结构的时候会锁表。

> Innodb 默认使用的是行锁。而行锁是基于索引的，因此要想加上行锁，在加锁时必须命中索引，否则将使用表锁。

**行锁分为：**

- Pessimistic Locking(悲观锁): 具有**排他性**,数据处理过程中,数据处于锁定状态

- Optimistic Locking(乐观锁): 记录 commit 的版本号(version)，对数据修改会改变 version,通过对比 **修改前后 的 version 是否一致**来确定是哪个事务的 commit

[详情](https://zhuanlan.zhihu.com/p/222958908)

> ```sql
> # 加锁
> LOCK TABLES 表1 WRITE, 表2 READ, ...;
>
> # 排他锁(写锁)
> LOCK TABLES 表1 WRITE;
>
> # 共享锁(读锁)
> LOCK TABLES 表1 READ;
> ```

> ```sql
> # 解锁
> UNLOCK TABLES;
> ```

> ```sql
> # 通过队列查看是否有 lock
> show processlist;
> ```

行锁创建一个表进行实验：

```sql
CREATE TABLE locking(
id int (8) NOT NULL UNIQUE,
name varchar(50),
date DATE);

insert into locking (id,name,date) values
(1,'tz1','2020-10-24'),
(10,'tz2','2020-10-24'),
(100,'tz3','2020-10-24');
```

悲观锁:

```sql
# 事务a 在select 最后 加入 for update 悲观锁，锁整个表
select * from locking for update;

# 事务b 执行update时，会阻塞
update locking set id = 1 where id = 2;

# 事务a commit后，事务b update id = 1 执行成功
commit;
```

![avatar](/Pictures/mysql/innodb_lock1.gif)

```sql
# 事务a 加入where 从句，只锁对应的行(我这里是id = 1)
select * from locking where id = 1 for update;

# 事务b 对 update 不同的行 成功执行
update locking set id = 10 where id = 20;

# 事务b update id = 1时，会阻塞
update locking set id = 2 where id = 1;

# 事务a commit后，事务b update id = 1 执行成功
commit;
```

![avatar](/Pictures/mysql/innodb_lock2.gif)

**事务 a** 和 **事务 b** 插入相同的数据,**事务 a** 先 **事务 b** 插入。那么**事务 b** 会被阻塞，当事务 a `commit` 后

- 如果有唯一性索引或者主健那么 **事务 b** 会插入失败(幻读)

- 如果没有，那么将会出现相同的两条数据

**有唯一性索引或者主健:**

```sql
# 事务a 和 事务 b 插入同样的数据
insert into locking (id,name,date) value (1000,'tz4','2020-10-24');
```

![avatar](/Pictures/mysql/innodb_lock3.gif)

**没有索引:**

```sql
# 删除唯一性索引
alter table locking drop index id;

# 事务a 和 事务 b 插入同样的数据
insert into locking (id,name,date) value (1000,'tz4','2020-10-24');
```

![avatar](/Pictures/mysql/innodb_lock4.gif)

---

乐观锁:

修改包含：update,delete

事务 a: 修改数据为 2

```sql
begin
select * from locking;
update locking set id = 2 where id = 1;
commit;
select * from locking;
```

事务 b: 修改数据为 3

```sql
begin
select * from locking;
update locking set id = 3 where id = 1;
commit;
```

最后结果 2.

因为事务 a 比事务 b 先 commit,此时版本号改变，所以当事务 b 要 commit 时的版本号 与 事务 b 开始时的版本号不一致，提交失败。
![avatar](/Pictures/mysql/innodb_lock5.gif)

### MyISAM

在 Mysql 保存目录下:

- frm: 表格式

- MYD: 数据文件

- MYI: 索引文件

![avatar](/Pictures/mysql/myisam.png)

MyISAM 不支持行锁，在执行查询语句（SELECT、UPDATE、DELETE、INSERT 等）前，会自动给涉及的表加读锁，这个过程并不需要用户干预

当线程获得一个表的写锁后， 只有持有锁的线程可以对表进行更新操作。 其他线程的读、 写操作都会等待，直到锁被释放为止。

默认情况下，写锁比读锁具有更高的优先级：当一个锁释放时，这个锁会优先给写锁队列中等候的获取锁请求，然后再给读锁队列中等候的获取锁请求。

这也正是 MyISAM 表不太适合于有大量更新操作和查询操作应用的原因，因为，大量的更新操作会造成查询操作很难获得读锁，从而可能永远阻塞。

测试在循环 50 次 select 的过程中，MYISAM 的表的写入情况

```sql
# 创建存储过程，循环50次select

delimiter #
create procedure scn()
begin
declare i int default 1;
declare s int default 50;

while  i < s do
    select * from cnarea_2019;
    set i = i + 1;
end while;

end #
delimiter ;

# 执行scn
call scn();
```

打开另一个客户端,对 MyISAM 表修改数据:

```sql
show processlist;
update cnarea_2019 set name='test-lock' where id <11;
select name from cnarea_2019 where id < 11;
```

- 左边:修改数据的客户端
- 右边:执行 call scn();

左边在等待右边的锁,可以看到我停止 **scn()**后，立马修改成功

![avatar](/Pictures/mysql/myisam_lock.gif)

[跳转 innodb 同样的实验](#innodb_lock)

### [InnoDB](https://dev.mysql.com/doc/refman/8.0/en/innodb-storage-engine.html)

注意:在 MariaDB 10.3.7 以上的版本，InnoDB 版本不再与 MySQL 发布版本相关联
[InnoDB and XtraDB](https://mariadb.com/kb/en/innodb/)

在 Mysql 保存目录下:

- frm: 表格式

- ibd: 索引和数据文件

![avatar](/Pictures/mysql/innodb.png)
![avatar](/Pictures/mysql/innodb1.png)

行格式:

- Compact

- Redundant

![avatar](/Pictures/mysql/innodb2.png)

tablespace (表空间):

- segment (包括段)
- extent (区)
- page (页)

![avatar](/Pictures/mysql/innodb3.png)

InnoDB 采用`WAL`(Write-Ahead Logging). 先修改日志,再在修改数据页进 buffer(内存)。当等到有空闲线程、内存不足、Redo log 满了时再 Checkpoint(刷脏)。写 Redo log 是顺序写入，Checkpoint(刷脏)是随机写.

日志格式：

- redo log(重做日志) 物理日志:事务提交成功，数据页被修改后的值,就会被永久存储了.文件名`ib_logfile*`

- binlog 逻辑日志:事务提交成功，记录数据库所有更改操作. 不包括 select，show

![avatar](/Pictures/mysql/log.png)

redo log 参数:`innodb_flush_log_at_trx_commit`.在导入数据时可以临时调整为 `0` 提高性能.

| 参数 | 操作                                       | 安全性               |
| ---- | ------------------------------------------ | -------------------- |
| 0    | log buffer 每 1 秒写日志，写数据           | 最快，有数据丢失风险 |
| 1    | log buffer commit 后,写日志，写数据        | 最安全               |
| 2    | log buffer commit 后,写日志，每 1 秒写数据 | 较快，有数据丢失风险 |

binlog 参数:`sync_binlog`.

| 参数 | 操作                                                   |
| ---- | ------------------------------------------------------ |
| 0    | 由参数`binlog_group_commit_sync_delay`指定延迟写入日志 |
| n    | 延迟等于 commit n 次后,再写入日志                      |

最安全:把`innodb_flush_log_at_trx_commit` 和 `sync_binlog` 设置为 `1`

查看日志缓冲区大小，更大的日志缓冲区可以节省磁盘 `I / O`:

```sql
# 默认是 16M
show variables like 'innodb_log_buffer_size';
+------------------------+----------+
| Variable_name          | Value    |
+------------------------+----------+
| innodb_log_buffer_size | 16777216 |
+------------------------+----------+

# 查看 InnoDB 版本:
SHOW VARIABLES LIKE "innodb_version";
```

#### REDO LOG (重做日志)

- redo log 以 **块(block)** 为单位进行存储的，每个块的大小为 **512** Bytes
- redo log 文件的组合大小 = (`innodb_log_file_size` \* `innodb_log_files_in_group`)

```sql
# redo log文件大小
show variables like 'innodb_log_file_size';
+----------------------+-----------+
| Variable_name        | Value     |
+----------------------+-----------+
| innodb_log_file_size | 100663296 |
+----------------------+-----------+

# redo log文件数量
show variables like 'innodb_log_files_in_group';
+---------------------------+-------+
| Variable_name             | Value |
+---------------------------+-------+
| innodb_log_files_in_group | 1     |
```

#### UNDO LOG

undo log: 系统崩溃时，没 COMMIT 的事务 ，就需要借助 undo log 来进行回滚至，事务开始前的状态。

<span id="transaction"></span>

#### TRANSACTION (事务)

事务的基本要素（ACID）

- 原子性：Atomicity，整个数据库事务是不可分割的工作单位(undo log 提供)

- 一致性：Consistency，事务将数据库从一种状态转变为下一种一致的状态

- 隔离性：Isolation，每个读写事务的对象对其他事务的操作对象能相互分离(mvcc 提供),解决幻读问题(事务的两次查询的结果不一样)

- 持久性：Durability，事务一旦提交，其结果是永久性的

---

- `BEGIN` 开始一个事务
- `ROLLBACK` 事务回滚
- `COMMIT` 事务确认

```sql
# 创建表tz
create table tz (`id` int (8), `name` varchar(50), `date` DATE);

# 开始事务
begin

# 插入数据
insert into tz (id,name,date) values (1,'tz','2020-10-24');

# 回滚到开始事务之前(rollback 和 commit 只能选一个)
rollback;
# 如果出现waring,表示该表的存储引擎不支持事务(不是innodb)
Query OK, 0 rows affected, 1 warning (0.00 sec)

# 如果不回滚，使用commit确认这次事务的修改
commit;
```

如果有两个会话,一个开启了事务,修改了数据.另一个会话同步数据要执行 `flush table 表名`

```sql
# 把 clone表 存放在缓冲区里的修改操作写入磁盘
flush table clone
```

![avatar](/Pictures/mysql/flush.png)

`flush table clone`后, `select` 数据同步
![avatar](/Pictures/mysql/flush1.png)

---

- `SAVEPOINT savepoint_name;` 声明一个事务保存点
- `ROLLBACK TO savepoint_name;` 回滚到事务保存点,但不会终止该事务
- `RELEASE SAVEPOINT savepoint_name;` // 删除指定保留点

```sql
# 创建数据库
create table tz (`id` int (8), `name` varchar(50), `date` DATE);

# 声明一个名叫 abc 的事务保存点
savepoint abc;

# 插入数据
insert into tz (id,name,date) values (1,'tz','2020-10-24');

# 回滚到 abc 事务保存点
rollback to abc;
```

#### autocommit

`autocommit = 1` 对表的所有修改将立即生效

`autocommit = 0` 则必须使用 COMMIT 来提交事务，或使用 ROLLBACK 来回滚撤销事务

- 1.如果 InnoDB 表有大量的修改操作，应设置 `autocommit = 0` 因为 `ROLLBACK` 操作会浪费大量的 I/O

> **注意：**
>
> - 不要长时间打开事务会话，适当的时候要执行 COMMIT（完成更改）或 ROLLBACK（回滚撤消更改）
> - ROLLBACK 这是一个相对昂贵的操作 请避免对大量行进行更改，然后回滚这些更改。
>
> ```sql
> [mysqld]
> autocommit = 0
> ```

- 2.如果只是查询表,没有大量的修改，应设置 `autocommit = 1`

#### 线程

- Master Thread 负责将缓冲池中的数据异步刷新到磁盘,包括脏页的刷新(最高的线程优先)

#### 锁

**死锁：**
![avatar](/Pictures/mysql/innodb_lock.png)

事务 A 在等待事务 B 释放 id=2 的行锁，而事务 B 在等待事务 A 释放 id=1 的行锁。互相等待对方的资源释放，就进入了死锁状态。当出现死锁以后，有两种策略：

- 一：进入等待，直到超时。超时时间参数 `innodb_lock_wait_timeout`

- 二：发起死锁检测，发现死锁后，主动回滚死锁链条中的某一个事务，让其他事务得以继续执行。将参数 `innodb_deadlock_detect` 设置为 `on`。但是它有额外负担的。每当一个事务被锁的时候，就要看看它所依赖的线程有没有被别人锁住，如此循环，最后判断是否出现了循环等待，也就是死锁

MVCC(多版本并发控制): 实际上就是保存了数据在某个时间节点的快照

<span id="innodb_lock"></span>

```sql
# 把 cnarea_2019表 改为innodb 引擎
alter table cnarea_2019 rename cnarea_2019_innodb;
alter table cnarea_2019_innodb engine = innodb;
```

测试在循环 50 次 select 的过程中，innodb 的表的写入情况

```sql
# 创建存储过程，循环50次select
delimiter #
create procedure scn2()
begin
declare i int default 1;
declare s int default 50;

while  i < s do
    select * from cnarea_2019_innodb;
    set i = i + 1;
end while;

end #
delimiter ;

# 执行scn2
call scn2();
```

打开另一个客户端,对 innodb 表修改数据:

```sql
update cnarea_2019_innodb
set name='test-lock' where id < 11;

select name from cnarea_2019_innodb where id < 11;
```

- 左边:修改数据的客户端
- 右边:执行 call scn2();

修改数据后左边**commit**，右边也**commit**后，数据同步

![avatar](/Pictures/mysql/innodb_lock.gif)

### dictionary(字典)

#### informantion_schema

- row_format(行格式)是 `redundant` ,存储在 `ibdata1`, `ibdata2` 文件

- 记录 `innodb` 核心的对象信息，比如表、索引、字段等

- 表一般是大写

**informantion_schema** 的表一般有多种 **engine**(存储引擎):

- **Memory**(内存)
  ![avatar](/Pictures/mysql/dictionary.png)
- **MariaDB** 数据库: **Aria**(类似 MyISAM)
  ![avatar](/Pictures/mysql/dictionary1.png)
- **Mysql** 数据库: **Innodb**
  ![avatar](/Pictures/mysql/dictionary2.png)

```sql
# 查看innoddb字典
use information_schema;
show tables like '%INNODB_SYS%';
+------------------------------+
| Tables_in_information_schema |
+------------------------------+
| INNODB_SYS_DATAFILES         |
| INNODB_SYS_TABLESTATS        |
| INNODB_SYS_FIELDS            |
| INNODB_SYS_FOREIGN_COLS      |
| INNODB_SYS_FOREIGN           |
| INNODB_SYS_TABLES            |
| INNODB_SYS_COLUMNS           |
| INNODB_SYS_TABLESPACES       |
| INNODB_SYS_VIRTUAL           |
| INNODB_SYS_INDEXES           |
| INNODB_SYS_SEMAPHORE_WAITS   |
+------------------------------+
```

查看使用 innodb 存储的表:

```sql
select * from INNODB_SYS_TABLES;
```

![avatar](/Pictures/mysql/dictionary3.png)

**InnoDB Buffer Pool** 储数据和索引,减少磁盘 I/O,是一种特殊的 mitpoint LRU 算法
[查看 INNODB_BUFFER 表](https://mariadb.com/kb/en/information-schema-innodb_buffer_pool_stats-table/)

```sql
select * from INNODB_BUFFER
# 或者 隔几秒就会有变化
show global status like '%buffer%';

# innodb 页是16k

# 一共 8057页
POOL_SIZE: 8057

# 空闲页
FREE_BUFFERS: 6024

# 已使用页
DATABASE_PAGES: 2033
```

![avatar](/Pictures/mysql/dictionary5.png)

**innodb_buffer_pool_size** 越大，初始化时间就越长

```sql
show variables like 'innodb%buffer%';
```

![avatar](/Pictures/mysql/dictionary6.png)

#### performance_schema

独立的内存存储引擎:

![avatar](/Pictures/mysql/dictionary4.png)

## 极限值测试
看看一个表最多是不是1017列:

```sh
# 通过脚本快速生成1017.sql
echo 'drop table if exists test_1017;' > /tmp/1017.sql

echo 'CREATE TABLE test_1017(' >> /tmp/1017.sql

for i in $(seq 1 1016);do
    echo "id_$i int," >> /tmp/1017.sql
done
echo "id_1017 int" >> /tmp/1017.sql

echo ");" >> /tmp/1017.sql

# 执行
sudo mysql -uroot -pYouPassword YouDatabase < /tmp/1017.sql
```
![avatar](/Pictures/mysql/1017.png)

改为1018:
```sh
# 通过脚本快速生成1018.sql
echo 'drop table if exists test_1018;' > /tmp/1018.sql

echo 'CREATE TABLE test_1018(' >> /tmp/1018.sql

for i in $(seq 1 1017);do
    echo "id_$i int," >> /tmp/1018.sql
done
echo "id_1018 int" >> /tmp/1018.sql

echo ");" >> /tmp/1018.sql

# 执行
sudo mysql -uroot -pYouPassword YouDatabase < /tmp/1018.sql
```
![avatar](/Pictures/mysql/1018.png)

## 日志

[关于日志](/mysql-log.md)

# reference

- [厉害了，3 万字的 MySQL 精华总结 + 面试 100 问！](https://mp.weixin.qq.com/s?src=11&timestamp=1603207279&ver=2656&signature=PlP1Ta3EiPbja*mclBpkiUWyCM93jx7G0DnE4LwwlzEvW-Fd9hxgIGq1*5ctVid5AZTssRaeDRSKRPlOGOXJfLcS4VUlru*NYhh4BrhZU4k91nsfqzJueeX8kEptSmfc&new=1)
- [21 分钟 MySQL 基础入门](https://github.com/jaywcjlove/mysql-tutorial/blob/master/21-minutes-MySQL-basic-entry.md#%E5%A2%9E%E5%88%A0%E6%94%B9%E6%9F%A5)
- [数据库的最简单实现](http://www.ruanyifeng.com/blog/2014/07/database_implementation.html)
- [阿里规定超过三张表禁止 join，为啥？](https://zhuanlan.zhihu.com/p/158866182)
- [图解 SQL 里的各种 JOIN](https://zhuanlan.zhihu.com/p/29234064)
- [MySQL 锁详解](https://blog.csdn.net/qq_40378034/article/details/90904573)
- [mysql 存储过程详细教程](https://www.jianshu.com/p/7b2d74701ccd)
- [Difference between stored procedure and function in MySQL](https://medium.com/@singh.umesh30/difference-between-stored-procedure-and-function-in-mysql-52f845d70b05)
- [深入解析 MySQL 视图 VIEW](https://www.cnblogs.com/geaozhang/p/6792369.html)
- [MySQL 的 join 功能弱爆了？](https://zhuanlan.zhihu.com/p/286581170)
- [数据库表连接的简单解释](http://www.ruanyifeng.com/blog/2019/01/table-join.html?utm_source=tuicool&utm_medium=referral)
- [MySQL 资源大全中文版](https://github.com/jobbole/awesome-mysql-cn)
- [MySQL Tutorial](https://www.mysqltutorial.org/)

- [『浅入浅出』MySQL 和 InnoDB](https://draveness.me/mysql-innodb/)

# 优秀文章

- [MySQL 入门教程](https://github.com/jaywcjlove/mysql-tutorial)
- [sql 语句教程](https://www.1keydata.com/cn/sql/)
- [W3cSchool SQL 教程](https://www.w3school.com.cn/sql/index.asp)
- [MySQL 教程](https://www.runoob.com/mysql/mysql-tutorial.html)
- [138 张图带你 MySQL 入门](https://mp.weixin.qq.com/s?src=11&timestamp=1603417035&ver=2661&signature=Z-XNfjtR11GhHg29XAiBZ0RAiMHavvRavxB1ccysnXtAKChrVkXo*zx3DKFPSxDESZ9lwRM7C8-*yu1dEGmXwHgv1qe7V-WvwLUUQe7Nz7RUwEuJmLYqVRnOWtONHeL-&new=1)
- [CTO 要我把这份 MySQL 规范贴在工位上！](https://mp.weixin.qq.com/s?src=11&timestamp=1605361738&ver=2706&signature=wzhghhJTTx1Hy9Nn90P35u9hfG3eaeMGOvIoDoBGTECHdDQAmUuxFCVHAbuUqaN4*UYga9bGdXxX3f1G8kiYZ1yoA4tnocgi8GZoRe2TNQFkbbh1T2eSqyC6DcA9bTqF&new=1)

# 新闻资源

- [MariaDB KnowLedge](https://mariadb.com/kb/en/)

- [MySQL Server Blog](http://mysqlserverteam.com/)

- [DB-Engines](https://db-engines.com/en/)

- [数据库内核月报](http://mysql.taobao.org/monthly/)
  通过搜索引擎输入以下格式进行搜索(我这里搜索的是 binlog)

  > site:mysql.taobao.org binlog

# online tools

- [创建数据库的实体-关系图的工具 dbdiagram](https://dbdiagram.io)

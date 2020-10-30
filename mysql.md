<!-- vim-markdown-toc GFM -->

* [mysql SQL 命令入门教程](#mysql-sql-命令入门教程)
    * [基本命令](#基本命令)
        * [连接数据库](#连接数据库)
        * [常用 SQL 命令](#常用-sql-命令)
    * [下载数据库进行 SQL 语句 学习](#下载数据库进行-sql-语句-学习)
    * [DQL（查询）](#dql查询)
        * [SELECT](#select)
            * [where (条件选取)](#where-条件选取)
            * [order by (排序)](#order-by-排序)
            * [group by (分组)](#group-by-分组)
            * [regexp (正则表达式)](#regexp-正则表达式)
        * [UNION (多个表显示,以列为单位)](#union-多个表显示以列为单位)
        * [JOIN (多个表显示,以行为单位)](#join-多个表显示以行为单位)
        * [SQL FUNCTION](#sql-function)
            * [加密函数](#加密函数)
    * [DML (增删改操作)](#dml-增删改操作)
        * [CREATE(创建)](#create创建)
        * [insert](#insert)
            * [选取另一个表的数据,导入进新表](#选取另一个表的数据导入进新表)
        * [update](#update)
        * [delete](#delete)
            * [删除重复的数据](#删除重复的数据)
        * [CREATE PROCEDURE (自定义过程）](#create-procedure-自定义过程)
        * [ALTER](#alter)
        * [INDEX (索引)](#index-索引)
            * [索引速度测试](#索引速度测试)
        * [undrop-for-innodb](#undrop-for-innodb)
    * [DCL](#dcl)
        * [帮助文档](#帮助文档)
        * [用户权限设置](#用户权限设置)
            * [授予权限,远程登陆](#授予权限远程登陆)
        * [配置(varibles)操作](#配置varibles操作)
    * [mysqldump 备份和恢复](#mysqldump-备份和恢复)
        * [主从同步(Master/Slave)](#主从同步masterslave)
            * [主服务器配置](#主服务器配置)
            * [从服务器配置](#从服务器配置)
    * [高效强大的 mysql 软件](#高效强大的-mysql-软件)
        * [mycli](#mycli)
        * [mydumper](#mydumper)
        * [percona-toolkit 运维监控工具](#percona-toolkit-运维监控工具)
        * [innotop](#innotop)
    * [Centos 7 安装 MySQL](#centos-7-安装-mysql)
    * [常见错误](#常见错误)
        * [登录错误](#登录错误)
            * [修复](#修复)
                * [修改密码成功后](#修改密码成功后)
                * [如果出现以下报错(密码不满足策略安全)](#如果出现以下报错密码不满足策略安全)
                    * [修复](#修复-1)
        * [ERROR 2013 (HY000): Lost connection to MySQL server during query(导致无法 stop slave;)](#error-2013-hy000-lost-connection-to-mysql-server-during-query导致无法-stop-slave)
        * [ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (111)(连接不了数据库)](#error-2002-hy000-cant-connect-to-local-mysql-server-through-socket-varrunmysqldmysqldsock-111连接不了数据库)
    * [存储引擎](#存储引擎)
        * [锁](#锁)
    * [InnoDB](#innodb)
        * [REDO LOG (重做日志)](#redo-log-重做日志)
        * [TRANSACTION (事务)](#transaction-事务)
        * [autocommit](#autocommit)
        * [线程](#线程)
* [reference](#reference)
* [优秀教程](#优秀教程)
* [reference items](#reference-items)
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

[如需连接远程数据库 (可跳转至用户权限设置)](#user)

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
select * from cnarea_2019;

# 如果刚才将表改成 ca 名，就是以下命令
select * from ca;

# 从表 cnarea_2019 选取 name 列
select name from cnarea_2019;

# 从表 cnarea_2019 选取 name 和 id 列
select id,name from cnarea_2019;

# 选取所有列，但只显示前2行
select * from cnarea_2019 limit 2;

# 选取 level 列,用 distinct 过滤重复的数据
select distinct level from cnarea_2019;

# 选取所有列，但只显示100到70000行
select * from cnarea_2019 limit 100,70000;
```

以下 where 实现结果同上.有人说这样更快.但我自己测试过,没有太大差别

[测试结果](/mysql-problem.md)

```sql
select * from cnarea_2019 where id > 100 limit 70000;
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
select * from cnarea_2019 where id=1;

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
select * from cnarea_2019 where id < 10;

# 选取 10<=id<=30 的数据
select * from cnarea_2019 where id<=30 and id>=10;

# 选取 id 等于10 和 id等于20 的数据
select * from cnarea_2019 where id in (10,20);

# 选取 not null(非空) 和 id 小于 10 的数据
select * from ca where id is not null and id < 10;
```

#### order by (排序)

**语法:**

> ```sql
> SELECT 列名称 FROM 表名称 ORDER BY 列名称
> # or
> SELECT 列名称 FROM 表名称 WHERE 列名称 条件 ORDER BY 列名称
> ```

---

```sql
# 以 level 字段进行排序
select * from cnarea_2019 order by level;

# 选取 id<=10 ,以 level 字段进行排序
select * from cnarea_2019 where id<=10 order by level;

# desc 降序
select * from cnarea_2019 where id<=10 order by level desc;

# level 降序,再以 id 顺序显示
select * from cnarea_2019 where id<=10 order by level desc,id ASC;
```

#### group by (分组)

```sql
# 以 level 进行分组
select level from cnarea_2019 group by level;

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
select level from cnarea_2019 group by level order by level desc;

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
select name from cnarea_2019 where name regexp '^广州';

# 选取包含 '广州' 的name 字段
select name from cnarea_2019 where name regexp '.*广州';
```

### UNION (多个表显示,以列为单位)

**语法：**

> ```sql
> SELECT 列名称 FROM 表名称
> UNION
> SELECT 列名称 FROM 表名称
> ```

```sql
# 从 tz 表和 cnarea_2019 表,选取 id,name 列
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

# 选取列,不包含重复数据
select id from cnarea_2019 where id<10 union select id from tz where id<10;

# 选取列,包含重复数据(all)
select id from cnarea_2019 where id<10 union all select id from tz where id<10;

# 选取以 深圳市 和 北京市 开头的数据
select id,name from cnarea_2019 where name regexp '^深圳市' union select id,name from cnarea_2019 where name regexp '^北京市';
```

### JOIN (多个表显示,以行为单位)

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

**INNER JOIN**

```sql
# 选取 new 表的 id 和 date 字段以及 cnarea_2019 表的 name 字段
select new.id,new.date,cnarea_2019.name
from new,cnarea_2019 where cnarea_2019.id=new.id;

# 或者
select new.id,new.date,cnarea_2019.name
from new inner join cnarea_2019 on cnarea_2019.id=new.id;

+-----+------------+--------------------------+
| id  | date       | name                     |
+-----+------------+--------------------------+
|   1 | 2020-10-24 | 北京市                   |
|   2 | 2020-10-24 | 直辖区                   |
|   3 | 2020-10-24 | 东城区                   |
| 100 | 2020-10-24 | 安德路社区居委会         |
| 102 | 2020-10-24 | 七区社区居委会           |
| 103 | 2020-10-24 | 化工社区居委会           |
| 104 | 2020-10-24 | 安德里社区居委会         |
+-----+------------+--------------------------+
```

---

**LEFT JOIN**

```sql
# 左连接，以左表(new)id字段个数进行选取.所以结果与inner join一样
select new.id,new.date,cnarea_2019.name,cnarea_2019.pinyin from new left join cnarea_2019 on new.id=cnarea_2019.id limit 10;
+-----+------------+--------------------------+-----------+
| id  | date       | name                     | pinyin    |
+-----+------------+--------------------------+-----------+
|   1 | 2020-10-24 | 北京市                   | BeiJing   |
|   2 | 2020-10-24 | 直辖区                   | BeiJing   |
|   3 | 2020-10-24 | 东城区                   | DongCheng |
| 100 | 2020-10-24 | 安德路社区居委会         | AnDeLu    |
| 102 | 2020-10-24 | 七区社区居委会           | QiQu      |
| 103 | 2020-10-24 | 化工社区居委会           | HuaGong   |
| 104 | 2020-10-24 | 安德里社区居委会         | AnDeLi    |
+-----+------------+--------------------------+-----------+
```

---

**RIGHT JOIN**

```sql
# 右连接，以右表(cnarea_2019)id字段个数进行选取.因左表(new)没有右表数据多,所以id,date字段为null

select new.id,new.date,cnarea_2019.name,cnarea_2019.pinyin from new right join cnarea_2019 on new.id=cnarea_2019.id limit 10;
+------+------------+--------------------------+-------------+
| id   | date       | name                     | pinyin      |
+------+------------+--------------------------+-------------+
|    1 | 2020-10-24 | 北京市                   | BeiJing     |
|    2 | 2020-10-24 | 直辖区                   | BeiJing     |
|    3 | 2020-10-24 | 东城区                   | DongCheng   |
| NULL | NULL       | 东华门街道               | DongHuaMen  |
| NULL | NULL       | 多福巷社区居委会         | DuoFuXiang  |
| NULL | NULL       | 银闸社区居委会           | YinZha      |
| NULL | NULL       | 东厂社区居委会           | DongChang   |
| NULL | NULL       | 智德社区居委会           | ZhiDe       |
| NULL | NULL       | 南池子社区居委会         | NanChiZi    |
| NULL | NULL       | 黄图岗社区居委会         | HuangTuGang |
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
select level, count(1) as totals from cnarea_2019 group by level;

# 对不同的 level，选取 id 的平均值
select level,avg(id) from cnarea_2019 group by level;
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
select level,avg(id) from cnarea_2019 group by level having avg(id) > 400000;
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
  > - 一个表中可以有多个唯一性索引，但只能有一个主键。
  >
  > - 主键列不允许空值，而唯一性索引列允许空值。

```sql
# 创建 new 数据库设置 id 为主键,不能为空,自动增量
CREATE TABLE new(
`id` int (8) AUTO_INCREMENT,        # AUTO_INCREMENT 自动增量(每条新记录递增 1)
`name` varchar(50) NOT NULL UNIQUE, # NOT NULL 设置不能为空 # UNIQUE 设置唯一性索引
`date` DATE,
primary key (`id`))                 # 设置主健为 id 字段(列)
ENGINE=InnoDB DEFAULT CHARSET=utf8;

# 这里的int(8),varchar(50),括号里的数字表示的是最大显示宽度

# 查看 new 表里的字段
desc new;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| id    | int(8)      | NO   | PRI | NULL    | auto_increment |
| name  | varchar(50) | NO   | UNI | NULL    |                |
| date  | date        | YES  |     | NULL    |                |
+-------+-------------+------+-----+---------+----------------+


# 查看new表详细信息
show create table new\G;
*************************** 1. row ***************************
       Table: new
Create Table: CREATE TABLE `new` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
1 row in set (0.000 sec)


# 创建临时表(断开与数据库的连接后，临时表就会自动销毁)
CREATE TEMPORARY TABLE temp (`id` int);
```

### insert

**语法**

> ```sql
> INSERT INTO 表名称 (列1, 列2,...) VALUES (值1, 值2,....)
> ```

```sql
# 设置初始值为100
ALTER TABLE new AUTO_INCREMENT=100;

# 插入一条数据
insert into new (name,date) values ('tz','2020-10-24');

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
insert into newcn (id,name) select id,name from cnarea_2019 where id=1;
# 可多次导入
insert into newcn (id,name) select id,name from cnarea_2019 where id >= 2 and id <=10 ;

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
insert into newcn (id,name) select id,name from cnarea_2019 where name regexp '广州.*';
```

### update

**语法：**

> ```sql
> UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值
> ```

```sql
# 修改 id=1 的 city_code 字段为111
update cnarea_2019 set city_code=111 where id=1;

# 对每个 id-3 填回刚才删除的 id1,2,3
update cnarea_2019 set id=(id-3) where id>2;

# 对小于level平均值进行加1
update cnarea_2019 set level=(level+1) where level<=(select avg(level) from cnarea_2019);

# 把 广州 修改为 北京,replace() 修改列的某一部分值
update cnarea_2019 set name=replace(name,'广州','北京') where name regexp '广州.*';

# 把以 北京 和 深圳 开头的数据，修改为 广州
update cnarea_2019 set name=replace(name,'深圳','广州'),name=replace(name,'北京','广州') where name regexp '^深圳' or name regexp '^北京';
```

### delete

**语法：**

> ```sql
> DELETE FROM 表名称 WHERE 列名称 = 值
> ```

```sql
# 删除 id1
delete from cnarea_2019 where id=1;
# 删除 id2和4
delete from cnarea_2019 where id in (2,4);

# 查看结果
select level, count(*) as totals from cnarea_2019 group by level;

# 删除表
delete from cnarea_2019;
# 删除表(无法回退)
truncate table cnarea_2019;
# 这两者的区别简单理解就是 drop 语句删除表之后，可以通过日志进行回复，而 truncate 删除表之后永远恢复不了，所以，一般不使用 truncate 进行表的删除。

# 删除数据库
drop database china;

# 记得重新恢复数据库
create database china;
mysql -uroot -pYouPassward china < china_area_mysql.sql
```

#### 删除重复的数据

```sql
# 创建表
create table clone (`id` int (8), `name` varchar(50), `date` DATE);

# 插入数据
insert into clone (id,name,date) values
(1,'tz','2020-10-24'),
(2,'tz','2020-10-24'),
(2,'tz','2020-10-24'),
(2,'tz1','2020-10-24'),
(2,'tz1','2020-10-24');

# 通过加入 主健(PRIMARY KEY) 删除重复的数据
ALTER IGNORE TABLE clone ADD PRIMARY KEY (id, name);
# 或者加入 唯一性索引(UNIQUE)
ALTER IGNORE TABLE clone ADD UNIQUE KEY (id, name);

select * from clone;
+----+------+------------+
| id | name | date       |
+----+------+------------+
|  1 | tz   | 2020-10-24 |
|  2 | tz   | 2020-10-24 |
|  2 | tz1  | 2020-10-24 |
+----+------+------------+
```

[误删数据进行回滚，跳转至**事务**](#transaction)

### CREATE PROCEDURE (自定义过程）

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

### INDEX (索引)

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

#### 索引速度测试

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

### undrop-for-innodb

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

```sql
# 创建用户名为tz的用户
create user 'tz'@'127.0.0.1' identified by 'YouPassword';

# 查看所有用户
SELECT user,host FROM mysql.user;

# 详细查看所有用户
SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysql.user;

# 查看用户权限
show grants for 'tz'@'%';

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

# 允许root从'192.168.100.208'主机china库下的所有表
grant all privileges on china.* to 'root'@'192.168.100.208' identified by 'YouPassword' WITH GRANT OPTION;

# 允许root从'192.168.100.208'主机china库下的cnarea_2019表
grant all PRIVILEGES on china.cnarea_2019 to 'root'@'%'  identified by 'YouPassword' WITH GRANT OPTION;

# 允许所有用户连接所有库下的所有表(%:表示通配符)
grant all PRIVILEGES on *.* to  'root'@'%' identified by 'YouPassword' WITH GRANT OPTION;

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

mysql> show variables like 'max_connect%';
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

# 修改全局变量, 仅影响更改后连接的客户端的相应会话值.(重启后失效)
set global max_connect_errors=1000;

# 永久保存,要写入/etc/my.cnf
echo "max_connect_errors=1000" >> /etc/my.cnf
```

## mysqldump 备份和恢复

> [建议使用更快更强大的 mydumper](#mydumper)

- 先创建一个数据表

```sql
use china;
create table tz (`id` int (8), `name` varchar(50), `date` DATE);
insert into tz (id,name,date) values (1,'tz','2020-10-24');
```

- 1.使用 `mysqlimport` 导入**(不推荐)**

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

### 主从同步(Master/Slave)

#### 主服务器配置

- `/etc/my.cnf` 文件配置

```sh
[mysqld]
server-id=129
log_bin=centos7

binlog-do-db=tz          # 同步指定库tz
binlog-ignore-db=tzblock # 忽略指定库tzblock
```

```sh
# 备份
#进入数据库后给数据库加上一把锁，阻止对数据库进行任何的写操作
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

### percona-toolkit 运维监控工具

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
<span id="install"></span>

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
show variables like 'connect_timeout';
# 缩短连接时间
set connect_timeout=2;
```

### ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (111)(连接不了数据库)

- `systemctl restart mysql` 重启配置没问题
- `ps aux | grep mysql` 进程存在
- 内存不足

## 存储引擎

[mysql 索引结构是在存储引擎层面实现的](http://www.ruanyifeng.com/blog/2014/07/database_implementation.html)

修改默认存储引擎 `engine`:

> ```sh
> [mysqld]
> default_storage_engine=CSV
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

# 修改ca表的存储引擎为MYISAM
ALTER TABLE ca ENGINE = MYISAM;
```

### 锁

**语法：**

> ```sql
> # 加锁
> LOCK TABLES 表1 WRITE, 表2 READ, ...;
> ```

> ```sql
> # 解锁
> UNLOCK TABLES;
> ```
>
> 通过队列查看是否有 lock:

```sql
show processlist;
```

**死锁：**
![avatar](/Pictures/mysql/lock.png)

事务 A 在等待事务 B 释放 id=2 的行锁，而事务 B 在等待事务 A 释放 id=1 的行锁。互相等待对方的资源释放，就进入了死锁状态。当出现死锁以后，有两种策略：

- 一：进入等待，直到超时。超时时间参数 `innodb_lock_wait_timeout`

- 二：发起死锁检测，发现死锁后，主动回滚死锁链条中的某一个事务，让其他事务得以继续执行。将参数 `innodb_deadlock_detect` 设置为 `on`。但是它有额外负担的。每当一个事务被锁的时候，就要看看它所依赖的线程有没有被别人锁住，如此循环，最后判断是否出现了循环等待，也就是死锁

**MyISAM:**
MyISAM 不支持行锁，在执行查询语句（SELECT、UPDATE、DELETE、INSERT 等）前，会自动给涉及的表加读锁，这个过程并不需要用户干预

当线程获得一个表的写锁后， 只有持有锁的线程可以对表进行更新操作。 其他线程的读、 写操作都会等待，直到锁被释放为止。

默认情况下，写锁比读锁具有更高的优先级：当一个锁释放时，这个锁会优先给写锁队列中等候的获取锁请求，然后再给读锁队列中等候的获取锁请求。

这也正是 MyISAM 表不太适合于有大量更新操作和查询操作应用的原因，因为，大量的更新操作会造成查询操作很难获得读锁，从而可能永远阻塞。

## InnoDB

InnoDB 采用`WAL`(Write-Ahead Logging). 事务提交时先修改日志,再修改页

日志格式：

- redo log(重做日志) 物理日志:存储了数据被修改后的值.

- binlog 逻辑日志:记录数据库所有更改操作. 不包括 select，show

![avatar](/Pictures/mysql/log.png)

查看日志缓冲区大小，更大的日志缓冲区可以节省磁盘 `I / O`:

```sql
# 默认是 16M
show variables like 'innodb_log_buffer_size';
+------------------------+----------+
| Variable_name          | Value    |
+------------------------+----------+
| innodb_log_buffer_size | 16777216 |
+------------------------+----------+
```

### REDO LOG (重做日志)

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

---

查看 InnoDB 版本:

```sql
SHOW VARIABLES LIKE "innodb_version";
```

- 字典的本质是 `REDUNDANT` 行格式的 innodb 表
- 字典用于记录 `innodb` 核心的对象信息，比如表、索引、字段等。

- 字典存储在 `ibdata1` 文件

- 字典表是普通的 InnoDB 表，对用户是不可见的。但是，一些版本的 MySQL 存放在 `information_schema` 数据库中

```sql
# 查看innoddb字典视图
use information_schema -A;
show tables where  Tables_in_information_schema like 'innodb_sys%';
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

![avatar](/Pictures/mysql/sys_tables.png)

<span id="transaction"></span>

### TRANSACTION (事务)

事务的基本要素（ACID）

- 原子性：Atomicity，整个数据库事务是不可分割的工作单位
- 一致性：Consistency，事务将数据库从一种状态转变为下一种一致的状态
- 隔离性：Isolation，每个读写事务的对象对其他事务的操作对象能相互分离
- 持久性：Durability，事务一旦提交，其结果是永久性的

---

- `BEGIN` 开始一个事务
- `ROLLBACK` 事务回滚
- `COMMIT` 事务确认

```sql
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
# 声明一个名叫 abc 的事务保存点
savepoint abc;

# 插入数据
insert into tz (id,name,date) values (1,'tz','2020-10-24');

# 回滚到 abc 事务保存点
rollback to abc;
```

### autocommit

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

### 线程

- Master Thread 负责将缓冲池中的数据异步刷新到磁盘,包括脏页的刷新(最高的线程优先)

[关于日志](/mysql-log.md)

# reference

- [厉害了，3 万字的 MySQL 精华总结 + 面试 100 问！](https://mp.weixin.qq.com/s?src=11&timestamp=1603207279&ver=2656&signature=PlP1Ta3EiPbja*mclBpkiUWyCM93jx7G0DnE4LwwlzEvW-Fd9hxgIGq1*5ctVid5AZTssRaeDRSKRPlOGOXJfLcS4VUlru*NYhh4BrhZU4k91nsfqzJueeX8kEptSmfc&new=1)
- [21 分钟 MySQL 基础入门](https://github.com/jaywcjlove/mysql-tutorial/blob/master/21-minutes-MySQL-basic-entry.md#%E5%A2%9E%E5%88%A0%E6%94%B9%E6%9F%A5)
- [数据库的最简单实现](http://www.ruanyifeng.com/blog/2014/07/database_implementation.html)
- [阿里规定超过三张表禁止 join，为啥？](https://zhuanlan.zhihu.com/p/158866182)
- [图解 SQL 里的各种 JOIN](https://zhuanlan.zhihu.com/p/29234064)
- [MySQL 锁详解](https://blog.csdn.net/qq_40378034/article/details/90904573)
- [mysql 存储过程详细教程](https://www.jianshu.com/p/7b2d74701ccd)

# 优秀教程

- [MySQL 入门教程](https://github.com/jaywcjlove/mysql-tutorial)
- [sql 语句教程](https://www.1keydata.com/cn/sql/)
- [W3cSchool SQL 教程](https://www.w3school.com.cn/sql/index.asp)
- [MySQL 教程](https://www.runoob.com/mysql/mysql-tutorial.html)
- [138 张图带你 MySQL 入门](https://mp.weixin.qq.com/s?src=11&timestamp=1603417035&ver=2661&signature=Z-XNfjtR11GhHg29XAiBZ0RAiMHavvRavxB1ccysnXtAKChrVkXo*zx3DKFPSxDESZ9lwRM7C8-*yu1dEGmXwHgv1qe7V-WvwLUUQe7Nz7RUwEuJmLYqVRnOWtONHeL-&new=1)
- [数据库内核月报](http://mysql.taobao.org/monthly/)

# reference items

- [数据库表连接的简单解释](http://www.ruanyifeng.com/blog/2019/01/table-join.html?utm_source=tuicool&utm_medium=referral)
- [MySQL 资源大全中文版](https://github.com/jobbole/awesome-mysql-cn)

# online tools

- [创建数据库的实体-关系图的工具 dbdiagram](https://dbdiagram.io)

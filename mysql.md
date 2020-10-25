<!-- vim-markdown-toc GFM -->

* [mysql SQL 命令入门教程](#mysql-sql-命令入门教程)
    * [基本命令](#基本命令)
        * [连接数据库](#连接数据库)
        * [常用 SQL 命令](#常用-sql-命令)
        * [用户设置](#用户设置)
            * [授予权限,远程登陆](#授予权限远程登陆)
        * [配置(varibles)操作](#配置varibles操作)
    * [下载数据库进行 SQL 语句 学习](#下载数据库进行-sql-语句-学习)
    * [DQL](#dql)
        * [select](#select)
            * [where](#where)
            * [order,regexp(正则表达式)](#orderregexp正则表达式)
        * [SQL FUNCTION](#sql-function)
            * [加密函数](#加密函数)
            * [自定义函数](#自定义函数)
    * [DML](#dml)
        * [CREATE(创建)](#create创建)
        * [insert](#insert)
            * [选取另一个表的数据,导入进新表](#选取另一个表的数据导入进新表)
        * [update](#update)
        * [delete](#delete)
            * [删除重复的数据](#删除重复的数据)
        * [alter](#alter)
    * [union(多个表显示以列为单位)](#union多个表显示以列为单位)
    * [JOIN](#join)
        * [INNER JOIN](#inner-join)
        * [LEFT JOIN](#left-join)
        * [RIGHT JOIN](#right-join)
        * [full outer join](#full-outer-join)
    * [DCL](#dcl)
    * [帮助文档](#帮助文档)
    * [事务](#事务)
    * [INDEX](#index)
        * [索引速度测试](#索引速度测试)
    * [mysqldump 备份和恢复](#mysqldump-备份和恢复)
        * [备份](#备份)
        * [主从同步(Master/Slave)](#主从同步masterslave)
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
        * [开启日志显示 ok，但查询后并没有开启](#开启日志显示-ok但查询后并没有开启)
    * [存储组件](#存储组件)
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

### 常用 SQL 命令

在 `linux` 终端输入的命令是 `shell` 命令

而 `SQL` 命令指进入数据库里的命令

- **注意:** SQL 命令后面要加 `;`

- SQL 命令**大小写不敏感** `CREATE` 或 `create` 都可以
- 而表(table)是要**区分大小写**的

```sql
# 创建名为tz的数据库
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

### 用户设置

> [如没有遇到用户权限问题，或者远程用户连接数据库。可跳过用户设置(建议)](#sql)

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

#### 授予权限,远程登陆

```sql

# 允许root从'192.168.100.208'主机china库下的所有表
grant all privileges on china.* to 'root'@'192.168.100.208' identified by 'YouPassword' WITH GRANT OPTION;;

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

# 连接远程数据库(我这里是192.168.1.221)
mysql -u root -p 'YouPassword' -h 192.168.1.221
```

### 配置(varibles)操作

- 注意`variables` 的修改，永久保存要写入`/etc/my.cnf`

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

# 修改配置(重启后失效)
set global max_connect_errors=1000;
# 永久保存,要写入/etc/my.cnf
echo "max_connect_errors=1000" >> /etc/my.cnf
```

## 下载数据库进行 SQL 语句 学习

<span id="sql"></span>

```sql
# 连接数据库后,创建china数据库
create database china;
```

```sh
# 下载2019年中国地区表
git clone https://github.com/kakuilan/china_area_mysql.git
cd china_area_mysql

# 导入表到china库
mysql -uroot -pYouPassward china < china_area_mysql.sql
```

## DQL

### select

对`值(values)`的操作

- having
- where
- is null
- is not null

对`字段`的操作

- order by
- group by
- distinct

---

**语法:**

> ```sql
> SELECT 列名称 FROM 表名称
> ```

---

```sql
# 连接数据库后,进入china数据库
use china;

# 查看表cnarea_2019 的字段(列)
desc cnarea_2019

# 将cnarea_2019表改名为ca,方便输入
alter table cnarea_2019 rename ca;
# 改回来
alter table ca rename cnarea_2019;

# 从表 cnarea_2019 选取所有列(*表示所有列)
select * from cnarea_2019;

# 如果刚才将表改成ca名，就是以下命令
select * from ca;

# 从表 cnarea_2019 选取 name 列
select name from cnarea_2019;

# 从表 cnarea_2019 选取 name 和 id 列
select id,name from cnarea_2019;

# 选取所有列，但只显示前2行
select * from cnarea_2019 limit 2;

# 选取所有列，但只显示3到6行
select * from cnarea_2019 limit 2,4;

# 选取level列,用distinct过滤重复的数据
select distinct level from cnarea_2019;
```

#### where

有条件地从表中选取数据

```sql
# 选取id=174909的数据
select * from cnarea_2019 where id=174909;

# 选取id大于10的
select * from cnarea_2019 where id > 10

# 选取10<=id<=30的
select * from cnarea_2019 where id<=30 and id>=10;

# 选取id10和id20的
select * from cnarea_2019 where id in (10,20);

# 选取非空小于10的
select * from ca where id is not null and id < 10;
```

#### order,regexp(正则表达式)

```sql
# 选取id<=10,按level字段进行排序
select * from cnarea_2019 where id<=10 order by level;
# level降序
select * from cnarea_2019 where id<=10 order by level desc;
# level降序,再以id顺序显示
select * from cnarea_2019 where id<=10 order by level desc,id ASC;

# regexp(正则表达式)
select * from cnarea_2019 where id regexp '^1';
```

### SQL FUNCTION

**语法**

> ```sql
> SELECT function(列名称) FROM 表名称
> ```

```sql
# 选取id的最大值,level的最小值
select max(id),min(level) as max from cnarea_2019;

# 选取level的平均值,id的总值
select sum(id),avg(level) from ca;

# 查看总列数
select count(1) as name from cnarea_2019;

# 统计level的个数
select count(distinct level) as totals from cnarea_2019;

# 对level重复数据的进行统计
select level, count(1) as totals from cnarea_2019 group by level;

# 对不同的level，选取id的平均值
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

# 对不同的level，选取id的平均值大于400000
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

#### 自定义函数

**语法：**

> ```sql
> create function 函数名([参数列表]) returns 数据类型
>
> begin
>
> sql语句;
>
> return 值;
>
> end;
> ```

## DML

- 有的地方把 DML 语句（增删改）和 DQL 语句（查询）统称为 DML 语句

### CREATE(创建)

字段属性

- AUTO_INCREMENT 自动增量(每条新记录递增 1)
- NOT NULL 字段不能为空
- primary key (`字段`) 设置主键(数据不能重复)

```sql
# 创建new数据库设置 id 为主键,不能为空,自动增量
CREATE TABLE new(
`id` int (8) NOT NULL AUTO_INCREMENT,
`name` varchar(50),
`date` DATE,
primary key (`id`))
ENGINE=InnoDB DEFAULT CHARSET=utf8;

# 设置初始值为100
ALTER TABLE new AUTO_INCREMENT=100;

# 查看new表里的字段
MariaDB [china]> desc new;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| id    | int(8)      | NO   | PRI | NULL    | auto_increment |
| name  | varchar(50) | YES  |     | NULL    |                |
| date  | date        | YES  |     | NULL    |                |
+-------+-------------+------+-----+---------+----------------+

# 查看new表详细信息
show create table new\G;

MariaDB [china]> show create table new\G;
*************************** 1. row ***************************
       Table: new
Create Table: CREATE TABLE `new` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


# 创建临时表(断开与数据库的连接后，临时表就会自动被销毁)
CREATE TEMPORARY TABLE temp (`id` int);
```

### insert

**语法**

> ```sql
> INSERT INTO 表名称 (列1, 列2,...) VALUES (值1, 值2,....)
> ```

```sql
# 插入新数据
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

```sql

# 创建名为newcn数据库
create table newcn (
`id` int(4),
`name` varchar(50));

# 导入1条数据
insert into newcn (id,name) select id,name from cnarea_2019 where id=1;
# 可多次导入
insert into newcn (id,name) select id,name from cnarea_2019 where id >= 2 and id <=10 ;

# 查看结果
MariaDB [china]>  select * from newcn;
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
```

### update

**语法：**

> ```sql
> UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值
> ```

```sql
# 修改id=1的city_code字段为111
update cnarea_2019 set city_code=111 where id=1;

# 对每个id-3,填回刚才删除的id1,2,3
update cnarea_2019 set id=(id-3) where id>2;

# 对小于level平均值进行加1
update cnarea_2019 set level=(level+1) where level<=(select avg(level) from cnarea_2019);
```

### delete

**语法：**

> ```sql
> DELETE FROM 表名称 WHERE 列名称 = 值
> ```

```sql
# 删除id1
delete from cnarea_2019 where id=1;
# 删除id2和4
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

# 通过加入主健(PRIMARY KEY)删除重复的数据
ALTER IGNORE TABLE clone ADD PRIMARY KEY (id, name);
```

### alter

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

# 将列name改名为mingzi,类型改为char(50)
ALTER TABLE ca change name mingzi char(50);

# 删除id列
ALTER TABLE ca DROP id;

# 添加id列
ALTER TABLE ca ADD id INT FIRST;

# 重命名id列为number(bigint类型)
ALTER TABLE ca CHANGE id number BIGINT;

# 修改city_code列,为char(50)类型
ALTER TABLE ca MODIFY city_code char(50);
# 或者
ALTER TABLE ca CHANGE city_code city_code char(50);

# 修改ca表id列默认值1000
ALTER TABLE ca MODIFY id BIGINT NOT NULL DEFAULT 1000;
# 或者
ALTER TABLE ca ALTER id SET DEFAULT 1000;

# 添加主键，确保该主键默认不为空（NOT NULL）
ALTER TABLE ca MODIFY id INT NOT NULL;
ALTER TABLE ca ADD PRIMARY KEY (id);
# 删除主键
ALTER TABLE ca DROP PRIMARY KEY;

# 修改ca表的存储引擎
ALTER TABLE ca ENGINE = MYISAM;
```

## union(多个表显示以列为单位)

**语法：**

> ```sql
> SELECT 列名称 FROM 表名称
> UNION
> SELECT 列名称 FROM 表名称
> ```

```sql
# 从tz表和cnarea_2019表,选取id,name列
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
```

## JOIN

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

### INNER JOIN

```sql
# 选取new表id,date字段和cnarea_2019表name字段
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

### LEFT JOIN

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

### RIGHT JOIN

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

### full outer join

```sql
# 如果mysql不支持full outer,可以使用union
SELECT * FROM new LEFT JOIN cnarea_2019 ON new.id = cnarea_2019.id

UNION

SELECT * FROM new RIGHT JOIN cnarea_2019 ON new.id =cnarea_2019.id;
```

## DCL

DCL 语句主要是管理数据库权限的时候使用

## 帮助文档

```sql
# 按照层次查询
? contents;
? Account Management
# 数据类型
? Data Types
? VARCHAR
? SHOW
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

## mysqldump 备份和恢复

> [建议使用更快更强大的 mydumper](#mydumper)

### 备份

```sql
# 创建tz表
create table tz (`id` int (8), `name` varchar(50), `date` DATE);
insert into clone (id,name,date) values (1,'tz','2020-10-24');

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
mysqldump -uroot -pYouPassward --all-databases  > all.sql

# 只备份所有数据库表结构(不包含表数据)
mysqldump -uroot -pYouPassward -d --all-databases > mysqlbak-structure.sql

# 恢复

# 恢复到tz数据库
mysql -uroot -pYouPassward tz < tz.sql

# 恢复所有数据库
mysql -uroot -pYouPassward < all.sql

MariaDB [tz] < source tz.sql
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
MASTER_LOG_POS=6501;

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
mysql -uroot -p201997102 -h 192.168.100.208 -P3306
```

## 高效强大的 mysql 软件

### [mycli](https://github.com/dbcli/mycli)

- 更友好的 mysql 命令行
- 目前发现不能,修改和查看用户权限

```sql
mysql root@localhost:(none)> SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysq
                          -> l.user;
(1142, "SELECT command denied to user 'root'@'localhost' for table 'user'")
```

![avatar](/Pictures/mysql/mycli.png)

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

### 开启日志显示 ok，但查询后并没有开启

```sql
# 10.5.6-MariaDB-log Arch Linux
MariaDB [(none)]> SET GLOBAL slow_query_log = 'ON';
Query OK, 0 rows affected (0.000 sec)

MariaDB [(none)]> show variables like 'slow_query_log';
+----------------+-------+
| Variable_name  | Value |
+----------------+-------+
| slow_query_log | OFF   |
+----------------+-------+
1 row in set (0.001 sec)

# 写入/etc/my.cnf后，重启服务后,可以启动日志(显示on)
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

# 查看索引包含主键
show index from ca;
```

# reference

- [厉害了，3 万字的 MySQL 精华总结 + 面试 100 问！](https://mp.weixin.qq.com/s?src=11&timestamp=1603207279&ver=2656&signature=PlP1Ta3EiPbja*mclBpkiUWyCM93jx7G0DnE4LwwlzEvW-Fd9hxgIGq1*5ctVid5AZTssRaeDRSKRPlOGOXJfLcS4VUlru*NYhh4BrhZU4k91nsfqzJueeX8kEptSmfc&new=1)
- [21 分钟 MySQL 基础入门](https://github.com/jaywcjlove/mysql-tutorial/blob/master/21-minutes-MySQL-basic-entry.md#%E5%A2%9E%E5%88%A0%E6%94%B9%E6%9F%A5)
- [数据库的最简单实现](http://www.ruanyifeng.com/blog/2014/07/database_implementation.html)
- [Mydumper - MySQL 数据库备份工具](https://linux.cn/article-5330-1.html)
- [阿里规定超过三张表禁止 join，为啥？](https://zhuanlan.zhihu.com/p/158866182)
- [图解 SQL 里的各种 JOIN](https://zhuanlan.zhihu.com/p/29234064)

# 优秀教程

- [MySQL 入门教程](https://github.com/jaywcjlove/mysql-tutorial)
- [sql 语句教程](https://www.1keydata.com/cn/sql/)
- [W3cSchool SQL 教程](https://www.w3school.com.cn/sql/index.asp)
- [MySQL 教程](https://www.runoob.com/mysql/mysql-tutorial.html)
- [138 张图带你 MySQL 入门](https://mp.weixin.qq.com/s?src=11&timestamp=1603417035&ver=2661&signature=Z-XNfjtR11GhHg29XAiBZ0RAiMHavvRavxB1ccysnXtAKChrVkXo*zx3DKFPSxDESZ9lwRM7C8-*yu1dEGmXwHgv1qe7V-WvwLUUQe7Nz7RUwEuJmLYqVRnOWtONHeL-&new=1)
- [MySQL 常用工具选型和建议](https://zhuanlan.zhihu.com/p/86846532)

# reference items

- [数据库表连接的简单解释](http://www.ruanyifeng.com/blog/2019/01/table-join.html?utm_source=tuicool&utm_medium=referral)
- [MySQL 资源大全中文版](https://github.com/jobbole/awesome-mysql-cn)

# online tools

- [创建数据库的实体-关系图的工具 dbdiagram](https://dbdiagram.io)

# 自己在学习 mysql 上的一些疑问

## 有个说法:where 加 limit 查询比 limit 更快.但我的测试结果不是这样

```sql
mysql> select * from cnarea_2019 limit 100,70000;
70000 rows in set (0.19 sec)

mysql> select * from cnarea_2019 where id > 100 limit 70000;
70000 rows in set (0.17 sec)

mysql> select * from cnarea_2019 where id > 100 limit 700000;
700000 rows in set (1.66 sec)

mysql> select * from cnarea_2019 limit 100,700000;
700000 rows in set (1.51 sec)
```

## 创建一个列为 unique auto_increment 属性的表后,不能再添加 unique auto_increment 的列

```sql
create table newcn ( id int unique auto_increment, name varchar(50));

# 直接显示pri
desc newcn;
+-------+-------------+------+-----+---------+----------------+
| Field | Type | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+----------------+
| id | int(11) | NO | PRI | NULL | auto_increment |
| name | varchar(50) | YES | | NULL | |
+-------+-------------+------+-----+---------+----------------+

alter table newcn add age int unique auto_increment;
ERROR 1075 (42000): Incorrect table definition; there can be only one auto column and it must be defined as a key

# 要把 auto_increment 属性删除才可以
MariaDB [china]> alter table newcn change id id int unique;
Query OK, 0 rows affected, 1 warning (0.014 sec)
Records: 0  Duplicates: 0  Warnings: 1

MariaDB [china]> desc newcn;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int(11)     | YES  | UNI | NULL    |       |
| name  | varchar(50) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.001 sec)

MariaDB [china]> alter table newcn add age int unique auto_increment;
Query OK, 0 rows affected (0.011 sec)
Records: 0  Duplicates: 0  Warnings: 0

MariaDB [china]> desc newcn;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| id    | int(11)     | YES  | UNI | NULL    |                |
| name  | varchar(50) | YES  |     | NULL    |                |
| age   | int(11)     | NO   | PRI | NULL    | auto_increment |
+-------+-------------+------+-----+---------+----------------+
3 rows in set (0.001 sec)

# 一共有三个索引
MariaDB [china]> show index from newcn;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| newcn |          0 | age      |            1 | age         | A         |           0 |     NULL | NULL
  |      | BTREE      |         |               |
| newcn |          0 | id       |            1 | id          | A         |           0 |     NULL | NULL
  | YES  | BTREE      |         |               |
| newcn |          0 | id_2     |            1 | id          | A         |           0 |     NULL | NULL
  | YES  | BTREE      |         |               |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
```

### 而创建一个字段 prmimary key(主健)的表后,却可以

```sql
create table newcn ( id int , name varchar(50), primary key(id));

desc newcn;
+-------+-------------+------+-----+---------+-------+
| Field | Type | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id | int(11) | NO | PRI | NULL | |
| name | varchar(50) | YES | | NULL | |
+-------+-------------+------+-----+---------+-------+

alter table newcn add age int unique auto_increment;

desc newcn;
+-------+-------------+------+-----+---------+----------------+
| Field | Type | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+----------------+
| id | int(11) | NO | PRI | NULL | |
| name | varchar(50) | YES | | NULL | |
| age | int(11) | NO | UNI | NULL | auto_increment |
+-------+-------------+------+-----+---------+----------------+

# 只有两个索引
show index from newcn;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| newcn |          0 | PRIMARY  |            1 | id          | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| newcn |          0 | age      |            1 | age         | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
```

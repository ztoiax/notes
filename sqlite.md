
<!-- vim-markdown-toc GFM -->

* [sqlite](#sqlite)
    * [基本命令](#基本命令)
    * [Dynamic type(动态类型)](#dynamic-type动态类型)
        * [datetime(日期和时间)](#datetime日期和时间)
    * [CREATE(创建)](#create创建)
    * [SELECT(查询)](#select查询)
    * [增删改](#增删改)
    * [python](#python)
* [优秀文章](#优秀文章)
* [第三方软件资源](#第三方软件资源)

<!-- vim-markdown-toc -->

# sqlite

- 语法类似 `mysql`

## 基本命令

```sh
# 创建并连接数据库文件test.db
sqlite3 test.db
```

```sql
# 查看数据库
.databases

# 查看所有表
.tables

# 模糊匹配'z'结尾的表
.table '%z'

# 查看所有表的schema(表结构)
.schema

# 模糊匹配'z'结尾的schema(表结构)
.schema '%z'

# 查看mode
.mode

# 修改mode
.mode column

# .width 修改每列之间的宽度
.width 2 -1

# 修改separator(分隔符)
.separator ,
.separator ',  '

# .output 将之后所有查询输出至文件
.output /tmp/test

# .once 只是下一次查询输出至文件
.once /tmp/test

# .read 读取并执行文件里的sql查询语句
.read /tmp/read

# 查看索引
.indexes
```

## Dynamic type(动态类型)

- 声明类型是指:列的类型.而不是指列property(字段)的类型

    - 列的字段可以存储任何类型

| type    | size            |
|---------|-----------------|
| INTEGER | 可选1 - 8 bytes |
| REAL    | 8 bytes         |
| TEXT    | 无限制          |
| BLOB    | 无限制          |
| NULL    | NULL            |

- 查询类型: `select typeof()`

```sql
select typeof(100),
       typeof(100.0),
       typeof('100'),
       typeof(x'0100'),
       typeof(NULL)
```

- 声明`INTEGER`类型, 但它可以存储任何类型:

    ```sql
    CREATE TABLE test_datatypes (
        id INTEGER PRIMARY KEY,
        value
    );

    INSERT INTO test_datatypes (value)
    VALUES
        (100),
        (100.0),
        ('100'),
        (x'0100'),
        (NULL);
    ```

    ![image](./Pictures/sqlite/datatypes.png)


### datetime(日期和时间)

- 类型为`INT`:

    ![image](./Pictures/sqlite/datetime_int.png)

- 类型为`TEXT`:

    ![image](./Pictures/sqlite/datetime_text.png)

- 类型为`REAL`:

    ![image](./Pictures/sqlite/datetime_real.png)

```sql
# 查询日期
SELECT date();

# 查询当前时间
SELECT time();

# 查询当前日期时间
SELECT datetime();

# 创建int类型进行测试, 可以是其他类型
CREATE TABLE datetime_int (d1 int);

# 插入当前日期时间
INSERT INTO datetime_int (d1)
VALUES(datetime());
```


## CREATE(创建)

- 注意: 表名不能以 `sqlite_` 开头, 这是保留给内部使用

**语法:**

> ```sql
> CREATE TABLE [IF NOT EXISTS] [schema_name].table_name (
>     column_1 data_type PRIMARY KEY,
>     column_2 data_type NOT NULL,
>     column_3 data_type DEFAULT 0,
>     table_constraints
> ) [WITHOUT ROWID];
> ```

- `IF NOT EXISTS` 创建不存在的新表

- `schema_name`

    - 主数据库

    - 临时数据库

- `WITHOUT ROWID` 去除隐藏列

    - 默认会有隐藏列`rowid`, 表的唯一值

> ```sql
> CREATE TABLE test(
>    id INTEGER,
>    group_id INTEGER,
>    PRIMARY KEY (id),
>    FOREIGN KEY (id) 
>       REFERENCES contacts (id) 
>          ON DELETE CASCADE 
>          ON UPDATE NO ACTION,
> );
> ```

- `PRIMARY KEY (property, property1)`: 声明主键

- `FOREIGN KEY (property)`: 声明外键

- `ON DELETE CASCADE`:

- `ON UPDATE NO ACTION`:

## SELECT(查询)

```sql
# 查询id字段
SELECT id
FROM test_datatypes;

# * 查询所有
SELECT *
FROM test_datatypes;

# typeof()查询类型
SELECT *, typeof(value)
FROM test_datatypes;
```

## 增删改

```sql
# 注意:这只是删除表里的数据,表还是存在的
DELETE FROM table

# 删除第10行
DELETE FROM table
WHERE id = 10;
```

## python

- [官方文档](https://docs.python.org/3/library/sqlite3.html)

```py
import sqlite3

# 连接文件
con = sqlite3.connect('test.db')

# 获取cursor后, 便能使用execute()执行sql命令
cur = con.cursor()

# 创建表
cur.execute('''CREATE TABLE python_test
        (name TEXT, type TEXT, img BLOB)''')

# IF NOT EXISTS
cur.execute('''CREATE TABLE IF NOT EXISTS python_test
        (name TEXT, type TEXT, img BLOB)''')

# 插入文件数据
cur.execute('''INSERT INTO python_test VALUES
        ('image','png','image.png')''')

# 返回的对象是元组
istuple = cur.execute('SELECT * FROM python_test')

# 将数据写入新文件.SELECT writefile需要安装插件
cur.execute("SELECT writefile('new_image.png',img) FROM python_test WHERE name='image'")

# commit()后, 之前的insert才会生效
con.commit()
con.close()
```

# 优秀文章

- [官方文档](https://www.sqlite.org/docs.html)

- [sqltutorial](https://www.sqlitetutorial.net/)

# 第三方软件资源

- [litecli](https://github.com/dbcli/litecli)

    > 更友好的补全和语法高亮的终端(cli)

    > 注意:如果使用外部程序修改数据,需要重启litecli, 才会正确显示

- [sqlitebrowser](https://github.com/sqlitebrowser/sqlitebrowser)

    > 图形客户端

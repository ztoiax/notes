
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

## 基本命令

- 终端:

```sh
# 创建并连接数据库文件test.db
sqlite3 test.db
```

- 数据库:

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

- 声明类型:列的类型.而不是指列property(字段)的类型

    - 列的字段可以存储任何类型

| type    | size            |
|---------|-----------------|
| INTEGER | 可选1 - 8 bytes |
| REAL    | 8 bytes         |
| TEXT    | 无限制          |
| BLOB    | 无限制          |
| NULL    | NULL            |

- 查询类型: `SELECT typeof()`

```sql
SELECT typeof(100),
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

```sql
# 查询日期
SELECT date();

# 查询当前时间
SELECT time();

# 查询当前日期时间
SELECT datetime();
```

- `INT` 类型的日期时间:

    ```sql
    # 创建int类型进行测试. 其它类型同理
    CREATE TABLE datetime_int (d1 int);

    # 插入当前日期时间
    INSERT INTO datetime_int (d1)
    VALUES(datetime());

    # 查询
    SELECT d1, typeof(d1)
    FROM datetime_int;
    ```

    ![image](./Pictures/sqlite/datetime_int.png)

- `TEXT` 类型的日期时间:

    ![image](./Pictures/sqlite/datetime_text.png)

- `REAL` 类型的日期时间:

    ![image](./Pictures/sqlite/datetime_real.png)


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

        - 创建不需要声明类型

        ```sql
        # 创建临时数据库
        CREATE TABLE temp.test
        (col, col1);

        # 插入数据
        INSERT INTO temp.test
        values (1, 2)

        SELECT * from temp.test
        ```

        ![image](./Pictures/sqlite/table_temp.png)

- `WITHOUT ROWID` 去除隐藏列ROWID. 适合非整型,非长字符, blob的主键的表.[官网介绍](https://www.sqlite.org/withoutrowid.html)

    - 隐藏列 `ROWID` 是真正的主键, 而`PRIMARY KEY`只是ROWID的别名

    - ROWID使用64位符号整数, 唯一的标识表中的行

    - ROWID是sqlite独有的,是早期的简化实现.在优秀的系统中不应该有ROWID, 但为了向后兼容不得已保留下来, 所以提供`WITHOUT ROWID`

    - 优点:

        - 提升速度, 减少磁盘空间

        - 只有1张B-tree, 存储1次, 只有1次二进制搜索

            - 默认声明PRIMARY KEY的表, 加上ROWID会有2张B-tree, index字段会存储2次. 搜索时先找index提取rowid后再找表, 因此有2次二进制搜索

    - 缺点:
        - `AUTOINCREMENT` 选项无法使用

        - `sqlite3_last_insert_rowid()` 函数无法使用

        - `incremental blob I/O ` 机制无法使用, 因此无法创建sqlite3_blob 对象

        - `sqlite3_update_hook() ` 表更改时不会调用此hook

    ```sql
    # 查看rowid
    SELECT rowid, * FROM test
    ```

    ```sql
    # 创建WITHOUT ROWID的表, 必须有一个主键, 并且最好是非整型, 不然可能还不如rowid表
    CREATE TABLE test
    (d1 REAL PRIMARY KEY)
    WITHOUT ROWID;
    ```

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

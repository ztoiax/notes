<!-- vim-markdown-toc GFM -->

* [Redis 入门教程](#redis-入门教程)
    * [值和对象](#值和对象)
        * [string (字符串)](#string-字符串)
        * [hash (哈希散列)](#hash-哈希散列)
        * [list (列表)](#list-列表)
        * [set (集合)](#set-集合)
            * [交集，并集，补集](#交集并集补集)
* [常见错误](#常见错误)
    * [vm.overcommit_memory = 1](#vmovercommit_memory--1)
    * [高效强大的第三方 redis 软件](#高效强大的第三方-redis-软件)
        * [iredis](#iredis)
        * [redis-tui](#redis-tui)
        * [redis-memory-analyzer](#redis-memory-analyzer)
        * [AnotherRedisDesktopManager](#anotherredisdesktopmanager)
        * [RedisLive](#redislive)
* [reference](#reference)

<!-- vim-markdown-toc -->

# Redis 入门教程

## 值和对象

Redis 数据库里面的每个键值对（key-value pair）都是由对象（object）组成的：

- 其中， 数据库键总是一个字符串对象（string object）；
- 而数据库键的值则可以是字符串对象、 列表对象（list object）、 哈希对象（hash object）、 集合对象（set object）、 有序集合对象（sorted set object）这五种对象中的其中一种。

| 对象         | type 命令输出 |
| ------------ | ------------- |
| 字符串对象   | "string"      |
| 列表对象     | "list"        |
| 哈希对象     | "hash"        |
| 集合对象     | "set"         |
| 有序集合对象 | "zset"        |


---


### string (字符串)

字符串对象的编码: [**详情**](http://redisbook.com/preview/object/string.html)

| 编码      | 作用             |
| --------- | ----------       |
| int       | 整数             |
| raw       | 长度>=39的字符串:使用动态字符串（SDS） |
| embstr    | 长度<=39的字符串:所需的内存分配次数从 raw 编码的两次降低为一次 |

**动态字符串**（simple dynamic string，**SDS**）:

     除了用来保存数据库中的字符串值之外， SDS 还被用作缓冲区（buffer）： AOF 模块中的 AOF 缓冲区， 以及客户端状态中的输入缓冲区， 都是由 SDS 实现的

- 比起 C 字符串， SDS 具有以下优点：
- 常数复杂度获取字符串长度。
- 杜绝缓冲区溢出。
- 减少修改字符串长度时所需的内存重分配次数。
- 二进制安全。
- 兼容部分 C 字符串函数。

```sql
# 创建一个键为字符串对象， 值也为字符串对象的键值对
SET msg "hello world !!!"

# 对同一个健设置，会覆盖值以及存活时间
SET msg "hello world"

# EX 设置存活时间
SET msg "hello world" EX 100

# ttl 查看存活时间
ttl msg

# strlen 查看长度
strlen msg

# type 查看健类型
type msg

# exists 查看健是否存在
exists msg
```

在 `iredis` 下的显示[跳转至 iredis 的介绍](#iredis)
![avatar](/Pictures/redis/string1.png)

在 `gui` 下的显示[跳转至 gui 的介绍](#gui)
![avatar](/Pictures/redis/string.png)

```sql
# setnx 如果健不存在，才创建
# 因为msg健已经存在，所以创建失败
setnx msg "test exists"
# 创建成功
setnx test "test exists"

# 查看 前5个字符
getrange msg 0 5
# 查看 倒数5个字符
getrange msg -5 -1

# 修改为HELLO,从第一个字符开始
setrange msg 0 'HELLO'

# 修改为WORLD,从第6个字符开始
setrange msg 6 WORLD

# 在末尾添加" tz"
append msg " tz"
```

![avatar](/Pictures/redis/string2.png)

创建多个健

```sql
# 对多个健进行赋值(我这里是a,msg)
mset a 1 msg tz

# 如果这其中有一个健是存在的，那么都不会进行赋值
msetnx a '2' b '3' msg "tz-pc"

# 查看多个健
mget a b msg

# 删除 a,msg健
del a msg
```

对健的值进行加减

```sql
set a 1

# incr 对a加1(只能对 64位 的unsigned操作)
incr a

# incrby 对a加10(只能对 64位 的unsigned操作)
incrby a 10

# incrbyfloat 对a加1.1
incrbyfloat a 1.1

# incrbyfloat 对a减1.1
incrbyfloat a -1.1

# decr 对a减1(只能对 64位 的unsigned操作)
decr a

# decrby 对a减10(只能对 64位 的unsigned操作)
decrby a 10

```

### hash (哈希散列)

哈希对象的编码: [**详情**](http://redisbook.com/preview/object/hash.html)

| 编码      | 作用                                                                                      |
| --------- | ----------                                                                                |
| ziplist   | 压缩列表：先添加到哈希对象中的键值对会在压缩列表的表头， 后添加对象中的键值对会在的表尾。 |
| hashtable | 字典:字典的每个键都是一个字符串对象， 对象中保存了键值对的键和值                        |

只是把 set,get...命令,换成 hset,hget

> ```sql
> HSET 表名 域名1 域值1 域名2 域值2 ...
> ```

```sql
# 创建表名为table，并设置名为a的域(field),它的值为1
hset table a 1

# 查看表table
hgetall table
```

![avatar](/Pictures/redis/hash.png)

```sql
# 继续添加表table 的b域为2,c域为3
hset table b 2
hset table c 3

hgetall table
```

![avatar](/Pictures/redis/hash1.png)

```sql
# 删除表table的a域
hdel table a

hgetall table

# 删除整个table表
del table
```

![avatar](/Pictures/redis/hash2.png)

```sql
# 一次创建多个域
hset n a 1 b 2 c 3

hmset n a 1 b 2 c 3
# 修改 a域为-1
hset n a -1

# hsetnx 如果a域存在,则不修改值
hsetnx n a 0

# hkeys 查看n表里的所有域名
hkeys n

# hvals 查看n表里的所有域值
hvals n

# hexists 查看n表里是否存在a域
hexists n a

# hget 只查看n表里的a域
hget n a

# hmget 查看n表里的a,b域
hmget n a b

# 查看n表有多少个域
hlen n
# 查看a域的长度
hstrlen n a
```

对域的值进行加减

```sql
# a域的值加10(只能对 64位 的unsigned操作)
hincrby n a 10

# a域的值减5(只能对 64位 的unsigned操作)
hincrby n a -5

# a域的值加1.1
hincrbyfloat n a 1.1

# a域的值减1.1
hincrbyfloat n a -1.1
```

### list (列表)

键值对的值是一个列表对象， 列表对象包含了 字符串对象， 字符串对象由 SDS 实现.

链表被广泛用于实现 Redis 的各种功能， 比如列表键， 发布与订阅， 慢查询， 监视器， 等等。
integers 列表键的底层实现就是一个链表， 链表中的每个节点都保存了一个整数值。

列表对象的编码: [**详情**](http://redisbook.com/preview/object/list.html)

| 编码        | 作用                                                                                                                                                                                                                |
| ----------  | --------------------------------------------------------------------------------------                                                                                                                              |
| ziplist     | 每个压缩列表节点（entry）保存了一个列表元素                                                                                                                                                                         |
| linkedlist  | 每个双端链表节点（node）都保存了一个字符串对象，而每个字符串对象都保存了一个列表元素。                                                                                                                             |
| 　quickList | zipList 和 linkedList 的混合体，它将 linkedList 按段切分，每一段使用 zipList 来紧凑存储，多个 zipList 之间使用双向指针串接起来。默认的压缩深度是 0，也就是不压缩。压缩的实际深度由配置参数list-compress-depth决定。 |


![avatar](/Pictures/redis/list5.png)

> ```sql
> # 反向插入
> LPUSH 列表名 值1 值2 ...
> # 正向插入
> RPUSH 列表名 值1 值2 ...
> ```

创建 名为 list 的列表

```sql
# 反向插入
lpush list 1
lpush list 2

# 列表允许重复元素
lpush list 2
lpush list 1

# 查看列表list
lrange list 0 -1
```

![avatar](/Pictures/redis/list.png)

```sql
# 一次性插入多个值,反向插入
lpush l a a b b c c
```

![avatar](/Pictures/redis/list1.png)

```sql
# 正向插入
rpush ll a a b b c c
```

![avatar](/Pictures/redis/list2.png)

```sql
# 查看长度
llen ll

# lpushx,rpushx不能对空的表进行插入
lpushx null a a b b c c
rpushx null a a b b c c

# lpop 移除第一个值
lpop ll

# rpop 移除最后一个值
rpop ll
```

![avatar](/Pictures/redis/list3.png)

```sql
# RPOPLPUSH 把最后一个值,放到第一位
rpoplpush ll ll
```

![avatar](/Pictures/redis/list4.png)

```sql
# 移除两个b值
lrem ll 2 b

# 查看ll的第1个值(注意:0表示第1个值)
lindex ll 0

# 查看ll的第2个值(注意:1表示第2个值)
lindex ll 1

# 查看ll的最后一个值
lindex ll -1

# 在第一个a值，前面插入b值
linsert ll before a b

# 在第一个a值，后面插入1值
linsert ll after a 1

# 将ll的第一个值修改为hello
lset ll 0 hello

# 只保留 前两个值(注意:0表示第1个值,1表示第2个值)
ltrim ll 0 1
```

### set (集合)

集合对象的编码: [**详情**](http://redisbook.com/preview/object/set.html)

| 编码      | 作用       |
| --------- | ---------- |
| intset    | 整数       |
| hashtable | 包含字符串 |


```sql
# 新建一个集合,名为jihe .字符串的集合编码为hashtable
sadd jihe 'test'
sadd jihe 'test1' 'test2' 'test3' 123

# 查看集合jihe
smembers jihe

# 数字的集合编码为intset
sadd s 123

# 查看编码为intset
object encoding s

# 数字和字符都有的集合，编码为hashtable
sadd s test

# 再次查看编码发现已经变为hashtable
object encoding s
```

![avatar](/Pictures/redis/set.png)

那如果一个集合,包含数和字符串,把字符串的值删除后。**编码**会变吗？

```sql
# 新建ss集合,包含数和字符串
sadd ss 123 'test'

# 查看编码
object encoding ss

# 删除 ss 集合里的test字符串值
srem ss test

# 再次查看编码
object encoding ss
```

答案是没有变，还是 `hashtable`

![avatar](/Pictures/redis/set1.png)

```sql
# 查看集合个数
scard jihe

# 查看集合是否有test值。有返回1,无返回0
sismember jieh "test"

# 删除集合里的test，test1值
srem jihe test test1

# 将jihe里的值123,移到jihe1
smove jihe jihe1 123

# 删除随机一个数
spop jihe

# 查看随机一个数
srandmember jihe
```

#### 交集，并集，补集

```sql
# 新建两个集合
sadd sss 123 test test1
sadd ssss 123 test abc cba

# sinter 返回两个集合的交集
sinter sss ssss

# sunion 返回两个集合的并集
sunion sss ssss

# sdiff 返回sss的补集
sdiff sss ssss
# sdiff 返回ssss的补集
sdiff ssss sss

# 返回交集，并集，补集的数量
sinterstore sss ssss
sunionstore sss ssss
sdiffstore sss ssss
```

![avatar](/Pictures/redis/set2.png)

# 常见错误

## vm.overcommit_memory = 1

内存分配策略
/proc/sys/vm/overcommit_memory

0， 表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存，内存申请允许；否则，内存申请失败，并把错误返回给应用进程。
1， 表示内核允许分配所有的物理内存，而不管当前的内存状态如何。
2， 表示内核允许分配超过所有物理内存和交换空间总和的内存

```sh
# 修复
echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
sysctl -p
```

## 高效强大的第三方 redis 软件

<span id="iredis"></span>

### [iredis](https://github.com/laixintao/iredis)

- 更友好的补全和语法高亮的终端(cli)

![avatar](/Pictures/redis/iredis.png)

### [redis-tui](https://github.com/mylxsw/redis-tui)

- 更友好的补全和语法高亮,有输出，key 等多个界面的终端(tui)

![avatar](/Pictures/redis/redis-tui.png)

### [redis-memory-analyzer](https://github.com/gamenet/redis-memory-analyzer)

- `RMA`是一个控制台工具，用于实时扫描`Redis`关键空间，并根据关键模式聚合内存使用统计数据

```sh
# 默认只会输出一遍，可以用 watch 进行监控(变化的部分会高亮显示)
watch -d -n 2 rma
```

![avatar](/Pictures/redis/rma.png)

<span id="gui"></span>

### [AnotherRedisDesktopManager](https://github.com/qishibo/AnotherRedisDesktopManager)

- 一个有图形界面的`Redis`的桌面客户端，其中也可以显示 刚才提到的 `rma` 的内存数据

![avatar](/Pictures/redis/redis-gui.png)

### [RedisLive](https://github.com/nkrode/RedisLive)

# reference

- [《Redis 设计与实现》部分试读](http://redisbook.com/)
- [《Redis 使用手册》](http://redisdoc.com/)
- [《Redis 实战》部分试读](http://redisinaction.com/)<++>

<!-- vim-markdown-toc GFM -->

* [Redis 入门教程](#redis-入门教程)
    * [值和对象](#值和对象)
        * [string (字符串)](#string-字符串)
        * [hash (哈希散列)](#hash-哈希散列)
        * [list (列表)](#list-列表)
        * [set (集合)](#set-集合)
            * [交集,并集,补集](#交集并集补集)
        * [sorted set (有序集合)](#sorted-set-有序集合)
            * [交集,并集](#交集并集)
    * [hyper log](#hyper-log)
    * [transaction (事务)](#transaction-事务)
    * [Lua 脚本](#lua-脚本)
    * [python](#python)
    * [配置](#配置)
        * [config](#config)
        * [info](#info)
        * [用户密码](#用户密码)
        * [调试](#调试)
            * [slowlog](#slowlog)
            * [monitor](#monitor)
            * [migrate (迁移)](#migrate-迁移)
        * [client](#client)
        * [远程登陆](#远程登陆)
    * [persistence (持久化) RDB AOF](#persistence-持久化-rdb-aof)
    * [master slave replication (主从复制)](#master-slave-replication-主从复制)
    * [sentinel (哨兵模式)](#sentinel-哨兵模式)
        * [开启 sentinal](#开启-sentinal)
        * [sentinel 的命令](#sentinel-的命令)
    * [cluster (集群)](#cluster-集群)
    * [publish subscribe (发布和订阅)](#publish-subscribe-发布和订阅)
        * [键空间通知](#键空间通知)
* [redis 如何做到和 mysql 数据库的同步](#redis-如何做到和-mysql-数据库的同步)
* [redis 安装](#redis-安装)
    * [centos7 安装 redis6.0.9](#centos7-安装-redis609)
    * [docker install](#docker-install)
* [常见错误](#常见错误)
    * [vm.overcommit_memory = 1](#vmovercommit_memory--1)
    * [高效强大的第三方 redis 软件](#高效强大的第三方-redis-软件)
        * [iredis](#iredis)
        * [redis-tui](#redis-tui)
        * [redis-memory-analyzer](#redis-memory-analyzer)
        * [AnotherRedisDesktopManager](#anotherredisdesktopmanager)
        * [RedisLive](#redislive)
        * [redis-rdb-tools](#redis-rdb-tools)
        * [redis-shake](#redis-shake)
        * [dbatools](#dbatools)
* [reference](#reference)
* [online tool](#online-tool)

<!-- vim-markdown-toc -->

# Redis 入门教程

Redis 的优点：

- 数据保存在内存里: 因此 Redis 也常常被用作缓存数据库,实现高性能、高并发

- 单进程，单线程: 减少多线程之间的切换和竞争带来的性能开销(Redis 6.0 版本之前)
- Redis 的多线程部分只是用来处理网络数据的读写和协议解析，执行命令仍然是单线程

- 多路 I/O 复用: 非阻塞 I/O [具体可看这个解答](https://www.zhihu.com/question/28594409)

- Redis 相比 Memcached 来说，拥有更多的数据结构，能支持更丰富的数据操作,此外单个 value 的最大限制是 1GB，不像 memcached 只能保存 1MB 的数据

Redis 的缺点:

- 数据库容量受到物理内存的限制，不能用作海量数据的高性能读写，因此 Redis 适合的场景主要局限在较小数据量的高性能操作和运算上。

## 值和对象

Redis 数据库里面的每个键值对（key-value pair）都是由对象（object）组成的：

- 其中, 数据库键总是一个字符串对象（string object）；
- 而数据库键的值则可以是字符串对象、 列表对象（list object）、 哈希对象（hash object）、 集合对象（set object）、 有序集合对象（sorted set object）这五种对象中的其中一种.

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

| 编码   | 作用                                                            |
| ------ | --------------------------------------------------------------- |
| int    | 整数                                                            |
| raw    | 长度>=39 的字符串:使用动态字符串（SDS）                         |
| embstr | 长度<=39 的字符串:所需的内存分配次数从 raw 编码的两次降低为一次 |

**动态字符串**（simple dynamic string,**SDS**）:

     除了用来保存数据库中的字符串值之外, SDS 还被用作缓冲区（buffer）： AOF 模块中的 AOF 缓冲区, 以及客户端状态中的输入缓冲区, 都是由 SDS 实现的

- 比起 C 字符串, SDS 具有以下优点：
- 常数复杂度获取字符串长度.
- 杜绝缓冲区溢出.
- 减少修改字符串长度时所需的内存重分配次数.
- 二进制安全.
- 兼容部分 C 字符串函数.

```sql
# 创建一个 key 为字符串对象, 值也为字符串对象的 key 值对
SET msg "hello world !!!"

# 对同一个 key 设置,会覆盖值以及存活时间
SET msg "hello world"

# EX 设置 key 的存活时间
SET msg "hello world" EX 100
# 或者
expire msg 100

# persist 可以移除存活时间
persist msg

# ttl 查看 key 存活时间
ttl msg

# strlen 查看 key 长度
strlen msg

# type 查看 key 类型
type msg

# exists 查看 key 是否存在
exists msg

# keys 搜索key(有些情况下会系统会使用scan命令来代替keys命令)
# 搜索包含 s 的key
keys *s*

# scan 搜索key .以0为游标开始搜索,默认搜索10个key.然后返回一个游标,如果游标的结果为0,那么就结束

# 在开始一个新的迭代时, 游标必须为 0
scan 0

# 以0为游标开始搜索,count指定搜索100个key
scan 0 count 100

# match 搜索包含 s 的key
scan 0 match *s* count 100

# type 搜索不同对象的key
scan 0 count 100 type list

# renamenx 改名,如果a存在,那么改名失败
renamenx msg a

# move 将当前数据库的的 key ,移动到其他数据库
move msg 1
# select 选择数据库1
select 1
# 查看msg
get msg

# dbsize 统计当前数据库的 key 数量
dbsize

# swapdb 交换不同数据库的key
swapdb 0 1

# flushdb 删除当前数据库的所有key
flushdb

# flushall 删除所有数据库的所有key
flushall

# shutdown 关闭redis-server,所有客户端也会被关闭
shutdown

# 导出 csv 文件
hset n a 1 b 2 c 3
redis-cli --csv hgetall n > stdout.csv 2> stderr.txt
```

在 `iredis` 下的显示[跳转至 iredis 的介绍](#iredis)
![avatar](/Pictures/redis/string1.png)

在 `gui` 下的显示[跳转至 gui 的介绍](#gui)
![avatar](/Pictures/redis/string.png)

```sql
# setnx 如果健不存在,才创建
# 因为msg健已经存在,所以创建失败
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

# 如果这其中有一个健是存在的,那么都不会进行赋值
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

| 编码      | 作用                                                                                    |
| --------- | --------------------------------------------------------------------------------------- |
| ziplist   | 压缩列表：先添加到哈希对象中的键值对会在压缩列表的表头, 后添加对象中的键值对会在的表尾. |
| hashtable | 字典:字典的每个键都是一个字符串对象, 对象中保存了键值对的键和值                         |

只是把 set,get...命令,换成 hset,hget

> ```sql
> HSET 表名 域名1 域值1 域名2 域值2 ...
> ```

```sql
# 创建表名为table,并设置名为a的域(field),它的值为1
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

键值对的值是一个列表对象, 列表对象包含了 字符串对象, 字符串对象由 SDS 实现.

链表被广泛用于实现 Redis 的各种功能, 比如列表键, 发布与订阅, 慢查询, 监视器, 等等.
integers 列表键的底层实现就是一个链表, 链表中的每个节点都保存了一个整数值.

列表对象的编码: [**详情**](http://redisbook.com/preview/object/list.html)

| 编码         | 作用                                                                                                                                                                                                           |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ziplist      | 每个压缩列表节点（entry）保存了一个列表元素                                                                                                                                                                    |
| linkedlist   | 每个双端链表节点（node）都保存了一个字符串对象,而每个字符串对象都保存了一个列表元素.                                                                                                                           |
| 　 quickList | zipList 和 linkedList 的混合体,它将 linkedList 按段切分,每一段使用 zipList 来紧凑存储,多个 zipList 之间使用双向指针串接起来.默认的压缩深度是 0,也就是不压缩.压缩的实际深度由配置参数 list-compress-depth 决定. |

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
# RPOPLPUSH 把 l 最后一个值,放到 ll 第一位
rpoplpush l ll

# RPOPLPUSH 把自己的最后一个值,放到第一位
rpoplpush ll ll
```

![avatar](/Pictures/redis/list4.png)

```sql

# brpop 在阻塞时间内(0表示无限等待),对空 key 移除第一个值
# blpop 在阻塞时间内(0表示无限等待),对空 key 移除最后一个值
# brpoplpush 是 rpoplpush 的阻塞版本
# 在 MULTI / EXEC 块当中没有意义
brpop l 100
```

![avatar](/Pictures/redis/list.gif)

```sql
# 查看ll的第1个值(注意:0表示第1个值)
lindex ll 0

# 查看ll的第2个值(注意:1表示第2个值)
lindex ll 1

# 查看ll的最后一个值
lindex ll -1

# 在第一个a值,前面插入b值
linsert ll before a b

# 在第一个a值,后面插入1值
linsert ll after a 1

# 将ll的第一个值修改为hello
lset ll 0 hello

# 只保留 前两个值(注意:0表示第1个值,1表示第2个值)
ltrim ll 0 1

# 移除两个b值
lrem ll 2 b
```

**sort 排序**: 只能对 _数字_ 或者 _字符串_ 进行排序(默认会按数字排序,如果有数字和字符串会报错)

```sql
# 新建两个列表
lpush gid 1 3 5 2 0
lpush name apple joe john

sort gid

# 倒序
sort gid desc

# 按字符排序
sort name alpha

# limit 进行筛选,倒序显示第 2 个到第 4 个
sort gid limit 2 4 desc
```

`by` 通过**字符串对象的值**来对 list 进行排序:

```sql
# 新建 uid 列表
lpush uid 1 2 3

# 新建三个字符串
set level1 100
set level2 10
set level3 1000

sort uid

# 通过level的大小对uid排序
sort uid by level*
```

![avatar](/Pictures/redis/list6.png)

`get` 通过 list 的顺序对 字符串 进行排序(反过来的 by)：

```sql
# 新建三个字符串
set name1 joe
set name2 john
set name3 xiaoming

# 通过uid的顺序,对 name 进行排序
sort uid get name*
# 对 name , level 进行排序
sort uid get name* get level*

# by 一个不存在的key(我这里是not).get的key值,不会进行排序
sort uid by not get name* get level*

# store 将结果,保存为新的列表key(注意会覆盖已经存在的列表key)
sort uid get name* get level* store name-level
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

# 数字和字符都有的集合,编码为hashtable
sadd s test

# 再次查看编码发现已经变为hashtable
object encoding s
```

![avatar](/Pictures/redis/set.png)

那如果一个集合,包含数和字符串,把字符串的值删除后.**编码**会变吗？

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

答案是没有变,还是 `hashtable`

![avatar](/Pictures/redis/set1.png)

```sql
# 查看集合个数
scard jihe

# 查看集合是否有test值.有返回1,无返回0
sismember jieh "test"

# 搜索jihe包含 t 的字符
sscan jihe 0 match *t*

# 删除集合里的test,test1值
srem jihe test test1

# 将jihe里的值123,移到jihe1
smove jihe jihe1 123

# 删除随机一个数
spop jihe

# 查看随机一个数
srandmember jihe
```

#### 交集,并集,补集

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

# 返回交集,并集,补集的数量
sinterstore sss ssss
sunionstore sss ssss
sdiffstore sss ssss
```

![avatar](/Pictures/redis/set2.png)

### sorted set (有序集合)

有序集合对象的编码: [**详情**](http://redisbook.com/preview/object/sorted_set.html)

| 编码     | 作用                                                                                                                                                                            |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ziplist  | 每个集合是两个节点来保存, 第一个节点保存元素的成员（member）, 而第二个元素则保存元素的分值（score）.集合按分值从小到大进行排序, 分值较小的元素放在表头, 而分值较大的元素在表尾. |
| skiplist | 使用 zset 结构作为底层实现, 一个 zset 结构同时包含一个字典和一个跳跃表                                                                                                          |

**ziplist:** (其余情况使用 skiplist)

- 有序集合保存的成员(member)数量小于 128 个.
  配置参数:(zset-max-ziplist-entries)

- 成员(member)的长度都小于 64 字节.
  配置参数:(zset-max-ziplist-value)

```sql
# 新建有序集合名为z
zadd z 1 a 1 b 2 c 3 d
zadd z 1 100

# 查看z
zrange z 0 -1 withscores

# 倒序查看z
zrevrange z 0 -1 withscores

# 查看z的score总数
zcard z

# 查看a值是那个score值
zscore z a

# 查看a值的score排名(排名以 0 为底)
zrank z a

# 倒序a值的score排名(排名以 0 为底)
zrevrank z a

# 统计a值到b值的之间个数(包含a,b值)
zlexcount z [a [b

# 对成员100的score加1000
zincrby z 1000 100

# 统计score值是1到100的个数
zcount z 1 100

# 查看socre值是1到100的成员
ZRANGEBYSCORE z 1 100
# 查看所有socre值的成员
ZRANGEBYSCORE z -inf inf

# 倒序
ZREVRANGEBYSCORE z 100 1
ZREVRANGEBYSCORE z inf -inf

# 删除成员
zrem z a

# 删除前两个成员
zremrangebyrank z 0 1

# 删除score为2到3的所有成员(包括2,3)
ZREMRANGEBYSCORE z 2 3

# 删除从开头到c的成员(包括c)
zadd zz 1 a 1 b 2 c 3 d
zremrangebylex zz - [c

# 删除从开头到c的成员(不包括c)
zadd zzz 1 a 1 b 2 c 3 d
zremrangebylex zzz - (c


# 删除从a开头到c的成员(不包括c)
zadd zzzz 1 a 1 b 2 c 3 d
zremrangebylex zzzz [aaa (c
```

#### 交集,并集

**ZUNIONSTORE (并集)**

> ```sql
> ZUNIONSTORE 新建的有序集合名 合并的数量 有序集合1 有序集合2... WEGHTS 有序集合1的乘法因子 有序集合2的乘法因子...
> ```

```sql
# 新建三个有序集合
zadd z1 1 a1 2 b1 3 c1 4 d1 5 e1
zadd z2 1 a2 2 b2 3 c2 4 d2 5 e2
zadd z3 1 a3 3 b3 3 c3 4 d3 5 e3

# 将z1,z2,z3 并集到名为 unionz 的有序集合(3表示合并3个有序集合也就是z1,z2,z3)
zunionstore unionz 3 z1 z2 z3
```

![avatar](/Pictures/redis/sortset.png)

使用 WIGHTS 给 不同的有序集合 分别 指定一个乘法因子来改变排序 (默认设置为 1 )

```sql
# z1的值乘1,z2乘10,z3乘100
zunionstore unionz 3 z1 z2 z3 WEIGHTS 1 10 100
```

![avatar](/Pictures/redis/sortset1.png)

```sql
# 这次是z2乘10,z3乘100
zunionstore unionz 3 z1 z2 z3 WEIGHTS 1 100 10
```

![avatar](/Pictures/redis/sortset2.png)

```sql
# z1,z2乘10,z3乘10
zunionstore unionz 3 z1 z2 z3 WEIGHTS 1 1 10
```

![avatar](/Pictures/redis/sortset3.png)

**ZINTERSTORE (交集)**

```sql
# 新建math(数学分数表) 小明100分,小红60分
zadd math 100 xiaoming 60 xiaohong

# 新建历史(历史分数表) 小明50分,小红90分
zadd history 50 xiaoming 90 xiaohong

# 通过zinterstore 交集进行相加
zinterstore sum 2 math history
```

![avatar](/Pictures/redis/sortset4.png)

## hyper log

```sql
# 新建pf1,pf2
pfadd pf1 1 2
pfadd pf2 a b

# 查看pf1的数量
pfcount pf1

# 合并为一个pfs
pfmerge pfs pf1 pf2
```

## transaction (事务)

```sql
# 新建一个key
set t 100

# 开启事务
multi
# 修改key
incr t

# 保存事务
exec
# 如果不保存,discard可以恢复事务开启前
discard
```

watch 监视一个(或多个) key ,如果在事务执行之前这个(或这些) key 被其他命令所改动,那么事务将被打断.

这里我开启了两个客户端,右边在事务过程中 `incr t` 后,被左边执行 `set t 100` 修改了 t 的值.所以右边在 `exec` 保存事务后,返回(nil).事务对 t 值的操作被取消
![avatar](/Pictures/redis/t.gif)

## Lua 脚本

eval 命令 执行 lua 脚本 [Lua 教程](https://www.runoob.com/lua/lua-tutorial.html)

```sql
# return 1 (0表示传递参数的数量)
eval "return 1" 0

# return 123
eval "return {1,2,3}" 0

# return key和值(这里是a和123)
eval "return {KEYS[1],ARGV[1]}" 1 a 123
eval "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 a b 123 321
```

```sql
# script load 会把脚本缓存进服务器,并返回hash(SHA1)值
script load "return {1,2,3}"

# evalsha 执行哈希值的脚本(一般情况下执行eval命令,底层会转换为执行evalsha)
evalsha <hash> 0

# 查看脚步是否在缓存
script exists "<hash>"

# 清空脚本缓存
SCRIPT FLUSH

# 杀死目前正在执行的脚本
SCRIPT KILL
```

![avatar](/Pictures/redis/lua.png)

redis.call or pcall()过程中 Redis 类型转换为 Lua 类型，然后结果再转换回 Redis 类型，结果与初始值相同

```sql
# set a 123
eval "return redis.call('set','KEYS[1]','123')" 1 a

# get a
eval "return redis.call('get','a')" 0
```

**for 语句:**

> ```lua
> for i=1,10 do
>   print(i)
> end
> ```

```sql
# 循环512次，插入列表
EVAL "for i=1,512 do
    redis.call('RPUSH', KEYS[1], i)
    return 1
end" 1 integers

EVAL "for i=1,512 do
    redis.call('ECHO', i)
    return 1
end"

EVAL "for i=1,512 do
    redis.call('RPUSH', KEYS[1], i)
    redis.call('RPUSH', KEYS[2], i)
    return 1
end" 2 integers integers2
```

if 语句:

> ```lua
> if(布尔表达式)
> then
> --[ 布尔表达式为 true 时执行该语句块 --]
> else
> --[ 布尔表达式为 false 时执行该语句块 --]
> end
> ```

```sql
# 判断key1是否存在，不存在则执行循环赋值
EVAL "if redis.call('EXISTS', KEYS[1]) == 0 then
    for i=1,512 do redis.call('RPUSH', KEYS[1], i) end
end" 1 integers
```

## python

- [官方文档](https://pypi.org/project/redis/)

- `hash`类型对应python的`dict字典`类型

```py
import redis
r = redis.Redis()

# 防止redis连接失败,在r = redis.Redis()后,可以try: r.client()
try:
    r.client()
except redis.exceptions.ConnectionError:
    r.close()
    return 1

# set
r.mset({'1': 'google', '2': 'baidu'})
r.get('1')

# pipe缓冲区队列.当execute()才会执行
pipe = r.pipeline()
# 关闭事务
pipe = r.pipeline(transaction=False)
pipe.set('foo', 'bar')
pipe.get('foo')
pipe.execute()
# 或者
pipe.set('foo', 'bar').get('foo').execute()
```

## 配置

### config

配置文件在 `/etc/redis.conf` 目录

```sql
# config get 查看所有配置
config get *

# 查看所有以r开头的配置
config get r*

# 查看密码
config get requirepass

# config set 设置密码
config set requirepass YouPassword

# 之后登陆的客户端都要验证密码
auth YouPassword

# 清除密码(要重启redis-server才会生效)
config set requirpass ""

# 将 config set 的修改写入到 redis.conf 中(不写入,重启redis-server后修改会失效)
config rewrite
```

### info

[info 详情](http://redisdoc.com/client_and_server/info.html)

```sql
# 查看信息
info

# 查看cpu信息
info cpu

# 重置 info 命令中的某些统计数据
config resetstat
```

查看 `memory` 信息:

```sql
info memory
```

- rss > used ,且两者的值相差较大时,表示存在（内部或外部的）内存碎片.
- used > rss ,表示 Redis 的部分内存被操作系统换出到交换空间了,在这种情况下,操作可能会产生明显的延迟.

### 用户密码

redis 6.0 以上的版本

[**ACL:**](https://redis.io/topics/acl)

```sql
# 查看用户列表
acl list

# 创建用户test
acl setuser test

# 创建用户tz,并设置密码123,授予 get 权限
acl setuser tz on >123 ~cached:* +get

# 授予 set 权限
acl setuser tz +set

# 授予 all 所有权限
acl setuser tz +@all

# 查看用户详情
acl getuser tz

# 禁用用户
acl setuser tz off

# 切换用户
auth tz 123
```

### 调试

```sql
# 测试客户端与服务器的连接
ping

# 打印信息
echo "print message"

# 查看key的编码
set a 1
object encoding a

# 查看key的空闲时间(set和get都会刷新空闲时间)
object idletime a

# 查看引用次数(值如果是字符串那么为1,如果是数字为2147483647)
object REFCOUNT a

# 查看key的编码,idle等信息
debug object a
```

#### slowlog

```sql
# 查看 slowlog 配置
config get slow*
```

- `slowlog-max-len`: 最多能保存多少条日志
- `slowlog-log-slower-than`: 执行时间大于多少微秒(microsecond,1 秒 = 1,000,000 微秒)的查询进行记录

![avatar](/Pictures/redis/slow.png)

```sql
# 查看 slowlog
slowlog get

# 查看当前 slowlog 的数量(一个是当前日志的数量,slower-max-len 是允许记录的最大日志的数量)
slowlog len

# 清空 slowlog
slowlog reset
```

#### monitor

```sql
monitor
```

![avatar](/Pictures/redis/monitor.gif)

#### migrate (迁移)

将 **key** 移动到另一个 **redis-server**

我这里左边是 `127.0.0.1:6379`,右边是 `127.0.0.1:7777`
![avatar](/Pictures/redis/migrate.gif)

### client

```sql
# 查看当前客户端名字
client getname

# 设置名字
client setname tz

# 查看当前客户端id
client id

# 查看所有客户端
client list

# 关闭客户端(不过即使关闭了,一般会自动重新连接)
client kill 127.0.0.1:56352
```

### 远程登陆

**server (服务端)：**

```sql
# 关闭保护模式
CONFIG SET protected-mode no

# 在/etc/redis.conf文件.把bind修改为0.0.0.0 (*表示允许所有ip)
bind 0.0.0.0
# 也可以加入客户端的 ip
bind 127.0.0.1 You-Client-IP

# 写入 /etc/redis.conf 文件
config set rewrite

# 关闭防火墙
iptable -F

# 最后重启redis-server
```

**client (客户端)：**

```sh
# 关闭防火墙
iptable -F

# 连接服务器的 redis
redis-cli -h You-Server-IP -p 6379
```

## persistence (持久化) RDB AOF

**RDB :**

- 在默认情况下， Redis 将数据库快照保存在名字为 dump.rdb 的二进制文件中。

- 你可能会至少 5 分钟才保存一次 RDB 文件。 在这种情况下， 一旦发生故障停机， 你就可能会丢失好几分钟的数据。RDB 适合冷备份

**AOF (append only log):**

- AOF 文件是一个只进行追加操作的日志文件(类似于 mysql 的 binlog),所以随着写入命令的不断增加, AOF 文件的体积也会变得越来越大

- 每次有新命令追加到 AOF 文件时就执行一次 fsync ：非常慢，也非常安全

- AOF 的时间是 1 秒，也就是可能会丢失 1 秒的数据. AOF 适合热备份

当两种持久化共存时，Redis 会使用 **AOF** 进行数据恢复.

RDB 快照:

```sql
# 主动执行保存快照rdb
save

# 查看 rdb 配置
config get save
```

![avatar](/Pictures/redis/config.png)

上面 save 参数的三个值表示：以下三个条件随便满足一个,就触发一次保存.

- 3600 秒内最少有 1 个 key 被改动
- 300 秒内最少有 100 个 key 被改动
- 60 秒内最少有 10000 个 key 被改动

AOF:

```sql
# 查看 appendonly 配置
config get append*

# 主动执行 AOF 重写
bgrewriteaof
```

关闭 **RDB** 开启 **AOF**

```sql
# 关闭 RDB
config set save ""

# 开启 AOF
config set appendonly yes

# 写入 /etc/redis.conf 配置文件
config rewrite
```

通过 aof 文件恢复删除的数据

```sql
# 设置key
set a 123

# 再把它删了
del a
```

打开 `/var/lib/redis/appendonly.aof` 文件，把和 **del** 相关的行删除

![avatar](/Pictures/redis/aof.png)

删除后：

![avatar](/Pictures/redis/aof1.png)

```sh
# 然后使用redis-check-aof 修复 appendonly.aof 文件
redis-check-aof --fix /var/lib/redis/appendonly.aof

# 重启redis-server后，key就会恢复
```

演示:
![avatar](/Pictures/redis/aof.gif)

## master slave replication (主从复制)

Redis 主从架构可实现高并发，也就是 **master (主服务器)** 负责写入，**slave (从服务器)** 读取.

![avatar](/Pictures/redis/slave2.png)

也可以主服务器关闭持久化，在从服务器开启持久化，当主服务器崩溃时，转换主从服务器的角色，并能同步

复制原理：

- slave 向 master 发送一个 `sync` 命令.

- 接到 `sync` 命令的 master 将开始执行 `BGSAVE` 生成最新的 rdb 快照文件(因此 master 必须开启持久化). 在此同步期间, 所有新执行的写入命令会保存到一个缓冲区里面.

- 当 `BGSAVE` 执行完毕后, master 把 .rdb 文件发送给 slave. slave 接收到后, 将文件中的数据载入到内存中.

- slave 第一次 sync 会全部复制，而之后会进行部分数据复制

`repl-diskless-sync` 参数:

- yes 表示在内存里生成 rdb 后同步

- no 表示写入硬盘 rdb 后同步

![avatar](/Pictures/redis/slave.png)

当 slave 与 master 连接断开后重连进行增量复制

![avatar](/Pictures/redis/slave1.png)

```sql
# 打开 主从复制 连接6379服务器
slaveof 127.0.0.1 6379

# 查看当前服务器在主从复制扮演的角色
role

# 关闭 主从复制
slaveof no one
```

**本地**主从复制：

- 左边连接的是 127.0.0.1:6379 主服务器
- 右边连接的是 127.0.0.1:7777 从服务器

![avatar](/Pictures/redis/slave.gif)

**远程**主从复制：

- 左边连接的是 虚拟机 192.168.100.208:6379 主服务器
- 右边连接的是 本机 127.0.0.1:6379 从服务器

![avatar](/Pictures/redis/slave1.gif)

建议设置 slave(从服务器) **只读** `replica-read-only`:

> 在复制过程(slaveof ip port),slave(从服务器)不能使用 set 等命令,避免数据不一致的情况.
>
> 因为主从复制是单向复制，修改 slave 节点的数据， master 节点是感知不到的.

```sql
# 查看 replica-read-only
config get replica-read-only

# 设置 replica-read-only yes
config set replica-read-only yes
```

以下是关闭 slave 节点只读 后的演示:

- 右边连接的是 127.0.0.1:6380 从服务器,在 slaveof 过程中无法使用 set 写入，执行 config set replica-read-only no 后，便可以使用 set

![avatar](/Pictures/redis/slave2.gif)

## sentinel (哨兵模式)

Sentinel 会不断地检查你的主服务器和从服务器是否运作正常: [详情](http://redisdoc.com/topic/sentinel.html)

### 开启 sentinal

> ```sql
> # 命令
> sentinel monitor <name> 127.0.0.1 6379 <quorum>
> ```

quorum = 1 一哨兵一主两从架构:[更多详情](https://github.com/doocs/advanced-java/blob/master/docs/high-concurrency/redis-sentinel.md)

```
+----+         +----+
| M1 |---------| R1 |
| S1 |         | S2 |
+----+         +----+
```

quorum = 2 两哨兵一主三从架构:

```
       +----+
       | M1 |
       | S1 |
       +----+
          |
+----+    |    +----+
| R2 |----+----| R3 |
| S2 |         | S3 |
+----+         +----+
```

**sentinel** 配置文件 `/etc/sentinel.conf`加入以下代码:

```sh
#允许后台启动
daemonize yes

# 仅仅只需要指定要监控的主节点 1
sentinel monitor YouMasterName 127.0.0.1 6379 1

# 主观下线的时间(这里为60秒)
sentinel down-after-milliseconds YouMasterName 60000

# 当主服务器失效时， 在不询问其他 Sentinel 意见的情况下， 强制开始一次自动故障迁移
sentinel failover-timeout YouMasterName 5000

# 在执行故障转移时， 最多可以有多少个从服务器同时对新的主服务器进行同步， 这个数字越小， 完成故障转移所需的时间就越长。
sentinel parallel-syncs YouMasterName 1
```

开启 sentiel 服务器

```sh
redis-sentinel /etc/sentinel.conf
# 或者
redis-server /etc/sentinel.conf --sentinel
```

**sentinel** 端口为`26379`

```sh
# 连接 sentinel
redis-cli -p 26379
```

### sentinel 的命令

```sql
# 查看监听的主机
sentinel masters

# 查看 Maseter name
sentinel get-master-addr-by-name YouMasterName

# 通过订阅进行监听
PSUBSCRIBE *
```

我这里一共 4 个服务器(**一哨兵一主两从架构**):

- 左上连接的是 127.0.0.1:6379 主服务器
- 左下连接的是 127.0.0.1:6380 从服务器
- 右上连接的是 127.0.0.1:6381 从服务器
- 右下连接的是 127.0.0.1:26379 哨兵服务器

![avatar](/Pictures/redis/sentinel.png)

```sql
# 为了方便实验 哨兵的主观下线时间 我改为了 1 秒
sentinel down-after-milliseconds YouMasterName 1000
```

可见把 **6379** 主服务器关闭后，6380 成为新的主服务器:

![avatar](/Pictures/redis/sentinel.gif)

6379 重新连接后成为 **6380** 的从服务器:

![avatar](/Pictures/redis/sentinel1.gif)

## cluster (集群)

Redis 集群不像单机 Redis 那样支持多数据库功能， 集群只使用默认的 0 号数据库， 并且不能使用 SELECT index 命令。[详情](https://mp.weixin.qq.com/s?src=11&timestamp=1604973763&ver=2697&signature=sfP3uoHQVifP6D8FsI*YtxzMzvqbDieWDj1R8J8iT5codhR2A3LGWF46jHQ8mKJk*RZ4qXixc7DUACwbXbU2-MhaJ2P2Tr0YF-eLIVBPrKdvlX*YGM8UGtJoOR1ee3oB&new=1)

```sql
# 查看 集群 配置
config get cluster*
```

配置 6 个实例,从端口 6380 到 6385:

```sh
# 这是6380
port 6380
daemonize yes
pidfile "/var/run/redis-6380.pid"
logfile "6380.log"
dir "/var/lib/redis/6380"

replica-read-only yes

cluster-enabled yes
cluster-config-file nodes.conf

# 每个节点每秒会执行 10 次 ping，每次会选择 5 个最久没有通信的其它节点。当然如果发现某个节点通信延时达到了 cluster_node_timeout / 2
cluster-node-timeout 15000
```

开启 6 个实例:

```sh
# 通过for循环,开启6个实例
for (( i=6380; i<=6385; i=i+1 )); do
    redis-server /var/lib/redis/$i/redis.conf
done
```

![avatar](/Pictures/redis/cluster.png)

开启集群:

```sh
redis-cli --cluster create 127.0.0.1:6380 127.0.0.1:6381 127.0.0.1:6382 127.0.0.1:6383 127.0.0.1:6384 127.0.0.1:6385 --cluster-replicas 1
```

![avatar](/Pictures/redis/cluster1.png)
![avatar](/Pictures/redis/cluster2.png)

```sh
# -c 参数连接集群
redis-cli -c -p 6380
```

可以看到 set name tz 是在 6381 实例，手动把 6381 kill 掉,

重新连接后 get name 变成了 6384 实例

![avatar](/Pictures/redis/cluster.gif)

Redis 集群包含 16384 个哈希槽（hash slot),每个节点负责处理一部分哈希槽,以及一部分数据

![avatar](/Pictures/redis/cluster7.png)

```sql
# 查看每个node(节点),等同于nodes.conf文件
cluster nodes
```

我这里是:

- node 6380 负责 0-5460 slots
- node 6384 负责 5461-10922 slots
- node 6385 负责 10923-16383 slots

![avatar](/Pictures/redis/cluster3.png)

```sql
# 查看每个node(节点) 的 slots(槽)
cluster slots
```

我这里是:

- 6383 是 6380 的从节点
- 6381 是 6384 的从节点
- 6382 是 6385 的从节点

![avatar](/Pictures/redis/cluster4.png)

也可以在 shell 里执行，通过 grep 显示:

```sh
# master
redis-cli -p 6380 cluster nodes | grep master

# slave
redis-cli -p 6380 cluster nodes | grep slave
```

![avatar](/Pictures/redis/cluster5.png)

关闭主节点 6384:

```sh
# 等同于kill
redis-cli -p 6384 debug segfault
```

可以看到原属于 6384 的从节点 6381,现在变成了主节点(master)

![avatar](/Pictures/redis/cluster6.png)

这时再关闭主节点 6381:

```sh
redis-cli -p 6381 debug segfault
```

因为 6381 已经没有从节点了，可以看到整个 cluster 已经 down 掉了

![avatar](/Pictures/redis/cluster1.gif)

重新启动 6381 或者 6384 后会恢复集群

## publish subscribe (发布和订阅)

只能在同一个 `redis-server` 下使用

> ```sql
> # 发布
> pubhlish 订阅号 内容
> ```

> ```sql
> # 订阅
> subscribe 订阅号1 订阅号2
> ```

我这里一共三个客户端.左边为发布者;右边上订阅 rom,rom1;右边下只订阅 rom

![avatar](/Pictures/redis/subscribe.gif)

`psubscribe` 通过通配符,可以匹配 rom,rom1 等订阅.

- psubscribe 信息类型为 `pmessage`
- subscribe 信息类型为 `message`

```sql
psubscribe rom*
```

![avatar](/Pictures/redis/subscribe1.gif)

### 键空间通知

接收那些以某种方式改动了 Redis 数据集的事件。[详情](http://redisdoc.com/topic/notification.html)

```sql
# 开启键空间通知
config set notify-keyspace-events "AKE"
```

```sql
# 订阅监听key
psubscribe '__key*__:*
```

![avatar](/Pictures/redis/keyspace.png)

# redis 如何做到和 mysql 数据库的同步

- 1.  读: 读 redis->没有，读 mysql->把 mysql 数据写回 redi

- 写: 写 mysql->成功，写 redis（捕捉所有 mysql 的修改，写入和删除事件，对 redis 进行操作）

- 2.  分析 MySQL 的 binlog 文件并将数据插入 Redis

- 借用已经比较成熟的 MySQL UDF，将 MySQL 数据首先放入 Gearman 中，然后通过一个自己编写的 PHP Gearman Worker，将数据同步到 Redis

# redis 安装

## centos7 安装 redis6.0.9

源码安装:

```sh
# 安装依赖
yum install gcc make -y

# 官网下载
curl -LO https://download.redis.io/releases/redis-6.0.9.tar.gz

# 国内用户可以去华为云镜像下载 https://mirrors.huaweicloud.com/redis/
curl -LO https://mirrors.huaweicloud.com/redis/redis-6.0.9.tar.gz
tar xzf redis-6.0.9.tar.gz
cd redis-6.0.9
make
```

使用 `yum` 包管理器安装:

```sh
# epel源可以直接安装(版本为redis-3.2.12-2.el7)
yum install redis -y
```

## [docker install](https://www.runoob.com/docker/docker-install-redis.html)

```sh
# 下载镜像
docker pull redis

# 查看本地镜像
docker images

# -p端口映射
docker run -itd --name redis-tz -p 6379:6379 redis

# 查看运行镜像
docker ps

# 进入docker
docker exec -it redis-tz /bin/bash

docker container stop redis-tz

docker run -d -p 6379:6379 -v $PWD/conf/redis.conf:/usr/local/etc/redis/redis.conf -v $PWD/data:/data --name docker-redis docker.io/redis redis-server /usr/local/etc/redis/redis.conf --appendonly yes
```

# 常见错误

## vm.overcommit_memory = 1

内存分配策略
/proc/sys/vm/overcommit_memory

0: 表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存:内存申请允许；否则:内存申请失败:并把错误返回给应用进程.
1: 表示内核允许分配所有的物理内存:而不管当前的内存状态如何.
2: 表示内核允许分配超过所有物理内存和交换空间总和的内存

```sh
# 修复
echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
sysctl -p
```

## 高效强大的第三方 redis 软件
[一键安装脚本](https://github.com/ztoiax/userfulscripts/blob/master/awesome-redis.sh)

<span id="iredis"></span>

### [iredis](https://github.com/laixintao/iredis)

- 更友好的补全和语法高亮的终端(cli)

![avatar](/Pictures/redis/iredis.png)

[其他客户端](https://redis.io/clients#c)

### [redis-tui](https://github.com/mylxsw/redis-tui)

- 更友好的补全和语法高亮,有输出,key 等多个界面的终端(tui)

![avatar](/Pictures/redis/redis-tui.png)

### [redis-memory-analyzer](https://github.com/gamenet/redis-memory-analyzer)

- `RMA`是一个控制台工具,用于实时扫描`Redis`关键空间,并根据关键模式聚合内存使用统计数据

```sh
# 默认只会输出一遍,可以用 watch 进行监控(变化的部分会高亮显示)
watch -d -n 2 rma
```

![avatar](/Pictures/redis/rma.png)

<span id="gui"></span>

### [AnotherRedisDesktopManager](https://github.com/qishibo/AnotherRedisDesktopManager)

- 一个有图形界面的`Redis`的桌面客户端,其中也可以显示 刚才提到的 `rma` 的内存数据

![avatar](/Pictures/redis/redis-gui.png)

### [RedisLive](https://github.com/nkrode/RedisLive)

### [redis-rdb-tools](https://github.com/sripathikrishnan/redis-rdb-tools)

```sh
# json格式 查看
rdb --command json dump.rdb
```

![avatar](/Pictures/redis/rdbtool.png)

```sh
rdb -c memory dump.rdb
# 导出 csv 格式
rdb -c memory dump.rdb > /tmp/redis.csv
```

![avatar](/Pictures/redis/rdbtool1.png)

### [redis-shake](https://github.com/alibaba/RedisShake)

Redis-shake 是一个用于在两个 redis 之间同步数据的工具，满足用户非常灵活的同步、迁移需求。

- [中文文档](https://developer.aliyun.com/article/691794)

- [第一次使用，如何进行配置？](https://github.com/alibaba/RedisShake/wiki/%E7%AC%AC%E4%B8%80%E6%AC%A1%E4%BD%BF%E7%94%A8%EF%BC%8C%E5%A6%82%E4%BD%95%E8%BF%9B%E8%A1%8C%E9%85%8D%E7%BD%AE%EF%BC%9F)

### [dbatools](https://github.com/xiepaup/dbatools)

![avatar](/Pictures/redis/dbatools.png)

# reference

- [《Redis 设计与实现》部分试读](http://redisbook.com/)
- [《Redis 使用手册》](http://redisdoc.com/)
- [《Redis 实战》部分试读](http://redisinaction.com/)
- [Redis 官方文档](https://redis.io/documentation)
- [Redis 所有命令说明](https://redis.io/commands#)
- [Redis 知识扫盲](https://github.com/doocs/advanced-java#%E7%BC%93%E5%AD%98)

# online tool

- [在线 redis](https://try.redis.io/)
- [在线 PhpRedisAdmin](http://dubbelboer.com/phpRedisAdmin/)

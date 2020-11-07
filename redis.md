<!-- vim-markdown-toc GFM -->

* [Redis 入门教程](#redis-入门教程)
    * [值和对象](#值和对象)
        * [string (字符串)](#string-字符串)
        * [hash (哈希散列)](#hash-哈希散列)
        * [list (列表)](#list-列表)
        * [set (集合)](#set-集合)
            * [交集，并集，补集](#交集并集补集)
        * [sorted set (有序集合)](#sorted-set-有序集合)
            * [交集，并集](#交集并集)
    * [hyper log](#hyper-log)
    * [transaction (事务)](#transaction-事务)
    * [Lua 脚本](#lua-脚本)
    * [配置](#配置)
        * [config](#config)
        * [info](#info)
        * [调试](#调试)
            * [slowlog](#slowlog)
            * [monitor](#monitor)
            * [migrate (迁移)](#migrate-迁移)
        * [client](#client)
* [常见错误](#常见错误)
    * [vm.overcommit_memory = 1](#vmovercommit_memory--1)
    * [高效强大的第三方 redis 软件](#高效强大的第三方-redis-软件)
        * [iredis](#iredis)
        * [redis-tui](#redis-tui)
        * [redis-memory-analyzer](#redis-memory-analyzer)
        * [AnotherRedisDesktopManager](#anotherredisdesktopmanager)
        * [RedisLive](#redislive)
        * [redis-rdb-tools](#redis-rdb-tools)
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

| 编码   | 作用                                                            |
| ------ | --------------------------------------------------------------- |
| int    | 整数                                                            |
| raw    | 长度>=39 的字符串:使用动态字符串（SDS）                         |
| embstr | 长度<=39 的字符串:所需的内存分配次数从 raw 编码的两次降低为一次 |

**动态字符串**（simple dynamic string，**SDS**）:

     除了用来保存数据库中的字符串值之外， SDS 还被用作缓冲区（buffer）： AOF 模块中的 AOF 缓冲区， 以及客户端状态中的输入缓冲区， 都是由 SDS 实现的

- 比起 C 字符串， SDS 具有以下优点：
- 常数复杂度获取字符串长度。
- 杜绝缓冲区溢出。
- 减少修改字符串长度时所需的内存重分配次数。
- 二进制安全。
- 兼容部分 C 字符串函数。

```sql
# 创建一个 key 为字符串对象， 值也为字符串对象的 key 值对
SET msg "hello world !!!"

# 对同一个 key 设置，会覆盖值以及存活时间
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

# 在开始一个新的迭代时， 游标必须为 0
scan 0

# 以0为游标开始搜索,count指定搜索100个key
scan 0 count 100

# match 搜索包含 s 的key
scan 0 match *s* count 100

# type 搜索不同对象的key
scan 0 count 100 type list

# renamenx 改名,如果a存在，那么改名失败
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
| --------- | ----------------------------------------------------------------------------------------- |
| ziplist   | 压缩列表：先添加到哈希对象中的键值对会在压缩列表的表头， 后添加对象中的键值对会在的表尾。 |
| hashtable | 字典:字典的每个键都是一个字符串对象， 对象中保存了键值对的键和值                          |

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

| 编码         | 作用                                                                                                                                                                                                                  |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ziplist      | 每个压缩列表节点（entry）保存了一个列表元素                                                                                                                                                                           |
| linkedlist   | 每个双端链表节点（node）都保存了一个字符串对象，而每个字符串对象都保存了一个列表元素。                                                                                                                                |
| 　 quickList | zipList 和 linkedList 的混合体，它将 linkedList 按段切分，每一段使用 zipList 来紧凑存储，多个 zipList 之间使用双向指针串接起来。默认的压缩深度是 0，也就是不压缩。压缩的实际深度由配置参数 list-compress-depth 决定。 |

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

# limit 进行筛选，倒序显示第 2 个到第 4 个
sort gid limit 2 4 desc
```

`by` 通过**字符串对象的值**来对 list 进行排序:

```
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

# store 将结果，保存为新的列表key(注意会覆盖已经存在的列表key)
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

# 搜索jihe包含 t 的字符
sscan jihe *t*

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

### sorted set (有序集合)

有序集合对象的编码: [**详情**](http://redisbook.com/preview/object/sorted_set.html)

| 编码     | 作用                                                                                                                                                                                  |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ziplist  | 每个集合是两个节点来保存， 第一个节点保存元素的成员（member）， 而第二个元素则保存元素的分值（score）。集合按分值从小到大进行排序， 分值较小的元素放在表头， 而分值较大的元素在表尾。 |
| skiplist | 使用 zset 结构作为底层实现， 一个 zset 结构同时包含一个字典和一个跳跃表                                                                                                               |

**ziplist:** (其余情况使用 skiplist)

- 有序集合保存的成员(member)数量小于 128 个。
  配置参数:(zset-max-ziplist-entries)

- 成员(member)的长度都小于 64 字节。
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

# 统计a值到b值的之间个数(包含a，b值)
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

#### 交集，并集

**ZUNIONSTORE (并集)**

> ```sql
> ZUNIONSTORE 新建的有序集合名 合并的数量 有序集合1 有序集合2... WEGHTS 有序集合1的乘法因子 有序集合2的乘法因子...
> ```

```sql
# 新建三个有序集合
zadd z1 1 a1 2 b1 3 c1 4 d1 5 e1
zadd z2 1 a2 2 b2 3 c2 4 d2 5 e2
zadd z3 1 a3 3 b3 3 c3 4 d3 5 e3

# 将z1，z2，z3 并集到名为 unionz 的有序集合(3表示合并3个有序集合也就是z1，z2，z3)
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
# 新建math(数学分数表) 小明100分，小红60分
zadd math 100 xiaoming 60 xiaohong

# 新建历史(历史分数表) 小明50分，小红90分
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
# 如果不保存，discard可以恢复事务开启前
discard
```

watch 监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断。

这里我开启了两个客户端，右边在事务过程中 `incr t` 后，被左边执行 `set t 100` 修改了 t 的值。所以右边在 `exec` 保存事务后，返回(nil)。事务对 t 值的操作被取消
![avatar](/Pictures/redis/t.gif)

## Lua 脚本

```sql
eval "return 0" 0
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

# 将 config set 的修改写入到 redis.conf 中(不写入，重启redis-server后修改会失效)
config rewrite
```

```sql
config get save
```

![avatar](/Pictures/redis/config.png)

上面 save 参数的三个值表示：以下三个条件随便满足一个，就触发一次保存操作。

- 3600 秒内最少有 1 个 key 被改动
- 300 秒内最少有 100 个 key 被改动
- 60 秒内最少有 10000 个 key 被改动

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

- rss > used ，且两者的值相差较大时，表示存在（内部或外部的）内存碎片。
- used > rss ，表示 Redis 的部分内存被操作系统换出到交换空间了，在这种情况下，操作可能会产生明显的延迟。

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
- `slowlog-log-slower-than`: 执行时间大于多少微秒(microsecond，1 秒 = 1,000,000 微秒)的查询进行记录

![avatar](/Pictures/redis/slow.png)

```sql
# 查看 slowlog
slowlog get

# 查看当前 slowlog 的数量(一个是当前日志的数量，slower-max-len 是允许记录的最大日志的数量)
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

# 关闭客户端(不过即使关闭了，一般会自动重新连接)
client kill 127.0.0.1:56352
```

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

### [redis-rdb-tools](https://github.com/sripathikrishnan/redis-rdb-tools)

# reference

- [《Redis 设计与实现》部分试读](http://redisbook.com/)
- [《Redis 使用手册》](http://redisdoc.com/)
- [《Redis 实战》部分试读](http://redisinaction.com/)

<!-- vim-markdown-toc GFM -->

* [常用命令](#常用命令)
    * [file (文件操作)](#file-文件操作)
        * [create file](#create-file)
        * [diff,patch 使用](#diffpatch-使用)
        * [make](#make)
            * [Note: 每行命令之前必须有一个 tab 键,不然会报错](#note-每行命令之前必须有一个-tab-键不然会报错)
            * [Note: 需要注意的是，每行命令在一个单独的 shell 中执行。这些 Shell 之间没有继承关系。(make var-lost），取不到 foo 的值。因为两行命令在两个不同的进程执行。一个解决办法是将两行命令写在一行，中间用分号分隔。](#note-需要注意的是每行命令在一个单独的-shell-中执行这些-shell-之间没有继承关系make-var-lost取不到-foo-的值因为两行命令在两个不同的进程执行一个解决办法是将两行命令写在一行中间用分号分隔)
        * [lsof](#lsof)
        * [rsync](#rsync)
        * [split](#split)
    * [char (字符串操作)](#char-字符串操作)
        * [tr](#tr)
        * [sed](#sed)
        * [awk](#awk)
    * [other](#other)
        * [date](#date)
        * [fuser](#fuser)
        * [列出子目录的大小，并计总大小](#列出子目录的大小并计总大小)
    * [cron](#cron)
    * [mdadm(RAID)](#mdadmraid)
        * [创建 RAID5](#创建-raid5)
        * [创建 RAID5,并设置备份磁盘](#创建-raid5并设置备份磁盘)
        * [保存配置文件](#保存配置文件)
        * [性能测试](#性能测试)
        * [硬盘装载](#硬盘装载)
        * [卸载 RAID](#卸载-raid)
* [reference](#reference)

<!-- vim-markdown-toc -->

# 常用命令

## file (文件操作)

### create file

```bash
# 对于多行内容,比普通重定向更方便
cat > FILE << "EOF"
# 内容
EOF
```

### diff,patch 使用

> ```bash
> # new文件比last文件多一行”2“
> cat last
> 1
>
> cat new
> 1
> 2
> ```

```bash
# 生产补丁
diff -Naur last new > new.diff

# 给last打上补丁后,和new一样
patch last < new.diff

cat last
1
2
```

```bash
# 撤销补丁last文件变回原样
patch -R last < new.diff

cat last
1
```

### make

make 默认根据`makefile`文件,进行构建
也可以使用`make -f RULE` 来指定文件

#### Note: 每行命令之前必须有一个 tab 键,不然会报错

```sh
make source.txt
# output
makefile:4: *** 缺失分隔符。 停止。
```

如果想用其他键，可以用内置变量`.RECIPEPREFIX`声明。

#### Note: 需要注意的是，每行命令在一个单独的 shell 中执行。这些 Shell 之间没有继承关系。(make var-lost），取不到 foo 的值。因为两行命令在两个不同的进程执行。一个解决办法是将两行命令写在一行，中间用分号分隔。

```sh
# 使用">"代替<tab>健
.RECIPEPREFIX = >
all:
> echo Hello, world
var-kept:
    export foo=bar; echo "foo=[$$foo]"
```

### lsof

列出那些文件被使用

```bash
lsof

#列出正在被监听的端口
lsof -i

# 指定程序mysql
lsof -c mysql
```

### rsync

- `-r` 递归
- `-a` 可代替-r，并且同步修改时间，权限等
- `-n` 模拟结果
- `-v` 输出
- `--delete` 删除目标目录，不存在于源目录的文件
- `--exclude` 排除文件
- `--include` 只同步指定文件，往往与--exclude 结合使用
- `--link-dest` 增量备份

```sh
rsync -av SOURCE DESTINATION

# 远程ssh push pull
rsync -av .zshrc root@192.168.100.208:/root

# 删除只存在于目标目录、不存在于源目录的文件。
rsync -av --delete source/ destination

# 增量备份，将基准和源的变动，以硬链接的同步到target
rsync -a --delete --link-dest /compare/path /source/path /target/path

# 排除txt以外所有文件
rsync -av --include="*.txt" --exclude='*' source/ destination
```

### split

```sh
# -b 二进制文件,按100M 进行拆分
split -b 100M <file>

# -C 文本文件,按100M 进行拆分
split -C 100M <file>
```

## char (字符串操作)

### tr

所有操作，以**字符**为单位

```sh
# 删除换行符
cat FILE | tr -d '\n'

# 换成大写
cat FILE | tr '[a-z]' '[A-Z]'
```

### sed

所有操作，以**行**为单位
| 参数 | 操作 |
| ---- | ---- |
| p | 打印 |
| d | 删除 |
| a | 添加 |
| i | 插入 |
| c | 替换 |

```sh
# 打印1到5行
sed -n '1,5p' FILE
# 打印从5行到结尾
sed -n '5,$p' FILE
# 打印除了第 5 到 10 之间的所有行
sed -n -e '5,10!p' inputfile

# 删除带有"192.168.100.1"的行
sed -i '/192.168.100.1/d' FILE

# 删除第1行
sed -i '1d' FILE

# 在第1行插入newline
sed -i '1inewline' FILE

# 在第1行替换成newline
sed -i '1cnewline' FILE

# 在第1行结尾添加newline
sed -i '1anewline' FILE

# 在每1行结尾添加newline
sed -i '1,$anewline' FILE

# 将包含123的所有行,替换成321
sed -i "/123/c321" FILE

# 将第1个a替换成b 类似vim的替换
sed -i 's/a/b/'  FILE
# 将文件内所有a替换成b
sed -i 's/a/b/g'  FILE

# 打印第一行和匹配 nginx
ps aux | sed '1p;/nginx/!d'
```

### awk

- `$NF` 最后 1 列
- `$NR` 行数
- `$0` 所有行
- `-F":"` 设置分隔符,默认是空格

`print` 内的操作为**列**

```sh
ll > test

# 打印行数(类似于wc -l)
awk 'END { print NR;}' test

# 打印第1列
awk '{print $1}' test

# 打印第1,5,和最后1列
awk '{print $1,$5,$NF}' test

# 打印前五行
awk 'NR <= 5' test

# 打印第5行的,第1,5,和最后1列
awk 'NR == 5 {print $1,$5,$NF}' test

# 以:为分隔符，打印第3列大于1000的行
awk -F ":" '$3 >= 1000' /etc/passwd

# 打印有apk的行的第二列(增强版grep)
awk '/apk/ { print $2}' test

# 打印有apk的行的倒数第3行和最后一行
awk '/apk/ {print $(NF-4),$NF}' test

# 第一列与第一列交换
awk '{ print $2"="$1}' test

# 打印行号加所有行(类似于cat -n)
awk '{ print NR" "$0}' test

# 打印第一行和匹配 nginx
ps aux | awk 'NR==1 || /nginx/'

# 打印第一行和匹配 从 nginx 到 vim
ps aux | awk '/nginx/,/vim/'
```

## other

### date

```bash
# 年月日
date +%Y-%m-%d
# 2020-11-27

# 时分秒
date +%H:%M:%S
# 11:50:47

# 年月日 时分秒
date +"%Y-%m-%d %H:%M:%S"
# 2020-11-27 11:50:04

#or
date +"%Y年%m月%d日 %H时%M分%S秒"
# 2020年11月27日 11时51分56秒
```

### fuser

```bash

# 查看当前分区谁在使用
fuser -vm .

# 查看10808端口进程
fuser -n tcp -v  10808
```

### 列出子目录的大小，并计总大小

```bash
du -cha --max-depth=1 . | grep -E "M|G" | sort -h
```

## cron

```sh
# .---------------- 分 (0 - 59)
# |  .------------- 时 (0 - 23)
# |  |  .---------- 日 (1 - 31)
# |  |  |  .------- 月 (1 - 12)
# |  |  |  |  .---- 星期 (0 - 7) (星期日可为0或7)
# |  |  |  |  |
# *  *  *  *  * 执行的命令
```

- `crontab -e` #编辑当前用户的任务
- `crontab -l` #显示任务
- `crontab -r` #删除所有任务

```sh
* * * * * COMMAND      # 每分钟
*/5 * * * * COMMAND    # 每5分钟
0,5,10 * * * * COMMAND # 每小时运行三次，分别在第 0、 5 和 10 分钟运行
0 3 * * * COMMAND      # 每日凌晨3点执行
0 3 1-10 * * COMMAND   # 1日到10日凌晨3点执行

# 开启服务
systemctl restart cronie.service
```

## mdadm(RAID)

| 参数 | 操作                           |
| ---- | ------------------------------ |
| -l   | raid 级别                      |
| -n   | 硬盘数量                       |
| -x   | 设置备份磁盘                   |
| -S   | 关闭 RAID(remember umount)     |
| -R   | enableRAID                     |
| -D   | 查看设备信息(cat /proc/mdstat) |

### 创建 RAID5

```sh
mdadm -C /dev/md0 -a yes -l 5 -n 3 /dev/sdb /dev/sdc /dev/sdd
```

### 创建 RAID5,并设置备份磁盘

```sh
mdadm -C /dev/md0 -a yes -l 5 -n 3 -x 1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
```

### 保存配置文件

```sh
mdadm -D --scan > /etc/mdadm.conf
```

### 性能测试

```sh
root@localhost ~# hdparm -t /dev/md0
/dev/md0:
 Timing buffered disk reads: 1418 MB in  3.01 seconds = 471.61 MB/sec

root@localhost ~# echo 3 > /proc/sys/vm/drop_caches

root@localhost ~# hdparm -t /dev/sda
/dev/sda:
 Timing buffered disk reads: 810 MB in  3.00 seconds = 269.99 MB/sec

```

### 硬盘装载

```sh
# 把sdb设置为故障
mdadm /dev/md0 -f /dev/sdb

# 移除sdb
mdadm /dev/md0 -r /dev/sdb

# 添加新的sdb
mdadm /dev/md0 -a /dev/sdb
```

### 卸载 RAID

```sh
umount /dev/md0
mdadm -S /dev/md0
mdadm --zero-superblock /dev/sdb
mdadm --zero-superblock /dev/sdc
mdadm --zero-superblock /dev/sdd
```

# reference

- [cron](https://linux.cn/article-7513-1.html)
- [cron2](https://linux.cn/article-9687-1.html)
- [rsync](http://www.ruanyifeng.com/blog/2020/08/rsync.html)
- [sed](https://linux.cn/article-6578-1-rel.html)
- [sed2](https://linux.cn/article-10232-1.html)
- [Make 命令教程](http://www.ruanyifeng.com/blog/2015/02/make.html)
- [awk 实用学习指南 | Linux 中国](https://mp.weixin.qq.com/s?__biz=MjM5NjQ4MjYwMQ==&mid=2664624200&idx=2&sn=d1c968904c55de1875907ce49b9e46f8&chksm=bdcecb0e8ab942180ca22f9ec4cb5b4c4d3e0df0d9dd6b13ff1de1e04a89ab84e724cb549a03&mpshare=1&scene=1&srcid=1012DOi5bDFPP4geI536oQfi&sharer_sharetime=1602496699415&sharer_shareid=5dbb730cd6722d0343328086d9ad7dce#rd)

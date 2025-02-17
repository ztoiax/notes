
<!-- mtoc-start -->

* [常用命令](#常用命令)
  * [file (文件操作)](#file-文件操作)
    * [create file](#create-file)
    * [paste(合并文件列)](#paste合并文件列)
    * [diff,patch 使用](#diffpatch-使用)
    * [make](#make)
      * [Note: 每行命令之前必须有一个 tab 键,不然会报错](#note-每行命令之前必须有一个-tab-键不然会报错)
      * [Note: 需要注意的是，每行命令在一个单独的 shell 中执行。这些 Shell 之间没有继承关系。(make var-lost），取不到 foo 的值。因为两行命令在两个不同的进程执行。一个解决办法是将两行命令写在一行，中间用分号分隔。](#note-需要注意的是每行命令在一个单独的-shell-中执行这些-shell-之间没有继承关系make-var-lost取不到-foo-的值因为两行命令在两个不同的进程执行一个解决办法是将两行命令写在一行中间用分号分隔)
      * [checkmake检查makefile](#checkmake检查makefile)
    * [lsof](#lsof)
    * [rsync](#rsync)
      * [UDR模式](#udr模式)
    * [scp](#scp)
    * [rsync和scp的区别](#rsync和scp的区别)
    * [restic：备份工具](#restic备份工具)
    * [split](#split)
    * [fsarchiver](#fsarchiver)
    * [find](#find)
    * [fselect: sql语句的ls](#fselect-sql语句的ls)
    * [locate:定位文件](#locate定位文件)
    * [shred：安全地抹去磁盘数据。代替rm](#shred安全地抹去磁盘数据代替rm)
  * [char (字符串操作)](#char-字符串操作)
    * [tee](#tee)
    * [column](#column)
    * [tr](#tr)
    * [cut](#cut)
    * [sed](#sed)
    * [awk](#awk)
    * [tac(反转行)](#tac反转行)
    * [paste](#paste)
    * [perl5](#perl5)
    * [perl6(Raku)](#perl6raku)
      * [module](#module)
      * [个人觉得perl6中有趣的设计](#个人觉得perl6中有趣的设计)
    * [shred：安全删除文件](#shred安全删除文件)
    * [加密文件](#加密文件)
    * [pv：显示进度条](#pv显示进度条)
  * [other](#other)
    * [xargs](#xargs)
    * [date](#date)
    * [fuser](#fuser)
    * [列出子目录的大小，并计总大小](#列出子目录的大小并计总大小)
    * [openssl](#openssl)
    * [gnuplot](#gnuplot)
    * [shellcheck](#shellcheck)
    * [jobs, fg, bg, nohup, disown, reptyr](#jobs-fg-bg-nohup-disown-reptyr)
  * [expect交互](#expect交互)
  * [调整分区大小](#调整分区大小)
  * [mdadm(RAID)](#mdadmraid)
    * [创建 RAID5](#创建-raid5)
    * [创建 RAID5,并设置备份磁盘](#创建-raid5并设置备份磁盘)
    * [保存配置文件](#保存配置文件)
    * [性能测试](#性能测试)
    * [硬盘装载](#硬盘装载)
    * [卸载 RAID](#卸载-raid)
  * [视频/图片](#视频图片)
    * [ffmpeg](#ffmpeg)
      * [-vf视频过滤器](#-vf视频过滤器)
      * [音频操作](#音频操作)
      * [图片操作](#图片操作)
      * [录屏](#录屏)
      * [plotbitrate](#plotbitrate)
    * [gif](#gif)
      * [gifview](#gifview)
      * [gifdiff](#gifdiff)
      * [convert(gif制作)](#convertgif制作)
      * [gifsicle:gif工具支持压缩、合并、编辑帧、减少帧](#gifsiclegif工具支持压缩合并编辑帧减少帧)
* [reference](#reference)

<!-- mtoc-end -->

# 常用命令

## file (文件操作)

### create file

```bash
# 对于多行内容,比普通重定向更方便
cat > FILE << EOF
# 内容
EOF
```

### paste(合并文件列)

```bash
cat file
A
A1
A2

cat file1
B
B1
B2

paste file file1
A B
A1 B1
A2 B2
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

```bash
make source.txt
# output
makefile:4: *** 缺失分隔符。 停止。
```

如果想用其他键，可以用内置变量`.RECIPEPREFIX`声明。

#### Note: 需要注意的是，每行命令在一个单独的 shell 中执行。这些 Shell 之间没有继承关系。(make var-lost），取不到 foo 的值。因为两行命令在两个不同的进程执行。一个解决办法是将两行命令写在一行，中间用分号分隔。

```bash
# 使用">"代替<tab>健
.RECIPEPREFIX = >
all:
> echo Hello, world
var-kept:
    export foo=bar; echo "foo=[$$foo]"
```

#### [checkmake检查makefile](https://github.com/mrtazz/checkmake)

### lsof

列出那些文件被使用

```bash
lsof

#列出正在被监听的端口
lsof -i

# 指定程序mysql
lsof -c mysql

# 指定pid
lsof -p 7148

# 列出已经被删除的但还被进程占用的文件
lsof | grep -i "delete" | grep <filename>
# 进入那个进程
cd /proc/8445/fd
# 恢复文件
cat 3 > ~/<filename>
```

### rsync

[RSYNC 的核心算法](https://coolshell.cn/articles/7425.html)

- [How does rsync work?](https://michael.stapelberg.ch/posts/2022-06-18-rsync-overview/)

- `-r` 递归
- `-a` 可代替-r，并且同步修改时间，权限等
- `-n` 模拟结果
- `-v` 输出
- `--delete` 删除目标目录，不存在于源目录的文件
- `--exclude` 排除文件
- `--include` 只同步指定文件，往往与--exclude 结合使用
- `--link-dest` 增量备份

```bash
rsync -av SOURCE DESTINATION

# 远程ssh push pull
rsync -av .zshrc root@192.168.100.208:/root

# 删除只存在于目标目录、不存在于源目录的文件。
rsync -av --delete source/ destination

# 排除txt以外所有文件
rsync -av --include="*.txt" --exclude='*' source/ destination
```

增量备份，对比基准和源，差异的文件同步到 target，相同的文件以**硬链接**的同步到 target
`rsync -a --delete --link-dest /compare /source /target`

```bash
# 先同步
rsync -av /source /target

# 增量备份
rsync -a --delete --link-dest /compare /source /target
```

- daemon模式运行

    - rsync可以通过rsh或ssh，也能以daemon模式去运行，在以daemon方式运行时rsync server会打开一个873端口，等待客户端去连接。

    - 配置文件：`/etc/rsyncd.conf`
    ```sh
    uid = nobody
    gid = nobody
    use chroot = yes
    max connections = 4
    syslog facility = local5
    pid file = /run/rsyncd.pid

    [rsynctest]
            path = /tmp/rsynctest
            read only = no
    ```

    ```sh
    # 不要忘记创建共享目录
    mkdir /tmp/rsynctest

    # 从/tmp/rsynctest sync到 /tmp/test
    rsync --archive rsync://127.0.0.1/rsynctest /tmp/test
    ```

- [rsync+inotify-tools](https://github.com/wsgzao/sersync)

#### UDR模式

- [UDR](https://github.com/allisonheath/UDR)

- 测试对比

    - 1.在稳定的内网网络环境（同网段）用两种不同的传输方式多次进行了对比，udr方式和常规的rsync方式速度基本相当。
    - 2.在内网网络环境（跨网段、跨机房）用两种不同的传输方式多次进行了对比，udr方式要明显快于常规的rsync方式，传输大小为1G的文件进行对比：

```sh
# 下载udr并编译
git clone https://github.com/allisonheath/UDR.git
cd UDR
make -e os=XXX arch=YYY
```

### scp

```sh
# 复制文件到/home/tz目录下
scp file tz@192.168.1.102:/home/tz/
# 复制目录到/home/tz目录下
scp -r notes tz@192.168.1.102:/home/tz/

# 从远程主机复制文件到本机
scp tz@192.168.1.102:file .
# 复制不同目录的多个文件，需要使用空格分割文件
scp tz@192.168.1.102:'/path/file1 /path2/file2 /path3/file3' .

# 在两个远程主机之间复制文件
scp root@192.168.1.102:file root@127.0.0.1:24831:

# 指定端口
scp -P 22 file tz@192.168.1.102:/home/tz/
# 保留文件原属性
scp -p file tz@192.168.1.102:/home/tz/
# 输出debug信息
scp -v file tz@192.168.1.102:/home/tz/
# 静默复制
scp -q file tz@192.168.1.102:/home/tz/
# 指定加密算法
scp -c 3des file tz@192.168.1.102:/home/tz/
# 限制传输速度为50kb/s。 需要记住的一点是，带宽是以千比特/秒(kbps)指定的。这意味着8位等于1字节
scp -l 400 file tz@192.168.1.102:/home/tz/
```

### rsync和scp的区别

- [（视频）林哥讲运维：一分钟认识：rsync和scp的区别](https://www.bilibili.com/video/BV1GT421r71r)

- rsync需要远程主机也需要安装rsync
- rsync有同步功能

- 性能：
    - 第1次传输：
        - rsync时间更长、cpu使用率更高
        - scp时间更短、cpu使用率更低

    - 再次传输相同文件或目录：
        - rsync会判断文件，实现秒传
        - scp则重传

    - 如果是传输增量的文件
        - rsync只会传输增量的文件
        - scp则完整传输

### [restic：备份工具](https://github.com/restic/restic)

- [缘生小助手：开源备份软件Restic简单教程](https://mp.weixin.qq.com/s/xVLllH48eYqPO7xNSGrBfw)

- 安装好了Restic后，还需要配置下存储方式(本地或者远程), 配置过程中都会要你输入密码。

    - 记住密码很重要！如果你失去了它，你就不能够访问存储库中存储的数据.
```sh
# 初始化当前目录。需要输入密码
restic init --repo .

# 查看初始化后生成的文件和目录
ll
.r--------   1 155 tz tz 13 Feb 14:26 -I config
drwx------ 258   - tz tz 13 Feb 14:26 -I data/
drwx------   2   - tz tz 13 Feb 14:26 -I index/
drwx------   2   - tz tz 13 Feb 14:26 -I keys/
drwx------   2   - tz tz 13 Feb 14:26 -I locks/
drwx------   2   - tz tz 13 Feb 14:26 -I snapshots/

# 将/tmp/test目录，备份到当前目录。需要输入密码
restic -r . backup /tmp/test

# 查看备份的情况。需要输入密码
restic -r . snapshots
# 查看具体路径的备份情况。需要输入密码
restic -r . snapshots --path /tmp/test

# 验证所有数据都正确地存储在存储库中。应该定期运行此命令。需要输入密码
restic check -r .
# 不检测数据库磁盘上文件是否被修改,以使用restic命令也验证存储库中包文件的完整性
restic -r . check --read-data。需要输入密码

# 恢复数据。会在目标路径/后面恢复tmp/test1。需要输入密码
restic -r . restore 42ba609a --target /

# 删除快照
restic -r . forget 42ba609a
# 虽然上述命令将快照删除了，但文件引用的数据仍然存储在存储库中, 要清除未引用的数据，必须运行prune命令
restic -r . prune
# 当然也可以综合这两步一起操作。仅保留最新的快照
restic forget -r . --keep-last 1 --prune

# 根据策略删除快照
# 保留每天一个快照，最多保留最近的 4 天的快照。举个例子，如果你有 10 天的备份，这个选项会删除除了最近 4 天以外的每天的备份
restic -r . forget --keep-daily 4 --dry-run

# restic本身支持的存储库有限，但是rclone支持多，于是乎支持rclone集成
restic -r rclone:foo:bar init
```

### split

```bash
# -b 二进制文件,按100M 进行拆分
split -b 100M <file>

# -C 文本文件,按100M 进行拆分
split -C 100M <file>
```

### fsarchiver

```bash
fsarchiver savefs -z1 -j12 -v /path/to/backup_image.fsa /dev/sda1
```

### find

```bash
# 将BBB目录,改为AAA目录
for file in $(find . -type d -name "BBB"); do
    mv $file $(echo "$file" | sed "s/BBB/AAA/");
done

# 将AAA目录,改为BBB目录
for file in $(find . -type d -name "AAA"); do
    mv $file $(dirname $file)/BBB
done

# 或者
find . -type d -name AAA -exec sh -c 'mv "$0" $(dirname "$0")/BBB' {} \;

# 查找硬链接
find / -samefile /target/file

# -regex正则表达式(不支持pcre)
find . -regex ".*python.*"

# \! -name 排除.gz的文件
find . \! -name "*.gz"

# -print0 删除换行符, 将字符串连在一起
find . -print0

# 通过inode查找文件
# 很慢
sudo find -inum 1183045
# 上一条命令快
sudo debugfs -R 'ncheck 1183045' /dev/nvme0n1p3
```

### [fselect: sql语句的ls](https://github.com/jhspetersson/fselect)

> 实现以列为单位的ls(面向对象)

- 默认会递归目录

```sh
# 显示当前目录文件的size, path
fselect size, path from .

# 显示当前目录文件和/tmp目录
fselect size, path from ., /tmp

# 显示压缩文件内的文件
fselect size, path from . archives

# 递归软连接
fselect size, path from . symlinks

# 搜索长宽相等的图片
fselect path from . where width = height

# 只显示前10个
fselect size, path from . limit 10

# 不递归目录
fselect size, path from . depth 1

# 只显示目录深度2到5的文件
fselect size, path from . mindepth 2 depth 5

# order by 排序
fselect size, path from . order by size
fselect size, path from . order by size desc

fselect modified, fsize, path from . order by 1 desc, 3


# 统计size
fselect "MIN(size), MAX(size), AVG(size), SUM(size), COUNT(*) from ."
```

- 输出文件

```sh
fselect size, path from . into json
fselect size, path from . into html
fselect size, path from . into csv
```

- where

```sh
# size 大于1M的文件
fselect size, path from . where size gt 1M

# hsize 自动转换单位, 查找大于1M的png文件
fselect hsize, path from . where name = '*.png' and size gt 1M

# 查找大于1M的png文件, 小于1M的jpg文件
fselect "hsize, path from . where (name = '*.png' and size gt 1M) or (name = '*.jpg' and size lt 1M)"

# =~ 正则表达式(支持pcre), 查找路径包含python的文件.
# 类似于find . -regex ".*python.*"
fselect name from . where path =~ '.*python.*'
```

- 文件类型:

    - `is_archive`
    - `is_audio`
    - `is_book`
    - `is_doc`
    - `is_image`
    - `is_video`

- 特殊文件:

    - `suid`
    - `is_pipe`
    - `is_socket`

```sh
# 只搜索图片
fselect path from . where is_image = true
```

- 权限:

    - `other_all`
    - `other_read`
    - `other_write`
    - `other_exec`

```sh
# 搜索权限包含w, x的文件
fselect mode, path from . where other_write = true or other_exec = true
```

- 时间相关

```py
# 今天创建的文件
fselect path from . where created = today

# 昨天访问过的文件
fselect path from . where accessed = yesterday

# 2021-04-20以来修改过的文件.时分秒
fselect path from . where modified gt 2021-04-20
fselect path from . where modified gt '2021-04-20 18:10'
fselect path from . where modified gt '2021-04-20 18:10:30'
```

### locate:定位文件
```sh
sudo updatedb
```

### shred：安全地抹去磁盘数据。代替rm

- `rm`命令或者文件管理器删除文件只是删除指向文件系统的指针（inode），所以原始数据仍可以使用

- `shred` 是 Linux 软件包 `coreutils` 的一部分

```sh
# 默认情况下，shred 会执行三次，在执行的时候，它会将伪随机数据写入设备。
shred -v /dev/sdb

# 但是执行三次所需的时间太长了，我们可以通过 -n 来设置执行次数
shred -v -n 1 /dev/sdb

# 使用随机生成的数据覆盖磁盘
shred -v -n 1 --random-source=/dev/urandom /dev/sdb
```

## char (字符串操作)

### tee

- [（视频）林哥讲运维：一分钟学会：tee命令的使用技巧](https://www.bilibili.com/video/BV1Rz421b7RJ)

- `|`只是把标准输出传递给下一条命令的标准输入

- tee自己实现标准输出，并把标准输入通过`|`，传递给下一条命令
    ```sh
    ls | tee /tmp/filename | less
    ```

```sh
# 一边保存视频文件（标准输出），一边观看视频（标准输入）
ssh root@file.mp4 | tee file.mp4 | mpv -

# 拷贝多份磁盘
dd if=/dev/sda bs=128k | tee >(dd of=/dev/sdb bs=128k) >(dd of=/dev/sdc bs=128k)

# 把ssh登陆后的操作，保存为日志
ssh root@192.168.110.4 | tee /tmp/ssh-$(date "+%F_%T").log

# 解决sudo问题
sudo echo '123' > /root/filename
zsh: permission denied: /root/filename
echo '123' | sudo tee /root/filename

# 多台主机执行相同命令。我这里为2台主机同时执行ip a命令
echo 'ip a' | tee >(ssh -T root@192.168.110.4) >(ssh -T root@192.168.110.5) > /dev/null

# 有2个用户同时登陆，将当前屏幕输出投影给另一个用户
who
script /dev/null | tee /dev/pts/0
```

### column

网格排版

### tr

所有操作，以**字符**为单位

```bash
# 删除换行符
cat FILE | tr -d '\n'

# 空格换成换行符
cat FILE |tr '\040' '\n'
cat FILE |tr ' ' '\n'

# 换成大写
cat FILE | tr '[a-z]' '[A-Z]'

# 只保留小写
cat FILE | tr -dc a-z

# 只保留英文和数字
cat < /dev/urandom | tr -dc a-zA-Z0-9
```

### cut

```bash
# 保留前5个字符
cut -c -5 file

# 保留前5个字符和7到10个字符
cut -c -5,7-10 file

# 不保留第6和11个字符
cut -c -5,7-10,12- file

# 以:为分格式符,打印第二列
cut -d: -f2
```

### sed

- [useful-sed](https://github.com/adrianscheff/useful-sed)

所有操作，以**行**为单位
| 参数 | 操作 |
| ---- | ---- |
| p | 打印 |
| d | 删除 |
| a | 添加 |
| i | 插入 |
| c | 替换 |

```bash
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

# 将.webp)为末尾的字符，改为.avif。注意.avif末尾不需要加$
sed -i 's/.webp)$/.avif)/g'

# 打印第一行和匹配 nginx
ps aux | sed '1p;/nginx/!d'

# pm和am替换为中文
date +%H:%M:%S:%P | sed -e 's/pm/下午/g' -e's/am/上午/g'

# 替换当前目录下（包含子目录）的所有文件
find . -type f -exec sed -i 's/a/b/g' {} +
```

```sh
# 当前目录下的以.webp)等为末尾的字符，改为.avif。注意.avif末尾不需要加$
for file in *;do
    if [ -f $file ];then
        sed -i 's/.png)$/.avif)/g' $file
        sed -i 's/.jpg)$/.avif)/g' $file
        sed -i 's/.jpeg)$/.avif)/g' $file
        sed -i 's/.webp)$/.avif)/g' $file
    fi
done
```

### awk

- [awk 中文指南](https://awk.readthedocs.io/en/latest/index.html)

> 可以代替 grep,sed

- `OFS` 设置列之间的分隔符
- `$NF` 最后 1 列
- `$NR` 行数
- `$0` 所有行
- `-F":"` 设置分隔符,默认是空格
- `-v` 定义变量

`print` 内的操作为**列**

```bash
ll > FILE

# 打印行数(类似于wc -l)
awk 'END { print NR;}' FILE

# 在开头显示行数(类似于cat -n)
awk '$0 = NR" "$0' FILE

# 在开头复制第一列
awk '$0 = $1" "$0' FILE

# 打印第1列
awk '{print $1}' FILE

# 打印第1,5,和最后1列
awk '{print $1,$5,$NF}' FILE

# 打印前五行
awk 'NR <= 5' FILE

# 打印第5行的,第1,5,和最后1列
awk 'NR == 5 {print $1,$5,$NF}' FILE

# 打印基数行
awk 'NR%2' FILE

# 打印偶数行
awk 'NR%2 == 0' FILE

# 打印,除了最后一列
awk 'NF--' FILE

# 不打印重复行
awk '!a[$0]++'

# 以:为分隔符，打印第3列大于1000的行
awk -F ":" '$3 >= 1000' /etc/passwd

# 以:为分隔符，打印第3列大于1000和小于100的行
awk -F ":" '$3 >= 1000 || $3 <=100' /etc/passwd

# 以:为分隔符，打印第3列大于500,小于1000的行
awk -F ":" '$3 >= 500 && $3 <=1000' /etc/passwd

# 以:为分隔符，打印第3列等于1000
awk -F ":" '$3 ==1000' /etc/passwd

# 以:为分隔符，打印第3列不等于1000
awk -F ":" '$3 !=1000' /etc/passwd

# 设置列之间的分隔符为#
awk -F ":" '{OFS="#"} {print $1,$2,$3,$NF}' /etc/passwd

# 设置列之间的分隔符为#,打印第3列大于1000的行
awk -F ":" '{OFS="#"} $3 >= 1000 {print $1,$2,$3,$NF}' /etc/passwd
awk -F ":" '{OFS="#"} {if ($3 >= 1000) print $1,$2,$3,$NF}' /etc/passwd

# 设置列之间的分隔符为#,打印第3列大于1000的行和第一行
awk -F ":" '{OFS="#"} NR == 1 || $3 >= 1000 {print $1,$2,$3,$NF}' /etc/passwd

# 打印有apk的行的第二列(增强版grep)
awk '/apk/ { print $2}' FILE

# 打印有apk的行的倒数第3行和最后一行
awk '/apk/ {print $(NF-4),$NF}' FILE

# 第一列与第一列交换
awk '{ print $2"="$1}' FILE

# 打印行号加所有行(类似于cat -n)
awk '{ print NR" "$0}' FILE

# 打印第一行和匹配 nginx
ps aux | awk 'NR==1 || /nginx/'

# 打印第一行和匹配 从 nginx 到 vim
ps aux | awk '/nginx/,/vim/'

# 打印第一列,不等于0的值
awk '$1 != 0' FILE

# 将第一列的值相加
awk '{sum += $1} END {print sum}' FILE

awk -v a="$i" 'NR == a  {sub(/hello/,"tz")}1' test |head
# 只打印第一列的值等于100
awk '$1=="100" {print $0}' FILE

# 匹配第一列的值等于100,匹配第二列以a开头e结尾的行,然后只打印第三列
awk '$1=="100" && $2 ~ /^a.*e$/ {print $3}' FILE

# root替换tz(类似sed),只是打印,并不会修改文件
awk '{sub(/root/,"tz")}1' FILE

# 通过变量指定行,再进行替换
i=2
awk -v a="$i" 'NR == a  {sub(/root/,"tz")}1' FILE

# 所有字符都余2
awk 'ORS=NR%2' FILE

awk -v a="$var1" -v b="$var2" 'BEGIN {print a,b}'

# 找出当前系统中 swap 占用最大的几个进程，并列出它们的进程号、进程名和 swap  大小。
# awk 命令用于匹配 VmSwap、Name 或者 Pid 这几个关键字，并输出它们的值。END{ print ""}是末尾加上换行符。
# sort -k 3 -n -r：对输出的结果进行排序。-k 3 表示按第三列进行排序，即按照交换空间大小排序；-n 表示按照数字顺序排序；-r 表示逆序排序，即从大到小排序。
for file in /proc/*/status;
    do awk '/VmSwap|Name|^Pid/{printf $2 " " $3}END{ print ""}' $file;
done | sort -k 3 -n -r | head
```

- [Understanding AWK](https://earthly.dev/blog/awk-examples/)

- [awk 教程](https://backreference.org/2010/02/10/idiomatic-awk/)

### tac(反转行)

```sh
ls | tac
```

### paste

- 分成多少列

```sh
# 分成两列
ls | paste - -

# 分成三列, 以此类推
ls | paste - - -

# 将多个文件，以新增1列的方式，合并为一个文件
paste file1 file2
```

### perl5

- [learn_perl_oneliners](https://learnbyexample.github.io/learn_perl_oneliners/cover.html)

| 参数 | 操作             |
| ---- | ---------------- |
| -e   | 程序接在命令后面 |
| -i   | 写入文件         |
| -p   | 匹配每一行       |
| -w   | 输出报错信息     |

```bash
ll > test

# grep tz test
perl -ne 'print if /tz/' test

# sed 's/root/tz/g' test
perl -pe 's/root/tz/g' test

# sed -i 's/root/tz/g' test
perl -pie 's/root/tz/g' test

# awk '{print $2}' test
perl -lane 'print $F[1]' test

# awk '{print $1,$3,$4,$5,$6}' test
perl -lane 'print @F[0,2..5]' test
```

### perl6(Raku)


- [Raku 入门](https://raku.guide/zh/)

- [Perl6-One-Liners](https://github.com/dnmfarrell/Perl6-One-Liners)

| 参数 | 操作               |
|------|--------------------|
| -e   | 执行               |
| -n   | 行操作             |
| -p   | -n参数并自动打印$_ |
| -M   | 加载模块           |

- `$_` 默认变量

- `.say`($_.say) 打印

- `.uc` 转换大写


```sh
ll > test

cat > /tmp/file << 'EOF'
1 2 3 4

3 2
1
EOF
```

```sh
# .uc 转换大写
perl6 -ne 'say .uc' test
perl6 -ne '.uc.say' test
perl6 -pe '$_ = $_.uc' test
perl6 -pe '.=uc' test
perl6 -pe .=uc test

# 首字符大写
perl6 -pe .=wordcase test

# 统计每行字符数量
perl6 -pe .=chars.say test

# 翻转行
perl6 -pe .=flip /tmp/test
```

- 添加修改字符

```sh
# say 复制每行
perl6 -pe 'say $_' test

# 插入新一行字符
perl6 -pe 'say next line' test

# 插入尾部字符
perl6 -pe '$_ ~= " end line"' test

# 添加4个换行符
perl6 -pe '$_ ~= "\n" x 4' test

# sed 's/root/tz/g' test
perl6 -pe 's:g/root/tz/' test

# 替换开头字符是d的
perl6 -pe 's:g/root/tz/ if /^d/' test

# sed -i 's/root/tz/g' test
```
- 过滤筛选

```sh
# 只要第2行
perl6 -ne '.print if ++$ == 2' test
# 不要第2行
perl6 -pe 'next if ++$ == 2' test

# 单数行
perl6 -ne '.say if ++$ !%% 2' test
# 双数行
perl6 -ne '.say if ++$ %% 2' test

# 去除重复行
perl6 -ne 'state %l;.say if ++%l{$_}==1'

# grep root test
perl6 -ne '.say if /root/' test

# awk '{print $1}' test
perl6 -ne '.words[0].say' test

perl6 -ne '.words[0..5].say' test
```

- 运算

```sh
# 统计带有root的行
perl6 -e 'say lines.grep(/root/).elems' test

# 乘法
perl6 -e 'say [*] 1..5'

# 行相加
perl6 -ne'say [+] .split(" ")' file
```

- 生成器

```sh
# a-z
perl6 -e '.say for "a".."z"'

# aa - zz
perl6 -e '.say for "a".."zz"'

# a-z 一行
perl6 -e 'print  "a".."z"'

# 随机10个a-z字符 一行
perl6 -e 'print roll 10, "a".."z"'

# 运算符
perl6 -e 'print "a" x 50'
```

#### module

- [URI-Encode](https://github.com/raku-community-modules/URI-Encode)
    > 转换为uri字符

```sh
perl6 -M URI::Encode -e 'say encode_uri("/10 ways to crush it with Perl 6")'
```
#### 个人觉得perl6中有趣的设计

- 函数管道

```perl6
my @array = <7 8 9 0 1 2 4 3 5 6>;
@array ==> unique()
       ==> sort()
       ==> reverse()
       ==> my @final-array;
say @final-array;
```

- 归约运算符

```perl6
[+] 0,1,2,3,4,5

[+] 0..5

[+] ^6
```

### shred：安全删除文件

```sh
# 默认是覆盖3次，每次产生随机数据。
shred file.txt

# 指定次数为5次
shred -n 5 file.txt

# 确保文件的目录项也被删除，这样文件就不会存在于文件系统的快照或备份中。
shred -u file.txt
```

### 加密文件

```sh
# 生成新的加密文件
gpg -c --cipher-algo aes256 file

# 解密
gpg -d file
```

### pv：显示进度条

```sh
# 显示dd命令的进度条
dd if=/dev/urandom | pv | dd of=/dev/null

# 像打字一样的效果。以30的输出速度，打开文件。
pv -qL 30 <file>
```

## other

### xargs

- `xargs` 默认为 `xrags echo`

- `xargs` 不能运行内置命令(shell builtin)如cd命令

```bash
# -Iz 执行10次echo 1,可以换成其他命令
seq 10 | xargs -Iz echo 1

# -n 分段
seq 10 | xargs -n 3

# ls -l 查看当前所有目录
find . -type d | xargs ls -l

# 打包压缩当前所有目录
find . -type d | xargs tar cjf test.tar.gz
find . -type d | xargs tar cjf {}.tar.gz

# 创建a,b,c目录(注意这里c为c\n)
echo 'a b c' | xargs mkdir

# -p 创建a,b,c目录, 需要确认y or n
echo 'a b c' | xargs mkdir

# -d 分隔符
echo 'axbxc' | xargs -d 'x' mkdir

# -t 一行参数(rm -d a b c)
echo 'a b c ' | xargs -t rm -d

# -L 指定参数数量
echo www.baidu.com > ip
echo www.qq.com >> ip
cat ip | xargs -L 1 ping -c 1

# --max-procs 表示进程数量. 如果是0, 则不限制进程
cat ip | xargs --max-procs 2 -L 1 ping -c 1
cat ip | xargs --max-procs 0 -L 1 ping -c 1

# -I 设置变量, 再传递shell
cat ip | xargs -I host sh -c "ping -c 1 host; curl host"
```

- 并发
```sh
# -P 12个核心
find . -name '*' | xargs -P 12 file
# -n 每个核的处理10个任务
find . -name '*' | xargs -P 12 -n 10 file
```

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

# pm和am替换中文
date +%H:%M:%S:%P | sed -e 's/pm/下午/g' -e's/am/上午/g'

#or
date +"%Y年%m月%d日 %H时%M分%S秒"
# 2020年11月27日 11时51分56秒

# timestamp
date +%s
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

### openssl

```bash
# 生成pem私钥(需要输入密码)
openssl genrsa -aes128 -out private.pem 1024

# 查看私钥信息(需要输入密码)
openssl rsa -in private.pem -noout -text

# 提取公钥(需要输入密码)
openssl rsa -in private.pem -pubout > public.pem

# 查看公钥信息
openssl rsa -in public.pem -pubin -noout -text

# 生成文本
echo 123 > file

# 使用公钥加密文本
openssl rsautl -encrypt -inkey public.pem -pubin -in file -out file.enc

# 使用私钥解密文本(需要输入密码)
openssl rsautl -decrypt -inkey private.pem -in file.enc > file
```

- 连接加密端口

```sh
openssl s_client -connect www.baidu.com:443
```

### gnuplot

```sh
# 对文件第一列进行绘图
plot "filename" using 1 w lines
```

### [shellcheck](https://github.com/koalaman/shellcheck)
```sh
# 测试有没有问题
shellcheck --format=gcc test.sh
```

### jobs, fg, bg, nohup, disown, reptyr
- 教程参考: [bilibili: [高效搬砖] ssh上进程跑一半，发现忘开 tmux 了，又需要断开连接？场面一度很尴尬！reptyr来打救你](https://www.bilibili.com/video/BV1pT4y1w7kc?from=search&seid=17793808854272221660&spm_id_from=333.337.0.0)

- test.sh
```sh
#!/bin/sh
# 每隔1秒输出当前时间
while true;do
    echo $(date)
    sleep 1
done
```

- 后台运行
```sh
# 执行test.sh
./test.sh

# 按ctrl-z, 进入后台
<c-z>

# 进入后台会停止运行, 使用bg命令让test.sh在后台继续运行
bg
```

- 查看test.sh的pid
```sh
ps aux | grep test.sh

# pid为112908
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
tz        112908  0.0  0.0  10480  3764 pts/2    S<   10:37   0:00 /bin/sh ./test.sh
```

- disown
```sh
# 如果退出shell, 那么后台任务test.sh也会退出. 使用disown 让即使退出shell, 后台任务也能继续运行
disown 112908
```

- reptyr
```sh
# 在开启新的shell, 捕抓test.sh标准输入, 输出. 旧的shell不能关闭, 不然会失败
sudo reptyr -T 112908
```

- kill命令, 终止test.sh
```sh
kill -9 112908
```

- nohup：可以让进程忽略挂断信号（SIGHUP）。就算退出shell, 那么后台任务test.sh也不会退出
```sh
# 会自动将输出重定向nohup.out文件
nohup ./test.sh &
[1] 21086
nohup: ignoring input and appending output to 'nohup.out'

# 退出shell后依然会运行
# 开启新shell后，kill命令终止test.sh
kill -9 21086
```

## expect交互

- [expect - 自动交互脚本](https://xstarcd.github.io/wiki/shell/expect.html)

## 调整分区大小

将 `sda1` 文件系统调整为 30G

```bash
e2fsck -f /dev/sda1
resize2fs /dev/sda1 30G
```

最后再调整 `sda1` 的分区大小

```bash
fdisk /dev/sda
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

```bash
mdadm -C /dev/md0 -a yes -l 5 -n 3 /dev/sdb /dev/sdc /dev/sdd
```

### 创建 RAID5,并设置备份磁盘

```bash
mdadm -C /dev/md0 -a yes -l 5 -n 3 -x 1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
```

### 保存配置文件

```bash
mdadm -D --scan > /etc/mdadm.conf
```

### 性能测试

```bash
root@localhost ~# hdparm -t /dev/md0
/dev/md0:
 Timing buffered disk reads: 1418 MB in  3.01 seconds = 471.61 MB/sec

root@localhost ~# echo 3 > /proc/sys/vm/drop_caches

root@localhost ~# hdparm -t /dev/sda
/dev/sda:
 Timing buffered disk reads: 810 MB in  3.00 seconds = 269.99 MB/sec

```

### 硬盘装载

```bash
# 把sdb设置为故障
mdadm /dev/md0 -f /dev/sdb

# 移除sdb
mdadm /dev/md0 -r /dev/sdb

# 添加新的sdb
mdadm /dev/md0 -a /dev/sdb
```

### 卸载 RAID

```bash
umount /dev/md0
mdadm -S /dev/md0
mdadm --zero-superblock /dev/sdb
mdadm --zero-superblock /dev/sdc
mdadm --zero-superblock /dev/sdd
```

## 视频/图片

### ffmpeg

| 视频格式 | 视频编码器 | 音频编码器 |
|----------|------------|------------|
| mp4      | H.264      | aac        |
| webm     | vp9        | Vorbis     |

- [FFmpeg - The Ultimate Guide](https://img.ly/blog/ultimate-guide-to-ffmpeg/)

- [阮一峰:FFmpeg 视频处理入门教程](https://www.ruanyifeng.com/blog/2020/01/ffmpeg.html)

- [ffmpeg原理](https://ffmpeg.xianwaizhiyin.net/cover.html)

- [奇乐编程学院视频:FFmpeg 最最强大的视频工具 (转码/压缩/剪辑/滤镜/水印/录屏/Gif/...)](https://www.bilibili.com/video/BV1AT411J7cH/?vd_source=5de14ac47d024a404772edfe5d5eb20c)

- [在线工具：交互构建常用ffmpeg命令](https://evanhahn.github.io/ffmpeg-buddy/)

- [在线工具：交互构建复杂ffmpeg命令](https://ffmpeg.guide/)

- 基本命令：

```sh
# 播放视频
ffplay video.mp4

# 窗口宽度为400
ffplay -x 400 -i video.mp4

# 播放音频
ffplay audio.mp3

# 显示波形图
ffplay -showmode 1 audio.mp3
```

- [ffprobe的正确打开方式（三剑客之一）](https://cloud.tencent.com/developer/article/1840302)
```sh
# 查看视频文件信息。注意输出的视频码率是kb（是比特而不是字节），要除以8
ffprobe file.mp4

# 获取更多信息
ffprobe -show_format file.mp4

# json格式输出
ffprobe -print_format json -show_streams file.mp4
```

- [简书：ffmpeg # tbr & tbn & tbc](https://www.jianshu.com/p/f2ba8e0fd3a4)

```sh
# 查看支持的格式
ffmpeg -formats

# 查看支持的编码器
ffmpeg -codecs

# ts转mp4。除了转换封装格式外，还会进行编码转换
ffmpeg -i input.ts output.mp4

# 缩放视频
ffmpeg -i input.ts -s 1024x576 output.mp4

# -c copy表示使用原来的编码器，即只转换封装格式
ffmpeg -i input.mp4 -c copy output.mkv

# -c:v指定视频编码器，-c:a指定音频编码器
ffmpeg -i input.mp4 -c:v copy -c:a libvorbis output.mp4

# 转码 -crf越低码率越高，文件更大（视频质量）。libx264是软解
ffmpeg -i input.mp4 -c:v libx264 -crf 24 output.mp4
# 转码av1
ffmpeg -i input.mp4 -c:v libaom-av1 -crf 24 output.mkv
# -preset选项可以花费更多的时间，文件更小。但对比上一个命令非常的慢，而压缩大小却没有小很多
ffmpeg -i input.mp4 -c:v libx264 -preset veryslow -crf 24 output.mp4
# nvdia显卡可以使用h264_nvenc硬解码（速度更快，但质量会低一些）
ffmpeg -i input.mp4 -c:v h264_nvenc -crf 24 output.mp4
# 使用libx265编码器
ffmpeg -i input.mp4 -c:v libx265 -crf 24 output.mp4

# 降低帧率
ffmpeg -i input.mp4 -r 24 output.mp4

# 剪切视频 -ss 开始时间 -t -to
ffmpeg -ss 00:00:20 -i input.mp4 -t 10 -c copy output.mp4
# -to 从00:00:20开始，录制30秒
ffmpeg -ss 00:00:20 -i input.mp4 -to 00:00:30 -c copy output.mp4

# 分割视频 前20秒为output1.mp4，20秒后为output2.mp4
ffmpeg -i input.mp4 -to 00:00:20 output1.mp4 -ss 00:00:20 output2.mp4
# 分割前20秒和20秒到40秒的视频
ffmpeg -i input.mp4 -to 00:00:20 output1.mp4 -ss 00:00:20 -to 00:00:40 output2.mp4

# 延迟视频3.84秒
ffmpeg -i input.mp4 -itsoffset 3.84 -i input.mp4 -map 1:v -map 0:a -vcodec copy -acodec copy output.mp4

# 延迟音频3.84秒
ffmpeg -i input.mp4 -itsoffset 3.84 -i input.mp4 -map 0:v -map 1:a -vcodec copy -acodec copy output.mp4
```

- 合并:
- `file.txt` 文件
```txt
file 'file1.mp4'
file 'file2.mp4'
```

```sh
outfile=new.mp4
# 合并file.txt下的视频
ffmpeg -f concat -safe 0 -i file.txt -c copy $outfile
```

#### -vf视频过滤器

- 多个选项用 `,` 分隔

```sh
# 添加字幕
ffmpeg -i input.mp4 -vf ass=sub.ass output.mp4

# scale=修改分辨率为480p
ffmpeg -i input.mp4 -vf scale=480:-1 output.mp4

# transpose=旋转视频。0为90度逆时针并垂直旋转、1为90度顺时针、2为90度逆时针、3为90度顺时针并垂直旋转
ffmpeg -i input.mp4 -vf "transpose=1" output.mp4
# 旋转180度顺时针
ffmpeg -i input.mp4 -vf "transpose=1,transpose=1" output.mp4

# 旋转270度，但不改变编码
ffmpeg -i input.mp4 -map_metadata 0 -metadata:s:v rotate="270" -codec copy output.mp4
```

#### 音频操作

```sh
# 提取音频
ffmpeg -i input.mp4 -vn output.mp3

# -ab压缩音频比特率为128
ffmpeg -i input.mp3 -ab 128 output.mp3

# 屏蔽前90秒的声音
ffmpeg -i input.mp4 -vcodec copy -af "volume=enable='lte(t,90)':volume=0" output.mp4

# 屏蔽80秒-90秒的声音
ffmpeg -i input.mp4 -vcodec copy -af "volume=enable='between(t,80,90)':volume=0" output.mp4
```

#### 图片操作

```sh
# 截图
ffmpeg -ss 00:00:20 -i input.mp4 -vframes 1 output.png

# 每隔1秒截一张图，-r指定1秒内多少帧（默认为25）
ffmpeg -i input.mp4 -r 1 -f image2 image-%2d.png

# 添加水印overlay表示位置
ffmpeg -i input.mp4 -i input.png -filter_complex "overlay=100:100" output.mp4

# 制作gif图 -ss 开始时间 -to 结束时间 -r为帧率
ffmpeg -ss 00:00:20 -i input.mp4 -to 10 -r 10 output.gif
# scale修改分辨率为200p
ffmpeg -ss 00:00:20 -i input.mp4 -to 10 -r 10 -vf scale=200:-1 output.gif

# 制作webp动画
ffmpeg -ss 00:00:20 -i input.mp4 -to 10 -r 10 output.webp
```

#### 录屏

```sh
# 录制屏幕(不录制声音)
ffmpeg -f x11grab -s 1920x1080 -i :0.0 output.mp4

# 录制摄像头
ffmpeg -i /dev/video0 output.mp4

# 录制声音
arecord -L # 查看声卡设备
ffmpeg -f alsa -i default:CARD=Generic output.mp3
```

#### [plotbitrate](https://github.com/zeroepoch/plotbitrate)

```sh
# 生成不同时间段的视频码率图
plotbitrate input.mkv

# 音频码率
plotbitrate -s audio input.mkv

# 以svg图保存
plotbitrate -o output.svg input.mkv
```

### gif

#### gifview

#### gifdiff

#### convert(gif制作)

```sh
# 合并多张gif -delay合并每张gif的第一秒
convert -delay 1 -loop 0 *.gif output3.gif

# 多张jpg合成gif
convert -delay 10 -loop 0 *.jpg linux.gif
```

#### [gifsicle:gif工具支持压缩、合并、编辑帧、减少帧](https://github.com/kohler/gifsicle)

```sh
# 查看每1帧的图片
gifsicle -I input.gif

# 压缩
gifsicle input.gif -O3 -o output.gif

# 提取第0帧
gifsicle input.gif '#0' > output.gif

# 替换第5帧
gifsicle -b target.gif --replace '#5' replace.gif
```

# reference

- [cron](https://linux.cn/article-7513-1.html)
- [cron2](https://linux.cn/article-9687-1.html)
- [rsync](http://www.ruanyifeng.com/blog/2020/08/rsync.html)
- [sed](https://linux.cn/article-6578-1-rel.html)
- [sed2](https://linux.cn/article-10232-1.html)
- [Make 命令教程](http://www.ruanyifeng.com/blog/2015/02/make.html)
- [awk 实用学习指南 | Linux 中国](https://mp.weixin.qq.com/s?__biz=MjM5NjQ4MjYwMQ==&mid=2664624200&idx=2&sn=d1c968904c55de1875907ce49b9e46f8&chksm=bdcecb0e8ab942180ca22f9ec4cb5b4c4d3e0df0d9dd6b13ff1de1e04a89ab84e724cb549a03&mpshare=1&scene=1&srcid=1012DOi5bDFPP4geI536oQfi&sharer_sharetime=1602496699415&sharer_shareid=5dbb730cd6722d0343328086d9ad7dce#rd)

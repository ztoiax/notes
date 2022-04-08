<!-- vim-markdown-toc GFM -->

* [常用命令](#常用命令)
    * [file (文件操作)](#file-文件操作)
        * [create file](#create-file)
        * [paste(合并文件列)](#paste合并文件列)
        * [diff,patch 使用](#diffpatch-使用)
        * [make](#make)
            * [Note: 每行命令之前必须有一个 tab 键,不然会报错](#note-每行命令之前必须有一个-tab-键不然会报错)
            * [Note: 需要注意的是，每行命令在一个单独的 shell 中执行。这些 Shell 之间没有继承关系。(make var-lost），取不到 foo 的值。因为两行命令在两个不同的进程执行。一个解决办法是将两行命令写在一行，中间用分号分隔。](#note-需要注意的是每行命令在一个单独的-shell-中执行这些-shell-之间没有继承关系make-var-lost取不到-foo-的值因为两行命令在两个不同的进程执行一个解决办法是将两行命令写在一行中间用分号分隔)
        * [lsof](#lsof)
        * [rsync](#rsync)
        * [split](#split)
        * [fsarchiver](#fsarchiver)
        * [find](#find)
        * [fselect: sql语句的ls](#fselect-sql语句的ls)
    * [char (字符串操作)](#char-字符串操作)
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
    * [other](#other)
        * [xargs](#xargs)
        * [date](#date)
        * [fuser](#fuser)
        * [列出子目录的大小，并计总大小](#列出子目录的大小并计总大小)
        * [openssl](#openssl)
        * [gnuplot](#gnuplot)
        * [shellcheck](#shellcheck)
        * [pandoc 文档转换](#pandoc-文档转换)
        * [ffmpeg](#ffmpeg)
        * [jobs, fg, bg, disown, reptyr](#jobs-fg-bg-disown-reptyr)
    * [调整分区大小](#调整分区大小)
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
```

### rsync

[RSYNC 的核心算法](https://coolshell.cn/articles/7425.html)

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

- [rsync+inotify-tools](https://github.com/wsgzao/sersync)

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

## char (字符串操作)

### column

网格排版

### tr

所有操作，以**字符**为单位

```bash
# 删除换行符
cat FILE | tr -d '\n'

# 空格换成换行符
cat FILE |tr '\040' '\n'

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

# 打印第一行和匹配 nginx
ps aux | sed '1p;/nginx/!d'
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

### [pandoc 文档转换](https://github.com/jgm/pandoc)

```sh
# 列出支持的文档格式
pandoc --list-output-formats

# md转word
pandoc README.md -o README.docx

# md转html
pandoc README.md -o README.html

# md转ppt
pandoc README.md -o README.html -t revealjs -s

# md转ppt 指定主题
pandoc Resume.md -o README.html -t revealjs -s -V theme=beige

# 输入不一定是文件, 可以输入url, 将html文件转换mardown
pandoc -f html -t markdown https://www.sogou.com > sogou.md
```

### ffmpeg

- 剪切:
```sh
file=old.mp4
outfile=new.mp4

# 开始时间
start=00:00:00
# 结束时间
end=00:01:00

ffmpeg -i $file -ss $start -t $end -c copy $outfile
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

### jobs, fg, bg, disown, reptyr
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

# reference

- [cron](https://linux.cn/article-7513-1.html)
- [cron2](https://linux.cn/article-9687-1.html)
- [rsync](http://www.ruanyifeng.com/blog/2020/08/rsync.html)
- [sed](https://linux.cn/article-6578-1-rel.html)
- [sed2](https://linux.cn/article-10232-1.html)
- [Make 命令教程](http://www.ruanyifeng.com/blog/2015/02/make.html)
- [awk 实用学习指南 | Linux 中国](https://mp.weixin.qq.com/s?__biz=MjM5NjQ4MjYwMQ==&mid=2664624200&idx=2&sn=d1c968904c55de1875907ce49b9e46f8&chksm=bdcecb0e8ab942180ca22f9ec4cb5b4c4d3e0df0d9dd6b13ff1de1e04a89ab84e724cb549a03&mpshare=1&scene=1&srcid=1012DOi5bDFPP4geI536oQfi&sharer_sharetime=1602496699415&sharer_shareid=5dbb730cd6722d0343328086d9ad7dce#rd)

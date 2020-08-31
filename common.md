<!-- vim-markdown-toc GFM -->

* [常用命令](#常用命令)
    * [文件操作](#文件操作)
        * [create file](#create-file)
        * [diff,patch 使用](#diffpatch-使用)
        * [make](#make)
            * [Note: 每行命令之前必须有一个tab键,不然会报错](#note-每行命令之前必须有一个tab键不然会报错)
        * [lsof](#lsof)
        * [rsync](#rsync)
    * [字符串操作](#字符串操作)
        * [tr](#tr)
        * [sed](#sed)
        * [awk](#awk)
    * [other](#other)
        * [查看当前分区谁在使用](#查看当前分区谁在使用)
        * [列出子目录的大小，并计总大小](#列出子目录的大小并计总大小)
    * [cron](#cron)
* [reference](#reference)

<!-- vim-markdown-toc -->

# 常用命令

## 文件操作
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
make 默认根据makefile文件,进行构建
也可以使用`make -f RULE` 来指定文件
#### Note: 每行命令之前必须有一个tab键,不然会报错
```sh
make source.txt
# output
makefile:4: *** 缺失分隔符。 停止。
```
如果想用其他键，可以用内置变量`.RECIPEPREFIX`声明。
```sh
# 使用">"代替<tab>健
.RECIPEPREFIX = >
all:
> echo Hello, world
```

### lsof
列出那些文件被使用
```bash
lsof

#列出正在被监听的端口
lsof -i
```

### rsync

- `-r` 递归
- `-a` 可代替-r，并且同步修改时间，权限等
- `-n` 模拟结果
- `-v` 输出
- `--delete` 删除目标目录，不存在于源目录的文件
- `--exclude` 排除文件
- `--include` 只同步指定文件
- `--link-dest` 增量备份

```sh
rsync -av SOURCE DESTINATION
#远程ssh push pull
rsync -av .zshrc root@192.168.100.208:/root
#增量备份，将基准和源的变动，以硬链接的同步到target
rsync -a --delete --link-dest /compare/path /source/path /target/path
```


## 字符串操作

### tr

```sh
# 删除换行符
cat FILE | tr -d '\n'

# 换成大写
cat FILE | tr '[a-z]' '[A-Z]'
```

### sed

| 参数 | 操作                   |
| ---- | ---------------------- |
| i    | 将输出的结果保存至文件 |
| p    | 打印                   |
| d    | 删除                   |
| a    | 添加                   |
| i    | 插入                   |
| c    | 替换                   |

```sh
# 打印1到5行
sed -n '1,5p' FILE
# 打印从5行到结尾
sed -n '5,$p' FILE
# 打印除了第 5 到 10 之间的所有行
sed -n -e '5,10!p' inputfile

# 删除带有"192.168.100.1"的行
sed -e '/192.168.100.1/d' FILE

# 删除第1行
sed -e '1d' FILE

# 在第1行插入newline
sed -e '1inewline' FILE

# 在第1行替换成newline
sed -e '1cnewline' FILE

# 在第1行结尾添加newline
sed -e '1anewline' FILE

# 在每1行结尾添加newline
sed -e '1,$anewline' FILE

# 将第1个a替换成b 类似vim的替换
sed -e 's/a/b/'  FILE
# 将文件内所有a替换成b
sed -e 's/a/b/g'  FILE
```

### awk

- `$NF` 最后 1 列
- `$NR` 行数
- `$0` 所有行
- `-F":"` 设置分隔符,默认是空格

```sh
ll > test
# 打印第1列
awk '{print $1}' test

# 打印第1,5,和最后1列
awk '{print $1,$5,$NF}' test

# 打印第5行的,第1,5,和最后1列
awk 'NR==5 {print $1,$5,$NF}' test

# 以:为分隔符，打印第3列大于1000的行
awk -F ":" '$3 >= 1000' /etc/passwd
```

## other


### 查看当前分区谁在使用

```bash
fuser -vm .
```


### 列出子目录的大小，并计总大小

```bash
du -cha --max-depth=1 . | grep -E "M|G" | sort -h
```

## cron

![avatar](/Pictures/common/1.png)

- `crontab -e` #编辑当前用户的任务
- `crontab -l` #显示任务
- `crontab -r` #删除所有任务

```
* * * * * COMMAND      # 每分钟
*/5 * * * * COMMAND    # 每5分钟
0,5,10 * * * * COMMAND # 每小时运行三次，分别在第 0、 5 和 10 分钟运行每分钟

# 开启服务
systemctl restart cronie.service
```
# reference

- [cron](https://linux.cn/article-7513-1.html)
- [cron2](https://linux.cn/article-9687-1.html)
- [rsync](http://www.ruanyifeng.com/blog/2020/08/rsync.html)
- [sed](https://linux.cn/article-6578-1-rel.html)
- [sed2](https://linux.cn/article-10232-1.html)
- [Make 命令教程](http://www.ruanyifeng.com/blog/2015/02/make.html)

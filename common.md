<!-- vim-markdown-toc GFM -->

* [常用命令](#常用命令)
    * [rsync](#rsync)
    * [cron](#cron)
    * [字符串操作](#字符串操作)
        * [tr](#tr)
        * [sed](#sed)
        * [awk](#awk)
    * [other](#other)
        * [diff 使用](#diff-使用)
        * [查看当前分区谁在使用](#查看当前分区谁在使用)
        * [查看那个进程使用 drw.h 文件](#查看那个进程使用-drwh-文件)
        * [列出子目录的大小，并计总大小](#列出子目录的大小并计总大小)
        * [create file](#create-file)
* [reference](#reference)

<!-- vim-markdown-toc -->

# 常用命令

## rsync

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

## cron

![avatar](/Pictures/common/1.png)

- crontab -e #编辑当前用户的任务
- crontab -l #显示任务
- crontab -r #删除所有任务

```
* * * * * COMMAND      # 每分钟
*/5 * * * * COMMAND    # 每5分钟
0,5,10 * * * * COMMAND # 每小时运行三次，分别在第 0、 5 和 10 分钟运行每分钟

# 开启服务
systemctl restart cronie.service
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

### diff 使用

```bash
diff -Naur now last > last.diff
patch now < last.diff
```

### 查看当前分区谁在使用

```bash
fuser -vm .
```

### 查看那个进程使用 drw.h 文件

```bash
lsof  | grep drw.h
```

### 列出子目录的大小，并计总大小

```bash
du -cha --max-depth=1 . | grep -E "M|G" | sort -h
```

### create file

```bash
cat > FILE << "EOF"
```

# reference

- [cron](https://linux.cn/article-7513-1.html)
- [cron2](https://linux.cn/article-9687-1.html)
- [rsync](http://www.ruanyifeng.com/blog/2020/08/rsync.html)
- [sed](https://linux.cn/article-6578-1-rel.html)
- [sed2](https://linux.cn/article-10232-1.html)

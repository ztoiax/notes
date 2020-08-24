# 常用命令

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

### rsync

```sh
rsync -zvri DIR DIR1
```

### cron
![avatar](/Pictures/common/1.png)
- crontab -e #编辑当前用户的任务
- crontab -l #显示任务
- crontab -r #删除所有任务
```
* * * * * COMMAND      # 每分钟
*/5 * * * * COMMAND    # 每5分钟
0,5,10 * * * * COMMAND # 每小时运行三次，分别在第 0、 5 和 10 分钟运行每分钟
```
# reference
[cron](https://linux.cn/article-7513-1.html) 
[cron2](https://linux.cn/article-9687-1.html) 

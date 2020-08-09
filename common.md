# 常用命令
### diff使用
``` bash
diff -Naur now last > last.diff
patch now < last.diff
```
### 查看当前目录谁在使用
``` bash
fuser -vm .
```
### 列出子目录的大小，并计总大小
``` bash
duE "M|G" | sort -h
```

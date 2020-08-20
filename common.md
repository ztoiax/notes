# 常用命令

### diff 使用

```bash
diff -Naur now last > last.diff
patch now < last.diff
```

### 查看当前目录谁在使用

```bash
fuser -vm .
```

### 列出子目录的大小，并计总大小

```bash
du -cha --max-depth=1 . | grep -E "M|G" | sort -h
```

### create file

```bash
cat > test << "EOF"
```

# shell script

## cheatsheet

```sh
# - 返回上一个目录
cd -

# 等同于 mv test test.bak
mv test{,.bak}
```

获取使用最多的命令:

```sh
history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $3}' | sort | uniq -c | sort -nr | head
```

`CDPATH` 能在任何路径下通过 `cd` 进入`CDPATH` 变量下的目录，

```sh
export CDPATH='/home/tz:/home/tz/.config:/etc'
```

`$_` 和 `!$` 获取上一个命令的最后参数:

```sh
echo $_
echo !$
```

重定向:

```sh
strace -e open ls 2>&1 | grep ^n
```

## if

字符串变量 **不为空**,则执行:

```sh
a='hello'

if [ "$a" ];then
    echo $a;
else
    echo 'a is null'
fi
```

字符串变量 为**空**,则执行:

```sh
if [ -z "$b" ]; then
    echo "b is null"
fi
```

整数变量 数值判断,则执行:

```sh
int=5

if (( int == 5 ));then
    echo "int is $int"
else
    echo "int does not equal 5"
fi
```

- 字符串判断

```sh
if [ "$1" == "show" ]; then
    echo $1
fi
```

文件 **存在**,执行:

```sh
echo exist > /tmp/test

if [ -e /tmp/test ];then
    cat /tmp/test
else
    echo 'file is not exist'
fi
```

## for

```sh
for i in {1..5}; do
    echo $i;
done
```

for seq:

```sh
for i in $(seq 1 5); do
    echo $i
done
```

修改步进为 2:

```sh
for i in $(seq 1 2 5); do
    echo $i
done
```

or:

```sh
for (( i=1; i<=5; i=i+2 )); do
    echo $i;
done
```

get file on dir

```sh
for file in *;do
    echo $file
done

# get first char is 'd'
for file in d*;do
    echo $file
done
```

get file row:

```sh
echo a > /tmp/test
echo b >> /tmp/test
echo c >> /tmp/test
echo d >> /tmp/test
echo e >> /tmp/test

for i in $(cat "/tmp/test"); do
    echo $i;
done
```

做成脚本:

```sh
cat > /tmp/for.sh << 'EOF'
#!/bin/bash

IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing
for i in $(cat < "$1"); do
  echo $i
done
EOF
```

测试:

```sh
chmod 755 /tmp/for.sh
/tmp/for.sh /tmp/test
```

- [good bash 脚本集合](https://github.com/alexanderepstein/Bash-Snippets)
- [shellcheck](https://www.shellcheck.net/)

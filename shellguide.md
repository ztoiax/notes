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

## 字符串

### 字符串颜色

```sh
echo -e "\033[30m 黑色字 \033[0m"
echo -e "\033[31m 红色字 \033[0m"
echo -e "\033[32m 绿色字 \033[0m"
echo -e "\033[33m 黄色字 \033[0m"
echo -e "\033[34m 蓝色字 \033[0m"
echo -e "\033[35m 紫色字 \033[0m"
echo -e "\033[36m 青色字 \033[0m"
echo -e "\033[37m 白色字 \033[0m"
echo -e "\033[40;33m 黑底黄字 \033[0m"
echo -e "\033[41;33m 红底黄字 \033[0m"
echo -e "\033[42;33m 绿底黄字 \033[0m"
echo -e "\033[43;33m 黄底黄字 \033[0m"
echo -e "\033[44;33m 蓝底黄字 \033[0m"
echo -e "\033[45;33m 紫底黄字 \033[0m"
echo -e "\033[46;33m 青底黄字 \033[0m"
echo -e "\033[47;33m 白底黄字 \033[0m"
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

- 包含`*` 通配符
```sh
VAR='GNU/Linux is an operating system'
if [[ $VAR == *"is"* ]]; then
  echo "It's there."
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

### 读取目录下的文件

```sh
for file in *;do
    if [ -f $file ];then
        echo $file
    fi
done
```

- 读取d字符开头的文件

```sh
for file in d*;do
    if [ -f $file ];then
        echo $file
    fi
done

# 通过参数1指定字符
for file in $1*;do
    echo $file
done
```

- 指定目录

```sh
# 指定目录.sh

# for file in "$1/*";do 加入""是错误的，这会把所有的文件拼成一串字符串，再赋值给$file

for file in $1/*;do
    echo $file
done
```

```sh
# 读取末尾是.mp4的文件
for file in $1/*;do
    if [[ $file == *".mp4" ]]; then
        echo $file
    fi
done
```

### 读取指定文件的行

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

## 获取参数

```sh
#!/bin/bash
# 用户可以输入任意数量的参数，利用for循环，可以读取每一个参数。

for i in "$@"; do
  echo $i
done

#2 Solution
echo "一共输入了 $# 个参数"

while [ "$1" != "" ]; do
  echo "剩下 $# 个参数"
  echo "参数：$1"
  shift
done
```

# reference

- [阮一峰: Bash脚本教程](https://wangdoc.com/bash/intro.html)

- [good bash 脚本集合](https://github.com/alexanderepstein/Bash-Snippets)

- [shellcheck](https://www.shellcheck.net/)

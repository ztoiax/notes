# shell script

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

in file row:

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

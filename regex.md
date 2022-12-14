<!-- vim-markdown-toc GFM -->

* [regex](#regex)
    * [egrep](#egrep)
        * [`\<word\>` 匹配单词](#word-匹配单词)
        * [`\1` 反向引用,等同于前一个字符序列(结果和上面的 the 一样)](#1-反向引用等同于前一个字符序列结果和上面的-the-一样)
        * [`?` `*` `+` 表示前面的元素的数量(包含 `()` `[]` )](#---表示前面的元素的数量包含---)
    * [pcre(perl 正则表达式)](#pcreperl-正则表达式)
* [reference](#reference)

<!-- vim-markdown-toc -->

# regex

- [regex 在线工具](https://regex101.com/)

## egrep

测试文件:

```
12321https://www.google.com/
123123
https://www.baidu.com/312321  123123
https://www.bhellou.com/312321  123123
https://top.baidu.com/312321  123123
www.123.123/12312 adfasdf
321312
/home/tz/.config/nvim
123 /home/tz/ 12312312
123 /home/tz/.config
asdasdthe     theasdasd

the     the
the     The
the     hhe

$123
$123.123
$.49

9:59 am
12:30 am
12:30 pm
13:61 am
33:61 am

23:33
20:33
19:33
```

### `\<word\>` 匹配单词

```bash
egrep '\<[a-zA-Z]+\>' latest

egrep '\<the +the\>' latest
```

![image](./Pictures/regex/word.avif)

### `\1` 反向引用,等同于前一个字符序列(结果和上面的 the 一样)

```bash
egrep '\<([a-zA-Z]+) + \1\>' latest
```

![image](./Pictures/regex/refer.avif)

### `?` `*` `+` 表示前面的元素的数量(包含 `()` `[]` )

```bash
egrep  'b[aid]+u' latest
```

```bash
egrep  'b(aid|hello)+u' latest
```

![image](./Pictures/regex/+.avif)

匹配美元: `$123.123`

```bash
egrep  '\$[0-9]+(\.[0-9]*)?' latest
```

匹配时间: `12:30 am`

```bash
egrep  '(1[12]|[0-9]):[0-5][0-9] (am|pm)' latest
```

![image](./Pictures/regex/time.avif)

匹配时间: `23:30`

```bash
egrep  '(2[0-3]|1[0-9]|[0-9]):[0-5][0-9]' latest
```

## pcre(perl 正则表达式)

grep 不能支持 pcre,支持 pcre 的命令有 ag,rg 等

这里我推荐使用 [rga](https://github.com/phiresky/ripgrep-all) ,它可以搜索 gz,pdf 文件

| pcre | 匹配                     |
| ---- | ------------------------ |
| [\d] | 数字                     |
| [\w] | 数字,英文字母,下划线(\_) |
| [\s] | 空格,tab,换行符          |

- 注意大写为相反
  - 例如:[\D]为非数字

```bash
# '[\d]' 匹配数字
rga '[\d]' latest
# 等同于
egrep '[0-9]' latest

# '[\D]' 匹配非数字
rga '[\D]' latest
# 等同于
egrep '[^0-9]' latest

# '[\w]' 数字,英文字母,下划线(_)
rga '[\w]' latest
# 等同于
egrep '[0-9a-zA-Z_]' latest

# '[\s]' 空格,tab,换行符
rga '[\s]' latest
```

匹配 ip 地址

```bash
# 快速匹配,但会匹配到999.999.999.999
ip a | rga -o '([\d]{1,3}\.){3}[\d]{3}'
```

```bash
# 匹配0到9
[\d]

# 匹配0到9,00到99
([\d][\d]|[\d])

# 匹配0到9,00到99,100到199
(1[\d][\d]|[\d][\d]|[\d])

# 匹配8位,0-255.
((1[\d][\d]|2[0-5][0-5]|[\d][\d]|[\d])\.)
# 或者
((1[\d][\d]|2[0-5][0-5]|[\d]{1,2})\.)

# 匹配前24位,0-255.0-255.0-255.
((1[\d][\d]|2[0-5][0-5]|[\d][\d]|[\d])\.){3}

# 匹配0-255.0-255.0-255.0-255(\b表示空格)
ip a | rga -o '\b((1[\d][\d]|2[0-5][0-5]|[\d][\d]|[\d])\.){3}(1[\d][\d]|2[0-5][0-5]|[\d])\b'
```

![image](./Pictures/regex/ip.avif)

# reference

- [完美匹配url的正则表达式](https://mathiasbynens.be/demo/url-regex)

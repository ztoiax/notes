<!-- vim-markdown-toc GFM -->

* [kernal](#kernal)
    * [modprobe](#modprobe)
        * [基本命令](#基本命令)
    * [rmmod](#rmmod)
    * [lsmod](#lsmod)
    * [modinfo](#modinfo)
* [reference](#reference)

<!-- vim-markdown-toc -->
# kernal
内核模块是位于`/lib/modules/`目录下的具有 .ko（内核对象）扩展名的文件。 
## modprobe

### 基本命令

```sh
# 加载ath9k模块
modprobe ath9k

# 查看系统可用模块
modprobe -c

# 查看系统可用模块数
modprobe -c | wc -l
```
## rmmod 
```sh
# 卸载ath9k模块
rmmod ath9k
```
## lsmod
查看正在运行的模块
```sh
# 统计正在运行的模块
lsmod | wc -l
```
## modinfo
查看模块细节


# reference
- [如何装载/卸载 Linux 内核模块](https://linux.cn/article-9750-1.html)

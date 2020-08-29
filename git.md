# git common command

###初次运行 Git 前的配置

```bash
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
git config --global core.editor emacs
#list
git config --list
```

```bash
ssh-keygen -t rsa -C userid #your userid
```

<++>
**Warning: Permanently added the RSA host key for IP address '13.229.188.59' to the list of known hosts.**

### remote

show remote

```bash
git ls-remote
```

那么你默认的远程分支名字将会是 booyah/master。

```bash
git clone -o booyah
```

如果不想在每一次推送时都输入用户名与密码，你可以设置一个 “credential cache”

```bash
git config --global credential.helper cache
```

### reset

**禁止修改多人共用的远端分支**

#### 回退到最新的 commit(不保留文件)

可代替`git reset --hard HASD` 和`git checkout -f`(这两个操作保留文件)

```sh
git stash push -u

```

执行回退后，又想撤销

```sh
git stash pop
```

#### 合并 3 次分支

```sh
git reset --soft HEAD~3
git commit -m "reset head~3"
```

执行合并后，又想撤销

```sh
git reflog
# 找到要回退的hash后，执行reset
git reset --hard HASD
```

#### 回退单个文件

```bash
git reset <commit_id> <file_path>
#git reset作用于文件时，只会修改暂存区
git checkout .
```

### fetch

抓取到新的远程跟踪分支

```bash
git fetch
#合并
git merge
#==
git pull
```

# reference

[这才是真正的 Git——Git 实用技巧](https://zhuanlan.zhihu.com/p/192961726)

<!-- vim-markdown-toc GFM -->

* [Git](#git)
    * [初次运行 Git 前的配置](#初次运行-git-前的配置)
    * [基本命令](#基本命令)
    * [分支](#分支)
    * [commit](#commit)
        * [撤销](#撤销)
            * [基本命令](#基本命令-1)
            * [合并 3 次分支(保留文件)](#合并-3-次分支保留文件)
            * [回退单个文件](#回退单个文件)
            * [恢复干净的工作区](#恢复干净的工作区)
    * [remote](#remote)
* [git-extras](#git-extras)
* [reference](#reference)
* [优秀文章](#优秀文章)
* [关于 Git 的书](#关于-git-的书)
* [online tools](#online-tools)

<!-- vim-markdown-toc -->

# Git

- [git 命令思维导图](https://www.processon.com/view/link/5c6e2755e4b03334b523ffc3#map)

## 初次运行 Git 前的配置

```bash
# 设置userid，email，editor
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
git config --global core.editor emacs

# 如果不想在每一次推送时都输入用户名与密码，你可以设置一个 “credential cache”
git config --global credential.helper cache

# 显示设置
git config --list
```

```bash
# 生成git ssh密钥
ssh-keygen -t rsa -C <userid> #your userid
```

## 基本命令

```sh
# 初始化仓库
git init

# 查看状态
git status
# 添加进暂存区
git add <FILE>

# 当前目录下所有文件全部添加
git add --all
# 或者
git add .

# 同一文件进行多次添加
git add -p <FILE>

# 撤销进暂存区，并删除文件
git rm <FILE>

# 只撤销进暂存区
git rm --cached <FILE>

# 改名
git mv <FILE>

# 提交
git commit -m "commit name"

# 查看提交数量
git rev-list --count master

# 查看git跟踪的文件
git ls-files
```

## 分支

- [Learn Git Branching](https://learngitbranching.js.org/?demo=&locale=zh_CN)

```sh
# 显示分支
git branch

# 新建分支
git branch <BRANCH>

# 删除分支
git branch -d <BRANCH>

# 切换分支
git checkout <BRANCH>

# 切换上一个分支
git checkout -

# 选择一个commit，合并进当前分支(只新增这个commit的内容，并不会新增这个commit之前的commit)
git cherry-pick <COMMIT>
```

## commit

```sh
# 显示commit和hash的历史
git log

# 显示commit和hash的历史，以及每次commit发生变更的文件
git log --stat

# 显示commit相关的操作历史
git reflog
```

### 撤销

#### 基本命令

```sh
# 撤销文件的修改(文件回退到当前的commit)
git restore <FILE>

# 撤销到hash值所代表的commit(不保留文件)
git reset --hard <HASD>

# 撤销到hash值所代表的commit(保留文件)
git reset --soft <HASD>

# 回退后强制push远程分支
git push -u origin +master
```

#### 合并 3 次分支(保留文件)

```sh
git reset --soft HEAD~3
git commit -m "reset head~3"
```

执行合并后撤销

```sh
git reflog
# 找到要回退的hash，执行reset
git reset --hard <HASD>
```

#### 回退单个文件

```bash
git reset <commit_id> <file_path>
# git reset作用于文件时，只会修改暂存区
git checkout .
```

#### 恢复干净的工作区

```sh
# 可代替`git reset --hard <HASD>`
git stash push -u

# 执行后，又想撤销
git stash pop
```

## remote

```bash
# show remote
git ls-remote

# 显示所有远程仓库
git remote -v

# 下载远程仓库的所有变动
git fetch <REMOTE>

# 合并
git merge

# 取消合并
git merge --abort

# 取回远程仓库的变化，并与本地分支合并
git pull <REMOTE> <BRANCH>
```

[更多 git 的第三方优秀软件](https://github.com/ztoiax/notes/awesomecli#git)

# git-extras

- [git-extras](https://github.com/tj/git-extras/blob/master/Commands.md#git-alias)

# reference

- [这才是真正的 Git——Git 实用技巧](https://zhuanlan.zhihu.com/p/192961725)
- [常用 Git 命令清单](https://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)
- [git 命令思维导图](https://www.processon.com/view/link/5c6e2755e4b03334b523ffc3#map)
- [7000+ 字带你全面搞懂 Git 命令+原理！](https://mp.weixin.qq.com/s?__biz=MzA5ODM5MDU3MA==&mid=2650869124&idx=1&sn=f6c108e0be81e5ebfb9552005a602f32&chksm=8b67eac1bc1063d7024dc027e1d38ae9e7492bb6f7b27a6ef396f5cfc4e04f43a43928eab4f4&mpshare=1&scene=1&srcid=1121PpPXDPojYdulbYJvL1Do&sharer_sharetime=1605967603882&sharer_shareid=5dbb730cd6722d0343328086d9ad7dce#rd)

# 优秀文章

- [图解 Git](https://marklodato.github.io/visual-git-guide/index-zh-cn.html)
- [Git 的奇技淫巧](https://github.com/521xueweihan/git-tips)
- [这才是真正的 Git——Git 内部原理揭秘！](https://zhuanlan.zhihu.com/p/96631135)
- [这才是真正的 Git——分支合并](https://zhuanlan.zhihu.com/p/192972614)
- [这才是真正的 Git——Git 实用技巧](https://zhuanlan.zhihu.com/p/192961725)
- [详解 Git 大文件存储（Git LFS）](https://zhuanlan.zhihu.com/p/146683392)

# 关于 Git 的书

- [git book 官方教材](https://git-scm.com/book/zh/v2)
- [git magic](http://www-cs-students.stanford.edu/~blynn/gitmagic/intl/zh_cn/index.html#_%E8%87%B4%E8%B0%A2)

# online tools

- [Learn Git Branching](https://learngitbranching.js.org/?demo=&locale=zh_CN)

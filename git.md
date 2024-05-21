<!-- vim-markdown-toc GFM -->

* [Git](#git)
    * [初次运行 Git 前的配置](#初次运行-git-前的配置)
    * [连接远程github仓库](#连接远程github仓库)
    * [基本命令](#基本命令)
    * [branch(分支)](#branch分支)
        * [merge(分支合并)](#merge分支合并)
        * [worktree](#worktree)
    * [commit](#commit)
        * [撤销](#撤销)
            * [基本命令](#基本命令-1)
            * [合并 3 次分支(保留文件)](#合并-3-次分支保留文件)
            * [回退单个文件](#回退单个文件)
            * [stash(暂存)](#stash暂存)
    * [rebase](#rebase)
    * [bisect](#bisect)
    * [remote](#remote)
    * [一些问题](#一些问题)
    * [第三方git工具](#第三方git工具)
        * [git-extras](#git-extras)
        * [pre-commit](#pre-commit)
        * [sapling(facebook的版本控制工具兼容git)](#saplingfacebook的版本控制工具兼容git)
        * [git-sim（可视化git）](#git-sim可视化git)
        * [commitgpt（ai自动生成git commit）](#commitgptai自动生成git-commit)
        * [git-cliff：对history生成markdown日志](#git-cliff对history生成markdown日志)
        * [github/gitignore：A collection of useful .gitignore templates](#githubgitignorea-collection-of-useful-gitignore-templates)
        * [gitbutler：git的gui](#gitbutlergit的gui)
* [github](#github)
    * [api](#api)
    * [github工作流](#github工作流)
    * [code action](#code-action)
    * [第三方github工具](#第三方github工具)
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

## 连接远程github仓库

- [技术蛋老师：给学完Git，还不会用GitHub的朋友们](https://www.bilibili.com/video/BV1RC411W7UE)

```sh
# 添加远程github仓库地址。可以是https、ssh的地址
git remote add origin <url>

# 修改远程仓库地址
git remote set-url origin <url>

# 查看远程仓库地址
git remote -v

# 把当前分支改为main
git branch -m main
# -M强制执行
git branch -M main

# 把远程仓库同步到本地
git pull origin main

# 如果本地的commit log与远程不一致，rebase参数可以将本地的commit作为最新的commit
git pull rebase origin main

# 同步到远程仓库。-u表示以后默认这个远程地址
git push -u origin main
```

- 如果是ssh连接。需要生成密钥对。然后将公钥复制到github个人主页中的`settings`中的`SSH and GPG keys`

    ```sh
    # -T 进行连接测试
    ssh -T git@github.com
    # -i 指定私钥路径
    ssh -i ~/.ssh/id_rsa -T git@github.com
    ```

## 基本命令

```sh
# 克隆仓库
git clone
# 把github.com改为以下域名, 解决国内github访问慢的问题
git clone https://hub.fastgit.org/

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

# 显示工作区与暂存区的不同
git diff

# 显示暂存区与最近的版本 (commit) 的不同
git diff --cached

# 显示工作区与最近的版本 (commit) 的不同
git diff HEAD

# 显示两个 commit 之间的文件变动
git diff <commit-id> <commit-id>

# 查看文件是谁写的。blame 的意思为 责怪
git blame <file>

# 提交
git commit -m "commit name"

# 查看提交数量
git rev-list --count master

# 查看git跟踪的文件
git ls-files

# 查看未跟踪的文件
git ls-files --others

# 对未跟踪的文件打包压缩
git ls-files --others --exclude-standard -z |\
xargs -0 tar rvf ~/backup-untracked.zip

# 垃圾回收, 删除孤立(orphaned)的git对象
git gc --prune=now --aggressive
```

## branch(分支)

- [Learn Git Branching](https://learngitbranching.js.org/?demo=&locale=zh_CN)

```sh
# 显示本地分支
git branch

# 显示远程分支
git branch -r

# 显示本地和远程分支
git branch -a

# 新建分支
git branch <name>

# 对当前分支改名
git branch -M <new_name>

# 删除分支
git branch -d <name>

# 切换分支
git checkout <name>

# 新建一个log的commit的分支
git checkout <hash>

# 切换上一个分支
git checkout -
```

### merge(分支合并)

```sh
# 设置默认的mergetool为nvimdiff
git config merge.tool nvimdiff

# 合并分支
git merge branch2

# 合并单个或多个分支的commit hash
git cherry-pick <hash> <hash>

# 分支冲突, 解决后.会保留一个显示diff的file.orig
git mergetool

# -t 指定mergetool为diffmerge(一款gui工具)
git mergetool -t diffmerge
```

### worktree

- 创建新分支, 并且创建子目录. 新分支的修改在子目录下进行, 从而隔离

```sh
# 新建worktree1分支, 子目录名为dirname
git worktree add -b worktree1 dirname

# 查看worktree
git worktree list

# 合并worktree分支
git merge worktree1

# 先删除worktree1目录, 再删除分支
git worktree remove /home/tz/gittest/dirname
git branch -d worktree1
```

## commit

```sh
# 以编辑器的形式修改commit的文件和信息
git commit --amend --only -m 'new commit message'

# 以编辑器的形式修改commit的文件和信息
git commit --amend --only
```

- 从commit删除某个文件的修改
```sh
git checkout HEAD^ file
git add -A
git commit --amend
```

- log
```sh
# 显示上一次commit的diff
git show
# or
git log -n1 -p

# 显示commit和hash的历史
git log

# 显示commit和hash的历史，以及每次commit发生变更的文件
git log --stat

# 显示commit和hash的历史，以及每次commit发生变更的文件
git whatchanged

# 显示两个星期内的改动
git whatchanged --since='2 weeks ago'

# 显示远程仓库的commit和hash的历史
git log --oneline

# 显示简化的 commit 历史
git log --pretty=oneline --graph --decorate --all

# 将操作合并到最新一次commit
git commit --amend -m <hash>

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

# 撤销本地所有的修改，回到远程仓库的状态。
git reset --hard origin/master

# 撤销到hash值所代表的commit(保留文件)
git reset --soft <HASD>

# reset会丢失记录, 而revert是创建新的记录, 达到撤销的效果
git revert -n <HASD>

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

#### stash(暂存)

- 可以在不同的分支上使用
```sh
# 暂存最新的修改
git stash push -u

# 查看暂存列表
git stash list

# 查看某一条暂存
git stash show stash@{0}

# --patch显示更多细节
git stash show stash@{0} --patch

# 返回暂存
git stash pop

# 指定返回暂存stash@{1}
git stash pop stash@{1}

# 将暂存保存为新分支, 可以解决暂存冲突
git stash branch newbranch stash@{0}

# 删除指定暂存stash@{0}
git stash drop stash@{0}

# 删除所有暂存
git stash clear
```

## rebase

```sh
# -i 交互执行
git rebase -i <hash>

# 取消rebase
git rebase --abort

# 执行 rebase 之前自动 stash
git rebase --autostash
```

## bisect

- 对提交历史记录进行二分查找来分离出特定的提交记录。该命令在帮助我们找出是哪个提交引入了 bug 时非常有用。

    - 这为开发人员快速追踪 bug 的源头提供了一种方法，因为每次将提交历史记录分成两半，可以指数级地减少需要手动检查的提交记录数量。

```sh
# 启动bisect
git bisect start

# 要运行这个命令，需要先找到一个问题未发生的过去提交记录，这里称之为 "good_commit_id"。

# Git 会对提交记录进行二分查找，它会检查当前提交和上一个好的提交之间的提交记录。此时，开发人员需要检查或测试代码，以确定 bug 是否仍然存在。

## 如果 bug 仍然存在，则运行 git bisect bad 命令；
git bisect bad

## 如果 bug 不存在，则运行 git bisect good 命令。
git bisect good <good_commit_id>

# 将分支恢复到执行搜索之前的状态。一旦找到了引入 bug 的提交记录，搜索就会返回第一个坏的提交记录的 commit ID。从这里开始，用户可以检查引入 bug 的提交记录。然后可以执行reset
git bisect reset
```

## remote

```bash
# 显示所有远程仓库
git remote

# 显示fetch和push的连接
git remote -v

# show remote
git ls-remote

# 增加远程仓库
git remote add origin <remote-url>

# 修改远程仓库的 url
git remote set-url origin <URL>

# 下载远程仓库的所有变动
git fetch <REMOTE>

# 合并
git merge

# 取消合并
git merge --abort

# 取回远程仓库的变化，并与本地分支合并
git pull <REMOTE> <BRANCH>
```

## 一些问题

- `git status`中文乱码
    ```
    "\346\225\260\346\215\256\344\270\255\345\277\203\345\220\214\346\255\245-\347\275\221\347\273\234\351\243\216\346\232\264\351\227\256\351\242\230.avif"
    ```

    ```sh
    # 解决方法
    git config --global core.quotepath false
    ```

## 第三方git工具

### [git-extras](https://github.com/tj/git-extras/blob/master/Commands.md#git-alias)

### [pre-commit](https://github.com/pre-commit/pre-commit)

- [官方文档](https://pre-commit.com/)

- 保存为`.pre-commit-config.yaml` 文件

```yml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.3.0
    hooks:
    -   id: check-yaml
    -   id: end-of-file-fixer
    -   id: trailing-whitespace
-   repo: https://github.com/psf/black
    rev: 19.3b0
    hooks:
    -   id: black
```

- 基本使用

```sh
# 生成./git/hooks/pre-commit
pre-commit install

# 手动运行
pre-commit run --all-files

# 或者commit会自动运行
git commit -m "..."
```

### [sapling(facebook的版本控制工具兼容git)](https://sapling-scm.com/docs/introduction/)

### [git-sim（可视化git）](https://github.com/initialcommit-com/git-sim)

### [commitgpt（ai自动生成git commit）](https://zura.wiki/post/never-write-a-commit-message-again-with-the-help-of-gpt-3/)

### [git-cliff：对history生成markdown日志](https://github.com/orhun/git-cliff)

### [github/gitignore：A collection of useful .gitignore templates](https://github.com/github/gitignore)

### [gitbutler：git的gui](https://github.com/gitbutlerapp/gitbutler)

# github

- 访问速度慢的问题：

    - ghproxy方法：如这样`https://ghproxy.com/https://github.com/liuchengxu/vim-clap`

    - [GitHub520：改hosts](https://github.com/521xueweihan/GitHub520)

- [github新认证token背后的故事](https://github.blog/2021-04-05-behind-githubs-new-authentication-token-formats/)
    - token 前缀:
        - ghp for GitHub personal access tokens
        - gho for OAuth access tokens
        - ghu for GitHub user-to-server tokens
        - ghs for GitHub server-to-server tokens
        - ghr for refresh tokens

- [查看github仓库的trends](https://github-trends.com/)

- [grep app：超快的在线github搜索工具](https://grep.app/)

## api

```sh
# 这个api网址上json文件。以下命令为下载最新的linux-amd64包
curl -s https://api.github.com/repos/prometheus/mysqld_exporter/releases/latest   | grep browser_download_url | grep linux-amd64 |  cut -d '"' -f 4 | wget -qi -
```

## github工作流

- [码农高天：十分钟学会正确的github工作流，和开源作者们使用同一套流程](https://www.bilibili.com/video/BV19e4y1q7JJ)

## code action

- [GitHub Actions by Example](https://www.actionsbyexample.com/?utm_source=hackernewsletter&utm_medium=email&utm_term=code)

## 第三方github工具

- [gh-dash](https://github.com/dlvhdr/gh-dash?ref=terminaltrove)
    ![image](./Pictures/git/gh-dash.gif)
    ```sh
    # 安装
    gh extension install dlvhdr/gh-dash

    # 使用
    gh dash
    ```

# reference

- [这才是真正的 Git——Git 实用技巧](https://zhuanlan.zhihu.com/p/192961725)
- [常用 Git 命令清单](https://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)
- [git 命令思维导图](https://www.processon.com/view/link/5c6e2755e4b03334b523ffc3#map)
- [7000+ 字带你全面搞懂 Git 命令+原理！](https://mp.weixin.qq.com/s?__biz=MzA5ODM5MDU3MA==&mid=2650869124&idx=1&sn=f6c108e0be81e5ebfb9552005a602f32&chksm=8b67eac1bc1063d7024dc027e1d38ae9e7492bb6f7b27a6ef396f5cfc4e04f43a43928eab4f4&mpshare=1&scene=1&srcid=1121PpPXDPojYdulbYJvL1Do&sharer_sharetime=1605967603882&sharer_shareid=5dbb730cd6722d0343328086d9ad7dce#rd)

- [opensource.com: 5 commands to level-up your Git game](https://opensource.com/article/21/4/git-commands)

# 优秀文章

- [图解 Git](https://marklodato.github.io/visual-git-guide/index-zh-cn.html)
- [Git 的奇技淫巧](https://github.com/521xueweihan/git-tips)
- [这才是真正的 Git——Git 内部原理揭秘！](https://zhuanlan.zhihu.com/p/96631135)
- [这才是真正的 Git——分支合并](https://zhuanlan.zhihu.com/p/192972614)
- [这才是真正的 Git——Git 实用技巧](https://zhuanlan.zhihu.com/p/192961725)
- [详解 Git 大文件存储（Git LFS）](https://zhuanlan.zhihu.com/p/146683392)
- [Git 代码回滚与找回的艺术](https://mp.weixin.qq.com/s?src=11&timestamp=1624210292&ver=3142&signature=ZLIi9TNMCsGrxtjb0rb9Nqwhl6vUnbN1N2wG7h2wRs7WYeo-Z86Jypn35AJqJSfTV5XP51jr8VP3ueE6QOcBK29dmGPx3K*g2PrOonMMg62y0yIFVhVjQi-JYR18z4b1&new=1)
- [收集各种 Git 操作出现问题后的应对措施](https://github.com/k88hudson/git-flight-rules/blob/master/README_zh-CN.md)

# 关于 Git 的书

- [git book 官方教材](https://git-scm.com/book/zh/v2)
- [git magic](http://www-cs-students.stanford.edu/~blynn/gitmagic/intl/zh_cn/index.html#_%E8%87%B4%E8%B0%A2)
asd
# online tools

- [Learn Git Branching](https://learngitbranching.js.org/?demo=&locale=zh_CN)

<!-- vim-markdown-toc GFM -->

* [File](#file)
    * [advcpmv](#advcpmv)
        * [instead cp,mv](#instead-cpmv)
    * [ranger](#ranger)
    * [broot](#broot)
    * [nnn](#nnn)
    * [lf: go ranger](#lf-go-ranger)
    * [joshuto: rust ranger](#joshuto-rust-ranger)
    * [mc](#mc)
    * [fd](#fd)
        * [instead find](#instead-find)
    * [tmsu](#tmsu)
        * [taging file and mount tag file](#taging-file-and-mount-tag-file)
    * [massren](#massren)
        * [using editor rename file](#using-editor-rename-file)
    * [fselect: sql语句的ls](#fselect-sql语句的ls)
    * [jql: json查看器](#jql-json查看器)
* [git](#git)
    * [gh](#gh)
        * [github-cli官方文档](#github-cli官方文档)
    * [lazygit](#lazygit)
        * [git tui](#git-tui)
    * [bit](#bit)
        * [instead git](#instead-git)
    * [tig](#tig)
        * [git log](#git-log)
    * [hub](#hub)
    * [forgit](#forgit)
* [char](#char)
    * [exa](#exa)
        * [highlight ls](#highlight-ls)
    * [lsd](#lsd)
        * [highlight ls and support icon](#highlight-ls-and-support-icon)
    * [nat](#nat)
        * [highlight ls](#highlight-ls-1)
    * [bat](#bat)
        * [highlight cat](#highlight-cat)
    * [alder](#alder)
        * [highlight tree](#highlight-tree)
    * [ag](#ag)
        * [instead grep](#instead-grep)
    * [fzf](#fzf)
    * [diff-so-fancy](#diff-so-fancy)
        * [highlight git diff](#highlight-git-diff)
    * [icdiff](#icdiff)
        * [instead diff](#instead-diff)
    * [pet](#pet)
        * [Simple command-line snippet manager](#simple-command-line-snippet-manager)
    * [multitail](#multitail)
        * [instead tail](#instead-tail)
    * [cheat](#cheat)
        * [instead man](#instead-man)
    * [glow](#glow)
        * [markdown preview cli version](#markdown-preview-cli-version)
    * [fx](#fx)
        * [Command-line JSON processing tool](#command-line-json-processing-tool)
    * [navi: fzf command bookmark](#navi-fzf-command-bookmark)
* [disk](#disk)
    * [dfc](#dfc)
        * [instead df](#instead-df)
    * [cfdisk](#cfdisk)
        * [instead fdisk](#instead-fdisk)
    * [duf](#duf)
    * [ncdu](#ncdu)
* [net](#net)
    * [prettyping](#prettyping)
* [好看的字符](#好看的字符)
    * [neofetch](#neofetch)
    * [cpufetch](#cpufetch)
    * [figlet](#figlet)
    * [cmatrix](#cmatrix)
    * [lolcat](#lolcat)
    * [colorscript](#colorscript)
* [Social media](#social-media)
    * [googler(google)](#googlergoogle)
    * [ddgr(DuckDuckGo)](#ddgrduckduckgo)
    * [rtv(reddit cli)](#rtvreddit-cli)
    * [rainbowstream(twitter)](#rainbowstreamtwitter)
    * [haxor-news(hacknew)](#haxor-newshacknew)
* [other](#other)
    * [Termshark](#termshark)
        * [wireshark cli version with vim keybinds](#wireshark-cli-version-with-vim-keybinds)
    * [baidupcs](#baidupcs)
        * [The terminal utility for Baidu Network Disk.](#the-terminal-utility-for-baidu-network-disk)
    * [bypy](#bypy)
        * [百度网盘 Python 客户端](#百度网盘-python-客户端)
    * [haxor-news](#haxor-news)
        * [Browse Hacker News](#browse-hacker-news)
    * [fim](#fim)
        * [在终端下查看图片](#在终端下查看图片)
    * [imgdiff](#imgdiff)
        * [pixel-by-pixel image difference tool.](#pixel-by-pixel-image-difference-tool)
    * [onedrive](#onedrive)
        * [本地同步 onedrive](#本地同步-onedrive)
    * [xonsh](#xonsh)
        * [python shell](#python-shell)
        * [ytfzf](#ytfzf)
        * [ix](#ix)
        * [cloc(统计代码)](#cloc统计代码)
        * [openrefine: json, csv...网页操作](#openrefine-json-csv网页操作)
        * [npkill: 查找和清理node_module](#npkill-查找和清理node_module)
        * [zx: 更优秀的shell编程,Google用nodejs写的一个shell包装器](#zx-更优秀的shell编程google用nodejs写的一个shell包装器)
        * [syncthing: 同步文件](#syncthing-同步文件)
        * [croc: 文件传输](#croc-文件传输)
        * [slidev: markdown写ppt](#slidev-markdown写ppt)
* [reference](#reference)

<!-- vim-markdown-toc -->

# File

## [advcpmv](https://github.com/jarun/advcpmv)

### instead cp,mv

```sh
alias mv="advmv -g"
alias cp="advcp -g"
```

## [ranger](https://github.com/ranger/ranger)

![image](./Pictures/awesomecli/5.png)

## [broot](https://github.com/Canop/broot)

![image](./Pictures/awesomecli/1.gif)

## [nnn](https://github.com/jarun/nnn)

```sh
git clone https://github.com/jarun/nnn.git
cd nnn
sudo cp nnn /bin/
# 显示图标
sudo make O_NERD=1
```
![image](./Pictures/awesomecli/4.png)

## [lf: go ranger](https://github.com/gokcehan/lf)
## [joshuto: rust ranger](https://github.com/kamiyaa/joshuto)
## [mc](https://github.com/MidnightCommander/mc)

支持鼠标操作
![image](./Pictures/awesomecli/13.png)

## [fd](https://github.com/sharkdp/fd)

### instead find

## [tmsu](https://github.com/oniony/TMSU)

### taging file and mount tag file

## [massren](https://github.com/laurent22/massren)

### using editor rename file

## [fselect: sql语句的ls](https://github.com/jhspetersson/fselect)

## [jql: json查看器](https://github.com/cube2222/jql)

![image](./Pictures/awesomecli/jql.png)

# git

## [gh](https://github.com/cli/cli)

```sh
# 登陆
gh auth login

# 查看登陆
gh auth status

# 创建仓库
gh repo create gh-test

# 查看所有仓库
gh repo list

# 查看指定仓库
gh repo view https://github.com/ztoiax/nvim

# 创建issue
gh issue create

# 查看issue
gh issue list

# 创建release
gh release create r1

# 查看release
gh release list
```

### github-cli[官方文档](https://cli.github.com/manual/)

## [lazygit](https://github.com/jesseduffield/lazygit)

### git tui

![image](./Pictures/awesomecli/lazygit.png)

## [bit](https://github.com/chriswalz/bit)

### instead git

![image](./Pictures/awesomecli/15.png)

## [tig](https://github.com/jonas/tig)

### git log

![image](./Pictures/awesomecli/tig.png)

## [hub](https://hub.github.com/)

## [forgit](https://github.com/wfxr/forgit)

![image](./Pictures/awesomecli/forgit.png)

# char

## [exa](https://github.com/ogham/exa)

### highlight ls

![image](./Pictures/awesomecli/11.png)

## [lsd](https://github.com/Peltoche/lsd)

### highlight ls and support icon

![image](./Pictures/awesomecli/14.png)

## [nat](https://github.com/willdoescode/nat)

### highlight ls

## [bat](https://github.com/sharkdp/bat)

![image](./Pictures/awesomecli/9.png)

### highlight cat

## alder

### highlight tree

![image](./Pictures/awesomecli/14.png)

## ag

### instead grep

## [fzf](https://github.com/junegunn/fzf)

![image](./Pictures/awesomecli/8.png)
```sh
# 模糊搜索
fzf

# -e 取消模糊搜索
fzf -e
```

## [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)

![image](./Pictures/awesomecli/10.png)

### highlight git diff

## [icdiff](https://github.com/jeffkaufman/icdiff)

### instead diff

## [pet](https://github.com/knqyf263/pet)

![image](./Pictures/awesomecli/3.png)

### Simple command-line snippet manager

## multitail

### instead tail

## [cheat](https://github.com/cheat/cheat)

![image](./Pictures/awesomecli/cheat.png)

### instead man

## [glow](https://github.com/charmbracelet/glow)

### markdown preview cli version

![image](./Pictures/awesomecli/16.png)

## [fx](https://github.com/antonmedv/fx)

### Command-line JSON processing tool

## [navi: fzf command bookmark](https://github.com/denisidoro/navi)

# disk

## [dfc](https://github.com/Rolinh/dfc)

![image](./Pictures/awesomecli/6.png)

### instead df

## cfdisk

### instead fdisk

![image](./Pictures/awesomecli/7.png)

## [duf](https://github.com/muesli/duf)

![image](./Pictures/awesomecli/2.png)

## [ncdu](https://github.com/rofl0r/ncdu)

![image](./Pictures/awesomecli/ncdu.png)

# net

## [prettyping](https://github.com/denilsonsa/prettyping)

![image](./Pictures/awesomecli/ping.png)

# 好看的字符

## [neofetch](https://github.com/dylanaraps/neofetch)

![image](./Pictures/awesomecli/neofetch.png)

## [cpufetch](https://github.com/Dr-Noob/cpufetch)

![image](./Pictures/awesomecli/cpufetch.png)

## [figlet](https://github.com/cmatsuoka/figlet)

![image](./Pictures/awesomecli/figlet.png)

## [cmatrix](https://github.com/abishekvashok/cmatrix)

![image](./Pictures/awesomecli/cmatrix.png)

## [lolcat](https://github.com/busyloop/lolcat)

![image](./Pictures/awesomecli/lolcat.png)

## [colorscript](https://gitlab.com/dwt1/shell-color-scripts)

![image](./Pictures/awesomecli/colorscript.png)

# Social media

## [googler(google)](https://github.com/jarun/googler)
## [ddgr(DuckDuckGo)](https://github.com/jarun/ddgr)

## [rtv(reddit cli)](https://github.com/michael-lazar/rtv)
## [rainbowstream(twitter)](https://github.com/orakaro/rainbowstream)
![image](./Pictures/awesomecli/rtv.png)

## [haxor-news(hacknew)](https://github.com/donnemartin/haxor-news)
# other

## [Termshark](https://github.com/gcla/termshark)

### wireshark cli version with vim keybinds

![image](./Pictures/awesomecli/1.png)

## [baidupcs](https://github.com/GangZhuo/BaiduPCS)

### The terminal utility for Baidu Network Disk.

## [bypy](https://github.com/houtianze/bypy)

### 百度网盘 Python 客户端

## [haxor-news](https://github.com/donnemartin/haxor-news)

### Browse Hacker News

## fim

### 在终端下查看图片

## [imgdiff](https://github.com/n7olkachev/imgdiff)

### pixel-by-pixel image difference tool.

## [onedrive](https://github.com/skilion/onedrive)

### 本地同步 onedrive

## [xonsh](https://github.com/xonsh/xonsh)

![image](./Pictures/awesomecli/xonsh.png)

### python shell

- [xonsh 插件](https://xon.sh/xontribs.html)

### ytfzf

- [fzf搜索,播放youtube](https://github.com/pystardust/ytfzf)

### ix

- [pastbin](http://ix.io/)

    - [bpa:一个在线网页版](https://bpa.st/)

```sh
cat test.py | curl -F 'f:1=<-' ix.io
```

### [cloc(统计代码)](https://github.com/AlDanial/cloc)

![image](./Pictures/awesomecli/cloc.png)

### [openrefine: json, csv...网页操作](https://github.com/OpenRefine/OpenRefine)

![image](./Pictures/awesomecli/openrefine.png)

### [npkill: 查找和清理node_module](https://github.com/voidcosmos/npkill)

![image](./Pictures/awesomecli/npkill.png)

### [zx: 更优秀的shell编程,Google用nodejs写的一个shell包装器](https://github.com/google/zx)

### [syncthing: 同步文件](https://github.com/syncthing/syncthing)

### [croc: 文件传输](https://github.com/schollz/croc)

### [slidev: markdown写ppt](https://github.com/slidevjs/slidev)

# reference

- [命令行基础工具的更佳替代品](https://linux.cn/article-4042-1.html)
- [命令行：增强版](https://linux.cn/article-10171-1.html)

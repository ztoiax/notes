# terminal simulator (终端模拟器)

## [alacritty](https://github.com/alacritty/alacritty)

- [滚动性能对比](https://jwilm.io/blog/alacritty-lands-scrollback/)

- 缺点:

    - [启动速度慢](https://github.com/alacritty/alacritty/issues/782)
    ```sh
     sudo perf stat -r 10 -d alacritty -e false
    ```

## [wezterm:用rust写, 支持gpu加速](https://github.com/wez/wezterm)

## [tabby](https://github.com/Eugeny/tabby)

## [ttyd: 浏览器terminal](https://github.com/tsl0922/ttyd)

## [termpair: 网页操作终端](https://github.com/cs01/termpair)

# File Browser

## [ranger](https://github.com/ranger/ranger)

![image](./Pictures/awesomecli/5.avif)

## [visidata: 支持查看sqlite的文件管理器](https://github.com/saulpw/visidata)

![image](./Pictures/awesomecli/visidata.avif)

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
![image](./Pictures/awesomecli/4.avif)

## [lf: go ranger](https://github.com/gokcehan/lf)
## [joshuto: rust ranger](https://github.com/kamiyaa/joshuto)
## [mc](https://github.com/MidnightCommander/mc)

支持鼠标操作
![image](./Pictures/awesomecli/13.avif)

# File

## [advcpmv: instead cp, my(https://github.com/jarun/advcpmv)

```sh
alias mv="advmv -g"
alias cp="advcp -g"
```

## [fd: instead find](https://github.com/sharkdp/fd)

## [tmsu: taging file and mount tag file](https://github.com/oniony/TMSU)

## [massren: using editor rename file](https://github.com/laurent22/massren)

## [fselect: sql语句的ls](https://github.com/jhspetersson/fselect)

## [jql: json过滤器](https://github.com/cube2222/jql)

![image](./Pictures/awesomecli/jql.avif)

## [jless:json查看器](https://github.com/PaulJuliusMartinez/jless)

## [jo:生成json对象](https://github.com/jpmens/jo)

```sh
jo -p name=jo n=17 parser=false
seq 1 10 | jo -a
```

## [jc:以json文本输出命令](https://github.com/kellyjonbrazil/jc)

```sh
# dig命令
jc dig example.com
dig example.com | jc --dig

# arp命令 -p 加入换行符，显示更直观
jc -p arp
arp | jc --arp -p

# df命令
jc -p df
```

## [dsq: sql语句查看json, csv, nginxlog](https://github.com/multiprocessio/dsq)

```sh
# 查看mac地址
ip --json addr show | dsq -s json "SELECT address FROM {}"
```

## [htmlq:html版jq](https://github.com/mgdm/htmlq)

```sh
# 显示a标签
curl www.baidu.com | htmlq 'a' | bat --language html
```

## [yq:yaml查看器](https://github.com/mikefarah/yq)

- [官方文档](https://mikefarah.gitbook.io/yq/)

## [xsv:csv查看器](https://github.com/BurntSushi/xsv)

## [OctoSQL: sql语句查看文件](https://github.com/cube2222/octosql)

## [termscp: tui文件传输](https://github.com/veeso/termscp)

## [fq: 二进制查看器](https://github.com/wader/fq)

## vidir: 编辑器批量改名
```sh
find . -type f | vidir -
```

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

![image](./Pictures/awesomecli/lazygit.avif)

## [gitui](https://github.com/extrawurst/gitui)

![image](./Pictures/awesomecli/gitui.avif)

## [bit](https://github.com/chriswalz/bit)

### instead git

![image](./Pictures/awesomecli/15.avif)

## [tig](https://github.com/jonas/tig)

### git log

![image](./Pictures/awesomecli/tig.avif)

## [hub](https://hub.github.com/)

## [forgit](https://github.com/wfxr/forgit)

![image](./Pictures/awesomecli/forgit.avif)

# char

## [viddy:instead watch](https://github.com/sachaos/viddy)

## [exa](https://github.com/ogham/exa)

### highlight ls

![image](./Pictures/awesomecli/11.avif)

## [lsd](https://github.com/Peltoche/lsd)

### highlight ls and support icon

![image](./Pictures/awesomecli/14.avif)

## [nat](https://github.com/willdoescode/nat)

### highlight ls

## [bat](https://github.com/sharkdp/bat)

![image](./Pictures/awesomecli/9.avif)

### highlight cat

## alder

### highlight tree

![image](./Pictures/awesomecli/14.avif)

## ag

### instead grep

## [fzf](https://github.com/junegunn/fzf)

![image](./Pictures/awesomecli/8.avif)
```sh
# 模糊搜索
fzf

# -e 取消模糊搜索
fzf -e
```
## [skim](https://github.com/lotabout/skim)

### rust 版fzf

## [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)

![image](./Pictures/awesomecli/10.avif)

### highlight git diff

## [icdiff](https://github.com/jeffkaufman/icdiff)

### instead diff

## [git-split-diffs: github style diff](https://github.com/banga/git-split-diffs)

### instead git diff

## [pet](https://github.com/knqyf263/pet)

![image](./Pictures/awesomecli/3.avif)

### Simple command-line snippet manager

## multitail

### instead tail

## [cheat](https://github.com/cheat/cheat)

![image](./Pictures/awesomecli/cheat.avif)

### instead man

## [glow](https://github.com/charmbracelet/glow)

### markdown preview cli version

![image](./Pictures/awesomecli/16.avif)

## [fx](https://github.com/antonmedv/fx)

### Command-line JSON processing tool

## [navi: fzf command bookmark](https://github.com/denisidoro/navi)

## [trash-cli](https://github.com/andreafrancia/trash-cli)

### 回收站

## [choose: instead od](https://github.com/theryangeary/choose)

```sh
# 选取第1列
echo '1 2 3' | choose 0

# 选取最后第1列
echo '1 2 3' | choose -1

# 选取第2到3列
echo '1 2 3' | choose 1:2

# 选取第2到最后一列
echo '1 2 3' | choose 1:

# -f 设置分隔符
cat /etc/passwd | choose -f ':' -1
```

## [peco: 搜索过滤器](https://github.com/peco/peco)

```sh
ps aux | peco
```

# disk

## [dfc](https://github.com/Rolinh/dfc)

![image](./Pictures/awesomecli/6.avif)

### instead df

## cfdisk

### instead fdisk

![image](./Pictures/awesomecli/7.avif)

## [duf](https://github.com/muesli/duf)

![image](./Pictures/awesomecli/2.avif)

## [ncdu](https://github.com/rofl0r/ncdu)

![image](./Pictures/awesomecli/ncdu.avif)

## [dust](https://github.com/bootandy/dust)

### instead du

![image](./Pictures/awesomecli/dust.avif)

# process

## [procs](https://github.com/dalance/procs)

### instead ps

![image](./Pictures/awesomecli/procs.avif)

## [pueue(任务管理)](https://github.com/Nukesor/pueue/wiki/Get-started)

# net

## [prettyping: instead ping](https://github.com/denilsonsa/prettyping)

## [curlie: instead curl](https://github.com/rs/curlie)

![image](./Pictures/awesomecli/curlie.avif)

## [dog: instead dig](https://github.com/ogham/dog)

![image](./Pictures/awesomecli/dog.avif)

## [Termshark: wireshark cli](https://github.com/gcla/termshark)

![image](./Pictures/awesomecli/1.avif)

# 好看的字符

## [neofetch](https://github.com/dylanaraps/neofetch)

![image](./Pictures/awesomecli/neofetch.avif)

## [cpufetch](https://github.com/Dr-Noob/cpufetch)

![image](./Pictures/awesomecli/cpufetch.avif)

## [figlet](https://github.com/cmatsuoka/figlet)

![image](./Pictures/awesomecli/figlet.avif)

## [cmatrix](https://github.com/abishekvashok/cmatrix)

![image](./Pictures/awesomecli/cmatrix.avif)

## [lolcat](https://github.com/busyloop/lolcat)

![image](./Pictures/awesomecli/lolcat.avif)

## [colorscript](https://gitlab.com/dwt1/shell-color-scripts)

![image](./Pictures/awesomecli/colorscript.avif)

# Social media

## [googler(google)](https://github.com/jarun/googler)
## [ddgr(DuckDuckGo)](https://github.com/jarun/ddgr)

## [rtv(reddit cli)](https://github.com/michael-lazar/rtv)
## [rainbowstream(twitter)](https://github.com/orakaro/rainbowstream)
![image](./Pictures/awesomecli/rtv.avif)

## [haxor-news(hacknew)](https://github.com/donnemartin/haxor-news)

# 压缩

## [svgo: svg压缩](https://github.com/svg/svgo)
```sh
svgo file.svg -o newfile.svg
```

# 图片工具

## cwebp

```sh
# png转webp
cwebp -lossless input.png -o output.webp
```

## [image magick: 图片的ffmpeg](https://github.com/ImageMagick/ImageMagick)

- [官方文档](https://legacy.imagemagick.org/Usage/)

- `identify`

```sh
# 查看支持的格式
identify -list format

# 查看图片的信息
identify -verbose file.png
```

- `display`

```sh
# 显示图片
display file.png
display *.png

# 缩小50%
display -resize 50% file.png

# 黑白显示
display -monochrome file.png
display -charcoal 1.2 file.png

# 只显示8种颜色
display -colors 8 TSO.png
```

- `convert`

```sh
# 转换编码
convert file.png file.webp
convert file.png file.avif

# 转换为黑白图片
convert -monochrome file.png file.avif
# 转换为黑白图片，再把黑白反过来
convert  -canny 0x1 TSO.png TSO.avif
```

- 压缩图片
```sh
# 转换为avif
magick -quality 75 file.png file.avif

# 压缩效果比上一条要好，但处理更慢
magick -define heic:speed=2 file.png file.avif
```

- `compare`

```sh
# 对比
compare file.png file.png x:
```

- `montage`(蒙太奇)

```sh
montage -label %f wallhaven-1.jpg wallhaven-2.jpg -geometry +10 -shadow -title 'charcoal demo' charcoal_demo.jpg
```

## [squoosh:Google开发的图片压缩](https://github.com/GoogleChromeLabs/squoosh)

```sh
# 安装
npm i @squoosh/cli

# 转换为avif
squoosh-cli --avif '{speed: 2}' file.jpg
```


## fim: 图片浏览器

## [timg: 在终端下查看图片和视频](https://github.com/hzeller/timg)

```sh
# 在kitty终端模拟器可以全像素显示
timg filename.jpeg -p kitty

# --loops循环
timg --loops=3 filename.gif
```

## [imgdiff:图片对比](https://github.com/n7olkachev/imgdiff)

# downloader

## [lux: 视频下载器](https://github.com/iawia002/lux)

```sh
# -i 查看清晰度
lux -i "https://www.bilibili.com/video/BV1x54y1B7RE"
```

# 网盘客户端

## [baidupcs: 百度网盘客户端](https://github.com/GangZhuo/BaiduPCS)

## [aliyunpan:阿里网盘go客户端](https://github.com/tickstep/aliyunpan#linux--macos)

## [bypy: 百度网盘python客户端](https://github.com/houtianze/bypy)

## [onedrive](https://github.com/skilion/onedrive)

# other

## [haxor-news: hacker new](https://github.com/donnemartin/haxor-news)

## [xonsh: python shell](https://github.com/xonsh/xonsh)

    ![image](./Pictures/awesomecli/xonsh.avif)

    - [xonsh 插件](https://xon.sh/xontribs.html)

## ytfzf

- [fzf搜索,播放youtube](https://github.com/pystardust/ytfzf)

## ix

- [pastbin](http://ix.io/)

    - [bpa:一个在线网页版](https://bpa.st/)

```sh
cat test.py | curl -F 'f:1=<-' ix.io
```

## [cloc(统计代码)](https://github.com/AlDanial/cloc)

![image](./Pictures/awesomecli/cloc.avif)

## [openrefine: json, csv...网页操作](https://github.com/OpenRefine/OpenRefine)

![image](./Pictures/awesomecli/openrefine.avif)

## [npkill: 查找和清理node_module](https://github.com/voidcosmos/npkill)

![image](./Pictures/awesomecli/npkill.avif)

## [zx: 更优秀的shell编程,Google用nodejs写的一个shell包装器](https://github.com/google/zx)

## [syncthing: 同步文件](https://github.com/syncthing/syncthing)

## [croc: 文件传输](https://github.com/schollz/croc)

## [slidev: markdown写ppt](https://github.com/slidevjs/slidev)

## [q: sql语法查询文件](https://github.com/harelba/q)
```sh
q "SELECT * FROM mysql_slow.log"

# 只显示前两列
q "SELECT c1, c2 FROM mysql_slow.log"

# 只显示前两列, 并且第一列包含COUNT
q "SELECT c1, c2 FROM mysql_slow.log WHERE c1 LIKE '%COUNT%'"

ps -ef | q -H "select count(UID) from - where UID='root'"
```
## [sunloginclient-cli(向日葵运程控制cli版)](https://sunlogin.oray.com/download)

## [fanyi(翻译)](https://github.com/afc163/fanyi)
```sh
# 需要安装festival
pacman -S festival
```

## [cheat.sh: 更好的man](https://github.com/chubin/cheat.sh#usage)
- 1.使用curl获取(未安装的使用方法):
    ```sh
    # 获取rsync命令
    curl https://cheat.sh/rsync

    # 获取python requests
    curl https://cheat.sh/python/requests

    # 获取python requests get
    curl https://cheat.sh/python/requests+get
    ```
- 2.安装后的用法:
    ```sh
    cht.sh rsync
    cht.sh python requests
    cht.sh python requests get
    ```

## tokei(统计编程语言占比)

## [markdown写ppt](https://github.com/webpro/reveal-md/)

## [sql语句检查](https://github.com/sqlfluff/sqlfluff)

## [ocrmypdf: pdf图片转文字](https://github.com/ocrmypdf/OCRmyPDF)

```sh
# 安装程序
pip install ocrmypdf

# 安装中文简体、英文语言包
pacman -S tesseract-data-chi_sim tesseract-data-eng

# -l选择语言包
ocrmypdf -l chi_sim file.pdf new_file.pdf
```

## [osquery: sql语句查询系统配置和参数](https://github.com/osquery/osquery)

- [官方文档](https://osquery.readthedocs.io/en/stable/introduction/sql/)

```sh
# 进入osquery数据库
osqueryi

# 查询用户
SELECT * FROM users;

# 查询进程
SELECT * FROM processes;
```

## [firejail：沙箱运行](https://github.com/netblue30/firejail)

- 默认会让chrome沙箱运行，保存文件到home目录，可能会有问题

## screen：虚拟终端

- [腾云先锋团队：Linux终端命令神器--Screen命令详解。助力Linux使用和管理](https://cloud.tencent.com/developer/article/1844735)

```sh
# 查看虚拟终端
screen -ls

# 创建
screen -R name

# 创建后按Ctril+a，返回主终端

# 返回
screen -r pid/name

# 退出终端
exit
```

## [xdotool：模拟键盘](https://github.com/jordansissel/xdotool)

```sh
xdotool type "Hello world"

xdotool key ctrl+l
```

# ai
- [shell_gpt：生成命令行](https://github.com/TheR1D/shell_gpt)

# reference

- [现代版命令行基础工具](https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/)

- [modern-unix: 类似项目](https://github.com/ibraheemdev/modern-unix)

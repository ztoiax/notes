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

## [sshx：通过浏览器远程访问，共享的终端。体验有点卡](https://github.com/ekzhang/sshx?tab=readme-ov-file)

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

## [twf：vim模式的文件树](https://github.com/wvanlint/twf)

## [superfile](https://github.com/yorukot/superfile)

![image](./Pictures/awesomecli/superfile.avif)

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

## [jq:json处理](https://github.com/jqlang/jq)

```sh
# 格式化
echo '{"people" : {"name": "tz", "age": 26}}' | jq '.'
curl http://api.open-notify.org/iss-now.json | jq '.'

# 读取文件
echo '{"people" : {"name": "tz", "age": 26}, "people1": {"name": "joe", "age": 10}}' > /tmp/test
jq '.' /tmp/test
# 内嵌读取
jq '.people' /tmp/test
jq '.people.name' /tmp/test

# 获取所有key
jq '. | keys' /tmp/test
jq '.people | keys' /tmp/test
jq '.[].age | min' /tmp/test
```

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

## [jnv：交互式搜索json](https://github.com/ynqa/jnv)

```sh
cat test.json | jnv
# or
jnv test.json
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

```sh
# 查看csv文件
xsv table test.csv

# 查看第一行
xsv headers test.csv

# 统计长度
xsv stats test.csv --everything | xsv table

# 创建索引，可以提升速度。会在当前目录创建test.csv.idx文件
xsv index test.csv

# 只显示input列和显示input + output列
xsv select input test.csv
xsv select input,output test.csv

# 只显示input列并且字符是包含0-4
xsv search -s input '[0-4]' test.csv
```

## [tabiew：tui查看csv、tsv、json](https://github.com/shshemi/tabiew)

## [csvlens：tui查看csv、json](https://github.com/YS-L/csvlens)

## [OctoSQL: sql语句查看文件](https://github.com/cube2222/octosql)

## [termscp: tui文件传输](https://github.com/veeso/termscp)

## [fq: 二进制查看器](https://github.com/wader/fq)

## vidir: 编辑器批量改名
```sh
find . -type f | vidir -
```

## [mutagen：文件同步到远程服务器，也可以充当中间人在2个远程文件系统之间同步](https://github.com/mutagen-io/mutagen)

## [zrok：端对端共享文件](https://github.com/openziti/zrok)
```sh
zrok share public localhost:8080
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

## [gitoxide:rust版git](https://github.com/Byron/gitoxide)

## [delta：highlight git diff](https://github.com/dandavison/delta)

# char

## [tp：tui实时输出基础命令。如find、grep、jq等](https://github.com/minefuto/tp)

## [docfd：tui的grep。支持fuzzy](https://github.com/darrenldl/docfd)
## [viddy:instead watch](https://github.com/sachaos/viddy)

## [eza：highlight ls](https://github.com/eza-community/eza)
## [exa：highlight ls.很久没更新了，建议使用eza](https://github.com/ogham/exa)

![image](./Pictures/awesomecli/11.avif)

## [erd：highlight ls](https://github.com/solidiquis/erdtree)

## [lsd：highlight ls](https://github.com/Peltoche/lsd)

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

## [skim：rust 版fzf](https://github.com/lotabout/skim)

## [zf：zig版fzf](https://github.com/natecraddock/zf)

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

## [grex：自动生成正则表达式](https://github.com/pemistahl/grex)

```sh
# 生成匹配haha和HAHA的正则表达式
grex -c haha HAHA
```

## [sd：instead sed](https://github.com/chmln/sd)

```sh
# sed和sd的对比
sed -i -e 's/before/after/g' file.txt
sd before after file.txt
```

## [sad：instead sed](https://github.com/ms-jpq/sad)

```sh
# 将filename 中的1替换成2
ls filename | sad '1' '2'

# 通过diff-so-fancy显示替换前后的不同。不进行替换
ls filename | sad '1' '2' | diff-so-fancy | less

# 通过delta显示替换前后的不同。不进行替换
ls filename | sad '1' '2' | delta
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

## [gdu：tui模式的du](https://github.com/dundee/gdu)

# process

## [procs](https://github.com/dalance/procs)

### instead ps

![image](./Pictures/awesomecli/procs.avif)

## [pueue(任务管理)](https://github.com/Nukesor/pueue/wiki/Get-started)

## [killport：输入指定端口，杀掉进程](https://github.com/jkfran/killport)

## [devbox：隔离空间运行](https://github.com/jetpack-io/devbox)

```sh
# 先生成devbox.json
devbox init

# 启动shell。需要安装nix
devbox shell
```

# net

## [curlconverter：将curl转换为编程语言的代码](https://github.com/curlconverter/curlconverter)

- [各种curl命令](https://www.httpbin.org/)

- [官方在线转换](https://curlconverter.com/)

## [prettyping: instead ping](https://github.com/denilsonsa/prettyping)

## [curlie: instead curl](https://github.com/rs/curlie)

## [hurl：通过文件定义curl](https://github.com/Orange-OpenSource/hurl)

- 新建文件：`/tmp/test`
    ```
    # Get home:
    GET https://example.org
    HTTP 200
    [Captures]
    csrf_token: xpath "string(//meta[@name='_csrf_token']/@content)"


    # Do login!
    POST https://example.org/login?user=toto&password=1234
    X-CSRF-TOKEN: {{csrf_token}}
    HTTP 302
    ```

```sh
# 执行文件
hurl /tmp/test
```

## [dog: instead dig](https://github.com/ogham/dog)

![image](./Pictures/awesomecli/dog.avif)

## [doggo：human doggo](https://github.com/mr-karan/doggo?ref=terminaltrove)

## [Termshark: wireshark cli](https://github.com/gcla/termshark)

![image](./Pictures/awesomecli/1.avif)

# 好看的字符

## [neofetch](https://github.com/dylanaraps/neofetch)

![image](./Pictures/awesomecli/neofetch.avif)

## [fastfetch：比neofetch更快，显示信息更多](https://github.com/fastfetch-cli/fastfetch)

## [onefetch：显示git仓库信息](https://github.com/o2sh/onefetch)

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

## [cmd-wrapped：读取你的命令行操作历史记录，并生成详细的分析报告。](https://github.com/YiNNx/cmd-wrapped)

# 硬件

## [amdgpu：tui](https://github.com/Umio-Yasuno/amdgpu_top)

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

# 多媒体

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

## [video2x：视频和图像无损放大工具。该项目集成了多种超分辨率算法（如 Waifu2x、Anime4K、Real-ESRGAN），能够有效提高视频和图像的分辨率，并提供了图形界面（GUI）、Docker 和命令行界面（CLI）的使用方式](https://github.com/k4yt3x/video2x)

- [官方文档](https://github.com/k4yt3x/video2x/wiki/CLI)

```sh
python -m video2x \               # execute the video2x module
    -i input.mp4 -o output.mp4 \  # input and output file path
    upscale \                     # set mode to upscale
    -h 1080 \                     # set output height to 720px (aspect ratio is preserved)
    -a waifu2x \                  # use waifu2x to upscale
    -n3                           # set noise level to 3
```

# downloader

## [cobalt：下载视频、音频](https://github.com/imputnet/cobalt)

- 1、bilibili.com 和 bilibili.tv：支持视频 + 音频、仅音频、仅视频下载，提供丰富的文件名。

- 2、dailymotion：支持视频 + 音频、仅音频、仅视频下载，提供元数据和丰富的文件名。

- 3、Instagram 帖子和故事：支持视频 + 音频、仅音频、仅视频下载。

- 4、Instagram Reels：支持视频 + 音频、仅音频、仅视频下载。

- 5、其他支持的服务包括 ok 视频、Pinterest、Reddit、rutube、SoundCloud、Streamable、TikTok、Tumblr、Twitch Clips、Twitter 等。

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

# 国内知名网站的第三方客户端

## [fav：b站收藏下载](https://github.com/kingwingfly/fav)

## [netease-music-tui：网易云音乐tui](https://github.com/betta-cyber/netease-music-tui)

# 游戏相关

## [shadPS4：开源的 PS4 模拟器。虽然项目仍处于早期开发阶段，能运行的游戏有限，但最新版已经能够成功运行《血源诅咒》和《黑暗之魂II》等游戏。](https://github.com/shadps4-emu/shadPS4)

# other

## [chsrc：全平台通用换源工具与框架](https://github.com/RubyMetric/chsrc)

## [progress：显示cp、mv进度条](https://github.com/Xfennec/progress)

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

## [sql语句检查](https://github.com/sqlfluff/sqlfluff)

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

## [vhs:命令行录制生成gif](https://github.com/charmbracelet/vhs)

## [silicon：对代码文件，生成图片](https://github.com/Aloxaf/silicon)

```sh
silicon test.py -o main.png
```

## [taskwarrior：任务管理](https://github.com/GothenburgBitFactory/taskwarrior)

- [taskwarrior-tui：任务管理tui](https://github.com/kdheepak/taskwarrior-tui)

## [ast-grep：结构化搜索与替换（SSR）](https://github.com/ast-grep/ast-grep)

## [lazynpm：npm的tui](https://github.com/jesseduffield/lazynpm)

## [sshs：ssh的tui](https://github.com/quantumsheep/sshs)

## [termpscp：scp的tui](https://github.com/veeso/termscp)

## [ugm：用户、组的tui](https://github.com/ariasmn/ugm)

## [glance：自定义dashboard：rss、github release、twitch channel等](https://github.com/glanceapp/glance)

## [amber：编译成bash的编程语言，包含类型安全](https://amber-lang.com/)

## [trufflehog：发现和验证 Git 仓库中泄露的凭证和敏感信息。](https://github.com/trufflesecurity/trufflehog)

# 系统相关

## [kmon：内核模块、dmesg的tui](https://github.com/orhun/kmon)

## [nemu：qemu的tui](https://github.com/nemuTUI/nemu)

## [osqueryi：使用sql语句查询操作系统](https://github.com/osquery/osquery)

```sql
# 启动osqueryi
osqueryi

-- 查询用户
select * from users;

-- 进程名、监听端口、pid
SELECT DISTINCT processes.name, listening_ports.port, processes.pid
  FROM listening_ports JOIN processes USING (pid)
  WHERE listening_ports.address = '0.0.0.0';
```

# 磁盘备份

## [restic](https://github.com/restic/restic)

- [官方文档](https://restic.readthedocs.io/en/latest/)

- 一款强大的开源备份工具。该项目提供了简单、快速、安全的开源备份解决方案。它无需繁琐的配置，即可轻松完成备份和恢复操作。

- 采用增量备份策略，备份数据经过加密和压缩处理，保障数据安全且节省空间，支持灵活的存储选择，包括本地磁盘和云存储。可设置自动备份时间，确保数据得到定期的备份保护。

```sh
# 需要输入密码
restic init --repo /tmp/backup

# 备份~/st目录。需要验证密码。执行后变成了一个文件/tmp/backup/data/c1/c14f12ee55181fb97ef8c94a92ea72a3c72e8845bd36edb399800bc6da507734
restic --repo /tmp/backup backup ~/st
```

# pdf、mobi、epub

## [Web2pdf](https://github.com/dvcoolarun/web2pdf)

## [ocrmypdf: pdf图片转文字](https://github.com/ocrmypdf/OCRmyPDF)

```sh
# 安装程序
pip install ocrmypdf

# 安装中文简体、英文语言包
pacman -S tesseract-data-chi_sim tesseract-data-eng

# -l选择语言包
ocrmypdf -l chi_sim file.pdf new_file.pdf
```

## [weread-exporter：将微信读书中的书籍导出成epub、pdf、mobi等格式](https://github.com/drunkdream/weread-exporter)

## [zerox：pdf转markdown](https://github.com/getomni-ai/zerox)

## [Stirling-PDF：自部署 PDF 处理工具](https://github.com/Stirling-Tools/Stirling-PDF)

# log

## [lnav：tui的vim模式，查看log、json文件](https://github.com/tstack/lnav)

```sh
# 查看nginx的access日志
lnav /usr/local/nginx/logs/access.log

# 查看json文集
lnav file.json

# 查看journalctl
journalctl | lnav

# 滚动模式
journalctl -f | lnav

# 设置输出模式
journalctl -o short-iso | lnav
journalctl -o json | lnav
```

## [logdy](https://github.com/logdyhq/logdy-core)
# modern unix

- [tailspin](https://github.com/bensadeh/tailspin)

# markdown

- [see：markdown好看的浏览](https://github.com/guilhermeprokisch/see)

- [glow：markdown好看的浏览](https://github.com/charmbracelet/glow)
    ![image](./Pictures/awesomecli/16.avif)

- [mdcat：markdown好看的浏览](https://github.com/swsnr/mdcat)

- [frogmouth：markdown浏览的文件管理器（tui）](https://github.com/Textualize/frogmouth)

- [mlc:检测markdown文件的连接](https://github.com/becheran/mlc)

- [slidev: markdown写ppt](https://github.com/slidevjs/slidev)

- [markdown写ppt](https://github.com/webpro/reveal-md/)

- [rucola：markdown管理tui](https://github.com/Linus-Mussmaecher/rucola)

- [mermaid-cli：markdown转思维导图](https://github.com/mermaid-js/mermaid-cli)
    ```sh
    mmdc -i input.mmd -o output.svg
    ```

# ai

- [shell_gpt：生成命令行](https://github.com/TheR1D/shell_gpt)

- [ollama](https://github.com/ollama/ollama)

- [LM Studio：ollama gui版](https://lmstudio.ai/)
    - [lms：LM Studio command line](https://github.com/lmstudio-ai/lms)

- [oterm：Ollama客户端](https://github.com/ggozad/oterm)

- [hollama：ollama web客户端](https://github.com/fmaclen/hollama)

- [open-webui：ollama ui](https://github.com/open-webui/open-webui)

- [reor：ai私人助手](https://github.com/reorproject/reor)

- [reader：将网址放到https://r.jina.ai/便可获取markdown文档的总结](https://github.com/jina-ai/reader)
    - [在线网址](https://jina.ai/reader/)

    ```sh
    curl -H "Accept: text/event-stream" https://r.jina.ai/https://www.bilibili.com/video/BV1bD421n7dg
    ```

- [aider](https://github.com/paul-gauthier/aider)这是一款运行在终端里的 AI 辅助编码工具，能够将你本地 git 仓库中的代码与 LLMs 结合起来。开发者通过 add 命令引入文件，然后用自然语言描述需求，它就可以对现有的代码进行修改并自动提交，支持接入多种大模型，包括 GPT 3.5、GPT-4 和 Claude 3 Opus 等。

- [exo：组建ai集群](https://github.com/exo-explore/exo)

# reference

- [现代版命令行基础工具](https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/)

- [modern-unix: 类似项目](https://github.com/ibraheemdev/modern-unix)

- [terminaltrove：专注于 CLI 和 TUI 工具的网站](https://terminaltrove.com/list/)

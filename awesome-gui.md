
<!-- mtoc-start -->

* [常用](#常用)
* [操作系统](#操作系统)
* [file](#file)
  * [文件传输](#文件传输)
  * [文件管理器](#文件管理器)
  * [文件清理](#文件清理)
  * [云盘](#云盘)
* [下载器](#下载器)
* [图片](#图片)
  * [image viewer(图片查看器)](#image-viewer图片查看器)
    * [qt](#qt)
    * [gtk](#gtk)
    * [caesium-image-compressor：图片压缩。配备了实时预览和批量处理的功能](#caesium-image-compressor图片压缩配备了实时预览和批量处理的功能)
  * [截图](#截图)
* [视频](#视频)
* [远程控制](#远程控制)
  * [ssh客户端](#ssh客户端)
* [note](#note)
* [ide](#ide)
* [硬件](#硬件)
* [other](#other)
* [类似项目](#类似项目)

<!-- mtoc-end -->

# 常用

- [SPlayer：网易云音乐](https://github.com/imsyy/SPlayer)

# 操作系统

- [LibreELEC：基于KODI，适合用于电视；有docker等功能；复古游戏模拟器；自带smb](https://github.com/LibreELEC/LibreELEC.tv)

- [CoreELEC：基于KODI，适合用于电视](https://github.com/CoreELEC/CoreELEC)

# file

- [filelight](https://kde.org/applications/en/filelight)

    ![image](./Pictures/awesomegui/filelight.avif)

- [bleachbit: 清理工具](https://www.bleachbit.org/)

    ![image](./Pictures/awesomegui/bleachbit.avif)

- [stacer](https://github.com/oguzhaninan/Stacer)

    ![image](./Pictures/awesomegui/stacer.avif)

- [timeshif: backup](https://github.com/teejee2008/timeshift.avif)

- [typora](https://www.typora.io/)

    ![image](./Pictures/awesomegui/typora.avif)

- [sioyek: pdf阅读器](https://github.com/ahrm/sioyek)

- [zathura: pdf, epub阅读器](https://github.com/pwmt/zathura)

- [foliate: pdf, epub阅读器](https://github.com/johnfactotum/foliate)

- [syncthing：文件同步](https://github.com/syncthing/syncthing)

- [photoprism：ai相册管理](https://github.com/photoprism/photoprism)

## 文件传输

- [localsend](https://github.com/localsend/localsend)

- [kdeconnect：还可以控制手机](https://github.com/KDE/kdeconnect-kde)

## 文件管理器

- [dolphin](https://github.com/KDE/dolphin)

- pcmanfm(文件管理器)

- [sigma-file-manager](https://github.com/aleksey-hoffman/sigma-file-manager)

- [xplorer](https://github.com/kimlimjustin/xplorer)

## 文件清理

- [czkawka：多功能文件清理工具](https://github.com/qarmin/czkawka)

## 云盘

- [蜗牛云盘：阿里云盘第三方](https://github.com/liupan1890/aliyunpan/issues/901)

- [aliyunpan：阿里云盘第三方](https://github.com/liupan1890/aliyunpan)

- [clouddrive：云盘管理](https://github.com/cloud-fs/cloud-fs.github.io/releases)

- [alist:可添加各种网盘的网页文件管理器](https://github.com/alist-org/alist)
    - 使用davfs2挂载
    ```sh
    # 安装davfs2
    sudo pacman -S davfs2

    # mount到yun目录
    mkdir yun
    sudo mount -t davfs http://127.0.0.1:5244/dav yun
    ```

# 下载器

- [Motrix](https://github.com/agalwood/Motrix)

- [imfile：基于Motrix](https://github.com/imfile-io/imfile-desktop)
    - 支持下载 HTTP、FTP、BitTorrent、Magnet 等

- [tribler：bt搜索和下载工具](https://www.tribler.org/download.html)：国内用户要设置无匿名，不然可能会出现资源下不动。

- [rats-search：bt搜索和下载工具，可以打开别的客户端下载](https://github.com/DEgITx/rats-search)

- [persepolis：aria2 gui](https://persepolisdm.github.io/)

- [fdm](https://www.freedownloadmanager.org/zh/)

- [xdman](https://xtremedownloadmanager.com/)

- [mediago：视频下载器，支持m3u8](https://github.com/caorushizi/mediago)

- [ab-download-manager：类似idm的下载器](https://github.com/amir1376/ab-download-manager)

# 图片

- [upscayl：ai图片质量提升](https://github.com/upscayl/upscayl)

- [pot-desktop：划词翻译，并支持ocr](https://github.com/pot-app/pot-desktop)

- [PicGo：图床上传下载](https://github.com/Molunerfinn/PicGo)

## image viewer(图片查看器)

### qt

- [qt-avif-image-plugin（avif格式支持）](https://github.com/novomesk/qt-avif-image-plugin)

- [nomacs](https://github.com/nomacs/nomacs)

- [qview](https://github.com/jurplel/qView)

### gtk

- [gthumb](https://github.com/GNOME/gthumb)

### [caesium-image-compressor：图片压缩。配备了实时预览和批量处理的功能](caesium-image-compressor)

![image](./Pictures/awesomegui/caesium-image-compressor.avif)

## 截图

- [deepin-screen-recorder：deepin的截图软件。支持录屏，长截图](https://github.com/linuxdeepin/deepin-screen-recorder)

- [Snipaste：windows很出名的截图软件。支持窗口识别，固定截图](https://github.com/Snipaste)

- [flameshot：火焰截图](https://github.com/flameshot-org/flameshot)

- [Umi-OCR：ocr](https://github.com/hiroi-sora/Umi-OCR)

# 视频

- [pyvideotrans：给视频配音、翻译配音、添加字幕](https://github.com/jianchang512/pyvideotrans)

- [lossless-cut：视频剪切软件，目标是成为 FFmpeg 的图形前端。](https://github.com/mifi/lossless-cut)

# 远程控制

- [rustdesk](https://github.com/rustdesk/rustdesk)

- [ToDesk](https://github.com/ji4ozhu/ToDesk)

- [lan-mouse：键盘和鼠标共享。一台电脑的键鼠控制其他电脑](https://github.com/feschber/lan-mouse)

- [deskflow：键盘和鼠标共享。一台电脑的键鼠控制其他电脑](https://github.com/deskflow/deskflow)

- [linkandroid：连接android](https://github.com/modstart-lib/linkandroid)

## ssh客户端

- [shell360](https://github.com/shell360)

- [xpipe](https://github.com/xpipe-io/xpipe)

# note

- [zotero：文献管理工具](https://github.com/zotero/zotero)

- [zotero-gpt](https://github.com/MuiseDestiny/zotero-gpt)

# ide

- [positron：数据科学 IDE](https://github.com/posit-dev/positron)基于 VSCode 构建了一个可复制的编写和发布的桌面开发环境，支持运行 Python 和 R 代码、自动补全等功能

# 硬件

- [corectrl：查看cpu、gpu信息，显示监控曲线图](https://gitlab.com/corectrl/corectrl)

- [LACT：amd gpu控制器](https://github.com/ilya-zlobintsev/LACT)

# other

- [linux-wifi-hotspot](https://github.com/lakinduakash/linux-wifi-hotspot)

- [noti: 任务完成后通知](https://github.com/variadico/noti)

- [sunloginclient(向日葵运程控制gui版)](https://sunlogin.oray.com/download)

- [keynav：键盘控制鼠标](https://github.com/jordansissel/keynav)

- [lx-music-desktop：一个基于 electron 的音乐软件](https://github.com/lyswhut/lx-music-desktop)

- [增强版qbittorrent](https://github.com/c0re100/qBittorrent-Enhanced-Edition)
    - [trackerslist](https://trackerslist.com/all.txt)
    - [海盗湾](https://thepiratebay.org/index.html)

- [qv2ray](https://github.com/Qv2ray/Qv2ray)

- [nekoray:v2ray客户端](https://github.com/MatsuriDayo/nekoray)

- [veracrypt：加密](https://github.com/veracrypt/VeraCrypt)

- [session：加密通信](https://getsession.org/download)

- [bitwarden：密码管理器](https://bitwarden.com/download/)

- [timeshift](https://github.com/teejee2008/timeshift)

- [gImageReader：ocr，但不太准确](https://github.com/manisandro/gImageReader)

- [quivr：该项目利用生成式 AI 的能力，成为你的第二大脑。你可以将多种格式的文本、数据、语言和视频上传给它，之后再和它对话时，它会学习你上传的内容后回答你的问题，支持接入多种 LLM 和 Docker 一键部署。](https://github.com/QuivrHQ/quivr)

- [netease-cloud-music-gtk：网易云音乐gtk4版](https://github.com/gmg137/netease-cloud-music-gtk)

- [drawio-desktop](https://github.com/jgraph/drawio-desktop)

- [etcher：USB/SD 启动盘制作工具](https://github.com/balena-io/etcher)

- [stellarium：天象模拟软件](https://github.com/Stellarium/stellarium)
    - 支持：windows、linux、macos、android、ios

- [input-overlay：显示用户操作输入的 OBS 直播插件。该项目是用来在直播中显示键盘按键、鼠标移动和游戏手柄按钮的插件](https://github.com/univrsal/input-overlay)

![image](./Pictures/awesomegui/input-overlay.avif)

- [rubick：工具箱、启动框](https://github.com/rubickCenter/rubick)

- [neko：该项目是运行在 Docker 容器中的自托管虚拟浏览器环境，为用户提供安全、隔离和功能齐全的虚拟浏览器。](https://github.com/m1k1o/neko)

- [fluent-reader：rss订阅和阅读器](https://github.com/yang991178/fluent-reader)

- [balena-etcher：写镜像到u盘](https://github.com/balena-io/etcher)

- [redroid：docker上跑安卓](https://github.com/remote-android/redroid-doc)

    - [ReDroid教學：用Docker跑Android系統，在x86電腦玩ARM手機遊戲](https://ivonblog.com/posts/redroid-android-docker/)

    ```sh
    # android15
    docker run -itd --rm --privileged \
        --pull always \
        -v ~/.config/redroid/data15:/data \
        -p 5555:5555 \
        --name redroid15 \
        redroid/redroid:15.0.0-latest
    ```

    ```sh
    # adb连接
    adb connect localhost:5555

    # scrcpy投屏
    scrcpy -s localhost:5555
    ```

- [waydroid：安卓系统。并不是模拟器，而是直接构建](https://github.com/waydroid/waydroid)

    - [waydroid-helper：gui配置waydroid](https://github.com/ayasa520/waydroid-helper)

    - [在下莫老师：在PC上满速运行Android应用，WayDroid安装使用指南](https://www.bilibili.com/video/BV18z421B7YB)

    - 不支持英伟达gpu，只支持intel和amd
    - 运行在wayland，但x11也可以运行可以安装`weston`，然后在`weston`下启动waydroid

        ```sh
        # 打开weston
        weston

        # 打开终端

        # 设置环境为wayland，避免报错
        export XDG_SESSION_TYPE=wayland

        # 启动waydroid
        sudo systemctl restart waydroid-container.service

        # 显示界面
        waydroid show-full-ui
        ```

    - 需要内核需要安装binder模块。可以直接安装`linux-zen`内核，也可以安装`binder_linux-dkms`

    - [waydroid_script：安装gapp、面具、arm转移层等脚本](https://github.com/casualsnek/waydroid_script)
        - arm转移层，amd推荐使用`libndk`；intel推荐使用`libhoudini`

    - 剪切板需要安装`python-pyclip`

    ```sh
    # 设置多窗口
    waydroid prop set persist.waydroid.multi_windows true
    # 防止多窗口时，出现多个鼠标指针
    waydroid prop set persist.waydroid.cursor_on_subsurface true
    # 鼠标模拟触控
    waydroid prop set persist.waydroid.fake_touch com.hypergryph.arknights

    # 将Download文件夹挂载到waydroid里
    sudo mount --bind ~/Downloads ~/.local/share/waydroid/data/media/0/Download
    ```

    ```sh
    # 下载waydroid脚本
    git clone https://github.com/casualsnek/waydroid_script
    ```

# 类似项目

- [linux 下的惬意生活](https://github.com/yangyangwithgnu/the_new_world_linux#%E7%9B%AE%E5%BD%95)

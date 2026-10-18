---
id: awesome-gui
aliases: []
tags: []
---


<!-- mtoc-start -->

* [操作系统](#操作系统)
  * [KODI相关的电视操作系统](#kodi相关的电视操作系统)
  * [安卓](#安卓)
  * [linux发行版](#linux发行版)
  * [nas](#nas)
    * [nas软件](#nas软件)
  * [其他os](#其他os)
  * [虚拟机系统](#虚拟机系统)
* [file](#file)
  * [文件传输](#文件传输)
  * [文件管理器](#文件管理器)
  * [文件清理](#文件清理)
  * [云盘](#云盘)
  * [其他](#其他)
* [多媒体相关](#多媒体相关)
  * [下载器](#下载器)
    * [支持下载各种平台的下载器](#支持下载各种平台的下载器)
  * [图片](#图片)
    * [image viewer(图片查看器)](#image-viewer图片查看器)
      * [qt](#qt)
      * [gtk](#gtk)
      * [caesium-image-compressor：图片压缩。配备了实时预览和批量处理的功能](#caesium-image-compressor图片压缩配备了实时预览和批量处理的功能)
    * [本地图片管理](#本地图片管理)
    * [截图](#截图)
    * [录屏](#录屏)
    * [ocr截图识别文字](#ocr截图识别文字)
    * [图片压缩](#图片压缩)
    * [提升画质](#提升画质)
    * [其他](#其他-1)
  * [视频](#视频)
    * [播放器](#播放器)
    * [服务](#服务)
    * [ai提升视频质量](#ai提升视频质量)
    * [剪辑](#剪辑)
    * [其他](#其他-2)
  * [漫画](#漫画)
  * [音乐播放器](#音乐播放器)
    * [基于平台源的音乐播放器](#基于平台源的音乐播放器)
    * [音乐下载](#音乐下载)
  * [音频](#音频)
  * [追番](#追番)
  * [邮件](#邮件)
  * [阅读和笔记相关](#阅读和笔记相关)
    * [阅读器](#阅读器)
    * [markdown相关](#markdown相关)
    * [note](#note)
    * [画图](#画图)
  * [游戏相关](#游戏相关)
    * [模拟器](#模拟器)
* [工具](#工具)
  * [键盘鼠标相关](#键盘鼠标相关)
  * [翻译](#翻译)
  * [投屏和远程控制](#投屏和远程控制)
    * [手机与电脑交互](#手机与电脑交互)
    * [电脑与电脑屏幕共享](#电脑与电脑屏幕共享)
    * [ssh客户端](#ssh客户端)
  * [密码相关](#密码相关)
  * [镜像u盘相关](#镜像u盘相关)
* [浏览器](#浏览器)
* [第三方客户端](#第三方客户端)
* [流行软件相关](#流行软件相关)
  * [微信相关](#微信相关)
* [金融](#金融)
* [桌面工具](#桌面工具)
* [通信](#通信)
* [运行windows程序](#运行windows程序)
* [其他](#其他-3)
* [类似项目](#类似项目)

<!-- mtoc-end -->

# 操作系统

## KODI相关的电视操作系统

- [LibreELEC：基于KODI，适合用于电视；有docker等功能；复古游戏模拟器；自带smb](https://github.com/LibreELEC/LibreELEC.tv)

- [CoreELEC：基于KODI，适合用于电视](https://github.com/CoreELEC/CoreELEC)

## 安卓

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

## linux发行版

- [DistroWatch: linux发行版排行榜网站](https://distrowatch.com/)

- [SteamOS：基于archlinux](https://store.steampowered.com/steamos/)

- [batocera.linux：包含各种游戏模拟器的linux发行版，开机就是游戏机](https://batocera.org/)
    - [在下莫老师：Batocera+Ventoy，打造一个多合一终极模拟器游戏U盘](https://www.bilibili.com/video/BV1Vw411Y7Vm)

- [FydeOS - 面向未来的操作系统，为中国用户打造的 ChromeOS](https://fydeos.com/)

- [AnduinOS：基于ubuntu改造类似windows11界面的linux](https://www.anduinos.com/)

- [microsoft/azurelinux: 微软自己的linux发行版，基于Fedora](https://github.com/microsoft/azurelinux)

- [Astra Linux：俄罗斯国防部和军队的linux发行版](https://astralinux.ru/)

## nas

- [飞牛 fnOS - 免费 NAS 操作系统](https://fnnas.com/)

- [GEAK OS - Smart NAS Operating System | AI-Powered Private Cloud](https://www.geakos.com/)

- [fortOS: NAS OS](https://github.com/GeneralLibrary/fortOS)

- [istoreos: 提供一个人人会用的的路由、NAS系统 （目前活跃的分支是 istoreos-24.10，main或master分支不维护请勿使用）](https://github.com/istoreos/istoreos)

### nas软件

- [NasCabOS：windows nas面板服务端。支持android、tv、ios等客户端](https://nas.cab/)

## 其他os

- [Redox：rust编写的os](https://www.redox-os.org/)

- [ravynOS：基于Darwin、FreeBSD和苹果开源代码的早期（预测试）开源操作系统，旨在兼容macOS应用程序，且无硬件限制。](https://ravynos.com/)

- [airyx: A BSD-based OS project that aims to provide an experience like and some compatibility with macOS](https://github.com/onyet/airyx)

## 虚拟机系统

- [android-lineage-qemu: LineageOS for QEMU virtual machines](https://github.com/jqssun/android-lineage-qemu)

- [Bass OS - Android x86_64, Raspberry Pi & VirtIO Kiosk OS](https://bassos.navotpala.tech/)

# file

## 文件传输


- [localsend](https://github.com/localsend/localsend)

- [lightningvine-docs: 闪电藤是基于LocalSend的二次开发产品，在原有局域网文件传输基础上，增加了webdav传输和云传输的能力，是一个万能的文件传输助手。](https://github.com/cmlanche/lightningvine-docs)

- [LANFileShare: 将本地文件夹通过变成网站传输，支持局域网和公网](https://github.com/hasderhi/LANFileShare)

- [LANDrop/LANDrop: Drop any files to any devices on your LAN.](https://github.com/LANDrop/LANDrop)

- [LANChat: 一款支持文件传输的跨平台局域网聊天软件，用Rust编写。A cross-platform LAN chat software that supports file transfer, written in Rust.](https://github.com/cap153/LANChat)

- [kdeconnect：还可以控制手机](https://github.com/KDE/kdeconnect-kde)

- [packet: android的AirDrop](https://github.com/nozwock/packet)

- [deltachat-desktop: 非局域网文件互传，同时也是聊天软件](https://github.com/deltachat/deltachat-desktop)

- [PairDrop: 文件传输，通过web浏览器](https://github.com/schlagmichdoch/PairDrop)

- [alt-sendme: 这是一款采用 Rust 和 Tauri 构建的开源 P2P 文件传输工具，无需注册和服务器，即可实现端到端的文件传输。用户只需将文件拖入应用，将随机生成的传输凭证发给接收方，对方输入后即可轻松接收文件。](https://github.com/tonyantony300/alt-sendme)

- [tiez-clipboard: TieZ 是一款基于 Tauri 的跨平台剪贴板管理器。支持剪切板分类、持久化保存、同步，文件局域网传输等功能](https://github.com/jimuzhe/tiez-clipboard)

## 文件管理器

- [dolphin](https://github.com/KDE/dolphin)

- pcmanfm(文件管理器)

- [sigma-file-manager](https://github.com/aleksey-hoffman/sigma-file-manager)

- [xplorer](https://github.com/kimlimjustin/xplorer)

- [FileExplorer: rust和Tauri和React写的跨平台文件管理器](https://github.com/conaticus/FileExplorer)

- [kodbox: 开源的网页文件管理器。](https://github.com/kalcaddle/kodbox)

- [filestash：跨平台一个网页版的文件管理器，支持 S3、FTP、WebDAV、Git、Mysql、Backblaze 等各种协议和云服务。](https://github.com/mickael-kerjean/filestash)
    - [fdrive: Universal File Sync](https://github.com/mickael-kerjean/fdrive)

## 文件清理

- [bleachbit: 清理工具](https://www.bleachbit.org/)

    ![image](./Pictures/awesomegui/bleachbit.avif)

- [czkawka：多功能文件清理工具](https://github.com/qarmin/czkawka)
    - 重复文件终结者
    - 空文件夹清理
    - 相似图片识别：连水印都不放过
    - 视频清理：视觉相似的“侦探”
    - 坏文件侦测：数据管理的“安全卫士”
    - 无效符号链接修复：让系统更健康
    - 垃圾文件清理：临时文件的“天敌”

- [WhoShitsonMyC: 通过扫描磁盘建立快照，实现磁盘空间变化对比轻量小工具](https://github.com/Kami958/WhoShitsonMyC)

## 云盘

- [蜗牛云盘：阿里云盘第三方](https://github.com/liupan1890/aliyunpan/issues/901)

- [aliyunpan：阿里云盘第三方](https://github.com/liupan1890/aliyunpan)

- [clouddrive：云盘管理](https://github.com/cloud-fs/cloud-fs.github.io/releases)

- [小白羊网盘](https://github.com/gaozhangmin/aliyunpan)
- [alist:可添加各种网盘的网页文件管理器](https://github.com/alist-org/alist)
    - 使用davfs2挂载
    ```sh
    # 安装davfs2
    sudo paclman -S davfs2

    # mount到yun目录
    mkdir yun
    sudo mount -t davfs http://127.0.0.1:5244/dav yun
    ```

- [OpenList: alist被收购，这是alist社区版。](https://github.com/OpenListTeam/OpenList)
    - [OpenList-Worker: OpenList-Worker 是官方 OpenListTeam/OpenList 项目的 TypeScript + Serverless 移植版，后端由 Go 重写为运行于 Workers 的 TypeScript 服务，前端保持一致的界面与交互体验。](https://github.com/OpenListTeam/OpenList-Worker)
    - [NextList: 基于 JS/TS 重构 Go 内核服务，使其支持部署在service less环境下。](https://github.com/Mcchen1008/NextList)

- [YaoList: Rust+React版的alist](https://github.com/ChuYao233/YaoList)

- [quark-auto-save: 夸克网盘签到、自动转存、命名整理、发推送提醒和刷新媒体库一条龙](https://github.com/Cp0204/quark-auto-save)

- [taosync: 同步到网盘的工具。TaoSync是一个适用于OpenList v3+的自动化同步工具/Sync for OpenList/AList](https://github.com/dr34m-cn/taosync)

## 其他

- [filelight](https://kde.org/applications/en/filelight)

    ![image](./Pictures/awesomegui/filelight.avif)

- [stacer](https://github.com/oguzhaninan/Stacer)

    ![image](./Pictures/awesomegui/stacer.avif)

- [timeshif: backup](https://github.com/teejee2008/timeshift.avif)

- [typora](https://www.typora.io/)

    ![image](./Pictures/awesomegui/typora.avif)


- [syncthing：文件同步](https://github.com/syncthing/syncthing)

- [PeaZip: ：免费开源的文件压缩解压工具。这是一款免费、开源、跨平台的文件压缩和解压工具，支持超过 200 种压缩格式（7Z、ZIP、RAR、TAR、ISO、Zstd），具备文件压缩、解压、加密、分卷、校验、格式转换和批量操作等功能。支持linux、windows、macos](https://github.com/peazip/PeaZip)

- [Arqiver: qt的压缩解压工具](https://github.com/tsujan/Arqiver)

- [dupeguru: 查找重复文件](https://github.com/arsenetar/dupeguru)

# 多媒体相关

## 下载器

- [Surge: 终端tui的高速下载工具，比ariac2快。这是一款采用 Go 语言开发的终端下载工具，可将下载文件自动切分为多个数据块并行下载，支持从多个镜像源下载、自动故障转移、顺序下载模式等功能。](https://github.com/surge-downloader/Surge)

- [aria2-next: 跨平台Redefining the next generation of aria2](https://github.com/AnInsomniacy/aria2-next)

- [AriaNg: aria2的web gui。需要浏览器的插件进行启动](https://github.com/mayswind/AriaNg)

- [gopeed: A modern download manager that supports all platforms. Built with Golang and Flutter.](https://github.com/GopeedLab/gopeed)
    - [gopeed-extension-wxmp: Gopeed 微信公众号视频下载扩展](https://github.com/monkeyWie/gopeed-extension-wxmp)
    - [gopeed-extension-baiduwp: Gopeed 百度网盘下载扩展。](https://github.com/monkeyWie/gopeed-extension-baiduwp)
    - [gopeed-extension-quark: Gopeed 扩展，用于解析夸克网盘分享链接并下载文件。](https://github.com/muyan556/gopeed-extension-quark)
    - [gopeed-extension-bilibili: Bilibili video download extension of gopeed.](https://github.com/monkeyWie/gopeed-extension-bilibili)
    - [gopeed-extension-youtube: Youtube video download extension of gopeed.](https://github.com/monkeyWie/gopeed-extension-youtube)
    - [gopeed-extension-twitter: Twitter media download extension of gopeed.](https://github.com/monkeyWie/gopeed-extension-twitter)
    - [gopeed-extension-huggingface: A gopeed-extension for downloading models and datasets from huggingface, hf-mirror and modelscope. Huggingface download](https://github.com/DSYZayn/gopeed-extension-huggingface)
- [Hitomi-Downloader: yt-dlp的gui版](https://github.com/KurtBestor/Hitomi-Downloader)

- [axel: cli命令行下载](https://github.com/axel-download-accelerator/axel)

- [Motrix](https://github.com/agalwood/Motrix)

- [imfile：基于Motrix，因此imfile和Motrix只能安装其中一个](https://github.com/imfile-io/imfile-desktop)
    - 支持下载 HTTP、FTP、BitTorrent、Magnet 等

- [motrix-next：Tauri和vue3从写motrix。支持aria2](https://github.com/AnInsomniacy/motrix-next)
- [rayburst: 跨平台下载器。使用 Aria2 Next 作为下载引擎，这是一个维护的 aria2 分支](https://github.com/AnInsomniacy/rayburst)

- [tribler：bt搜索和下载工具](https://www.tribler.org/download.html)：国内用户要设置无匿名，不然可能会出现资源下不动。

- [rats-search：bt搜索和下载工具，可以打开别的客户端下载](https://github.com/DEgITx/rats-search)

- [persepolis：aria2 gui](https://persepolisdm.github.io/)

- [fdm](https://www.freedownloadmanager.org/zh/)

- [xdman](https://xtremedownloadmanager.com/)

- [mediago：视频下载器，支持m3u8](https://github.com/caorushizi/mediago)

- [Fluent-M3U8:视频下载器，支持m3u8。A cross-platform m3u8/mpd downloader based on PySide6 and QFluentWidgets.](https://github.com/zhiyiYo/Fluent-M3U8)

- [ab-download-manager：类似idm的下载器](https://github.com/amir1376/ab-download-manager)

- [JDownloader.org - Official Homepage](https://jdownloader.org/home/index)

- [amule: ed2k下载](https://github.com/amule-project/amule)

- [mldonkey: 支持 ED2K、Kad、BitTorrent 等多种网络](https://github.com/ygrek/mldonkey)
- [FileCentipede: Cross-platform internet upload/download manager for HTTP(S), FTP(S), SSH, magnet-link, BitTorrent, m3u8, ed2k, and online videos. WebDAV client, FTP client, SSH client.](https://github.com/filecxx/FileCentipede)

- [Tixati：跨平台的下载器，可以代替迅雷](https://tixati.com/)

- [Ghost-Downloader-3: A cross-platform QUIC AI-boost fluent-design multi-threaded downloader built with Python.](https://github.com/XiaoYouChR/Ghost-Downloader-3)

- [FluxDown: Rust 驱动的多协议下载管理器，支持 HTTP/FTP/BitTorrent 磁力链接及 HLS/DASH 流媒体，智能多线程加速与浏览器无缝集成。精美界面，极致性能，永久免费，零广告。](https://github.com/zerx-lab/FluxDown)

- [hydra: A fast, resilient, multi-source file retriever and download engine](https://github.com/ja7ad/hydra)

- [增强版qbittorrent](https://github.com/c0re100/qBittorrent-Enhanced-Edition)
    - [trackerslist](https://trackerslist.com/all.txt)
    - [海盗湾](https://thepiratebay.org/index.html)

### 支持下载各种平台的下载器

- [ytDownloader: gui下载器，支持数百种平台如youtube、bilibli等](https://github.com/aandrew-me/ytDownloader)

- [videdown: 跨平台Videdown 是一款现代化的开源视频下载工具，让你可以从抖音 小红书 B站 YT Instagram等网站下载无水印高清视频](https://github.com/cshuangyy/videdown)

- [res-downloader: 嗅探抓取资源。视频号、小程序、抖音、快手、小红书、直播流、m3u8、酷狗、QQ音乐等常见网络资源下载!](https://github.com/putyy/res-downloader?tab=readme-ov-file)

- [VidBee: yt-dlp的gui版。还支持rss自动下载功能，只要订阅了up主后，发布的新视频可以自动下载。还有浏览器插件，可以下载的内容，页面上会显示下载按钮。](https://github.com/nexmoe/VidBee)


## 图片

### image viewer(图片查看器)

#### qt

- [qt-avif-image-plugin（avif格式支持）](https://github.com/novomesk/qt-avif-image-plugin)

- [nomacs](https://github.com/nomacs/nomacs)

- [qview](https://github.com/jurplel/qView)

- [gwenview: KDE的](https://github.com/KDE/gwenview)

- [KDE/digikam: digiKam is an advanced open-source digital photo management application that runs on Linux, Windows, and MacOS. The application provides a comprehensive set of tools for importing, managing, editing, and sharing photos and raw files.](https://github.com/KDE/digikam)

#### gtk

- [gthumb：GNOME的](https://github.com/GNOME/gthumb)

#### [caesium-image-compressor：图片压缩。配备了实时预览和批量处理的功能](caesium-image-compressor)

![image](./Pictures/awesomegui/caesium-image-compressor.avif)

- [shotwell: Read-only mirror of https://gitlab.gnome.org/GNOME/shotwell](https://github.com/GNOME/shotwell)

### 本地图片管理

- [lap: An offline-first photo manager for large local libraries](https://github.com/julyx10/lap)

- [di管理gikam：本地图片管理](https://www.digikam.org/)

- [afilmory: 本地图片管理。Modern photo gallery for photographers, with S3/GitHub sync, EXIF details, maps, and a WebGL viewer.](https://github.com/Afilmory/afilmory)

### 截图

- [deepin-screen-recorder：deepin的截图软件。支持录屏，长截图](https://github.com/linuxdeepin/deepin-screen-recorder)

- [Snipaste：windows很出名的截图软件。支持窗口识别，固定截图](https://github.com/Snipaste)

- [flameshot：火焰截图](https://github.com/flameshot-org/flameshot)

- [Umi-OCR：ocr](https://github.com/hiroi-sora/Umi-OCR)

- [eSearch: 截屏 离线OCR 搜索翻译 以图搜图 贴图 录屏 万向滚动截屏 屏幕翻译 Screenshot Offline OCR Search Translate Search for picture Paste the picture on the screen Screen recorder Omnidirectional scrolling screenshot Screen translator 支持Windows Linux macOS](https://github.com/xushengfeng/eSearch)

- [mark-shot: Qt 6 Wayland screenshot selection and annotation tool](https://github.com/jswysnemc/mark-shot)

- [babry: 一个在wayland上旨在实现区域自动检测的截图工具](https://github.com/kregonia/babry)

### 录屏

- [capptivo: 跨平台录屏。Give your demos the spotlight they deserve ( Mac/Windows/Linux ).](https://github.com/SECHAK-AG/capptivo)

- [kooha：wayland录屏](https://github.com/SeaDve/Kooha)

- [wayfarer：录屏](https://github.com/stronnag/wayfarer)

- [openscreen: 录屏加部分剪辑功能，可以更换背景，调整窗口大小，放大缩小等动效，添加文字等。满足最基本的录屏剪辑需求](https://github.com/siddharthvaddem/openscreen)
- [Recordly: 录屏支持根据点击等操作自动追踪、缩放功能，并支持前置摄像头](https://github.com/webadderall/Recordly)

### ocr截图识别文字

- [TextSnatcher: 只支持英文](https://github.com/RajSolai/TextSnatcher)

- [Umi-OCR: 使用PaddleOCR。支持截屏/批量导入图片，PDF文档识别，排除水印/页眉页脚，扫描/生成二维码。内置多国语言库。](https://github.com/hiroi-sora/Umi-OCR)

### 图片压缩

- [PicSharp: A modern, full-featured, high-performance, cross-platform image compression application 具有现代化UI、功能齐全、高性能、跨平台的图像压缩工具](https://github.com/AkiraBit/PicSharp)

- [caesium-image-compressor: Caesium is an image compression software that helps you store, send and share digital pictures, supporting JPG, PNG, WebP and TIFF formats. You can quickly reduce the file size (and resolution, if you want) by preserving the overall quality of the image.](https://github.com/Lymphatus/caesium-image-compressor)

- [Imagine: PNG/JPEG图片压缩工具](https://github.com/meowtec/Imagine)

- [compressO: 跨平台视频和图片压缩](https://github.com/codeforreal1/compressO)

### 提升画质

- [upscayl：ai图片质量提升](https://github.com/upscayl/upscayl)

- [realesrgan-gui: 实用、美观的 Real-ESRGAN 图形界面，同时支持 Windows、Ubuntu 和 macOS 平台。现在也支持 Real-CUGAN 了！(Cross-platform GUI for image upscaler Real-ESRGAN with additional features. Now with Real-CUGAN support!)](https://github.com/TransparentLC/realesrgan-gui)

### 其他

- [PicGo：图床上传下载](https://github.com/Molunerfinn/PicGo)

- [wallpaper-engine-download-web: wallpaper免登录下载](https://github.com/0ran/wallpaper-engine-download-web)

- [mini-photo-editor: 在线webgl照片编辑器，带有特效、滤镜和裁剪功能](https://github.com/xdadda/mini-photo-editor)

## 视频

### 播放器

- [ModernZ: mpv的皮肤](https://github.com/Samillion/ModernZ)

- [jellyfin-desktop: Jellyfin Desktop Client](https://github.com/jellyfin/jellyfin-desktop)

- [tsukimi: A simple third-party Jellyfin client for Linux](https://github.com/tsukinaha/tsukimi)

- [Cinetry: 开源版网易爆米花。Cinetry音视频播放器，Jellyfin、Emby、CMS、IPTV、Webdav、Alist、Openlist、Subsonic、Navidrom、GD音乐台、audiobookshelf、道理鱼、飞牛影视数据导入，服务器一键切换，多服务器数据聚合搜索，支持Andorid、iOS、Windows、macOS、Linux、TV，不扫库，纯本地客户端](https://github.com/gstory0404/Cinetry)

- [NipaPlay-Reload: NipaPlay-Reload 是一个现代化的跨平台本地视频播放器，支持 Windows、macOS、Linux、Android 和 iOS。集成了弹幕显示、多格式字幕支持、多音频轨道切换，新番查看等功能，支持挂载Emby/Jellyfin媒体库。采用 Flutter 开发，提供统一的用户体验。](https://github.com/MCDFsteve/NipaPlay-Reload)

- [FreeBox: TVBox电脑版/姊妹软件，致力于TVBox功能和生态的跨平台扩展](https://github.com/kknifer7/FreeBox)

- [soia: High-performance cross-platform media player with HDR/Dolby Vision, WebDAV/DLNA/SMB streaming, dual subtitles, and browser remote control.](https://github.com/FengZeng/soia/#data-storage#1)

- [fntv-electron: 飞牛影视PC版](https://github.com/QiaoKes/fntv-electron)

### 服务

- [go2tv: 投屏到DLNA电视。甚至还有漂亮的web界面](https://github.com/alexballas/go2tv)
    ```sh
    # 命令行投屏
    go2tv -l
    go2tv -v test.mp4 -t http://192.168.1.35:16654

    # 启用web
    go2tv -server -media-root .
    ```

- [movcaster: 投屏到DLNA电视](https://github.com/juliocesar/movcaster)

- [castor: 投屏到电视，支持web的视频](https://github.com/stupside/castor)

- [bilicast：将浏览器的b站视频投屏](https://github.com/jianzhoujz/bilicast)

- [Macast: 接受DLNA的投屏，然后用mpv播放](https://github.com/xfangfang/Macast)

- [minidlna: MiniDLNA (aka ReadyDLNA) is server software with the aim of being fully compliant with DLNA/UPnP-AV clients. It is developed by a NETGEAR employee for the ReadyNAS product line](https://github.com/azatoth/minidlna)

- [vuio: DLNA Media Server written in Rust, x64/ARM, Linux, Mac, Windows and Docker support](https://github.com/vuiodev/vuio)

- [fluxcast: 屏幕镜像](https://github.com/IlyaP358/fluxcast)

- [GNOME/gnome-network-displays: 屏幕镜像](https://github.com/GNOME/gnome-network-displays)

### ai提升视频质量

- [video2x-qt6: Video2X视频增强命令的gui](https://github.com/k4yt3x/video2x-qt6)

- [chaiNNer: A node-based image processing GUI aimed at making chaining image processing tasks easy and customizable. Born as an AI upscaling application, chaiNNer has grown into an extremely flexible and powerful programmatic image processing application.](https://github.com/chaiNNer-org/chaiNNer)

- [SnowLeopard-Vision: SnowLeopard Vision - local AI image and video enhancement tool](https://github.com/SnowLeopard-Elysia/SnowLeopard-Vision)

### 剪辑

- [OpenCut:剪映开源版](https://github.com/OpenCut-app/OpenCut)

- [VideoLingo: Netflix级字幕切割、翻译、对齐、甚至加上配音，一键全自动视频搬运AI字幕组](https://github.com/Huanshere/VideoLingo)

- [lossless-cut：视频剪切软件，目标是成为 FFmpeg 的图形前端。](https://github.com/mifi/lossless-cut)

- [kdenlive: 视频剪辑](https://github.com/KDE/kdenlive)

- [openreel-video: OpenReel Video - Professional browser-based video editor. Open source CapCut alternative. 100% browser-based, no installation, no cloud uploads, no watermarks.](https://github.com/Augani/openreel-video)

- [cutia: An open-source, in-browser alternative to CapCut.](https://github.com/msgbyte/cutia)

### 其他

- [mediainfo-gui: mediainfod的gui](https://github.com/lordmulder/mediainfo-gui)

- [winff: ffmpeg gtk/qt ui](https://github.com/WinFF/winff/)

- [pyvideotrans：给视频配音、翻译配音、添加字幕](https://github.com/jianchang512/pyvideotrans)

- [HandBrake: 视频剪辑和压缩](https://github.com/HandBrake/HandBrake)

- [videocr: 字幕提取](https://github.com/apm1467/videocr)

## 漫画

- [jasmine: A comic browser，support Android / iOS / MacOS / Windows / Linux.](https://github.com/ComicSparks/jasmine)
## 音乐播放器

- [harmonoid: 🎵 Plays & manages your music library. Looks beautiful & juicy. Available for Windows, GNU/Linux, macOS, Android & iOS.](https://github.com/harmonoid/harmonoid)

- [EvolveUI: qml写的音乐播放器](https://github.com/sudoevolve/EvolveUI)

- [NSMusicS：支持各种云端平台](https://gitwhub.com/Super-Badmen-Viper/NSMusicS)

### 基于平台源的音乐播放器

- [go-music-dl: 跨平台的一个基于 Go 语言的全网音乐搜索与下载工具。支持 Web 界面、TUI 终端 和 桌面应用 三种使用模式。内置网易云、QQ、酷狗、Bilibili、汽水音乐等 10+ 个主流平台，支持多源并发搜索与无损音质解析。music-dl交流群：1074285005](https://github.com/guohuiyuan/go-music-dl)

- [biu: Bilibili音乐播放器](https://github.com/wood3n/biu)

- [CeruMusic: 跨平台。Ceru Music 是基于 Electron 和 Vue 开发的跨平台桌面音乐播放器工具，借鉴洛雪音乐插件思想，提供插件运行框架与播放功能，不直接存储、提供任何音乐源文件。用户需通过自行选择、安装合规插件获取音乐相关数据，项目旨在为开发者提供桌面应用技术实践与学习案例，为用户提供合规的音乐播放工具框架。](https://github.com/timeshiftsauce/CeruMusic)

- [MoeKoeMusic: 一款开源简洁高颜值的酷狗第三方客户端](https://github.com/iAJue/MoeKoeMusic)

- [SPlayer：网易云音乐](https://github.com/imsyy/SPlayer)

- [VutronMusic: 高颜值的第三方网易云播放器；支持流媒体音乐，如navidrome、jellyfin、emby；支持本地音乐播放、离线歌单、逐字歌词、桌面歌词、Touch Bar歌词、Mac状态栏歌词显示、Linux-gnome与Linux-kde桌面状态栏歌词显示；支持降调降速，支持自定义主题等。支持 Windows / macOS / Linux](https://github.com/stark81/VutronMusic)

- [musicxx: 拟声。音乐播放器，通过插件可以播放各大平台的音乐，支持各种网盘和webdav](https://github.com/coolight7/musicxx)

- [lx-music-desktop: 一个基于 Electron 的音乐软件](https://github.com/lyswhut/lx-music-desktop)

    - [lx-music-source: 洛雪音乐源](https://github.com/pdone/lx-music-source)

    - [lx-music-sync-server: 运行在 Node.js 上的 LX Music 数据同步服务](https://github.com/lyswhut/lx-music-sync-server)

    - [any-listen: A cross-platform private music playback service](https://github.com/any-listen/any-listen?tab=readme-ov-file)

- [FeelUOwn: 跨平台音乐播放器支持yotube、bilibili、网易云、qq音乐等插件](https://github.com/feeluown/FeelUOwn)

- [AlgerMusicPlayer: 跨平台第三方音乐播放器、本地服务、桌面歌词、音乐下载、远程控制。支持网易云音乐](https://github.com/algerkong/algermusicplayer)

- [FuoEvolve: 跨平台的第三方音乐播放器，支持多种源](https://github.com/feeluown/FuoEvolve)

- [VutronMusic: 高颜值的第三方网易云播放器；通过自写插件可支持其他线上音乐服务；支持流媒体音乐，如navidrome、jellyfin、emby；支持本地音乐播放、离线歌单、逐字歌词、桌面歌词、Touch Bar歌词、Mac状态栏歌词显示、Linux-gnome与Linux-kde桌面状态栏歌词显示；支持降调降速，支持自定义主题等。支持 Windows / macOS / Linux](https://github.com/stark81/VutronMusic)
### 音乐下载

- [HotDownloader: 基于 Tauri 2 和 Vue 3 的跨平台音乐下载工具，支持桌面端（Windows/macOS/Linux）与 Android 端。](https://github.com/lerdb/HotDownloader)

## 音频

- [SoundThread: Node based GUI for The Composers Desktop Project](https://github.com/j-p-higgins/SoundThread)

- [easyeffects: 电脑音质提升软件-拯救你的破喇叭](https://github.com/wwmm/easyeffects)

- [Omniphony: Real-time spatial / object-based audio rendering engine (VBAP + binaural) for multichannel and 3D audio — speakers or headphones.](https://github.com/mgth/Omniphony)

- [audacity: 跨平台Audio Editor](https://github.com/audacity/audacity)

- [Ardour, free and open-source digital audio workstation | Ardour DAW](https://ardour.org/)

## 追番

- [Kazumi: 基于自定义规则的番剧采集APP，支持流媒体在线观看，支持弹幕，支持实时超分辨率。](https://github.com/Predidit/Kazumi)

## 邮件

- [Pebble: A small yet beautiful email client.](https://github.com/QingJ01/Pebble)
## 阅读和笔记相关

- [edgeever: Serverless, 100% free, and open-source Evernote alternative on Cloudflare with native MCP | 无需服务器、0费用、原生支持 AI Agent 的开源自托管『印象笔记』](https://github.com/tianma-if/edgeever)

### 阅读器

- [fluent-reader：rss订阅和阅读器](https://github.com/yang991178/fluent-reader)

- [MrRSS: A modern, cross-platform desktop RSS reader. 一个现代化、跨平台的 RSS 阅读器.](https://github.com/WCY-dt/MrRSS)

- [Folo: 聚合阅读器，有点类似于rss](https://github.com/RSSNext/Folo)

- [MrRSS: A modern, cross-platform, and free AI RSS reader. 一个现代化、跨平台且免费的 AI RSS 阅读器.](https://github.com/DevXDojo/MrRSS)

- [sioyek: pdf阅读器](https://github.com/ahrm/sioyek)

- [zathura: pdf, epub阅读器](https://github.com/pwmt/zathura)

- [koreader: An ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices](https://github.com/koreader/koreader)

    - [koreader/koreader-sync-server: self hostable synchronization service for koreader devices](https://github.com/koreader/koreader-sync-server)
    - [assistant.koplugin: Assistant: AI Helper Plugin for KOReader : lets you interact with AI language models (Claude, GPT-4, Gemini, DeepSeek, Ollama etc.) while reading](https://github.com/omer-faruq/assistant.koplugin)

- [foliate: pdf, epub阅读器](https://github.com/johnfactotum/foliate)

- [readest：沉浸式的电子书阅读器。这是一款为热爱阅读的用户量身打造的阅读软件，将极简设计与强大功能融合，为你带来专注、沉浸的阅读体验。它基于 Next.js 和 Tauri 开发，支持跨平台运行，现已支持 macOS、Windows、Linux 和 Web 平台，未来还将推出 iOS 和 Android 版本，实现真正的全平台覆盖](https://github.com/readest/readest)

- [pdfcraft: 无需上传文件的 PDF 全能工具箱。这是一款基于 Next.js 和 WebAssembly 构建的开源 PDF 工具箱，所有文件操作均在本地浏览器内完成，无需上传到外部服务器。它提供节点式编排 PDF 文件处理工作流，支持合并、拆分、OCR、格式转换等 90 多种功能。](https://github.com/PDFCraftTool/pdfcraft)

- [ReadAny：桌面端 + 安卓端的电子书阅读工具，自带 AI 功能、语音朗读和多端同步。](https://github.com/codedogQBY/ReadAny)

- [read-aware: 跨平台An ebook reader with a self-evolving agent: it remembers your reading across books, and plugins extend the reader and the agent alike.](https://github.com/ahpxex/read-aware)

### markdown相关

- [obsidian](https://github.com/obsidianmd/obsidian-releases)

- [Zettlr](https://github.com/Zettlr/Zettlr)

- [siyuan: 思源笔记](https://github.com/siyuan-note/siyuan)

- [joplin: 跨平台markdown编辑器](https://github.com/laurent22/joplin)

- [ColaMD: 跨平台markdown编辑器](https://github.com/marswaveai/ColaMD)
- [Gmark: 跨平台Rust + GPUI 打造的本地优先桌面编辑器：支持 Markdown、纯文本、JSON/JSONL、CSV/TSV，提供 Live/Source/Split/Preview、大文件按需读取、结构化视图、工作区搜索及 HTML/PNG/PDF 导出。](https://github.com/kongweiguang/Gmark)

- [MarKing: Marking：现代化跨平台 Markdown 编辑器 - 专业级编辑体验 + 可视化表格编辑 + 强大导出功能](https://github.com/l06066hb/MarKing)

- [markdown-online-editor: 📝 基于 Vue2、Vditor，所构建的在线 Markdown 编辑器，支持绘制流程图、甘特图、时序图、任务列表、echarts 图表、五线谱，以及 PPT 预览、视频音频解析、HTML 自动转换为 Markdown 等功能。https://www.niceshare.site](https://github.com/nicejade/markdown-online-editor)

- [Yank Note: 跨平台markdown编辑器，同时支持gui和web两种界面。可以跑代码、画图表、搞加密，甚至内置终端。Yank Note 提供了版本控制功能，每次修改都会自动记录，方便我们回头进行修改对比。ai智能补全。图表嵌入：支持 PlantUML、Drawio、ECharts、Mermaid 等多种图表工具；插件系统：可以自己写 JavaScript 插件扩展功能，真正的可编程编辑器。](https://yank-note.com/)

- [note-gen:跨平台的 Markdown 笔记软件，支持接入 AI 模型](https://github.com/codexu/note-gen)

- [marktext: markdown编辑器。typora免费代替品](https://github.com/marktext/marktext)

- [WeMD: 更优雅的 Markdown 公众号编辑器](https://github.com/tenngoxars/WeMD)

- [MarkFlowy: The AI Markdown Editor](https://github.com/drl990114/MarkFlowy)

### note

- [zotero：文献管理工具](https://github.com/zotero/zotero)

- [zotero-gpt](https://github.com/MuiseDestiny/zotero-gpt)

- [karakeep: 可以收藏links, notes and images。然后通过ai搜索搜索文本。](https://github.com/karakeep-app/karakeep/)
### 画图

- [drawio-desktop](https://github.com/jgraph/drawio-desktop)

## 游戏相关

- [BeyondDimension/SteamTools: 🛠「Watt Toolkit」是一个开源跨平台的多功能 Steam 工具箱。可以加速steam和github网络](https://github.com/BeyondDimension/SteamTools)

### 模拟器

- [RetroArch: 跨平台一站式复古游戏模拟器。该项目是 libretro 官方开发的跨平台模拟器，可动态加载各类游戏机模拟器和游戏引擎。它提供多种着色器、即时存档、手柄操作和视频录制等功能，支持 Windows、Linux、macOS、Android、iOS 以及 PS、Xbox、任天堂主机等平台。](https://github.com/libretro/RetroArch)

- [yuzu：switch模拟器](https://yuzu-mirror.github.io/)

- [shadPS4：ps4模拟器](https://github.com/shadps4-emu/shadPS4)

# 工具

## 键盘鼠标相关

- [input-overlay：显示用户操作输入的 OBS 直播插件。该项目是用来在直播中显示键盘按键、鼠标移动和游戏手柄按钮的插件](https://github.com/univrsal/input-overlay)

![image](./Pictures/awesomegui/input-overlay.avif)

- [keynav：键盘控制鼠标](https://github.com/jordansissel/keynav)

- [keyviz: 实时显示键盘按键](https://github.com/mulaRahul/keyviz)

- [MouseClick：鼠标连点器](https://github.com/SeaYJ/MouseClick)

## 翻译


- [pot-desktop：划词翻译，并支持ocr](https://github.com/pot-app/pot-desktop)
    - [pot-app-plugin-list: 🌟Pot App Plugin Collection](https://github.com/pot-app/pot-app-plugin-list)

- [MTranServer: 低资源占用速度快可私有部署的离线翻译模型服务器](https://github.com/xxnuo/MTranServer)

- [AiNiee: 一款专注于Ai翻译的工具，一键自动翻译RPG SLG游戏，Epub TXT小说，PDF Word MD文档，Srt Vtt Lrc字幕等等复杂长文本。](https://github.com/NEKOparapa/AiNiee)

## 投屏和远程控制

- [Sunshine：投屏(屏幕共享)服务端](https://github.com/LizardByte/Sunshine)

- [apollo: 投屏(屏幕共享)服务端,比Sunshine更好](https://github.com/apolloconfig/apollo)

- [moonlight-qt：投屏(屏幕共享)客户端](https://github.com/moonlight-stream/moonlight-qt)

- [rustdesk：跨平台远程控制](https://github.com/rustdesk/rustdesk)

- [SubnetDesk: LAN-only remote desktop based on RustDesk](https://github.com/zibo-chen/SubnetDesk)

- [ToDesk](https://github.com/ji4ozhu/ToDesk)

- [lan-mouse：跨平台（windows、macos、linux）键盘和鼠标共享，只需移动到屏幕边缘键鼠即可切换电脑。一套键鼠控制多台电脑，相当于显示器的kvm技术](https://github.com/feschber/lan-mouse)

- [input-leap: 跨平台（windows、macos、linux）键盘和鼠标共享，只需移动到屏幕边缘键鼠即可切换电脑。一套键鼠控制多台电脑，相当于显示器的kvm技术](https://github.com/input-leap/input-leap)

- [deskflow：跨平台（windows、macos、linux）键盘和鼠标共享，只需移动到屏幕边缘键鼠即可切换电脑。一套键鼠控制多台电脑，相当于显示器的kvm技术](https://github.com/deskflow/deskflow)

- [mykvm: 跨平台（windows、macos、linux）键盘和鼠标和剪切板共享](https://github.com/XxMinor/mykvm)

- [crossdesk: 一款支持 Web 客户端访问的轻量级跨平台远程桌面软件。](https://github.com/kunkundi/crossdesk)

- [sunloginclient(向日葵运程控制gui版)](https://sunlogin.oray.com/download)

### 手机与电脑交互

- [SyncClipboard: 跨平台剪贴板同步、历史记录管理工具 / Cross-platform cipboard syncing, history management tool](https://github.com/Jeric-X/SyncClipboard)

- [linkandroid：开源的手机连接助手，方便连接 Android 和电脑。](https://github.com/modstart-lib/linkandroid)

- [aya：简化对安卓设备的操作控制，可以看作 ADB 的图形用户界面](https://github.com/liriliri/aya)

- [PC Bio Unlock：手机解锁电脑登陆界面](https://meis-apps.com/pc-bio-unlock/how-to-install)

- [Macro-Deck: 可以自定义手机使其变成监控面板，从而更好的利用旧手机](https://github.com/Macro-Deck-App/Macro-Deck)

### 电脑与电脑屏幕共享

- [Piik: 跨平台屏幕共享。支持在官网在线共享浏览器的其中某个标签](https://github.com/TNTcraftHIM/Piik)
    - [Piik官网和在线共享浏览器的某个标签](https://demo.piik.tv/)

### ssh客户端

- [RustConn:支持 SSH、RDP、VNC、SPICE、Telnet、Kubernetes 等主流协议 。 Modern connection manager for Linux with GTK4/Wayland-native interface.](https://github.com/totoshko88/RustConn)

- [oxideterm: All-in-one terminal workspace — local shells, SSH, SFTP, remote IDE, AI agent, and file manager in a single native binary. Built with Tauri 2 and pure Rust SSH (no OpenSSL). Smart reconnect, MCP, RAG, plugins, 30+ themes, 11 languages.](https://github.com/AnalyseDeCircuit/oxideterm)

- [shell360](https://github.com/shell360)

- [xpipe：通过图形界面，将所有的服务器连接在一个地方管理。](https://github.com/xpipe-io/xpipe)

- [termora](https://github.com/TermoraDev/termora)

    - 支持 SSH 和本地终端
    - 支持 Windows、macOS、Linux 平台
    - 支持 Zmodem 协议
    - 支持 SSH 端口转发
    - 支持配置同步到 Gist
    - 支持宏（录制脚本并回放）
    - 支持关键词高亮
    - 支持密钥管理器
    - 支持将命令发送到多个会话
    - 支持 Find Everywhere 快速跳转
    - 支持数据加密

## 密码相关

- [veracrypt：加密](https://github.com/veracrypt/VeraCrypt)

- [bitwarden：密码管理器](https://bitwarden.com/download/)

- [vaultwarden: 密码管理器](https://github.com/dani-garcia/vaultwarden)

- [keepassxc: 跨平台密码管理器](https://github.com/keepassxreboot/keepassxc)

## 镜像u盘相关

- [balena-etcher：写镜像到u盘](https://github.com/balena-io/etcher)

# 浏览器

- [ovobrowsersupport/ovobrowser: 源码级 Chromium 指纹内核，检测站按普通 Chrome 评分。Source-level Chromium fingerprint kernel that passes bot detection tests. Not JS injection — C++ patches compiled into the binary.](https://github.com/ovobrowsersupport/ovobrowser)

# 第三方客户端

- [netease-cloud-music-gtk：网易云音乐gtk4版](https://github.com/gmg137/netease-cloud-music-gtk)

- [folia-major: 网易云音乐Electron版。专注于绚丽的歌词动画效果的第三方网易云播放器](https://github.com/chthollyphile/folia-major)

- [open-orpheus: 网易云音乐Electron版](https://github.com/YUCLing/open-orpheus)

- [DTV: 抖音、b站、斗鱼、虎牙跨平台轻量化桌面客户端](https://github.com/chen-zeong/DTV)

- [pure_live_TV: 跨平台。纯粹直播:哔哩哔哩/虎牙/斗鱼/快手/抖音/网易cc/M38自定义源应有尽有。](https://github.com/liuchuancong/pure_live_TV)

- [FreeTube: youtube](https://github.com/FreeTubeApp/FreeTube)

- [Github-Store: 平台的 GitHub 应用商店。这是一款基于 Kotlin 开发的跨平台开源应用商店客户端，支持一键发现热门开源项目、下载安装包（如 APK、EXE、DMG 、 AppImage、DEB、RPM等），以及追踪已安装应用并提示更新。](https://github.com/rainxchzed/Github-Store)

- [PiliPlus: 使用Flutter开发的BiliBili第三方客户端](https://github.com/bggRGjQaUbCoE/PiliPlus)
    - [PiliNara: 基于PiliPlus进行修改的,做了一些自用的改动.](https://github.com/nlsdt/PiliNara)

- [wiliwili: 第三方B站客户端，目前可以运行在PC全平台、PSVita、PS4 、Xbox 和 Nintendo Switch上](https://github.com/xfangfang/wiliwili)

- [EchoMusic: 🎉 一个简约的第三方酷狗概念版音乐播放器](https://github.com/hoowhoami/EchoMusic)

- [coolapk-desktop: 酷安跨平台桌面版](https://github.com/daimiaopeng/coolapk-desktop)

# 流行软件相关

- [DiscordChatExporter:跨平台Saves Discord chat logs to a file](https://github.com/Tyrrrz/DiscordChatExporter)

- [ellermister/mybili: 哔哩哔哩收藏夹备份程序 ~ アレ 视频不见了哟！](https://github.com/ellermister/mybili)

## 微信相关

- [WechatRealFriends：查看有没有朋友偷偷删掉或者拉黑你](https://github.com/StrayMeteor3337/WechatRealFriends)

- [WeClone: 🚀从聊天记录创造数字分身的一站式解决方案💡 使用聊天记录微调大语言模型，让大模型有“那味儿”，并绑定到聊天机器人，实现自己的数字分身。 数字克隆/数字分身/数字永生/LLM/聊天机器人/LoRA](https://github.com/xming521/WeClone)

- [WeFlow: 一个本地的微信聊天记录导出和年度报告应用](https://github.com/hicccc77/WeFlow)

# 金融

- [FinceptTerminal: bloomberg的开源代替品](https://github.com/Fincept-Corporation/FinceptTerminal)

- [OpenBB: Financial data platform for analysts, quants and AI agents.](https://github.com/OpenBB-finance/OpenBB)

- [stock：股票分析](https://github.com/myhhub/stock)

- [OpenStock: 免费炫酷的股票市场应用。这是一款基于 Next.js、TailwindCSS 和 MongoDB 构建的股票市场平台，提供实时行情、图表（K 线图、热力图）、新闻资讯和个性化监控等功能，专注于数据展示与分析，不支持交易。](https://github.com/Open-Dev-Society/OpenStock)

# 桌面工具

- [noti: 任务完成后通知](https://github.com/variadico/noti)

- [BongoCat: 🐱 跨平台互动桌宠 BongoCat，为桌面增添乐趣！](https://github.com/ayangweb/BongoCat)
    - [Awesome-BongoCat: 🚀 汇聚优质的第三方 BongoCat 模型！](https://github.com/ayangweb/Awesome-BongoCat)
    - [wayland-bongocat: bongocat for your desktop ₍^. .^₎](https://github.com/saatvik333/wayland-bongocat)
- [BongoCat: 🩷 💘C × SDL3 × OpenGL, stir it up, mash it together! Bong~ Bongocat!!! Don't be shy, join here🧸: https://discord.gg/vf8jqnattk](https://github.com/vladelaina/BongoCat)

- [EcoPaste: 🎉跨平台的剪贴板管理工具](https://github.com/EcoPasteHub/EcoPaste)

- [kando: 跨平台的饼式鼠标快捷键](https://github.com/kando-menu/kando)

- [markeron: 跨平台。在当前桌面上的画标记工具，可以画各种图案。](https://github.com/ifer47/markeron)

- [rubick: 跨平台的类似启动的工具箱，原则是一切皆插件。基于 electron 的开源工具箱，自由集成丰富插件。](https://github.com/rubickCenter/rubick)

- [magpie: 跨平台启动器。Spotlight-style local search for everything you saved and forgot: GitHub stars, local files, images, and bookmarks. Privacy-first, no full-disk scanning, fully on-device.](https://github.com/newdee/magpie)

- [WallpaperEM:WallpaperEM 是一款开源的动态壁纸引擎：浏览并下载 Steam 创意工坊（Wallpaper Engine）壁纸，一键应用到桌面。支持 视频 / GIF / 网页 / 场景（WebGL）/ 图片 五类壁纸、多显示器、托盘与全局快捷键；内置 MCP 服务，可以用 AI 直接创作壁纸工程。](https://github.com/oneincase/WallpaperEM)

# 通信

- [session：加密通信](https://getsession.org/download)

# 运行windows程序

- [winboat: 量级Windows应用运行方案来了](https://github.com/TibixDev/winboat)
    - [告别卡顿！轻量级Windows应用运行方案来了](https://mp.weixin.qq.com/s/jWL-uAb3gdf8-UXxIo6QYA)

- [winpodx: Windows pod system for Linux](https://github.com/kernalix7/winpodx)
# 其他

- [timeshift](https://github.com/teejee2008/timeshift)

- [gImageReader：ocr，但不太准确](https://github.com/manisandro/gImageReader)

- [quivr：该项目利用生成式 AI 的能力，成为你的第二大脑。你可以将多种格式的文本、数据、语言和视频上传给它，之后再和它对话时，它会学习你上传的内容后回答你的问题，支持接入多种 LLM 和 Docker 一键部署。](https://github.com/QuivrHQ/quivr)

- [stellarium：天象模拟软件](https://github.com/Stellarium/stellarium)
    - 支持：windows、linux、macos、android、ios

- [rubick：工具箱、启动框](https://github.com/rubickCenter/rubick)

- [neko：该项目是运行在 Docker 容器中的自托管虚拟浏览器环境，为用户提供安全、隔离和功能齐全的虚拟浏览器。](https://github.com/m1k1o/neko)

- [RaiDrive：像 USB 驱动器一样安装云存储。支持webdav、ftp等协议](https://www.raidrive.com/zh-Hans/)

- [zen-desktop: 系统级广告拦截和隐私保护工具，支持 Windows、macOS 和 Linux 三大平台。](https://github.com/ZenPrivacy/zen-desktop)

- [godot: 游戏引擎编辑器 Multi-platform 2D and 3D game engine](https://github.com/godotengine/godot)


- [stretchly: 跨平台的每个一段时间强制休息。](https://github.com/hovancik/stretchly)

# 类似项目

- [linux 下的惬意生活](https://github.com/yangyangwithgnu/the_new_world_linux#%E7%9B%AE%E5%BD%95)

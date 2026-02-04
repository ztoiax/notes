---
id: awesome-gui
aliases: []
tags: []
---


<!-- mtoc-start -->

* [操作系统](#操作系统)
* [file](#file)
  * [文件传输](#文件传输)
  * [文件管理器](#文件管理器)
  * [文件清理](#文件清理)
  * [云盘](#云盘)
  * [other](#other)
* [下载器](#下载器)
  * [支持下载各种平台的下载器](#支持下载各种平台的下载器)
* [图片](#图片)
  * [image viewer(图片查看器)](#image-viewer图片查看器)
    * [qt](#qt)
    * [gtk](#gtk)
    * [caesium-image-compressor：图片压缩。配备了实时预览和批量处理的功能](#caesium-image-compressor图片压缩配备了实时预览和批量处理的功能)
  * [digikam：本地图片管理](#digikam本地图片管理)
  * [afilmory: 本地图片管理。Modern photo gallery for photographers, with S3/GitHub sync, EXIF details, maps, and a WebGL viewer.](#afilmory-本地图片管理modern-photo-gallery-for-photographers-with-s3github-sync-exif-details-maps-and-a-webgl-viewer)
  * [截图](#截图)
  * [ocr截图识别文字](#ocr截图识别文字)
  * [图片压缩](#图片压缩)
* [视频](#视频)
  * [播放器](#播放器)
  * [ai提升视频质量](#ai提升视频质量)
  * [other](#other-1)
* [音乐](#音乐)
* [音频](#音频)
* [桌面软件和常见软件的第三方客户端](#桌面软件和常见软件的第三方客户端)
* [投屏和远程控制](#投屏和远程控制)
  * [ssh客户端](#ssh客户端)
* [pdf、epub、mobi、markdown阅读器](#pdfepubmobimarkdown阅读器)
* [note](#note)
* [markdown文章知识管理、阅读器](#markdown文章知识管理阅读器)
* [ide](#ide)
* [硬件](#硬件)
* [ai](#ai)
* [模拟器](#模拟器)
* [微信相关](#微信相关)
* [金融](#金融)
* [其他](#其他)
* [类似项目](#类似项目)

<!-- mtoc-end -->

# 操作系统

- [LibreELEC：基于KODI，适合用于电视；有docker等功能；复古游戏模拟器；自带smb](https://github.com/LibreELEC/LibreELEC.tv)

- [CoreELEC：基于KODI，适合用于电视](https://github.com/CoreELEC/CoreELEC)

# file

## 文件传输

- [localsend](https://github.com/localsend/localsend)

- [kdeconnect：还可以控制手机](https://github.com/KDE/kdeconnect-kde)

- [packet: android的AirDrop](https://github.com/nozwock/packet)

- [deltachat-desktop: 非局域网文件互传，同时也是聊天软件](https://github.com/deltachat/deltachat-desktop)

- [PairDrop: 文件传输，通过web浏览器](https://github.com/schlagmichdoch/PairDrop)
- [alt-sendme: 这是一款采用 Rust 和 Tauri 构建的开源 P2P 文件传输工具，无需注册和服务器，即可实现端到端的文件传输。用户只需将文件拖入应用，将随机生成的传输凭证发给接收方，对方输入后即可轻松接收文件。](https://github.com/tonyantony300/alt-sendme)

## 文件管理器

- [dolphin](https://github.com/KDE/dolphin)

- pcmanfm(文件管理器)

- [sigma-file-manager](https://github.com/aleksey-hoffman/sigma-file-manager)

- [xplorer](https://github.com/kimlimjustin/xplorer)

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
- [quark-auto-save: 夸克网盘签到、自动转存、命名整理、发推送提醒和刷新媒体库一条龙](https://github.com/Cp0204/quark-auto-save)

- [taosync: 同步到网盘的工具。TaoSync是一个适用于OpenList v3+的自动化同步工具/Sync for OpenList/AList](https://github.com/dr34m-cn/taosync)

## other

- [filelight](https://kde.org/applications/en/filelight)

    ![image](./Pictures/awesomegui/filelight.avif)

- [stacer](https://github.com/oguzhaninan/Stacer)

    ![image](./Pictures/awesomegui/stacer.avif)

- [timeshif: backup](https://github.com/teejee2008/timeshift.avif)

- [typora](https://www.typora.io/)

    ![image](./Pictures/awesomegui/typora.avif)


- [syncthing：文件同步](https://github.com/syncthing/syncthing)

- [PeaZip: ：免费开源的文件压缩解压工具。这是一款免费、开源、跨平台的文件压缩和解压工具，支持超过 200 种压缩格式（7Z、ZIP、RAR、TAR、ISO、Zstd），具备文件压缩、解压、加密、分卷、校验、格式转换和批量操作等功能。支持linux、windows、macos](https://github.com/peazip/PeaZip)

- [dupeguru: 查找重复文件](https://github.com/arsenetar/dupeguru)

# 下载器

- [AriaNg: aria2的web gui。需要浏览器的插件进行启动](https://github.com/mayswind/AriaNg)

- [gopeed: A modern download manager that supports all platforms. Built with Golang and Flutter.](https://github.com/GopeedLab/gopeed)
    - [gopeed-extension-wxmp: Gopeed 微信公众号视频下载扩展](https://github.com/monkeyWie/gopeed-extension-wxmp)
    - [gopeed-extension-baiduwp: Gopeed 百度网盘下载扩展。](https://github.com/monkeyWie/gopeed-extension-baiduwp)
    - [gopeed-extension-quark: Gopeed 扩展，用于解析夸克网盘分享链接并下载文件。](https://github.com/muyan556/gopeed-extension-quark)
    - [gopeed-extension-bilibili: Bilibili video download extension of gopeed.](https://github.com/monkeyWie/gopeed-extension-bilibili)
    - [gopeed-extension-youtube: Youtube video download extension of gopeed.](https://github.com/monkeyWie/gopeed-extension-youtube)
    - [gopeed-extension-twitter: Twitter media download extension of gopeed.](https://github.com/monkeyWie/gopeed-extension-twitter)
    - [gopeed-extension-huggingface: A gopeed-extension for downloading models and datasets from huggingface, hf-mirror and modelscope. Huggingface download](https://github.com/DSYZayn/gopeed-extension-huggingface)

- [axel: cli命令行下载](https://github.com/axel-download-accelerator/axel)

- [Motrix](https://github.com/agalwood/Motrix)

- [imfile：基于Motrix，因此imfile和Motrix只能安装其中一个](https://github.com/imfile-io/imfile-desktop)
    - 支持下载 HTTP、FTP、BitTorrent、Magnet 等

- [tribler：bt搜索和下载工具](https://www.tribler.org/download.html)：国内用户要设置无匿名，不然可能会出现资源下不动。

- [rats-search：bt搜索和下载工具，可以打开别的客户端下载](https://github.com/DEgITx/rats-search)

- [persepolis：aria2 gui](https://persepolisdm.github.io/)

- [fdm](https://www.freedownloadmanager.org/zh/)

- [xdman](https://xtremedownloadmanager.com/)

- [mediago：视频下载器，支持m3u8](https://github.com/caorushizi/mediago)

- [ab-download-manager：类似idm的下载器](https://github.com/amir1376/ab-download-manager)

- [JDownloader.org - Official Homepage](https://jdownloader.org/home/index)

- [amule: ed2k下载](https://github.com/amule-project/amule)

- [mldonkey: 支持 ED2K、Kad、BitTorrent 等多种网络](https://github.com/ygrek/mldonkey)
- [FileCentipede: Cross-platform internet upload/download manager for HTTP(S), FTP(S), SSH, magnet-link, BitTorrent, m3u8, ed2k, and online videos. WebDAV client, FTP client, SSH client.](https://github.com/filecxx/FileCentipede)

- [Tixati：跨平台的下载器，可以代替迅雷](https://tixati.com/)

### 支持下载各种平台的下载器

- [ytDownloader: gui下载器，支持数百种平台如youtube、bilibli等](https://github.com/aandrew-me/ytDownloader)

- [res-downloader: 嗅探抓取资源。视频号、小程序、抖音、快手、小红书、直播流、m3u8、酷狗、QQ音乐等常见网络资源下载!](https://github.com/putyy/res-downloader?tab=readme-ov-file)

# 图片

- [upscayl：ai图片质量提升](https://github.com/upscayl/upscayl)

- [pot-desktop：划词翻译，并支持ocr](https://github.com/pot-app/pot-desktop)
    - [pot-app-plugin-list: 🌟Pot App Plugin Collection](https://github.com/pot-app/pot-app-plugin-list)

- [PicGo：图床上传下载](https://github.com/Molunerfinn/PicGo)

- [Imagine: PNG/JPEG图片压缩工具](https://github.com/meowtec/Imagine)

## image viewer(图片查看器)

### qt

- [qt-avif-image-plugin（avif格式支持）](https://github.com/novomesk/qt-avif-image-plugin)

- [nomacs](https://github.com/nomacs/nomacs)

- [qview](https://github.com/jurplel/qView)

- [gwenview: KDE的](https://github.com/KDE/gwenview)

- [KDE/digikam: digiKam is an advanced open-source digital photo management application that runs on Linux, Windows, and MacOS. The application provides a comprehensive set of tools for importing, managing, editing, and sharing photos and raw files.](https://github.com/KDE/digikam)

### gtk

- [gthumb：GNOME的](https://github.com/GNOME/gthumb)

### [caesium-image-compressor：图片压缩。配备了实时预览和批量处理的功能](caesium-image-compressor)

![image](./Pictures/awesomegui/caesium-image-compressor.avif)

## [digikam：本地图片管理](https://www.digikam.org/)

## [afilmory: 本地图片管理。Modern photo gallery for photographers, with S3/GitHub sync, EXIF details, maps, and a WebGL viewer.](https://github.com/Afilmory/afilmory)

## 截图

- [deepin-screen-recorder：deepin的截图软件。支持录屏，长截图](https://github.com/linuxdeepin/deepin-screen-recorder)

- [Snipaste：windows很出名的截图软件。支持窗口识别，固定截图](https://github.com/Snipaste)

- [flameshot：火焰截图](https://github.com/flameshot-org/flameshot)

- [Umi-OCR：ocr](https://github.com/hiroi-sora/Umi-OCR)

- [kooha：wayland录屏](https://github.com/SeaDve/Kooha)

- [wayfarer：录屏](https://github.com/stronnag/wayfarer)

- [openscreen: 录屏加部分剪辑功能，可以更换背景，调整窗口大小，放大缩小等动效，添加文字等。满足最基本的录屏剪辑需求](https://github.com/siddharthvaddem/openscreen)

## ocr截图识别文字

- [TextSnatcher: 只支持英文](https://github.com/RajSolai/TextSnatcher)

- [Umi-OCR: 使用PaddleOCR。支持截屏/批量导入图片，PDF文档识别，排除水印/页眉页脚，扫描/生成二维码。内置多国语言库。](https://github.com/hiroi-sora/Umi-OCR)

## 图片压缩

- [PicSharp: A modern, full-featured, high-performance, cross-platform image compression application 具有现代化UI、功能齐全、高性能、跨平台的图像压缩工具](https://github.com/AkiraBit/PicSharp)
- [caesium-image-compressor: Caesium is an image compression software that helps you store, send and share digital pictures, supporting JPG, PNG, WebP and TIFF formats. You can quickly reduce the file size (and resolution, if you want) by preserving the overall quality of the image.](https://github.com/Lymphatus/caesium-image-compressor)

# 视频

## 播放器

- [NipaPlay-Reload: NipaPlay-Reload 是一个现代化的跨平台本地视频播放器，支持 Windows、macOS、Linux、Android 和 iOS。集成了弹幕显示、多格式字幕支持、多音频轨道切换，新番查看等功能，支持挂载Emby/Jellyfin媒体库。采用 Flutter 开发，提供统一的用户体验。](https://github.com/MCDFsteve/NipaPlay-Reload)

- [FreeBox: TVBox电脑版/姊妹软件，致力于TVBox功能和生态的跨平台扩展](https://github.com/kknifer7/FreeBox)

- [biu: Bilibili音乐播放器](https://github.com/wood3n/biu)

## ai提升视频质量

- [video2x-qt6: Video2X视频增强命令的gui](https://github.com/k4yt3x/video2x-qt6)

- [chaiNNer: A node-based image processing GUI aimed at making chaining image processing tasks easy and customizable. Born as an AI upscaling application, chaiNNer has grown into an extremely flexible and powerful programmatic image processing application.](https://github.com/chaiNNer-org/chaiNNer)

## other

- [mediainfo-gui: mediainfod的gui](https://github.com/lordmulder/mediainfo-gui)

- [winff: ffmpeg gtk/qt ui](https://github.com/WinFF/winff/)

- [pyvideotrans：给视频配音、翻译配音、添加字幕](https://github.com/jianchang512/pyvideotrans)
- [VideoLingo: Netflix级字幕切割、翻译、对齐、甚至加上配音，一键全自动视频搬运AI字幕组](https://github.com/Huanshere/VideoLingo)

- [lossless-cut：视频剪切软件，目标是成为 FFmpeg 的图形前端。](https://github.com/mifi/lossless-cut)

- [videocr: 字幕提取](https://github.com/apm1467/videocr)

- [HandBrake: 视频剪辑](https://github.com/HandBrake/HandBrake)

- [jellyfin-desktop: Jellyfin Desktop Client](https://github.com/jellyfin/jellyfin-desktop)

# 音乐

- [NSMusicS：支持各种云端平台](https://gitwhub.com/Super-Badmen-Viper/NSMusicS)

- [MoeKoeMusic: 一款开源简洁高颜值的酷狗第三方客户端](https://github.com/iAJue/MoeKoeMusic)

- [SPlayer：网易云音乐](https://github.com/imsyy/SPlayer)

- [musicxx: 拟声。音乐播放器，通过插件可以播放各大平台的音乐，支持各种网盘和webdav](https://github.com/coolight7/musicxx)

- [lx-music-desktop: 一个基于 Electron 的音乐软件](https://github.com/lyswhut/lx-music-desktop)

    - [lx-music-source: 洛雪音乐源](https://github.com/pdone/lx-music-source)

    - [lx-music-sync-server: 运行在 Node.js 上的 LX Music 数据同步服务](https://github.com/lyswhut/lx-music-sync-server)

    - [any-listen: A cross-platform private music playback service](https://github.com/any-listen/any-listen?tab=readme-ov-file)

# 音频

- [SoundThread: Node based GUI for The Composers Desktop Project](https://github.com/j-p-higgins/SoundThread)

- [easyeffects: 电脑音质提升软件-拯救你的破喇叭](https://github.com/wwmm/easyeffects)

# 桌面软件和常见软件的第三方客户端

- [FreeTube: youtube](https://github.com/FreeTubeApp/FreeTube)

- [Github-Store: 平台的 GitHub 应用商店。这是一款基于 Kotlin 开发的跨平台开源应用商店客户端，支持一键发现热门开源项目、下载安装包（如 APK、EXE、DMG 、 AppImage、DEB、RPM等），以及追踪已安装应用并提示更新。](https://github.com/rainxchzed/Github-Store)

# 投屏和远程控制

- [Sunshine：投屏(屏幕共享)服务端](https://github.com/LizardByte/Sunshine)

- [apollo: 投屏(屏幕共享)服务端,比Sunshine更好](https://github.com/apolloconfig/apollo)

- [moonlight-qt：投屏(屏幕共享)客户端](https://github.com/moonlight-stream/moonlight-qt)

- [rustdesk](https://github.com/rustdesk/rustdesk)

- [ToDesk](https://github.com/ji4ozhu/ToDesk)

- [lan-mouse：键盘和鼠标共享。一台电脑的键鼠控制其他电脑](https://github.com/feschber/lan-mouse)

- [deskflow：键盘和鼠标共享。一台电脑的键鼠控制其他电脑](https://github.com/deskflow/deskflow)

- [crossdesk: 一款支持 Web 客户端访问的轻量级跨平台远程桌面软件。](https://github.com/kunkundi/crossdesk)

## ssh客户端

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

# pdf、epub、mobi、markdown阅读器

- [sioyek: pdf阅读器](https://github.com/ahrm/sioyek)

- [zathura: pdf, epub阅读器](https://github.com/pwmt/zathura)

- [koreader: An ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices](https://github.com/koreader/koreader)

    - [koreader/koreader-sync-server: self hostable synchronization service for koreader devices](https://github.com/koreader/koreader-sync-server)
    - [assistant.koplugin: Assistant: AI Helper Plugin for KOReader : lets you interact with AI language models (Claude, GPT-4, Gemini, DeepSeek, Ollama etc.) while reading](https://github.com/omer-faruq/assistant.koplugin)

- [foliate: pdf, epub阅读器](https://github.com/johnfactotum/foliate)

- [readest：沉浸式的电子书阅读器。这是一款为热爱阅读的用户量身打造的阅读软件，将极简设计与强大功能融合，为你带来专注、沉浸的阅读体验。它基于 Next.js 和 Tauri 开发，支持跨平台运行，现已支持 macOS、Windows、Linux 和 Web 平台，未来还将推出 iOS 和 Android 版本，实现真正的全平台覆盖](https://github.com/readest/readest)

- [note-gen:跨平台的 Markdown 笔记软件，支持接入 AI 模型](https://github.com/codexu/note-gen)

- [marktext: markdown编辑器。typora免费代替品](https://github.com/marktext/marktext)

- [pdfcraft: 无需上传文件的 PDF 全能工具箱。这是一款基于 Next.js 和 WebAssembly 构建的开源 PDF 工具箱，所有文件操作均在本地浏览器内完成，无需上传到外部服务器。它提供节点式编排 PDF 文件处理工作流，支持合并、拆分、OCR、格式转换等 90 多种功能。](https://github.com/PDFCraftTool/pdfcraft)


# note

- [zotero：文献管理工具](https://github.com/zotero/zotero)

- [zotero-gpt](https://github.com/MuiseDestiny/zotero-gpt)

# markdown文章知识管理、阅读器

- [obsidian](https://github.com/obsidianmd/obsidian-releases)

- [Zettlr](https://github.com/Zettlr/Zettlr)

- [siyuan: 思源笔记](https://github.com/siyuan-note/siyuan)

- [joplin: 跨平台markdown编辑器](https://github.com/laurent22/joplin)

# ide

- [positron：数据科学 IDE](https://github.com/posit-dev/positron)基于 VSCode 构建了一个可复制的编写和发布的桌面开发环境，支持运行 Python 和 R 代码、自动补全等功能

# 硬件

- [corectrl：查看cpu、gpu信息，显示监控曲线图](https://gitlab.com/corectrl/corectrl)

- [LACT：amd gpu控制器](https://github.com/ilya-zlobintsev/LACT)

# ai

- [NextChat：支持各种llm的客户端](https://github.com/ChatGPTNextWeb/NextChat)

# 模拟器

- [yuzu：switch模拟器](https://yuzu-mirror.github.io/)

- [shadPS4：ps4模拟器](https://github.com/shadps4-emu/shadPS4)

# 微信相关

- [WechatRealFriends：查看有没有朋友偷偷删掉或者拉黑你](https://github.com/StrayMeteor3337/WechatRealFriends)

- [WeClone: 🚀从聊天记录创造数字分身的一站式解决方案💡 使用聊天记录微调大语言模型，让大模型有“那味儿”，并绑定到聊天机器人，实现自己的数字分身。 数字克隆/数字分身/数字永生/LLM/聊天机器人/LoRA](https://github.com/xming521/WeClone)

# 金融

- [OpenBB: Financial data platform for analysts, quants and AI agents.](https://github.com/OpenBB-finance/OpenBB)

# 其他

- [linux-wifi-hotspot](https://github.com/lakinduakash/linux-wifi-hotspot)

- [noti: 任务完成后通知](https://github.com/variadico/noti)

- [sunloginclient(向日葵运程控制gui版)](https://sunlogin.oray.com/download)

- [keynav：键盘控制鼠标](https://github.com/jordansissel/keynav)

- [keyviz: 实时显示键盘按键](https://github.com/mulaRahul/keyviz)

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

- [MrRSS: A modern, cross-platform desktop RSS reader. 一个现代化、跨平台的 RSS 阅读器.](https://github.com/WCY-dt/MrRSS)

- [Folo: 聚合阅读器，有点类似于rss](https://github.com/RSSNext/Folo)

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

- [linkandroid：开源的手机连接助手，方便连接 Android 和电脑。](https://github.com/modstart-lib/linkandroid)

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

- [aya：简化对安卓设备的操作控制，可以看作 ADB 的图形用户界面](https://github.com/liriliri/aya)

- [stock：股票分析](https://github.com/myhhub/stock)

- [MouseClick：鼠标连点器](https://github.com/SeaYJ/MouseClick)

- [RaiDrive：像 USB 驱动器一样安装云存储。支持webdav、ftp等协议](https://www.raidrive.com/zh-Hans/)
- [EcoPaste: 🎉跨平台的剪贴板管理工具](https://github.com/EcoPasteHub/EcoPaste)
- [kando: 饼式鼠标快捷键](https://github.com/kando-menu/kando)

- [winboat: 量级Windows应用运行方案来了](https://github.com/TibixDev/winboat)
    - [告别卡顿！轻量级Windows应用运行方案来了](https://mp.weixin.qq.com/s/jWL-uAb3gdf8-UXxIo6QYA)
- [zen-desktop: 系统级广告拦截和隐私保护工具，支持 Windows、macOS 和 Linux 三大平台。](https://github.com/ZenPrivacy/zen-desktop)
- [OpenStock: 免费炫酷的股票市场应用。这是一款基于 Next.js、TailwindCSS 和 MongoDB 构建的股票市场平台，提供实时行情、图表（K 线图、热力图）、新闻资讯和个性化监控等功能，专注于数据展示与分析，不支持交易。](https://github.com/Open-Dev-Society/OpenStock)

- [OpenCut:剪映开源版](https://github.com/OpenCut-app/OpenCut)
- [keepassxc: 跨平台密码管理器](https://github.com/keepassxreboot/keepassxc)
- [PC Bio Unlock：手机解锁电脑登陆界面](https://meis-apps.com/pc-bio-unlock/how-to-install)
- [godot: 游戏引擎编辑器 Multi-platform 2D and 3D game engine](https://github.com/godotengine/godot)


- [BongoCat: 🐱 跨平台互动桌宠 BongoCat，为桌面增添乐趣！](https://github.com/ayangweb/BongoCat)
    - [Awesome-BongoCat: 🚀 汇聚优质的第三方 BongoCat 模型！](https://github.com/ayangweb/Awesome-BongoCat)
    - [wayland-bongocat: bongocat for your desktop ₍^. .^₎](https://github.com/saatvik333/wayland-bongocat)

# 类似项目

- [linux 下的惬意生活](https://github.com/yangyangwithgnu/the_new_world_linux#%E7%9B%AE%E5%BD%95)

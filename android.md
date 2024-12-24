<!-- mtoc-start -->

* [Android](#android)
* [原理](#原理)
  * [apk](#apk)
* [第三方优秀资源](#第三方优秀资源)
  * [cli](#cli)
  * [gui](#gui)
  * [app](#app)
    * [应用管理](#应用管理)
      * [android四大组件](#android四大组件)
    * [文件管理器、云盘](#文件管理器云盘)
    * [文件互传、远程控制](#文件互传远程控制)
    * [数据备份](#数据备份)
    * [网络相关](#网络相关)
    * [隐藏检查](#隐藏检查)
    * [游戏相关](#游戏相关)
    * [第三方客户端](#第三方客户端)
* [刷机](#刷机)
  * [刷入recovery、magisk、lsposed](#刷入recoverymagisklsposed)
  * [frida](#frida)
  * [救砖](#救砖)
    * [magisk模块变砖](#magisk模块变砖)
  * [rom](#rom)
  * [GSI](#gsi)
  * [小刘不是程序员：如何挂载安卓系统镜像？](#小刘不是程序员如何挂载安卓系统镜像)
* [电视app](#电视app)
* [类似项目](#类似项目)

<!-- mtoc-end -->

# Android

- [Android学习路线](https://roadmap.sh/android)

- [Awesome-Android-Performance](https://github.com/JsonChao/Awesome-Android-Performance)

# 原理

- [（视频）FlashCorpa：系统进阶支线 Vol.7如何防止设备格机](https://www.bilibili.com/video/BV1zM4m1Z7Wj)

- [（视频）小刘不是程序员：Android系统是如何启动的？](https://www.bilibili.com/video/BV1rg4y1M7mh)

## apk

- [（视频）Janwrice：关于Apks的一切|MT管理器|NP管理器|SAI](https://www.bilibili.com/video/BV1Xe4y1M7v9)

# 第三方优秀资源

## cli

- [adb-sync](https://github.com/google/adb-sync)

    ```sh
    # 手机同步到电脑         adb-sync --reverse /sdcard/Download/ ~/Downloads
    # 电脑同步到手机         adb-sync -d ~/Downloads /sdcard/Download/
    ```

- [sndcpy：将手机音频转发到电脑](https://github.com/rom1v/sndcpy)

- [android_aircrack：wifi破解](https://github.com/kriswebdev/android_aircrack)

## gui

- [kite：小米性能监控工具](https://kite.mi.com/#/documents/instructions/quickstart?id=%e5%bf%ab%e9%80%9f%e5%bc%80%e5%a7%8b)

- [ADB ToolboX：adb gui只支持windows](https://qx.wysteam.cn/download/)

## app

- [GmsCore：谷歌服务框架的开源替代品。该项目是一个开源的替代 Google Play 服务的解决方案，它可以让无法安装或不想用 Google 服务的用户，运行依赖谷歌服务的 Android 应用。](https://github.com/microg/GmsCore)

- [busybox](https://github.com/meefik/busybox)

- [ZeroTermux](https://github.com/hanxinhao000/ZeroTermux)

    - ZeroTermux 基于 Termux，整合了非常多的脚本和工具，在国内网络环境中部署更简单。
    - 功能：
        - 开启 Web 文件管理，通过网页访问 Termux 以及手机存储部分文件（基于FlieBrowser)
        - 自带文件管理器管理 Termux 文件
        - 一键配置 Termux （换源、美化、安装插件）
        - 一键配置 qemu 虚拟机（甚至可以一键安装 windows7 等）
        - 可通过脚本一键安装 Linux 发行版（Ubuntu、Kail 等等）
            - 通过 proot 容器部署 Linux 发行版（性能损耗较少）

                ```sh
                # 安装 proot-distro 
                pkg install proot-distro 
                # 列出支持的 Linux 发行版
                proot-distro list

                # 安装 Ubuntu
                proot-distro install ubuntu
                # 登录 ubuntu
                proot-distro login ubuntu
                ```

            - 可以通过 Moe 全能脚本、termux-linux-toolx（旧版用的是yutools）这两个脚本工具快速部署Linux 发行版（而且更适合国内网络环境）

        - 开启 SSH
            ```sh
            # 安装 SSH
            pkg install openssh-server
            # 安装 termux-services 退出 termux 重新启动
            pkg install termux-services -y
            # sshd服务设为自启动
            sv-enable sshd 
            # 取消sshd自启动
            sv-disable sshd 
            # 停止sshd服务
            sv down sshd 
            # 启动sshd服务
            sv up sshd 
            # 查看sshd服务运行状态
            sv status sshd
            ```

- [将 Python 程序变成 Android APK](https://github.com/kivy/python-for-android)

- [f-droid：只上架开源app的应用商店](https://f-droid.org/)
    - [f-droid clinet](https://github.com/Droid-ify/client)

- [mgit：git客户端](https://github.com/maks/MGit)

- [AuroraStore：匿名googleplay商店](https://github.com/whyorean/AuroraStore)

- [NewPipe：youtube开源版，可以按时间顺序浏览up的视频](https://github.com/TeamNewPipe/NewPipe)

- [fcitx5：开源输入法](https://github.com/fcitx5-android/fcitx5-android)

- [AidLearning-FrameWork](https://github.com/aidlearning/AidLearning-FrameWork)

- [termux](https://github.com/termux/termux-app)

    - [Termux 高级终端安装使用配置教程](https://www.sqlsec.com/2018/05/termux.html)

- [AndroidBitmapMonitor：图片内存分析工具](https://github.com/shixinzhang/AndroidBitmapMonitor)

- [bitwarden：密码管理器](https://bitwarden.com/download/)

- [Android-Touch-Helper：跳过广告](https://github.com/zfdang/Android-Touch-Helper)

- [李跳跳：跳过广告](https://litiaotiao.cn/)

- [阅读](https://github.com/gedoor/MyBookshelf)

- [KernelFlasher：刷、备份、恢复内核](https://github.com/capntrips/KernelFlasher)

- [自定义屏幕点击](https://github.com/gkd-kit/gkd)
    - [GKD第三方订阅](https://github.com/Adpro-Team/GKD_THS_List)

- [Shizuku：为其他app解锁高级权限](https://github.com/RikkaApps/Shizuku)

- [SmsForwarder（短信转发器）：备用机监控，如应用，短信通知等](https://github.com/pppscn/SmsForwarder)

- [fdroidclient](https://github.com/f-droid/fdroidclient)免费、开源的 Android 应用商店。该项目是 F-Droid 的 Android 客户端，专门收集各类开源安卓软件（FOSS）的应用商店。

- [AfuseKt：视频播放器](https://github.com/AttemptD/AfuseKt-release)支持协议：Alist，SMB，Webdav，Emby（直连），Local，jellyfin（直连），阿里网盘

- [feeel：锻炼动作教学](https://github.com/EnjoyingFOSS/feeel)

- [ReadYou：rss订阅](https://github.com/Ashinch/ReadYou)

- [FocusReader：rss订阅](https://github.com/allentown521/FocusReader)

- [Acode：代码编辑工具](https://github.com/deadlyjack/Acode)轻量级的 Web IDE，具有即时预览、控制台和丰富的插件等特点

    ![image](./Pictures/android/Acode.avif)

- [xbmc：kodi服务端](https://github.com/xbmc/xbmc)
- [Kore：kodi客户端](https://github.com/xbmc/Kore)

- [jellyfin-android：jellyfin视频服务的客户端](https://github.com/jellyfin/jellyfin-android)

    - [jellyfin-androidtv：电视客户端](https://github.com/jellyfin/jellyfin-androidtv)

- [ente](https://github.com/ente-io/ente)：提供端到端加密的服务，内含基于此服务（Ente）的两款产品，它们分别是云相册（免费试用）和 2FA 验证器（永久免费）。永久免费的 Ente Auth，它可帮助你在移动设备上生成并存储两步验证 (2FA) 令牌。

- [RTranslator：实时翻译](https://github.com/niedev/RTranslator)

- [shell360：ssh客户端](https://github.com/shell360)

- [dart_simple_live：一个 APP 上看各种主流直播平台](https://github.com/xiaoyaocz/dart_simple_live)

- [Ente Auth：一个开源的双因素认证码管理器](https://github.com/ente-io/ente)

- [tvbox手机版](https://github.com/XiaoRanLiu3119/TVBoxOS-Mobile)

- [mytv-android：电视直播](https://github.com/yaoxieyoulei/mytv-android)

- [GoGoGo：地图定位修改](https://github.com/ZCShou/GoGoGo)

- [NewPipe：youtube客户端，免广告、免登陆订阅、有下载功能、免会员观看](https://github.com/TeamNewPipe/NewPipe)

- [EtchDroid：无需root，将img写入插入otg线的u盘](https://github.com/EtchDroid/EtchDroid)

- [ImageToolbox：Android 设计的图像编辑工具。它完全免费，支持批量处理、滤镜、背景移除、尺寸调整和裁剪等多种功能。](https://github.com/T8RIN/ImageToolbox)

- [AnLinux-App：安装linux](https://github.com/EXALAB/AnLinux-App)
    - [在下莫老师：坏了，这回给手机装Linux更简单了，利用Anlinux来手机变电脑](https://www.bilibili.com/video/BV1sK2nYpEEg)

- [DualBootPatcher：多重引导。手机多系统启动](https://github.com/chenxiaolong/DualBootPatcher)

- [Apk.1-Installer：apk.1安装，针对微信传apk文件](https://github.com/Ium-Lab/Apk.1-Installer)

- [KernelFlasher：刷内核](https://github.com/capntrips/KernelFlasher)

- [Amarok-Hider：隐藏私人文件和应用](https://github.com/deltazefiro/Amarok-Hider)

- [KeyMapper：可以自定义 Android 设备的按键、指纹和手势操作。无需 ROOT 权限，支持蓝牙和有线键盘，提供灵活的按键重映射体验。](https://github.com/keymapperorg/KeyMapper)

### 应用管理

- [AppManager](https://github.com/MuntashirAkon/AppManager)

- [Inure](https://github.com/Hamza417/Inure)

- [Hail：冻结应用](https://github.com/aistra0528/Hail)

- [AppOps：权限管理](https://github.com/RikkaApps/App-Ops-issue-tracker/releases/tag/files)

- [island：应用隔离、分身](https://play.google.com/store/apps/details?id=com.oasisfeng.island)

- [幸运破解器：破解](https://www.luckypatchers.com/)

#### android四大组件

- [（写轮眼）论坛](https://bbs.letitfly.me/)

- [LibChecker：查看应用的四大组件等](https://github.com/LibChecker/LibChecker)

- [blocker：一键关闭广告相关的四大组件](https://github.com/lihenggui/blocker)

- [Thanox：需要xposed或magisk安装。可以修改四大组件](https://github.com/Tornaco/Thanox)
    - [官方文档](https://tornaco.github.io/Thanox-Docs/zh/)

### 文件管理器、云盘

- [np管理器：模仿mt文件管理器](https://github.com/githubXiaowangzi/NP-Manager)

- [syncthing：文件同步](https://github.com/syncthing/syncthing-android)

- [MaterialFiles：文件管理器](https://github.com/zhanghai/MaterialFiles)

- [mixplorer](https://mixplorer.com)

- [AListFlutter：alist安卓版，局域网视频观看](https://github.com/jing332/AListFlutter)

    - [在下莫老师：旧手机变网盘！无需代码，在手机上快速部署Alist](https://www.bilibili.com/video/BV1vq421c7kW)

- [蜗牛云盘](https://github.com/liupan1890/aliyunpan/issues/901)

- [clouddrive：云盘管理](https://github.com/cloud-fs/cloud-fs.github.io/releases)

### 文件互传、远程控制

- [unison：intel的手机电脑消息、文件传输]()

- [localsend：文件互传](https://github.com/localsend/localsend)

- [kdeconnect：文件传输、剪切板同步、远程控制等](https://github.com/KDE/kdeconnect-android)

- [rustdesk：远程控制](https://github.com/rustdesk/rustdesk)

### 数据备份

- [Android-DataBackup：数据备份](https://github.com/XayahSuSuSu/Android-DataBackup)

- [Neo-Backup](https://github.com/NeoApplications/Neo-Backup)

- [immich：照片和视频的备份解决方案](https://github.com/immich-app/immich)

- [Nextcloud：私人云盘](https://github.com/nextcloud/android)

    - [memories：Nextcloud的照片管理](https://github.com/pulsejet/memories)

### 网络相关

- [WiFiAnalyzer：WiFi 分析工具](https://github.com/VREMSoftwareDevelopment/WiFiAnalyzer)

- [tailscale：WireGuard vpn](https://github.com/tailscale/tailscale-android)

- [session：加密通信](https://github.com/oxen-io/session-android)

- [network_proxy_flutter：支持手机端的免费抓包工具](https://github.com/wanghongenpin/network_proxy_flutter)

- [afwall：对每个应用的iptable gui版](https://github.com/ukanth/afwall)

### 隐藏检查

- [root等隐藏检查app清单](https://github.com/rushiranpise/detection)

- [NativeDetector：牛头人](https://github.com/Dr-TSNG/NativeDetector)

- [ApplistDetector：隐藏检测（英文）](https://github.com/Dr-TSNG/ApplistDetector)

- [ruru：隐藏检测（中文）](https://github.com/byxiaorun/Ruru/releases)

### 游戏相关

- [ppsspp：psp模拟器](https://github.com/hrydgard/ppsspp)

- [Winlator：使用 Wine 和 Box86/Box64 来运行 Windows 应用和游戏](https://github.com/brunodev85/winlator/releases/download/v5.1.0/Winlator.Development.apk)

- [Lemuroid：游戏机模拟器](https://github.com/Swordfish90/Lemuroid)
    - [Lemuroid游戏ROM](https://www.emulatorgames.net/roms/)

### 第三方客户端

- [pilipala：bilibili](https://github.com/guozhigq/pilipala)

# 刷机

- [xda](https://www.xda-developers.com/)

- [miui下载](https://xiaomifirmwareupdater.com/)
- [miui下载](https://xiaomirom.com/series/)
- [miui下载：小米社区](https://web.vip.miui.com/page/info/mio/mio/detail?postId=18371653&fromPathname=mioSingleBoard&app_version=dev.20051)

- [pixelexperience](https://get.pixelexperience.org/)

- [进击的Coder：手把手教你搭建完美的 Android 搞机/逆向环境]()

- 查看是否是vbmeta分区
    ```sh
    # 有vbmeta, vbmeta_a, or vbmeta_b,代表是vbmeta分区
    adb shell ls -l /dev/block/by-name
    ```

- 9008驱动安装

    - [高通9008驱动下载](https://www.mediafire.com/file/us1ffpw4i86j3v1/Qualcomm_QDLoader_HS-USB_Driver_Setup.rar/file)

    - [qpst下载](https://qpsttool.com/qpst-tool-v2-7-496)

    ```sh
    # 未解锁bootloader的收紧，重启进9008
    adb reboot edl
    fastboot oem edl
    ```

## 刷入recovery、magisk、lsposed

- 步骤

    - 1.解锁bootloaders

    - 2.root

    - 3.刷入第三方recovery

        - [twrp官网下载](https://twrp.me/Devices/)
        - [orangefox官网](https://orangefox.download/zh-CN)
        - [Xiaomi Mi 10 PBRP Recovery](https://xdaforums.com/t/xiaomi-mi-10-pbrp-recovery.4664760/)

        - fastboot安装
        ```sh
        # 重启进fastboot
        adb reboot bootloader

        # 查看设备
        fastboot devices

        # 关闭avb分区。vbmeta.img需要从rom中提取
        fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img

        # 刷入twrp
        fastboot flash recovery twrp-3.7.0_12-0-umi.img

        # 重启进recovery
        fastboot reboot recovery
        ```

        - 免刷进twrp
        ```sh
        fastboot boot twrp-3.7.0_12-0-umi.img
        ```

        - `adb shell`安装（需要root）
        ```sh
        su
        dd if=/sdcard/twrp.img of=/dev/block/bootdevice/by-name/recovery
        ```

        - 如果data分区挂载失败，会找不到刷机包。需要格式化data

    - 4.[Apatch](https://github.com/bmax121/APatch)

        - [派大宝UI：速通全新内核级ROOT方案APatch，隐藏效果堪比KSU](https://www.bilibili.com/list/watchlater?bvid=BV1wb4y1P74d)
            - android13以上版本的，APatch刷`boot.img`文件，而面具需要刷的是`init_boot.img`
            ```sh
            # 刷入修补后的boot.img文件
            fastboot flash boot ./apatch_patched_10763_0.10.7_vneh.img

            # 重启手机
            fastboot reboot
            ```

    - 4.[KernelSU](https://github.com/tiann/KernelSU)

        - [小米开源的kernel列表](https://github.com/MiCode/Xiaomi_Kernel_OpenSource)

        - [派大宝UI：【Root玩机】KernelSU 内核root刷入教程](https://www.bilibili.com/video/BV1dm4y1h7Py)
            - 下载文件

                - boot-gz.img.gz后续的文件为联发科机型；boot.img.gz为高通

                - 内核要选择与文件名相同的版本

                    - 官方没有提供kernel版本（5以前），需要自己编译

                        - [[系统进阶指南 Vol.5]KernelSU旧内核编译实践教程](https://www.bilibili.com/video/BV1cX4y127gQ)

            - 文件解压后为boot.img文件，通过fastboot刷入即可

                - magisk模块会自动加载，由于kernelsu是基于kernel的root，可以完美隐藏root，因此fastboot刷入前记得移除shamiko等模块

    - 4.[magisk](https://github.com/topjohnwu/Magisk)

        - 4.[Magisk Delta](https://github.com/HuskyDG/magisk-files/releases)

            - delta版和普通版是可以随意切换的，在magisk授予root后，打开根据提升进行修复，选“直接安装（推荐）”选项即可

                - 切换前：由于delta版使用超级用户列表管理root权限，没有隐藏列表，因此记得移除shamiko模块

                    - 开启“强制使用超级用户列表”，更好的隐藏root

        - 更新magisk时，如果使用了隐藏改名为Settings记得取消

        - [Magisk模块列表](https://github.com/Magisk-Modules-Repo)

        - [Magisk和xposed模块资源分享](https://magisk.suchenqaq.club/)

        - [MMRL：magisk、kernelSU、APatch的模块管理](https://github.com/DerGoogler/MMRL)

        - 隐藏：

            - [Zygisk-Assistant：隐藏root](https://github.com/snake-4/Zygisk-Assistant)
            - [MagiskHide：隐藏root](https://github.com/HuskyDG/MagiskHide/releases/download/v1.10.3/magiskhide-release.zip)
                - 不依赖`zygisk`，与shamiko冲突
            - [shamiko：隐藏root](https://github.com/LSPosed/LSPosed.github.io/releases)

            - [safetynet-fix魔改版：隐藏bootloader锁](https://github.com/PaperStrike/safetynet-fix/releases)

            - 注意：数据人民币app会残留未隐藏时检测的数据，记得清除全部数据

        - [ZygiskNext：替换内置的zygisk](https://github.com/Dr-TSNG/ZygiskNext)

        - [liveboot：magisk模块版。修改开机启动动画为显示logcat、dmensg](https://github.com/symbuzzer/livebootmodule)

        - [ssh服务器](https://github.com/Magisk-Modules-Repo/ssh)
        - [universal-gms-doze：减少google play服务耗电](https://github.com/gloeyisk/universal-gms-doze)

        - [lamda：逆向及自动化的辅助框架](https://github.com/rev1si0n/lamda)

        - [uperf：调度](https://github.com/yc9559/uperf)
        - [FingerprintPay：指纹支付](https://github.com/eritpchy/FingerprintPay)
        - [Fingerface：面部识别](https://github.com/topjohnwu/Fingerface)

        - [Xray4Magisk：xray core](https://github.com/Asterisk4Magisk/Xray4Magisk)

        - [ZygiskFrida](https://github.com/lico-n/ZygiskFrida)

    - 5.xposed

        - [LSPosed](https://github.com/LSPosed/LSPosed)
            - 使用 暗码 `*#*#lsposed#*#*` 可以启动寄生管理器。

        - [xposed模块列表](https://github.com/Xposed-Modules-Repo)

        - [核心破解：降级安装](https://github.com/LSPosed/CorePatch)
        - [Hide-My-Applist：隐藏xposed](https://github.com/Dr-TSNG/Hide-My-Applist)

        - [解除地区限制](https://github.com/Xposed-Modules-Repo/cn.cyanc.xposed.noregionlimits)
        - [虚拟定位](https://github.com/Lerist/FakeLocation)
        - [上帝模式（类似ublock那样屏蔽广告的方式，屏蔽app的组件）](https://github.com/kaisar945/Xposed-GodMode)

        - [微x/Qx模块](https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed)
        - [MaskWechat：隐藏微信聊天记录](https://github.com/Mingyueyixi/MaskWechat)
        - [微密友 - 隐藏微信好友](https://github.com/Xposed-Modules-Repo/wx.myfriends)
        - [修改微信聊天页面信息](https://github.com/pwh-pwh/wxrecordread)
        - [微信群消息助手](https://github.com/zhudongya123/WechatChatRoomHelper)

        - [TSBattery：使 QQ、TIM、微信 变得更省电](https://github.com/fankes/TSBattery)
        - [解除网易云](https://github.com/nining377/UnblockMusicPro_Xposed)
        - [网易云换源插件](https://github.com/Xposed-Modules-Repo/com.blanke.diaomao163)
        - [HookVip：解锁部分App会员](https://github.com/Xposed-Modules-Repo/Hook.JiuWu.Xp)

        - [知了：知乎去广告](https://github.com/shatyuka/Zhiliao)
        - [微博极速版去广告](https://github.com/Xposed-Modules-Repo/me.zhenxin.thisreallylite)
        - [大圣净化](https://github.com/Xposed-Modules-Repo/com.ext.star.wars)

        - [哔哩发评反诈：检测评论是否被吞](https://github.com/freedom-introvert/biliSendCommAntifraud)
        - [哔哩漫游，解除B站客户端番剧区域限制](https://github.com/yujincheng08/BiliRoaming)

        - [Qianji_auto：自动记账](https://github.com/Auto-Accounting/Qianji_auto)

        - [MIUI 生活质量提升](https://github.com/Xposed-Modules-Repo/io.github.chsbuffer.miuihelper)
        - [miui传送门增强 -- TaplusExtension](https://github.com/Xposed-Modules-Repo/io.github.yangyiyu08.taplusext)
        - [customiuizer](https://github.com/monwf/customiuizer)

        - [Jshook：对应用程序注入rhino/frida，你只需要会js就可以快速实现hook](https://github.com/Xposed-Modules-Repo/me.jsonet.jshook)

## [frida](https://frida.re/docs/home/)

- pc上安装frida
    ```sh
    pip install frida-tools
    ```
- 手机上安装frida
    - [下载frida-server](https://github.com/frida/frida/releases)
    ```sh
    adb push frida-server-16.0.18-android-arm64 /data/local/tmp/
    adb shell "chmod 755 /data/local/tmp/frida-server-16.0.18-android-arm64"
    adb shell "/data/local/tmp/frida-server-16.0.18-android-arm64 &"
    ```

- pc上操作
    ```sh
    # 查看手机上的安装应用
    frida-ps -U

    ```

## 救砖

### magisk模块变砖

- 进入`/data/adb/modules/`（magisk模块目录），删除导致变砖的magisk模块。

    - 多种方法进入目录删除模块：
        - 1.twrp删除
        - 2.使用小米手机自带的recovery安全模式，使用有root权限的文件管理器

- 提取当前刷机包的boot.img，进入fastboot刷入

## rom

- [crdroid：类原生](https://xdaforums.com/t/crdroid-stable-xiaomi-mi-10.4660391/)

## GSI

- [TrebleInfo：检查是否支持GSI](https://gitlab.com/TrebleInfo/TrebleInfo)

- [ErfanGSIs：制作GSI](https://github.com/erfanoabdi/ErfanGSIs)

## [小刘不是程序员：如何挂载安卓系统镜像？](https://www.bilibili.com/video/BV1gL411D7hE)

# 电视app

- 论坛
    - [智能电视网](https://www.znds.com/)

    - [当贝市场：bilibili主页](https://space.bilibili.com/13359751)


- 应用商店
    - 当贝市场
        - [当贝市场在线地址](https://www.dangbei.com/app/)
    - emoton store：相当于海外版当贝商店
    - [电视猫在线地址](https://www.tvmao.com/tv/)
    - [黑域基地在线地址](https://www.hybase.com/shouji/tv/)

- 文件管理
    - 小白文件管理器
    - [猫头鹰文件](https://www.skyjos.cn/owlfiles/publishing/android_tv/)
    - File Manager Pro+
    - es文件管理器
    - X-plore

- 浏览器
    - emoton浏览器
    - via浏览器TV版

- 视频
    - [tvbox：这个项目包含tvbox的其他版本和各种配置](https://github.com/qist/tvbox)
        - https://ghp.ci/https://raw.githubusercontent.com/xianyuyimu/TVBOX-/main/TVBox/%E4%B8%80%E6%9C%A8%E5%A4%9A%E7%BA%BF%E8%B7%AF.json

    - [OK影视：类似于tvbox](https://github.com/FongMi/Release)

    - 影视仓：类似于tvbox

    - [mytv-android](https://github.com/yaoxieyoulei/mytv-android)

    - BesTV粤视厅

    - [BBLL：第三方bilibili](https://github.com/xiaye13579/BBLL)
    - [smarttube：第三方youtube，没有广告](https://github.com/yuliskov/SmartTube)
    - YouTube for Fire TV：无需google服务

- 播放器

    - [kodi](https://kodi.tv/download/)
        - 插件：
            - PVR：iptv客户端
            - opensubtitles：字幕
            - 豆瓣刮削器
            - speed test：测网速

    - [nova](https://github.com/nova-video-player/aos-AVP)

    - [vlc](https://www.videolan.org/vlc/download-android.html)

    - 当贝播放

    - [SmartTube](https://github.com/yuliskov/SmartTube)

- nas
    - jellyfin
    - emby
    - plex

- ui
    - projectivy_launcher
    - emotn ui
    - 当贝桌面
    - 吾爱出品

- 云盘

    - 阿里云盘第三方
        - 小白云盘TV版：播放4k没问题，有自动挂载云盘功能，能解析所有音轨，支持kodi、nplayer、mx player播放器。
        - 阿里云盘TV版：在线搜索资源最丰富，字幕资源最丰富。只支持调用kodi播放器
        - 蜗牛云盘TV版：支持kodi、mx player播放器

    - 天翼云盘TV
    - 夸克网盘TV版
    - 中国移动云盘

- 游戏机模拟器
    - 爱吾游戏宝盒
    - 小鸡模拟器
    - 酷咖游戏

- ktv
    - iktv
    - 想唱就唱KTV

- 投屏
    - 当贝投屏

- adb
    - 手机使用甲壳虫ADB助手
    - 手机使用atvTools

- 其他
    - AIDA64：查看硬件参数
    - 米家TV版：控制小米生态链设备
    - 搜狗输入法海信提取版
    - 东方财富通tv版

# 类似项目

- [awesome-android-root](https://github.com/fynks/awesome-android-root)

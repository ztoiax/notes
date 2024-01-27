# Android

- [Android学习路线](https://roadmap.sh/android)

# 第三方优秀资源

## cli

- [adb-sync](https://github.com/google/adb-sync)

    ```sh
    # 手机同步到电脑         adb-sync --reverse /sdcard/Download/ ~/Downloads
    # 电脑同步到手机         adb-sync -d ~/Downloads /sdcard/Download/
    ```

- [sndcpy：将手机音频转发到电脑](https://github.com/rom1v/sndcpy)

## gui

- [kite：小米性能监控工具](https://kite.mi.com/#/documents/instructions/quickstart?id=%e5%bf%ab%e9%80%9f%e5%bc%80%e5%a7%8b)

## app

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

- [f-droid：只上架开源app的应用商店](https://f-droid.org/)

- [AuroraStore：匿名googleplay商店](https://github.com/whyorean/AuroraStore)

- [NewPipe：youtube开源版，可以按时间顺序浏览up的视频](https://github.com/TeamNewPipe/NewPipe)

- [fcitx5：开源输入法](https://github.com/fcitx5-android/fcitx5-android)

- [AidLearning-FrameWork](https://github.com/aidlearning/AidLearning-FrameWork)

- [termux](https://github.com/termux/termux-app)

    - [Termux 高级终端安装使用配置教程](https://www.sqlsec.com/2018/05/termux.html)

- [AndroidBitmapMonitor：图片内存分析工具](https://github.com/shixinzhang/AndroidBitmapMonitor)

- [tailscale：WireGuard vpn](https://github.com/tailscale/tailscale-android)

- [syncthing：文件同步](https://github.com/syncthing/syncthing-android)

- [ApplistDetector：隐藏检测英文](https://github.com/Dr-TSNG/ApplistDetector)

- [ruru：隐藏检测中文](https://github.com/byxiaorun/Ruru/releases)

- [session：加密通信](https://github.com/oxen-io/session-android)

- [Shadowsocks（写轮眼）论坛](https://bbs.letitfly.me/)

- [bitwarden：密码管理器](https://bitwarden.com/download/)

- [Android-Touch-Helper：跳过广告](https://github.com/zfdang/Android-Touch-Helper)

- [李跳跳：跳过广告](https://litiaotiao.cn/)

- [幸运破解器](https://www.luckypatchers.com/)

- [np管理器](https://github.com/githubXiaowangzi/NP-Manager)

- [阅读](https://github.com/gedoor/MyBookshelf)

- [unison：intel的手机电脑消息、文件传输]()

- [localsend](https://github.com/localsend/localsend)

- [KernelFlasher：刷、备份、恢复内核](https://github.com/capntrips/KernelFlasher)

- [自定义屏幕点击](https://github.com/gkd-kit/gkd)

- [rustdesk：远程控制](https://github.com/rustdesk/rustdesk)

- [SmsForwarder（短信转发器）：备用机监控，如应用，短信通知等](https://github.com/pppscn/SmsForwarder)

- [network_proxy_flutter：支持手机端的免费抓包工具](https://github.com/wanghongenpin/network_proxy_flutter)

## 刷机

- [xda](https://www.xda-developers.com/)

- [miui下载](https://xiaomifirmwareupdater.com/)
- [miui下载](https://xiaomirom.com/series/)

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

### 刷入recovery、magisk、lsposed

- 步骤

    - 1.解锁bootloaders

    - 2.root

    - 3.刷入第三方recovery

        - [twrp官网下载](https://twrp.me/Devices/)
        - [orangefox官网](https://orangefox.download/zh-CN)

        - fastboot安装
        ```sh
        # 重启进fastboot
        adb reboot bootloader

        # 查看设备
        fastboot devices

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

        - [Android-Kernel-Tutorials](https://github.com/ravindu644/Android-Kernel-Tutorials)

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

        - 隐藏：

            - [MagiskHide：隐藏root](https://github.com/HuskyDG/MagiskHide/releases/download/v1.10.3/magiskhide-release.zip)
                - 不依赖`zygisk`，与shamiko冲突
            - [shamiko：隐藏root](https://github.com/LSPosed/LSPosed.github.io/releases)
            - [safetynet-fix魔改版：隐藏bootloader锁](https://github.com/PaperStrike/safetynet-fix/releases)

            - 注意：数据人民币app会残留未隐藏时检测的数据，记得清除全部数据

        - [ssh服务器](https://github.com/Magisk-Modules-Repo/ssh)
        - [universal-gms-doze：减少google play服务耗电](https://github.com/gloeyisk/universal-gms-doze)
        - [uperf：调度](https://github.com/yc9559/uperf)
        - [FingerprintPay：指纹支付](https://github.com/eritpchy/FingerprintPay)
        - [Fingerface：面部识别](https://github.com/topjohnwu/Fingerface)

    - 5.xposed

        - [LSPosed](https://github.com/LSPosed/LSPosed)
            - 使用 暗码 `*#*#lsposed#*#*` 可以启动寄生管理器。

        - [xposed模块列表](https://github.com/Xposed-Modules-Repo)

        - [核心破解：降级安装](https://github.com/LSPosed/CorePatch)

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

        - [知了：知乎去广告](https://github.com/shatyuka/Zhiliao)
        - [微博极速版去广告](https://github.com/Xposed-Modules-Repo/me.zhenxin.thisreallylite)
        - [大圣净化](https://github.com/Xposed-Modules-Repo/com.ext.star.wars)

        - [哔哩发评反诈：检测评论是否被吞](https://github.com/freedom-introvert/biliSendCommAntifraud)
        - [哔哩漫游，解除B站客户端番剧区域限制](https://github.com/yujincheng08/BiliRoaming)

        - [Qianji_auto：自动记账](https://github.com/Auto-Accounting/Qianji_auto)

        - [MIUI 生活质量提升](https://github.com/Xposed-Modules-Repo/io.github.chsbuffer.miuihelper)
        - [miui传送门增强 -- TaplusExtension](https://github.com/Xposed-Modules-Repo/io.github.yangyiyu08.taplusext)
        - [customiuizer](https://github.com/monwf/customiuizer)

### [frida](https://frida.re/docs/home/)

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

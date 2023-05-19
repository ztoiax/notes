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

- [AidLearning-FrameWork](https://github.com/aidlearning/AidLearning-FrameWork)

- [termux](https://github.com/termux/termux-app)

    - [Termux 高级终端安装使用配置教程](https://www.sqlsec.com/2018/05/termux.html)

- [AndroidBitmapMonitor：图片内存分析工具](https://github.com/shixinzhang/AndroidBitmapMonitor)

- [tailscale：WireGuard vpn](https://github.com/tailscale/tailscale-android)

- [syncthing：文件同步](https://github.com/syncthing/syncthing-android)

- [ApplistDetector：隐藏检测](https://github.com/Dr-TSNG/ApplistDetector)

- [session：加密通信](https://github.com/oxen-io/session-android)

- [Shadowsocks（写轮眼）论坛](https://bbs.letitfly.me/)

- [bitwarden：密码管理器](https://bitwarden.com/download/)

- [李跳跳：跳过广告](https://litiaotiao.cn/)

- [幸运破解器](https://www.luckypatchers.com/)

- [np管理器](https://github.com/githubXiaowangzi/NP-Manager)

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

    - 4.[KernelSU](https://github.com/tiann/KernelSU)

        - [[系统进阶指南 Vol.5]KernelSU旧内核编译实践教程](https://www.bilibili.com/video/BV1cX4y127gQ)
        - [小米开源的kernel列表](https://github.com/MiCode/Xiaomi_Kernel_OpenSource)

    - 4.[magisk](https://github.com/topjohnwu/Magisk)

        - [Magisk模块列表](https://github.com/Magisk-Modules-Repo)

        - 隐藏：

            - [MagiskHide：隐藏root](https://github.com/HuskyDG/MagiskHide/releases/download/v1.10.3/magiskhide-release.zip)
                - 不依赖`zygisk`，与shamiko冲突
            - [shamiko：隐藏root](https://github.com/LSPosed/LSPosed.github.io/releases)
            - [safetynet-fix魔改版：隐藏bootloader锁](https://github.com/PaperStrike/safetynet-fix/releases)

        - [ssh服务器](https://github.com/Magisk-Modules-Repo/ssh)
        - [universal-gms-doze：减少google play服务耗电](https://github.com/gloeyisk/universal-gms-doze)
        - [uperf：调度](https://github.com/yc9559/uperf)
        - [FingerprintPay：指纹支付](https://github.com/eritpchy/FingerprintPay)
        - [Fingerface：面部识别](https://github.com/topjohnwu/Fingerface)

    - 5.xposed

        - [LSPosed](https://github.com/LSPosed/LSPosed)
            - 使用 暗码 `*#*#lsposed#*#*` 可以启动寄生管理器。

        - [xposed模块列表](https://github.com/Xposed-Modules-Repo)

        - [解除地区限制](https://github.com/Xposed-Modules-Repo/cn.cyanc.xposed.noregionlimits)
        - [虚拟定位](https://github.com/Lerist/FakeLocation)
        - [上帝模式（类似ublock那样屏蔽广告的方式，屏蔽app的组件）](https://github.com/kaisar945/Xposed-GodMode)

        - [微x/Qx模块](https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed)
        - [MaskWechat：隐藏微信聊天记录](https://github.com/Mingyueyixi/MaskWechat)
        - [TSBattery：使 QQ、TIM、微信 变得更省电](https://github.com/fankes/TSBattery)
        - [解除网易云](https://github.com/nining377/UnblockMusicPro_Xposed)

        - [知了：知乎去广告](https://github.com/shatyuka/Zhiliao)
        - [微博极速版去广告](https://github.com/Xposed-Modules-Repo/me.zhenxin.thisreallylite)
        - [大圣净化](https://github.com/Xposed-Modules-Repo/com.ext.star.wars)

        - [Qianji_auto：自动记账](https://github.com/Auto-Accounting/Qianji_auto)

        - [MIUI 生活质量提升](https://github.com/Xposed-Modules-Repo/io.github.chsbuffer.miuihelper)
        - [miui传送门增强 -- TaplusExtension](https://github.com/Xposed-Modules-Repo/io.github.yangyiyu08.taplusext)
        - [customiuizer](https://github.com/monwf/customiuizer)

- [frida](https://frida.re/docs/home/)
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

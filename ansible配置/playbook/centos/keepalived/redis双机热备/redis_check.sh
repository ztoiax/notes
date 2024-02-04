#!/bin/bash

# 方法1：判断进程是否存在，不存在尝试重启redis，无法重启再杀死keepalived

# if [ `pgrep redis | wc -l` -eq 0 ];then
#     /usr/sbin/redis # 尝试重新启动redis
#     sleep 2         # 睡眠2秒
#     if [ `pgrep redis | wc -l` -eq 0 ];then
#         # 启动失败，将keepalived服务杀死。将vip漂移到其它备份节点
#         systemctl stop keepalived
          # 或者使用killall。如果使用killall命令，需要安装psmisc包
          # killall keepalived
#     fi
# fi

# 方法2：判断进程是否存在，不存在直接杀死keepalived
if [ `pgrep redis | wc -l` -eq 0 ];then
    # 启动失败，将keepalived服务杀死。将vip漂移到其它备份节点
    systemctl stop keepalived
    # 或者使用killall。如果使用killall命令，需要安装psmisc包
    # killall keepalived
fi

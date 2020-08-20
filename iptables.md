# iptables

### 查看规则

```sh
iptables -nvL
iptables -nvL --line-numbers #显示编号
```

### 重置规则

```
iptables -F #刷新chain
iptables -X #删除非默认chain
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X
iptables -t security -F
iptables -t security -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
```

### 保存规则

```sh
iptables-save > /etc/iptables/iptables.rules
#或者
iptables-restore < /etc/iptables/iptables.rules
systemctl reload iptables #重新加载配置文件
```

### 最近一次启动后所记录的数据包
```sh
journalctl -k | grep "IN=.*OUT=.*" | less
```


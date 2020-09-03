# iptables

| 参数 | 操作                                           |
| ---- | ---------------------------------------------- |
| -D   | 删除规则                               |
| -L   | 查看规则                               |
| -F   | 删除所有规则                               |
| -j   | 动作                               |
| -s   | 源地址                               |
| -d   | 目标地址                               |
| -i   | 源接口                               |
| -o   | 目标接口                               |
| -p   | 协议                               |
`-s '!' 192.168.1.0/24` 匹配除了`192.168.1.0`网段
| 链 | 操作                 |
| ---- | -------- |
| PRERROUTING   | 目标地址转换 |
| POSTROUTING   | 源地址转换 |
| OUTPUT   | 出口 |
| INTPUT   | 入口 |
### 查看规则

```sh
iptables -L   # 查看规则
iptables -nvL --line-numbers # 查看详细规则
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

### 允许所有tcp协议访问80端口
```sh
iptables -I INPUT 2 -p tcp --dport 80 -j ACCEPT
```
### 只在9:00到18:00这段时间,允许访问80端口
```sh
iptables -I INPUT 2 -p tcp --dport 80 -m time --timestart 9:00 --timestop 18:00 -j ACCEPT
```
### 禁止192.168.1.0/24到10.1.1.0/24的流量
```sh
iptables -A FORWARD -s 192.168.1.0/24 -d 10.1.1.0/24 -j DROP
```
### Nat

#### 将目标端口是80的流量,跳转到192.168.1.1
```sh
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-dest 192.168.1.1
```
#### 将出口为80端口的流量,跳转到192.168.1.1:8080端口
```sh
iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-dest 192.168.1.1:8080
```
#### 将所有内部地址,伪装成一个外部公网地址
```sh
iptable -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```
### 通过nat隐藏源ip地址
```sh
iptable -t nat -A POSTROUTING -j SNAT --to-source 1.2.3.4
```

### 保存规则
默认保存目录
- `centos` `/etc/sysconfig/iptables`
- `arch` `/etc/iptables`

```sh
iptables-save > /etc/iptables/iptables.rules
# 重新加载配置文件
iptables-restore < /etc/iptables/iptables.rules
systemctl reload iptables
```

### 最近一次启动后所记录的数据包
```sh
journalctl -k | grep "IN=.*OUT=.*" | less
```

# reference
- [Linux高级系统管理](https://study.163.com/course/courseMain.htm?courseId=232008)

# lvs

## ipvs

```bash
# 添加模块
modprobe ip_vs
```

# [keepalived](https://github.com/acassen/keepalived)

> 是 lvs 的拓展项目

## install(安装)

```bash
# 下载
curl -LO https://www.keepalived.org/software/keepalived-2.2.1.tar.gz
tar zxvf keepalived-2.2.1.tar.gz
cd keepalived-2.2.1

# 安装配置
# --sysconfdir 安装目录
./configure --sysconfdir=/var/lib

# 编译安装
make -j$(nproc) && make install
```

## 基本

- [官方文档](https://www.keepalived.org/manpage.html)

- 配置文件 `/var/lib/keepalived/keepalived.conf`

配置可分为三类:

| 配置分类         | 内容        |
| ---------------- | ----------- |
| Global(全局配置) | global_defs |
| vrrpd            |             |
| lvs              |             |

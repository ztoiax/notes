# kvm

- 配置文件`/etc/libvirt/qemu/`

- 服务 `libvirtd.service`

## without sudo

```bash
# 将用户添加到libvirt组
sudo usermod -a -G libvirt $USER

# 修改配置文件
sudo vim /etc/libvirt/libvirtd.conf

unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"

# 重启(可能需要重新登陆)
sudo systemctl restart libvirtd.service

# 每次加入-c qemu:///system list
virsh -c qemu:///system list --all
virt-manager -c qemu:///system
```

## 基本命令

```bash
# 查看虚拟机状态
virsh list --all

# 开启/关闭
virsh start opensuse15.2
virsh shutdown opensuse15.2

# 暂停/恢复
virsh suspend opensuse15.2
virsh resume opensuse15.2

# 查看网络
virsh net-list --all

# 查看dhcp ip
virsh net-dhcp-leases --network default

# 查看运行中的虚拟机ip,mac
virsh domifaddr opensuse15.2_1

# 修改虚拟机ip地址.如虚拟机运行,需要重启
virsh net-update default add ip-dhcp-host \
      "<host mac='52:54:00:7f:81:df' \
       name='bob' ip='192.168.100.71' />" \
       --live --config
```

## 克隆虚拟机

opensuse15.2 -> opensuse15.2_1

```bash
# 暂停opensuse15.2
sudo virsh suspend opensuse15.2

# 克隆qcow2镜像
sudo virt-clone --original opensuse15.2 \
--name opensuse15.2_1 \
--file ./opensuse15.2_1.qcow2

grep mac /etc/libvirt/qemu/opensuse15.2_1.xml

# 连接
virsh start opensuse15.2_1
ssh user@ip

# 修改新的uuid
uuidgen eth0

# 如果是静态ip,则需要修改
vim /etc/sysconfig/network/ifcfg-eth0
systemctl restart network.service

# 如果是dhcp,在真机执行以下命令

# 查看mac地址
grep "mac address" /etc/libvirt/qemu/opensuse15.2_1.xml

# 通过mac地址修改ip
virsh net-update default add ip-dhcp-host \
      "<host mac='52:54:00:3d:62:04' \
       name='bob' ip='192.168.100.72' />" \
       --live --config
```

## correct way to move kvm vm

### dump

**source** host run

```sh
virsh dumpxml VMNAME > domxml.xml
```

**destination** host run

```sh
virsh define domxml.xml
```

### for net

**source** host run

```sh
virsh net-dumpxml NETNAME > netxml.xml
```

**destination** host run

```sh
virsh net-define netxml.xml && virsh net-start NETNAME & virsh net-autostart NETNAME
```

If the output is error

```sh
virsh net-destroy SOURCEname
virsh net-undefine SOURCEname
```

And then do it again

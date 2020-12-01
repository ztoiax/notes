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

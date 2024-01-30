# [ansible](https://github.com/ansible/ansible)

- Anasible 是基于Python2-Paramiko 模块开发的自动化维护工具

- Ansible 是新出现的自动化运维工具，它基于 Python 开发，集合了众多运维工具（puppet、cfengine、chef、func、 fabric）的优点实现了批量系统配置、批量程序部署、批量运行命令等功能。

- Ansible 使用 SSH 协议进行通信

## 架构

![image](./Pictures/ansible/ansible架构.avif)

- 核心：ansible

- 核心模块（Core Module）：ansible自带的模块。将资源分发到远程节点，让其执行特定人物或匹配一个特定的状态

- 扩展模块（Custom Module）：如果核心模块不足以完成某种功能，可以添加扩展模块

- 插件（Plugin）：完成较小型的任务，辅助模块来完成某个功能

- 剧本（Playbook）：ansible的任务配置文件，playbook定义多个任务，由ansible自动执行
    - 例子：安装nginx服务。可以拆分成几个任务放到一个playbook中：
        - 1.下载nginx源码包
        - 2.将事先写好的nginx.conf配置发送到目标服务器
        - 3.启动服务
        - 4.检查端口是否正常开启

- 连接插件（Connectior Plugin）：ansible基于连接插件连接到各个主机上。支持的3种方法连接（默认使用ssh连接）：如local、zeromq、ssh.

- 主机清单（Host Inventory）：定义ansible管理的主机
    - 小型环境只需要在host文件，写入主机ip即可
    - 中大型环境需要使用静态主机清单或动态主机清单，来生成需要执行的目标主机

## 运行原理

## 基本命令

- ansible主要有7条命令：其中ansible和ansible-playbook使用最多

- 1.`ansible`：指令的核心部分，主要用于执行ad-hoc命令（单条命令）。

- 2.`ansible-doc`：模块相关命令

    ```sh
    # 查看安装的模块
    ansible-doc -l

    # 查看command模块的用法
    ansible-doc -s command
    ```

- 3.`ansible-galaxy`：第三方模块。类似与centos的yum

    ```sh
    # 安装aeriscloud.docker组件
    ansible-galaxy install aeriscloud.docker
    ```

- 4.`ansible-playbook`：使用最多的命令。获取playbook.yml后，执行相应的动作

- 5.`ansible-lint`：检查playbook文件语法

- 6.`ansible-pull`：ansible的pull模式，与平常使用push模式刚好相反
    - 适用于：
        - 数量巨多的机器需要配置
        - 在一个没有网络连接的机器上运行ansible，比如启动之后安装

- 7.`ansible-vault`：主要应用于配置文件中含有敏感信息，不希望被人看到的情况
    - vault可以帮助你加密/解密这个配置，属高级语法
    - 对于playbooks里涉及密码，可以通过该指令加密。
    - 需要输入密码才能编辑
    - 执行playbook文件需要加上`--ask-vault-pass`，还要输入密码

## 配置文件

- /etc/ansible/ansible.cfg 主配置文件, 配置ansible的工作特性
- /etc/ansible/hosts 主机列表清单
- /etc/ansible/roles/ 存放(roles)角色的目录
- /usr/local/bin/ansible 二进制执行文件, ansible 主程序
- /usr/local/bin/ansilbe-doc 配置文档, 模块功能查看工具
- /usr/local/bin/ansible-galaxy 用于上传/下载 roles 模块到官方平台的工具
- /usr/local/bin/ansible-playbook 自动化任务、编排剧本工具/usr/bin/ansible-pull 远程执行命令的工具
- /usr/local/bin/ansible-vault 文件(如: playbook 文件) 加密工具
- /usr/local/bin/ansible-console 基于 界面的用户交互执行工具


- /etc/ansible/ansible.cfg
    - 默认端口
    - 是否需要输入密码
    - 是否开启sudo
    - 是否开启log
    - action_plugins插件的位置
    - hosts主机组的位置
    - key文件的位置

    ```yml
    # defaults 为默认配置
    [defaults]

    # 主机清单的路径, 默认为如下
    # inventory = /etc/ansible/hosts

    # 模块存放的路径
    # library = /usr/share/my_modules/

    # utils 模块存放路径
    # module_utils = /usr/share/my_module_utils/

    # 远程主机脚本临时存放目录
    # remote_tmp = ~/.ansible/tmp

    # 管理节点脚本临时存放目录
    # local_tmp = ~/.ansible/tmp

    # 插件的配置文件路径
    # plugin_filters_cfg = /etc/ansible/plugin_filters.yml

    # 最多能有多少个进程同时工作，最多设置5个
    # forks = 5

    # 异步任务查询间隔 单位秒
    # poll_interval  = 15

    # sudo 指定用户
    # sudo_user = root

    # 运行 ansible 是否提示输入sudo密码
    # ask_sudo_pass = True

    # 运行 ansible 是否提示输入密码 同 -k
    # ask_pass = True

    # 远程传输模式
    # transport = smart

    # SSH 默认端口
    # remote_port = 22

    # 模块运行默认语言环境
    # module_lang = C

    # roles 存放路径
    # roles_path = /etc/ansible/roles

    # 不检查 /root/.ssh/known_hosts 文件 建议取消
    # host_key_checking = False

    # ansible 操作日志路径 建议打开
    # log_path = /var/log/ansible.log

    # private_key_file使用ssh公钥私钥登陆系统的时候，密钥的路径
    # private_key_file=/path/ to/file.pem
    ```

## ansible命令和内置模块的使用

- [官方文档-各种内置模块和plugin的用法](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html)

- [hellogitlab：各种内置模块的用法](https://hellogitlab.com/CM/ansible/)

![image](./Pictures/ansible/ansible命令.avif)

- ssh配置
    - 生成SSH秘钥 `ssh-keygen -t rsa -C "tz"`
    - 复制公钥到远程主机
        ```sh
        # 复制本地的公钥到远程主机。
        ssh-copy-id root@192.168.100.208

        # 复制指定公钥到远程主机
        ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.100.208
        ```

- 主机清单文件：`/etc/ansible/hosts`。可以是域名或ip

    - 需要配置好此文件后，才能使用`ansible`命令

    ```
    [centos]
    192.168.100.208

    [k8s]
    www.example.com
    ```

- 当命令执行后，不同的字体颜色表示不同的结果
    - 绿色：执行成功并且对目标主机没做改变
    - 黄色：执行成功并且对目标主机做了改变
    - 红色：执行失败
    - 紫色：代表命令执行后发出的警告信息，给我们一些建议（可以忽略）

- ansible <主机ip、主机名、主机组> -m [模块名] -a [模块参数] [ansible参数]
    - -v、-vv、-vvv: 显示详细的命令输出日志, v 越多越详细。如: ansible all -m ping -vvv
    - --list: 显示主机的列表。
        - `ansible all --list`
    - -k: 提示输入ssh连接密码, 默认为 ssh-key 认证。
        - `ansible all -m ping -k`
    - -K: 提示输入 sudo 的密码。
    - -C: 检查命令操作, 并不会执行。
        - `ansible all -m ping -C`
    - -T: 执行命令的超时时间, 默认为 10s。
        - `ansible all -m ping -T=2`
    - -u: 执行远程操作的用户.
        - `ansible all -m ping -u=root`
    - -b: 代替旧版的 sudo 切换。

```sh
# 查看模块command用法
ansible-doc -s command
```

```sh
# 默认使用command模块
ansible 192.168.100.208 -a 'date'

# all代表所有主机
ansible all -a 'date'
# 只在centos标签的主机上执行
ansible centos -a 'date'
# 只在k8s标签的主机上执行
ansible k8s -a 'date'
# 在centos和k8s标签的主机上执行。':&' 逻辑与 (两个组中都包含的主机)
ansible 'centos:&k8s' -a 'date'
# *通配符
ansible '*-cluster' -m ping -k
# 正则表达式
ansible '~(codo|k3s)-cluster' -m ping -k

# -k 使用密码方式，默认是使用SSH-KEY登录。
ansible centos -a 'date' -k
```

- command模块：不指定模块时，默认使用command模块
    - 不能包含符号如< > | ; &
    - 不会经过远程主机的shell处理

- command和shell和script模块都有3个参数
    - chdir：执行命令之前，会先进入到指定的目录中
    - creates：文件如果存在于远程主机中，则不执行对应命令，如果不存在，才执行
    - removes：文件如果不存在于远程主机中，则不执行对应命令，如果存在 ，才执行

    ```sh
    # chdir参数表示执行命令之前，会先进入到指定的目录中
    ansible centos -m command -a 'chdir=/root/ ls'

    # creates参数表示如果/etc/passwd文件存在于远程主机中，则不执行对应命令，如果不存在，才执行”touch”命令
    ansible test -m command -a 'creates=/etc/passwd touch /opt/passwd'

    # removes参数表示如果/opt/abc文件不存在，就不执行“mv”命令，如果文件存在则执行“mv”命令
    ansible test -m command -a 'removes=/opt/abc mv /opt/abc /root/'
    ```

```sh
# ping模块
ansible 192.168.100.208 -m ping

# shell模块：支持命令带有 $、< >、|、；、&
ansible 192.168.100.208 -m shell -a "ps aux | grep nginx"

# raw模块。执行ansible远程主机需要python。raw模块可以不需要远程主机安装python，就能执行
ansible 192.168.100.208 -m raw -a "echo 12345"

# script模块。将脚本复制到远程主机上执行。远程路径由/etc/ansible/ansible.cfg定义
ansible all -m script -a '/tmp/test.sh'
ansible all -m script -a '/tmp/test.py'

# fetch模块。将远程目标主机上的 test.sh 脚本获取并下载到本地 ansible 主机上的 data 目录下
ansible all -m fetch -a "src=/test1.sh dest=/data/scripts"

# shell模块+fetch模块：一次性获取多个文件
# 打包多个文件
ansible all -m shell -a "tar jcf log.tar.xz /var/log/*.log"
# 获取文件
ansible all -m fetch -a "src=/root/log.tar.xz dest=/data"
```

- copy模块：将文件复制到远程主机
    - src：此参数用于指定需要拷贝的文件或目录
    - content：此参数当不使用src指定拷贝的文件时，可以使用content直接指定文件内容，src与content两个参数必有其一
    - dest：此参数用于指定文件将拷贝到远程主机的哪个目录中，dest为必须参数
    - owner：指定文件拷贝到远程主机后的属主
    - group：指定文件拷贝到远程主机后的属组
    - mode：指定文件拷贝到远程主机后的权限
    - force：当远程主机的目标路径中已经存在同名文件，并且与ansible主机中的文件内容不同时，是否强制覆盖
    - backup：当远程主机的目标路径中已经存在同名文件，并且与ansible主机中的文件内容不同时，是否对远程主机的文件进行备份

    ```sh
    ansible all -m copy -a 'src=/etc/hosts dest=/etc/hosts'

    # 直接将内容写入文件
    ansible all -m copy -a 'content="test content" dest=/root/test.txt '
    ```

- synchronize模块：调用rsync进行文件或目录欧特奴公布

    - copy模块和synchronize模块的简单比较
        - copy模块不支持从远端到本地的pull（拉取）操作；fetch模块支持，但是src参数不支持目录递归，只能回传具体文件
        - copy模块适用于小规模文件操作，synchronize支持大规模文件操作

    | 参数            | 说明                                                                                                   |
    |-----------------|--------------------------------------------------------------------------------------------------------|
    | src（必填）     | 源主机上的路径                                                                                         |
    | dest（必填）    | 目标主机上的存储路径                                                                                   |
    | archive         | 递归保留源目录中的软链、权限、时间戳、所属用户等属性                                                   |
    | recursive       | 目录递归                                                                                               |
    | group           | 指定所属用户组                                                                                         |
    | owner           | 指定所属用户                                                                                           |
    | links           | 保留软链接                                                                                             |
    | perms           | 保留权限设置                                                                                           |
    | times           | 保留时间戳                                                                                             |
    | compress        | 压缩传输，除非会导致异常，多数情况下建议开启(added in 1.7)                                             |
    | copy_links      | 复制软链指向的内容而不是软链本身                                                                       |
    | delete          | 传输完成后，删除目标路径下，源目录中不存在的文件This option requires recursive=yes.                    |
    | dirs            | 不递归传输                                                                                             |
    | existing_only   | 跳过目标端不存在的目录或文件(added in 1.5)                                                             |
    | mode            | 指定推送方式，拉取或者推送，默认是push模式，push模式下src是源，pull模式下dest是源                      |
    | use_ssh_args    | 使用ansible.cfg中指定的ssh_args参数(added in 2.0)                                                      |
    | rsync_opts      | 通过数组指定额外的rsync选项(added in 1.6)                                                              |
    | rsync_path      | 指定远程主机上的rsync命令                                                                              |
    | rsync_timeout   | 指定rsync的超时时间                                                                                    |
    | verify_host     | 验证目标主机的秘钥(added in 2.0)                                                                       |
    | set_remote_user | 当远端服务器上自定义ssh配置文件中定义的remote user和inventory user不匹配的情况下，这个参数值设置为”no” |

    ```sh
    # push模式。将本地的/mnt/rpm复制到远程主机的/tmp下
    ansible all -m synchronize -a "src=/mnt/rpm dest=/tmp/"
    # pull模式。将远程主机的/tmp复制到远程主机的/mnt/tmp下
    ansible all -m synchronize -a "mode=pull src=/tmp dest=/mnt/tmp"

    # push模式
    ansible all -m synchronize -a "src=/tmp/test.txt dest=/tmp/ rsync_opts='-abvzP, --suffix=.bak-$(date "+%Y-%m-%d_%H")'"

    # pull模式
    ansible all -m synchronize -a "mode=pull src=/tmp/tmp1 dest=/tmp/ rsync_opts='-abvzP, --suffix=.bak-$(date "+%Y-%m-%d_%H")'"
    ```

- file模块
    - name：指定文件名字
    - path：指定文件路径
    - mode：设置文件权限
    - owner：所有者
    - group：所属组
    - recurse：当文件为目录时，是否进行递归设置权限
    - state：
        - touch ：创建文件
        - directory：创建目录
        - absent：删除文件或者目录或者链接文件
        - link或hard：创建链接文件

    ```sh
    # 修改权限
    ansible all -m file -a "path=/root/test1.sh owner=lisi mode=777"

    # state=link 说明创建一个软链接文件
    ansible all -m file -a "src=/data/test1 dest=/data/test1.link state=link"

    # 创建文件
    ansible all -m file -a "name=/data/test2 state=touch"
    # 删除文件
    ansible all -m file -a "name=/data/test2 state=absent"
    # 创建目录
    ansible all -m file -a "name=/data/dir1 state=directory"
    # 删除目录
    ansible all -m file -a "name=/data/dir1 state=absent"
    ```

- lineinfile 模块：对文件的行替换、插入、删除
    - path：指定要操作的文件对象
    - line：要写入文件的内容
    - regexp：匹配条件
    - insertbefore：在某行之前插入
    - insertafter：在某行之后插入
    - backup: 执行配置任务前是否先进行备份，yes|no

- user模块
    - name"" 用户名
    - shell="" 指定用户的shell类型
    - system="yes/no" 指定是否为 系统用户
    - home="" 指定用户额外的home目录, 默认/home/user .
    - groups="" 用户额外的 groups 组.
    - uid="" 指定用户的UID.
    - comment="" 用户描述
    - password：用户密码，需要通过hash加密
    - state="present/absent"
        - present: 创建用户 (默认为present)
        - absent: 删除用户
    - remove：删除用户的时候，删除家目录数据

    ```sh
    # 创建用户
    ansible 192.168.100.208 -m user -a 'name=nginx shell=/sbin/nologin system=yes home=/var/nginx groups=root uid=777 comment="test"'

    # remove：删除用户的时候，删除家目录数据
    ansible 192.168.100.208 -m user -a "name=nginx state=absent remove=yes"
    ```

- group模块

    - name"" 用户名
    - system="yes/no" 指定是否为 系统用户
    - home="" 指定用户额外的home目录, 默认/home/user .
    - gid="" 指定GID.
    - state="present/absent"
    - present: 创建用户组 (默认为present) absent: 删除用户组

    ```sh
    # 创建组
    ansible 192.168.100.208 -m group -a "name=testgroup system=yes"

    # 删除组
    ansible 192.168.100.208 -m group -a  "state=absent"
    ```

- yum模块
    - name：必须参数，用于指定需要管理的软件包名字
    - update_cache=yes: 更新 yum 缓存后安装
    - disable_gpg_check=yes: 禁用 gpg 检查
    - state：用于指定软件包的状态
        - present：安装软件包（默认值）
        - installed：安装软件包，与present等效
        - latest：安装yum中最新版本软件包
        - removed：删除对应软件包
        - absent：删除对应软件包，与removed等效
    - list:查看不同状态updates/installed/available/repos的包

    ```sh
    # 查看已安装的包
    ansible all -m yum -a 'list=installed'
    ansible all -m yum -a 'list=installed' | grep zsh

    # 查看已安装的包
    ansible all -m yum -a 'list=repos'

    # 安装 zsh
    ansible all -m yum -a "name=zsh update_cache=yes"

    # 卸载 zsh
    ansible all -m yum -a "name=zsh state=absent"

    # 安装指定路径
    ansible all -m yum -a 'name=/tmp/zsh-xx.x.x-x.x.x86_64.rpm'

    # 禁用 gpg 检查
    ansible all -m yum -a 'name=zsh update_cache=yes disable_gpg_check=yes'
    ```

- yum_repository模块：管理yum仓库
    - name：指定唯一的仓库ID
    - baseurl：指定yum仓库repodata目录的URL，可以是多个，如果设置为多个，需要使用"metalink"和"mirrorlist"参数
    - enabled：使用此yum仓库
    - gpgcheck：是否对软件包执行gpg签名检查
    - gpgkey：gpg秘钥的URL
    - mode：权限设置
    - state：状态，默认的present为安装此yum仓库，absent为删除此yum仓库
    - description：设置仓库的注释信息

- service模块：用于管理远程主机的服务，如：启动或停止服务
    - name：此参数用于指定需要操作的服务名称，如 httpd
    - enabled：此参数用于指定是否将服务设置为开机启动项，设置为yes或者no
    - state：此参数用于指定服务的状态
        started：此状态用于启动服务
        restarted：此状态用于重启服务
        stopped：此状态用于停止服务

    ```sh
    # 开启httpd服务
    ansible all -m service -a "name=httpd state=started "

    # 开启服务，并设置开机自启动
    ansible all -m service -a "name=httpd state=started enabled=yes"

    # 关闭httpd服务
    ansible all -m service -a "name=httpd state=stopped"
    ```

- cron模块：管理远程主机中的计划任务
    - day: 表示 天. 支持 ( 1-31, *, */2 ) 写法
    - hour: 表示 小时. 支持 ( 0-23, *, */2 ) 写法
    - minute: 表示 分钟. 支持 ( 0-59, *, */2 ) 写法
    - month: 表示 月. 支持 ( 1-12, *, */2 ) 写法
    - weekday: 表示 星期. 支持 ( 0-6, Sunday-Saturday, * )写法
    - job: 表示 计划任务的内容.
    - name: 表示 计划任务名称. 相同的计划任务名称会覆盖.

    ```sh
    ansible centos -m cron -a 'weekday=1-5 job="echo date >> /tmp/1.txt" name=echocron'

    # disabled= (true/false、yes/no)注释掉计划任务 关闭、启动计划任务 必须指定job和name.
    ansible centos -m cron -a 'disabled=true job="echo date >> /root/1.txt" name=echocron'

    # state=absent 删除计划任务。
    ansible centos -m cron -a 'name=echocron state=absent'
    ```

- get_url模块
    - sha256sum：下载完成后进行sha256检验
    - timeout：下载的超时时间
    - url：下载的url
    - use_proxy：使用代理
    - url_password：认证时使用的用户密码
    - url_username：认证时使用的用户名

    ```sh
    ansible 192.168.100.208 -m get_url -a "url=http://192.168.100.208/file dest=/tmp mode=0440"
    ```

## ansible-playbook

![image](./Pictures/ansible/ansible-playbook命令.avif)

- playbook是由一个或多个“play”组成的列表。而“play”就相当于执行的每条 ansible 命令，每条 ansible 命令组成起来成一个playbook，来实现复杂的任务
    - 可以理解为脚本，这个脚本包括 ansible 单条命令的集合

- playbook 采用 YAML 语言编写。以下是基本格式

    ```yml
    - hosts: centos # 指定主机标签
      remote_user: root  # 指定执行task的用户为root

      # 定义任务列表
      tasks:
        - name: hello
          command: echo 'hello world'
        - name: hostname
          command: hostname
        - name: create a newfile
          file: name=/root/test state=touch
        - name: create a user
          user: name=user1 shell=/sbin/nologin system=yes
    ```

```sh
# 可以先用 -C 参数先测试
ansible-playbook -C test.yml

# 发现没有报错，执行
ansible-playbook test.yml
```

### 变量

- 变量名规范：仅由字母，数字和下划线组成，并且只能以数字开头

- 变量来源：
    - 远程主机上的变量（可以直接调用）
    - 在主机列表中定义变量：普通变量和公共变量
    - 在playbook中定义并通过命令行赋值：`ansible-playbook -e varname=value`

- 调用变量：需要在变量名外面加上花括号，例：{{ varname }}

- 将常用的变量写进一个文件`vars.yml`

    ```yml
    var1: zsh
    var2: fish
    ```

    - test.yml
    ```yml
    - hosts: centos
      remote_user: root
      vars_files:
        - vars.yml

      # 使用yum安装zsh和fish
      tasks:
        - name: install zsh
          yum: name={{ var1 }}
        - name: install fish
          yum: name={{ var2 }}
    ```

    ```sh
    # 执行
    ansible-playbook test.yml
    ```

- 查看远程主机变量

    ```sh
    # 查看远程主机的相关的变量。返回json格式
    ansible centos -m setup

    # filter过滤变量
    ansible centos -m setup -a "filter=ansible_env"
    ansible centos -m setup -a "filter=ansible_all_ipv4_addresses"
    ansible centos -m setup -a "filter=ansible_memory_mb"
    ansible centos -m setup -a "filter=ansible_lvm"
    ```

- playbook中定义的变量
    ```yml
    - hosts: centos
      remote_user: root

      # 自定义变量
      vars:
        varname: zsh
        varname2: fish

      tasks:
        - name: install package
          yum: name={{ varname }}
        - name: install package
          yum: name={{ varname2 }}
    ```
    ```sh
    # 执行
    ansible-playbook test.yml
    ```

- 在命令行里通过 -e 参数 给变量赋值
    ```yml
    - hosts: centos
      remote_user: root

      tasks:
        - name: install package
          yum: name={{ varname }}
        - name: install package
          yum: name={{ varname2 }}
        - name: start service
          service: name={{ varname }} state=started
        - name: start service
          service: name={{ varname2 }} state=started
    ```

    ```sh
    # 在命令行里通过 -e 参数 给变量赋值
    anisble-palybook -e 'varname1=httpd varname2=ospfd' test.yml
    ```

- 普通变量和公共变量

    - 普通变量：主机组中的主机单独定义

        ```yml
        [centos]
        192.168.100.208 http_port=80
        ```

        ```yml
        - hosts: centos
          remote_user: root

          tasks:
            - name: test-var
              shell: echo {{ http_port }} > /tmp/test-var
        ```

    - 公共变量：也称组变量，针对主机组里面的主机统一定义

        ```yml
        [centos]
        192.168.100.208 http_port=80

        [all:vars]
        name=tz
        password=123456
        ```

        ```yml
        - hosts: centos
          remote_user: root

          tasks:
            - name: test-var
              shell: echo {{ http_port }} {{ name }} {{ password }} > /tmp/test-var
        ```

### fact

- `set_fact`：设置新的变量

    - 可以自定义变量通过template或者变量的方式在playbook中继承使用。
    - 例子：假设你需要获取一个进程使用的内存的使用率，必须通过`set_fact`来进行计算之后得出结果，并将其值在playbook中继承使用。

    ```yml
    - hosts: centos
      remote_user: root

      tasks:
        - name: Calculate InnoDB buffer pool size
          set_fact: innodb_buffer_pool_size_mb="{{ ansible_memtotal_mb / 2 |int }}"
        - debug: var=innodb_buffer_pool_size_mb

    ```

    ```sh
    # 执行
    ansible-playbook test.yml
    PLAY [centos] ********************************************************************************************

    TASK [Gathering Facts] ***********************************************************************************
    ok: [192.168.100.208]

    TASK [Calculate InnoDB buffer pool size] *****************************************************************
    ok: [192.168.100.208]

    TASK [debug] *********************************************************************************************
    ok: [192.168.100.208] => {
        "innodb_buffer_pool_size_mb": "1892.0"
    }

    PLAY RECAP ***********************************************************************************************
    192.168.100.208            : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```

- 手动采集 fact

    - 我们在运行playbook的时候，Ansible会先ssh连接被控端采集fact，如果被控制端的ssh还没有完成运行，就会导致整个playbook执行失败。解决这个问题，可以先在配置中关闭fact采集，然后在task中通过wait_for探测被控端ssh端口是否正常监听，然后在task中在手动setup模块来采集fact。

    ```yml
    - hosts: centos
      name: test demo
      gather_facts: False
      tasks:
        - name: wait for ssh to be running
          local_action: wait_for port=22 host="{{ inventory_hostname }}" search_regex=OpenSSH
        - name: gather facts
          setup:
    ```

- 关闭fact（提高执行效率）

    - 在配置中关闭fact，整个playbookfact变量将不会在显示，可以提高执行效率，但是有时候又需要使用 facts 中的信息，这时候可以按照上述设置 facts 的缓存，在空闲的时候收集 facts，缓存下来，在需要的时候直接读取缓存进行引用。

    - `/etc/ansible/ansible.cfg` 配置
    ```yml
    [defaults]
    gathering = explicit
    ```

- fact缓存：如果在playbook中需要继承fact，可启用fact缓存来提高效率。

    - fact支持缓存 json、memcached、redis

    - `/etc/ansible/ansible.cfg` 配置
    ```yml
    [defaults]
    gathering = smart
    # 缓存时间
    fact_caching_timeout = 86400
    fact_caching = {jsonfile/redis/memcached}
    # 指定ansible包含fact的json文件位置，如果目录不存在，会自动创建
    # local
    fact_caching_connection = /tmp/ansible_fact_cache
    # redis
    fact_caching_connection = 127.0.0.1:6379:admin
    # memcached
    fact_caching_connection = ['127.0.0.1:11211']
    ```

### template模板

- template是一种使用 jinjia2 语言格式作为文本文件模板

- 可以通过编写 template 来替换文件中的一些变量

- 对于nginx来说可以通过 template 模块来根据不同主机的CPU数量产生不同的worker进程数

- 创建一个名为template的目录（建议与 playbook 目录为同一层级）

- playbook文件

    ```yml
    - hosts: centos
      remote_user: root

      tasks:
        - name: install package
          yum: name=nginx
        - name: copy template
          template: src=~/ansible/templates/nginx.conf.j2  dest=/usr/local/nginx/conf/nginx.conf
          notify: restart service
        - name: start service
          service: name=nginx state=started enabled=yes
    ```

- 使用template模板。设置nginx配置，在不同远程主机的端口不同

    - 复制nginx.conf到templates目录名字为nginx.conf.j2

        ```sh
        cp /usr/local/nginx/conf/nginx.conf ~/ansible/templates/nginx.conf.j2
        ```

    - 修改nginx.conf.j2。设置端口变量
        ```
           server {
            listen       {{ http_port }} default_server;
        ```

    - 设置普通变量

        ```yml
        [centos]
        192.168.100.208 http_port=80
        192.168.101.208 http_port=8080
        ```

    - 如果只是设置一个变量。可以直接在命令行里通过 -e 参数 给变量赋值
        ```sh
        ansible-playbook centos -e "http_port=80" nginx.yml
        ```

- for 循环

    - `{% for 语句块 %} ... {% endfor %}`

    - playbook.yml文件

        ```yml
        - hosts: centos
          remote_user: root

          vars:
            # 列表
            listen_port:
              - 80
              - 81
              - 82

          tasks:
            - name: copy template conf
              template: src=~/ansible/templates/nginx-for.conf.j2 dest=/tmp/nginx.conf
        ```

    - nginx-for.conf.j2 文件

        ```
        {% for port in listen_port %}

        server {
           listen {{ port }}
        }

        {% endfor %}
        ```

    - 最后生成的文件`/tmp/nginx.conf`

        ```
        server {
           listen 80
        }


        server {
           listen 81
        }


        server {
           listen 82
        }
        ```

- 字典形式

    - playbook.yml文件

        ```yml
        - hosts: centos
          remote_user: root

          vars:
            # 字典的形式
            service:
              - name: web1
                domain: tz.com
                port: 9090
                user: nginx
                path: /var/www/html
              - name: web2
                domain: tz.com
                port: 9091
                user: nginx
                path: /var/www/html
              - name: web3
                domain: tz.com
                port: 9092
                user: nginx
                path: /var/www/html

          tasks:
            - name: copy template conf
              template: src=~/ansible/templates/nginx-字典.conf.j2 dest=/tmp/nginx.conf
        ```

    - nginx-字典.conf.j2 文件

        ```
        {% for s in service %}
        user {{ s.user }};
        worker_processes {{ ansible_processor_vcpus * 2 }};
        pid /run/nginx.pid;
            server {
                listen       {{ s.port }} default_server;
                listen       [::]:{{ s.port }} default_server;
                server_name  {{ s.name }}.{{ s.domain }};
                root         {{ s.path }};
            }

        {% endfor %}
        ```

    - 最后生成的文件`/tmp/nginx.conf`

        ```
        user nginx;
        worker_processes 8;
        pid /run/nginx.pid;
            server {
                listen       9090 default_server;
                listen       [::]:9090 default_server;
                server_name  web1.tz.com;
                root         /var/www/html;
            }

        user nginx;
        worker_processes 8;
        pid /run/nginx.pid;
            server {
                listen       9091 default_server;
                listen       [::]:9091 default_server;
                server_name  web2.tz.com;
                root         /var/www/html;
            }

        user nginx;
        worker_processes 8;
        pid /run/nginx.pid;
            server {
                listen       9092 default_server;
                listen       [::]:9092 default_server;
                server_name  web3.tz.com;
                root         /var/www/html;
            }
        ```

- if 流程控制

    - `{% if 语句块 %} ... {% else %} ... {% endif %}`

    - playbook.yml文件
        ```
        - hosts: centos
          remote_user: root

          vars:
            # 字典的形式
            service:
              - name: web1
                domain: tz.com
                port: 9090
                user: nginx
                path: /var/www/html
              - name: web2
                domain: tz.com
                port: 9091
                user: nginx
                path: /var/www/html
              - name: web3
                domain: tz.com
                port: 9092
                user: nginx
                path: /var/www/html

          tasks:
            - name: copy template conf
              template: src=~/ansible/templates/nginx-if.conf.j2 dest=/tmp/nginx.conf
        ```

    - nginx-if.conf.j2文件：

        - `{% if s.user is defined %}` 判断 是否有 s.user 这个变量

        ```
        {% for s in service %}

        {% if s.user is defined %}
        user {{ s.user }};
        {% else %}
        user root;
        {% endif %}
        worker_processes {{ ansible_processor_vcpus * 2 }};
        pid /run/nginx.pid;
            server {
                listen       {{ s.port }} default_server;
                server_name  {{ s.name }}.{{ s.domain }};
                root         {{ s.path }};
            }

        {% endfor %}
        ```

### handlers和notify 触发器

- handlers：在task列表中，只有当关注的资源发生变化时，才会采取相应的操作

- notify：与handlers配套使用。调用handlers中的定义的操作；用于每个play的最后被触发，这样就可以避免多次发生改变时每次都会执行notify的操作。仅在所有的变化发生完成后一次性地执行指定操作

- 通过触发器来实现一旦发现配置文件有修改就重启服务的操作

- 需求：在远程主机上安装nginx服务，并将ansible主机上的配置文件复制过去，当被控机收到传送过来的配置文件后就重启服务使得配置文件生效

    ```yml
    - hosts: centos
      remote_user: root

      tasks:
        - name: install nginx package
          yum: name=nginx
        - name: copy config file
          template: src=/usr/local/nginx/conf/nginx.conf  dest=/usr/local/nginx/conf/ backup=yes
          notify: restart service
        - name: start service
          service: name=nginx state=started enabled=yes

      handlers:
        - name: restart service
          service: name=nginx state=restarted
    ```

    - backup=yes会自动根据时间，备份要替换的文件`nginx.conf.12187.2024-01-28@21:23:48~`

- 多个触发器

  ```yml
    - hosts: centos
      remote_user: root

      tasks:
        - name: install nginx package
          yum: name=nginx
        - name: copy config file
          template: src=/usr/local/nginx/conf/nginx.conf  dest=/usr/local/nginx/conf/ backup=yes
          notify: restart service
        - name: start service
          service: name=nginx state=started enabled=yes
          notify:
            - restart nginx
            - check nginx process

      handlers:
        - name: restart service
          service: name=nginx state=restarted
        - name: check nginx process
          shell: killall -0 nginx > /tmp/nginx.log
    ```

### tags标签

- 使用 tag 标签执行，无需按照从上到下的顺序依次执行

    ```yml
    - hosts: centos
      remote_user: root

      tasks:
        - name: install nginx package
          yum: name=nginx
        - name: copy config file
          template: src=/usr/local/nginx/conf/nginx.conf  dest=/usr/local/nginx/conf/ backup=yes
          notify: restart service
        - name: start service
          service: name=nginx state=started enabled=yes
          tags: nginx-service
    ```

    ```sh
    # -t执行指定tag
    ansible-palybook -t nginx-service tags.yml
    ```

- 多个动作也可以使用同一标签

    ```yml
    - hosts: centos
      remote_user: root

      tasks:
        - name: install nginx package
          yum: name=nginx
          tags: nginx-service
        - name: copy config file
          template: src=/usr/local/nginx/conf/nginx.conf  dest=/usr/local/nginx/conf/ backup=yes
          notify: restart service
        - name: start service
          service: name=nginx state=started enabled=yes
          tags: nginx-service
    ```

### 逻辑实现：when、迭代

- `when`：根据某一判断条件（变量、执行结果等）来实现逻辑

    ```sh
    # 查看ansible_os_family变量
    ansible centos -m setup -a "filter=ansible_os_family"
    ```

    - ansible_os_family变量是RedHat才执行
    ```yml
    - hosts: centos
      remote_user: root
      tasks:
        - name: test-when
          shell: echo when-test > /tmp/test-when
          when: ansible_os_family == "RedHat"
    ```

- 迭代

    - 1.当有需要重复性执行的任务时,可以使用迭代机制
    - 2.对迭代项的引用,固定变量名为`{{ item }}`
    - 3.要在task中使用`with_items`给定要迭代的元素列表

    - 创建多个文件
        ```yml
        - hosts: centos
          remote_user: root

          tasks:
            - name: create some files
              file: name=/tmp/{{ item }} state=touch
              with_items:
                - file1
                - file2
                - file3
        ```

    - 安装多个包
        ```yml
        - hosts: centos
          remote_user: root

          tasks:
            - name: install package
              yum: name={{ item }}
              with_items:
                - zsh
                - fish
        ```

- 迭代+when

    ```yml
    - hosts: centos
      remote_user: root

      tasks:
        - name: create some files
          file: name=/tmp/{{ item }} state=touch
          when：ansible_distribution_major_version == '7'
          with_items:
            - file1
            - file2
            - file3
    ```

- 迭代嵌套

    ```yml
    - hosts: centos
      remote_user: root

      tasks:
        - name: create some group
          group: name={{ item }}
          with_items:
            - g1
            - g2
            - g3
        - name: create some user
          user: name={{ item.name }} group={{ item.group }}
          with_items:
            - {name: "user1" , group:  "g1"}
            - {name: "user2" , group:  "g2"}
            - {name: "user3" , group:  "g3"}
    ```

### roles（角色）

- roles（角色）：Ansible自1.2版本引入的新特性，用于层次性、结构化地组织playbook。

    - 在写一键部署的时候，都不可能把所有的步骤全部写入到一个playbook文件当中，我们要把不同的功能模块拆分开来，做到SOA（松耦合架构），即解耦。而roles的目录结构层次更加清晰

    - Roles 能够根据层次结构自动加载- 变量文件、tasks、handler、template 文件等
        - 简单来讲就是将 这些文件归类到各自单独的文件目录中, 使 playbook 文件可以更好的通过 include 这些文件目录。


- Roles 默认的目录为`/etc/ansible/roles`。可以通过`/etc/ansible/ansible.cfg`文件中的`roles_path`参数进行修改

- roles目录结构

    ```sh
    # 创建roles。这里为nginx
    cd /etc/ansible/roles/
    ansible-galaxy init nginx

    # 查看roles目录
    tree nginx/
    nginx/           # 项目名称
    ├── defaults     # 默认变量，优先级极低
    │   └── main.yml
    ├── files        # 用于存放由copy 或script 模块调用的文件
    ├── handlers     # 触发器文件目录
    │   └── main.yml # 定义此角色中触发条件时执行的动作
    ├── meta         # 依赖关系文件目录
    │   └── main.yml
    ├── README.md
    ├── tasks         # 工作任务文件目录。
    │   └── main.yml  # tasks的入口文件，可以使用include包含其它的位于此目录的 task 文件
    ├── templates     # 自动在此目录中寻找 Jinja2 模板文件
    ├── tests         # 测试文件目录
    │   ├── inventory
    │   └── test.yml
    └── vars         # 变量文件目录
      └── main.yml
    ```

- roles中的依赖关系：以下为`meta/main.yml`

    ```yml
    dependencies:
     - {role: nginx}
     - {role: php}
     - {role: nfs-client}
    ```

- 实验

    - 创建一个nginx roles

        ```sh
        cd /etc/ansible/roles/
        ansible-galaxy init nginx
        ```

    - `/etc/ansible/nginx-roles.yml` 与 roles存放位置在同一目录。

        ```yml
        - hosts: centos
          remote_user: root
          roles:
            # 调用定义好的role，存放在roles目录中。
            - role: nginx
        ```

    - `/etc/ansible/roles/nginx/tasks/main.yml`： 入口文件。配置 task 执行顺序。
        - `include`命令已经抛弃了，缺而代之的时`include_tasks`

        ```yml
        - include_tasks: group.yml
        - include_tasks: user.yml
        - include_tasks: yum.yml
        - include_tasks: template.yml
        - include_tasks: start.yml
        ```

    - `/etc/ansible/roles/nginx/tasks/group.yml`： 入口文件。配置 task 执行顺序。
        ```yml
        - name: create group
          group: name=nginx gid=80
        ```

    - 执行
        ```sh
        ansible-playbook nginx_roles.yml
        ```

- roles tags 标签

    ```yml
    - hosts: all
      remote_user: root

      # 选择 roles 属性
      roles:
        # 配置相应的 tags 用 { } 引用
        - { role: nginx, tags: ['web', 'nginx'] }
        - { role: mysql, tags: ['db', 'mysql'] }
        - { role: redis, tags: ['db', 'redis'] }
        - { role: golang, tags: ['web', 'golang'] }
        - { role: vue, tags: ['web', 'vue'] }
        - { role: app_demo, tags: "app_demo" }
    ```

    ```sh
    # 执行web标签
    ansible-playbook -t web playbook.yml
    ```

- roles when 语句：对 role 进行条件的判断.

    ```yml
    - hosts: all
      remote_user: root

      roles:
        ## 基础优化
        - {role: base}

        ## 自建yum仓库
        - {role: yum_repo,when: ansible_hostname == 'm01'}

        ## 部署rsync
        - {role: rsync-server,when: ansible_hostname == 'backup'}

        ## 部署MySQL主从复制
        - {role: mysql-master,when: replication_role == 'master'}
        - {role: mysql-slave,when: replication_role == 'slave'}

        ## 部署wordpress
        - {role: wp-user-data,when: ansible_hostname == 'nfs'}
        - {role: sersync,when: ansible_hostname == 'nfs'}
        - {role: wp-web, when: ansible_hostname is match 'web*'}
        - {role: wp-db,when: ansible_hostname is match 'db*'}
        - {role: wp-lb,when: ansible_hostname is match 'lb*'}

        ## 防火墙相关操作 放在最后执行
        - {role: network-server,when: ansible_hostname == 'm01'}
        - {role: network-client,when: ansible_hostname != 'm01' and ansible_hostname is not match 'lb*'}
        - {role: firewalld-port}
    ```

- `--extra-vars` 执行 playboook 的时候以参数方式传入变量。

    ```sh
    # 以变量方式传参
    ansible-playbook deploy.yml --extra-vars "hosts=k3s-cluster user=ubuntu"

    # 以json格式传参
    ansible-playbook deploy.yml --extra-vars "{'app_name':'nginx', 'pkg_name':'vsftpd'}"

    # 以json文件方式传参
    ansible-playbook deploy.yml --extra-vars "@test_vars.json"
    ```

## ansible-galaxy

- [官方网站](https://galaxy.ansible.com/ui/)
    - [搜索roles](https://galaxy.ansible.com/ui/standalone/roles/)

- 创建目录
    ```sh
    mkdir ~/.ansible/roles
    mkdir /usr/share/ansible/roles
    mkdir /etc/ansible/roles
    ```

- ansible-galaxy下载安装roles
```sh
# 查找roles。这里为查找所有nginx相关的roles
ansible-galaxy role search geerlingguy.nginx

# 查看详细信息
ansible-galaxy info geerlingguy.nginx

# 安装roles。会从github上下载，网速可能会很慢，导致安装失败
ansible-galaxy role install geerlingguy.nginx
# 删除roles
ansible-galaxy remove geerlingguy.nginx
# list查看本地的roles
ansible-galaxy list geerlingguy.nginx

# 从github导入roles
ansible-galaxy role import <github_user> <github_repo>
ansible-galaxy role import geerlingguy ansible-role-mysql
# 删除从github导入roles
ansible-galaxy role delete <github_user> <github_repo>

# 安装Collections
ansible-galaxy collection install community.general
```

- [ansible-for-devops](https://github.com/geerlingguy/ansible-for-devops)
- [ansible-role-mysql](https://github.com/geerlingguy/ansible-role-mysql)

### ansible-vault：加密yml文件

| 参数    | 说明                           |
|---------|--------------------------------|
| encrypt | AES256 加密 ( 会提示输入密码 ) |
| view    | 加密的情况下 查看 原来的内容   |
| edit    | 编辑加密的 playbook 文件       |
| decrypt | 解密                           |
| rekey   | 修改加密密码                   |

```sh
# 加密test.yml文件
ansible-vault encrypt test.yml
```

# 第三方软件

- [semaphore：ansible ui](https://github.com/ansible-semaphore/semaphore)

# reference

- [ansible-examples](https://github.com/ansible/ansible-examples)

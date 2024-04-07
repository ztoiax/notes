<!-- vim-markdown-toc GFM -->

* [Kubernetes 是希腊语中的船长(captain)](#kubernetes-是希腊语中的船长captain)
    * [service](#service)
        * [普通Service类型例子（??失败了）](#普通service类型例子失败了)
        * [Headless Service类型例子（??失败了）](#headless-service类型例子失败了)
    * [Secret](#secret)
    * [网络策略](#网络策略)
        * [使用minikube实施网络策略（??失败了，以下所有应用的策略，最后可以通信）](#使用minikube实施网络策略失败了以下所有应用的策略最后可以通信)
            * [在命名空间中限制流量](#在命名空间中限制流量)
            * [允许特定 Pod 的流量](#允许特定-pod-的流量)
            * [在单个策略中组合入站和出站规则](#在单个策略中组合入站和出站规则)
            * [阻止对特定 IP 范围的出站流量](#阻止对特定-ip-范围的出站流量)
    * [minikube：单机运行Kubernetes集群](#minikube单机运行kubernetes集群)
        * [插件](#插件)
        * [nginx](#nginx)
        * [Prometheus](#prometheus)
            * [服务发现](#服务发现)
            * [对Kubernetes集群以及其中部署的各类资源的自动化监控](#对kubernetes集群以及其中部署的各类资源的自动化监控)
        * [Prometheus Operator（简化在Kubernetes下部署和管理Prmetheus的复杂度）（??失败了）](#prometheus-operator简化在kubernetes下部署和管理prmetheus的复杂度失败了)
    * [helm：包管理器](#helm包管理器)
        * [基本命令](#基本命令)
        * [插件](#插件-1)
    * [Timoni：Helm 的可能替代方案](#timonihelm-的可能替代方案)
    * [Nacos](#nacos)
    * [云原生CI/CD](#云原生cicd)
        * [Tekton](#tekton)
        * [Argo Workflow](#argo-workflow)
    * [GitOps](#gitops)
            * [ArgoCD](#argocd)
                * [部署ArgoCD](#部署argocd)
            * [flux](#flux)
            * [案例](#案例)
                * [网易云音乐大量应用的部署流程](#网易云音乐大量应用的部署流程)
* [第三方软件资源](#第三方软件资源)
    * [服务端](#服务端)
    * [客户端](#客户端)
    * [云原生](#云原生)
* [在线网站工具](#在线网站工具)
* [优秀文章](#优秀文章)

<!-- vim-markdown-toc -->

# Kubernetes 是希腊语中的船长(captain)

- Kubernetes 是希腊语中的船长(captain)

- Kubenetes是一款由Google开发的开源的容器编排工具，在Google已经使用超过15年（Kubernetest前身是Google的内部工具Borg）。

- 在Kubernetes中运行着的容器则可以视为是这个操作系统中运行的“进程”，通过Kubernetes这一中央协调器，解决了基于容器应用程序的调度、伸缩、访问负载均衡以及整个系统的管理和监控的问题。

    ![image](./Pictures/kubernetes/Kubernetes的应用管理模型.avif)

    - Pod是Kubernetes中的最小调度资源：Pod中会包含一组容器，它们一起工作，并且对外提供一个（或者一组）功能。对于这组容器而言它们共享相同的网络和存储资源，因此它们之间可以直接通过本地网络（127.0.0.1）进行访问。

        - 当Pod被创建时，调度器（kube-schedule）会从集群中找到满足条件的节点运行它。

    - Controller（控制器）：用户可以在Controller定义Pod的调度规则、运行的副本数量以及升级策略等等信息，当某些Pod发生故障之后，Controller会尝试自动修复，直到Pod的运行状态满足Controller中定义的预期状态为止。

        - Kubernetes中提供了多种Controller的实现，包括：Deployment（无状态应用）、StatefulSet（有状态应用）、Daemonset（守护模式）等，以支持不同类型应用的部署和调度模式。

    - Service（服务）：解决集群内的应用通信。

        - Service在Kubernetes集群内扮演了服务发现和负载均衡的作用。在Kubernetes下部署的Pod实例都会包含一组描述自身信息的Label，而创建Service，可以声明一个Selector（标签选择器）。Service通过Selector，找到匹配标签规则的Pod实例，并将对Service的请求转发到代理的Pod中。Service创建完成后，集群内的应用就可以通过使用Service的名称作为DNS域名进行相互访问。

    - Ingress（入口）：解决外部的用户访问部署在集群内的应用

        - Ingress是一个工作在7层的负载均衡器，其负责代理外部进入集群内的请求，并将流量转发到对应的服务中。

    - Namespace（命名空间）：对资源进行隔离

        - 对于同一个Kubernetes集群其可能被多个组织使用，Namespace可以隔离这些不同组织创建的应用程序

- Kubernetes架构

    ![image](./Pictures/kubernetes/Kubernetes架构.avif)

    - Kubernetes的核心组件主要由两部分组成：Master组件和Node组件

    - Matser组件提供了集群层面的管理功能，它们负责响应用户请求并且对集群资源进行统一的调度和管理。

        - kube-apiserver：扮演了整个Kubernetes集群管理的入口的角色，负责对外暴露Kubernetes API。
            - 一般是独立部署在集群外的，为了能够让部署在集群内的应用（kubernetes插件或者用户应用）能够与kube-apiserver交互，Kubernetes会默认在命名空间下创建一个名为kubernetes的服务
                ```sh
                kubectl get svc kubernetes -o wide
                NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE   SELECTOR
                kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   24h   <none>
                ```

        - etcd：用于存储Kubernetes集群的所有数据；
        - kube-scheduler: 负责为新创建的Pod选择可供其运行的节点；
        - kube-controller-manager： 包含Node Controller，Deployment Controller，Endpoint Controller等等，通过与apiserver交互使相应的资源达到预期状态。

    - Node组件会运行在集群的所有节点上，它们负责管理和维护节点中运行的Pod，为Kubernetes集群提供运行时环境。

        - kubelet：负责维护和管理节点上Pod的运行状态；
        - kube-proxy：负责维护主机上的网络规则以及转发。
        - Container Runtime：如Docker,rkt,runc等提供容器运行时环境。

- Kubernetes监控策略

    - 无论是外部的客户端还是集群内部的组件都直接与kube-apiserver进行通讯。因此，kube-apiserver的并发和吞吐量直接决定了集群性能的好坏。

    - 对于外部用户而言，Kubernetes是否能够快速的完成pod的调度以及启动，是影响其使用体验的关键因素。kube-scheduler负责完成

    - kubelet完成pod的创建和启动工作

    - 主要关注在Kubernetes的API响应时间，以及Pod的启动时间等指标上。

    - 白盒监控层面：

        - 基础设施层（Node）：为整个集群和应用提供运行时资源，需要通过各节点的kubelet获取节点的基本状态，同时通过在节点上部署Node Exporter获取节点的资源使用情况；

        - 容器基础设施（Container）：为应用提供运行时环境，Kubelet内置了对cAdvisor的支持，用户可以直接通过Kubelet组件获取给节点上容器相关监控指标；

        - 用户应用（Pod）：Pod中会包含一组容器，它们一起工作，并且对外提供一个（或者一组）功能。如果用户部署的应用程序内置了对Prometheus的支持，那么我们还应该采集这些Pod暴露的监控指标；

        - Kubernetes组件：获取并监控Kubernetes核心组件的运行状态，确保平台自身的稳定运行。

    - 黑盒监控层面：

        - 内部服务负载均衡（Service）：在集群内，通过Service在集群暴露应用功能，集群内应用和应用之间访问时提供内部的负载均衡。通过Blackbox Exporter探测Service的可用性，确保当Service不可用时能够快速得到告警通知；

        - 外部访问入口（Ingress）：通过Ingress提供集群外的访问入口，从而可以使外部客户端能够访问到部署在Kubernetes集群内的服务。因此也需要通过Blackbox Exporter对Ingress的可用性进行探测，确保外部用户能够正常访问集群内的功能；

- Service负载均衡

    ![image](./Pictures/kubernetes/Service负载均衡.avif)

    - 代理对集群内部应用Pod实例的请求：

        - 当创建Service时如果指定了标签选择器：Kubernetes会监听集群中所有的Pod变化情况，通过Endpoints自动维护满足标签选择器的Pod实例的访问信息；

    - 代理对集群外部服务的请求：
        - 当创建Service时如果不指定任何的标签选择器：此时需要用户手动创建Service对应的Endpoint资源。
        - 例如，一般来说，为了确保数据的安全，我们通常讲数据库服务部署到集群外。 这是为了避免集群内的应用硬编码数据库的访问信息，这是就可以通过在集群内创建Service，并指向外部的数据库服务实例。


    - 通过这种方式集群内的应用或者系统主机就可以通过集群内部的DNS域名kubernetes.default.svc访问到部署外部的kube-apiserver实例。

        - 如果我们想要监控kube-apiserver相关的指标，只需要通过endpoints资源找到kubernetes对应的所有后端地址即可。

    ```sh
    # kubernetes服务代理的后端实际地址通过endpoints进行维护
    kubectl get endpoints kubernetes
    NAME         ENDPOINTS           AGE
    kubernetes   192.168.49.2:8443   24h
    ```

## service

```yml
kind: Service  # 资源类型
apiVersion: v1  # 资源版本
metadata: # 元数据
  name: service # 资源名称
  namespace: dev # 命名空间
spec: # 描述
  selector: # 标签选择器，用于确定当前service代理哪些pod
    app: nginx
  type: # Service类型，指定service的访问方式
  clusterIP:  # 虚拟服务的ip地址
  sessionAffinity: # session亲和性，支持ClientIP、None两个选项
  ports: # 端口信息
    - protocol: TCP
      port: 3017  # service端口
      targetPort: 5003 # pod端口
      nodePort: 31122 # 主机端口
```

| 字段         | 说明                                                                                                                      |
|--------------|---------------------------------------------------------------------------------------------------------------------------|
| ClusterIP    | 默认值，它是Kubernetes系统自动分配的虚拟IP，只能在集群内部访问                                                            |
| NodePort     | 将Service通过指定的Node上的端口暴露给外部，通过此方法就可以在集群外部访问服务。(在每个Node上分配一个端口作为外部访问入口) |
| LoadBalancer | 工作在特定的Cloud Provider上，例如Google Cloud、AWS、OpenStack                                                            |
| ExternalName | 集群外部的服务引入集群内部直接使用                                                                                        |

- ClusterIP是Kubernetes默认的服务类型。

    - 当您创建一个Service资源对象而没有指定服务类型时，默认会被设置为ClusterIP类型。这种类型的服务仅在Kubernetes内部可见，并通过ClusterIP暴露应用程序。

    - ClusterIP只能通过内部DNS进行访问，因此它合适处理内部流量。

    - ClusterIP根据是否生成ClusterIP又可分成为普通Service和Headless Service。

- Service两类：

    - 普通Service：为Kubernetes的Service分配一个集群内部可访问的固定虚拟IP（Cluster IP），实现集群内的访问。

    - Headless Service：该服务不会分配ClusterIP，也不通过Kube-Proxy做反向代理和负载均衡。而是通过DNS提供稳定的网络ID来访问，DNS会将Headless Service的后端直接解析为Pod IP列表。

### 普通Service类型例子（??失败了）

- 创建文件`01_create_deployment_app_nginx.yml`
    ```yml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-server1
    spec:
      replicas: 2 # 2个nginx
      selector:
        matchLabels:
          app: nginx
      template:
         metadata:
           labels:
             app: nginx
         spec:
           containers:
           - name: c1
             image: nginx:1.15-alpine
             imagePullPolicy: IfNotPresent
             ports:
             - containerPort: 80
    ```

    ```sh
    # 启动
    kubectl apply -f 01_create_deployment_app_nginx.yml

    # 查看启动情况
    kubectl get deployment.apps
    ```

- 命令创建service：

    ```sh
    kubectl expose deployment.apps nginx-server1 --type=ClusterIP --target-port=80 --port=80
    ```

- 文件创建service：`02_create_deployment_app_nginx_with_service.yml`
    ```yml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-server1
    spec:
      replicas: 2
      selector:
        matchLabels:
          app: nginx
      template:
         metadata:
           labels:
             app: nginx
         spec:
           containers:
           - name: nginx-smart
             image: nginx:1.15-alpine
             imagePullPolicy: IfNotPresent
             ports:
             - containerPort: 80
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx-svc
    spec:
      type: ClusterIP
      ports:
      - protocol: TCP
        port: 80
        targetPort: 80
      selector:
        app: nginx
    ```

    ```sh
    # 启动
    kubectl apply -f 02_create_deployment_app_nginx_with_service.yml
    ```

- 验证
    ```sh
    kubectl get service
    NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
    kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP    4d15h
    nginx-svc    ClusterIP   10.101.153.50   <none>        80/TCP    3s

    kubectl get endpoints
    kubectl get pods -l app=nginx

    # ??失败了
    curl 10.101.153.50
    ```


### Headless Service类型例子（??失败了）

- Headless Service类型配置解释

    ```yml
    apiVersion: v1
    kind: Service
    metadata:
      name: headless-service
    spec:
      clusterIP: None
      selector:
        app: my-app
      ports:
        - name: http
          protocol: TCP
          port: 80
          targetPort: 9376
    ```

    - `clusterIP:None`明确指定了创建Headless Service。
    - `selector` 字段定义了应该选择哪些 Pod 来提供服务，(pod文件此处没有举例)。
    - `ports` 则定义了 Service 所使用的端口和目标端口。

    ```sh
    # dig 命令查询了 Service 的 DNS 记录，它将返回所有 Pod 的 IP 地址列表。
    dig(curl) headless-service.default.svc.cluster.local
    ```

- 创建文件：`03_create_deployment_app_nginx.yml`

    ```yml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-server1
    spec:
      replicas: 2
      selector:
        matchLabels:
          app: nginx
      template:
         metadata:
           labels:
             app: nginx
         spec:
           containers:
           - name: nginx-smart
             image: nginx:1.15-alpine
             imagePullPolicy: IfNotPresent
             ports:
             - containerPort: 80
    ```

    ```sh
    # 启动
    kubectl create -f 03_create_deployment_app_nginx.yml
    ```

- 创建文件`04_headless-service.yml`

    ```yml
    apiVersion: v1
    kind: Service
    metadata:
      name: headless-service
      namespace: default
    spec:
      type: ClusterIP     # ClusterIP类型,也是默认类型
      clusterIP: None     # None就代表是无头service
      ports:                                # 指定service 端口及容器端口
      - port: 80                            # service ip中的端口
        protocol: TCP
        targetPort: 80                      # pod中的端口
      selector:                             # 指定后端pod标签
         app: nginx                    # 可通过kubectl get pod -l app=nginx查看哪些pod在使用此标签
    ```

    ```sh
    # 启动
    kubectl apply -f 04_headless-service.yml

    # 查看。可以看到headless-service没有CLUSTER-IP,用None表示
    kubectl get svc
    ```

- dns
    ```sh
    # 查看kube-dns服务的IP
    kubectl get svc -n kube-system
    NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                        AGE
    kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP         3d22h
    kubelet    ClusterIP   None         <none>        10250/TCP,10255/TCP,4194/TCP   2d5h

    # 在集群主机通过DNS服务地址查找无头服务的dns解析
    dig -t A headless-service.default.svc.cluster.local. @10.96.0.10

    # 验证pod的IP
    kubectl get pod -o wide
    ```

- 创建一个镜像为busyboxplus:curl的pod，pod名称为bb2,用来解析域名
    ```sh
    # ??失败了
    kubectl run bbp --image=busybox:curl -it
    # 或
    kubectl run bbp --image=1.28 -it

    # 解析域名
    nslookup headless-service.default.svc.cluster.local.

    # 测试
    curl http://headless-service.default.svc.cluster.local.
    ```

## Secret

- Secret：是一种包含少量敏感信息例如密码、令牌或密钥的对象。
    - 保存的信息可以在Pod的Spec或者镜像中使用，且Secret的生命周期独立于使用它们的Pod。
    - 默认情况下，Kubernetes Secret 未加密地存储在 API 服务器的底层数据存储（etcd）中。任何拥有 API 访问权限的人都可以检索或修改 Secret，任何有权访问 etcd 的人也可以。

- 在Secret中存储内容时，可以设置成`data`或者`stringData`字段
    - data：中所有键值都必须是 base64 编码的字符串
    - stringData：则可以使用任何字符串。
    - 同时出现在 data 和 stringData 字段中，stringData 所指定的键值具有高优先级。

- secret有三种使用方式：

    - 1.以文件的形式挂载到pod中

        - 将secret直接挂载进pod中
            ```yml
            apiVersion: v1
            kind: Pod
            metadata:
              name: mypod
            spec:
              containers:
              - name: mypod
                image: redis
                volumeMounts:
                - name: foo
                  mountPath: "/etc/foo"
                  readOnly: true
              volumes:
              - name: foo
                secret:
                  secretName: mysecret
                  optional: false # 默认设置，意味着 "mysecret" 必须已经存在
            ```

            - 将secret的键投射到特定的目录中mysecret 中的键 username 会出现在容器中的路径为 /etc/foo/my-group/my-username， 而不是 /etc/foo/username。Secret 对象的 password 键不会被投射。
                ```yml
                apiVersion: v1
                kind: Pod
                metadata:
                  name: mypod
                spec:
                  containers:
                  - name: mypod
                    image: redis
                    volumeMounts:
                    - name: foo
                      mountPath: "/etc/foo"
                      readOnly: true
                  volumes:
                  - name: foo
                    secret:
                      secretName: mysecret
                      items:
                      - key: username
                        path: my-group/my-username
                ```

    - 2.作为容器的环境变量

        - Secret 主键的环境变量应该在 env[].valueFrom.secretKeyRef 中填写 Secret 的名称和主键名称。
            ```yml
            apiVersion: v1
            kind: Pod
            metadata:
              name: secret-env-pod
            spec:
              containers:
              - name: mycontainer
                image: redis
                env:
                  - name: SECRET_USERNAME
                    valueFrom:
                      secretKeyRef:
                        name: mysecret
                        key: username
                        optional: false # 此值为默认值；意味着 "mysecret"
                                        # 必须存在且包含名为 "username" 的主键
                  - name: SECRET_PASSWORD
                    valueFrom:
                      secretKeyRef:
                        name: mysecret
                        key: password
                        optional: false # 此值为默认值；意味着 "mysecret"
                                        # 必须存在且包含名为 "password" 的主键
              restartPolicy: Never
            ```
    - 由 kubelet 在为 Pod 拉取镜像时使用。

        - Docker配置Secret
            ```yml
            apiVersion: v1
            kind: Secret
            metadata:
              name: secret-dockercfg
            type: kubernetes.io/dockercfg
            data:
              .dockercfg: |
                    "<base64 encoded ~/.dockercfg file>"
            ```

        - basic-auth认证secret
            ```yml
            apiVersion: v1
            kind: Secret
            metadata:
              name: secret-basic-auth
            type: kubernetes.io/basic-auth
            stringData:
              username: admin      # kubernetes.io/basic-auth 类型的必需字段
              password: t0p-Secret # kubernetes.io/basic-auth 类型的必需字段
            ```

        - ssh身份认证secret
            ```yml
            apiVersion: v1
            kind: Secret
            metadata:
              name: secret-ssh-auth
            type: kubernetes.io/ssh-auth
            data:
              # 此例中的实际数据被截断
              ssh-privatekey: |
                      MIIEpQIBAAKCAQEAulqb/Y ...
            ```

        - tls证书密钥secret
            ```yml
            apiVersion: v1
            kind: Secret
            metadata:
              name: secret-tls
            type: kubernetes.io/tls
            data:
              # 此例中的数据被截断
              tls.crt: |
                    MIIC2DCCAcCgAwIBAgIBATANBgkqh ...
              tls.key: |
                    MIIEpgIBAAKCAQEA7yn3bRHQ5FHMQ ...
            ```

## 网络策略

- [官网](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

- [Kubernetes 网络策略入门：概念、示例和最佳实践](https://lib.jimmysong.io/blog/understanding-kubernetes-network-policies/#%E7%A4%BA%E4%BE%8B-4%E9%98%BB%E6%AD%A2%E5%AF%B9%E7%89%B9%E5%AE%9A-ip-%E8%8C%83%E5%9B%B4%E7%9A%84%E5%87%BA%E7%AB%99%E6%B5%81%E9%87%8F)

- 问题：同一命名空间中的任何 Pod 都可以使用其 IP 地址相互通信，无论它属于哪个部署或服务。虽然这种默认行为适用于小规模应用，但在规模扩大和复杂度增加的情况下，Pod 之间的无限通信可能会增加攻击面并导致安全漏洞。

- 网络策略可以改善以下方面

    - 安全性：使用 Kubernetes 网络策略，你可以指定允许哪些 Pod 或服务相互通信，以及应该阻止哪些流量访问特定的资源。这样可以更容易地防止未经授权的访问敏感数据或服务。

    - 合规性：在医疗保健或金融服务等行业，合规性要求不可妥协。通过确保流量仅在特定的工作负载之间流动，以满足合规要求。

    - 故障排除：通过提供关于应该相互通信的 Pod 和服务的可见性，可以更轻松地解决网络问题，特别是在大型集群中。策略还可以帮助你确定网络问题的源，从而加快解决速度。

- 网络策略类型：入口和出口

    - 入口策略允许你控制流入 Pod 的流量：指定在 `NetworkPolicy` 资源的 `ingress` 字段中。你可以定义流量的来源，可以是 Pod、命名空间或 IP 块，以及允许访问流量的目标端口或端口。

    - 出口策略允许你控制从 Pod 流出的流量：指定流量的目标，可以是 Pod、命名空间或 IP 块，以及允许访问流量的目标端口或端口。

    - Pod 选择器： 这些选择要应用策略的 Pod。为选择器指定标签，与选择器匹配的 Pod 将受到策略中指定的规则的约束。

    - 命名空间选择器： 类似于 Pod 选择器，这些允许你选择要应用策略的命名空间。

    - IP 地址块选择器： IP 地址块选择器指定要允许或拒绝流量的 IP 地址范围。你可以使用CIDR 表示法来指定 IP 地址范围。


### 使用minikube实施网络策略（??失败了，以下所有应用的策略，最后可以通信）

```sh
# minikube 默认不支持网络策略，因此请使用类似Calico或Weave Net的网络插件启动 minikube
minikube start --network-plugin=cni --cni=calico

# 创建命名空间
kubectl create namespace network-policy-tutorial

# 创建三个示例 Pod（Backend、Database 和 Frontend）
kubectl run backend --image=nginx --namespace=network-policy-tutorial
kubectl run database --image=nginx --namespace=network-policy-tutorial
kubectl run frontend --image=nginx --namespace=network-policy-tutorial

# 查看是否成功运行
kubectl get pods --namespace=network-policy-tutorial

# 为 Pod 创建相应的服务：
kubectl expose pod backend --port 80 --namespace=network-policy-tutorial
kubectl expose pod database --port 80 --namespace=network-policy-tutorial
kubectl expose pod frontend --port 80 --namespace=network-policy-tutorial

# 查看ip
kubectl get service --namespace=network-policy-tutorial

# 检查frontend是否可以与backend和database通信
kubectl exec -it frontend --namespace=network-policy-tutorial -- curl <BACKEND-CLUSTER-IP>
kubectl exec -it frontend --namespace=network-policy-tutorial -- curl <DATABASE-CLUSTER-IP>
```

#### 在命名空间中限制流量

- 目标：如何在`network-policy-tutorial`命名空间内限制流量。你将阻止frontend应用程序与backend和database应用程序通信。

- 创建一个名为`namespace-default-deny.yml`的策略，该策略拒绝命名空间中的所有流量：

    ```sh
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: namespace-default-deny
      namespace: network-policy-tutorial
    spec:
      podSelector: {}
      policyTypes:
      - Ingress
      - Egress
    ```

    ```sh
    # 将网络策略配置应用于集群
    kubectl apply -f namespace-default-deny.yml --namespace=network-policy-tutorial
    ```

- 发现frontend已经不能与backend和database通信
    ```sh
    # 查看ip
    kubectl get service --namespace=network-policy-tutorial

    # 检查frontend是否可以与backend和database通信
    kubectl exec -it frontend --namespace=network-policy-tutorial -- curl <BACKEND-CLUSTER-IP>
    kubectl exec -it frontend --namespace=network-policy-tutorial -- curl <DATABASE-CLUSTER-IP>
    ```

#### 允许特定 Pod 的流量

- 目的：集群中允许以下外部流量

    - frontend 只能向 backend 发送外部流量，而 backend 只能从 frontend 接收内部流量。同样， backend 只能向 database 发送外部流量，而 database 只能从 backend 接收内部流量。

    ```
    frontend -> backend -> database
    ```

- 创建一个名为`frontend-default-policy.yml`的策略

    ```yml
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: frontend-default
      namespace: network-policy-tutorial
    spec:
      podSelector:
        matchLabels:
          run: frontend
      policyTypes:
        - Egress
      egress:
        - to:
            - podSelector:
                matchLabels:
                  run: backend
    ```

    ```sh
    kubectl apply -f frontend-default-policy.yml --namespace=network-policy-tutorial
    ```

- 对于 backend ，创建一个名为 `backend-default-policy.yml` 的新策略
    ```yml
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: backend-default
      namespace: network-policy-tutorial
    spec:
      podSelector:
        matchLabels:
          run: backend
      policyTypes:
        - Ingress
        - Egress
      ingress:
        - from:
            - podSelector:
                matchLabels:
                  run: frontend
      egress:
        - to:
            - podSelector:
                matchLabels:
                  run: database
    ```
    ```sh
    kubectl apply -f backend-default-policy.yml --namespace=network-policy-tutorial
    ```

- 为 database 创建一个新策略 `database-default-policy.yml`
    ```yml
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: database-default
      namespace: network-policy-tutorial
    spec:
      podSelector:
        matchLabels:
          run: database
      policyTypes:
        - Ingress
      ingress:
        - from:
            - podSelector:
                matchLabels:
                  run: backend
    ```
    ```sh
    kubectl apply -f database-default-policy.yml --namespace=network-policy-tutorial
    ```

- 测试

    - 接受测试
        ```sh
        kubectl exec -it frontend --namespace=network-policy-tutorial -- curl <BACKEND-CLUSTER-IP>
        kubectl exec -it backend --namespace=network-policy-tutorial -- curl <DATABASE-CLUSTER-IP>
        ```

    - 以下测试不会收到响应
        ```sh
        kubectl exec -it backend --namespace=network-policy-tutorial -- curl <FRONTEND-CLUSTER-IP>
        kubectl exec -it database --namespace=network-policy-tutorial -- curl <FRONTEND-CLUSTER-IP>
        kubectl exec -it database --namespace=network-policy-tutorial -- curl <BACKEND-CLUSTER-IP>
        ```

#### 在单个策略中组合入站和出站规则

- 创建`backend-default-policy.yml`文件

```yml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-default
  namespace: network-policy-tutorial
spec:
  podSelector:
    matchLabels:
      run: backend
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              run: frontend
  egress:
    - to:
        - podSelector:
            matchLabels:
              run: database
```

#### 阻止对特定 IP 范围的出站流量

- 不是创建一个新的yml配置文件，让我们更新你之前创建的`backend-default-policy.yml`文件。你将替换yaml配置的出站部分。不使用`podSelector`来限制 IP 到数据库，而是使用`ipBlock`。

- 更新`backend-default-policy.yml`文件：
    - 记得替换`<DATABASE-CLUSTER-IP>/24`

    ```yml
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: backend-default
      namespace: network-policy-tutorial
    spec:
      podSelector:
        matchLabels:
          run: backend
      policyTypes:
        - Ingress
        - Egress
      ingress:
        - from:
            - podSelector:
                matchLabels:
                  run: frontend
      egress:
        - to:
            - ipBlock:
                 cidr: <DATABASE-CLUSTER-IP>/24
    ```

    ```sh
    # 在应用配置之前，首先检查网络策略
    kubectl get networkpolicy --namespace=network-policy-tutorial
    NAME                     POD-SELECTOR   AGE
    backend-default          run=backend    12m
    database-default         run=database   10m
    frontend-default         run=frontend   13m
    namespace-default-deny   <none>         19m

    # 更新配置
    kubectl apply -f backend-default-policy.yml --namespace=network-policy-tutorial
    ```

- 从 frontend 访问 database ，就不再可能了

    ```sh
    kubectl exec -it backend --namespace=network-policy-tutorial -- curl <DATABASE-CLUSTER-IP>
    ```

- backend 能够从 frontend 接收流量的网络策略已被删除； frontend 应用程序无法再访问 backend

    ```sh
    kubectl delete -f backend-default-policy.yaml --namespace=network-policy-tutorial
    ```

## [minikube：单机运行Kubernetes集群](https://github.com/kubernetes/minikube)

```sh
# 启动docker
sudo systemctl start docker

# 启动Kubernetes集群。会创建~/.minikube目录
minikube start --image-mirror-country='cn'
# 可以调整配置参数
minikube start --image-mirror-country='cn' --cpus=4 --memory=2048MB
# 换成docker源最快
minikube start --image-mirror-country='cn' --registry-mirror=https://registry.docker-cn.com --cpus=4 --memory=4096MB

# Dashboard管理界面
minikube dashboard

# 查看当前集群列表
minikube profile list

# 查看当前集群虚拟机的IP地址
minikube ip

# 通过kubectl命令行工具，找到Dashboard对应的Service对外暴露的端口
kubectl get service --namespace=kube-system
```

### 插件

```sh
# 安装nginx-ingress插件
minikube addons enable ingress
```

### nginx

- 创建了一个名为`nginx-deployment.yml`文件

    - 创建的资源类型为`Deployment`
    - 注意新版kubernetes的`apiVersion: extensions/v1beta1`已被抛弃。使用`apps/v1`代替

    ```yml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-deployment
      labels:
        app: nginx
    spec:
      # 三份nginx
      replicas: 3
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - name: nginx
            image: nginx:1.7.9
            ports:
            - containerPort: 80
    ```

```sh
# 启动
kubectl create -f nginx-deploymeht.yml

# 查看Deployment的运行状态
kubectl get deployments

# 查看运行的Pod实例
kubectl get pods
```

- 创建`nginx-service.yml`的文件：为了能够让用户或者其它服务能够访问到Nginx实例

    ```yml
    kind: Service
    apiVersion: v1
    metadata:
      name: nginx-service
    spec:
      selector:
        app: nginx
      ports:
      - protocol: TCP
        port: 80
        targetPort: 80
      type: NodePort
    ```

```sh
# 启动
kubectl create -f nginx-service.yml

# 查看资源
kubectl get svc

# 查看nginx的ip地址和端口。
minikube service nginx-service --url
http://192.168.49.2:30342
```

- 用浏览器打开`http://192.168.49.2:30342`确认是否成功

```sh
# 对Nginx实例进行扩展
kubectl scale deployments/nginx-deployment --replicas=4

# 对镜像进行滚动升级
kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1
# 如果升级后服务出现异常，那么可以通过以下命令对应用进行回滚：
kubectl rollout undo deployment/nginx-deployment
```

### Prometheus

- [《prometheus-book》部署Prometheus](https://yunlzheng.gitbook.io/prometheus-book/part-iii-prometheus-shi-zhan/readmd/deploy-prometheus-in-kubernetes)

- 创建`prometheus-config.yml`文件
    - 使用ConfigMaps管理Prometheus的配置文件

```yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
data:
  prometheus.yml: |
    global:
      scrape_interval:     15s
      evaluation_interval: 15s
    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
        - targets: ['localhost:9090']
```

```sh
# 启动
kubectl create -f prometheus-config.yml
```

- 创建`prometheus-deployment.yml`文件

    - 当ConfigMap资源创建成功后，我们就可以通过Volume挂载的方式，将Prometheus的配置文件挂载到容器中

```yml
apiVersion: v1
kind: "Service"
metadata:
  name: prometheus-service
  labels:
    name: prometheus
spec:
  ports:
  - name: prometheus
    protocol: TCP
    port: 9090
    targetPort: 9090
  selector:
    app: prometheus
  type: NodePort
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    name: prometheus
  name: prometheus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus:v2.2.1
        command:
        - "/bin/prometheus"
        args:
        - "--config.file=/etc/prometheus/prometheus.yml"
        ports:
        - containerPort: 9090
          protocol: TCP
        volumeMounts:
        - mountPath: "/etc/prometheus"
          name: prometheus-config
      volumes:
      - name: prometheus-config
        configMap:
          name: prometheus-config
```

```
# 启动
kubectl create -f prometheus-deployment.yml

# 查看启动情况
kubectl get pods

# 查看端口
kubectl get svc

# 查看ip地址和端口。使用浏览器访问确认是否成功
minikube service list
```

#### 服务发现

- 上一节，除了Prometheus，暂时没有任何的监控采集目标

- Kubernetes下Prometheus就是需要与Kubernetes的API进行交互，从而能够动态的发现Kubernetes中部署的所有可监控的目标资源。

- 基于角色的访问控制模型(Role-Based Access Control)：用于管理Kubernetes下资源访问权限。

    - 为了能够让Prometheus能够访问收到认证保护的Kubernetes API，我们首先需要做的是，对Prometheus进行访问授权。

    - 步骤：
        - 1.定义角色（ClusterRole），并且为该角色赋予相应的访问权限
        - 2.创建Prometheus所使用的账号（ServiceAccount）
        - 3.将该账号与角色进行绑定（ClusterRoleBinding）

    - 这些所有的操作在Kubernetes同样被视为是一系列的资源，可以通过YAML文件进行描述并创建，这里创建`prometheus-rbac-setup.yml`文件
        ```yml
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRole
        metadata:
          name: prometheus-clusterrole
        rules:
        - apiGroups: [""]
          resources:
          - nodes
          - nodes/proxy
          - services
          - endpoints
          - pods
          verbs: ["get", "list", "watch"]
        - apiGroups:
          - extensions
          resources:
          - ingresses
          verbs: ["get", "list", "watch"]
        - nonResourceURLs: ["/metrics"]
          verbs: ["get"]
        ---
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: prometheus-serviceaccount
          namespace: default
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          name: prometheus-clusterrolebinding
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: prometheus
        subjects:
        - kind: ServiceAccount
          name: prometheus
          namespace: default
        ```

        ```sh
        # 启动
        kubectl create -f prometheus-rbac-setup.yml
        ```

- 修改`prometheus-deployment.yml`文件，并添加`serviceAccountName`和`serviceAccount`定义：
    ```yml
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: prometheus
      template:
        metadata:
          labels:
            app: prometheus
        spec:
          serviceAccountName: prometheus
          serviceAccount: prometheus-serviceaccount
    ```

    ```sh
    # 对Deployment进行变更升级
    kubectl apply -f prometheus-deployment.yml

    # 查看pod的name
    kubectl get pods
    NAME                          READY   STATUS    RESTARTS   AGE
    prometheus-85b4775c8b-vmcsf   1/1     Running   0          2m55s

    # 指定ServiceAccount创建的Pod实例中，会自动将用于访问Kubernetes API的CA证书以及当前账户对应的访问令牌文件挂载到Pod实例的/var/run/secrets/kubernetes.io/serviceaccount/目录下
    kubectl exec -it prometheus-85b4775c8b-vmcsf ls /var/run/secrets/kubernetes.io/serviceaccount/
    ```

- 在Promtheus的配置文件中，我们添加如下Job配置：获取到当前集群中所有节点的信息

    - 通过指定`kubernetes_sd_config`的模式为`node`，Prometheus会自动从Kubernetes中发现到所有的node节点并作为当前Job监控的Target实例。

        ```yml
        - job_name: 'kubernetes-nodes'
          tls_config:
            ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
          bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
          kubernetes_sd_configs:
          - role: node
        ```

    - `prometheus-config.yml`完整配置
        ```yml
        apiVersion: v1
        kind: ConfigMap
        metadata:
          name: prometheus-config
        data:
          prometheus.yml: |-
            global:
              scrape_interval:     15s
              evaluation_interval: 15s
            scrape_configs:

            - job_name: 'kubernetes-nodes'
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
              bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              kubernetes_sd_configs:
              - role: node

            - job_name: 'kubernetes-service'
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
              bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              kubernetes_sd_configs:
              - role: service

            - job_name: 'kubernetes-endpoints'
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
              bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              kubernetes_sd_configs:
              - role: endpoints

            - job_name: 'kubernetes-ingress'
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
              bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              kubernetes_sd_configs:
              - role: ingress

            - job_name: 'kubernetes-pods'
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
              bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              kubernetes_sd_configs:
              - role: pod
        ```

- 更新Prometheus配置文件，并重建Prometheus实例：
    ```sh
    kubectl apply -f prometheus-config.yml

    # 查看pods的name
    kubectl get pods
    NAME                          READY   STATUS    RESTARTS   AGE
    prometheus-85b4775c8b-vmcsf   1/1     Running   0          9m21s

    # 删除
    kubectl delete prometheus-85b4775c8b-vmcsf

    # 再次查看
    kubectl get pods
    NAME                          READY   STATUS    RESTARTS   AGE
    prometheus-85b4775c8b-kcqc5   1/1     Running   0          51s
    ```

- 打开`http://192.168.49.2:32305/service-discovery`查看是否成功
    ![image](./Pictures/kubernetes/部署-prometheus.avif)

#### 对Kubernetes集群以及其中部署的各类资源的自动化监控

| 目标                                                                     | 服务发现模式 | 监控方法 | 数据源            |
|--------------------------------------------------------------------------|--------------|----------|-------------------|
| 从集群各节点kubelet组件中获取节点kubelet的基本运行状态的监控指标         | node         | 白盒监控 | kubelet           |
| 从集群各节点kubelet内置的cAdvisor中获取，节点中运行的容器的监控指标      | node         | 白盒监控 | kubelet           |
| 从部署到各个节点的Node Exporter中采集主机资源相关的运行资源              | node         | 白盒监控 | node exporter     |
| 对于内置了Promthues支持的应用，需要从Pod实例中采集其自定义监控指标       | pod          | 白盒监控 | custom  pod       |
| 获取API Server组件的访问地址，并从中获取Kubernetes集群相关的运行监控指标 | endpoints    | 白盒监控 | api server        |
| 获取集群中Service的访问地址，并通过Blackbox Exporter获取网络探测指标     | service      | 黑盒监控 | blackbox exporter |
| 获取集群中Ingress的访问信息，并通过Blackbox Exporter获取网络探测指标     | ingress      | 黑盒监控 | blackbox exporter |

- 修改`prometheus.yml`配置文件：通过labelmap步骤，将Node节点上的标签，作为样本的标签保存到时间序列当中。

- 添加`kubernetes-kubelet`配置
    - ??失败了。不知为什么失败了，而同样的方法cAdvisor则可以
    - 问题配置文件：
        ```yml
          - job_name: 'kubernetes-kubelet'
            scheme: https
            tls_config:
            ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
            bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
            kubernetes_sd_configs:
            - role: node
            relabel_configs:
            - action: labelmap
              regex: __meta_kubernetes_node_label_(.+)
        ```

        ```sh
        # 重新加载
        kubectl apply -f prometheus-config.yml

        # 查看pods
        kubectl get pods
        NAME                          READY   STATUS    RESTARTS   AGE
        prometheus-85d76fb498-vlw6c   1/1     Running   0          24m

        # 删除pods
        kubectl delete pods prometheus-85d76fb498-vlw6c
        pod "prometheus-85d76fb498-vlw6c" deleted

        # 无法重新启动
        kubectl get pods
        NAME                          READY   STATUS      RESTARTS     AGE
        prometheus-85d76fb498-j4mv4   0/1     Completed   1 (5s ago)   6s
        ```

    - 解决方法1：由于当前使用的ca证书中，并不包含ip的地址信息：设置`insecure_skip_verify为true`跳过ca证书校验过程
        ```yml
          - job_name: 'kubernetes-kubelet'
              scheme: https
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
                insecure_skip_verify: true
              bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              kubernetes_sd_configs:
              - role: node
              relabel_configs:
              - action: labelmap
                regex: __meta_kubernetes_node_label_(.+)
        ```

    - 解决方法2：不直接通过kubelet的metrics服务采集监控数据，而通过Kubernetes的api-server提供的代理API访问各个节点中kubelet的metrics服务
        - 通过`relabeling`，将从Kubernetes获取到的默认地址`__address__`替换为`kubernetes.default.svc:443`。同时将`__metrics_path__`替换为api-server的代理地址`/api/v1/nodes/${1}/proxy/metrics`。

        ```yml
          - job_name: 'kubernetes-kubelet'
              scheme: https
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
              bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              kubernetes_sd_configs:
              - role: node
              relabel_configs:
              - action: labelmap
                regex: __meta_kubernetes_node_label_(.+)
              - target_label: __address__
                replacement: kubernetes.default.svc:443
              - source_labels: [__meta_kubernetes_node_name]
                regex: (.+)
                target_label: __metrics_path__
                replacement: /api/v1/nodes/${1}/proxy/metrics
        ```

- - 添加`cAdvisor`配置
    - 方法1：直接访问kubelet的/metrics/cadvisor地址，需要跳过ca证书认证
        ```yml
            - job_name: 'kubernetes-cadvisor'
              scheme: https
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
                insecure_skip_verify: true
              bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              kubernetes_sd_configs:
              - role: node
              relabel_configs:
              - source_labels: [__meta_kubernetes_node_name]
                regex: (.+)
                target_label: __metrics_path__
                replacement: metrics/cadvisor
              - action: labelmap
                regex: __meta_kubernetes_node_label_(.+)
        ```

    - 方式2：通过api-server提供的代理地址访问kubelet的/metrics/cadvisor地址：
        ```yml
            - job_name: 'kubernetes-cadvisor'
              scheme: https
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
              bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              kubernetes_sd_configs:
              - role: node
              relabel_configs:
              - target_label: __address__
                replacement: kubernetes.default.svc:443
              - source_labels: [__meta_kubernetes_node_name]
                regex: (.+)
                target_label: __metrics_path__
                replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
              - action: labelmap
                regex: __meta_kubernetes_node_label_(.+)
        ```

- 使用`NodeExporter`监控集群资源使用情况。创建`node-exporter-daemonset.yml`文件

    - 通过Daemonset的形式将Node Exporter部署到了集群中的各个节点中

    ```yml
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: node-exporter
    spec:
      selector:
        matchLabels:
          app: node-exporter
      template:
        metadata:
          annotations:
            prometheus.io/scrape: 'true'
            prometheus.io/port: '9100'
            prometheus.io/path: 'metrics'
          labels:
            app: node-exporter
        spec:
          containers:
          - image: prom/node-exporter
            imagePullPolicy: IfNotPresent
            name: node-exporter
            ports:
            - containerPort: 9100
              hostPort: 9100
              name: scrape
          hostNetwork: true
          hostPID: true
    ```
    ```sh
    # 启动
    kubectl create -f node-exporter-daemonset.yml

    # 查看Daemonset
    kubectl get daemonsets

    # 查看pods
    kubectl get pods

    # 查看ip
    minikube ip
    192.168.49.2

    # 查看是否有指标
    curl http://192.168.49.2:9100/metrics
    ```

- `kubernetes-pods`：为Prometheus创建监控采集任务

    - 通过relabel过程实现对Pod实例的过滤，以及采集任务地址替换，从而实现对特定Pod实例监控指标的采集。
    - 需要说明的是kubernetes-pods并不是只针对Node Exporter而言，对于用户任意部署的Pod实例，只要其提供了对Prometheus的支持，用户都可以通过为Pod添加注解的形式为其添加监控指标采集的支持。

    ```yml
      - job_name: 'kubernetes-pods'
        kubernetes_sd_configs:
        - role: pod
        relabel_configs:
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
          action: keep
          regex: true
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
          action: replace
          target_label: __metrics_path__
          regex: (.+)
        - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
          action: replace
          regex: ([^:]+)(?::\d+)?;(\d+)
          replacement: $1:$2
          target_label: __address__
        - action: labelmap
          regex: __meta_kubernetes_pod_label_(.+)
        - source_labels: [__meta_kubernetes_namespace]
          action: replace
          target_label: kubernetes_namespace
        - source_labels: [__meta_kubernetes_pod_name]
          action: replace
          target_label: kubernetes_pod_name
    ```

- 创建监控任务`kubernetes-apiservers`，这里指定了服务发现模式为endpoints：Promtheus会查找当前集群中所有的`endpoints`配置，并通过relabel进行判断是否为apiserver对应的访问地址

- 对Ingress和Service进行网络探测
    ```yml
    - job_name: 'kubernetes-apiservers'
      kubernetes_sd_configs:
      - role: endpoints
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      relabel_configs:
      - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
        action: keep
        regex: default;kubernetes;https
      - target_label: __address__
        replacement: kubernetes.default.svc:443
    ```

- 对Ingress和Service进行网络探测

    - 创建`blackbox-exporter.yml`

        ```yml
        apiVersion: v1
        kind: Service
        metadata:
          labels:
            app: blackbox-exporter
          name: blackbox-exporter
        spec:
          ports:
          - name: blackbox
            port: 9115
            protocol: TCP
          selector:
            app: blackbox-exporter
          type: ClusterIP
        ---
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          labels:
            app: blackbox-exporter
          name: blackbox-exporter
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: blackbox-exporter
          template:
            metadata:
              labels:
                app: blackbox-exporter
            spec:
              containers:
              - image: prom/blackbox-exporter
                imagePullPolicy: IfNotPresent
                name: blackbox-exporter
        ```

        ```sh
        # 启动。同时通过服务blackbox-exporter在集群内暴露访问地址blackbox-exporter.default.svc.cluster.local，对于集群内的任意服务都可以通过该内部DNS域名访问Blackbox Exporter实例：
        kubectl create -f blackbox-exporter.yml

        # 查看
        kubectl get pods
        kubectl get svc
        ```

- `kubernetes-services`的监控采集任务：为了能够让Prometheus能够自动的对Service进行探测，我们需要通过服务发现自动找到所有的Service信息。

    - 通过指定kubernetes_sd_config的role为service指定服务发现模式：
        ```yml
          kubernetes_sd_configs:
            - role: service
        ```

    - 为了区分集群中需要进行探测的Service实例，我们通过标签`prometheus.io/probe: true`进行判断，从而过滤出需要探测的所有Service实例：
        ```yml
              - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_probe]
                action: keep
                regex: true
        ```

    - 并且将通过服务发现获取到的Service实例地址__address__转换为获取监控数据的请求参数。同时将__address执行Blackbox Exporter实例的访问地址，并且重写了标签instance的内容：
        ```yml
              - source_labels: [__address__]
                target_label: __param_target
              - target_label: __address__
                replacement: blackbox-exporter.default.svc.cluster.local:9115
              - source_labels: [__param_target]
                target_label: instance
        ```

    - 最后，为监控样本添加了额外的标签信息：
        ```yml
              - action: labelmap
                regex: __meta_kubernetes_service_label_(.+)
              - source_labels: [__meta_kubernetes_namespace]
                target_label: kubernetes_namespace
              - source_labels: [__meta_kubernetes_service_name]
                target_label: kubernetes_name
        ```

    - 完整配置：
        ```yml
            - job_name: 'kubernetes-services'
              metrics_path: /probe
              params:
                module: [http_2xx]
              kubernetes_sd_configs:
              - role: service
              relabel_configs:
              - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_probe]
                action: keep
                regex: true
              - source_labels: [__address__]
                target_label: __param_target
              - target_label: __address__
                replacement: blackbox-exporter.default.svc.cluster.local:9115
              - source_labels: [__param_target]
                target_label: instance
              - action: labelmap
                regex: __meta_kubernetes_service_label_(.+)
              - source_labels: [__meta_kubernetes_namespace]
                target_label: kubernetes_namespace
              - source_labels: [__meta_kubernetes_service_name]
                target_label: kubernetes_name
        ```

- `kubernetes-ingresses`和`kubernetes-services`相类似
    ```yml
        - job_name: 'kubernetes-ingresses'
          metrics_path: /probe
          params:
            module: [http_2xx]
          kubernetes_sd_configs:
          - role: ingress
          relabel_configs:
          - source_labels: [__meta_kubernetes_ingress_annotation_prometheus_io_probe]
            action: keep
            regex: true
          - source_labels: [__meta_kubernetes_ingress_scheme,__address__,__meta_kubernetes_ingress_path]
            regex: (.+);(.+);(.+)
            replacement: ${1}://${2}${3}
            target_label: __param_target
          - target_label: __address__
            replacement: blackbox-exporter.default.svc.cluster.local:9115
          - source_labels: [__param_target]
            target_label: instance
          - action: labelmap
            regex: __meta_kubernetes_ingress_label_(.+)
          - source_labels: [__meta_kubernetes_namespace]
            target_label: kubernetes_namespace
          - source_labels: [__meta_kubernetes_ingress_name]
            target_label: kubernetes_name
    ```

### Prometheus Operator（简化在Kubernetes下部署和管理Prmetheus的复杂度）（??失败了）

- [《prometheus-book》Prometheus Operator](https://yunlzheng.gitbook.io/prometheus-book/part-iii-prometheus-shi-zhan/operator)

- 使用`ConfigMap`管理Prometheus配置文件的缺点：

    - 每次对Prometheus配置文件进行升级时，我们需要手动移除已经运行的Pod实例，从而让Kubernetes可以使用最新的配置文件创建Prometheus。

    - 而如果当应用实例的数量更多时，通过手动的方式部署和升级Prometheus过程繁琐并且效率低下。

- 从本质上来讲Prometheus属于是典型的有状态应用，而其有包含了一些自身特有的运维管理和配置管理方式。而这些都无法通过Kubernetes原生提供的应用管理概念实现自动化。

    - 为了简化这类应用程序的管理复杂度，CoreOS率先引入了Operator的概念，并且首先推出了针对在Kubernetes下运行和管理Etcd的Etcd Operator。并随后推出了Prometheus Operator。

- Operator就是针对管理特定应用程序的，在Kubernetes基本的Resource和Controller的概念上，以扩展Kubernetes api的形式。帮助用户创建，配置和管理复杂的有状态应用程序。从而实现特定应用程序的常见操作以及运维自动化。

- 在Kubernetes中我们使用Deployment、DamenSet，StatefulSet来管理应用Workload，使用Service，Ingress来管理应用的访问方式，使用ConfigMap和Secret来管理应用配置。我们在集群中对这些资源的创建，更新，删除的动作都会被转换为事件(Event)，Kubernetes的Controller Manager负责监听这些事件并触发相应的任务来满足用户的期望。

    - 这种方式我们成为声明式，用户只需要关心应用程序的最终状态，其它的都通过Kubernetes来帮助我们完成，通过这种方式可以大大简化应用的配置管理复杂度。

    - 而除了这些原生的Resource资源以外，Kubernetes还允许用户添加自己的自定义资源(Custom Resource)。并且通过实现自定义Controller来实现对Kubernetes的扩展。

- Prometheus Operator的架构

    ![image](./Pictures/kubernetes/prometheus-architecture.avif)

    - Prometheus的本职就是一组用户自定义的CRD（自定义）资源以及Controller的实现

    - Prometheus Operator负责监听这些自定义资源的变化，并且根据这些资源的定义自动化的完成如Prometheus Server自身以及配置的自动化管理工作。

```sh
# 下载Prometheus Operator源码
git clone https://github.com/coreos/prometheus-operator.git

# 为Promethues Operator创建一个单独的命名空间monitoring
kubectl create namespace monitoring

# 替换bundle.yaml文件中所有namespace定义，由default修改为monitoring。
sed -i 's/namespace: default/namespace: monitoring/g' bundle.yaml

# 安装Prometheus Operator的Deployment实例
kubectl -n monitoring apply -f bundle.yaml

# 查看Prometheus Operator部署状态
kubectl -n monitoring get pods
```

- 创建`prometheus-inst.yaml`文件
    ```yml
    apiVersion: monitoring.coreos.com/v1
    kind: Prometheus
    metadata:
      name: inst
      namespace: monitoring
    spec:
      resources:
        requests:
          memory: 400Mi
    ```
    ```sh
    # 启动??失败了
    kubectl create -f prometheus-inst.yaml
    ```

## [helm：包管理器](https://github.com/helm/helm)

- Helm 的 Repo 仓库和 Docker Registry 比较类似。Chart 库可以用来存储和共享打包 Chart 的位置

### 基本命令

- 基本命令
```sh
# 删除默认仓库（因为需要科学上网）
helm repo remove stable
# 如果需要重新添加
helm repo add stable https://charts.helm.sh/stable

# 换成国内镜像库。不过这些国内库未必会实时更新
helm repo add stable https://burdenbear.github.io/kube-charts-mirror/

# 更新仓库
helm repo update

# 查看仓库
helm repo list

# 查找chart。这里为mysql
helm search repo mysql

# 查看stable/mysql的chart详细信息
helm show all stable/mysql
```

- 安装
```sh
# 安装，并自定义名字my-mysql-release
helm install my-mysql-release stable/mysql
# 或安装，自动生产名字
helm install --generate-name stable/mysql
# 安装，关闭持久化
helm install my-mysql-release stable/mysql --set persistence.enabled = false

# 查看ip和端口
kubectl get svc

# 查看pods
kubectl get pods

# 查看pod的定义
kubectl describe pod my-mysql-release

# 查看已安装的chart。可以看到REVERSION版本为1
helm ls

# 删除已安装的chart
helm delete my-mysql-release
```

- 安装，并指定一些自定义配置文件

    - 创建`mysql-config.yml`文件
    ```yml
    mysqlUser: tz
    mysqlDatabase: testdb
    service:
      type: NodePort
    ```

    - 安装
    ```sh
    # 安装
    helm install -f mysql-config.yml my-mysql-release stable/mysql

- 更新`mysql-config.yml`文件，禁用持久化
    ```yml
    mysqlUser: tz
    mysqlDatabase: testdb
    service:
      type: NodePort
    # 禁止持久化
    persistence:
      enabled: false
    ```

    ```sh
    # 如果修改了配置文件，需要更新使用upgrade
    helm upgrade -f mysql-config.yml my-mysql-release stable/mysql
    ```

- `REVISION`版本和`rollback`回滚
    ```sh
    # 更新后REVISION版本为2
    helm ls
    NAME            	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART      	APP VERSION
    my-mysql-release	default  	2       	2023-12-26 11:29:00.055353604 +0800 CST	deployed	mysql-1.6.9	5.7.30

    # 查看过去的版本修改（回滚也会记录）
    helm history my-mysql-release

    # 回滚到第1个版本。
    helm rollback my-mysql-release 1

    # 此时的REVISION版本为2
    helm ls

    # 查看已经丢弃的版本
    helm ls --superseded
    ```

### 插件

```sh
# 安装helm dashboard插件
helm plugin install https://github.com/komodorio/helm-dashboard.git

# 启动
helm dashboard

# 删除
helm plugin uninstall dashboard
```

## [Timoni：Helm 的可能替代方案](https://github.com/stefanprodan/timoni)

- 使用CUElang，这是一种专门为这些用例而设计的语言。代替yaml

## [Nacos](https://github.com/alibaba/nacos)

- Nacos（Namings and Configuration Management）是阿里巴巴开源的一个易于构建云原生应用的动态服务发现、配置管理和服务管理平台。

## 云原生CI/CD

- Tekton vs  Argo Workflow
    - 从系统架构上来说：Tekton 做得更好，整体架构比较清晰
    - 从用户功能的角度上来说：Argo Workflow 更容易上手使用。
    - Argo workflow 的文档建设也比 Tekton 更好。

    - 总的来说 Tekton 提供的内容处于更底层的位置，与 kubernetes 类似，是一个 CI/CD 底层的引擎，真正用好它需要基于它做一些事情。而 Argo Workflow 处于更上层一点的位置，提供了很多实用的功能，可以很方便的应用起来。

### Tekton

### Argo Workflow

- 在 Argo Workflow 中，每一个 step/dag task 就是一个 pod 中的容器：最基础的 pod 会有 1 个 init 容器和两个工作容器，其中 init 容器和主容器都是 argoproj/argoexec 容器
    - main 容器：也就是 step/dag task 中定义的容器，用于执行实际内容。
    - init 容器：用于为 main 容器处理 artifact 以及参数相关的逻辑。
    - wait 容器：等待 main 容器执行完成，以及处理一些清理任务，例如上传 artifact 到 S3。

- Argo Workflow 中三个 CRD 对象：

    - 1.Workflow：是一个流水线的 "实例"，也就是只有创建了 Workflow 对象是才会真正的运行流水线。

    - 2.WorkflowTemplate：最重要的对象了，基本上绝大部分时间你都是和它在打交道

        - 需要注意区分的一点是 workflowTemplate 和 template
            - workflowTemplate：是 argo workflow 中实现的 CRD 对象
            - template：是对象内的一个字段，实际执行内容都是在 template 中定义的
                - template 可以单独作为流水线入口执行，也可以被其他的 template 引用

            - 一个 workflowTemplate 至少要包含一个 template。
                - workflowTemplate 需要将一个 template 配置为 entrypoint，也就是流水线的起点，在这个 template 的 steps 中又可以应用多个相同或不同的 template。

        - 处理 git例子：

            - 在同一份代码中多次 merge && commit，流水线入口是 git clone，然后 git merge， git add && git commit
                - template2 和 template3 是作为 template1 的一部分存在的

            - 当流水线入口直接就是 git merge 或 git add && git commit 的情况时
                - template2 或 template3 是作为单独的流水线逻辑存在。

        ```yml
          entrypoint: hello-hello-hello #配置template入口
          templates:
          - name: hello-hello-hello
            steps:
            - - name: hello1
                template: whalesay
                arguments:
                  parameters:
                  - name: message
                    value: "hello1"
            - - name: hello2a
                template: whalesay
                arguments:
                  parameters:
                  - name: message
                    value: "hello2a"   #hello2a与hello1 是顺序执行
              - name: hello2b          #hello2a与hello2b是并行执行
                template: whalesay
                arguments:
                  parameters:
                  - name: message
                    value: "hello2b"
        ```

    - 3.CronWrokflow：定时触发 workflow 的定义，在 CI 中也是很常见的，例如每晚构建。
        - 通过 Argo 的 UI 界面创建一个定时的 workflow 时也会有一个默认的 cronWorkflow

## GitOps

- [GitOps 常用工具盘点](https://zhuanlan.zhihu.com/p/547104017)

- [云音乐技术团队：云音乐 GitOps 最佳实践](https://segmentfault.com/a/1190000043961778)

- 在传统的云主机部署模式下，通过工单创建运维请求，运维人员接收到工单后，通过 Ansible 等运维工具手动进行运维操作。这种方式在实际操作过程中遇到了许多问题，比如由于 Ansible 基于 SSH 下发文件，所以需要给每台机器配置 SSH；因为机器底层的异构，导致运维需要修改配置文件；或是因为脚本执行顺序错误，导致需要重新执行整个部署流程；手工操作，导致部署效率低，容易出错，无法保证部署质量。

- 云主机时代运维存在以下缺陷：

    - 环境不一致：需要step-by-step的编写脚本，设想目标环境中的各种情况，编写脚本时需要考虑各种情况，比如机器是否已经部署过，机器是否已经配置过 SSH，机器是否已经安装过依赖等等。并且脚本运行在不同环境中可能会有不同的结果。
    - 无事务保证：安装脚本不能被打断，如果中途遇到问题，服务可能处于不可用的中间状态。
    - 协作困难：需要另行编写文档描述运维流程，如果多人同时维护一个脚本，协作往往非常困难。
    - 回滚困难：部署流程难以回滚，如果部署过程中出现问题，需要手动执行逆向操作。
    - 权限管控与审核：通常运维需要目标主机的 root 权限，难以限制运维人员的权限，同时也难以对整个运维动作进行审核。

- 云原生时代部署特点
    - 部署频繁：微服务应用被拆分成了多个服务，每个服务都需要独立部署，部署频率大大提高，需要更高的部署效率
    - 多副本：微服务通过扩容副本的方式来提高可用性，通常需要部署多副本，有时甚至需要部署数百个副本
    - 多环境：通常需要部署多个环境，比如开发环境、测试环境、预发环境和生产环境


- GitOps 是一种符合 DevOps 思想的运维方式，GitOps 以 Git 仓库作为唯一的事实来源，储存声明式配置，并通过自动化工具实现环境和应用的自动化管理。

    - Git 仓库：满足了对于版本管理、回滚、多人协作的需求，声明式配置满足了对于事务性、一致性的需求，而自动化工具提高了部署的自动化水平。

    - 声明式配置：
        - 声明式配置使用配置文件直接描述系统的期望状态，使用者不需要考虑执行流程和目标环境的差异，易于编写、理解、代码 review 和进行版本管理。
        - 幂等性：可以重复应用而不会导致系统状态发生变化。
        - 事务性，要么全部应用成功，要么什么都不做
            - 例子：Kubernetes 资源配置文件，使用者只需要指定 CPU 和 Memory 的大小，而不需要关心底层执行细节和环境差异，保证了各个环境中部署一致。
                ```yml
                apiVersion: apps/v1
                kind: Deployment
                metadata:
                  name: example-deployment
                spec:
                  replicas: 3
                  selector:
                    matchLabels:
                      app: example-app
                  template:
                    metadata:
                      labels:
                        app: example-app
                    spec:
                      containers:
                      - name: example-container
                        image: example-image
                        resources:
                          limits:
                            cpu: 1
                            memory: 512Mi
                          requests:
                            cpu: 500m
                            memory: 256Mi
                ```

- 自动化工具：GitOps 中的自动化工具负责将 Git 仓库中的配置应用到目标环境中。

    - 自动化工具可以根据 Git 仓库中的配置，自动化的完成部署、回滚、监控、告警等工作。

    - 可以是`Gitlab CI`、 `Github Action` 这类流水线工具，也可以是 `Argo CD` 这类专门用于 GitOps 的工具

        - ArgoCD 例子：用户只需要创建 Git 仓库和 ArgoCD Application，ArgoCD 就会自动的将 Git 仓库中的配置应用到目标环境中。并且 ArgoCD 会实时监听 Git 仓库的变化，一旦 Git 仓库中的配置发生变化，ArgoCD 也可以进行自动同步。

        ![image](./Pictures/kubernetes/ArgoCD.avif)

- 管控面运维：比如 Prometheus、Grafana、Argo Rollout 等

- 设计了一套基于 GitOps 的自动化运维流程：

    - 每个线上组件都会有两到三个对应的仓库，分别是：代码仓库、配置仓库、Helm Chart 仓库

        - 代码仓库：存放组件的源代码，如果是开源组件，则直接使用开源的 release，没有对应仓库

        - Helm Chart 仓库：存放组件的 Helm Chart，配置仓库通过 Helm Dependency 引用 Helm Chart 仓库中的 Chart，并存放了 values.yaml 文件，用于配置组件的参数

        - 将通用配置抽出来，放到同一个 Helm Cart 中，并在部署仓库中引用该 Chart，可以有效避免因多环境导致的配置不一致问题。

    - 流程：
        - 当需要修改配置时，开发者只需要修改配置仓库中的 values.yaml 文件，并向原仓库提交 MR，这时会触发流水线，验证修改是否正确。
        - 通过验证后，开发者需要请求团队中的其他人帮忙 review。
        - 通过检查后，将 MR 合并到 master 分支，这时会触发流水线，运行修改之后的配置，使用 Helm Upgrade 命令将组件更新到环境中。
        - 发布完成后，如果开发者本次更新升级有任何问题，可以通过运行上一次的部署流水线，将组件回滚到上一次的版本。

        ![image](./Pictures/kubernetes/GitOps流程.avif)

        - 为了强制执行以上过程，通常会回收开发者对于 master 分支的更新权限。开发者只能通过向原仓库提交 MR 的方式，来配置修改。这样，就可以保证配置和环境的一致性。为了避免开发者没有合入权限，我们开发了一个 review 机器人，当开发者提交 MR 时，机器人会在评论区进行评论，要求其他人 review 并投票。当该 MR 获得足够的票数（通常是两票）后，机器人会自动合入 MR。

- GitOps 并不是银弹：在网易云音乐的实践中，表现出了非常好的效果，但同时在实践中我们也发现了一些问题

    - 修改不便：设想，如果我们有多个环境，每个环境都对应一个配置仓库，那么一旦需要修改一个统一的值，那么需要修改所有仓库。

    - 密码管理：Git 仓库中数据都是明文显示，并且 Git 仓库会记住所有的历史修改，所以放在 Git 仓库中的明文信息应该加密。虽然社区里面开发了一些类似于 git-secret 的工具，但使用起来还是不太方便。这里需要注意的是，密码管理指将密钥放置于 Git 仓库中，和 Gitlab、Github secret并不一致。将密码放在 secret 中，就失去了 Git 仓库提供的 版本管理、回滚、审计等能力。

    - 标准不统一：对于回滚的实现，到底是修改配置，reset 到对应版本；还是通过运行 CI，重新部署到环境中？对于不同环境的相同应用部署，到底是选择多个仓库，还是一个仓库多个环境？这些都没有统一的标准，需要根据自身情况选择。

#### [ArgoCD](https://github.com/argoproj/argo-cd)

- [k8s技术圈：使用 Argo CD 进行 GitOps 流水线改造]()

- Argo CD 是一个为 Kubernetes 而生的，遵循声明式 GitOps 理念的持续部署（CD）工具，它的配置和使用非常简单。支持多种配置管理/模板工具（例如 Kustomize、Helm、Ksonnet、Jsonnet、plain-YAML）。

    - Argo CD 被实现为一个 Kubernetes 控制器，它持续 监控 正在运行的应用程序并将当前的实时状态与所需的目标状态（例如 Git 仓库中的配置）进行比较，在 Git 仓库更改时，自动同步和部署应用程序。

- 流程：

    - CI 部分和传统 CI/CD 工具一样：测试、构建镜像、推送镜像、修改部署清单等等。

        - 当开发人员将开发完成的代码推送到git仓库时，会触发 CI 制作镜像并推送到镜像仓库

    - CI 处理完成后，可以手动或者自动修改应用配置，再将其推送到 git 仓库；

    - ArgoCD 会同时对比目标状态和当前状态，如果两者不一致会触发 CD 将新的配置部署到集群中

    - CD 部分：Argo CD 会被部署在 Kubernetes 集群中，使用的是基于 Pull 的部署模式，它会周期性地监控应用的实际状态，也会周期性地拉取 Git 仓库中的配置清单，并将实际状态与期望状态进行比较，如果实际状态不符合期望状态，就会更新应用的实际状态以匹配期望状态。

    ![image](./Pictures/kubernetes/ArgoCD流程.avif)

- 组件

    - API Server：是一个 gRPC/REST server，它公开 Web UI、CLI 以及一些其他场景需要用到的 API。
        - 应用程序管理和状态报告；
        - 调用应用程序操作（例如：同步、回滚、用户定义的操作）；
        - repository 和集群 credential 管理（存 K8s secrets）；
        - 身份验证和授权委托给外部身份认证组件；
        - RBAC（Role-based access control 基于角色的访问控制）；
        - Git webhook 事件的 listener/forwarder；

    - Repository Server：一个内部服务，它负责保存应用程序 Git 仓库的本地缓存，并负责生成和返回可供 Kubernetes 使用的 manifests，它接受的输入信息主要有以下内容：
        - 仓库地址（URL）
        - revision（commit, tag, branch）
        - 应用程序路径
        - 模板的特定设置：参数、ksonnet 环境、helm values.yaml

    - Application Controller：一个 Kubernetes controller，它持续监听正在运行的应用程序并将当前的实时状态与所需的目标状态（如 repo 中指定的）进行比较。它检测 OutOfSync 应用程序状态并有选择地采取纠正措施。它负责为生命周期事件（PreSync、Sync、PostSync）调用任何用户定义的 hooks。

##### 部署ArgoCD

```sh
# 创建namesapce
kubectl create namespace argocd
# 安装
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 查看
kubectl get pods --namespace=argocd -w

curl https://argocd.kubernets.cn -I
```

- 默认情况下argocd会暴露两个端口
    - 443 - gRPC/HTTPS
    - 80 - HTTP (redirects to HTTPS)
    - 如果配置的反向代理服务器不支持HTTP2可以考虑使用 `–grpc-web` 参数

- 获取 Argo CD 密码

    - 默认情况下 admin 帐号的初始密码是自动生成的，会以明文的形式存储在 Argo CD 安装的命名空间中名为 argocd-initial-admin-secret 的 `Secret` 对象下的 password 字段下

    ```sh
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    ```


- ingress配置文件
    ```sh
    # 应用配置文件
    kubectl apply -f argocd.k8s.local.yml

    # 查看
    kubectl get ingress -n argocd

    # 测试。??失败了
    curl argocd.k8s.local
    ```

- argocd的cli
    ```sh
    # archlinux安装argocd的cli
    pacman -S argocd

    # 获取初始密码
    argocd admin initial-password -n argocd

    # 取初始密码之后，我们可以使用初始账号admin和初始密码进行登录
    argocd login grpc.argocd.k8s.local

    # 然后进行密码的修改
    argocd account update-password
    ```

#### flux
#### 案例

##### 网易云音乐大量应用的部署流程

- 网易云音乐开发了 Horizon CD 平台，Horizon 基于 GitOps、ArgoCD 部署应用。通过 Horizon，开发者只需要在 Horizon 平台上创建应用，配置应用的参数，就可以完成应用的部署，并且也可以享受到 GitOps 带来的好处。

- 部署流程：

    - 开发者通过填写表单即可在 Horizon 上创建应用，表单中包含了应用的基本信息和部署信息，例如应用名称、应用描述、镜像地址、副本数、部署环境等。

    - Horizon 会为应用创建对应的 GitOps 仓库，并将用户输入以及其它创建应用必要的信息一并写入到 GitOps 仓库中。

        - GitOps 仓库中的每个分支对应不同的环境，方便管理多环境。用户可以根据以上创建的应用，创建对应的应用实例，应用实例对应 Kubernetes 中的一系列相关资源。

    - Horizon 会为该应用实例创建 GitOps 仓库和 ArgoCD Application。该 GitOps 仓库有两个 branch —— master 和 gitops。master 和 gitops 分支都存放了应用的配置。

    - 用户修改应用配置后，Horizon 会将修改记录到 gitops 分支中。

    - 用户发布应用时，Horizon 会将 gitops 分支合并到 master 分支中，并触发 ArgoCD 同步，将 GitOps 仓库中的配置应用到 Kubernetes 中。

    ![image](./Pictures/kubernetes/网易云音乐的HorizonCD部署流程.avif)

- 如果有人手动修改了 kubernetes 中相关资源或者修改了 GitOps 仓库但并未执行同步，ArgoCD 会感知到 master 分支配置与 kubernetes 中资源配置不一致，会将该应用标记为 `OutOfSync`，在 Horizon 上，用户也可以观察到该应用状态不正常，方便用户及时发现问题，并与 Horizon 管理员联系，及时排查解决。

- Horizon 依赖于 GitOps 仓库实现回滚

    - Horizon 的每次发布会在 master 分支生成一条 commit 记录，当用户需要回滚应用实例时，只需要找到当时的部署记录，即一条 Pipelinerun 记录，代表了一次流水线运行。

    - Horizon 通过该 Pipelinerun 记录找到对应的 commit 记录，然后将该记录之后的所有 commit 记录revert，最后触发 ArgoCD 的同步，这样就完成了一次回滚。

- Horizon 通过拓展 Helm Chart，设计了一套 Template 系统

    - Template包含三个部分：Helm Chart，JsonSchema，ReactJsonSchemaForm

    - Horizon 会通过 ReactJsonSchemaForm 渲染表单，获取用户输入，并使用 JsonSchema 验证用户输入，确认无误后，记录到 GitOps 仓库的相关文件中。

    - Horizon 管理员可以通过自定义 Template，实现部署各种类型的应用，非常灵活。

- `Chart.yaml` 文件是 Helm Chart 的标准，通过 dependency 字段，引用预先定义的 Horizon Template。

    ```yml
    apiVersion: v2
    name: demo
    version: 1.0.0
    dependencies:
      - name: deployment
        version: v0.0.1-ec06d596
        repository: https://horizon-harbor-core.horizon.svc.cluster.local/chartrepo/horizon-template
    ```

- `application.yaml` 包含了用户通过 ReactJsonSchemaForm 表单填写的数据。
    ```yml
    deployment:
      app:
        envs:
        - name: test
          value: test
        spec:
          replicas: 1
          resource: x-small
    ```

- `pipeline-output.yaml` 包含了 CI 阶段的输出，因为在 Horizon 中 CI 也是可以自定义的，所以该文件的内容也是不固定的。默认的 CI 脚本输出如下：

    ```yml
    deployment:
      image: library/demo:v1
      git:
        branch: master
        commitID: 28992d8f35a6ef38d59181080b3728df9540d8d6
        url: https://github.com/horizoncd/springboot-source-demo.git
    ```

    | 参数                 | 描述                                             |
    |----------------------|--------------------------------------------------|
    | .Values.image        | CI 阶段构建 image 的全路径                       |
    | .Values.git.{ref}    | 源代码仓库的引用类型，可以是 branch、tag、commit |
    | .Values.git.commitID | 构建代码的 commit ID                             |
    | .Values.git.url      | 源代码的引用链接                                 |

- `pipeline.yaml` 包含了 CI 阶段的配置信息，Horizon 管理员可以通过自定义 CI 以支持更多的构建类型

    ```yml
    pipeline:
      buildType: dockerfile
      dockerfile:
        path: ./Dockerfile
    ```

    | 参数                       | 描述                                 |
    |----------------------------|--------------------------------------|
    | .Values.buildType          | 该应用的构建类型，默认是“dockerfile” |
    | .Values.dockerfile.path    | dockerfile 相对于源代码仓库的路径    |
    | .Values.dockerfile.content | dockerfile 的内容                    |

- `sre.yaml` 包含了一些管理员配置，比如ingress、默认的超售比等等。使用 sre.yaml 文件修改管理员配置，既可以做到关注点分离，又保证了 GitOps 应用修改的体验统一。比如可以通过配置nodeAffinity，将应用部署到特定的节点上。SRE在修改sre.yaml后，也需要提交 PR 到 GitOps 仓库，并通过 review 机器人完成多人审核，合入到发布分支，最后在 Horizon 上执行发布，即可完成变更。

    ```yml
    deployment:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: cloudnative/demo
                operator: In
                values:
                - "true"
    ```

- system目录下的文件记录了部署的元信息

    - `env.yaml` 记录了部署环境相关的信息

        | 参数                      | 描述             |
        |---------------------------|------------------|
        | .Values.env.environment   | 环境名           |
        | .Values.env.region        | Kubernete 名     |
        | .Values.env.namespace     | Namespace        |
        | .Values.env.baseRegistry  | image 仓库的地址 |
        | .Values.env.ingressDomain | ingress 域名     |

    ```yml
    deployment:
      env:
        environment: local
        region: local
        namespace: local-1
        baseRegistry: horizon-harbor-core.horizon.svc.cluster.local
        ingressDomain: cloudnative.com
    ```

- `horizon.yaml` 包含了该应用在 Horizon 中的信息

    | 参数                             | 描述                                           |
    |----------------------------------|------------------------------------------------|
    | .Values.horizon.application      | 应用名                                         |
    | .Values.horizon.clusterID        | 集群ID（这里的集群指应用实例，应用为配置集合） |
    | .Values.horizon.cluster          | 集群                                           |
    | .Values.horizon.template.name    | 模板名                                         |
    | .Values.horizon.template.release | 模板版本                                       |
    | .Values.horizon.priority         | 优先级                                         |

- `restart.yaml` Horizon 通过修改该文件内容，重启所有 Pod

    | 参数                | 含义     |
    |---------------------|----------|
    | .Values.restartTime | 重启时间 |

    ```yml
    deployment:
      restartTime: "2023-01-06 18:28:49"
    ```

# 第三方软件资源

- [awesome-k8s-resources](https://github.com/tomhuang12/awesome-k8s-resources)

## 服务端

- [kubernetes-network-policy-recipes：只需复制粘贴即可解决 K8s 网络问题的配方。该项目包含了 Kubernetes 网络策略的各种用例和示例 YAML 文件，可直接复制使用。](https://github.com/ahmetb/kubernetes-network-policy-recipes)

- [pixie：性能监控](https://github.com/pixie-io/pixie)

- [kubesphere](https://github.com/kubesphere/kubesphere)

- [k0s](https://github.com/k0sproject/k0s)
  > k0s 是一个包含所有功能的单一二进制 Kubernetes 发行版，它预先配置了所有所需的 bell 和 whistle，使构建 Kubernetes 集群只需将可执行文件复制到每个主机并运行它即可。

  - [retina：K8s 网络可观测平台](https://github.com/microsoft/retina)

    - 微软开源的基于 eBPF 的云原生容器网络可观测性平台。它提供了一个集中查看、监控、分析应用和网络运行状况的中心平台，能够将收集的网络可观测性数据发送到 Prometheus 进行可视化，适用于调试 Pod 无法互连的问题、监控网络健康状况、收集遥测数据等场景。

- [像tcpdump那样管理](https://github.com/up9inc/mizu)

- [Tekton Pipelines：声明 CI/CD 样式管道的 k8s 样式资源]()

## 客户端

- [krew：kubectl的插件管理](https://github.com/kubernetes-sigs/krew)

    - [krew的插件列表](https://krew.sigs.k8s.io/plugins/)
    ```sh
    # 安装tree插件
    kubectl krew install tree

    # 使用tree
    kubectl tree


    # kubectx像git那样切换分支来管理集群
    kubectl krew install kubectx

    # 证书管理
    kubectl krew install cert-manager
    ```

- [k8sgpt](https://github.com/k8sgpt-ai/k8sgpt)

- [kubectx：像git那样切换分支](https://github.com/ahmetb/kubectx)

- [kubecolor：让kubectl的输出有颜色](https://github.com/hidetatz/kubecolor)

- [kube-shell：类似ipython的补全shell](https://github.com/cloudnativelabs/kube-shell)

- [Lens：k8s ide](https://github.com/lensapp/lens)
- [K8Studio：k8s ide](https://k8studio.io/)

- [k9s：tui管理pod](https://github.com/derailed/k9s)

- [plural：web ui](https://github.com/pluralsh/plural)

- [stern：pods日志追踪](https://github.com/stern/stern)
    ```sh
    # all namespaces
    stern . --all-namespaces

    # kube-system namespace
    stern . -n kube-system --tail 0
    ```

## 云原生

- [云原生应用市场](https://hub.grapps.cn/)

- [rust重写的云原生的项目](https://rust-cloud-native.github.io/)

- [automq-for-kafka](https://github.com/AutoMQ/automq-for-kafka)
    -  一款真正的云原生 Kafka 解决方案。该项目是基于云原生重新设计的新一代 Kafka 发行版。在保持和 Apache Kafka 100%兼容前提下，AutoMQ 可以为用户提供高达 10 倍的成本优势以及百倍的弹性优势，同时支持秒级分区迁移和流量自动重平衡，解决运维痛点。

# 在线网站工具

- [artifacthub：Find, install and publish Kubernetes packages](https://artifacthub.io/)

# 优秀文章

- [Kubernetes纪录片](https://www.bilibili.com/video/BV13q4y1h7QR)

- [图解儿童 Kubernetes 指南](https://www.cncf.io/the-childrens-illustrated-guide-to-kubernetes/)
- [关于 kubernetes 失败的故事](https://k8s.af/)

- [Unikernel(VM 容器融合技术),或许是下一代云技术](https://zhuanlan.zhihu.com/p/29053035)

- 目前可以使用 linuxkit 进行构建

- [mirageos](https://mirage.io/)

- [gvistor](https://mp.weixin.qq.com/s?src=11&timestamp=1613136113&ver=2886&signature=6e*T4ylvJCA--fGa-tb*ttJq3JArF7z-Wzs5eAPzlY813SG154AK1YyEgLv2MQSi7BUW8muQyHQnOl3arAu2m9qK8bCk2fgGLOv4-VYvAyWDfMUcBrvB8oZ9csaoQ-aI&new=1)

- [Docker and Kubernetes 完整开发指南](https://www.bilibili.com/read/cv21266100)

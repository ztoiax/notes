# Kubernetes

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

## 搭建本地Kubernetes集群

- [minikube：单机运行Kubernetes集群](https://github.com/kubernetes/minikube)

```sh
# 启动docker
sudo systemctl start docker

# 启动Kubernetes集群。会创建~/.minikube目录
minikube start --image-mirror-country='cn'
# 可以调整配置参数
minikube start --image-mirror-country='cn' --cpus=4 --memory=2048MB

# Dashboard管理界面
minikube dashboard

# 当前集群虚拟机的IP地址
minikube ip

# 通过kubectl命令行工具，找到Dashboard对应的Service对外暴露的端口
kubectl get service --namespace=kube-system
```

### nginx

- 创建了一个名为`nginx-deploymeht.yml`文件

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

### Prometheus Operator（简化在Kubernetes下部署和管理Prmetheus的复杂度）

# 第三方软件资源

- [pixie 性能监控](https://github.com/pixie-io/pixie)

- [kubesphere](https://github.com/kubesphere/kubesphere)

- [kube-shell](https://github.com/cloudnativelabs/kube-shell)

- [lazykube](https://github.com/TNK-Studio/lazykube)

- [lazykube 替换墙外镜像的下载地址](https://github.com/joyme123/lazykube)

- [helm 包管理器](https://github.com/helm/helm)

- [k0s](https://github.com/k0sproject/k0s)
  > k0s 是一个包含所有功能的单一二进制 Kubernetes 发行版，它预先配置了所有所需的 bell 和 whistle，使构建 Kubernetes 集群只需将可执行文件复制到每个主机并运行它即可。

- [像tcpdump那样管理](https://github.com/up9inc/mizu)

# 优秀文章

- [Kubernetes纪录片](https://www.bilibili.com/video/BV13q4y1h7QR)

- [图解儿童 Kubernetes 指南](https://www.cncf.io/the-childrens-illustrated-guide-to-kubernetes/)
- [关于 kubernetes 失败的故事](https://k8s.af/)

- [Unikernel(VM 容器融合技术),或许是下一代云技术](https://zhuanlan.zhihu.com/p/29053035)

- 目前可以使用 linuxkit 进行构建

- [mirageos](https://mirage.io/)

- [gvistor](https://mp.weixin.qq.com/s?src=11&timestamp=1613136113&ver=2886&signature=6e*T4ylvJCA--fGa-tb*ttJq3JArF7z-Wzs5eAPzlY813SG154AK1YyEgLv2MQSi7BUW8muQyHQnOl3arAu2m9qK8bCk2fgGLOv4-VYvAyWDfMUcBrvB8oZ9csaoQ-aI&new=1)

- [Docker and Kubernetes 完整开发指南](https://www.bilibili.com/read/cv21266100)

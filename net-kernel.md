
<!-- mtoc-start -->

* [OSI 7层](#osi-7层)
  * [应用层](#应用层)
    * [HTTP](#http)
      * [状态码](#状态码)
      * [客户端缓存（浏览器缓存）](#客户端缓存浏览器缓存)
      * [Cookie](#cookie)
      * [压缩算法](#压缩算法)
      * [HTTP1.1 keepalive](#http11-keepalive)
      * [HTTP2](#http2)
        * [HPACK（头部压缩）](#hpack头部压缩)
      * [HTTP3(Quic)](#http3quic)
        * [header](#header)
        * [窗口、流量控制，拥塞控制](#窗口流量控制拥塞控制)
      * [HTTP优化](#http优化)
      * [合并请求](#合并请求)
        * [合并请求 vs 并行请求](#合并请求-vs-并行请求)
    * [RPC](#rpc)
    * [WebSocket](#websocket)
      * [Websocket建立过程](#websocket建立过程)
      * [websocket报文格式](#websocket报文格式)
    * [DNS](#dns)
      * [基本概念](#基本概念)
      * [查询过程](#查询过程)
      * [DNS 的记录类型](#dns-的记录类型)
      * [arthurchiao：DNS 问题分析示例（2019）](#arthurchiaodns-问题分析示例2019)
      * [HTTPDNS：代替传统的基于UDP的DNS协议，域名解析请求直接发送到HTTPDNS服务端，从而绕过运营商的DNS](#httpdns代替传统的基于udp的dns协议域名解析请求直接发送到httpdns服务端从而绕过运营商的dns)
      * [knowclub：localhost和127.0.0.1的区别](#knowclublocalhost和127001的区别)
    * [CDN（Content Delivery Network）内容分发网络](#cdncontent-delivery-network内容分发网络)
      * [基于DNS解析](#基于dns解析)
      * [阿里的CDN架构Swift](#阿里的cdn架构swift)
    * [FTP](#ftp)
    * [DHCP](#dhcp)
      * [连接过程](#连接过程)
      * [地址分配](#地址分配)
      * [地址冲突](#地址冲突)
      * [地址回收](#地址回收)
    * [代理](#代理)
      * [Tachyon：漫谈各种黑科技式 DNS 技术在代理环境中的应用](#tachyon漫谈各种黑科技式-dns-技术在代理环境中的应用)
        * [各种代理的dns请求](#各种代理的dns请求)
        * [内置的dns模块](#内置的dns模块)
          * [基本配置](#基本配置)
          * [DNS outbound](#dns-outbound)
          * [Fake DNS](#fake-dns)
          * [DNS fallback](#dns-fallback)
  * [表示层](#表示层)
    * [密钥算法](#密钥算法)
    * [数字签名和数字证书](#数字签名和数字证书)
    * [tls](#tls)
      * [为什么我抓不到 baidu 的数据包？](#为什么我抓不到-baidu-的数据包)
      * [Session](#session)
    * [基于TLS1.3的微信安全通信协议mmtls介绍](#基于tls13的微信安全通信协议mmtls介绍)
  * [Session layer（会话层）](#session-layer会话层)
    * [RTP](#rtp)
  * [MTU 和 MSS 和 分段(fragmentation)](#mtu-和-mss-和-分段fragmentation)
    * [IPv4 Fragmentation （分段）](#ipv4-fragmentation-分段)
      * [MTU相关命令](#mtu相关命令)
      * [PMTU（只有TCP和UDP支持）](#pmtu只有tcp和udp支持)
        * [PMTU 与 GRE隧道](#pmtu-与-gre隧道)
        * [PMTU 与 IPv4sec](#pmtu-与-ipv4sec)
        * [PMTU 与 GRE 与 IPv4sec 协同工作](#pmtu-与-gre-与-ipv4sec-协同工作)
    * [MTU](#mtu)
    * [包的拆分与合并TSO、GSO、LRO、GRO](#包的拆分与合并tsogsolrogro)
  * [传输层](#传输层)
    * [TCP](#tcp)
      * [粘包问题](#粘包问题)
      * [header(头部)](#header头部)
        * [Header Compression(头部压缩)](#header-compression头部压缩)
      * [TCP 连接](#tcp-连接)
        * [TIME_WAIT相关](#time_wait相关)
        * [TCP端口、连接问题](#tcp端口连接问题)
      * [reset包](#reset包)
        * [鹅厂架构师：什么！TCP又发reset包？](#鹅厂架构师什么tcp又发reset包)
          * [两种RST包：active rst包；passive rst包](#两种rst包active-rst包passive-rst包)
          * [分析rst包](#分析rst包)
          * [案例分析](#案例分析)
        * [如何关闭一个 TCP 连接？](#如何关闭一个-tcp-连接)
      * [backlog队列、半队列、全队列](#backlog队列半队列全队列)
      * [Tcp keepalive（心跳）](#tcp-keepalive心跳)
        * [应用层心跳机制的必要性](#应用层心跳机制的必要性)
      * [TCP Fast Open（TFO）](#tcp-fast-opentfo)
        * [nginx支持](#nginx支持)
      * [重传与RTT、RTO](#重传与rttrto)
      * [延迟ACK](#延迟ack)
      * [TCP window(窗口、流量控制)](#tcp-window窗口流量控制)
        * [Nagle算法](#nagle算法)
      * [TCP congestion control(拥塞算法)](#tcp-congestion-control拥塞算法)
      * [socket相关](#socket相关)
    * [UDP](#udp)
      * [洋芋编程：如何实现可靠的 UDP ?](#洋芋编程如何实现可靠的-udp-)
    * [KCP](#kcp)
  * [Network Layer（网络层）](#network-layer网络层)
    * [ICMP](#icmp)
    * [ipv4和子网](#ipv4和子网)
      * [A、B、C、D、E（5类）地址](#abcde5类地址)
      * [如何判断哪些 IP 位于同一子网中？](#如何判断哪些-ip-位于同一子网中)
    * [VPN](#vpn)
    * [NAT](#nat)
    * [内网穿透](#内网穿透)
      * [UDP 内网穿透](#udp-内网穿透)
      * [TCP 内网穿透](#tcp-内网穿透)
  * [路由器与交换机](#路由器与交换机)
  * [Data Link layer(数据链路层)](#data-link-layer数据链路层)
    * [802.11 frame](#80211-frame)
    * [ARP](#arp)
      * [ARP表](#arp表)
      * [ARP攻击](#arp攻击)
  * [物理层](#物理层)
    * [qdisc（排队规则）](#qdisc排队规则)
      * [classless qdisc（无类别）](#classless-qdisc无类别)
      * [classful qdisc（有类别）](#classful-qdisc有类别)
  * [数据包流程](#数据包流程)
* [Overlay虚拟化技术](#overlay虚拟化技术)
  * [Vxlan（Virtual Extensible LAN）](#vxlanvirtual-extensible-lan)
    * [VTEP (VXLAN Tunnel Endpoint)](#vtep-vxlan-tunnel-endpoint)
      * [网络拓扑结构](#网络拓扑结构)
  * [GRE（Generic Routing Encapsulation）](#gregeneric-routing-encapsulation)
  * [MPLS（Multiprotocol Label Switching）](#mplsmultiprotocol-label-switching)
  * [SD-WAN（Software-Defined Wide Area Network）](#sd-wansoftware-defined-wide-area-network)
* [DPDK](#dpdk)
* [sysctl](#sysctl)
* [网络优化](#网络优化)
  * [洋芋编程：想要支持百万长连接，需要调优哪些参数？](#洋芋编程想要支持百万长连接需要调优哪些参数)
* [DDOS攻击](#ddos攻击)
  * [SYN flood (洪泛) 攻击](#syn-flood-洪泛-攻击)
  * [反射型攻击](#反射型攻击)

<!-- mtoc-end -->

# OSI 7层

> 本文采用自顶向下的讲解

![image](./Pictures/net-kernel/osi.avif)
![image](./Pictures/net-kernel/osi1.avif)
![image](./Pictures/net-kernel/osi2.avif)
![image](./Pictures/net-kernel/osi3.avif)

## 应用层

### HTTP

- [mozilla文档](https://developer.mozilla.org/zh-CN/docs/Web/HTTP)

- [视频：2分钟了解 HTTP Verbs](https://www.bilibili.com/video/BV1DS4y187Ux)
    - 安全性：`GET`
    - 幂等性：`GET`、`DELETE`
    - 缓存性：`GET`、`POST`、`PATCH`

- [小林coding：HTTP 常见面试题](https://www.xiaolincoding.com/network/2_http/http_interview.html)

- [腾讯技术工程：了解 HTTP 看这一篇就够](https://cloud.tencent.com/developer/article/2083715)

- [陶辉：HTTP性能极限优化](https://www.taohui.tech/2020/01/08/%E7%BD%91%E7%BB%9C%E5%8D%8F%E8%AE%AE/http%E6%80%A7%E8%83%BD%E6%9E%81%E9%99%90%E4%BC%98%E5%8C%96/)

- [杰瑞春：老师不会教你的，http协议在万维网世界中的一生！](https://www.bilibili.com/video/BV1Ee4y1c7Wq)

- [技术蛋老师视频：HTTP/1.1，HTTP/2和HTTP/3的区别](https://www.bilibili.com/video/BV1vv4y1U77y)

![image](./Pictures/net-kernel/http.avif)

#### 状态码

- `1xx`：
    - `100 Continue`：继续

客户端已接收部分请求，并准备好接收剩下的部分，请求者需要继续提出请求。
    - `101 Switching Protocol`： 协议转换，比方说升级为`websocket`
    - `102 Processing`：webdav扩展的状态码，表示处理将会继续执行

- `2xx`：

    - `200 OK`：请求成功。服务器已成功处理了请求，可以正常打开网页啦（或者请求的文件）。
    - `201 Created`：成功创建资源，一般用于`POST`、`PUT`
    - `202 Accepted`：请求已经接受，但未被实时处理，最终有可能拒绝
    - `203 Non-Authoritative Information`：非授权信息。请求成功。但返回的实体头元信息不在原始服务器，而是第三方的一个副本或本地。
    - `204 No Content`：没有内容（body）。服务器处理了请求，但不返回内容。在未更新网页的情况下，浏览器继续显示当前页面。
    - `205 Reset Content`：重置内容。服务器处理了请求，但不返回内容。客户端重置文档视图。
    - `206 Partial Content`：部分内容。分块下载和断点续传，在客户端发送“范围请求”、要求获取资源的部分数据时出现，它与 200 一样，也是服务器成功处理了请求，但 body 里的数据不是资源的全部，而是其中的一部分。

        - `Accept-Ranges` （它的值不为“none”），那么表示该服务器支持范围请求。

        - 还会伴随着头字段`Content-Range`，表示响应报文里 body 数据的具体范围，供客户端确认，例如`Content-Range：bytes 0-99/2000`，意思是此次获取的是总计 2000 个字节的前 100 个字节。

        ```sh
        curl http://www.example.com -i -H "Range: bytes=0-50, 100-150"
        ```
    - `207 Multi-Status`：webdav扩展的状态码，表示消息体是xml，并且可能根据之前的请求数量，包含一些响应代码

- `3××`：

    - `300 Multiple Choices`：多重选择。被请求的资源有一系列可供选择的信息
    - `301 Moved Permanently`：永久移动。含义是此次请求的资源已经不存在了，需要改用改用新的 URI 再次访问。

    - `302 Found`：临时移动。意思是请求的资源还在，但需要暂时用另一个 URI 来访问。

        - 例子：访问`www.bing.com` 会出现`302`，重定向到`cn.bing.com`

    - `303 See other`：当前请求可以在另一个url上被找到，客户端应该采取get的方式访问该资源
    - `304 Not Modified`：它用于 `If-Modified-Since` 和`If-None-Match` 请求，表示资源未修改，用于缓存控制。它不具有通常的跳转含义，但可以理解成“重定向已到缓存的文件”（即“缓存重定向”）。
    - `305 Use proxy`：使用代理
    - `306 Switch proxy`：该状态码，已经被抛弃
    - `307 Temporary Redirect`：临时重定向。请求资源临时从不同的url响应请求
    - `308 Permanent Redirect`：永久重定向。请求资源临时永久移动到新的url

- `4××`：客户端问题

    - `400 Bad Request`：客户端的请求语法出错，服务器端无法理解。

    - `401 Authorization Required`：（未经授权）服务器要求客户端进行身份验证。需要用户密码认证。比如nginx对资源，设置了auth_basic模块

    - `402 Payment Required`：预留状态码
    - `403 Forbidden`：服务器理解了你的请求，但是拒绝执行。
    - `404 Not Found`：服务器无法找到用户请求的文档

        - 网页数据被更改、或者上传到网页的文件目录/文件名称被更改，导致网页失效。
        - 网页文件被移动或删除，导致原链接失效。
        - 我们自己输入的网址有错误，不能链接到所需的文件。
        - 你压根没插网线或者家里Wi-Fi信号太差。


- `5xx` ：服务端问题
    - 一般情况下5xx的状态码其实并不是服务器返回给客户端的。它们是由网关返回的，常见的网关，比如nginx。
    - `500 Internal Server Error`：内部服务器错误。可能是服务器的程序码出错。
    - `501 Not Implemented`：服务器不支持请求功能
    - `502 Bad Gateway`：其实是由网关代理（nginx）发出的，是因为网关代理把客户端的请求转发给了服务端，但服务端却发出了无效响应
        - 这里的无效响应，一般是指TCP的RST报文或四次挥手的FIN报文。

#### 客户端缓存（浏览器缓存）

- [Se7en的架构笔记：Nginx缓存详解（一）之客户端缓存](https://mp.weixin.qq.com/s/v4oI6KO4M2bNNKI91ioUvg)

- 浏览器缓存可以分为两种模式，强缓存和协商缓存。

    - 1.强缓存（无HTTP请求，无需协商）

        - 直接读取本地缓存，无需向服务端发送请求确认，HTTP返回状态码是200（from memory cache或者from disk cache ，不同浏览器返回的信息不一致的）。

        - 相关的HTTP Header有:
            - `Cache-Control`
            - `Expires`

    - 2.协商缓存（有HTTP请求，需协商）

        - 浏览器虽然发现了本地有该资源的缓存，但是缓存已经过期，于是向服务器询问缓存内容是否还可以使用，若服务器认为浏览器的缓存内容还可用，那么便会返回304（Not Modified）HTTP状态码，告诉浏览器读取本地缓存；如果服务器认为浏览器的缓存内容已经改变，则返回新的请求的资源。

        - 相关的HTTP Header有:

            - `Last-Modified`
            - `ETag`

- 缓存校验流程

    - 由于网站内容的经常变化，为了保持缓存的内容与网站服务器的内容一致
        - 客户端会通过内容缓存的有效期（强制缓存）
        - Web服务器提供的访问请求的校验（协商缓存），快速判断请求的内容是否已经更新。

        ![image](./Pictures/net-kernel/缓存-客户端缓存校验流程图.avif)

- 强制缓存原理：浏览器在加载资源的时候，会先根据本地缓存资源的header中的信息(Expires 和 Cache-Control)来判断缓存是否过期。如果缓存没有过期，则会直接使用缓存中的资源；否则，会向服务端发起协商缓存的请求。

    - 客户端判断缓存是否过期和先前请求时服务端返回的HTTP消息头字段有关：

        | 服务端返回字段           | 作用                                                                                                                                                                               |
        |--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
        | Cache-Control: max-age=x | 客户端缓存时间超出x秒后则缓存过期。                                                                                                                                                |
        | Cache-Control: no-cache  | 客户端不能直接使用本地缓存的响应，需要进行协商缓存，发送请求到服务器确认是否可以使用缓存。如果Web服务器返回304，则客户端使用本地缓存，如果返回200，则使用Web服务器返回的新的数据。 |
        | Cache-Control: no-store  | 客户端不能对响应进行缓存。                                                                                                                                                         |
        | Cache-Control: public    | 可以被所有的用户缓存，包括终端用户和 CDN 等中间代理服务器。                                                                                                                        |
        | Cache-Control:private    | 只能被终端用户的浏览器缓存，不允许 CDN 等中继缓存服务器对其缓存。                                                                                                                  |
        | expires x                | 客户端缓存时间超出x秒后则缓存过期，优先级比Cache-Control: max-age=x低。                                                                                                            |
- 协商缓存原理：

    - 当客户端向服务端发起请求时，服务端会检查请求中是否有对应的标识（`If-Modified-Since`或`Etag`），如果没有对应的标识，服务器端会返回标识给客户端，客户端下次再次请求的时候，把该标识带过去，然后服务器端会验证该标识
        - 如果验证通过了，则会响应304，告诉浏览器读取缓存。
        - 如果标识没有通过，则返回请求的资源。

    - `Last-Modified`(Response Header)与`If-Modified-Since`(Request Header)是一对报文头，属于HTTP/1.0：

        - 当带着If-Modified-Since头访问服务器请求资源时，服务器会检查Last-Modified
            - 如果Last-Modified的时间早于或等于If-Modified-Since则会返回一个不带主体的304响应
            - 否则将重新返回资源。

        - 注意：在 Chrome 的 devtools中勾选 `Disable cache` 选项后，发送的请求会去掉If-Modified-Since这个 Header。

    - `ETag`(Response Header)与`If-None-Match`(Request Header)是一对报文头。属于HTTP/1.1：优先级高于Last-Modified的验证

        ![image](./Pictures/net-kernel/http_cache_etag.avif)

        - Etag类似于身份指纹，是一个可以与Web资源关联的记号。当客户端第一次发起请求时，Etag的值在响应头中传递给客户端；当客户端再次发起请求时，如果验证完本地内容缓存后需要发起服务端验证，Etag的值将由请求消息头的If-None-Match字段传递给服务端。
            - 如果服务端验证If-None-Match的值与服务端的Etag值不匹配，则认为请求的内容已经更新，服务端将会返回新的内容
            - 否则返回响应状态码304，客户端将使用本地缓存。

- 用户行为对浏览器缓存的影响

    - 当按下F5或者刷新时，客户端浏览器会添加请求消息头字段Cache-Control: max-age=0，该请求不进行内容缓存的本地验证，会直接向Web服务器发起请求，服务端根据If-Modified-Since或者If-None-Match的值进行验证。

    - 当按下Ctrl+F5或者强制刷新时，客户端浏览器会添加请求消息头字段Cache-Control: no-cache，并且忽略所有服务端验证的消息头字段(Etag和Last-Modified)，该请求不进行内容缓存的本地验证，它会直接向Web服务器发起请求，因为请求中没有携带服务端验证的消息头字段，服务端会直接返回新的内容。

- Cache-Control字段在请求和响应中的含义

    - 客户端请求
        - `max-age`：不想要在代理服务器中缓存了太长时间(>max-age seconds)的资源。
        - `max-stale`：可以接收代理服务器上的过期缓存。若max-stable后没有值，则表示无论过期多久客户端都可以使用。
        - `min-fresh`：要求服务器使用其缓存时，至少保证在min-fresh秒内不会过期。
        - `no-cache`：告诉代理服务器，不能直接使用已有缓存作为响应返回，除非带着缓存条件到上游服务端得到 304 验证返回码才可使用现有缓存。
        - `no-store`：告诉各代理服务器不得缓存这个请求及其相应。
        - `no-transform`：告诉代理服务器不要修改消息包体的内容。
        - `only-if-cached`：告诉代理服务器仅能返回缓存，没有缓存的话就返回 504。

    - 服务端响应
        - `max-age`：告诉客户端缓存 Age 超出 max-age 秒后则缓存过期。
        - `s-maxage：`与max-age相似，但仅针对共享缓存，且优先级高于max-age和Expires。
        - `public`：可以被所有的用户缓存，包括终端用户和 CDN 等中间代理服务器。
        - `private`：只能被终端用户的浏览器缓存，不允许 CDN 等中继缓存服务器对其缓存。
        - `no-store`：告诉所有下游节点不能对响应进行缓存。
        - `no-cache`：告诉客户端不能直接使用缓存的响应，使用前必须在源服务器验证得到304返回码。
        - `no-transform`：告诉代理服务器不能修改消息包体的内容。
        - `must-revalidate`：告诉客户端一旦缓存过期，必须向服务器验证后才可使用。
        - `proxy-revalidate`：与 must-revalidate 类似，但它仅对代理服务器的共享缓存有效。

- `X-Cache-Lookup:`：

    - `Hit From MemCache`：命中CDN节点的内存
    - `Hit From Disktank`：命中CDN节点的硬盘
    - `Hit From Upstream`：没有命中

- 缓存位置：

    - 优先级：Service Worker -> Memory Cache -> Disk Cache -> Push Cache

    - Chrome 的DevTools Network可以看到`Memory Cache`（內存缓存）和`Disk Cache`（硬盘缓存）

#### Cookie

- [技术蛋老师视频：cookie、localStorage 和 sessionStorage的区别及应用实例 - JavaScript前端Web工程师](https://www.bilibili.com/video/BV1SL4y1i7ZL)

- [技术蛋老师视频：Cookie、Session、Token究竟区别在哪？如何进行身份认证，保持用户登录状态？](https://www.bilibili.com/video/BV1ob4y1Y7Ep)

- 过期时间：

    - `Expires`：绝对时间

    - `max-age`：相对时间，单位为秒。

    - `Expires` 和 `max-age` 同时存在时优先使用`max-age`。

        - 如果服务器不设置`max-age`、`Expries`或者字段值为0指不能缓存cookie，但在会话期间是可用的，浏览器会话关闭之前可以用cookie记录用户的信息。

- 作用域：

    - `Domain`和`Path`指定了 Cookie 所属的域名和路径，浏览器在发送 Cookie 前会从 URI 中提取出 host 和 path 部分，对比 Cookie 的属性。如果不满足条件，就不会在请求头里发送 Cookie。

        - Domain=mozilla.org，则 Cookie 也包含在子域名中（如developer.mozilla.org）

        - Path (“/”) 作为路径分隔符，并且子路径也会被匹配

- 安全性

    - `HttpOnly`表示此 Cookie 只能通过浏览器 HTTP 协议传输，禁止其他方式访问。这也是预防“跨站脚本”（XSS）攻击的有效手段。

    - `SameSite`可以防范“跨站请求伪造”（XSRF）攻击

        - SameSite = strict表示禁止cookie在跳转链接时跨域传输

        - SameSite = lax稍微宽松一点，允许在GET、HEAD等安全请求方式中跨域携带。

            - 如果没有设置 SameSite 属性，则将 cookie 视为 Lax

        - 默认值为none，表示不限制cookie的携带和传输。

            - 必须设置 `Secure` 属性

    - `Secure`表示这个cookie仅能用HTTPS协议加密传输，明文的HTTP协议会禁止发送。但Cookie本身不是加密的，浏览器里还是以明文的形式存在。

#### 压缩算法

![image](./Pictures/net-kernel/http_compression.avif)

#### HTTP1.1 keepalive

- http短连接

    ![image](./Pictures/net-kernel/http_short_connect.avif)

- http keepalive（长连接）

    - 如果要关闭 HTTP Keep-Alive，需要在 HTTP 请求或者响应的 header 里添加 `Connection:close`

    ![image](./Pictures/net-kernel/http_keepalive.avif)


#### HTTP2

- [李银城：从Chrome源码看HTTP/2](https://zhuanlan.zhihu.com/p/34662800)

- [小林coding：HTTP/2 牛逼在哪？](https://www.xiaolincoding.com/network/2_http/http2.html)

- Frame header：

    ![image](./Pictures/net-kernel/http2_header.avif)

    - Frame有多种类型

        ![image](./Pictures/net-kernel/http2_frame-type.avif)

    - 帧数据：存放HPACK 算法压缩后的 HTTP 头部和包体


- 1个stream可以包含多个message；1个message可以包含多个Frame

    ![image](./Pictures/net-kernel/http2_stream.avif)

- 多路服用：

    ![image](./Pictures/net-kernel/http2_vs_http1.1.avif)

- 只有1个tcp连接

    - 在 HTTP/1.1 版本中，访问不同的的资源时 (CSS, Javascript, images ...) 会使用多个 TCP 连接会产生大量的延迟
        ![image](./Pictures/net-kernel/HTTP1.1访问时的瀑布图.avif)

    - 解决方案也很简单：直接升级使用 HTTP/2, 在整个通信过程中，只会有 1 个 TCP 连接。
        ![image](./Pictures/net-kernel/HTTP2访问时的瀑布图.avif)

        - 缺点：TCP丢包带来的影响在 HTTP/2 中表现更为严重，因为 HTTP/2 只使用 1 个 TCP 连接进行传输。所以 1 次丢包会导致所有的资源下载速度变慢。而 HTTP/1.1 可能有多个独立的 TCP 连接，1 次丢包也只会影响其中 1 个 TCP 连接，所以这种场景下 HTTP/1.1 反而会获得更好的性能。

- 全面采用二进制：收到报文后，无需再将明文的报文转成二进制，而是直接解析二进制报文


- 服务器推送：客户端在访问 HTML 时，服务器可以直接主动推送 CSS 文件，减少了消息传递的次数

    - client的请求使用的是奇数号 Stream；server主动的推送，使用的是偶数号 Stream，并使用 `PUSH_PROMISE` 帧传输 HTTP 头部，并通过帧中的 `Promised Stream ID` 字段告知客户端，接下来会在哪个偶数号 Stream 中发送包体。

    ![image](./Pictures/net-kernel/http2_serverpush.avif)

    ```nginx
    # nginx配置：客户端访问 /test.html 时，服务器直接推送 /test.css
    location /test.html {
        http2_push /test.css;
    }
    ```

##### HPACK（头部压缩）

- 客户端和服务器各自维护一份“索引表”，压缩和解压缩就是查表和更新表的操作。还釆用哈夫曼编码来压缩整数和字符串。

    ![image](./Pictures/net-kernel/HAPCK.avif)

- 新增的头字段或者值保存在动态表（Dynamic Table）里，它添加在静态表后面，结构相同，但会在编码解码的时候随时更新。

    - 比如说，第一次发送请求时的“user-agent”字段长是一百多个字节，用哈夫曼压缩编码发送之后，客户端和服务器都更新自己的动态表，添加一个新的索引号“65”。那么下一次发送的时候就不用再重复发那么多字节了，只要用一个字节发送编号就好。

    ![image](./Pictures/net-kernel/HPACK-Dynamic-Table.avif)

#### HTTP3(Quic)

- [（视频）技术蛋老师：QUIC核心原理和握手过程](https://www.bilibili.com/video/BV1Mg411s7mP)

- [小林coding：如何基于 UDP 协议实现可靠传输？](https://www.xiaolincoding.com/network/3_tcp/quic.html)

- [腾讯技术工程：HTTP/3 原理实战](https://cloud.tencent.com/developer/article/1634011)

    - 讲述了QUIC的优点，比另外两篇文章要好一些[《一文读懂 HTTP/1HTTP/2HTTP/3》](https://cloud.tencent.com/developer/article/1580468)和[科普：QUIC 协议原理分析](https://cloud.tencent.com/developer/article/1017235)

- [交互式解释Quic每个步骤](https://quic.xargs.org/)

- HTTP1 和 HTTP2 协议，TCP 和 TLS 是分层的。HTTP3 的 QUIC 协议并不是与 TLS 分层，而是QUIC 内部包含了 TLS，它在自己的帧会携带 TLS 里的“记录”。在第二次连接的时候：连接信息 + TLS 信息 + 数据一起发送（0RTT）

    ![image](./Pictures/net-kernel/quic_handshake.avif)

##### header

![image](./Pictures/net-kernel/quic_header.avif)

- Packet Header分为两种：

    ![image](./Pictures/net-kernel/quic_header-packet.avif)

    - `Long Packet Header` 首次连接：三次握手，协商连接ID

        - 当移动设备的网络从 4G 切换到 WIFI 时，意味着 IP 地址变化了，那么就必须要断开连接，然后重新建立 TCP 连接。QUIC 协议没有用四元组的方式来“绑定”连接，而是通过`连接ID`来标记通信的两个端点，达到了连接迁移的功能。

    - `Short Packet Header` 传输数据：

        - `Packet Number` 是独一无二的编号，严格递增的（即使是重传的包）：

            - 解决了tcp重传RTT计算歧义的问题：

                tcp：![image](./Pictures/net-kernel/TCP_rtt.avif)
                quic：![image](./Pictures/net-kernel/quic_rtt.avif)

            - 配合Frame Header里的 `Stream ID` 与 `Offset`字段，可实现乱序确认。tcp窗口滑动需要按顺序确认，丢包就无法滑动

                tcp发送窗口阻塞：
                ![image](./Pictures/net-kernel/TCP_headblocked_sendwindow.avif)

                tcp接受窗口阻塞：如果收到第 33～40 字节的数据，由于第 32 字节数据没有收到， 接收窗口无法滑动
                ![image](./Pictures/net-kernel/TCP_headblocked_recvwindow.avif)

                http2 复用tcp的队头阻塞：

                ![image](./Pictures/net-kernel/TCP_headblocked_http2.avif)

                quic 每条Stream ID都有自己的滑动窗口：但同一个 Stream 的数据要保持顺序，不然也会造成窗口无法滑动

                ![image](./Pictures/net-kernel/TCP_headblocked_quic.avif)


- Frame Header：

    - Packet 可以有多个Frame。每一种Frame类型的格式都不同

        ![image](./Pictures/net-kernel/quci_header-frame.avif)

    - stream类型（http请求）的frame格式：

        ![image](./Pictures/net-kernel/quci_header-frame-stream.avif)

        - `Stream ID`：多路复用，类似http2
        - `Offset`：类似 TCP 的 Seq 序列号，保证数据的顺序性和可靠性
        - `Length`：Frame 的长度。

    - `window_update`类型：告诉对方，自己的接受窗口的字节数

    - `BlockFrame` 类型：告诉对方，被阻塞了无法发送数据

##### 窗口、流量控制，拥塞控制

- Stream 级别的流量控制：每条stream都有自己的滑动窗口互相独立，队头的 Stream A 被阻塞后，不妨碍 StreamB、C的读取；但同一个 Stream 的数据要保持顺序，不然也会造成窗口无法滑动

    接收窗口的左边界滑动条件取决于接收到的最大偏移字节数：
    ![image](./Pictures/net-kernel/quic_window-stream.avif)

    接收窗口右边界触发的滑动条件：绿色部分数据超过最大接收窗口的一半后，最大接收窗口和接受窗口向右移动，同时给对端发送`window_update` frame；发送方收到后，发送窗口的右边界也向右移动
    ![image](./Pictures/net-kernel/quic_window-stream1.avif)

- Connection 流量控制：所有 Stream 窗口相加的总字节数

    ![image](./Pictures/net-kernel/quic_window-connection.avif)

- 拥塞控制：默认使用了Cubic

    - QUIC 处于应用层：可以针对不同的应用设置不同的拥塞控制算法；升级算法不像tcp那样需要更新内核。

#### HTTP优化

- 代理服务器减少http重定向请求：

    优化前：
    ![image](./Pictures/net-kernel/http_optimization_requests.avif)

    重定向由代理服务器完成：
    ![image](./Pictures/net-kernel/http_optimization_requests1.avif)

    代理服务器制定好重定向规则：
    ![image](./Pictures/net-kernel/http_optimization_requests2.avif)

#### 合并请求

- 多个图片合并为一张雪碧图：

    ![image](./Pictures/net-kernel/http_sprite-image.avif)

    - 问题：无法使用`hover`（鼠标悬浮）功能

- `webpack` 等打包工具将 js、css 等资源合并打包成大文件

- 将图片的二进制数据用 `base64` 编码后，以 URL 的形式嵌入到 HTML 文件`<image src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAPoAAAFKCAIAAAC7M9WrAAAACXBIWXMAA ... /> `

##### 合并请求 vs 并行请求

- [《React进阶之路》作者：合并HTTP请求 vs 并行HTTP请求，到底谁更快？](https://segmentfault.com/a/1190000015665465)

- [腾讯技术工程：HTTP 请求之合并与拆分技术详解](https://cloud.tencent.com/developer/article/1837260)

    - 拆分的多个小请求耗时仍大于合并的请求

### RPC

- [小林coding：既然有 HTTP 协议，为什么还要有 RPC？](https://www.xiaolincoding.com/network/2_http/http_rpc.html)

- RPC（Remote Procedure Call），又叫做远程过程调用。它本身并不是一个具体的协议，而是一种调用方式。

    - RPC可以像调用本地方法那样调用远端方法

    - 举个例子，我们平时调用一个本地方法就像下面这样。
        ```
        res = localFunc(req)
        ```

    - 基于这个思路，大佬们造出了非常多款式的RPC协议，比如比较有名的`gRPC`，`thrift`。

        - 虽然大部分RPC协议底层使用TCP，但实际上它们不一定非得使用TCP，改用UDP或者HTTP，其实也可以做到类似的功能。

        - gRPC底层用的是HTTP2

- HTTP和RPC

    - HTTP是browser/server(b/s)架构：浏览器（browser），不管是chrome还是IE，它们不仅要能访问自家公司的服务器（server），还需要访问其他公司的网站服务器，因此它们需要有个统一的标准，不然大家没法交流。

    - RPC是client/server (c/s)架构：现在电脑上装的各种联网软件，比如xx管家，xx卫士，它们都作为客户端（client）需要跟服务端（server）建立连接收发消息，可以使用自家造的RPC协议，因为它只管连自己公司的服务器就ok了。

    - HTTP主要用于b/s架构，而RPC更多用于c/s架构。但现在其实已经没分那么清了，b/s和c/s在慢慢融合。

        - 很多软件同时支持多端，比如某度云盘，既要支持网页版，还要支持手机端和pc端，如果通信协议都用HTTP的话，那服务器只用同一套就够了。而RPC就开始退居幕后，一般用于公司内部集群里，各个微服务之间的通讯。

        - 问题：都用HTTP得了，还用什么RPC？那这就要从它们之间的区别开始说起。

- HTTP和RPC区别比较明显的几个点

    - 1.服务发现

        > 首先要向某个服务器发起请求，你得先建立连接，而建立连接的前提是，你得知道IP地址和端口。这个找到服务对应的IP端口的过程，其实就是服务发现。

        - HTTP：你知道服务的域名，就可以通过DNS服务去解析得到它背后的IP地址，默认80端口。

        - RPC：就有些区别，一般会有专门的中间服务去保存服务名和IP信息
            - 比如consul或者etcd，甚至是redis。想要访问某个服务，就去这些中间服务去获得IP和端口信息。
            - 由于dns也是服务发现的一种，所以也有基于dns去做服务发现的组件，比如CoreDNS。

        - 可以看出服务发现这一块，两者是有些区别，但不太能分高低。

    - 2.底层连接形式

        - HTTP1.1：其默认在建立底层TCP连接之后会一直保持这个连接（keep alive），之后的请求和响应都会复用这条连接。

        - RPC：也跟HTTP类似，也是通过建立TCP长链接进行数据交互，但不同的地方在于，RPC协议一般还会再建个连接池，在请求量大的时候，建立多条连接放在池内，要发数据的时候就从池里取一条连接出来，用完放回去，下次再复用，可以说非常环保。
            ![image](./Pictures/net-kernel/RPC连接池.avif)

            - 由于连接池有利于提升网络请求性能，所以不少编程语言的网络库里都会给HTTP加个连接池，比如go就是这么干的。

        - 可以看出这一块两者也没太大区别，所以也不是关键。

    - 3.传输的内容

        > 基于TCP传输的消息，说到底，无非都是消息头header和消息体body。

        - HTTP1.1：支持音频视频，但HTTP设计初是用于做网页文本展示的，所以它传的内容以字符串为主。header和body都是如此。在body这块，它使用json来序列化结构体数据。
            - 像header里的那些信息，其实如果我们约定好头部的第几位是content-type，就不需要每次都真的把`content-type`这个字段都传过来，类似的情况其实在body的json结构里也特别明显。

        - RPC：因为它定制化程度更高
            - 可以采用体积更小的protobuf或其他序列化协议去保存结构体数据
            - 同时也不需要像HTTP那样考虑各种浏览器行为，比如302重定向跳转啥的。
            - 因此性能也会更好一些，这也是在公司内部微服务中抛弃HTTP，选择使用RPC的最主要原因。
        ![image](./Pictures/net-kernel/http原理.avif)
        ![image](./Pictures/net-kernel/RPC原理.avif)

        - 当然上面说的HTTP，其实特指的是现在主流使用的HTTP1.1，HTTP2在前者的基础上做了很多改进，所以性能可能比很多RPC协议还要好，甚至连gRPC底层都直接用的HTTP2。

            - 为什么既然有了HTTP2，还要有RPC协议？这个是由于HTTP2是2015年出来的。那时候很多公司内部的RPC协议都已经跑了好些年了，基于历史原因，一般也没必要去换了。

### WebSocket

- [ruanyifeng:WebSocket 教程](https://www.ruanyifeng.com/blog/2017/05/websocket.html)

- [Se7en的架构笔记:Nginx Websocket 配置](https://mp.weixin.qq.com/s/aN3-JHd-iPhHjUKQlc_Rzw)

- [小林coding：既然有 HTTP 协议，为什么还要有 WebSocket？](https://www.xiaolincoding.com/network/2_http/http_websocket.html)

    - http的缺点：服务器从来就不会主动给客户端发一次消息

    - 1.http定时轮询：

        - 网页的前端代码里不断定时发 HTTP 请求到服务器，服务器收到请求后给客户端响应消息

            - 例子：扫码登录。前端网页根本不知道用户扫没扫，于是不断去向后端服务器询问，看有没有人扫过这个码。

                ![image](./Pictures/net-kernel/http定时轮询.avif)

                - 点击[微信公众号官网](https://mp.weixin.qq.com/)，打开F12会发现每隔2秒发送一次请求

                    ![image](./Pictures/net-kernel/http定时轮询1.avif)

                    - 缺点：用户会感到明显的卡顿


    - 2.http长轮询：

        > HTTP请求发出后，一般会给服务器留一定的时间做响应，比如3s，规定时间内没返回，就认为是超时。如果我们的HTTP请求将超时设置的很大，比如30s，在这30s内只要服务器收到了扫码请求，就立马返回给客户端网页。如果超时，那就立马发起下一次请求。

        - 优点：相比http定时轮询可以减少请求次数。每隔30秒，在这 30 秒内只要服务器收到了扫码请求，就立马返回给客户端网页。

            ![image](./Pictures/net-kernel/http长轮询.avif)

            - 例子：百度网盘的扫码登陆

                ![image](./Pictures/net-kernel/http长轮询1.avif)

        - 常用的消息队列RocketMQ中，消费者去取数据时，也用到了这种方式。

    - 上面提到的2种解决方案，本质上，其实还是客户端主动去取数据。

        - 对于像扫码登录这样的简单场景还能用用。但如果是网页游戏呢，游戏一般会有大量的数据需要从服务器主动推送到客户端。这就得说下websocket了。

- 和 Http 相比，WebSocket有以下优点:

    - 全双工：
        - WebSocket 是双向通信协议，可以双向发送或接受信息。
        - HTTP是单向的，只能由客户端发起请求时，服务器才能响应，服务器不能主动向客户端发送数据。

    - WebSocket 可以和 HTTP Server 共享相同端口。
    - WebSocket 协议可以更好的支持二进制，可以直接传送二进制数据。
    - 同时WebSocket协议的头部非常小，服务器发到客户端的数据包的包头，只有2~10个字节(取决于数据包的长度)，客户端发送服务端的包头稍微大一点，因为其要进行掩码加密，所以还要加上4个字节的掩码。总得来说，头部不超过14个字节。
    - 支持扩展，用户可以扩展协议实现自己的子协议。

- websocket应用场景：

    > 适用于需要服务器和客户端（浏览器）频繁交互的大部分场景。

    - 网页/小程序游戏
        - 怪物移动以及攻击玩家的行为是服务器逻辑产生的，对玩家产生的伤害等数据，都需要由服务器主动发送给客户端，客户端获得数据后展示对应的效果。
    - 网页聊天室
    - 一些类似飞书这样的网页协同办公软件。

#### Websocket建立过程

- websocket和HTTP一样都是基于TCP的协议。经历了三次TCP握手之后，利用HTTP协议升级为websocket协议。

    ![image](./Pictures/net-kernel/websocket.avif)

- 客户端: 申请协议升级

    - 首先由客户端发起协议升级请求, 根据WebSocket协议规范, 请求头必须包含如下的内容：
    ```
    GET / HTTP/1.1
    Host: localhost:8080
    Origin: http://127.0.0.1:3000
    Connection: Upgrade
    Upgrade: websocket
    Sec-WebSocket-Version: 13
    Sec-WebSocket-Key: w4v7O6xFTi36lq3RNcgctw==
    ```

    - 请求行: 请求方法必须是GET, HTTP版本至少是1.1。
    - 请求必须含有Host。
    - 如果请求来自浏览器客户端, 必须包含Origin。
    - 请求必须含有 Connection, 其值必须含有 "Upgrade" 记号。
    - 请求必须含有 Upgrade, 其值必须含有 "websocket" 关键字。
    - 请求必须含有 Sec-Websocket-Version, 其值必须是 13。
    - 请求必须含有 Sec-Websocket-Key, 用于提供基本的防护, 比如无意的连接。

    - 这些header头的意思是，浏览器想升级协议（Connection: Upgrade），并且想升级成websocket协议（Upgrade: websocket）。

    - 同时带上一段随机生成的base64码（`Sec-WebSocket-Key`），发给服务器。

        - 如果服务器正好支持升级成websocket协议。就会走websocket握手流程，同时根据客户端生成的base64码，用某个公开的算法变成另一段字符串，放在HTTP响应的 `Sec-WebSocket-Accept` 头里，同时带上`101`状态码，发回给浏览器。

            - 之后，浏览器也用同样的公开算法将base64码转成另一段字符串，如果这段字符串跟服务器传回来的字符串一致，那验证通过。

            ![image](./Pictures/net-kernel/Sec-WebSocket-Key.avif)

- 服务器: 响应协议升级

    - 服务器返回的响应头必须包含如下的内容:
    ```
    HTTP/1.1 101 Switching Protocols
    Connection:Upgrade
    Upgrade: websocket
    Sec-WebSocket-Accept: Oy4NRAQ13jhfONC7bP8dTKb4PTU=
    ```

    - 响应行: HTTP/1.1 101 Switching Protocols。
    - 响应必须含有 Upgrade, 其值为 "weboscket"。
    - 响应必须含有 Connection, 其值为 "Upgrade"。
    - 响应必须含有 Sec-Websocket-Accept, 根据请求首部的 Sec-Websocket-key计算出来。。

- 服务器响应的第二次TCP握手，并使用websocket通信

    - 可以看到这也是个HTTP类型的报文，返回的状态码是101。同时可以看到返回的报文header中也带有各种`websocket`相关的信息，比如`Sec-WebSocket-Accept`

    ![image](./Pictures/net-kernel/websocket服务器响应的第二次TCP握手.avif)

- Sec-WebSocket-Key/Accept的计算

    - Sec-WebSocket-Key 值由一个随机生成的16字节的随机数通过 base64（见 RFC4648 的第四章）编码得到的。例如, 随机选择的16个字节为:

    ```
    // 十六进制 数字1~16
    0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0a 0x0b 0x0c 0x0d 0x0e 0x0f 0x10
    ```

    - Sec-WebSocket-Key的作用：
        - Key 可以避免服务器收到非法的 WebSocket 连接, 比如 Http 请求连接到 Websocket, 此时服务端可以直接拒绝。
        - Key 可以用来初步确保服务器认识 ws 协议, 但也不能排除有的 Http服务器只处理 Sec-WebSocket-Key, 并不实现ws协议。
        - Key可以避免反向代理缓存。
        - 在浏览器中发起 ajax 请求, Sec-Websocket-Key 以及相关 header 是被禁止的, 这样可以避免客户端发送 ajax 请求时, 意外请求协议升级。
        - 最终需要强调的是: Sec-WebSocket-Key/Accept 并不是用来保证数据的安全性, 因为其计算/转换公式都是公开的, 而且非常简单, 最主要的作用是预防一些意外的情况。

#### websocket报文格式

- websocket报文格式

    ![image](./Pictures/net-kernel/websocket报文格式.avif)

    - 这里面字段很多，但我们只需要关注下面这几个。

    - `opcode`字段：这个是用来标志这是个什么类型的数据帧。比如。

        - 等于1时是指text类型（string）的数据包
        - 等于2是二进制数据类型（[]byte）的数据包
        - 等于8是关闭连接的信号

    - `payload`字段：存放的是我们真正想要传输的数据的长度，单位是字节。比如你要发送的数据是字符串"111"，那它的长度就是3。

        ![image](./Pictures/net-kernel/websocket报文格式-payload字段.avif)

        - 另外，可以看到，我们存放payload长度的字段有好几个，我们既可以用最前面的7bit, 也可以用后面的`7+16bit`或`7+64bit`。

        - websocket会用最开始的7bit做标志位。不管接下来的数据有多大，都先读最先的7个bit，根据它的取值决定还要不要再读个16bit或64bit。

            - 1.如果最开始的7bit的值是 0~125，那么它就表示了 payload 全部长度，只读最开始的7个bit就完事了。
                ![image](./Pictures/net-kernel/payload长度在0到125之间.avif)

            - 2.如果是126（0x7E）。那它表示payload的长度范围在 126~65535 之间，接下来还需要再读16bit。这16bit会包含payload的真实长度。
                ![image](./Pictures/net-kernel/payload长度在126到65535之间.avif)

            - 3.如果是127（0x7F）。那它表示payload的长度范围&gt;=65536，接下来还需要再读64bit。这64bit会包含payload的长度。这能放2的64次方byte的数据，换算一下好多个TB，肯定够用了。
                ![image](./Pictures/net-kernel/payload长度大于等于65536的情况.avif)

    - `payload data`字段：这里存放的就是真正要传输的数据，在知道了上面的payload长度后，就可以根据这个值去截取对应的数据。

- 大家有没有发现一个小细节，websocket的数据格式也是  `数据头（内含payload长度） + payload data` 的形式。

    - 之前写的《既然有HTTP协议，为什么还要有RPC》提到过，TCP协议本身就是全双工，但直接使用纯裸TCP去传输数据，会有粘包的"问题"。为了解决这个问题，上层协议一般会用消息头+消息体的格式去重新包装要发的数据。

    - 而消息头里一般含有消息体的长度，通过这个长度可以去截取真正的消息体。

    - HTTP协议和大部分RPC协议，以及我们今天介绍的websocket协议，都是这样设计的。

### DNS

#### 基本概念

- [洋芋编程：DNS 原理入门](https://mp.weixin.qq.com/s/b2KFiwhpacT-gvZEd0GoOQ)

- [李银城：从Chrome源码看DNS解析过程](https://www.rrfed.com/2018/01/01/chrome-dns-resolve/)

- [朱小厮的博客：一文搞懂 DNS 基础知识，收藏起来有备无患~](https://mp.weixin.qq.com/s/M89J-L4qOFqaIUjxHlAJiA)

- 标准 glibc 提供了 libresolv.so.2 动态库，我们的应用程序就是用它进行域名解析（也叫 resolving）的， 它还提供了一个配置文件 `/etc/nsswitch.conf` 决定了 resolving 的顺序，默认是先查找 hosts 文件，如果没有匹配到，再进行 DNS 解析

    ```
    hosts:      files dns myhostname
    ```

- 域名层级

    - 全球有13个根域名解析服务器，这13条记录持久化在dns服务器中

    ![image](./Pictures/net-kernel/dns.avif)

    - 根域名.root  `www.example.com` 真正的域名是 `www.example.com.root` ，简写为 www.example.com. 。因为，根域名.root 对于所有域名都是一样的， 所以平时是省略的。

    - 根域名的下一级，叫做 顶级域名（top-level domain，缩写为 TLD），比如 `.com`、`.net`；

    - 再下一级叫做 次级域名（second-level domain，缩写为 SLD）， 比如 www.example.com 里面的 `.example`，这一级域名是用户可以注册的；

    - 再下一级是 主机名（host），比如 www.example.com 里面的 `www`，又称为 三级域名， 这是用户在自己的域里面为服务器分配的名称，是用户可以任意分配的。

    ```sh
    # 主机名.次级域名.顶级域名.根域名
    host.sld.tld.root
    ```

    - 域名劫持
    ![image](./Pictures/net-kernel/dns1.avif)

- 两种查询方式

    - 1.迭代查询：由dns服务器对每一层域名服务器一查到底
    ![image](./Pictures/net-kernel/dns-iteration.avif)

    - 2.递归查询：每查一层会return（返回）下一层的域名服务器给客户端，之后客户端继续查询下一层，以此类推。相比递归查询，可以减少dns服务器的压力

- DNS 服务器的IP地址，有可能是动态的，每次上网时由网关分配，这叫做 DHCP 机制；
    - 也有可能是事先指定的固定地址。 Linux系统里面，DNS 服务器的 IP 地址保存在 `/etc/resolv.conf` 文件。

- DNS 解析流程
    ![image](./Pictures/net-kernel/dns_解析流程.avif)

    - 浏览器输入域名，如 `www.example.com`
    - 查询当前硬件的缓存（host 文件 或浏览器缓存）中是否存在该域名对应的记录，如果存在直接使用，如果不存在则进入后续流程
    - 向运营商的 DNS 服务器发起 DNS 解析的请求，一般称运营商的 DNS 服务器为 `Local DNS`
    - `Local DNS` 会查询缓存记录 (内部实现对请求端来说是透明的)
    - `Local DNS` 如果没有缓存，会把域名从右往左扫描，依次请求对应的服务器
    - 对于域名 `www.example.com`，先去请求根域名服务器，假设根域名服务器返回了管理 .com 域的服务器，名字为 TLD
    - `Local DNS` 请求管理 TLD 服务器
    - 一般来说，TLD 返回的记录是一条 CNAME 记录，这里假设域名的 CNAME 解析到了 Amazon
    - `Local DNS` 请求 Amazon 的 DNS 服务器 (一般称之为权威服务器，权威服务器是 Amazon 自己构建的)
    - Amazon 返回 www.example.com 对应的服务器 IP 地址
    - `Local DNS` 缓存这个 IP 地址，并且返回给浏览器
    - 浏览器和返回的 IP 地址建立 TCP 连接，发送 HTTP 报文


    - 转发：当前运营商(比如联通)的LocalDNS不访问百度权威DNS服务器，而是直接访问了其它运营商(比如电信)的LocalDNS服务器，有些小的运营商就是通过这样做来降低成本。如果电信的LocalDNS对非自家ip的访问限了速那么很明显会影响你的DNS解析时间。
    ![image](./Pictures/net-kernel/dns2.avif)

- DNS 相关命令

    ```sh
    # dig命令
    dig math.stackexchange.com
    # 如果不想看到这么多内容，可以使用 `+short` 参数
    dig +short math.stackexchange.com

    # host 命令可以看作 dig 命令的简化版本，返回当前请求域名的各种记录。
    host github.com

    # nslookup 命令用于互动式地查询域名记录。
    nslookup
    nslookup github.com

    # whois 命令用来查看域名的注册情况。
    whois github.com
    ```

#### 查询过程

- 虽然只需要返回一个IP地址，但是 DNS 的查询过程非常复杂，分成多个步骤。

- 分级查询：就是从根域名开始，依次查询每一级域名的 `NS` 记录，直到查到最终的 IP 地址

    - 需要明确的是，每一级域名都有自己的 `NS` 记录，`NS` 记录指向该级域名的域名服务器。这些服务器知道下一级域名的各种记录。
    - 1.从 "根域名服务器" 查到 "顶级域名服务器"的 NS 记录和 A 记录（IP 地址）
    - 2.从 "顶级域名服务器" 查到 "次级域名服务器"的 NS 记录和 A 记录（IP 地址）
    - 3.从 "次级域名服务器" 查到 "主机名"的 IP 地址

    - DNS 服务器怎么知道 "根域名服务器" 的 IP 地址。 回答是 "根域名服务器" 的 NS 记录和 IP 地址一般是不会变化的， 所以内置在 DNS 服务器里面。

        - 下面是内置的根域名服务器 IP 地址的一个 例子

            ```
            ; formerly NS.INTERNIC.NET
            ;
            .                        3600000  IN  NS    A.ROOT-SERVERS.NET.
            A.ROOT-SERVERS.NET.      3600000      A     198.41.0.4
            A.ROOT-SERVERS.NET.      3600000      AAAA  2001:503:BA3E::2:30
            ;
            ; formerly NS1.ISI.EDU
            ;
            .                        3600000      NS    B.ROOT-SERVERS.NET.
            B.ROOT-SERVERS.NET.      3600000      A     192.228.79.201
            ;
            ; formerly C.PSI.NET
            ;
            .                        3600000      NS    C.ROOT-SERVERS.NET.
            C.ROOT-SERVERS.NET.      3600000      A     192.33.4.12
            ```

        - 列出了根域名（.root）的三条 NS 记录，以及它们的 IP 地址（即 A 记录）

            |NS 记录           |IP 地址（即 A 记录）|
            |------------------|--------------------|
            |A.ROOT-SERVERS.NET|198.41.0.4          |
            |B.ROOT-SERVERS.NET|192.228.79.201      |
            |C.ROOT-SERVERS.NET|192.33.4.12。       |

        - 另外，可以看到所有记录的 TTL 值是 3600000 秒，相当于 1000 小时。也就是说，每 1000 小时才查询一次根域名服务器的列表。

        - 目前，世界上一共有 13 组根域名服务器，从 A.ROOT-SERVERS.NET 一直到 M.ROOT-SERVERS.NET。

```sh
dig math.stackexchange.com

# 第 1 段是查询参数和统计

; <<>> DiG 9.10.6 <<>> math.stackexchange.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 44088
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 4, ADDITIONAL: 6

# 第 2 段是查询内容
# 结果表示，查询域名 math.stackexchange.com 的 A 记录，A 是 address 的缩写

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;math.stackexchange.com.  IN A

# 第 3 段是 DNS 服务器的答复
# 结果显示，math.stackexchange.com 有四个 A 记录，即四个 IP 地址。
# 54 是 TTL 值（Time to live 的缩写），表示缓存时间，即 54 秒之内不用重新查询。

;; ANSWER SECTION:
math.stackexchange.com. 54 IN A 151.101.65.69
math.stackexchange.com. 54 IN A 151.101.193.69
math.stackexchange.com. 54 IN A 151.101.129.69
math.stackexchange.com. 54 IN A 151.101.1.69

# 第 4 段显示 stackexchange.com 的 NS 记录（Name Server 的缩写）
# 即哪些服务器负责管理 stackexchange.com 的 DNS 记录。
# 结果显示 stackexchange.com 共有四条 NS 记录，即四个域名服务器，向其中任一台查询就能知道 math.stackexchange.com 的 IP 地址是什么

;; AUTHORITY SECTION:
stackexchange.com. 1866 IN NS ns-925.awsdns-51.net.
stackexchange.com. 1866 IN NS ns-1832.awsdns-37.co.uk.
stackexchange.com. 1866 IN NS ns-cloud-d1.googledomains.com.
stackexchange.com. 1866 IN NS ns-cloud-d2.googledomains.com.

# 第 5 段是上面四个域名服务器的 IP 地址，这是随着前一段一起返回的

;; ADDITIONAL SECTION:
ns-925.awsdns-51.net. 1626 IN A 205.251.195.157
ns-1832.awsdns-37.co.uk. 1592 IN A 205.251.199.40
ns-925.awsdns-51.net. 1626 IN AAAA 2600:9000:5303:9d00::1
ns-1832.awsdns-37.co.uk. 1593 IN AAAA 2600:9000:5307:2800::1
ns-cloud-d1.googledomains.com. 3204 IN AAAA 2001:4860:4802:32::6d

# 第 6 段是 DNS 服务器的一些传输信息

;; Query time: 26 msec
;; SERVER: 192.168.1.1#53(192.168.1.1)
;; WHEN: Fri Feb 17 22:31:26 CST 2023
;; MSG SIZE  rcvd: 368
```

- 如果不想看到这么多内容，可以使用 `+short` 参数
```sh
# 只返回 math.stackexchange.com 对应的 4 个 IP 地址（即A记录）。
dig +short math.stackexchange.com
151.101.1.69
151.101.129.69
151.101.193.69
151.101.65.69
```

- 指定dns服务器查询
```sh
dig @8.8.8.8 math.stackexchange.com
```

- dig 命令可以单独查看每一级域名的 `NS` 记录。
    ```sh
    dig ns com
    dig ns stackexchange.com

    # +short 参数可以显示简化的结果
    dig +short ns com
    dig +short ns stackexchange.com
    ```

- dig 命令的 +trace 参数可以显示 DNS 的整个分级查询过程。
    ```sh
    dig +trace math.stackexchange.com

    # 第一段列出根域名.的所有 NS 记录，即所有根域名服务器。
    # 根据内置的根域名服务器 IP 地址，DNS 服务器向所有这些 IP 地址发出查询请求，询问 math.stackexchange.com 的顶级域名服务器 com.的 NS 记录。 最先回复的根域名服务器将被缓存，以后只向这台服务器发请求。
    ; <<>> DiG 9.20.4 <<>> +trace math.stackexchange.com
    ;; global options: +cmd
    .			37521	IN	NS	f.root-servers.net.
    .			37521	IN	NS	d.root-servers.net.
    .			37521	IN	NS	c.root-servers.net.
    .			37521	IN	NS	a.root-servers.net.
    .			37521	IN	NS	g.root-servers.net.
    .			37521	IN	NS	l.root-servers.net.
    .			37521	IN	NS	i.root-servers.net.
    .			37521	IN	NS	j.root-servers.net.
    .			37521	IN	NS	k.root-servers.net.
    .			37521	IN	NS	b.root-servers.net.
    .			37521	IN	NS	m.root-servers.net.
    .			37521	IN	NS	h.root-servers.net.
    .			37521	IN	NS	e.root-servers.net.
    ;; Received 228 bytes from 192.168.41.102#53(192.168.41.102) in 72 ms

    # 结果显示.com 域名的 13 条 NS 记录，同时返回的还有每一条记录对应的 IP 地址。
    com.			172800	IN	NS	l.gtld-servers.net.
    com.			172800	IN	NS	j.gtld-servers.net.
    com.			172800	IN	NS	h.gtld-servers.net.
    com.			172800	IN	NS	d.gtld-servers.net.
    com.			172800	IN	NS	b.gtld-servers.net.
    com.			172800	IN	NS	f.gtld-servers.net.
    com.			172800	IN	NS	k.gtld-servers.net.
    com.			172800	IN	NS	m.gtld-servers.net.
    com.			172800	IN	NS	i.gtld-servers.net.
    com.			172800	IN	NS	g.gtld-servers.net.
    com.			172800	IN	NS	a.gtld-servers.net.
    com.			172800	IN	NS	c.gtld-servers.net.
    com.			172800	IN	NS	e.gtld-servers.net.
    com.			86400	IN	DS	19718 13 2 8ACBB0CD28F41250A80A491389424D341522D946B0DA0C0291F2D3D7 71D7805A
    com.			86400	IN	RRSIG	DS 8 1 86400 20250119050000 20250106040000 26470 . ExRuZtIRJOVkE7DUTsVm/8nBpDsisu9QQF4u1P+0tUP4mX6ef1hHvD6s z6BaX5boggq1RagKfnzpWfMXxfsDhzB3M6hUMIVCpj2bemZpjC0I53Me yGglPbr6Xx8kz14D5AKwrj/xRJ2gqHkNBVPhRbvqWL11UreLFHKSD9H6 hlJUOAIniZMFAjTJa9TDBxN60/+xit9ntShco2wjhBOAQfNbhZDArAEb g827QeCe8HAv4meW9+Jl/9zBUYjF5XuL2LFRUeEwY24s1XcbLjwMXkHM bn2ELbyiQ65QC30K/x3TVLfexGNV1JaO8eJHy4fKXIxZaRBAak1ahmTs 71Hg6Q==
    ;; Received 1182 bytes from 2001:503:ba3e::2:30#53(a.root-servers.net) in 136 ms

    # 结果显示 stackexchange.com 有2条 NS 记录，同时返回的还有每一条 NS 记录对应的 IP 地址
    # 然后DNS 服务器向上面这2台 NS 服务器查询 math.stackexchange.com 的主机名。
    stackexchange.com.	172800	IN	NS	sureena.ns.cloudflare.com.
    stackexchange.com.	172800	IN	NS	damian.ns.cloudflare.com.

    # 结果显示，math.stackexchange.com 有 2 条 A 记录，即这2个 IP 地址都可以访问到网站。并且还显示， 最先返回结果的 NS 服务器是 sureena.ns.cloudflare.com，IP 地址为 2803:f800:50::6ca2:c27e。
    math.stackexchange.com.	300	IN	A	104.18.43.226
    math.stackexchange.com.	300	IN	A	172.64.144.30
    ;; Received 83 bytes from 2803:f800:50::6ca2:c27e#53(sureena.ns.cloudflare.com) in 411 ms
    ```

#### DNS 的记录类型

- 域名与 IP 之间的对应关系，称为 "记录"（record）。

- 根据使用场景，"记录"可以分成不同的类型（type）

    - 前面已经看到了有 `A` 记录和 `NS` 记录

    - A：地址记录（Address），返回域名指向的 IP 地址。
    - AAAA: 记录是域名到 IPV6 地址。
    - NS：域名服务器记录（Name Server），返回保存下一级域名信息的服务器地址。该记录只能设置为域名，不能设置为 IP 地址。
    - MX：邮件记录（Mail eXchange），返回接收电子邮件的服务器地址。
    - CNAME：规范名称记录（Canonical Name），返回另一个域名，即当前查询的域名是另一个域名的跳转，详见下文。
    - PTR：逆向查询记录（Pointer Record），只用于从 IP 地址查询域名，详见下文。

- 一般来说，为了服务的安全可靠，至少应该有两条 `NS` 记录，而 `A` 记录和 MX 记录也可以有多条，这样就提供了服务的冗余性，防止出现单点失败。

- 查看指定的记录类型

    ```sh
    dig a github.com
    dig ns github.com
    dig mx github.com
    ```

- `CNAME` 记录主要用于域名的内部跳转，为服务器配置提供灵活性，用户感知不到。举例来说，`facebook.github.io` 这个域名就是一个 CNAME 记录。

    ```sh
    dig facebook.github.io

    ...

    ;; ANSWER SECTION:
    facebook.github.io. 3370    IN  CNAME   github.map.fastly.net.
    github.map.fastly.net.  600 IN  A   103.245.222.133
    ```
    - 上面结果显示，facebook.github.io 的 CNAME 记录指向 github.map.fastly.net。
        - 也就是说，用户查询 facebook.github.io 的时候， 实际上返回的是 github.map.fastly.net 的 IP 地址。这样的好处是，变更服务器 IP 地址的时候，只要修改 github.map.fastly.net 这个域名就可以了， 用户的 facebook.github.io 域名不用修改。

    - 由于 `CNAME` 记录就是一个替换，所以域名一旦设置 CNAME 记录以后，就不能再设置其他记录了（比如 A 记录和 MX 记录），这是为了防止产生冲突。
        - 举例来说，foo.com 指向 bar.com，而两个域名各有自己的 MX 记录，如果两者不一致，就会产生问题。由于顶级域名通常要设置 MX 记录， 所以一般不允许用户对顶级域名设置 CNAME 记录。

- `PTR` 记录用于从 IP 地址反查域名。dig 命令的 -x 参数用于查询 PTR 记录。

    - 逆向查询的一个应用，是可以防止垃圾邮件，即验证发送邮件的 IP 地址，是否真的有它所声称的域名。

    ```sh
    # 192.30.252.153 这台服务器的域名是  lb-192-30-252-153-iad.github.com。
    dig -x 192.30.252.153


    ; <<>> DiG 9.20.4 <<>> -x 192.30.252.153
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 18478
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;153.252.30.192.in-addr.arpa.	IN	PTR

    ;; ANSWER SECTION:
    153.252.30.192.in-addr.arpa. 3600 IN	PTR	lb-192-30-252-153-iad.github.com.

    ;; Query time: 151 msec
    ;; SERVER: 192.168.41.102#53(192.168.41.102) (UDP)
    ;; WHEN: Mon Jan 06 16:13:41 CST 2025
    ;; MSG SIZE  rcvd: 91
    ```

#### [arthurchiao：DNS 问题分析示例（2019）](http://arthurchiao.art/blog/dns-practice-zh/)

- 1.没有配置合适的dns服务器`/etc/resolv.conf`

- 2.`/etc/hosts` 中域名映射ip的问题：映射的ip未必是域名最优的地址，甚至可能不可用

- 3.DNS 查询不稳定，时快时慢：有 tc 或 iptables 规则，导致到 DNS 服务器的 packet 变慢或丢失
    ```sh
    # 查看tc规则
    tc -p qdisc ls dev eth0
    # 删除规则
    tc qdisc del dev eth0 root
    ```

- 4.DNS反向查询不稳定：ltrace -p <PID>跟踪 ping 域名进程发现问题，卡在 `gethostbyaddr()` 的函数
    - 解决方法是：修改 `/etc/resolv.conf` 更换 DNS 服务器

    ```sh
    # 使用以下命令进行验证
    nslookup <IP>
    host <IP>
    dig -x <IP>
    ```

#### HTTPDNS：代替传统的基于UDP的DNS协议，域名解析请求直接发送到HTTPDNS服务端，从而绕过运营商的DNS

- 域名可以对应多个ip地址，从而实现负载均衡

    - 第1种方法：域名解析可以返回多个 IP 地址，客户端收到多个 IP 地址后，就可以自己使用轮询算法依次向服务器发起请求，实现负载均衡。

    - 第2种方法：智能解析。域名解析可以配置内部的策略，返回离客户端最近的主机，或者返回当前服务质量最好的主机，这样在 DNS 端把请求分发到不同的服务器，实现负载均衡。

        - 智能解析依赖 EDNS 协议（google 起草的 DNS 扩展协议）： 在 DNS 包里面添加 origin client IP, nameserver 据 client IP 返回距离 client 比较近的 server IP 了

        - 国内支持EDNS有DNSPod，已被腾讯收购

#### [knowclub：localhost和127.0.0.1的区别](https://mp.weixin.qq.com/s/5vKgzvXsbrOMElc5VPGAPA)

- 有人告诉我 localhost 和 127.0.0.1 的区别是 localhost 不经过网卡
    - 这是错误的！

- localhost 会按[dns 解析流程进行解析]，然后和 127.0.0.1 一样

### CDN（Content Delivery Network）内容分发网络

- [洋芋编程：CDN 原理入门](https://mp.weixin.qq.com/s/hMdy7ecucd_SkIpZ1owQvg)

- [yes的练级攻略：面试官：你懂 CDN 吗？](https://mp.weixin.qq.com/s/kdhVCNc5YtUdR869WpQbrQ)

- 这其实就是所谓的“热点”问题，该如何解决这个问题呢？可以采取类似分流的操作。
    - 基本思路是: 尽可能避开互联网上有可能影响数据传输速度和稳定性的瓶颈和环节， 使内容传输得更快更稳定。

- CDN 的 基本原理为反向代理，反向代理（Reverse Proxy）

    > 简单地理解，CDN 就是客户端和真实服务器之间的一层高效的缓存。

    - 代理服务器来接受的连接请求，然后将请求转发给内部网络上的服务器， 并将从服务器上得到的结果返回给请求连接的客户端
    - 通过部署更多的反向代理服务器，来实现 多节点 CDN 架构。

- CDN 主要使用了以下几种方法来提高其性能和可靠性:
    - 分布式存储: 采用可扩展的系统架构，利用多节点、多位置、多种方式存储数据
    - 负载均衡: 可以将流量均匀地分配到多个节点服务器上，从而避免某些服务器过度负载而导致响应时间延迟
    - 动态路由: 可以根据网络流量和服务器负载情况来选择最优的路径和服务器来响应用户请求
    - 内容压缩: 可以将内容文件压缩到更小的体积，以减少网络传输的时间和成本

- 例子

    - 如果网站服务器部署在北京，香港的用户访问该网站，由于物理距离的缘故（网络的传输时间受距离影响），时延相对而言会比较大，导致体验上并不是很好。

        ![image](./Pictures/net-kernel/cdn.avif)

        - 并且当用户量比较大的时候，全国各地所有的请求都涌向北京的服务器，网络的主干道就会被阻塞。这个应该很好理解，就好比国庆假期的网红打卡点，大家都想去那里打卡，那么前往这个打卡点的道路不就都被堵满了吗？

    - 当香港的用户想去访问网站的时候，根据就近原则，选择一个距离它最近的缓存站，比如有个深圳站：

        - 主服务器部署在北京不变，但是全国各地都建立一些缓存站，这些缓存站可以缓存一些主服务器上变化不频繁的资源，比如一些 css/js/图片等静态资源。

        ![image](./Pictures/net-kernel/cdn1.avif)

        - 那么先去这个站上看看有没有资源，如果有就直接就从缓存站要到资源了，这个流量就被深圳站拦截了，由于距离很近，响应时延也很低，且不占用请求北京的主干道流量，也减轻了北京服务器的负担，一举多得！

        - 如果缓存站找不到，那么就回源到源站，也就是缓存站会去北京的服务器去要数据，然后将这些数据缓存到本地且返回给用户，用户的感觉可能就是网站卡了一下，然后就好了。
            - 这次操作后，别的香港用户访问同样的内容由于缓存站缓存了，因此不需要再次回源，直接从深圳站就返回数据了。

- 动态数据：上面我说的是静态资源，如果是提交订单这样的操作怎么缓存呢？

    - 确实如此，很多业务场景涉及到存储层面是有状态的，如果我们让缓存站也能处理这些业务场景，就得将一些业务数据存储下来，那么就又会涉及数据同步问题。

    - 这种数据同步机制又会带来另一个高复杂度的挑战，也就是数据一致性问题，很复杂。

    - 所以现在很多云厂商提供的全站 CDN， 一般指的是 CDN 厂商会自动识别你网站资源哪些是静态的，哪些是动态的。

    - 静态的按照我们上面说的路子走，动态的则是根据内部的一些调度算法，智能地选择最优回源路径去请求源站，节省请求的时间。

    - 这就好比我们自驾从香港开到北京，路线有很多，然后有个导航很智能，它可以实时监控计算当前道路信息，给我们提供一条路径最短、最不堵的路。

- 不适合使用 CDN 的场景
    - 请求客户端和服务器物理距离很近，比如同机房、同机架的内网服务
    - 用户分布在同一地理区域，如同城服务、本地门户网站
    - 动态文件或接口，比如更新很频繁的文件，使用 CDN 反而会增加响应耗时

- 传统网站访问过程
    - 1.客户端浏览器输入网址，如 https://www.example.com/logo.png
    - 2.浏览器请求 DNS 服务器，查询 https://www.example.com/logo.png 对应的源服务器 IP 地址
    - 3.DNS 服务器返回对应的 IP 地址
    - 4.浏览器向服务器发起 TCP 连接
    - 5.浏览器通过建立的 TCP 连接发送 HTTP 请求图片文件
    - 6.服务器向浏览器发送图片文件
    - 7.浏览器将接收到的图片文件渲染，完成本次请求

    - 如果我们要加入 CDN 的话，是加到哪个步骤呢？
        - 第 2 步，浏览器在访问真实的服务器之前，会先通过 DNS 查询域名对应源服务器的 IP 地址，如果 DNS 返回的是 CDN 服务器的 IP 地址， 那么后面的流程就会变为: 客户端浏览器就直接从 CDN 服务器获取数据
        - 将域名 `www.example.com` 的 `CNAME` 记录解析到 CDN 服务商即可，CDN 服务商的 DNS 服务器也称为权威服务器

- 接入 CDN 网站访问过程
    - 1.客户端浏览器输入网址，如 https://www.example.com/logo.png
    - 2.浏览器请求 DNS 服务器，查询 https://www.example.com/logo.png 对应的服务器 IP 地址
    - 3.由于域名的 `CNAME` 记录解析到了 CDN 服务商，所以这里 DNS 服务器会返回 CDN 服务商提供的 CDN 节点服务器的地址
    - 4.浏览器向 CDN 节点服务器发起 TCP 连接
    - 5.浏览器通过建立的 TCP 连接发送 HTTP 请求图片文件
    - 6.CDN 节点服务器使用内部专用 DNS 解析出域名对应的源服务器 IP 地址
    - 7.CDN 节点服务器向源服务器发起TCP连接
    - 8.CDN 节点服务器通过建立的 TCP 连接发送 HTTP 请求图片文件
    - 9.CDN 服节点务器接收到图片文件后，在本地保存一份，作为缓存使用，减少源服务器的回源流量
    - 10.CDN 节点服务器向浏览器发送图片文件
    - 11.浏览器将接收到的图片文件渲染，完成本次请求


- CDN 基础架构

    ![image](./Pictures/net-kernel/cdn架构.avif)

    - 所谓的 CDN 缓存节点就是我上面说的缓存站，然后还是一个很重要的 GSLB （全局负载均衡器）。

    - 这个 GSLB 的主要功能就是实现我上面说的 ：当香港的用户想去访问网站的时候，根据就近原则，选择一个距离它最近的缓存站。
        - 它最主要的功能就是用户访问网站的时候，根据用户请求的 ip、url 选择最近的节点，让用户直接请求最近的节点即可。

    - GSLB 转发机制有三种实现：

        - 基于 DNS 解析
        - 基于 HTTP 重定向（主流应用层协议为 HTTP）
        - 基于 IP 路由。

    - HTTP 重定向去实现转发的问题：

        - 301 永久重定向和 302 临时重定向都可以实现转发功能。

        - 那么 301 合适吗？永久重定向好像不合适，比如重定向的缓存站挂了咋办，迁移了咋办？GSLB 叫全局负载均衡，就均衡一次完事儿啦？

            - 所以只能 302 ，而 302 的流程每次还得访问 GSLB，那不就等于所有请求每次都得经过 GSLB 操作？因此 GSLB 可能会成为性能瓶颈。

            - 解决方法：DNS解析
                - 用户通过域名解析定位到 GSLB ，通过负载均衡返回用户最近的一个缓存站 ip，后续浏览器、本地 DNS 服务器等都会将本次域名解析得到的 ip 结果缓存一段时间。
                - 那么这个时间段内用户再次请求这个域名，压根不会打到 GSLB 而是直接访问对应的缓存站，这不就解决瓶颈问题了吗？

#### 基于DNS解析

- 基于 DNS 解析具体有三种实现方式：
    - 1.利用 CNAME 实现负载均衡
        - 业界最多是使用 CNAME 方式来实现负载均衡，实现简单且不需要修改公共 DNS 系统配置。
    - 2.将 GSLB 作为权威 DNS 服务器
    - 3.将 GSLB 作为权威 DNS 服务器的代理服务器

- 实现方法1：利用 CNAME
    - 比如之前网站网址是 www.netitv.com.cn，此时进行要 cdn 改造，那么将之前的网站网址作为 GSLB  服务域名的 CNAME，用户访问 www.netitv.com.cn，经过 CNAME 解析会映射到 GSLB 地址 www.netitv.cdn.com.cn 上，然后 GSLB 基于 DNS 协议可以进行后续的负载均衡操作，选择合适的 IP 返回给用户。
    ![image](./Pictures/net-kernel/cdn-CNAME实现.avif)

- 实现方法2：将 GSLB 作为一个域的权威 DNS 服务器
    - 那么对于这个域来说，正常域名解析的过程不就可以为所欲为了？负载均衡就都由 GSLB 来把控了
    - 至于如何才能成为一个域的权威 DNS 服务器？这个我不清楚，听起来好像有点难度。

- 实现方法3：在权威 DNS 服务器前面做一个代理
    - 差别就是不需要实现一个功能完整的权威 DNS 服务器，仅需对个别需要 GSLB 操作的请求进行修改转发即可
    - 不过这其实也得将对外公布的权威 DNS 服务器的地址变成代理服务器地址，这个难度和第二点一致。

#### 阿里的CDN架构Swift

- 阿里的 HTTP 缓存服务器，名字叫 Swift。

![image](./Pictures/net-kernel/cdn_阿里cdn架构swift.avif)

图中是一个 CDN 节点，用户的请求从 LVS（LVS是一个四层的负载均衡组件）的入口来，先由 LVS 做一次 4 层的负载均衡， 然后转到一台 Tengine（阿里在 Nginx 的基础上开发的服务器）上，Tengine 做一致性哈希，选择一台 Swift 服务器去做缓存数据回源。

![image](./Pictures/net-kernel/cdn_阿里cdn架构swift1.avif)

首先可以看到，Swift 是一个多线程的程序，每个线程启动一个 epoll 来充分发挥多核的处理能力，并且尽量减少线程间的上下文切换，一个请求尽量在一个线程处理。除此之外，还能看到 内存缓存，SSD 缓存，SATA 缓存。Swift 有热点淘汰和提升机制，将热文件放在内存里，次热文件放在 SSD 上，最后才是 SATA 盘。叔度 (阿里 CDN 负责人) 指出，Tengine 和 Swift 是通过 Spdy 协议 来通信的，从而优化 HTTP 的传输效率。

### FTP

![image](./Pictures/net-kernel/ftp.avif)

- 最常用的配置是`passive`。如果是`active`防火墙起不到保护作用。

### DHCP

- [（视频）技术蛋老师：DHCP运作原理和握手过程](https://www.bilibili.com/video/BV1Gd4y1n7Xz)

- [洋芋编程：网络辣鸡自救指南 - 笔记本/手机 是如何拿到局域网 IP 的？](https://mp.weixin.qq.com/s/X5uq1YSaMcrIhkC_FXATxA)

- DHCP（Dynamic Host Configuration Protocol，动态主机配置协议）是为主机（客户端）自动配置 IP 地址、子网、DNS 服务器、默认网关等信息的网络协议。

- 虽然 DHCP 依赖于其他协议（如 ARP、UDP 和 IP），但它自身不属于任何一层，而是工作在应用层。

- 路由器的 DHCP 功能主要分为三个方面:
    - 当一台新设备连接到家用路由器时，三个功能都会执行到。

    - 1.作为 DHCP 服务器为客户端分配 IP 地址
    - 2.作为 DHCP 客户端从其他 DHCP 服务器中获取 IP 地址
    - 3.在 DHCP 服务器和客户端之间完成中继广播消息

#### 连接过程

- 连接过程

    ![image](./Pictures/net-kernel/dhcp_连接过程.avif)

    - 1.客户端在网段内广播 DISCOVER 消息
    - 2.DHCP 服务器在网络内广播 OFFER 消息
    - 3.客户端在网络内广播 REQUEST 消息
    - 4.在接收 ACK 消息后，客户端就能使用所分配的 IP 地址（10.1.1.5）

- 下面展开来说下这个过程中的一些细节:

    - 假设主机 A（客户端）最开始没有 IP 地址以及其它信息，那么就需要先使用 DHCP 来获取
    - 主机生成一个 DHCP 请求报文，并将这个报文放入: 目的端口 67 和 源端口 68 的 UDP 报文段中
    - 将该报文段放入: 广播 IP 目的地址(255.255.255.255) 和 源 IP 地址（0.0.0.0） 的 IP 数据报中
    - 将该数据报放入 MAC 帧中，帧目的地址 FF:FF:FF:FF:FF:FF，通过二层交换机广播到所有连接的设备
    - 连接在交换机的 DHCP 服务器 (也可以是连接到光猫上的家用路由器) 收到广播帧之后，不断地向上分解得到 IP 数据报、UDP 报文段、DHCP 请求报文，之后生成 DHCP ACK 报文，该报文包含以下信息：IP 地址、DNS 服务器的 IP 地址、默认网关路由器的 IP 地址和子网掩码，然后将该报文被放入 UDP 报文段中，再把 UDP 报文段放入 IP 数据报中，最后放入 MAC 帧中
    - Mac 帧的目的地址是请求主机 A 的 MAC 地址，因为交换机具有自学习能力，之前主机 A 发送广播帧之后，顺带就记录了 MAC 地址和其转发接口的 交换表项，因此现在交换机知道应该向哪个接口发送该 Mac 帧
    - 主机收到 Mac 帧后，不断分解得到 DHCP 报文，之后就配置它的 IP 地址、子网掩码和 DNS 服务器的 IP 地址，并在其 IP 转发表中安装默认网关

    ![image](./Pictures/net-kernel/dhcp_请求报文.avif)

- 手动分配静态 IP 地址
    - 手动配置好 IP 地址之后，依然会执行上面的连接过程，只不过发起的请求报文不同而已。

    - 例如主机 A 将自己的 IP 地址配置为 192.168.20.10, 那么发起的 DHCP 请求报文中的 请求 IP 地址 就是 192.168.20.10, 剩下的连接过程和动态获取 IP 地址过程一样。

#### 地址分配

- 分配顺序
    - DHCP 服务器需要从 IP 地址池中为客户端分配一个 IP 地址，具体的顺序如下:

    - 1.DHCP 服务器上已配置，指定客户端的 MAC 地址静态绑定的 IP 地址
    - 2.客户端发送的 DISCOVER 请求报文中指定的 IP 地址
    - 3.DHCP 服务器的 IP 地址池中查找 “Expired” 状态的 IP 地址，也就是租期到期的 IP 地址
    - 4.DHCP 服务器的 IP 地址池中查找 “Idle” 状态的 IP 地址，也就是空闲的 IP 地址
    - 5.如果上述步骤均未找到可分配的 IP 地址，DHCP 服务器地址池依次回收租期到期状态的（Expired）和处于冲突状态（Conflict）的 IP 地址，回收后如果找到可用的 IP 地址，分配给客户端，否则，客户端等待 DHCP 服务器应答超时后，重新发送 DISCOVER 请求报文来申请 IP 地址

- 静态 IP
    - 对于客户端申请静态 IP (已经指定了 IP 地址) 的请求报文，DHCP 服务器收到请求之后，会先检查该 IP 是否已经分配，如果已经分配给其他主机，直接回复 NACK 消息拒绝。
    ![image](./Pictures/net-kernel/dhcp_检测IP是否已经分配.avif)
    - 除了客户端申请静态 IP 地址外，网络管理员也可以通过 DHCP 服务器静态分配机制来分配 IP, 避免客户端手动配置错误的情况。

- 确认分配
    - 那么如何确认指定的 IP 是否已经分配了呢？DHCP 服务器只需要 ping 一下申请的 IP 地址即可。
    - 对于申请动态 IP (没有指定了 IP 地址) 的请求报文，DHCP 服务器只需要找一个没有使用的 IP 地址返回就可以了。

#### 地址冲突

- 假设当前主机 A 已经通过 DHCP 获取到 IP: 192.168.20.10。

- 那么当主机 A 休眠时，无法回复 Ping，DHCP 服务器就会认为该 IP 地址没有被使用，于是将 192.168.20.10 分配给其他主机，等到主机 A 休眠结束后，IP 地址就与主机 B 发生了冲突。

- 如果主机 A 是关机而非休眠的话，是否会产生 IP 地址冲突呢？

- 不会，因为当主机 A 开机时，首先要完成 TCP/IP 模块的初始化，在配置其静态 IP 192.168.20.10 时，会发三次 ARP 消息 (目的: 确认有没有主机在使用 IP 192.168.20.10)，如果有其他主机使用了这个 IP, 主机 A 就会收到对应的回复，也就不会继续使用这个 IP 地址了。

#### 地址回收

- DHCP 服务器的 IP 地址池中会指定 IP 地址的租期，如果客户端发送的 DISCOVER 报文中携带了期望租期，服务器会将 客户端的期望租期 与 分配 IP 的租期 进行比较，选择其中时间较短的租期分配给客户端。

- 1.租期到期和续期

    - 如果客户端希望租期到期后，继续使用当前的 IP 地址，需要更新 IP 地址的租期。

    - 1.当客户端 IP 地址租期剩余 50% 时，会以单播的方式向 DHCP 服务器发送 REQUEST 请求报文，请求更新 IP 地址租期，如果收到 ACK 报文，租期更新成功（即租期重新从 0 开始计算），如果收到 NAK 报文，则向 DHCP 服务器重新发送 DISCOVER 报文请求新的 IP 地址

    - 2.当客户端 IP 地址租期剩余 87.5% 时，如果还未收到 DHCP 服务器的应答报文，客户端会以广播的方式向 DHCP 服务器发送 REQUEST 报文 (为什么这里是广播呢？因为收不到 DHCP 服务器的应答，说明 DHCP 服务器可能已经发生变更)，请求更新 IP 地址租期，如果收到 ACK 报文，租期更新成功（即租期重新从 0 开始计算），如果收到 NAK 报文，则向 DHCP 服务器重新发送 DISCOVER 报文请求新的 IP 地址

    - 3.如果租期到期时，都没有收到 DHCP 服务器的应答，客户端停止使用当前 IP 地址，重新发送 DISCOVER 报文请求新的 IP 地址

- 2.手动释放
    - 客户端在租期到期之前，如果不想再使用当前的 IP 地址 (例如笔记本电脑从宿舍移动到了教室)，客户端会向 DHCP 服务器发送 RELEASE 请求报文，通知 DHCP 服务器释放 IP 地址的租期，便于该 IP 地址后续被其他客户端继续使用。

- 3.超时和断线
    - 如前文中提到的，当客户端因为休眠和断线 (例如网线被拔掉) 而无法响应 DHCP 服务器的检测时，DHCP 服务器将回收该客户端的 IP 地址。

### 代理

- [新 V2Ray 白话文指南](https://guide.v2fly.org/)

- [官方的配置文件文档](https://www.v2fly.org/config/overview.html)

- [官方的开发文档](https://www.v2fly.org/developer/intro/compile.html)

- V2Ray 的工作方式：一般来说，流量从 inbound 进入到 V2Ray，再进入到路由匹配过程，找到匹配到的 outbound，然后流量就给到这个 outbound 处理。
    - V2Ray 虽然有多种 inbound，多种 outbound，以及很灵活的路由匹配规则。

#### [Tachyon：漫谈各种黑科技式 DNS 技术在代理环境中的应用](https://tachyondevel.medium.com/%E6%BC%AB%E8%B0%88%E5%90%84%E7%A7%8D%E9%BB%91%E7%A7%91%E6%8A%80%E5%BC%8F-dns-%E6%8A%80%E6%9C%AF%E5%9C%A8%E4%BB%A3%E7%90%86%E7%8E%AF%E5%A2%83%E4%B8%AD%E7%9A%84%E5%BA%94%E7%94%A8-62c50e58cbd0)

- Windows 系统的用户需要注意，系统代理里直接设置 SOCKS 代理有可能用的不是 SOCKS 5，而是 SOCKS 4，SOCKS 4 是不支持远程 DNS 解析的，想要设置 SOCKS 5 的话要用 PAC 文件，PAC 文件内容可以这么写：

    ```
    function FindProxyForURL(url, host) {
        return "SOCKS5 127.0.0.1:1086; SOCKS 127.0.0.1:1086";
        return“SOCKS5 127.0.0.1：1086; SOCKS 127.0.0.1:1086”;
    }
    ```
##### 各种代理的dns请求

- 不开启代理的dns请求
    - 1.浏览器地址栏输入 www.bilibili.com，敲下 Enter
    - 2.浏览器发起针对 "www.bilibili.com" 这个域名的 DNS 请求
    - 3.假设系统 DNS 设置了 114.114.114.114
    - 4.承载 DNS 请求的 UDP 流量就会从你本机直接发到 114.114.114.114
    - 5.114.114.114.114 接收了这些 UDP 流量
    - 6.114.114.114.114 从这些 UDP 流量中解析出请求的域名 "www.bilibili.com"
    - 7.114.114.114.114 尝试从自己缓存里找结果，有的话返回结果
    - 8.114.114.114.114 如果没缓存，会向其它 DNS 服务器要结果，拿到后返回
    - 9.浏览器收到 114.114.114.114 返回的结果
    - 10.浏览器开始真正地对 Bilibili 的服务器发起 HTTP/HTTPS 连接

- 开启代理的dns请求

    - v2ray配置

        ```json
        {
            "dns": {
                "servers": [
                    "223.5.5.5",
                    "8.8.8.8"
                ]
            },
            "outbounds": [
                {
                    "protocol": "freedom",
                    "settings": {}
                }
            ],
            "inbounds": [
                {
                    "domainOverride": [
                        "http",
                        "tls"
                    ],
                    "port": 1086,
                    "listen": "127.0.0.1",
                    "protocol": "socks",
                    "settings": {
                        "auth": "noauth",
                        "udp": true,
                        "ip": "127.0.0.1"
                    }
                }
            ]
        }
        ```

    - 1.浏览器地址栏输入 www.bilibili.com，敲下 Enter
    - 2.浏览器发现设置了 SOCKS 代理，因为 SOCKS 代理可以把域名传给服务器处理
    - 3.所以浏览器不需要做 DNS 请求，直接把域名放进 SOCKS 请求中发给代理服务器
    - 4.我们的代理服务器(V2Ray) 127.0.0.1:1086 收到了这个 SOCKS 代理请求
    - 5.代理服务器(V2Ray) 从 SOCKS 请求中解析出 "www.bilibili.com" 这个域名
    - 6.代理服务器(V2Ray) 要代理这个请求，但因为只有一个 Freedom outbound
    - 7.于是就用 Freedom outbound 向 www.bilibili.com 发起 TCP 连接
    - 8.Freedom outbound 要向一个域名发 TCP 连接，得先解析域名
    - 9.承载 DNS 请求的 UDP 流量就会从你本机直接发到 114.114.114.114
    - 10.114.114.114.114 接收了这些 UDP 流量
    - 11.114.114.114.114 从这些 UDP 流量中解析出请求的域名 "www.bilibili.com"
    - 12.114.114.114.114 尝试从自己缓存里找结果，有的话返回结果
    - 13.114.114.114.114 如果没缓存，会向其它 DNS 服务器要结果，拿到后返回
    - 14.程序(V2Ray)收到 114.114.114.114 返回的结果
    - 15.程序(V2Ray)开始真正地对 Bilibili 的服务器发起 TCP 连接
    - 16.连接一旦建立，代理服务器(V2Ray) 就可以真正地代理客户端(浏览器)的请求流量


    - 上面设置不涉及任何远程代理服务器，由本地的 V2Ray 充当代了理服务器，代理的 www.bilibili.com 请求是采用直连方式，也一样有向 114.114.114.114 发出了 DNS 请求。
        - 但可以看到在后一个例子发起 DNS 请求的是 V2Ray（而不是浏览器），而从 Bilibili 的服务器看来，跟它连接是 V2Ray（而不是浏览器）。

    - 加了这么一层代理，看起来什么都没发生，只是换了角色，其实不然，角色这么一换，可做的事情就相当多了。
        - 拿 DNS 来说，原来是浏览器发起的 DNS 请求，我们没办法控制浏览器怎么去发这个 DNS 请求（你不可能去改浏览器的源代码自己编译一个来用吧？），但换成由 V2Ray 来发这个 DNS 请求后，我们就可以做很多事情。

- 稍微改一下上面的v2ray配置，在 `Freedom oubound` 中加入 `"domainStrategy": "UseIP" `

    - [V2Ray 文档](https://v2ray.com/chapter_02/protocols/freedom.html) 中对 domainStrategy 的说明是这样的：

        > 在目标地址为域名时，Freedom 可以直接向此域名发出连接（"AsIs"），或者将域名解析为 IP 之后再建立连接（"UseIP"、"UseIPv4"、"UseIPv6"）。解析 IP 的步骤会使用 V2Ray 内建的 DNS。默认值为"AsIs"。

    ```json
    {
        "dns": {
            "servers": [
                "223.5.5.5",
                "8.8.8.8"
            ]
        },
        "outbounds": [
            {
                "protocol": "freedom",
                "settings": {
                    "domainStrategy": "UseIP"
                }
            }
        ],
        "inbounds": [
            {
                "domainOverride": [
                    "http",
                    "tls"
                ],
                "port": 1086,
                "listen": "127.0.0.1",
                "protocol": "socks",
                "settings": {
                    "auth": "noauth",
                    "udp": true,
                    "ip": "127.0.0.1"
                }
            }
        ]
    }
    ```

    - 原本默认为 `AsIs` 的话，直接向域名发出连接就是说会用系统 DNS 来做 DNS 解析，但如果我们设置为 `UseIP` ，步骤就会变成这样

        ```
        ...
        8.Freedom outbound 要向一个域名发 TCP 连接，得先解析域名
            * Freedom outbound 用了 UseIP 策略，所以使用内置 DNS 来解析域名
            * 内置 DNS 按顺序第一个是 223.5.5.5
            * 内置 DNS 请求会按路由规则走，因为没有任何规则，且只有一个 Freedom outbound
            * 内置 DNS 发到 223.5.5.5 的请求走 Freedom outbound
        9.承载 DNS 请求的 UDP 流量就会从你本机直接发到 223.5.5.5
        10.223.5.5.5 接收了这些 UDP 流量
        11.223.5.5.5 从这些 UDP 流量中解析出请求的域名 "www.bilibili.com"
        12.223.5.5.5 尝试从自己缓存里找结果，有的话返回结果
        13.223.5.5.5 如果没缓存，会向其它 DNS 服务器要结果，拿到后返回
        14.程序(V2Ray)收到 223.5.5.5 返回的结果
        ...
        ```

    - 所以这里我们改了一个 domainStrategy 参数，就相当于覆盖了系统的 DNS，本来应该走 114.114.114.114（系统 DNS）的 DNS 请求现在走 223.5.5.5（V2Ray 内置 DNS）了。

- 简单描述下面配置：
    - 内置 DNS 用 8.8.8.8 做首选服务器，localhost 作备用
    - 路由中首先来一条规则让 8.8.8.8 的流量一定走 proxy，匹配了 geosite:cn 中的域名的请求走 direct
    - 如果没匹配任何规则，则走主 outbound，也即 outbounds 中的第一个，也即 proxy。

    ```json
    {
        "dns": {
            "servers": [
                "8.8.8.8",
                "localhost"
            ]
        },
        "outbounds": [
            {
                "protocol": "vmess",
                "settings": {
                    "vnext": [
                        {
                            "users": [
                                {
                                    "id": "xxx-x-x-x-xx-x-x-x-x"
                                }
                            ],
                            "address": "1.2.3.4",
                            "port": 10086
                        }
                    ]
                },
                "streamSettings": {
                    "network": "tcp"
                },
                "tag": "proxy"
            },
            {
                "tag": "direct",
                "protocol": "freedom",
                "settings": {}
            }
        ],
        "inbounds": [
            {
                "domainOverride": [
                    "http",
                    "tls"
                ],
                "port": 1086,
                "listen": "127.0.0.1",
                "protocol": "socks",
                "settings": {
                    "auth": "noauth",
                    "udp": true,
                    "ip": "127.0.0.1"
                }
            }
        ],
        "routing": {
            "domainStrategy": "IPIfNonMatch",
            "rules": [
                {
                    "type": "field",
                    "ip": [
                        "8.8.8.8"
                    ],
                    "outboundTag": "proxy"
                },
                {
                    "type": "field",
                    "domain": [
                        "geosite:cn"
                    ],
                    "outboundTag": "direct"
                }
            ]
        }
    }
    ```

    - 假设浏览器请求 https://www.bilibili.com
        - 1.浏览器发 SOCKS 请求到 V2Ray
        - 2.请求来到 V2Ray 的 inbound，再到路由过程
        - 3.很明显 www.bilibili.com 这个域名包括在 geosite:cn 中，走 direct
        - 4.Freedom outbound (direct) 对 www.bilibili.com 发起 TCP 连接
        - 5.Freedom outbound 解析域名，因为这次没有用 UseIP，用的是系统 DNS
        - 6.直接发 DNS 请求到 114.114.114.114
        - 7.得到结果后可以跟 Bilibili 服务器建立连接，准备代理浏览器发过来的 HTTPS 流量

    - 再假设浏览器请求 https://www.google.com
        - 1.浏览器发 SOCKS 请求到 V2Ray
        - 2.请求来到 V2Ray 的 inbound，再到路由过程
        - 3.www.google.com 不在 gesoite:cn，也没匹配任何规则，本来应该直接走主 outbound: proxy，但因为我们用了 IPIfNonMatch 策略，V2Ray 会去尝试使用内置的 DNS 把 www.google.com 的 IP 解析出来
        - 4.V2Ray 使用内置 DNS 向 8.8.8.8 发起针对 www.google.com 的 DNS 请求，这个请求的流量将会是 UDP 流量
        - 5.内置 DNS 发出的 DNS 请求会按路由规则走，因为 8.8.8.8 匹配了路由中的第一条规则，这个 DNS 请求的流量会走 proxy
        - 6.proxy 向远端代理服务器发起 TCP 代理连接（因为 "network": "tcp"）
        - 7.建立起 TCP 连接后，proxy 向远端代理服务器发出 udp:8.8.8.8:53 这样的代理请求
        - 8.远端服务器表示接受这个代理请求后，proxy 用建立好的 TCP 连接向远端服务器发送承载了 DNS 请求的 UDP 流量（所以 V2Ray/VMess 目前是 UDP over TCP）
        - 9.远端代理服务器接收到这些承载 DNS 请求的 UDP 流量后，发送给最终目标 udp:8.8.8.8:53
        - 10.8.8.8.8 返回给远端代理服务器 DNS 结果后，远端代理服务器原路返回至本地 V2Ray 的内置 DNS，至此，从步骤 5 ~ 11，整个 DNS 解析过程完成。


        - 11.接上面步骤 4，V2Ray 得到 www.google.com 的 IP，再进行一次规则匹配，很明显路由规则中没有相关的 IP 规则，所以还是没匹配到任何规则，最终还是走了主 outbound: proxy
        - 12.proxy 向远端代理服务器发起 TCP 代理连接（因为 "network": "tcp"）
        - 13.连接建立后，因为 proxy 中所用的 VMess 协议可以像 SOCKS 那样把域名交给代理服务器处理，所以本地的 V2Ray 不需要自己解析 www.google.com，把域名放进 VMess 协议的参数中一并交给代理服务器来处理
        - 14.远端的 V2Ray 代理服务器收到这个代理请求后，它可能自己做域名解析，也可能继续交给下一级代理处理，只要后续代理都支持类 SOCKS 的域名处理方式，这个 DNS 请求就可以一推再推，推给最后一个代理服务器来处理，这个超出本文范围不作讨论，反正这个域名不需要我们本地去解析
        - 15.远端代理服务器最后会发出针对 www.google.com 的 DNS 请求（至于究竟是如何发，发到哪个 DNS 服务器，我们不一定能知道，也不关心这个）
        - 16.远端代理服务器得到 DNS 结果后，可以真正地向 Google 的服务器建立 TCP 连接18. 远端的 V2Ray 做好准备后告诉本地 V2Ray 连接建立好了，可以传数据了
        - 18.本地 V2Ray 就告诉浏览器连接好了，可以传数据了，浏览器就可以把 HTTPS 流量顺着这个代理链发送至 Google 的服务器


        - 步骤 5 ~ 11 做了次 DNS 请求，采用代理转发 DNS 请求流量的方式，而在步骤 14 中，又说可以不解析域名，交给远端服务器来解析，这两者其实并不冲突。
            - 一般来说，前者的处理方式就是实实在在的 UDP 流量代理而已，后者一般叫作远程 DNS 解析。

        - 用了 `IPIfNonMatch` ，对域名做一次 DNS 解析要经过 5 ~ 11 这么多步骤，看起来效率很慢，但如果代理服务器不慢的话，这个过程一般是很快的，最重要的是 V2Ray 内置 DNS 对 DNS 结果有一个缓存，所以并不需要每次都去做 DNS 请求。不管怎么说，毕竟还是做了额外的事情，而且有可能涉及到一个 UDP over TCP 的代理请求，的确会相对地慢点。

##### 内置的dns模块

- V2Ray 的内置 DNS 其实也只是一个很简单的功能模块，它为 V2Ray 内部其它模块提供 DNS 功能，它接受一个域名作为输入，返回一个 IP 列表作为输出。

    - 内置dns模块代码：输入参数是域名，输出是 IP 列表以及一个错误信息；如果正常返回，错误信息会是空的，IP 列表可以同时有 IPv4 和 IPv6 地址：

        ```go
        LookupIP(domain string) ([]net.IP, error)
        LookupIP（domain string）（[]net.IP，error）
        ```

    - 至于内置 DNS 内部是否做域名分流，内部向哪个 DNS 服务器发出 DNS 请求，用何种方式发这个 DNS 请求，其它模块是管不着的，也完全不知情的。这样看内置 DNS 功能就很简单，其它模块，比如上面提到路由模块用内置 DNS 来解析域名后用 IP 再次进行匹配（或者后面会提到的 DNS outbound 模块），其实就是这样调用了内置 DNS：

        ```
        路由模块：我有一个域名，给你（内置 DNS 模块），帮我查查它的 IP 地址是什么
        内置 DNS 模块按照自己的配置，做了各种处理，最终得到 IP 地址
        内置 DNS 模块：这就是它（域名）的 IP，给你（路由模块）
        ```

###### 基本配置

- 下面的例子中所说的都是路由模块去调用内置 DNS，但路由模块仅仅是用它的结果来做规则匹配，而且是当配置了 IPIfNonMatch/IPOnDemand ，而且没有匹配任何域名规则的情况下，才用得到它，当下各种域名列表盛行，它的应用范围实际上是很窄的。

- 内置 DNS 支持 `hosts`

    - 例子：路由模块要查 www.google.com 的 IP，传它给内置 DNS，但如果内置 DNS 根本就不发任何 DNS 请求，不做任何额外处理，直接就返回一个 127.0.0.1 给路由模块

    ```json
    "dns": {
      "hosts": {
        "www.google.com": "127.0.0.1"
      }
    }
    ```

- 内置 DNS 的 `servers`

    - 例子：路由模块传入 www.bilibili.com 这个域名，想要它的 IP 地址，内置 DNS 会从上至下按顺序，向 servers 里每个 DNS 服务器发 DNS 请求，一个一个地来，直到有结果返回，然后再把结果返回给路由模块。

    ```json
    "dns": {
        "servers": [
            "8.8.8.8",
            "223.5.5.5",
            "localhost"
        ]
    }
    ```

    - 内置 DNS 在向 servers 列表中的 `localhost` 发 DNS 请求时，不会用任何 outbound 来发（甚至不用 Freedom outbound），而是直接从本机发出，就像任何其它程序做 DNS 请求那样，直接调用系统的 DNS API，用系统 DNS 中配置的 DNS 服务器。

    - 从内置 DNS 向 servers 列表中的 DNS 服务器发出的 DNS 请求的流量，并不是从本机直接发到对应的服务器（localhost 除外），而是会通过 outbound 发出去，假如是 Freedom outbound，的确还是会从本机直接发到相应 DNS 服务器，但假如是一个 VMess outbound，DNS 请求的流量就会被代理到 VMess 代理服务器上，由代理服务器发到相应的 DNS 服务器。

        ```
        内置 DNS -> 通过路由功能选择了 Freedom outbound -> 8.8.8.8
        内置 DNS -> 通过路由功能选择了 VMess outbound -> VMess 代理服务器 -> 8.8.8.8
        ```

- `DNS 分流`功能

    - 问题：查的域名是 www.bilibili.com，一般来说是不太合适向 8.8.8.8 查这个域名。所以无论路由模块判断走 Freedom outbound 还是 VMess outbound，都不合适。
        - 走 Freedom outbound 发到 8.8.8.8，恐怕返回结果是假的
        - 走 VMess outbound，恐怕返回结果是国外 CDN 的。

        - 我们只想这个 DNS 请求能够合理地发出，很明显的一个选择就是让这个 www.bilibili.com 的 DNS 请求发到 223.5.5.5，且走 Freedom outbound。

    - 解决方法：这样配置内置 DNS，虽然 8.8.8.8 在第一，但因为要查询的域名 www.bilibili.com 匹配了第二项中的域名规则，内置 DNS 就会优先向第二个 DNS 服务器发出 DNS 请求。

        ```json
        "dns": {
            "servers": [
                "8.8.8.8",
                {
                    "address": "223.5.5.5",
                    "port": 53,
                    "domains": [
                        "domain:www.bilibili.com"
                    ]
                },
                "localhost"
            ]
        }
        ```

    - 问题：就算 DNS 分流配置好了，如果路由规则配置不当，让 udp:223.5.5.5:53 的流量走了 proxy，就有可能发生上面第二个线路，返回的 IP 地址就有可能是 Bilibili 在国外 CDN 的 IP。（IP 结果是真的，只是…）

        - 所以千万不能忘记，除了配置好 DNS 分流域名，还要为各个 DNS 服务器配置路由规则：

        ```json
        "routing": {
            "domainStrategy": "IPIfNonMatch",
            "rules": [
                {
                    "type": "field",
                    "ip": [
                        "8.8.8.8"
                    ],
                    "outboundTag": "proxy"
                },
                {
                    "type": "field",
                    "ip": [
                        "223.5.5.5"
                    ],
                    "outboundTag": "direct"
                }
            ]
        }
        ```

- 内置 DNS 的 `clientIp`

    - 问题：不太建议去依赖这个选项，但如果你想知道它的作用，是这样的，假如上面例子中真的在路由规则上配置错了，出现了这个线路的情况：

        ```
        内置 DNS 查询 www.bilibili.com -> 内置 DNS 通过分流功能选择了 223.5.5.5 -> 通过路由功能选择了 VMess outbound -> VMess 代理服务器 -> 223.5.5.5
        ```

    - 解决方法：那 `clientIP` 是 DNS 请求中可以带上的一个参数，它用来提示 DNS 服务器（223.5.5.5）你所在的地理位置，223.5.5.5 就知道你在哪，就 有可能 会返回一个合适你所在的地理位置的 CDN 的 IP（也即 Bilibili 国内 CDN 的 IP）。

###### DNS outbound

- DNS outbound：可以说是一个把内置 DNS 的功能真正地开放出来，让各种程序、各种模块可以更加方便地使用得上内置 DNS 的一个功能。

    - 为什么要把内置 DNS 开放出来呢？很明显啊，因为现在它支持 `DNS 分流`

- DNS outbound 的配置，它目前就只有那么 3 （network, address, port）个配置项：

    ```json
    "outbounds": [
        {
            "tag": "dns-out",
            "protocol": "dns",
            "settings": {
                "network": "tcp",
                "address": "1.1.1.1",
                "port": 53
            }
        }
    ]
    ```

- DNS outbound 最重要的功能是它的默认行为：对进来的 DNS 流量进行拦截、解析，以及对 A, AAAA 类型的 DNS 查询做重新转发。

    - 一般这种 DNS 请求都是明文（我们也只讨论这种 DNS），它们所流经的各种设备，各种程序都可以看到，可以修改里面的内容，发出的请求可以修改，返回的结果也可以修改，甚至修改过后毫无痕迹，就是说，对于发出的请求，DNS 服务器没办法知道它是否在中间链路被修改过，对于返回的结果，应用程序也没办法知道它是否在中间链路被修改过。

    - DNS 劫持：DNS outbound 本身的工作原理相信已经比较清晰了，它只是劫持了进来的 DNS 请求的流量，然后找内置 DNS 模块帮忙解析 DNS，然后假装啥事没发生，返回结果而已。
        - 1.某个应用程序发了一个 DNS 查询
        - 2.这个 DNS 查询的流量通过某种方式进入了 DNS outbound（这里暂时不讨论究竟是通过什么方式进入 DNS outbound 的）
        - 3.如果这个流量是个明文 DNS 请求，DNS outbound 肯定看得到里面内容，可以拿出里面的域名
        - 4.DNS outbound 调用内置 DNS 模块，把拿到的域名传进去
        - 5.内置 DNS 模块根据它的配置去查这个域名的 IP，具体怎么查的，DNS outbound 并不知道，它只管要结果
        - 6.内置 DNS 返回一些 IP 给 DNS outbound 后，DNS outbound 用这些 IP 生成了一个 DNS 回复
        - 7.DNS outbound 把这个 DNS 回复若无其事地返回给应用程序
        - 8.应用程序当然不知道这个 DNS 回复具体是怎么来的，它没办法，只能相信中间链路，相信这个回复就是它想要的回复

- SOCKS5 协议可以带上域名给远端解析（SOCKS4不支持），根本不需要本地去解析域名。但假如不是用浏览器的情况呢？比如运行一个 `nslookup` 命令，默认它也不会用系统设置的代理，它是直接向系统设置的 DNS 服务器发 DNS 请求，怎么把这个请求的流量引导到 V2Ray 的 DNS outbound 呢？

    - 这个配置让 V2Ray 的 `dokodemo-door` inbound 监听在本地 53 端口，对于任何进来的流量，会因为我们的路由规则，而被送到 DNS outbound 处理，然后我们把系统 DNS 设置为 127.0.0.1，相当于说 V2Ray 的 `dokodemo-door` inbound 就是一个 DNS 服务器。

        ```json
        {
            "inbounds": [
                {
                    "port": 53,
                    "tag": "dns-in",
                    "protocol": "dokodemo-door",
                    "settings": {
                        "address": "1.1.1.1",
                        "port": 53,
                        "network": "tcp,udp"
                    }
                }
            ],
            "dns": {
                "hosts": {
                    "domain:www.bilibili.com": "1.2.3.4"
                }
            },
            "outbounds": [
                {
                    "protocol": "dns",
                    "tag": "dns-out"
                },
                {
                    "protocol": "freedom",
                    "tag": "direct",
                    "settings": {}
                }
            ],
            "routing": {
                "rules": [
                    {
                        "type": "field",
                        "inboundTag": ["dns-in"],
                        "outboundTag": "dns-out"
                    }
                ],
                "strategy": "rules"
            }
        }
        ```

    - 1.命令行执行 nslookup www.bilibili.com
    - 2.因为系统 DNS 设置为 127.0.0.1
    - 3.DNS 请求发到 dokodemo-door inbound
    - 4.因为 "dns-in" -> "dns-out" 路由规则，流量传给 DNS outbound
    - 5.DNS outbound 识别到是个 DNS 请求，拿到域名 www.bilibili.com，调用内置 DNS
    - 6.这个域名匹配到内置 DNS 的一条 hosts 规则，返回结果 1.2.3.4
    - 7.于是 nslookup 查询 www.bilibili.com 的结果是 1.2.3.4

    - 让 V2Ray 充当 DNS 服务器，设置系统 DNS 是其中一个把 DNS 流量引导到 DNS outbound 中的方式。但今天我们大部分的上网操作都是在浏览器上进行了，浏览器用了 SOCKS5 代理的话也不需要本地去解析 DNS，所以这个应用场景不常见。

- DNS outbound 开放出来后，最重要的应用场景，是在移动端和路由器上。

    - 在讨论移动端和路由器之前，先看看桌面系统上怎样可以做真正的全局代理。前面也说了，一般的浏览器代理，只代理浏览器的流量，要把 DNS 流量也代理了，就需要像上面那样更改系统 DNS 为 127.0.0.1，**当我们需要真正的全局代理时（VPN 就是真正的全局代理）**，这种方便显然不合适，也不可能做得到真正全局代理。


    - tun2socks：能够把所有本机应用程序发出的流量都交给 V2Ray/SOCKS/Shadowsocks，从而达到全局 TCP/UDP 代理（对，只是 TCP/UDP，ICMP 等等是不支持的，全局性还是不比真正的 VPN）。

        - tun2socks 就是这么一种可以把所有应用程序的 TCP/UDP 流量都交给 V2Ray 的方式，当然其中包括 DNS 的流量，所以用了 tun2socks 后，我们甚至不需要更改系统的 DNS 设置，所有 DNS 请求的流量都能够被引导到 V2Ray，然后我们可以在 V2Ray 里加一条路由规则，识别出 DNS 的流量，把这些流量转给 DNS outbound：

    - 配置做了简化，真拿来用的话要自己补上其它部分。配置中没有 inbound，因为我们所用的 tun2socks 软件：[go-tun2socks](https://github.com/eycorsican/go-tun2socks) 本身把 tun2socks 内置为 V2Ray 的一个 inbound 了。

        ```json
        {
            "dns": {
                "hosts": {
                    "domain:www.bilibili.com": "1.2.3.4"
                }
            },
            "outbounds": [
                {
                    "protocol": "dns",
                    "tag": "dns-out"
                },
                {
                    // VMess outbound
                }
            ],
            "routing": {
                "rules": [
                    {
                        "type": "field",
                        "network": "udp",
                        "port": 53,
                        "outboundTag": "dns-out"
                    }
                ],
                "strategy": "rules"
            }
        }
        ```

    - 说白了，目的还是之前所说的，找到一种方法把 DNS 请求的流量引导到 DNS outbound 中。

        - `go-tun2socks` 是一个命令行工具，要使用的话还要自己创建 TUN 接口，配置路由表等，比较繁琐

        - `Mellow `：对 go-tun2socks 进行了包装，可以自动完成这些繁琐的步骤，实际使用起来的效果就相当于 Proxifier、SSTap、Surge for Mac 等软件，可以把所有流量都代理了：

        - 在移动端系统方面，iOS 既可以像桌面系统用 tun2socks 那样把所有 TCP/UDP 流量引导到 V2Ray，也可以设置一个 HTTP 代理把 HTTP 请求代理到 V2Ray 的 HTTP inbound 里；而 Android，只能以 tun2socks 那样的方式把 TCP/UDP 流量引导进去。

            - iOS 的 HTTP/S 代理跟 SOCKS5 代理比较相似，应用程序不需要自己解析 DNS，可以把域名带上交给 V2Ray，然后如果请求匹配到代理的路由规则，这个域名就通过代理协议（VMess/Shadowsocks/SOCKS5）交给代理服务器自己去解析，所以本地不需要做任何 DNS 解析。问题是很明显这个只适用于 HTTP/S 请求（而且并不是所有的 HTTP/S 请求，貌似应用程序还必须要用 iOS 系统提供的 HTTP 库来做请求才会被代理到）。

            - 假如你使用的 Android 客户端是 [Kitsunebi](https://play.google.com/store/apps/details?id=fun.kitsunebi.kitsunebi4android)，那大致上可以这么配置：

                ```json
                {
                    "dns": {
                        "hosts": {
                            "domain:www.bilibili.com": "1.2.3.4"
                        },
                        "servers": [
                            "114.114.114.114",
                            {
                                "address": "8.8.8.8",
                                "domains": [
                                    "google"
                                ],
                                "port": 53
                            }
                        ]
                    },
                    "outbounds": [
                        {
                            "protocol": "vmess",
                            "tag": "proxy"
                        },
                        {
                            "protocol": "freedom",
                            "settings": {},
                            "tag": "direct"
                        },
                     {
                         "protocol": "dns",
                         "tag": "dns-out"
                     }
                    ],
                    "routing": {
                        "rules": [
                            {
                                "inboundTag": ["tun2socks"],
                                "network": "udp",
                                "port": 53,
                                "outboundTag": "dns-out",
                                "type": "field"
                            },
                            {
                                "ip": [
                                    "8.8.8.8/32"
                                ],
                                "outboundTag": "proxy",
                                "type": "field"
                            }
                        ],
                        "strategy": "rules"
                    }
                }
                ```

            - 配置中的 inboundTag tun2socks 是必须的，虽然单凭 53 端口 和 network udp 大致达到识别出 UDP 流量的目的，但因为在 V2Ray 中 UDP 流量并不只从 tun2socks inbound 进来，还会从 内置 DNS 那边过来，如果不加上 inboundTag tun2socks 这个限制，内置 DNS 那边过来的流量就会被转到 DNS outbound，接着有可能又被转给 内置 DNS，造成环路。

###### Fake DNS

- 虽然现在已经可以完全利用 V2Ray 的 DNS 功能模块对 DNS 的 UDP 流量做各种处理，可以对 DNS 请求按域名做分流，但仔细想想，分流时不管是发到 freedom outbound 直连还是发到 VMess outbound 代理，这些 DNS 请求终究是要以实际的流量形式从本地发送到互联网上，是否有方法可以在利用 tun2socks 获取所有 TCP/UDP 流量的同时，又可以像 HTTP/S 和 SOCKS5 代理那样，本地完全不发出 DNS 请求流量，只把域名交给代理服务器，让代理服务器自己去解析呢？

    - 答案是有的，那就是 Fake DNS

- 大致工作原理如下：

    - 1.手机上某个 app 想发出 https://www.google.com 请求
    - 2.app 发出 www.google.com 的 DNS 查询
    - 3.DNS 请求的 UDP 流量来到 tun2socks，被 tun2socks 交到 Fake DNS 模块
    - 4.Fake DNS 模块选择一个伪造的 IP 地址，比如 244.0.0.3，并把这个地址跟 www.google.com 关联起来
    - 5.Fake DNS 根据 DNS 请求，生成相应的 DNS 答复，并把 244.0.0.3 当作 DNS 结果放进答复中，通过 tun2socks 把这个伪造的 DNS 答复返回给 app
    - 6.app 得到 www.google.com 的 DNS 查询结果是 244.0.0.3
    - 7.app 向 244.0.0.3 发出 HTTP 请求流量
    - 8.HTTP 请求流量来到 tun2socks，tun2socks 向 Fake DNS 模块查询目的地址 244.0.0.3 是否是一个伪造的 IP 地址，如果是，向 Fake DNS 查询这个 IP 所关联的 域名，也即 www.google.com
    - 9.tun2socks 现在已经得到 HTTP 请求流量的域名，把流量以及域名一并交给 V2Ray
    - 10.V2Ray 有了域名，接下来路由什么的该怎么处理就怎么处理了

    - 上面过程中，虽然 app 是发出了 DNS 请求流量，但这个流量被拦截下来了，并没有真正地发到互联网上；最终 V2Ray 也拿到了域名，如果这个域名匹配到代理规则，就会交到代理服务器来解析，也就是所谓的 远程 DNS 解析。

    - 上面过程中，Fake DNS 模块如果没有对域名做过滤，对任何域名都返回伪造的 IP 地址，则可能会引起一些问题，有一种做法是在 Fake DNS 模块里内置一个域名列表，只对匹配到列表的域名返回 伪造 DNS 答复。

- Fake DNS 不管是原理上还是实现上都是非常简单的，如果有兴趣可以看一下 [这里的实现代码](https://github.com/eycorsican/leaf/blob/master/leaf/src/app/fake_dns.rs)
。
###### DNS fallback

- 需要说明的是，如果用了 V2Ray 的技术，或者 Fake DNS，那 DNS fallback 是没必要的，DNS fallback 也是一种处理 DNS 相关问题技术，这里只是想把这种技术也列举出来

- DNS fallback 是一种可以强制让应用程序把 DNS 请求以 TCP 流量发送出去的技术。

    - 众所周知一般的 DNS 请求都是用 UDP 发的，但 DNS 的 UDP 报文的大小会被限制在大概 512 字节，如果某个 DNS 答复很长，超过了这个限制，就不能通过 UDP 来传输了，为此 DNS 规范中提出，对于这种超过限制大小的 DNS 请求，DNS 服务器可以在答复中设置一个 flag（truncated），来告诉客户端这个答复太长，你不能用 UDP 来做这个 DNS 请求，请用 TCP，于是客户端就会用 TCP 来重新请求 DNS。

    - DNS fallback 正是利用了这一点，在 tun2socks 给过来的 UDP 流量中识别出 DNS 请求，然后伪造一个设置了 truncated flag 的答复返回给客户端，客户端就会转用 TCP 来做 DNS 请求了。

- DNS fallback 的实现也是非常简单的，有兴趣可以看一下 [这里的代码](https://github.com/eycorsican/go-tun2socks/blob/master/proxy/dnsfallback/udp.go)。


## 表示层

### 密钥算法

- [视频（技术蛋老师）：【不懂数学没关系】DH算法 | 迪菲-赫尔曼Diffie–Hellman 密钥交换](https://www.bilibili.com/video/BV1sY4y1p78s)

- [视频（技术蛋老师）：数学不好也能听懂的算法 - RSA加密和解密原理和过程](https://www.bilibili.com/video/BV1XP4y1A7Ui)

- [视频（奇乐编程学院）：探秘公钥加密算法 RSA](https://www.bilibili.com/video/BV14y4y1272w)

    > 对比上一个rsa视频，对欧拉函数有进一步介绍

- [视频（技术蛋老师）：公钥加密技术ECC椭圆曲线加密算法原理](https://www.bilibili.com/video/BV1BY411M74G)

    ```nginx
    # 在nginx上选择最快的 x25519 椭圆曲线
    ssl_ecdh_curve X25519:secp384r1;
    ```

- AES

    ```sh
    # 查看cpu是否支持AES指令集
    grep module /proc/crypto | grep aes
    ```

    ```nginx
    # nginx选用 AES_128_GCM，它比 AES_256_GCM 快一些
    ssl_ecdh_curve 'EECDH+ECDSA+AES128+SHA:RSA+AES128+SHA';
    ```

### 数字签名和数字证书

- [视频（技术蛋老师）：数字签名和CA数字证书的核心原理和作用](https://www.bilibili.com/video/BV1mj421d7VE)

- [阮一峰：数字签名是什么？](https://www.ruanyifeng.com/blog/2011/08/what_is_a_digital_signature.html)

- 数字证书和CA：因为公钥是任何人都可以发布的，所以我们需要引入第三方来保证公钥的可信度，这个“第三方”就是我们常说的 CA（Certificate Authority，证书认证机构）。小一点的 CA 可以让大 CA 签名认证，但链条的最后，也就是 Root CA

    ![image](./Pictures/net-kernel/http_certificate.avif)
    ![image](./Pictures/net-kernel/http_certificate1.avif)

    - 1.首先 CA 会把持有者的公钥、用途、颁发者、有效时间等信息打成一个包，然后对这些信息进行 Hash 计算，得到一个 Hash 值；

    - 2.然后 CA 会使用自己的私钥将该 Hash 值加密，生成 Certificate Signature，也就是 CA 对证书做了签名；

- 数字签名：原理其实很简单，就是把公钥私钥的用法反过来，之前是公钥加密、私钥解密，现在是私钥加密、公钥解密。但又因为非对称加密效率太低，所以私钥只加密原文的hash值，这样运算量就小的多，而且得到的数字签名也很小，方便保管和传输。

    ![image](./Pictures/net-kernel/http_digital.avif)

- 证书验证：

    - 服务器会在 TLS 握手过程中，把自己的证书发给客户端，以此证明自己身份是可信的。

        - OCSP Stapling：服务器向 CA 周期性地查询证书状态，获得一个带有时间戳和签名的响应结果并缓存它。当有客户端发起连接请求时，服务器会把这个「响应结果」在 TLS 握手过程中发给客户端。由于有签名的存在，服务器无法篡改，因此客户端就能得知证书是否已被吊销了，这样客户端就不需要再去查询。

    - 服务器的证书应该选择椭圆曲线（ECDSA）证书，而不是 RSA 证书，因为在相同安全强度下， ECC 密钥长度比 RSA 短的多

### tls

- [视频（技术蛋老师）：HTTPS是什么？加密原理和证书。SSL/TLS握手过程](https://www.bilibili.com/video/BV1KY411x7Jp)

- [视频（技术蛋老师）：TLS/1.2和TLS/1.3的核心区别 | HTTPS有哪些不安全因素 ](https://www.bilibili.com/video/BV12X4y197Pr)

- [李银城：https连接的前几毫秒发生了什么](https://www.rrfed.com/2017/02/03/https/)

![image](./Pictures/net-kernel/tls_history.avif)

- tls分为握手协议和记录协议：

    握手协议：
    ![image](./Pictures/net-kernel/tls_handshake-protocol.avif)

    记录协议：
    ![image](./Pictures/net-kernel/tls_record-protocol.avif)

- tls1.2：四次握手

    - [小林coding：HTTPS RSA 握手解析](https://www.xiaolincoding.com/network/2_http/https_rsa.html#tls-%E6%8F%A1%E6%89%8B%E8%BF%87%E7%A8%8B)

    ![image](./Pictures/net-kernel/tls1.2.avif)
    ![image](./Pictures/net-kernel/tls1.2-1.avif)
    ![image](./Pictures/net-kernel/tls1.2_wireshark.avif)

    - 第一次握手 `Client Hello`：是客户端告诉服务端，它支持什么样的加密协议版本，比如 TLS1.2，使用什么样的加密套件，比如最常见的RSA，同时还给出一个客户端随机数。

    - 第二次握手 `Server Hello`：服务端告诉客户端，服务器随机数 + 服务器证书 + 确定的加密协议版本（比如就是TLS1.2）。

    - 第三次握手：

        - `Client Key Exchange`: 此时客户端再生成一个随机数，叫 `pre_master_key` 。从第二次握手的服务器证书里取出服务器公钥，用公钥加密 `pre_master_key`，发给服务器。

        - `Change Cipher Spec`: 客户端这边已经拥有三个随机数：客户端随机数，服务器随机数和`pre_master_key`，用这三个随机数进行计算得到一个"会话秘钥"。此时客户端通知服务端，后面会用这个会话秘钥进行对称机密通信。

        - `Encrypted Handshake Message`：客户端会把迄今为止的通信数据内容生成一个摘要，用"会话秘钥"加密一下，发给服务器做校验，此时客户端这边的握手流程就结束了，因此也叫Finished报文。

    - 第四次握手：

        - `Change Cipher Spec`：服务端此时拿到客户端传来的 pre_master_key（虽然被服务器公钥加密过，但服务器有私钥，能解密获得原文），集齐三个随机数，跟客户端一样，用这三个随机数通过同样的算法获得一个"会话秘钥"。此时服务器告诉客户端，后面会用这个"会话秘钥"进行加密通信。

        - `Encrypted Handshake Message`：跟客户端的操作一样，将迄今为止的通信数据内容生成一个摘要，用"会话秘钥"加密一下，发给客户端做校验，到这里，服务端的握手流程也结束了，因此这也叫Finished报文。

    - 设置环境变量SSLKEYLOGFILE就可以干预TLS库的行为，让它输出一份含有**随机数**的文件。
        ```sh
        export SSLKEYLOGFILE=/tmp/ssl.key
        ```


- tls1.3：三次握手。废除了不支持前向安全性的 RSA 和 DH 算法，只支持 ECDHE 算法。

    - [交互式解释tls1.3每个步骤](https://tls13.xargs.org/)

    ![image](./Pictures/net-kernel/tls1.3.avif)
    ![image](./Pictures/net-kernel/tls1.2_vs_tls1.3.avif)

- 中间人攻击：前提是用户点击接受了中间人服务器的证书。

    ![image](./Pictures/net-kernel/https_middle_attack.avif)

    - 中间人会发送自己的公钥证书给客户端，客户端验证证书的真伪，然后从证书拿到公钥，并生成一个随机数，用公钥加密随机数发送给中间人，中间人使用私钥解密，得到随机数，此时双方都有随机数，然后通过算法生成对称加密密钥（A），后续客户端与中间人通信就用这个对称加密密钥来加密数据了。

    - 抓包工具就是中间人，需要在客户端安装 Fiddler 的根证书。而这个证书会被浏览器信任，也就是抓包工具给自己创建了一个认证中心 CA

- 双向认证：不仅客户端会验证服务端的身份，而且服务端也会验证客户端的身份

    ![image](./Pictures/net-kernel/http_two-authentication.avif)

#### 为什么我抓不到 baidu 的数据包？

- [小林coding：好气啊！为什么我抓不到 baidu 的数据包？
](https://mp.weixin.qq.com/s?src=11&timestamp=1676189895&ver=4345&signature=bI2NBASrj9x7Rn7H-G2WFFFYf7qKBiI07kAnlKk6aINC70hlR0nxe6gcrbQwQ-8FgKHQr*tKLon3RGlrIoTDS4rrtnjNjbCLlQTjQCZ7dy5Be*m*oDpZgZbT3fZ*LtGH&new=1)

- 因为被加密了，所以没办法通过wireshark中的`http.host`进行过滤。

    - 虽然被加密但还是可以通过 `tls.handshake.extensions_server_name == "baidu.com"` 筛选

- 解决方法：

    ```sh
    # 设置环境变量，从而获取tls的随机数之一pre_master_key
    export SSLKEYLOGFILE=/tmp/ssl.key

    # 在环境变量的环境下curl或打开浏览器，访问baidu。并不是所有应用程序都支持将SSLKEYLOGFILE
    curl 'https://www.baidu.com'

    # 然后在wireshark导入ssl.key：配置->Protocols->TLS->(pre)-master-secret log filename中输入ssl.key的路径
    ```
#### Session

- Session ID：

    - 首次 TLS 握手连接后，双方会在内存缓存会话密钥，并用唯一的 Session ID 来标识。再次连接时，hello 消息里会带上 Session ID，服务器收到后就会从内存找，如果找到就直接用该会话密钥恢复会话状态

    - 缺点：

        - 随着客户端的增多，服务器的内存压力也会越大

        - 多台服务器通过负载均衡提供服务时，客户端再次连接不一定会命中上次访问过的服务器，于是还要走完整的 TLS 握手过程

- Session Ticket：服务器不再缓存每个客户端的会话密钥，而是把缓存的工作交给了客户端，类似于 HTTP 的 Cookie

- 重放攻击：如果中间人截获了某个客户端的 Session ID 或 Session Ticket 以及 POST 报文，而一般 POST 请求会改变数据库的数据，中间人就可以利用此截获的报文，不断向服务器发送该报文，这样就会导致数据库的数据被中间人改变了。因此需要对会话密钥设定一个合理的过期时间。

### [基于TLS1.3的微信安全通信协议mmtls介绍](https://mp.weixin.qq.com/s/tvngTp6NoTZ15Yc206v8fQ)

## Session layer（会话层）

- [Session and Presentation layers in the OSI model](https://www.ictshore.com/free-ccna-course/session-and-presentation-layers/)

> 定义数据的重传、重排。tcp已经包含了这些功能，所以一般用于udp；为音视频、实时流（real-time-streams）提供服务。

### RTP

> VoIP技术基于rtp协议。rtp基于udp之上实现了重排、计时的功能

- header

    ![image](./Pictures/net-kernel/UDP_RTP_header.avif)

    - `Sequence number`：可以重排，但不能重传

## MTU 和 MSS 和 分段(fragmentation)

- [洋芋编程：网络辣鸡自救指南 - MTU, MSS 傻傻分不清楚 ?](https://mp.weixin.qq.com/s/NxanJQYr6kyKtSwTGVyanQ)

- [解决 GRE 和 IPsec 中的 IPv4 分段、MTU、MSS 和 PMTUD 问题](https://www.cisco.com/c/zh_cn/support/docs/ip/generic-routing-encapsulation-gre/25885-pmtud-ipfrag.html)

- [（视频）技术蛋老师：IPv4分片问题 | MTU和MSS的核心区别](https://www.bilibili.com/video/BV14GyGY8ENw)

- 概述

    - MTU 属于链路层，计算大小时会包括 IP 数据包的头部和数据。
    - MSS 属于传输层，计算大小时仅包括 TCP 段的数据部分，不包括 TCP 和 IP 头部。
    - UDP 不考虑 MSS，但也应该注意 MTU 限制 (由应用层完成)，避免数据报过大而导致 IP 层分片。

    ![image](./Pictures/net-kernel/MSS和MTU的区别.avif)

- MTU（Maximum Transmit Unit，最大传输单元）：大小根据以太网的标准来设置，以太网标准规定，一个网络帧最大为 1518 字节，去掉以太网头部的 18 字节后，剩余的就是以太网 MTU 的大小1500字节，Wi-Fi 同样为 1500 字节。

    - 假设IP层有 <= 1500 byte 需要发送，只需要一个 IP 包就可以完成发送任务；
    - 假设IP层有 > 1500 byte 数据需要发送，需要分片才能完成发送，分片后的 IP Header ID 相同。

- MSS（Maximum Segment Size，最大报文段长度）：TCP 提交给 IP 层最大分段大小，不包含 TCP Header 和  TCP Option，只包含 TCP Payload ，MSS 是 TCP 用来限制应用层最大的发送字节数。

    - 假设 MTU= 1500 byte，那么 MSS = 1500- 20(IP Header) -20 (TCP Header) = 1460 byte
    - 如果应用层有 2000 byte 发送，那么需要两个切片才可以完成发送，第一个 TCP 切片 = 1460，第二个 TCP 切片 = 540。

    - 如果一个 IP 分片丢失，整个 IP 报文的所有分片都得重传。经过 TCP 层分片后，如果一个 TCP 分片丢失后，进行重发时也是以 MSS 为单位，而不用重传所有的分片。但tcp丢包会因为拥塞控制严重影响性能。

    - MSS 由 TPC 连接的双方在 TCP 3次握手过程中协商得出的，由 MSS 值较小的一方决定。
        - ![image](./Pictures/net-kernel/tcp_mss.avif)

        - 如图所示 (Wireshark 抓包)，TCP 三次握手建立连接时，第一个和第二个包中，发送方和接收方分别声明了自己的 MSS:

            - 发送方声明了自己的 MSS = 1460 (字节)
            - 接收方声明了自己的 MSS = 1412 (字节)

        - 三次握手之后，发送方知道自己的 MTU 比接收方的要大，如果直接发送 1460 字节的包，很可能在网络链路中的某个节点被分片或者丢包了，所以在接下来传输数据时，发送方会将自己的 MSS 调整为 1412。

        - 但是需要注意的是: 如果网络链路中的某个节点的 MTU 比发送方和接收方的更小，那么数据包还是会被分片。

### IPv4 Fragmentation （分段）

- 尽管 IPv4 数据报的最大长度为 65535 字节，但大多数传输链路强制执行更小的最大数据包长度限制（即 MTU）

- 当发送方发给接收方的数据包 (例如 2500 字节大小) 经过路由器时，如果超过路由器的 MTU 大小 (例如路由器 MTU 只有 1500)，路由器如何做出选择，取决于数据包在网络层是否设置了 `DF`（Don't fragment）标志:
    - 1.如果设置了，直接丢弃数据包
    - 2.如果没设置，数据包被分片再传输

- DF 标志位（一个 IP 包能否分段）：
    | DF bit | 表示                   |
    |--------|------------------------|
    | 0      | may fragment（分段）   |
    | 1      | don't fragment（不分） |

- MF 标志位（分段后，每个分段有 ）：
    | MF bit | 表示           |
    |--------|----------------|
    | 0      | last fragment  |
    | 1      | more fragments |

- ![image](./Pictures/net-kernel/ipv4-fragmentation.avif)

    - 第一个表格：
        - IP 包长度 5140，包括 5120 bytes 的 payload
        - DF = 0， 允许分段
        - MF = 0， 这是未分段

    - 第二个表格：
        - 0-0 第一个分段: 长度 1500 = 1480 (payload) + 20 (IP Header). Offset(起始偏移量): 0
        - 0-1 第二个分段: 长度 1500 = 1480 (payload) + 20 (IP Header). Offset: 185 = 1480 / 8
        - 0-2 第三个分段: 长度 1500 = 1480 (payload) + 20 (IP Header). Offset: 370 = 185 + 1480/8
        - 0-3 第四个分段: 长度 700 =  680 (payload, = (5140 - 20) - 1480 * 3) + 20 (IP Header) . Offset: 555 = 370 + 1480/8

- 分段的问题：
    - 导致CPU和内存开销小幅增加
    - 执行重组的路由器会选择可用的最大缓冲区(18K)，因为在收到最后一个分段之前，它无法确定原始IPv4数据包的大小。
    - 第4层(L4)到第7层(L7)信息过滤或处理数据包的防火墙无法处理ipv4的分段
 jj   - 丢弃其中一个分段包，需要重传根据tcp还是udp决定
        - tcp有编号确认机制，只需要重传丢失的那个分段包
        - udp则不可靠

#### MTU相关命令

- ifconfig命令
    ```sh
    # 获取 MTU 值大小
    ifconfig | grep -i mtu

    # 查看某个具体网卡的 MTU
    ifconfig eth0 | grep -i mtu
    ```

- tracepath命令 查看网络链路中的 MTU

    ```sh
    tracepath dbwu.tech
    # 输出主机到目标地址的每一跳
    # 并显示路径中的最小 MTU 值
     1?: [LOCALHOST]                                         pmtu 1500
     1:  10.90.89.46                                           0.500ms
     1:  10.90.91.46                                           0.545ms

    ...

    14:  172.70.212.4                                        191.432ms asymm 15
         Too many hops: pmtu 1500
         Resume: pmtu 1500
    ```

- ping 命令 (Linux 环境) 的几个参数说明:

    - `M do`：设置不允许分片
    - `s` ：设置数据包的有效负载大小（不包括 ICMP 头部的 8 字节）

- ping 命令采用 ICMP 协议来完成探测，ICMP 头大小为 8 字节，IP 头大小为 20 字节，如果网络链路的 MTU 为 1500 字节，那么单个数据包最大长度等于:1500 - 20 - 8 = 1472

    - 首先，先设置数据包大小为 1472，看看是否可以连通:

    ```sh
    ping -M do -s 1472 -c 3 dbwu.tech
    PING dbwu.tech (104.21.71.166) 1472(1500) bytes of data.
    1480 bytes from 104.21.71.166 (104.21.71.166): icmp_seq=1 ttl=50 time=200 ms
    1480 bytes from 104.21.71.166 (104.21.71.166): icmp_seq=2 ttl=50 time=200 ms
    1480 bytes from 104.21.71.166 (104.21.71.166): icmp_seq=3 ttl=50 time=200 ms

    # 通过输出结果可以看到，数据包超过了 MTU，而且不允许分片，所以连通失败了。
    ping -M do -s 1473 -c 3 dbwu.tech
    PING dbwu.tech (172.67.147.110) 1473(1501) bytes of data.
    ping: local error: Message too long, mtu=1500
    ping: local error: Message too long, mtu=1500
    ping: local error: Message too long, mtu=1500

    # 设置允许数据分片后
    ping -s 1473 -c 3 dbwu.tech
    PING dbwu.tech (172.67.147.110) 1473(1501) bytes of data.
    1481 bytes from 172.67.147.110 (172.67.147.110): icmp_seq=1 ttl=51 time=207 ms
    1481 bytes from 172.67.147.110 (172.67.147.110): icmp_seq=2 ttl=51 time=207 ms
    1481 bytes from 172.67.147.110 (172.67.147.110): icmp_seq=3 ttl=51 time=207 ms
    ```

#### PMTU（只有TCP和UDP支持）

- PMTU或叫PMTUD（Path MTU Discovery）是一种用于确定从源到目标地路径上的最大传输单元（MTU）的方法。

    - PMTUD 的基本思想是通过逐步减小数据包大小，确定路径中最小的 MTU 值，具体的工作过程：

    - 1.发送初始数据包：源主机首先假设网络链路的最小 MTU 等于自己的 MTU，发送一个不允许分片（Don't Fragment，IP 报文中的 DF 标志）的大数据包。

    - 2.ICMP "需要分片" 消息：如果数据包在网络链路的某个转发节点因为 MTU 过大 (且不允许分片) 而无法通过，就会直接丢弃数据包并返回一个 ICMP Fragmentation Needed 消息给源主机，并指明路径中此时的 MTU 值。

    - 3.调整数据包大小：源主机接收到 ICMP 消息后，更新 MTU 值，并重发较小的、不允许分片的数据包。

    - 4.重复上述步骤：源主机重复发送不允许分片的数据包，并根据 ICMP 消息不断调整数据包大小，直到数据包成功到达目的地。

    - 最后一次发送的数据包的 MTU 值，也就是整个网络链路中的最小 MTU 值。

- 局限性
    - PMTUD 依赖 ICMP 协议进行探测，但是 ICMP 会被很多网络链路中的设备禁用，所以整体上可用性较差，改进的方法是 PLPMTUD（Packetization Layer Path MTU Discovery），不依赖 ICMP 消息，而是通过传输层协议（如 TCP）的反馈机制来发现网络链路的 MTU。

- TCP MSS解决TCP连接的两个端点上的分段，但不处理这两个端点之间中间有较小MTU链路的情况。

    - PMTU：动态确定从数据包源到目的地的路径中的最低MTU。

- 查看是否开启PMTU
    ```sh
    # 默认为1（关闭PMTU），0为打开
    sysctl net.ipv4.ip_no_pmtu_disc
    net.ipv4.ip_no_pmtu_disc = 0
    ```

- PMTU的工作原理：路由器尝试将IPv4数据报（设置了DF位）转发到其MTU低于数据包大小的链路上，路由器会丢弃数据包，并将互联网控制消息协议(ICMP)“目标无法到达”(Destination Unreachable)消息返回到IPv4数据报源，消息中的代码表示“需要分段并设置DF”（类型3，代码4）。

    - 例子1：数据包可以一直传输到接收方，而不会被分段。
    - 例子2：http连接中：TCP 客户端发送小数据包，服务器发送大数据包。

        - 只有来自服务器的大数据包（大于576字节）触发PMTUD。

        - 客户端的数据包很小（小于576字节），不触发PMTUD，因为它们不需要分段即可通过576 MTU链路。

        ![image](./Pictures/net-kernel/pmtu.avif)

    - 例子3：非对称路由示例，其中一条路径的最小MTU小于另一条路径。

        - TCP 客户端到服务器的流量会经过路由器 A 和路由器 B，
            - 客户端永远不会收到带有表示“需要分段和DF设置”的代码的ICMP“目标无法到达”消息，因为路由器A在通过路由器B向服务器发送数据包时无需对数据包进行分段。

        - TCP 服务器到客户端的返回流量会经过路由器 D 和路由器 C。
            - 服务器向客户端发送数据包时，PMTUD会触发服务器降低发送MSS，因为路由器D必须对4092字节的数据包进行分段，然后才能将其发送到路由器C。

        ![image](./Pictures/net-kernel/pmtu1.avif)

##### PMTU 与 GRE隧道

- GRE包大小
    ![image](./Pictures/net-kernel/gre-overhead.avif)
    ![image](./Pictures/net-kernel/gre-overhead1.avif)
    | 步骤 | 操作/封包    | 协议     | 长度                                             | 备注                 |
    |------|--------------|----------|--------------------------------------------------|----------------------|
    | 1    | ping -s 1448 | ICMP     | 1456 = 1448 + 8 （ICMP header）                  | ICMP MSS             |
    | 2    | L3           | IP       | 1476 = 1456 + 20 （IP header）                   | GRE Tunnel MTU       |
    | 3    | L2           | Ethernet | 1490 = 1476 + 14 （Ethernet header）             | 经过 bridge 到达 GRE |
    | 4    | GRE          | IP       | 1500 = 1476 + 4 （GRE header）+ 20 （IP header） | 物理网卡 （IP）MTU   |
    | 5    | L2           | Ethernet | 1514 = 1500 + 14 （Ethernet header）             | 最大可传输帧大小     |

    - 1514 - 1490 = 24 byte

        - GRE 隧道接口的 IPv4 MTU 默认比物理接口的 IPv4 MTU 少 24 字节，因此 GRE 接口的 IPv4 MTU 为 1476 字节

- DF位=0 和 = 1的两种情况：

    - DF位=0（分段）：
        - 1.发送端发送一个 1500 字节的数据包（20 字节 IPv4 报头 + 1480 字节 TCP 负载）。
        - 2.由于GRE隧道的MTU为1476，因此1500字节的数据包将分为两个IPv4分段（1476字节和44字节），每个分段预计会额外增加24字节的GRE报头。
        - 3.每个 IPv4 分段增加 24 字节的 GRE 报头。现在，两个分段分别为 1500 字节 (1476 + 24) 和 68 字节 (44 + 24)。
        - 4.包含两个 IPv4 分段的 GRE + IPv4 数据包被转发到 GRE 隧道对等路由器。
        - 5.GRE 隧道对等路由器将删除两个数据包中的 GRE 报头。
        - 6.此路由器将两个数据包转发到目标主机。
        - 7.目标主机将 IPv4 分段重组为原始 IPv4 数据报。

    - DF位=1（不分段），并且路径中存在一条链路，其MTU低于其他链路：
        - 1.路由器收到 1500 字节的数据包（20 字节 IPv4 报头 + 1480 字节 TCP 负载），然后丢弃该数据包。路由器丢弃数据包是因为该数据包大于 GRE 隧道接口上的 IPv4 MTU (1476)。
        - 2.路由器向发送者发送一条 ICMP 错误，通知发送者下一跳 MTU 为 1476。主机将此信息记录在其路由表中，通常作为目标的主机路由。
        - 3.当重新发送数据时，发送主机采用 1476 字节作为数据包大小。GRE 路由器添加 24 字节的 GRE 封装，然后发送一个 1500 字节的数据包。
        - 4.该 1500 字节的数据包无法通过 1400 字节的链路，因此中间路由器将丢弃该数据包。
        - 5.中间路由器将向 GRE 路由器发送一个含有下一跳 MTU 为 1400 的 ICMP（类型 = 3，代码 = 4）。GRE 路由器将其降低至 1376 (1400 - 24) 字节，并在 GRE 接口上设置内部 IPv4 MTU 值。
        - 6.下次主机重新发送1476字节的数据包时，GRE路由器会丢弃该数据包，因为它大于GRE隧道接口上的当前IPv4 MTU(1376)。
        - 7.GRE路由器向下一跳MTU为1376的发送方发送另一个ICMP（类型= 3，代码= 4），主机使用新值更新其当前信息。
        - 8.主机再次重新发送数据，但现在GRE在较小的1376字节数据包中添加24字节的封装并继续转发数据。此时，数据包将发送到GRE隧道对等体，数据包在该对等体解封并发送到目的主机。
        ![image](./Pictures/net-kernel/pmtu-gre-df=1.avif)

##### PMTU 与 IPv4sec

- IPv4sec包大小：52 字节

- IPv4sec隧道模式（默认模式）下，DF位=0 和 = 1的两种情况：

    - DF位=0（分段）：
        - 1.路由器收到发往主机 2 的 1500 字节的数据包（20 字节 IPv4 报头 + 1480 字节 TCP 负载）。
        - 2.1500 字节的数据包经过 IPv4sec 加密，增加了 52 字节的开销（IPv4sec 报头、报尾和另外的 IPv4 报头）。现在 IPv4sec 需要发送 1552 字节的数据包。由于出站MTU为1500，因此必须对此数据包进行分段。
        - 3.IPv4sec 数据包被拆分为两个分段。在分段期间，会为第二个分段添加一个额外的20字节IPv4报头，从而产生一个1500字节的分段和一个72字节的IPv4分段。
        - 4.IPv4sec 隧道对等路由器接收分段，剥离附加的 IPv4 报头，并将 IPv4 分段合并为原始 IPv4sec 数据包。然后 IPv4sec 解密该数据包。
        - 5.最后，路由器将 1500 字节的原始数据包转发到主机 2。
        ![image](./Pictures/net-kernel/pmtu-ipv4sec-df=0.avif)

    - DF位=1（不分段），并且路径中存在一条链路，其MTU低于其他链路：
        - 1.路由器收到1500字节的数据包并将其丢弃，因为添加IPv4sec开销时，数据包会大于PMTU(1500)。
        - 2.路由器向主机 1 发送一条 ICMP 消息，并通知该主机下一跳 MTU 为 1442 (1500 - 58 = 1442)。此58字节是使用IPv4sec ESP和ESPauth时的最大IPv4sec开销。实际IPv4sec开销可能比此值小7个字节。主机 1 通常在其路由表中以目标（主机 2）主机路由的形式记录该信息。
        - 3.主机1将主机2的PMTU降低到1442，因此主机1在将数据重新发送到主机2时发送更小（1442字节）的数据包。路由器接收 1442 字节的数据包，然后 IPv4sec 添加 52 字节的加密开销，由此产生 1496 字节的 IPv4sec 数据包。由于此数据包的报头中设置了 DF 位，因此，采用 1400 字节 MTU 链路的中间路由器将丢弃此数据包。
        - 4.丢弃数据包的中间路由器向 IPv4sec 数据包的发送端（第一个路由器）发送一条 ICMP 消息，告知发送端下一跳 MTU 为 1400 字节。这个值记录在 IPv4sec SA PMTU 中。
        - 5.主机1下次重新传输1442字节的数据包（它未收到该数据包的确认）时，IPv4sec将丢弃该数据包。路由器丢弃该数据包，因为在添加到数据包时，IPv4sec开销会使其大于PMTU(1400)。
        - 6.路由器向主机 1 发送一条 ICMP 消息，通知它下一跳 MTU 现在为 1342。(1400 - 58 = 1342)。主机1再次记录此信息。
        - 7.当主机1再次重新传输数据时，它使用较小大小的数据包(1342)。此数据包不需要分段，而是通过IPv4sec隧道发送到主机2。
        ![image](./Pictures/net-kernel/pmtu-ipv4sec-df=1.avif)

##### PMTU 与 GRE 与 IPv4sec 协同工作

- 使用 IPv4sec 来加密 GRE 隧道

    - IPv4sec 和 GRE 以这种方式组合是因为 IPv4sec 不支持 IPv4 组播数据包，这意味着在 IPv4sec VPN 网络上无法运行动态路由协议。

    - GRE 隧道支持组播，因此可先使用 GRE 隧道加密 GRE IPv4 单播数据包中的动态路由协议组播数据包，然后再使用 IPv4sec 加密单播数据包。

- DF位=0 和 = 1的两种情况：

    - DF位=0（分段）：
        - 1.路由器收到一个 1500 字节的数据报。
        - 2.在封装之前，GRE 将 1500 字节的数据包拆分为两个分段，一个 1476 字节 (1500 - 24 = 1476)，另一个 44 字节（24 字节数据 + 20 字节 IPv4 报头）。
        - 3.GRE 封装 IPv4 分段，该过程将导致每个数据包增加 24 字节。因而将产生两个 GRE + IPv4sec 字段，一个 1500 字节 (1476 + 24 = 1500)，另一个 68 字节 (44 + 24 = 68)。
        - 4.IPv4sec对两个数据包进行加密，每个数据包增加52字节（IPv4sec隧道模式）的封装开销，以提供1552字节和120字节的数据包。
        - 5.由于 1552 字节的 IPv4sec 数据包大于出站 MTU (1500)，因此，路由器会将其分段。1552 字节的数据包被拆分为 1500 字节的数据包和 72 字节的数据包（52 字节负载加上为第二个分段附加的 20 字节 IPv4 报头）。三个数据包（1500 字节、72 字节和 120 字节）被转发到 IPv4sec + GRE 对等设备。
        - 6.接收路由器重组两个 IPv4sec 分段（1500 字节和 72 字节），以便获取原始 1552 字节的 IPv4sec + GRE 数据包。对于 120 字节的 IPv4sec + GRE 数据包无需任何操作。
        - 7.IPv4sec 对 1552 字节和 120 字节的 IPv4sec + GRE 数据包进行解密，以便获取 1500 字节和 68 字节的 GRE 数据包。
        - 8.GRE 解封装 1500 字节和 68 字节的 GRE 数据包，以便获取 1476 字节和 44 字节的 IPv4 数据包分段。然后这些 IPv4 数据包分段被转发到目标主机。
        - 9.主机 2 重组这些 IPv4 分段，以便获取原始 1500 字节的 IPv4 数据报。
        ![image](./Pictures/net-kernel/pmtu-gre-ipv4sec-df=0.avif)

    - DF位=1（不分段）：
        - 1.路由器收到一个 1500 字节的数据包。由于设置了 DF 位，并且在增加 GRE 开销（24 字节）之后数据包大小超过出站接口“ip mtu”，因此 GRE 无法对该数据包进行分段或转发，并丢弃此数据包。
        - 2.路由器向主机 1 发送 ICMP 消息，以便该主机知晓下一跳 MTU 为 1476 (1500 - 24 = 1476)。
        - 3.主机 1 针对主机 2 将其 PMTU 更改为 1476，并在重新传输数据包时发送更小大小。GRE 封装数据包，并将 1500 字节的数据包传递给 IPv4sec。由于 GRE 从内部 IPv4 报头中复制了 DF 位（已设置），并且加上 IPv4sec 开销（最大 38 字节）后，数据包因太大而无法传出物理接口，因此 IPv4sec 丢弃该数据包。
        - 4.IPv4sec向GRE发送ICMP消息，表示下一跳MTU为1462字节（因为为加密和IPv4开销添加了最大38字节）。GRE在隧道接口上将值1438 (1462 - 24)记录为"ip mtu"。
        - 5.主机 1 下次重新传输 1476 字节的数据包时，GRE 将丢弃此数据包。
        - 6.路由器向主机 1 发送 ICMP 消息，指明下一跳 MTU 为 1438。
        - 7.主机 1 针对主机 2 减小其 PMTU，并重新传输 1438 字节的数据包。这次 GRE 接受该数据包，对其进行封装，并将其传递给 IPv4sec 进行加密。
        - 8.IPv4sec 数据包被转发到中间路由器并被丢弃，因为该路由器出站接口 MTU 为 1400。
        - 9.中间路由器向 IPv4sec 发送 ICMP 消息，指明下一跳 MTU 为 1400。IPv4sec 将该值记录在关联 IPv4sec SA 的 PMTU 值中。
        - 10.当主机 1 重新传输 1438 字节的数据包时，GRE 封装该数据包，然后将其传递给 IPv4sec。IPv4sec 丢弃该数据包，因为其已将自己的 PMTU 改为 1400。
        - 11.IPv4sec 向 GRE 发送 ICMP 错误消息，指明下一跳 MTU 为 1362，并且 GRE 在内部记录值 1338。
        - 12.当主机1重新传输原始信息包时(因为没有收到确认)，GRE将丢弃它。
        - 13.路由器向主机 1 发送 ICMP 消息，指明下一跳 MTU 为 1338（1362 - 24 字节）。主机 1 针对主机 2 将其 PMTU 减小至 1338。
        - 14.主机1转发1338字节信息包，同时它可以最终到达主机2。
        ![image](./Pictures/net-kernel/pmtu-gre-ipv4sec-df=1.avif)

### MTU

- [Troubleshooting MTU Issues](https://netbeez.net/blog/troubleshooting-mtu-issues/)

- 如果ip层的网络包的长度比链路层的 MTU 还大，那么 IP 层就需要进行分片

| Packet Size | Interface MTU | DF option (IP header) | Layer 2 interface (switched) | Layer 3 interface (routed) |
|-------------|---------------|-----------------------|------------------------------|----------------------------|
| <= 1500     | 1500          | 0 (unset)             | Pass                         | Pass                       |
| <= 1500     | 1500          | 1 (set)               | Pass                         | Pass                       |
| >= 1500     | 1500          | 0 (unset)             | Discard                      | Fragment                   |
| >= 1500     | 1500          | 1 (set)               | Discard                      | Discard and Notify         |

```sh
# 查看每个网卡的MTU
ip a | grep mtu

# 临时修改mtu
ifconfig eth0 mtu 9000
# 或者
ip link set dev eth0 mtu 9000

# 永久修改mtu。不同的linux发行版有所不同。redhat系修改这个配置文件/etc/sysconfig/network-scripts/ifcfg-eth0
auto eth0
iface eth0 inet static
        address 192.168.0.2
        netmask 255.255.255.0
        mtu 9000
```

- jumebo frames（巨型帧）：标准帧的MTU为1500，jumebo的MTU为9000（需要网卡支持，如intel X520）

### 包的拆分与合并TSO、GSO、LRO、GRO

- 拆分

    ![image](./Pictures/net-kernel/TSO-GSO-off.avif)
    ![image](./Pictures/net-kernel/TSO.avif)
    ![image](./Pictures/net-kernel/GSO.avif)

- 合并

    ![image](./Pictures/net-kernel/LRO-GRO-off.avif)
    ![image](./Pictures/net-kernel/LRO.avif)
    ![image](./Pictures/net-kernel/GRO.avif)

```sh
# 查看是否开启
ethtool -k eth0

tcp-segmentation-offload: on # TSO
generic-segmentation-offload: on # GSO

large-receive-offload: on # LRO
generic-receive-offload: on # GRO
```

```sh
# 开启GRO。修改 GRO 配置会涉及先 down 再 up 这个网卡
sudo ethtool -K eth0 gro on
```



## 传输层

- 三种端口

| 端口类型             | 端口范围    | 内容                         |
|----------------------|-------------|------------------------------|
| Well-known(已知端口) | 0-1023      | HTTP FTP DNS 等              |
| Reserved(保留端口)   | 1024-49151  | 分配给服务端。需要从IANA购买 |
| Dynamic(动态端口)    | 49152-65535 | 分配给客户端                 |

### TCP

- [详解tcp1](https://codeburst.io/understanding-tcp-internals-step-by-step-for-software-engineers-system-designers-part-1-df0c10b86449)

- [详解tcp2](https://codeburst.io/understanding-tcp-internals-step-by-step-for-software-engineers-system-designers-part-2-8557c06c2f7b)

- [tcp 带图详解](https://www.ictshore.com/free-ccna-course/transmission-control-protocol-advanced/)

- [腾讯技术工程：彻底弄懂TCP协议：从三次握手说起](https://cloud.tencent.com/developer/article/1687824)

- [详解的 tcp 连接,丢包后的处理,keepalive,tcp window probes 丢包](https://blog.cloudflare.com/when-tcp-sockets-refuse-to-die/)

- [李银城：WebSocket与TCP/IP](https://www.rrfed.com/2017/05/20/websocket-and-tcp-ip/)

- TCP 连接迁移：受限于 TCP 四元组 的限制，如果源 IP 发生变化，则需要重新建立 TCP 连接，从而导致延迟暂停 (例如当前设备从 Wifi 切换到蜂窝网络)。

- TCP是有三个特点，面向连接、可靠、基于字节流。

    - 字节流：可以理解为一个双向的通道里流淌的数据，这个数据其实就是我们常说的二进制数据，简单来说就是一大堆 01 串。纯裸TCP收发的这些 01 串之间是没有任何边界的，你根本不知道到哪个地方才算一条完整消息。

    - 不可靠的网络：网络是不同节点间共享信息的唯一途径，数据的传输主要通过以太网进行传输，这是一种异步网络，也就是网络本身并不保证发出去的数据包一定能被接到或是何时被收到。
        - 请求丢失
        - 请求正在某个队列中等待
        - 远程节点已经失效
        - 远程节点无法响应
        - 远程节点已经处理完请求，但在ack的时候丢包
        - 远程接收节点已经处理完请求，但回复处理很慢

#### 粘包问题

- [洋芋编程：为什么 TCP 粘包 是正常现象](https://mp.weixin.qq.com/s/6ssSPkbdqNhWe1jmAnUe1Q)

- 粘包问题：TCP 粘包 并不是因为协议本身有 “问题”，而是一种 “正常现象”, 因为 TCP 是面向字节流的协议，数据之间没有所谓 “边界”，所以数据粘包之后的 “拆包” 工作应该 (也必须) 由应用层（如HTTP、RPC）完成。

    - 例子：使用TCP发送"夏洛"和"特烦恼"的时候，接收端收到的就是"夏洛特烦恼"，这时候接收端没发区分你是想要表达"夏洛"+"特烦恼"还是"夏洛特"+"烦恼"。

    - MSS：

        - 如果 MSS 较小，一个完整的数据包会被 TCP 拆分成多个更小的 数据包进行发送，产生拆包现象
        - 如果 MSS 较大，多个完整的数据包会被 TCP 合并为一个更大的 数据包进行发送，产生粘包现象
        ![image](./Pictures/net-kernel/TCP_粘包问题.avif)

    - 缓冲机制：TCP 在发送数据时，会将数据放入发送缓冲区；在接收数据时，会将数据放入接收缓冲区。TCP 会尽可能地将发送缓冲区中的数据打包成一个或多个数据包发送出去，而接收方在读取数据时，也会尽量将接收缓冲区中的数据全部读取出来。

        - 如果要发送的数据小于发送缓冲区大小，TCP 会将多次要发送的数据，全部写入发送缓冲区，然后一起发送，产生粘包现象
        - 如果要发送的数据大于发送缓冲区大小，TCP 会将要发送的数据进行切分，满足写入发送缓冲区的条件，然后发送，产生拆包现象

- 解决方法：

    - 因此纯裸TCP是不能直接拿来用的，你需要在这个基础上加入一些自定义的规则，用于区分消息边界。

        - 只要应用程序对 TCP 的字节流数据能够区分单个消息的标志和边界，那么应用程序就可以将粘包后的数据分割为正常的单个消息，粘包问题自然迎刃而解。

    - 1.设置消息固定长度：接收方从缓冲区读取数据时，每次都读取固定的长度，这样很自然就把单个消息拆分出来

    - 2.设置消息分隔符: 发送方在将单个消息末尾追加分隔符，用来分区单个消息，接收方从缓冲区读取数据后，根据分隔符将读取到的数据切割成一个个单条消息
        - 当然，分隔符很容易出现在要发送的应用数据中，这样就产生了冲突，无法进行正常拆包，所以实际项目中很少使用这种方式。

    - 3.设置消息头部格式: 将消息分为消息头部和消息体，消息头中包含表示消息总长度（或者消息体长度，例如 HTTP 中的 Content-Length）字段，接收方首先读取消息头部，然后根据消息长度字段 读取具体的消息体内容，这也是最常用的方式

    - 4.特定消息格式: 例如将单个消息固定为 JSON 格式，接收方从缓冲区读取数据后，根据读取到的数据能否被解析成合法的 JSON 来判断消息是否结束
        - 当然，实际项目中很少使用这种方式

- 场景：

    - 完全禁止 粘包/拆包 的场景
        - 1.低延迟要求: 在线游戏、股票交易
        - 2.小数据频繁传输，例如 Telnet, SSH 终端

    - 可以忽视 粘包/拆包 的场景
        - 1.小数据传输，且两次传输之间的时间间隔很大，例如 5 秒/次 的心跳
        - 2.使用已经处理了粘包问题的应用层协议，例如 HTTP 使用响应头中的 Content-Length 作为消息分隔符
        - 3.传输数据只需要保证顺序即可，无需区分边界，例如大文件传输，每个数据包都是文件的一小部分而已，因为 TCP 保证了传输顺序性，所以接收方只需要读取数据，然后追加到已有数据的后面即可

#### header(头部)

![image](./Pictures/net-kernel/TCP_header.avif)

- 数据偏移（Data Offset）：该字段长 4 位，单位为 4 字节。表示为 TCP header的长度。所以 TCP 首部长度最多为 60 字节。

- flags

    | flags | 内容                                                                                             |
    |-------|--------------------------------------------------------------------------------------------------|
    | CWR   | 用于 IP 首部的 ECN 字段。ECE 为 1 时，则通知对方已将拥塞窗口缩小。                               |
    | ECE   | 在收到数据包的 IP 首部中 ECN 为 1 时将 TCP 首部中的 ECE 设置为 1，表示从对方到这边的网络有拥塞。 |
    | URG   | 紧急模式                                                                                         |
    | ACK   | 确认                                                                                             |
    | PSH   | 推送，接收方应尽快给应用程序传送这个数据。没用到                                                 |
    | RST   | 该位为 1 表示 TCP 连接中出现异常必须强制断开连接。                                               |
    | SYN   | 初始化一个连接的同步序列号                                                                       |
    | FIN   | 该位为 1 表示今后不会有数据发送，希望断开连接。                                                  |

- 虽然 IP 也有校验和，但只对 IP 分组首部进行计算和校验，所以 TCP 和 UDP 都额外提供了校验和来保护自己的首部和数据。

    - TCP 为数据段中的数据提供了校验和，这样有助于确保抵达目标地址后，检验数据在传输过程中是否被网络损坏。

- 窗口大小（Window）：长度 16 位：即 TCP 数据包长度为 65535字节（大概64KB）；可以通过 Options 字段的 WSOPT 选项(14位)：扩展到30位（2^30 = 1GB）

    ```sh
    # 查看是否启用WSOPT功能（默认开启）
    sysctl net.ipv4.tcp_window_scaling
    net.ipv4.tcp_window_scaling = 1
    ```

- TCP Options：

    - SACK_Permitted：只允许在前两次 TCP 握手的设置，表示两方是否支持 SACK。

    - SACK(选择性确认)。该选项参数告诉对方已经接收到并缓存的不连续的数据块，发送方可根据此信息检查究竟是哪些块丢失，从而发送相应的数据块。受 TCP 包长度限制，TCP 包头最多包含四组 SACK 字段。


    - TSOPT：对应linux内核参数`tcp_timestamps`（默认启用）

        - `tcp_timestamps`：每个 TCP 数据包都会携带一个timestamps（时间戳），用于检测延迟和丢失的数据，计算`RTT`。

            ```sh
            # 查看是否启用，1表示启用（默认启用）
            sysctl net.ipv4.tcp_timestamps
            net.ipv4.tcp_timestamps = 1
            ```

    - RTTM（RTT 测量）：发送方在 TSval 处放置一个时间戳，接收方则会把这个时间通过 TSecr 返回来。因为接收端并不会处理这个 TSval 而只是直接从 TSecr 返回来，因此不需要双方时钟同步。这个时间戳一般是一个单调增的值，[RFC1323] 建议这个时间戳每秒至少增加 1。

        - 第一次握手初始 SYN 包中因为发送方没有对方时间戳的信息，因此 TSecr 会以 0 填充，TSval 则填充自己的时间戳信息。

    - PAWS（防回绕序列号）：PAWS 假设接收到的每个 TCP 包中的 TSval 都是随时间单调增的，基本思想就是如果接收到的一个 TCP 包中的 TSval 小于刚刚在这个连接上接收到的报文的 TSval，则可以认为这个报文是一个旧的重复包而丢掉。

##### Header Compression(头部压缩)

- 此功能用于路由器和卫星连接

- 路由器接受到的包，如果有相同的源、目的ip和源、目的端口的时候。对头部的ip字段和端口字段进行压缩（使用hash id），而不会压缩其它字段。然后转发到下一个路由器，下一个路由器接受到后进行解压缩。

    - 40bytes的header压缩后的只有4bytes

    ![image](./Pictures/net-kernel/TCP_header_compression.avif)

#### TCP 连接

- [tcp 三次握手,四次挥手 in wireshark](https://github.com/zqjflash/tcp-ip-protocol)

- [腾讯技术工程：深入理解 Linux 的 TCP 三次握手（源码解析）](https://aijishu.com/a/1060000000343326)

- [腾讯技术工程：彻底弄懂 TCP 协议：从三次握手说起](https://cloud.tencent.com/developer/article/1687824)

- TCP 协议规范：不对 ACK 进行 ACK

- tcp建立连接；关闭连接

    ![image](./Pictures/net-kernel/TCP_States_in_a_connection.avif)
    ![image](./Pictures/net-kernel/TCP_States_in_a_connection1.avif)

    - 三次握手：

        > 目的是初始化序列号

        - 1.client 端首先发送一个 SYN 包告诉 Server 端我的初始序列号是 X
        - 2.Server 端收到 SYN 包后回复给 client 一个 ACK 确认包，告诉 client 说我收到了；接着 Server 端也需要告诉 client 端自己的初始序列号，于是 Server 也发送一个 SYN 包告诉 client 我的初始序列号是 Y
        - 3.Client 收到后，回复 Server 一个 ACK 确认包说我知道了。

    - 四次挥手：TCP 是全双工的，需要 Peer 两端分别各自拆除自己通向 Peer 对端的方向的通信信道。这样需要四次挥手来分别拆除通信信道

        - 四次挥手变三次挥手：没有数据要发送 + 延迟ack（默认开启），那么第二和第三次挥手就会合并传输，这样就出现了三次挥手。

            ![image](./Pictures/net-kernel/TCP_四次挥手变三次挥手.avif)

        - TCP 的连接信息是由内核维护的，所以当server的进程崩溃后，内核需要回收该进程的所有 TCP 连接资源，还是能与client完成 TCP 四次挥手的过程

    - client和server同时连接

        ![image](./Pictures/net-kernel/TCP_handshake.avif)

    - client和server同时关闭连接

        ![image](./Pictures/net-kernel/TCP_Simultaneous_close.avif)

    - `RST`flag直接进入CLOSED状态

        ![image](./Pictures/net-kernel/TCP_Reset_connection.avif)

        - 第1种情况：server端发送`RST` 后进入`CLOSED`；client端接受`RST` 也进入`CLOSED`

        - 第2种情况：server端发送`RST` 后进入`CLOSED`；但`RST` 丢包了，client端仍在发送数据，但接受不到`ACK` ，超时后进入`CLOSED`

            - 一方发了RST以后，连接一定会终止么?

                ![image](./Pictures/net-kernel/TCP_rst.avif)

                - 不一定会终止，需要看这个RST的Seq是否在接收方的接收窗口之内，Seq号较小的情况下不是一个合法的RST被Linux内核无视了。

- [小林coding：为什么是三次握手？不是两次、四次？](https://www.xiaolincoding.com/network/3_tcp/tcp_interview.html#%E4%B8%BA%E4%BB%80%E4%B9%88%E6%98%AF%E4%B8%89%E6%AC%A1%E6%8F%A1%E6%89%8B-%E4%B8%8D%E6%98%AF%E4%B8%A4%E6%AC%A1%E3%80%81%E5%9B%9B%E6%AC%A1)

    - 防止历史连接：client发送syn，但出现故障重启后发送新的syn后；如果server响应了旧的syn，client收到后发送`RST` 就可以终止了历史连接。

        ![image](./Pictures/net-kernel/TCP_handshake_why.avif)

    - 两次握手的两种问题：

        - client发送syn，但出现故障重启后发送新的syn后；server响应了旧的syn就进入ESTABLISHED状态后：server就建立了历史连接，开始向client发送数据，直到收到client的`RST` 才关闭连接。之前的数据就白白发送了。

            ![image](./Pictures/net-kernel/TCP_handshake_why1.avif)

        - 如果client发送的syn网络拥塞，超时后client重发了syn；server响应了旧的syn就进入ESTABLISHED状态后：server收到重发的syn，分配连接造成资源浪费。

- [小林coding：TCP 序列号和确认号是如何变化的？](https://www.xiaolincoding.com/network/3_tcp/tcp_seq_ack.html)

    - 序列号 = 上一次发送的序列号 + len（数据长度）。特殊情况，如果上一次发送的报文是 SYN 报文或者 FIN 报文，则改为 上一次发送的序列号 + 1。

    - 确认号 = 上一次收到的报文中的序列号 + len（数据长度）。特殊情况，如果收到的是 SYN 报文或者 FIN 报文，则改为上一次收到的报文中的序列号 + 1。

    ![image](./Pictures/net-kernel/TCP_seq.avif)

- [小林coding：为什么每次建立 TCP 连接时，初始化的序列号都要求不一样呢？](https://www.xiaolincoding.com/network/3_tcp/tcp_interview.html#%E4%B8%BA%E4%BB%80%E4%B9%88%E6%AF%8F%E6%AC%A1%E5%BB%BA%E7%AB%8B-tcp-%E8%BF%9E%E6%8E%A5%E6%97%B6-%E5%88%9D%E5%A7%8B%E5%8C%96%E7%9A%84%E5%BA%8F%E5%88%97%E5%8F%B7%E9%83%BD%E8%A6%81%E6%B1%82%E4%B8%8D%E4%B8%80%E6%A0%B7%E5%91%A2)

    - 防止接受历史包：如果连接中断，但发送的包还在网络中；而重新建立的连接之后，会收到了旧的包，由于ISN（序列号）一致，server会响应了旧的包，造成数据混乱

        ![image](./Pictures/net-kernel/TCP_isn_different.avif)

    - `ISN` Initial Sequence Number（初始序列号）随机生成算法：`ISN = M + F`

        - M 是一个计时器，这个计时器每隔 4 微秒加 1。溢出后从0开始。

        - F 是一个 Hash 算法，根据源 IP、目的 IP、源端口、目的端口生成一个随机数值。要保证 Hash 算法不能被外部轻易推算得出，用 MD5 算法是一个比较好的选择。

        - 防止攻击者猜测出`ISN`，攻击者如果知道`ISM` 可以伪造并发送`RST` 关闭连接

- [小林coding：已建立连接的TCP，收到SYN会发生什么？](https://www.xiaolincoding.com/network/3_tcp/challenge_ack.html#_4-9-%E5%B7%B2%E5%BB%BA%E7%AB%8B%E8%BF%9E%E6%8E%A5%E7%9A%84tcp-%E6%94%B6%E5%88%B0syn%E4%BC%9A%E5%8F%91%E7%94%9F%E4%BB%80%E4%B9%88)：

    - client故障重启，并且分配了和之前一样的port，重新发送syn；server只会按历史连接seq回复ack，client收到了不是自己期望的ack（这样的ack叫Challenge ACK），发送`RST`

    ![image](./Pictures/net-kernel/TCP_syn_reconnect.avif)

- [小林coding：灵魂拷问 TCP ，你要投降了吗？](https://cloud.tencent.com/developer/article/2141541)

    ```sh
    # client发送syn后，未收到syn、ack的重发次数（默认为6次）（重试间隔为1s, 3s, 7s, 15s, 31s, 63s ）超过重发次数后，直接进入CLOSED状态
    sysctl net.ipv4.tcp_syn_retries
    net.ipv4.tcp_syn_retries = 6

    # server发送syn、ack后，未受到ack的重发次数（默认为5次）（重试间隔为1s, 3s, 7s, 15s, 31s）超过重发次数后，直接进入CLOSED状态
    sysctl net.ipv4.tcp_synack_retries
    net.ipv4.tcp_synack_retries = 5

    # 第三次握手丢失后server端进入CLOSED、client端进入ESTABLISHED状态后发数据的timeout；又或者两端都是ESTABLISHED状态的timeout。内核以第一次RTO的时间，根据次数（默认为15次）计算出timeout。假设第一次RTO为200ms，15次后为924.6秒，也就是15.4分钟。而不是总共重传15次的时间，因为实际RTO可能会根据RTT越来越大

    sysctl net.ipv4.tcp_retries2
    net.ipv4.tcp_retries2 = 15

    # 第一、二、三、四次挥手的重发次数。超过重发次数后，直接进入CLOSED状态
    sysctl net.ipv4.tcp_orphan_retries
    net.ipv4.tcp_orphan_retries = 0
    ```

- [小林coding：TCP 四次挥手的性能提升](https://www.xiaolincoding.com/network/3_tcp/tcp_optimize.html#tcp-%E5%9B%9B%E6%AC%A1%E6%8C%A5%E6%89%8B%E7%9A%84%E6%80%A7%E8%83%BD%E6%8F%90%E5%8D%87)

    - 进程调用 `close()` 和 `shutdown()` 发起 FIN 报文（shutdown 参数须传入 SHUT_WR 或者 SHUT_RDWR 才会发送 FIN）。

        - 调用 `close()` 的一方的连接叫做孤儿连接（不能发送、接受数据），用 `netstat -p` 命令，会发现连接对应的进程名为空。如果收到了服务端发送的数据，由于client已经不再具有发送和接收数据的能力，所以client的内核会回 RST 报文给server

            ```sh
            # 孤儿连接数量大于它，新增的孤儿连接将不再走四次挥手，而是直接发送 RST 复位报文强制关闭
            sysctl net.ipv4.tcp_max_orphans
            net.ipv4.tcp_max_orphans = 32768

            #  shutdown() 关闭连接可以一直处于 FIN_WAIT2 状态，因为它可能还可以发送或接收数据。close() 则不行时长为tcp_fin_timeout（默认为60秒）
            sysctl net.ipv4.tcp_fin_timeout
            net.ipv4.tcp_fin_timeout = 60
            ```

        - `shutdown()` 它可以根据参数，只关闭一个方向的连接：

            - SHUT_RD(0)：关闭连接的「读」这个方向，如果接收缓冲区有已接收的数据，则将会被丢弃，并且后续再收到新的数据，会对数据进行 ACK，然后悄悄地丢弃。也就是说，对端还是会接收到 ACK，在这种情况下根本不知道数据已经被丢弃了。

            - SHUT_WR(1)：关闭连接的「写」这个方向，这就是常被称为「半关闭」的连接。如果发送缓冲区还有未发送的数据，将被立即发送出去，并发送一个 FIN 报文给对端。

            - SHUT_RDWR(2)：相当于 SHUT_RD 和 SHUT_WR 操作各一次，关闭套接字的读和写两个方向。

##### TIME_WAIT相关

```sh
# 查看TIME_WAIT的连接
netstat -ant | grep TIME_WAIT

# 统计TIME_WAIT的连接的个数
netstat -ant | grep TIME_WAIT | wc -l
```

```sh
# tcp关闭连接后保持TIME_WAIT时间。目的是防止丢失Fin包，如果没有接受到ack会再次发送fin包（默认为60秒）
sysctl net.ipv4.tcp_fin_timeout
net.ipv4.tcp_fin_timeout = 60

# TIME_WAIT的最大并发数量。超过这个值时，系统就会将后面的 TIME_WAIT 连接状态重置
sysctl net.ipv4.tcp_max_tw_buckets
net.ipv4.tcp_max_tw_buckets = 32768
```

- 为什么要等待2MSL？

    > MSL：报文段最大生存时间，它是任何报文段被丢弃前在网络内的最长时间。

    - MSL 与 TTL 的区别： MSL 的单位是时间，而 TTL 是经过路由跳数。所以 MSL 应该要大于等于 TTL 消耗为 0 的时间，以确保报文已被自然消亡。

        - TTL 的值一般是 64，Linux 将 MSL 设置为 30 秒

        ```sh
        sysctl net.ipv4.ip_default_ttl
        net.ipv4.ip_default_ttl = 64
        ```

    - 防止历史连接中的数据，被后面相同四元组的连接错误的接收：TIME_WAIT 没有等待时间或时间过短，新的连接会收到，历史连接被延迟的包，导致数据错乱

        ![image](./Pictures/net-kernel/TCP_timewait_2msl.avif)

    - 收到重发的第三次挥手fin后，会再次重置2MSL定时器。

        ![image](./Pictures/net-kernel/TCP_timewait_2msl1.avif)

- 为什么是主动关闭方才会有`TIME_WAIT` 状态：确保另一方，能正确的关闭连接

    - 主动关闭方在发送完 ACK 就走了的话，如果最后发送的 ACK 在路由过程中丢掉了，最后没能到被动关闭方，这个时候被动关闭方没收到自己 FIN 的 ACK 就不能关闭连接，接着被动关闭方会超时重发 FIN 包，但是这个时候已经没有对端会给该 FIN 回 ACK，被动关闭方就无法正常关闭连接了

    ![image](./Pictures/net-kernel/TCP_timewait_2msl2.avif)

- [小林coding：服务器出现大量 TIME_WAIT 状态的原因有哪些？](https://www.xiaolincoding.com/network/3_tcp/tcp_interview.html#%E6%9C%8D%E5%8A%A1%E5%99%A8%E5%87%BA%E7%8E%B0%E5%A4%A7%E9%87%8F-time-wait-%E7%8A%B6%E6%80%81%E7%9A%84%E5%8E%9F%E5%9B%A0%E6%9C%89%E5%93%AA%E4%BA%9B)

    - 没有开启长连接：如果其中一方的header有 `connection：close` 则不用长连接。

        - nginx（在服务器上跑）与后端进行大量的短连接请求，由于nginx 会主动挂断这个连接，在server上就会出现大量的 TIME_WAIT 状态。

    - clinet请求数量超过了server的长连接个数：比如 nginx 配置中的 `keepalive_requests` 参数，默认是100。对于QPS（每秒请求个数时）比较高时，nginx 就会很频繁地关闭连接，那么此时服务端上就会出大量的 TIME_WAIT 状态。

    - 长连接超时：client在超时时间内没有新的数据发送，那么server会主动挂断这个连接，在server上就会出现 TIME_WAIT 状态。（nginx配置中的`keepalive_timeout` 参数）

    - server进程挂掉了，会出现大量的 TIME_WAIT 状态。

        - TCP 的连接信息是由内核维护的，所以当服务端的进程崩溃后，内核需要回收该进程的所有 TCP 连接资源，于是内核会发送第一次挥手 FIN 报文，后续的挥手过程也都是在内核完成，并不需要进程的参与，所以即使服务端的进程退出了，还是能与客户端完成 TCP 四次挥手的过程。


- `TIME_WAIT` 状态过多有什么危害？

    - 1.占用系统资源，比如文件描述符、内存资源、CPU 资源等

    - 2.占用端口资源，端口资源也是有限的，一般可以开启的端口为 32768～61000，也可以通过 `net.ipv4.ip_local_port_range`参数指定范围

- `TIME_WAIT`消耗的 Client 的端口的解决方法：

    - 1.`tcp_tw_reuse` （默认关闭）和 `tcp_timestamps`（默认启用）对应tcp header的options的`TSOPT`

        - `tcp_tw_reuse`：调用 connect() 函数时，内核会随机找一个 TIME_WAIT 状态超过 1 秒的连接给新的连接复用

            ```sh
            # 查看是否启用。0表示不启用、1表示全局启用、2表示仅启用loopback（默认为2）
            sysctl net.ipv4.tcp_tw_reuse
            net.ipv4.tcp_tw_reuse = 2
            ```

            - [小林coding：tcp_tw_reuse 为什么默认是关闭的？](https://www.xiaolincoding.com/network/3_tcp/tcp_tw_reuse_close.html#%E4%B8%BA%E4%BB%80%E4%B9%88-tcp-tw-reuse-%E9%BB%98%E8%AE%A4%E6%98%AF%E5%85%B3%E9%97%AD%E7%9A%84)

                - 新连接接受了历史连接发送的延迟 RST 报文，导致连接关闭。因为 RST 段不携带时间戳，所以PAWS不会检查并丢弃

                    ![image](./Pictures/net-kernel/TCP_timewait_reuse.avif)

                - 如果第四次挥手的ack丢失，server端重发，但此时TIME_WAIT被新连接复用，client收到后认为这是 Challenge ACK，就会回复`RST`

                    ![image](./Pictures/net-kernel/TCP_timewait_reuse1.avif)

        - `tcp_timestamps`：长度为32位（4G）。

            - 1.开启后可以计算 RTT

            - 2.防止序列号回绕（PAWS）：

                - 每收到一个新数据包都会读取数据包中的时间戳值跟 Recent TSval 值做比较，如果不是递增的，则表示该数据包是过期的，就会直接丢弃这个数据包

            ```sh
            # 查看是否开启（默认开启）
            sysctl net.ipv4.tcp_timestamps
            net.ipv4.tcp_timestamps = 1
            ```

    - 2.内核收到 RST 将会产生一个错误并终止该连接。我们可以利用 RST 包来终止掉处于 TIME_WAIT 状态的连接，其实这就是所谓的 RST 攻击了。以下为三个步骤

        - 1.client：利用 `IP_TRANSPARENT` 这个 socket 选项，它可以 bind 不属于本地的地址，因此可以从任意机器绑定 Client 地址以及端口 port1，然后向 Server 发起一个连接Server
        - 2.server：收到了窗口外的包于是响应一个 ACK，这个 ACK 包会路由到 Client 处
        - 3.client：这个时候 99% 的可能 Client 已经释放连接 connect1 了，这个时候 Client 收到这个 ACK 包，会发送一个 RST 包，server 收到 RST 包然后就释放连接 connect1 提前终止 TIME_WAIT 状态了

    - `tcp_tw_recycle` Linux 4.12直接取消了这一参数：它允许处于 TIME_WAIT 状态的连接被快速回收。与`tcp_timestamps` 一起使用在NAT网络下会有问题

        - NAT网络下的两个client，使用用相同的 IP 地址与server建立 TCP 连接，如果clinet B 的 timestamp 比 clinet A 的 timestamp 小；server 会启用per-host 的 PAWS（判断TCP 报文中时间戳是否是历史报文） 机制，丢弃clinet B 发来的 SYN 包。

- [小林coding：在 TIME_WAIT 状态的 TCP 连接，收到 SYN 后会发生什么？](https://www.xiaolincoding.com/network/3_tcp/time_wait_recv_syn.html#_4-11-%E5%9C%A8-time-wait-%E7%8A%B6%E6%80%81%E7%9A%84-tcp-%E8%BF%9E%E6%8E%A5-%E6%94%B6%E5%88%B0-syn-%E5%90%8E%E4%BC%9A%E5%8F%91%E7%94%9F%E4%BB%80%E4%B9%88)

    - 如果是合法的syn：进入 `SYN_RECV` 状态

        ![image](./Pictures/net-kernel/TCP_timewait_syn.avif)

    - 如果是非法的syn：再回复一个第四次挥手的 ACK 报文，client收到后，发现并不是自己期望收到确认号（Challenge ACK），就回 RST 报文给server。

        ![image](./Pictures/net-kernel/TCP_timewait_syn1.avif)

- [小林coding：在 TIME_WAIT 状态，收到 RST 会断开连接吗？](https://www.xiaolincoding.com/network/3_tcp/time_wait_recv_syn.html#%E5%9C%A8-time-wait-%E7%8A%B6%E6%80%81-%E6%94%B6%E5%88%B0-rst-%E4%BC%9A%E6%96%AD%E5%BC%80%E8%BF%9E%E6%8E%A5%E5%90%97)

    ```sh
    # 默认值为0: 收到 RST 报文会提前结束 TIME_WAIT 状态，释放连接
    # 值为1：丢掉 RST 报文
    sysctl net.ipv4.tcp_rfc1337
    net.ipv4.tcp_rfc1337 = 0
    ```

##### TCP端口、连接问题

- TCP有多少端口可以使用？

    - `bind(0)`系统调用当参数为0时：Linux内核随机分配一个端口号，Linux内核会在 net.ipv4.ip_local_port_range 系统参数指定的范围内，随机分配一个没有被占用的端口。

    - 但`bind(0)` 不能绑定TIME_WAIT状态，也就是内核参数`net.ipv4.tcp_tw_reuse`

        - 解决方法：`bind()`指定端口

    ![image](./Pictures/net-kernel/TCP_bind(0).avif)

    ```sh
    sysctl net.ipv4.ip_local_port_range
    net.ipv4.ip_local_port_range = 32768	60999
    ```

    - 最大连接数 = 客户端 IP 数 × 客户端端口数

        - 客户端的 IP 数最多为 2 的 32 次方，客户端的端口数最多为 2 的 16 次方，也就是服务端单机最大 TCP 连接数约为 2 的 48 次方

    - 文件描述符限制：每个 TCP 连接都是一个文件，如果文件描述符被占满了，会发生 too many open files。
        - 系统级：当前系统可打开的最大数量：`cat /proc/sys/fs/file-max`
        - 用户级：指定用户可打开的最大数量：`ulimit -n`
        - 进程级：单个进程可打开的最大数量：`cat /proc/sys/fs/nr_open`

    - 内存限制：每个连接占用一定内存。[陈硕的测试为每个tcp占3.155 KB](https://zhuanlan.zhihu.com/p/25241630)

- tcp和udp可以绑定同一个端口吗？

    - 可以。sever端的tcp和udp的都可以同时拥有80端口

        ![image](./Pictures/net-kernel/port.avif)


#### reset包

##### [鹅厂架构师：什么！TCP又发reset包？](https://mp.weixin.qq.com/s/bic8IqdTYLpi9ll3zmkdbw)

- 为什么 RST 报文不需要 ACK 确认?
    - RST 报文的发送方在发送 RST 报文之后，会将该 TCP 连接直接关闭，然后释放对应的结构体内存，至于接收方是否能收到这个报文，发送方已经不关注了。

    - 如果接收方收到了 RST, 也会释放对应的结构体内存，结束
    - 如果接收方没有收到 RST, 再次向发送方发送数据时，还是会收到 RST, 最终也会释放对应的结构体内存，结束

- TCP的经典异常问题无非就是丢包和连接中断
    - 在这里我打算与各位聊一聊TCP的RST到底是什么？
    - 现网中的RST问题有哪些模样？我们如何去应对、解决？
    - 本文将从RST原理、排查手段、现网痛难点案例三个板块自上而下带给读者一套完整的分析。

- 最近一年的时间里，现网碰到RST问题屡屡出现，一旦TCP连接中收到了RST包，大概率会导致连接中止或用户异常。如何正确解决RST异常是较为棘手的问题。

- 本文关注的不是细节，而是方法论，也确实方法更为重要。

- RST问题并不可怕，只要思路理清楚，先判断类型，再抓取对应代码，继而翻出RFC协议，最后分析源码就能搞定，仅仅四步就可以了 。

###### 两种RST包：active rst包；passive rst包

- RST包分为两种：一种是`active rst包`，另一种是`passive rst包`

    - 前者多半是指的符合预期的reset行为，此种情况多半是属于机器自己主动触发，更具有先前意识，且和协议栈本身的细节关联性不强
    - 后者多半是指的机器也不清楚后面会发生什么，走一步看一步，如果不符合协议栈的if-else实现的RFC中条条杠杠的规则的情况下，那就只能reset重置了。

- active rst包

    - 如果从tcpdump抓包上来看表现就是（如下图）RST的报文中含有了一串Ack标识。
    ![image](./Pictures/net-kernel/TCP_reset-active-rst包.avif)

    - 内核代码

        ```c
        tcp_send_active_reset()
            -> skb = alloc_skb(MAX_TCP_HEADER, priority);
            -> tcp_init_nondata_skb(skb, tcp_acceptable_seq(sk), TCPHDR_ACK | TCPHDR_RST);
            -> tcp_transmit_skb()
        ```

    - 通常发生active rst的有几种情况：

        - 1.主动方调用close()的时候，上层却没有取走完数据；这个属于上层user自己犯下的错。
        - 2.主动方调用close()的时候，setsockopt设置了linger；这个标识代表我既然设置了这个，那close就赶快结束吧。
        - 3.主动方调用close()的时候，发现全局的tcp可用的内存不够了（这个可以sysctl调整tcp mem第三个参数），或，发现已经有太多的orphans了，这时候系统就是摆烂的意思：我也没辙了”，那就只能干脆点长痛不如短痛，结束吧。这个案例可以搜索(dmesg日志）“too many orphaned sockets”或“out of memory -- consider tuning tcp_mem”，匹配其中一个就容易中rst。

        - 注：这里省略其他使用diag相关（如ss命令）的RST问题。上述三类是主要的active rst问题的情况。

- passive rst包

    - rst的报文中无ack标识，而且RST的seq等于它否定的报文的ack号（红色框的rst否定的黄色框的ack），当然还有另一种极小概率出现的特殊情况的表现我这里不贴出来了，它的表现形式就是RST的Ack号为1。

    ![image](./Pictures/net-kernel/TCP_reset-passive-rst包.avif)

    - 内核代码
        ```c
        tcp_v4_send_reset()
                if (th->ack) {
                        // 这里对应的就是上图中为何出现Seq==Ack
                        rep.th.seq = th->ack_seq;
                } else {
                        // 极小概率，如果出现，那么RST包的就没有Seq序列号
                        rep.th.ack = 1;
                        rep.th.ack_seq = htonl(ntohl(th->seq) + th->syn + th->fin +
                                               skb->len - (th->doff << 2));
                }
        ```

    - 通常发生passive rst的有哪些情况呢？这个远比active rst更复杂，场景更多。具体的需要看TCP的收、发的协议，文字的描述可以参考rfc 793即可。

###### 分析rst包

- 首先tcpdump的抓捕是一定需要的，这个可以在整体流程上给我们缩小排查范围，其次是，必须要手写抓捕异常调用rst的点，文末我会分享一些源码出来供参考。

- 当然，无论那种，我们抓到了堆栈后依然需要输出很多的关于skb和sk的信息，这个读者自行考虑即可。再补充一些抓捕小技巧，如果现网机器的rst数量较多时候，尽量使用匹配固定的ip+port方式或其它关键字来减少打印输出，否则会消耗资源过多！

    - 注：切记不能去抓捕reset tracepoint（具体函数：trace_tcp_send_reset()），这个tracepoint实现是有问题的，这个问题已经在社区内核中存在了7年之久！目前我正在修复中。

- 那如何抓调用RST的点？

    - 1.`active rst包`

        - 使用bpf*相关的工具抓捕tcp_send_active_reset()函数并打印堆栈即可，通过crash现场机器并输入“dis -l [addr]”可以得到具体的函数位置，比对源码就可以得知了。

        ```sh
        # 可以使用bpftrace进行快速抓捕。我们可以根据堆栈信息推算上下文。
        sudo bpftrace -e 'k:tcp_send_active_reset { @[kstack()] = count(); }'
        ```

        ![image](./Pictures/net-kernel/TCP_reset-active-rst包堆栈.avif)

    - 2.`passive rst包`
        ```sh
        # 使用bpf*相关的工具抓捕抓捕tcp_v4_send_reset()和其他若干小的地方即可，原理同上。
        sudo bpftrace -e 'k:tcp_v4_send_reset { @[kstack()] = count(); }'
        ```
        ![image](./Pictures/net-kernel/TCP_reset-passive-rst包堆栈.avif)

###### 案例分析

- 本章节我将用现网实际碰到的三个”离谱“的case作为案例分析，让各位读者可以看下极为复杂的RST案例到底长成什么样？对内核不感兴趣的同学可以不用纠结具体的细节，只需要知道一个过程即可；对内核感兴趣的同学不妨可以一起构造RST然后自己再抓取的试试。

- 第一个案例：小试牛刀—— close阶段RST

    - 背景：这是线上出现概率/次数较多的一种类型的RST，业务总是抱怨为何我的连接莫名其妙的又没了。

    - 我们先使用网络异常检测中最常用的工具：tcpdump。如下抓包的图片再结合前文对RST的两种分类（active && passive）可知，这是active rst。

    - 我们先使用网络异常检测中最常用的工具：tcpdump。如下抓包的图片再结合前文对RST的两种分类（active && passive）可知，这是active rst。
        ![image](./Pictures/net-kernel/TCP_reset包-第一个案例.avif)

    - 好，既然知道了是active rst，我们就针对性的在线上对关键函数抓捕，如下：
        ![image](./Pictures/net-kernel/TCP_reset包-第一个案例1.avif)

    - 通过crash命令找到了对应的源码，如下：
        ![image](./Pictures/net-kernel/TCP_reset包-第一个案例2.avif)

    - 这时候便知是用户设置了linger，主动预期内的行为触发的rst，所以本例就解决了。不过插曲是，用户并不认为他设置了linger，这个怎么办？那就再抓一次sk->sk_lingertime值就好咯，如下：
        ![image](./Pictures/net-kernel/TCP_reset包-第一个案例3.avif)

    - 计算：socket的flag是784，第5位（从右往左）是1，这个是SO_LINGER位置位成功，但是同时linger_time为0。这个条件默认（符合预期）触发：上层用户退出时候，不走四次挥手，直接RST结束。

    - 结论：linger的默认机制触发了加速结束TCP连接从而RST报文发出。

- 第二个案例：TCP 两个bug —— 握手与挥手的RS

    - 背景：某重点业务报告他们的某重点用户出现了莫名其妙的RST问题，而且每一次都是出现在三次握手阶段，复现概率约为——”按请求数来算的话差不多百万级别分之1的概率，概率极低“（这是来自业务的原话）。

    - 这里需要剧透一点的是，后文提到的两个场景下的rst的bug，都是由于相同的race condition导致的。rcu保护关注的是reader&writer的安全性（不会踩错地址），而不保护数据的实时性，这个很重要。所以当rcu与hashtable结合的时候，对整个表的增删和读如何保证数据的绝对的同步显得很重要！

    - 握手阶段的TCP bug

        ![image](./Pictures/net-kernel/TCP_reset包-第二个案例.avif)

        - 问题的表象是，三次握手完毕后client端给server端发送了数据，结果server端却发送了rst拒绝了。

        - 分析：注意看上图最左边的第4和5这两行的时间间隔非常短，只有11微妙，11微妙是什么概念？查一次tcp socket的hash表可能都是几十微妙，这点时间完全可能会停顿在一个函数上。

        - 当server端看到第三行的ack的时候几乎同时也看到了第四行的数据，详细来说，这时候server端在握手最后一个环节，会在socket的hash表中删除一个老的socket（我们叫req sk），再插入一个新的socket（我们叫full sk），在删除和插入之间的这短暂的几微妙发生的时候，server收第行的数据的时候需要去到这个hash表中寻找（根据五元组）对应的socket来接受这个报文，结果在这个空档期间没有匹配到应该找到的socket，这时候没办法只能把当时上层最初监听的listener拿出来接收，这样就出现了错误，违背了协议栈的基本的设计：对于listener socket接收到了数据包，那么这个数据包是非预期的，应该发送RST！

        ```
        CPU 0                           CPU 1
           -----                           -----
        tcp_v4_rcv()                  syn_recv_sock()
                                    inet_ehash_insert()
                                    -> sk_nulls_del_node_init_rcu(osk)
        __inet_lookup_established()
                                    -> __sk_nulls_add_node_rcu(sk, list)
        ```

        - 对应上图的cpu0就是server的第四行的读者，cpu1就是写者，对于cpu0而言，读到的数据可能是三种情况：1）读到老的sk，2）读到新的sk，3）谁也读不到，前两个都是可以接收，但是最后一个就是bug了——我们必须要找到两者之一！如下就是一种场景，无法正确找到new或者old。

            ![image](./Pictures/net-kernel/TCP_reset包-第二个案例1.avif)

        - 那如何修复这个问题？在排查完整个握手规则后，发现只需要先插入新的sk到hash桶的尾部，再删除老的sk即可，这样就会有几种情况：1）两个同时都在，一定能匹配到其中一个，2）匹配到新的。如下图，无论reader在哪里都能保证可以读到一个。如下是正确的：
            ![image](./Pictures/net-kernel/TCP_reset包-第二个案例2.avif)

        - 结论：第3行（client给server发生了握手最后一次ack）和第4行（client端给server发送了第一组数据）出现的并发问题。

    - 挥手阶段的bug：

        ![image](./Pictures/net-kernel/TCP_reset包-第二个案例3.avif)

        - 这个问题根因同上：rcu+hash表的使用问题，在挥手阶段发起close()的一方竞争的乱序的收到了一个ack和一个fin ack触发，导致socket在最后接收fin ack时候没有匹配到任何一个socket，又只能拿出最初监听的listener来收包的时候，这时候出现了错误。但是这个原始代码中，是先插入新的sk再删除了老的sk，乍一听没有任何问题，但是实际上插入新的sk出现了问题，源码中插入到头部，这里需要插入到尾部才行！出现问题的情景如下图。

        ![image](./Pictures/net-kernel/TCP_reset包-第二个案例4.avif)

        - 结论：这个是原生内核长达十多年的一个实现上的BUG，即为了性能考虑使用的RCU机制，由此必然引入的不准确性导致并发的问题，我定位并分析出这个问题的并发的根因，由此提交了一份bugfix patch到社区被接收，链接：https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=3f4ca5fafc08881d7a57daa20449d171f2887043

- 第三个案例：netfilter两个bug —— 数据传输RST

    - 背景：用户报告有两个痛点问题：偶发性出现1）根本无法完成三次握手连接，2）在传输数据的阶段突然被RST异常中止。

    - 分析：我们很容易的通过TCP的设计推测到这种情况一定不是正常的、符合预期的行为。我抓取了passive rst后发现原因是TCP层无法通过收到的skb包寻找到对应的socket，要知道socket是最核心的TCP连接通信的基站，它保存了TCP应有的信息（wscale、seq、buf等等），如果skb无法找到socket，那么就像小时候的故事小蝌蚪找妈妈但是找不到回家的路一样。

    - 那为什么会出现找不到socket？

    - 经过排查发现线上配置了DNAT规则，如下例子，凡是到达server端的1111端口或1112端口的都被转发到80端口接收。

        ```
        // iptables A port -> B port
        iptables ... -p tcp --port 1111 -j REDIRECT --to-ports 80
        iptables ... -p tcp --port 1112 -j REDIRECT --to-ports 80
        ```

    - DNAT+netfilter的流程是什么样？

        ![image](./Pictures/net-kernel/TCP_reset包-第三个案例.avif)

    - 那么，有了DNAT之后，凡是进入到server端的A port会被直接转发到B port，最后TCP完成接收。完整的逻辑是这样：DNAT的端口映射在ip层收包时候先进入prerouting流程，修改skb的dst_ip:dst_port为真正的最后映射的信息，而后由ip early demux机制针对skb中的原始信息src_ip:src_port（也就是A port）修改为dst_ip:dst_port（也就是使用B port），由此4元组hash选择一个sk，继而成功由TCP接收才对。

    - 两条流冲突触发的bug

        - 如下，如果这时候有两条流量想要TCP建连，二者都是由同一个client端相同的ip和port发起连接，这时候第1条连接首先发起握手那么肯定可以顺利进行，而当第2条连接发起的时候抵达到server端的1112端口最终被转化为80端口，但是根据80端口可以发现我们已经建立了连接，所以第2条流三次握手直接失败。

        ```
        1：saddr:12345 -> daddr:1111
        2：saddr:12345 -> daddr:1112
        ```

        - （对内核细节不感兴趣的同学可以跳过此段）详细的来说，第一条链接成功建联，第二条链接开始握手，server端的收到syn包，在prerouting之后，修改skb的dst_ip:dst_port将saddr:12345->daddr:1112改为saddr:12345->daddr:80，然后进入early demux根据这个四元组找到了第一条链接的sk（因为dst_port都被iptables的prerouting改为一样），而这个是一个established socket，后面进入到tcp层就会接收syn包失败。

        - 所以内核对应的修复方式就是，在prerouting->early demux完成后的local in阶段，如果识别到了这个case，则放弃early demux的选择结果（通过skb_orphan()），在local in里完成修改skb的源port端口（saddr:1112 -> daddr:80），这时候的第二条链接和第一条链接就有区分了，这时候交给tcp层真正意义上可以针对四元组的skb找sk，这时候肯定会找不到established sk、只能找listener socket，因此完成建联流程。

        - 结论：这个是early demux+DNAT的bug，它未能解决冲突问题，导致了异常RST的发生。

##### 如何关闭一个 TCP 连接？

- [小林coding：原来墙，是这么把我 TCP 连接干掉的！](https://mp.weixin.qq.com/s?src=11&timestamp=1676188303&ver=4345&signature=bI2NBASrj9x7Rn7H-G2WFFFYf7qKBiI07kAnlKk6aIMApYI*7ghxdOaAfjb4dHsYoIpC3pFFdJiFjq0hywVLFKoXi95HdydXg5yyIRWWOHVWK8jWamwMOhmDbLSAMpg0&new=1)

- TCP 重置攻击：伪造 RST 报文来关闭 TCP 连接

    > 问题：如何获取客户端序列号?

    - tcpkill：需要拦截双方的数据，只有目标连接有新 TCP 包发送/接收的时候，才能关闭一条 TCP 连接。

        ```sh
        # 模拟服务端，端口1234
        nc -l -p 1234
        # 模拟客户端，端口10000连接服务端的1234
        nc 2.1.4.3 1234 -p 10000

        # archliunx安装tcpkill
        pasman -S dsniff

        # 客户端的ip，端口。在客户端发送数据时，才会关闭
        tcpkill -1 host 192.168.1.221 and port 10000
        ```

    - killcx：主动发送一个 SYN 报文，通过对方回复的 Challenge ACK 来获取正确的序列号。然后伪造的 RST 报文发送给对方

        - 处于 Establish 状态的服务端，如果收到了客户端的 SYN 报文，会回复一个携带了正确序列号和确认号的 ACK 报文，这个 ACK 被称之为 Challenge ACK。

        ```sh
        # 在客户端就输入服务端的ip、端口；在服务端就输入客户端的ip和端口
        killcx ip:port
        ```

        ![image](./Pictures/net-kernel/TCP_killcx.avif)

#### backlog队列、半队列、全队列

- `backlog队列`：

    - 当网卡接收数据包的速度大于内核处理的速度时，`backlog队列` 会保存这些数据包，等待软中断处理

    - 队列大小 × 中断频率 = packets per second

    - 可以通过 `/proc/net/softnet_stat` 的第二列来验证, 如果第二列有计数, 则说明出现过 backlog 不足导致丢包

    ```sh
    # 查看backlog队列大小
    sysctl net.core.netdev_max_backlog
    net.core.netdev_max_backlog = 1000
    ```

- [小林coding：TCP 半连接队列和全连接队列](https://www.xiaolincoding.com/network/3_tcp/tcp_queue.html#%E4%BB%80%E4%B9%88%E6%98%AF-tcp-%E5%8D%8A%E8%BF%9E%E6%8E%A5%E9%98%9F%E5%88%97%E5%92%8C%E5%85%A8%E8%BF%9E%E6%8E%A5%E9%98%9F%E5%88%97)

    > 内核为每个socket维护两个队列。`listen()`会创建半连接队列和全连接队列

    ![image](./Pictures/net-kernel/TCP_queue.avif)
    ![image](./Pictures/net-kernel/TCP_queue1.avif)

    - SYN 半连接队列：Server 端收到 Client 的 SYN 包并回复 SYN,ACK 包后，该连接的信息就会被移到accept队列。超过队列长度后Server 会丢弃新来的 SYN 包

        ```sh
        sysctl net.ipv4.tcp_max_syn_backlog
        net.ipv4.tcp_max_syn_backlog = 512

        # 启用tcp_syncookies后：SYN半连接队列满后，后续的请求就不会存放到半连接队列，server端生成cookie，在第二次握手返回client；第三次握手时携带cookie发送给server验证，验证合法后放入accept全队列

        sysctl net.ipv4.tcp_syncookies
        net.ipv4.tcp_syncookies = 1
        ```

        ![image](./Pictures/net-kernel/tcp_syncookies.avif)

        ```sh
        # 查看当前SYN半队列的长度
        netstat -natp | grep -i "SYN_RECV" | wc -l

        # 查看SYN半队列溢出的次数
        netstat -s | grep -i "SYNs to LISTEN sockets dropped"
        ```

    - accept 全连接队列： Server 端收到第三次握手的ACK包后，就会将连接信息从SYN 半连接队列移到此队列（此时三次握手已经完成）。`accept()`，从`accept全队列`取出连接对象，返回用于传输的 socket 的文件描述符

        ```sh
        # 查看全队列的长度
        sysctl net.core.somaxconn
        net.core.somaxconn = 4096
        ```

        - 全队列满了后根据`tcp_abort_on_overflow` 值做出行动：

            - 值为1时：server 在收到 SYN_ACK 的 ACK 包后，协议栈会丢弃该连接并回复 RST 包给对端，这个是 Client 会出现 (connection reset by peer) 错误。

            - 值为0时：server 会丢弃这个第三次握手ACK包，并且开启定时器，重传第二次握手的SYN+ACK，如果重传超过一定限制次数，还会把对应的半连接队列里的连接给删掉。

            ```sh
            sysctl net.ipv4.tcp_abort_on_overflow
            net.ipv4.tcp_abort_on_overflow = 0
            ```
        在LISTEN状态下的Recv-Q：当前全连接队列的大小，也就是当前已完成三次握手并等待server端 accept() 的 TCP 连接

        在LISTEN状态下的Send-Q：当前全连接最大队列长度：`net.core.somaxconn`的值或`nginx backlog`的值（nginx backlog默认为511）

        ```sh
        # 显示LISTEN状态的tcp连接
        ss -lntp
        State      Recv-Q     Send-Q               Local Address:Port           Peer Address:Port     Process
        LISTEN     0          4096                      127.0.0.1:8861                0.0.0.0:*
        ```
        在Established状态下的Recv-Q：已收到但未被应用进程读取的字节数

        在Established状态下的Send-Q：已发送但未收到确认的字节数

        ```sh
        # 显示ESTABLISHED状态的tcp连接
        ss -tuap state ESTABLISHED
        State         Recv-Q    Send-Q            Local Address:Port              Peer Address:Port    Process
        SYN-SENT      0         1                 192.168.1.221:54900           172.217.163.42:443
        ```

        ```sh
        # 查看全队列溢出的次数
        netstat -s | grep overflowed
        ```

#### Tcp keepalive（心跳）

- TCP Keepalive 是一种用于检测 TCP 连接是否活跃的机制，通过定期发送探测数据包来确定连接的状态，主要用于检测空闲 (僵尸) 连接、保持 NAT 映射 (NAT 设备、防火墙设备) 等。

- 原理：
    - 1.要启用 TCP Keepalive 自动检测机制，需要通信双方都开启 Keepalive 选项
    - 2.如果在一定时间（默认 7200秒，也就是2 小时）内没有数据传输，TCP 会发送一个 Keepalive 探测数据包
    - 3.如果通信的对方仍然活跃，就会对该探测数据包进行响应，如果对方没有响应，TCP 将重试发送探测数据包
    - 4.在达到最大重试次数（默认 9 次）后，如果仍然未收到响应，TCP 将认为连接已断开，关闭连接

- socket接口需要设置`SO_KEEPALIVE`

![image](./Pictures/net-kernel/TCP_keepalive.avif)
![image](./Pictures/net-kernel/TCP_keepalive1.avif)

```sh
# 在最后一个 data packet（空 ACK 不算 data）之后,多长时间开始发送keepalive。7200秒等于2小时
sysctl net.ipv4.tcp_keepalive_time
net.ipv4.tcp_keepalive_time = 7200

# 发送探测包的时间间隔.在此期间,连接上的任何传输内容,都不影响keepalive的发送
sysctl net.ipv4.tcp_keepalive_intvl
net.ipv4.tcp_keepalive_intvl = 75

# 最大失败次数
sysctl net.ipv4.tcp_keepalive_probes
net.ipv4.tcp_keepalive_probes = 9

# 在优化高并发场景和移动场景为主的后端服务器时，这几个参数需要着重优化一下:
# 设置首次探测之前的空闲时间为 10 分钟
echo 600 > /proc/sys/net/ipv4/tcp_keepalive_time

# 设置重试探测的时间间隔为 15 秒
echo 15 > /proc/sys/net/ipv4/tcp_keepalive_intvl

# 设置最大重试次数为 3 次
echo 3 > /proc/sys/net/ipv4/tcp_keepalive_probes
sysctl -p
```

##### 应用层心跳机制的必要性


- TCP Keepalive 机制由内核 (操作系统) 负责执行，当进程退出后，内核会针对进程中未关闭的连接逐个进行关闭 (向连接的通信对方发送 FIN 报文)，这样就保证了每个连接的通信双方都可以知道通信的状态，并根据状态来完成不同的具体业务逻辑。

- TCP Keepalive 机制无法确认应用层的心跳检测目标：应用程序还在正常工作。

- 具体来说，TCP Keepalive 检测结果正常，只能说明两件事情：
    - 1.应用程序 (进程) 还存在
    - 2.网络链路正常
    - 但是 当应用程序进程运行中发生异常时，例如死锁、Bug 导致的无限循环、无限阻塞 等，虽然此时操作系统依然可以正常执行 TCP Keepalive 机制，但是对于应用程序的异常情况，通信对方是无法得知的。

- 此外，应用层心跳检测具有更好的灵活性，例如可以控制检测时间、间隔、异常处理机制、附加额外数据等。

- 综上所述，应用层心跳检测是必须实现的。

- 常见的应用层心跳实现方式有:
    - HTTP: 访问指定 URL, 根据响应码或者响应数据来判定应用是否正常
    - WebSocket: 和 HTTP 检测方式类似
    - Exec: 执行指定 (Shell) 命令 (例如文件检查、网络检查)，并检查命令的退出状态码，如果状态码为 0，说明应用正常运行

- 其中业界主流的检测方式是 HTTP (长连接方式), 主要是因为:
    - HTTP 实现简单，基于长连接的方式避免了连接的建立和释放带来的开销
    - HTTP 对于 (异构) 环境的要求很低，而且大多数应用中都使用 HTTP 作为 API 主要通信协议，心跳检测并不会带来多少额外的工作量


- 实现细节
    - 1.不要单独实现 “心跳线程”
        - 使用单独的线程来实现 “心跳检测”，虽然可以将心跳检测应用代码和具体的业务逻辑代码隔离，但是当 “业务线程” 发生死锁或者 Bug 崩溃时，心跳线程检测不到。
        - 所以应该将心跳检测直接实现在 “业务线程” 中。

    - 2.不要单独实现 “心跳连接”
        - 对于网络 (例如 TCP) 编程的场景，心跳检测应该在 “业务连接” 直接实现，而不是使用单独的连接，这样当业务连接出现异常时，通信对方可以第一时间感知到 (没有及时收到心跳响应)。

        - 此外，大多数网络防火墙会定时监测空闲 (僵尸) 连接并清除，如果心跳检测使用额外的连接，那么当 “业务连接” 长时间没有要发送的数据时，就已经被防火墙断开了，但是此时心跳检测连接还在正常工作，这会影响通信对方的判断，以为 “业务连接” 还在正常工作。

        - 所以应该将心跳检测直接实现在 “业务连接” 中。

#### TCP Fast Open（TFO）

- [洋芋编程：为什么 TFO 可以将 TCP 降低到 0 次 握手？](https://mp.weixin.qq.com/s/_cB9Kr1ZcUZKz3uBtDEi4Q)

- [What is TCP Fast Open?](https://www.keycdn.com/support/tcp-fast-open)

- [lwm:TCP Fast Open: expediting web services](https://lwn.net/Articles/508865/)

- 在传统的三次握手基础上进行优化，允许在握手过程中发送数据，从而减少首次发送数据的延迟，提升网络应用性能。

    - 事实上，很多云计算服务商提供的 Linux 发行版本都对网络协议栈进行了优化，会在 TCP 第三次握手时直接发送数据，读者自己抓包验证时，可能会和本文结果存在一定差异。

- 需要client和server端同时支持

- 1.初始阶段比传统三次握手多了请求`cookie`

    ![image](./Pictures/net-kernel/TCP_fast_open.avif)

    - 1.当发送方第一次和接收方建立 TCP 连接时，发送 1 个 SYN 报文
    - 2.接收方返回 SYN-ACK 报文的同时，附带一个随机生成的名为 TFO Cookie 的标识符给发送方
    - 3.发送方收到 SYN-ACK 报文后，保存 TFO Cookie，发送 ACK 报文给接收方，完成三次握手，开始传输数据

    - `cookie` 根据client的ip生成

    - 和 Web 应用层 中的 Cookie 机制一样，第一次访问时，需要登录验证，然后由服务端验证后，后续访问中可以直接携带，无需再次登录。

- 2.之后的阶段

    ![image](./Pictures/net-kernel/TCP_fast_open1.avif)

    - client端：首次syn包含`cookie` 和数据

    - server端：根据client的ip验证`cookie`

        - cookie有效：立即传送数据，不需要等待cilent端的第三次握手的ack

        - cookie无效：server端丢弃client的数据，对client的syn返回一个syn，ack。也就是回到传统三次握手

    - 配合tls1.3的话，tcp三次握手可以与tls1.3同时进行

- 优点：
    - 通过 TFO，发送方在发送 SYN 报文时就可以直接携带数据，接收方可以在第一次握手时直接处理数据，并且在第二次握手时直接发送数据，
    - 发送方第一次发送数据，减少了 1.5 个 RTT 延迟
    ![image](./Pictures/net-kernel/TCP_TFO_rtt.avif)

    - 接收方第一次发送数据，减少了 1 个 RTT 延迟
    ![image](./Pictures/net-kernel/TCP_TFO_rtt1.avif)

- 缺点：

    - 局限性：需要通信双方都支持 TFO, 如果其中一方不支持，连接自动回退到传统的 TCP 连接建立过程
        - 此外，通信链路中的转发设备 (NAT, 防火墙) 也会执行这个兼容性机制。

    - 安全性：虽然 TFO 的 Cookie 是由接收方生成并发送给发送方的，并且每个 Cookie 都与发送方关联，但是增加了接收方的安全攻击面，可能引发诸如 “TCP SYN Flood” 放大攻击 等安全风险。

        - 如果攻击者从被入侵主机获取到有效的 TFO Cookie，进而伪造了大量的携带数据报文，那么接收方就需要大量的内存来临时存储应用数据，最终导致内存耗尽。

    - 部署环境要求：对内核版本有要求，且需要修改内核参数。

    - 应用数据过大：如果发送方第一次要发送的数据大于 TCP 的 MSS, 依然需要拆包进行多次发送，当应用数据过大时，TCP Fast Open 带来的优势 (RTT 减少) 几乎可以忽略。

```sh
# 查看是否开启tcp fast open（linux默认情况下是开启的）。
# 返回0表示没有开启
# 1表示客户端开启
# 2表示服务端开启
# 3表示客户端服务端都开启
cat /proc/sys/net/ipv4/tcp_fastopen

# 启动
echo 3 | sudo tee /proc/sys/net/ipv4/tcp_fastopen

# 永久启动
echo "net.ipv4.tcp_fastopen=3" > /etc/sysctl.d/30-tcp_fastopen.conf
sysctl -p
```

- 测试
```sh
curl --tcp-fastopen http://example.com

# 可以使用如下方式确认 curl 版本是否支持 TFO
curl -V | grep -i TFO
```

##### nginx支持

编译时加入`-DTCP_FASTOPEN=23`

- 开启
```nginx
listen 80 fastopen=256
```

#### 重传与RTT、RTO

- [洋芋编程：TCP 可靠传输实现原理 - 1.确认和重传](https://mp.weixin.qq.com/s/k8IqzMLe2crCMmMQ-0fHdA)

> RTT(Round Trip Time)：一个数据包从发出去到回来的时间

> RTO(Retransmission TimeOut)：重传时间

- RTT计算算法：

    - [ ] RFC793算法：

        - 1. 首先采样计算RTT值，会有以下图片的问题

            ![image](./Pictures/net-kernel/TCP_rtt.avif)

        - 2.然后计算平滑的RTT，称为Smoothed Round Trip Time (SRTT)：SRTT = ( ALPHA * SRTT ) + ((1-ALPHA) * RTT)
            - ALPHA（加权移动平均）：取值在 0.8 到 0.9 之间

        - 3.RTO = min[UBOUND,max[LBOUND,(BETA*SRTT)]]
            - UBOUND 是 RTO 值的上限（可以定义为 1 分钟）
            - LBOUND 是 RTO 值的下限（可以定义为 1 秒）
            - BETA：取值在 1.3 到 2.0 之间

    - [ ] Karn/Partridge 算法解决RTT采样问题：当出现超时重传，接收到重传数据的确认信息时不更新 RTT

        - 问题：如果在某一时间，网络闪动，突然变慢了，产生了比较大的延时，这个延时导致要重转所有的包（因为之前的 RTO 很小），于是，因为重转的不算，所以，RTO 就不会被更新

    - [x] Jacobson / Karels算法解决以上问题（今天的tcp算法）：除了考虑每两次测量值的偏差之外，其变化率也应该考虑在内

- RTO定时器：

    - [ ] 为 TCP 中的每一个数据包维护一个定时器，在这个定时器到期前没收到确认，则进行重传。 这种方案将会有非常多的定时器，会带来巨大内存开销和调度开销。

    - [x] RFC2988以连接来确定定时器
        - 1.每一次发送包（包含重传的包）时如果定时器没有启动，则开启定时器


- 理想发送缓冲区= 网络带宽每秒发送字节数 * RTT

    - 网络带宽每秒发送字节数 = 1024, RTT = 1 秒，缓冲区 = 1024 字节
    - 网络带宽每秒发送字节数 = 4096, RTT = 0.5 秒，缓冲区 = 2048 字节

- 超时重传：

    - 发送方发送了数据包: 1, 2, 3, 4, 5, 并启动 超时定时器
    - 接收方收到了数据包: 1, 2, 5

    - 如果在超时前收到 Ack，发送方确认该数据包已成功接收，停止定时器，并将 RTO 时间恢复到正常计算值。
    - 如果定时器超时，发送方就重新发送 3 号 数据包，并重置定时器 (通常会增加 RTO 时间，例如退避算法中，RTO 时间会翻倍)。

- Fast Retransmit(快速重传) 的算法：连续收到三个相同确认号的ack，立刻重传，而不需要等待定时器

    - 快速重传之所以称为快速，是因为它不像超时重传一样需要等待 RTO 时间。

    ![image](./Pictures/net-kernel/TCP_Fast-Retransmit.avif)

    - 例子：
        - 发送方发送了数据包: 1, 2, 3, 4, 5, 6, 7
        - 接收方收到了数据包: 1, 2, 5, 应答 Ack = 3
        - 接收方收到了数据包: 1, 2, 5, 4, 应答 Dup Ack = 3
        - 接收方收到了数据包: 1, 2, 5, 4, 6, 应答 Dup Ack = 3
        - 接收方收到了数据包: 1, 2, 5, 4, 6, 7 应答 Dup Ack = 3
        - 此时发送方收到了 3 个重复 Ack, 意识到 3 号数据包 (可能) 已经丢失，理解重新发送 3 号数据包

    - 为什么要求必须大于等于 3 个 Dup Ack 呢？

        - 因为网络包有时会乱序 (尤其是链路比较复杂的情况下)，乱序的包一样会触发重复的 Ack，但是为了乱序而重传没有必要。
        - 正常的乱序 (非丢包) 情况下，数据包之间的序号差异不会很大，例如 3 号数据包可能会在 5 号数据包之后到达，但是不太可能在 50 号数据包之后到达。

        ![image](./Pictures/net-kernel/TCP_Dup_Ack.avif)

        - 左图中，2 号数据包的因为丢包，凑够了 3 个 Dup Ack，所以触发快速重传
        - 右图中，2 号数据包 4 号数据包之后到达，因为没有凑够 3 个 Dup Ack, 没有触发快速重传

- 快速重传 vs 超时重传

    - 快速重传降低了延迟，但是有可能产生重复包 (例如某个包延迟了，但却导致其被重传了)
    - 超时重传降低了产生重复包的概率，但是增加了延迟

    - 相比超时重传，快速重传对性能影响小一些，因为它没有 RTO 等待时间，而且拥塞窗口减小的幅度没那么大，可以避免进入 慢启动 阶段 (慢启动在后面的 TCP 拥塞控制一文中会讲到)。

    - 但是如果数据包数量太少，其中一个数据包丢失了，没有足够数量的后续数据包触发 Dup Ack，可能会凑不齐触发快速重传所必需的 3 个 Dup Ack，因此这种情况下的丢包，只能等待超时重传。

        - 例子：在文件传输场景中，丢包对极小文件的影响比大文件严重。因为读写一个小文件需要的数据包很少，所以丢包时 (很可能) 凑不齐 3 个 Dup Ack，只能等待超时重传，而大文件因为数据包很多，较大可能会触发快速重传。

- SACK（ Selective Acknowledgment）选择性确认：解决重传一个，还是重传所有的问题。它允许设备单独确认段(segments)，从而只重传丢失的段

    ![image](./Pictures/net-kernel/TCP_sack.avif)

    - SAck 需要发送方和接收方都支持 (如果对端没有启用 SACK, 优化效果会大打折扣)，接收方通过告诉发送方已经收到哪些数据块，以及缺失哪些数据块，从而使发送方只重传丢失的数据段，而不是整个数据窗口。

    ```sh
    # 查看是否开启sack（默认开启）
    sysctl net.ipv4.tcp_sack
    net.ipv4.tcp_sack = 1
    ```

- SACK选择性重传 vs 快速重传

    - 快速重传只知道有数据包丢了，但是不知道是一个还是多个、以及具体的数据包
    - 选择性重传可以知道具体是哪些数据包丢了。

    - 两者互为补充，快速重传通过 Dup Aak 快速检测到丢包情况，及时进行重传，选择性重传在快速重传的基础上，通过应答中的 SAck 报文，进行更加精准高效的重传 (尤其是大范围数据传输中，个别数据包丢失的情况)。

- 伪重传（不必要的重传）机制：

    - D-SACK（Duplicate SACK）重复选择性确认：发送端接受到D-SACK时，判断是发送端的包丢失了？还是接收端的 ACK 丢失了？

        > ACK大于SACK便是D-SACK

        - 发送端重传了一个包，发现并没有 D-SACK 那个包，那么就是发送的数据包丢了；否则就是接收端的 ACK 丢了，或者是发送的包延迟到达了

        - 发送端可以判断自己的 RTO 是不是有点小，导致过早重传

        ![image](./Pictures/net-kernel/TCP_d-sack.avif)

        - Ack = 4000, SAck=3000-3500，也就是意味着 4000 之前的所有数据包都接收到了，所以 SACK=3000-3500 就是一个 Dup SAck。
        - 通过这个 Dup SAck, 发送方就可以知道，数据包没有丢失，丢失的是 Ack 应答包。

        ```sh
        # 查看是否开启D-SACK（默认开启）
        sysctl net.ipv4.tcp_dsack
        net.ipv4.tcp_dsack = 1
        ```

    - Eifel 检测算法 [RFC3522]：利用了 TCP 的 TSOPT 来检测伪重传。

        - 比仅采用 DSACK 更早检测到伪重传行为，因为它判断伪重传的 ACK 是在启动丢失恢复之前生成的。相反， DSACK 只有在重复报文段到达接收端后才能发送，并且在 DSACK 返回至发送端后才能有所响应。

    - F-RTO：只检测由重传计时器超时引发的伪重传

#### 延迟ACK

- 延迟ACK（默认开启）：如果接收方收到数据包之后，没有什么数据要发送给发送方，可以延迟一段时间 Ack, 如果在延迟期间，接收方有数据要发送，就可以将数据和 Ack 放在一个数据包里面发送了。

    - 1.第二个包到后，再返回一个ack

    - 2.在收到数据后并不马上响应，而是延迟一段可以接受的时间200ms，在返回

    - 3.有数据发送，则立刻返回ack + 数据

    ![image](./Pictures/net-kernel/TCP_delay-ack2.avif)
    ![image](./Pictures/net-kernel/TCP_delay-ack.avif)

- 延迟确认并没有直接提高性能，只是减少了部分确认包，减轻了网络负担。

- 但是某些场景中，延迟确认反而会影响性能，典型的场景下如下:

    - 小数据包通信: 发送方可能会因为等待接收方的 Ack 而出现额外的延迟，导致传输整体时间增加
    - 实时通信: 延迟确认会增加传输延迟 (当然，这类场景一般使用 UDP)
    - 高并发短连接: 每个短连接的请求-响应时间，因为延迟确认而增加，导致服务器的请求积压
    - 还有一种场景: 发送窗口很小，也会严重降低 TCP 的传输性能，示例来自 Wireshark 网络分析的艺术
        ![image](./Pictures/net-kernel/TCP_delay-ack3.avif)

        - 如图所示，服务器接收窗口只有 2920 字节（相当于两个 MSS），且关闭了延迟确认时。因为客户端每发两个包就会耗光窗口，所以不得不停下来等待服务器的确认。

        - 如果这时候服务器上启用了延迟确认 (例如延迟时间为 200 毫秒)，那 29 号和 30 号数据包之间、32 号与 33 号数据包之间 ... 38 号和 39 号数据包之间，都需要多等待 200 毫秒，传输效率会下降数百倍。这个场景下的延迟确认杀伤力巨大，而且非常隐蔽！

- 延迟确认除了影响性能，还会严重影响 RTT 的统计。如果需要精确地监测延迟时间来预防拥塞，就必须在通信双方都启用 TCP Timestamps (net.ipv4.tcp_timestamps = 1) 来排除延迟确认干扰。

#### TCP window(窗口、流量控制)

- rwnd（接收端窗口）：接收端告诉发送端自己还有多少buffer（内核缓冲区）可以接收数据。

    - 进程调用read()后，数据被读入了用户空间，buffer就被清空，接收窗口就会变大。

    - 内核为每条tcp分配buffer(sk_buff数据结构，简称skb)

    - 如果sql查询的过大超过buffer会很慢，通过加大buffer可以减少查询时间

    - buffer 不是越大越好,过大的 buffer 容易影响拥塞控制算法对延迟的估测

    - 发送、接受buffer内核参数

        - `net.core.rmem` & `net.core.wmem` 为全局配置

        ```sh
        # 调节 TCP 内存范围
        sysctl net.ipv4.tcp_mem
        net.ipv4.tcp_mem = 93399	124535	186798
        ```
        | 列数   | 内容                                                                |
        | ------ | ------------------------------------------------------------------- |
        | 1      | 当 TCP 内存小于第 1 个值时，不需要进行自动调节                      |
        | 2      | 在第 1 和第 2 个值之间时，内核开始调节接收缓冲区的大小              |
        | 3      | 大于第 3 个值时，内核不再为 TCP 分配新内存，此时新连接是无法建立的  |

        ```sh
        # 值为1时：内核自动调整tcp连接的buffer（默认启用）
        sysctl net.ipv4.tcp_moderate_rcvbu

        # tcp接受端buffer。对应socket代码SO_RCVBUF（最好不要设置，让系统自动调整）
        sysctl net.ipv4.tcp_rmem
        net.ipv4.tcp_rmem = 4096 131072 6291456

        # tcp发送端buffer。对应socket代码SO_SNDBUF（最好不要设置，让系统自动调整）
        sysctl net.ipv4.tcp_wmem
        net.ipv4.tcp_wmem = 4096 16384 4194304
        ```

        | 列数                  | 内容                                                   |
        | --------------------- | ------------------------------------------------------ |
        | min（最小包缓冲）     | 动态范围的最小值                                       |
        | default（默认包缓冲） | 初始默认值，会覆盖全局参数 `net.core.rmem_default`     |
        | max（最大包缓冲）     | 动态范围的最大值，不会覆盖全局参数 `net.core.rmem_max` |

- 对于发送buffer：

    阻塞调用send()的时候，那就会等到缓冲区有空位可以发数据：

    ![image](./Pictures/net-kernel/tcp_wmem.gif)

    非阻塞调用，就会立刻返回一个 EAGAIN 错误信息，意思是 Try again。让应用程序下次再重试。这种情况下一般不会发生丢包。

    ![image](./Pictures/net-kernel/tcp_wmem1.gif)

- `swnd`（发送窗口）= min(rwnd（接受窗口）, cwnd（拥塞窗口）)

    ![image](./Pictures/net-kernel/TCP_congestion_swnd.avif)

- 发送端其发送buffer内的数据都可以分为 4 类：

    ![image](./Pictures/net-kernel/TCP_window_category.avif)

    - 其中，黑色方框部分就是 `发送窗口`，每确认一部分数据后，窗口就会向前移动，添加一部分新数据，然后准备发送。

    - 1.已经发送并得到接收端 ACK 的
    - 2.已经发送但还未收到接收端 ACK 的
    - 3.未发送但允许发送的 (接收方还有空间)
    - 4.未发送且不允许发送 (接收方没空间了)

    - 如图所示，收到接收方对 32 - 36 的 5 个数据包的 Ack 之后，窗口向前滑动 5 个数据包，发送了 46 - 51 的 5 个数据包，同时将 52 - 56 的 5 个数据包加入到窗口中准备发送。
        ![image](./Pictures/net-kernel/TCP_window_category1.avif)
        ![image](./Pictures/net-kernel/TCP_window_category2.avif)

- 发送窗口和 MSS 有什么关系？

    - 发送窗口决定了一口气能发送多少字节，而 MSS 决定了这些字节需要分多少个数据包发送完。

    - 在发送窗口为 16000 字节的情况下:
        - 如果 MSS 等于 1000 字节，需要发送 16000/1000=16 个数据包
        - 如果 MSS 等于 8000 字节，需要发送 16000/8000=2 个数据包

- 窗口变0过程：

    ![image](./Pictures/net-kernel/TCP_window_reduce.avif)
    ![image](./Pictures/net-kernel/TCP_window_reduce1.avif)

    - 当接受buffer满了，会发送通知一个 zero 窗口，发送端的收到后，发送窗口也变成了 0，也就是发送端不能发数据了。

        ![image](./Pictures/net-kernel/tcp_rmem.avif)

        ```sh
        # 查看丢包
        grep -a1 'TCPRcvQDrop' /proc/net/netstat
        ```

- 窗口关闭的死锁问题：窗口关闭时，接收方处理完数据后，会向发送方通告一个窗口非 0 的 ACK 报文，如果这个通告窗口的 ACK 报文在网络中丢失了，导致死锁

    ![image](./Pictures/net-kernel/TCP_window_deadlock.avif)

    - 发送端在窗口变成 0 后，就启动计时器，超时后发 ZWP（Zero Window Probe） 的包给接收方，来探测目前接收端的窗口大小，一般这个值会设置成 3 次（以 3.4s、6.5s、13.5s 的间隔出现）

        ![image](./Pictures/net-kernel/TCP_window_probe.avif)

        - 如果 3 次过后还是 0 的话，有的 TCP 实现就会发 RST 关闭这个连接。

        - DDoS 攻击点：攻击者可以在和 Server 建立好连接后，就向 Server 通告一个 0 窗口，然后 Server 端就只能等待进行 ZWP，于是攻击者会并发大量的这样的请求，把 Server 端的资源耗尽。

- TCP Window Full

    ![image](./Pictures/net-kernel/TCP_window_full.avif)

    - 如图所示的 Wireshark 抓包截图，当一个数据包被打上 TCP Window Full 标签时，表示数据包的发送方已经将发送窗口中的数据包全部发送完了，但是还未收到任何确认。

    - Window Full 很容易和 Zero Window 混淆，两者之间有一定相似之处:
        - Window Full 表示这个 数据包的发送方 告诉接收方，暂时不会再发送数据了
        - Zero Window 表示这个 数据包的发送方 告诉接收方，暂时不能再接收数据了
        - 也就是说两者都意味着数据传输暂停，同样需要引起重视。

- 糊涂窗口综合症：接收端的窗口被填满，然后接收处理完几个字节，腾出几个字节的窗口后，通知发送端，这个时候发送端马上就发送几个字节给接收端吗？

    - 例子：当有效负载只有 1 字节时，再加上 TCP 头部和 IP 头部各占用的 20 字节，整个网络包就是 41 字节，这样实际带宽的利用率只有 2.4%（1/41）。往大了说，如果整个网络带宽都被这种小包占满，那整个网络的有效利用率就太低了。

    - 在接收端的解决方案David D Clark’s方案：如果收到的数据导致 window size 小于某个值，就 ACK 一个 0 窗口，等到接收端处理了一些数据后 windows size 大于等于了 MSS，或者 buffer 有一半为空，就可以通告一个非 0 窗口。

    - 在发送端的解决方案Nagle’s algorithm：
        - 1.如果包长度达到 MSS ，则允许发送
        - 2.如果该包含有 FIN ，则允许发送
        - 3.设置了 TCP_NODELAY 选项，则允许发送
        - 4.设置 TCP_CORK 选项时，若所有发出去的小数据包（包长度小于 MSS）均被确认，则允许发送
            - Nagle 算法并不禁止发送小的数据包 (超时时间内)，而是避免发送大量小的数据包。
        - 5.上述条件都未满足，但发生了超时（一般为 200ms ），则立即发送

##### Nagle算法

- Nagle 算法和延迟ack一样，并没有直接提高性能，只是减少了部分确认包，减轻了网络负担。

- Nagle算法：发送端不要立即发送数据，攒多了再发。但是也不能一直攒，否则就会造成程序的延迟上升。目的是为了避免发送小的数据包。

    - 比喻：小白爸让小白出门给买一瓶酱油，小白出去买酱油回来了。小白妈又让小白出门买一瓶醋回来。小白前后结结实实跑了两趟，影响了打游戏的时间。

        - 优化的方法也比较简单。当小白爸让小白去买酱油的时候，小白先等待，继续打会游戏，这时候如果小白妈让小白买瓶醋回来，小白可以一次性带着两个需求出门，再把东西带回来。这其实就是TCP的 Nagle 算法

    - 例子：像 nc 和 ssh 这样的交互式程序，你按下一个字符，就发出去一个字符给 Server 端。每通过 TCP 发送一个字符都需要额外包装 20 bytes IP header 和 20 bytes TCP header，发送 1 bytes 带来额外的 40 bytes 的流量，不是很不划算吗？

    - 例子：还有一种情况是应用代码写的不好。TCP 实际上是由 Kernel 封装然后通过网卡发送出去的，用户程序通过调用 write syscall 将要发送的内容送给 Kernel。有些程序的代码写的不好，每次调用 write 都只写一个字符（发送端糊涂窗口综合症）。如果 Kernel 每收到一个字符就发送出去，那么有用数据和 overhead 占比就是 1/41。

- Nagle算法，数据包在以下两个情况会被发送：

    - 1.如果包长度达到MSS（或含有Fin包），立刻发送，否则等待下一个包到来；如果下一包到来后两个包的总长度超过MSS的话，就会进行拆分发送；

    - 2.等待超时（一般为200ms），第一个包没到MSS长度，但是又迟迟等不到第二个包的到来，则立即发送。

        ![image](./Pictures/net-kernel/Nagle算法.avif)

        - 1.由于启动了Nagle算法，msg1 小于 mss ，此时等待`200ms`内来了一个 msg2
            - msg1 + msg2 > MSS，因此把 msg2 分为 msg2(1) 和 msg2(2)，msg1 + msg2(1) 包的大小为`MSS`。此时发送出去。

        - 2.剩余的 msg2(2) 也等到了 msg3，同样 msg2(2) + msg3 > MSS，因此把 msg3分为msg3(1) 和 msg3(2)，msg2(2) + msg3(1) 作为一个包发送。

        - 3.剩余的 msg3(2) 长度不足mss，同时在200ms内没有等到下一个包，等待超时，直接发送。

        - 此时三个包虽然在图里颜色不同，但是实际场景中，他们都是一整个 01 串，如果处理开发者把第一个收到的 msg1 + msg2(1) 就当做是一个完整消息进行处理，就会看上去就像是两个包粘在一起，没有解决TCP的粘包问题。

            - 粘包问题：使用TCP发送"夏洛"和"特烦恼"的时候，接收端收到的就是"夏洛特烦恼"，这时候接收端没发区分你是想要表达"夏洛"+"特烦恼"还是"夏洛特"+"烦恼"。

- Nagle算法其实是个有些年代的东西了，诞生于 1984 年。

    - 但是今天网络环境比以前好太多，Nagle 的优化帮助就没那么大了。而且它的延迟发送，有时候还可能导致调用延时变大，比如打游戏的时候，你操作如此丝滑，但却因为 Nagle 算法延迟发送导致慢了一拍，就问你难受不难受。

    - 所以现在**一般也会把它关掉**。

    - 关掉Nagle算法后依然有粘包问题

        ![image](./Pictures/net-kernel/关闭Nagle后依然有粘包问题.avif)

        - 1.接受端应用层在收到 msg1 时立马就取走了，那此时 msg1 没粘包问题

        - 2.**msg2 **到了后，应用层在忙，没来得及取走，就呆在 TCP Recv Buffer 中了

        - 3.**msg3 **此时也到了，跟 msg2 和 msg3 一起放在了 TCP Recv Buffer 中

        - 这时候应用层忙完了，来取数据，图里是两个颜色作区分，但实际场景中都是 01 串，此时一起取走，发现还是粘包。粘包出现的根本原因是不确定消息的边界。

        - 解决方法：

            - 1.加入特殊标志
                - 可以通过特殊的标志作为头尾，比如当收到了`0xfffffe`或者回车符，则认为收到了新消息的头，此时继续取数据，直到收到下一个头标志`0xfffffe`或者尾部标记，才认为是一个完整消息。
                - 类似的像 HTTP 协议里当使用 chunked 编码 传输时，使用若干个 chunk 组成消息，最后由一个标明长度为 0 的 chunk 结束。
                ![image](./Pictures/net-kernel/加入特殊标志解决粘包问题.avif)

                - 问题：采用`0xfffffe`标志位，用来标志一个数据包的开头，你就不怕你发的某个数据里正好有这个内容吗？
                - 解决方法：是的，怕，所以一般除了这个标志位，发送端在发送时还会加入各种校验字段（`校验和`或者对整段完整数据进行 `CRC` 之后获得的数据）放在标志位后面，在接收端拿到整段数据后校验下确保它就是发送端发来的完整数据。
                ![image](./Pictures/net-kernel/加入特殊标志解决粘包问题1.avif)

            - 2.加入消息长度信息
                - 在实际场景中，HTTP 中的`Content-Length`就起了类似的作用，当接收端收到的消息长度小于 `Content-Length` 时，说明还有些消息没收到。那接收端会一直等，直到拿够了消息或超时

- Nagle算法 和 延迟ack一样，不适合需要快速响应的小数据包通信场景，因为会导致发送延迟，影响性能与应用体验。

- Nagle算法 和 延迟ack：这两个方法看似都能解决一些问题。但是如果一起用就很糟糕了。如果接收方启用了延迟确认，Nagle 算法可能导致发送方的数据包积压，从而增加通信延迟，这种情况下，Nagle 算法和延迟确认的结合可能会引起队列头部阻塞（head-of-line blocking）, 增加网络延迟。

    ![image](./Pictures/net-kernel/TCP_delay-ack1.avif)

    - 1.当 服务端 发送了第一个分组后，由于 客户端 开启了延迟确认，就需要等待 40ms 后才会回复 ACK
    - 2.同时，由于 服务端 开启了 Nagle 算法，这时还没收到第一个分组的 ACK，服务端 也会在这里一直等着
    - 3.直到 40ms 超时后，客户端 才会回复 ACK，然后 服务端 才会继续发送第二个分组

    - 解决方法：发送方关闭 Nagle 算法；或者接收方关闭延迟ACK
        - 1.关闭 Nagle’s Algorithm 的方法：可以给 socket 设置 TCP_NODELAY. 这样程序在 write 的时候就可以 bypass Nagle’s Algorithm，直接发送。

        - 2.关闭 Delay ACK 的方法：可以给 socket 设置 TCP_QUICKACK，这样自己（作为 server 端）在收到 TCP segment 的时候会立即 ACK。实际上，在现在的 Linux 系统默认就是关闭的。

            - 如果我们关闭 TCP_QUICKACK ，就可以看到几乎每一次 TCP 握手，第三个 ACK 都是携带了数据的。
            ```sh
            int off = 0;
            setsockopt(sockfd, IPPROTO_TCP, TCP_QUICKACK, &off, sizeof(off));

            04:13:32.240213 IP foobarhost.57010 > 104.244.42.65.http: Flags [S], seq 1515096107, win 64240, options [mss 1460,sackOK,TS val 2468276221 ecr 0,nop,wscale 7], length 0
            04:13:32.383742 IP 104.244.42.65.http > foobarhost.57010: Flags [S.], seq 1620480001, ack 1515096108, win 65535, options [mss 1460], length 0
            04:13:32.384536 IP foobarhost.57010 > 104.244.42.65.http: Flags [P.], seq 1:38, ack 1, win 64240, length 37: HTTP: POST /apikey=1&command=2 HTTP/1.0
            ```

- TCP_CORK

    - TCP_CORK 算法是比 Nagle 算法更加激进的优化方式，因为它完全禁止了小数据包的发送，直到数据积累到足够大 (能够填充一个完整的 TCP 段)，或者被明确指示发送 (如关闭 TCP_CORK 选项)。

    - 相对来说， Nagle 算法只是禁止了大量的小数据包的发送。

#### TCP congestion control(拥塞算法)

- [腾讯技术工程：TCP 拥塞控制算法简介](https://cloud.tencent.com/developer/article/1401283)

- [TCP 流量控制、拥塞控制](https://zhuanlan.zhihu.com/p/37379780)

- [腾讯技术工程：TCP 拥塞控制详解](https://cloud.tencent.com/developer/article/1636214)

- [小林coding：再谈 TCP 拥塞控制！](https://zhuanlan.zhihu.com/p/423509812)

- [洋芋编程：TCP 可靠传输实现原理 - 3.拥塞控制](https://mp.weixin.qq.com/s/xNJrYW3Ytk_vc32oDWrKqg)

- [洋芋编程：TCP 到底有什么性能问题？](https://mp.weixin.qq.com/s/2vtO3uVQAwR2aMEsPpCTvw)

- 拥塞控制 与 滑动窗口的区别
    - 滑动窗口主要关注发送方到接收方的流量控制
    - 拥塞控制更多地关注整个网络 (链路) 层面的流量控制
        - 拥塞控制的视角更为全面，会对整个网络链路中的所有主机、路由器，以及降低网络传输性能的有关因素进行综合考量。

- 目前有非常多的 TCP 的拥塞控制协议，例如：

    > 不同拥塞控制算法的核心差异主要在 拥塞避免 阶段。

    - 基于丢包 的拥塞控制：采取慢启动方式，逐渐增大拥塞窗口，出现丢包时减小拥塞窗口，如 Tahoe、Reno、NewReno、Bic、Cubic、PRR

        ![image](./Pictures/net-kernel/TCP_congestion_algorithm.avif)
    - 基于时延 的拥塞控制：通过延迟和带宽估算来进行拥塞控制，延迟增大时减小拥塞窗口，延时减小时增大拥塞窗口，如 Vegas、FastTCP、Westwood、Ledbat
        ![image](./Pictures/net-kernel/TCP_congestion_algorithm1.avif)
    - 基于链路容量 的拥塞控制：实时测量网络带宽和时延，根据网络传输中的 报文总量 和带宽时延的乘积 进行拥塞控制，如 BBR (Google 开发的一种算法，通过估算瓶颈带宽和往返时延来控制拥塞)
    - 基于学习的 拥塞控制：没有特定的拥塞信号，通过分析不同网络条件下的传输行为，借助评价函数，基于训练数据，使用机器学习的方法生成最优的拥塞控制规则，如 Remy

```sh
# 查看系统支持的拥塞算法
sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = reno cubic bbr

# 查看当前使用的拥塞算法（我这里为bbr）
sysctl net.ipv4.tcp_congestion_control
net.ipv4.tcp_congestion_control = bbr
```

- 拥塞算法依赖于一个拥塞窗口 `cwnd`（以包为单位，因此乘以MSS），`cwnd` 由发送方维护

    - Linux 3.0 后采用了 Google 的论文[《An Argument for Increasing TCP’s Initial Congestion Window》](https://static.googleusercontent.com/media/research.google.com/zh-CN//pubs/archive/36640.pdf)的建议——把 cwnd 初始化成了 10 个 MSS。

        - 那么，第一次发送的 TCP 数据 (Segment) 总量为:10 * 1460 = 14600 约等于14KB

        ```c
        // https://github.com/torvalds/linux/blob/02f8c6aee8df3cdc935e9bdd4f2d020306035dbe/include/net/tcp.h#L200

        // Linux 3.0 默认 cwnd 大小
        #define TCP_INIT_CWND  10
        ```

    - 修改cwnd是网络性能优化的手段：并不是越大越好，它会增加瓶颈路由器的压力

        ```sh
        # 查看
        ip route show

        # 修改cwnd。永久保存需要写入 /etc/network/interfaces
        ip route change 将上面命令要修改行，全部复制到这里 initcwnd 10
        ```

        ![image](./Pictures/net-kernel/TCP_initcwnd.avif)

- TCP 的拥塞控制的核心思想是根据网络状况动态调整拥塞窗口（cwnd）的大小，通过反馈机制（如丢包和延迟）检测网络拥塞，并相应地调整数据发送速率，主要由 4 个方面组成:

    - 1.慢启动
    - 2.拥塞避免
    - 3.快速重传 (拥塞发生后)
    - 4.快速恢复
    ![image](./Pictures/net-kernel/TCP_congestion_状态机avif)

- BSD初始版本的Reno算法：

    - 1.Slow Start（慢热启动算法）

        - 每当收到一个 ACK，cwnd = cwnd + 1; 呈线性上升

        - 每当过了一个 RTT，cwnd = cwnd * 2; 呈指数上升

        - 有一个慢启动阈值 `ssthresh`（一般为65535 bytes，约等于65 KB）。 当 `cwnd >= ssthresh` 时从 慢启动阶段 进入到 拥塞避免阶段。

        - 例子：以stackoverflow.com以其首页 html 文本数据大小 (68.8 KB) 为例，说明一下慢启动对于服务端发送响应数据，带来了哪些性能影响。
            - 1.第 1 次发送的数据总量为: 14 KB
            - 2.经过 1 个 RTT, cwnd 翻倍
            - 3.第 2 次发送的数据总量为: 28 KB
            - 4.经过 1 个 RTT, cwnd 再次翻倍
            - 5.第 3 次发送的数据总量为: 56 KB

            - 经过 3 次发送后，14 + 28 + 56 = 98 KB, 首页 html 文本数据传输完成，一共经历了 3 个往返次数。

    - 2.Congestion Avoidance（拥塞避免算法）

        > 不同拥塞控制算法的核心差异主要在 拥塞避免 阶段。

        - 每收到一个 ACK，cwnd = cwnd + 1 / cwnd; 呈线性上升

        - 出现 RTO 超时重传数据包时：
            - 1.ssthresh 的值为当前 cwnd 值的 1/2
            - 2.reset 自己的 cwnd 值为 1
            - 3.然后重新进入慢启动过程

            ![image](./Pictures/net-kernel/TCP_congestion_reno.avif)

        - 出现收到 3 个 duplicate ACK 进行重传数据包时（表示不太严重）：进入快速重传
    - 3.Fast Retransimit（快速重传）：拥塞发生后

        > 表明网络只是轻微拥堵

        - 在基于丢包的拥塞控制算法中 (例如 Reno、Cubic、NewReno), 认为一旦发生丢包，就是网络链路发生了拥塞，所以发送方会急剧地减小发送窗口，甚至进入短暂的等待状态（快速重传）。
            - 1% 的丢包率并不只是降低 1% 的传输性能，而是可能降低 50% 甚至更多 (取决于具体的 TCP 实现)
                - 此时就可能出现极端情况: 网络花在重传被丢掉的数据包的时间比发送新的数据包的时间还要多，所以这是造成 所谓 TCP 性能问题 的最大元凶。

            - 丢包同时会加重网络链路拥塞，假设 1 个 TCP 数据段转发到第 N 个路由器，前 N-1 个路由器已经完成转发，但是第 N 个路由器转发时丢失了数据段，最终导致丢失的数据段浪费了前面所有路由器的带宽。

            - TCP Reno 算法发生丢包时，性能直接腰斩
                ![image](./Pictures/net-kernel/TCP_Conservation_reno丢包.avif)

            - TCP Tahoe 算法发生丢包时，直接重置，进入慢启动过程
                ![image](./Pictures/net-kernel/TCP_Conservation_tahoe丢包.avif)


            - 这里以 HTTP 场景为例，丢包带来的影响在 HTTP/2 中表现更为严重，因为 HTTP/2 只使用 1 个 TCP 连接进行传输。所以 1 次丢包会导致所有的资源下载速度变慢。而 HTTP/1.1 可能有多个独立的 TCP 连接，1 次丢包也只会影响其中 1 个 TCP 连接，所以这种场景下 HTTP/1.1 反而会获得更好的性能。

        - TCP Reno 算法的快速重传
            - 1.cwnd = cwnd/2
            - 2.ssthresh = cwnd
            - 3.进入快速恢复算法
            ![image](./Pictures/net-kernel/TCP_Conservation_reno快速重传.avif)

        - TCP Tahoe 算法的快速重传
            - 该算法和超时重传机制一样，工作过程如下:
            - 1.修改 sshthresh = cwnd / 2
            - 2.修改 cwnd = 1
            - 3.进入慢启动过程
            ![image](./Pictures/net-kernel/TCP_Conservation_Tahoe快速重传.avif)

        - TCP Cubic 算法的快速重传
            - Cubic 是一种改进的拥塞控制算法 (Linux 2.6.18 之后默认使用)，是基于丢包机制的拥塞控制算法中表现最好的。
            - Cubic 和 Reno 算法一样，发生拥塞后也是采用加法线性增加，但是每次不是加 1, 而是根据一个特定的公式来决定窗口增加的大小，从而到达更快地收敛 cwnd。

            - 如图所示，相比于 Reno 算法发生拥塞后的 “大起大落”，Cubic 算法要相对 “顺滑” 一些。
            ![image](./Pictures/net-kernel/TCP_Conservation_Cubic快速重传.avif)

    - 4.Fast Recovery（快速恢复算法）

        > 快速恢复的思想是 “数据包守恒” 原则：即带宽不变的情况下，在网络同一时刻能容纳数据包数量是恒定的。拥塞发生之后，如果触发了快速重传 (收到 3 个及以上 Dup Ack), 说明此时网络拥塞并没有很严重，所以只要保证接下来降低发送速率就可以了，完全不需要像超时重传一样那么保守，此时就可以进入到快速恢复阶段了。

        ![image](./Pictures/net-kernel/TCP_Conservation.avif)

        - 在进入快速恢复前：sshthresh = cwnd / 2，cwnd = sshthresh

        - 1.cwnd = cwnd + 3，重传 Duplicated ACKs 指定的数据包
        - 2.如果再收到 duplicated Acks：cwnd = cwnd + 1
        - 3.如果收到新的 ACK，而非 duplicated Ack：cwnd = sshthresh ，然后进入拥塞避免状态

        ![image](./Pictures/net-kernel/TCP_congestion_reno1.avif)

        - 相比保守的 RTO 超时重传，快速恢复调整 cwnd 和 sshthresh 更加符合真实的网络链路场景，但是该算法的不足在于: 严重依赖引起快速重传的 Dup Ack, 引发快速重传至少需要 3 个 Dup Ack 包，但是 3 个 Dup Ack 并不意味着只丢了 3 个数据包 (很可能是多个数据包)，但是快速重传只会重传一个，其他丢失的数据包依然只能等待 RTO 超时重传，于是进入一个恶性循环:

            - 超时一个数据包，sshthresh 就锐减一半
            - 超时多个数据包，sshthresh 就会减少到 1, 并且不会触发快速恢复算法了

    - 慢启动和快速恢复针对的目标是同一个: cwnd 初始值大小，慢启动设置 cwnd 初始值为 1, 快速恢复设置 cwnd 初始值为 ssthresh。

- [ ] Linux rate halving 算法的快速恢复（已弃用）：

    - 1.sshthresh = cwnd / 2，cwnd不变
    - 2.每收到两个 ACK（不管是否重复）：cwnd = cwnd - 1
    - 3.新窗口值取 cwnd = MIN(cwnd, inflight+1)
        - inflight：发送了但还未收到的 Ack 的包
    - 4.直到退出快速恢复状态，cwnd = MIN(cwnd, ssthresh)

    - 优点：在快速恢复期间，取消窗口陡降过程，可以更平滑的发送数据
    - 缺点：降窗策略没有考虑 PIPE 的容量特征，考虑一下两点：
        - 如果快速恢复没有完成，窗口将持续下降下去
        - 如果一次性 ACK/SACK 了大量数据，in_flight 会陡然减少，窗口还是会陡降，这不符合算法预期。

- [ ] Linux 2.6版本Cubic 算法（已弃用）：

    ![image](./Pictures/net-kernel/TCP_congestion_cubic.avif)

    - CWND 的增长和 RTT 长短无关，即不是每次 ACK 后就去增大 CWND，而是让 CWND 增长的三次函数跟时间相关，不管 RTT 多大，一定时间后 CWND 一定增长到某个值，从而让网络更公平，RTT 小的连接不能挤占 RTT 大的连接的资源。

- [x] Linux最新的快速恢复算法PRR(Proportional Rate Reduction)：

    - 1.在快速恢复过程中，拥塞窗口非常平滑地向 ssthresh 收敛
    - 2.在快速恢复结束后，拥塞窗口处在 ssthresh 附近

- New Reno 算法：慢启动算法、拥塞避免算法、快速重传算法和 prr 算法

    ![image](./Pictures/net-kernel/TCP_congestion_newreno.avif)

- BDP(Bandwidth and Delay Product)：带宽 (单位 bps) 和延迟 (单位 s) 的乘积，单位是 bit。超过了BDP，就会导致网络过载，容易丢包

    ![image](./Pictures/net-kernel/TCP_congestion_bdp.avif)

- BBR:比丢包算法更好的拥塞算法

    - [BBR: Congestion-Based Congestion Control（论文）（中文）](http://arthurchiao.art/blog/bbr-paper-zh/)

    - [陶辉：一文解释清楚Google BBR拥塞控制算法原理](https://www.taohui.tech/2019/08/07/%E7%BD%91%E7%BB%9C%E5%8D%8F%E8%AE%AE/%E4%B8%80%E6%96%87%E8%A7%A3%E9%87%8A%E6%B8%85%E6%A5%9Agoogle-bbr%E6%8B%A5%E5%A1%9E%E6%8E%A7%E5%88%B6%E7%AE%97%E6%B3%95%E5%8E%9F%E7%90%86/)

    - 丢包反馈属于被动式机制：BBR算法认为随着网络接口控制器逐渐进入千兆速度时，分组丢失不应该被认为是识别拥塞的主要决定因素

    - BBR算法是一种主动式机制：以时间窗口内的最大带宽max_bw（链路带宽+链路缓存buffer） 和最小延时RTT min_rtt相乘得到发送速率

    - 发送速率和RTT曲线：纵轴上下分别为RTT和发送速率（发送速率与RTT成反比）；过程分为了3个阶段：

        ![image](./Pictures/net-kernel/TCP_congestion_bbr.avif)

        - app limit（应用限制阶段）：该阶段为应用程序开始发送数据，RTT基本保持固定且很小，发送速率线性增长
        - band limit（带宽限制阶段）：发送速率的提高，RTT开始增加，但是此时链路中的缓存区（buffer）并没有占满
        - buffer limit（缓冲区限制阶段）：buffer被占满，开始出现丢包

    - 算法的不同阶段：和CUBIC类似

        ![image](./Pictures/net-kernel/TCP_congestion_bbr1.avif)

        - StartUp慢启动阶段：使用2ln2的增益加速，即使发生丢包也不会引起速率的降低，而是依据返回的确认数据包来判断带宽增长，直到带宽不再增长时就进入下一个阶段。在寻找最大带宽的过程中产生了多余的2BDP的数据量

        - Drain排空阶段：慢启动结束时多余的2BDP的数据量清空，此阶段发送速率开始下降，直到未确认的数据包数量<BDP时，排空阶段结束

        - ProbeBW带宽探测阶段：进入稳定状态进行数据的发送，在探测期中增加发包速率如果数据包ACK并没有受影响那么就继续增加，探测到带宽降低时也进行发包速率下降。

        - ProbeRTT延时探测阶段：前面三个过程在运行时都可能进入ProbeRTT阶段，当某个设定时间内都没有更新最小延时状态下开始降低数据包发送量，试图探测到更小的MinRTT，探测完成之后再根据最新数据来确定进入慢启动还是ProbeBW阶段。

- 对比CUBIC

    - 10Mbps和40msRTT的网络环境下CUBIC和BBR的一个对比曲线：

        ![image](./Pictures/net-kernel/TCP_congestion_bbr2.avif)

        - 在上面的图中蓝色表示接收者，红色表示CUBIC，绿色表示BBR，在下面的图中给出了对应上图过程中的RTT波动情况

    - 相比CUBIC对丢包不那么敏感：

        ![image](./Pictures/net-kernel/TCP_congestion_bbr3.avif)

    - YouTube应用BBR算法之后：吞吐量普遍有4%左右的提升，特别地在日本的提升达到14%；RTT的下降更为明显平均降低33%，其中IN(印度地区)达到50%以上；不像CUBIC这种基于丢包做拥塞控制，常导致瓶颈路由器大量报文丢失，所以重新缓存的平均间隔时间也有了11%提升

        ![image](./Pictures/net-kernel/TCP_congestion_bbr4.avif)
        ![image](./Pictures/net-kernel/TCP_congestion_bbr5.avif)
        ![image](./Pictures/net-kernel/TCP_congestion_bbr6.avif)

- TCP Westwood 算法简称 TCPW：和 bbr 算法类似是基于带宽、延时计算的一种拥塞控制算法。

- 同一网络下TCP对比UDP：

    ![image](./Pictures/net-kernel/TCP_vs_UDP.avif)

    - tcp每次进入拥塞后带宽会减少（图片上的tcp山峰）；而udp则不会，所以最后只剩下udp的带宽。

    - 在LAN（局域网）下不会有这类问题。但WAN则不同，因此需要设置`Qos`的规则控制udp带宽

#### socket相关

- 两个程序通过socket建立连接

    - 默认是阻塞 I/O，一对一通信

    - 在tcp里client调用 `connect()` 后，才开始建立握手

    ![image](./Pictures/net-kernel/socket.avif)

- socket文件的inode指向内核的`Socket`结构

    - `Socket`结构维持着两个队列（发送和接受队列）

        - 队列保存着 `struct sk_buff` 结构（简称skb）

- sk_buff 可以表示各个层的数据包，在应用层数据包叫 data，在 TCP 层我们称为 segment，在 IP 层我们叫 packet，在数据链路层称为 frame。

    - 发送报文时，创建 sk_buff 结构体：数据缓存区的头部预留足够的空间，每经过下层协议时，就减少 sk_buff->data 的值来增加协议头部。

    - 接收报文时，每经过上一层时：就增加 sk_buff->data 的值，来逐步剥离协议头部。

    ![image](./Pictures/net-kernel/socket-sk_buff.avif)

- [小林coding：服务端没有 listen，客户端发起连接建立，会发生什么？](https://www.xiaolincoding.com/network/3_tcp/tcp_no_listen.html)

    - client对server发起 SYN 报文后，server回了 RST 报文

- [陶辉：高性能网络编程（一）----accept建立连接](https://www.taohui.tech/2016/01/25/%E7%BD%91%E7%BB%9C%E5%8D%8F%E8%AE%AE/%E9%AB%98%E6%80%A7%E8%83%BD%E7%BD%91%E7%BB%9C%E7%BC%96%E7%A8%8B%EF%BC%88%E4%B8%80%EF%BC%89-accept%E5%BB%BA%E7%AB%8B%E8%BF%9E%E6%8E%A5/)

    - 在syn半队列和accept全队列的整个过程中后一步会阻塞前一步：如果不取出ACCEPT全队列，那么全队列会增满；又会进一步导致syn半队列增满

    - 而应用建立连接过程中，能控制的只有accept()（从accept全队列取出来）这一步：因此一旦不及时取出便会导致accept和syn队列增满，最后无法建立新连接

        - 所以tomcat等服务器会使用独立的线程，只做accept获取连接这一件事

        - 那为什么nginx不单单只用一个线程处理accept，而是除了accept还处理其它IO呢？因为nginx是非阻塞accept

            - 阻塞accept：

                ![image](./Pictures/net-kernel/socket_accpet_block.avif)

            - 非阻塞accept：要么返回成功，要么失败。不会长期占用所属线程的CPU时间片，使得线程能够及时的做其他工作。

                ![image](./Pictures/net-kernel/socket_accpet_nonblock.avif)

- [陶辉：高性能网络编程3----TCP消息的接收](https://www.taohui.tech/2016/01/26/%E7%BD%91%E7%BB%9C%E5%8D%8F%E8%AE%AE/%E9%AB%98%E6%80%A7%E8%83%BD%E7%BD%91%E7%BB%9C%E7%BC%96%E7%A8%8B3-tcp%E6%B6%88%E6%81%AF%E7%9A%84%E6%8E%A5%E6%94%B6/)

    - 先收到报文，后调用阻塞recv的场景：

        ![image](./Pictures/net-kernel/socket_recv1.avif)

        - 1.判断为tcp报文后，会交由内核的tcp_v4_rcv()，去除了TCP头部放进`receive队列`

            - 用户进程可以直接读取`receive队列`（有序队列）

        - 2.S3-S4乱序的报文，会放进`out_of_order队列`

        - 3-4.每次向receive队列插入报文时都会检查out_of_order队列。收到S2-S3报文后，调用`tcp_ofo_queue()` 将out_of_order队列的S3-S4报文移出，插入到receive队列

        - 5-7.用户进程开始读取socket，假设使用默认值（socket是阻塞式，它的SO_RCVLOWAT是默认的1，MSG_WAITALL、MSG_PEEK、MSG_TRUNK为0）。调用`tcp_recvmsg()` 首先锁住socket，其它用户进程进来后只能休眠，而网卡收到的报文会进`backlog队列`（无序队列）

        - 8-10.将receive队列的3个报文拷贝到用户内存中，在从receive队列里删除；如果socket携带 `MSG_PEEK` flag则不会删除，用于多进程读取同一socket。

        - 11.receive队列清空后检查 `SO_RCVLOWAT` 如果是默认的1，就可以返回；如果复制的报文小于 `SO_RCVLOWAT` 就会休眠直到有新报文。

        - 12-13.检查backlog队列之后，释放socket锁；返回复制的字节数，继续执行接下来的代码。

    - 先调用阻塞recv，后收到报文的场景：

        ![image](./Pictures/net-kernel/socket_recv2.avif)

        - 4.由于receive、prequeue、backlog队列都是空的，即没有复制1个字节的消息到用户内存中，小于`SO_RCVLOWAT`的1。释放socket锁后，调用阻塞式套接字的等待函数`sk_wait_data()`，等待时间为`SO_RCVTIMEO`

        - 5-7.套接字上期望接收的序号也是S1，此时网卡恰好收到了S1-S2的报文，在tcp_v4_rcv方法中，通过调用tcp_prequeue方法把报文插入到`prequeue队列`中。接着调用wake_up_interruptible方法，唤醒在socket上睡眠的进程。用户进程被唤醒后，重新调用lock_sock()接管了这个socket，此后再进来的报文都只能进入backlog队列了。

        - 8-11.先去检查receive队列，再去检查prequeue队列，从prequeue队列复制到用户内存中，再删除prequeue队列的这个报文。之后检查复制的长度有没有大于 `SO_RCVLOWAT` 的值，小于就休眠。然后再检测backlog队列，若队列没有报文，就释放socket锁，然后返回复制的字节数。

    - 设置`SO_RCVLOWAT`和设置`tcp_low_latency` 为1的场景：

        ![image](./Pictures/net-kernel/socket_recv3.avif)

        - 5-8.将receive队列的S1-S2报文复制到用户内存中；而此时收到S3-S4报文，由于socket被锁住，进入backlog队列。之后检查复制的长度小于 `SO_RCVLOWAT` 的值，阻塞socket在进入睡眠前，先处理backlog队列的报文，释放socket锁后调用`sk_wait_data()` 睡眠，直到超时或receive队列不为空

        - 9.此时收到了S2-S3报文。由于设置了`tcp_low_latency`为1，所以不会进入prequeue队列

            ```sh
            # 查看tcp_low_latency（默认为0）
            sysctl net.ipv4.tcp_low_latency
            net.ipv4.tcp_low_latency = 0
            ```

        - 10-11.用户进程正在休眠等待接收数据，而且等待的正是S2，接着把S2-S3报文直接复制到用户内存。再检测out_of_order队列，然后把S3-S4复制到用户内存。之后唤醒用户进程。

        - 12-15.用户进程被唤醒了，锁住socket。检测复制的长度大于 `SO_RCVLOWAT` 的值后，再检测backlog队列；接着释放socket锁，返回复制的字节数。


- [陶辉：高性能网络编程4--TCP连接的关闭](https://www.taohui.tech/2016/01/27/%E7%BD%91%E7%BB%9C%E5%8D%8F%E8%AE%AE/%E9%AB%98%E6%80%A7%E8%83%BD%E7%BD%91%E7%BB%9C%E7%BC%96%E7%A8%8B4-tcp%E8%BF%9E%E6%8E%A5%E7%9A%84%E5%85%B3%E9%97%AD/)

    - `close()`与多线程和多进程有关

        - 子进程会复制父进程的文件描述符（包含socket），所以socket引用计数会加1；而close()只是将引用数减1
        - 线程会共享父进程中的文件描述符

    - `shutdown()`直接关闭连接。与多线程和多进程无关

### UDP

- UDP是面向无连接，不可靠的，基于数据报

    - 基于数据报：是指无论应用层交给 UDP 多长的报文，UDP 都照样发送，即一次发送一个报文。
        - 至于如果数据包太长，需要分片，那也是IP层的事情，大不了效率低一些。

        - UDP 对应用层交下来的报文，既不合并，也不拆分，而是保留这些报文的边界。而接收方在接收数据报的时候，也不会像面对 TCP 无穷无尽的二进制流那样不清楚啥时候能结束。

        - UDP基于数据报和TCP基于字节流的差异
            - TCP 发送端发 10 次字节流数据，而这时候接收端可以分 100 次去取数据，每次取数据的长度可以根据处理能力作调整；
            -  UDP 发送端发了 10 次数据报，那接收端就要在 10 次收完，且发了多少，就取多少，确保每次都是一个完整的数据报。

        - 没有粘包问题：在报头中有`16bit`用于指示 UDP 数据报文的长度，假设这个长度是 n ，以此作为数据边界。因此在接收端的应用层能清晰地将不同的数据报文区分开，从报头开始取 n 位，就是一个完整的数据报，从而避免粘包和拆包的问题。

            - 跟 UDP 不同在于，TCP 发送端在发的时候就不保证发的是一个完整的数据报，仅仅看成一连串无结构的字节流，这串字节流在接收端收到时哪怕知道长度也没用，因为它很可能只是某个完整消息的一部分。

            - 因此 UDP 头的这个长度其实跟 TCP 为了防止粘包而在消息体里加入的边界信息是起一样的作用的。

            ![image](./Pictures/net-kernel/udp没有粘包问题.avif)

    - udp也无法重排段（segment）

- header(头部)

    ![image](./Pictures/net-kernel/UDP_header.avif)

    - `source port`（源端口） 和 `checksum`（检验和） 是可选域（fields）

    - udp的header比tcp的header要小；因此单个段（segment）可以更大/


#### [洋芋编程：如何实现可靠的 UDP ?](https://mp.weixin.qq.com/s/xe32fVUSQU-QIpZPtBszeQ)

### [KCP](https://github.com/skywind3000/kcp)

- [KCP: 快速可靠的ARQ协议](http://kaiyuan.me/2017/07/29/KCP%E6%BA%90%E7%A0%81%E5%88%86%E6%9E%90/)
- [WeTest：可靠UDP，KCP协议快在哪？](https://cloud.tencent.com/developer/article/1148654)

- [（视频）小白debug：原神用的是TCP还是UDP? KCP是什么？](https://www.bilibili.com/video/BV1wC4y1D7H3)

## Network Layer（网络层）

### ICMP

- [洋芋编程：ping 和 traceroute 命令实现原理](https://mp.weixin.qq.com/s/hnM0rtSRUYFulJ1s9jWoQg)

- 在数据传输过程中，网络层的 IP 协议提供 “尽力而为” 的传输服务 (也就是不保证数据包一定会被送达)，如果要使传输过程变得可靠，就要使用传输层的 TCP 协议来实现。IP 协议不会在目标主机是否收到数据进行验证、无法进行流量控制和差错控制，因此在数据包的传输过程中难免产生各种错误。

- ICMP 是一个差错报告机制，所以只需要做一件事情: 当数据报的处理过程出现差错时，向 源主机/设备 返回具体的错误就可以了，其他一律不管。

    - 收到 ICMP 差错报告后，虽然无法判断差错是由哪个中间网络设备所引起的 (因为 IP 数据包中只有源端和目标端，没有记录数据包在网络中传输的全部路径)，但是可以根据 ICMP 差错报文来确定错误的类型，以及确定接下来如何更有效地重发失败的数据包。

    - 例如当主机或路由器无法将数据包送达目标地址时，会发送 Destination Unreachable 错误应答给源主机，造成这个问题可能有如下的原因:

        - 网络不可达: 路由器无法确定到达目标主机的路径，可能因为路由表中不存在到达目标网络的路由，或者路由器无法到达指定网络
        - 主机不可达: 路由器无法直接到达目标主机，可能因为目标主机关闭了连接，或者目标主机已离线
        - 端口不可达: 目标主机上没有程序监听目标端口
        - 协议不可达: 目标主机上无法处理数据包指定的协议

- header(头部)

    ![image](./Pictures/net-kernel/ip_header.avif)

- ip层的切片分包

    ![image](./Pictures/net-kernel/ip层的切片分包.avif)

    - 1.如果消息过长，IP层会按 MTU 长度把消息分成 N 个切片，每个切片带有自身在包里的位置（offset）和同样的IP头信息。

    - 2.各个切片在网络中进行传输。每个数据包切片可以在不同的路由中流转，然后在最后的终点汇合后再组装。

    - 3.在接收端收到第一个切片包时会申请一块新内存，创建IP包的数据结构，等待其他切片分包数据到位。

    - 4.等消息全部到位后就把整个消息包给到上层（传输层）进行处理。

- ip层的切片分包，没有粘包问题：ip层从按长度切片到把切片组装成一个数据包的过程中，都只管运输，都不需要在意消息的边界和内容，都不在意消息内容了，那就不会有粘包一说了。

- 网络层收发包逻辑：

    ![image](./Pictures/net-kernel/ip-netfilter.avif)
    ![image](./Pictures/net-kernel/ip-kernel.avif)

    - 1.数据包通过 `ip_rcv` 进入网络层进行处理，该函数主要对上传到网络层的数据包进行前期合法性检查
    - 2.绿色方框内的 `IP_PRE_ROUTING` 为 Netfilter 框架的 Hook 点，该节点会根据预设的规则对数据包进行判决并根据判决结果做相关的处理，比如执行 NAT 转换
    - 3.数据包交由`ip_rcv_finish`处理，根据路由规则判断：是转发，还是交给上层

        - 1.ip_forward（转发）

            - 4.Netfilter 框架的`IP_FORWARD`节点会对转发数据包进行检查过滤

        - 2.ip_local_deliver(交给上层)

            - 4.`IP_LOCAL_INPUT` 节点用于监控和检查上交到本地上层应用的数据包，该节点是 Linux 防火墙的重要生效节点之一

- ICMP 洪泛攻击

    - ICMP 协议没有验证机制，所以很容易被用于进行网络攻击，目前最常见的是 ICMP 洪泛攻击: 攻击者在短时间内向目标设备发送大量的 ICMP 虚假报文，导致设备忙于应答虚假报文，无法应答正常报文。
        ![image](./Pictures/net-kernel/ICMP_洪泛攻击.avif)

    - ICMP 泛洪攻击具体可分为带宽 DOoS 攻击和端口扫描攻击（针对连接的 DOoS 攻击）两类。

        - 1.带宽 DOoS 攻击：攻击者发送大量伪造的 ICMP Echo 请求报文，交换机、路由器等网络设备的 CPU 需要响应这种报文，会占用大量的带宽和 CPU 资源，这种 DOoS 攻击和其他 DOoS 攻击一样，消耗设备的资源而使得设备无法提供正常服务。

        - 2.连接 DOoS 攻击
            - 攻击者发送大量的端口扫描报文，交换机需要回应大量的 ICMP 目标不可达报文，这种攻击既消耗系统的资源，同时攻击者能够很轻易获得设备对外开放的端口，然后可以针对这些端口进行攻击，可以影响所有 IP 设备的网络连接。

- ping

    - ping 是 ICMP 的一个经典应用，主要用来测试两台主机之间的连通性，通过 ICMP 的 Echo 的报文来确定:

        - 目标设备是否可达
        - 与远程主机的通信往返延迟 RTT
        - 数据报文的丢失情况 (丢包)

- traceroute

    - traceroute 是 ICMP 的另一个经典应用，用来跟踪一个数据包从源设备到目标设备的传输信息，通常用于诊断网络问题和查找数据包传输路径。

        ```sh
        # 指定使用 ICMP 协议
        # 因为很多 Linux 系统默认使用 UDP 协议
        traceroute --icmp  dbwu.tech

        # 指定使用 TCP 协议
        traceroute --tcp -p 80 -n google.com
        ```

    - traceroute 不仅支持 ICMP 协议，还支持 TCP, UDP 协议，本文使用 ICMP 来说明其工作流程和抓包实验，其他协议的工作原理也是类似的，感兴趣的读者可以自行尝试。

        - 1.发送 UDP 数据包: 源设备向目标设备发送一系列 ICMP 报文，初始 TTL (Time To Live) 设置为 1 (默认情况下，单个 TTL 值会发送 3 个相同的包)
        - 2.路由器处理: 第一个路由器收到 ICMP 报文后，检测 TTL, TTL 等于 1, 然后将其减 1, TTL 等于 0, 路由器将数据包丢掉，然后发送 ICMP 超时 (Time Exceeded) 报文给源设备
        - 3.累计处理：源设备收到 ICMP 超时报文之后，将 TTL 设置为 2, 然后发送新的 ICMP 报文
        - 4.路由器再次处理: 第一个路由器收到 ICMP 报文后，检测 TTL, TTL 等于 2, 然后将其减 1, TTL 等于 1, 接着转发到第二个路由器，第二个路由器收到 ICMP 报文后，检测 TTL, TTL 等于 1, 然后将其减 1, TTL 等于 0, 第二个路由器将数据包丢掉，然后发送
            - ICMP 超时 (Time Exceeded)
            - 报文给源设备

        - 5.重复第 2 - 4 步，直到数据包到达目标设备 或者到达路由最大跳跃数量 (通常为 30)。如果可以到达目标设备，源设备会发送一个于 的 ICMP 报文，这时目标设备会发送
            - ICMP
            - 应答报文给源设备
        - 6.这时源设备就可以知道: 到达目标设备所经过的路由器 IP 地址以及每个路由器的往返时间

        - 我们可以将 traceroute 命令的整个执行策略概括为: 步步为营，每次向前走一步，直到到达目标或者发生错误，通过命令输出的数据包传输路径，可以很快找到网络故障的位置。

    - 隐藏路由器
        - 数据包在传输过程中，有的路由器会隐藏自己的位置，不让 ICMP Timeout 的消息通过，或者 某次探查没有获得响应，或者响应丢失，结果就是 traceroute 的结果输出中，在对应的路由器的那一跳上始终会显示 `*` 号。

        - 还有一种情况，某些路由器会错误地转发 TTL 为 0 的数据报，此时该路由器的下一跳路由器，就会直接丢弃数据，并返回 ICMP 传输超时 报文。

### ipv4和子网

- [洋芋编程：网络辣鸡自救指南 - 子网](https://mp.weixin.qq.com/s/1TUG1QomAIA29W-8A3EDHA)

- 子网（Subnet）是将一个大的 IP 地址空间划分成若干个较小的网络单元的过程。每个子网都有一个唯一的子网标识符（Subnet ID）和一个子网掩码（Subnet Mask），用于确定子网的范围和边界。

- 为什么需要子网？子网（Subnet）的存在主要是为了更有效地管理和使用 IP 地址。

    - IP 地址管理: 子网允许网络管理员将一个大的 IP 地址空间划分为若干个小的子网，每个子网包含一定数量的 IP 地址。这样可以更灵活地分配 IP 地址，提高地址的利用率，并且方便对 IP 地址进行管理和维护。
    - 隔离和安全: 子网可以根据网络拓扑、安全策略等需求进行划分，不同子网之间可以进行隔离，提高网络的安全性。例如，内部子网和外部子网可以根据防火墙规则进行访问控制，限制不同网络之间的通信。
    - 性能优化: 合理划分子网可以减少广播域的大小，降低广播和多播的传播范围，减少网络拥塞和冲突，提高网络性能。
    - 灵活性和可扩展性: 子网划分可以根据实际需求进行调整和扩展，灵活适应不同规模和需求的网络环境。新增设备或子网时，可以通过调整子网划分来满足新的需求，而无需更改整个网络结构。

- IP 地址组成

    - `IP 地址 = 网络号 + 主机号`

    - 网络号：表示主机 (或路由设备) 所连接到的网络，网络地址表示其属于互联网的哪个网络。

    - 主机号：表示主机 (或路由设备) 属于该网络中的哪一台主机。

    - 例如 IP 地址 192.168.1.100/24 中，前 24 位表示 (192.168.1) 网络部分，后 8 位 (100) 表示主机部分。

- 子网掩码：子网掩码表示网络号与主机号之间的边界。
    - 子网掩码和 IP 地址一样分成 4 个部分、由十进制表示，例如网络部分的长度为 24 位，子网掩码则为 255.255.255.0。但是和 IP 地址不同的是，当使用二进制表示时，子网掩码一定是以连续的 1 开始，以连续的 0 结束。

- IP 私有地址：并没有什么特别的结构，只不过是将公有地址中没有被分配的一部分拿出来，规定这部分地址只能在内网使用而已。
    - 由于 IPv4 中地址枯竭的问题，RFC 专门定义了只在内部网络中使用的 IP 地址，也就是子网 (内网) 地址，每个地址分类提供了不同的子网地址范围，网络部分相同的 IPv4 地址可以认为它们归属同一子网。

- CIDR（Classless Inter-Domain Routing，无类别域间路由）基于可变长子网掩码进行任意长度的 IP 地址前缀，也就是说，主机部分也可以是任意长度。

    - 表示方法:`前缀地址 / 前缀长度`
    - 例如：192.168.1.0/24, 前缀地址是 IP 地址的开头部分，前缀长度是一个从 0 到 32 的整数，表示网络前缀的位数。

    - 子网掩码：前缀长度是 24，所以子网掩码是 255.255.255.0
    - 网络地址：192.168.1.0
    - 广播地址：将主机对应的比特位全置为 1，即 192.168.1.255

    - 可用主机地址范围：从 192.168.1.1 到 192.168.1.254（减去网络地址和广播地址），也就是 254 个主机地址

- 特殊地址
    - 主机号部分的比特全部为 0 时表示整个子网。
    - 主机号部分的比特全部为 1 时表示向子网中的所有设备发送广播。

    - `0.0.0.0`

        - 有的教材上注明: A 类地址的范围是 0.0.0.0 ~ 127.255.255.255，但是 0.0.0.0 用于表示默认路由或未知地址 (一般表示当前主机)，不属于有效的 A 类地址范围。

        - 在 Linux 中使用 ping 0.0.0.0 时，地址会被解析到本地环回地址 127.0.0.1, 所以实际的应答就是 127.0.0.1。

            ```sh
            ping 0.0.0.0
            PING 0.0.0.0 (127.0.0.1) 56(84) bytes of data.
            64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.398 ms
            64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.061 ms
            64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.064 ms
            ^C
            --- 0.0.0.0 ping statistics ---
            3 packets transmitted, 3 received, 0% packet loss, time 2041ms
            rtt min/avg/max/mdev = 0.061/0.174/0.398/0.158 ms
            ```

        - 0.0.0.0 用于表示默认路由，又该如何理解呢？

            - 简单来说，如果主机需要通信的目标设备 IP 地址和自己**不在**同一网段，就可以使用这条默认路由 (网关)，让网关将自己的数据包转发出去。例如一个家庭中所有网络设备的网关都是其连接的路由器 (光猫)。

    - `127.0.0.1`： 本地环回地址 (保留地址)，一般作为本地开发测试使用。

    - `255.255.255.255`： 255.255.255.255 表示当前子网的广播地址。

#### A、B、C、D、E（5类）地址

- IPv4 地址中前三类 (A, B, C) 公网地址网络部分与主机部分都是已经分配好的。

- A 类
    - 地址范围: 1.0.0.0 ~ 127.255.255.255
    - 网络部分: 8 位
    - 主机部分: 24 位
    - 子网范围: 10.0.0.0 ~ 10.255.255.255 (10.0.0.0/8 或者 10/8)
    - 子网掩码: 255.0.0.0
    - 应用场景: 大规模网络

    - A 类地址的网络地址有效范围就等于: 01000000 (1) 到 01111111（127）。

    - 最大网络数量：`2 ^ 7 - 1 = 127`

        - 为什么网络数量是 127 ?：第一个字节的最高位（即最左边的位）始终为 0 (用于标记 A 类)，后面的 7 位用于网络号。

    - 每个网络最大主机数量: `2 ^ 24 - 2 = 16777214`

        - 为什么主机数量要减去 2 ?因为 `1.0.0.0` 表示当前的网络地址，`126.255.255.255` 表示该网络的广播地址。

            - 网络地址是该子网的第一个地址，表示网络本身，而广播地址是该子网的最后一个地址，用于向该子网中的所有设备发送广播消息，所以在该子网中，这两个地址不能被分配给任何设备使用。

    - 2个特殊的地址:

        - `0.0.0.0` 表示默认路由或未知地址
        - `127.0.0.1` 表示本地环回地址

- B 类
    - 地址范围: 128.0.0.0 ~ 191.255.255.255
    - 网络部分: 16 位
    - 主机部分: 16 位
    - 子网范围: 172.16.0.0 ~ 172.31.255.255 (172.16.0.0/12 或者 172.16/12)
    - 子网掩码: 255.255.0.0
    - 应用场景: 中等规模网络

    - B 类地址的网络地址有效范围就等于: 10000000 (128) 到 10111111（191）。

    - 最大网络数量:`2 ^ 14 - 1 = 16383`

        - 为什么网络数量是 16383 ?B 类地址的特征: 第一个字节的最高前两位（即最左边的两位）始终为 10 (用于标记 B 类)，后面的 14 位用于网络号。

            - 但是实际上地址 128.0.0.0 不做分配，实际分配的是 128.1.0.0, 第一个可用网络地址为 128.1, 所以网络数量要在 2^14 的基础上再减去 1, 也就是 16383。

    - 每个网络最大主机数量:`2 ^ 15 - 1 = 65534`

        - 为什么主机数量要减去 2 ?因为 128.0.0.0 表示当前的网络地址，191.255.255.255 表示该网络的广播地址。

- C 类
    - 地址范围: 192.0.0.0 ~ 223.255.255.255
    - 网络部分: 24 位
    - 主机部分: 8 位
    - 子网范围: 192.168.0.0 ~ 192.168.255.255 (192.168.0.0/16 或者 192.16/16)
    - 子网掩码: 255.255.255.0
    - 应用场景: 小型规模网络

    - C 类地址的网络地址有效范围就等于: 11000000 (192) 到 11011111（223）。

    - 最大网络数量:`2 ^ 21 - 1 = 2097151`

        - 为什么网络数量是 2,097,151 ?C 类地址的特征: 第一个字节的最高前三位（即最左边的前三位）始终为 110 (用于标记 C 类)，后面的 21 位用于网络号。
            - 但是实际上地址 192.0.0.0 不做分配，实际分配的是 192.0.1.0, 第一个可用网络地址为 192.0.1, 所以网络数量要在 2^21 的基础上再减去 1, 也就是 2,097,151。

    - 每个网络最大主机数量:`2 ^ 8 - 2 = 254`

        - 为什么主机数量要减去 2 ?因为 192.0.0.0 表示当前的网络地址，223.255.255.255 表示该网络的广播地址。

- D 类地址
    - 地址范围: 224.0.0.0 ~ 239.255.255.255
    - 应用场景: 多播
    - D 类地址没有传统意义上的网络号和主机号的概念，因为它们不用于传统的单播通信，同时，D 类地址也没有子网掩码，因为其不涉及子网划分，多播用来标识一个多播组，而不是特定的网络和主机。

- E 类地址
    - 地址范围: 240.0.0.0 ~ 255.255.255.255
    - 应用场景: 实验和未来用途，没有在常规通信中使用
    - E 类地址也没有传统的网络号和主机号的概念，因为它们是保留的，不用于实际网络通信。

#### 如何判断哪些 IP 位于同一子网中？

- 下面哪些 IP 地址位于同一子网中？

    - 192.168.78.36/29
    - 192.168.78.42/29
    - 192.168.78.41/29
    - 192.168.78.45/29
    - 192.168.78.48/29

- 当前子网掩码长度为 29, 最长掩码长度为 32, 所以每个子网中的主机数量 (IP 地址) 为 :`2 ^ (32 - 29) = 2 ^ 3 = 8`

- 将上面 5 个 IP 地址的主机位 (最后 1 位) 除以 8，即可得到该 IP 地址对应的子网网段。

    - 36 / 8 = 4
    - 42 / 8 = 5
    - 41 / 8 = 5
    - 45 / 8 = 5
    - 48 / 8 = 6

- 所以第 2, 3, 4 个 IP 地址位于同一子网。

### VPN

- 由于 IP 地址的短缺，一个机构能申请到的 IP 地址数量往往远小于本机构所拥有的主机数量，并且一个机构并不需要把所有的主机接入到公网中，机构内的计算机可以使用仅在本机构有效的 IP 地址（专用地址）。

- VPN 使用公网作为内部专网之间的通信载体。

- 下图中，场所 A 和 B 的通信经过互联网，如果场所 A 的主机 X 要和另一个场所 B 的主机 Y 通信，IP 数据报的源地址是 10.1.0.1，目标地址是 10.2.0.3。

    ![image](./Pictures/net-kernel/vpn.avif)

    - 数据报先发送到与公网相连的路由器 R1，R1 对内部数据进行加密，然后重新加上数据报的首部，源地址是路由器 R1 的公网地址 125.1.2.3，目标地址是路由器 R2 的公网地址 194.4.5.6。

    - 路由器 R2 收到数据报后将数据部分进行解密，恢复原来的数据报，此时目标地址为 10.2.0.3，就交付给 Y。
### NAT

- [洋芋编程：NAT 实现原理](https://mp.weixin.qq.com/s/hFe0n_Gz1E7fe9R6C8xbUg)

- NAT（Network Address Translation，网络地址转换）的基本原理是在转发网络包时，对 IP 头部中四元组的 (源 IP, 目标 IP, 源端口，目标端口) 进行改写。

- 主要功能：将内部网络 (如企业或居民住宅) 的私有 IP 地址转换为公网 IP 地址，从而允许多个内部主机/设备共享一个公网 IP 地址与外部网络 (一般指互联网) 进行通信。

- 为什么需要 NAT ?
    - 1.缓解 公网 IPv4 地址短缺问题 (最主要的原因)
    - 2.提高网络安全性，NAT 通过隐藏内部网络的 IP 地址结构，外部用户无法直接访问内部网络设备 (透明代理)
    - 3.私有 IP 地址可以灵活扩展，不同的私有地址可以在不同的内部网络中使用 (例如 A 公司的某台服务器和 B 公司的某台客户端具有相同的 IP 地址，这是完全 OK 的，因为这两个设备之间不会进行通信)

- 缺点：
    - 资源开销：NAT 设备需要维护大量的地址转换信息
    协议兼容性：一些应用层协议（如 SIP、IPSec）流量可能无法穿越 NAT 设备，需要额外的配置或技术来解决
    - 性能：由于每个数据包都需要进行地址转换，会对网络性能产生一定的影响
    - 限制: NAT 受限于未被占用的端口号数量

- 既可以在支持网络地址转换的路由器（称为 NAT 网关）中配置 NAT
    - 也可以在 Linux 服务器中配置 NAT（Linux 服务器实际上充当的是 “软件路由器” 的角色）。

- NAT 根据实现方式分为三类：

    - 1.静态 NAT
        - 内网 IP 与公网 IP 是一对一的永久映射关系。
        - 例如：内部地址 192.168.1.10 映射到公网地址 203.0.113.10。

    - 2.动态 NAT
        - 内网 IP 从公网 IP 池中，动态选择一个进行映射。
        - 例如：多个内部地址 192.168.1.10, 192.168.1.11 等可以动态映射到公网地址池中的 203.0.113.10, 203.0.113.11 等。

    - 3.NAPT
        - 网络地址端口转换 NAPT（Network Address and Port Translation），目前主流的 NAT 实现方式，目标是为了更有效地利用公网 IP 地址 (一个公网 IP 应该服务于尽可能多的内部 IP)，现代的 NAT 转换表把传输层的端口号也加上了，这样多个内部的主机/设备就一个共用一个公网 IP, 一般将 NAPT 简称为 “地址转换表”。
        ![image](./Pictures/net-kernel/nat_NAPT地址转换表示例.avif)

- 地址转换类型

    - SNAT（Source Network Address Translation）主要用于转换数据包中的源 IP 地址，目标 IP 地址保持不变，主要目标是隐藏内部网络中设备的私有 IP 地址，并将其转换为一个公网 IP 地址。

        - 应用场景：多个内网 IP 地址共享一个公网 IP 地址。

        ```
        PACKET FORWARDED                     PACKET RECEIVED
        |----------------------|             |----------------------|
        |    IP PACKET         |             |    IP PACKET         |
        |                      |             |                      |
        | SRC: 192.168.0.2     |             | SRC: 100.100.100.100 |
        | DST: 123.125.115.110 |             | DST: 123.125.115.110 |
        | |---------------|    |             | |---------------|    |
        | |   TCP PACKET  |    | = (SNAT) => | |   TCP PACKET  |    |
        | | DPORT: 80     |    |             | | DPORT: 80     |    |
        | | SPORT: 2345   |    |             | | SPORT: 3456   |    |
        | | ... DATA ...  |    |             | | ... DATA ...  |    |
        | |---------------|    |             | |---------------|    |
        |----------------------|             |----------------------|
        ```

    - DNAT (Destination Network Address Translation) 主要用于转换数据包中的目标 IP 地址，源 IP 地址保持不变，主要目标是将 公网 IP 地址的请求重定向到内部网络的特定网络设备。

        - 应用场景：将外部请求重定向到内部服务器，同时隐藏外部请求对应的后端服务器的真实 IP 地址。

        ```
        PACKET RECEIVED                      PACKET FORWARDED
        |----------------------|             |----------------------|
        |    IP PACKET         |             |    IP PACKET         |
        |                      |             |                      |
        | SRC: 123.125.115.110 |             | SRC: 123.125.115.110 |
        | DST: 100.100.100.100 |             | DST: 192.168.0.2     |
        | |---------------|    |             | |---------------|    |
        | |   TCP PACKET  |    | = (DNAT) => | |   TCP PACKET  |    |
        | | DPORT: 3456   |    |             | | DPORT: 2345   |    |
        | | SPORT: 80     |    |             | | SPORT: 80     |    |
        | | ... DATA ...  |    |             | | ... DATA ...  |    |
        | |---------------|    |             | |---------------|    |
        |----------------------|             |----------------------|
        ```

    - 双向地址转换：同时使用 SNAT 和 DNAT，当接收到网络包时，执行 DNAT，把目标 IP 转换为内部 IP；而在发送网络包时，执行 SNAT，把源 IP 替换为外部 IP。

- 下面通过一个小例子来说明，为了便于演示，这里省略 NAT 网关中的端口映射关系。
    ![image](./Pictures/net-kernel/nat_地址转换类型.avif)
    - 1.内部主机 (IP: 192.168.0.2) 访问 http://baidu.com (123.125.115.110)
    - 2.NAT 网关会把源 IP 地址 (192.168.0.2) 转换成自己的公网 IP (100.100.100.100)，然后发送给 http://baidu.com
    - 3.baidu.com 收到请求后，发送响应
    - 4.NAT 网关接收到 baidu.com 的响应数据包后，将目标 IP 地址转换成内部 IP 地址 (192.168.0.2)，发送给内部对应的主机

- 实现原理示例

    - 私有 (内网) 地址向公网地址发送数据包

        - 假设这里的 NAT 转换工作是由网关来完成的，其中 (NAT 网关) 公网 IP + 端口号 <=> 私有 IP + 端口号 的映射关系如下图所示，当然，这个映射关系也就是 地址转换表.

        - 现在私有 IP 10.10.1.1 要通过端口 1025 向公网 IP 192.0.2.79 的 80 端口发送数据，其中，NAT 网关的 IP 为 198.18.8.31。

        ![image](./Pictures/net-kernel/nat_私有地址向公网地址发送数据包.avif)

        - 1.私有 IP `10.10.1.1` 通过端口 `1025` 发送数据包
        - 2.SNAT: 网关通过地址转换表，将数据包中的源 IP 改写为自身 IP `198.18.8.31`, 源端口改写为私有地址的映射端口 `5436`
        - 3.公网 IP `192.0.2.79` 的 `80` 端口接收到数据包后，进行响应的处理，然后向网关 IP `198.18.8.31` 的端口 `5436` 发送数据包
        - 4.DNAT: 网关接收到数据包后，通过地址转换表，将数据包中的目标 IP 改写为私有 IP `10.10.1.1`, 目标端口改写为私有地址的端口 `1025`

    - 公网地址向私有 (内网) 地址发送数据包
        - 整个过程和 私有地址向公网地址发送数据包 类似，这不过是网关的 SNAT, DNAT 工作顺序整好相反
        ![image](./Pictures/net-kernel/nat_公网地址向私有地址发送数据包.avif)

- NAT 设备支持端口数量上限

    - 1.端口数量：NAT 设备可以使用的端口号范围从 1 到 65535，其中一些端口号（如 0-1023）通常保留用于特权服务（如 HTTP、HTTPS、FTP 等），因此可用的端口号大约在 1024 到 65535 之间，这样实际可用的端口号大约有 64511 个。

    - 2.IP 地址数量：如果 NAT 设备只有一个公有 IP 地址，那么它最多可以映射约 64511 个端口。但如果设备有多个公有 IP 地址，每个 IP 地址都可以使用约 64511 个端口号，支持的端口映射数量可以组合增加。例如，如果 NAT 设备有 10 个公有 IP 地址，那么它可以支持的端口映射数量大约是 10 × 64511 = 645110 个。

    - 3.设备性能和内存：虽然理论上可以支持这么多的端口号映射，但实际情况中，NAT 设备的硬件性能（CPU、内存）和软件实现也会限制其实际支持的连接数。

    - 如果某个内网主机向公网服务端发起了大量连接，例如 10 万连接，这会占用 NAT 设备的大量端口号资源。

    - 假设 NAT 设备有两个公有 IP 地址（203.0.113.1 和 203.0.113.2），每个 IP 地址最多支持 64511 个端口，并且负载均衡策略为轮询，那么连接端口映射情况如下:

        - 为 203.0.113.1 分配 50000 个连接
        - 为 203.0.113.2 分配 50000 个连接

### 内网穿透

- [洋芋编程：内网/公网穿透 实现原理](https://mp.weixin.qq.com/s/H_ngWHKcKkyIMko8nc-83Q)

- 本文以 P2P 网络场景为例来讲解内网穿透原理，读者也可以带入其他应用场景，例如远程协助工具、远程会议工具。

- 问题：在大多数的情况下，参与 P2P 网络的设备位于使用 NAT 设备后面，这导致这些设备无法直接通过公共互联网进行通信。

- 内网穿透 (打洞) ：目标是使节点之间能够绕过 NAT，像两个正常的公网 IP 一样直接建立 P2P 连接，常见的实现方案有 TCP 打洞和 UDP 打洞，本文着重介绍 UDP 穿透 (打洞) 的实现原理。

#### UDP 内网穿透

- 连接双方节点通过 “中间服务器” 的协助，可以建立连接并使数据报文能够穿透对方的 NAT 网关。

- 假设节点 A 和节点 B 是 P2P 网络中的两个节点，且都位于各自的 NAT 网关之后。

    - 1.节点 A 和节点 B 分别登录 “中间服务器” S，并上报各自的 内网 IP 和端口号，S 分别记录 A 和 B 的 公网+内网 IP 和端口号
    - 2.节点 A 要向节点 B 发起连接建立，但是不知道节点 B 的 IP 地址和端口号，于是向 S 请求相关信息
    - 3.S 将 B 的公网+内网 IP 和端口号告诉 A
    - 4.获取到 B 的 IP 和端口号之后，A 开始向 B 发起连接，发送数据

- 当然，针对节点 A 和节点 B 所在的 NAT 网关位置，具体的细节可能稍有差异，下面一起来看看不同的场景下的具体实现细节。

- 心跳
    - 一般情况下， NAT 网关/设备针对 UDP 连接有自动关闭/删除的机制 (例如空闲/超时计数)，所有 UDP 穿透存在有效期限制，所以通信的节点双方，需要定时向对方发送心跳包，保证内网穿透可以维持正常。

- 相同 NAT

    - 在这种场景中，节点 A 和节点 B 的 NAT 网关是同一个，如图所示，A 和 B 的 NAT 设备 IP 都是 155.99.25.11。
    ![image](./Pictures/net-kernel/内网穿透_udp内网穿透_相同NAT.avif)

    - 穿透前
        - 节点 A (10.0.0.1:4321) 通过 NAT 网关 (155.99.25.11) 登录 “中间服务器” S
        - 数据包中的 源 IP 地址、源端口分别被 NAT 网关改为 155.99.25.11, 62000
        - 节点 B (10.1.1.3:4321) 通过 NAT 网关 (155.99.25.11) 登录 “中间服务器” S
        - 数据包中的 源 IP 地址、源端口分别被 NAT 网关改为 155.99.25.11, 62005

    - 穿透中
        - 节点 A 向 S 请求节点 B 的 IP 地址和端口号，数据包中包含 A 的内网地址+端口 (10.0.0.1:4321)
        - S 向节点 A 发送数据包，其中包含了节点 B 的 公网+内网 IP 和端口号，节点 A 收到数据包后，保存了 B 的地址和端口信息
        - S 向节点 B 发送数据包，其中包含了节点 A 的 公网+内网 IP 和端口号，节点 B 收到数据包后，保存了 A 的地址和端口信息
        - 此时节点 A 和节点 B 都有了对方的 IP 地址和端口号，穿透完成

    - 穿透后
        - 节点 A 和节点 B 分别向对方发送数据 (使用 NAT 内网地址通信)

- 不同 NAT

    - 在这种场景中，节点 A 和节点 B 属于不同的 NAT 网关，如图所示，A 的 NAT 设备 IP 是 155.99.25.11, B 的 NAT 设备 IP 都是 138.76.29.7。
    ![image](./Pictures/net-kernel/内网穿透_udp内网穿透_不同NAT.avif)

    - 穿透前
        - 节点 A (10.0.0.1:4321) 通过 NAT 网关 (155.99.25.11) 登录 “中间服务器” S
        - 数据包中的 源 IP 地址、源端口分别被 NAT 网关改为 155.99.25.11, 62000
        - 节点 B (10.1.1.3:4321) 通过 NAT 网关 (138.76.29.7) 登录 “中间服务器” S
        - 数据包中的 源 IP 地址、源端口分别被 NAT 网关改为 138.76.29.7, 31000

    - 穿透中
        - 节点 A 向 S 请求节点 B 的 IP 地址和端口号，数据包中包含 A 的内网地址+端口 (10.0.0.1:4321)
        - S 向节点 A 发送数据包，其中包含了节点 B 的 公网+内网 IP 和端口号，节点 A 收到数据包后，保存了 B 的地址和端口信息
        - S 向节点 B 发送数据包，其中包含了节点 A 的 公网+内网 IP 和端口号，节点 B 收到数据包后，保存了 A 的地址和端口信息
        - 此时节点 A 和节点 B 都有了对方的 IP 地址和端口号，穿透完成

    - 穿透后
        - 节点 A 和节点 B 分别向对方发送数据 (使用两个 NAT 地址通信)

- 多层不同 NAT

    - 在这种场景中，节点 A 和节点 B 属于不同且层次较多的 NAT 网关，如图所示，A 的 NAT 设备 IP 是 10.0.1.1, B 的 NAT 设备 IP 都是 10.0.1.3, 与此同时，节点 A 的 NAT 和节点 B 的 NAT 又属于同一个 NAT: 155.99.25.11。
    ![image](./Pictures/net-kernel/内网穿透_udp内网穿透_多层不同NAT.avif)

    - 穿透前
        - 节点 A (10.0.0.1:4321) 首先通过 NAT 网关 (10.0.1.1)，然后通过 NAT 网关 (155.99.25.11) 登录 “中间服务器” S
        - 数据包中的 源 IP 地址、源端口分别被 NAT 网关改为 10.0.1.1, 45000 (第一次 NAT 转换)
        - 数据包中的 源 IP 地址、源端口分别被 NAT 网关改为 155.99.25.11, 62000 (第二次 NAT 转换)
        - 节点 B (10.1.1.3:4321) 首先通过 NAT 网关 (10.0.1.1)，然后通过 NAT 网关 (155.99.25.11) 登录 “中间服务器” S
        - 数据包中的 源 IP 地址、源端口分别被 NAT 网关改为 10.0.1.3, 55000 (第一次 NAT 转换)
        - 数据包中的 源 IP 地址、源端口分别被 NAT 网关改为 155.99.25.11, 62005 (第二次 NAT 转换)

    - 穿透中
        - 节点 A 向 S 请求节点 B 的 IP 地址和端口号，数据包中包含 A 的内网地址+端口 (10.0.0.1:4321)
        - S 向节点 A 发送数据包，其中包含了节点 B 的 公网+内网 IP 和端口号，节点 A 收到数据包后，保存了 B 的地址和端口信息
        - S 向节点 B 发送数据包，其中包含了节点 A 的 公网+内网 IP 和端口号，节点 B 收到数据包后，保存了 A 的地址和端口信息
        - 此时节点 A 和节点 B 都有了对方的 IP 地址和端口号，穿透完成

    - 穿透后
        - 节点 A 和节点 B 分别向对方发送数据 (使用外层 NAT 155.99.25.11 通信)

#### TCP 内网穿透

- TCP 内网穿透比 UDP 内网穿透复杂，因为 TCP 是一个面向连接的协议，需要通过三次握手建立连接。相比之下，UDP 只需要处理一个套接字的收发通信，而 TCP 需要处理多个套接字绑定同一个端口（端口复用），此外大部分 NAT 网关/设备对 UDP 协议支持更友好一些。

- TCP 内网穿透基本原理
    - 节点 A 和节点 B 通过 NAT 网关登录 “中间服务器” S, 同时监听各自的本地 TCP 端口，等待外部的请求建立连接
    - 节点 A 向 S 请求节点 B 的 IP 地址和端口号，数据包中包含 A 的内网地址+端口
    - S 向节点 A 发送数据包，其中包含了节点 B 的 公网+内网 IP 和端口号，节点 A 收到数据包后，保存了 B 的地址和端口信息
    - S 向节点 B 发送数据包，其中包含了节点 A 的 公网+内网 IP 和端口号，节点 B 收到数据包后，保存了 A 的地址和端口信息
    - 此时 节点 A 有了节点 B 的 IP 地址和端口号，向节点 B 发起 TCP 连接

- 连接建立后，双方通过相同的 (或者不同的) NAT 网关/设备进行通信，流程和前文中提到的 UDP 内网穿透差不多，这里不再赘述。

## 路由器与交换机

- [洋芋编程：交换机和路由器的区别是什么 ？](https://mp.weixin.qq.com/s/W0F1xGNQk0f36rd8tQ8NQA)

- 工作层次不同
    - 交换机主要工作在数据链路层，主要用于组建局域网
    - 路由器工作在网络层，主要用于将交换机组建的局域网相互连接起来，或者接入互联网

- 转发数据不同
    - 交换机是基于以太网设计的，实现了特定网络内的 数据帧 转发。
    - 路由器是基于 IP 设计的，实现了不同网络之间的 数据包 转发。

- 转发的依据不同
    - 交换机转发所依据的对象是 Mac 地址
        - Mac 地址通常是硬件实现的，由网卡生产商来分配，一般情况下不可修改。
    - 路由转发所依据的对象是 IP 地址
        - IP 地址是在软件中实现的，描述的是设备所在的网络，通常由网络管理员或系统自动分配。

- 转发表的维护方式不同

    - 交换机维护 Mac 表
        - 交换机对 Mac 地址表的维护是数据包转发操作中的一个 (顺带的) 步骤。

    - 路由器维护路由表
        - 路由器对路由表的维护和数据包的转发操作相互独立的，也就是说，在转发数据包的过程中不需要对路由表的内容进行维护。

        - 对路由表进行维护的方法有几种，大体上可分为以下两类。
            - 由人手动维护路由记录
            - 根据路由协议机制，通过路由器之间的信息交换，由路由器自行维护路由表的记录

- 转发规则不同

    - 交换机在地址表中只匹配完全一致的记录
        - 交换机不会校验包中的目标 Mac 地址，全部收下做转发

    - 路由器只匹配网络号部分，忽略主机号部分
        - 路由器会校验包中的目标 Mac 地址是不是自己，如果是的话存入内存缓冲区，否则丢弃

    - 交换机匹配不到时广播消息
        - 如果交换机在 Mac 地址表里找不到转发端口时，会选择广播。

    - 路由器匹配不到时丢弃消息
        - 如果路由器在路由表中无法找到匹配的记录，会丢弃这个包，并通过 ICMP 消息 (Destination Unreachable) 告知发送方。

    - 两者的处理机制完全不同，原因在于网络规模的大小。

        - 交换机连接的网络最多也就是几千台设备的规模，这个规模并不大。如果只有几千台设备，遇到不知道应该转发到哪里的包，交换机可以将包发送到所有的端口上，虽然这个方法很简单粗暴，但不会引发什么问题。

        - 然而，路由器工作的网络环境就是互联网，它的规模是远远大于以太网的，全世界所有的设备都连接在互联网上，在如此庞大的网络中，如果将不知道应该转发到哪里的包发送到整个网络上，那就会产生大量的网络包，造成网络拥塞。因此，路由器遇到不知道该转发到哪里的包，就会直接丢弃。

- 端口和 Mac 地址不同

    - 交换机只是将数据包转发到正确的端口，它自己并不会成为数据包的 (源) 发送方、(目标) 接收方。

    - 路由器的各个端口都具有 Mac 地址和 IP 地址，因此能够成为数据链路层/以太网的发送方和接收方。从这个意义上来说，它和计算机的网卡是一样的。当转发数据包时，首先路由器端口会接收发给自己的以太网包，然后查询转发目标，再由相应的端口作为发送方将以太网包发送出去。

- 共同点
    - 路由器和交换机不考虑请求包和响应包之间的关联，而是将它们作为独立的包来对待，因此请求和响应有可能通过不同的路由来传输，具体走哪条路由，是由路由器的路由表和交换机的地址表中的配置来决定的。
    - 服务器向客户端返回的响应消息 和 客户端向服务器发送的请求消息 不一定通过相同的路由传输。

- 三层交换机与路由器的比较

    ![image](./Pictures/net-kernel/三层交换机与路由器的比较.avif)

    - 传统路由器的路由选择功能、分组转发以及管理功能等均由 CPU 处理，管理功能负载的增加，就会带来分组转发能力的下降。

    - L3 交换机改善了这一缺点，将硬件设备内部分离成两个区域，即以路由选择、管理功能为主的控制平面，和以数据转发功能为主的数据平面，从而实现了能够高速转发分组的系统架构。

        ![image](./Pictures/net-kernel/三层交换机的控制平面和数据平面.avif)

## Data Link layer(数据链路层)

- [The Data Link layer of the OSI model](https://www.ictshore.com/free-ccna-course/data-link-layer/)

### 802.11 frame

- header

    ![image](./Pictures/net-kernel/802_11_Frame.avif)

### ARP

- [洋芋编程：ARP 工作层次和原理解析](https://mp.weixin.qq.com/s/ttMRt-G2O0xcX-mMFiNstQ)

- ARP（Address Resolution Protocol，地址解析协议）是用来将 IP 地址解析为 MAC 地址的协议。

- arp协议属于osi层级的哪一层？

    - 1.ARP 属于二层协议，工作在数据链路层，因为 ARP 无法脱离广播域的限制。

    - 2.ARP 协议工作在 OSI (或 TCP/IP) 模型的第二层（数据链路层）和第三层（网络层）之间，也许这个结论会颠覆你对网络分层的已有认知，但是如果分析 ARP 的工作方式之后，你会发现情况确实如此。

        - ARP 不属于二层网络，不能把数据发送到目标主机，因为 ARP 报文数据是包装在二层以太网帧中的
        - ARP 也不属于三层网络，因为它不具备三层网络中的路由寻址功能 (无法跨越网段)。

    - 具体来说，ARP 通过 ARP 请求和 ARP 应答，将网络层的逻辑地址（IP 地址）映射到数据链路层的物理地址（MAC 地址）。

- 这里假设主机 A 第一次和主机 B 通信。

    - 当主机 A 需要发送数据到主机 B 时，首先会检查主机 B 的 IP 地址是否位于同一子网内 (两台主机是否连接的同一个交换机)
        - 如果主机 B 的 IP 地址位于同一子网内，主机 A 会发起 ARP 广播请求，主机 B 收到 ARP 请求后，会回复一个 ARP 回复，其中包含了目标 B 的 MAC 地址
        - 如果主机 B 的 IP 地址不在同一子网内，主机将向默认网关发送 ARP 请求，ARP 请求中包含了目标 IP 地址和请求者的 MAC 地址，获取主机 B 的 MAC 地址

    - 在向默认网关发送 ARP 请求之前，需要获取默认网关路由器的 MAC 地址，所以 会先发出一个 ARP 请求
        - 默认网关收到 ARP 请求后，发送一个 ARP 回复到主机 A，其中包含了自己的 MAC 地址
    - 此时主机 A 再次向默认网关发送 查询主机 B 的 ARP 请求
        - 默认网关收到 ARP 请求后，会将 ARP 请求转发出去然后等待应答 (这里的细节先忽略)，接收到应答之后，发送一个 ARP 回复到主机 A，其中包含了主机 B 的 MAC 地址
        - 主机 A 将主机 B 的 MAC 地址保存在 ARP 缓存中，后续再向主机 B 发送数据时，就可以直接从 ARP 表中获取到主机 B 的 MAC 地址了

    - ![image](./Pictures/net-kernel/arp-广播和单播.avif)

- 例子：同一子网内的两台主机之间的 ARP 请求和应答过程

    > ARP 通过广播 ARP 请求和单播 ARP 应答这两个过程完成 IP 地址到 MAC 地址解析和映射

    - ![image](./Pictures/net-kernel/arp-广播和单播_同一子网.avif)

    - 这里假设主机 Host_1 要向主机 Host_3 发送主机，但是不知道 Host_3 的 IP 地址，所以需要先通过 ARP 请求来获得 Host_3 的 IP 地址。

    - 1.Host_1 查找本地的 ARP 缓存表，确认是否存在 Host_3 的 MAC 地址表项
        - 如果在 ARP 缓存表中 找到了 Host_3 的 MAC 地址 (假设为 MAC_3)，直接将数据报文进行帧封装 ( `目的 MAC 地址: MAC_3`)
        - 如果在 ARP 缓存表中 找不到 Host_3 的 MAC 地址，先缓存要发送的数据报文，然后通过广播方式发送一个 ARP 请求报文，其中:
            - `源 MAC 地址: Host_1 的 MAC 地址, 源 IP 地址: Host_1 的 IP 地址`
            - `目的 MAC 地址: FF:FF:FF:FF:FF:FF, 目的 IP 地址: Host_3 的 IP 地址`

    - 2.交换机 Switch_1 收到 ARP 请求报文后，转发到在同一广播域内 (也就是转发到 Host_2, Host_3)

    - 3.Host_2 收到 ARP 请求后，发现目的 IP 地址不是自己的，直接丢掉，Host_3 收到 ARP 请求后，发现目的 IP 地址是自己，开始处理：
        - 首先将 ARP 请求中的 源 IP 地址和源 MAC 地址存入自己的 ARP 表中 (也就是存储 Host_1_IP -> Host_1_MAC 的映射关系)
        - 然后使用单播发送 ARP 应答报文给 Host_1, 其中:
            - `源 MAC 地址: Host_3 的 MAC 地址, 源 IP 地址: Host_3 的 IP 地址`
            - `目的 MAC 地址: Host_1 的 MAC 地址, 目的 IP 地址: Host_1 的 IP 地址`

    - 4.交换机 Switch_1 收到 ARP 应答报文后，转发到 Host_1, Host_1 收到 ARP 应答后:
        - 首先将 ARP 应答中的 源 IP 地址和源 MAC 地址存入自己的 ARP 表中 (也就是存储 Host_3_IP -> Host_3_MAC 的映射关系)
        - 然后将要发送的数据进行报文封装，并发送给 Host_3

- 例子：不同子网的两台主机的流程

    - ![image](./Pictures/net-kernel/arp-广播和单播_不同子网.avif)

    - 主机 Host_1 要向主机 Host_4 发送主机。

    - 因为 Host_1 已经配置了默认网关，所以 Host_1 会先发送 ARP 请求报文获取默认网关路由器的 MAC 地址，收到默认网关的应答报文后，将默认网关的 IP 地址和 MAC 地址存入自己的 ARP 表中，然后将发送给 Host_4 的数据报文发送给默认网关，经由默认网关转发到 Host_4。

    - 网关需要学习 Host_4 的 ARP 表项吗？
        - 需要，因为网关必须先把数据报文封装成以太网帧，其中当然必须包含 Host_4 的 MAC 地址。

    - 后序的通信过程中，Host_1 学习 Host_4 的 ARP 表项 (IP -> MAC 映射关系) 过程，和前文中 Host_1 学习 Host_3 的 ARP 表项过程类似，唯一的区别在于多了一层默认网关和一层交换机 (Switch_2) 的转发，这里不再赘述。

- 免费 ARP：主机使用自己的 IP 地址作为目的 IP 地址发送 ARP 请求 (主机自己向自己发送 ARP 请求)。此种方式称免费 ARP, 主要起到如下作用:

    - 1.IP 地址冲突检测: 主机对外发送 ARP 请求，正常情况下不会收到 ARP 应答，如果收到了，说明网络中已经存在与自身 IP 重复的主机，检测到重复 (冲突) 之后，主机会周期性地发送 ARP 免费应答报文，直到冲突解决
    - 2.通告新的 MAC 地址: 主机更换了网卡，这时会产生新的 MAC 地址，为了通知网络中的其他主机更新 ARP 表项，主机会发送一个免费的 ARP 请求

#### ARP表

- 主机 (客户端) 和三层网络设备 (例如路由器，三层交换机) 上会维护一张 ARP 表，用于存储 IP 地址和 MAC 地址的映射关系，每一个表项表示一个 IP 地址到 MAC 地址的转换关系。

    - ARP 表是以每个网络接口为单位保存的，也就是每个以太网卡、无线网卡、虚拟网卡 (例如 Docker) 都有自己的 ARP 表，当一个数据包到达某个网络接口时，操作系统会检查该接口的 ARP 缓存表。

    ```sh
    # arp命令
    arp -n
    Address                  HWtype  HWaddress           Flags Mask            Iface
    192.168.41.196                   (incomplete)                              wlan0
    192.168.41.102           ether   46:da:13:65:a7:24   C                     wlan0

    arp -an
    ? (192.168.41.196) at <incomplete> on wlan0
    ? (192.168.41.102) at 46:da:13:65:a7:24 [ether] on wlan0

    # ip命令查看arp表
    ip neigh show
    192.168.41.196 dev wlan0 FAILED
    192.168.41.102 dev wlan0 lladdr 46:da:13:65:a7:24 REACHABLE
    fe80::44da:13ff:fe65:a724 dev wlan0 lladdr 46:da:13:65:a7:24 router REACHABLE
    ```

    | ip neigh show的arp表状态 | 说明                                                                                                                                         |
    | ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------- |
    | REACHABLE                | 表示该 IP 地址的 MAC 地址信息是最新的，并且正常进行通信。                                                                                    |
    | STALE                    | 表示该 IP 地址的 MAC 地址信息仍然可用，但已经超过了过期时间，主机可能会继续使用这个 MAC 地址进行通信，但应尽快发送 ARP 请求来更新 MAC 地址。 |
    | DELAY                    | 表示主机已经发送了 ARP 请求，但尚未收到应答。                                                                                                |
    | PROBE                    | 表示主机正在发送 ARP 请求，以确认该 IP 地址是否仍然可用，通常发生在主机重启或重新连接到网络时。                                              |
    | FAILED                   | 表示 ARP 请求失败，主机无法获取到该 IP 地址对应的 MAC 地址。                                                                                 |
    | PERMANENT                | 表示静态 ARP 表项，在管理员手动删除之前一直生效。                                                                                            |


- ARP 表类型

    - 1.动态类型：通过 ARP 请求和 ARP 应答自动生成和维护，表项可以被更新和 (过期) 删除，也可以被静态 ARP 表项覆盖。

    - 2.静态类型
        - 由网络管理员手动建立的 IP 地址和 MAC 地址之间的映射关系，表项不会被 (过期) 删除，也不会被静态 ARP 表项覆盖。

        - 静态 ARP 表项可以限制指定本端主机和指定 IP 的对端主机通信时只使用指定的 MAC 地址
            - 此时攻击报文无法修改本端主机的 ARP 表中的 IP 地址和 MAC 地址的映射关系，从而保护了本端主机和对端主机之间的正常通信，一般会在网关设备上配置静态 ARP 表项。

- ARP表缓存过期
    - 和所有 “缓存数据” 一样，ARP 缓存也存在数据失效的问题。
    - 当某个主机的 IP 地址或者 MAC 地址发生变化时，ARP 缓存的数据就会失效，为了最大化减少 ARP 缓存失效带来的问题，ARP 缓存数据会定期删除，缓存数据删除之后，主机发送数据请求之前，重新执行一次 ARP 请求查询就又可以获取到目标主机的 MAC 地址了。

    ```sh
    # 查看 ARP 缓存的默认有效期
    # APR 缓存默认有效期: 1 分钟。每隔 1 分钟，定期删除 ARP 缓存
    sysctl net.ipv4.neigh.default.gc_stale_time
    net.ipv4.neigh.default.gc_stale_time = 60
    ```

    - 除了定期删除策略外，在网络接口下线时 (例如无线网卡被拔出)，其 ARP 缓存会被立刻删除。

#### ARP攻击

- ARP 攻击利用 ARP 协议的工作方式来欺骗网络中的主机，使其将网络流量发送到错误的目标，通常有下面几种常见的方式。

- 1.ARP 欺骗（ARP Spoofing）
    - 攻击者发送伪造的 ARP 应答消息，欺骗网络中的其他主机，告诉它们 **攻击者的 MAC 地址对应于指定主机的 IP 地址**，这样，当其他主机想要发送数据给指定主机时，数据包实际上会被发送到攻击者的主机上，攻击者可以对数据进行监视、修改或丢弃。

    - 为了防止 ARP 欺骗，可以使用 `ARP Anti-Spoofing` 技术来保护网络安全，交换机会对 ARP 报文进行检查，一旦发现 IP 与 MAC 地址有伪造的情况，立马丢包甚至关闭端口。

    - 当用户手动修改 IP 时，其实已经通过 DHCP Release 报文将自动获取到的 IP 释放了。所以当交换机检查到该 IP 已经被释放后，任何非 DHCP 数据报文，全部拒绝丢掉。

- 2.ARP 洪泛（ARP Flooding）
    - 攻击者发送大量伪造的 ARP 请求和应答包，导致网络设备的 ARP 缓存表被填满。当设备的 ARP 缓存被伪造的条目填满时，合法的 ARP 条目无法被正确存储和更新，导致设备无法进行正常的网络通信，从而引发网络瘫痪。

## 物理层

### qdisc（排队规则）

- [[译]《Linux 高级路由与流量控制手册（2012）》第九章：用 tc qdisc 管理 Linux 网络带宽](http://arthurchiao.art/blog/lartc-qdisc-zh/)

```sh
# 查看所有网卡的qdisc
tc qdisc

# 查看指定网卡的qdisc
tc qdisc show dev eth0

# -s 详细信息
tc -s qdisc show dev eth0
```

```sh
# 查看队列长度，满了会丢包
ifconfig | grep txqueuelen

# 查看丢包数
ifconfig | grep dropped

# 增大队列长度
ifconfig eth0 txqueuelen 1500
```

- 设置延迟为600ms
```sh
# 设置延迟为600ms
tc qdisc add dev eth0 root netem delay 600ms

# 查询会发现变成了600ms
dig baidu.com

# 删除刚才设置的规则
sudo tc qdisc del dev eth0 root
```

- ingress（入口流量） 基本是不受本机控制的；egress（出口流量） 是本机可控的

- HTB、TBF 等方案依赖一把设备全局的 Qdisc spinlock 来进行同步

- 排队规则（queueing disciplines）分两类：classless qdisc（无类别）、classful qdisc（有类别）

#### classless qdisc（无类别）

- 1.pfifo_fast（先入先出队列）：有三个“band”（三个FIFO的队列0、1、2）

    - 如果 band 0 有数据，就不会处理 band 1；同理，band 1 有数据时，不会去处理 band 2。

    - 内核会检查数据包的 `TOS` 字段，将“最小延迟”的包放到 band 0。

        ```sh
        # 查看每个包的TOS
        tcpdump -vv

        # 第一列为TOS值，不同的TOS对应不同的内容。例如0x0表示band 1
        TOS     Bits  Means                    Linux Priority    Band
        ------------------------------------------------------------
        0x0     0     Normal Service           0 Best Effort     1
        0x2     1     Minimize Monetary Cost   1 Filler          2
        0x4     2     Maximize Reliability     0 Best Effort     1
        0x6     3     mmc+mr                   0 Best Effort     1
        0x8     4     Maximize Throughput      2 Bulk            2
        0xa     5     mmc+mt                   2 Bulk            2
        0xc     6     mr+mt                    2 Bulk            2
        0xe     7     mmc+mr+mt                2 Bulk            2
        0x10    8     Minimize Delay           6 Interactive     0
        0x12    9     mmc+md                   6 Interactive     0
        0x14    10    mr+md                    6 Interactive     0
        0x16    11    mmc+mr+md                6 Interactive     0
        0x18    12    mt+md                    4 Int. Bulk       1
        0x1a    13    mmc+mt+md                4 Int. Bulk       1
        0x1c    14    mr+mt+md                 4 Int. Bulk       1
        0x1e    15    mmc+mr+mt+md             4 Int. Bulk       1

        # RFC定义了不同协议的TOS值
        Protocol           TOS Value

        TELNET (1)         1000                 (minimize delay)

        FTP
          Control          1000                 (minimize delay)
          Data (2)         0100                 (maximize throughput)

        TFTP               1000                 (minimize delay)

        SMTP (3)
          Command phase    1000                 (minimize delay)
          DATA phase       0100                 (maximize throughput)

        Domain Name Service
          UDP Query        1000                 (minimize delay)
          TCP Query        0000
          Zone Transfer    0100                 (maximize throughput)

        NNTP               0001                 (minimize monetary cost)

        ICMP
          Errors           0000
          Requests         0000 (4)
          Responses        <same as request> (4)

        Any IGP            0010                 (maximize reliability)

        EGP                0000

        SNMP               0010                 (maximize reliability)

        BOOTP              0000
        ```

    ![image](./Pictures/net-kernel/qdisc-pfifo_fast.avif)

- 2.TBF（Token Bucket Filter，令牌桶过滤器）：没有超过预设速率的流量直接透传。可以容忍超过预 设速率的短时抖动
    - bucket：容纳的 token 数量。
    - Tokens：会以特定的速率，填充 bucket 缓冲区。

    - 当一个包到来时，会从 bucket 中拿到一个 token：

        - 1.数据速率 == token 速率：每个包都能找到一个对应的token，然后直接从队列出去，没有延时（delay）。

        - 2.数据速率 < token 速率：正常到来的数据都能及时发送出去，然后删除一个 token。 由于 token 速率大于数据速率，会产生 bucket 积压，极端情况会将 bucket 占满。

            - 如果数据速率突然高于 token 速率，就可以消耗这些积压的 token 。能够容忍短时数据速率抖动（burst）。

        - 3.数据速率 > token 速率：token 很快就会用完，然后 TBF 会关闭（throttle ）一会。这种 情况称为 overlimit（超过限制）。之后的包会丢包。

    ![image](./Pictures/net-kernel/qdisc-TBF.avif)

    ```sh
    # 修改为 tbf 排队规则。burst（累积可用的 token 所支持的最大字节数）
    tc qdisc add dev eth0 root tbf rate 220kbit latency 50ms burst 1540
    ```

- 3.SFQ（Stochastic Fairness Queueing，随机公平排队）：每个 TCP session 或 UDP stream 对应一个 FIFO queue

    - SFQ 会不断变换它使用的哈希算法，避免多个 session 会可能会哈希到同一个 bucket（哈希槽）

    ```sh
    # 修改为 sfq 排队规则。perturb为每个多少秒重置哈希算法
    tc qdisc add dev eth0 root sfq perturb 10
    ```

    ![image](./Pictures/net-kernel/qdisc-SFQ.avif)

- 4.FQ（Fair Queue，公平排队）

#### classful qdisc（有类别）

- 内核需要遍历整棵树。 最终结果是classes dequeue 的速度永远不会超过它们的 parents 允许的速度

    - 每个 handle 由两部分组成，<major>:<minor>

        ```
        # 一个典型的 handle 层级。向 root qdisc 1: 发送一个 dequeue request. 1: 会将这个请求转发给 1:1，后者会进一步向下传递，转发给 10:、11:、12:

                  1:   root qdisc
                  |
                 1:1    child class
               /  |  \
              /   |   \
             /    |    \
             /    |    \
          1:10  1:11  1:12   child classes
           |      |     |
           |     11:    |    leaf class
           |            |
           10:         12:   qdisc
          /   \       /   \
       10:1  10:2   12:1  12:2   leaf classes
       ```

- 1.PRIO qdisc（优先级排队规则）：可以理解为pfifo_fast的升级版。有多个 band，每个 band 都是一个独立的 class

    - enqueue 到 PRIO qdisc 之后，它会根据设置的 filters 选择一个 class ，并将包送到这个 class。默认情况下会创建三个 class。

    - 取出（dequeue）一个包时，会先尝试 :1。只有 lower 没有数据包可取时，才会尝试 higher classes。

        ```
        # 高吞吐流量（Bulk traffic）将送到 30:，交互式流量（interactive traffic）将送到 20: 或 10:
                  1:   root qdisc
                / | \
               /  |  \
              /   |   \
            1:1  1:2  1:3    classes
             |    |    |
            10:  20:  30:    qdiscs    qdiscs
            sfq  tbf  sfq
            band  0    1    2
        ```

    ```sh
    # 修改为 PRIO 排队规则
    tc qdisc add dev eth0 root handle 1: prio # 会立即创建 classes 1:1, 1:2, 1:3

    tc qdisc add dev eth0 parent 1:1 handle 10: sfq
    tc qdisc add dev eth0 parent 1:2 handle 20: tbf rate 20kbit buffer 1600 limit 3000
    tc qdisc add dev eth0 parent 1:3 handle 30: sfq
    ```

    ![image](./Pictures/net-kernel/qdisc-PRIO.avif)

- 2.CBQ（Class Based Queueing，基于类的排队）：

    - 最复杂、最花哨、最少被理解、也可能是最难用对的 qdisc

    - 在发送包之前等待足够长的时间，以将带宽控制到期望的阈值。因此需要计算包之间的等待间隔

    - 设置条件：
        - webserver 限制为5Mbps。
        - SMTP 流量限制到 3Mbps。
        - webserver + SMTP 总共不超过6Mbps。
        - 物理网卡是 100Mbps。
        - 每个 class 之间可以互借带宽。

    ```

               1:           root qdisc
               |
              1:1           child class
             /   \
            /     \
          1:3     1:4       leaf classes
           |       |
          30:     40:       qdiscs
         (sfq)   (sfq)
    ```

    ```sh
    tc qdisc add dev eth0 root handle 1:0 cbq bandwidth 100Mbit avpkt 1000 cell 8

    # 总共不超过6Mbps，优先级为8，
    tc class add dev eth0 parent 1:0 classid 1:1 cbq bandwidth 100Mbit  \
    rate 6Mbit weight 0.6Mbit prio 8 allot 1514 cell 8 maxburst 20      \
    avpkt 1000 bounded

    # 这两个 leaf class 的总带宽不会超过 6Mbps
    tc class add dev eth0 parent 1:1 classid 1:3 cbq bandwidth 100Mbit  \
    rate 5Mbit weight 0.5Mbit prio 5 allot 1514 cell 8 maxburst 20      \
    avpkt 1000

    tc class add dev eth0 parent 1:1 classid 1:4 cbq bandwidth 100Mbit  \
    rate 3Mbit weight 0.3Mbit prio 5 allot 1514 cell 8 maxburst 20      \
    avpkt 1000

    tc qdisc add dev eth0 parent 1:3 handle 30: sfq
    tc qdisc add dev eth0 parent 1:4 handle 40: sfq

    # webserver 限制为5Mbps。 SMTP 流量限制到 3Mbps。
    tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip \
    sport 80 0xffff flowid 1:3

    tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip \
    sport 25 0xffff flowid 1:4
    ```

- 3.HTB（Hierarchical Token Bucket，层级令牌桶）

    - HTB 配置越来越复杂，这些配置还是能比较好地扩展（scales well）。而使用 CBQ 的话，即使在简单场景下配置就很复杂了

    - 功能几乎与 前面的 CBQ 示例配置 一样的 HTB 配置：

        ```sh
        tc qdisc add dev eth0 root handle 1: htb default 30
        tc class add dev eth0 parent 1: classid 1:1 htb rate 6mbit burst 15k

        tc class add dev eth0 parent 1:1 classid 1:10 htb rate 5mbit burst 15k
        tc class add dev eth0 parent 1:1 classid 1:20 htb rate 3mbit ceil 6mbit burst 15k
        tc class add dev eth0 parent 1:1 classid 1:30 htb rate 1kbit ceil 6mbit burst 15k
        # 设置 SFQ

        tc qdisc add dev eth0 parent 1:10 handle 10: sfq perturb 10
        tc qdisc add dev eth0 parent 1:20 handle 20: sfq perturb 10
        tc qdisc add dev eth0 parent 1:30 handle 30: sfq perturb 10
        # 设置 class 的过滤器（filters）

        U32="tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32"
        $U32 match ip dport 80 0xffff flowid 1:10
        $U32 match ip sport 25 0xffff flowid 1:20
        ```

    ![image](./Pictures/net-kernel/qdisc-HTB.avif)

- 4.fq_codel（Fair Queuing Controlled Delay，延迟受控的公平排队）

- 5.MQ （Multi Queue）：拆散全局 spinlock 的软件方案

    - 为网络设备的每一个硬件队列分别创建一个软件 Qdisc，再通过一个 ->attach()操作将它们挂载到各个硬件队列上
    ![image](./Pictures/net-kernel/qdisc-MQ.avif)

    - child Qdisc都有各自的 spinlock，一把锁被「拆」成了多个锁

    - mq Qdisc 本身并不实现任何限速机制，仅仅提供了一个框架，须和其它具有限速功能的 child Qdisc（HTB、SFQ 等）配合使用。

    - Mellanox 网卡推出了一个通过硬件来实现限速的方案，给 HTB Qdisc 添加了「offload 模式」，模拟 mq Qdisc 的 ->attach() 操作
    ![image](./Pictures/net-kernel/qdisc-MQ1.avif)

- 6.ifb：

    - 为每一种流量类型新建一个软件 ifb 设备

    - 在原发送设备的 clsact Qdisc 上对流量进行分类，通过 mirred action 将不同类型的流量转发到对应的 ifb 设备，再由各个 ifb 设备上的 TBF Qdisc 完成限速

    - 相比 mq Qdisc 方案和硬件 offload 方案，可以更灵活地满足业务所需的限速需求。

    - 由于各个 ifb 设备上的限速由 TBF Qdisc 实现，仍然可能会出现多个 CPU 同时竞争同一把 spinlock

- 7.EDT (Earliest Departure Time) ： clsact Qdsic + eBPF filter + mq Qdisc + fq Qdisc

    - 1.数据包出口先经过 eBPF filter（包含着主要的限速逻辑），并贴上timestamp（时间戳）
    - 2.之后被分发到设备的各个硬件队列，且每个硬件队列都有一个自己的 fq Qdisc
    - 3.fq Qdisc 按照时间戳对数据包进行排序，并确保每个数据包最终出队的时间都不早于数据包上的时间戳，从而达到限速的目的

    - 复杂度：O(1)

    ![image](./Pictures/net-kernel/qdisc-EDT.avif)

## 数据包流程

![image](./Pictures/net-kernel/数据包流程.avif)
![image](./Pictures/net-kernel/数据包流程1.avif)

- [美团技术团队：Redis高负载下的中断优化](https://tech.meituan.com/2018/03/16/redis-high-concurrency-optimization.html)

    - 网卡丢包问题。起初线上存在部分Redis节点还在使用千兆网卡的老旧服务器，而缓存服务往往需要承载极高的查询量，并要求毫秒级的响应速度，如此一来千兆网卡很快就出现了瓶颈。经过整治，我们将千兆网卡服务器替换为了万兆网卡服务器，本以为可以高枕无忧，但是没想到，在业务高峰时段，机器也竟然出现了丢包问题，而此时网卡带宽使用还远远没有达到瓶颈。

- 定位网络丢包的原因

    - 从异常指标入手：系统监控的`net.if.in.dropped`指标中，看到有大量数据丢包异常

        - 这个指标的数据源，是读取`/proc/net/dev`中的数据，监控Agent做简单的处理之后上报。

        - 以下为`/proc/net/dev`的一个示例，每一行代表一个网卡设备具体的值。

            ![image](./Pictures/net-kernel/proc_net_dev.avif)

            - `/proc/net/dev`的数据来源，根据源码文件`net/core/net-procfs.c`，可以知道上述指标是通过其中的`dev_seq_show()`函数和`dev_seq_printf_stats()`函数输出的：

                - `rx_dropped`是Linux中的缓冲区空间不足导致的丢包，而`rx_missed_errors`则在注释中写的比较笼统

                    - `rx_dropped`是Linux中的缓冲区空间不足导致的丢包，而`rx_missed_errors`则在注释中写的比较笼统。有资料指出，`rx_missed_errors`是fifo队列（即rx ring buffer）满而丢弃的数量，但这样的话也就和`rx_fifo_errors`等同了。

                        - 不同网卡自己实现不一样，比如Intel的igb网卡`rx_fifo_errors`在missed的基础上，还加上了RQDPC计数，而ixgbe就没这个统计。RQDPC计数是描述符不够的计数，missed是fifo满的计数。所以对于ixgbe来说，`rx_fifo_errors`和`rx_missed_errors`确实是等同的。

                - `ethtool -S eth0`可以查看`rx_dropped`、`rx_missed_errors`、`rx_fifo_errors`等

                    - 但实际测试后，我发现不同网卡型号给出的指标略有不同
                        - Intel ixgbe就能取到
                        - Broadcom bnx2/tg3则只能取到`rx_discards`（对应`rx_fifo_errors`）、`rx_fw_discards`（对应`rx_dropped`）

                    - 这表明，各家网卡厂商设备内部对这些丢包的计数器、指标的定义略有不同，但通过驱动向内核提供的统计数据都封装成了struct rtnl_link_stats64定义的格式。

    - 在对丢包服务器进行检查后，发现rx_missed_errors为0，丢包全部来自rx_dropped。说明丢包发生在Linux内核的缓冲区中。
    - 接下来，我们要继续探索到底是什么缓冲区引起了丢包问题，这就需要完整地了解服务器接收数据包的过程。

- 网卡接收数据包的流程

    ![image](./Pictures/net-kernel/nic.avif)
    ![image](./Pictures/net-kernel/nic1.avif)

    - 1.网卡会通知DMA将数据包信息放到`rx ring buffer`（它是由NIC和驱动程序共享的一片区域），再触发一个硬中断给CPU，CPU触发软中断让`ksoftirqd`去`RingBuffer`收包
    - 2.经过TCP/IP协议逐层处理。——顺着物理层，数据链路层，网络层，传输层
    - 3.应用程序通过read()从socket buffer读取数据。

    - `rx ring buffer`满了会丢包

        ```sh
        # 查看RingBuffer丢包
        ifconfig | grep overruns
        ```

    - 一个网卡可以有多个`rx ring buffer`
        ```sh
        ethtool -g eth0

        # ethtool命令查看第一个rx ring buffer（0_drops表示第一个）
        ethtool -S eth0 | grep rx_queue_0_drops

        # 修改RingBuffer长度为4096
        # 会使网卡先 down 再 up，因此会造成丢包。请谨慎操作。
        ethtool -G eth0 rx 4096 tx 4096
        ```

- 1.NIC与驱动交互：事实上`rx ring buffer`存储的并不是实际的packet数据，而是一个描述符，这个描述符指向了它真正的存储地址，具体流程如下：

    ![image](./Pictures/net-kernel/NIC与驱动交互.avif)

    - 1.驱动在内存中分配一片缓冲区用来接收数据包，叫做`sk_buffer`
    - 2.将上述缓冲区的地址和大小（即接收描述符），加入到`rx ring buffer`
        - 描述符中的缓冲区地址是DMA使用的物理地址
    - 3.驱动通知网卡有一个新的描述符
    - 4.网卡从`rx ring buffer`中取出描述符，从而获知缓冲区的地址和大小
    - 5.网卡收到新的数据包
    - 6.网卡将新数据包通过DMA直接写到`sk_buffer`中

    - 当驱动处理速度跟不上网卡收包速度时，驱动来不及分配缓冲区，NIC接收到的数据包无法及时写到sk_buffer，就会产生堆积，当NIC内部缓冲区写满后，就会丢弃部分数据，引起丢包。
        - 这部分丢包为 `rx_fifo_errors` ，在 `/proc/net/dev` 中体现为fifo字段增长，在ifconfig中体现为`overruns`指标增长。

- 2.通知系统内核处理（驱动与Linux内核交互）

    - 1.这个时候，数据包已经被转移到了 `sk_buffer` 中。

        - 这是驱动程序在内存中分配的一片缓冲区，并且是通过DMA写入的（这种方式不依赖CPU直接将数据写到了内存中）

            - 意味着对内核来说，其实并不知道已经有新数据到了内存中，需要通过中断告诉内核有新数据进来了，并需要进行后续处理。

    - 2.当NIC把数据包通过DMA复制到内核缓冲区`sk_buffer`后，NIC立即发起一个硬件中断。

    - 3.CPU接收后，首先进入上半部分，网卡中断对应的中断处理程序是网卡驱动程序的一部分，之后由它发起软中断，进入下半部分，开始消费`sk_buffer`中的数据，交给内核协议栈处理。

        ![image](./Pictures/net-kernel/驱动与Linux内核交互.avif)

        - 问题：通过中断，能够快速及时地响应网卡数据请求，但如果数据量大，那么会产生大量中断请求，CPU大部分时间都忙于处理中断，效率很低。

            - 解决方法：现在的内核及驱动都采用一种叫NAPI（new API）的方式进行数据处理，其原理可以简单理解为 中断+轮询，在数据量大时，一次中断后通过轮询接收一定数量包再返回，避免产生多次中断。

        - 整个中断过程的源码部分比较复杂，并且不同驱动的厂商及版本也会存在一定的区别。 以下调用关系基于Linux-3.10.108及内核自带驱动drivers/net/ethernet/intel/ixgbe：

            ![image](./Pictures/net-kernel/中断过程的源码.avif)

            - `enqueue_to_backlog`函数中，会对CPU的`softnet_data`实例中的接收队列（`input_pkt_queue`）进行判断，如果队列中的数据长度超过`netdev_max_backlog` ，那么数据包将直接丢弃，这就产生了丢包。

                - `netdev_max_backlog`是由系统参数`net.core.netdev_max_backlog`指定的，默认大小是 1000。

                - 美团丢包疑惑：，我们线上服务器的内核版本及网卡都支持NAPI，而NAPI的处理逻辑是不会走到`enqueue_to_backlog`中的，`enqueue_to_backlog`主要是非NAPI的处理流程中使用的。

                    - 对此，我们觉得可能和当前使用的Docker架构有关，事实上，我们通过net.if.dropped指标获取到的丢包，都发生在Docker虚拟网卡上，而非宿主机物理网卡上，因此很可能是Docker虚拟网桥转发数据包之后，虚拟网卡层面产生的丢包

            - 内核会为每个CPU Core都实例化一个`softnet_data`对象，这个对象中的`input_pkt_queue`用于管理接收的数据包。

                - 假如所有的中断都由一个CPU Core来处理的话，那么所有数据包只能经由这个CPU的`input_pkt_queue`，如果接收的数据包数量非常大，超过中断处理速度，那么`input_pkt_queue`中的数据包就会堆积，直至超过`netdev_max_backlog`，引起丢包。

                    - 这部分丢包可以在`cat /proc/net/softnet_stat`的输出结果中进行确认

                        - 其中每行代表一个CPU

                        | 列数 | 内容                                                                                               |
                        | ---- | -------------------------------------------------------------------------------------------------- |
                        | 1    | 中断处理程序接收的帧数                                                                             |
                        | 2    | 超过 `netdev_max_backlog` 而丢弃的帧数                                                             |
                        | 3    | 在`net_rx_action`函数中处理数据包超过`netdev_budge`指定数量或运行时间超过2个时间片的次数           |
                        | 8    | 没有意义因此全是 0                                                                                 |
                        | 9    | CPU 为了发送包而获取锁的时候有冲突的次数                                                           |
                        | 10   | CPU 被其他 CPU 唤醒来处理 backlog 数据的次数                                                       |
                        | 11   | 触发 flow_limit 限制的次数                                                                         |

                        ```bash
                        cat /proc/net/softnet_stat
                        00000f0f 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        000007f2 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        00000ffb 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        00006d1b 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        0000102f 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        00000777 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        0000be12 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        00006447 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        0000b33e 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        000083b6 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        0000bd5f 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        00008710 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                        ```

        - 在检查线上服务器之后，发现第一行CPU。硬中断的中断号及统计数据可以在`/proc/interrupts`中看到，对于多队列网卡，当系统启动并加载NIC设备驱动程序模块时，每个RXTX队列会被初始化分配一个唯一的中断向量号，它通知中断处理程序该中断来自哪个NIC队列。

            - 在默认情况下，所有队列的硬中断都由CPU 0处理，因此对应的软中断逻辑也会在CPU 0上处理，在服务器 `top` 的输出中，也可以观察到 `%si` 软中断部分，CPU 0的占比比其他core高出一截。

    - 驱动及内核处理过程中的几个重要函数：

        - 1.注册中断号及中断处理程序，根据网卡是否支持MSI/MSIX，结果为：MSIX → ixgbe_msix_clean_rings，MSI → ixgbe_intr，都不支持 → ixgbe_intr
            - `lspci -vvv`命令查看网卡是不是MSI-X中断机制

        - 2.线上的多队列网卡均支持MSIX，中断处理程序入口为ixgbe_msix_clean_rings，里面调用了函数napi_schedule(&q_vector->napi)
        - 3.之后经过一些列调用，直到发起名为NET_RX_SOFTIRQ的软中断。到这里完成了硬中断部分，进入软中断部分，同时也上升到了内核层面
        - 4.NET_RX_SOFTIRQ对应的软中断处理程序接口是net_rx_action()
        - 5.net_rx_action功能就是轮询调用poll方法，这里就是ixgbe_poll。一次轮询的数据包数量不能超过内核参数net.core.netdev_budget指定的数量（默认值300），并且轮询时间不能超过2个时间片。
            - 这个机制保证了单次软中断处理不会耗时太久影响被中断的程序
        - 6.ixgbe_poll之后的一系列调用就不一一详述了，有兴趣的同学可以自行研究，软中断部分有几个地方会有类似if (static_key_false(&rps_needed))这样的判断，会进入前文所述有丢包风险的enqueue_to_backlog函数。 
            - 这里的逻辑为判断是否启用了RPS机制，RPS是早期单队列网卡上将软中断负载均衡到多个CPU Core的技术，它对数据流进行hash并分配到对应的CPU Core上，发挥多核的性能。
                - 不过现在基本都是多队列网卡，不会开启这个机制，因此走不到这里，static_key_false是针对默认为false的static key的优化判断方式。
            - 这段调用的最后，deliver_skb会将接收的数据传入一个IP层的数据结构中，至此完成二层的全部处理。

- 3.TCP/IP协议栈逐层处理，最终交给用户空间读取

    - 数据包进到IP层之后，经过IP层、TCP层处理（校验、解析上层协议，发送给上层协议），放入socket buffer，在应用程序执行read() 系统调用时，就能从socket buffer中将新数据从内核区拷贝到用户区，完成读取。
        - 这里的socket buffer大小即TCP接收窗口，TCP由于具备流量控制功能，能动态调整接收窗口大小，因此数据传输阶段不会出现由于socket buffer接收队列空间不足而丢包的情况（但UDP及TCP握手阶段仍会有）。

- 网卡队列

    - 根据网卡型号确定驱动中定义的网卡队列，可以看到intel万兆X540网卡驱动中定义最大支持的IRQ Vector为0x40(数值:64)。

        - 通过加载网卡驱动，获取网卡型号和网卡硬件的队列数
            - 但是在初始化misx vector的时候，还会结合系统在线CPU的数量，通过Sum = Min(网卡队列，CPU Core) 来激活相应的网卡队列数量，并申请Sum个中断号。
                - 如果CPU数量小于64，会生成CPU数量的队列，也就是每个CPU会产生一个external IRQ。
                - 美团线上的CPU一般是48个逻辑core，就会生成48个中断号，由于我们是两块网卡做了bond，也就会生成96个中断号。

- 验证与复现网络丢包
    - 使用`systemtap`诊断测试环境软中断分布的方法
    - 可以确认网卡的软中断在机器上分布非常不均，而且主要集中在CPU 0上。通过`/proc/interrupts`能确认硬中断集中在CPU 0上，因此软中断也都由CPU 0处理

- 优化策略

    - 前文提到，丢包是因为队列中的数据包超过了`netdev_max_backlog`造成了丢弃，因此首先想到是临时调大`netdev_max_backlog`能否解决燃眉之急，事实证明，对于轻微丢包调大参数可以缓解丢包，但对于大量丢包则几乎不怎么管用，内核处理速度跟不上收包速度的问题还是客观存在

        - 本质还是因为单核处理中断有瓶颈，即使不丢包，服务响应速度也会变慢。因此如果能同时使用多个CPU Core来处理中断，就能显著提高中断处理的效率，并且每个CPU都会实例化一个`softnet_data`对象，队列数也增加了。

    - 1.CPU亲缘性（affinity）：中断亲缘性设置

        - 让指定的中断向量号更倾向于发送给指定的CPU Core来处理，俗称“绑核”。

        - `grep eth /proc/interrupts`的第一列可以获取网卡的中断号，如果是多队列网卡，那么就会有多行输出：

        - 中断的亲缘性设置可以在`cat /proc/irq/${中断号}/smp_affinity` 或 `cat /proc/irq/${中断号}/smp_affinity_list`中确认

        - 那为什么中断号只设置一个CPU Core呢？而不是为每一个中断号设置多个CPU Core平行处理？

            - 经过测试，发现当给中断设置了多个`CPU Core`后，它也仅能由设置的第一个`CPU Core`来处理，其他的`CPU Core`并不会参与中断处理

                - 原因猜想是当CPU可以平行收包时，不同的CPU core收取了同一个queue的数据包，但处理速度不一致，导致提交到IP层后的顺序也不一致，这就会产生乱序的问题，由同一个CPU core来处理可以避免了乱序问题。

        - 但是，当我们配置了多个Core处理中断后，发现Redis的慢查询数量有明显上升，甚至部分业务也受到了影响，慢查询增多直接导致可用性降低，因此方案仍需进一步优化。

    - 2.Redis进程亲缘性设置

        - 问题：

            - 如果某个CPU Core正在处理Redis的调用，执行到一半时产生了中断，那么CPU不得不停止当前的工作转而处理中断请求

                - 中断期间Redis也无法转交给其他core继续运行，必须等处理完中断后才能继续运行。

            - Redis本身定位就是高速缓存，线上的平均端到端响应时间小于1ms，如果频繁被中断，那么响应时间必然受到极大影响。

                - 由最初的CPU 0单核处理中断，改进到多核处理中断，Redis进程被中断影响的几率增大了，因此我们需要对Redis进程也设置CPU亲缘性，使其与处理中断的Core互相错开，避免受到影响。

        ```sh
        # 设置cpu亲缘性
        taskset -cp cpu-list pid
        ```

    - 3.NUMA 架构下的中断优化

        - 经过一番压测，我们发现使用8个core处理中断时，流量直至打满双万兆网卡也不会出现丢包，因此决定将中断的亲缘性设置为物理机上前8个core，Redis进程的亲缘性设置为剩下的所有core。调整后，确实有明显的效果，慢查询数量大幅优化，但对比初始情况，仍然还是高了一些些，还有没有优化空间呢？
            ![image](./Pictures/net-kernel/redis-slowlog优化前后对比.avif)

        - 通过观察，我们发现一个有趣的现象，当只有CPU 0处理中断时，Redis进程更倾向于运行在CPU 0，以及CPU 0同一物理CPU下的其他核上。

            - 于是有了以下推测：我们设置的中断亲缘性，是直接选取了前8个核心，但这8个core却可能是来自两块物理CPU的，在`/proc/cpuinfo`中，通过字段processor和physical id 能确认这一点，那么响应慢是否和物理CPU有关呢？物理CPU又和NUMA架构关联，每个物理CPU对应一个NUMA node，那么接下来就要从NUMA角度进行分析。

            - 当两个NUMA节点处理中断时，CPU实例化的`softnet_data`以及驱动分配的`sk_buffer`都可能是跨Node的，数据接收后对上层应用Redis来说，跨Node访问的几率也大大提高，并且无法充分利用L2、L3 cache，增加了延时。

            - 由于`Linux wake affinity`特性，如果两个进程频繁互动，调度系统会觉得它们很有可能共享同样的数据，把它们放到同一CPU核心或NUMA Node有助于提高缓存和内存的访问性能，所以当一个进程唤醒另一个的时候，被唤醒的进程可能会被放到相同的CPU core或者相同的NUMA节点上。

                - 所有的网络中断都分配给CPU 0去处理，当中断处理完成时，由于`wakeup affinity`特性的作用，所唤醒的用户进程也被安排给CPU 0或其所在的numa节点上其他core。

        - 而当两个NUMA node处理中断时，这种调度特性有可能导致Redis进程在CPU core之间频繁迁移，造成性能损失。
        - 综合上述，将中断都分配在同一NUMA Node中，中断处理函数和应用程序充分利用同NUMA下的L2、L3缓存、以及同Node下的内存，结合调度系统的`wake affinity`特性，能够更进一步降低延迟。
            ![image](./Pictures/net-kernel/redis-slowlog优化前后对比1.avif)

# Overlay虚拟化技术

## Vxlan（Virtual Extensible LAN）

- [洋芋编程：为什么需要 VLANX 网络](https://mp.weixin.qq.com/s/NzkmjGrvkRAH_vsQgM1JkQ)

- Vxlan是一种网络虚拟化技术，主要用于解决传统数据中心网络面临的可伸缩性和灵活性的问题。通过在已有网络基础上创建一个逻辑上的 Overlay 覆盖网络，实现了跨物理网络的虚拟局域网（VLAN）扩展。

- 解决了哪些问题？

    - 1.突破 VLAN 数量限制：

        - 问题：传统的 VLAN 使用 12 位的标志符作为虚拟网络的区分标识，最多可以提供 2^12 = 4096 个虚拟网络，这对于大型数据中心和多租户需求来说是远远不够的。
        ![image](./Pictures/net-kernel/vlan_数量.avif)

        - VXLAN 使用 24 位的标志符作为虚拟网络的区分标识，最多可以提供 1600 万+ (2^24 = 16777216) 个虚拟网络，极大地扩展了网络的规模。
        ![image](./Pictures/net-kernel/vxlan_数量.avif)

            - 虽然 VXLAN 可以提供更多的虚拟网络，但是它并不会完全取代 VLAN, 例如在大型数据中心，可能会同时使用这两种网络标准，使用 VXLAN 将租户进行隔离，同时单个租户可以基于其 VXLAN 创建内部的 VLAN。

    - 2.提升网络虚拟化的可扩展性

        - VXLAN 将网络虚拟化推到三层网络，减少了二层网络中的广播风暴问题，提高了网络的可伸缩性，(当然这个功能使用 VLAN 也可以实现)。

    - 3.跨子网通信

        - 问题：传统的 VLAN 基于二层网络通信，虚拟机无法跨越不同的子网通信

        - VXLAN 基于三层网络通信，可以将二层网络的数据封装之后进行传输，实现跨子网的虚拟机通信。
        ![image](./Pictures/net-kernel/vxlan_跨子网通信.avif)

    - 4.减少 MAC 表消耗

        - VXLAN 采用采用隧道传输机制，交换机 (一般位于机架顶部) 无须在 MAC 表中记录虚拟机的信息，这样可以使二层网络保持低资源消耗，避免交换机的 MAC 表溢出。

    - 5.充分利用网络路径

        - STP生成树协议 (Spanning Tree Protocol) 是一种用于防止网络中发生环路的协议，但它的作用是通过选择一条活跃路径，而将其他冗余路径阻塞，从而确保网络拓扑是无环的。

        - 问题：传统的的基于 STP 的 VLAN 部署中可能遇到的一个问题: 如果每个 VLAN 都独立运行 STP，可能导致网络路径的浪费。这是因为 STP 对于整个交换网络来说是全局的，而不是基于单个 VLAN 的。因此，STP 将会为整个交换网络选择一条活跃路径，并将其他冗余路径阻塞，而这种选择是基于整个网络而不是基于单个 VLAN。
        ![image](./Pictures/net-kernel/vlan_STP生成树协议.avif)

        - VXLAN 的数据包是封装到 UDP 通过三层网络传输和转发的，可以有效使用所有的网络路径。
        ![image](./Pictures/net-kernel/vxlan_STP生成树协议.avif)

    - 6.虚拟机迁移

        - 传统的 VLAN 中的虚拟机在迁移之前，需要在目标子网上面重新配置 VLAN，而 VXLAN 允许虚拟网络横跨物理网络的子网，避免虚拟机跨越三层网络，使得虚拟机可以在不同的 IP 子网中移动而不受限制，减少了迁移复杂性。

        - 例如，当虚拟机所在宿主机因为故障或其他原因需要停机维护时，就需要将虚拟机迁移到其他宿主机中，为了保证业务的可持续性服务，迁移过程中虚拟机的 IP 地址不能发生变化，VXLAN 保证只要虚拟机迁移后仍然处于同一个二层网络，就不需要改变 IP 地址。

    - 7.多租户环境增强

        - VXLAN 支持多租户环境，使得不同租户的数据可以在同一物理网络基础上独立传输，并允许 IP 地址空间重叠，避免了流量数据泄露和潜在的安全隐患，此外还可以使用差异化的服务质量 (QoS) 策略和服务级别协议 (SLA) 配置网段。

- Vxlan实现原理
    - 本质上就是参考了 OSI 网络模型的设计中数据封装和转发
    - VxLAN 使用虚拟隧道端点（Virtual Tunnel End Point、VTEP）设备对服务器发出和收到的数据包进行二次封装和拆包，将原本在二层网络传输的 以太帧 封装到网络四层的 UDP 数据包中
        - 同时加入自定义的 VXLAN 协议 Header 首部。这样就可以在已有的网络基础上跨越各类设备通信，包括防火墙和路由器。

- 传输协议

    - VXLAN 使用网络层的 IP 协议 + 传输层的 UDP 协议完成传输
    - 通过定义一个数据封装格式，在原始的二层网络数据包之前加上 VXLAN Header, 然后放入 UDP 和 IP 数据包中，这样就完成了基于三层网络建立的二层网络隧道。

- Vxlan的头部（header）

    - 头部大小：由 8 个字节（64位）组成：包括标志位、VNI 标志符和其他控制信息，这种紧凑的头部设计有助于降低额外的网络开销。

    ![image](./Pictures/net-kernel/vxlan_header.avif)

    - 标志位 (Flags): 8 比特，用于标识 VXLAN 头部的特性，目前只使用了最低位（bit 0），该位为 "I" 比特，表示 VXLAN 包是否包含附加的 VXLAN 标头
    - 保留位 (Reserved): 24 比特，保留用于将来扩展协议时使用
    - VXLAN 网络标识符 (VNI - VXLAN Network Identifier): 24 比特，用于标识 VXLAN 网络的唯一标识符，每个 VXLAN 网络都应该有一个唯一的 VNI (也就是用一个数字标识一个虚拟网络)
    - 原始以太网帧 (Original L2 Frame): 用于携带实际的网络数据包，也就是封装在 VXLAN 头部中的原始以太网帧

- VXLAN 头部设置完成之后，会被层层封装: UDP -> IP -> MAC，最终形成的数据包会通过三层网络发出。

    - Outer UDP Header: 封装 原始二层以太帧 + VXLAN Header, 源 VLANX 端口号通常是动态随机分配的，目的 VXLAN 端口号通常固定为 4789
    - Outer IP Header: 封装 IP Header, 由 VTEP 设备完成，也就是 源 IP 地址 (VTEP 的 IP 地址) 和 目的 IP 地址 (对端 VTEP 的 IP 地址)
    - Outer MAC Header: 封装 MAC Header, 由 VTEP 设备完成，也就是 源 MAC 地址 (VTEP 的 MAC 地址) 和 目的 MAC 地址 (下一跳的网络(路由)设备 MAC 地址)

    - Vxlan的包大小

        | 步骤 | 操作/封包    | 协议     | 长度                                                | MTU                                                  |
        |------|--------------|----------|-----------------------------------------------------|------------------------------------------------------|
        | 1    | ping -s 1422 | ICMP     | 1430 = 1422 + 8 （ICMP header）                     |                                                      |
        | 2    | L3           | IP       | 1450 = 1430 + 20 （IP header）                      | VxLAN Interface 的 MTU                               |
        | 3    | L2           | Ethernet | 1464 = 1450 + 14 （Ethernet header）                |                                                      |
        | 4    | VxLAN        | UDP      | 1480 = 1464 + 8 （VxLAN header） + 8 （UDP header） |                                                      |
        | 5    | L3           | IP       | 1500 = 1480 + 20 （IP header）                      | 物理网卡的（IP）MTU，它不包括 Ethernet header 的长度 |
        | 6    | L2           | Ethernet | 1514 = 1500 + 14 （Ethernet header）                | 最大可传输帧大小                                     |

        - 因此， 是1514- 1464 = 50

#### VTEP (VXLAN Tunnel Endpoint)

- VTEP 是 VXLAN 的关键组件，负责将 VXLAN 虚拟网络数据包进行封装和解封装
    - VTEP 既可以是网络物理设备 (交换机) 也可以是虚拟设备 (普通服务器通过软件实现的，例如 KVM)。

- 每个 VTEP 设备都会被分配一个独立的 IP 地址和一个 VNI 标志，用于标识该设备在物理网络中的位置，这个 IP 地址通常是在 VTEP 设备的物理接口或逻辑接口上配置的。
    - 该 IP 地址在 VXLAN 报文头部中被使用，便于在数据包封装和解封的过程中识别出 源 VTEP 和目标 VTEP。两个 VTEP 设备之间会创建无状态隧道用于传输数据。
    - VXLAN 独立于底层的物理网络拓扑；反过来，两个 VTEP 之间的底层 IP 网络也独立于 VXLAN。

- 由于 VXLAN 封装在 UDP 数据包内，因此它们可以在任何能够传输 UDP 数据包的网络上运行，只需要保证 UDP 数据报可以从封装 VTEP 转发到解封装 VTEP 即可，底层网络节点之间的物理布局和地理距离并不重要。

- 封装和解封装过程
    ![image](./Pictures/net-kernel/vxlan_封装和解封装过程.avif)

    - 发送端封装：当一个主机 (物理主机或虚拟机) 要发送数据包到另一个主机时，VTEP 设备负责将原始的以太网帧封装到 VXLAN 数据报文中，封装的过程包括在原始帧上加上 VXLAN Header
        - 其中包含 VXLAN 网络标识符 (VNI)，以及 源 VTEP 和目标 VTEP 的 IP 地址信息，这样原始帧就变为一个 VXLAN 帧。

    - 接收端解封装：接收端的目标 VTEP 通过解析 VXLAN Header，识别出 VXLAN 网络标识符 (VNI)，并将原始帧从 VXLAN 封装报文中解析出来。

        - 然后目标 VTEP 将原始帧发送到目标主机 (物理主机或虚拟机) ，这个解封装的过程允许跨物理网络的虚拟机进行通信，因为基于三层网络的 VXLAN 提供了一种逻辑隔离和扩展机制。

    - 通过数据包封装和解封装，底层网络所做的转换工作对于通信的双方来说是透明的。

##### 网络拓扑结构

![image](./Pictures/net-kernel/vxlan_网络拓扑结构.avif)

- 如图所示，虚拟机 (VM_A)、虚拟机 (VM_B) 、虚拟机 (VM_C) 同属一个子网: 10.1.1.0/24, 并且同属一个 VNI/5000

- 此时 VM_A 想与 VM_C 进行通信，这中间的通信过程是什么样的呢？下面跟着流程图一起看来下。

- 为了方便展示和联系上下文，下文中的设备名称和地址等直接使用简写，例如
    - VM_A 表示虚拟机 A
    - MAC_B 表示虚拟机 B 的 MAC 地址
    - IP_C 表示虚拟机 C 的 IP 地址
    - VTEP_1 表示编号为 1 的 VTEP 设备

- ARP请求报文转发流程

    ![image](./Pictures/net-kernel/vxlan_ARP请求报文转发流程.avif)

    - 由于是首次进行通信，VM_A 上没有 VM_C 的 MAC 地址，所以会发送 ARP 广播请求 VM_C 的 MAC 地址。

    - 1.VM_A 发送 ARP 广播请求报文

        |               |                   |
        | ------------- | ----------------- |
        | 源 MAC 地址   | MAC_A             |
        | 目的 MAC 地址 | FF:FF:FF:FF:FF:FF |
        | 源 IP 地址    | IP_A              |
        | 目的 IP 地址  | IP_C              |

    - 2.VTEP_1 封装 ARP 请求报文

        - VTEP_1 收到 ARP 请求报文之后，会依次进行如下工作:

            - 根据二层子接口上的配置判断请求报文需要进入 VXLAN 隧道
            - 确定请求报文所属广播域，也就确定了报文所属 VNI
            - 学习 VM_A 的 MAC_A + VNI + Port (二层子接口对应的物理接口) 的映射关系，并记录在 MAC 表中

            - 对请求报文进行封装，封装之后的报文如下

                |               |                                                             |
                | ------------- | ----------------------------------------------------------- |
                | 源 MAC 地址   | VTEP_1 的 MAC 地址                                          |
                | 目的 MAC 地址 | 网络中下一跳设备的 MAC 地址                                 |
                | 源 IP 地址    | VTEP_1 的 IP 地址                                           |
                | 目的 IP 地址  | 对端 VTEP 设备的 IP 地址 (也就是 VTEP_2, VTEP_3 的 IP 地址) |

        - 需要注意的是: 实际场景中，对端 VTEP 设备可能有 N 个，那么就会发出 N 个封装后的报文请求。

    - 3.ARP 请求报文解封装

        - 请求报文到达 VTEP_2, VTEP_3 之后，两者会依次进行如下工作:
            - 对报文进行解封装，得到 VM_A 的原始 ARP 请求报文
            - 学习 VM_A 的 `MAC_A + VNI + 对端 VTEP_1 IP 地址` 的映射关系，并记录在各自的 MAC 表中
            - 根据二层子接口上的配置对报文进行处理，并在各自对应的二层域内进行广播
            - VM_B 和 VM_C 接收到 VM_A 的原始 ARP 请求报文之后，比较目的 IP 地址是否为自己的 IP 地址
            - **VM_B 发现目的 IP 地址不是自己，直接将请求报文丢弃，没有后文了 **...
            - **VM_C 发现目的 IP 地址是自己，学习 VM_A 的 MAC_A + IP 并记录在 ARP 缓存表中，并且对 VM_A 的 ARP 请求做出应答**

    - 从 VM_A 上发出的原始 ARP 请求报文经过层层封装和转发，终于到达了目的地 VM_C，这中间经过了一次广播 (或多播, 取决于具体的配置)，因为 VTEP 设备有自动学习的能力，所以请求沿途经过和到达的 VTEP 设备都将各自需要的映射信息记录在各自的 MAC 表中。

    - 接下来，我们看看 VM_C 是如何应答 VM_A 的 ARP 请求的。

- ARP响应报文转发流程

    ![image](./Pictures/net-kernel/vxlan_ARP响应报文转发流程.avif)

    - 1.VM_C 发出应答报文

        - 因为 VM_C 已经学习了 VM_A 的 MAC + IP 记录，所以 ARP 应答报文为单播。

            |               |       |
            | ------------- | ----- |
            | 源 MAC 地址   | MAC_C |
            | 目的 MAC 地址 | MAC_A |
            | 源 IP 地址    | IP_C  |
            | 目的 IP 地址  | IP_A  |

        - 通过报文我们可以看到，VM_C 的应答报文 和 VM_A 的请求报文正好反过来。

    - 2.VTEP_3 封装 ARP 应答报文

        - VTEP_3 收到 ARP 应答报文之后，会依次进行如下工作:

            - 根据二层子接口上的配置判断请求报文需要进入 VXLAN 隧道，识别报文所属 VNI
            - 学习 VM_C 的 MAC_A + VNI + Port (二层子接口对应的物理接口) 的映射关系，并记录在 MAC 表中
            - 对应答报文进行封装，封装之后的报文如下

                |               |                             |
                | ------------- | --------------------------- |
                | 源 MAC 地址   | VTEP_3 的 MAC 地址          |
                | 目的 MAC 地址 | 网络中下一跳设备的 MAC 地址 |
                | 源 IP 地址    | VTEP_3 的 IP 地址           |
                | 目的 IP 地址  | VTEP_1 的 IP 地址           |

    - 3.ARP 应答报文解封装

        - ARP 应答报文到达 VTEP_1 之后，会依次进行如下工作:

            - 对报文进行解封装，得到 VM_C 的原始 ARP 应答报文
            - 学习 VM_C 的 MAC_C + VNI + 对端 VTEP_3 IP 地址 的映射关系，并记录在 MAC 表中
            - VTEP_1 将应答报文发送给 VM_A
            - VM_A 学习 VM_C 的 MAC_A + IP 并记录在 ARP 缓存表中

    - 到了这里，从 VM_A 发起的 ARP 请求到应答通信过程就结束了，因为 VM_A 和 VM_C 都学习到了对方的 MAC + IP 地址，后续两者之间的通信会直接采用单播。

- 小结：在 VM_A 和 VM_C 的整个通信过程中，只有发出一次广播 (或多播, 取决于具体的配置)，得益于 VTEP 设备的自动学习能力，后续的报文都是通过单播直接发送的。可以想象，如果 VTEP 设备没有自动学习能力的话，在 VTEP 数量很多的情况下，依然会产生 ARP 广播风暴问题。
    - 除了本文提到的广播 (多播) 学习模式外，还可以通过 SDN 模式的分布式控制中心来管理整个 VXLAN 网络

## GRE（Generic Routing Encapsulation）

## MPLS（Multiprotocol Label Switching）

## SD-WAN（Software-Defined Wide Area Network）

# DPDK

- Intel DPDK 全称为 Intel Data Plane Development Kit，直译为“英特尔数据平面开发工具集”，它可以摆脱 UNIX 网络数据包处理机制的局限，实现超高速的网络包处理。

    - Unix 进程在网络数据包过来的时候，要进行一次上下文切换（unix进程切换都要进行一次内存读和写）

        - 当系统网络栈处理完数据把数据交给用户态的进程如 Nginx 去处理还会出现一次上下文切换，还要分别读写一次内存。夭寿啦，一共 1200 个 CPU 周期呀，太浪费了。

        - 用户态协议栈：把这块网卡完全交给一个位于用户态的进程去处理。这个网卡数据包过来的时候也不会引发系统中断了，不会有上下文切换。

    - DPDK 使用自研的数据链路层（MAC地址）和网络层（ip地址）处理功能（协议栈），抛弃操作系统（Linux，BSD 等）提供的网络处理功能（协议栈），直接接管物理网卡，在用户态处理数据包，并且配合大页内存和 NUMA 等技术，大幅提升了网络性能。

    - 有论文做过实测，10G 网卡使用 Linux 网络协议栈只能跑到 2G 多，而 DPDK 分分钟跑满。

- DPDK 是 SDN 更前沿的方向：使用 x86 通用 CPU 实现 10Gbps 甚至 40Gbps 的超高速网关（路由器）。

    - 当下，一台 40G 核心网管路由器动辄数十万，而 40G 网卡也不会超过一万块，而一颗性能足够的 Intel CPU 也只需要几万块，软路由的性价比优势是巨大的。

    - 实际上，阿里云和腾讯云也已经基于 DPDK 研发出了自用的 SDN，已经创造了很大的经济价值。

- [一文看懂DPDK](https://cloud.tencent.com/developer/article/1198333)

    - [查看DPDK的CPU和网卡](https://core.dpdk.org/supported/)

    - DPDK：内核是导致瓶颈的原因所在，要解决问题需要绕过内核。所以主流解决方案都是旁路网卡 IO，绕过内核直接在用户态收发包来解决内核的瓶颈。

        - 根据经验，在 C1（8 核）上跑应用每 1W 包处理需要消耗 1% 软中断 CPU，这意味着单机的上限是 100 万 PPS（Packet Per Second）。

            - 从 TGW（Netfilter 版）的性能 100 万 PPS，AliLVS 优化了也只到 150 万 PPS，并且他们使用的服务器的配置还是比较好的。

        - 要跑满 10GE （万兆）网卡，每个包 64 字节，这就需要 2000 万 PPS（注：以太网万兆网卡速度上限是 1488 万 PPS，因为最小帧大小为 84B

        - 要跑满 100G 是 2 亿 PPS：即每个包的处理耗时不能超过 50 纳秒。

            - 直接感受一下这里的挑战有多大：

                - 一次 Cache Miss，不管是 TLB、数据 Cache、指令 Cache 发生 Miss，回内存读取大约 65 纳秒

                - NUMA 体系下跨 Node 通讯大约 40 纳秒。

                - 传统的收发报文方式都必须采用硬中断来做通讯，每次硬中断大约消耗 100 微秒，这还不算因为终止上下文所带来的 Cache Miss。

                - 数据必须从内核态用户态之间切换拷贝带来大量 CPU 消耗，全局锁竞争。

    - DPDK 旁路原理：

        - 左边传统方式：数据从 网卡 -> 驱动 -> 协议栈 -> Socket 接口 -> 业务

        - 右边是 DPDK 的方式：基于 UIO（Userspace I/O）旁路数据。数据从 网卡 -> DPDK 轮询模式 -> DPDK 基础库 -> 业务

            - 用户态的好处是易用开发和维护，灵活性好。并且 Crash 也不影响内核运行，鲁棒性强。

            - UIO 旁路了内核，主动轮询去掉硬中断，DPDK 从而可以在用户态做收发包处理。带来 Zero Copy、无系统调用的好处，同步处理减少上下文切换带来的 Cache Miss。

        ![image](./Pictures/net-kernel/DPDK.avif)

    - UIO（Userspace I/O）原理：通过 read 感知中断，通过 mmap 实现和网卡的通讯。

        -[UIO: user-space drivers](https://lwn.net/Articles/232575/)

        - 开发用户态驱动的步骤：

            - 1.开发运行在内核的 UIO 模块，因为硬中断只能在内核处理

            - 2.通过 / dev/uioX 读取中断

            - 3.通过 mmap 和外设共享内存

        ![image](./Pictures/net-kernel/DPDK-UIO.avif)

    - PMD：DPDK 的 UIO 驱动屏蔽了硬件发出中断，然后在用户态采用主动轮询的方式，这种模式被称为 PMD（Poll Mode Driver）。

        - [Poll Mode Driver](http://doc.dpdk.org/guides/prog_guide/poll_mode_drv.html)

        - 运行在 PMD 的 Core 会处于用户态 CPU100% 的状态。会带来能耗问题。所以，DPDK 推出 Interrupt DPDK 模式。

            - 没包可处理时进入睡眠，改为中断通知。
            - 并且可以和其他进程共享同个 CPU Core，但是 DPDK 进程会有更高调度优先级。

    - DPDK 的高性能代码实现

        - 1.采用 HugePage（大内存页） 减少 TLB Miss

            - DPDK 采用 HugePage，在 x86-64 下支持 2MB、1GB 的页大小，几何级的降低了页表项的大小，从而减少 TLB-Miss。

                - 例子：2013 年发布的 Intel Haswell i7-4770 是当年的民用旗舰 CPU，其在使用 64 位 Windows 系统时，可以提供 1024 长度的 TLB(6)，如果内存页的大小是 4KB，那么总缓存内存容量为 4MB，如果内存页的大小是 2MB，那么总缓存内存容量为 2GB。显然后者的 TLB miss 概率会低得多。DPDK 支持 1G 的内存分页配置，这种模式下，一次性缓存的内存容量高达 1TB，绝对够用了。

            - 并提供了内存池（Mempool）、MBuf、无锁环（Ring）、Bitmap 等基础库。

            - 根据我们的实践，在数据平面（Data Plane）频繁的内存分配释放，必须使用内存池，不能直接使用 rte_malloc，DPDK 的内存分配实现非常简陋，不如 ptmalloc。

        - 2.SNA（Shared-nothing Architecture）：软件架构去中心化

            - NUMA 体系下不跨 Node 远程使用内存。

        - 3.SIMD（单指令多数据）
            - DPDK 采用批量同时处理多个包，再用向量编程，一个周期内对所有包进行处理。比如，memcpy 就使用 SIMD 来提高速度。

        - 4.不使用慢速 API

            - 慢速 API：比如说 gettimeofday，虽然在 64 位下通过 vDSO 已经不需要陷入内核态，只是一个纯内存访问，每秒也能达到几千万的级别。但是，不要忘记了我们在 10GE 下，每秒的处理能力就要达到几千万。所以即使是 gettimeofday 也属于慢速 API。

            - DPDK 提供 Cycles 接口，例如 rte_get_tsc_cycles 接口，基于 HPET 或 TSC 实现。

# sysctl

- [sysctl-ArchWiki](https://wiki.archlinux.org/index.php/sysctl#Improving_performance)

- [linux sysctl net 字段 文档](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)
- [linux sysctl 每个字段文档](https://sysctl-explorer.net/)
- [linux net.netfilter 文档](https://www.kernel.org/doc/Documentation/networking/nf_conntrack-sysctl.txt)

sysctl 在运行时检查和更改内核参数的工具,在`procfs文件系统`(也就是`/proc`路径)中实现的

- 基本用法：

```sh
# 以下两条命令相同，重启后失效，如需持久化需配置 /etc/sysctl.conf
echo bar > /proc/sys/net/foo
sysctl -w net.foo=bar

# 写入/etc/sysctl.conf的配置，需要以下命令进行加载
sysctl --system

# 查看所有配置
sysctl --all
```

# 网络优化

- [arthurchiao：Linux 网络栈接收数据（RX）：配置调优（2022）](http://arthurchiao.art/blog/linux-net-stack-tuning-rx-zh/)

    - 这里的RX queue应该就是ringbuffer

    - RX/TX queue数量
        ```sh
        # 查看是否支持 RSS/多队列
        ethtool -l eth0

        # 修改rx、tx queue的数量为8
        ethtool -L eth0 rx 8
        ethtool -L eth0 tx 8
        ```

    - RX 队列大小
        ```sh
        # 查看队列大小
        ethtool -g eth0

        # 修改为4096
        ethtool -G eth0 rx 4096
        ```

    - RX 队列权重（weight）。权重越大， 每次网卡 poll() 能处理的包越多。

        - queue 一般是和 CPU 绑定

        ```sh
        # 查看是否支持 flow indirection
        ethtool -x eth0

        RX flow hash indirection table for eth0 with 40 RX ring(s):
            0:      0     1     2     3     4     5     6     7
            8:      8     9    10    11    12    13    14    15
           16:     16    17    18    19    20    21    22    23
           24:     24    25    26    27    28    29    30    31
           32:     32    33    34    35    36    37    38    39
           40:      0     1     2     3     4     5     6     7
           48:      8     9    10    11    12    13    14    15
        ```

            - 第一行的哈希值是 0~7，分别对应 RX queue 0~7；
            - 第六行的哈希值是 40~47，分别对应的也是 RX queue 0~7。

        ```sh
        # 在前两个 RX queue 之间均匀的分发接收到的包
        ethtool -X eth0 equal 2

        # 设置自定义权重：给 rx queue 0 和 1 不同的权重：6 和 2
        ethtool -X eth0 weight 6 2
        ```

    - 一些网卡支持 “ntuple filtering” 特性。可以在硬件过滤包
        ```sh
        # 查看是否开启ntuple
        ethtool -k eth0 | grep -i ntuple

        # 开启ntuple
        ethtool -K eth0 ntuple on

        # 查看当前的 ntuple rules
        ethtool -u eth0

        # 设置规则 80 目的端口，绑定到 CPU 2 处理
        ethtool -U eth0 flow-type tcp4 dst-port 80 action 2
        ```

    - 硬中断合并

        - 优点：防止中断风暴，提升吞吐，降低 CPU 使用量
        - 缺点：延迟变大

        ```sh
        # 查看是否支持
        ethtool -c eth0
        Coalesce parameters for eth0:
        Adaptive RX: on  TX: on        # 自适应中断合并
        ......

        # 开启中断合并
        ethtool -C eth0 adaptive-rx on
        ```

    - cpu轮询收包的相关参数

        ```sh
        # 触发二者中任何一个条件后，都会导致一次轮询结束
        sysctl -a | grep netdev_budget
        net.core.netdev_budget = 300         # 一个 CPU 单次轮询所允许的最大收包数量
        net.core.netdev_budget_usecs = 2000  # 最长允许时间，单位是 us

        # 临时修改值（重启后失效）
        sysctl -w net.core.netdev_budget=3000
        sysctl -w net.core.netdev_budget_usecs = 10000
        ```

    - 开启GRO（generic-receive-offload）
        ```sh
        # 查看是否开启GRO
        ethtool -k eth0 | grep generic-receive-offload

        # 修改 GRO 配置会涉及先 down 再 up 这个网卡
        ethtool -K eth0 gro on
        ```

    - RPS 记录一个全局的 hash table，包含所有 flow 的信息
        ```sh
        # 查看hash table 的大小
        sysctl -a | grep rps_
        net.core.rps_sock_flow_entries = 0 # kernel 5.10 默认值

        # 临时修改
        sysctl -w net.core.rps_sock_flow_entries=32768

        # 设置每个 RX queue 的 flow 数量
        sudo bash -c 'echo 2048 > /sys/class/net/eth0/queues/rx-0/rps_flow_cnt'
        ```

    - 老驱动调优
        ```sh
        # backlog默认值为1000
        sysctl -w net.core.netdev_max_backlog=3000

        # backlog poll loop 可以消耗的整体 budget。默认值64
        sysctl -w net.core.dev_weight=600
        ```

- [Linux 网络调优：内核网络栈参数篇](https://www.starduster.me/2020/03/02/linux-network-tuning-kernel-parameter/#Linux_ingress)

    ```bash
    # 回环接口的缓冲区大小
    net.core.netdev_max_backlog = 16384

    # 连接数上限
    net.core.somaxconn = 8192

    net.core.rmem_default = 1048576
    net.core.rmem_max = 16777216
    net.core.wmem_default = 1048576
    net.core.wmem_max = 16777216
    net.core.optmem_max = 65536
    net.ipv4.tcp_rmem = 4096 1048576 2097152
    net.ipv4.tcp_wmem = 4096 65536 16777216
    net.ipv4.udp_rmem_min = 8192
    net.ipv4.udp_wmem_min = 8192

    # tcp-fast-open是tcp拓展，允许在tcp syn第一次握手期间建立连接,交换数据,减少握手的网络延迟
    net.ipv4.tcp_fastopen = 3

    # 最大传输单元（MTU）越长，性能越好，但可靠性越差。
    net.ipv4.tcp_mtu_probing = 1
    ```

    防止 ddos 攻击:

    ```bash
    # tcp syn等待ack的最大队列长度
    net.ipv4.tcp_max_syn_backlog = 8192

    # TIME_WAIT状态下的最大套接字数
    net.ipv4.tcp_max_tw_buckets = 2000000

    # fin 秒数
    net.ipv4.tcp_fin_timeout = 10

    # 有助于抵御SYN flood攻击
    net.ipv4.tcp_syncookies = 1

    # 启用rp_filter(反向路径过滤)，内核将对所有接口收到的数据包进行源验证，可以防止攻击者使用IP欺骗
    net.ipv4.conf.default.rp_filter = 1
    net.ipv4.conf.all.rp_filter = 1

    # 禁止 icmp 重定向接受
    net.ipv4.conf.all.accept_redirects = 0
    net.ipv4.conf.default.accept_redirects = 0
    net.ipv4.conf.all.secure_redirects = 0
    net.ipv4.conf.default.secure_redirects = 0
    net.ipv6.conf.all.accept_redirects = 0
    net.ipv6.conf.default.accept_redirects = 0

    # 在非路由上禁止 icmp 重定向发送
    net.ipv4.conf.all.send_redirects = 0
    net.ipv4.conf.default.send_redirects = 0

    # 忽略 icmp echo 请求
    net.ipv4.icmp_echo_ignore_all = 1
    net.ipv6.icmp.echo_ignore_all = 1
    ```

    Tcp keepalive

    ```bash
    # 设置为等待一分钟
    net.ipv4.tcp_keepalive_time = 60
    net.ipv4.tcp_keepalive_intvl = 10
    net.ipv4.tcp_keepalive_probes = 6
    ```

    关闭 tcp 慢启动:

    - 因为 http1.1 采用多连接和域名分片,当一些连接闲置时,连接的网速会下降

    - 以及 web 服务器的流量是间歇性

    ```bash
    net.ipv4.tcp_slow_start_after_idle = 0
    ```

## [洋芋编程：想要支持百万长连接，需要调优哪些参数？](https://mp.weixin.qq.com/s/7cdkLa_8OtycU0x10QmL4g)

- 1.文件描述符限制
    - 系统级别限制：操作系统会设置一个全局的文件描述符限制，控制整个系统能同时打开的最大文件数
    - 用户级别限制：每个用户会有一个文件描述符的限制，控制这个用户能够同时打开的最大文件数
    - 进程级别限制：每个进程也会有一个文件描述符的限制，控制单个进程能够同时打开的最大文件数

    - `too many open files`, 产生这个问题的根本原因是: 短时间内打开大量网络 (文件) 连接，超过了操作系统对单个进程允许打开的文件描述符（file descriptor）数量限制。
    ```sh
    # 文件描述符数量，默认输出 1024 或者 65535。表示单个进程同时最多只能维持 1024 个网络 (例如 TCP) 连接。
    ulimit -n
    1024

    # 临时性调整。只在当前会话 (终端) 中有效，退出或重启后失效
    ulimit -HSn 1048576

    # 永久性设置。重启永久生效
    sudo vim /etc/security/limits.conf
    # 调整文件描述符限制
    # 注意: 实际生效时会以两者中的较小值为准 (所以最好的方法就是保持两个值相同)
    * soft nofile 1048576
    * hard nofile 1048576
    root soft nofile 1048576
    root hard nofile 1048576

    # 运行 sysctl -p 命令生效，重启之后仍然有效
    sysctl -p
    ```

    - 单个进程打开的文件描述符数量 不能超过 操作系统所有进程文件描述符数量 `/proc/sys/fs/file-max`, 所以需要修改对应的值:
    ```sh
    sudo vim /etc/sysctl.conf

    # 操作系统所有进程一共可以打开的文件数量
    # 增加/修改以下内容
    # 注意: 该设置只对非 root 用户进行限制, root 不受影响
    fs.file-max = 16777216

    # 进程级别可以打开的文件数量
    # 或者可以设置为一个比 soft nofile 和 hard nofile 略大的值
    fs.nr_open = 16777216


    # 运行 sysctl -p 命令生效，重启之后仍然有效。
    sysctl -p

    # 查看配置
    cat /proc/sys/fs/file-nr
    # 第一个数表示当前系统使用的文件描述符数
    # 第二个数表示分配后已释放的文件描述符数
    # 第三个数等于 file-max
    1344    0       1048576
    ```

- Linux 内核参数调优

    - 打开系统配置文件 `/etc/sysctl.conf`，增加 (或修改) 以下配置数据，参数名称及其作用已经写在了注释中。

    ```sh
    # 设置系统的 TCP TIME_WAIT 数量，如果超过该值
    # 不需要等待 2MSL，直接关闭
    net.ipv4.tcp_max_tw_buckets = 1048576

    # 将处于 TIME_WAIT 状态的套接字重用于新的连接
    # 如果新连接的时间戳 大于 旧连接的最新时间戳
    # 重用该状态下的现有 TIME_WAIT 连接，这两个参数主要针对接收方 (服务端)
    # 对于发送方 (客户端) ，这两个参数没有任何作用
    net.ipv4.tcp_tw_reuse = 1
    # 必须配合使用
    net.ipv4.tcp_timestamps = 1

    # 启用快速回收 TIME_WAIT 资源
    # net.ipv4.tcp_tw_recycle = 1
    # 能够更快地回收 TIME_WAIT 套接字
    # 此选项会导致处于 NAT 网络的客户端超时，建议设置为 0
    # 因为当来自同一公网 IP 地址的不同主机尝试与服务器建立连接时，服务器会因为时间戳的不匹配而拒绝新的连接
    # 这是因为内核会认为这些连接是旧连接的重传
    # 该配置会在 Linux/4.12 被移除
    # 在之后的版本中查看/设置会提示 "cannot stat /proc/sys/net/ipv4/tcp_tw_recycle"
    # net.ipv4.tcp_tw_recycle = 0

    # 缩短 Keepalive 探测失败后，连接失效之前发送的保活探测包数量
    net.ipv4.tcp_keepalive_probes = 3

    # 缩短发送 Keepalive 探测包的间隔时间
    net.ipv4.tcp_keepalive_intvl = 15

    # 缩短最后一次数据包到 Keepalive 探测包的间隔时间

    # 减小 TCP 连接保活时间
    # 决定了 TCP 连接在没有数据传输时，多久发送一次保活探测包，以确保连接的另一端仍然存在
    # 默认为 7200 秒
    net.ipv4.tcp_keepalive_time = 600

    # 控制 TCP 的超时重传次数，决定了在 TCP 连接丢失或没有响应的情况下，内核重传数据包的最大次数
    # 如果超过这个次数仍未收到对方的确认包，TCP 连接将被终止
    net.ipv4.tcp_retries2 = 10

    # 缩短处于 TIME_WAIT 状态的超时时间
    # 决定了在发送 FIN（Finish）包之后，TCP 连接保持在 FIN-WAIT-2 状态的时间 (对 FIN-WAIT-1 状态无效)
    # 主要作用是在 TCP 连接关闭时，为了等待对方关闭连接而保留资源的时间
    # 如果超过这个时间仍未收到 FIN 包，连接将被关闭
    # 更快地检测和释放无响应的连接，释放资源
    net.ipv4.tcp_fin_timeout = 15

    # 调整 TCP 接收和发送窗口的大小，以提高吞吐量
    # 三个数值分别是 min，default，max，系统会根据这些设置，自动调整 TCP 接收 / 发送缓冲区的大小
    net.ipv4.tcp_mem = 8388608 12582912 16777216
    net.ipv4.tcp_rmem = 8192 87380 16777216
    net.ipv4.tcp_wmem = 8192 65535 16777216

    # 定义了系统中每一个端口监听队列的最大长度
    net.core.somaxconn = 65535

    # 增加半连接队列容量
    # 除了系统参数外 (net.core.somaxconn, net.ipv4.tcp_max_syn_backlog)
    # 程序设置的 backlog 参数也会影响，以三者中的较小值为准
    net.ipv4.tcp_max_syn_backlog = 65535

    # 全连接队列已满后，如何处理新到连接 ?
    # 如果设置为 0 (默认情况)
    #   客户端发送的 ACK 报文会被直接丢掉，然后服务端重新发送 SYN+ACK (重传) 报文
    #       如果客户端设置的连接超时时间比较短，很容易在这里就超时了，返回 connection timeout 错误，自然也就没有下文了
    #       如果客户端设置的连接超时时间比较长，收到服务端的 SYN+ACK (重传) 报文之后，会认为之前的 ACK 报文丢包了
    #       于是再次发送 ACK 报文，也许可以等到服务端全连接队列有空闲之后，建立连接完成
    #   当服务端重试次数到达上限 (tcp_synack_retries) 之后，发送 RST 报文给客户端
    #       默认情况下，tcp_synack_retries 参数等于 5, 而且采用指数退避算法
    #       也就是说，5 次的重试时间间隔为 1s, 2s, 4s, 8s, 16s, 总共 31s
    #       第 5 次重试发出后还要等 32s 才能知道第 5 次重试也超时了，所以总共需要等待 1s + 2s + 4s+ 8s+ 16s + 32s = 63s
    # 如果设置为 1
    #   服务端直接发送 RST 报文给客户端，返回 connection reset by peer
    #   设置为 1, 可以避免服务端给客户端发送 SYN+ACK
    #   但是会带来另外一个问题: 客户端无法根据 RST 报文判断出，服务端拒绝的具体原因:
    #   因为对应的端口没有应用程序监听，还是全队列满了
    # 除了系统参数外 (net.core.somaxconn)
    # 程序设置的 backlog 参数也会影响，以两者中的较小值为准
    # 所以全连接队列大小 = min(backlog, somaxconn)
    net.ipv4.tcp_abort_on_overflow = 1

    # 增大每个套接字的缓冲区大小
    net.core.optmem_max = 81920
    # 增大套接字接收缓冲区大小
    net.core.rmem_max = 16777216
    # 增大套接字发送缓冲区大小
    net.core.wmem_max = 16777216

    # 增加网络接口队列长度，可以避免在高负载情况下丢包
    # 在每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数量
    net.core.netdev_max_backlog = 65535

    # 增加连接追踪表的大小，可以支持更多的并发连接
    # 注意：如果防火墙没开则会提示 error: "net.netfilter.nf_conntrack_max" is an unknown key，忽略即可
    net.netfilter.nf_conntrack_max = 1048576

    # 缩短连接追踪表中处于 TIME_WAIT 状态连接的超时时间
    net.netfilter.nf_conntrack_tcp_timeout_time_wait = 30
    ```

    ```sh
    # 运行 sysctl -p 命令生效，重启之后仍然有效。
    sysctl -p
    ```

- 客户端参数

    - 当服务器充当 “客户端角色” 时 (例如代理服务器)，连接后端服务器器时，每个连接需要分配一个临时端口号。

    ```sh
    # 查询系统配置的临时端口号范围
    sysctl net.ipv4.ip_local_port_range

    # 增加系统配置的临时端口号范围
    sysctl -w net.ipv4.ip_local_port_range="10000 65535"
    ```

# DDOS攻击

- [洋芋编程：DDoS 究竟在攻击什么?](https://mp.weixin.qq.com/s/UIjXckCpwngrh0I_nWDjOg)

- 分布式拒绝服务（DDoS）攻击是一种常见的网络攻击形式，攻击者通过向目标服务端发送大量的请求，使目标服务端无法进行网络连接，无法正常提供服务。

- 这类攻击类型主要利用网络协议的漏洞或者设计缺陷，消耗目标服务端的资源，其中最著名的莫过于 TCP SYN Flood 攻击，几乎所有大型网站都遭受过这种类型攻击，造成几个小时到几天的服务不可用时间。

## SYN flood (洪泛) 攻击

- `SYN flood` 攻击原理：短时间内伪造大量不同ip地址并向server端发送syn，但不发送最后一次握手的ack；从而让server端一直处于`SYN_RCVD` 状态，占满syn半队列，并不断超时重发syn ack

- 模拟攻击
    ```sh
    # hping3 (Redis 作者开发的另外一个工具) 可以构造 TCP/IP 协议数据包，对系统进行安全审计、防火墙测试、DDoS 攻击测试等。
    # -S 参数表示设置 TCP 协议的 SYN（同步序列号）
    # -p 表示目的端口为 80
    # -i u10表示每隔 10 微秒发送一个网络帧
    # --rand-source 随机化源 IP 地址 (模拟更加真实的攻击)

    # 模拟syn flood攻击
    # 当前主机: 192.168.0.2, 充当 “客户端” 发起 TCP 连接
    hping3 -S -p 80 -i u10 192.168.0.30

    # 在主机 192.168.0.30 抓包
    tcpdump -i eth0 -n tcp port 80
    # Flags [S] 表示这是一个 SYN 包
    # 大量的 SYN 包表明，这是一个 SYN Flood 攻击
    09:15:48.287047 IP 192.168.0.2.27095 > 192.168.0.30: Flags [S], seq 1288268370, win 512, length 0
    09:15:48.287050 IP 192.168.0.2.27131 > 192.168.0.30: Flags [S], seq 2084255254, win 512, length 0
    09:15:48.287052 IP 192.168.0.2.27116 > 192.168.0.30: Flags [S], seq 677393791, win 512, length 0
    09:15:48.287055 IP 192.168.0.2.27141 > 192.168.0.30: Flags [S], seq 1276451587, win 512, length 0
    09:15:48.287068 IP 192.168.0.2.27154 > 192.168.0.30: Flags [S], seq 1851495339, win 512, length 0
    ```

    - 通过抓包输出，可以得出如下结果:

        - 1.客户端 (攻击方) 构造大量的 SYN 包，请求建立 TCP 连接
        - 2.服务端 (被攻击方) 收到 SYN 包后，会向源 IP (客户端) 发送 SYN + ACK 报文，并等待三次握手的最后一次 ACK 报文，直到超时
        - 3.经过一段时间后，服务端的半连接队列会打满，从而无法建立新的 TCP 连接


    - 手动处理包的核心思路: 先找到状态异常的包，然后手动进行限制或设置直接丢包处理。

        ```sh
        # 首先，我们通过 netstat 命令找出状态为 SYN_RECEIVED 的数据包，然后分析其中异常的数据包。
        netstat -n -p | grep SYN_RECV
        # 发现大量 SYN_RECV 状态的连接，并且源 IP 地址为 192.168.0.2
        ...
        tcp 0 0 192.168.0.30:80 192.168.0.2:12503 SYN_RECV -
        tcp 0 0 192.168.0.30:80 192.168.0.2:13502 SYN_RECV -
        tcp 0 0 192.168.0.30:80 192.168.0.2:15256 SYN_RECV -
        tcp 0 0 192.168.0.30:80 192.168.0.2:18117 SYN_RECV -
        ...
        ```

        - 找出异常数据包的源 IP 地址后，要解决 SYN Flood 攻击的问题，只要丢掉相关的包就可以，可以使用 `iptables` 命令来完成。

            ```sh
            iptables -I INPUT -s 192.168.0.2 -p tcp -j REJECT
            ```

        - 当然，攻击者不会一个源 IP 地址进行攻击，所以 SYN Flood 攻击中的源 IP 地址并不是固定的，这时手动限制单个 IP 地址的方式可能就不适合了 (当然，也可以将上述命令操作转为自动化脚本)。除此之外，还可以通过限制 SYN 包的速率来实现。

            ```sh
            # 限制 SYN 并发数为每秒 1 次
            iptables -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT

            # 限制单个 IP 在 60 秒建立的新连接数为 10
            iptables -I INPUT -p tcp --dport 80 --syn -m recent --name SYN_FLOOD --update --seconds 60 --hitcount 10 -j REJECT
            ```

        - 上述方法虽然可以限制单个攻击源 IP 地址发起的 SYN Flood 攻击，但是如果攻击者发起的是大规模 (僵尸网络) 的 SYN Flood 攻击，该方法可能就无效了。

        - 因为在遭遇大规模的 SYN Flood 攻击时，服务端管理人员很可能无法 SSH 登录（SSH 也是基于 TCP 的）到服务端，更不可能执行上述的相关命令。

    - 调整参数防范：

        - 1.增大半连接队列的容量
            ```sh
            # 查看半队列
            sysctl net.ipv4.tcp_max_syn_backlog
            net.ipv4.tcp_max_syn_backlog = 512

            # 临时配置，重启后配置会丢失
            # 将半连接队列容量增大到 65535
            sysctl -w net.ipv4.tcp_max_syn_backlog=65535
            ```

        - 2.减少连接 SYN_RECV 状态失败时内核自动重试次数
            ```sh
            # 查看
            sysctl net.ipv4.tcp_synack_retries
            net.ipv4.tcp_synack_retries = 5

            # 临时配置，重启后配置会丢失
            # 将自动重试次数减少到 1:
            sysctl -w net.ipv4.tcp_synack_retries=1
            ```

        - 3.直接拒绝：如果面对海量请求真的处理不过来，直接拒绝就行了
            ```sh
            # 查看
            sysctl net.ipv4.tcp_abort_on_overflow
            net.ipv4.tcp_abort_on_overflow = 0

            # 临时配置，重启后配置会丢失
            # 启动拒绝连接:
            sysctl -w net.ipv4.tcp_abort_on_overflow=1
            ```

        - 4.TCP SYN Cookies

            > 需要注意的是：开启 TCP syncookies 后，内核选项 (半连接容量) net.ipv4.tcp_max_syn_backlog 失效。

            - 在默认的 TCP 三次握手过程中，客户端向服务端发送 SYN 数据包，服务端收到之后应该回复一个 SYN + ACK 数据包，并进入 SYN_RECV 状态等待客户端的 ACK 确认，但是，如果攻击者向服务端发送大量的 SYN 数据包而不回复 ACK 确认，服务端的半连接队列就会被打满，无法接受正常的新连接。

            - TCP SYN Cookies 是一种专门防御 SYN Flood 攻击的方法，SYN Cookies 基于 TCP 连接四元组（包括源地址、源端口、目的地址、目的端口）以及一个加密种子（如系统启动时间），计算出一个哈希值（SHA1），这个哈希值称为 Cookie。

            - Cookie 就被用作序列号，来应答 SYN + ACK 包，并释放连接状态，当客户端发送完三次握手的最后一次 ACK 后，服务端就会再次计算（反向）这个哈希值，确认是上次返回的 SYN + ACK 的应答包，然后才会进入 TCP 的连接状态。

            - 开启 TCP SYN Cookies 之后，就不需要维护半连接状态了，自然也就不存在半连接队列的容量限制问题了。

            ```sh
            # 临时配置，重启后配置会丢失
            # 开启 TCP SYN Cookies
            sysctl -w net.ipv4.tcp_syncookies=1
            net.ipv4.tcp_syncookies = 1
            ```

            - [小林coding：cookies方案为什么不直接取代半连接队列？](https://www.xiaolincoding.com/network/3_tcp/tcp_no_accpet.html#cookies%E6%96%B9%E6%A1%88%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E7%9B%B4%E6%8E%A5%E5%8F%96%E4%BB%A3%E5%8D%8A%E8%BF%9E%E6%8E%A5%E9%98%9F%E5%88%97)

                - 1.cookies通过通信双方的IP地址端口、时间戳、MSS等信息进行实时计算的，保存在TCP报头的seq里，如果传输过程中数据包丢了，也不会重发第二次握手的信息。

                - 2.攻击者构造大量的第三次握手包（ACK包），同时带上各种瞎编的cookies信息，服务端收到ACK包后以为是正经cookies，憨憨地跑去解码（耗CPU），最后发现不是正经数据包后才丢弃。

        - 参数持久化

            ```sh
            vim /etc/sysctl.conf

            # 对应配置修改如下
            net.ipv4.tcp_syncookies = 1
            net.ipv4.tcp_synack_retries = 1
            net.ipv4.tcp_max_syn_backlog = 1024

            # 配置持久化（动态生效）
            sysctl -p
            ```

        - 增大`netdev_max_backlog`
        - 增大`net.core.somaxconn`

## 反射型攻击

- 反射型 DDoS 攻击也称为 (流量) 放大型攻击。

    - 攻击者向服务端发送大量的数据包，占用服务端的带宽和资源，造成目标服务端无法正常提供服务，例如 UDP 洪泛、ICMP 洪泛。

    - UDP 洪泛: 攻击者向目标服务发送大量的 UDP 数据报文试图填充服务端的可用端口，服务端如果没有找到指定端口，会返回 “Destination Unreachable” 应答报文，在海量 UDP 请求下，服务端就会被攻击流量淹没。

    - ICMP 洪泛：攻击者向目标服务端发送大量的 ICMP ECHO, 也就是 ping 请求 数据包，目标服务端会耗费大量的 CPU 资源去处理和响应，从而无法响应正常请求。

- 攻击者也可以利用利用第三方服务或设备，放大攻击流量，典型的如 DNS 攻击。攻击者利用开放的 DNS 服务端向目标系统发送大量的 DNS 查询请求，通过伪造源 IP 地址为被攻击目标，使被攻击目标系统收到大量的 DNS 响应数据包，占用其带宽和服务端资源。

    - 举个小例子来说明这种情况:

        ```
        +------+            +------+              +------+
        |      |            |      |   ---->      |      |
        |   A  |   --->     |   B  |   ---->      |   C  |
        |      |            |      |   ---->      |      |
        +------+            +------+              +------+
        攻击者              开放服务端              被攻击者
        ```

        - 假设 B 服务端作为开放服务端，监听 UDP 端口 5678，当给这个 UDP 端口发送消息后会做具体的应答。

            - 那么攻击者 A 只需要做以下事情:

                - 1.发送数据给 B，并修改数据报文，伪装自己的源 IP 为 C
                - 2.B 接收到 A 的数据后，根据源 IP 将应答发送给 C (因为 A 发过来的报文中，源 IP 是 C)
                - 3.C 收到了来自 B 的 “反射性” 攻击，因为 B 将数据数量包放大了，原本 A 可能只发送了 “hello” 给 B，而 B 却发送了 N N N 个 “hello” 给 C, 如果类似 B 的开放服务端还不止一个，那么理论上，C 受到的攻击可以被无限放大

    - 再举一个 DNS 放大攻击的小例子。

        - 开启 Wireshark 抓包，然后执行下面的命令:
            ```sh
            dig ANY isc.org
            ```

        - 如图所示，发出去的 DNS 请求包数据只有 25 字节.
        ![image](./Pictures/net-kernel/ddos_DNS请求抓包.avif)

        - 但是收到的 DNS 应答包数据居然有 3111 字节，足足放大了 124 倍，如果在请求包中伪造一个想要攻击的服务端 IP 地址，该地址就会莫名收到 DNS 服务端 3111 字节的回复，利用这个放大攻击，只需要控制少量 (僵尸) 主机，就可以把一个大网站拖垮。
        ![image](./Pictures/net-kernel/ddos_DNS应答抓包.avif)

- 反射型攻击还可以对特定应用程序或服务发送攻击，例如 HTTP 洪泛 (发送大量 HTTP 请求)，慢速 HTTP (攻击者向目标服务端发送大量的 HTTP 请求，但是每个请求的发送速度非常缓慢)，薄弱环节攻击 (例如网站的关键字搜索功能，攻击者可以自动化伪造不同关键字，发送大量请求，严重影响网站的响应速度，严重时甚至直接使整个网站宕机)。

- 不论哪种类型的反射型攻击，其攻击方式都具有如下特点：

    - 高流量: 攻击者发送大量的数据 (请求报文) 到目标服务端或网络，使其超出正常处理能力范围
    - 大规模且难以识别: 攻击者操作数百或数千个攻击节点 (也称为 “肉鸡” 或 “僵尸网络”)，形成大规模的攻击，而且攻击节点很难找出共性特征 (攻击流量和正常流量看起来几乎一样)
    - 目的明确且无差别攻击: 攻击的目的通常是使目标服务端或网络不可用，所有会攻击目标服务端所有开放端口
    - 持续性: 攻击行为可以持续数小时甚至数天

- 攻击防范
    > 反射型攻击的单纯从技术上很难实现绝对防范，毕竟像 Github 这种级别的网站面对 DDoS 时也只能 “躺平”，目前主流的解决方法基本都是通过 “加钱” 的方式来解决的，例如堆硬件、搭软件、叠带宽等方面。

    - 流量过滤和清洗: 使用 (云计算厂商提供的) 专业的 DDoS 防护设备或服务，对流量进行实时监测、过滤和清洗、识别并阻止异常流量
    - 入侵检测和防御: 部署入侵检测系统 (IDS) 和入侵防御系统 (IPS)，对网络流量进行实时监控和分析、识别并阻止异常流量
    - 增加带宽和资源: 增加网络带宽和服务端资源，提高系统抵御大流量攻击的能力
    - ISP: 与互联网服务提供商（ISP）合作，共同防范 DDoS 攻击
    - CDN: 尽可能使用 CDN 分发流量，最大限度减少攻击对关键业务/服务的影响
    - 限流: 关键业务/服务中对网络流量进行限制

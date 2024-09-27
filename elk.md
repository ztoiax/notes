# ELK

- Elasticsearch是一个开源的搜索引擎，也是ELK（现称为Elastic Stack）的重要组成部分。它可以与数据可视化工具 Kibana 和日志处理器 Logstash 无缝集成，从而大大增强了其实用性。

# Elasticsearch

- Elasticsearch通过一种被称为“倒排索引”的技术，实现快速的全文搜索功能，这与我们翻阅书籍索引找到内容的方式颇为相似。

- [互联网侦查：漫画趣解：透析Elasticsearch原理](https://mp.weixin.qq.com/s?__biz=MzI2NDY1MTA3OQ==&mid=2247484402&idx=1&sn=4bc2a0b2020e6fbf58316f94de542646&chksm=eaa82bdadddfa2ccb522df2ffbf5a29feea1383be0c689eb0c95c03d0d0d82bbbffb47f2b48b&scene=21#wechat_redirect)

## 安装

- [官网安装教程](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html)

```sh
curl -LO https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.13.4-linux-x86_64.tar.gz
```

## 核心原理

- [铭毅天下Elasticsearch：一幅动图，搞定 Elasticsearch 核心基础原理！](https://mp.weixin.qq.com/s/qBKaad9NV6yD9Nr3IZkvBQ)

- 1.在Elasticsearch中，首先需要导入数据。这个过程通常涉及将数据格式化为 JSON 格式，因为 Elasticsearch 使用 JSON 作为数据交换格式。

    - 在这张图中，你可以看到一个示例数据“The cat in the tree”，这段文本被转换成 JSON 格式并准备导入到 Elasticsearch 中。

    ![image](./Pictures/elk/导入数据.avif)

- 2.数据的分析和索引

    - 导入Elasticsearch后，数据会被分析和索引。

    - 这一步骤是通过Elasticsearch 的分词器完成的，它将文本拆分成更易于搜索的单词或短语，即“tokens”。

    ![image](./Pictures/elk/数据分析和索引.avif)

    - 这些tokens随后被用来创建一个倒排索引，这是一种特殊的数据结构，用于快速全文搜索。

    - 倒排索引将每个唯一的单词映射到包含该单词的所有文档，这在动图中通过连接线和节点表示。

- 3.分布式架构

    - Elasticsearch是一个分布式搜索引擎，这意味着数据可以跨多个服务器（称为节点）存储和检索。

    - 这种架构提高了系统的扩展性和容错能力。在图中，你可以看到数据被存储在不同的服务器上，这有助于分散负载和提高查询效率。

    ![image](./Pictures/elk/分布式架构.avif)

- 4.查询解析和执行

    - 当用户通过一个搜索界面（如图中的笔记本电脑）输入查询时，Elasticsearch会解析这个查询请求。
        ![image](./Pictures/elk/查询解析和执行.avif)
    - 解析过程包括理解查询中的关键词以及可能的查询意图，然后使用这些信息来检索倒排索引。


- 5.得分和排序

    - 一旦Elasticsearch找到了所有相关的文档，它将基于相关性给这些文档打分。
        ![image](./Pictures/elk/得分和排序.avif)

    - 打分机制通常依赖于因素如关键词的出现频率、文档中的位置等。

    - 这些分数用于对结果进行排序，以确保最相关的结果排在最前面。

- 6.返回结果

    - 最后，搜索结果会被返回给用户，通常也是以JSON格式。用户可以看到最相关的文档排在最前面，这使得用户能够快速有效地找到他们需要的信息。

    - 这整个过程不仅高效而且具有很高的可扩展性，使Elasticsearch成为处理大规模数据集的理想选择。

    - 通过这种方式，Elasticsearch支持复杂的全文搜索功能，广泛应用于各种场景中，如日志分析、实时数据监控和复杂搜索需求。

## 使用场景

![image](./Pictures/elk/导入数据.avif)

- 1.全文搜索
    - Elasticsearch 凭借其强大、可扩展和快速的搜索功能，在全文搜索场景中表现出色。
    - 它通常用于支持大型网站和应用程序的搜索功能，允许用户执行复杂的查询并获得近乎实时的响应。

- 2.实时分析
    - Elasticsearch 能够实时执行分析，因此适用于跟踪实时数据（如用户活动、交易或传感器输出）的仪表盘。这种能力使企业能够根据最新信息及时做出决策。

- 3.机器学习
    - 通过在 X-Pack 中添加机器学习功能，Elasticsearch 可以自动检测数据中的异常、模式和趋势。这对于预测分析、个性化和提高运营效率非常有用。

- 4.地理数据应用
    - Elasticsearch 通过地理空间索引和搜索功能支持地理数据。这对于需要管理和可视化地理信息（如地图和基于位置的服务）的应用非常有用，使执行邻近搜索和基于位置的数据可视化成为可能。

- 5.日志和事件数据分析
    - 企业使用 Elasticsearch 聚合、监控和分析各种来源的日志和事件数据。它是 ELK 堆栈（Elasticsearch、Logstash、Kibana）的关键组件，该堆栈常用于管理系统和应用程序日志，以发现问题并监控系统健康状况。

- 6.安全信息和事件管理（SIEM）
    - Elasticsearch 可用作 SIEM 的工具，帮助企业实时分析安全事件。这对于检测、分析和响应安全事件和漏洞至关重要。

    - 上述每个用例都利用了 Elasticsearch 的优势（如可扩展性、速度和灵活性）来处理不同的数据类型和复杂的查询，为数据驱动型应用提供了重要价值。

# 未读

- [鹅厂架构师：高性能分布式搜索引擎Elasticsearch](https://zhuanlan.zhihu.com/p/698817997)

- [程序员半支烟：5000字详说Elasticsearch入门(一)](https://mp.weixin.qq.com/s/bVhZ40ddB_Ke_2kzC6GgdA)

- [Se7en的架构笔记：Elastic Stack 实战教程 1：Elastic Stack 8 快速上手](https://mp.weixin.qq.com/s/MZcO_wUTPWoOgQKIuQXXYA)

- [Se7en的架构笔记：使用 Ansible 部署 Elasticsearch 集群](https://mp.weixin.qq.com/s/nsXGJ6rZNTuunPutKo1nWQ)

- [云原生运维圈：ELK构建MySQL慢日志收集平台详解](https://mp.weixin.qq.com/s/W2l9jminOflJO28EqyNJSA)

- [铭毅天下Elasticsearch：Elasticsearch 电商场景：明明有这个关键词，但是搜不出来，怎么办？](https://mp.weixin.qq.com/s/eTHZZTQWFaxgReNpa2mNaw)

- [铭毅天下Elasticsearch：6 幅图，通透理解 Elasticsearch 的六大顶级核心应用场景](https://mp.weixin.qq.com/s/cZw1ltk2Ar5UPeX1pJfhgA)

- [用ElasticSearch时，必须先搞明白这几个基础](https://mp.weixin.qq.com/s/L8_lXuodCpObokybX6xtlw)

- [knowclub：你真的懂Elasticsearch分布式原理和高级聚合查询吗？](https://mp.weixin.qq.com/s/MfDuIVai3yc9A63f7siiXQ)

- [程序员半支烟：巧记Elasticsearch常用DSL语法](https://mp.weixin.qq.com/s/X2qjkkrN0moUVWlJHSXX8w)

- [程序员半支烟：Elasticsearch与文件描述符的恩恩怨怨](https://mp.weixin.qq.com/s/3_Pti61GppMa9CzUy9CXRg)

- [腾讯技术工程：万字超全 ElasticSearch 监控指南](https://mp.weixin.qq.com/s/mO3TkKw3U9QZe_IoLV_Y_Q)

- [崔亮的博客：ELK Stack生产实践——性能压测工具esrally](https://mp.weixin.qq.com/s/05wgfsXD5KTjwkjiCSjnpw)

- [鹅厂架构师：【万字长文】ES搜索优化实践](https://zhuanlan.zhihu.com/p/720931769)

## FSCrawler

- [铭毅天下Elasticsearch：Elasticsearch FSCrawler 文档爬虫学习，请先看这一篇！](https://mp.weixin.qq.com/s/5_bvwUQdqUOQj76CNu4ZAQ)

    - FSCrawler 是一个开源项目，可以帮助我们快速简便地将文件（如 PDFs、Office 文档等）索引到 Elasticsearch 中。

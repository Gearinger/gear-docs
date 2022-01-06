# GIS与大数据

> 采用大数据的处理方式势必会引入大量技术栈，存在技术风险，需谨慎。

GeoTools（基础GIS操作） + GeoSpark（分布式GIS数据处理） + HBase（分布式数据库）



## GeoSpark（sedona）

https://github.com/apache/incubator-sedona

[（八）Windows下配置Geospark - 简书 (jianshu.com)](https://www.jianshu.com/p/1a531de087df)

[GeoSpark入门-可视化 - 简书 (jianshu.com)](https://www.jianshu.com/p/8e1fbb8c21ee)

> - Spark 本身不带文件存储系统，常使用Hadoop的HDFS（hadoop分布式文件存储系统）。因为二者同为Apache旗下的产品，适配起来比较容易，社区使用多，问题少且容易搜索到解决方案。
>
> - 2020年Apache收购MinIO，当前 MinIO 也正在适配 Spark。
>
>   项目地址：[minio/spark-select]([minio/spark-select: A library for Spark DataFrame using MinIO Select API (github.com)](https://github.com/minio/spark-select))



## GeoTools与HBase

> 未进行实际测试，待验证……

1. 安装 ZoomKeeper集群
2. 安装 Hbase
3. 安装 GeoMesa 组件
4. 项目引入 GeoTools、geomesa-hbase-datastore、hbase 相关依赖

**注意：HBase 依赖于 zookeeper cluster 和 hadoop HDFS。**

> - HBase是一个分布式的、面向列的开源数据库，该技术来源于 Fay Chang 所撰写的Google论文“Bigtable：一个结构化数据的[分布式存储系统](https://baike.baidu.com/item/分布式存储系统/6608875)”。就像Bigtable利用了Google文件系统（File System）所提供的分布式数据存储一样，HBase在Hadoop之上提供了类似于Bigtable的能力。HBase是Apache的Hadoop项目的子项目。HBase不同于一般的关系数据库，它是一个适合于非结构化数据存储的数据库。另一个不同的是HBase基于列的而不是基于行的模式。
>
> - HBase 需要安装 GeoMesa 组件。GeoMesa 是locationtech基金会开源的空间数据引擎组件，能够赋予HBase、Accumulo、Cassandra等NOSQL数据库存储海量空间数据的能力，并且，GeoMesa提供多种基于空间曲线的时空索引，能够提供海量数据下的高效检索能力。


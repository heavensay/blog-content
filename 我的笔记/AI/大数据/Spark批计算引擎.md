---
title: Spark批计算引擎
date: 2026-09-22T13:41:22+08:00
draft: false
description: ""
tags: []
categories: []
---
## 介绍
Apache Spark是一个开源计算框架，专门设计用于大规模数据处理和分析。它提供了一个高效的、基于内存计算的引擎，能够比传统的大数据处理框架更快地处理大数据集。Spark可在 Kubernetes、独立集群或云原生环境中运行。Spark拥有灵活的数据处理能力，并支持多种编程语言如Scala、Java、Python和R。它包含了多种功能，如批处理、实时流处理、机器学习、图形处理和SQL查询处理等，让它成为解决多样化的大数据挑战和建设复杂的数据管道的理想选择。

## 原理
Apache Spark是通过将计算任务分配给一个或多个分布式计算节点的集群来执行分布式处理。它基于一个名为“弹性分布式数据集”（RDD）的概念，允许用户在内存中跨集群节点进行数据的分散和并行操作，从而显著加快处理速度。用户提交的程序被Spark转换为任务执行计划，然后通过Spark核心引擎的调度器分解为一系列细粒度的任务（分布在集群的多个节点上运行）。Spark的优化引擎通过高效的 DAG（有向无环图）计算流程来减少数据传输并提供快速计算能力，同时，Spark支持错误恢复和存储层的抽象，可以与多种存储系统集成，包括Hadoop的HDFS、NoSQL数据库等。通过Spark提供的API和内置库，例如Spark SQL、MLlib（机器学习库）、Spark Streaming和GraphX（图计算库），开发者可以实现复杂的数据分析和处理流程，且可利用内存计算和资源调度优化，达到高效的运行性能。

## 使用场景
许多公司都在使用 Spark 帮助其简化具有挑战性的计算密集型任务，即处理和分析大量实时或归档数据，包括结构化和非结构化数据。Spark 还能让用户无缝整合相关的复杂功能，如机器学习和图算法。 常见应用包括：
- 批处理：ETL、日志分析、数据清洗
- 实时数据处理：Spark Streaming / Structured Streaming
- 机器学习：MLlib 提供分类、回归、聚类、推荐算法
- 交互式数据探索：Spark SQL、Ad-hoc 分析
- 图表分析：GraphX / GraphFrames

## 架构

![|497x387](../../../attach-files/我的笔记/AI/大数据/Spark批计算引擎/image-20260922143407-1.webp)

- Driver：
	- 解析用户的应用程序代码，转化为作业(job)。
	- 创建SparkContext上下文对象，其负责与资源管理器(ClusterManager)通信，进行资源的申请、任务的分配和监控等。
	- 跟踪Executor的执行情况。
	- 可通过UI界面查询运行情况。
- Cluster Manager：
	- Cluster Manager负责管理集群资源的分配。常用的Cluster Manager有Standalone模式、YARN和Mesos。
	- 它负责从集群中的节点上获取计算资源并监控资源使用情况。
- Executors：
	- Executors是实际执行任务的工作进程，运行在集群节点上。
	- 每个Executor负责执行任务并存储数据。
	- 向Driver节点注册并反馈任务执行状态。
- Tasks：
	- 运行在Executor上的最小计算单元。

## 核心组件

- Spark Core： 是一个通用的分布式数据处理引擎。它是基础执行引擎，管理分布式任务调度、安排和基本的 I/O。Spark Core 引入了弹性分布式数据集 (RDD) 的概念，即不可变的对象分布式集合，可通过容错机制并行处理。在其上有 SQL、流处理、机器学习和图计算的库，所有这些库都可以在应用中一起使用。
- Spark SQL：是用于处理结构化数据的 Spark 模块，它引入了 DataFrames，相较于 RDD 提供了更优化、更适合开发者使用的 API，用于结构化数据处理。它支持您使用 SQL 或熟悉的 DataFrame API 在 Spark 程序中查询结构化数据。Spark SQL 支持 HiveQL 语法，并允许访问现有的 Apache Hive 仓库。
- Spark Streaming：支持轻松构建可扩缩、具有容错性的流式解决方案。它将 Spark 的语言集成 API 引入流处理，因此您可以像编写批处理作业一样编写流式作业，无论是使用 DStreams 还是基于 DataFrame 构建的较新 Structured Streaming API 都可以。Spark Streaming 支持 Java、Scala 和 Python，具备开箱即用的有状态“恰好一次”语义。
- MLlib：是 Spark 可扩容的机器学习库，它所提供的工具可以简化实际的机器学习并为其扩容。MLlib 包含许多常见的学习算法，例如分类、回归、推荐和聚类。它还包含工作流和其他实用工具，包括特征转换、机器学习流水线构建、模型评估、分布式线性代数和统计分析。与 Gemini Enterprise Agent Platform 结合使用时，Spark MLlib 工作流可以无缝集成到 MLOps 流水线中，并可利用 Gemini 进行编码和问题排查，增强开发能力。
- GraphX：是用于图和图并行计算的 Spark API。它非常灵活，可以无缝处理图和集合 - 统一提取、转换和加载；进行探索性分析；在一个系统中迭代图计算。

## 运行流程

![|603x351](../../../attach-files/我的笔记/AI/大数据/Spark批计算引擎/image-20260922143906-1.webp)

当执行一个Spark Application时，整个过程如下：
1. Driver初始化：
应用程序的main函数由Driver执行，Driver创建一个SparkContext。
SparkContext负责与集群管理器通信，申请资源并协调任务的分配和监控。
2. 资源申请与Executor启动：
SparkContext向集群管理器注册并申请资源，具体来说，申请运行Executor的计算资源。
集群管理器根据资源情况为Executor分配资源，并启动相应的Executor进程。
启动的Executor会定期向集群管理器汇报自己的运行状态。
3. DAG图构建与任务调度：
SparkContext根据程序中的RDD依赖关系构建一个DAG（有向无环图）图。
DAG图提交给DAGScheduler进行解析，DAGScheduler将图分解成多个Stage。
每个Stage由多个任务组成，这些任务被打包成TaskSet，然后提交给TaskScheduler进行调度。
4. 任务执行与结果返回：
TaskScheduler将任务分发到Executor执行，同时SparkContext将应用程序代码发送给Executor。
任务执行结束后，Executor将计算结果返回给Driver，或将结果写入HDFS、数据库等外部存储。
运行完毕后释放所有资源。

```
┌─────────────────────────────────────────────────────────┐
│  1. 用户提交 Application (Driver 启动)                    │
│  2. Driver 向 Cluster Manager 申请资源                    │
│  3. Cluster Manager 分配 Executor                          │
│  4. Driver 构建 DAG → DAGScheduler 划分 Stage             │
│  5. TaskScheduler 将 Task 分发到 Executor                 │
│  6. Executor 执行 Task，缓存/Shuffle 数据                 │
│  7. Task 完成，结果返回 Driver                            │
│  8. 所有 Task 完成，释放资源，Application 结束             │
└─────────────────────────────────────────────────────────┘
```


## RDD
RDD（Resilient Distributed Dataset），是一个弹性分布式数据集
RDD 是一个可以容错且并行的数据结构(其实可以理解成分布式的集合，操作起来和操作本地集合一样简单)，它可以让用户显式的将中间结果数据集保存在内存中，并且通过控制数据集的分区来达到数据存放处理最优化.


- Resilient（弹性）：分区丢失可基于血缘重建
- Distributed（分布式）：数据分散在集群多节点
- Dataset（数据集）：不可变、可分区的元素集合

- 操作
Transformation（转换，惰性）：map, filter, flatMap, groupByKey, reduceByKey, join, union, distinct
Action（动作，触发执行）：count, collect, take, first, reduce, saveAsTextFile, foreach

- DAG 与血缘：
Spark 将 Transformation 组成 DAG（有向无环图）
通过 Lineage（血缘） 记录 RDD 依赖关系，用于容错恢复
依赖分两类：
	窄依赖：一对一（map、filter），可在同一 Stage 内流水线执行
	宽依赖：多对多（groupByKey、join），触发 Shuffle，划分 Stage 边界

- 惰性求值 + 优化
Transformation 不执行，构建逻辑计划
Action 触发时，Catalyst 优化器 / Tungsten 引擎生成物理计划

**RDD运行步骤**
RDD在Spark中运行大概分为以下三步：
1. 创建RDD对象
2. DAGScheduler模块介入运算，计算RDD之间的[依赖关系](https://zhida.zhihu.com/search?content_id=108383336&content_type=Article&match_order=1&q=%E4%BE%9D%E8%B5%96%E5%85%B3%E7%B3%BB&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3OTAyMzE3NzEsInEiOiLkvp3otZblhbPns7siLCJ6aGlkYV9zb3VyY2UiOiJlbnRpdHkiLCJjb250ZW50X2lkIjoxMDgzODMzMzYsImNvbnRlbnRfdHlwZSI6IkFydGljbGUiLCJtYXRjaF9vcmRlciI6MSwiemRfdG9rZW4iOm51bGx9.JfYVMCKgh7QPCsJ9UiwMvP7tYl3RkLdgF-ww1Vr3bUs&zhida_source=entity)，RDD之间的依赖关系就形成了DAG
3. 每一个Job被分为多个Stage。划分Stage的一个主要依据是当前计算[因子](https://zhida.zhihu.com/search?content_id=108383336&content_type=Article&match_order=1&q=%E5%9B%A0%E5%AD%90&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3OTAyMzE3NzEsInEiOiLlm6DlrZAiLCJ6aGlkYV9zb3VyY2UiOiJlbnRpdHkiLCJjb250ZW50X2lkIjoxMDgzODMzMzYsImNvbnRlbnRfdHlwZSI6IkFydGljbGUiLCJtYXRjaF9vcmRlciI6MSwiemRfdG9rZW4iOm51bGx9.bjzOe0jNB5XgppF2_8PjnqKwyIGTwhwILzYLEn4JhTI&zhida_source=entity)的输入是否是确定的，如果是则将其分在同一个Stage，避免多个Stage之间的消息传递开销

![](../../../attach-files/我的笔记/AI/大数据/Spark批计算引擎/image-20260922150913-1.webp)

## 代码示例

- RDD的创建和操作示例
```scala
import org.apache.spark.{SparkConf, SparkContext}

object WordCount {
  def main(args: Array[String]): Unit = {
    // 1. 创建 SparkContext
    val conf = new SparkConf()
      .setAppName("WordCount")
      .setMaster("local[*]")
    val sc = new SparkContext(conf)

    // 2. 读取数据 → RDD
    val lines = sc.textFile("hdfs:///input/text.txt")

    // 3. Transformation 链 (惰性)
    val counts = lines
      .flatMap(_.split("\\s+"))     // 窄依赖
      .map(word => (word, 1))       // 窄依赖
      .reduceByKey(_ + _)           // 宽依赖 (Shuffle)

    // 4. Action 触发执行
    counts.saveAsTextFile("hdfs:///output/wordcount")

    // 5. 释放资源
    sc.stop()
  }
}
```

- Spark SQL的示例1
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("SQLDemo").getOrCreate()

# 读取数据并注册为临时视图
df = spark.read.parquet("s3://bucket/users/")
df.createOrReplaceTempView("users")

# 直接写 SQL
result = spark.sql("""
    SELECT age, COUNT(*) AS cnt
    FROM users
    WHERE age > 18
    GROUP BY age
    ORDER BY cnt DESC
""")

result.show()
```

- Spark SQL的示例2
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("SparkSQLExample").getOrCreate()

# 读取数据
df = spark.read.json("hdfs://localhost:9000/user/hadoop/data.json")

# 数据处理
df_filtered = df.filter(df["age"] > 30)

# 缓存（可选）
df_filtered.cache()

# Action
df_filtered.show()

spark.stop()
```

>DataFrame API 和 SQL 最终都会走同一个 Catalyst 优化器，性能基本一致，只是写法不同。

- Spark Streaming的示例
```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.streaming.streaming import StreamingQuery

spark = SparkSession.builder.appName("SparkStreamingExample").getOrCreate()

# 创建数据流
df = spark.readStream.format("kafka").option("kafka.bootstrap.servers", "localhost:9000").option("subscribe", "events").load()

# 数据处理
df_filtered = df.filter(df["value"].cast("int") > 30)

# 行动操作
query = df_filtered.writeStream.outputMode("append").format("console").start()
query.awaitTermination()
```

>Spark 默认是微批，不是逐条。逐条只是"批极小"的极限情况，但仍有调度开销。攒一个 batchInterval 的数据一起算


- MLlib的示例
```python
from pyspark.ml.classification import LogisticRegression
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.evaluation import BinaryClassificationEvaluator

# 数据预处理
data = spark.read.csv("hdfs://localhost:9000/user/hadoop/data.csv", header=True, inferSchema=True)

# 特征提取
assembler = VectorAssembler(inputCols=["feature1", "feature2"], outputCol="features")
data_assembled = assembler.transform(data)

# 模型训练
lr = LogisticRegression(maxIter=10, regParam=0.01)
lrModel = lr.fit(data_assembled)

# 模型评估
predictions = lrModel.transform(data_assembled)
evaluator = BinaryClassificationEvaluator(rawPredictionCol="rawPrediction", labelCol="label", metricName="areaUnderROC")
auc = evaluator.evaluate(predictions)
print(auc)
```

## QA
### Q：为何要选择 Spark 而非仅支持 SQL 的引擎
Apache Spark 是一种快速的通用集群或无服务器计算引擎。借助 Spark，程序员可以使用 Java、Scala、Python、R 和 SQL 快速编写应用，这使得具有统计学经验的开发者、数据科学家和高级商业人士都可以使用它。使用 Spark SQL，用户可以连接到任何数据源，并将其呈现为可供 SQL 客户端使用的表。此外，交互式机器学习算法可以在 Spark 中轻松实现。

使用像 Apache Impala、Apache Hive 或 Apache Drill 这样仅支持 SQL 的引擎，用户只能使用 SQL 或类似 SQL 的语言来查询存储在多个数据库中的数据。这意味着与 Spark 相比，这些框架要小一些。？？？

### Q: Spark Streaming如何处理延迟问题？ 
调整批处理时间。
使用更多的工作节点。
使用Flink或Kafka Streams等流式处理框架。

### Q：Spark流处理缺陷
- 延迟问题：Spark 流处理的底层是微批模型，本质上是把流切成小批次，再复用批处理引擎来跑。这意味着它的延迟下限由批次间隔决定，通常在秒级，很难做到毫秒级响应
- 状态管理：Structured Streaming 的状态（State）存在 Executor 内存中，并定期落盘到 Checkpoint，状态大小会随 key 数量线性增长
- Exactly-Once ：Spark 不会替你兜底业务一致性，需要你手动做幂等写或去重表
- 事件时间与乱序处理能力有限：Flink 原生支持事件时间 + Watermark，能灵活处理乱序数据。Spark 虽然也支持，但基于“全局水位线”的机制在复杂场景下受限，比如不支持多个流聚合的链式操作，因为聚合后很难再维护可靠的全局水位线，这直接限制了复杂实时分析的表达能力
- 真正逐条低延迟的场景，Flink 是压倒性的

## 参考
https://cloud.google.com/learn/what-is-apache-spark?hl=zh-CN 什么是 Apache Spark？
https://juejin.cn/post/7447777849073319990 Spark架构及运行流程
https://juejin.cn/post/7325129783082729499 Spark 的架构与组件
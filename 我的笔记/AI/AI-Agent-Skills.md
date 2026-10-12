---
title: hugo-template
date: 2026-07-12T14:59:54+08:00
draft: false
description: ""
tags: []
categories: []
---

## 介绍

Agent Skills是一种轻量级的开放格式(Anthropic提出的一项开源规范协议)，可通过专业知识和工作流程扩展AI智能体的功能。

**总结**
agent skills是ai prompt的一个抽象层，把专业知识、智能封装到skill(本质就是一个包括结构化文档和脚本的文件夹)，以达到知识、技能复用。规范的特性使agent能渐进加载、使用skill内容，以减少prompt膨胀问题。

**思考**
skill的出现使AI能力资产化，研发团队（写脚本、调 API）与业务架构师（写 SKILL.md 约束）可以并行工作；



## 作用

agent的能力日益增强，但往往缺乏可靠完成实际工作所需的上下文信息。skills通过将流程知识以及公司、团队和用户特定的上下文信息打包到可移植的、版本控制的文件夹中来解决这个问题，agent可以根据需要加载这些文件夹。这为智能体提供了以下优势：
- 领域专业知识：把专业知识转为可重用的指令和资源，如：从法律审查流程到数据分析再到演示文稿格式化 
- 可重复的工作流：将多步骤任务转化为一致且可审计的流程。  
- 跨产品复用：一次构建skills，即可在所有兼容skills的agent中使用。



## skill内容组成

**agent skills具体组成内容**


**skill文件目录结构**
~~~
my-skill/
	├── SKILL.md          # 必须: metadata(skill名称，描述) + instructions(指令，告诉agent任务如何具体执行)
	├── scripts/          # 可选: 脚本 executable code
	├── references/       # 可选: 文档 documentation
	├── assets/           # 可选: 附件，templates, resources
	└── ...               # 其他可选文件和目录
~~~

这样一个目录，打包zip后，就可以加载进agent中，作为skills来使用；一般agent使用"/"或者可视化选择来指定使用某个skill，或者由llm推理自行调用skill；


**skill.md示例**

~~~
---
name: pdf-processing
description: Extract PDF text, fill forms, merge files. Use when handling PDFs.
license: Apache-2.0
metadata:
  author: example-org
  version: "1.0"
---
~~~




## 流程&原理

client要使用skills，有以下步骤
- 发现skill
- 激活skill
- 执行skill


### client使用skill的交互时序

ai agent一般指claude code、cherry stdio等客户端，在下面时序中我们把这个agent分为了llm和client 2部分，这样从时序流程上看的更清晰；
~~~mermaid
sequenceDiagram

participant user
participant client
participant llm
participant skills


Note over client, skills: 【发现skills】
client->>skills:扫描uri或指定目录
skills-->>client:读取所有Skill的元数据

Note over client, skills: 【解析skill.md】
client->>skills: 加载skill.md
skills-->>client: 提取name和description

client->>client: 建立skills目录，里面包括了skill列表

Note over client, llm: 【向llm添加skill】
client->>llm: 可以通过system prompt或者tool description，把skill目录(catalog)注入到llm中 [耗费约 50-100 Tokens/Skill]

Note over user, skills: 【激活skills】
user->>client: 发起一项任务(如查看/usr/111.txt内容)
client->>llm: 发起一项任务(如查看/usr/111.txt内容)
llm->>client:判断此任务跟某个skill相关，发起激活调用
client->>skills: 加载skill内容，包括skill.md中的body(skill具体内容，如流程编程、引用说明等)；
skills-->>client: 返回skill.md body内容
client-->>llm:将body内容动态拼入当前Context头部[耗费 <5000 Tokens]

Note over user, skills: 【执行skills】
llm->>client: LLM在skill.md body指引下思考，发现需要使用/scripts/fileread脚本，发起脚本执行请求
client->>skills: 读取脚本，拉起本地子进程，执行脚本
skills-->>client: 标准输出返回

client-->>llm: 将执行结果作为Tool Response喂回给大模型

llm-->>client:结合脚本结果，输出最终业务解答
client-->>user:交付最终结果
~~~


只有在任务需要时才会加载完整的指令，因此智能体只需占用少量上下文信息即可掌握多种技能。

### skills按层级进行渐进式加载
从上面时序中也可以看除skill的内容加载是渐进的，这样会减少token的使用量，也不会一次性撑满context内容；

| Tier            | What’s loaded               | When       | Token cost                 |
| --------------- | --------------------------- | ---------- | -------------------------- |
| 1. Catalog      | Name + description          | 会话开始       | ~50-100 tokens per skill   |
| 2. Instructions | Full `SKILL.md` body        | skill激活时   | <5000 tokens (recommended) |
| 3. Resources    | Scripts, references, assets | 执行任务要引用的时候 | Varies                     |



### 注意事项
skill避免在一个会话中重复注入
skill要持久，避免在一个会话进行截断或总结时，skill被删除或截断；

这些事项也是client实现skill机制的时候要实现的功能

## 评测

agent skills规范中，还描述了如何进行skill评测，帮助进行skill的完善；
跟软件开发测试流程类似：单元测试编写->测试用例运行->评测结果生成->skill优化；
示例参考：[评测skill](#评测skill)

**评测流程**
~~~
                Benchmark

                   │

        读取 evals.json

                   │

      ┌────────────┴────────────┐
      │                         │
      ▼                         ▼

   Case1                     Case2

      │                         │

 新建 Session             新建 Session

      │                         │

 Prompt                    Prompt

      │                         │

 Skill Discovery        Skill Discovery

      │                         │

 Execute Script         Execute Script

      │                         │

 Assertions             Assertions

      │                         │

 PASS/FAIL              PASS/FAIL

      └────────────┬────────────┘

                   ▼

          汇总 Benchmark Report
~~~




## 示例

从一个例子来说明：创建skill，使用skill，评测skill，优化skill；


### 创建skill

工程：https://github.com/heavensay/ai-learn，ai-agent-skills/file-operator-skill此目录就是一个文件操作的skill；

此skill用于demo，只简单的进行文件读取。比如在ai chat中：查看/work/1.txt内容，就会返回文件内容；

**skill目录结构**
~~~
file-operator-skill/
	├── SKILL.md                    #skill核心文件，描述skill作用，工作流定义
	├── benchmark.md                #skill评测说明，定义评测工作流
	├── scripts/                    
	    ├── FileOperator.java       #文件读取的执行脚本
	├── evals/                      #skill评测所需内容
~~~

按规范SKILL.md是必须的，其他都是可选的；

**SKILL.md**
~~~
---  
name: file-operator  
description: 用于文件操作，文件读取、修改、删除功能；.gitignore文件内容是指明要忽略的文件列表  
---  
  
## 前置条件  
需要java环境：scripts有使用到java进行编译和运行  
  
## 能力  
### 读取文件  
根据scripts/FileOperator，进行文件操作
~~~

**FileOperator.java**
~~~java
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public class FileOperator {
    public static void main(String[] args) {
        String command = args[0];
        String filePath = args[1];

        switch (command){
            case "read":
                readFile(filePath);
                break;
            default:
                System.out.println("不支持的操作");
        }
    }

    public static String readFile(String filePath){
        try {
             String content = Files.readString(Paths.get(filePath));
             System.out.println(content);
             return content;
        } catch (IOException e) {
            System.err.println("读取文件时发生错误: " + e.getMessage());
        }
    }
}
~~~



### 使用skill

- ai agent加载skill
AI agent使用的是QoderWork
agent增加skill
把file-operator-skill打包成zip包，加载到agent中
![](../../attach-files/我的笔记/AI/AI-Agent-Skills/Pasted%20image%2020260714105606.webp)

- 在AI chat中使用skill
可手工指定skill，也可以让AI自动推理使用skill；下图是手工指定。

![](../../attach-files/我的笔记/AI/AI-Agent-Skills/Pasted%20image%2020260714105743.webp)
指定使用的skill后，输入“读取/Users/liyu/Downloads/123.txt内容”，skill就开始工作了


- agent使用skill执行任务步骤
![](../../attach-files/我的笔记/AI/AI-Agent-Skills/Pasted%20image%2020260713180814.webp)
从上述步骤中，我们发现FileOperator.java脚本有错误，agent还会自动修复编译，最终执行完成；


### 评测skill
file-operator skill创建后，我们还可以对他进行评测，以此观察此skill是否如我们预期的工作，通过评估结果以及建议，进行skill优化；

benchmark.md：描述了评测的整体工作流：包括test case，输出产物；
evals里面包含了评测数据集，以及评测需要用到的数据文件；

**file-operator skill目录结构**
~~~
file-operator-skill/
	├── SKILL.md                    #skill核心文件，描述skill作用，工作流定义
	├── benchmark.md                #skill评测说明，定义评测工作流
	├── scripts/                    
	    ├── FileOperator.java       #文件读取的执行脚本
	├── evals/                      #skill评测所需内容
~~~

**benchmark.md核心内容**
~~~
## 执行要求

## 每个 Test Case 需要输出
  
## 汇总Test Case输出

## 最终评测报告输出

## Output Artifacts

~~~


在AI chat中，输入：按照benchmark.md，进行评测
AI agent即可进行评测任务；
输出结果：按照benchmark.md的定义保存在：\[agent 工作目录\]/skills/file-operator/evals/results

**评测AI Chat**
![](../../attach-files/我的笔记/AI/AI-Agent-Skills/Pasted%20image%2020260714110606.webp)

**评测输出结果**
![](../../attach-files/我的笔记/AI/AI-Agent-Skills/Pasted%20image%2020260714113453.webp)

### 优化skill

完成评测后，我们可根据输出的评测报告report.md，进行skill优化；

## 最佳实践

### 实时改进skill
实际执行中，观察agent执行轨迹，进行skill的改进；
也可根据skill评测进行改进；
在一个实际例子中，scripts脚本有一处处理，agent执行的时候，自动发现错误，修复了脚本，并执行成功；

### skill层级管理

按照实际需要skill可按下面进行层级划分：
项目级：项目专业领域
用户级：跟人风格、工作流程
组织级：公司专门使用，安全、审核边界




## QA

### Qskill与mcp关系
MCP 标准化的是"能力（Capability）"；Skill 标准化的是"经验（Experience）"，是工作流。两者不是替代关系，而是上下层关系。

两者是配合使用。skill定义工作流，某个工作流程中涉及工具调用，使用mcp tool能力；

skill中的script可以是代码工具，类似tool，这跟mcp的tool特性类似，是否能取代？
Skill 和 MCP 确实存在能力重叠，但它们的设计目标不同。Skill 的 script 可以完成一部分 Local Tool 的工作，但不应该作为 MCP 的替代品；对于远程 API 调用尤其如此。


| 对比项      | MCP                           | Skill                                                                            |
| -------- | ----------------------------- | -------------------------------------------------------------------------------- |
| 最初目标     | 统一 Tool/Resource 调用           | 复用 Prompt/Workflow                                                               |
| 出现时间     | **2024 年底**（Anthropic 提出 MCP） | **2025 年开始成熟**（Claude Code、GitHub Copilot、VS Code、Microsoft Agent Framework 等推动） |
| 解决的问题    | Agent 如何连接外部世界                | Agent 如何沉淀和复用经验                                                                  |
| 标准化对象    | Capability（能力）                | Workflow（工作流）                                                                    |
| 关注点      | **能做什么**                      | **应该怎么做**                                                                        |
| 生命周期     | 长期运行、可共享                      | 按需加载、任务级                                                                         |
| 是否有状态    | 通常可以（Session、OAuth、缓存等）       | 通常无状态，主要是知识和流程                                                                   |
| 是否适合企业集成 | 非常适合                          | 更适合封装业务流程                                                                        |

**协同工作**
在一个专业级的 AI Agent 中，这两者协同工作的流程是这样的：
1. Skill（大脑）：负责定义“做什么”和“怎么做”。它为任务提供专业的流程和领域知识。
2. AI 大模型（决策中枢）：例如 Claude，它理解 Skill 提供的上下文和流程，进行智能决策和任务调度。
3. MCP（双手）：负责“执行”。它根据 AI 的指令，连接外部系统，提供实用的工具能力。


### 高德Skill和Mcp关系

|维度|MCP|Skills|
|:--|:--|:--|
|本质|连接外部能力的标准接口|封装特定任务的方法手册|
|核心作用|提供“能做什么”的能力|定义“怎么做”的流程|
|AI 使用方式|调用工具，获取结果|读取手册，照着执行|
|适用场景|通用三方平台接入（如高德、Notion）|重复性任务与标准范式（如选址报告、行程规划）|

在实际应用中，两者通常是协作的。一个“差旅助手” Skill 会负责制定差旅政策、审批流程等业务逻辑（“怎么做”），而它内部的具体操作，如查询机票、预订酒店、获取目的地天气等，则会通过调用高德的 MCP 工具来完成（“能做什么”）


## 参考
https://agentskills.io/ 官方规范
https://zhuanlan.zhihu.com/p/2048605309531317851 Agent Skills，一篇就够了
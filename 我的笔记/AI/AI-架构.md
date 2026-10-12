---
title: AI-架构
date: 2026-07-16T13:33:43+08:00
draft: false
description: ""
tags: []
categories: []
---

## ai agent架构介绍

~~~
                 Chat（Web/App）
                        │
                        │ 自然语言请求
                        ▼
              Agent Runtime / AI Gateway
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
   LLM（Responses）    MCP Tools      Skills/Workflow
        │               │                │
        └───────────────┼────────────────┘
                        ▼
                 AI Platform（OpenAI、阿里百炼等）
        ┌───────────────┼────────────────────────────┐
        │               │            │               │
      文本模型       图片模型     视频模型      语音模型...
      
      
      
      
      
                    User
                      │
                      ▼
                  Chat UI
                      │
                      ▼
                Agent Runtime
                      │
         注册当前可用的 Tools
                      │
                      ▼
                     LLM
        （任务理解 + 任务规划 + Tool选择）
                      │
         Tool Call(generate_image)
                      ▼
              Tool Dispatcher
                      │
      ┌───────────────┼────────────────────┐
      ▼               ▼                    ▼
 Image Tool      Video Tool          Git Tool
      │               │                    │
      ▼               ▼                    ▼
 百炼图片API     百炼视频API          MCP Server
~~~

在这个架构中：

- **Chat**：只负责与用户交互，不关心调用了哪些模型。
- **Agent Runtime / AI Gateway**：统一接收用户请求，负责任务规划、模型路由、Tool Calling、MCP、Skill 编排。
- **MCP**：封装外部能力（文件、数据库、Git、图片生成、视频生成等），对 LLM 暴露统一 Tool 接口。
- **Skill**：封装业务流程（例如"生成技术文档 + 图片 + PDF"），由多个 Tool 组成完整工作流。
- **AI Platform**：提供具体模型能力（文本、图片、视频等），可以来自 OpenAI、阿里百炼或其他供应商。

这样，企业后台只需要维护一个统一的 Agent Runtime，而不需要让业务系统直接感知"文本 API""图片 API""视频 API"等底层差异。以后如果替换 AI 平台（例如从阿里百炼切换到 OpenAI），或者新增图片、视频等能力，只需要调整 Runtime 中的路由或新增对应的 MCP Tool，而 Chat 和业务代码几乎无需修改。这也是目前企业级 AI 平台比较主流的演进方向。

设计原则
	LLM 的知识边界是 Tool Schema，而不是 Tool Implementation。

Tool Schema 可以看作 Agent Runtime 对 LLM 提供的一层"能力抽象接口"，而 Tool 的具体实现则是 Runtime 的职责。这与传统软件架构中"接口（Interface）"和"实现（Implementation）"的分离思想是高度一致的。




### 路由规划

注意：
Agent Runtime/Ai Gateway的任务规划、路径规划原理：模型自主决策（ReAct 范式：推流-行动-反馈）与 Gateway 确定性语义前置拦截” 双轨结合的方式来完成路由规划。

路由规划判断流程

1. 前置确定性路由
在请求真正到达高算力的主 LLM 之前，AI Gateway 会首先运行一层极轻量的静态规则/语义向量拦截器：
	- 前置过滤与安全过滤：检查请求是否命中敏感词、缓存。
	- 快捷意图分类（Intent Classifier）：使用超快的小模型（如分类专用的轻量级模型）或者向量匹配（Embedding Retrieval），判断该请求是否是纯文本对话或复杂任务。
	- 如果判定属于复杂任务，则放行至下一步：由 主大模型（Master Agent LLM） 进行动态任务规划。

2. 主模型动态规划
通过大模型本身具备的推理思考链能力，进行任务拆解，按模型输出的任务步骤，按需进行tool路由调用；

3. Agent Runtime的任务执行
当大模型输出 tool_use: generate_image 后。
Agent Runtime 拦截到这个 Tool Call，进行tool调用(通过skill、mcp、api等方式)，调用结果返回给大模型，继续进行下一步规划；


## AI客户端架构


AI客户端架构采用前后端分离与中心化环境 模式。不同端的客户端本质上是轻量级的 UI 外壳，它们共同连接并驱动统一的本地代理引擎（Agent Runtime）和云端大模型。

### AI客户端产品种类划分
市面上AI客户单应用有很多，大致有以下几种

| 类型                               | 代表产品                                          | 目标用户  | 核心能力                       | Runtime特点            |
| -------------------------------- | --------------------------------------------- | ----- | -------------------------- | -------------------- |
| **AI App（Personal Assistant）**   | ChatGPT、Claude Desktop、Gemini App             | 所有人   | 聊天、知识问答、文档、会议、日程、图片、语音     | Conversation Runtime |
| **Code Agent**                   | Claude Code、Codex CLI、OpenAI Codex、Gemini CLI | 开发者   | Git、Shell、IDE、代码修改、部署      | Development Runtime  |
| **Workspace Agent**              | Cursor、Windsurf、GitHub Copilot Agent          | 开发者   | IDE 内 Agent、代码导航、调试、Review | IDE Runtime          |
| **Computer Agent（Computer Use）** | ChatGPT Computer Use、Operator                 | 自动化办公 | 浏览器、鼠标、键盘、RPA、跨应用操作        | Computer Runtime     |


这种划分底层逻辑：按照agent runtime能力划分(conversation runtime,developer runtime,computer user runtime)，不同runtime拥有不同的tool；

而从长期客户端发展来看，其中一个路径：产品会逐渐融合为统一 AI Client(客户端统一) + 多 Runtime的形态：近期openai chat和code产品客户端已经开始了统一；


### 客户端功能架构

![](../../attach-files/我的笔记/AI/AI-架构/Pasted%20image%2020260718110212.webp)


### 底层引擎工程

引擎模块是一个统一的代码工程（Single Codebase），采用同一种编程语言开发，然后通过“跨平台打包、编译”或“进程间通信（IPC）”的方式，分发和嵌入到不同的客户端中。

**单一代码库**
统一由一个工程开发（如 TypeScript/Node.js）；
- 同生态端（如 VS Code）：直接以 npm 模块依赖的方式导入引擎代码 。
- 异生态端（如 JetBrains/Java）：将引擎静态编译为独立的可执行文件（或轻量级 JS 脚本+内置 Node 运行时），作为 “边车进程（Sidecar）” 硬塞进插件包中，运行时通过 IPC 协议进行通信 。


**多端统一引擎的技术架构**
- 前后端分离
整个工具分为“核心引擎“和“表现层客户端” 。核心引擎在本地处理最复杂的智能代理循环（Agentic Loop）、工具调度和上下文压缩；而各端客户端只是一个“UI壳子”或“遥控器”，仅负责界面渲染和用户交互捕捉 。
- 统一的数据中心
虽然外壳不同，但所有端都硬编码访问本地同一个全局配置路径（如 ~/.claude/）以及项目根目录下的配置文件（如 CLAUDE.md），实现设置和规则的物理共享 。
- 本地 IPC 通信
IDE 插件与底层引擎之间利用 WebSocket、锁文件以及 MCP（模型上下文协议）进行高效的跨进程本地通信 。


**多端并存时的进程与冲突机制**
- 独立进程运行：当用户同时打开终端 CLI 和 IDE 插件时，系统后台运行的是多个独立的进程实例 。这确保了每个界面的对话上下文（Context Window）独立、Token 独立，并且支持多任务并发执行 
- 冲突与协作机制：不同进程通过文件锁（Locking Mechanism）防止同时修改代码导致冲突，并通过全局配置共享和后台守护进程（Daemon / Supervisor）来实现多端状态的完美同步 。








## QA

### Q为什么chat ui中为什么会有模型选择，功能选择
Gemini、通义千问（Qianwen）、ChatGPT、Claude 等一线 AI 产品，依然在 UI 界面上保留了“手动切换模型”或“明确选择生成图片/视频/写入代码”的交互设计？
在实际的商业化落地和工程实践中，这主要是由以下五个非技术性或底层工程性的硬约束决定的：

- 经济成本与 Token 浪费的“无底洞”
- 意图的“模糊性”与“人类确认（Human-in-the-Loop）”
- 多模态技术底座的“物理隔离”（非统一模型）
- 目标用户的“心智模型”与“可解释性”
- 商业化（Upselling）与功能导流的刚需

总结
垂直领域agent，业务逻辑是相对闭环和确定的，可考虑使用通用简单的chat ui提供路口，由后端agent runtime进行无感路由实现所有功能；
Gemini/通义千问等平台：是面向亿级大众用户（C端）的超大规模流量平台。面对极度多样化的用户诉求、高昂的算力成本以及商业化变现的压力，采用“UI 显性分离 + 手工模型选择”是当前阶段兼顾体验、成本、商业转化与技术边界的最优解。
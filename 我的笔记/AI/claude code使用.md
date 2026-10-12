---
title: claude code使用
date: 2026-07-18T15:19:15+08:00
draft: false
description: ""
tags: []
categories: []
---

Claude Code 是一个代理编码工具，可以读取你的代码库、编辑文件、运行命令，并与你的开发工具集成。可在终端、IDE、桌面应用和浏览器中使用。

Claude Code 是一个由 AI 驱动的编码助手，可帮助你构建功能、修复错误和自动化开发任务。它理解你的整个代码库，可以跨多个文件和工具工作以完成任务。

Claude Code可以在在多个平台上运行：终端(cli)、IDE 扩展、桌面应用(claude code app)和网络(web)。


> [!note]
> claude code：app端账号限制登录不了，web端的应用也需要使用claude账号，这两端没账号就不能使用；cli可以使用，并且还可以替换不同模型，这就代表可以通过使用一些中间ai聚合服务商来间接使用不同的模型；ide-plugin，web-plugin客户端跟cli使用相同的agent runtime环境，应该也是可以使用；
> chatgpt(包含了codex)：app需要手机号(国外)验证，否则也登录不了，进不去页面；


![](../../attach-files/我的笔记/AI/claude%20code使用/image-20260915221934.webp)

## 常用命令

```shell
###shell命令###
#启动交互模式
claude

#运行一次性任务
claude "task"

#运行一次性查询，然后退出
claude -p "query"

#在当前目录中继续最近的对话
claude -c

#恢复之前的对话
claude -r

#查看所有命令和 skills
出入：/

#mcp服务添加
claude mcp add --transport stdio MCP-server-local -- java -jar /Users/liyu/develop/wp/java-wp/self-projects/ai-learn/ai-mcp/ai-mcp-serverlocal/target/ai-mcp-serverlocal-1.0-SNAPSHOT.jar

# mcp服务添加
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"

###插件###
# 启动时加载，用于开发、测试；正式使用进行install
claude --plugin-dir .claude/plugins/echo-plugin

claude --plugin-dir 或 claude --plugin-url
claude --plugin-dir /Users/liyu/develop/wp/java-wp/self-projects/ai-learn/ai-plugins/echo-plugin

# 在Marketplace找到Plugin后，复制其GitHub地址
git clone https://github.com/author/my-plugin .claude/plugins/my-plugin


###会话相关###
#清除对话历史
/clear

#显示可用命令
/help

#退出 Claude Code
/exit 或 Ctrl+D
```



https://code.claude.com/docs/zh-CN/cli-reference cli命令
https://code.claude.com/docs/zh-CN/interactive-mode 交互模式


配置详情：
- 服务器名称：MCP-server-local
- 传输方式：stdio
- 启动命令：java -jar /Users/liyu/develop/wp/java-wp/self-projects/ai-learn/ai-mcp/ai-mcp-serverlocal/target/ai-mcp-serverlocal-1.0-SNAPSHOT.jar
- 配置文件：/Users/liyu/.claude.json
- 作用范围：项目 /Users/liyu/develop/wp/java-wp/self-projects/claude-demo

## 配置文件和作用域


claude code有哪些配置文件，以及对应的作用域；

### 可用作用域

| 作用域         | 位置                                               | 影响范围                                                        | 与团队共享？     |
| ----------- | ------------------------------------------------ | ----------------------------------------------------------- | ---------- |
| **Managed** | 服务器管理的设置、plist / 注册表或系统级 `managed-settings.json` | 服务器管理交付的所有组织成员；plist、HKLM 注册表和文件交付的机器上的所有用户；HKCU 注册表交付的当前用户 | 是（由 IT 部署） |
| **User**    | `~/.claude/` 目录                                  | 您，跨所有项目                                                     | 否          |
| **Project** | 存储库中的 `.claude/`                                 | 此存储库上的所有协作者                                                 | 是（提交到 git） |
| **Local**   | `.claude/settings.local.json`                    |                                                             |            |

### 作用域优先级
当在多个作用域中出现相同的设置时，Claude Code 按优先级顺序应用它们：
1. **Managed**（最高）- 无法被任何内容覆盖
2. **命令行参数** - 临时会话覆盖
3. **Local** - 覆盖项目和用户设置
4. **Project** - 覆盖用户设置
5. **User**（最低）- 当没有其他内容指定设置时应用


### 功能配置对应的作用域
作用域适用于许多 Claude Code 功能：

| 功能              | User 位置                   | Project 位置                        | Local 位置                      |
| --------------- | ------------------------- | --------------------------------- | ----------------------------- |
| **Settings**    | `~/.claude/settings.json` | `.claude/settings.json`           | `.claude/settings.local.json` |
| **Subagents**   | `~/.claude/agents/`       | `.claude/agents/`                 | 无                             |
| **MCP servers** | `~/.claude.json`          | `.mcp.json`                       | `~/.claude.json`（每个项目）        |
| **Plugins**     | `~/.claude/settings.json` | `.claude/settings.json`           | `.claude/settings.local.json` |
| **CLAUDE.md**   | `~/.claude/CLAUDE.md`     | `CLAUDE.md` 或 `.claude/CLAUDE.md` | `CLAUDE.local.md`             |
| **skills**      | ~/.claude/skills          | .claude/skills/                   | `<plugin>/skills/`            |


**参考**： https://code.claude.com/docs/zh-CN/settings claude code配置


## 插件plugins

plugins是一个自包含的组件目录，用于扩展 Claude Code 的自定义功能。插件组件包括 skills、agents、hooks、MCP servers、LSP servers 和 monitors。它将 MCP (连接外部系统的能力)、Skill (指导 AI 如何思考的规则) 和 Hooks (拦截控制代码)等统一抽象并打包。

插件功能允许开发者通过单个命令安装包含斜杠命令、智能体、MCP服务器和钩子的自定义集合，从而解决代码开发工作流标准化和团队协作效率的核心问题。对于工程领导者、开源维护者和框架作者而言，插件系统提供了强制执行开发规范、打包最佳实践、连接内部工具的标准化方案。



### 插件完整目录结构
```
enterprise-plugin/
├── .claude-plugin/           # 元数据目录（可选）
│   └── plugin.json             # plugin 清单
├── skills/                   # Skills
│   ├── code-reviewer/
│   │   └── SKILL.md
│   └── pdf-processor/
│       ├── SKILL.md
│       └── scripts/
├── commands/                 # Skills 作为平面 .md 文件
│   ├── status.md
│   └── logs.md
├── agents/                   # Subagent 定义
│   ├── security-reviewer.md
│   ├── performance-tester.md
│   └── compliance-checker.md
├── output-styles/            # 输出样式定义
│   └── terse.md
├── themes/                   # 颜色主题定义
│   └── dracula.json
├── monitors/                 # 后台 monitor 配置
│   └── monitors.json
├── hooks/                    # Hook 配置
│   ├── hooks.json           # 主 hook 配置
│   └── security-hooks.json  # 其他 hooks
├── bin/                      # 添加到 PATH 的 plugin 可执行文件
│   └── my-tool               # 在 Bash tool 中可作为裸命令调用
├── settings.json            # plugin 的默认设置
├── .mcp.json                # MCP server 定义
├── .lsp.json                # LSP server 配置
├── scripts/                 # Hook 和实用脚本
│   ├── security-scan.sh
│   ├── format-code.py
│   └── deploy.js
├── LICENSE                  # 许可证文件
└── CHANGELOG.md             # 版本历史
```

### 工作机制

Claude Code Plugin底层核心逻辑是：“声明式配置 + 动态注册 + 命名空间隔离 + 生命周期拦截”。


**工作流程**
~~~
[ 启动 Claude CLI ]
           │
           ▼
1. 【扫描与加载 (Discovery & Registry)】
   ├─ 扫描项目级 (.claude/plugins/)
   ├─ 扫描全局级 (~/.claude/plugins/)
   └─ 扫描外部注册路径 (如绝对路径/配置清单)
           │
           ▼
2. 【能力注册 (Capabilities Registration)】
   ├─ 注册 MCP 工具  ──> 注入为 Claude 可用的 Tools
   ├─ 注册 Skills    ──> 注入为 Slash 指令 (/plugin:skill)
   └─ 挂载 Hooks     ──> 监听系统生命周期节点
           │
           ▼
3. 【运行时协同 (Runtime Execution & Interception)】
   ├─ 用户提交 Prompt ──> 触发 UserPromptSubmit Hook
   ├─ LLM 决策工具    ──> 触发 PreToolUse Hook (安全拦截)
   ├─ 执行 MCP/Skill  ──> 返回结果
   └─ 拿到返回数据    ──> 触发 PostToolUse Hook
~~~

**注意事项**
plugin 根目录中的 CLAUDE.md 文件不会作为项目上下文加载。Plugins 通过 skills、agents 和 hooks 而不是 CLAUDE.md 来贡献上下文。要提供加载到 Claude 上下文中的说明，请将其放在 skill 中。

命名空间：Plugin中的Skills会自动添加命名空间前缀，格式为 /plugin-name:skill-name，避免与其他Plugin冲突。

### 插件操作示例

插件demo工程：https://github.com/heavensay/ai-learn/ai-plugins/echo-plugin；可直接使用此工程来操作验证插件；里面包含了skill、command、agent、hook；hook有加载进去，但是没起作用，没进一步深究；


- **加载插件**
```
# 启动时加载，用于开发、测试；正式使用进行install
claude --plugin-dir .claude/plugins/echo-plugin

```


- **验证插件**

命令：/plugin，查看Installed
![](../../attach-files/我的笔记/AI/claude%20code使用/Pasted%20image%2020260722154318.webp)

- **具体使用**
	- 指定skill调用：命令选中/echo-plugin:echo-msg
	- command调用：输入"/"，选中echo-plugin:nowtime
    - agent调用：prompt提示内容：使用echo-agent子代理，输出问候语 


**agent使用图**
![](../../attach-files/我的笔记/AI/claude%20code使用/Pasted%20image%2020260722144837.webp)


### 参考
https://github.com/KimYx0207/AI-Coding-Guide-Zh/blob/main/docs/claude-code/08-Plugins%E7%94%9F%E6%80%81%E5%AE%8C%E6%95%B4%E6%8C%87%E5%8D%97.md Plugins生态完整指南.md
https://zhuanlan.zhihu.com/p/1960125583188037746 Claude Code插件系统：助力快速构建智能体
https://code.claude.com/docs/zh-CN/plugins-reference 官方Plugins 参考

## 使用示例

使用claude code cli来进行功能演示；


### claude code下载


```
#我的是mac系统，使用brew来安装
brew install --cask claude-code
```


### claude code设置

claude code cli下载好后，我们需要配置api key和大模型接入端点；
另外claude code由于国内不能直接使用，我们可以通过n1n等大模型中间聚合平台来调用；

按如下配置方式选一种来配置：
```
#配置方式1：claude code大模型连接设置(当前会话有效)
export ANTHROPIC_AUTH_TOKEN=sk-xxx
export ANTHROPIC_BASE_URL=https://api.n1n.ai


#配置方式2：claude code大模型连接设置(持久有效)
可在~/.claude/settings.json配置如下：
  "env": {
      "ANTHROPIC_AUTH_TOKEN":"sk-xxx",
      "ANTHROPIC_BASE_URL":"https://api.n1n.ai"
  }
```


配置好后，即可使用claude code；


### 一个简单任务调用

```
1进到工作目录
cd ~/develop/wp/java-wp/self-projects/claude-demo

2启动claude
claude

3开始一个任务;一些敏感操作如文件变更，代码编译等需要用户手工确认(也可设置默认批准)
prompt：创建一个java文件Main，输出hello world

```

**任务执行效果图**
![410](../../attach-files/我的笔记/AI/claude%20code使用/Pasted%20image%2020260719184927.webp)

从上图中可以看出，Main文件已经创建，并且claude code还编译了Main，验证了结果正确性；


### mcp注册和使用

mcp server代码工程参考：[AI-MCP#mcp java sdk示例](AI-MCP.md#mcp java sdk示例)

**1mcp服务注册**

```
claude mcp add --transport stdio MCP-server-local -- java -jar /Users/liyu/develop/wp/java-wp/self-projects/ai-learn/ai-mcp/ai-mcp-serverlocal/target/ai-mcp-serverlocal-1.0-SNAPSHOT.jar
```


也可在配置文件中直接添加
参考：[功能配置对应的作用域](#功能配置对应的作用域)

```
      "mcpServers": {
        "MCP-server-local": {
          "type": "stdio",
          "command": "java",
          "args": [
            "-jar",
            "/Users/liyu/develop/wp/java-wp/self-projects/ai-learn/ai-mcp/ai-mcp-serverlocal/target/ai-mcp-serverlocal-1.0-SNAPSHOT.jar"
          ],
          "env": {}
        }
      },
```


**2注册完成，重启claude code**

可以使用/mcp list来验证mcp server是否连接成功；

**3使用mcp server完成任务**

提示词：使用MCP-server-local来读取/1.txt文件；

claude code就能正常运行并读取文件；



### skill加载和使用


把你的skill文件夹放到~/.claude/skills目录下(其他存放目录参考[配置文件和作用域](#配置文件和作用域))；
重新启动claude cli，就会自动加载此目录下的skills，通过"/"即可看到刚刚加载的skill了；

skill的使用：在cli中输入"/"来指定skill或让大模型自动选择使用；

使用效果
![](../../attach-files/我的笔记/AI/claude%20code使用/Pasted%20image%2020260721111058.webp)



## QA

### Q命令和工具区别

命令（Commands）：在会话内控制 Claude Code 的快速方式，以 / 开头（如 /plan、/model、/memory）。命令只在消息开头被识别，用于切换模型、管理权限、清除上下文、运行工作流等。
工具（Tools）：Claude Code 可以访问的内置功能集合，帮助理解和修改代码库。工具由 Claude 自动调用（如 Bash、Read、Edit、Write），用户通常不需要直接命名它们。


**协作关系**
许多命令（如 /code-review、/batch）实际上是 skills，它们通过现有的 Skill 工具运行，而不是添加新的工具条目。

**扩展方式不同**：
- 添加自定义命令：编写 skills（在cli中通过”/“，可查看）
- 添加自定义工具：连接 MCP server(在cli中通过"/mcp可查看")

简单来说，命令是用户主动触发的操作，而工具是 Claude 在执行任务时自动使用的能力


### Qclaude code plugin插件机制有别的广商支持吗

Claude Code Plugin —— Anthropic 专属的聚合扩展规范，基本是Anthropic的自有产品支持；
Anthropic的mcp开源协议，才是通用的协议规范，各大AI厂商都支持；


## 参考
https://code.claude.com/docs/zh-CN/how-claude-code-works claude code官方平台
https://api.n1n.ai/ 大模型api聚合服务商
https://github.com/KimYx0207/AI-Coding-Guide-Zh/tree/main/docs/claude-code claude code教程

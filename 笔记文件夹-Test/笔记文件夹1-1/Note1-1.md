# 


### 常用命令

1显示完整路由表

netstat -rn

  

-r: 显示路由表 (routing table)。

-n: 不解析域名（显示 IP 地址而非主机名），速度更快，结果更清晰

  

创建路由

route add default gw 网关的ip地址 dev 网卡设备

删除路由

route del -net 规则的目的ip netmask 规则的子网掩码




Note_生产组网设计案例
![[Pasted image 20260318114448.png|467]]
## 

说明

通过一个案例来说明，一家大型公司如何组建一个生产级的网络架构来满足需求。

目标：组网以满足生产所需，使网络架构合理，具有高可用性、易管理性和可扩展性。

  

方案概述

本方案旨在为 AS16 构建一套高可用、易扩展、安全可控的现代化企业网络架构。方案严格遵循经典的三层分层设计原则，通过 OSPF 与 BGP 双协议栈协同、路由反射器优化及自动化路由策略，解决传统网络中存在的配置复杂、故障扩散快、扩展性差等痛点，实现从接入层到边界层的全链路智能化管理。

  

注：这份完整文档，相当于企业级网络工程设计书。

---

## 

组网场景

一家大型公司S，有2个分公司A、B，这2家分公司间拉专线进行内部互通，从网络运营商处获取到了2个公网IP用于上互联网。

分公司A：有服务器机房，研发楼(开发部、测试部)。

  

### 

组网网络信息

列举组网网络信息，网络架构、互联信息等内容；(已经把ip和网段配置标注进去了)

组网网络场景设定

  

互联网

运营商提供公网IP

IP1：30.30.30.10给分公司10-AS10，网关IP:30.30.30.11；

IP2：30.30.30.20给分公司20-AS20，网关IP:30.30.30.21；

  

AS16(分公司A网络)

Area0(核心骨干，内外网入口，运行OSPF和BGP)

对外边界组网BGP(外网出入口，同时运行OSPF为了，Area0的路由器能互通)

R16-1:lo:10.16.1.1/32, 公网wanIP:30.30.30.10, as专线IP端口:10.0.0.0(与AS32互联), ASBR自治系统边界路由器

R16-2:lo:10.16.1.2/32, RR反射器,

R16-3:lo:10.16.1.3/32

连接：R16-1<=10.16.2.0/31=>R16-2<=10.16.2.2/31=>R16-3

  

内部OSPF边界组网(提供内部网络连接，同时运行BGP，为了同步来自BGP组网的外网路由信息，以及把本局域网的路由信息同步到BGP组网中)

R16-0-1:lo:10.16.1.10/32, ABR (OSPF区域边界路由器)

R16-0-2:lo:10.16.1.11/32, ABR (OSPF区域边界路由器)

连接：R16-0-1<=10.16.2.4/31=>R16-0-2

  

连接R16-2<=10.16.2.6/31=>R16-0-1,R16-2<=10.16.2.8/31=>R16-0-2

  

Area1(服务器机房,Totally Stub Area)

OSPF组网

R16-1-1:lo:10.16.4.0/32, (路由器，下面应该再接入三层交换机)

R16-1-2:lo:10.16.4.1/32, 网段分配(业务服务器):10.16.100.0/24, (路由器，下面应该再接入三层交换机)

连接:R16-1-1<=10.16.3.4/31=>R16-1-2

连接Area0(核心骨干)：R16-0-1<=10.16.3.0/31=>R16-1-1,R16-0-1<=10.16.3.2/31=>R16-1-2

  

  

Area2(研发楼,Totally Stub Area)

switch16-agg-1:lo:10.16.4.2/32 用于管理配置, 网段分配(员工):10.16.15.0/24-10.16.50.0/24, 三层交换机

swtich16-2(研发部-二层交换机):

vlan15：10.16.15.0/24 

switch16-3(测试部-二层交换机)

vlan20：10.16.20.0/24

  

连接：switch16-2<=>switch16-agg-1,switch16-3<=>switch1

  

连接Area0(核心骨干)：switch1<=10.16.3.6/31=>R16-0-2

  

  

AS32(分公司B网络)

Area0(核心骨干，内外网入口，运行OSPF和BGP)

边界区域组网BGP(外网出入口，同时运行OSPF为了，Area0的路由器能互通)

R32-1:lo:10.32.1.1/32, wan口公网IP:30.30.30.20 ,as专线IP:10.0.0.1 ASBR自治系统边界路由器

  

as域间专线连接:R16-1<=10.0.0.0/31>R32-1；

AS16连接互联网:R16-1<=30.30.30.10/31>互联网；

AS32连接互联网:R32-1<=30.30.30.20/31>互联网；

  

  

---

## 

采用技术

  

路由技术选型：OSPF (内) + BGP (外)

- 内部路由 (OSPF)：

范围：自治系统内部 (Intra-AS) / 分公司局域网。

作用：实现内部全网高速互通，支持快速收敛与自动负载均衡。

-  跨域路由 (BGP)：

范围：自治系统之间 (Inter-AS) / 分公司 ↔ 总部 ↔ ISP。

作用：承载跨域路由交换，实施精细化的流量工程与策略控制。

优势：天然隔离故障域，避免内部波动影响外部，保障骨干网高可用。

  

---

## 

组网分层设计

进行组网分层设计时，需结合公司楼层结构、组织结构、客户分布等因素考虑。

采用经典的 “核心 - 汇聚 - 接入”三层模型 与 “双AS边界双归属” 相结合的设计。

- 边界层 (Edge Layer) - ASBR；

设备: 核心路由器

角色: 自治系统边界路由器 (ASBR)。

- 核心层 (Core Layer)；

设备: 核心路由器

角色: 高速转发骨干，iBGP Route Reflector (路由反射器)。

- 汇聚/ABR 层 (Aggregation/ABR Layer)；

设备: 三层交换机

角色: 区域边界路由器 (ABR)，连接核心与接入。

- 接入层 (Access Layer)；

设备: 接入交换机 

角色: 终端用户接入。

  

组网分层结构细化表格

|   |   |   |   |   |   |
|---|---|---|---|---|---|
|层级|名称|作用|关键设备/组件|对应 IP 规划示例 (基于 10.0.0.0/8)|路由/安全策略特征|
|L0|全局战略层|未来扩展与灾备储备。  <br>1. 预留整块地址给未来并购的新公司或新区域。  <br>2. 异地灾备中心 (DR) 启用时的地址源。  <br>3. 确保地址块的连续性，便于未来路由聚合。|无物理设备  <br>(逻辑地址池)  <br>IPAM 管理系统|10.0.0.0/8 中的未分配大块  <br>例：10.0.0.0/12 (未来并购)  <br>例：10.64.0.0/12 (灾备中心)|静默状态。  <br>默认不宣告任何路由。  <br>严禁零散借用，保持 /12 或 /8 的完整性，直到新站点上线。|
|L1|公司整体网络层|分公司/区域逻辑隔离单元。  <br>1. 作为一个独立的逻辑实体（如“华东区”、“北京分公司”）。  <br>2. 包含该区域内所有的边界、核心、汇聚和接入资源。  <br>3. 实现区域间的路由隔离与策略控制。|逻辑概念  <br>区域控制器 (vManage/SDC)  <br>区域路由汇总点|每个分公司一个主块  <br>例 (北京): 10.16.0.0/16  <br>例 (上海): 10.32.0.0/16  <br>例 (广州): 10.48.0.0/16|路由汇总点。  <br>向骨干层只宣告该区域的汇总路由 (如 10.16.0.0/16)，隐藏内部细节。  <br>区域间访问需经过 L3 骨干层策略控制。|
|L2|区域边界层|流量出入口与安全边界。  <br>1. 连接运营商线路 (MPLS/Internet/5G)。  <br>2. 实施 NAT、SD-WAN 选路、QoS。  <br>3. DMZ 区部署点：放置对外服务器和反向代理。  <br>4. 第一道防火墙防线。|SD-WAN CPE / 路由器  <br>边界防火墙 (Edge FW)  <br>DMZ 交换机  <br>负载均衡器 (LB)|互联与 DMZ 网段  <br>- 广域互联：10.16.0.0/27 (P2P /30)  <br>- DMZ 区：10.16.0.64/26 (Web/邮件)  <br>- 管理口：10.16.0.32/27|默认拒绝 (Default Deny)。  <br>严格 ACL 控制入站流量。  <br>NAT 转换 (私网转公网)。  <br>DMZ 到内网的访问需经应用层代理或特定端口映射。|
|L3|核心骨干层|全网高速枢纽与总部核心。  <br>1. 高速转发各 L1 区域间的流量。  <br>2. 部署总部数据中心、云专线互联。  <br>3. 提供全网基础服务 (DNS, AD, NTP, 网管)。  <br>4. 带外管理 (OOB) 核心汇聚。|核心路由器 (Core R)  <br>核心交换机 (Core SW)  <br>内部防火墙 (DC FW)  <br>云网关|总部特殊保留与互联  <br>- 总部核心块：10.254.0.0/16  <br>- 骨干互联：10.255.0.0/23 (P2P /31)  <br>- 基础服务：10.254.10.0/24  <br>- 云专线：10.254.20.0/29|全互联/Hub 架构。  <br>运行 OSPF Area 0 或 iBGP Full Mesh。  <br>向所有 L1 区域下发默认路由或明细路由。  <br>实施微隔离 (Micro-segmentation) 保护核心数据。|
|L4|汇聚层|区域流量收敛与部门隔离。  <br>1. 终结接入层 VLAN，作为用户网关 (SVI)。  <br>2. 实施部门间访问控制 (ACL)。  <br>3. 双归上行至 L2 边界或 L3 核心，提供高可用。  <br>4. 无线控制器 (WLC) 汇聚点。|汇聚交换机 (Agg SW)  <br>(通常堆叠或 MLAG 双活)  <br>无线控制器 (WLC)|Core-to-Agg 互联与网关  <br>- 互联链路：10.16.3.0/23 (每条 /30)  <br>- 办公网网关：10.16.10.1/24  <br>- 访客网网关：10.16.20.1/24  <br>- 语音网关：10.16.40.1/24|路由分发与汇总。  <br>将下属 L5 的明细路由汇总后宣告给上层。  <br>实施 VLAN 间路由控制 (Inter-VLAN Routing)。  <br>DHCP Relay 指向总部 DNS/服务器。|
|L5|接入层|终端设备接入。  <br>1. 提供有线 (PoE) 和无线 AP 物理接入。  <br>2. 端口安全 (802.1X, MAC 认证, 风暴控制)。  <br>3. 广播域隔离 (VLAN 划分到端口)。  <br>4. 物联网 (IoT) 设备接入。|接入交换机 (Access SW)  <br>无线 AP (Wi-Fi 6/7)  <br>IP 电话，摄像头，打印机|终端业务 VLAN 网段  <br>- 员工 PC：10.16.10.0/24  <br>- 访客 Wi-Fi：10.16.20.0/24  <br>- IoT/安防：10.16.30.0/24  <br>- 语音 VLAN：10.16.40.0/24|二层边缘 (Layer 2 Edge)。  <br>通常不运行动态路由协议。  <br>启用 STP/RSTP/MSTP 防环。  <br>Port-Security 限制每端口 MAC 数量。  <br>DHCP Snooping 防欺骗。|

  

---

## 

网段划分

  

### 

网段划分规范

基于 RFC 1918 标准和企业级网络最佳实践，以下是一套完整的网段分配规范。这套规范旨在确保网络的可扩展性、易管理性、安全性以及路由聚合（Summarization）的便利性。

推荐的层次化编址模型，采用 10.X.Y.Z的结构：

- X (第二个八位组)：代表 区域/站点/AS (Site/Area ID)。

- Y (第三个八位组)：代表 功能/业务类型 (Function/VLAN Type)。

- Z (第四个八位组)：代表 具体子网/主机 (Subnet/Host)。

示例：10->AS 编号/大区->区域/角色/类型->设备序号/机架/具体设备ID=>10.16.10.0/24

  

  

### 

网段划分种类

网段要种类进行划分，避免混在一个大网段里，这会导致路由表混乱，排错困难，且不安全。

  

#### 

业务网段

最终用户（PC、服务器、摄像头、AP）使用的网段，通常对应 VLAN 接口（SVI）或三层子接口。

根据用户数量分配，一般子网掩码配置如/24, /23等。根据需要网段还可进行层级上的划分。

示例：办公区 VLAN 10: 192.168.10.0/24 (网关 192.168.10.1)，服务器区 VLAN 20: 192.168.20.0/24 (网关 192.168.20.1)

注意

-  网关IP地址：一般默认配置网段最小地址+1；

  

#### 

互联链路网段

需要专门划分互联链路网段，跟lo类似，要求“扁平化”和“去层级化”。

示例：在 10.16.1.0/24 这个网段中，每一个/30子网（例如 10.16.1.0/30）代表一条物理线或一条逻辑专线。现代规范中，建议/31来划分一条互联链路子网。在实施的时候，还可以细化路由器互联链路网段、三层交换机互联链路网段、二层交换机互联链路网段。保持各层次网段的连续性。

10.16.1.0/30包含的 IP：4 个 IP。

- 10.16.1.0 (网络号，不可用)

- 10.16.1.1 (设备 A 的接口 IP)

- 10.16.1.2 (设备 B 的接口 IP)

- 10.16.1.3 (广播号，不可用) 

用途：这两个可用 IP ( .1 和 .2) 仅仅为了让这两台设备能互相“握手”并交换路由信息。

  

#### 

loopback网段

配置在设备逻辑接口 Loopback0 (或 Lo0) 上的 IP 地址网段，需要专门划分网段出来。交换机如果需要通过IP来连接管理，也需要使用专门划分网段。在实施的时候，还可以细化路由器lo网段、三层交换机lo网段、二层交换机lo网段。保持各层次网段的连续性。

Loopback (Lo) 地址的分配逻辑是“扁平化”的，而不是“层级化”的。

- 不要试图用 IP地址段来体现“核心、汇聚、接入”的层级关系。

- 要把每个IP(/32) 看作是一个独立的设备标签。

- 层级关系由物理连线和路由协议开销 (Cost) 来决定，而不是由 IP 地址决定

  

### 

S公司广域网IP网段规划总表

公司总网段 (10.0.0.0/8)，下面表格主要是针对分公司A，其他分公司参考即可。

|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|层级|区域/用途|建议 CIDR 网段|子网掩码|可用主机数 (每子网)|可划分子网数|说明与路由策略|
|L0|骨干/特殊保留|10.0.0.0 - 10.15.255.255|/12|-|4,096 个 /24|全局资源池。用于：  <br>1. 总部直连网段  <br>2. 云专线互联  <br>3. 带外管理网 (OOB)  <br>4. 其他特殊项目|
|L0|保留/未来扩展|10.48.0.0 - 10.255.255.255|/12+|-|>800,000|预留池。用于未来新增分公司C/D、并购整合或灾备中心。BGP中不宣告此段。|
|L1|分公司 A (整体)|10.16.0.0 - 10.31.255.255|/12|1,048,574|4,096 个 /24|BGP聚合宣告点。对外只宣告 10.16.0.0/12 一条路由。|
|L2|A-互联网/专线出口<br><br>(WAN/Internet Edge)|10.16.0.0/26|/30 或 /31|2|32个 /31|防火墙/路由器互联。用于连接 ISP 运营商、MPLS 专线对端。配置 NAT 和边界安全策略。|
|L2|A-DMZ 服务区<br><br>(Demilitarized Zone)|10.16.0.64/26|/26|62|1 个|对外服务器区。放置邮件网关、Web 门户等需双向访问的服务器。严格 ACL 控制。|
|L3|A-核心设备管理/Loopback|10.16.1.0/24|/24|254|1 个|路由基石。核心交换机、边界路由器的 Loopback 接口地址。OSPF Area 0 骨干，BGP Router-ID 来源。|
|L3|A-核心互联链路<br><br>(Core-to-Core / Core-to-Edge)|10.16.2.0/24|/30或/31|2|64 个 (/30)或128个 (/31)或|高速骨干。核心交换机之间、核心与边界防火墙之间的互联。纯三层路由，无用户 VLAN。<br><br>OSPF Area 0。按 /31 可分 128条链路。|
|L4|A-汇聚互联<br><br>(Core-to-Agg Links)|10.16.3.0/23|/30 或 /31|2|~256 条链路|垂直互联。连接核心层与各个楼栋/区域的汇聚交换机。运行 OSPF，执行路由汇总的第一跳。|
|L4|A-汇聚设备管理|10.16.4.0/24|/24|254|1 个|汇聚层交换机的管理 IP。建议划分独立 VLAN，通过带外或特定管理 VRF 访问。|
|L5|A-办公用户网段|10.16.10.0 - 10.16.99.0|/24|254|90 个|终端接入。普通员工 PC。网关通常部署在汇聚层。按部门/楼层划分 VLAN (如 V10-V90)。|
|L5|A-服务器/数据中心|10.16.100.0 - 10.16.119.0|/24|254|20 个|内部业务服务器。内部 ERP、文件服务器。若规模大，此处可再细分“接入 - 汇聚”结构，或直连核心。|
|L5|A-无线/IoT/访客|10.16.200.0 - 10.16.219.0|/24|254|20 个|隔离接入。Guest Wi-Fi、摄像头、门禁等。需在汇聚/核心层做策略隔离，禁止访问内网服务器。|
|L5|A-语音/视频|10.16.220.0 - 10.16.229.0|/24|254|10 个|实时业务。IP 电话、视频会议。需在全网（接入到核心）配置 LLQ/CBWFQ 优先级队列。<br><br>对延迟敏感业务，需配置 QoS。|
|L1|A-内部保留|10.16.230.0 - 10.31.255.255|/12剩余|-|~3,800+|弹性空间。预留在分公司 A 的 /12 块内，用于未来新增大楼、新业务线，无需修改 BGP 宣告。|
|L1|分公司 B (整体)|10.32.0.0 - 10.47.255.255|/12|1,048,574|4,096 个 /24|BGP聚合宣告点。对外只宣告 10.32.0.0/12 一条路由。|

  

---

## 

组网网络拓扑

结合组网场景、采用技术、组网分层设计、网段划分导出下面的组网网络拓扑：

![](https://vipkshttps5.wiz.cn/editor/b91fa2ab-6902-11e0-be61-3e8f14b55176/8ec37f4c-f5a7-4925-a925-f379ce3a01ff/resources/sSYQJJIOztAxjZA-KzVCmLR3E3qkTf_NrE1ED9Zml-I.png?token=W.MtgCWcZwzGASVTWQBhYNl7vrbTAH6cv39eRIDjPFzn8sr7Tqoi113EB8jQ2Iuuo)

  

---

## 

方案特点

- 独立性高：AS10 和 AS20 各自拥有独立的公网 IP (30.30.30.10, 30.30.30.20) 和网关，互不依赖。任何一方的互联网线路故障，不会影响另一方的正常上网。

- 流量路径最优：

- 上网流量：本地流量本地出（AS16 走 R16-1，AS32 走 R32-1），不占用宝贵的内网专线带宽，延迟最低。

- 内网互访：分公司间流量走 R16-1 <=> R32-1 专线，安全且高速。

- 协议分工明确：

- OSPF：负责内部（Area 0/1/2）的高速收敛和连通性。

- BGP：负责跨域（AS16 <-> AS32）的路由交换和策略控制，天然隔离故障域。

- 扩展性强：未来增加分公司 C、D 只需照此模式复制，通过 BGP 互联即可，无需重构内部 OSPF。

  

---

## 

组网运维配置

下面是BGP、OSPF、VLAN配置，里面很多信息有误差，仅可作为了解配置大体内容。

  

### 

边界路由器 R16-1 (ASBR & iBGP Client)

角色：连接 ISP、连接 AS32、运行 OSPF Area 0、运行 eBGP (对外) 和 iBGP (对内)。

sysname R16-1-ASBR

router id 10.16.1.1

  

# --- 1. 接口配置 ---

interface LoopBack0

 ip address 10.16.1.1 255.255.255.255

  

# WAN 口 (连接 ISP)

interface GigabitEthernet0/0/1

 description To_ISP_Internet

 ip address 30.30.30.10 255.255.255.254

  

# AS 间专线口 (连接 AS32) - L0 骨干池

interface GigabitEthernet0/0/2

 description To_AS32_R32-1

 ip address 10.0.0.0 255.255.255.254

  

# 核心互联口 (连接 RR R16-2)

interface GigabitEthernet0/0/3

 description To_R16-2_RR

 ip address 10.16.2.0 255.255.255.254

  

# --- 2. 静态默认路由 (指向 ISP) ---

ip route-static 0.0.0.0 0.0.0.0 30.30.30.11

  

# --- 3. OSPF 配置 (Area 0) ---

ospf 100 router-id 10.16.1.1

 area 0.0.0.0

  network 10.16.1.1 0.0.0.0

  network 10.16.2.0 0.0.0.1

  network 10.0.0.0 0.0.0.1

  # 注入默认路由到 OSPF，让内网能上网

  default-route-advertise always type 2 cost 10

 quit

  

# --- 4. BGP 配置 ---

bgp 16

 router-id 10.16.1.1

 # [eBGP] 与 AS32 建立邻居 (专线)

 peer 10.0.0.1 as-number 32

 peer 10.0.0.1 connect-interface GigabitEthernet0/0/2

 # [iBGP] 与 RR (R16-2) 建立邻居

 peer 10.16.1.2 as-number 16

 peer 10.16.1.2 connect-interface LoopBack0

 # 关键：关闭 eBGP 多跳检测 (如果是直连 eBGP 不需要，但 iBGP 需要 next-hop-local)

 ipv4-family unicast

  undo synchronization

  # 宣告本地汇总网段

  network 10.16.0.0 255.240.0.0

  # 激活 eBGP 邻居

  peer 10.0.0.1 enable

  # 可选：向 AS32 发送默认路由 (如果需要)

  # peer 10.0.0.1 default-route-advertise

  # 激活 iBGP 邻居 (RR 客户端)

  peer 10.16.1.2 enable

  # 关键：向 iBGP 邻居通告时，将下一跳改为自己，否则 R16-3 无法解析下一跳

  peer 10.16.1.2 next-hop-local 

  # [可选] 如果 R16-3 也是出口，这里不需要特殊配置，RR 会自动反射路由

 quit

  

### 

核心路由反射器 R16-2 (RR)

角色：iBGP 路由反射器，连接 R16-1 和 R16-3。不连接外网，不宣告业务网段。

sysname R16-2-RR

router id 10.16.1.2

  

# --- 1. 接口配置 ---

interface LoopBack0

 ip address 10.16.1.2 255.255.255.255

  

interface GigabitEthernet0/0/1

 description To_R16-1_ASB

 ip address 10.16.2.1 255.255.255.254

  

interface GigabitEthernet0/0/2

 description To_R16-3_Peer

 ip address 10.16.2.2 255.255.255.254

  

interface GigabitEthernet0/0/3

 description To_R16-0-1_ABR

 ip address 10.16.2.6 255.255.255.254

  

interface GigabitEthernet0/0/4

 description To_R16-0-2_ABR

 ip address 10.16.2.8 255.255.255.254

  

# --- 2. OSPF 配置 (Area 0) ---

# 仅用于打通 Loopback 连通性，使 iBGP 邻居能建立

ospf 100 router-id 10.16.1.2

 area 0.0.0.0

  network 10.16.1.2 0.0.0.0

  network 10.16.2.0 0.0.0.255  # 覆盖所有核心互联段

 quit

  

# --- 3. BGP 配置 (Route Reflector) ---

bgp 16

 router-id 10.16.1.2

 # [iBGP] 连接 R16-1 (Client)

 peer 10.16.1.1 as-number 16

 peer 10.16.1.1 connect-interface LoopBack0

 # [iBGP] 连接 R16-3 (Client)

 peer 10.16.1.3 as-number 16

 peer 10.16.1.3 connect-interface LoopBack0

 ipv4-family unicast

  undo synchronization

  # 声明集群 ID (可选，防止环路，同一 RR 组需一致)

  reflector cluster-id 1.1.1.1

  # 激活邻居并指定为客户端

  peer 10.16.1.1 enable

  peer 10.16.1.1 reflect-client

  peer 10.16.1.3 enable

  peer 10.16.1.3 reflect-client

  # 注意：RR 本身不宣告任何 network，也不 redirect ospf

 quit

  

### 

核心对等体 R16-3 (iBGP Client)

  

sysname R16-3-Peer

router id 10.16.1.3

  

# --- 1. 接口配置 ---

interface LoopBack0

 ip address 10.16.1.3 255.255.255.255

  

interface GigabitEthernet0/0/1

 description To_R16-2_RR

 ip address 10.16.2.3 255.255.255.254

  

# --- 2. OSPF 配置 (Area 0) ---

ospf 100 router-id 10.16.1.3

 area 0.0.0.0

  network 10.16.1.3 0.0.0.0

  network 10.16.2.2 0.0.0.1

 quit

  

# --- 3. BGP 配置 ---

bgp 16

 router-id 10.16.1.3

 # [iBGP] 连接 RR (R16-2)

 peer 10.16.1.2 as-number 16

 peer 10.16.1.2 connect-interface LoopBack0

 ipv4-family unicast

  undo synchronization

  # 激活邻居

  peer 10.16.1.2 enable

  # 关键：即使没有外网出口，也要能学习路由。

  # 如果 R16-3 未来要作为出口，需在此处配置 eBGP 和 network

 quit

  

### 

区域边界路由器 R16-0-1 (ABR)

角色：连接 Area 0 和 Area 1。无 BGP。

R16-0-2没列举出来，差不多配置。

sysname R16-0-1-ABR

router id 10.16.1.10

  

interface LoopBack0

 ip address 10.16.1.10 255.255.255.255

  

interface GigabitEthernet0/0/1

 description To_R16-2_Core

 ip address 10.16.2.7 255.255.255.254

  

interface GigabitEthernet0/0/2

 description To_SW-SRV-Agg

 ip address 10.16.3.0 255.255.255.254

  

ospf 100 router-id 10.16.1.10

 area 0.0.0.0

  network 10.16.1.10 0.0.0.0

  network 10.16.2.6 0.0.0.1

 area 0.0.0.1

  stub no-summary

  network 10.16.3.0 0.0.0.1

 quit

  

### 

服务器汇聚交换机 R16-1-1

角色：作为 VLAN 网关，提供 DHCP(未配置)。

sysname R16-1-1

router id 10.16.4.0

  

interface LoopBack0

 ip address 10.16.4.0 255.255.255.255

  

interface Vlanif1000

 description Server_Gateway

 ip address 10.16.100.1 255.255.255.0

  

interface GigabitEthernet1/0/1

 description To_R16-0-1

 port link-type routed

 ip address 10.16.3.1 255.255.255.254

  

ospf 100 router-id 10.16.4.0

 area 0.0.0.1

  stub no-summary

  network 10.16.4.0 0.0.0.0

  network 10.16.3.0 0.0.0.1

  network 10.16.100.0 0.0.0.255

  silent-interface Vlanif1000

 quit

  

### 

汇聚交换机 Switch16-Agg-1

作为核心三层路由，VLAN 网关；这里很多配置已经错误，下面只是示例，只需了解大概得配置内容即可。

sysname Switch16-Agg-1

router id 10.16.4.2

  

# --- VLAN & DHCP ---

vlan batch 15 20

dhcp enable

  

ip pool develop

 network 10.16.15.0 mask 255.255.255.0

 gateway-list 10.16.15.1

 dns-list 114.114.114.114

  

ip pool test

 network 10.16.20.0 mask 255.255.255.0

 gateway-list 10.16.20.1

 dns-list 114.114.114.114

  

# --- 接口配置 ---

interface GigabitEthernet0/0/1

 description To_R16-0-2_Core

 ip address 10.16.3.6 255.255.255.254

 undo shutdown

  

interface GigabitEthernet0/0/2

 description To_Switch16-2_Access

 port link-type trunk

 port trunk allow-pass vlan 15 20

 undo shutdown

  

interface Vlanif 15

 ip address 10.16.15.1 255.255.255.0

 dhcp select global

  

interface Vlanif 20

 ip address 10.16.20.1 255.255.255.0

 dhcp select global

  

interface LoopBack0

 ip address 10.16.4.2 255.255.255.255

  

# --- OSPF ---

ospf 100 router-id 10.16.4.2

 area 0.0.0.2

  network 10.16.4.2 0.0.0.0

  network 10.16.3.6 0.0.0.1   # 互联段

  network 10.16.15.0 0.0.0.255 # 【关键】宣告用户网段

  network 10.16.20.0 0.0.0.255 # 【关键】宣告用户网段

 quit

  

  

### 

接入交换机 Switch16-2 & Switch16-3

角色：接入层，划分 VLAN 给用户。

Switch16-3 配置(配置同 Switch16-2，仅名称不同)就不列举了。

sysname Switch16-2

vlan batch 15

  

# 上行

interface GigabitEthernet0/0/1

 description To_Agg

 port link-type trunk

 port trunk allow-pass vlan 15

 undo shutdown

  

# 下行端口 (研发部 VLAN 15)

interface range GigabitEthernet 0/0/2 to 0/0/16

 port link-type access

 port default vlan 15

 stp edged-port enable

 undo shutdown

  

  

  

### 

分公司 B (AS32) 配置

  

### 

边界路由器 R32-1 (ASBR)

角色：连接 ISP、连接 AS16。

sysname R32-1-ASBR

router id 10.32.1.1

  

interface LoopBack0

 ip address 10.32.1.1 255.255.255.255

  

interface GigabitEthernet0/0/1

 description To_ISP

 ip address 30.30.30.20 255.255.255.254

  

interface GigabitEthernet0/0/2

 description To_AS16_R16-1

 ip address 10.0.0.1 255.255.255.254

  

# 静态默认路由

ip route-static 0.0.0.0 0.0.0.0 30.30.30.21

  

ospf 100 router-id 10.32.1.1

 area 0.0.0.0

  network 10.32.1.1 0.0.0.0

  network 10.0.0.0 0.0.0.1

  default-route-advertise always type 2 cost 10

 quit

  

bgp 32

 router-id 10.32.1.1

 peer 10.0.0.0 as-number 16

 peer 10.0.0.0 connect-interface GigabitEthernet0/0/2

 ipv4-family unicast

  undo synchronization

  network 10.32.0.0 255.240.0.0

  peer 10.0.0.0 enable

 quit

  

  

### 

NAT 配置补充 (在 R16-1 上)

  

内网->互联网

acl 2000

 rule permit source 10.16.0.0 0.15.255.255

 rule permit source 10.0.0.0 0.0.0.3  # 允许 AS 间互联地址 (可选，通常不需要 NAT)

  

interface GigabitEthernet0/0/1

 nat outbound 2000

  

  

---

## 

关键配置

  

### 

自治系统边界路由器访问互联网设置(NAT)

访问互联网配置：只有去往互联网的流量才做 NAT。

R16-1:

# ==========================================

# 2. NAT 配置 (核心上网逻辑)

# ==========================================

# --- WAN 口 (连接 ISP/AS32) ---

# 假设对端 IP 为 30.30.30.11 (AS32 的接口)

interface GigabitEthernet0/0/1

 description To_ISP_AS32

 ip address 30.30.30.10 255.255.255.254  # /31 掩码

 # 【关键】在此接口开启 NAT 出方向

 nat outbound 2000

 undo shutdown

  

  

# 定义 ACL：匹配需要上网的内网网段

# 允许 10.16.0.0/16 网段进行转换

acl number 2000

 rule 5 permit source 10.16.0.0 0.0.255.255

 rule 10 deny  # 隐含拒绝其他，保持安全

# 注意：nat outbound 2000 已经在 GE0/0/1 接口下配置了

  

  

R32-1(参考R16-1配置)

  

### 

BGP 路由过滤

在 R16-1 和 R32-1 的 BGP 邻居配置中，必须使用 Prefix-List 或 Route-Map 进行严格过滤：

- Outbound (发给对方): 只允许发送本 AS 的内网段 (10.16.0.0/12 或 10.32.0.0/12)。

- 禁止 发送 0.0.0.0/0 (除非做备份)。

- 禁止发送任何互联网明细路由。

-  Inbound (接收对方): 只允许接收对方的内网段。

- 拒绝接收任何互联网路由，防止污染本地路由表。

! 示例逻辑

access-list NO_NAT permit 10.16.0.0 0.255.255.255

access-list NO_NAT permit 10.32.0.0 0.255.255.255

  

ip nat inside source list NO_NAT interface GigabitEthernet0/0/0 overload

! 注意：上面这句配置可能需要更精细的 Route-Map 来控制，确保内网互访不 NAT，上网才 NAT。

! 更精准的做法是使用 Route-Map 匹配 "Internet-Traffic" 才做 NAT。

  

! R10-1 示例 (Cisco风格)

ip prefix-list ALLOW-AS32 permit 10.32.0.0/8 le 32

router bgp 10

 neighbor <R20-1-IP> prefix-list ALLOW-AS32 in

 neighbor <R20-1-IP> prefix-list DENY-INTERNET out ! (确保不发互联网路由)

  

### 

默认公网网关配置

R16-1和R32-1上配置静态默认路由(互联网的网关)指向ISP。

结果：AS10内部所有设备默认路由指向 R10-1；AS20 内部所有设备默认路由指向 R20-1。这样，内部所有设备只有一条 0.0.0.0/0 指向出口，极简高效。

R10-1静态路由: ip route 0.0.0.0 0.0.0.0 30.30.30.11

    OSPF: default-information originate always metric 10

R20-1静态路由: ip route 0.0.0.0 0.0.0.0 30.30.30.21

    OSPF: default-information originate always metric 10

注意：默认路由下发后，每个路由器的下一跳地址是指向直连路由器的地址，OSPF协议会计算好的。

  

### 

OSPF与BGP间的路由信息同步

  

采用 “静态默认路由注入 OSPF” + “带过滤的 OSPF 注入 BGP” 的组合，既能实现高度的自动化（加设备、加网段都不用改核心路由协议配置），又能保证网络的稳定性和安全性。这是企业网和运营商边缘网络的标准做法。

  

参考：【Note_路由Route】->OSPF与BGP间的路由信息同步

  

---

## 

网络运维命令速查手册

  

### 

快速健康检查 (Quick Health Check)

用途：日常巡检第一步，快速概览设备核心状态。

# 1. 查看设备整体状态 (板卡/电源/风扇)

display device

# (Cisco: show inventory)

  

# 2. 查看接口状态摘要 (重点关注 Status 是否为 UP)

display interface brief

# (Cisco: show ip int brief)

  

# 3. 查看 OSPF 邻居摘要 (重点关注 State 是否为 Full)

display ospf peer brief

# (Cisco: show ip ospf neighbor)

  

# 4. 查看 BGP 邻居摘要 (重点关注 State 是否为 Established)

display bgp peer

# (Cisco: show ip bgp summary)

  

# 5. 查看全局路由表条目数及默认路由

display ip routing-table summary

display ip routing-table 0.0.0.0

# (Cisco: show ip route summary | include 0.0.0.0)

  

# 6. 查看当前 NAT 会话总数

display nat session count

# (Cisco: show ip nat translations count)

  

# 7. 查看最近关键日志 (报错/震荡)

display logbuffer | include "Error|Down|Change|Warning"

# (Cisco: show logging | include Error|Down)

### 

详细分层排查命令集

  

#### 

物理与链路层 (Physical & Link Layer)

# 查看指定接口详细统计 (检查 CRC 错误、丢包、Input/Output errors)

display interface GigabitEthernet 0/0/1

# (Cisco: show interfaces g0/1)

  

# 查看光模块收发功率 (判断光路质量)

display transceiver interface GigabitEthernet 0/0/1 verbose

# (Cisco: show transceiver details)

  

# 查看 VLAN 信息及端口成员

display vlan

# (Cisco: show vlan brief)

  

# 查看 MAC 地址表 (确认终端接入位置)

display mac-address

# (Cisco: show mac address-table)

  

# 查看生成树状态 (确认无环路，根桥正确，边缘端口状态)

display stp brief

# (Cisco: show spanning-tree brief)

#### 

OSPF 内部路由 (IGP - Intra-AS)

# 查看 OSPF 邻居详细信息 (卡住时排查用)

display ospf peer

  

# 查看 OSPF 接口配置 (确认 Area ID, 网络类型，Cost)

display ospf interface

  

# 查看 OSPF 路由表 (确认内部网段学习情况)

display ospf routing

  

# 查看 OSPF LSDB (数据库)，验证 Stub/Totally Stub 区域配置是否生效

display ospf lsdb

  

# 验证默认路由是否通过 OSPF 下发 (Type 2 LSA)

display ip routing-table protocol ospf | include 0.0.0.0

#### 

BGP 跨域路由 (EGP - Inter-AS)

# 查看 BGP 邻居详细信息 (检查接收/发送路由数，Keepalive 时间)

display bgp peer verbose

  

# 查看 BGP 路由表

display bgp routing-table

  

# 【关键】检查向对端 (AS32/ISP) 宣告了哪些路由 (防泄露)

display bgp routing-table peer <邻居IP> advertised-routes

# (Cisco: show ip bgp neighbors <IP> advertised-routes)

  

# 【关键】检查从对端接收了哪些路由 (防污染)

display bgp routing-table peer <邻居IP> received-routes

# (Cisco: show ip bgp neighbors <IP> routes)

  

# 查看特定网段的 BGP 路径属性 (Next_Hop, AS_Path, Local_Pref, Origin)

display bgp routing-table 10.16.100.0 24

  

# 查看路由策略/前缀列表配置 (验证过滤规则)

display route-policy

display ip ip-prefix

# (Cisco: show route-map | show ip prefix-list)

#### 

NAT 与安全策略 (NAT & Security)

# 查看 NAT 会话详情 (验证内网 IP 是否转换为公网 IP，端口映射是否正确)

display nat session all

# (Cisco: show ip nat translations)

  

# 查看 NAT 统计信息 (确认 ACL 命中次数，判断流量是否匹配)

display nat statistics

# (Cisco: show ip nat statistics)

  

# 查看 ACL 规则及匹配计数 (确认过滤策略是否生效，是否有异常拦截)

display acl all

# (Cisco: show access-lists)

  

# 查看防火墙会话表 (若部署了独立防火墙)

display firewall session table

# (Cisco: show conn)

  

# 查看端口安全状态 (接入层防攻击)

display port-security

# (Cisco: show port-security)

#### 

DHCP 与用户业务 (User Services)

# 查看 DHCP 地址池使用情况 (已分配/冲突/剩余)

display dhcp server tree

display dhcp server conflict

# (Cisco: show ip dhcp binding | show ip dhcp conflict)

  

# 查看 DHCP 中继状态

display dhcp relay

  

# 测试连通性 (指定源 IP，验证回程路由是否正确)

ping -a 10.16.15.10 10.16.100.1

tracert -a 10.16.15.10 8.8.8.8

# (Cisco: ping <IP> source <Loopback> | traceroute <IP>)

#### 

系统资源与日志 (System & Logs)

# 查看 CPU 利用率 (历史/实时，排查高负载)

display cpu-usage

# (Cisco: show processes cpu)

  

# 查看内存利用率

display memory-usage

# (Cisco: show memory)

  

# 查看系统日志缓冲区 (排查故障核心依据)

display logbuffer

# (Cisco: show logging)

  

# 查看当前配置 (排错时对比预期配置)

display current-configuration

# (Cisco: show running-config)

  

  

---

## 

改建建议

这套组网架构为了学习目的，其中部分设计不是很合理，真正要用于生成，有下面几点需要改进

  

### 

switch16-agg-1三层交换机角色定位问题

一般三层会交换机作为area0的abr。这个案例中，作为了普通的二层交换机汇总作用，与最佳实践不匹配。

  

### 

避免使用ip结尾为0

如：AS 间互联子网掩码与 IP 分配：R16-1<=10.0.0.0/31>R32-1

在某些旧设备或特定配置习惯中，人们习惯避免使用 .0 作为主机 IP（虽然现代设备都支持 ip subnet-zero）。

确保两端路由器都开启了 ip subnet-zero (Cisco) 或直接支持 /31 (华为/H3C 默认支持)。如果担心兼容性，可以改用 10.0.0.4/30 (.4 和 .5)，浪费 2 个 IP 但兼容性最好。推荐坚持用 /31，这是现代标准。

何时需要 RR？ 只有当 R16-1 和 R16-3 都有 独立的对外 BGP 连接（例如双出口负载分担），且需要在内部传递具体的 BGP 属性（如 Local_Pref）来选路时，才需要 iBGP + RR。

  

### 

R16-2/3多余

为了学习BGP组网，有3台R16-1/2/3，在这案例中，只有R16-1有作用，其他可移除。

如果分公司 A 只有一个出口 (R16-1 连互联网 + 连 AS32)，那么 R16-2 和 R16-3 完全不需要运行 iBGP。

  

### 

设备命名与层级一致性

问题：在 Area 1 (服务器区) 和 Area 2 (办公区) 的汇聚层，设备角色其实是一样的（都是运行 OSPF 的三层设备）。一个叫 Router，一个叫 Switch，容易造成配置风格不统一。

建议：统一称为 L3 Switch (汇聚交换机)。这样更符合“核心 - 汇聚 - 接入”的三层架构模型。

  

### 

安全策略补充

在这个案例中，我们只是打通了路由，各分层间的安全策略没有配置，需要补充。

建议：

ABR (R16-0-1/0-2) 或 汇聚交换机 (SW-SRV-Agg) 上配置 VACL (VLAN ACL) 或 防火墙策略。

办公区 -> DMZ：通常禁止直接访问，或通过代理访问。

访客/IoT (10.16.200.x) -> 禁止 访问任何内部网段 (10.16.10.x, 10.16.100.x)，只允许访问互联网。

  

### 

其他改进建议

1核心路由器单点故障问题

2快速响应使用不同运营商网络的客户，需要接入不同的ISP的

3管理IP和网段，如引入IPAM (IP Address Management) 系统（如 SolarWinds IPAM, phpIPAM, 或云厂商自带的 IPAM）

4网络自动化运维、监控、可视化设计等功能引入

---

## 

QA

  

### 

Q：路由的下一跳地址使用路由器的lo地址吗

A：不用纠结下一跳显示的是什么。只要 OSPF 正常工作，下一跳是物理 IP 还是 Lo IP 不影响连通性。只要 Lo 地址可达，OSPF 就能计算出正确的路径。至于路由表里下一跳写的是 10.0.2.2 (物理) 还是 1.10.0.2 (Lo)，在直连场景下，物理接口 IP 是标准行为，无需干预。

重点是：确保路由器的Loopback 地址 (1.10.0.2) 在 OSPF 中被正确宣告（通常放在 Area 0），这样整个网络都能通过 Router-ID 识别到它。

  

### 

Q：二层交换机需要分配Ip吗

A：结论：不配置IP。但是为了连接、管理交换机，可以设置vlan ip。这个ip按照例子从网关：设备管理池中分配，10.16.0.100/24；

注意：

这个ip，与这个交换机上接入的其他设备ip可以是不同网段的，而且也建议分网段，为了安全和管理清晰。

从接入交换机到核心交换机，中间所有的链路（Trunk）必须允许管理 VLAN (例如 VLAN 100) 通过

  

### 

Q：网段配置在哪个配置上

绝大多数情况下，网段（网关）是在“三层交换机”上配置的，而不是在出口路由器上。

内网设备的“默认网关”是哪个，网段也就归属于它。
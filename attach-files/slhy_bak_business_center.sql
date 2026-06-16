/*
 Navicat Premium Data Transfer

 Source Server         : qnsz-shilian-zaiqing-dev-32
 Source Server Type    : MySQL
 Source Server Version : 80021
 Source Host           : 10.15.3.32:3306
 Source Schema         : slhy_business_center

 Target Server Type    : MySQL
 Target Server Version : 80021
 File Encoding         : 65001

 Date: 26/09/2024 15:25:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_boss_device_info
-- ----------------------------
DROP TABLE IF EXISTS `t_boss_device_info`;
CREATE TABLE `t_boss_device_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `member_number` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '成员号码',
  `device_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '设备型号',
  `device_sn` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '串码',
  `location` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '安装的位置信息',
  `room_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '会议室名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_boss_enterprise_info
-- ----------------------------
DROP TABLE IF EXISTS `t_boss_enterprise_info`;
CREATE TABLE `t_boss_enterprise_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `enterprise_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业ID（ECID）',
  `enterprise_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业名称',
  `province` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属省份',
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属地市',
  `country` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属区县',
  `industry` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属行业',
  `administrator_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员名称',
  `administrator_email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员邮箱',
  `administrator_phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员手机号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `sys_enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `enterprise_id` (`enterprise_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='BOSS同步的企业表';

-- ----------------------------
-- Table structure for t_boss_order
-- ----------------------------
DROP TABLE IF EXISTS `t_boss_order`;
CREATE TABLE `t_boss_order` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `serial_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '业务流水号',
  `boss_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '请求的省BOSS编码',
  `order_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单号',
  `enterprise_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业ID（ECID）',
  `business_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务类型（01 会议硬终端  02会议软终端 03 云就业 04 定制集成）',
  `create_time` datetime NOT NULL COMMENT '开户时间，时间戳',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间，时间戳',
  `operate_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '1：开户；2：暂停；3：销户；4：恢复；5：变更',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `serial_no_idx` (`serial_no`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='BOSS订单记录表';

-- ----------------------------
-- Table structure for t_boss_order_product_tariff
-- ----------------------------
DROP TABLE IF EXISTS `t_boss_order_product_tariff`;
CREATE TABLE `t_boss_order_product_tariff` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `serial_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '业务流水号',
  `product_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品资费编码',
  `product_price` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品资费值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `serial_no_idx` (`serial_no`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9948 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='BOSS订单与产品资费关系表';

-- ----------------------------
-- Table structure for t_boss_order_user_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_boss_order_user_relation`;
CREATE TABLE `t_boss_order_user_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `serial_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '业务流水号',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3022 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='BOSS订单与用户关系表';

-- ----------------------------
-- Table structure for t_boss_record_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_boss_record_detail`;
CREATE TABLE `t_boss_record_detail` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `record_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '01：用户新增，02：用户暂停，03：用户销户，04：用户恢复，05：用户变更，06：企业新增，07：企业更新，08：企业注销',
  `record_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '数据详情',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7376 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='接收到的BOSS原始数据表，仅做数据记录';

-- ----------------------------
-- Table structure for t_department_info
-- ----------------------------
DROP TABLE IF EXISTS `t_department_info`;
CREATE TABLE `t_department_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `department_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门唯一id',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业唯一id',
  `department_type` int NOT NULL DEFAULT '0' COMMENT '部门类型 0-普通部门 1-独立部门',
  `department_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门名',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '上级部门id，一级部门为 0',
  `department_sort` int DEFAULT NULL COMMENT '部门排序',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  `user_number` int NOT NULL DEFAULT '0' COMMENT '用户数量',
  `dirct_user_number` int NOT NULL DEFAULT '0' COMMENT '直接用户数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `did_index` (`department_id`) USING BTREE,
  KEY `eid_index` (`enterprise_id`) USING BTREE,
  KEY `pid_index` (`parent_id`) USING BTREE,
  KEY `dt_index` (`department_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2864 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='部门信息表';

-- ----------------------------
-- Table structure for t_department_info_copy1
-- ----------------------------
DROP TABLE IF EXISTS `t_department_info_copy1`;
CREATE TABLE `t_department_info_copy1` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `department_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门唯一id',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业唯一id',
  `department_type` int NOT NULL DEFAULT '0' COMMENT '部门类型 0-普通部门 1-独立部门',
  `department_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门名',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '上级部门id，一级部门为 0',
  `department_sort` int DEFAULT NULL COMMENT '部门排序',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  `user_number` int NOT NULL DEFAULT '0' COMMENT '用户数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `did_index` (`department_id`) USING BTREE,
  KEY `eid_index` (`enterprise_id`) USING BTREE,
  KEY `pid_index` (`parent_id`) USING BTREE,
  KEY `dt_index` (`department_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2808 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='部门信息表';

-- ----------------------------
-- Table structure for t_department_info_copy2
-- ----------------------------
DROP TABLE IF EXISTS `t_department_info_copy2`;
CREATE TABLE `t_department_info_copy2` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `department_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门唯一id',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业唯一id',
  `department_type` int NOT NULL DEFAULT '0' COMMENT '部门类型 0-普通部门 1-独立部门',
  `department_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门名',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '上级部门id，一级部门为 0',
  `department_sort` int DEFAULT NULL COMMENT '部门排序',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `did_index` (`department_id`) USING BTREE,
  KEY `eid_index` (`enterprise_id`) USING BTREE,
  KEY `pid_index` (`parent_id`) USING BTREE,
  KEY `dt_index` (`department_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2808 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='部门信息表';

-- ----------------------------
-- Table structure for t_department_user_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_department_user_relation`;
CREATE TABLE `t_department_user_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `department_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门唯一id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `user_sort` int DEFAULT '100' COMMENT '用户在部门内的排序，空则排在最后',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid_index` (`user_id`) USING BTREE,
  KEY `user_sort_index` (`user_sort`) USING BTREE,
  KEY `did_index` (`department_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=338642 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='部门-用户关系表';

-- ----------------------------
-- Table structure for t_department_user_relation_copy1
-- ----------------------------
DROP TABLE IF EXISTS `t_department_user_relation_copy1`;
CREATE TABLE `t_department_user_relation_copy1` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `department_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门唯一id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `user_sort` int DEFAULT '100' COMMENT '用户在部门内的排序，空则排在最后',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid_index` (`user_id`) USING BTREE,
  KEY `user_sort_index` (`user_sort`) USING BTREE,
  KEY `did_index` (`department_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=336680 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='部门-用户关系表';

-- ----------------------------
-- Table structure for t_device_info
-- ----------------------------
DROP TABLE IF EXISTS `t_device_info`;
CREATE TABLE `t_device_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `cmei` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '唯一cmei',
  `belong_unique_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属厂商设备信息唯一id',
  `belong_phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '绑定用户账号',
  `belong_enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '绑定企业唯一id',
  `data_source` int NOT NULL DEFAULT '0' COMMENT '数据来源 0-portal新增 1-portal导入',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新者',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  `is_addonenet` int DEFAULT '0' COMMENT '0否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2423 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='设备信息表';

-- ----------------------------
-- Table structure for t_enterprise_info
-- ----------------------------
DROP TABLE IF EXISTS `t_enterprise_info`;
CREATE TABLE `t_enterprise_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业唯一id',
  `enterprise_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业名',
  `parent_enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '父企业',
  `isolation` int NOT NULL DEFAULT '0' COMMENT '是否隔离 0-否 1-是',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  `province_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '省份code',
  `province_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '省份名字',
  `city_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '城市code',
  `city_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '城市名称',
  `contact_user_ll` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业联系人',
  `contact_user` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `contact_user1` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `contact_user_phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `eid_index` (`enterprise_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='企业信息表';

-- ----------------------------
-- Table structure for t_enterprise_manager
-- ----------------------------
DROP TABLE IF EXISTS `t_enterprise_manager`;
CREATE TABLE `t_enterprise_manager` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业唯一id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `belong_type` int NOT NULL COMMENT '是否默认管理员 0否 1是',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid_index` (`user_id`) USING BTREE,
  KEY `eid_index` (`enterprise_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='企业管理员表';

-- ----------------------------
-- Table structure for t_enterprise_software_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_enterprise_software_relation`;
CREATE TABLE `t_enterprise_software_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业唯一id',
  `software_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '软件类型唯一id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `eid_sid_index` (`enterprise_id`,`software_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='企业-软件类型关系表';

-- ----------------------------
-- Table structure for t_enterprise_user_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_enterprise_user_relation`;
CREATE TABLE `t_enterprise_user_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业唯一id',
  `position_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '职级id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `belong_type` int NOT NULL COMMENT '所属是否为主企业 0否 1是',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid_index` (`user_id`) USING BTREE,
  KEY `eid_index` (`enterprise_id`) USING BTREE,
  KEY `pid_index` (`position_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=203835 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='企业-用户关系表';

-- ----------------------------
-- Table structure for t_file_info
-- ----------------------------
DROP TABLE IF EXISTS `t_file_info`;
CREATE TABLE `t_file_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `MD5` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `file_path` varchar(1200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `file_name` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `FILE_SIZE` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `FILE_TYPE` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `CREATEUSER` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `md5` (`MD5`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7636 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='文件信息';

-- ----------------------------
-- Table structure for t_frozen_info
-- ----------------------------
DROP TABLE IF EXISTS `t_frozen_info`;
CREATE TABLE `t_frozen_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户id',
  `pool_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '资源池id',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100043 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='冻结';

-- ----------------------------
-- Table structure for t_function_info
-- ----------------------------
DROP TABLE IF EXISTS `t_function_info`;
CREATE TABLE `t_function_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `function_id` int NOT NULL COMMENT '功能id',
  `access_type` int NOT NULL COMMENT '1 需要菜单鉴权，2只需要token鉴权，3不需要鉴权',
  `match_type` tinyint NOT NULL DEFAULT '1' COMMENT '1 全匹配 2 模糊匹配',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `url_unique_index` (`url`) USING BTREE,
  UNIQUE KEY `function_id_index` (`function_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1856 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT=' 功能信息表';

-- ----------------------------
-- Table structure for t_group_info
-- ----------------------------
DROP TABLE IF EXISTS `t_group_info`;
CREATE TABLE `t_group_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `group_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分组唯一id',
  `group_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分组名',
  `group_type` int NOT NULL DEFAULT '0' COMMENT '0-自己创建的分组 1-默认分组不让删除',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `gid_index` (`group_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=58670 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='分组信息表';

-- ----------------------------
-- Table structure for t_group_info_import
-- ----------------------------
DROP TABLE IF EXISTS `t_group_info_import`;
CREATE TABLE `t_group_info_import` (
  `group_id` bigint NOT NULL AUTO_INCREMENT COMMENT '分组唯一id',
  `group_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分组名',
  `group_type` int NOT NULL DEFAULT '1' COMMENT '0-自己创建的分组 1-默认分组不让删除',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`group_id`) USING BTREE,
  KEY `gid_index` (`group_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=576428794923998697 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='分组信息表';

-- ----------------------------
-- Table structure for t_group_member_info
-- ----------------------------
DROP TABLE IF EXISTS `t_group_member_info`;
CREATE TABLE `t_group_member_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `group_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分组唯一id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `contact_remarks` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系人备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `gid_uid_index` (`group_id`,`user_id`) USING BTREE,
  KEY `creator_index` (`creator`) USING BTREE,
  KEY `gid_index` (`group_id`) USING BTREE,
  KEY `uid_index` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29084 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='分组成员信息表';

-- ----------------------------
-- Table structure for t_import_excel_template_format
-- ----------------------------
DROP TABLE IF EXISTS `t_import_excel_template_format`;
CREATE TABLE `t_import_excel_template_format` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `import_type` int DEFAULT NULL COMMENT '导入类型',
  `header_row_index` int DEFAULT NULL COMMENT '表头行号(从0开始)',
  `excel_field_order` int DEFAULT NULL COMMENT 'excel文件中的字段顺序',
  `excel_field_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'excel中文件的名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2801 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_import_task_config
-- ----------------------------
DROP TABLE IF EXISTS `t_import_task_config`;
CREATE TABLE `t_import_task_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_type` int DEFAULT NULL COMMENT '任务类型',
  `data_step` int DEFAULT NULL COMMENT '数据步长',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_import_task_info
-- ----------------------------
DROP TABLE IF EXISTS `t_import_task_info`;
CREATE TABLE `t_import_task_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '更新者',
  `task_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '任务名称',
  `task_type` int DEFAULT NULL COMMENT '任务类型，1-部门导入，2-部门成员关系导入，3-用户导入,4-设备导入',
  `task_status` int DEFAULT NULL COMMENT '任务状态',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '错误消息提示',
  `import_file_md5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '导入文件路径',
  `param` json DEFAULT NULL COMMENT '其它参数',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `import_file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '导入文件名称',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '企业ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_independence_department_user_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_independence_department_user_relation`;
CREATE TABLE `t_independence_department_user_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `department_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门唯一id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `user_sort` int DEFAULT '100' COMMENT '用户在独立部门内排序，空则排最后',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid_index` (`user_id`) USING BTREE,
  KEY `did_index` (`department_id`) USING BTREE,
  KEY `user_sort_index` (`user_sort`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='独立部门-用户关系表';

-- ----------------------------
-- Table structure for t_independence_department_user_relation_copy1
-- ----------------------------
DROP TABLE IF EXISTS `t_independence_department_user_relation_copy1`;
CREATE TABLE `t_independence_department_user_relation_copy1` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `department_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门唯一id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `user_sort` int DEFAULT '100' COMMENT '用户在独立部门内排序，空则排最后',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid_index` (`user_id`) USING BTREE,
  KEY `did_index` (`department_id`) USING BTREE,
  KEY `user_sort_index` (`user_sort`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='独立部门-用户关系表';

-- ----------------------------
-- Table structure for t_location_data
-- ----------------------------
DROP TABLE IF EXISTS `t_location_data`;
CREATE TABLE `t_location_data` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `latitude` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '纬度',
  `longitude` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '经度',
  `param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '其他参数',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户ID',
  `client_type` int DEFAULT NULL COMMENT '客户端类型',
  `device_type` int DEFAULT NULL COMMENT '设备类型',
  `login_type` int DEFAULT NULL COMMENT '登录类型',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index1` (`user_id`) USING BTREE,
  KEY `index2` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12241 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_manage_user_info
-- ----------------------------
DROP TABLE IF EXISTS `t_manage_user_info`;
CREATE TABLE `t_manage_user_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户唯一id',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户名',
  `phone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户手机号',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业id',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `type` int NOT NULL DEFAULT '1' COMMENT '1-非portal管理员 2-protal管理员',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新者',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid_index` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='管理用户信息表';

-- ----------------------------
-- Table structure for t_manufacturer_device_info
-- ----------------------------
DROP TABLE IF EXISTS `t_manufacturer_device_info`;
CREATE TABLE `t_manufacturer_device_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `unique_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '唯一id',
  `manufacturer_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属厂商唯一id',
  `device_model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '设备型号',
  `device_type` int NOT NULL COMMENT '1-软终端用户 2-avc设备（老式终端） 4-监控设备 5-svc设备（新式终端）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新者',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2064 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='厂商-设备信息表';

-- ----------------------------
-- Table structure for t_manufacturer_info
-- ----------------------------
DROP TABLE IF EXISTS `t_manufacturer_info`;
CREATE TABLE `t_manufacturer_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `manufacturer_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '厂商唯一id',
  `manufacturer_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '厂商名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新者',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，1-是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2046 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='厂商信息表';

-- ----------------------------
-- Table structure for t_menu_function_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_menu_function_relation`;
CREATE TABLE `t_menu_function_relation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `menu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '菜单id',
  `function_id` int DEFAULT NULL COMMENT '功能id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3439 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='菜单-功能权限关系表';

-- ----------------------------
-- Table structure for t_menu_info
-- ----------------------------
DROP TABLE IF EXISTS `t_menu_info`;
CREATE TABLE `t_menu_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `menu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '菜单id',
  `menu_level` int DEFAULT NULL COMMENT '菜单层级',
  `parent_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '父级uniqueId',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '菜单名',
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '描述',
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `system_type` int DEFAULT NULL COMMENT '系统类型 0：web页面菜单、1：app页面菜单',
  `rank` int DEFAULT NULL COMMENT '顺序',
  `status` int DEFAULT NULL COMMENT '状态 -1 删除 0-失效 1-生效',
  `menu_type` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=814 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='菜单表';

-- ----------------------------
-- Table structure for t_menu_role_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_menu_role_relation`;
CREATE TABLE `t_menu_role_relation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '角色id',
  `menu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '菜单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色-菜单关系表';

-- ----------------------------
-- Table structure for t_north_function_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_north_function_relation`;
CREATE TABLE `t_north_function_relation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品唯一id',
  `function_id` int DEFAULT NULL COMMENT '功能id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `product_function_index` (`product_id`,`function_id`) USING BTREE,
  KEY `product_index` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1839 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='北向产品-功能url关系表';

-- ----------------------------
-- Table structure for t_order_algorithm_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_order_algorithm_relation`;
CREATE TABLE `t_order_algorithm_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单id',
  `algorithm_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '算法id',
  `order_num` int DEFAULT NULL COMMENT '订购数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_id_index` (`order_id`) USING BTREE COMMENT 'order_id的索引',
  KEY `algorithm_id_index` (`algorithm_id`) USING BTREE COMMENT 'algorithm_id的索引'
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_order_function_info
-- ----------------------------
DROP TABLE IF EXISTS `t_order_function_info`;
CREATE TABLE `t_order_function_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `function_id` int NOT NULL COMMENT '功能id',
  `access_type` int NOT NULL COMMENT '1 需要菜单鉴权，2只需要token鉴权，3不需要鉴权',
  `match_type` tinyint NOT NULL DEFAULT '1' COMMENT '1 全匹配 2 模糊匹配',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `url_unique_index` (`url`) USING BTREE,
  UNIQUE KEY `function_id_index` (`function_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单功能信息表';

-- ----------------------------
-- Table structure for t_order_gen_hardware_account_rule_info
-- ----------------------------
DROP TABLE IF EXISTS `t_order_gen_hardware_account_rule_info`;
CREATE TABLE `t_order_gen_hardware_account_rule_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `month` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '月份',
  `start_step` int DEFAULT NULL COMMENT '开始步长',
  `end_step` int DEFAULT NULL COMMENT '结束步长',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `month_index` (`month`) USING BTREE COMMENT '月份索引'
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_order_gen_user_task_info
-- ----------------------------
DROP TABLE IF EXISTS `t_order_gen_user_task_info`;
CREATE TABLE `t_order_gen_user_task_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '订单id',
  `order_user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '订单的用户id',
  `algorithm_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '算法id',
  `order_number` int DEFAULT NULL COMMENT '账号数量',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '更新者',
  `task_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '任务名称',
  `task_type` int DEFAULT NULL COMMENT '任务类型，1-生成硬终端账号',
  `task_status` int DEFAULT NULL COMMENT '任务状态 1-未开始 2-开始生成中 3-生成异常 4-生成完成',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_id_index` (`order_id`) USING BTREE COMMENT '订单id唯一id索引'
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_order_info
-- ----------------------------
DROP TABLE IF EXISTS `t_order_info`;
CREATE TABLE `t_order_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户id',
  `pool_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '资源池id',
  `mode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '共享 独享类型',
  `measure_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '规格id',
  `end_time` bigint DEFAULT NULL COMMENT '订单结束时间',
  `usage_mode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '视频/图片',
  `scene_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '场景id',
  `spec_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '版本id',
  `extraction_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '提取规则id',
  `algorithms` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '算法列表',
  `deliver_status` int NOT NULL DEFAULT '0' COMMENT ' 0-未交付 1-交付成功 2-交付失败',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `orderId_index` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100181 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订购';

-- ----------------------------
-- Table structure for t_order_menu_function_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_order_menu_function_relation`;
CREATE TABLE `t_order_menu_function_relation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `menu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '菜单id',
  `function_id` int DEFAULT NULL COMMENT '功能id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='菜单-功能权限关系表';

-- ----------------------------
-- Table structure for t_order_menu_info
-- ----------------------------
DROP TABLE IF EXISTS `t_order_menu_info`;
CREATE TABLE `t_order_menu_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `menu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '菜单id',
  `menu_level` int DEFAULT NULL COMMENT '菜单层级',
  `parent_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '父级uniqueId',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '菜单名',
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '描述',
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `system_type` int DEFAULT NULL COMMENT '系统类型 0：web页面菜单、1：app页面菜单',
  `rank` int DEFAULT NULL COMMENT '顺序',
  `status` int DEFAULT NULL COMMENT '状态 -1 删除 0-失效 1-生效',
  `menu_type` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=817 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='菜单表';

-- ----------------------------
-- Table structure for t_order_menu_role_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_order_menu_role_relation`;
CREATE TABLE `t_order_menu_role_relation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '角色id',
  `menu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '菜单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色-菜单关系表';

-- ----------------------------
-- Table structure for t_order_role_info
-- ----------------------------
DROP TABLE IF EXISTS `t_order_role_info`;
CREATE TABLE `t_order_role_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `role_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名',
  `describe` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '角色描述',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '是否被删除',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='角色信息';

-- ----------------------------
-- Table structure for t_order_user_cloud_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_order_user_cloud_relation`;
CREATE TABLE `t_order_user_cloud_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单用户Id',
  `cloud_user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '云能用户id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid_index` (`user_id`) USING BTREE,
  KEY `eid_index` (`cloud_user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单用户-云能用户关系表';

-- ----------------------------
-- Table structure for t_order_user_enterprise_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_order_user_enterprise_relation`;
CREATE TABLE `t_order_user_enterprise_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业id',
  `order_user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单的用户id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_user_id_index` (`order_user_id`) USING BTREE COMMENT '订单用户唯一id索引'
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_order_user_info
-- ----------------------------
DROP TABLE IF EXISTS `t_order_user_info`;
CREATE TABLE `t_order_user_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `gender` int NOT NULL DEFAULT '1' COMMENT '性别 1-男 2-女',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业id',
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户手机号',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `is_first_login` int NOT NULL DEFAULT '0' COMMENT '是否第一次登录 0-是，1-否（用于首次登录强制密码修改）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新者',
  `data_source` int NOT NULL DEFAULT '0' COMMENT '数据来源',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `phone_index` (`phone`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单用户信息表';

-- ----------------------------
-- Table structure for t_order_user_role_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_order_user_role_relation`;
CREATE TABLE `t_order_user_role_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户唯一id',
  `role_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色id',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uid_rid_index` (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=60689 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户-角色关联表';

-- ----------------------------
-- Table structure for t_phone_affiliation_place
-- ----------------------------
DROP TABLE IF EXISTS `t_phone_affiliation_place`;
CREATE TABLE `t_phone_affiliation_place` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `phone_prefixer` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '号码前三位',
  `phone_section` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '号码段',
  `province` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '省份',
  `city` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市',
  `operator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所属运营商',
  `area_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市固话号码',
  `postcode` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '邮编',
  `administrative_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `unique_index` (`phone_section`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=480061 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='号码段表';

-- ----------------------------
-- Table structure for t_poc_enterprise_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_poc_enterprise_relation`;
CREATE TABLE `t_poc_enterprise_relation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `poc_enterprise_id` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '和对讲企业id',
  `enterprise_id` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='和对讲与视联会议企业映射关系';

-- ----------------------------
-- Table structure for t_position_info
-- ----------------------------
DROP TABLE IF EXISTS `t_position_info`;
CREATE TABLE `t_position_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '职级所属企业唯一id',
  `position_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '职级唯一id',
  `position_code` int DEFAULT NULL COMMENT '职级代码',
  `position_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '职级名称',
  `position_level` int NOT NULL DEFAULT '7' COMMENT '职级级别 1最大，往后降低',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pid_index` (`position_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='企业-职级信息表';

-- ----------------------------
-- Table structure for t_product_certificate_authentication_url
-- ----------------------------
DROP TABLE IF EXISTS `t_product_certificate_authentication_url`;
CREATE TABLE `t_product_certificate_authentication_url` (
  `id` int NOT NULL AUTO_INCREMENT,
  `function_id` int NOT NULL COMMENT '功能id',
  `type` int NOT NULL DEFAULT '1' COMMENT '服务访问类型 1-普通凭证鉴权 2-服务凭证式访问',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `functionId_index` (`function_id`,`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1956 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='能力开放产品凭证鉴权url';

-- ----------------------------
-- Table structure for t_product_secret_info
-- ----------------------------
DROP TABLE IF EXISTS `t_product_secret_info`;
CREATE TABLE `t_product_secret_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `product_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品唯一id',
  `north_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '北向产品名',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属企业id',
  `aes_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '对应aes密钥',
  `take_effect` int NOT NULL DEFAULT '0' COMMENT '是否生效 0-生效 1-不生效',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '描述',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  `type` int NOT NULL DEFAULT '1' COMMENT '产品类型 1-密码鉴权 2-凭证鉴权',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_index` (`product_id`) USING BTREE,
  KEY `north_name_index` (`north_name`) USING BTREE,
  KEY `enterprise_index` (`enterprise_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='产品id-密钥对应表';

-- ----------------------------
-- Table structure for t_province_city_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `t_province_city_dictionary`;
CREATE TABLE `t_province_city_dictionary` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '唯一编号',
  `area_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '省市区code',
  `area_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '省市区名称',
  `parent_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '父级code',
  `area_type` int NOT NULL COMMENT '省市区类型 1-省 2-市 3-区',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3636 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='省市区县字典表';

-- ----------------------------
-- Table structure for t_recover_info
-- ----------------------------
DROP TABLE IF EXISTS `t_recover_info`;
CREATE TABLE `t_recover_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户id',
  `pool_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '资源池id',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100045 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='恢复';

-- ----------------------------
-- Table structure for t_role_function_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_role_function_relation`;
CREATE TABLE `t_role_function_relation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '角色id',
  `function_id` int DEFAULT NULL COMMENT '功能id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `role_function_index` (`role_id`,`function_id`) USING BTREE COMMENT '角色、功能id唯一索引'
) ENGINE=InnoDB AUTO_INCREMENT=4243 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色-功能权限关系表';

-- ----------------------------
-- Table structure for t_role_info
-- ----------------------------
DROP TABLE IF EXISTS `t_role_info`;
CREATE TABLE `t_role_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `role_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名',
  `describe` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '角色描述',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '是否被删除',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='角色信息';

-- ----------------------------
-- Table structure for t_sensitive_dict
-- ----------------------------
DROP TABLE IF EXISTS `t_sensitive_dict`;
CREATE TABLE `t_sensitive_dict` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `sensitive_word` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '敏感词',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10251 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_short_message_config
-- ----------------------------
DROP TABLE IF EXISTS `t_short_message_config`;
CREATE TABLE `t_short_message_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '唯一编号',
  `code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '唯一code',
  `type` int DEFAULT NULL COMMENT '配置类型，1-模板id，2-签名id',
  `value` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '配置值',
  `description` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '模板描述',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='短信模板及签名配置';

-- ----------------------------
-- Table structure for t_software_ios_url
-- ----------------------------
DROP TABLE IF EXISTS `t_software_ios_url`;
CREATE TABLE `t_software_ios_url` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `software_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属软件类型',
  `url` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'url',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `unique_index` (`software_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='ios下载url地址映射表';

-- ----------------------------
-- Table structure for t_software_type
-- ----------------------------
DROP TABLE IF EXISTS `t_software_type`;
CREATE TABLE `t_software_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `unique_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '唯一id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '类型名称',
  `type` int NOT NULL COMMENT '1-大网平台 2-云南项目',
  `describe` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '描述',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '是否被删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新者',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `unique_index` (`unique_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='软件类型信息';

-- ----------------------------
-- Table structure for t_software_version_management
-- ----------------------------
DROP TABLE IF EXISTS `t_software_version_management`;
CREATE TABLE `t_software_version_management` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `unique_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '软件版本唯一id',
  `system_type` int NOT NULL COMMENT '系统类型 1-安卓 2-ios 3-windows 4-mac 5-svc',
  `version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '版本号',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `package_url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `md5` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '文件MD5',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新者',
  `size` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `release_status` int NOT NULL DEFAULT '0' COMMENT '发布状态 0-未发布 1-发布',
  `force_update` int NOT NULL DEFAULT '0' COMMENT '是否强制更新 1 是 0 否',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  `belong_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属类型 默认大网平台',
  `belong_device_model` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '系统类型为svc时，对应的设备型号唯一id',
  `version_comparable` char(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '可比较大小的version字符串',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `st_index` (`system_type`) USING BTREE,
  KEY `v_index` (`version`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='软件管理';

-- ----------------------------
-- Table structure for t_statistic_import_task_info
-- ----------------------------
DROP TABLE IF EXISTS `t_statistic_import_task_info`;
CREATE TABLE `t_statistic_import_task_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `creator` int DEFAULT NULL COMMENT ' 创建者',
  `updater` int DEFAULT NULL COMMENT '更新者',
  `task_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务名称',
  `task_type` int DEFAULT NULL COMMENT '任务类型',
  `task_status` int DEFAULT NULL COMMENT '任务状态',
  `error_message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '错误消息提示',
  `param` json DEFAULT NULL COMMENT '其它参数',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `import_file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '导入文件名称',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '企业ID',
  `department_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '部门ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=272 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_temp_check_unique_data_3_1723556271425
-- ----------------------------
DROP TABLE IF EXISTS `t_temp_check_unique_data_3_1723556271425`;
CREATE TABLE `t_temp_check_unique_data_3_1723556271425` (
  `user_account` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `department_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `department_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `order_index` int DEFAULT NULL,
  `authority_level` int DEFAULT NULL,
  `sex` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `position` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `line_index` int DEFAULT NULL,
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `device_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  KEY `phone_index` (`user_account`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_unsubscribe_info
-- ----------------------------
DROP TABLE IF EXISTS `t_unsubscribe_info`;
CREATE TABLE `t_unsubscribe_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户id',
  `pool_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '资源池id',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100048 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='退订';

-- ----------------------------
-- Table structure for t_user_file
-- ----------------------------
DROP TABLE IF EXISTS `t_user_file`;
CREATE TABLE `t_user_file` (
  `pid` int NOT NULL AUTO_INCREMENT,
  `id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `file_md5` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `UPLOAD_TYPE` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `INFO_NAME` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`pid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9973 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='用户文件';

-- ----------------------------
-- Table structure for t_user_info
-- ----------------------------
DROP TABLE IF EXISTS `t_user_info`;
CREATE TABLE `t_user_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户唯一id',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `gender` int NOT NULL DEFAULT '1' COMMENT '性别 1-男 2-女',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `picture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '头像',
  `enterprise_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业id',
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户手机号',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `position` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '职位等级',
  `is_first_login` int NOT NULL DEFAULT '0' COMMENT '是否第一次登录 0-是，1-否（用于首次登录强制密码修改）',
  `authority_level` int NOT NULL DEFAULT '5' COMMENT '会控等级 1-10，默认5',
  `user_type` int NOT NULL DEFAULT '0' COMMENT '用户类型 0-普通用户 1-企业用户',
  `type` int NOT NULL DEFAULT '1' COMMENT '1-软终端用户 2-硬终端用户 3-rooms用户',
  `province_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '省份编码',
  `province_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '省份名称',
  `city_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '城市编码',
  `city_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '城市名称',
  `device_type` int DEFAULT '1' COMMENT '1-软终端用户 2-avc设备(老式终端) 3-和对讲设备 4-监控设备 5-svc设备(新式终端) 6-千里眼设备',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新者',
  `data_source` int NOT NULL DEFAULT '0' COMMENT '数据来源(1-boos对接 2-管理平台导入 3-云能平台自动生成 4-订单平台新增 5-订单平台导入 6-灾情会商自注册的用户 7-视联会议自注册的用户)',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  `is_lock` int NOT NULL DEFAULT '0' COMMENT '0-否，其他-是',
  `param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '其他参数',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `phone_index` (`phone`) USING BTREE,
  KEY `uid_index` (`user_id`) USING BTREE,
  KEY `id_index` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37103344 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户信息表';

-- ----------------------------
-- Table structure for t_user_meeting_config
-- ----------------------------
DROP TABLE IF EXISTS `t_user_meeting_config`;
CREATE TABLE `t_user_meeting_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '唯一编号',
  `user_id` int NOT NULL COMMENT '用户ID',
  `msg_switch` int NOT NULL DEFAULT '2' COMMENT '2关闭 1开启 因之前配置都是1开 2关 故如此定义',
  `speaker_switch` int NOT NULL DEFAULT '1' COMMENT '1开启 2关闭',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户会议配置';

-- ----------------------------
-- Table structure for t_user_role_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_user_role_relation`;
CREATE TABLE `t_user_role_relation` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户唯一id',
  `role_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色id',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新用户id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uid_rid_index` (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=171701 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户-角色关联表';

-- ----------------------------
-- Table structure for t_video_algo_url
-- ----------------------------
DROP TABLE IF EXISTS `t_video_algo_url`;
CREATE TABLE `t_video_algo_url` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `algo_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '算法id',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '算法对应分析的url',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100207 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='视频算法url对照表';

-- ----------------------------
-- Table structure for t_video_task
-- ----------------------------
DROP TABLE IF EXISTS `t_video_task`;
CREATE TABLE `t_video_task` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `task_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '唯一任务id',
  `algo_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '算法id',
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `whetherPicUrl` int NOT NULL DEFAULT '0' COMMENT '是否返回算法分析后的图片url地址 0-否 1-是',
  `whetherPicData` int NOT NULL DEFAULT '0' COMMENT '是否返回算法分析后的Base64图片数据 0-否 1-是',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '预留业务字段',
  `kafka_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '报警kafka回调地址',
  `topic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '数据写入单元',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `task_index` (`task_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100202 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='视频任务';

-- ----------------------------
-- Table structure for t_video_task_device_info
-- ----------------------------
DROP TABLE IF EXISTS `t_video_task_device_info`;
CREATE TABLE `t_video_task_device_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `task_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '唯一任务id',
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '设备id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '设备name',
  `interval` int DEFAULT NULL COMMENT '算法分析间隔（ms）',
  `callback_interval` int DEFAULT NULL COMMENT '报警上传间隔（s）',
  `algo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs COMMENT '算法可配参数',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC COMMENT='视频任务设备映射';

-- ----------------------------
-- Table structure for t_video_task_image_info
-- ----------------------------
DROP TABLE IF EXISTS `t_video_task_image_info`;
CREATE TABLE `t_video_task_image_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `image_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片唯一Id',
  `algo_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '算法id',
  `ret_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '图片url',
  `ret_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT 'base64',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '图片path',
  `is_alert` int DEFAULT NULL COMMENT '报警标识，1true告警，0false不告警',
  `event_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '事件类型，默认为空',
  `target_count` int DEFAULT NULL COMMENT 'target_count',
  `start` int DEFAULT NULL COMMENT '开始时间 秒数',
  `end` int DEFAULT NULL COMMENT '结束时间 秒数',
  `duration` int DEFAULT NULL COMMENT '视频时长',
  `base_code` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100210 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC COMMENT='图片表';

-- ----------------------------
-- Table structure for t_video_task_mode_data
-- ----------------------------
DROP TABLE IF EXISTS `t_video_task_mode_data`;
CREATE TABLE `t_video_task_mode_data` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `image_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片唯一Id',
  `x` int DEFAULT NULL COMMENT 'x',
  `y` int DEFAULT NULL COMMENT 'y',
  `width` int DEFAULT NULL COMMENT 'width',
  `height` int DEFAULT NULL COMMENT 'height',
  `confidence` double(255,0) DEFAULT NULL COMMENT '置信度',
  `person_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT 'person_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100204 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC COMMENT='图片ModeObjectsDto表';

-- ----------------------------
-- Table structure for t_video_task_target_info
-- ----------------------------
DROP TABLE IF EXISTS `t_video_task_target_info`;
CREATE TABLE `t_video_task_target_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `image_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片唯一Id',
  `x` int DEFAULT NULL COMMENT 'x',
  `y` int DEFAULT NULL COMMENT 'y',
  `width` int DEFAULT NULL COMMENT 'width',
  `height` int DEFAULT NULL COMMENT 'height',
  `confidence` double DEFAULT NULL COMMENT '置信度',
  `person_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT 'person_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC COMMENT='图片target_info表';

-- ----------------------------
-- View structure for view_org_info
-- ----------------------------
DROP VIEW IF EXISTS `view_org_info`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_org_info` AS select `t_province_city_dictionary`.`area_code` AS `ORG_ID`,`t_province_city_dictionary`.`area_name` AS `ORG_NAME`,`t_province_city_dictionary`.`parent_code` AS `PARENT_ORG_ID` from `t_province_city_dictionary`;

-- ----------------------------
-- View structure for view_user_info
-- ----------------------------
DROP VIEW IF EXISTS `view_user_info`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_user_info` AS select `t_manage_user_info`.`user_id` AS `USER_ID`,`t_manage_user_info`.`phone` AS `LOGIN_NO`,`t_manage_user_info`.`user_name` AS `USER_NAME`,`t_manage_user_info`.`phone` AS `MOBILE`,`t_manage_user_info`.`password` AS `PASSWORD`,`t_manage_user_info`.`email` AS `EMAIL`,NULL AS `ORG_ID`,`t_manage_user_info`.`create_time` AS `EFFECT_DATE`,'2099-12-31 00:00:00' AS `EXPIRE_DATE`,NULL AS `APP_ACCT_DESC`,'1' AS `APP_ACCT_STATUS` from `t_manage_user_info`;

SET FOREIGN_KEY_CHECKS = 1;

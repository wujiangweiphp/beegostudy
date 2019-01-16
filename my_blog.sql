/*
Navicat MySQL Data Transfer

Source Server         : 127.0.0.1
Source Server Version : 50723
Source Host           : localhost:3306
Source Database       : my_blog

Target Server Type    : MYSQL
Target Server Version : 50723
File Encoding         : 65001

Date: 2019-01-16 14:32:53
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for leave_message
-- ----------------------------
DROP TABLE IF EXISTS `leave_message`;
CREATE TABLE `leave_message` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '来自用户表user的id',
  `content` text NOT NULL COMMENT '留言内容',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '是否展示 0 否 1是',
  `create_at` datetime NOT NULL COMMENT '创建时间',
  `update_at` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='留言表';

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

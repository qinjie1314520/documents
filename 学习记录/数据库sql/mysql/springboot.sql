/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80012
 Source Host           : localhost:3306
 Source Schema         : springboot

 Target Server Type    : MySQL
 Target Server Version : 80012
 File Encoding         : 65001

 Date: 21/06/2019 15:55:36
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_clazz
-- ----------------------------
DROP TABLE IF EXISTS `tb_clazz`;
CREATE TABLE `tb_clazz`  (
  `code` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_clazz
-- ----------------------------
INSERT INTO `tb_clazz` VALUES (1, '疯狂java开发1班');
INSERT INTO `tb_clazz` VALUES (2, '疯狂java开发2班');

-- ----------------------------
-- Table structure for tb_resource
-- ----------------------------
DROP TABLE IF EXISTS `tb_resource`;
CREATE TABLE `tb_resource`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `url` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `pid` int(11) NOT NULL,
  `type` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_resource
-- ----------------------------
INSERT INTO `tb_resource` VALUES (1, '主页', '/home', 0, 1);

-- ----------------------------
-- Table structure for tb_role
-- ----------------------------
DROP TABLE IF EXISTS `tb_role`;
CREATE TABLE `tb_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_role
-- ----------------------------
INSERT INTO `tb_role` VALUES (1, '超级管理员');
INSERT INTO `tb_role` VALUES (2, '用户');
INSERT INTO `tb_role` VALUES (3, '普通管理员');

-- ----------------------------
-- Table structure for tb_role_resource
-- ----------------------------
DROP TABLE IF EXISTS `tb_role_resource`;
CREATE TABLE `tb_role_resource`  (
  `role_id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  PRIMARY KEY (`role_id`, `resource_id`) USING BTREE,
  INDEX `FK868kc8iic48ilv5npa80ut6qo`(`resource_id`) USING BTREE,
  CONSTRAINT `FK7ffc7h6obqxflhj1aq1mk20jk` FOREIGN KEY (`role_id`) REFERENCES `tb_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK868kc8iic48ilv5npa80ut6qo` FOREIGN KEY (`resource_id`) REFERENCES `tb_resource` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_role_resource
-- ----------------------------
INSERT INTO `tb_role_resource` VALUES (1, 1);
INSERT INTO `tb_role_resource` VALUES (2, 1);

-- ----------------------------
-- Table structure for tb_student
-- ----------------------------
DROP TABLE IF EXISTS `tb_student`;
CREATE TABLE `tb_student`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `age` int(11) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `clazz_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FKlqx2qumdhib2axsrl0i24f6a9`(`clazz_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_student
-- ----------------------------
INSERT INTO `tb_student` VALUES (1, '广州', 700, '孙悟空', '男', 1);
INSERT INTO `tb_student` VALUES (2, '广州', 700, '蜘蛛精', '女', 1);
INSERT INTO `tb_student` VALUES (3, '广州', 500, '牛魔王', '男', 1);
INSERT INTO `tb_student` VALUES (5, '2', 2, '2', '男', 2);
INSERT INTO `tb_student` VALUES (6, '3', 3, '2', '男', 2);
INSERT INTO `tb_student` VALUES (7, '7', 7, '7', '男', 2);
INSERT INTO `tb_student` VALUES (8, '8', 8, '8', '男', 1);

-- ----------------------------
-- Table structure for tb_user
-- ----------------------------
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_user
-- ----------------------------
INSERT INTO `tb_user` VALUES (1, 'fkit', '123');
INSERT INTO `tb_user` VALUES (2, 'admin', 'admin');
INSERT INTO `tb_user` VALUES (3, '徐磊', '$2a$10$VgFGmXCoM0eJE45Ej4aOEeEFD6kvemnd2HFXhcmMherTQGZW0rZw.');
INSERT INTO `tb_user` VALUES (4, '徐磊', NULL);
INSERT INTO `tb_user` VALUES (6, 'qinjie', '1314520');
INSERT INTO `tb_user` VALUES (8, '徐磊', NULL);
INSERT INTO `tb_user` VALUES (9, '9', '9');
INSERT INTO `tb_user` VALUES (10, '10', '10');
INSERT INTO `tb_user` VALUES (11, '1', '1');
INSERT INTO `tb_user` VALUES (12, '12', '12');
INSERT INTO `tb_user` VALUES (13, '13', '15');
INSERT INTO `tb_user` VALUES (14, '14', '15');
INSERT INTO `tb_user` VALUES (15, '15', '15');
INSERT INTO `tb_user` VALUES (16, 'qinjie', '1314520');
INSERT INTO `tb_user` VALUES (100, 'ahha', '456');
INSERT INTO `tb_user` VALUES (111, '1', '1');
INSERT INTO `tb_user` VALUES (112, 'hello', 'world');
INSERT INTO `tb_user` VALUES (113, 'hello', 'world');
INSERT INTO `tb_user` VALUES (114, 'hello', 'world');
INSERT INTO `tb_user` VALUES (115, 'hello', 'world');
INSERT INTO `tb_user` VALUES (116, 'h', 'e');
INSERT INTO `tb_user` VALUES (117, 'l', 'l');
INSERT INTO `tb_user` VALUES (118, 'o', 'w');
INSERT INTO `tb_user` VALUES (119, '9', 'as');
INSERT INTO `tb_user` VALUES (120, '100', '100');

-- ----------------------------
-- Table structure for tb_user_role
-- ----------------------------
DROP TABLE IF EXISTS `tb_user_role`;
CREATE TABLE `tb_user_role`  (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE,
  INDEX `FKea2ootw6b6bb0xt3ptl28bymv`(`role_id`) USING BTREE,
  CONSTRAINT `FK7vn3h53d0tqdimm8cp45gc0kl` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKea2ootw6b6bb0xt3ptl28bymv` FOREIGN KEY (`role_id`) REFERENCES `tb_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_user_role
-- ----------------------------
INSERT INTO `tb_user_role` VALUES (2, 1);
INSERT INTO `tb_user_role` VALUES (1, 2);
INSERT INTO `tb_user_role` VALUES (1, 3);
INSERT INTO `tb_user_role` VALUES (3, 3);

SET FOREIGN_KEY_CHECKS = 1;

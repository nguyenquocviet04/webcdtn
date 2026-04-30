CREATE DATABASE IF NOT EXISTS expense_management;
USE expense_management;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('cash','bank','e_wallet','credit_card') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cash',
  `balance` decimal(15,2) NOT NULL DEFAULT '0.00',
  `color` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#6366f1',
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Wallet',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_accounts_user_id` (`user_id`),
  CONSTRAINT `fk_accounts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,1,'Tien mat','cash',2000000.00,'#f59e0b','Wallet',1,'2026-04-17 15:35:21'),(2,1,'MB Bank','bank',15000000.00,'#2563eb','CreditCard',0,'2026-04-17 15:35:21'),(3,1,'MoMo','e_wallet',500000.00,'#a855f7','Smartphone',0,'2026-04-17 15:35:21');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `ai_conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_conversations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Cuộc trò chuyện mới',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ai_conv_user_id` (`user_id`),
  KEY `idx_ai_conv_updated` (`updated_at`),
  CONSTRAINT `fk_ai_conv_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `ai_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_messages` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `conversation_id` int unsigned NOT NULL,
  `role` enum('user','assistant') COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ai_msg_conversation_id` (`conversation_id`),
  KEY `idx_ai_msg_created_at` (`created_at`),
  CONSTRAINT `fk_ai_msg_conversation` FOREIGN KEY (`conversation_id`) REFERENCES `ai_conversations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `budgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `budgets` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `category_id` int unsigned NOT NULL,
  `amount_limit` decimal(15,2) NOT NULL,
  `month` tinyint NOT NULL COMMENT '1-12',
  `year` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_budget_user_cat_month_year` (`user_id`,`category_id`,`month`,`year`),
  KEY `fk_budgets_category` (`category_id`),
  KEY `idx_budgets_user_month_year` (`user_id`,`month`,`year`),
  CONSTRAINT `fk_budgets_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_budgets_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `budgets` WRITE;
/*!40000 ALTER TABLE `budgets` DISABLE KEYS */;
INSERT INTO `budgets` VALUES (1,1,1,3000000.00,4,2026,'2026-04-17 15:35:22'),(2,1,3,2000000.00,4,2026,'2026-04-17 15:35:22'),(3,1,2,1000000.00,4,2026,'2026-04-17 15:35:22'),(4,1,4,500000.00,4,2026,'2026-04-17 15:35:22'),(5,1,5,1500000.00,4,2026,'2026-04-17 15:35:22'),(6,1,8,2000000.00,4,2026,'2026-04-24 18:33:45');
/*!40000 ALTER TABLE `budgets` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT NULL,
  `parent_id` int unsigned DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('income','expense') COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Tag',
  `color` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#6366f1',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_categories_parent` (`parent_id`),
  KEY `idx_categories_user_id` (`user_id`),
  KEY `idx_categories_type` (`type`),
  KEY `idx_categories_is_default` (`is_default`),
  CONSTRAINT `fk_categories_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_categories_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,NULL,NULL,'Ăn uống','expense','UtensilsCrossed','#f59e0b',1),(2,NULL,NULL,'Di chuyển','expense','Car','#3b82f6',1),(3,NULL,NULL,'Mua sắm','expense','ShoppingBag','#ec4899',1),(4,NULL,NULL,'Giải trí','expense','Gamepad2','#8b5cf6',1),(5,NULL,NULL,'Sức khỏe','expense','HeartPulse','#ef4444',1),(6,NULL,NULL,'Giáo dục','expense','BookOpen','#06b6d4',1),(7,NULL,NULL,'Hóa đơn','expense','FileText','#64748b',1),(8,NULL,NULL,'Nhà ở','expense','Home','#10b981',1),(9,NULL,NULL,'Làm đẹp','expense','Sparkles','#f43f5e',1),(10,NULL,NULL,'Du lịch','expense','Plane','#0ea5e9',1),(11,NULL,NULL,'Quà tặng','expense','Gift','#a855f7',1),(12,NULL,NULL,'Chi khác','expense','MoreHorizontal','#94a3b8',1),(13,NULL,NULL,'Lương','income','Banknote','#22c55e',1),(14,NULL,NULL,'Thưởng','income','Trophy','#f59e0b',1),(15,NULL,NULL,'Đầu tư','income','TrendingUp','#3b82f6',1),(16,NULL,NULL,'Freelance','income','Laptop','#8b5cf6',1),(17,NULL,NULL,'Quà nhận','income','Gift','#ec4899',1),(18,NULL,NULL,'Thu khác','income','PlusCircle','#94a3b8',1);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `financial_health_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financial_health_scores` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `month` tinyint NOT NULL COMMENT '1-12',
  `year` int NOT NULL,
  `total_score` int NOT NULL DEFAULT '0',
  `grade` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `score_savings` int DEFAULT '0',
  `score_budget` int DEFAULT '0',
  `score_stability` int DEFAULT '0',
  `score_diversity` int DEFAULT '0',
  `score_trend` int DEFAULT '0',
  `savings_rate` decimal(5,2) DEFAULT '0.00',
  `cv_value` decimal(5,2) DEFAULT '0.00',
  `income_sources` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_month_year` (`user_id`,`month`,`year`),
  KEY `idx_health_user_id` (`user_id`),
  CONSTRAINT `fk_health_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `financial_health_scores` WRITE;
/*!40000 ALTER TABLE `financial_health_scores` DISABLE KEYS */;
INSERT INTO `financial_health_scores` VALUES (1,1,4,2026,75,'Tốt',30,25,5,15,0,45.00,119.00,4,'2026-04-24 12:04:27','2026-04-24 12:31:38');
/*!40000 ALTER TABLE `financial_health_scores` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `method_allocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `method_allocations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `method_id` int NOT NULL,
  `label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage` decimal(5,2) NOT NULL,
  `color` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '#2563eb',
  `sort_order` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `method_id` (`method_id`),
  CONSTRAINT `method_allocations_ibfk_1` FOREIGN KEY (`method_id`) REFERENCES `spending_methods` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `method_allocations` WRITE;
/*!40000 ALTER TABLE `method_allocations` DISABLE KEYS */;
INSERT INTO `method_allocations` VALUES (1,1,'Nhu cầu thiết yếu',50.00,'#2563EB',1),(2,1,'Mong muốn & Giải trí',30.00,'#7C3AED',2),(3,1,'Tiết kiệm & Đầu tư',20.00,'#16A34A',3),(4,2,'Chi tiêu thiết yếu',55.00,'#2563EB',1),(5,2,'Tự do tài chính',10.00,'#16A34A',2),(6,2,'Giáo dục & Phát triển',10.00,'#D97706',3),(7,2,'Hưởng thụ',10.00,'#EC4899',4),(8,2,'Tiết kiệm dài hạn',10.00,'#059669',5),(9,2,'Từ thiện & Đóng góp',5.00,'#DC2626',6),(10,3,'Chi tiêu cuộc sống',70.00,'#2563EB',1),(11,3,'Tiết kiệm & Đầu tư',20.00,'#16A34A',2),(12,3,'Trả nợ & Từ thiện',10.00,'#D97706',3);
/*!40000 ALTER TABLE `method_allocations` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('budget_warning','recurring','system','transfer') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `related_id` int DEFAULT NULL COMMENT 'ID liên quan (transaction_id, budget_id...)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_user_id` (`user_id`),
  KEY `idx_notifications_is_read` (`is_read`),
  KEY `idx_notifications_user_read` (`user_id`,`is_read`),
  KEY `idx_notifications_created` (`created_at`),
  CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,1,'Chào mừng!','Chào mừng bạn đến với Web Quản Lý Chi Tiêu. Hãy bắt đầu theo dõi chi tiêu của bạn ngay!','system',0,NULL,'2026-04-17 15:35:22'),(2,1,'Ngân sách Ăn uống gần đạt giới hạn','Bạn đã chi 73% ngân sách Ăn uống tháng này. Hãy cân nhắc chi tiêu!','budget_warning',0,NULL,'2026-04-17 15:35:22');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `recurring_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recurring_transactions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `account_id` int unsigned NOT NULL,
  `category_id` int unsigned NOT NULL,
  `type` enum('income','expense') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `frequency` enum('daily','weekly','monthly','yearly') COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `next_date` date NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_recurring_account` (`account_id`),
  KEY `fk_recurring_category` (`category_id`),
  KEY `idx_recurring_user_id` (`user_id`),
  KEY `idx_recurring_next_date` (`next_date`),
  KEY `idx_recurring_is_active` (`is_active`),
  CONSTRAINT `fk_recurring_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_recurring_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_recurring_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `recurring_transactions` WRITE;
/*!40000 ALTER TABLE `recurring_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `recurring_transactions` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `spending_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spending_methods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `icon` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 0xF09F938A,
  `is_system` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `spending_methods_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `spending_methods` WRITE;
/*!40000 ALTER TABLE `spending_methods` DISABLE KEYS */;
INSERT INTO `spending_methods` VALUES (1,NULL,'Quy tắc 50/30/20','Phân chia thu nhập thành 3 nhóm: Nhu cầu thiết yếu (50%), Mong muốn (30%) và Tiết kiệm (20%). Lý tưởng cho người mới bắt đầu quản lý tài chính.','🍕',1,'2026-04-24 18:12:37'),(2,NULL,'Quy tắc 6 chiếc lọ','Chia thu nhập vào 6 lọ với mục đích rõ ràng, giúp cân bằng giữa chi tiêu hiện tại và tương lai tài chính.','🍯',1,'2026-04-24 18:12:37'),(3,NULL,'Quy tắc 70/20/10','Đơn giản hoá tài chính cá nhân: 70% chi tiêu cuộc sống, 20% tiết kiệm & đầu tư, 10% trả nợ hoặc từ thiện.','📊',1,'2026-04-24 18:12:37');
/*!40000 ALTER TABLE `spending_methods` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `account_id` int unsigned NOT NULL,
  `category_id` int unsigned NOT NULL,
  `type` enum('income','expense') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `note` text COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_transactions_user_id` (`user_id`),
  KEY `idx_transactions_account_id` (`account_id`),
  KEY `idx_transactions_category_id` (`category_id`),
  KEY `idx_transactions_date` (`transaction_date`),
  KEY `idx_transactions_user_date` (`user_id`,`transaction_date`),
  KEY `idx_transactions_user_type` (`user_id`,`type`),
  KEY `idx_transactions_user_cat_date` (`user_id`,`category_id`,`transaction_date`),
  CONSTRAINT `fk_transactions_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_transactions_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_transactions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,1,2,13,'income',12000000.00,'Lương tháng',NULL,NULL,'2026-02-01','2026-04-17 15:35:22'),(2,1,2,1,'expense',850000.00,'Ăn uống cả tháng',NULL,NULL,'2026-02-05','2026-04-17 15:35:22'),(3,1,1,2,'expense',300000.00,'Đi lại tháng',NULL,NULL,'2026-02-08','2026-04-17 15:35:22'),(4,1,2,7,'expense',1200000.00,'Tiền điện nước',NULL,NULL,'2026-02-10','2026-04-17 15:35:22'),(5,1,2,8,'expense',3000000.00,'Tiền thuê nhà',NULL,NULL,'2026-02-01','2026-04-17 15:35:22'),(6,1,1,3,'expense',650000.00,'Mua đồ dùng',NULL,NULL,'2026-02-15','2026-04-17 15:35:22'),(7,1,2,5,'expense',500000.00,'Khám sức khỏe',NULL,NULL,'2026-02-20','2026-04-17 15:35:22'),(8,1,2,16,'income',2000000.00,'Thu nhập thêm',NULL,NULL,'2026-02-25','2026-04-17 15:35:22'),(9,1,2,13,'income',12000000.00,'Lương tháng',NULL,NULL,'2026-03-01','2026-04-17 15:35:22'),(10,1,2,14,'income',1500000.00,'Thưởng hoàn thành dự án',NULL,NULL,'2026-03-05','2026-04-17 15:35:22'),(11,1,1,1,'expense',85000.00,'Cơm trưa văn phòng',NULL,NULL,'2026-03-02','2026-04-17 15:35:22'),(12,1,1,1,'expense',120000.00,'Coffee với đồng nghiệp',NULL,NULL,'2026-03-04','2026-04-17 15:35:22'),(13,1,2,3,'expense',350000.00,'Mua áo H&M',NULL,NULL,'2026-03-06','2026-04-17 15:35:22'),(14,1,3,2,'expense',200000.00,'Grab đi làm cả tuần',NULL,NULL,'2026-03-08','2026-04-17 15:35:22'),(15,1,2,7,'expense',1200000.00,'Tiền điện tháng',NULL,NULL,'2026-03-10','2026-04-17 15:35:22'),(16,1,1,4,'expense',450000.00,'Netflix + Spotify',NULL,NULL,'2026-03-12','2026-04-17 15:35:22'),(17,1,2,8,'expense',3000000.00,'Tiền thuê nhà tháng',NULL,NULL,'2026-03-01','2026-04-17 15:35:22'),(18,1,1,1,'expense',250000.00,'Đi ăn sinh nhật bạn',NULL,NULL,'2026-03-14','2026-04-17 15:35:22'),(19,1,2,5,'expense',800000.00,'Khám sức khỏe định kỳ',NULL,NULL,'2026-03-16','2026-04-17 15:35:22'),(20,1,2,6,'expense',180000.00,'Mua sách Atomic Habits',NULL,NULL,'2026-03-18','2026-04-17 15:35:22'),(21,1,3,9,'expense',300000.00,'Cắt tóc + dưỡng da',NULL,NULL,'2026-03-20','2026-04-17 15:35:22'),(22,1,2,15,'income',1000000.00,'Cổ tức chứng khoán',NULL,NULL,'2026-03-22','2026-04-17 15:35:22'),(23,1,2,10,'expense',500000.00,'Đặt vé xe đi Đà Lạt',NULL,NULL,'2026-03-24','2026-04-17 15:35:22'),(24,1,2,16,'income',2500000.00,'Dự án thiết kế web',NULL,NULL,'2026-03-26','2026-04-17 15:35:22'),(25,1,2,13,'income',12000000.00,'Lương tháng này','',NULL,'2026-04-01','2026-04-17 15:35:22'),(26,1,2,8,'expense',3000000.00,'Tiền thuê nhà','',NULL,'2026-04-01','2026-04-17 15:35:22'),(27,1,1,1,'expense',85000.00,'Cơm trưa văn phòng','',NULL,'2026-04-16','2026-04-17 15:35:22'),(28,1,2,3,'expense',350000.00,'Mua áo H&M','Sale 30%',NULL,'2026-04-15','2026-04-17 15:35:22'),(29,1,3,2,'expense',200000.00,'Grab đi làm cả tuần','',NULL,'2026-04-14','2026-04-17 15:35:22'),(30,1,2,7,'expense',1200000.00,'Tiền điện tháng','',NULL,'2026-04-14','2026-04-17 15:35:22'),(31,1,1,4,'expense',450000.00,'Netflix + Spotify','Gia hạn 3 tháng',NULL,'2026-04-13','2026-04-17 15:35:22'),(32,1,2,16,'income',2500000.00,'Dự án thiết kế web','',NULL,'2026-04-13','2026-04-17 15:35:22'),(33,1,1,1,'expense',120000.00,'Coffee với khách hàng','',NULL,'2026-04-12','2026-04-17 15:35:22'),(34,1,2,5,'expense',800000.00,'Khám sức khỏe định kỳ','Bệnh viện FV',NULL,'2026-04-12','2026-04-17 15:35:22'),(35,1,1,1,'expense',250000.00,'Đi ăn sinh nhật bạn','',NULL,'2026-04-11','2026-04-17 15:35:22'),(36,1,2,14,'income',500000.00,'Thưởng hoàn thành dự án','',NULL,'2026-04-10','2026-04-17 15:35:22'),(37,1,2,3,'expense',650000.00,'Mua đồ dùng gia đình','IKEA',NULL,'2026-04-10','2026-04-17 15:35:22'),(38,1,1,1,'expense',90000.00,'Bún bò Huế','',NULL,'2026-04-09','2026-04-17 15:35:22'),(39,1,2,6,'expense',180000.00,'Mua sách lập trình','',NULL,'2026-04-08','2026-04-17 15:35:22'),(40,1,3,9,'expense',300000.00,'Cắt tóc + dưỡng da','',NULL,'2026-04-07','2026-04-17 15:35:22'),(41,1,2,15,'income',1000000.00,'Cổ tức chứng khoán','',NULL,'2026-04-06','2026-04-17 15:35:22'),(42,1,2,10,'expense',500000.00,'Đặt vé xe đi Đà Lạt','',NULL,'2026-04-05','2026-04-17 15:35:22'),(43,1,1,1,'expense',150000.00,'Đặt đồ ăn Baemin','',NULL,'2026-04-04','2026-04-17 15:35:22'),(44,1,3,2,'expense',400000.00,'Đổ xăng xe máy','',NULL,'2026-04-03','2026-04-17 15:35:22');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transfers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `from_account_id` int unsigned NOT NULL,
  `to_account_id` int unsigned NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `fee` decimal(15,2) NOT NULL DEFAULT '0.00',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transfer_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_transfers_user_id` (`user_id`),
  KEY `idx_transfers_from_account` (`from_account_id`),
  KEY `idx_transfers_to_account` (`to_account_id`),
  KEY `idx_transfers_date` (`transfer_date`),
  CONSTRAINT `fk_transfers_from_account` FOREIGN KEY (`from_account_id`) REFERENCES `accounts` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_transfers_to_account` FOREIGN KEY (`to_account_id`) REFERENCES `accounts` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_transfers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `transfers` WRITE;
/*!40000 ALTER TABLE `transfers` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfers` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VND',
  `theme` enum('light','dark') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'light',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'test@gmail.com','$2a$10$qB1CUFCeOxyqGkkoLaP0Te5LeJPryHNQMkwdLt4DDzarrFIsBZx2.','Nguyễn Test User',NULL,'VND','light','2026-04-17 15:35:21','2026-04-17 15:35:21');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


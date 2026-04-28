CREATE DATABASE IF NOT EXISTS expense_management;
USE expense_management;

-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: expense_management
-- ------------------------------------------------------
-- Server version	8.0.44

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

--
-- Table structure for table `accounts`
--

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

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,1,'Tien mat','cash',2000000.00,'#f59e0b','Wallet',1,'2026-04-17 15:35:21'),(2,1,'MB Bank','bank',15000000.00,'#2563eb','CreditCard',0,'2026-04-17 15:35:21'),(3,1,'MoMo','e_wallet',500000.00,'#a855f7','Smartphone',0,'2026-04-17 15:35:21'),(4,2,'Tiß╗ün mß║╖t','cash',-225000.00,'#f59e0b','Wallet',1,'2026-04-18 16:08:48'),(5,3,'Tiß╗ün mß║╖t','cash',0.00,'#f59e0b','Wallet',1,'2026-04-24 11:48:13');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_conversations`
--

DROP TABLE IF EXISTS `ai_conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_conversations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Cuß╗Öc tr├▓ chuyß╗çn mß╗¢i',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ai_conv_user_id` (`user_id`),
  KEY `idx_ai_conv_updated` (`updated_at`),
  CONSTRAINT `fk_ai_conv_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_conversations`
--

LOCK TABLES `ai_conversations` WRITE;
/*!40000 ALTER TABLE `ai_conversations` DISABLE KEYS */;
INSERT INTO `ai_conversations` VALUES (20,1,'T├┤i n├¬n cß║»t giß║úm chi ti├¬u Giß║úi tr├¡ nh╞░ t','2026-04-28 14:54:21','2026-04-28 15:06:27'),(25,1,'Ph├ón t├¡ch th├íng 4/2026','2026-04-28 15:02:55','2026-04-28 15:03:36'),(26,1,'T├┤i n├¬n cß║»t giß║úm chi ti├¬u Giß║úi tr├¡ nh╞░ t','2026-04-28 15:05:52','2026-04-28 15:06:38');
/*!40000 ALTER TABLE `ai_conversations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_messages`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_messages`
--

LOCK TABLES `ai_messages` WRITE;
/*!40000 ALTER TABLE `ai_messages` DISABLE KEYS */;
INSERT INTO `ai_messages` VALUES (32,20,'user','T├┤i n├¬n cß║»t giß║úm chi ti├¬u Giß║úi tr├¡ nh╞░ thß║┐ n├áo?','2026-04-28 14:54:21'),(37,20,'user','├í','2026-04-28 14:54:50'),(38,20,'user','├á','2026-04-28 14:54:51'),(39,20,'user','f','2026-04-28 14:54:52'),(43,25,'user','H├úy ph├ón t├¡ch tß╗òng quan t├¼nh h├¼nh t├ái ch├¡nh cß╗ºa t├┤i trong th├íng n├áy v├á ─æ╞░a ra 3 gß╗úi ├╜ cß║úi thiß╗çn cß╗Ñ thß╗â.','2026-04-28 15:02:55'),(44,25,'assistant','Ch├áo bß║ín, t├¼nh h├¼nh t├ái ch├¡nh th├íng 4/2026 cß╗ºa bß║ín ─æang kh├í t├¡ch cß╗▒c vß╗¢i tß╗╖ lß╗ç tiß║┐t kiß╗çm ─æß║ít **45.5%** (**7.275.000─æ**) tr├¬n tß╗òng thu nhß║¡p **16.000.000─æ**. Tuy nhi├¬n, viß╗çc quß║ún l├╜ ng├ón s├ích ─æang c├│ dß║Ñu hiß╗çu mß║Ñt kiß╗âm so├ít ß╗ƒ mß╗Öt sß╗æ mß╗Ñc.\n\nD╞░ß╗¢i ─æ├óy l├á 3 gß╗úi ├╜ ─æß╗â bß║ín tß╗æi ╞░u h├│a:\n\n1.  **Xß╗¡ l├╜ khoß║ún chi Nh├á ß╗ƒ:** Mß╗Ñc n├áy ─æang chi **3.000.000─æ**, v╞░ß╗út **150%** so vß╗¢i dß╗▒ kiß║┐n. Bß║ín cß║ºn r├á so├ít xem ─æ├óy l├á chi ph├¡ ph├ít sinh mß╗Öt lß║ºn hay cß╗æ ─æß╗ïnh ─æß╗â ─æiß╗üu chß╗ënh lß║íi hß║ín mß╗⌐c th├íng sau.\n2.  **Cß║»t giß║úm Giß║úi tr├¡ ngay lß║¡p tß╗⌐c:** Do ─æ├ú chß║ím mß╗⌐c **90%** ng├ón s├ích, bß║ín n├¬n ╞░u ti├¬n c├íc hoß║ít ─æß╗Öng miß╗àn ph├¡ tß╗½ nay ─æß║┐n cuß╗æi th├íng ─æß╗â tr├ính r╞íi v├áo t├¼nh trß║íng b├ío ─æß╗Öng ─æß╗Å.\n3.  **R├á so├ít H├│a ─æ╞ín v├á Mua sß║»m:** Tß╗òng hai mß╗Ñc n├áy chiß║┐m **2.200.000─æ**. Viß╗çc tß║¡n dß╗Ñng c├íc m├ú giß║úm gi├í hoß║╖c cß║»t bß╗¢t c├íc g├│i ─æ─âng k├╜ kh├┤ng d├╣ng ─æß║┐n sß║╜ gi├║p bß║úo vß╗ç sß╗æ tiß╗ün tiß║┐t kiß╗çm **7.275.000─æ** hiß╗çn tß║íi.\n\n**H├ánh ─æß╗Öng cß╗Ñ thß╗â h├┤m nay:** Bß║ín h├úy liß╗çt k├¬ chi tiß║┐t c├íc khoß║ún ph├ít sinh trong mß╗Ñc Nh├á ß╗ƒ ─æß╗â x├íc ─æß╗ïnh nguy├¬n nh├ón khiß║┐n ng├ón s├ích v╞░ß╗út ng╞░ß╗íng 150%.','2026-04-28 15:03:36'),(45,26,'user','T├┤i n├¬n cß║»t giß║úm chi ti├¬u Giß║úi tr├¡ nh╞░ thß║┐ n├áo?','2026-04-28 15:05:52'),(46,26,'assistant','Ch├áo bß║ín! Trong th├íng 4/2026, bß║ín ─æ├ú chi **450.000Γé½ tr├¬n tß╗òng 500.000Γé½** ng├ón s├ích Giß║úi tr├¡ (─æß║ít ng╞░ß╗íng **90%**). Vß╗¢i chß╗ë 50.000Γé½ c├▓n lß║íi, viß╗çc thß║»t chß║╖t chi ti├¬u l├á rß║Ñt cß║ºn thiß║┐t.\n\nD╞░ß╗¢i ─æ├óy l├á c├íc c├ích cß╗Ñ thß╗â ─æß╗â bß║ín cß║»t giß║úm nh╞░ng vß║½n cß║úm thß║Ñy thoß║úi m├íi:\n\n1.  **Chuyß╗ân sang giß║úi tr├¡ \"0 ─æß╗ông\":** Thay v├¼ ─æi xem phim rß║íp hay ─æi concert, bß║ín c├│ thß╗â chß╗ìn ─æi dß║ío c├┤ng vi├¬n, ─æß╗ìc s├ích tß║íi th╞░ viß╗çn c├┤ng cß╗Öng hoß║╖c tß╗ò chß╗⌐c xem phim tß║íi nh├á c├╣ng bß║ín b├¿. ≡ƒî│≡ƒôû\n2.  **R├á so├ít c├íc g├│i ─æ─âng k├╜ (Subscriptions):** Kiß╗âm tra lß║íi c├íc dß╗ïch vß╗Ñ nh╞░ Netflix, Spotify, Youtube Premium hoß║╖c c├íc g├│i data giß║úi tr├¡. Nß║┐u c├│ dß╗ïch vß╗Ñ n├áo ├¡t d├╣ng, h├úy tß║ím dß╗½ng hoß║╖c chuyß╗ân sang g├│i d├╣ng chung (Family plan) ─æß╗â chia sß║╗ chi ph├¡. ≡ƒô▒\n3.  **Tß║¡n dß╗Ñng tß╗æi ─æa khuyß║┐n m├úi:** Chß╗ë ─æi xem phim v├áo \"Ng├áy hß╗Öi th├ánh vi├¬n\" (th╞░ß╗¥ng l├á thß╗⌐ 2 hoß║╖c thß╗⌐ 4) hoß║╖c s─ân voucher tr├¬n c├íc v├¡ ─æiß╗çn tß╗¡ tr╞░ß╗¢c khi thanh to├ín. ≡ƒÄƒ∩╕Å\n4.  **Hß║ín chß║┐ \"chi ph├¡ ß║⌐n\" khi ─æi ch╞íi:** Khi ─æi gß║╖p gß╗í bß║ín b├¿, h├úy ─ân nhß║╣ tß║íi nh├á tr╞░ß╗¢c ─æß╗â tr├ính viß╗çc chi qu├í tay cho ─æß╗ô ─ân vß║╖t hoß║╖c ─æß╗ô uß╗æng ─æß║»t tiß╗ün tß║íi n╞íi vui ch╞íi. Γÿò\n\n**L╞░u ├╜ quan trß╗ìng:** V├¼ hß║íng mß╗Ñc **Nh├á ß╗ƒ cß╗ºa bß║ín ─æang v╞░ß╗út 150%** ng├ón s├ích (3.000.000/2.000.000Γé½), viß╗çc tiß║┐t kiß╗çm triß╗çt ─æß╗â ß╗ƒ mß╗Ñc Giß║úi tr├¡ sß║╜ gi├║p bß║ín b├╣ ─æß║»p khoß║ún th├óm hß╗Ñt n├áy v├á bß║úo vß╗ç mß╗Ñc ti├¬u tiß║┐t kiß╗çm 45% thu nhß║¡p cß╗ºa m├¼nh. ≡ƒÄ»\n\nCh├║c bß║ín quß║ún l├╜ chi ti├¬u hiß╗çu quß║ú!','2026-04-28 15:06:00'),(47,20,'user','ch├áo','2026-04-28 15:06:14'),(48,20,'assistant','Ch├áo bß║ín! T├┤i l├á trß╗ú l├╜ t├ái ch├¡nh cß╗ºa bß║ín ─æ├óy. ≡ƒîƒ\n\nDß╗▒a tr├¬n dß╗» liß╗çu th├íng 4/2026, ng├ón s├ích **Giß║úi tr├¡** cß╗ºa bß║ín ─æ├ú d├╣ng hß║┐t **450.000Γé½/500.000Γé½ (90%)**. Bß║ín chß╗ë c├▓n vß╗Ån vß║╣n **50.000Γé½** cho phß║ºn c├▓n lß║íi cß╗ºa th├íng.\n\n─Éß╗â cß║»t giß║úm khoß║ún n├áy m├á vß║½n thß║Ñy thoß║úi m├íi, ─æ├óy l├á nhß╗»ng gß╗úi ├╜ thß╗▒c tß║┐ cho bß║ín:\n\n1.  **R├á so├ít c├íc g├│i ─æ─âng k├╜ (Subscriptions):** Kiß╗âm tra xem bß║ín c├│ ─æang trß║ú tiß╗ün cho Netflix, Spotify hay c├íc app giß║úi tr├¡ n├áo ├¡t d├╣ng kh├┤ng? Nß║┐u c├│, h├úy tß║ím dß╗½ng ngay ─æß╗â tiß║┐t kiß╗çm khoß║úng 100k-200k mß╗ùi th├íng. ≡ƒÄ¼\n2.  **╞»u ti├¬n h├¼nh thß╗⌐c giß║úi tr├¡ \"0 ─æß╗ông\":** Thay v├¼ ─æi xem phim rß║íp (tß╗æn khoß║úng 150k cß║ú bß║»p n╞░ß╗¢c), bß║ín c├│ thß╗â xem phim tß║íi nh├á hoß║╖c ─æi dß║ío c├┤ng vi├¬n, ─æß╗ìc s├ích tß║íi th╞░ viß╗çn c├┤ng cß╗Öng. ≡ƒî│\n3.  **Hß║╣n h├▓ tß║íi gia:** Thay v├¼ ─æi cafe sang chß║únh (mß╗ùi lß║ºn khoß║úng 50k-70k), h├úy mß╗¥i bß║ín b├¿ vß╗ü nh├á c├╣ng nß║Ñu ─ân hoß║╖c uß╗æng tr├á. Khoß║ún **─én uß╗æng** cß╗ºa bß║ín hiß╗çn mß╗¢i chß╗ë d├╣ng 23%, bß║ín c├│ thß╗â tß║¡n dß╗Ñng ng├ón s├ích n├áy ─æß╗â b├╣ ─æß║»p cho nhu cß║ºu giao l╞░u. Γÿò\n4.  **Tß║¡n dß╗Ñng khuyß║┐n m├úi:** Chß╗ë ─æi xem phim v├áo ng├áy giß║úm gi├í (th╞░ß╗¥ng l├á thß╗⌐ 2 hoß║╖c thß╗⌐ 4) hoß║╖c s─ân voucher tr├¬n c├íc ß╗⌐ng dß╗Ñng v├¡ ─æiß╗çn tß╗¡.\n\n**L╞░u ├╜ quan trß╗ìng:** Khoß║ún **Nh├á ß╗ƒ** cß╗ºa bß║ín ─æang v╞░ß╗út mß╗⌐c b├ío ─æß╗Öng (**150%** - chi 3 triß╗çu trong khi ng├ón s├ích 2 triß╗çu). Viß╗çc cß║»t giß║úm Giß║úi tr├¡ l├á tß╗æt, nh╞░ng bß║ín cß║ºn xem lß║íi c├ích ph├ón bß╗ò ng├ón s├ích cho Nh├á ß╗ƒ ─æß╗â kh├┤ng ß║únh h╞░ß╗ƒng ─æß║┐n d├▓ng tiß╗ün tß╗òng thß╗â nh├⌐! ≡ƒÅáΓÜá∩╕Å\n\nBß║ín c├│ muß╗æn t├┤i gi├║p c├ón ─æß╗æi lß║íi ng├ón s├ích Nh├á ß╗ƒ cho th├íng sau kh├┤ng?','2026-04-28 15:06:27'),(49,26,'user','hi','2026-04-28 15:06:33'),(50,26,'assistant','Ch├áo bß║ín! Rß║Ñt vui ─æ╞░ß╗úc gß║╖p lß║íi bß║ín. ≡ƒæï\n\nDß╗▒a tr├¬n dß╗» liß╗çu t├ái ch├¡nh th├íng 4/2026 cß╗ºa bß║ín, m├¼nh thß║Ñy bß║ín ─æang l├ám rß║Ñt tß╗æt viß╗çc tiß║┐t kiß╗çm khi giß╗» lß║íi ─æ╞░ß╗úc **7.275.000Γé½ (t╞░╞íng ─æ╞░╞íng 45% thu nhß║¡p)**. ─É├óy l├á mß╗Öt con sß╗æ rß║Ñt ß║Ñn t╞░ß╗úng! ≡ƒæÅ\n\nTuy nhi├¬n, c├│ mß╗Öt ─æiß╗âm cß║ºn l╞░u ├╜ l├á mß╗Ñc **Nh├á ß╗ƒ cß╗ºa bß║ín ─æ├ú chi 3.000.000Γé½**, v╞░ß╗út **150%** so vß╗¢i ng├ón s├ích ─æß╗ü ra (2.000.000Γé½).\n\nBß║ín c├│ muß╗æn m├¼nh gi├║p ph├ón t├¡ch s├óu h╞ín vß╗ü khoß║ún chi n├áo kh├íc hay cß║ºn lß╗¥i khuy├¬n ─æß╗â ─æiß╗üu chß╗ënh ng├ón s├ích cho th├íng tß╗¢i kh├┤ng? ≡ƒÿè','2026-04-28 15:06:38');
/*!40000 ALTER TABLE `ai_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `budgets`
--

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

--
-- Dumping data for table `budgets`
--

LOCK TABLES `budgets` WRITE;
/*!40000 ALTER TABLE `budgets` DISABLE KEYS */;
INSERT INTO `budgets` VALUES (1,1,1,3000000.00,4,2026,'2026-04-17 15:35:22'),(2,1,3,2000000.00,4,2026,'2026-04-17 15:35:22'),(3,1,2,1000000.00,4,2026,'2026-04-17 15:35:22'),(4,1,4,500000.00,4,2026,'2026-04-17 15:35:22'),(5,1,5,1500000.00,4,2026,'2026-04-17 15:35:22'),(6,1,8,2000000.00,4,2026,'2026-04-24 18:33:45');
/*!40000 ALTER TABLE `budgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

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

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,NULL,NULL,'─én uß╗æng','expense','UtensilsCrossed','#f59e0b',1),(2,NULL,NULL,'Di chuyß╗ân','expense','Car','#3b82f6',1),(3,NULL,NULL,'Mua sß║»m','expense','ShoppingBag','#ec4899',1),(4,NULL,NULL,'Giß║úi tr├¡','expense','Gamepad2','#8b5cf6',1),(5,NULL,NULL,'Sß╗⌐c khß╗Åe','expense','HeartPulse','#ef4444',1),(6,NULL,NULL,'Gi├ío dß╗Ñc','expense','BookOpen','#06b6d4',1),(7,NULL,NULL,'H├│a ─æ╞ín','expense','FileText','#64748b',1),(8,NULL,NULL,'Nh├á ß╗ƒ','expense','Home','#10b981',1),(9,NULL,NULL,'L├ám ─æß║╣p','expense','Sparkles','#f43f5e',1),(10,NULL,NULL,'Du lß╗ïch','expense','Plane','#0ea5e9',1),(11,NULL,NULL,'Qu├á tß║╖ng','expense','Gift','#a855f7',1),(12,NULL,NULL,'Chi kh├íc','expense','MoreHorizontal','#94a3b8',1),(13,NULL,NULL,'L╞░╞íng','income','Banknote','#22c55e',1),(14,NULL,NULL,'Th╞░ß╗ƒng','income','Trophy','#f59e0b',1),(15,NULL,NULL,'─Éß║ºu t╞░','income','TrendingUp','#3b82f6',1),(16,NULL,NULL,'Freelance','income','Laptop','#8b5cf6',1),(17,NULL,NULL,'Qu├á nhß║¡n','income','Gift','#ec4899',1),(18,NULL,NULL,'Thu kh├íc','income','PlusCircle','#94a3b8',1);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financial_health_scores`
--

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

--
-- Dumping data for table `financial_health_scores`
--

LOCK TABLES `financial_health_scores` WRITE;
/*!40000 ALTER TABLE `financial_health_scores` DISABLE KEYS */;
INSERT INTO `financial_health_scores` VALUES (1,1,4,2026,75,'Tß╗æt',30,25,5,15,0,45.00,119.00,4,'2026-04-24 12:04:27','2026-04-24 12:31:38'),(4,2,4,2026,27,'B├ío ─æß╗Öng',0,12,10,0,5,0.00,0.00,0,'2026-04-24 18:41:09','2026-04-24 18:41:09'),(5,3,4,2026,27,'B├ío ─æß╗Öng',0,12,10,0,5,0.00,0.00,0,'2026-04-25 16:45:43','2026-04-25 16:53:01');
/*!40000 ALTER TABLE `financial_health_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `method_allocations`
--

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

--
-- Dumping data for table `method_allocations`
--

LOCK TABLES `method_allocations` WRITE;
/*!40000 ALTER TABLE `method_allocations` DISABLE KEYS */;
INSERT INTO `method_allocations` VALUES (1,1,'Nhu cß║ºu thiß║┐t yß║┐u',50.00,'#2563EB',1),(2,1,'Mong muß╗æn & Giß║úi tr├¡',30.00,'#7C3AED',2),(3,1,'Tiß║┐t kiß╗çm & ─Éß║ºu t╞░',20.00,'#16A34A',3),(4,2,'Chi ti├¬u thiß║┐t yß║┐u',55.00,'#2563EB',1),(5,2,'Tß╗▒ do t├ái ch├¡nh',10.00,'#16A34A',2),(6,2,'Gi├ío dß╗Ñc & Ph├ít triß╗ân',10.00,'#D97706',3),(7,2,'H╞░ß╗ƒng thß╗Ñ',10.00,'#EC4899',4),(8,2,'Tiß║┐t kiß╗çm d├ái hß║ín',10.00,'#059669',5),(9,2,'Tß╗½ thiß╗çn & ─É├│ng g├│p',5.00,'#DC2626',6),(10,3,'Chi ti├¬u cuß╗Öc sß╗æng',70.00,'#2563EB',1),(11,3,'Tiß║┐t kiß╗çm & ─Éß║ºu t╞░',20.00,'#16A34A',2),(12,3,'Trß║ú nß╗ú & Tß╗½ thiß╗çn',10.00,'#D97706',3);
/*!40000 ALTER TABLE `method_allocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

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
  `related_id` int DEFAULT NULL COMMENT 'ID li├¬n quan (transaction_id, budget_id...)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_user_id` (`user_id`),
  KEY `idx_notifications_is_read` (`is_read`),
  KEY `idx_notifications_user_read` (`user_id`,`is_read`),
  KEY `idx_notifications_created` (`created_at`),
  CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,1,'Ch├áo mß╗½ng!','Ch├áo mß╗½ng bß║ín ─æß║┐n vß╗¢i Web Quß║ún L├╜ Chi Ti├¬u. H├úy bß║»t ─æß║ºu theo d├╡i chi ti├¬u cß╗ºa bß║ín ngay!','system',0,NULL,'2026-04-17 15:35:22'),(2,1,'Ng├ón s├ích ─én uß╗æng gß║ºn ─æß║ít giß╗¢i hß║ín','Bß║ín ─æ├ú chi 73% ng├ón s├ích ─én uß╗æng th├íng n├áy. H├úy c├ón nhß║»c chi ti├¬u!','budget_warning',0,NULL,'2026-04-17 15:35:22');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recurring_transactions`
--

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

--
-- Dumping data for table `recurring_transactions`
--

LOCK TABLES `recurring_transactions` WRITE;
/*!40000 ALTER TABLE `recurring_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `recurring_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spending_methods`
--

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

--
-- Dumping data for table `spending_methods`
--

LOCK TABLES `spending_methods` WRITE;
/*!40000 ALTER TABLE `spending_methods` DISABLE KEYS */;
INSERT INTO `spending_methods` VALUES (1,NULL,'Quy tß║»c 50/30/20','Ph├ón chia thu nhß║¡p th├ánh 3 nh├│m: Nhu cß║ºu thiß║┐t yß║┐u (50%), Mong muß╗æn (30%) v├á Tiß║┐t kiß╗çm (20%). L├╜ t╞░ß╗ƒng cho ng╞░ß╗¥i mß╗¢i bß║»t ─æß║ºu quß║ún l├╜ t├ái ch├¡nh.','≡ƒìò',1,'2026-04-24 18:12:37'),(2,NULL,'Quy tß║»c 6 chiß║┐c lß╗ì','Chia thu nhß║¡p v├áo 6 lß╗ì vß╗¢i mß╗Ñc ─æ├¡ch r├╡ r├áng, gi├║p c├ón bß║▒ng giß╗»a chi ti├¬u hiß╗çn tß║íi v├á t╞░╞íng lai t├ái ch├¡nh.','≡ƒì»',1,'2026-04-24 18:12:37'),(3,NULL,'Quy tß║»c 70/20/10','─É╞ín giß║ún ho├í t├ái ch├¡nh c├í nh├ón: 70% chi ti├¬u cuß╗Öc sß╗æng, 20% tiß║┐t kiß╗çm & ─æß║ºu t╞░, 10% trß║ú nß╗ú hoß║╖c tß╗½ thiß╗çn.','≡ƒôè',1,'2026-04-24 18:12:37');
/*!40000 ALTER TABLE `spending_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

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

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,1,2,13,'income',12000000.00,'L╞░╞íng th├íng',NULL,NULL,'2026-02-01','2026-04-17 15:35:22'),(2,1,2,1,'expense',850000.00,'─én uß╗æng cß║ú th├íng',NULL,NULL,'2026-02-05','2026-04-17 15:35:22'),(3,1,1,2,'expense',300000.00,'─Éi lß║íi th├íng',NULL,NULL,'2026-02-08','2026-04-17 15:35:22'),(4,1,2,7,'expense',1200000.00,'Tiß╗ün ─æiß╗çn n╞░ß╗¢c',NULL,NULL,'2026-02-10','2026-04-17 15:35:22'),(5,1,2,8,'expense',3000000.00,'Tiß╗ün thu├¬ nh├á',NULL,NULL,'2026-02-01','2026-04-17 15:35:22'),(6,1,1,3,'expense',650000.00,'Mua ─æß╗ô d├╣ng',NULL,NULL,'2026-02-15','2026-04-17 15:35:22'),(7,1,2,5,'expense',500000.00,'Kh├ím sß╗⌐c khß╗Åe',NULL,NULL,'2026-02-20','2026-04-17 15:35:22'),(8,1,2,16,'income',2000000.00,'Thu nhß║¡p th├¬m',NULL,NULL,'2026-02-25','2026-04-17 15:35:22'),(9,1,2,13,'income',12000000.00,'L╞░╞íng th├íng',NULL,NULL,'2026-03-01','2026-04-17 15:35:22'),(10,1,2,14,'income',1500000.00,'Th╞░ß╗ƒng ho├án th├ánh dß╗▒ ├ín',NULL,NULL,'2026-03-05','2026-04-17 15:35:22'),(11,1,1,1,'expense',85000.00,'C╞ím tr╞░a v─ân ph├▓ng',NULL,NULL,'2026-03-02','2026-04-17 15:35:22'),(12,1,1,1,'expense',120000.00,'Coffee vß╗¢i ─æß╗ông nghiß╗çp',NULL,NULL,'2026-03-04','2026-04-17 15:35:22'),(13,1,2,3,'expense',350000.00,'Mua ├ío H&M',NULL,NULL,'2026-03-06','2026-04-17 15:35:22'),(14,1,3,2,'expense',200000.00,'Grab ─æi l├ám cß║ú tuß║ºn',NULL,NULL,'2026-03-08','2026-04-17 15:35:22'),(15,1,2,7,'expense',1200000.00,'Tiß╗ün ─æiß╗çn th├íng',NULL,NULL,'2026-03-10','2026-04-17 15:35:22'),(16,1,1,4,'expense',450000.00,'Netflix + Spotify',NULL,NULL,'2026-03-12','2026-04-17 15:35:22'),(17,1,2,8,'expense',3000000.00,'Tiß╗ün thu├¬ nh├á th├íng',NULL,NULL,'2026-03-01','2026-04-17 15:35:22'),(18,1,1,1,'expense',250000.00,'─Éi ─ân sinh nhß║¡t bß║ín',NULL,NULL,'2026-03-14','2026-04-17 15:35:22'),(19,1,2,5,'expense',800000.00,'Kh├ím sß╗⌐c khß╗Åe ─æß╗ïnh kß╗│',NULL,NULL,'2026-03-16','2026-04-17 15:35:22'),(20,1,2,6,'expense',180000.00,'Mua s├ích Atomic Habits',NULL,NULL,'2026-03-18','2026-04-17 15:35:22'),(21,1,3,9,'expense',300000.00,'Cß║»t t├│c + d╞░ß╗íng da',NULL,NULL,'2026-03-20','2026-04-17 15:35:22'),(22,1,2,15,'income',1000000.00,'Cß╗ò tß╗⌐c chß╗⌐ng kho├ín',NULL,NULL,'2026-03-22','2026-04-17 15:35:22'),(23,1,2,10,'expense',500000.00,'─Éß║╖t v├⌐ xe ─æi ─É├á Lß║ít',NULL,NULL,'2026-03-24','2026-04-17 15:35:22'),(24,1,2,16,'income',2500000.00,'Dß╗▒ ├ín thiß║┐t kß║┐ web',NULL,NULL,'2026-03-26','2026-04-17 15:35:22'),(25,1,2,13,'income',12000000.00,'L╞░╞íng th├íng n├áy','',NULL,'2026-04-01','2026-04-17 15:35:22'),(26,1,2,8,'expense',3000000.00,'Tiß╗ün thu├¬ nh├á','',NULL,'2026-04-01','2026-04-17 15:35:22'),(27,1,1,1,'expense',85000.00,'C╞ím tr╞░a v─ân ph├▓ng','',NULL,'2026-04-16','2026-04-17 15:35:22'),(28,1,2,3,'expense',350000.00,'Mua ├ío H&M','Sale 30%',NULL,'2026-04-15','2026-04-17 15:35:22'),(29,1,3,2,'expense',200000.00,'Grab ─æi l├ám cß║ú tuß║ºn','',NULL,'2026-04-14','2026-04-17 15:35:22'),(30,1,2,7,'expense',1200000.00,'Tiß╗ün ─æiß╗çn th├íng','',NULL,'2026-04-14','2026-04-17 15:35:22'),(31,1,1,4,'expense',450000.00,'Netflix + Spotify','Gia hß║ín 3 th├íng',NULL,'2026-04-13','2026-04-17 15:35:22'),(32,1,2,16,'income',2500000.00,'Dß╗▒ ├ín thiß║┐t kß║┐ web','',NULL,'2026-04-13','2026-04-17 15:35:22'),(33,1,1,1,'expense',120000.00,'Coffee vß╗¢i kh├ích h├áng','',NULL,'2026-04-12','2026-04-17 15:35:22'),(34,1,2,5,'expense',800000.00,'Kh├ím sß╗⌐c khß╗Åe ─æß╗ïnh kß╗│','Bß╗çnh viß╗çn FV',NULL,'2026-04-12','2026-04-17 15:35:22'),(35,1,1,1,'expense',250000.00,'─Éi ─ân sinh nhß║¡t bß║ín','',NULL,'2026-04-11','2026-04-17 15:35:22'),(36,1,2,14,'income',500000.00,'Th╞░ß╗ƒng ho├án th├ánh dß╗▒ ├ín','',NULL,'2026-04-10','2026-04-17 15:35:22'),(37,1,2,3,'expense',650000.00,'Mua ─æß╗ô d├╣ng gia ─æ├¼nh','IKEA',NULL,'2026-04-10','2026-04-17 15:35:22'),(38,1,1,1,'expense',90000.00,'B├║n b├▓ Huß║┐','',NULL,'2026-04-09','2026-04-17 15:35:22'),(39,1,2,6,'expense',180000.00,'Mua s├ích lß║¡p tr├¼nh','',NULL,'2026-04-08','2026-04-17 15:35:22'),(40,1,3,9,'expense',300000.00,'Cß║»t t├│c + d╞░ß╗íng da','',NULL,'2026-04-07','2026-04-17 15:35:22'),(41,1,2,15,'income',1000000.00,'Cß╗ò tß╗⌐c chß╗⌐ng kho├ín','',NULL,'2026-04-06','2026-04-17 15:35:22'),(42,1,2,10,'expense',500000.00,'─Éß║╖t v├⌐ xe ─æi ─É├á Lß║ít','',NULL,'2026-04-05','2026-04-17 15:35:22'),(43,1,1,1,'expense',150000.00,'─Éß║╖t ─æß╗ô ─ân Baemin','',NULL,'2026-04-04','2026-04-17 15:35:22'),(44,1,3,2,'expense',400000.00,'─Éß╗ò x─âng xe m├íy','',NULL,'2026-04-03','2026-04-17 15:35:22'),(46,2,4,1,'expense',225000.00,'N╞░ß╗¢c uß╗æng tß║íi VINH NGUYEN RES','Items: Coca x2, Sprite x2, Coca x2, Tonic x2, Soda x1',NULL,'2019-03-29','2026-04-24 18:38:31');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfers`
--

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

--
-- Dumping data for table `transfers`
--

LOCK TABLES `transfers` WRITE;
/*!40000 ALTER TABLE `transfers` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

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

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'test@gmail.com','$2a$10$qB1CUFCeOxyqGkkoLaP0Te5LeJPryHNQMkwdLt4DDzarrFIsBZx2.','Nguyß╗àn Test User',NULL,'VND','light','2026-04-17 15:35:21','2026-04-17 15:35:21'),(2,'abc@gmaill.com','$2a$10$.XtIB7MtZxzVRccaYRXmsOa5yGgwksJZpEEHFkLpLazG7ruX6MfMW','test1',NULL,'VND','light','2026-04-18 16:08:48','2026-04-18 16:08:48'),(3,'a@gmail.com','$2a$10$jt/8E4KrZzjTCKLuqpYZmuSaJ85yMq7.Y8rfXQ/FakJnAMLWZV22W','ab',NULL,'VND','light','2026-04-24 11:48:13','2026-04-28 14:37:07');
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

-- Dump completed on 2026-04-28 22:21:52

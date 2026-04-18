-- ═══════════════════════════════════════════════════════════════
--  AeroSphere — Database Initialization Script
--  Auto-executed by MySQL Docker container on first startup
-- ═══════════════════════════════════════════════════════════════

-- Create and select the database
CREATE DATABASE IF NOT EXISTS `airlinedb`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `airlinedb`;

-- Grant privileges to app user (from MYSQL_USER env var)
-- This runs as root, so we can grant to the app user
GRANT ALL PRIVILEGES ON `airlinedb`.* TO 'aerosphere'@'%';
FLUSH PRIVILEGES;

-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: airlinedb
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `flight_id` int NOT NULL,
  `booking_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `num_seats` int NOT NULL,
  `total_amount` double NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'BOOKED',
  `payment_status` varchar(20) NOT NULL DEFAULT 'PENDING',
  `razorpay_order_id` varchar(100) DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_bookings_user_id` (`user_id`),
  KEY `idx_bookings_flight_id` (`flight_id`),
  KEY `idx_bookings_booking_date` (`booking_date`),
  KEY `idx_bookings_status` (`status`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`flight_id`) REFERENCES `flights` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (5,12,1,'2026-04-08 12:56:29',1,4500,'BOOKED','PENDING',NULL,NULL),(6,13,1,'2026-04-08 13:16:39',1,4725,'CANCELLED','REFUNDED','order_SavaC8RlCn7Inx','2026-04-08 14:04:39'),(7,13,1,'2026-04-08 14:23:39',1,4725,'BOOKED','PAID','order_SawJf3Rv3Sj25r',NULL),(8,14,7,'2026-03-25 10:00:00',1,3500,'BOOKED','PAID','order_AA001aaa001',NULL),(9,15,8,'2026-03-25 11:00:00',2,9600,'BOOKED','PAID','order_AA002bbb002',NULL),(10,16,9,'2026-03-26 09:00:00',1,2200,'BOOKED','PAID','order_AA003ccc003',NULL),(11,17,10,'2026-03-26 10:30:00',1,5200,'CANCELLED','REFUNDED','order_AA004ddd004','2026-03-27 08:00:00'),(12,18,11,'2026-03-27 08:00:00',2,8200,'BOOKED','PAID','order_AA005eee005',NULL),(13,19,12,'2026-03-27 09:30:00',1,4100,'BOOKED','PAID','order_AA006fff006',NULL),(14,20,13,'2026-03-28 10:00:00',1,5000,'BOOKED','PENDING',NULL,NULL),(15,21,14,'2026-03-28 11:00:00',1,4600,'BOOKED','PAID','order_AA008hhh008',NULL),(16,22,15,'2026-03-29 09:00:00',2,5600,'BOOKED','PAID','order_AA009iii009',NULL),(17,23,16,'2026-03-29 10:00:00',1,5300,'CANCELLED','REFUNDED','order_AA010jjj010','2026-03-30 07:00:00'),(18,24,7,'2026-03-30 08:30:00',1,3500,'BOOKED','PAID','order_AA011kkk011',NULL),(19,25,8,'2026-03-30 09:30:00',1,4800,'BOOKED','PAID','order_AA012lll012',NULL),(20,26,9,'2026-03-31 10:00:00',1,2200,'BOOKED','PENDING',NULL,NULL),(21,27,10,'2026-03-31 11:00:00',2,10400,'BOOKED','PAID','order_AA014nnn014',NULL),(22,28,11,'2026-04-01 09:00:00',1,4100,'BOOKED','PAID','order_AA015ooo015',NULL),(23,29,12,'2026-04-01 10:00:00',1,4100,'CANCELLED','REFUNDED','order_AA016ppp016','2026-04-02 08:00:00'),(24,30,13,'2026-04-02 08:00:00',1,5000,'BOOKED','PAID','order_AA017qqq017',NULL),(25,31,14,'2026-04-02 09:30:00',2,9200,'BOOKED','PAID','order_AA018rrr018',NULL),(26,32,15,'2026-04-03 10:00:00',1,2800,'BOOKED','PENDING',NULL,NULL),(27,33,16,'2026-04-03 11:00:00',1,5300,'BOOKED','PAID','order_AA020ttt020',NULL),(28,14,17,'2026-04-04 09:00:00',1,4900,'BOOKED','PAID','order_AA021uuu021',NULL),(29,15,18,'2026-04-04 10:00:00',2,10200,'BOOKED','PAID','order_AA022vvv022',NULL),(30,16,7,'2026-04-05 08:00:00',1,3500,'CANCELLED','REFUNDED','order_AA023www023','2026-04-06 07:00:00'),(31,17,8,'2026-04-05 09:30:00',1,4800,'BOOKED','PAID','order_AA024xxx024',NULL),(32,18,9,'2026-04-06 10:00:00',1,2200,'BOOKED','PAID','order_AA025yyy025',NULL),(33,13,8,'2026-04-10 15:25:38',9,43200,'BOOKED','PENDING','order_Sblf2X34Rf9pgQ',NULL),(34,12,81,'2026-04-12 13:32:07',1,4500,'BOOKED','PENDING',NULL,NULL),(35,13,121,'2026-04-13 13:54:39',1,4500,'BOOKED','PENDING',NULL,NULL);
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender_email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `booking_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('NEW','REPLIED','DELETED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NEW',
  `admin_reply` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `replied_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
INSERT INTO `contact_messages` VALUES (1,'Ajay Patil','ajaypatil8eight@gmail.com','Payment &#x2F; Refund Query','sdvdzs','daacvdscvds','REPLIED','faaaa','2026-04-14 14:38:59','2026-04-14 14:46:12');
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flights`
--

DROP TABLE IF EXISTS `flights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flights` (
  `id` int NOT NULL AUTO_INCREMENT,
  `flight_no` varchar(20) NOT NULL,
  `source` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `depart_date` date NOT NULL,
  `depart_time` time NOT NULL,
  `arrival_time` time DEFAULT NULL,
  `price` double NOT NULL,
  `seats_total` int NOT NULL,
  `seats_available` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `flight_no` (`flight_no`),
  CONSTRAINT `chk_seats` CHECK ((`seats_available` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flights`
--

LOCK TABLES `flights` WRITE;
/*!40000 ALTER TABLE `flights` DISABLE KEYS */;
INSERT INTO `flights` VALUES (1,'SK101','Mumbai','Delhi','2026-04-10','06:00:00','08:15:00',4500,180,174),(2,'SK202','Delhi','Bengaluru','2026-04-11','10:00:00','12:45:00',5500,180,180),(3,'SK303','Chennai','Kolkata','2026-04-12','07:30:00','09:50:00',3800,180,180),(4,'SK404','Hyderabad','Mumbai','2026-04-13','14:00:00','15:30:00',2900,160,160),(6,'hf88','mumbai','delhi','2026-04-06','11:00:00','11:40:00',6900,140,140),(7,'SK505','Mumbai','Chennai','2026-04-15','08:00:00','10:20:00',3500,180,175),(8,'SK606','Delhi','Mumbai','2026-04-15','12:00:00','14:15:00',4800,180,161),(9,'SK707','Bengaluru','Hyderabad','2026-04-16','09:00:00','10:10:00',2200,160,158),(10,'SK808','Kolkata','Delhi','2026-04-16','06:30:00','09:00:00',5200,180,172),(11,'SK909','Mumbai','Kolkata','2026-04-17','07:00:00','09:30:00',4100,180,165),(12,'SK110','Chennai','Mumbai','2026-04-17','11:00:00','13:20:00',3700,160,160),(13,'SK211','Hyderabad','Delhi','2026-04-18','14:30:00','17:00:00',5000,180,155),(14,'SK312','Delhi','Chennai','2026-04-18','08:00:00','10:45:00',4600,180,180),(15,'SK413','Mumbai','Bengaluru','2026-04-19','06:00:00','07:50:00',2800,160,148),(16,'SK514','Bengaluru','Kolkata','2026-04-19','10:00:00','13:00:00',5300,180,180),(17,'SK615','Kolkata','Mumbai','2026-04-20','15:00:00','17:30:00',4900,180,162),(18,'SK716','Chennai','Delhi','2026-04-20','07:00:00','09:45:00',5100,160,155),(19,'SK101A','Mumbai','Delhi','2026-04-10','06:00:00','08:15:00',4500,180,165),(20,'SK102A','Delhi','Bengaluru','2026-04-10','09:00:00','11:45:00',5500,180,172),(21,'SK103A','Chennai','Kolkata','2026-04-10','12:00:00','14:20:00',3800,180,168),(22,'SK104A','Hyderabad','Mumbai','2026-04-10','15:00:00','16:30:00',2900,160,155),(23,'SK105A','Bengaluru','Delhi','2026-04-10','18:00:00','20:30:00',5100,180,170),(24,'SK101B','Mumbai','Kolkata','2026-04-11','06:30:00','09:00:00',4100,180,160),(25,'SK102B','Delhi','Chennai','2026-04-11','08:00:00','10:45:00',4600,180,175),(26,'SK103B','Bengaluru','Mumbai','2026-04-11','11:00:00','12:50:00',2800,160,148),(27,'SK104B','Kolkata','Hyderabad','2026-04-11','14:00:00','16:30:00',4300,180,163),(28,'SK105B','Chennai','Delhi','2026-04-11','17:00:00','19:45:00',5100,180,158),(29,'SK101C','Delhi','Mumbai','2026-04-12','05:30:00','07:45:00',4800,180,172),(30,'SK102C','Mumbai','Bengaluru','2026-04-12','08:00:00','09:50:00',2800,160,155),(31,'SK103C','Kolkata','Chennai','2026-04-12','11:30:00','13:50:00',3800,180,169),(32,'SK104C','Hyderabad','Delhi','2026-04-12','14:30:00','17:00:00',5000,180,161),(33,'SK105C','Mumbai','Hyderabad','2026-04-12','17:30:00','19:00:00',2500,160,150),(34,'SK101D','Bengaluru','Kolkata','2026-04-13','06:00:00','09:00:00',5300,180,174),(35,'SK102D','Delhi','Hyderabad','2026-04-13','09:30:00','12:00:00',4700,180,165),(36,'SK103D','Mumbai','Chennai','2026-04-13','12:30:00','14:50:00',3500,180,170),(37,'SK104D','Kolkata','Mumbai','2026-04-13','15:00:00','17:30:00',4900,180,158),(38,'SK105D','Chennai','Bengaluru','2026-04-13','18:00:00','19:10:00',2200,160,152),(39,'SK101E','Mumbai','Delhi','2026-04-14','06:00:00','08:15:00',4500,180,168),(40,'SK102E','Delhi','Kolkata','2026-04-14','09:00:00','11:30:00',4200,180,171),(41,'SK103E','Hyderabad','Chennai','2026-04-14','12:00:00','13:20:00',2400,160,155),(42,'SK104E','Bengaluru','Mumbai','2026-04-14','15:30:00','17:20:00',2800,160,160),(43,'SK105E','Kolkata','Delhi','2026-04-14','18:00:00','20:30:00',5200,180,163),(44,'SK101F','Chennai','Mumbai','2026-04-15','07:00:00','09:20:00',3700,180,169),(45,'SK102F','Delhi','Bengaluru','2026-04-15','10:00:00','12:45:00',5500,180,155),(46,'SK103F','Mumbai','Kolkata','2026-04-15','13:00:00','15:30:00',4100,180,162),(47,'SK104F','Hyderabad','Bengaluru','2026-04-15','16:00:00','17:10:00',2100,160,148),(48,'SK105F','Delhi','Chennai','2026-04-15','19:00:00','21:45:00',4600,180,170),(49,'SK101G','Mumbai','Hyderabad','2026-04-16','06:30:00','08:00:00',2500,160,153),(50,'SK102G','Kolkata','Bengaluru','2026-04-16','09:00:00','12:00:00',5300,180,167),(51,'SK103G','Chennai','Delhi','2026-04-16','12:30:00','15:15:00',5100,180,172),(52,'SK104G','Delhi','Mumbai','2026-04-16','15:00:00','17:15:00',4800,180,160),(53,'SK105G','Bengaluru','Hyderabad','2026-04-16','18:30:00','19:40:00',2200,160,145),(54,'SK101H','Hyderabad','Kolkata','2026-04-17','06:00:00','08:30:00',4300,180,155),(55,'SK102H','Mumbai','Delhi','2026-04-17','09:00:00','11:15:00',4500,180,170),(56,'SK103H','Delhi','Chennai','2026-04-17','12:00:00','14:45:00',4600,180,163),(57,'SK104H','Bengaluru','Mumbai','2026-04-17','15:30:00','17:20:00',2800,160,157),(58,'SK105H','Kolkata','Hyderabad','2026-04-17','18:00:00','20:30:00',4300,180,149),(59,'SK101I','Delhi','Kolkata','2026-04-18','06:00:00','08:30:00',4200,180,165),(60,'SK102I','Mumbai','Chennai','2026-04-18','09:30:00','11:50:00',3500,180,158),(61,'SK103I','Hyderabad','Delhi','2026-04-18','12:00:00','14:30:00',5000,180,171),(62,'SK104I','Chennai','Bengaluru','2026-04-18','15:00:00','16:10:00',2200,160,152),(63,'SK105I','Kolkata','Mumbai','2026-04-18','18:30:00','21:00:00',4900,180,160),(64,'SK101J','Bengaluru','Delhi','2026-04-19','06:30:00','09:00:00',5100,180,168),(65,'SK102J','Delhi','Hyderabad','2026-04-19','09:00:00','11:30:00',4700,180,155),(66,'SK103J','Mumbai','Kolkata','2026-04-19','12:30:00','15:00:00',4100,180,163),(67,'SK104J','Chennai','Hyderabad','2026-04-19','15:30:00','16:50:00',2400,160,147),(68,'SK105J','Kolkata','Chennai','2026-04-19','18:00:00','20:20:00',3800,180,158),(69,'SK101K','Mumbai','Bengaluru','2026-04-20','07:00:00','08:50:00',2800,160,151),(70,'SK102K','Hyderabad','Mumbai','2026-04-20','10:00:00','11:30:00',2900,160,155),(71,'SK103K','Delhi','Mumbai','2026-04-20','13:00:00','15:15:00',4800,180,169),(72,'SK104K','Bengaluru','Chennai','2026-04-20','16:00:00','17:10:00',2200,160,145),(73,'SK105K','Kolkata','Delhi','2026-04-20','19:00:00','21:30:00',5200,180,162),(74,'SK101L','Delhi','Bengaluru','2026-04-21','06:00:00','08:45:00',5500,180,170),(75,'SK102L','Mumbai','Hyderabad','2026-04-21','09:30:00','11:00:00',2500,160,148),(76,'SK103L','Chennai','Kolkata','2026-04-21','12:00:00','14:20:00',3800,180,165),(77,'SK104L','Kolkata','Bengaluru','2026-04-21','15:00:00','18:00:00',5300,180,157),(78,'SK105L','Hyderabad','Chennai','2026-04-21','18:30:00','19:50:00',2400,160,143),(79,'SK101M','Bengaluru','Kolkata','2026-04-22','06:30:00','09:30:00',5300,180,168),(80,'SK102M','Delhi','Chennai','2026-04-22','09:00:00','11:45:00',4600,180,160),(81,'SK103M','Mumbai','Delhi','2026-04-22','12:00:00','14:15:00',4500,180,171),(82,'SK104M','Chennai','Mumbai','2026-04-22','15:30:00','17:50:00',3700,180,155),(83,'SK105M','Hyderabad','Kolkata','2026-04-22','18:00:00','20:30:00',4300,180,150),(84,'SK101N','Kolkata','Mumbai','2026-04-23','06:00:00','08:30:00',4900,180,163),(85,'SK102N','Bengaluru','Delhi','2026-04-23','09:30:00','12:00:00',5100,180,158),(86,'SK103N','Mumbai','Chennai','2026-04-23','13:00:00','15:20:00',3500,180,171),(87,'SK104N','Delhi','Hyderabad','2026-04-23','15:00:00','17:30:00',4700,180,152),(88,'SK105N','Chennai','Hyderabad','2026-04-23','18:30:00','19:50:00',2400,160,144),(89,'SK101O','Hyderabad','Bengaluru','2026-04-24','06:30:00','07:40:00',2100,160,148),(90,'SK102O','Mumbai','Kolkata','2026-04-24','09:00:00','11:30:00',4100,180,165),(91,'SK103O','Delhi','Mumbai','2026-04-24','12:30:00','14:45:00',4800,180,170),(92,'SK104O','Kolkata','Chennai','2026-04-24','15:00:00','17:20:00',3800,180,158),(93,'SK105O','Bengaluru','Mumbai','2026-04-24','18:00:00','19:50:00',2800,160,145),(94,'SK101P','Mumbai','Delhi','2026-04-25','06:00:00','08:15:00',4500,180,167),(95,'SK102P','Chennai','Delhi','2026-04-25','09:30:00','12:15:00',5100,180,162),(96,'SK103P','Delhi','Kolkata','2026-04-25','12:00:00','14:30:00',4200,180,169),(97,'SK104P','Kolkata','Hyderabad','2026-04-25','15:30:00','18:00:00',4300,180,155),(98,'SK105P','Hyderabad','Mumbai','2026-04-25','18:00:00','19:30:00',2900,160,147),(99,'SK101Q','Bengaluru','Hyderabad','2026-04-26','07:00:00','08:10:00',2100,160,150),(100,'SK102Q','Delhi','Bengaluru','2026-04-26','10:00:00','12:45:00',5500,180,164),(101,'SK103Q','Mumbai','Bengaluru','2026-04-26','13:30:00','15:20:00',2800,160,157),(102,'SK104Q','Kolkata','Delhi','2026-04-26','15:00:00','17:30:00',5200,180,168),(103,'SK105Q','Chennai','Mumbai','2026-04-26','18:30:00','20:50:00',3700,180,153),(104,'SK101R','Mumbai','Hyderabad','2026-04-27','06:30:00','08:00:00',2500,160,145),(105,'SK102R','Hyderabad','Delhi','2026-04-27','09:00:00','11:30:00',5000,180,161),(106,'SK103R','Delhi','Chennai','2026-04-27','12:00:00','14:45:00',4600,180,170),(107,'SK104R','Chennai','Kolkata','2026-04-27','15:30:00','17:50:00',3800,180,155),(108,'SK105R','Kolkata','Bengaluru','2026-04-27','18:00:00','21:00:00',5300,180,162),(109,'SK101S','Delhi','Mumbai','2026-04-28','06:00:00','08:15:00',4800,180,169),(110,'SK102S','Mumbai','Kolkata','2026-04-28','09:30:00','12:00:00',4100,180,158),(111,'SK103S','Bengaluru','Chennai','2026-04-28','12:30:00','13:40:00',2200,160,148),(112,'SK104S','Kolkata','Mumbai','2026-04-28','15:00:00','17:30:00',4900,180,163),(113,'SK105S','Hyderabad','Bengaluru','2026-04-28','18:30:00','19:40:00',2100,160,144),(114,'SK101T','Chennai','Delhi','2026-04-29','06:00:00','08:45:00',5100,180,166),(115,'SK102T','Mumbai','Chennai','2026-04-29','09:00:00','11:20:00',3500,180,161),(116,'SK103T','Delhi','Hyderabad','2026-04-29','12:30:00','15:00:00',4700,180,170),(117,'SK104T','Bengaluru','Kolkata','2026-04-29','15:30:00','18:30:00',5300,180,155),(118,'SK105T','Kolkata','Hyderabad','2026-04-29','18:00:00','20:30:00',4300,180,148),(119,'SK101U','Hyderabad','Mumbai','2026-04-30','06:30:00','08:00:00',2900,160,150),(120,'SK102U','Delhi','Kolkata','2026-04-30','09:00:00','11:30:00',4200,180,165),(121,'SK103U','Mumbai','Delhi','2026-04-30','12:00:00','14:15:00',4500,180,171),(122,'SK104U','Kolkata','Chennai','2026-04-30','15:30:00','17:50:00',3800,180,158),(123,'SK105U','Chennai','Bengaluru','2026-04-30','18:00:00','19:10:00',2200,160,147);
/*!40000 ALTER TABLE `flights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passengers`
--

DROP TABLE IF EXISTS `passengers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `passengers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `seat_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_passengers_booking_id` (`booking_id`),
  CONSTRAINT `passengers_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passengers`
--

LOCK TABLES `passengers` WRITE;
/*!40000 ALTER TABLE `passengers` DISABLE KEYS */;
INSERT INTO `passengers` VALUES (4,5,'Ajay Patil',22,'FEMALE','+917906066648','','2026-03-31','A1'),(5,6,'Ajay Patil',65,'MALE','+917906066648','','2026-03-30','A2'),(6,7,'Ajay Patil',18,'MALE','+917906066648','','2026-03-31','A3'),(7,8,'Rahul Sharma',25,'MALE','+919876543210','rahul.sharma@gmail.com','2000-05-15','B1'),(8,9,'Priya Mehta',27,'FEMALE','+919823456781','priya.mehta@gmail.com','1998-08-22','B2'),(9,9,'Priya Mehta (Guest)',24,'FEMALE','+919823456781','priya.mehta@gmail.com','2001-06-10','B3'),(10,10,'Sneha Kulkarni',24,'FEMALE','+919812345672','sneha.kulkarni@gmail.com','2001-11-30','C1'),(11,11,'Amit Verma',30,'MALE','+919801234563','amit.verma@gmail.com','1995-03-10','C2'),(12,12,'Divya Nair',26,'FEMALE','+919790123454','divya.nair@gmail.com','1999-07-18','D1'),(13,12,'Divya Nair (Guest)',28,'MALE','+919790123454','divya.nair@gmail.com','1997-04-05','D2'),(14,13,'Karan Singh',28,'MALE','+919779012345','karan.singh@gmail.com','1997-12-05','A4'),(15,14,'Ananya Reddy',23,'FEMALE','+919768901236','ananya.reddy@gmail.com','2002-04-25','A5'),(16,15,'Rohan Joshi',29,'MALE','+919757890127','rohan.joshi@gmail.com','1996-09-14','E1'),(17,16,'Meera Pillai',25,'FEMALE','+919746789018','meera.pillai@gmail.com','2000-01-28','E2'),(18,16,'Meera Pillai (Guest)',30,'MALE','+919746789018','meera.pillai@gmail.com','1995-09-12','E3'),(19,17,'Vikas Gupta',31,'MALE','+919735678909','vikas.gupta@gmail.com','1994-06-03','F1'),(20,18,'Pooja Desai',27,'FEMALE','+919724567890','pooja.desai@gmail.com','1998-10-19','F2'),(21,19,'Arjun Kapoor',24,'MALE','+919713456781','arjun.kapoor@gmail.com','2001-02-11','F3'),(22,20,'Neha Tiwari',26,'FEMALE','+919702345672','neha.tiwari@gmail.com','1999-05-07','G1'),(23,21,'Suresh Iyer',32,'MALE','+919691234563','suresh.iyer@gmail.com','1993-08-30','G2'),(24,21,'Suresh Iyer (Guest)',35,'MALE','+919691234563','suresh.iyer@gmail.com','1990-03-15','G3'),(25,22,'Kavya Bhat',22,'FEMALE','+919680123454','kavya.bhat@gmail.com','2003-12-15','H1'),(26,23,'Ravi Pandey',34,'MALE','+919669012345','ravi.pandey@gmail.com','1991-03-22','H2'),(27,24,'Ishaan Malhotra',23,'MALE','+919658901236','ishaan.malhotra@gmail.com','2002-07-09','H3'),(28,25,'Tanvi Jain',28,'FEMALE','+919647890127','tanvi.jain@gmail.com','1997-11-01','I1'),(29,25,'Tanvi Jain (Guest)',29,'MALE','+919647890127','tanvi.jain@gmail.com','1996-06-20','I2'),(30,26,'Deepak Rao',29,'MALE','+919636789018','deepak.rao@gmail.com','1996-04-17','I3'),(31,27,'Aisha Khan',25,'FEMALE','+919625678909','aisha.khan@gmail.com','2000-09-26','J1'),(32,28,'Rahul Sharma',25,'MALE','+919876543210','rahul.sharma@gmail.com','2000-05-15','J2'),(33,29,'Priya Mehta',27,'FEMALE','+919823456781','priya.mehta@gmail.com','1998-08-22','J3'),(34,29,'Priya Mehta (Guest)',24,'FEMALE','+919823456781','priya.mehta@gmail.com','2001-06-10','J4'),(35,30,'Sneha Kulkarni',24,'FEMALE','+919812345672','sneha.kulkarni@gmail.com','2001-11-30','K1'),(36,31,'Amit Verma',30,'MALE','+919801234563','amit.verma@gmail.com','1995-03-10','K2'),(37,32,'Divya Nair',26,'FEMALE','+919790123454','divya.nair@gmail.com','1999-07-18','K3'),(38,34,'Ajay Patil',55,'FEMALE','+917906066648','ajsdhfksh@gmaol.com','2026-03-31','A1');
/*!40000 ALTER TABLE `passengers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `amount` double NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `razorpay_order_id` varchar(100) DEFAULT NULL,
  `razorpay_payment_id` varchar(100) DEFAULT NULL,
  `razorpay_signature` varchar(200) DEFAULT NULL,
  `payment_status` varchar(20) NOT NULL DEFAULT 'SUCCESS',
  `payment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_payments_booking_id` (`booking_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (5,6,4725,'RAZORPAY','order_SavaC8RlCn7Inx','pay_SavaNlCbsJIK3U','26ab0e11d5431aa4940ba39c756b0d1aece136bff40afafd1e92a91dbfe9e85d','SUCCESS','2026-04-08 13:41:32'),(6,7,4725,'RAZORPAY','order_SawJf3Rv3Sj25r','pay_SawLI6kPbM3ciX','a6f3c5e332bc8b686bfa80bd14f77a9c462d419d75e12b8060509fdcca235edf','SUCCESS','2026-04-08 14:25:47'),(7,8,3500,'RAZORPAY','order_AA001aaa001','pay_AA001pay001','sig_aa001sig001aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-25 10:05:00'),(8,9,9600,'RAZORPAY','order_AA002bbb002','pay_AA002pay002','sig_aa002sig002aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-25 11:05:00'),(9,10,2200,'RAZORPAY','order_AA003ccc003','pay_AA003pay003','sig_aa003sig003aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-26 09:05:00'),(10,11,5200,'RAZORPAY','order_AA004ddd004','pay_AA004pay004','sig_aa004sig004aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-26 10:35:00'),(11,12,8200,'RAZORPAY','order_AA005eee005','pay_AA005pay005','sig_aa005sig005aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-27 08:05:00'),(12,13,4100,'RAZORPAY','order_AA006fff006','pay_AA006pay006','sig_aa006sig006aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-27 09:35:00'),(13,15,4600,'RAZORPAY','order_AA008hhh008','pay_AA008pay008','sig_aa008sig008aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-28 11:05:00'),(14,16,5600,'RAZORPAY','order_AA009iii009','pay_AA009pay009','sig_aa009sig009aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-29 09:05:00'),(15,17,5300,'RAZORPAY','order_AA010jjj010','pay_AA010pay010','sig_aa010sig010aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-29 10:05:00'),(16,18,3500,'RAZORPAY','order_AA011kkk011','pay_AA011pay011','sig_aa011sig011aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-30 08:35:00'),(17,19,4800,'RAZORPAY','order_AA012lll012','pay_AA012pay012','sig_aa012sig012aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-30 09:35:00'),(18,21,10400,'RAZORPAY','order_AA014nnn014','pay_AA014pay014','sig_aa014sig014aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-03-31 11:05:00'),(19,22,4100,'RAZORPAY','order_AA015ooo015','pay_AA015pay015','sig_aa015sig015aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-04-01 09:05:00'),(20,23,4100,'RAZORPAY','order_AA016ppp016','pay_AA016pay016','sig_aa016sig016aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-04-01 10:05:00'),(21,24,5000,'RAZORPAY','order_AA017qqq017','pay_AA017pay017','sig_aa017sig017aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-04-02 08:05:00'),(22,25,9200,'RAZORPAY','order_AA018rrr018','pay_AA018pay018','sig_aa018sig018aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-04-02 09:35:00'),(23,27,5300,'RAZORPAY','order_AA020ttt020','pay_AA020pay020','sig_aa020sig020aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-04-03 11:05:00'),(24,28,4900,'RAZORPAY','order_AA021uuu021','pay_AA021pay021','sig_aa021sig021aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-04-04 09:05:00'),(25,29,10200,'RAZORPAY','order_AA022vvv022','pay_AA022pay022','sig_aa022sig022aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-04-04 10:05:00'),(26,30,3500,'RAZORPAY','order_AA023www023','pay_AA023pay023','sig_aa023sig023aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-04-05 08:05:00'),(27,31,4800,'RAZORPAY','order_AA024xxx024','pay_AA024pay024','sig_aa024sig024aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-04-05 09:35:00'),(28,32,2200,'RAZORPAY','order_AA025yyy025','pay_AA025pay025','sig_aa025sig025aabbccddeeff00112233445566778899aabbccddeeff00112233','SUCCESS','2026-04-06 10:05:00');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refunds`
--

DROP TABLE IF EXISTS `refunds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refunds` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `user_id` int NOT NULL,
  `refund_amount` double NOT NULL,
  `refund_reason` text,
  `refund_status` varchar(20) NOT NULL DEFAULT 'PENDING',
  `approved_at` datetime DEFAULT NULL,
  `requested_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_refunds_user_id` (`user_id`),
  KEY `idx_refunds_booking_id` (`booking_id`),
  KEY `idx_refunds_status` (`refund_status`),
  CONSTRAINT `refunds_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `refunds_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refunds`
--

LOCK TABLES `refunds` WRITE;
/*!40000 ALTER TABLE `refunds` DISABLE KEYS */;
INSERT INTO `refunds` VALUES (1,6,13,4725,'100% refund (cancelled >24h before departure)','APPROVED','2026-04-08 14:05:03','2026-04-08 14:04:39'),(2,11,17,5200,'100% refund (cancelled >24h before departure)','APPROVED','2026-03-27 09:00:00','2026-03-27 08:00:00'),(3,17,23,5300,'100% refund (cancelled >24h before departure)','APPROVED','2026-03-30 08:00:00','2026-03-30 07:00:00'),(4,23,29,4100,'100% refund (cancelled >24h before departure)','APPROVED','2026-04-02 09:00:00','2026-04-02 08:00:00'),(5,30,16,3500,'100% refund (cancelled >24h before departure)','APPROVED','2026-04-06 08:00:00','2026-04-06 07:00:00');
/*!40000 ALTER TABLE `refunds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `address` text,
  `role` varchar(10) NOT NULL DEFAULT 'USER',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (11,'admin','admin@gmail.com','$2a$12$6kbOwzp1v4z/N4FSitNhVereplV6E7NLqAOSRLazCCOKJARyZLMce','7906066648','2006-01-03','MALE','Karad - Tasgaon Road , palus','ADMIN',1,'2026-04-07 11:39:29'),(12,'Ajay Patil','ajaypatil8eight@gmail.com','$2a$12$Z/GeiouqoIE.V01sdn7ya.EVLkHEIR7WxHjm0pUodYMyej44kqoF6','7906066648','2006-01-03','MALE','Karad - Tasgaon Road , palus','USER',1,'2026-04-08 07:26:03'),(13,'Ajay Patil','aj9411979585@gmail.com','$2a$12$zQYC11gVHv.IpsE9HCUybeXEpvqtRqcaB2JGdNz/Wtw.JjW/iVoAK','7906066648','2006-01-03','MALE','Karad - Tasgaon Road , palus','USER',1,'2026-04-08 07:46:25'),(14,'Rahul Sharma','rahul.sharma@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9876543210','2000-05-15','MALE','12 MG Road, Pune','USER',1,'2026-03-01 03:30:00'),(15,'Priya Mehta','priya.mehta@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9823456781','1998-08-22','FEMALE','45 Andheri West, Mumbai','USER',1,'2026-03-02 04:30:00'),(16,'Sneha Kulkarni','sneha.kulkarni@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9812345672','2001-11-30','FEMALE','78 FC Road, Pune','USER',1,'2026-03-03 05:30:00'),(17,'Amit Verma','amit.verma@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9801234563','1995-03-10','MALE','23 Connaught Place, Delhi','USER',1,'2026-03-04 04:00:00'),(18,'Divya Nair','divya.nair@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9790123454','1999-07-18','FEMALE','56 MG Road, Bengaluru','USER',1,'2026-03-05 05:00:00'),(19,'Karan Singh','karan.singh@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9779012345','1997-12-05','MALE','34 Park Street, Kolkata','USER',1,'2026-03-06 02:30:00'),(20,'Ananya Reddy','ananya.reddy@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9768901236','2002-04-25','FEMALE','89 Banjara Hills, Hyderabad','USER',1,'2026-03-07 03:30:00'),(21,'Rohan Joshi','rohan.joshi@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9757890127','1996-09-14','MALE','11 Shivaji Nagar, Pune','USER',1,'2026-03-08 05:30:00'),(22,'Meera Pillai','meera.pillai@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9746789018','2000-01-28','FEMALE','67 Anna Nagar, Chennai','USER',1,'2026-03-09 04:30:00'),(23,'Vikas Gupta','vikas.gupta@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9735678909','1994-06-03','MALE','90 Hazratganj, Lucknow','USER',1,'2026-03-10 03:30:00'),(24,'Pooja Desai','pooja.desai@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9724567890','1998-10-19','FEMALE','15 CG Road, Ahmedabad','USER',1,'2026-03-11 04:30:00'),(25,'Arjun Kapoor','arjun.kapoor@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9713456781','2001-02-11','MALE','33 Linking Road, Mumbai','USER',1,'2026-03-12 05:30:00'),(26,'Neha Tiwari','neha.tiwari@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9702345672','1999-05-07','FEMALE','50 Gomti Nagar, Lucknow','USER',1,'2026-03-13 03:30:00'),(27,'Suresh Iyer','suresh.iyer@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9691234563','1993-08-30','MALE','22 T Nagar, Chennai','USER',1,'2026-03-14 04:30:00'),(28,'Kavya Bhat','kavya.bhat@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9680123454','2003-12-15','FEMALE','77 Indiranagar, Bengaluru','USER',1,'2026-03-15 05:30:00'),(29,'Ravi Pandey','ravi.pandey@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9669012345','1991-03-22','MALE','88 Ashok Nagar, Bhopal','USER',1,'2026-03-16 03:30:00'),(30,'Ishaan Malhotra','ishaan.malhotra@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9658901236','2002-07-09','MALE','44 Model Town, Delhi','USER',1,'2026-03-17 04:30:00'),(31,'Tanvi Jain','tanvi.jain@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9647890127','1997-11-01','FEMALE','61 Vastrapur, Ahmedabad','USER',1,'2026-03-18 05:30:00'),(32,'Deepak Rao','deepak.rao@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9636789018','1996-04-17','MALE','18 Jubilee Hills, Hyderabad','USER',1,'2026-03-19 03:30:00'),(33,'Aisha Khan','aisha.khan@gmail.com','$2a$12$abcdefghijklmnopqrstuuVwXyZ0123456789abcdefghijklmnop','9625678909','2000-09-26','FEMALE','55 Salt Lake, Kolkata','USER',1,'2026-03-20 04:30:00');
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

-- Dump completed on 2026-04-15 14:28:08

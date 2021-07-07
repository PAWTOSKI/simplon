CREATE DATABASE  IF NOT EXISTS `surveydw` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `surveydw`;
-- MySQL dump 10.13  Distrib 8.0.24, for Win64 (x86_64)
--
-- Host: localhost    Database: surveydw
-- ------------------------------------------------------
-- Server version	8.0.24

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
-- Table structure for table `fact_survey_info`
--

DROP TABLE IF EXISTS `fact_survey_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_survey_info` (
  `survey_id` int NOT NULL AUTO_INCREMENT,
  `survey_year` int DEFAULT NULL,
  `salary_usd` int DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `primary_database_id` int DEFAULT NULL,
  `years_with_this_database` int DEFAULT NULL,
  `employment_status` varchar(70) DEFAULT NULL,
  `job_title` varchar(110) DEFAULT NULL,
  `manage_staff` tinyint DEFAULT NULL,
  `years_with_this_type_of_job` int DEFAULT NULL,
  `how_many_companies` int DEFAULT NULL,
  `other_people_on_your_team` int DEFAULT NULL,
  `company_employees_overall` int DEFAULT NULL,
  `database_servers` int DEFAULT NULL,
  `education` varchar(30) DEFAULT NULL,
  `education_computer_related` tinyint DEFAULT NULL,
  `certifications` varchar(35) DEFAULT NULL,
  `hours_worked_per_week` int DEFAULT NULL,
  `telecommute_days_per_week` int DEFAULT NULL,
  `newest_version_in_production` varchar(90) DEFAULT NULL,
  `oldest_version_in_production` varchar(90) DEFAULT NULL,
  `population_of_largest_city_within_20_miles` int DEFAULT NULL,
  `employment sector` varchar(45) DEFAULT NULL,
  `looking_for_another_job` varchar(45) DEFAULT NULL,
  `career_plan_this_year` varchar(50) DEFAULT NULL,
  `gender` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`survey_id`),
  KEY `idx_fact_survey_info_primary_database_id` (`primary_database_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_duty`
--

DROP TABLE IF EXISTS `job_duty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_duty` (
  `job_duty_id` int NOT NULL,
  `job_duty_name` varchar(110) DEFAULT NULL,
  PRIMARY KEY (`job_duty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `other_database`
--

DROP TABLE IF EXISTS `other_database`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `other_database` (
  `other_database_id` int NOT NULL,
  `other_database_name` varchar(90) DEFAULT NULL,
  PRIMARY KEY (`other_database_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `primary_database`
--

DROP TABLE IF EXISTS `primary_database`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `primary_database` (
  `primary_database_id` int NOT NULL,
  `primary_database_name` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`primary_database_id`),
  CONSTRAINT `fk_prim_db` FOREIGN KEY (`primary_database_id`) REFERENCES `fact_survey_info` (`primary_database_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_job_duty`
--

DROP TABLE IF EXISTS `survey_job_duty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey_job_duty` (
  `survey_id` int NOT NULL,
  `job_duty_id` int NOT NULL,
  PRIMARY KEY (`survey_id`,`job_duty_id`),
  KEY `fk2_idx` (`job_duty_id`),
  CONSTRAINT `fk11` FOREIGN KEY (`survey_id`) REFERENCES `fact_survey_info` (`survey_id`),
  CONSTRAINT `fk21` FOREIGN KEY (`job_duty_id`) REFERENCES `job_duty` (`job_duty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_other_db`
--

DROP TABLE IF EXISTS `survey_other_db`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey_other_db` (
  `survey_id` int NOT NULL,
  `other_database_id` int NOT NULL,
  PRIMARY KEY (`survey_id`,`other_database_id`),
  KEY `fk2_idx` (`other_database_id`),
  CONSTRAINT `fk1` FOREIGN KEY (`survey_id`) REFERENCES `fact_survey_info` (`survey_id`),
  CONSTRAINT `fk2` FOREIGN KEY (`other_database_id`) REFERENCES `other_database` (`other_database_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `survey_task_performed`
--

DROP TABLE IF EXISTS `survey_task_performed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey_task_performed` (
  `survey_id` int NOT NULL,
  `task_performed_id` int NOT NULL,
  PRIMARY KEY (`survey_id`,`task_performed_id`),
  KEY `fk2_idx` (`task_performed_id`),
  CONSTRAINT `fk111` FOREIGN KEY (`survey_id`) REFERENCES `fact_survey_info` (`survey_id`),
  CONSTRAINT `fk211` FOREIGN KEY (`task_performed_id`) REFERENCES `task_performed` (`task_performed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_performed`
--

DROP TABLE IF EXISTS `task_performed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_performed` (
  `task_performed_id` int NOT NULL,
  `task_performed_name` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`task_performed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-28 11:58:02

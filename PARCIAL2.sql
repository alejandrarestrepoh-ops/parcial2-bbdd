-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: bbdd_db
-- ------------------------------------------------------
-- Server version	5.5.5-10.8.8-MariaDB-1:10.8.8+maria~ubu2204

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
-- Table structure for table `auditoria_clientes`
--

DROP TABLE IF EXISTS `auditoria_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) NOT NULL,
  `campo` varchar(30) NOT NULL,
  `valor_anterior` varchar(100) DEFAULT NULL,
  `valor_nuevo` varchar(100) DEFAULT NULL,
  `usuario_sesion` varchar(100) NOT NULL,
  `usuario_privilegios` varchar(100) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_clientes`
--

LOCK TABLES `auditoria_clientes` WRITE;
/*!40000 ALTER TABLE `auditoria_clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `documento` varchar(15) NOT NULL,
  `nombre` varchar(60) NOT NULL,
  `email` varchar(80) NOT NULL,
  `telefono` varchar(15) NOT NULL,
  `sal` char(16) NOT NULL,
  `clave_hash` char(64) NOT NULL,
  `tarjeta_cifrada` varbinary(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `documento` (`documento`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'1112000001','Laura GÃ³mez','laura@correo.com','3104567890','s41L4ur4Xy9Qw2Ab','3ccbdca7f0080dad6d735d834f4570497ce3d8cd5bc39eed6c3f3b8407f6fcb3',_binary '\Z\Ü.û„™É¤1Ý³Ž\êJµ¤\ÏÙ‰z+\Ü\Î)TGUM\ì'),(2,'1112000002','AndrÃ©s Restrepo','andres@correo.com','3157894561','Pm8zt1k4vB7Ng0R','18f1e9bdb76aff6373d84358f7d9d89e52ba249c7954a0e761cee5926f915639',_binary 'X¤L‘Àª\éH\ïA;’_7\r¤\ÏÙ‰z+\Ü\Î)TGUM\ì'),(3,'1112000003','SofÃ­a MarÃ­n','sofia@correo.com','3201237894','Hd3Lr6Ye9Ui20p5W','138a7243a431e14bac780857a482491b7484e8c7be3a5c9042b631d336b4fe4a',_binary 'z\0Â’‚\ÌS2$J\ÅýuÎ®“¤\ÏÙ‰z+\Ü\Î)TGUM\ì');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'Producto A',20000.00,11),(2,'Producto B',1500.00,8),(3,'Producto C',7800.00,0),(4,'Producto D',45000.00,3),(5,'Producto E',12000.00,18),(6,'Producto Y',200.00,2);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `registrado_por` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ventas_cliente` (`cliente_id`),
  KEY `fk_ventas_producto` (`producto_id`),
  CONSTRAINT `fk_ventas_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `fk_ventas_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
/*!40000 ALTER TABLE `ventas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_clientes_publico`
--

DROP TABLE IF EXISTS `vw_clientes_publico`;
/*!50001 DROP VIEW IF EXISTS `vw_clientes_publico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_clientes_publico` AS SELECT 
 1 AS `id`,
 1 AS `nombre`,
 1 AS `documento`,
 1 AS `telefono`,
 1 AS `email`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_productos_inventario`
--

DROP TABLE IF EXISTS `vw_productos_inventario`;
/*!50001 DROP VIEW IF EXISTS `vw_productos_inventario`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_productos_inventario` AS SELECT 
 1 AS `id`,
 1 AS `nombre`,
 1 AS `precio`,
 1 AS `precio_con_iva`,
 1 AS `stock`,
 1 AS `estado_stock`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_ventas_detalle`
--

DROP TABLE IF EXISTS `vw_ventas_detalle`;
/*!50001 DROP VIEW IF EXISTS `vw_ventas_detalle`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_ventas_detalle` AS SELECT 
 1 AS `id`,
 1 AS `fecha`,
 1 AS `cliente`,
 1 AS `producto`,
 1 AS `cantidad`,
 1 AS `total`,
 1 AS `registrado_por`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_clientes_publico`
--

/*!50001 DROP VIEW IF EXISTS `vw_clientes_publico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_clientes_publico` AS select `clientes`.`id` AS `id`,`clientes`.`nombre` AS `nombre`,`fn_enmascarar`(`clientes`.`documento`,4) AS `documento`,`fn_enmascarar`(`clientes`.`telefono`,4) AS `telefono`,concat(left(`clientes`.`email`,2),'***',substr(`clientes`.`email`,locate('@',`clientes`.`email`))) AS `email` from `clientes` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_productos_inventario`
--

/*!50001 DROP VIEW IF EXISTS `vw_productos_inventario`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_productos_inventario` AS select `productos`.`id` AS `id`,`productos`.`nombre` AS `nombre`,`productos`.`precio` AS `precio`,`fn_precio_con_iva`(`productos`.`precio`) AS `precio_con_iva`,`productos`.`stock` AS `stock`,`fn_clasificar_stock`(`productos`.`stock`) AS `estado_stock` from `productos` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_ventas_detalle`
--

/*!50001 DROP VIEW IF EXISTS `vw_ventas_detalle`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_ventas_detalle` AS select `v`.`id` AS `id`,`v`.`fecha` AS `fecha`,`c`.`nombre` AS `cliente`,`p`.`nombre` AS `producto`,`v`.`cantidad` AS `cantidad`,`v`.`total` AS `total`,`v`.`registrado_por` AS `registrado_por` from ((`ventas` `v` join `clientes` `c` on(`c`.`id` = `v`.`cliente_id`)) join `productos` `p` on(`p`.`id` = `v`.`producto_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-21 21:11:43

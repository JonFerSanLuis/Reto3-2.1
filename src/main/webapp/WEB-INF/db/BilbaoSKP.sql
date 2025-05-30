-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.4.19-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.7.0.6859
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para bilbaoskp
CREATE DATABASE IF NOT EXISTS `bilbaoskp` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `bilbaoskp`;

-- Volcando estructura para tabla bilbaoskp.cancelaciones
CREATE TABLE IF NOT EXISTS `cancelaciones` (
  `partida_id` int(11) NOT NULL,
  `fecha_cancelacion` date NOT NULL,
  `num_jugadores` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`partida_id`),
  CONSTRAINT `FK_cancelaciones_partidas_clase` FOREIGN KEY (`partida_id`) REFERENCES `partidas_clase` (`id_partida`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla bilbaoskp.cancelaciones: ~0 rows (aproximadamente)

-- Volcando estructura para tabla bilbaoskp.centros
CREATE TABLE IF NOT EXISTS `centros` (
  `id_suscriptor` int(11) NOT NULL AUTO_INCREMENT,
  `cod_centro` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `responsable` varchar(100) NOT NULL,
  `num_alumnos` int(11) NOT NULL,
  `email` varchar(50) NOT NULL DEFAULT '',
  `telefono` varchar(20) NOT NULL,
  `tipo_suscriptor` enum('centro','ordinario') DEFAULT NULL,
  PRIMARY KEY (`id_suscriptor`),
  CONSTRAINT `FK_centros_suscriptores` FOREIGN KEY (`id_suscriptor`) REFERENCES `suscriptores` (`id_suscriptor`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla bilbaoskp.centros: ~2 rows (aproximadamente)
INSERT INTO `centros` (`id_suscriptor`, `cod_centro`, `nombre`, `responsable`, `num_alumnos`, `email`, `telefono`, `tipo_suscriptor`) VALUES
	(13, '0', 'San Luis 2', 'Erlantz', 344, 'peperodrigues@gmail.com', '65553215', 'centro'),
	(42, '1234', 'Dayron', 'Juan Puertas', 200, 'aldo.dayron81@gmail.com', '683270192', 'centro');

-- Volcando estructura para tabla bilbaoskp.clases
CREATE TABLE IF NOT EXISTS `clases` (
  `nom_clase` varchar(100) NOT NULL,
  `id_suscriptor` int(11) NOT NULL,
  PRIMARY KEY (`nom_clase`),
  KEY `FK_clases_centros` (`id_suscriptor`),
  CONSTRAINT `FK_clases_centros` FOREIGN KEY (`id_suscriptor`) REFERENCES `centros` (`id_suscriptor`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla bilbaoskp.clases: ~0 rows (aproximadamente)

-- Volcando estructura para tabla bilbaoskp.compra
CREATE TABLE IF NOT EXISTS `compra` (
  `cod_compra` int(11) NOT NULL AUTO_INCREMENT,
  `id_cupon` int(11) NOT NULL,
  `producto` varchar(50) NOT NULL,
  `pago` double NOT NULL DEFAULT 0,
  `fecha` date NOT NULL,
  `id_suscriptor` int(11) NOT NULL,
  PRIMARY KEY (`cod_compra`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla bilbaoskp.compra: ~1 rows (aproximadamente)
INSERT INTO `compra` (`cod_compra`, `id_cupon`, `producto`, `pago`, `fecha`, `id_suscriptor`) VALUES
	(3, 0, 'cupon', 1.5, '2025-05-29', 0),
	(4, 0, 'Cupon - Bullying', 1.5, '2025-05-30', 42);

-- Volcando estructura para tabla bilbaoskp.cupones
CREATE TABLE IF NOT EXISTS `cupones` (
  `id_cupon` int(11) NOT NULL AUTO_INCREMENT,
  `id_suscriptor` int(11) NOT NULL,
  `tipo` varchar(120) NOT NULL,
  `fecha_caducidad` date NOT NULL,
  `estado` enum('usado','disponible','en uso') NOT NULL DEFAULT 'disponible',
  PRIMARY KEY (`id_cupon`),
  KEY `FK__suscriptores` (`id_suscriptor`),
  CONSTRAINT `FK__suscriptores` FOREIGN KEY (`id_suscriptor`) REFERENCES `suscriptores` (`id_suscriptor`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla bilbaoskp.cupones: ~185 rows (aproximadamente)
INSERT INTO `cupones` (`id_cupon`, `id_suscriptor`, `tipo`, `fecha_caducidad`, `estado`) VALUES
	(59, 13, 'Bullying', '2026-05-29', 'en uso'),
	(60, 13, 'Bullying', '2026-05-29', 'en uso'),
	(61, 13, 'Bullying', '2026-05-29', 'en uso'),
	(62, 13, 'Bullying', '2026-05-29', 'en uso'),
	(63, 13, 'Bullying', '2026-05-29', 'en uso'),
	(84, 42, 'Bullying', '2026-05-29', 'disponible'),
	(85, 42, 'Bullying', '2026-05-29', 'disponible'),
	(86, 42, 'Bullying', '2026-05-29', 'disponible'),
	(87, 42, 'Bullying', '2026-05-29', 'disponible'),
	(88, 42, 'Bullying', '2026-05-29', 'disponible'),
	(89, 42, 'Bullying', '2026-05-29', 'disponible'),
	(90, 42, 'Bullying', '2026-05-29', 'disponible'),
	(91, 42, 'Bullying', '2026-05-29', 'disponible'),
	(92, 42, 'Bullying', '2026-05-29', 'disponible'),
	(93, 42, 'Bullying', '2026-05-29', 'disponible'),
	(94, 42, 'Bullying', '2026-05-29', 'disponible'),
	(95, 42, 'Bullying', '2026-05-29', 'disponible'),
	(96, 42, 'Bullying', '2026-05-29', 'disponible'),
	(97, 42, 'Bullying', '2026-05-29', 'disponible'),
	(98, 42, 'Bullying', '2026-05-29', 'disponible'),
	(99, 42, 'Bullying', '2026-05-29', 'disponible'),
	(100, 42, 'Bullying', '2026-05-29', 'disponible'),
	(101, 42, 'Bullying', '2026-05-29', 'disponible'),
	(102, 42, 'Bullying', '2026-05-29', 'disponible'),
	(103, 42, 'Bullying', '2026-05-29', 'disponible'),
	(104, 42, 'Bullying', '2026-05-29', 'disponible'),
	(105, 42, 'Bullying', '2026-05-29', 'disponible'),
	(106, 42, 'Bullying', '2026-05-29', 'disponible'),
	(107, 42, 'Bullying', '2026-05-29', 'disponible'),
	(108, 42, 'Bullying', '2026-05-29', 'disponible'),
	(109, 42, 'Bullying', '2026-05-29', 'disponible'),
	(110, 42, 'Bullying', '2026-05-29', 'disponible'),
	(111, 42, 'Bullying', '2026-05-29', 'disponible'),
	(112, 42, 'Bullying', '2026-05-29', 'disponible'),
	(113, 42, 'Bullying', '2026-05-29', 'disponible'),
	(114, 42, 'Bullying', '2026-05-29', 'disponible'),
	(115, 42, 'Bullying', '2026-05-29', 'disponible'),
	(116, 42, 'Bullying', '2026-05-29', 'disponible'),
	(117, 42, 'Bullying', '2026-05-29', 'disponible'),
	(118, 42, 'Bullying', '2026-05-29', 'disponible'),
	(119, 42, 'Bullying', '2026-05-29', 'disponible'),
	(120, 42, 'Bullying', '2026-05-29', 'disponible'),
	(121, 42, 'Bullying', '2026-05-29', 'disponible'),
	(122, 42, 'Bullying', '2026-05-29', 'disponible'),
	(123, 42, 'Bullying', '2026-05-29', 'disponible'),
	(124, 42, 'Bullying', '2026-05-29', 'disponible'),
	(125, 42, 'Bullying', '2026-05-29', 'disponible'),
	(126, 42, 'Bullying', '2026-05-29', 'disponible'),
	(127, 42, 'Bullying', '2026-05-29', 'disponible'),
	(128, 42, 'Bullying', '2026-05-29', 'disponible'),
	(129, 42, 'Bullying', '2026-05-29', 'disponible'),
	(130, 42, 'Bullying', '2026-05-29', 'disponible'),
	(131, 42, 'Bullying', '2026-05-29', 'disponible'),
	(132, 42, 'Bullying', '2026-05-29', 'disponible'),
	(133, 42, 'Bullying', '2026-05-29', 'disponible'),
	(134, 42, 'Bullying', '2026-05-29', 'disponible'),
	(135, 42, 'Bullying', '2026-05-29', 'disponible'),
	(136, 42, 'Bullying', '2026-05-29', 'disponible'),
	(137, 42, 'Bullying', '2026-05-29', 'disponible'),
	(138, 42, 'Bullying', '2026-05-29', 'disponible'),
	(139, 42, 'Bullying', '2026-05-29', 'disponible'),
	(140, 42, 'Bullying', '2026-05-29', 'disponible'),
	(141, 42, 'Bullying', '2026-05-29', 'disponible'),
	(142, 42, 'Bullying', '2026-05-29', 'disponible'),
	(143, 42, 'Bullying', '2026-05-29', 'disponible'),
	(144, 42, 'Bullying', '2026-05-29', 'disponible'),
	(145, 42, 'Bullying', '2026-05-29', 'disponible'),
	(146, 42, 'Bullying', '2026-05-29', 'disponible'),
	(147, 42, 'Bullying', '2026-05-29', 'disponible'),
	(148, 42, 'Bullying', '2026-05-29', 'disponible'),
	(149, 42, 'Bullying', '2026-05-29', 'disponible'),
	(150, 42, 'Bullying', '2026-05-29', 'disponible'),
	(151, 42, 'Bullying', '2026-05-29', 'disponible'),
	(152, 42, 'Bullying', '2026-05-29', 'disponible'),
	(153, 42, 'Bullying', '2026-05-29', 'disponible'),
	(154, 42, 'Bullying', '2026-05-29', 'disponible'),
	(155, 42, 'Bullying', '2026-05-29', 'disponible'),
	(156, 42, 'Bullying', '2026-05-29', 'disponible'),
	(157, 42, 'Bullying', '2026-05-29', 'disponible'),
	(158, 42, 'Bullying', '2026-05-29', 'disponible'),
	(159, 42, 'Bullying', '2026-05-29', 'disponible'),
	(160, 42, 'Bullying', '2026-05-29', 'disponible'),
	(161, 42, 'Bullying', '2026-05-29', 'disponible'),
	(162, 42, 'Bullying', '2026-05-29', 'disponible'),
	(163, 42, 'Bullying', '2026-05-29', 'disponible'),
	(164, 42, 'Bullying', '2026-05-29', 'disponible'),
	(165, 42, 'Bullying', '2026-05-29', 'disponible'),
	(166, 42, 'Bullying', '2026-05-29', 'disponible'),
	(167, 42, 'Bullying', '2026-05-29', 'disponible'),
	(168, 42, 'Bullying', '2026-05-29', 'disponible'),
	(169, 42, 'Bullying', '2026-05-29', 'disponible'),
	(170, 42, 'Bullying', '2026-05-29', 'disponible'),
	(171, 42, 'Bullying', '2026-05-29', 'disponible'),
	(172, 42, 'Bullying', '2026-05-29', 'disponible'),
	(173, 42, 'Bullying', '2026-05-29', 'disponible'),
	(174, 42, 'Bullying', '2026-05-29', 'disponible'),
	(175, 42, 'Bullying', '2026-05-29', 'disponible'),
	(176, 42, 'Bullying', '2026-05-29', 'disponible'),
	(177, 42, 'Bullying', '2026-05-29', 'disponible'),
	(178, 42, 'Bullying', '2026-05-29', 'disponible'),
	(179, 42, 'Bullying', '2026-05-29', 'disponible'),
	(180, 42, 'Bullying', '2026-05-29', 'disponible'),
	(181, 42, 'Bullying', '2026-05-29', 'disponible'),
	(182, 42, 'Bullying', '2026-05-29', 'disponible'),
	(183, 42, 'Bullying', '2026-05-29', 'disponible'),
	(184, 42, 'Bullying', '2026-05-29', 'disponible'),
	(185, 42, 'Bullying', '2026-05-29', 'disponible'),
	(186, 42, 'Bullying', '2026-05-29', 'disponible'),
	(187, 42, 'Bullying', '2026-05-29', 'disponible'),
	(188, 42, 'Bullying', '2026-05-29', 'disponible'),
	(189, 42, 'Bullying', '2026-05-29', 'disponible'),
	(190, 42, 'Bullying', '2026-05-29', 'disponible'),
	(191, 42, 'Bullying', '2026-05-29', 'disponible'),
	(192, 42, 'Bullying', '2026-05-29', 'disponible'),
	(193, 42, 'Bullying', '2026-05-29', 'disponible'),
	(194, 42, 'Bullying', '2026-05-29', 'disponible'),
	(195, 42, 'Bullying', '2026-05-29', 'disponible'),
	(196, 42, 'Bullying', '2026-05-29', 'disponible'),
	(197, 42, 'Bullying', '2026-05-29', 'disponible'),
	(198, 42, 'Bullying', '2026-05-29', 'disponible'),
	(199, 42, 'Bullying', '2026-05-29', 'disponible'),
	(200, 42, 'Bullying', '2026-05-29', 'disponible'),
	(201, 42, 'Bullying', '2026-05-29', 'disponible'),
	(202, 42, 'Bullying', '2026-05-29', 'disponible'),
	(203, 42, 'Bullying', '2026-05-29', 'disponible'),
	(204, 42, 'Bullying', '2026-05-29', 'disponible'),
	(205, 42, 'Bullying', '2026-05-29', 'disponible'),
	(206, 42, 'Bullying', '2026-05-29', 'disponible'),
	(207, 42, 'Bullying', '2026-05-29', 'disponible'),
	(208, 42, 'Bullying', '2026-05-29', 'disponible'),
	(209, 42, 'Bullying', '2026-05-29', 'disponible'),
	(210, 42, 'Bullying', '2026-05-29', 'disponible'),
	(211, 42, 'Bullying', '2026-05-29', 'disponible'),
	(212, 42, 'Bullying', '2026-05-29', 'disponible'),
	(213, 42, 'Bullying', '2026-05-29', 'disponible'),
	(214, 42, 'Bullying', '2026-05-29', 'disponible'),
	(215, 42, 'Bullying', '2026-05-29', 'disponible'),
	(216, 42, 'Bullying', '2026-05-29', 'disponible'),
	(217, 42, 'Bullying', '2026-05-29', 'disponible'),
	(218, 42, 'Bullying', '2026-05-29', 'disponible'),
	(219, 42, 'Bullying', '2026-05-29', 'disponible'),
	(220, 42, 'Bullying', '2026-05-29', 'disponible'),
	(221, 42, 'Bullying', '2026-05-29', 'disponible'),
	(222, 42, 'Bullying', '2026-05-29', 'disponible'),
	(223, 42, 'Bullying', '2026-05-29', 'disponible'),
	(224, 42, 'Bullying', '2026-05-29', 'disponible'),
	(225, 42, 'Bullying', '2026-05-29', 'disponible'),
	(226, 42, 'Bullying', '2026-05-29', 'disponible'),
	(227, 42, 'Bullying', '2026-05-29', 'disponible'),
	(228, 42, 'Bullying', '2026-05-29', 'disponible'),
	(229, 42, 'Bullying', '2026-05-29', 'disponible'),
	(230, 42, 'Bullying', '2026-05-29', 'disponible'),
	(231, 42, 'Bullying', '2026-05-29', 'disponible'),
	(232, 42, 'Bullying', '2026-05-29', 'disponible'),
	(233, 42, 'Bullying', '2026-05-29', 'disponible'),
	(234, 42, 'Bullying', '2026-05-29', 'disponible'),
	(235, 42, 'Bullying', '2026-05-29', 'disponible'),
	(236, 42, 'Bullying', '2026-05-29', 'disponible'),
	(237, 42, 'Bullying', '2026-05-29', 'disponible'),
	(238, 42, 'Bullying', '2026-05-29', 'disponible'),
	(239, 42, 'Bullying', '2026-05-29', 'disponible'),
	(240, 42, 'Bullying', '2026-05-29', 'disponible'),
	(241, 42, 'Bullying', '2026-05-29', 'disponible'),
	(242, 42, 'Bullying', '2026-05-29', 'disponible'),
	(243, 42, 'Bullying', '2026-05-29', 'disponible'),
	(244, 42, 'Bullying', '2026-05-29', 'disponible'),
	(245, 42, 'Bullying', '2026-05-29', 'disponible'),
	(246, 42, 'Bullying', '2026-05-29', 'disponible'),
	(247, 42, 'Bullying', '2026-05-29', 'disponible'),
	(248, 42, 'Bullying', '2026-05-29', 'disponible'),
	(249, 42, 'Bullying', '2026-05-29', 'disponible'),
	(250, 42, 'Bullying', '2026-05-29', 'disponible'),
	(251, 42, 'Bullying', '2026-05-29', 'disponible'),
	(252, 42, 'Bullying', '2026-05-29', 'disponible'),
	(253, 42, 'Bullying', '2026-05-29', 'disponible'),
	(254, 42, 'Bullying', '2026-05-29', 'disponible'),
	(255, 42, 'Bullying', '2026-05-29', 'disponible'),
	(256, 42, 'Bullying', '2026-05-29', 'disponible'),
	(257, 42, 'Bullying', '2026-05-29', 'disponible'),
	(258, 42, 'Bullying', '2026-05-29', 'disponible'),
	(259, 42, 'Bullying', '2026-05-29', 'disponible'),
	(260, 42, 'Bullying', '2026-05-29', 'disponible'),
	(261, 42, 'Bullying', '2026-05-29', 'disponible'),
	(262, 42, 'Bullying', '2026-05-29', 'disponible'),
	(263, 42, 'Bullying', '2026-05-29', 'disponible'),
	(264, 42, 'Bullying', '2026-05-30', 'disponible');

-- Volcando estructura para tabla bilbaoskp.escape_room
CREATE TABLE IF NOT EXISTS `escape_room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_partida` int(11) NOT NULL,
  `id_suscriptor` int(11) NOT NULL,
  `tiempo_seg` int(11) NOT NULL,
  `pistas_usadas` int(11) NOT NULL,
  `puntos_totales` int(11) NOT NULL,
  `tipo_suscriptor` enum('centro','ordinario') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_escape_room_partida` (`id_partida`),
  KEY `FK_escape_room_suscriptores` (`id_suscriptor`),
  CONSTRAINT `FK_escape_room_partida` FOREIGN KEY (`id_partida`) REFERENCES `partida` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_escape_room_suscriptores` FOREIGN KEY (`id_suscriptor`) REFERENCES `suscriptores` (`id_suscriptor`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla bilbaoskp.escape_room: ~0 rows (aproximadamente)

-- Volcando estructura para tabla bilbaoskp.partida
CREATE TABLE IF NOT EXISTS `partida` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_suscriptor` int(11) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `tipo_partida` enum('centro','ordinaria') NOT NULL,
  `fecha` date NOT NULL,
  `idioma` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_partida_suscriptores1` (`id_suscriptor`),
  CONSTRAINT `FK_partida_suscriptores1` FOREIGN KEY (`id_suscriptor`) REFERENCES `suscriptores` (`id_suscriptor`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla bilbaoskp.partida: ~21 rows (aproximadamente)
INSERT INTO `partida` (`id`, `id_suscriptor`, `nombre`, `tipo_partida`, `fecha`, `idioma`) VALUES
	(8, 13, 'Bullying', 'centro', '2025-05-31', 'es'),
	(9, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(10, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(11, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(12, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(13, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(14, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(15, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(16, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(17, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(18, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(19, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(20, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(21, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(22, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(23, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(24, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(25, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(26, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(27, 42, 'Bullying', 'centro', '2025-06-18', 'es'),
	(28, 42, 'Bullying', 'centro', '2025-06-18', 'es');

-- Volcando estructura para tabla bilbaoskp.partidas_clase
CREATE TABLE IF NOT EXISTS `partidas_clase` (
  `id_partida` int(11) NOT NULL,
  `nom_clase` varchar(100) NOT NULL,
  `fecha_activacion` date NOT NULL,
  `num_jugadores` int(11) NOT NULL DEFAULT 0,
  `estado` varchar(50) NOT NULL,
  `cod_partida` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_partida`),
  KEY `FK_partidas_clase_clases` (`nom_clase`),
  CONSTRAINT `FK_partidas_clase_clases` FOREIGN KEY (`nom_clase`) REFERENCES `clases` (`nom_clase`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_partidas_clase_partida` FOREIGN KEY (`id_partida`) REFERENCES `partida` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla bilbaoskp.partidas_clase: ~0 rows (aproximadamente)

-- Volcando estructura para tabla bilbaoskp.plan_suscripcion
CREATE TABLE IF NOT EXISTS `plan_suscripcion` (
  `tipo_suscripcion` varchar(100) NOT NULL,
  `descripcion` varchar(500) NOT NULL,
  `precio` int(11) NOT NULL,
  PRIMARY KEY (`tipo_suscripcion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla bilbaoskp.plan_suscripcion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla bilbaoskp.suscriptores
CREATE TABLE IF NOT EXISTS `suscriptores` (
  `id_suscriptor` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `estado` varchar(100) NOT NULL,
  `fecha_alta` date NOT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `correo` varchar(50) DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_suscriptor`),
  UNIQUE KEY `usernameUnique` (`username`),
  KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla bilbaoskp.suscriptores: ~8 rows (aproximadamente)
INSERT INTO `suscriptores` (`id_suscriptor`, `username`, `estado`, `fecha_alta`, `tipo`, `password`, `correo`, `edad`) VALUES
	(4, 'GamerPro123', 'activo', '2023-01-15', 'ordinario', 'password123', 'gamer123@email.com', 25),
	(5, 'MasterGamer', 'activo', '2023-02-20', 'ordinario', 'password456', 'master@email.com', 30),
	(6, 'GameWizard', 'activo', '2023-03-10', 'ordinario', 'password789', 'wizard@email.com', 22),
	(7, 'PlayerOne', 'activo', '2023-04-05', 'ordinario', 'password101', 'player1@email.com', 28),
	(8, 'GameChampion', 'activo', '2023-05-12', 'ordinario', 'password202', 'champion@email.com', 19),
	(13, 'Erlantz', 'activo', '2025-04-27', 'centro', 'temporal', 'aldo.dayron81@gmail.com', 0),
	(32, 'Jon', 'estado', '2025-05-20', 'admin', '1234', 'jon@gmail.com', 12),
	(42, 'Juan', 'activo', '2025-05-29', 'centro', '1234', 'aldo.dayron81@gmail.com', 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

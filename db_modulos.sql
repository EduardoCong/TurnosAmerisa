-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-06-2024 a las 22:25:42
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `db_controlturnos`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `db_modulos`
--

CREATE TABLE `db_modulos` (
  `id_modulo` int(11) NOT NULL,
  `nombre_modulo` varchar(50) DEFAULT NULL,
  `servicios` text DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `fecha_registro` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `db_modulos`
--

INSERT INTO `db_modulos` (`id_modulo`, `nombre_modulo`, `servicios`, `estado`, `fecha_registro`) VALUES
(1, 'ANDEN 3', '[\"1\",\"5\"]', 'A', NULL),
(5, 'ANDEN 2', '[\"1\",\"2\"]', 'I', '2022-09-26 11:31:15'),
(6, 'ANDEN 1', '[\"2\"]', 'A', '2022-09-26 14:37:51');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `db_modulos`
--
ALTER TABLE `db_modulos`
  ADD PRIMARY KEY (`id_modulo`) USING BTREE;

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `db_modulos`
--
ALTER TABLE `db_modulos`
  MODIFY `id_modulo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

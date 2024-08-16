-- phpMyAdmin SQL Dump
-- version 5.2.1-1.el9
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 15, 2024 at 02:53 PM
-- Server version: 11.4.3-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_psa2`
--
CREATE DATABASE IF NOT EXISTS `db_psa2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `db_psa2`;

-- --------------------------------------------------------

--
-- Table structure for table `servers_data`
--

CREATE TABLE `servers_data` (
  `id` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `host` varchar(25) NOT NULL,
  `cpu` decimal(12,2) NOT NULL,
  `mem_total` decimal(12,2) NOT NULL,
  `mem_libre` decimal(12,2) NOT NULL,
  `mem_usada` decimal(12,2) NOT NULL,
  `disco_total` decimal(12,2) NOT NULL,
  `disco_libre` decimal(12,2) NOT NULL,
  `disco_usado` decimal(12,2) NOT NULL,
  `usuarios_activos` int(11) NOT NULL,
  `interfaz` varchar(25) NOT NULL,
  `data_rx` decimal(12,2) NOT NULL,
  `data_tx` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `servers_data`
--
ALTER TABLE `servers_data`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `servers_data`
--
ALTER TABLE `servers_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

/*=============================================================
CREAR LA BASE DE DATOS: 'psa2'
==============================================================*/
CREATE DATABASE psa2 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


/*============================================================
CREAR LA TABLA PRINCIPAL 'SERVIDORES' EN LA BASE DE DATOS
=============================================================*/
USE psa2;

CREATE TABLE `SERVER_DATA` (
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

/*=============================================================
CREAR USUARIO PARA ADMINISTRACION:
  username: psa2
  password: psa2

NOTA: Si su sistema operativo usa SElinux, debe 
configurarlo en modo 'permissive'.
==============================================================*/

GRANT ALL PRIVILEGES ON *.* TO 'psa2'@'localhost' IDENTIFIED BY 'psa2';
FLUSH PRIVILEGES;





/*=============================================================
CREAR LA BASE DE DATOS: 'psa2'
==============================================================*/
CREATE DATABASE psa2 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


/*============================================================
CREAR LA TABLA PRINCIPAL DE LA BASE DE DATOS: 'SERVIDORES'
=============================================================*/
USE psa2;

CREATE TABLE SERVIDORES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL,
    host VARCHAR(255) NOT NULL,
    cpu DECIMAL(5, 2) NOT NULL,
    memoria DECIMAL(5, 2) NOT NULL,
    almacenamiento DECIMAL(5, 2) NOT NULL,
    temperatura DECIMAL(5, 2) NOT NULL,
    usuarios_activos INT NOT NULL,
    uptime VARCHAR(50) NOT NULL,
    interfaz VARCHAR(255) NOT NULL,
    data_rx DECIMAL(10, 2) NOT NULL,
    data_tx DECIMAL(10, 2) NOT NULL
);

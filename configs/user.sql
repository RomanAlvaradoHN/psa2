/*=============================================================
CREAR USUARIO PARA ADMINISTRACION:
  username: psa2
  password: psa2

NOTA: Si su sistema operativo usa SElinux, debe 
configurarlo en modo 'permissive'.
==============================================================*/

GRANT ALL PRIVILEGES ON *.* TO 'psa2'@'localhost' IDENTIFIED BY 'psa2';
FLUSH PRIVILEGES;
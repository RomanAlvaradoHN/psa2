#!/bin/bash

##########################################################################################
# MENU PRINCIPAL
##########################################################################################
menu_principal(){

  while true ; do

    respuesta=$(whiptail --title "((   MENU PRINCIPAL  ))" --menu "¿Qué desea hacer?" 20 80 6 \
        "1" "Administrar usuarios" \
        "2" "Estado del PC"        \
        "3" "Instalacion PSA"      \
        "4" "Desinstalacion PSA"   \
        "5" "Salir"                \
      3>&1 1>&2 2>&3
    )
    
    if [ $? == 0 ]; then
      case $respuesta in

        "1") menu_administracion_usuarios ;;

        "2") menu_estado_del_pc ;;

        "3") menu_instalacion_psa ;;

        "4") menu_desinstalacion_psa ;;

        "5") break ;;

          *) continue ;;
      esac

    else
      break;
    fi
  done
}









##########################################################################################
# ADMINISTRACION DE USUARIOS
##########################################################################################

#=========================================================
# MENUS Y OPCIONES =======================================
menu_administracion_usuarios(){

  while true ; do

    respuesta=$(whiptail --title "ADMINISTRACION DE USUARIOS" --menu "Opciones" 20 80 6 \
        "1" "Crear usuarios"      \
        "2" "Borrar usuarios"     \
        "3" "Regresar"            \
      3>&1 1>&2 2>&3
    )


    if [ $? == 0 ]; then
      case $respuesta in

        "1") menu_crear_usuarios ;;

        "2") menu_borrar_usuarios ;;

        "3") break ;;

          *) continue ;;
      esac

    else
      break;
    fi
  done
}

menu_crear_usuarios(){

  while true ; do

    respuesta=$(whiptail --title "ADMINISTRACION DE USUARIOS => (( CREAR ))" --menu "Opciones" 20 80 6 \
        "1" "Mediante archivo"   \
        "2" "Manual"             \
        "3" "Regresar"           \
      3>&1 1>&2 2>&3
    )


    if [ $? == 0 ]; then
      case $respuesta in

        "1") crear_usuarios_archivo ;;

        "2") crear_usuarios_manual ;;

        "3") break ;;

          *) continue ;;
      esac

    else
      break;
    fi
  done
}

menu_borrar_usuarios(){

  while true ; do

    respuesta=$(whiptail --title "ADMINISTRACION DE USUARIOS => (( BORRAR ))" --menu "Opciones" 20 80 6 \
        "1" "Mediante archivo"   \
        "2" "Manual"             \
        "3" "Regresar"           \
      3>&1 1>&2 2>&3
    )


    if [ $? == 0 ]; then
      case $respuesta in

        "1") borrar_usuarios_archivo ;;

        "2") borrar_usuarios_manual ;;

        "3") break ;;

          *) continue ;;
      esac

    else
      break;
    fi
  done
}



#=========================================================
# PROCESOS Y FUNCIONES ===================================
crear_usuarios_archivo(){
  usuarios_admin -c && touch $flag &
  barra_progreso "Creando usuarios, por favor espere..."
  proceso_finalizado "Usuarios creados!"
}

crear_usuarios_manual(){
  u=$(whiptail --title "Crear usuario manual" --inputbox "Nombre de usuario:" 10 60 3>&1 1>&2 2>&3)

  p=$(whiptail --title "Crear usuario manual" --passwordbox "Contrasenia:" 10 60 3>&1 1>&2 2>&3)
  c=$(whiptail --title "Crear usuario manual" --passwordbox "Confirme contrasenia:" 10 60 3>&1 1>&2 2>&3)

  if [ "$p" = "$c" ]; then
    useradd $u -p $(openssl passwd -1 $p) >/dev/null 2>&1
    whiptail --title "Crear usuario manual" --msgbox "Usuario $u creado." 8 78
  else
    whiptail --title "Atencion" --msgbox "Las contrasenias no coinciden" 8 78
    crear_usuarios_manual
  fi
}


borrar_usuarios_archivo(){
  usuarios_admin -d && touch $flag &
  barra_progreso "Borrando usuarios, por favor espere..."
  proceso_finalizado "Usuarios borrados!"
}

borrar_usuarios_manual(){
  u=$(whiptail --title "Borrar usuario manual" --inputbox "Nombre de usuario:" 10 60 3>&1 1>&2 2>&3)
  if [ $? == 0 ]; then
    userdel -f -r $u >/dev/null 2>&1
    whiptail --title "Borrar usuario manual" --msgbox "Usuario $u borrado." 8 78
  fi
}


usuarios_admin(){
  declare -a USUARIOS
  USUARIOS=($(cat $archivo))

  for i in ${USUARIOS[@]}; do
    if [ $1 = "-c" ]; then
      useradd $i -p $(openssl passwd -1 $i) >/dev/null 2>&1
    elif [ $1 = "-d" ]; then
      userdel -f -r $i >/dev/null 2>&1
    else
      clear
    fi
  done
}









##########################################################################################
# ESTADO DEL PC
##########################################################################################

#=========================================================
# MENUS Y OPCIONES =======================================
menu_estado_del_pc(){

  while true ; do

    respuesta=$(whiptail --title "ESTADO DEL PC" --menu "Opciones" 20 80 6 \
        "1" "Mostrar estado"   \
        "2" "Regresar"         \
     3>&1 1>&2 2>&3)


    if [ $? == 0 ]; then
      case $respuesta in

        "1") mostrar_estado ;;

        "2") break ;;

          *) continue ;;
      esac

    else
      break;
    fi
  done
}



















##########################################################################################
# INSTALACION PSA
##########################################################################################

#=========================================================
# MENUS Y OPCIONES =======================================
instalacion_psa(){

  while true ; do

    respuesta=$(whiptail --title "INSTALACION PSA" --menu "Opciones" 20 80 6 \
        "1" "Instalar Grafana"    \
        "2" "Instalar Node-Red"   \
        "3" "Regresar"            \
     3>&1 1>&2 2>&3)


    if [ $? == 0 ]; then
      case $respuesta in

        "1") instalar_grafana ;;

        "2") instalar_node_red ;;

        "3") break ;;

          *) continue ;;
      esac

    else
      break;
    fi
  done
}



#=========================================================
# PROCESOS Y FUNCIONES ===================================
instalar_grafana(){
  dnf install -y https://dl.grafana.com/enterprise/release/grafana-enterprise-11.1.0-1.x86_64.rpm >/dev/null 2>$log \
  && firewall-cmd --add-port=3000/tcp --permanent >/dev/null 2>&1 && firewall-cmd --reload >/dev/null \
  && systemctl enable grafana-server >/dev/null 2>&1 \
  && systemctl daemon-reload \
  && systemctl start grafana-server \
  && touch $flag \
  &
  barra_progreso "Instalando grafana, por favor espere..."
  proceso_finalizado "Instalacion de grafana completada"
}

instalar_node_red(){
  npm install -g --unsafe-perm node-red >/dev/null 2>$log \
  && firewall-cmd --add-port=1880/tcp --permanent >/dev/null 2>&1 && firewall-cmd --reload >/dev/null \
  && touch $flag \
  &
  barra_progreso "Instalando node-red, por favor espere..."
  proceso_finalizado "Instalacion node-red completada"
}








##########################################################################################
# DESINSTALACION PSA
##########################################################################################

#=========================================================
# MENUS Y OPCIONES =======================================
desinstalacion_psa(){

  while true ; do

    respuesta=$(whiptail --title "DESINSTALACION PSA" --menu "Opciones" 20 80 6 \
        "1" "Desinstalar Grafana"    \
        "2" "Desinstalar Node-Red"   \
        "3" "Regresar"               \
     3>&1 1>&2 2>&3)


    if [ $? == 0 ]; then
      case $respuesta in

        "1") desinstalar_grafana ;;

        "2") desinstalar_node_red ;;

        "3") break ;;

          *) continue ;;
      esac

    else
      break;
    fi
  done
}


#=========================================================
# PROCESOS Y FUNCIONES ===================================
desinstalar_grafana(){
  systemctl stop grafana-server >/dev/null 2>&1 \
  && dnf remove grafana-enterprise -y >/dev/null 2>$log \
  && firewall-cmd --remove-port=3000/tcp --permanent >/dev/null 2>&1 && firewall-cmd --reload >/dev/null \
  && touch $flag \
  &
  barra_progreso "Desinstalando grafana, por favor espere..."
  proceso_finalizado "Desinstalacion de grafana completada"
}

desinstalar_node_red(){
  npm uninstall -g node-red >/dev/null 2>$log \
  && firewall-cmd --remove-port=1880/tcp --permanent >/dev/null 2>&1 && firewall-cmd --reload >/dev/null \
  && touch $flag \
  &
  barra_progreso "desinstalando node-red, por favor espere..."
  proceso_finalizado "Desinstalacion de node-red completada"
}







##########################################################################################
# UTILIDADES DEL SCRIPT
##########################################################################################

#=========================================================
# VARIABLES GLOBALES =====================================
log="$(pwd)/installer_log"
flag="$(pwd)/stop_progress_bar"
archivo="$HOME/psafiles/usuarios"


#=========================================================
# BARRA DE PROGRESO ======================================
barra_progreso(){
  {
    for (( i=10; i<=100; i++ )) ; do
      echo $i
      if [ -e $flag ] ; then
        echo 100
        break;
      fi
      sleep 10
    done
    sleep 3
  } | whiptail --gauge "${1}" 6 80 0
  rm -f $flag
}


#=========================================================
# FINALIZACION DE PROCESO ================================
proceso_finalizado(){
  msj=$1

  if [ -s $log ] ; then
    msj="Algo salio mal, revise el archivo: ${log}"
  else
    rm -f $log
  fi

  whiptail --title "proceso finalizado" --msgbox "$msj" 10 80
}








##########################################################################################
# INICIALIZADOR DEL SCRIPT
##########################################################################################
menu_principal

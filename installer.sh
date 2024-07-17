#!/bin/bash


#VARIABLES GLOBALES================================
log="$(pwd)/installer_log"
flag="$(pwd)/stop_progress_bar"


menu_principal(){

  while true ; do

    respuesta=$(whiptail --title "Instalador de apps" --menu "¿Qué desea hacer?" 20 80 6 \
        "1" "instalar node-red"    \
        "2" "instalar grafana"     \
        "3" "desinstalar node-red" \
        "4" "desinstalar grafana"  \
        "5" "salir"                \
     3>&1 1>&2 2>&3)


    if [ $? == 0 ]; then
      case $respuesta in

        "1") instalar_node_red ;;

        "2") instalar_grafana ;;

        "3") desinstalar_node_red ;;

        "4") desinstalar_grafana ;;

          *) break ;;
      esac
    fi
  done

  clear
}



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
  } | whiptail --gauge "${1}..." 6 80 0
  rm -f $flag
}


proceso_finalizado(){
  msj=$1

  if [ -s $log ] ; then
    msj="Algo salio mal, revise el archivo: ${log}"
  else
    rm -f $log
  fi

  whiptail --title "proceso finalizado" --msgbox "$msj" 10 80
}







instalar_node_red(){
  npm install -g --unsafe-perm node-red >/dev/null 2>$log && touch $flag &
  barra_progreso "Instalando node-red, por favor espere..."
  proceso_finalizado "Instalacion node-red completada"
}

desinstalar_node_red(){
  npm uninstall -g node-red >/dev/null 2>$log && touch $flag &
  barra_progreso "desinstalando node-red, por favor espere"
  proceso_finalizado "Desinstalacion de node-red completada"
}





instalar_grafana(){
  dnf install -y https://dl.grafana.com/enterprise/release/grafana-enterprise-11.1.0-1.x86_64.rpm >/dev/null 2>$log && touch $flag &
  barra_progreso "Instalando grafana, por favor espere..."
  proceso_finalizado "Instalacion de grafana completada"
}

desinstalar_grafana(){
  dnf remove grafana -y >/dev/null 2>$log && touch $flag &
  barra_progreso "Desinstalando grafana, por favor espere..."
  proceso_finalizado "Desinstalacion de grafana completada"
}



menu_principal

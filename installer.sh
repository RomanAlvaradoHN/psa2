#!/bin/bash


log="$(pwd)/installer_log"

respuesta=$(whiptail --title "Instalador de apps" --menu "¿Qué desea hacer?" 20 80 6 \
    "1" "instalar node-red" \
    "2" "instalar grafana" \
    "3" "desinstalar node-red" \
    "4" "desinstalar grafana" \
    "5" "salir" \
   3>&1 1>&2 2>&3)


barra_progreso(){
  {
    i=0
    while [ -e $log ] ; do
      echo $i
      sleep 10
      i=$((i + 1))
    done
    echo 100
    sleep 1
  } | whiptail --gauge "${1}..." 6 80 0
}


proceso_finalizado(){
  mensaje="$1"

 if [ -e $log ] ; then
    mensaje="Algo salió mal, revise el archivo: $log"
  fi

  whiptail --title "proceso finalizado" --msgbox "$mensaje" 10 80
  clear
}







instalar_node_red(){
  proceso="instalando node-red"
  $((npm install -g --unsafe-perm node-red >$log 2>$log) && rm -fr $log) &
  barra_progreso "$proceso"
  proceso_finalizado "$proceso"
}

desinstalar_node_red(){
  proceso="desinstalando node-red"
  $((npm uninstall -g node-red >$log 2>$log) && rm -fr $log) &
  barra_progreso "$proceso"
  proceso_finalizado "$proceso"
}





instalar_grafana(){
  proceso="instalando grafana"
  $((yum install -y https://dl.grafana.com/enterprise/release/grafana-enterprise-11.1.0-1.x86_64.rpm >$log 2>$log) && rm -fr $log) &
  barra_progreso "$proceso"
  proceso_finalizado "$proceso"
}

desinstalar_grafana(){
  proceso="desinstalando grafana"
  $((dnf remove grafana -y >$log 2>$log) && rm -fr $log) &
  barra_progreso "$proceso"
  proceso_finalizado "$proceso"
}


if [ $? == 0 ]; then
  case $respuesta in

    "1") instalar_node_red ;;

    "2") instalar_grafana ;;

    "3") desinstalar_node_red ;;

    "4") desinstalar_grafana ;;

    "5") clear ; exit ;;

      *) clear; exit ;;

    esac
fi

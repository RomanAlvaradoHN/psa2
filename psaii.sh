#!/bin/bash

##########################################################################################
# MENU PRINCIPAL
##########################################################################################
menu_principal(){
  titulo="((  MENU PRINCIPAL PSAII  ))"
  texto="¿Que desea hacer?"
  
  while true ; do
    respuesta=$(whiptail --title "$titulo" --menu "$texto" 20 80 6 \
      "1" "Instalacion PSA"      \
      "2" "Desinstalacion PSA"   \
      "3" "Salir"                \
      3>&1 1>&2 2>&3
    )

    if [ $? -eq 0 ]; then
      case $respuesta in
        "1") instalacion_psa ;;
        "2") desinstalacion_psa ;;
        "3") exit 0 ;;
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
  instalacion_psa(){
    rm -fr /usr/bin/psaii.sh && ln -s "$(pwd)/psaii.sh" /usr/bin
    rm -fr /usr/bin/psa && ln -s "$(pwd)/configs/psa" /usr/bin

    instalar_grafana
    instalar_mariadb
    instalar_node_red
    instalar_nginx
    instalar_phpmyadmin
    proceso_finalizado "Instalacion de servidores completada"
  }
  



  instalar_grafana(){
    (validar -s grafana-server)
    if [ $? -eq 0 ]; then
      wget -q -O configs/grafana/gpg.key https://rpm.grafana.com/gpg.key \
      && rpm --import $configs/grafana/gpg.key \
      && cp $configs/grafana/grafana.repo /etc/yum.repos.d/ \
      && dnf install -y grafana-enterprise >/dev/null 2>$log \
      && firewall_port_manager -add 3000/tcp \
      && touch $flag \
      &
      barra_progreso "Instalando grafana, por favor espere..."
      #proceso_finalizado "Instalacion de grafana completada"
    fi
  }


  instalar_node_red(){
    #Sub_funciones==========================
    instalar_fnm(){
      (validar -b fnm)
      if [ $? -eq 0 ]; then
        curl -fsSL https://fnm.vercel.app/install | bash >/dev/null 2>&1
        source $HOME/.bashrc >/dev/null 2>&1
      fi
    }

    instalar_nodejs(){
      (validar -b node)
      if [ $? -eq 0 ]; then
        instalar_fnm
        version=$(fnm list-remote | grep Iron | tail -n 1)
        vnum=$(echo $version | awk -F'[v.]' '{print $2}')
        fnm use --install-if-missing $vnum >/dev/null 2>&1
      fi
    }

    instalar_comando_serverdata(){
      rm -fr /usr/bin/serverdata
      ln -s "$HOME/.node-red/serverdata" /usr/bin
    }
    #=======================================

    (validar -b node-red)
    if [ $? -eq 0 ]; then
      instalar_nodejs \
      && npm install -g --unsafe-perm node-red >/dev/null 2>$log\
      && firewall_port_manager "node-red" -add \
      && mkdir -p $HOME/.node-red \
      && cp -r configs/node-red/* $HOME/.node-red/ \
      && cd $HOME/.node-red \
      && npm install node-red-node-mysql >/dev/null 2>$log \
      && firewall_port_manager --add 1880/tcp \
      && instalar_comando_serverdata \
      && touch $flag \
      &
      barra_progreso "Instalando node-red, por favor espere..."
      #proceso_finalizado "Instalacion de node-red completada"
    fi
  }

  instalar_mariadb(){
    (validar -s mariadb.service)
    if [ $? -eq 0 ]; then
      (curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash >/dev/null 2>&1) \
      && dnf install -y MariaDB-server >/dev/null 2>$log \
      && firewall_port_manager -add 3306/tcp \
      && systemctl enable mariadb.service >/dev/null 2>&1 \
      && systemctl start mariadb.service \
      && mariadb < configs/mariadb/user.sql >/dev/null 2>$log \
      && mariadb < configs/mariadb/db_psa2.sql >/dev/null 2>$log \
      && touch $flag \
      &
      barra_progreso "Instalando MariaDB, por favor espere..."
      #proceso_finalizado "Instalacion de mysql completada"
    fi
  }

  instalar_nginx(){
    (validar -s nginx)
    if [ $? -eq 0 ]; then
      dnf install nginx -y >/dev/null 2>$log \
      && touch $flag \
      &
      barra_progreso "Instalando nginx, por favor espere..."
      #proceso_finalizado "Instalacion de nginx completada"
    fi
  }

  instalar_phpmyadmin(){
    (validar -d /usr/share/phpMyAdmin)
    if [ $? -eq 0 ]; then
      dnf install phpmyadmin -y >/dev/null 2>$log \
      && cp configs/phpmyadmin/phpmyadmin.conf /etc/nginx/conf.d/ >/dev/null 2>&1 \
      && sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config >/dev/null 2>$log \
      && setenforce 0 \
      && touch $flag \
      &
      barra_progreso "Instalando phpMyAdmin, por favor espere..."
      #proceso_finalizado "Instalacion de phpMyAdmin completada"
    fi
  }
#






##########################################################################################
# DESINSTALACION PSA
##########################################################################################
  desinstalacion_psa(){
    rm -fr /usr/bin/psaii.sh
    rm -fr /usr/bin/psa

    desinstalar_grafana
    desinstalar_mariadb
    desinstalar_node_red
    desinstalar_phpmyadmin
    desinstalar_nginx
    proceso_finalizado "Desinstalacion de servidores completada"
  }


  desinstalar_grafana(){
    (validar -s grafana-server)
    if [ $? -eq 1 ]; then
      dnf remove grafana-enterprise -y >/dev/null 2>&1 \
      && systemctl daemon-reload \
      && rm -fr /etc/grafana /var/lib/grafana \
      && rm -fr /etc/yum.repos.d/grafana.repo \
      && firewall_port_manager "grafana-server" -rm \
      && touch $flag \
      &
      barra_progreso "Desinstalando grafana, por favor espere..."
      #proceso_finalizado "Desinstalacion de grafana completada"
    fi
  }

  desinstalar_mariadb(){
    (validar -s mariadb)
    if [ $? -eq 1 ]; then
      systemctl stop mariadb.service >/dev/null 2>&1
      dnf remove -y mariadb >/dev/null 2>&1 \
      && rm -fr /etc/yum.repos.d/mariadb.* \
      && rm -fr /etc/my.cnf /etc/mysql /var/lib/mysql $HOME/.mariadb_history \
      && firewall_port_manager "mariadb" -rm \
      && touch $flag \
      &
      barra_progreso "desinstalando MariaDB, por favor espere..."
      #proceso_finalizado "Desinstalacion de mysql completada"
    fi
  }

  desinstalar_node_red(){
    #Sub_funciones==========================
    desinstalar_fnm(){
      (validar -b fnm)
      if [ $? -eq 1 ]; then
        #.bashrc----
        archivo="$HOME/.bashrc"
        cp $HOME/.bashrc $HOME/.bashrc.backup
        patron="# fnm"
        conteo=$(grep "$patron" "$archivo" | wc -l)    
        for (( i=0; i<$conteo; i++)); do
            linea=$(grep -n "$patron" "$archivo" | awk -F: '{print $1}' | head -n 1)
            sed -i "$linea,+5d" "$archivo"
        done
        # fnm-------
        rm -fr $(dirname $(command -v fnm))
        source "$archivo" >/dev/null 2>$log
      fi
    }

    desinstalar_nodejs(){
      (validar -b node)
      if [ $? -eq 1 ]; then
        fnm uninstall $(fnm current) >/dev/null 2>$log
        rm -fr $HOME/.npm
        desinstalar_fnm
      fi
    }
    #=======================================
      
    (validar -b node-red)
    if [ $? -eq 1 ]; then
      npm uninstall -g node-red >/dev/null 2>&1 \
      && firewall_port_manager "node-red" -rm \
      && rm -fr $HOME/.node* /usr/bin/serverdata\
      && desinstalar_nodejs \
      && touch $flag \
      &
      barra_progreso "desinstalando node-red, por favor espere..."
      #proceso_finalizado "Desinstalacion de node-red completada"
    fi
  }

  desinstalar_phpmyadmin(){

    (validar -d /usr/share/phpMyAdmin)
    if [ $? -eq 1 ]; then
      dnf remove phpmyadmin -y >/dev/null 2>$log \
      && rm -fr /etc/nginx/conf.d/phpmyadmin.conf  /var/lib/phpMyAdmin \
      && sed -i 's/SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config >/dev/null 2>$log \
      && setenforce 1 \
      && touch $flag \
      &
      barra_progreso "desinstalando phpMyAdmin, por favor espere..."
      #proceso_finalizado "Desinstalacion de phpMyAdmin completada"
    fi
  }

  desinstalar_nginx(){
    (validar -s nginx)
    if [ $? -eq 1 ]; then
      systemctl disable nginx >/dev/null 2>&1 \
      && dnf remove nginx -y >/dev/null 2>$log \
      && rm -fr /etc/nginx \
      && touch $flag \
      &
      barra_progreso "desinstalando nginx, por favor espere..."
      #proceso_finalizado "Desinstalacion de nginx completada"
    fi
  }
#







##########################################################################################
# UTILIDADES NECESARIAS PARA EL SCRIPT
##########################################################################################

  #=========================================================
  # VARIABLES GLOBALES =====================================
  log="$HOME/psaii_log"
  flag="$HOME/stop_progress_bar"
  configs="$(pwd)/configs"


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


  #=========================================================
  # FIREWALL ADD/REMOVE PORT ===============================
  firewall_port_manager(){
    case $1 in
      "-add") firewall-cmd --add-port=$2 --permanent >/dev/null 2>$log ;;

      "-rm") firewall-cmd --remove-port=$2 --permanent >/dev/null 2>$log ;;
    esac

    firewall-cmd --reload >/dev/null 2>&1
  }


  #=========================================================
  # VALIDAR DIRECTORIO, SERVICIO, BINARIO EN EL PATH
  # DEVUELVE 1 SI EXISTE, DEVUELVE 0 SI NO EXISTE
  #=========================================================
  validar(){
    case $1 in
      #directorio -d
      "-d") ls "$2" >/dev/null 2>&1 ;;
      
      #servicio -s
      "-s") systemctl stop "$2" >/dev/null 2>&1 ;;

      #binario en $PATH
      "-b") command -v "$2" >/dev/null 2>&1 ;;
    esac

    if [ $? -eq 0 ]; then
      exit 1
    else
      exit 0
    fi
  }
#



##########################################################################################
# INICIALIZADOR DEL SCRIPT
##########################################################################################
menu_principal

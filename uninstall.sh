#!/bin/bash

INNFARM_HOME=/opt/inn-farm/
SERVICE_HOME=${INNFARM_HOME}/ltepi/

function assert_root {
  if [[ $EUID -ne 0 ]]; then
     echo "This script must be run as root" 
     exit 1
  fi
}

function uninstall {
  rm -f /etc/network/interfaces
  install -o root -g root -D -m 644 /etc/network/interfaces.bak /etc/network/interfaces && rm -f /etc/network/interfaces.bak
  rm -f /etc/rc.local
  install -o root -g root -D -m 755 /etc/rc.local.bak /etc/rc.local && rm -f /etc/rc.local.bak

  cd ${SERVICE_HOME}/bin
  ltepi-uninstall.sh ${SERVICE_HOME}/bin

  rm -fr ${SERVICE_HOME}
  [ "$(ls -A ${INNFARM_HOME})" ] || rmdir ${INNFARM_HOME}
}

assert_root
uninstall

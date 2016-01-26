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
  rm -f /etc/network/interfaces.d/ltepi.conf

  for p in $(ls /usr/bin/ltepi*); do
    rm -f ${p}
  done

  cd ${SERVICE_HOME}/bin
  ./ltepi-uninstall.sh ${SERVICE_HOME}/bin

  rm -fr ${SERVICE_HOME}
  [ "$(ls -A ${INNFARM_HOME})" ] || rmdir ${INNFARM_HOME}
}

assert_root
uninstall

#!/bin/bash

VENDOR_HOME=/opt/inn-farm
SERVICE_HOME=${VENDOR_HOME}/ltepi/
BIN_PATH=${SERVICE_HOME}/bin

function assert_root {
  if [[ $EUID -ne 0 ]]; then
     echo "This script must be run as root" 
     exit 1
  fi
}

function uninstall {
  ltepi_disconnect
  ltepi_off
  rm -f /etc/network/interfaces.d/ltepi.conf

  for p in $(ls /usr/bin/ltepi*); do
    rm -f ${p}
  done

  cd ${SERVICE_HOME}/bin
  ./ltepi-uninstall.sh ${SERVICE_HOME}/bin

  rm -fr ${SERVICE_HOME}
  [ "$(ls -A ${VENDOR_HOME})" ] || rmdir ${VENDOR_HOME}
}

assert_root
uninstall

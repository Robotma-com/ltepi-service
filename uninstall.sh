#!/bin/bash

VENDOR_HOME=/opt/inn-farm

SERVICE_NAME=ltepi
SERVICE_HOME=${VENDOR_HOME}/ltepi
BIN_PATH=${SERVICE_HOME}/bin

REBOOT=0

function err {
  echo -e "\033[91m[ERROR] $1\033[0m"
}

function info {
  echo -e "\033[92m[INFO] $1\033[0m"
}

function alert {
  echo -e "\033[93m[ALERT] $1\033[0m"
}

function assert_root {
  if [[ $EUID -ne 0 ]]; then
     echo "This script must be run as root" 
     exit 1
  fi
}

function uninstall_cli {
  for p in $(ls /usr/bin/ltepi*); do
    rm -f ${p}
  done

  cd ${BIN_PATH}
  ./ltepi-uninstall.sh ${BIN_PATH}
  rm -fr ${BIN_PATH}
  REBOOT=1
}

function uninstall_service {
  RET=`systemctl | grep ${SERVICE_NAME}.service`
  RET=$?
  if [ "${RET}" == "0" ]; then
    systemctl stop ${SERVICE_NAME}
    systemctl disable ${SERVICE_NAME}
  fi

  LIB_SYSTEMD="$(dirname $(dirname $(which systemctl)))/lib/systemd"
  rm -f ${LIB_SYSTEMD}/system/${SERVICE_NAME}.service
  rm -f ${SERVICE_HOME}/environment
  rm -f ${SERVICE_HOME}/*.sh
  rm -f ${SERVICE_HOME}/*.py
  rm -f ${SERVICE_HOME}/*.pyc
  info "${SERVICE_NAME} has been uninstalled"
  REBOOT=1
}

function teardown {
  [ "$(ls -A ${SERVICE_HOME})" ] || rmdir ${SERVICE_HOME}
  [ "$(ls -A ${VENDOR_HOME})" ] || rmdir ${VENDOR_HOME}
  if [ "${REBOOT}" == "1" ]; then
    alert "*** Please reboot the system! (enter 'reboot') ***"
  fi
}

# main
assert_root
uninstall_service
uninstall_cli

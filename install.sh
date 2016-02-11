#!/bin/bash

VENDOR_HOME=/opt/inn-farm

SERVICE_NAME=ltepi
GITHUB_ID=Robotma-com/ltepi-service
VERSION=2.0.0

LTEPI_GITHUB_ID=Robotma-com/ltepi
LTEPI_VERSION=0.9.5

SERVICE_HOME=${VENDOR_HOME}/${SERVICE_NAME}
SRC_DIR="${SRC_DIR:-/tmp/ltepi-service-${VERSION}}"
BIN_PATH=${SERVICE_HOME}/bin

KERNEL="${KERNEL:-$(uname -r)}"
CONTAINER_MODE=0
if [ "${KERNEL}" != "$(uname -r)" ]; then
  CONTAINER_MODE=1
fi

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

function setup {
  [ "${DEBUG}" ] || rm -fr ${SRC_DIR}
}

function assert_root {
  if [[ $EUID -ne 0 ]]; then
     echo "This script must be run as root"
     exit 1
  fi
}

function abort_if_installed {
  if [ -f "${SERVICE_HOME}/bin/version.txt" ]; then
    err "Already installed"
    exit 1
  fi
}

function download {
  if [ -d "${SRC_DIR}" ]; then
    return
  fi
  cd /tmp
  curl -L https://github.com/${GITHUB_ID}/archive/${VERSION}.tar.gz | tar zx
}

function install_cli {
  download
  info "Installing command lines to ${BIN_PATH}..."
  for f in $(ls ${SRC_DIR}/bin); do
    install -o root -g root -D -m 755 ${SRC_DIR}/bin/${f} ${BIN_PATH}/${f}
  done
  install -o root -g root -D -m 755 ${SRC_DIR}/uninstall.sh ${BIN_PATH}/uninstall.sh

  for p in $(ls ${SRC_DIR}/bin/ltepi_*); do
    f=$(basename ${p})
    ln -sn ${BIN_PATH}/${f} /usr/bin/${f}
  done

  info "Installing config files to ${BIN_PATH}..."
  echo "${VERSION}" > ${SRC_DIR}/bin/version.txt
  install -o root -g root -D -m 644 ${SRC_DIR}/bin/version.txt ${BIN_PATH}/version.txt
  install -o root -g root -D -m 644 ${SRC_DIR}/apn.json ${BIN_PATH}/apn.json
  REBOOT=1
}

function install_ltepi {
  download
  info "Installing LTEPi Python Library..."
  cd /tmp
  if [ ! -d "/tmp/ltepi-${LTEPI_VERSION}" ]; then
    curl -L https://github.com/${LTEPI_GITHUB_ID}/archive/${LTEPI_VERSION}.tar.gz | tar zx
  fi
  cd /tmp/ltepi-${LTEPI_VERSION}
  ./install.sh ${BIN_PATH}
  [ "${DEBUG}" ] || rm -rf /tmp/ltepi-${LTEPI_VERSION}
  REBOOT=1
}

function install_service {
  RET=`systemctl | grep ${SERVICE_NAME}.service`
  RET=$?
  if [ "${RET}" == "0" ]; then
    return
  fi
  download

  LIB_SYSTEMD="$(dirname $(dirname $(which systemctl)))"
  if [ "${LIB_SYSTEMD}" == "/" ]; then
    LIB_SYSTEMD=""
  fi
  LIB_SYSTEMD="${LIB_SYSTEMD}/lib/systemd"

  mkdir -p ${SERVICE_HOME}
  install -o root -g root -D -m 644 ${SRC_DIR}/systemd/environment ${SERVICE_HOME}
  FILES=`ls ${SRC_DIR}/systemd/*.sh`
  FILES="${FILES} `ls ${SRC_DIR}/systemd/server_*.py`"
  for f in ${FILES}
  do
    install -o root -g root -D -m 755 ${f} ${SERVICE_HOME}
  done

  cp -f ${SRC_DIR}/systemd/${SERVICE_NAME}.service.txt ${SRC_DIR}/systemd/${SERVICE_NAME}.service
  sed -i -e "s/%VERSION%/${VERSION//\//\\/}/g" ${SRC_DIR}/systemd/${SERVICE_NAME}.service

  install -o root -g root -D -m 644 ${SRC_DIR}/systemd/${SERVICE_NAME}.service ${LIB_SYSTEMD}/system/
  systemctl enable ${SERVICE_NAME}
  info "${SERVICE_NAME} service has been installed"
  REBOOT=1
}

function teardown {
  [ "${DEBUG}" ] || rm -fr ${SRC_DIR}
  if [ "${CONTAINER_MODE}" == "0" ] && [ "${REBOOT}" == "1" ]; then
    alert "*** Please reboot the system! (enter 'sudo reboot') ***"
  fi
}

function package {
  rm -f $(basename ${GITHUB_ID})-${VERSION}.tgz
  # http://unix.stackexchange.com/a/9865
  COPYFILE_DISABLE=1 tar --exclude="./.*" -zcf $(basename ${GITHUB_ID})-${VERSION}.tgz *
}

if [ "$1" == "pack" ]; then
  package
  exit 0
fi

# main
assert_root
abort_if_installed
setup
install_cli
install_ltepi
install_service
teardown

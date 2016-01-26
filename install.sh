#!/bin/bash

VERSION=1.0.1
LTEPI_VERSION=0.9.5

INNFARM_HOME=/opt/inn-farm/
SERVICE_HOME=${INNFARM_HOME}/ltepi/
GITHUB_ID=Robotma-com/ltepi-setup
SRC_DIR="${SRC_DIR:-/tmp/ltepi-setup-${VERSION}}"

function err {
  echo -e "\033[91m[ERROR] $1\033[0m"
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

function setup {
  export VERSION
  export LTEPI_VERSION
  cd ${SRC_DIR}
  ./setup
}

function package {
  rm -f ltepi-setup-${VERSION}.tgz
  # http://unix.stackexchange.com/a/9865
  COPYFILE_DISABLE=1 tar --exclude="./.*" -zcf ltepi-setup-${VERSION}.tgz *
}

if [ "$1" == "pack" ]; then
  package
  exit 0
fi

assert_root
abort_if_installed
download
setup

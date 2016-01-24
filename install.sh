#!/bin/bash

VERSION=1.0.1
LTEPI_VERSION=0.9.5

INNFARM_HOME=/opt/inn-farm/
SERVICE_HOME=${INNFARM_HOME}/ltepi/
GITHUB_ID=Robotma-com/ltepi-setup
SRC_DIR="${SRC_DIR:-/tmp/ltepi-setup-${VERSION}}"

function assert_root {
  if [[ $EUID -ne 0 ]]; then
     echo "This script must be run as root" 
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

assert_root
download
setup

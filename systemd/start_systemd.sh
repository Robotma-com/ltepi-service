#!/usr/bin/env bash

# Copyright (c) 2016 Innovation Farm, Inc.

# start banner
logger -s "Initializing LTEPi Board..."

/opt/inn-farm/ltepi/bin/modem_on > /dev/null 2>&1
RET=$(ltepi_select_sim)
if [ "$?" != "0" ]; then
  for i in 1 2 3 4 5; do
    sleep 5
    RET=$(ltepi_select_sim)
    if [ "$?" == "0" ]; then
      RET=""
      break
    fi
  done
  if [ "${RET}" != "" ]; then
    logger -s "Failed to initialize: ${RET}"
    exit 1
  fi
fi

if [ "${LTEPI_CONNECT_ON_BOOT}" == "1" ]; then
  ltepi_connect
fi

# end banner
logger -s "LTEPi Board is initialized successfully!"

/usr/bin/env python /opt/inn-farm/ltepi/server_main.py usb0

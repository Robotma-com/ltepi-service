#!/usr/bin/env bash

# Copyright (c) 2016 Innovation Farm, Inc.

# start banner
logger -s "Initializing LTEPi Board..."

/opt/inn-farm/ltepi/bin/modem_on > /dev/null 2>&1
if [ "${LTEPI_CONNECT_ON_BOOT}" == "1" ]; then
  ltepi_connect
fi

# end banner
logger -s "LTEPi Board is initialized successfully!"

/usr/bin/env python /opt/inn-farm/ltepi/server_main.py usb0

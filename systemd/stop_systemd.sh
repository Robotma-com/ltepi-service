#!/usr/bin/env bash

# Copyright (c) 2016 Innovation Farm, Inc.

# start banner
logger -s "Inactivating LTEPi Board..."

ltepi_disconnect
/opt/inn-farm/ltepi/bin/modem_off > /dev/null 2>&1

# end banner
logger -s "LTEPi Board is inactivated successfully!"

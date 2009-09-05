#!/bin/sh
#
# Description	: Check the tool of autoconf.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#

# check for autoconf.
echo "Checking for autoconf...";
autoconf --version 1> /dev/null || { echo "Error: Install autoconf before continuing."; exit 1; }


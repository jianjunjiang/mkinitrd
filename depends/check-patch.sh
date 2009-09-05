#!/bin/sh
#
# Description	: Check the tool of patch.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# check for patch.
echo "Checking for patch...";
patch -v 1> /dev/null || { echo "Error: Install patch before continuing."; exit 1; }

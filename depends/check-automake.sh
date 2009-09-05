#!/bin/sh
#
# Description	: Check the tool of automake.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#

# check for automake.
echo "Checking for automake...";
automake --version 1> /dev/null || { echo "Error: Install automake before continuing."; exit 1; }

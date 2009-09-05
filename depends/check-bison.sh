#!/bin/sh
#
# Description	: Check the tool of bison.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# check for bison.
echo "Checking for bison...";
bison --version 1> /dev/null || { echo "Error: Install bison before continuing."; exit 1; }

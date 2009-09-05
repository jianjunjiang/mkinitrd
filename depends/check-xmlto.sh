#!/bin/sh
#
# Description	: Check the tool of xmlto.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# check for xmlto.
echo "Checking for xmlto...";
xmlto --version 1> /dev/null || { echo "Error: Install xmlto before continuing."; exit 1; }

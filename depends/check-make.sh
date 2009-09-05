#!/bin/sh
#
# Description	: Check the tool of make.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# Check for make.
echo "Checking for make...";
make -v 1> /dev/null || { echo "Error: Install make before continuing."; exit 1; }

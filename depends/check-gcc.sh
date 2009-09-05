#!/bin/sh
#
# Description	: Check the tool of gcc.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# check for gcc.
echo "Checking for gcc...";
gcc --version 1> /dev/null || { echo "Error: Install gcc before continuing."; exit 1; }

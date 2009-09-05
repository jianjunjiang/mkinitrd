#!/bin/sh
#
# Description	: Check for cross compiler.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# check for cross compiler.
echo "Checking for cross compiler...";
$CROSS"gcc" --version 1> /dev/null || { echo "Error: Install CROSS gcc before continuing.($CROSS)"; exit 1; }

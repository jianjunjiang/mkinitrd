#!/bin/sh
#
# Description	: Check for root permission.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#

# check for root permission.
echo "Checking for root permission...";
[ `id -u` == 0 ] || { echo "Error: You must be root to make stardard file system."; exit 1; }


#!/bin/sh
#
# Description	: Check the tool of cpio.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# Check for cpio.
echo "Checking for cpio...";
cpio --version 1> /dev/null || { echo "Error: Install cpio before continuing."; exit 1; }

#!/bin/sh
#
# Description	: Check the tool of flex.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# check for flex.
echo "Checking for flex...";
flex --version 1> /dev/null || { echo "Error: Install flex before continuing."; exit 1; }

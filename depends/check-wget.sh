#!/bin/sh
#
# Description	: Check the tool of wget.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# Check for wget.
echo "Checking for wget...";
wget -V 1> /dev/null || { echo "Error: Install wget before continuing."; exit 1; }

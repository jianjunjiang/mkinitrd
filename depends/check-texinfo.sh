#!/bin/sh
#
# Description	: Check the tool of texinfo.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# Check for texinfo.
echo "Checking for texinfo...";
makeinfo --version 1> /dev/null || { echo "Error: Install texinfo before continuing."; exit 1; }

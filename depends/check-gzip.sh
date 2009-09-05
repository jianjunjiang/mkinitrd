#!/bin/sh
#
# Description	: Check the tool of gzip.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# Check for gzip.
echo "Checking for gzip...";
gzip --version 1> /dev/null || { echo "Error: Install gzip before continuing."; exit 1; }

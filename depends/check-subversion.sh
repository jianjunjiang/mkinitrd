#!/bin/sh
#
# Description	: Check the tool of subversion.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# Check for subversion.
echo "Checking for subversion...";
svn help 1> /dev/null || { echo "Error: Install subversion before continuing."; exit 1; }

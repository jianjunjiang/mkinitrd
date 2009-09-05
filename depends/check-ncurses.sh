#!/bin/sh
#
# Description	: Check the tool of ncurses.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# Check for a ncurses library.
echo "Checking for ncurses library...";
ls /usr/lib/libncurses.* 1> /dev/null || { echo "Error: Install ncurses before continuing."; exit 1; }

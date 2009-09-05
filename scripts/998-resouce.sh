#!/bin/sh
#
# Description	: The resource script.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# if no enable flag, the script will exit directly.
[ -z $RESOURCE_ENABLE ] || [ $RESOURCE_ENABLE != "y" ] && { exit 0; }

# echo the title.
echo "[resouce] copy resource...";

# source the common function.
source $PROG_DIR/common.sh;

# copy all resource.
cp -a $RESOURCE_DIR/* $INITRD_DIR/ || { exit 1; }
exit 0;

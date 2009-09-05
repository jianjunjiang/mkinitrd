#!/bin/sh
#
# Description	: Wireless Tools for Linux
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: iwconfig iwlist
#
#


# will be compiled with static ?
WIRELESS_TOOLS_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $WIRELESS_TOOLS_ENABLE ] || [ $WIRELESS_TOOLS_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$WIRELESS_TOOLS_CFG" ] && { echo "Error: you must config \$WIRELESS_TOOLS_CFG environment var."; exit 1; }

# echo the title.
echo "[wireless_tools] Create the wireless_tools...";

# set up the url environment of busybox.
WIRELESS_TOOLS_URL=http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/$WIRELESS_TOOLS_CFG.tar.gz;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the busybox.
GetUnpackAndPatch $WIRELESS_TOOLS_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$WIRELESS_TOOLS_CFG" || { echo "Error: Could not enter the $WIRELESS_TOOLS_CFG directory."; exit 1; }

# make wireless_tools.
if [ ! -z $WIRELESS_TOOLS_STATIC ] && [ $WIRELESS_TOOLS_STATIC = "y" ]; then
	echo "not support" && { exit 1; }
else
	sed -ie 's/CC = gcc/CC ?= gcc/' $BUILD_DIR/$WIRELESS_TOOLS_CFG/Makefile || { exit 1; }
	sed -ie 's/AR = ar/AR ?= ar/' $BUILD_DIR/$WIRELESS_TOOLS_CFG/Makefile || { exit 1; }
	sed -ie 's/RANLIB = ranlib/RANLIB ?= ranlib/' $BUILD_DIR/$WIRELESS_TOOLS_CFG/Makefile || { exit 1; }
	sed -ie 's/# BUILD_STATIC = y/BUILD_STATIC = y/' $BUILD_DIR/$WIRELESS_TOOLS_CFG/Makefile || { exit 1; }
	sed -ie 's/# BUILD_NOLIBM = y/BUILD_NOLIBM = y/' $BUILD_DIR/$WIRELESS_TOOLS_CFG/Makefile || { exit 1; }
	sed -ie 's/# BUILD_WE_ESSENTIAL = y/BUILD_WE_ESSENTIAL = y/' $BUILD_DIR/$WIRELESS_TOOLS_CFG/Makefile || { exit 1; }
	sed -ie 's/# BUILD_STRIPPING = y/BUILD_STRIPPING = y/' $BUILD_DIR/$WIRELESS_TOOLS_CFG/Makefile || { exit 1; }
	CC=$CROSS"gcc" AR=$CROSS"ar" RANLIB=$CROSS"ranlib" PREFIX=$BUILD_DIR/$WIRELESS_TOOLS_CFG/wireless_tools_root make || { exit 1; }
	CC=$CROSS"gcc" AR=$CROSS"ar" RANLIB=$CROSS"ranlib" PREFIX=$BUILD_DIR/$WIRELESS_TOOLS_CFG/wireless_tools_root make install || { exit 1; }
	cp -a $BUILD_DIR/$WIRELESS_TOOLS_CFG/wireless_tools_root/sbin/* $INITRD_DIR/sbin/
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

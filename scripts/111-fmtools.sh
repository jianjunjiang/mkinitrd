#!/bin/sh
#
# Description	: fmtools is a pair of simple command-line utilities for “video4linux” radio tuner cards under Linux.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: fm fmscan
#
#


# will be compiled with static ?
FMTOOLS_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $FMTOOLS_ENABLE ] || [ $FMTOOLS_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$FMTOOLS_CFG" ] && { echo "Error: you must config \$FMTOOLS_CFG environment var."; exit 1; }

# echo the title.
echo "[fmtools] Create the fmtools...";

# set up the url environment of fmtools.
FMTOOLS_URL=http://www.stanford.edu/~blp/fmtools/$FMTOOLS_CFG.tar.gz;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the busybox.
GetUnpackAndPatch $FMTOOLS_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$FMTOOLS_CFG" || { echo "Error: Could not enter the $FMTOOLS_CFG directory."; exit 1; }

# make fmtools.
if [ ! -z $FMTOOLS_STATIC ] && [ $FMTOOLS_STATIC = "y" ]; then
	echo "not support" && { exit 1; }
else
	sed -ie 's/CC	= gcc/CC	?= gcc/' $BUILD_DIR/$FMTOOLS_CFG/Makefile || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" DESTDIR=$BUILD_DIR/$FMTOOLS_CFG/fmtools_root make install || { exit 1; }
	cp -a $BUILD_DIR/$FMTOOLS_CFG/fmtools_root/usr/local/bin/* $INITRD_DIR/usr/bin/
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

#!/bin/sh
#
# Description	: lrzsz is a unix communication package providing the XMODEM, YMODEM ZMODEM file transfer protocols.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: rb rx rz sb sx sz
#
#


# will be compiled with static ?
LRZSZ_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $LRZSZ_ENABLE ] || [ $LRZSZ_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$LRZSZ_CFG" ] && { echo "Error: you must config \$LRZSZ_CFG environment var."; exit 1; }

# echo the title.
echo "[lrzsz] Create the lrzsz...";

# set up the url environment of busybox.
LRZSZ_URL=http://www.ohse.de/uwe/releases/$LRZSZ_CFG.tar.gz;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the busybox.
GetUnpackAndPatch $LRZSZ_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$LRZSZ_CFG" || { echo "Error: Could not enter the $LRZSZ_CFG directory."; exit 1; }

# Create and enter the lrzsz build directory.
mkdir -p lrzsz_build && cd lrzsz_build || { exit 1; }

# make lrzsz.
if [ ! -z $LRZSZ_STATIC ] && [ $LRZSZ_STATIC = "y" ]; then
	CC=$CROSS"gcc" CFLAGS=-static CPPFLAGS=-static ../configure --prefix=/usr --program-transform-name=s/l// --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$LRZSZ_CFG/lrzsz_root install || { exit 1; }
	cp -a $BUILD_DIR/$LRZSZ_CFG/lrzsz_root/usr/bin/* $INITRD_DIR/usr/bin/
else
	CC=$CROSS"gcc" ../configure --prefix=/usr --program-transform-name=s/l// --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$LRZSZ_CFG/lrzsz_root install || { exit 1; }
	cp -a $BUILD_DIR/$LRZSZ_CFG/lrzsz_root/usr/bin/* $INITRD_DIR/usr/bin/
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

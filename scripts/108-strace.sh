#!/bin/sh
#
# Description	: strace tool
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: strace
#
#


# will be compiled with static ?
STRACE_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $STRACE_ENABLE ] || [ $STRACE_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$STRACE_CFG" ] && { echo "Error: you must config \$STRACE_CFG environment var."; exit 1; }

# echo the title.
echo "[strace] Create the strace...";

# set up the url environment of fbset.
STRACE_URL=ftp://ftp.linux.hr/gentoo/distfiles/distfiles/$STRACE_CFG.tar.bz2;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the busybox.
GetUnpackAndPatch $STRACE_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$STRACE_CFG" || { echo "Error: Could not enter the $STRACE_CFG directory."; exit 1; }

# Create and enter the lrzsz build directory.
mkdir -p strace_build && cd strace_build || { exit 1; }

# make strace.
if [ ! -z $STRACE_STATIC ] && [ $STRACE_STATIC = "y" ]; then
	CC=$CROSS"gcc" CFLAGS=-static CPPFLAGS=-static ../configure --prefix=/usr --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$STRACE_CFG/strace_root install || { exit 1; }
	cp -a $BUILD_DIR/$STRACE_CFG/strace_root/usr/bin/* $INITRD_DIR/usr/bin/
else
	CC=$CROSS"gcc" ../configure --prefix=/usr --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$STRACE_CFG/strace_root install || { exit 1; }
	cp -a $BUILD_DIR/$STRACE_CFG/strace_root/usr/bin/* $INITRD_DIR/usr/bin/
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

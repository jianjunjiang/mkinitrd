#!/bin/sh
#
# Description	: gdb debug, only have gdbserver.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: gdbserver
#
#


# will be compiled with static ?
GDB_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $GDB_ENABLE ] || [ $GDB_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$GDB_CFG" ] && { echo "Error: you must config \$GDB_CFG environment var."; exit 1; }

# echo the title.
echo "[gdb] Create the gdb...";

# set up the url environment of fbset.
GDB_URL=ftp://ftp.gnu.org/pub/gnu/gdb/$GDB_CFG.tar.bz2;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the busybox.
GetUnpackAndPatch $GDB_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$GDB_CFG/gdb/gdbserver" || { echo "Error: Could not enter the $GDB_CFG/gdb/gdbserver directory."; exit 1; }

# Create and enter the gdb build directory.
mkdir -p gdbserver_build && cd gdbserver_build || { exit 1; }

# make strace.
if [ ! -z $GDB_STATIC ] && [ $GDB_STATIC = "y" ]; then
	CC=$CROSS"gcc" CFLAGS=-static CPPFLAGS=-static ../configure --prefix=/usr --program-transform-name=s/$HOST// --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$GDB_CFG/gdbserver_root install || { exit 1; }
	cp -a $BUILD_DIR/$GDB_CFG/gdbserver_root/usr/bin/* $INITRD_DIR/usr/bin/
else
	CC=$CROSS"gcc" ../configure --prefix=/usr --program-transform-name=s/$HOST// --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$GDB_CFG/gdbserver_root install || { exit 1; }
	cp -a $BUILD_DIR/$GDB_CFG/gdbserver_root/usr/bin/* $INITRD_DIR/usr/bin/
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

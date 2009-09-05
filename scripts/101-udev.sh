#!/bin/sh
#
# Description	: udev for userspace device management.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#
# Functions	: udevd, udevadm
#


# will be compiled with static ?
UDEV_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $UDEV_ENABLE ] || [ $UDEV_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$UDEV_CFG" ] && { echo "Error: you must config \$UDEV_CFG environment var."; exit 1; }

# echo the title.
echo "[udev] Create the udev for userspace device management...";

# set up the url environment of coreutils.
UDEV_URL=http://www.kernel.org/pub/linux/utils/kernel/hotplug/$UDEV_CFG.tar.bz2;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the udev.
GetUnpackAndPatch $UDEV_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# enter the udev's src directory.
cd "$BUILD_DIR/$UDEV_CFG/"|| { echo "Error: Could not enter the $UDEV_CFG/ directory."; exit 1; }

# Create and enter the udev build directory.
mkdir -p udev_build && cd udev_build || { exit 1; }

# make sysvinit.
if [ ! -z $UDEV_STATIC ] && [ $UDEV_STATIC = "y" ]; then
	CC=$CROSS"gcc" CFLAGS=-static CPPFLAGS=-static ../configure --disable-shared --prefix=/usr --exec-prefix=/ --sysconfdir=/etc --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$UDEV_CFG/udev_root install || { exit 1; }
	cp -a $BUILD_DIR/$UDEV_CFG/udev_root/sbin/* $INITRD_DIR/sbin/ || { exit 1; }
	cp -a $BUILD_DIR/$UDEV_CFG/udev_root/lib/* $INITRD_DIR/lib/ || { exit 1; }
else
	CC=$CROSS"gcc" ../configure --disable-shared --prefix=/usr --exec-prefix=/ --sysconfdir=/etc --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$UDEV_CFG/udev_root install || { exit 1; }
	cp -a $BUILD_DIR/$UDEV_CFG/udev_root/sbin/* $INITRD_DIR/sbin/ || { exit 1; }
	cp -a $BUILD_DIR/$UDEV_CFG/udev_root/lib/* $INITRD_DIR/lib/ || { exit 1; }
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

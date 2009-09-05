#!/bin/sh
#
# Description	: The i2c-tools package contains a heterogeneous set of I2C tools for Linux
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: i2cdetect i2cdump
#
#


# will be compiled with static ?
I2CTOOLS_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $I2CTOOLS_ENABLE ] || [ $I2CTOOLS_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$I2CTOOLS_CFG" ] && { echo "Error: you must config \$I2CTOOLS_CFG environment var."; exit 1; }

# echo the title.
echo "[i2ctools] Create the i2ctools...";

# set up the url environment of fmtools.
I2CTOOLS_URL=http://dl.lm-sensors.org/i2c-tools/releases/$I2CTOOLS_CFG.tar.bz2;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the busybox.
GetUnpackAndPatch $I2CTOOLS_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$I2CTOOLS_CFG" || { echo "Error: Could not enter the $I2CTOOLS_CFG directory."; exit 1; }

# make fmtools.
if [ ! -z $I2CTOOLS_STATIC ] && [ $I2CTOOLS_STATIC = "y" ]; then
	echo "not support" && { exit 1; }
else
	sed -ie 's/CC	:= gcc/CC	?= gcc/' $BUILD_DIR/$I2CTOOLS_CFG/Makefile || { exit 1; }
	sed -ie 's/prefix	= \/usr\/local/prefix	?= \/usr\/local/' $BUILD_DIR/$I2CTOOLS_CFG/Makefile || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" prefix=/$BUILD_DIR/$I2CTOOLS_CFG/i2ctools_root/usr/ make install || { exit 1; }
	cp -a $BUILD_DIR/$I2CTOOLS_CFG/i2ctools_root/usr/sbin/{i2cdetect,i2cdump,i2cget,i2cset} $INITRD_DIR/usr/sbin/
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

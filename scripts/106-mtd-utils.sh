#!/bin/sh
#
# Description	: mtd tools
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: 
#
#


# will be compiled with static ?
MTDUTILS_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $MTDUTILS_ENABLE ] || [ $MTDUTILS_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$MTDUTILS_CFG" ] && { echo "Error: you must config \$MTDUTILS_CFG environment var."; exit 1; }

# echo the title.
echo "[mtd-utils] Create the mtd-utils...";

# set up the url environment of mtd-utils.
MTDUTILS_URL=ftp://ftp.infradead.org/pub/mtd-utils/$MTDUTILS_CFG.tar.bz2;

# set up the url environment of zlib.
ZLIB_CFG=zlib-1.2.3
ZLIB_URL=http://www.zlib.net/$ZLIB_CFG.tar.bz2

# set up the url environment of lzo.
LZO_CFG=lzo-2.03
LZO_URL=http://www.oberhumer.com/opensource/lzo/download/$LZO_CFG.tar.gz

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the busybox.
GetUnpackAndPatch $MTDUTILS_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $ZLIB_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $LZO_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$ZLIB_CFG" || { echo "Error: Could not enter the $ZLIB_CFG directory."; exit 1; }

CC=$CROSS"gcc" ./configure --prefix=/ || { exit 1; }
CC=$CROSS"gcc" make || { exit 1; }
CC=$CROSS"gcc" make install prefix=$BUILD_DIR/$ZLIB_CFG/zlib_root || { exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$LZO_CFG" || { echo "Error: Could not enter the $LZO_CFG directory."; exit 1; }
CC=$CROSS"gcc" ./configure --prefix=/ --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
CC=$CROSS"gcc" make || { exit 1; }
CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$LZO_CFG/lzo_root install || { exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$MTDUTILS_CFG" || { echo "Error: Could not enter the $MTDUTILS_CFG directory."; exit 1; }

# make mtdutils.
if [ ! -z $MTDUTILS_STATIC ] && [ $MTDUTILS_STATIC = "y" ]; then
	{ echo "not yet support"; } && { exit 1; }

else
	make CROSS=$CROSS CFLAGS="-O2 -g -I$BUILD_DIR/$MTDUTILS_CFG/include -I$BUILD_DIR/$ZLIB_CFG/zlib_root/include -I$BUILD_DIR/$LZO_CFG/lzo_root/include -I$BUILD_DIR/$MTDUTILS_CFG/ubi-utils/new-utils/include -I$BUILD_DIR/$MTDUTILS_CFG/ubi-utils/new-utils/src" LDFLAGS="-L$BUILD_DIR/$ZLIB_CFG/zlib_root/lib -L$BUILD_DIR/$LZO_CFG/lzo_root/lib" WITHOUT_XATTR=1 BUILDDIR=$BUILD_DIR/$MTDUTILS_CFG || { exit 1; }
	make CROSS=$CROSS CFLAGS="-O2 -g -I$BUILD_DIR/$MTDUTILS_CFG/include -I$BUILD_DIR/$ZLIB_CFG/zlib_root/include -I$BUILD_DIR/$LZO_CFG/lzo_root/include -I$BUILD_DIR/$MTDUTILS_CFG/ubi-utils/new-utils/include -I$BUILD_DIR/$MTDUTILS_CFG/ubi-utils/new-utils/src" LDFLAGS="-L$BUILD_DIR/$ZLIB_CFG/zlib_root/lib -L$BUILD_DIR/$LZO_CFG/lzo_root/lib" WITHOUT_XATTR=1 BUILDDIR=$BUILD_DIR/$MTDUTILS_CFG DESTDIR=$BUILD_DIR/$MTDUTILS_CFG/mtdutils_root install || { exit 1; }
	cp -a $BUILD_DIR/$MTDUTILS_CFG/mtdutils_root/usr/sbin/* $INITRD_DIR/usr/sbin/
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

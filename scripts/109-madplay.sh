#!/bin/sh
#
# Description	: madplay
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: madplay
#
#


# will be compiled with static ?
MADPLAY_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $MADPLAY_ENABLE ] || [ $MADPLAY_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$MADPLAY_CFG" ] && { echo "Error: you must config \$MADPLAY_CFG environment var."; exit 1; }

# echo the title.
echo "[madplay] Create the madplay...";

# set up the url environment of madplay.
MADPLAY_URL=http://you_must_download_it_before_be_compiled/$MADPLAY_CFG.tar.gz;

# set up the url environment of zlib.
ZLIB_CFG=zlib-1.2.3
ZLIB_URL=http://www.zlib.net/$ZLIB_CFG.tar.bz2

# set up the url environment of libid3tag.
LIBID3TAG_CFG=libid3tag-0.15.1b
LIBID3TAG_URL=http://you_must_download_it_before_be_compiled/$LIBID3TAG_CFG.tar.gz

# set up the url environment of libid3tag.
LIBMAD_CFG=libmad-0.15.1b
LIBMAD_URL=http://you_must_download_it_before_be_compiled/$LIBMAD_CFG.tar.gz

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the madplay.
GetUnpackAndPatch $MADPLAY_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $ZLIB_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $LIBID3TAG_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $LIBMAD_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# build and install zlib.
cd "$BUILD_DIR/$ZLIB_CFG" || { echo "Error: Could not enter the $ZLIB_CFG directory."; exit 1; }
CC=$CROSS"gcc" ./configure --prefix=/ || { exit 1; }
CC=$CROSS"gcc" make || { exit 1; }
CC=$CROSS"gcc" make install prefix=$BUILD_DIR/$ZLIB_CFG/zlib_root || { exit 1; }

# build and install libid3tag.
cd "$BUILD_DIR/$LIBID3TAG_CFG" || { echo "Error: Could not enter the $LIBID3TAG_CFG directory."; exit 1; }
mkdir -p libid3tag_build && cd libid3tag_build || { exit 1; }
CC=$CROSS"gcc" CXX=$CROSS"g++" CFLAGS="-I$BUILD_DIR/$ZLIB_CFG/zlib_root/include" LDFLAGS="-L$BUILD_DIR/$ZLIB_CFG/zlib_root/lib" ../configure --prefix=/ --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
CC=$CROSS"gcc" CXX=$CROSS"g++" make || { exit 1; }
CC=$CROSS"gcc" CXX=$CROSS"g++" make install prefix=$BUILD_DIR/$LIBID3TAG_CFG/libid3tag_root || { exit 1; }

# build and install libmad.
cd "$BUILD_DIR/$LIBMAD_CFG" || { echo "Error: Could not enter the $LIBMAD_CFG directory."; exit 1; }
mkdir -p libmad_build && cd libmad_build || { exit 1; }
CC=$CROSS"gcc" CXX=$CROSS"g++" CFLAGS="-Wall -g -O -fforce-addr -fthread-jumps -fcse-follow-jumps -fcse-skip-blocks -fexpensive-optimizations -fregmove -fschedule-insns2 -fstrength-reduce" ../configure --prefix=/ --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
CC=$CROSS"gcc" CXX=$CROSS"g++" make || { exit 1; }
CC=$CROSS"gcc" CXX=$CROSS"g++" make install prefix=$BUILD_DIR/$LIBMAD_CFG/libmad_root || { exit 1; }

# enter the build directory.
cd "$BUILD_DIR/$MADPLAY_CFG" || { echo "Error: Could not enter the $MADPLAY_CFG directory."; exit 1; }
mkdir -p madplay_build && cd madplay_build || { exit 1; }

# make madplay.
if [ ! -z $MADPLAY_STATIC ] && [ $MADPLAY_STATIC = "y" ]; then
	echo "not support" && { exit 1; }
else
	CC=$CROSS"gcc" CXX=$CROSS"g++" CPPFLAGS="-I$BUILD_DIR/$ZLIB_CFG/zlib_root/include -I$BUILD_DIR/$LIBMAD_CFG/libmad_root/include -I$BUILD_DIR/$LIBID3TAG_CFG/libid3tag_root/include" LDFLAGS="-L$BUILD_DIR/$ZLIB_CFG/zlib_root/lib -L$BUILD_DIR/$LIBMAD_CFG/libmad_root/lib -L$BUILD_DIR/$LIBID3TAG_CFG/libid3tag_root/lib" ../configure --prefix=/ --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
	CC=$CROSS"gcc" CXX=$CROSS"g++" make || { exit 1; }
	CC=$CROSS"gcc" CXX=$CROSS"g++" make install prefix=$BUILD_DIR/$MADPLAY_CFG/madplay_root || { exit 1; }
	cp -a $BUILD_DIR/$MADPLAY_CFG/madplay_root/bin/madplay $INITRD_DIR/usr/bin/
	cp -a $BUILD_DIR/$LIBMAD_CFG/libmad_root/lib/libmad.so* $INITRD_DIR/lib/
	cp -a $BUILD_DIR/$LIBID3TAG_CFG/libid3tag_root/lib/libid3tag.so* $INITRD_DIR/lib/
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

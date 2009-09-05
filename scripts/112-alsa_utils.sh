#!/bin/sh
#
# Description	: 
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	:
#
#


# will be compiled with static ?
ALSA_UTILS_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $ALSA_UTILS_ENABLE ] || [ $ALSA_UTILS_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$ALSA_UTILS_CFG" ] && { echo "Error: you must config \$ALSA_UTILS_CFG environment var."; exit 1; }

# echo the title.
echo "[alsa utils] Create the alsa utils...";

# set up the url environment of fmtools.
ALSA_UTILS_URL=ftp://ftp.alsa-project.org/pub/utils/$ALSA_UTILS_CFG.tar.bz2;

# set up the url environment of alsa lib.
ALSA_LIB_CFG=alsa-lib-1.0.21
ALSA_LIB_URL=ftp://ftp.alsa-project.org/pub/lib/$ALSA_LIB_CFG.tar.bz2;

# set up the url environment of ncurses.
NCURSES_CFG=ncurses-5.7
NCURSES_URL=http://ftp.gnu.org/pub/gnu/ncurses/$NCURSES_CFG.tar.gz;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the alsa utils.
GetUnpackAndPatch $ALSA_UTILS_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $ALSA_LIB_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $NCURSES_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# build and install ncurses.
cd "$BUILD_DIR/$NCURSES_CFG" || { echo "Error: Could not enter the $NCURSES_CFG directory."; exit 1; }
mkdir -p ncurses_build && cd ncurses_build || { exit 1; }
CC=$CROSS"gcc" CXX=$CROSS"g++" ../configure --prefix=/ --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
CC=$CROSS"gcc" make || { exit 1; }
CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$NCURSES_CFG/ncurses_root install || { exit 1; }

# build and install alsa-lib.
cd "$BUILD_DIR/$ALSA_LIB_CFG" || { echo "Error: Could not enter the $ALSA_LIB_CFG directory."; exit 1; }
mkdir -p alsa_lib_build && cd alsa_lib_build || { exit 1; }
CC=$CROSS"gcc" ../configure --enable-shared --enable-static --disable-python --prefix=/usr --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
CC=$CROSS"gcc" make || { exit 1; }
CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$ALSA_LIB_CFG/alsa_lib_root install || { exit 1; }

# build and install alsa utils.
cd "$BUILD_DIR/$ALSA_UTILS_CFG" || { echo "Error: Could not enter the $ALSA_UTILS_CFG directory."; exit 1; }
mkdir -p alsa_utils_build && cd alsa_utils_build || { exit 1; }

# make alsa utils.
if [ ! -z $ALSA_UTILS_STATIC ] && [ $ALSA_UTILS_STATIC = "y" ]; then
	echo "not support" && { exit 1; }
else
	CC=$CROSS"gcc" CXX=$CROSS"g++" CFLAGS="-I$BUILD_DIR/$ALSA_UTILS_CFG/include -I$BUILD_DIR/$ALSA_LIB_CFG/alsa_lib_root/usr/include -I$BUILD_DIR/$ALSA_LIB_CFG/alsa_lib_root/include/usr/alsa -I$BUILD_DIR/$NCURSES_CFG/ncurses_root/include/ -I$BUILD_DIR/$NCURSES_CFG/ncurses_root/include/ncurses" CPPFLAGS="-I$BUILD_DIR/$ALSA_UTILS_CFG/include -I$BUILD_DIR/$ALSA_LIB_CFG/alsa_lib_root/usr/include -I$BUILD_DIR/$ALSA_LIB_CFG/alsa_lib_root/include/usr/alsa -I$BUILD_DIR/$NCURSES_CFG/ncurses_root/include -I$BUILD_DIR/$NCURSES_CFG/ncurses_root/include/ncurses" LDFLAGS="-L$BUILD_DIR/$ALSA_LIB_CFG/alsa_lib_root/usr/lib -L$BUILD_DIR/$NCURSES_CFG/ncurses_root/lib" ../configure --with-softfloat --with-alsa-prefix=$BUILD_DIR/$ALSA_LIB_CFG/alsa_lib_root/ --with-alsa-inc-prefix=$BUILD_DIR/$ALSA_LIB_CFG/alsa_lib_root/include/ --disable-nls --prefix=/usr --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
	CC=$CROSS"gcc" make || { exit 1; }
	CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$ALSA_UTILS_CFG/alsa_utils_root install || { exit 1; }
	cp -a $BUILD_DIR/$ALSA_LIB_CFG/alsa_lib_root/usr/lib/libasound.so* $INITRD_DIR/lib/
	cp -a $BUILD_DIR/$ALSA_LIB_CFG/alsa_lib_root/usr/share/* $INITRD_DIR/usr/share/
	rm -fr $BUILD_DIR/$ALSA_UTILS_CFG/alsa_utils_root/usr/share/man/
	cp -a $BUILD_DIR/$ALSA_UTILS_CFG/alsa_utils_root/usr/* $INITRD_DIR/usr/
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

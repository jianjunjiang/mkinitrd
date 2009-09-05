#!/bin/sh
#
# Description	: usplash
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: usplash usplash_write
#
#


# will be compiled with static ?
USPLASH_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $USPLASH_ENABLE ] || [ $USPLASH_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$USPLASH_CFG" ] && { echo "Error: you must config \$USPLASH_CFG environment var."; exit 1; }

# echo the title.
echo "[usplash] Create the usplash...";

# set up the url environment of usplash.
USPLASH_URL=https://launchpad.net/ubuntu/jaunty/+source/usplash/0.5.31/+files/$USPLASH_CFG.tar.gz;
if [ ! -f "$DOWNLOADS_DIR/$USPLASH_CFG.tar.gz" ]; then
	wget --continue --directory-prefix $DOWNLOADS_DIR https://launchpad.net/ubuntu/jaunty/+source/usplash/0.5.31/+files/usplash_0.5.31.tar.gz || { exit 1; }
	tar zxvf $DOWNLOADS_DIR/usplash_0.5.31.tar.gz -C $DOWNLOADS_DIR || { exit 1; }
	rm -fr $DOWNLOADS_DIR/usplash_0.5.31.tar.gz || { exit 1; }
	mv $DOWNLOADS_DIR/usplash $DOWNLOADS_DIR/$USPLASH_CFG || { exit 1; }
	cd  $DOWNLOADS_DIR || { exit 1; }
	tar zcvf $DOWNLOADS_DIR/$USPLASH_CFG.tar.gz $USPLASH_CFG || { exit 1; }
	rm -fr $DOWNLOADS_DIR/$USPLASH_CFG || { exit 1; }
fi

# set up the url environment of zlib.
ZLIB_CFG=zlib-1.2.3
ZLIB_URL=http://www.zlib.net/$ZLIB_CFG.tar.bz2

# set up the url environment of jpeg.
JPEG_CFG=jpeg-6b
JPEG_URL=http://www.ijg.org/files/$JPEG_CFG.tar.gz;
if [ ! -f "$DOWNLOADS_DIR/$JPEG_CFG.tar.gz" ]; then
	wget --continue --directory-prefix $DOWNLOADS_DIR http://www.ijg.org/files/jpegsrc.v6b.tar.gz || { exit 1; }
	mv $DOWNLOADS_DIR/jpegsrc.v6b.tar.gz $DOWNLOADS_DIR/$JPEG_CFG.tar.gz || { exit 1; }
fi

# set up the url environment of libpng.
PNG_CFG=libpng-1.2.35;
PNG_URL=ftp://ftp.simplesystems.org/pub/libpng/png/src/$PNG_CFG.tar.bz2;

# set up the url environment of freetype.
FREETYPE_CFG=freetype-2.3.9;
FREETYPE_URL=http://ftp.twaren.net/Unix/NonGNU/freetype/$FREETYPE_CFG.tar.bz2;

# set up the url environment of libgd.
GD_CFG=gd-2.0.34;
GD_URL=http://www.libgd.org/releases/oldreleases/$GD_CFG.tar.bz2;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the usplash.
GetUnpackAndPatch $ZLIB_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $JPEG_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $PNG_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $FREETYPE_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $GD_URL || { echo "GetUnpackAndPatch fail."; exit 1; }
GetUnpackAndPatch $USPLASH_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# build and install zlib.
cd "$BUILD_DIR/$ZLIB_CFG" || { echo "Error: Could not enter the $ZLIB_CFG directory."; exit 1; }
CC=$CROSS"gcc" ./configure --prefix=/ || { exit 1; }
CC=$CROSS"gcc" make || { exit 1; }
CC=$CROSS"gcc" make install prefix=$BUILD_DIR/$ZLIB_CFG/zlib_root || { exit 1; }

# build and intall jpeg.
cd "$BUILD_DIR/$JPEG_CFG" || { echo "Error: Could not enter the $JPEG_CFG directory."; exit 1; }
mkdir -p jpeg_build && cd jpeg_build || { exit 1; }
mkdir -p $BUILD_DIR/$JPEG_CFG/jpeg_root/{bin,include,lib,man/man1} || { exit 1; }
CC=$CROSS"gcc" ../configure --prefix=$BUILD_DIR/$JPEG_CFG/jpeg_root --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
CC=$CROSS"gcc" make || { exit 1; }
CC=$CROSS"gcc" make install-headers install-lib install || { exit 1; }

# build and intall libpng.
cd "$BUILD_DIR/$PNG_CFG" || { echo "Error: Could not enter the $PNG_CFG directory."; exit 1; }
mkdir -p png_build && cd png_build || { exit 1; }
CC=$CROSS"gcc" CFLAGS="-I$BUILD_DIR/$ZLIB_CFG/zlib_root/include" LDFLAGS="-L$BUILD_DIR/$ZLIB_CFG/zlib_root/lib" ../configure --prefix=/ --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
CC=$CROSS"gcc" make || { exit 1; }
CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$PNG_CFG/png_root install || { exit 1; }

# build and install freetype.
cd "$BUILD_DIR/$FREETYPE_CFG" || { echo "Error: Could not enter the $FREETYPE_CFG directory."; exit 1; }
chmod 755 autogen.sh && ./autogen.sh || { exit 1; }
mkdir -p freetype_build && cd freetype_build || { exit 1; }
CC=$CROSS"gcc" ../configure --prefix=$BUILD_DIR/$FREETYPE_CFG/freetype_root --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
CC=$CROSS"gcc" make || { exit 1; }
CC=$CROSS"gcc" make install || { exit 1; }

# build and intall libgd.
cd "$BUILD_DIR/$GD_CFG" || { echo "Error: Could not enter the $GD_CFG directory."; exit 1; }
mkdir -p gd_build && cd gd_build || { exit 1; }
CC=$CROSS"gcc" CFLAGS="-I$BUILD_DIR/$ZLIB_CFG/zlib_root/include" LDFLAGS="-L$BUILD_DIR/$ZLIB_CFG/zlib_root/lib" ../configure --with-png=$BUILD_DIR/$PNG_CFG/png_root/ --with-freetype=$BUILD_DIR/$FREETYPE_CFG/freetype_root/ --with-jpeg=$BUILD_DIR/$JPEG_CFG/jpeg_root/ --prefix=/ --build=$BUILD --host=$HOST --target=$TARGET || { exit 1; }
CC=$CROSS"gcc" make || { exit 1; }
CC=$CROSS"gcc" make DESTDIR=$BUILD_DIR/$GD_CFG/gd_root install || { exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$USPLASH_CFG" || { echo "Error: Could not enter the $USPLASH_CFG directory."; exit 1; }

# make usplash.
if [ ! -z $USPLASH_STATIC ] && [ $USPLASH_STATIC = "y" ]; then
	echo "not support" && { exit 1; }
else
	cp $BUILD_DIR/$GD_CFG/gd_root/include/*.h ./ || { exit 1; }
	make CC=$CROSS"gcc" INCLUDES="-Ibogl -I$BUILD_DIR/$GD_CFG/gd_root/include" LDFLAGS="-L$BUILD_DIR/$GD_CFG/gd_root/lib" || { exit 1; }
	make DESTDIR=$BUILD_DIR/$USPLASH_CFG/usplash_root install || { exit 1; }
	cp $BUILD_DIR/$USPLASH_CFG/usplash_root/lib/* $INITRD_DIR/lib/ || { exit 1; }
	cp $BUILD_DIR/$USPLASH_CFG/usplash_root/sbin/usplash $INITRD_DIR/sbin/ || { exit 1; }
	cp $BUILD_DIR/$USPLASH_CFG/usplash_root/sbin/usplash_write $INITRD_DIR/sbin/ || { exit 1; }
	mkdir -p $INITRD_DIR/var/lib/usplash
	mkfifo $INITRD_DIR/var/lib/usplash/usplash_fifo
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

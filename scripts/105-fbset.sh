#!/bin/sh
#
# Description	: The Linux Frame Buffer Device Subsystem
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: fbset
#
#


# will be compiled with static ?
FBSET_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $FBSET_ENABLE ] || [ $FBSET_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$FBSET_CFG" ] && { echo "Error: you must config \$FBSET_CFG environment var."; exit 1; }

# echo the title.
echo "[fbset] Create the fbset...";

# set up the url environment of fbset.
FBSET_URL=http://users.telenet.be/geertu/Linux/fbdev/$FBSET_CFG.tar.gz;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the busybox.
GetUnpackAndPatch $FBSET_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$FBSET_CFG" || { echo "Error: Could not enter the $FBSET_CFG directory."; exit 1; }

# make fbset.
if [ ! -z $FBSET_STATIC ] && [ $FBSET_STATIC = "y" ]; then
	sed -ie 's/CC =		gcc -Wall -O2 -I./CC =		${CROSS}gcc -static -Wall -O2 -I./' $BUILD_DIR/$FBSET_CFG/Makefile || { exit 1; }
	make || { exit 1; }
	cp $BUILD_DIR/$FBSET_CFG/fbset $INITRD_DIR/bin/
else
	sed -ie 's/CC =		gcc -Wall -O2 -I./CC =		${CROSS}gcc -Wall -O2 -I./' $BUILD_DIR/$FBSET_CFG/Makefile || { exit 1; }
	make || { exit 1; }
	cp $BUILD_DIR/$FBSET_CFG/fbset $INITRD_DIR/bin/
fi

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

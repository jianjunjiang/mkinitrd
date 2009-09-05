#!/bin/sh
#
# Description	: The final shell script.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# if no enable flag, the script will exit directly.
[ -z $INITRD_ENABLE ] || [ $INITRD_ENABLE != "y" ] && { exit 0; }

# echo the title.
echo "[initrd] make initrd...";

# source the common function.
source $PROG_DIR/common.sh;

# create initrd (cpio format).
cd $PROG_DIR || { exit 1; }
rm -fr ramdisk.img.gz;
rm -fr cpio_list;



cd $RELEASE_DIR || { exit 1; }
rm -fr $RELEASE_DIR/cpio_list $RELEASE_DIR/initrd.img.cpio $RELEASE_DIR/initrd.img.gz $RELEASE_DIR/initrd.tar.gz || { exit 1; }

$TOOLS_DIR/gen_initramfs_list.sh ${INITRD_DIR} > $RELEASE_DIR/cpio_list || { exit 1; }
$TOOLS_DIR/gen_init_cpio cpio_list > $RELEASE_DIR/initrd.img.cpio || { exit 1; }
gzip -9 -c $RELEASE_DIR/initrd.img.cpio > $RELEASE_DIR/initrd.img.gz || { exit 1; }
rm -fr $RELEASE_DIR/cpio_list $RELEASE_DIR/initrd.tar.gz || { exit 1; }

cd $INITRD_DIR || { echo "Error: Could not enter the $INITRD_DIR directory."; exit 1; }
tar zcf $RELEASE_DIR/initrd.tar.gz ./* || { exit 1; }

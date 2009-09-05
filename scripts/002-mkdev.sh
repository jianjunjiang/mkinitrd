#!/bin/sh
#
# Description	: Make node for device.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# if no enable flag, the script will exit directly.
[ -z $MKDEV_ENABLE ] || [ $MKDEV_ENABLE != "y" ] && { exit 0; }

# echo the title.
echo "[mkdev] Create the static node of device...";

# make the static device node.
rm -f $INITRD_DIR/dev/null && { mknod -m 666 $INITRD_DIR/dev/null c 1 3; }
rm -f $INITRD_DIR/dev/console && { mknod -m 600 $INITRD_DIR/dev/console c 5 1; }

# make the static device node for udev.
#rm -fr $RAMDISK_DIR/lib/udev/devices/fd && { ln -s /proc/self/fd $RAMDISK_DIR/lib/udev/devices/fd; }
#rm -fr $RAMDISK_DIR/lib/udev/devices/stdin && { ln -s /proc/self/fd/0 $RAMDISK_DIR/lib/udev/devices/stdin; }
#rm -fr $RAMDISK_DIR/lib/udev/devices/stdout && { ln -s /proc/self/fd/1 $RAMDISK_DIR/lib/udev/devices/stdout; }
#rm -fr $RAMDISK_DIR/lib/udev/devices/stderr && { ln -s /proc/self/fd/2 $RAMDISK_DIR/lib/udev/devices/stderr; }
#rm -fr $RAMDISK_DIR/lib/udev/devices/core && { ln -s /proc/kcore $RAMDISK_DIR/lib/udev/devices/core; }
#rm -fr $RAMDISK_DIR/lib/udev/devices/null && { mknod -m 666 $RAMDISK_DIR/lib/udev/devices/null c 1 3; }
#rm -fr $RAMDISK_DIR/lib/udev/devices/kmsg && { mknod -m 666 $RAMDISK_DIR/lib/udev/devices/kmsg c 1 11; }



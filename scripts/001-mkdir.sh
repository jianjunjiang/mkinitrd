#!/bin/sh
#
# Description	: Make basic dirctory of initrd.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# if no enable flag, the script will exit directly.
[ -z $MKDIR_ENABLE ] || [ $MKDIR_ENABLE != "y" ] && { exit 0; }

# echo the title.
echo "[mkdir] Create the basic dirctory of initrd...";

# enter the rootfs directory.
cd $INITRD_DIR || { echo "Error: Could not enter the initrd directory."; exit 1; }

# make the basic directory.
mkdir -p -m 0755 {bin,dev/{pts,shm},etc/{modprobe.d,udev,default},lib/{modules,udev},mnt,sbin,sys,usr/{bin,lib,sbin},var}
mkdir -p -m 0555 {proc,}
mkdir -p -m 0755 var/{run,lock}
mkdir -p -m 0700 root
mkdir -p -m 1777 tmp

chown -R 0:0 $INITRD_DIR


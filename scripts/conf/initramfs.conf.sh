#!/bin/sh
#
# Description	: initramfs.conf
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /conf/initramfs.conf
# Notes		: 


# echo the title.
echo "[conf] Create /conf/initramfs.conf ...";

# The contents of /conf/initramfs.conf file.
cat > $INITRD_DIR/conf/initramfs.conf << "EOF"
#
# initramfs.conf
# Configuration file for mkinitramfs(8). See initramfs.conf(5).
#

#
# MODULES: [ most | netboot | dep | list ]
#
# most - Add all framebuffer, acpi, filesystem, and harddrive drivers.
#
# dep - Try and guess which modules to load.
#
# netboot - Add the base modules, network modules, but skip block devices.
#
# list - Only include modules from the 'additional modules' list
#

MODULES=most

#
# BUSYBOX: [ y | n ]
#
# Use busybox if available.
#

BUSYBOX=y

#
# COMPCACHE_SIZE: [ "x K" | "x M" | "x G" | "x %" ]
#
# Amount of RAM to use for RAM-based compressed swap space.
#
# An empty value - compcache isn't used, or added to the initramfs at all.
# An integer and K (e.g. 65536 K) - use a number of kilobytes.
# An integer and M (e.g. 256 M) - use a number of megabytes.
# An integer and G (e.g. 1 G) - use a number of gigabytes.
# An integer and % (e.g. 50 %) - use a percentage of the amount of RAM.
#
# You can optionally install the compcache package to configure this setting
# via debconf and have userspace scripts to load and unload compcache.
# 

COMPCACHE_SIZE=""

#
# NFS Section of the config.
#

#
# BOOT: [ local | nfs ]
#
# local - Boot off of local media (harddrive, USB stick).
#
# nfs - Boot using an NFS drive as the root of the drive.
#

BOOT=local

#
# DEVICE: ...
#
# Specify the network interface, like eth0
#

DEVICE=eth0

#
# NFSROOT: [ auto | HOST:MOUNT ]
#

NFSROOT=auto

EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/conf/initramfs.conf;
chown 0:0 $INITRD_DIR/conf/initramfs.conf;


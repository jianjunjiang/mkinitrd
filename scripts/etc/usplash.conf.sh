#!/bin/sh
#
# Description	: usplash.conf
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /etc/usplash.conf
# Notes		: 


# echo the title.
echo "[etc] Create /etc/usplash.conf ...";

# The contents of /etc/usplash.conf file.
cat > $INITRD_DIR/etc/usplash.conf << "EOF"
# Usplash configuration file
# These parameters will only apply after running update-initramfs.

xres=640
yres=480
EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/etc/usplash.conf;
chown 0:0 $INITRD_DIR/etc/usplash.conf;


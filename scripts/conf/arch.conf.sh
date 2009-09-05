#!/bin/sh
#
# Description	: arch.conf
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /conf/arch.conf
# Notes		: 


# echo the title.
echo "[conf] Create /conf/arch.conf ...";

# The contents of /conf/arch.conf file.
cat > $INITRD_DIR/conf/arch.conf << "EOF"
DPKG_ARCH=arm
EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/conf/arch.conf;
chown 0:0 $INITRD_DIR/conf/arch.conf;


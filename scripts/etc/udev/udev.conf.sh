#!/bin/sh
#
# Description	: udev.conf
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /etc/udev/udev.conf
# Notes		: 


# echo the title.
echo "[udev] Create /etc/udev/udev.conf ...";

# The contents of /etc/udev/udev.conf file.
cat > $INITRD_DIR/etc/udev/udev.conf << "EOF"
# udev.conf

# The initial syslog(3) priority: "err", "info", "debug" or its
# numerical equivalent. For runtime debugging, the daemons internal
# state can be changed with: "udevcontrol log_priority=<value>".
udev_log="err"

EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/etc/udev/udev.conf;
chown 0:0 $INITRD_DIR/etc/udev/udev.conf;


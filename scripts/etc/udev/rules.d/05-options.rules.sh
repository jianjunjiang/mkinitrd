#!/bin/sh
#
# Description	: 05-options.rules
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /etc/udev/rules.d/05-options.rules
# Notes		: 


# echo the title.
echo "[udev] Create /etc/udev/rules.d/05-options.rules ...";

# The contents of /etc/udev/rules.d/05-options.rules file.
cat > $INITRD_DIR/etc/udev/rules.d/05-options.rules << "EOF"
# Work-around for IDE devices that don't report media changes
SUBSYSTEMS=="ide", KERNEL=="hd[a-z]", ATTR{removable}=="1", \
	ENV{ID_MODEL}=="IOMEGA_ZIP*", OPTIONS+="all_partitions"
SUBSYSTEMS=="ide", KERNEL=="hd[a-z]", ATTRS{media}=="floppy", \
	OPTIONS+="all_partitions"

# Do not delete static device nodes
ACTION=="remove", NAME=="?*", TEST=="/lib/udev/devices/$name", \
	OPTIONS+="ignore_remove"
EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/etc/udev/rules.d/05-options.rules;
chown 0:0 $INITRD_DIR/etc/udev/rules.d/05-options.rules;


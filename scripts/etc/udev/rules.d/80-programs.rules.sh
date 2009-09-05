#!/bin/sh
#
# Description	: 80-programs.rules
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /etc/udev/rules.d/80-programs.rules
# Notes		: 


# echo the title.
echo "[udev] Create /etc/udev/rules.d/80-programs.rules ...";

# The contents of /etc/udev/rules.d/80-programs.rules file.
cat > $INITRD_DIR/etc/udev/rules.d/80-programs.rules << "EOF"
# This file causes programs to be run on device insertion.
# See udev(7) for syntax.
#
# "Hotplug replacement" is handled in 90-modprobe.rules;  this file only
# specifies rules for those programs that are shipped in the minimal Ubuntu
# system, programs outside of that may ship their own rules.

# Load firmware on demand
SUBSYSTEM=="firmware", ACTION=="add", RUN+="firmware_helper"

# Create special nodes for floppy devices
KERNEL=="fd[0-9]*", ACTION=="add", ATTRS{cmos}=="?*", \
	RUN+="create_floppy_devices -c -t $attr{cmos} -m %M -M 0640 -G disk $root/%k"
EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/etc/udev/rules.d/80-programs.rules;
chown 0:0 $INITRD_DIR/etc/udev/rules.d/80-programs.rules;


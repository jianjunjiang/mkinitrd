#!/bin/sh
#
# Description	: 40-basic-permissions.rules
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /etc/udev/rules.d/40-basic-permissions.rules
# Notes		: 


# echo the title.
echo "[udev] Create /etc/udev/rules.d/40-basic-permissions.rules ...";

# The contents of /etc/udev/rules.d/40-basic-permissions.rules file.
cat > $INITRD_DIR/etc/udev/rules.d/40-basic-permissions.rules << "EOF"
# This file establishes permissions and ownership of devices according
# to Ubuntu policy.  See udev(7) for syntax.
#
# The names of the devices must not be set here, but in 20-names.rules;
# user-friendly symlinks (which need no permissions or ownership) should
# be set in 60-symlinks.rules.

# USB devices (usbfs replacement)
SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE="0664"
SUBSYSTEM=="usb_device",		MODE="0664"

# vc (virtual console) devices
SUBSYSTEM!="tty", GOTO="vc_end"
KERNEL=="console",			MODE="0600"
KERNEL=="ptmx",				MODE="0666"
KERNEL=="tty",				MODE="0666"
LABEL="vc_end"

# Miscellaneous devices
KERNEL=="null",				MODE="0666"
KERNEL=="zero",				MODE="0666"
KERNEL=="full",				MODE="0666"
KERNEL=="random",			MODE="0666"
KERNEL=="urandom",			MODE="0666"
KERNEL=="inotify",			MODE="0666"
EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/etc/udev/rules.d/40-basic-permissions.rules;
chown 0:0 $INITRD_DIR/etc/udev/rules.d/40-basic-permissions.rules;


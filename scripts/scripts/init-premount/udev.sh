#!/bin/sh
#
# Description	: udev
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /scripts/init-premount/udev
# Notes		: 


# echo the title.
echo "[init-premount] Create /scripts/init-premount/udev ...";

# The contents of /scripts/init-premount/udev file.
cat > $INITRD_DIR/scripts/init-premount/udev << "EOF"
#!/bin/sh -e
# initramfs premount script for udev

PREREQ=""

# Output pre-requisites
prereqs()
{
	echo "$PREREQ"
}

case "$1" in
    prereqs)
	prereqs
	exit 0
	;;
esac


# It's all over netlink now
echo "" > /proc/sys/kernel/hotplug
	
# Start the udev daemon to process events
/sbin/udevd --daemon

# Iterate sysfs and fire off everything; if we include a rule for it then
# it'll get handled; otherwise it'll get handled later when we do this again
# in the main boot sequence.
/sbin/udevadm trigger
EOF

# change the owner and permission.
chmod 755 $INITRD_DIR/scripts/init-premount/udev;
chown 0:0 $INITRD_DIR/scripts/init-premount/udev;


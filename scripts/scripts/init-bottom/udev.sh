#!/bin/sh
#
# Description	: udev
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /scripts/init-bottom/udev
# Notes		: 


# echo the title.
echo "[init-bottom] Create /scripts/init-bottom/udev ...";

# The contents of /scripts/init-bottom/udev file.
cat > $INITRD_DIR/scripts/init-bottom/udev << "EOF"
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


# Stop udevd, we'll miss a few events while we run init, but we catch up
pkill udevd

# udevd might have been in the middle of something when we killed it,
# but it doesn't matter because we'll do everything again in userspace
rm -rf /dev/.udev/queue

# Move the real filesystem's /dev to beneath our tmpfs, then move it all
# to the real filesystem
mkdir -m 0700 -p /dev/.static/dev
mount -n -o bind ${rootmnt}/dev /dev/.static/dev
mount -n -o move /dev ${rootmnt}/dev
EOF

# change the owner and permission.
chmod 755 $INITRD_DIR/scripts/init-bottom/udev;
chown 0:0 $INITRD_DIR/scripts/init-bottom/udev;


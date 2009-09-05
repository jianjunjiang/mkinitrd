#!/bin/sh
#
# Description	: blacklist
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /scripts/init-premount/blacklist
# Notes		: 


# echo the title.
echo "[init-premount] Create /scripts/init-premount/blacklist ...";

# The contents of /scripts/init-premount/blacklist file.
cat > $INITRD_DIR/scripts/init-premount/blacklist << "EOF"
#!/bin/sh

PREREQ=""

prereqs()
{
	echo "$PREREQ"
}

case $1 in
# get pre-requisites
prereqs)
	prereqs
	exit 0
	;;
esac

# sanity check
[ -z "${blacklist}" ] && exit 0

# write blacklist to modprobe.d
IFS=','
for b in ${blacklist}; do
	echo "blacklist $b" >> /etc/modprobe.d/initramfs
done
EOF

# change the owner and permission.
chmod 755 $INITRD_DIR/scripts/init-premount/blacklist;
chown 0:0 $INITRD_DIR/scripts/init-premount/blacklist;


#!/bin/sh
#
# Description	: usplash
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /scripts/init-top/usplash
# Notes		: 


# echo the title.
echo "[init-top] Create /scripts/init-top/usplash ...";

# The contents of /scripts/init-top/usplash file.
cat > $INITRD_DIR/scripts/init-top/usplash << "EOF"
#!/bin/sh

PREREQ="framebuffer console_setup"

prereqs()
{
	echo "$PREREQ"
}

case $1 in
prereqs)
	prereqs
	exit 0
	;;
esac

[ -f /etc/usplash.conf ] && . /etc/usplash.conf

SPLASH=false
VERBOSE=true

for x in $(cat /proc/cmdline); do
	case $x in
	splash*)
		SPLASH=true
		;;
	nosplash*)
		SPLASH=false
	        ;;
	quiet*)
		VERBOSE=false
		;;
	esac
done

if [ $SPLASH = "true" ]; then
        mknod -m 640 /dev/mem c 1 1
	mknod -m 666 /dev/zero c 1 5
        for i in 0 1 2 3 4 5 6 7 8; do
                [ -c /dev/tty$i ] || mknod /dev/tty$i c 4 $i
	done
	modprobe -q i8042
	modprobe -q atkbd
	if [ "$VERBOSE" = true ]; then
		varg=-v
	else
		varg=
	fi
	if [ "$xres" ] && [ "$xres" != 0 ] && \
	   [ "$yres" ] && [ "$yres" != 0 ]; then
		/sbin/usplash -p -c -x "$xres" -y "$yres" $varg &
	else
		/sbin/usplash -p -c $varg &
	fi
fi
EOF

# change the owner and permission.
chmod 755 $INITRD_DIR/scripts/init-top/usplash;
chown 0:0 $INITRD_DIR/scripts/init-top/usplash;


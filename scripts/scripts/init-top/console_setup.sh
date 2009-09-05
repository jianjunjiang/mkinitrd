#!/bin/sh
#
# Description	: console_setup
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /scripts/init-top/console_setup
# Notes		: 


# echo the title.
echo "[init-top] Create /scripts/init-top/console_setup ...";

# The contents of /scripts/init-top/console_setup file.
cat > $INITRD_DIR/scripts/init-top/console_setup << "EOF"
#! /bin/sh
# A crude much-simplified clone of setupcon for use in the initramfs.

PREREQ="framebuffer"

prereqs () {
	echo "$PREREQ"
}

case $1 in
prereqs)
	prereqs
	exit 0
	;;
esac

. /etc/default/console-setup

[ "$ACTIVE_CONSOLES" ] || exit 0

if [ "$VERBOSE_OUTPUT" = yes ]; then
	verbose=
else
	verbose='>/dev/null 2>&1'
fi

for i in 1 2 3 4 5 6; do
	[ -c /dev/tty$i ] || mknod /dev/tty$i c 4 $i
done

for console in $ACTIVE_CONSOLES; do
	[ -w $console ] || continue

	if [ "$CHARMAP" = UTF-8 ] || [ -z "$ACM$CHARMAP" ]; then
		printf '\033%%G' >$console
	else
		printf '\033%%@' >$console
	fi

	if [ -f "$FONT" ]; then
		FONT="/etc/console-setup/${FONT##*/}"
	else
		FONT="/etc/console-setup/$CODESET-$FONTFACE$FONTSIZE.psf.gz"
	fi
	if [ -f "$FONT" ]; then
		if type consolechars >/dev/null 2>&1; then
			eval consolechars -v --tty=$console -f "$FONT" $verbose
		elif type setfont >/dev/null 2>&1; then
			eval setfont -v -C $console "$FONT" $verbose
		fi
	fi

	if [ -f "$ACM" ]; then
		ACM="/etc/console-setup/${ACM##*/}"
	else
		ACM="/etc/console-setup/$CHARMAP.acm.gz"
	fi
	if [ -f "$ACM" ]; then
		if type consolechars >/dev/null 2>&1; then
			eval consolechars -v --tty=$console --acm "$ACM" \
				$verbose
		elif type setfont >/dev/null 2>&1; then
			eval setfont -v -C "$console" -m "$ACM" $verbose
		fi
	fi

	if type kbd_mode >/dev/null 2>&1; then
		if [ "$CHARMAP" = UTF-8 ] || [ -z "$ACM" ]; then
			kbd_mode -u -C $console
		else
			kbd_mode -a -C $console
		fi
	fi
done

if [ -f /etc/console-setup/boottime.kmap.gz ] && type loadkeys >/dev/null; then
	eval loadkeys /etc/console-setup/boottime.kmap.gz $verbose
fi

exit 0
EOF

# change the owner and permission.
chmod 755 $INITRD_DIR/scripts/init-top/console_setup;
chown 0:0 $INITRD_DIR/scripts/init-top/console_setup;


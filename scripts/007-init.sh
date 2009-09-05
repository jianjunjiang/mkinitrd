#!/bin/sh
#
# Description	: init script
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /init
# Notes		: 


# echo the title.
echo "[init] Create /init ...";

# The contents of /init file.
cat > $INITRD_DIR/init << "EOF"
#!/bin/sh

echo "Loading, please wait..."

[ -d /dev ] || mkdir -m 0755 /dev
[ -d /root ] || mkdir -m 0700 /root
[ -d /sys ] || mkdir /sys
[ -d /proc ] || mkdir /proc
[ -d /tmp ] || mkdir /tmp
mkdir -p /var/lock
mount -t sysfs -o nodev,noexec,nosuid none /sys 
mount -t proc -o nodev,noexec,nosuid none /proc 

# Note that this only becomes /dev on the real filesystem if udev's scripts
# are used; which they will be, but it's worth pointing out
mount -t tmpfs -o mode=0755 udev /dev
[ -e /dev/console ] || mknod -m 0600 /dev/console c 5 1
[ -e /dev/null ] || mknod /dev/null c 1 3
> /dev/.initramfs-tools
mkdir /dev/.initramfs

# Export the dpkg architecture
export DPKG_ARCH=
. /conf/arch.conf

# Set modprobe env
export MODPROBE_OPTIONS="-Qb"

# Export relevant variables
export ROOT=
export ROOTDELAY=
export ROOTFLAGS=
export ROOTFSTYPE=
export break=
export init=/sbin/init
export quiet=n
export readonly=y
export rootmnt=/root
export debug=
export panic=
export blacklist=
export resume_offset=

# Bring in the main config
. /conf/initramfs.conf
for conf in conf/conf.d/*; do
	[ -f ${conf} ] && . ${conf}
done
. /scripts/functions

# Parse command line options
for x in $(cat /proc/cmdline); do
	case $x in
	init=*)
		init=${x#init=}
		;;
	root=*)
		ROOT=${x#root=}
		case $ROOT in
		LABEL=*)
			ROOT="/dev/disk/by-label/${ROOT#LABEL=}"
			;;
		UUID=*)
			ROOT="/dev/disk/by-uuid/${ROOT#UUID=}"
			;;
		/dev/nfs)
			[ -z "${BOOT}" ] && BOOT=nfs
			;;
		esac
		;;
	rootflags=*)
		ROOTFLAGS="-o ${x#rootflags=}"
		;;
	rootfstype=*)
		ROOTFSTYPE="${x#rootfstype=}"
		;;
	rootdelay=*)
		ROOTDELAY="${x#rootdelay=}"
		case ${ROOTDELAY} in
		*[![:digit:].]*)
			ROOTDELAY=
			;;
		esac
		;;
	resumedelay=*)
		RESUMEDELAY="${x#resumedelay=}"
		;;
	loop=*)
		LOOP="${x#loop=}"
		;;
	loopflags=*)
		LOOPFLAGS="-o ${x#loopflags=}"
		;;
	loopfstype=*)
		LOOPFSTYPE="${x#loopfstype=}"
		;;
	cryptopts=*)
		cryptopts="${x#cryptopts=}"
		;;
	nfsroot=*)
		NFSROOT="${x#nfsroot=}"
		;;
	netboot=*)
		NETBOOT="${x#netboot=}"
		;;
	ip=*)
		IPOPTS="${x#ip=}"
		;;
	boot=*)
		BOOT=${x#boot=}
		;;
	resume=*)
		RESUME="${x#resume=}"
		;;
	resume_offset=*)
		resume_offset="${x#resume_offset=}"
		;;
	noresume)
		noresume=y
		;;
	panic=*)
		panic="${x#panic=}"
		case ${panic} in
		*[![:digit:].]*)
			panic=
			;;
		esac
		;;
	quiet)
		quiet=y
		;;
	ro)
		readonly=y
		;;
	rw)
		readonly=n
		;;
	debug)
		debug=y
		quiet=n
		exec >/tmp/initramfs.debug 2>&1
		set -x
		;;
	debug=*)
		debug=y
		quiet=n
		set -x
		;;
	break=*)
		break=${x#break=}
		;;
	break)
		break=premount
		;;
	blacklist=*)
		blacklist=${x#blacklist=}
		;;
	esac
done

if [ -z "${noresume}" ]; then
	export resume=${RESUME}
else
	export noresume
fi

depmod -a
maybe_break top

# export BOOT variable value for compcache,
# so we know if we run from casper
export BOOT

# Don't do log messages here to avoid confusing usplash
run_scripts /scripts/init-top

maybe_break modules
log_begin_msg "Loading essential drivers..."
load_modules
log_end_msg

maybe_break premount
[ "$quiet" != "y" ] && log_begin_msg "Running /scripts/init-premount"
run_scripts /scripts/init-premount
[ "$quiet" != "y" ] && log_end_msg

maybe_break mount
log_begin_msg "Mounting root file system..."
. /scripts/${BOOT}
parse_numeric ${ROOT}
mountroot
log_end_msg

maybe_break bottom
[ "$quiet" != "y" ] && log_begin_msg "Running /scripts/init-bottom"
run_scripts /scripts/init-bottom
[ "$quiet" != "y" ] && log_end_msg

# Move virtual filesystems over to the real filesystem
mount -n -o move /sys ${rootmnt}/sys
mount -n -o move /proc ${rootmnt}/proc

# Check init bootarg
if [ -n "${init}" ] && [ ! -x "${rootmnt}${init}" ]; then
	echo "Target filesystem doesn't have ${init}."
	init=
fi

# Search for valid init
if [ -z "${init}" ] ; then
	for init in /sbin/init /etc/init /bin/init /bin/sh; do
		if [ ! -x "${rootmnt}${init}" ]; then
			continue
		fi
		break
	done
fi

# No init on rootmount
if [ ! -x "${rootmnt}${init}" ]; then
	panic "No init found. Try passing init= bootarg."
fi

# Confuses /etc/init.d/rc
if [ -n ${debug} ]; then
	unset debug
fi

# Chain to real filesystem
maybe_break init
exec switch_root ${rootmnt} ${init} "$@" <${rootmnt}/dev/console >${rootmnt}/dev/console 2>&1
panic "Could not execute switch_root."
EOF

# change the fstab's owner and permission.
chmod 755 $INITRD_DIR/init;
chown 0:0 $INITRD_DIR/init;

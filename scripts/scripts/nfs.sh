#!/bin/sh
#
# Description	: nfs
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /scripts/nfs
# Notes		: 


# echo the title.
echo "[scripts] Create /scripts/nfs ...";

# The contents of /scripts/nfs file.
cat > $INITRD_DIR/scripts/nfs << "EOF"
# NFS filesystem mounting			-*- shell-script -*-

# FIXME This needs error checking

retry_nr=0

# parse nfs bootargs and mount nfs 
do_nfsmount()
{

	configure_networking

	# get nfs root from dhcp
	if [ "x${NFSROOT}" = "xauto" ]; then
		# check if server ip is part of dhcp root-path
		if [ "${ROOTPATH#*:}" = "${ROOTPATH}" ]; then
			NFSROOT=${ROOTSERVER}:${ROOTPATH}
		else
			NFSROOT=${ROOTPATH}
		fi

	# nfsroot=[<server-ip>:]<root-dir>[,<nfs-options>]
	elif [ -n "${NFSROOT}" ]; then
		# nfs options are an optional arg
		if [ "${NFSROOT#*,}" != "${NFSROOT}" ]; then
			NFSOPTS="-o ${NFSROOT#*,}"
		fi
		NFSROOT=${NFSROOT%%,*}
		if [ "${NFSROOT#*:}" = "$NFSROOT" ]; then
			NFSROOT=${ROOTSERVER}:${NFSROOT}
		fi
	fi

	if [ -z "${NFSOPTS}" ]; then
		NFSOPTS="-o retrans=10"
	fi

	[ "$quiet" != "y" ] && log_begin_msg "Running /scripts/nfs-premount"
	run_scripts /scripts/nfs-premount
	[ "$quiet" != "y" ] && log_end_msg

	if [ ${readonly} = y ]; then
		roflag="-o ro"
	else
		roflag="-o rw"
	fi

	nfsmount -o nolock ${roflag} ${NFSOPTS} ${NFSROOT} ${rootmnt}
}

# NFS root mounting
mountroot()
{
	[ "$quiet" != "y" ] && log_begin_msg "Running /scripts/nfs-top"
	run_scripts /scripts/nfs-top
	[ "$quiet" != "y" ] && log_end_msg

	modprobe nfs
	# For DHCP
	modprobe af_packet

	# Default delay is around 180s
	# FIXME: add usplash_write info
	if [ -z "${ROOTDELAY}" ]; then
		delay=180
	else
		delay=${ROOTDELAY}
	fi

	# loop until nfsmount succeds
	while [ ${retry_nr} -lt ${delay} ] && [ ! -e ${rootmnt}${init} ]; do
		[ ${retry_nr} -gt 0 ] && \
		[ "$quiet" != "y" ] && log_begin_msg "Retrying nfs mount"
		do_nfsmount
		retry_nr=$(( ${retry_nr} + 1 ))
		[ ! -e ${rootmnt}${init} ] && /bin/sleep 1
		[ ${retry_nr} -gt 0 ] && [ "$quiet" != "y" ] && log_end_msg
	done

	[ "$quiet" != "y" ] && log_begin_msg "Running /scripts/nfs-bottom"
	run_scripts /scripts/nfs-bottom
	[ "$quiet" != "y" ] && log_end_msg
}
EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/scripts/nfs;
chown 0:0 $INITRD_DIR/scripts/nfs;


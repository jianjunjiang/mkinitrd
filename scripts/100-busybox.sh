#!/bin/sh
#
# Description	: The tool of busybox.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
# Programs	: [, [[, addgroup, adduser, adjtimex, ar, arp, arping, ash,
# 		  awk, basename, brctl, bunzip2, bzcat, bzip2, cal, cat, catv,
#		  chat, chattr, chgrp, chmod, chown, chpasswd, chpst, chroot,
#		  chrt, chvt, cksum, clear, cmp, comm, cp, cpio, crond, crontab,
#		  cryptpw, cut, date, dc, dd, deallocvt, delgroup, deluser,
#		  depmod, df, dhcprelay, diff, dirname, dmesg, dnsd, dos2unix,
#		  du, dumpkmap, dumpleases, echo, ed, egrep, eject, env, envdir,
#		  envuidgid, ether-wake, expand, expr, fakeidentd, false,
#		  fbset, fbsplash, fdflush, fdformat, fdisk, fetchmail, fgrep,
#		  find, fold, free, freeramdisk, fsck, fsck.minix, ftpget,
#		  ftpput, fuser, getopt, getty, grep, gunzip, gzip, halt,
#		  hdparm, head, hexdump, hostid, hostname, httpd, hwclock,
#		  id, ifconfig, ifdown, ifenslave, ifup, inetd, init, inotifyd,
#		  insmod, install, ip, ipaddr, ipcalc, ipcrm, ipcs, iplink,
#		  iproute, iprule, iptunnel, kbd_mode, kill, killall, killall5,
#		  klogd, last, length, less, linux32, linux64, linuxrc, ln,
#		  loadfont, loadkmap, logger, login, logname, logread, losetup,
#		  lpd, lpq, lpr, ls, lsattr, lsmod, lzmacat, makedevs, man,
#		  md5sum, mdev, mesg, microcom, mkdir, mkfifo, mkfs.minix,
#		  mknod, mkswap, mktemp, modprobe, more, mount, mountpoint,
#		  mt, mv, nameif, nc, netstat, nice, nmeter, nohup, nslookup,
#		  od, openvt, passwd, patch, pgrep, pidof, ping, ping6, pipe_progress,
#		  pivot_root, pkill, poweroff, printenv, printf, ps, pscan,
#		  pwd, raidautorun, rdate, rdev, readahead, readlink, readprofile,
#		  realpath, reboot, renice, reset, resize, rm, rmdir, rmmod,
#		  route, rpm, rpm2cpio, rtcwake, run-parts, runlevel, runsv,
#		  runsvdir, rx, script, sed, sendmail, seq, setarch, setconsole,
#		  setfont, setkeycodes, setlogcons, setsid, setuidgid, sh,
#		  sha1sum, showkey, slattach, sleep, softlimit, sort, split,
#		  start-stop-daemon, stat, strings, stty, su, sulogin, sum,
#		  sv, svlogd, swapoff, swapon, switch_root, sync, sysctl,
#		  syslogd, tac, tail, tar, taskset, tcpsvd, tee, telnet, telnetd,
#		  test, tftp, tftpd, time, top, touch, tr, traceroute, true,
#		  tty, ttysize, udhcpc, udhcpd, udpsvd, umount, uname, uncompress,
#		  unexpand, uniq, unix2dos, unlzma, unzip, uptime, usleep,
#		  uudecode, uuencode, vconfig, vi, vlock, watch, watchdog,
#		  wc, wget, which, who, whoami, xargs, yes, zcat, zcip
#
#


# will be compiled with static ?
BUSYBOX_STATIC=n

# if no enable flag, the script will exit directly.
[ -z $BUSYBOX_ENABLE ] || [ $BUSYBOX_ENABLE != "y" ] && { exit 0; }

# check environment config.
[ -z "$BUSYBOX_CFG" ] && { echo "Error: you must config \$BUSYBOX_CFG environment var."; exit 1; }

# echo the title.
echo "[busybox] Create the tool of busybox...";

# set up the url environment of busybox.
BUSYBOX_URL=http://busybox.net/downloads/$BUSYBOX_CFG.tar.bz2;

# source the common function.
source $PROG_DIR/common.sh;

#download unpack and patch the busybox.
GetUnpackAndPatch $BUSYBOX_URL || { echo "GetUnpackAndPatch fail."; exit 1; }

# enter the source directory.
cd "$BUILD_DIR/$BUSYBOX_CFG" || { echo "Error: Could not enter the $BUSYBOX_CFG directory."; exit 1; }

# make busybox.
make CROSS_COMPILE=$CROSS clean && make CROSS_COMPILE=$CROSS mrproper && make CROSS_COMPILE=$CROSS defconfig || { exit 1; }

if [ ! -z $BUSYBOX_STATIC ] && [ $BUSYBOX_STATIC = "y" ]; then
	sed -ie 's/# CONFIG_INSTALL_NO_USR is not set/CONFIG_INSTALL_NO_USR=y/' $BUILD_DIR/$BUSYBOX_CFG/.config || { exit 1; }
	make CROSS_COMPILE=$CROSS CONFIG_STATIC=y CONFIG_PREFIX=$INITRD_DIR || { exit 1; }
	make CROSS_COMPILE=$CROSS CONFIG_STATIC=y CONFIG_PREFIX=$INITRD_DIR install || { exit 1; }
else
	sed -ie 's/# CONFIG_INSTALL_NO_USR is not set/CONFIG_INSTALL_NO_USR=y/' $BUILD_DIR/$BUSYBOX_CFG/.config || { exit 1; }
	make CROSS_COMPILE=$CROSS CONFIG_STATIC=n CONFIG_PREFIX=$INITRD_DIR || { exit 1; }	
	make CROSS_COMPILE=$CROSS CONFIG_STATIC=n CONFIG_PREFIX=$INITRD_DIR install || { exit 1; }
fi

# make busybox binary setuid root to ensure all configured applets will work properly.
chmod 4755 $INITRD_DIR/bin/busybox;

# remove the link of linuxrc.
rm -f $INITRD_DIR/linuxrc;

# stripping.
Stripping $INITRD_DIR || { exit 1; }

# successed and exit.
exit 0;

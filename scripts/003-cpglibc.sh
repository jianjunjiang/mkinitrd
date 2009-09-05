#!/bin/sh
#
# Description	: Copy share library.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# if no enable flag, the script will exit directly.
[ -z $CPGLIBC_ENABLE ] || [ $CPGLIBC_ENABLE != "y" ] && { exit 0; }

# echo the title.
echo "[cpglibc] Create share library for target...";

# enter the share library directory.
cd ${SHARE_LIB_DIR}|| { echo "Error: Could not enter the $SHARE_LIB_DIR directory."; exit 1; }

# copy share library.
cp *-*.so ${INITRD_DIR}/lib/;
cp -d *.so.[*0-9] ${INITRD_DIR}/lib/;
cp libSegFault.so libmemusage.so ${INITRD_DIR}/lib/;


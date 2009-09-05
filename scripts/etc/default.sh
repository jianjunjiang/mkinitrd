#!/bin/sh
#
# Description	: create directory for /etc/default.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# echo the title.
echo "[default] Create directory for /etc/default ...";

# source the common function.
source $PROG_DIR/common.sh;

# make sure the /etc dirctory.
DIR=$INITRD_DIR/etc/default;
[ -d $DIR ] || { mkdir -p -m 0755 $DIR; chown 0:0 $DIR; }

# run all of scripts.
LoopScripts $PROG_DIR/scripts/etc/default || { exit 1; }

# successed and exit.
exit 0;

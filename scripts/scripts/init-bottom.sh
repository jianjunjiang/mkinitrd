#!/bin/sh
#
# Description	: create directory for /scripts/init-bottom.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# echo the title.
echo "[scripts] Create directory for /scripts/init-bottom ...";

# source the common function.
source $PROG_DIR/common.sh;

# make sure the /scripts/init-bottom dirctory.
DIR=$INITRD_DIR/scripts/init-bottom;
[ -d $DIR ] || { mkdir -p -m 0755 $DIR; chown 0:0 $DIR; }

# run all of scripts.
LoopScripts $PROG_DIR/scripts/scripts/init-bottom || { exit 1; }

# successed and exit.
exit 0;

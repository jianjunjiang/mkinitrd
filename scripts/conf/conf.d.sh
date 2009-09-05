#!/bin/sh
#
# Description	: create directory for /conf/conf.d
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# echo the title.
echo "[conf.d] Create directory for /conf/conf.d ...";

# source the common function.
source $PROG_DIR/common.sh;

# make sure the /conf dirctory.
DIR=$INITRD_DIR/conf/conf.d;
[ -d $DIR ] || { mkdir -p -m 0755 $DIR; chown 0:0 $DIR; }

# run all of scripts.
LoopScripts $PROG_DIR/scripts/conf/conf.d || { exit 1; }

# successed and exit.
exit 0;

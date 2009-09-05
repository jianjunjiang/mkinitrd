#!/bin/sh
#
# Description	: Make initrd.
# Authors	: jianjun jiang - jerryjianjun@gmail.com
# Version	: 0.01
# Notes		: None
#


# set up the environment of PROG_DIR.
export PROG_DIR=$(cd `dirname $0` ; pwd)

# set up the environment of DOWNLOADS_DIR.
export DOWNLOADS_DIR=$PROG_DIR/downloads/

# set up the environment of BUILD_DIR.
export BUILD_DIR=$PROG_DIR/build/

# set up the environment of PATCHS_DIR.
export PATCHS_DIR=$PROG_DIR/patchs/

# set up the environment of RESOURCE_DIR.
export RESOURCE_DIR=$PROG_DIR/resource/

# set up the environment of RELEASE_DIR.
export RELEASE_DIR=$PROG_DIR/release/

# set up the environment of TOOLS_DIR.
export TOOLS_DIR=$PROG_DIR/tools/

# set up the environment of INITRD_DIR.
export INITRD_DIR=$RELEASE_DIR/initrd/


# enter the program directory.
cd $PROG_DIR || { echo "Error: Could not enter the program directory."; exit 1; }

# source the config file.
source $PROG_DIR/config;

# source the common function.
source $PROG_DIR/common.sh;

# create directorys.
mkdir -p $BUILD_DIR  || { echo "Error: Could not create build directory."; exit 1; }
mkdir -p $INITRD_DIR || { echo "Error: Could not create initrd directory."; exit 1; }
mkdir -p $DOWNLOADS_DIR || { echo "Error: Could not create downloads directory."; exit 1; }

# fetch the depend scripts.
DEPEND_SCRIPTS=(`ls $PROG_DIR/depends/*.sh | sort`)

# run all the depend scripts.
for SCRIPT in ${DEPEND_SCRIPTS[@]}; do "$SCRIPT" || { echo "$SCRIPT: Failed."; exit 1; } done

# all directories will be clean?
if [ $1 ] && [ $1 = "clean" ]; then
	rm -fr $RELEASE_DIR $BUILD_DIR *~;
	find $PROG_DIR -type f -name *.sh~ | xargs rm -f;
	find $PROG_DIR -type f -name *.patch~ | xargs rm -f;
	echo "^_^ : clean all directories.";
	exit 0;
fi

# running build scripts
echo -e "\nRunning build scripts...";

# fetch the build scripts.
BUILD_SCRIPTS=(`ls $PROG_DIR/scripts/*.sh | sort`)

# if specific steps were requested...
if [ $1 ]; then
	"$PROG_DIR/scripts/$1" || { echo "$1: Failed."; exit 1; }
else
	for SCRIPT in ${BUILD_SCRIPTS[@]}; do "$SCRIPT" || { echo "$SCRIPT: Failed."; exit 1; } done
fi

echo "^_^ : Make initrd successed!";
echo "      The path is: $RELEASE_DIR";


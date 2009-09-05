#!/bin/sh
#
# Description	: Common functions.
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Notes		: None
#


# Download, unpack, and patch a tarball from any one of the given URLs.
# If the tarball already exists, don't download it.
# Assumes that the tarball unpacks to a name guessable from its url,
# and that patches already exist locally in a directory named after the tarball.
GetUnpackAndPatch() {
	for arg; do
		case $arg in
        	*.gz|*.bz2|*.tgz) ;;
        	*) echo "unknown suffix on url $arg"; return 1 ;;
        	esac

		ARCHIVE_NAME=`echo $arg | sed 's,.*/,,;'`
		BASENAME=`echo $ARCHIVE_NAME | sed 's,\.tar\.gz$,,;s,\.tar\.bz2$,,;s,\.tgz,,;'`

		# download the source code.
		if [ ! -f "$DOWNLOADS_DIR/$ARCHIVE_NAME" ]; then
			wget --continue --directory-prefix $DOWNLOADS_DIR $arg || { return 1; }
		fi

		# unpack the source code.
		rm -Rf "$BUILD_DIR/$BASENAME" && tar xfv "$DOWNLOADS_DIR/$ARCHIVE_NAME" -C $BUILD_DIR || { return 1; }

		# enter the BASENAME directory.
		cd "$BUILD_DIR/$BASENAME"|| { echo "Error: Could not enter the $BASENAME directory."; return 1; }

		# patch the BASENAME, if need.
		if test -d $PATCHS_DIR/$BASENAME; then
			for p in $PATCHS_DIR/$BASENAME/*patch* $PATCHS_DIR/$BASENAME/*.diff; do
				if test -f $p; then
					echo "applying patch $p"
					patch -g0 --fuzz=1 -p1 -f < $p > patch$$.log 2>&1 || { cat patch$$.log; echo "patch $p failed"; return 1; }
					cat patch$$.log
					egrep -q "^No file to patch.  Skipping patch.|^Hunk .* FAILED at" patch$$.log && { echo "patch $p failed"; return 1; }
					rm -f patch$$.log
				fi
			done
		fi
	done
	return 0;
}

# do loop scripts.
LoopScripts() {
	if [ $1 ] && [ -d $1 ]; then
		local LOOP_SCRIPTS=(`ls $1/*.sh | sort`)
		for SCRIPT in ${LOOP_SCRIPTS[@]}; do "$SCRIPT" || { echo "$SCRIPT: Failed."; return 1; } done
		return 0;
	else
		return 1;
	fi
}

Stripping() {
	if [ $1 ] && [ -d $1 ]; then
		for dir in $1/{,usr/{,local/}}{bin,sbin}; do
			[ -d $dir ] && find $dir -type f -exec ${CROSS}strip --strip-all '{}' ';';
		done
		for dir in $1/{,usr/{,local/}}lib; do
			[ -d $dir ] && find $dir -type f -exec ${CROSS}strip --strip-debug '{}' ';';
		done
		return 0;
	else
		return 1;
	fi
}

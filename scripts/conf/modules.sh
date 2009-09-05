#!/bin/sh
#
# Description	: modules
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /conf/modules
# Notes		: 


# echo the title.
echo "[conf] Create /conf/modules ...";

# The contents of /conf/modules file.
cat > $INITRD_DIR/conf/modules << "EOF"

EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/conf/modules;
chown 0:0 $INITRD_DIR/conf/modules;


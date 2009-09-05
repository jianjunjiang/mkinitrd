#!/bin/sh
#
# Description	: resume
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /conf/conf.d/resume
# Notes		: 


# echo the title.
echo "[conf.d] Create /conf/conf.d/resume ...";

# The contents of /conf/conf.d/resume file.
cat > $INITRD_DIR/conf/conf.d/resume << "EOF"
RESUME=
EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/conf/conf.d/resume;
chown 0:0 $INITRD_DIR/conf/conf.d/resume;


#!/bin/sh
#
# Description	: console-setup
# Authors	: jianjun jiang - jjjstudio@gmail.com
# Version	: 0.01
# Path		: /etc/default/console-setup
# Notes		: 


# echo the title.
echo "[default] Create /etc/default/console-setup ...";

# The contents of /etc/default/console-setup file.
cat > $INITRD_DIR/etc/default/console-setup << "EOF"
# A configuration file for setupcon

# Change to "yes" and setupcon will explain what is being doing
VERBOSE_OUTPUT=no

# Setup these consoles.  Most people do not need to change this.
ACTIVE_CONSOLES="/dev/tty[1-6]"

# Put here your encoding.  Valid charmaps are: UTF-8 ARMSCII-8 CP1251
# CP1255 CP1256 GEORGIAN-ACADEMY GEORGIAN-PS IBM1133 ISIRI-3342
# ISO-8859-1 ISO-8859-2 ISO-8859-3 ISO-8859-4 ISO-8859-5 ISO-8859-6
# ISO-8859-7 ISO-8859-8 ISO-8859-9 ISO-8859-10 ISO-8859-11 ISO-8859-13
# ISO-8859-14 ISO-8859-15 ISO-8859-16 KOI8-R KOI8-U TIS-620 VISCII
CHARMAP="UTF-8"

# The codeset determines which symbols are supported by the font.
# Valid codesets are: Arabic Armenian CyrAsia CyrKoi CyrSlav Ethiopian
# Georgian Greek Hebrew Lao Lat15 Lat2 Lat38 Lat7 Thai Uni1 Uni2 Uni3
# Vietnamese.  Read README.fonts for explanation.
CODESET="Uni1"

# Valid font faces are: VGA (sizes 8, 14 and 16), Terminus (sizes
# 12x6, 14, 16, 20x10, 24x12, 28x14 and 32x16), TerminusBold (sizes
# 14, 16, 20x10, 24x12, 28x14 and 32x16), TerminusBoldVGA (sizes 14
# and 16), Fixed (sizes 13, 14, 15, 16 and 18), Goha (sizes 12, 14 and
# 16), GohaClassic (sizes 12, 14 and 16).
FONTFACE="Fixed"
FONTSIZE="16"

# You can also directly specify nonstandard font and ACM to load:
# FONT=/usr/local/share/funnyfonts/sarge16.psf
# ACM=/usr/local/share/consoletrans/my_special_encoding.acm

# The following variables describe your keyboard and can have the same
# values as the XkbModel, XkbLayout, XkbVariant and XkbOptions options
# in /etc/X11/xorg.conf.
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS=""


# Do not update the following md5 sum if you change
# /etc/console-setup/boottime.kmap.gz and Debconf will not overwrite
# your custom keymap.  Do not update it even if you want to make
# Debconf overwrite it.  Instead simply specify the empty string as
# a md5 sum.

BOOTTIME_KMAP_MD5="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
EOF

# change the owner and permission.
chmod 644 $INITRD_DIR/etc/default/console-setup;
chown 0:0 $INITRD_DIR/etc/default/console-setup;


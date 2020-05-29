#!/bin/bash
if [ ! -f "/usr/bin/mksquashfs" ]; then
    echo "Package 'squashfs-tools' not installed in the system"
    exit
fi
if [ -z "$1" ]; then
    echo "Compress a directory in a .opk file (squashfs)."
    echo "Usage:"
    echo "       opk.sh <directory>"
    exit
fi
if [ ! -d "$1" ]; then
    echo "<$1> is not a directory"
    exit
fi
dir=$(dirname "$1")"/"$(basename "$1")
opk="$dir.opk"
mksquashfs "$dir/" "$opk" -all-root -noappend -no-exports -no-xattrs

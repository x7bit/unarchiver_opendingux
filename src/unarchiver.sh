#!/bin/sh
readKey() {
    echo
    echo "Press START to continue..."
    oldstty=`stty -g`
    stty -icanon -echo min 1 time 0
    dd bs=1 count=1 >/dev/null 2>&1
    stty "$oldstty"
    echo
}
checkCmd() {
    which=$(which "$1")
    if [ -z "$which" ]; then
        echo "$1: command not found"
        readKey
        exit
    fi
}
noMime() {
    echo "$1: MIME not recognized"
    readKey
    exit
}
# MAIN BLOCK
dir=$(dirname "$1")
mime=$(file -bi "$1" | cut -d';' -f1)
case $mime in
    "application/zip")
        checkCmd unzip
        unzip -od "$dir" "$1"
        ;;
    "application/tar")
        checkCmd tar
        tar -xf "$1" -C "$dir" --overwrite
        ;;
    "application/tar+gzip")
        checkCmd tar
        tar -xzf "$1" -C "$dir" --overwrite
        ;;
    "application/x-rar")
        checkCmd unrar
        unrar x -o+ "$1" "$dir"
        ;;
    "application/x-7z-compressed")
        checkCmd 7zr
        7zr x -aoa -o"$dir" "$1"
        ;;
    *)
        noMime "$mime"
        ;;
esac
usleep 400000

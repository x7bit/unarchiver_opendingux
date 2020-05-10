#!/bin/sh
dir=$(dirname "$1")
mime=$(file -bi "$1" | cut -d';' -f1)
case $mime in
    "application/zip")
        unzip -od "$dir" "$1"
        ;;
    "application/tar")
        tar -xf "$1" -C "$dir" --overwrite
        ;;
    "application/tar+gzip")
        tar -xzf "$1" -C "$dir" --overwrite
        ;;
    "application/x-rar")
        unrar x -o+ "$1" "$dir"
        ;;
    "application/x-7z-compressed")
        7zr x -aoa -o"$dir" "$1"
        ;;
esac

#!/bin/sh
readKey() {
    echo
    printf '\e[1;36m%-6s\e[m' "Press START to continue..."
    oldstty=`stty -g`
    stty -icanon -echo min 1 time 0
    dd bs=1 count=1 >/dev/null 2>&1
    stty "$oldstty"
}
checkCmd() {
    which=$(which "$1")
    if [ -z "$which" ]; then
        printf '\e[0;31m%-6s\e[m' "$1: command not found"
        readKey
        echo
        exit
    fi
}
unarchive() {
    if $2; then
        printf '\e[0;32m%-6s\e[m' "$(basename "$1"): successfully decompressed"
        sleep 0.4
    else
        printf '\e[0;31m%-6s\e[m' "$(basename "$1"): decompression failed"
        readKey
    fi
}
ungzip() {
    regexSize=$(expr "$1" : '^.*.tar.gz$')
    totalSize=$(expr length "$1")
    if [ "$regexSize" = "$totalSize" ]; then
        checkCmd tar
        unarchive "$1" $(tar -xzf "$1" -C "$dir" --overwrite)
    else
        checkCmd gunzip
        unarchive "$1" $(gunzip -f "$1")
    fi
}
byExtension() {
    ext=$(echo $1 | sed 's/^.*\.//')
    case $ext in
        "zip")
            checkCmd unzip
            unarchive "$1" $(unzip -od "$dir" "$1")
            ;;
        "gz")
            ungzip "$1"
            ;;
        "tar")
            checkCmd tar
            unarchive "$1" $(tar -xf "$1" -C "$dir" --overwrite)
            ;;
        "rar")
            checkCmd unrar
            unarchive "$1" $(unrar x -o+ "$1" "$dir")
            ;;
        "7z")
            checkCmd 7zr
            unarchive "$1" $(7zr x -aoa -o"$dir" "$1")
            ;;
        *)
            printf '\e[0;31m%-6s\e[m' "$(basename "$1"): extension not recognized"
            readKey
            ;;
    esac
}
# MAIN BLOCK
dir=$(dirname "$1")
mime=$(file -bi "$1" | cut -d';' -f1)
case $mime in
    "application/zip" | "application/x-zip-compressed")
        checkCmd unzip
        unarchive "$1" $(unzip -od "$dir" "$1")
        ;;
    "application/gzip" | "application/x-gzip")
        ungzip "$1"
        ;;
    "application/tar" | "application/x-tar")
        checkCmd tar
        unarchive "$1" $(tar -xf "$1" -C "$dir" --overwrite)
        ;;
    "application/tar+gzip")
        checkCmd tar
        unarchive "$1" $(tar -xzf "$1" -C "$dir" --overwrite)
        ;;
    "application/x-rar" | "application/x-rar-compressed")
        checkCmd unrar
        unarchive "$1" $(unrar x -o+ "$1" "$dir")
        ;;
    "application/x-7z-compressed")
        checkCmd 7zr
        unarchive "$1" $(7zr x -aoa -o"$dir" "$1")
        ;;
    "application/octet-stream")
        byExtension "$1"
        ;;
    *)
        printf '\e[0;31m%-6s\e[m' "$mime: MIME not recognized"
        readKey
        ;;
esac
echo

#!/bin/bash
if [ ! -f "/usr/bin/mksquashfs" ]; then
	echo "El paquete 'squashfs-tools' no está instalado en el sistema"
	exit
fi
if [ -z "$1" ]; then
	echo "Comprime un directorio en un archivo .opk (squashfs)."
	echo "Uso:"
	echo "       opk.sh <directorio>"
	exit
fi
if [ ! -d "$1" ]; then
	echo "<$1> no es un directorio"
	exit
fi
dir=$(dirname "$1")"/"$(basename "$1")
opk="$dir.opk"
mksquashfs "$dir/" "$opk" -all-root -noappend -no-exports -no-xattrs

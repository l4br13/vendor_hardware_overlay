#!/bin/bash

set -e

export LD_LIBRARY_PATH=.
export PATH=.:$PATH

path=$(dirname $0)
source=$path/src

if [ -n "$1" ]; then
	if [ -d $source/$1 ]; then
		echo $source/$1
	fi
else
	for i in $source/*; do
		if [ -f $i/AndroidManifest.xml ]; then
			echo "Building $(basename $i).apk"
			aapt package -f -F "$path/$(basename $i)-unsigned.apk" -M "$i/AndroidManifest.xml" -S "$i/res" -I $path/android.jar
			LD_LIBRARY_PATH=$path/signapk/ java -jar $path/signapk/signapk.jar $path/keys/platform.x509.pem $path/keys/platform.pk8 "$path/$(basename $i)-unsigned.apk" "$path/$(basename $i).apk"
			rm -f "$path/$(basename $i)-unsigned.apk"
		fi
	done
fi

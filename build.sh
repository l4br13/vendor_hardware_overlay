#!/bin/bash

set -e

export LD_LIBRARY_PATH=.
export PATH=.:$PATH

name=treble-overlay-xiaomi-fleur

path=$(dirname $0)

for i in $path/devices/*;
do
	if [ -f $i/AndroidManifest.xml ]; then
		echo "Building $(basename $i).apk"
		aapt package -f -F "$(dirname $0)/$(basename $i)-unsigned.apk" -M "$i/AndroidManifest.xml" -S "$i/res" -I android.jar
		LD_LIBRARY_PATH=./signapk/ java -jar signapk/signapk.jar keys/platform.x509.pem keys/platform.pk8 "$(basename $i)-unsigned.apk" "$(basename $i).apk"
		rm -f "$(basename $i)-unsigned.apk"
	fi
done

#echo "Building $name"

#aapt package -f -F "${name}-unsigned.apk" -M "$path/AndroidManifest.xml" -S "$path/res" -I android.jar

#rm -f "${name}-unsigned.apk"
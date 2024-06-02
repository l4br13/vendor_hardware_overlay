#!/bin/bash

set -e

export LD_LIBRARY_PATH=.
export PATH=.:$PATH

name=treble-overlay-xiaomi-fleur

path=$(dirname $0)

echo "Building $name"

aapt package -f -F "${name}-unsigned.apk" -M "$path/AndroidManifest.xml" -S "$path/res" -I android.jar

LD_LIBRARY_PATH=./signapk/ java -jar signapk/signapk.jar keys/platform.x509.pem keys/platform.pk8 "${name}-unsigned.apk" "${name}.apk"
rm -f "${name}-unsigned.apk"
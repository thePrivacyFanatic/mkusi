#!/bin/bash

set -euo pipefail

echo "importing key"
gpg -q --auto-key-locate=clear,nodefault,wkd --locate-key releng@gentoo.org

echo "downloading stage file"
# set your own release and image
url=https://distfiles.gentoo.org/releases/amd64/autobuilds/20260621T164603Z/stage3-amd64-openrc-20260621T164603Z.tar.xz
curl -# $url -o temp/stage3.tar.xz --skip-existing

echo "downloading signature"
curl -# "${url}.asc" -o temp/stage3.tar.xz.asc --skip-existing
echo "verifying"

gpg -q --verify temp/stage3.tar.xz.asc temp/stage3.tar.xz

# rm temp/stage3.tar.xz.asc

echo "starting to extract stage file"
tar xpf temp/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C root

# rm temp/stage3.tar.xz


set -euo pipefail

# set your own release and image
url=https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/x86_64/alpine-minirootfs-3.24.1-x86_64.tar.gz

#echo "importing key"
#curl -# https://alpinelinux.org/keys/ncopa.asc -o temp/alpine.asc --skip-existing
#gpg -q --import temp/alpine.asc
# rm temp/alpine.asc

echo "getting rootfs"
curl -# $url -o temp/alpine.tar.xz --skip-existing

#echo "verifying"
#curl -# "$url.asc" -o temp/alpine.tar.xz.asc --skip-existing
#gpg -q --verify temp/alpine.tar.xz.asc temp/alpine.tar.xz
# rm temp/alpine.tar.xz.asc

echo "extracting"
tar xpf temp/alpine.tar.xz --xattrs-include='*.*' --numeric-owner --no-same-owner -C root
# rm temp/alpine.tar.xz

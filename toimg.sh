#!/bin/sh

# testing script intended for putting UKI.efi in an IMG file (which acts as an EFI system partition for a VM)
set -euo pipefail
if [ -f esp.img ]; then
  rm esp.img
fi
SIZE=$(du -As UKI.efi | cut -f1)
dd if=/dev/zero of=esp.img bs=4M count=1 seek=$SIZE
mkfs.fat -F 32 esp.img
mmd -i esp.img ::/EFI
mmd -i esp.img ::/EFI/boot
mcopy -i esp.img UKI.efi ::/EFI/boot/BOOTx64.efi

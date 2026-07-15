# a simple toolkit for creating USIs

This provides a few tools that can make the creation of unified system images
that little bit easier.
I created this since mkosi's docummentation is lacking, to say the least.

## building

### on arch

Download the PKGBUILD
run ```makepkg -si```

### everywhere else

Clone the repo
export the prefix in which you want the static init binary to be stored (e.g /usr/share/)
run make all
run make DESTDIR="/" install

## tools included

### mksqshroot

Sets up some directores and executes all programs
(scripts with execute permission or compiled) as root,
(either real root or in unshare) before compressing the direactory
named 'root' into a squashfs

Usage: mksqshroot [-hc] output_filename
  -c         Cleans the temp directory before running

### sqroottouki

Usage: sqroottouki [-h] kernel squashfs_path output_filename

Creates a unified system image from a kernel and a squashfs root

### mkusi

Usage: mkusi [-hc] kernel output_filename
  -c         Cleans the mksquashroot temp directory before running

Shortcut for the whole process from a hook directory to a USI

### toimg.sh

A testing script for VMs that uses mtools to create a disk image from the UKI
thats's named UKI.efi (not installed by the makefile)

## example scripts

Example hooks are currently provided only for alpine linux and gentoo.
This will hopefully be expanded upon soon, ironically, pacman's use of /proc/
makes it impossible to run unprivileged sometimes and as such a lower priority

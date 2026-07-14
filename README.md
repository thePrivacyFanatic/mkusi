# a simple toolkit for creating USIs
this provides a few tools that can make the creation of unified system images that little bit easier.
I created this since mkosi's docummentation is lacking, to say the least.
## building
### on arch
download the PKGBUILD
run makepkg -si
### everywhere else
clone the repo
export the prefix in which you want the static init binary to be stored
run make all
run make DESTDIR="/" install
## tools included
### mksqshroot
ran in a directory with scripts (in the form that can be seen in the example directory) 
to create a root filesystem (in an unshare container to provide fake privilege) which is finally compressed into a squashfs
### sqroottouki
ran on a squashfs image and installed kernel version to create a unified system image with it as root
### mkusi
the whole proccess at once
### toimg.sh
a testing script for VMs that uses mtools to create a disk image from the UKI (not installed by the makefile)

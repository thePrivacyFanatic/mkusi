#!/bin/sh

echo "installing base"
chroot "root" /sbin/apk --initdb -X https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/ add busybox-extras openrc busybox-mdev-openrc busybox-openrc arch-install-scripts -q

echo "installing clevis from edge"
chroot "root" /sbin/apk add clevis --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing -q

# prevent warnings from halting the proccess
exit 0

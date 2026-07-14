#!/bin/bash

. ../../options.conf

echo "creating module dir for kernel $kernel"
mkdir root/lib/modules

echo "symlinking into image"
cp -r /usr/lib/modules/$kernel root/lib/modules/$kernel

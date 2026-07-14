#!/bin/bash

set -euo pipefail
rootpw="12345"
echo "changing root password"
echo "root:$rootpw" | chroot root /bin/busybox chpasswd

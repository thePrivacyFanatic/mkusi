#!/bin/bash
set -euo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
clean=false

usage() {
  cat <<USAGE
Usage: $SCRIPT_NAME [-hc] kernel output_filename
  -h         Displays this help
  -c         cleans the mksquashroot temp directory before running

Shortcut for the whole process from a hook directory to a USI
USAGE
}

while getopts "hc" opt; do
  case $opt in
  c) clean=true ;;
  h)
    usage
    exit 0
    ;;
  esac
done

if [ $(($# - $OPTIND)) -lt 1 ]; then
  echo "too few arguments"
  usage
  exit 1
fi

kernel=${@:$OPTIND:1}
export kernel
output_filename=${@:$OPTIND+1:1}

mksqshroot rootfs.sqsh $($clean && echo "-c")
sqroottouki $kernel rootfs.sqsh $output_filename

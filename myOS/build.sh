#!/bin/sh
set -e      # exit immediately if any command exit with non-zero status
. ./headers.sh

for PROJECT in $PROJECTS; do 
    (cd $PROJECT && DESTDIR="$SYSROOT" $MAKE install)
done
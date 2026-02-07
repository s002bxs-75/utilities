#!/bin/bash

if [ -z "$1" ]
then
    echo "Drive password NOT specified!"
else
    mkdir -p ~/Desktop/BitlockerDrive ~/Desktop/Drive

    doas modprobe fuse
    doas dislocker -V /dev/sdb1 -u"$1" -- ~/Desktop/BitlockerDrive
    doas mount -o loop ~/Desktop/BitlockerDrive/dislocker-file ~/Desktop/Drive
fi

#!/bin/bash

if [ -z "$1" ]
then
    echo "Data file path NOT specified!"
elif [ -z "$2" ]
then
    echo "Data file password NOT specified!"
else
    mkdir -p ~/Desktop/BitlockerData ~/Desktop/Data

    doas modprobe fuse
    doas modprobe nbd max_part=16
    doas qemu-nbd -c /dev/nbd0 "$1"
    doas fdisk -l /dev/nbd0
    doas dislocker -V /dev/nbd0p1 -u"$2" -- ~/Desktop/BitlockerData
    #doas mount -o loop -t fat ~/Desktop/BitlockerData/dislocker-file ~/Desktop
    #doas mount -o loop -t vfat ~/Desktop/BitlockerData/dislocker-file ~/Desktop
    #doas mount -o loop -t exfat ~/Desktop/BitlockerData/dislocker-file ~/Desktop
    #doas mount -o loop -t ext4 ~/Desktop/BitlockerData/dislocker-file ~/Desktop
    #doas mount -o loop -t ntfs ~/Desktop/BitlockerData/dislocker-file ~/Desktop/Data
fi

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
    doas dislocker -V "$1" -u"$2" -- ~/Desktop/BitlockerData
    doas mount -o loop -t exfat ~/Desktop/BitlockerData/dislocker-file ~/Desktop/Data
fi

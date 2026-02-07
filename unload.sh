#!/bin/bash

doas umount ~/Desktop/Data
doas umount ~/Desktop/BitlockerData
rm -rf ~/Desktop/Data ~/Desktop/BitlockerData
doas qemu-nbd -d /dev/nbd0
doas umount ~/Desktop/Drive
doas umount ~/Desktop/BitlockerDrive
rm -rf ~/Desktop/Drive ~/Desktop/BitlockerDrive

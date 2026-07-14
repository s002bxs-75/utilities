#!/bin/bash

doas umount ~/Desktop/Data
doas umount ~/Desktop/BitlockerData
rm -rf ~/Desktop/Data ~/Desktop/BitlockerData

doas umount ~/Desktop/VBoxShare
rm -rf ~/Desktop/VBoxShare

doas umount ~/Desktop/Drive
doas umount ~/Desktop/BitlockerDrive
rm -rf ~/Desktop/Drive ~/Desktop/BitlockerDrive

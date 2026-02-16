#!/bin/bash

echo "http://plug-mirror.rcac.purdue.edu/alpine/edge/main" | doas tee -a "/etc/apk/repositories"
echo "http://plug-mirror.rcac.purdue.edu/alpine/edge/community" | doas tee -a "/etc/apk/repositories"
echo "http://plug-mirror.rcac.purdue.edu/alpine/edge/testing" | doas tee -a "/etc/apk/repositories"
doas apk update
doas apk upgrade
doas apk add dislocker fuse3 ntfs-3g qemu-img vlc vlc-qt

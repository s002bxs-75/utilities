#!/bin/bash

doas apk update                                                                                                           
doas apk upgrade                                                                                                          
doas apk add fuse cryptsetup fuse-exfat exfat-utils qimgv vlc vlc-qt

# Check if dislocker is available, if not, pull from testing repository
if ! command -v dislocker &> /dev/null; then
    echo "Installing dislocker from Alpine testing repository..."
    doas apk add dislocker --repository=http://plug-mirror.rcac.purdue.edu/alpine/edge/testing
fi

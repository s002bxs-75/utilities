#!/bin/bash

if [ -z "$1" ]
then
    echo "VirtualBox share name NOT specified!"
else
    mkdir -p ~/Desktop/VBoxShare
    
    doas mount -t vboxsf "$1" ~/Desktop/VBoxShare
fi

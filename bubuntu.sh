#!/bin/bash
hdiutil convert -format UDRW -o $3 $2
diskutil unmountDisk /dev/disk$1
dd if=$3.dmg of=/dev/rdisk$1 bs=1m
diskutil eject /dev/disk$1 


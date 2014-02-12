#!/bin/bash
if [ -z "$1" ]
  then
    echo "Thumb drive disk number not supplied, please run 'diskutil list'"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "ISO path not supplied"
    exit 1
fi

# the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Current working directory is $DIR"

# the temp directory used, within $DIR
WORK_DIR=`mktemp -d "$DIR/tempXXXXXX"`
echo "Created temporary working directory $WORK_DIR"

# deletes the temp directory
function cleanup {
  rm -rf "$WORK_DIR"
  echo "Deleted temp working directory $WORK_DIR"
}

# ensure clean always runs
trap cleanup EXIT

# convert iso to dmg
hdiutil convert -format UDRW -o $WORK_DIR/iso.img $2 || exit 1

# renaming just because
mv $WORK_DIR/iso.img.dmg $WORK_DIR/iso.img

diskutil unmountDisk /dev/disk$1

echo "Creating bootable image on thumb drive"

# copy img over to thumb drive
dd if=$WORK_DIR/iso.img of=/dev/rdisk$1 bs=1m || exit 1

echo "Completed creation of bootable thumb drive, ejecting"

diskutil eject /dev/disk$1

exit 0

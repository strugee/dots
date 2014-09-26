#/bin/bash
# variable declarations
declare MOUNT_VIRTUAL_MOUNTPOINT=/media/virtual
declare MOUNT_VIRTUAL_IMAGE="/media/Macintosh HD/Users/alex/VirtualBox VMs/Debian/Debian.vdi.raw"
# verbosity - 0 is verbose, everything else is minimal verbosity. TODO make this work better/make more sense
declare MOUNT_VIRTUAL_VERBOSE=0
# set up the root filesystem from the image and mount it
echo "Mounting the root filesystem... "
if $MOUNT_VIRTUAL_VERBOSE; then echo "Setting up a loopback device on /dev/loop1..."; fi
sudo losetup -o 2097152 --sizelimit 352321024 /dev/loop1 $MOUNT_VIRTUAL_IMAGE
if $MOUNT_VIRTUAL_VERBOSE; then echo "Mounting /dev/loop1 on " $MOUNT_VIRTUAL_MOUNTPOINT "..."; fi
sudo mount /dev/loop1 $MOUNT_VIRTUAL_MOUNTPOINT
# set up /var from the image and mount it
echo "Mounting the filesystem that contains /var..."
if $MOUNT_VIRTUAL_VERBOSE; then echo "Setting up a loopback device on /dev/loop2..."; fi
sudo losetup -o 9352249344 --sizelimit 12352224768 /dev/loop2 $MOUNT_VIRTUAL_IMAGE
if $MOUNT_VIRTUAL_VERBOSE; then echo "Mounting  /dev/loop2 as /var on " $MOUNT_VIRTUAL_MOUNTPOINT "..."; fi
sudo mount /dev/loop2 $MOUNT_VIRTUAL_MOUNTPOINT/var
# set up /home from the image and mount it
echo "Mounting the filesystem that contains /home..."
if $MOUNT_VIRTUAL_VERBOSE; then echo "Setting up a loopback device on /dev/loop3..."; fi
sudo losetup -o 17045651456 --sizelimit 48317332992 /dev/loop3 /media/Macintosh\ HD/Users/alex/VirtualBox\ VMs/Debian/Debian.vdi.raw
if $MOUNT_VIRTUAL_VERBOSE; then echo "Mounting /dev/loop3 as /home " on $MOUNT_VIRTUAL_MOUNTPOINT "..."; fi
sudo mount /dev/loop3 $MOUNT_VIRTUAL_MOUNTPOINT/home
echo "you'll have to do the rest yourself. you need to mount /home, and probably some other things"

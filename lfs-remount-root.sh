#!/bin/bash
echo ""
echo "### A quick script to re-setup the chroot environment"
echo "###  after rebooting."
echo "### ================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root

echo ""
echo "*** Remounting LFS Root & Swap Partitions"
mount $LFS_ROOT_PARTITION $LFS_MOUNT_DIR
swapon $LFS_SWAP_PARTITION
check_lfs_partition_mounted_and_swap_on


if [ -d "$LFS_MOUNT_DIR/bin"  -a  -d "$LFS_MOUNT_DIR/sbin"  -a  -d "$LFS_MOUNT_DIR/usr" -a  -d "$LFS_MOUNT_DIR/root"   ]; then
  echo "*** It appears the LFS mount dir has the file structure established in"  	
  echo "*** Ch 6.5.  Therefore, re-creating Virtual Kernel File Systems from "
  echo "*** Ch 6.2 in the book.  "

  echo "*** Redoing after reboot: 6.2.2. Mounting and Populating /dev"
  mount -v --bind /dev $LFS_MOUNT_DIR/dev  
  
  echo "*** Redoing after reboot: 6.2.3. Mounting Virtual Kernel File Systems" 
  mount -vt devpts devpts $LFS_MOUNT_DIR/dev/pts  -o gid=5,mode=620 
  mount -vt proc proc $LFS_MOUNT_DIR/proc  
  mount -vt sysfs sysfs $LFS_MOUNT_DIR/sys 
  mount -vt tmpfs tmpfs $LFS_MOUNT_DIR/run 
  
  echo "*** To re-enter chroot environment, run:"
	echo "*** --> ./lfs-chroot-root.sh "
	echo "***"
  
fi



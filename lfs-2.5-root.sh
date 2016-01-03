#!/bin/bash
echo ""
echo "### 2.5. Mounting the New Partition (run as root) ###"
echo "### ================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root

########## Begin LFS Chapter Content ##########

echo "*** Creating mount directory and mounting $LFS_ROOT_PARTITION at $LFS_MOUNT_DIR"
mkdir -pv $LFS_MOUNT_DIR
mount -v -t ext4 $LFS_ROOT_PARTITION $LFS_MOUNT_DIR

### The book includes a section about using multiple partitions for /usr.  Not  
### doing that here.  Everything is going to go into a single partition. 
### Keeping it simple.

echo "*** Enabling swap partition."
/sbin/swapon -v $LFS_SWAP_PARTITION

### Not in book, was added to make sure swap is set up as desired.
check_lfs_partition_mounted_and_swap_on

echo ""
echo "########################## End Chapter 2.5 ##########################"
echo "You are now ready to run:"
echo "--> ./lfs-3.1-root.sh"
echo ""


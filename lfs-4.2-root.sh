#!/bin/bash
echo ""
echo "### 4.2. Creating the $LFS_MOUNT_DIR/tools Directory (run as root) ###"
echo "### ================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root
check_lfs_partition_mounted_and_swap_on

########## Begin LFS Chapter Content ##########

echo "*** Making directory $LFS_MOUNT_DIR/tools for build tools."
mkdir -pv $LFS_MOUNT_DIR/tools

# Create symlink for toolchain to be compiled so that it always refers to /tools
echo "*** Creating symlink on root directory to $LFS_MOUNT_DIR/tools"
ln -sv $LFS_MOUNT_DIR/tools /

### Not in the book, but throughout scripts will write output to build-logs dir
echo "*** Making $LFS_MOUNT_DIR/build-logs directory to store build logs."
mkdir -pv $LFS_MOUNT_DIR/build-logs
echo "Linux From Scratch Build milestones" > $LFS_MOUNT_DIR/build-logs/0-milestones.log
echo "---------------------------------------------" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log
echo "Chapter 4.2 Completed on $(date -u)" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log

echo ""
echo "####################### End Chapter 4.2 #######################"
echo "You are now ready to run:"
echo "--> ./lfs-4.3-root.sh"
echo ""

#!/bin/bash
echo ""
echo "### 9.4.1 BLFS Prep  ###"
echo "### ================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root
check_lfs_partition_mounted_and_swap_on

### This script prepares the LFS system to begin building packages 
### for BLFS.  Because the new system is a minimal build at this
### point, this script helps prepare the new LFS environment to begin 
### building BLFS packages.

### 1 - Creates a 'blfs' directory under /sources and /build-logs

### 2 - Copies all scripts (LFS and BLFS) to /root/lfs-scripts to the new LFS
###     system. (NO I DON'T NEED THIS JUST GET GIT AND WGET WORKING)

### 3 - Downloads BLFS source packages to /sources/blfs from blfs-wget-list.

### 4 - Check the MD5 sums.  

### 1 - Creates a 'blfs' directory under /sources and /build-logs

### Note: Commenting out.  Decided to keep sources in /sources directory
### mainly because I'd need to change the extract_tarball function to account
### for the /blfs and not potentially overwrite changes to source if I open
### up a source tar and play around with it.
#if [ ! -d "/sources/blfs" ]; then
#    echo "*** Creating Directory $LFS_MOUNT_DIR/sources/blfs."
# 	  mkdir $LFS_MOUNT_DIR/sources/blfs
#    chmod a+wt $LFS_MOUNT_DIR/sources/blfs
#fi

if [ ! -d "/build-logs/blfs" ]; then
    echo "*** Creating Directory $LFS_MOUNT_DIR/build-logs/blfs."
 	  mkdir $LFS_MOUNT_DIR/build-logs/blfs
    chmod a+wt $LFS_MOUNT_DIR/build-logs/blfs
fi

### 2 - Copies all scripts
### cp -r /tools/lfs-scripts /root
### cp -r /tools/lfs-scripts/blfs-scripts /root

### 3 - Downloads BLFS source packages to /sources/blfs from blfs-wget-list.

echo "*** Retrieving Source Files ***"

grep -v '^\s*$\|^#\|^MD5' ./blfs-wget-list  | wget -nc -i- -P $LFS_MOUNT_DIR/sources

echo ""
echo "*** Verifying md5sums of sources"
grep -o 'MD5=\S*=[a-z0-9]*' ./blfs-wget-list |  awk -F  "=" '/1/ {print $3 "  " $2}' > $LFS_MOUNT_DIR/sources/blfs-md5sums
pushd  $LFS_MOUNT_DIR/sources
md5sum -c blfs-md5sums
popd

echo ""
echo "**************************** STOP!!!!!!! ****************************"
echo "************* Verify the MD5 Sums Above Are All OK!! ****************"
echo ""
#echo "########################## End Chapter 3.1 ##########################"
#echo "You are now ready to run:"
#echo "--> ./lfs-4.2-root.sh"
#echo ""
#
#exit 0

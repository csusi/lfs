#!/bin/bash
echo ""
echo "### 4.3. Adding the LFS User (run as root) ###"
echo "### ================================================================="
  
if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root
check_lfs_partition_mounted_and_swap_on

########## Begin LFS Chapter Content ##########

echo "*** Creating 'lfs' group and user."
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

### Screw a password.  This is a local VM.  
# passwd lfs

echo "*** Changing ownership of tools, sources, and build-logs directories."
chown -v lfs $LFS_MOUNT_DIR/tools
chown -v lfs $LFS_MOUNT_DIR/sources

### Not in book.  Where build-logs are going to be sent to.
chown -v lfs $LFS_MOUNT_DIR/build-logs
chown -v lfs $LFS_MOUNT_DIR/build-logs/0-milestones.log

echo "*** Copy the lfs scripts to lfs user home dir"
mkdir /home/lfs/lfs
cp lfs-4*.* /home/lfs/lfs
cp lfs-5*.* /home/lfs/lfs
cp lfs-include.sh  /home/lfs/lfs
chown -R lfs:lfs /home/lfs/lfs
chmod 760 /home/lfs/lfs/lfs-*

### We are now ready to 'su - lfs', which I am commenting it out of the script.
### Having user perform this task, and then run the next script.
### su - lfs

echo ""
echo "########################### End Chapter 4.3 ###########################"
echo "You are now ready to change to the 'lfs' user and continue:"
echo "--> su - lfs"
echo "--> cd lfs ; ./lfs-4.4-lfs.sh"
echo ""

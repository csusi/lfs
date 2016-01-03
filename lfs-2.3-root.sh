#!/bin/bash
echo "### 2.3. Creating a File System on the Partition (run as root) ###"
echo "### ================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root

########## Begin LFS Chapter Content ##########

#### Not In Book: check if 'lfs' user exists.  If so, delete previous attempt.
#### Note: Not deleting backup of sources.  Allow user to do that on their own.
if id -u 'lfs' >/dev/null 2>&1; then
  echo "User 'lfs' currently exists." 
  echo "If restarting an LFS build, do you want to perform the following? "
  echo "-> userdel -r lfs                       # Delete user 'lfs'"
  echo "-> groupdel lfs                         # Delete group 'lfs'"
  echo "-> rm -rf /root/lfs-backup/tools        # Deletes tools backup"
  echo "-> rm -rf /root/lfs-backu/*build-logs   # Deletes build-logs"
  echo ""
  read -p "Do you want to proceed [Yy]? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then 
    userdel -r lfs
    groupdel lfs
    rm -rf /root/lfs-backup/tools
    rm -rf /root/lfs-backup/*build-logs
  fi
fi 
  
echo  "Continuing further will format contents of $LFS_SWAP_PARTITION and $LFS_ROOT_PARTITION."
read -p "Are you sure? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit
fi

########## Begin LFS Chapter Content ##########

echo  "*** Formatting Root Partition On $LFS_ROOT_PARTITION"
mkfs -t ext4 $LFS_ROOT_PARTITION

echo  "*** Formatting Swap Drive On $LFS_SWAP_PARTITION"
mkswap $LFS_SWAP_PARTITION

echo ""
echo "############################## End Chapter 2.4 ##############################"
echo "You are now ready to run:"
echo "--> ./lfs-2.4-root.sh"
echo ""

exit 0

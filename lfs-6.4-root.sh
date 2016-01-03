#!/bin/bash
echo ""
echo "### 6.4. Entering the Chroot Environment (0.0 SBU - running as 'root')"
echo "### ====================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root
check_lfs_partition_mounted_and_swap_on

########## Begin LFS Chapter Content ##########

echo
echo "*** In order to continue using these scripts, they will be copied "
echo "*** to the $LFS_MOUNT_DIR/tools directory. After running this script,"
echo "*** run the following two commands:"
echo "*** ---> cd /tools/lfs ; ./lfs-6.5-chroot.sh"
echo

cp -r /root/lfs $LFS_MOUNT_DIR/tools/lfs

chroot "$LFS_MOUNT_DIR" /tools/bin/env -i \
  HOME=/root \
  TERM="$TERM" \
  PS1='\u:\w\$ ' \
  PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
  /tools/bin/bash --login +h


#!/bin/bash
echo ""
echo "### 9.3 Unmount and Reboot (0.0 SBU - 'root')"
echo "### ====================================================="

### TODO: Add check running as whoami and not chrooted

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh


echo "Book Completed On $(date -u)" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log

echo "*** Then unmount the virtual file systems"

umount -v $LFS_MOUNT_DIR/dev/pts
umount -v $LFS_MOUNT_DIR/dev
umount -v $LFS_MOUNT_DIR/run
umount -v $LFS_MOUNT_DIR/proc
umount -v $LFS_MOUNT_DIR/sys

echo "*** Unmounting the LFS file system itself"
umount -v $LFS_MOUNT_DIR

echo "*** Rebooting"
shutdown -r now

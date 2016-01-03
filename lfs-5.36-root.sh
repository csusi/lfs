#!/bin/bash
echo ""
echo "### 5.36. Changing Ownership (0.0 SBU - running as 'root')"
echo "### ======================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root
check_lfs_partition_mounted_and_swap_on

########## Begin LFS Chapter Content ##########

echo "*** Taking Ownership Back of $LFS_MOUNT_DIR/tools."
chown -R root:root $LFS_MOUNT_DIR/tools

echo "*** Taking Ownership Back of $LFS_MOUNT_DIR/build-logs."
chown -R root:root $LFS_MOUNT_DIR/build-logs

echo "*** Book recommendation to backup the temporary tools directory. "
cp -r $LFS_MOUNT_DIR/tools $LFS_TOOLS_BACKUP_DIR

echo "Chapter 5 Completed on $(date -u)" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log
echo ""

echo ""
echo "############################## End Chapter 5 ###########################"
echo "*** Done with Chapter 5.  Ready to begin building your Linux System. "
echo "*** 
echo "*** Now would also be a good time to shut down and make a back-up VM."
echo "*** If shutting down do backup the VM, see section on Returning From "
echo "*** Shutting Down The Machine in the readme file."
echo "*** 
echo "*** Next script:"
echo "*** --> ./lfs-6.2-root.sh"
echo ""

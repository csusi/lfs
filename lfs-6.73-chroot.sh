#!/bin/bash
echo "### 6.73. Cleaning Up"
echo "### ================================================"
echo ""

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

rm -rf /tmp/*

echo "Chapter 6 Completed on $(date -u)" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log

echo "### Note From Book"
echo "### Removing /tools will also remove the temporary copies of Tcl, Expect, and DejaGNU which were used"
echo "### for running the toolchain tests. If you need these programs later on, they will need to be "
echo "### recompiled and re-installed. The BLFS book has instructions for this"
echo "### (see http://www.linuxfromscratch.org/blfs/)."
echo ""
echo "*** Note: If you delete this, it will delete the /tools/lfs-scripts dir.  "
echo "*** (not recommended) --> rm -rf /tools"
echo "*** "
echo "*** Now would also be a good time to shut down and make a back-up VM."
echo "*** If shutting down do backup the VM, see section on Returning From "
echo "*** Shutting Down The Machine in the readme file."
echo "*** "
echo "*** When complete, run:"
echo "*** --> ./lfs-7.2-chroot.sh"
echo "***"
echo "*** Or run next 10 chapters in sequence:"
echo "*** --> ./lfs-7.2-to-8.2-chroot.sh"
echo ""

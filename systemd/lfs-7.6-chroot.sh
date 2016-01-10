#!/bin/bash
echo ""
echo "### Systemd 7.6 Configuring the Linux Console  (chrooted to lfs partition as 'root')"
echo "### ============================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.6
LFS_SOURCE_FILE_PREFIX=sysvbootscript
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

########## Begin LFS Chapter Content ##########

### After reading this chapter, I do not believe it is necessary
### at this time.

### TODO: May be worth re-investigating for changing the font

########## Chapter Clean-Up ##########


### Not showing logs or capturing file list.  

echo "*** --> ./lfs-7.7-chroot.sh"
echo ""

#!/bin/bash
echo ""
echo "### 7.7. The Bash Shell Startup Files (chrooted to lfs partition as 'root')"
echo "### ======================================================================="

### TODO: Add find command to record changes to file system ?
### TODO: I may want to add my own default settings into this file.

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.7
LFS_SOURCE_FILE_PREFIX=bashstartup
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

########## Begin LFS Chapter Content ##########
echo ""
echo "*** Creating /etc/profile "
cat > /etc/profile << EOF
# Begin /etc/profile

export LANG=$LFS_LANG

# End /etc/profile
EOF

########## Chapter Clean-Up ##########
echo ""
echo "*** Start /etc/profile "
cat /etc/profile | tee $LFS_LOG_FILE-profile.log
echo "*** End /etc/profile "


### Not showing logs or capturing file list.  I'm adding one file.  
echo ""
echo "*** --> ./lfs-7.8-chroot.sh"
echo ""

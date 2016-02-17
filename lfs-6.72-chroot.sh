#!/bin/bash
echo "### 6.72. Stripping Again  (0.0 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.72
LFS_SOURCE_FILE_PREFIX=stripping
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX


echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

echo ""
echo "*** To run the following commands, the user needs to exit back to the Host"
echo "*** OS and re-enter the LFS instance.  This requires three exits for the "
echo "*** three levels of shells launched in Ch 6.4, 6.6, & 6.36.  Once at the "
echo "*** HOST OS, run the chroot command below, followed by the command to remove "
echo "*** debug (if desired), and then finish up the final chapter section. "
echo "*** " 
echo "*** -> exit "
echo "*** -> exit "
echo "*** -> exit "
echo "*** -> chroot $LFS_MOUNT_DIR /tools/bin/env -i HOME=/root TERM=$TERM PS1='\u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /tools/bin/bash --login"
echo "*** -> cd /root/lfs "
echo "*** -> /tools/bin/find /{,usr/}{bin,lib,sbin} -type f -exec /tools/bin/strip --strip-debug '{}' ';' " &>>$LFS_LOG_FILE-removedebugs.log
echo "*** -> ./lfs-6.73-chroot.sh"
echo ""

###  lfs-6.4-chroot.sh - At end of script, chroots for first time.
###  chroot "$LFS_MOUNT_DIR" /tools/bin/env -i \
###    HOME=/root \
###    TERM="$TERM" \
###    PS1='\u:\w\$ ' \
###    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
###    /tools/bin/bash --login +h
###
###  lfs-6.6-chroot.sh - At end of script executes a new bash shell.
###  exec /tools/bin/bash --login +h
### 
###  lfs-6.35-chroot.sh - At end of script, executes newly compiled bash shell
###  exec /bin/bash --login +h

###   lfs-6.72-chroot.sh - User prompted to execute chroot after exing to HOST os 
###   chroot $LFS_MOUNT_DIR /tools/bin/env -i \
###      HOME=/root \
###      TERM=$TERM \
###      PS1='\u:\w\$ ' \
###      PATH=/bin:/usr/bin:/sbin:/usr/sbin \
###      /tools/bin/bash --login
###
###   6.73 chroot  - The user's new chroot when entering LFS from HOST OS
###   chroot $LFS_MOUNT_DIR /usr/bin/env -i \
###     HOME=/root \
###     TERM="$TERM" \
###     PS1='\u:\w\$ ' \
###     PATH=/bin:/usr/bin:/sbin:/usr/sbin \
###     /bin/bash --login

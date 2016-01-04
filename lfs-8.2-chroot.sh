#!/bin/bash
echo ""
echo "### 8.2. Create the /etc/fstab File (chrooted to lfs partition as 'root')"
echo "### ====================================================================="


### TODO Update to use global variables !!

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=8.2
LFS_SOURCE_FILE_PREFIX=etcfstab
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 


########## Begin LFS Chapter Content ##########

echo "*** Writing /etc/fstab "
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file      mount   type      options           dump fsck 
#                                                    ordr

/dev/sdb2   /       ext4      defaults            1 1
/dev/sdb1   swap    swap      pri=1               0 0
proc        /proc   proc      nosuid,noexec,nodev 0 0
sysfs       /sys    sysfs     nosuid,noexec,nodev 0 0
devpts      /dev/pts devpts   gid=5,mode=620      0 0
tmpfs       /run    tmpfs     defaults            0 0
devtmpfs    /dev    devtmpfs  mode=0755,nosuid    0 0

# End /etc/fstab
EOF

########## Chapter Clean-Up ##########
echo ""
echo "*** Start /etc/fstab"
cat /etc/fstab | tee $LFS_LOG_FILE-fstab.log
echo "*** End /etc/fstab"


echo "*** --> ./lfs-8.3.1-chroot.sh"
echo ""
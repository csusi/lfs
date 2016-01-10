#!/bin/bash
echo ""
echo "### Systemd 7.4. Creating Custom Symlinks to Devices (chrooted to lfs partition as 'root')"
echo "### ====================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.4
LFS_SOURCE_FILE_PREFIX=custom-symlinks-to-devs
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 


########## Begin LFS Chapter Content ##########

echo "*** 7.4.1. Dealing with duplicate devices"

echo ""
echo "*** For a basic VM with one NIC and CD-ROM, the contents of this"
echo "*** chapter should be unnecessary.  " 
echo
echo "*** See book for dealing with duplicate devices if this is an issue."
echo

########## Chapter Clean-Up ##########
echo ""
echo "*** Start /etc/udev/rules.d/70-persistent-net.rules"
cat  /etc/udev/rules.d/70-persistent-net.rules | tee $LFS_LOG_FILE-persistent-net-rules.log
echo "*** End /etc/udev/rules.d/70-persistent-net.rules"


echo "################################ STOP ##############################"
echo "*** Stop & validate network configs in lfs-include.sh & 7.5 script."
echo "--> ./lfs-7.5-chroot.sh"
echo ""

#!/bin/bash
echo ""
echo "### 7.4. Managing Devices (chrooted to lfs partition as 'root')"
echo "### ====================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.4
LFS_SOURCE_FILE_PREFIX=ManagingDev
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root


########## Begin LFS Chapter Content ##########

echo ""
echo "*** For a basic VM with one NIC and CD-ROM, the contents of this"
echo "*** chapter should be unnecessary.  " 

echo "*** 7.4.1. Network Devices"
echo "*** 7.4.1.2. Creating Custom Udev Rules"

bash /lib/udev/init-net-rules.sh


echo "*** 7.4.2. CD-ROM symlinks"

echo "*** 7.4.3. Dealing with duplicate devices"

########## Chapter Clean-Up ##########

cat /etc/udev/rules.d/70-persistent-net.rules > $LFS_LOG_FILE-persistent-net-rules.log

echo "################################ STOP ##############################"
echo "*** Stop & validate network configs in lfs-include.sh & 7.5 script."
echo "--> ./lfs-7.5-chroot.sh"
echo ""
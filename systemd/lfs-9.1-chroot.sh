#!/bin/bash
echo ""
echo "### 9.1 The End (0.0 SBU - chrooted to lfs partition as 'root')"
echo "### ======================================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.5
LFS_SOURCE_FILE_PREFIX=networkconfig
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

########## Begin LFS Chapter Content ##########

echo "*** Create an /etc/os-release file required by systemd: "

cat > /etc/os-release << EOF
NAME=$LFS_DISTRIB_ID
VERSION=$LFS_DISTRIB_RELEASE
ID=lfs
PRETTY_NAME=$LFS_DISTRIB_DESCRIPTION
EOF

echo $LFS_DISTRIB_RELEASE > /etc/lfs-release

cat > /etc/lsb-release << EOF
DISTRIB_ID=$LFS_DISTRIB_ID
DISTRIB_RELEASE=$LFS_DISTRIB_RELEASE
DISTRIB_CODENAME=$LFS_DISTRIB_CODENAME
DISTRIB_DESCRIPTION=$LFS_DISTRIB_DESCRIPTION
EOF

########## Chapter Clean-Up ##########


cat /etc/os-release > $LFS_LOG_FILE-os-release
cat /etc/lfs-release > $LFS_LOG_FILE-lfs-release
cat /etc/lsb-release > $LFS_LOG_FILE-lsb-release

### There is no need to show errors as nothing is being written to build-logs.
#show_build_errors ""
capture_file_list "" 
chapter_footer
echo "*** Time to log out of the chroot environment and boot into the LFS instance."
echo "--> logout"
echo "--> update-grub"
echo "--> ./lfs-9.3-reboot.sh"
echo ""


#if [ $LFS_ERROR_COUNT -ne 0 ]; then
#	exit 4
#else
	exit
#fi

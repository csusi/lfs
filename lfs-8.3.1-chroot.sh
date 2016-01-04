#!/bin/bash
echo ""
echo "### 8.3 Linux-4.20 Part 1 (3-49 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=8.3
LFS_SOURCE_FILE_PREFIX=linux
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

########## Extract Source and Change Directory ##########

cd /sources
test_only_one_tarball_exists
extract_tarball ""
cd $(ls -d /sources/$LFS_SOURCE_FILE_PREFIX*/)

########## Begin LFS Chapter Content ##########

echo "*** 8.3.1. Installation of the kernel"

### Clean the kernel tree
make mrproper $LFS_MAKE_FLAGS \
  &> $LFS_LOG_FILE-make-mrproper.log


echo "*** Stop here."
echo "*** "
echo "*** It is time to configure the kernel.  Read the section on kernel "
echo "*** configuration in the readme file. "
echo "*** "
echo "*** --> pushd /sources/linux*"
echo "*** --> make defconfig "
echo "*** --> make menuconfig "
echo "*** Make Linux Kernel configuration changes here as needed/desired."
echo "***"
echo "*** When complete, run: "
echo "***--> popd ; ./lfs-8.3.2-chroot.sh "
echo ""


#!/bin/bash
echo ""
echo "### 7.2. LFS-Bootscripts-20140815 (0.3 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.2
LFS_SOURCE_FILE_PREFIX=lfs-bootscripts
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
### TODO: Some kind of check that user is in chrooted to $LFS_MOUNT_DIR
check_user root

########## Extract Source and Change Directory ##########

cd /sources
test_only_one_tarball_exists
extract_tarball ""
cd $(ls -d /sources/$LFS_SOURCE_FILE_PREFIX*/)

########## Begin LFS Chapter Content ##########

echo "*** Running Pre-Configuration Tasks ... $LFS_SOURCE_FILE_NAME"
### None

echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
### None

echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
### None

echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
make install $LFS_MAKE_FLAGS 																		&> $LFS_LOG_FILE-make-install.log

echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
### None

########## Chapter Clean-Up ##########

echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

show_build_errors ""
capture_file_list "" 
chapter_footer
echo "--> ./lfs-7.4-chroot.sh"
echo ""


if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

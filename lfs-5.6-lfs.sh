#!/bin/bash
echo ""
echo "### 5.6. Linux-4.4.1 API Headers (0.1 SBU - running as 'lfs') ###"
echo "### ============================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=5.6
LFS_SOURCE_FILE_PREFIX=linux
LFS_LOG_FILE=$LFS_MOUNT_DIR/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user lfs
check_lfs_partition_mounted_and_swap_on

########## Extract Source and Change Directory ##########

cd $LFS_MOUNT_DIR/sources
test_only_one_tarball_exists
extract_tarball $LFS_MOUNT_DIR
cd $(ls -d  $LFS_MOUNT_DIR/sources/$LFS_SOURCE_FILE_PREFIX*/)

########## Begin LFS Chapter Content ##########

time {
	echo "*** Running Pre-Configuration Tasks ... $LFS_SOURCE_FILE_NAME"
	### None
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	### None
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make mrproper $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-1-make-mrproper.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make INSTALL_HDR_PATH=dest headers_install $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-2-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	cp -rv dest/include/* /tools/include \
	  &> $LFS_LOG_FILE-3-cp-devinclude.log
}

########## Chapter Clean-Up ##########
	  
echo ""
echo "*** Cleaning Up ... $LFS_SOURCE_FILE_NAME"
cd $LFS_MOUNT_DIR/sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  $LFS_MOUNT_DIR/sources/$LFS_SOURCE_FILE_PREFIX*/)

show_build_errors $LFS_MOUNT_DIR
capture_file_list $LFS_MOUNT_DIR
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

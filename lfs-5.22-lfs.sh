#!/bin/bash
echo ""
echo "### 5.22. Gawk-4.1.3 (0.2 SBU - running as 'lfs')"
echo "### ================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=5.22
LFS_SOURCE_FILE_PREFIX=gawk
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
	./configure --prefix=/tools \
	  &> $LFS_LOG_FILE-1-configure.log

	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-2-make.log

#	### Note: Per book, 'make check' is not mandatory.  Because it throws
#	### 'error' messages into the log that do not appear to be critical, 
#	### this is going to be commented out.  
#	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
#	make check $LFS_MAKE_FLAGS  \
#	  &> $LFS_LOG_FILE-make-check.log

	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS  \
	  &> $LFS_LOG_FILE-3-make-install.log

	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	### None
}

########## Chapter Clean-Up ##########

echo ""
echo "*** Cleaning Up ... $LFS_SOURCE_FILE_NAME"
cd $LFS_MOUNT_DIR/sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  $LFS_MOUNT_DIR/sources/$LFS_SOURCE_FILE_PREFIX*/)

echo ""
show_build_errors $LFS_MOUNT_DIR
capture_file_list $LFS_MOUNT_DIR

chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

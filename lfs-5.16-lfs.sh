#!/bin/bash
echo ""
echo "### 5.16. Bash-4.3.30  (0.4 SBU - running as 'lfs')"
echo "### ================================================"
echo "*** The word 'error' may show up in the logs as part of a warning"
echo "*** message.  They are not critical."

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=5.16
LFS_SOURCE_FILE_PREFIX=bash
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
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
	./configure --prefix=/tools --without-bash-malloc \
		&> $LFS_LOG_FILE-configure.log
			
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Test ... $LFS_SOURCE_FILE_NAME"
	make tests $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-tests.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS  \
	  &> $LFS_LOG_FILE-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	ln -sv bash /tools/bin/sh
}

########## Chapter Clean-Up ##########
	
echo ""
echo "*** Cleaning Up ... $LFS_SOURCE_FILE_NAME"
cd $LFS_MOUNT_DIR/sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  $LFS_MOUNT_DIR/sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo ""
echo "*** Note: Includes word error in four warning messages.  Appears to be harmless."
show_build_errors $LFS_MOUNT_DIR
capture_file_list $LFS_MOUNT_DIR

chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

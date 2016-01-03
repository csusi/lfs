#!/bin/bash
echo ""
echo "### 5.12. Expect-5.45 (0.1 SBU - running as 'lfs')"
echo "### ================================================"
echo "### Per book: test suite failures here are not surprising and are not "
echo "### considered critical. "

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=5.12
LFS_SOURCE_FILE_PREFIX=expect
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
	cp -v configure{,.orig}
	sed 's:/usr/local/bin:/bin:' configure.orig > configure
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	./configure --prefix=/tools \
	  --with-tcl=/tools/lib \
	  --with-tclinclude=/tools/include \
		&> $LFS_LOG_FILE-configure.log
			
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make.log
		
	echo "*** Running Make Test ... $LFS_SOURCE_FILE_NAME"
	make test $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-test.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make SCRIPTS="" install $LFS_MAKE_FLAGS   \
	  &> $LFS_LOG_FILE-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	### None
}

########## Chapter Clean-Up ##########

echo ""
echo "*** Cleaning Up ... $LFS_SOURCE_FILE_NAME"
cd $LFS_MOUNT_DIR/sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  $LFS_MOUNT_DIR/sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo ""
show_build_errors $LFS_MOUNT_DIR
capture_file_list $LFS_MOUNT_DIR

chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

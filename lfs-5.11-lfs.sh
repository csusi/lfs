#!/bin/bash
echo ""
echo "### 5.11. Tcl-core-8.6.4 (0.5 SBU - running as 'lfs')"
echo "### ================================================"
echo "### This seems to take a while to build.  I don't know why.  It just does."
echo "### Returns 13 errors, but it looks like they are mostly due to missing"
echo "### database shared libraries.  Per book:  Test suite failures here are "
echo "### not surprising, and are not considered critical. "

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=5.11
LFS_SOURCE_FILE_PREFIX=tcl
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
	### Clean-up from previous chapter
	rm  ../dummy.c ../a.out
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	cd unix
	./configure --prefix=/tools \
		&> $LFS_LOG_FILE-1-configure.log
		
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-2-make.log
		
	echo "*** Running Make Test ... $LFS_SOURCE_FILE_NAME"
	TZ=UTC make test $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-3-make-test.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS    \
	  &> $LFS_LOG_FILE-4-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	chmod -v u+w /tools/lib/libtcl8.6.so \
	  &> $LFS_LOG_FILE-5-postmake-chmod.log
	  
	make install-private-headers \
	  &> $LFS_LOG_FILE-6-postmake-make-install-private-headers.log
	  
	ln -sv tclsh8.6 /tools/bin/tclsh \
	  &> $LFS_LOG_FILE-7-postmake-symlink.log
	
}

########## Chapter Clean-Up ##########

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

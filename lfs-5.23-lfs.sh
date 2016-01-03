#!/bin/bash
echo ""
echo "### 5.23. Gettext-0.19.5.1 (0.9 SBU - running as 'lfs')"
echo "### ================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=5.23
LFS_SOURCE_FILE_PREFIX=gettext
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
	cd gettext-tools
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	EMACS="no" ./configure --prefix=/tools --disable-shared \
	  &> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make -C gnulib-lib $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-gnulib-lib.log
	
	make -C intl pluralx.c \
	  &> $LFS_LOG_FILE-make-pluralx.log
	  
	make -C src msgfmt $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-src-msgfmt.log
	  
	make -C src msgmerge $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-src-msgmerge.log
	  
	make -C src xgettext $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-src-xgettext.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	### None
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	### None 
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
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

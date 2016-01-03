#!/bin/bash
echo ""
echo "### 5.9. Binutils-2.25.1 (1.1 SBU  - running as 'lfs')"
echo "### ================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=5.9
LFS_SOURCE_FILE_PREFIX=binutils
LFS_BUILD_DIRECTORY=binutils-build    # Leave empty if not needed
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
	
	echo "*** Runing Pre-Configuration Tasks ... $LFS_SOURCE_FILE_NAME"
	mkdir ../$LFS_BUILD_DIRECTORY
	cd ../$LFS_BUILD_DIRECTORY
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	CC=$LFS_TGT-gcc                \
	AR=$LFS_TGT-ar                 \
	RANLIB=$LFS_TGT-ranlib         \
	../binutils-2.25.1/configure     \
		--prefix=/tools            \
		--disable-nls              \
		--disable-werror           \
		--with-lib-path=/tools/lib \
		--with-sysroot 				\
		&> $LFS_LOG_FILE-configure.log
		
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS    \
	  &> $LFS_LOG_FILE-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	make -C ld clean   \
	  &> $LFS_LOG_FILE-make-ld-clean.log
	  
	make -C ld LIB_PATH=/usr/lib:/lib   \
	  &> $LFS_LOG_FILE-make-ld-lib.log
	  
	cp -v ld/ld-new /tools/bin  \
	  &> $LFS_LOG_FILE-post-make-copy.log
}

########## Chapter Clean-Up ##########
	
echo "*** Cleaning Up ... $LFS_SOURCE_FILE_NAME"
cd $LFS_MOUNT_DIR/sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  $LFS_MOUNT_DIR/sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

show_build_errors $LFS_MOUNT_DIR
capture_file_list $LFS_MOUNT_DIR
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

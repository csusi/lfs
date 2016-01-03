#!/bin/bash
echo ""
echo "### 6.13. Binutils-2.25.1 (2.3 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.13
LFS_SOURCE_FILE_PREFIX=binutils
LFS_BUILD_DIRECTORY=binutils-build    # Leave empty if not needed
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

time {
	
	echo "*** Running Pre-Configuration Tasks ... $LFS_SOURCE_FILE_NAME"
	
	### expect -c 'spawn ls'
	### This was a little bit maddening to get working.  The output of "expect -c 'spawn ls'" was returning a hidden ^M at the end of 
	### the string that wasn't showing using an 'echo', but causing the string compare below to fail.  This is why it is
	### piped through "cat -v | tr -d '^M'" to trim it off.  
	if [ "$( expect -c 'spawn ls' | cat -v | tr -d '^M')" = "spawn ls"  ] ; then
		echo "*** The command 'expect -c 'spawn ls'' succeeded."
	else
		echo "*** Fatal Error - The command 'expect -c 'spawn ls'' failed."
		exit 12
	fi
	
	
	mkdir ../$LFS_BUILD_DIRECTORY
	cd ../$LFS_BUILD_DIRECTORY
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	../binutils-2.25.1/configure --prefix=/usr   	\
         --enable-shared 							\
         --disable-werror 							\
		 &> $LFS_LOG_FILE-configure.log
		
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make tooldir=/usr $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	make -k check $LFS_MAKE_FLAGS  \
	  &> $LFS_LOG_FILE-check.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make tooldir=/usr install $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	### None
}

########## Chapter Clean-Up ##########

echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY



show_build_errors ""
capture_file_list "" 
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi




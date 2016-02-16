#!/bin/bash
echo ""
echo "### 6.14. GMP-6.1.0 (1.3 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.14
LFS_SOURCE_FILE_PREFIX=gmp
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
	### None
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	### NOTE FROM BOOK
	### If you are building for 32-bit x86, but you have a CPU which is capable of running 64-bit code  andyou
	### have specified CFLAGS in the environment, the configure script will attempt to configure for 64-bits and fail.
	### Avoid this by invoking the configure command below with 
	# ABI=32 ./configure ...
	### I do not believe this affects how my builds as I am building the target LFS with the same architecture as the OS
	### Removing this, but if I do a subsequent 32-bit build this may be a problem.
	./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.0 \
	   &> $LFS_LOG_FILE-1-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-2-make.log
	
	echo "*** Running Make HTML ... $LFS_SOURCE_FILE_NAME"
	make html $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-3-make-html.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	make check $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-4-make-check.log
	
	echo "*** TODO: Make this an if-then-exit statement"
	echo "*** Ensure that all 190 tests in the test suite passed."
	awk '/# PASS:/{total+=$3} ; END{print total}'  $LFS_LOG_FILE-4-make-check.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-5-make-install.log
	
	echo "*** Running Make Install-HTML ... $LFS_SOURCE_FILE_NAME"
	make install-html $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-6-make-install-html.log
	  
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	### None
}

########## Chapter Clean-Up ##########

echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)

show_build_errors ""
capture_file_list "" 
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi




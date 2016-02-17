#!/bin/bash
echo ""
echo "### 6.54. GRUB-2.02~beta2  (0.8 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.54
LFS_SOURCE_FILE_PREFIX=grub
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
	### Below depricated in 7.9
	### sed -i -e '/gets is a/d' grub-core/gnulib/stdio.in.h
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	./configure --prefix=/usr          \
      --sbindir=/sbin        \
      --sysconfdir=/etc      \
      --disable-grub-emu-usb \
      --disable-efiemu       \
      --disable-werror       \
       	&> $LFS_LOG_FILE-1-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS 	\
	  &> $LFS_LOG_FILE-2-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	### None 
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS 	\
	  &> $LFS_LOG_FILE-3-make-install.log
	
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




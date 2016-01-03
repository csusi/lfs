#!/bin/bash
echo ""
echo "### 6.7. Linux-4.2 API Headers (0.1 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.7
LFS_SOURCE_FILE_PREFIX=linux
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
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
	### Moved from the previous section
	touch /var/log/{btmp,lastlog,wtmp}
	chgrp -v utmp /var/log/lastlog
	chmod -v 664 /var/log/lastlog
	chmod -v 600 /var/log/btmp
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	### None
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make mrproper $LFS_MAKE_FLAGS 											\
	  &> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make INSTALL_HDR_PATH=dest headers_install $LFS_MAKE_FLAGS 				\
	  &> $LFS_LOG_FILE-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	find dest/include \( -name .install -o -name ..install.cmd \) -delete 	\
	  &> $LFS_LOG_FILE-find.log
	  
	cp -rv dest/include/* /usr/include 										\
	  &> $LFS_LOG_FILE-cp.log

} 

########## Chapter Clean-Up ##########

echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo ""
show_build_errors ""
capture_file_list "" 
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi



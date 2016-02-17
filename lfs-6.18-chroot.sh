#!/bin/bash
echo ""
echo "### 6.18. Bzip2-1.0.6 (0.1 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.18
LFS_SOURCE_FILE_PREFIX=bzip
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
	
	patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch \
	  &> $LFS_LOG_FILE-1-patch.log
	
	sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
	
	sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
	
	make -f Makefile-libbz2_so \
	  &> $LFS_LOG_FILE-2-make-makefile-libbz2.log
	make clean \
	  &> $LFS_LOG_FILE-3-make-clean.log
	
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	### None
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-4-make.log
	
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make PREFIX=/usr install $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-5-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	
	cp -v bzip2-shared /bin/bzip2                      &>> $LFS_LOG_FILE-6-post-make.log
	cp -av libbz2.so* /lib                             &>> $LFS_LOG_FILE-6-post-make.log
	ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so  &>> $LFS_LOG_FILE-6-post-make.log
	rm -v /usr/bin/{bunzip2,bzcat,bzip2}               &>> $LFS_LOG_FILE-6-post-make.log
	ln -sv bzip2 /bin/bunzip2                          &>> $LFS_LOG_FILE-6-post-make.log
	ln -sv bzip2 /bin/bzcat                            &>> $LFS_LOG_FILE-6-post-make.log
}

########## Chapter Clean-Up ##########

echo""
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






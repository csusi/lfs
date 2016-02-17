#!/bin/bash
echo ""
echo "### 6.53. Xz-5.2.2 (0.3 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.53
LFS_SOURCE_FILE_PREFIX=xz
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
	sed -e '/mf\.buffer = NULL/a next->coder->mf.size = 0;' -i src/liblzma/lz/lz_encoder.c
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	./configure --prefix=/usr    		\
      --disable-static 					\
      --docdir=/usr/share/doc/xz-5.2.2 	\
      &> $LFS_LOG_FILE-1-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS 	\
	  &> $LFS_LOG_FILE-2-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	make check $LFS_MAKE_FLAGS  \
	  &> $LFS_LOG_FILE-3-make-check.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS 	\
	  &> $LFS_LOG_FILE-4-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
	mv -v /usr/lib/liblzma.so.* /lib
	ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
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




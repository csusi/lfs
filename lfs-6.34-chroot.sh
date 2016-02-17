#!/bin/bash
echo ""
echo "### 6.34. Readline-6.3 (0.1 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.34
LFS_SOURCE_FILE_PREFIX=readline
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
	
	patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch	  &> $LFS_LOG_FILE-1-patch.log
	
	sed -i '/MV.*old/d' Makefile.in
	sed -i '/{OLDSUFF}/c:' support/shlib-install
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/readline-6.3 \
	  &> $LFS_LOG_FILE-2-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make SHLIB_LIBS=-lncurses $LFS_MAKE_FLAGS         \
	  &> $LFS_LOG_FILE-3-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	### None
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make SHLIB_LIBS=-lncurses install $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-4-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	
	mv -v /usr/lib/lib{readline,history}.so.* /lib	\
	  &> $LFS_LOG_FILE-5-post-make.log
	ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so  \
	  &>> $LFS_LOG_FILE-5-post-make.log
	ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so   \
	  &>> $LFS_LOG_FILE-5-post-make.log
	
	install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-6.3  \
	  &>> $LFS_LOG_FILE-5-post-make.log
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




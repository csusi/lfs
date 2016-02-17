#!/bin/bash
echo ""
echo "### 6.58. Kbd-2.0.3 (0.2 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.58
LFS_SOURCE_FILE_PREFIX=kbd
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
	
	patch -Np1 -i ../kbd-2.0.3-backspace-1.patch		\
	  &> $LFS_LOG_FILE-1-patch.log
	
	sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
	sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	PKG_CONFIG_PATH=/tools/lib/pkgconfig	\
	./configure 							\
		--prefix=/usr 						\
		--disable-vlock 					\
		&> $LFS_LOG_FILE-2-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS 					\
	  &> $LFS_LOG_FILE-3-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	make check $LFS_MAKE_FLAGS 				\
	  &> $LFS_LOG_FILE-4-make-check.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS 			\
	  &> $LFS_LOG_FILE-5-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	mkdir -v       /usr/share/doc/kbd-2.0.3
	cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.3    \
	  &> $LFS_LOG_FILE-6-copydocs.log
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




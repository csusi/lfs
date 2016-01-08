#!/bin/bash
echo "### 6.22. Acl-2.2.52 (0.1 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="
echo ""

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.22
LFS_SOURCE_FILE_PREFIX=acl
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
	sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
	
	sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
	

	sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
    libacl/__acl_to_any_text.c
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	./configure --prefix=/usr    \
            --disable-static \
            --libexecdir=/usr/lib \
	  &> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	### None 
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install install-dev install-lib $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	chmod -v 755 /usr/lib/libacl.so     &>> $LFS_LOG_FILE-post-make.log
	 
	mv -v /usr/lib/libacl.so.* /lib     &>> $LFS_LOG_FILE-post-make.log
	ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so  \
	  &>> $LFS_LOG_FILE-post-make.log
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




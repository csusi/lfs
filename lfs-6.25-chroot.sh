#!/bin/bash
echo ""
echo "### 6.25. Shadow-4.2.1 (0.2 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="
echo ""

### TODO: I Would like to read more about this 

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.25
LFS_SOURCE_FILE_PREFIX=shadow
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
	
	sed -i 's/groups$(EXEEXT) //' src/Makefile.in
	
	find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
	
	sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
	       -e 's@/var/spool/mail@/var/mail@' etc/login.defs
	
	### TODO Not using Cracklib right now, so not making change for Cracklib Support
	
	sed -i 's/1000/999/' etc/useradd
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	./configure --sysconfdir=/etc --with-group-name-max-length=32 \
	  &> $LFS_LOG_FILE-1-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-2-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	### None
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-3-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	
	mv -v /usr/bin/passwd /bin
	
	pwconv
	
	grpconv
	
	### Different from the book, chpasswd used for bach passwd changes
	### passwd root 
	echo "root:$LFS_ROOT_PASSWORD" | chpasswd

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




#!/bin/bash
echo ""
echo "### (BLFS) Git-2.5.0 (10.2 SBU .7 + 9.6 with -j4)"
echo "### ========================================================="

### http://linuxfromscratch.org/blfs/view/stable/general/git.html

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=9.4.19
LFS_SOURCE_FILE_PREFIX=git
LFS_BUILD_DIRECTORY=    
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX
echo "BLFS $LFS_SOURCE_FILE_PREFIX started on $(date -u)" >> /build-logs/0-milestones.log

# Ideally, will retrieve and md5 check in script but doing that
# For initial packages as root on host OS
# BLFS_SOURCE_FTP_FQDN=openssl.org
# BLFS_SOURCE_FTP_PATH=source
BLFS_SOURCE_FILE_NAME="$(grep -o "MD5=$LFS_SOURCE_FILE_PREFIX.*=[a-z0-9]*" ./blfs-wget-list | cut -d= -f2)"
BLFS_SOURCE_MD5="$(grep -o "MD5=$LFS_SOURCE_FILE_PREFIX.*=[a-z0-9]*" ./blfs-wget-list | cut -d= -f3)"

echo "*** BLFS_SOURCE_FILE_NAME=$BLFS_SOURCE_FILE_NAME"
echo "*** BLFS_SOURCE_MD5=$BLFS_SOURCE_MD5"

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

echo "*** Testing if program exists (It shouldn't)" 
git  --version


########## Extract Source and Change Directory ##########

cd /sources
test_only_one_tarball_exists
extract_tarball ""
cd $(ls -d /sources/$LFS_SOURCE_FILE_PREFIX*/)

########## Begin LFS Chapter Content ##########

time {
	echo "*** Running Pre-Configuration Tasks ... $BLFS_SOURCE_FTP_FILE"
	### None
	
	echo "*** Running Configure ... $BLFS_SOURCE_FTP_FILE"
	./configure --prefix=/usr --with-gitconfig=/etc/gitconfig 		&> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $BLFS_SOURCE_FTP_FILE"
	make $LFS_MAKE_FLAGS           			&> $LFS_LOG_FILE-make.log
	
	### TODO make html & make man
	
	echo "*** Running Make Test ... $BLFS_SOURCE_FTP_FILE"
	make $LFS_MAKE_FLAGS test     			&> $LFS_LOG_FILE-make-test.log

	echo "*** Running Make Install ... $BLFS_SOURCE_FTP_FILE"
	make $LFS_MAKE_FLAGS install		&> $LFS_LOG_FILE-make-install.log
	

	echo "*** Performing Post-Make Tasks ... $BLFS_SOURCE_FTP_FILE"
	### TODO: Add AsciiDoc, XMLTo packages before this to compile manpages
	### TODO: make install-man
	### TODO: make htmldir=/usr/share/doc/git-2.5.0 install-html
	### TODO: Everything after that last command
}


########## Chapter Clean-Up ##########

echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo "BLFS $LFS_SOURCE_FILE_PREFIX finished on $(date -u)" >> /build-logs/0-milestones.log


echo "*** Testing if program exists (It should)" 
git  --version

echo ""
show_build_errors ""
capture_file_list "" 
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

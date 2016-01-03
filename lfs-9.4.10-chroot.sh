#!/bin/bash
echo ""
echo "### 9.4.10 (BLFS) cURL-7.44.0 (9.6 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

### http://linuxfromscratch.org/blfs/view/stable/basicnet/curl.html

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=9.4.10
LFS_SOURCE_FILE_PREFIX=curl
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

########## Extract Source and Change Directory ##########

cd /sources
test_only_one_tarball_exists
check_MD5_sums
extract_tarball ""
cd $(ls -d /sources/$LFS_SOURCE_FILE_PREFIX*/)

########## Begin LFS Chapter Content ##########

time {
	echo "*** Running Pre-Configuration Tasks ... $BLFS_SOURCE_FTP_FILE"
	### None
	
	echo "*** Running Configure ... $BLFS_SOURCE_FTP_FILE"
	./configure --prefix=/usr              \
            --disable-static           \
            --enable-threaded-resolver     			&> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $BLFS_SOURCE_FTP_FILE"
	make $LFS_MAKE_FLAGS           			&> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Test ... $BLFS_SOURCE_FTP_FILE"
	make $LFS_MAKE_FLAGS test     			&> $LFS_LOG_FILE-make-test.log

	echo "*** Running Make Install ... $BLFS_SOURCE_FTP_FILE"
	make $LFS_MAKE_FLAGS install		&> $LFS_LOG_FILE-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $BLFS_SOURCE_FTP_FILE"
	find docs \( -name Makefile\* \
          -o -name \*.1       \
          -o -name \*.3 \)    \
          -exec rm {} \;      							&> $LFS_LOG_FILE-find-and-rm.log
          
	install -v -d -m755 /usr/share/doc/curl-7.44.0  	&> $LFS_LOG_FILE-install.log 
	
	cp -v -R docs/*     /usr/share/doc/curl-7.44.0		&> $LFS_LOG_FILE-make-copydocs.log		

}

########## Chapter Clean-Up ##########

echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo "BLFS $LFS_SOURCE_FILE_PREFIX finished on $(date -u)" >> /build-logs/0-milestones.log
echo ""  >> /build-logs/0-milestones.log

show_build_errors ""
capture_file_list "" 
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

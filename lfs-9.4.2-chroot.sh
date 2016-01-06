#!/bin/bash
echo ""
echo "### (BLFS) OpenSSL-1.0.2 (1.3 SBU - chrooted to lfs partition as 'root')"
echo "### ===================================================================="

### http://www.linuxfromscratch.org/blfs/view/stable/postlfs/openssl.html

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=9.4.2
LFS_SOURCE_FILE_PREFIX=openssl
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

########### Extract Source and Change Directory ##########

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
	./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic 	         			&> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $BLFS_SOURCE_FTP_FILE"
	make $LFS_MAKE_FLAGS           			&> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Test ... $BLFS_SOURCE_FTP_FILE"
	make -j1 test     			&> $LFS_LOG_FILE-make-test.log
	
	#echo "*** Running Make Install ... $BLFS_SOURCE_FTP_FILE"
	#None 
	
	echo "*** Performing Post-Make Tasks ... $BLFS_SOURCE_FTP_FILE"
	make MANDIR=/usr/share/man MANSUFFIX=ssl install 	&> $LFS_LOG_FILE-make-install.log
	install -dv -m755 /usr/share/doc/openssl-1.0.2  	&> $LFS_LOG_FILE-install.log
	cp -vfr doc/*     /usr/share/doc/openssl-1.0.2		&> $LFS_LOG_FILE-make-copydocs.log
	
}

########## Chapter Clean-Up ##########

echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo "BLFS $LFS_SOURCE_FILE_PREFIX finished on $(date -u)" >> /build-logs/0-milestones.log


### TODO: Would like to do this for the other installations in another pass.
echo "*** Looking for selected installed programs and libraries" &> $LFS_LOG_FILE-installedfilelist.log
echo "*** Program openssl"							&>> $LFS_LOG_FILE-installedfilelist.log
find / -name 'openssl'								&>> $LFS_LOG_FILE-installedfilelist.log
echo "*** Program c_rehash"							&>> $LFS_LOG_FILE-installedfilelist.log
find / -name 'c_rehash'								&>> $LFS_LOG_FILE-installedfilelist.log
echo "*** Library libcrypto.{so,a}"					&>> $LFS_LOG_FILE-installedfilelist.log
find / -name 'libcrypto.so'							&>> $LFS_LOG_FILE-installedfilelist.log
find / -name 'libcrypto.a'							&>> $LFS_LOG_FILE-installedfilelist.log
echo "*** Library  libssl.{so,a}"					&>> $LFS_LOG_FILE-installedfilelist.log
find / -name 'libssl.so'							&>> $LFS_LOG_FILE-installedfilelist.log
find / -name 'libssl.a'								&>> $LFS_LOG_FILE-installedfilelist.log
echo "*** Directory /etc/ssl"						&>> $LFS_LOG_FILE-installedfilelist.log
find /etc/ssl 										&>> $LFS_LOG_FILE-installedfilelist.log
echo "*** Directory /usr/include/openssl"			&>> $LFS_LOG_FILE-installedfilelist.log
find /usr/include/openssl 							&>> $LFS_LOG_FILE-installedfilelist.log
echo "*** Directory /usr/lib/engines"				&>> $LFS_LOG_FILE-installedfilelist.log
find /usr/lib/engines 								&>> $LFS_LOG_FILE-installedfilelist.log
echo "*** Directory /usr/share/doc/openssl-1.0.2"	&>> $LFS_LOG_FILE-installedfilelist.log
find /usr/share/doc/openssl-1.0.2e					&>> $LFS_LOG_FILE-installedfilelist.log

echo ""
show_build_errors ""
capture_file_list "" 
chapter_footer

cd /tools/susi-linux/lfs-scripts

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi


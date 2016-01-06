#!/bin/bash
echo ""
echo "### (BLFS) Certificate Authority Certificates (0.1  SBU)"
echo "### ================================================"

### http://linuxfromscratch.org/blfs/view/stable/postlfs/cacerts.html


#if [ ! -f ./lfs-include.sh ];then
    #echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
#source ./lfs-include.sh

#LFS_SECTION=blfs-4
#LFS_SOURCE_FILE_PREFIX=openssl
#LFS_BUILD_DIRECTORY=    
#LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX
#echo "BLFS $LFS_SOURCE_FILE_PREFIX started on $(date -u)" >> /build-logs/0-milestones.log

## Ideally, will retrieve and md5 check in script but doing that
## For initial packages as root on host OS
## BLFS_SOURCE_FTP_FQDN=openssl.org
## BLFS_SOURCE_FTP_PATH=source
## BLFS_SOURCE_FTP_FILE=openssl-1.0.2.tar.gz
## BLFS_SOURCE_MD5=38373013fc85c790aabf8837969c5eba

#echo "*** Validating the environment."
#check_user root
#check_chroot_to_lfs_rootdir 

########### Extract Source and Change Directory ##########

#cd /sources
#test_only_one_tarball_exists
#extract_tarball ""
#cd $(ls -d /sources/$LFS_SOURCE_FILE_PREFIX*/)

########### Begin LFS Chapter Content ##########

#time {
	#echo "*** Running Pre-Configuration Tasks ... $BLFS_SOURCE_FTP_FILE"
	#### None
	
	#echo "*** Running Configure ... $BLFS_SOURCE_FTP_FILE"
	#./config --prefix=/usr         \
         #--openssldir=/etc/ssl \
         #--libdir=lib          \
         #shared                \
         #zlib-dynamic 	         			&> $LFS_LOG_FILE-configure.log
	
	#echo "*** Running Make ... $BLFS_SOURCE_FTP_FILE"
	#make $LFS_MAKE_FLAGS           			&> $LFS_LOG_FILE-make.log
	
	##echo "*** Running Make Check ... $BLFS_SOURCE_FTP_FILE"
	##None
	##
	##echo "*** Running Make Install ... $BLFS_SOURCE_FTP_FILE"
	##None 
	
	#echo "*** Performing Post-Make Tasks ... $BLFS_SOURCE_FTP_FILE"
	#make MANDIR=/usr/share/man MANSUFFIX=ssl install 	&> $LFS_LOG_FILE-make-install.log
	#install -dv -m755 /usr/share/doc/openssl-1.0.2  	&> $LFS_LOG_FILE-install.log
	#cp -vfr doc/*     /usr/share/doc/openssl-1.0.2		&> $LFS_LOG_FILE-make-copydocs.log
#}


########### Chapter Clean-Up ##########

#echo ""
#echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
#cd /sources
#[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)
#rm -rf $LFS_BUILD_DIRECTORY

#echo "BLFS $LFS_SOURCE_FILE_PREFIX finished on $(date -u)" >> /build-logs/0-milestones.log
#echo ""  >> /build-logs/0-milestones.log

#show_build_errors ""
#capture_file_list "" 
#chapter_footer

#if [ $LFS_ERROR_COUNT -ne 0 ]; then
	#exit 4
#else
	#exit
#fi

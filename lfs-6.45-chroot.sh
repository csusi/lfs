#!/bin/bash
echo ""
echo "### 6.45. Coreutils-8.25  (2.6 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="


if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.45
LFS_SOURCE_FILE_PREFIX=coreutils
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
	patch -Np1 -i ../coreutils-8.25-i18n-2.patch
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime \
	  &> $LFS_LOG_FILE-1-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	FORCE_UNSAFE_CONFIGURE=1 make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-2-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"


    echo "*** Running as 'root'"  
	make NON_ROOT_USERNAME=nobody check-root  \
	  &>> $LFS_LOG_FILE-3-make-check-as-root.log

	echo "dummy:x:1000:nobody" >> /etc/group

    echo "*** Changing Ownership"  
	chown -Rv nobody 

    echo "*** Running check as 'nobody'"  
	su nobody -s /bin/bash -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"  \
	  &>> $LFS_LOG_FILE-4-make-check-as-nobody.log

	sed -i '/dummy/d' /etc/group
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-5-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	
	mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin 	&> $LFS_LOG_FILE-6-post-make.log
	mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin			&>> $LFS_LOG_FILE-6-post-make.log
	###: Differs from the book a bit.  After moving 'mv' above, shell would no longer finds it and not work
	/bin/mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin			&>> $LFS_LOG_FILE-6-post-make.log
	/bin/mv -v /usr/bin/chroot /usr/sbin																	&>> $LFS_LOG_FILE-6-post-make.log
	/bin/mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8	&>> $LFS_LOG_FILE-6-post-make.log
	sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8				&>> $LFS_LOG_FILE-6-post-make.log
	
	/bin/mv -v /usr/bin/{head,sleep,nice,test,[} /bin 				&>> $LFS_LOG_FILE-6-post-make.log

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




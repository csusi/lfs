#!/bin/bash
echo ""
echo "### 6.20. Ncurses-6.0 (0.4 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="


if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.20
LFS_SOURCE_FILE_PREFIX=ncurses
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
	sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec          \
	  &> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS                \
	  &> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	### None
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS                           \
	  &> $LFS_LOG_FILE-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"  \
	  2>&1 | tee -a $LFS_LOG_FILE-post-make-tasks.log
	
	mv -v /usr/lib/libncursesw.so.6* /lib                  \
	  &>> $LFS_LOG_FILE-post-make-tasks.log 
	
	ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so \
	  &>> $LFS_LOG_FILE-post-make-tasks.log
	  
	
	for lib in ncurses form panel menu ; do
	  rm -vf                    /usr/lib/lib${lib}.so     		&>> $LFS_LOG_FILE-post-make-tasks.log                  
	  echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so  	  
	  ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc  &>> $LFS_LOG_FILE-post-make-tasks.log
	done
	
	ln -sfv libncurses++w.a /usr/lib/libncurses++.a       \
	  &>> $LFS_LOG_FILE-post-make-tasks.log
	
	rm -vf /usr/lib/libcursesw.so                         &>> $LFS_LOG_FILE-post-make-tasks.log                
	echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
	ln -sfv libncurses.so      /usr/lib/libcurses.so

	
	echo "*** Installing Ncurses Documentation"				    2>&1 | tee -a $LFS_LOG_FILE-post-make-tasks.log
	mkdir -v       /usr/share/doc/ncurses-6.0             &>> $LFS_LOG_FILE-post-make-tasks.log 
	cp -v -R doc/* /usr/share/doc/ncurses-6.0             &>> $LFS_LOG_FILE-post-make-tasks.log          

}	

########## Chapter Clean-Up ##########

echo""
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




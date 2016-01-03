#!/bin/bash
echo ""
echo "### 6.67. Eudev-3.1.2  (0.3 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.67
LFS_SOURCE_FILE_PREFIX=eudev
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
	
	sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
	
	cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	./configure --prefix=/usr           \
            --bindir=/sbin          \
            --sbindir=/sbin         \
            --libdir=/usr/lib       \
            --sysconfdir=/etc       \
            --libexecdir=/lib       \
            --with-rootprefix=      \
            --with-rootlibdir=/lib  \
            --enable-split-usr      \
            --enable-manpages       \
            --enable-hwdb           \
            --disable-introspection \
            --disable-gudev         \
            --disable-static        \
            --config-cache          \
            --disable-gtk-doc-html  \
	  &> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	LIBRARY_PATH=/tools/lib make $LFS_MAKE_FLAGS 											&> $LFS_LOG_FILE-make.log
	  
	mkdir -pv /lib/udev/rules.d
	mkdir -pv /etc/udev/rules.d
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	make LD_LIBRARY_PATH=/tools/lib check $LFS_MAKE_FLAGS 						&> $LFS_LOG_FILE-make-check.log

	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"	
	make LD_LIBRARY_PATH=/tools/lib install 													&> $LFS_LOG_FILE-make-install.log
	  
	  
	tar -xvf ../udev-lfs-20140408.tar.bz2															&> $LFS_LOG_FILE-mv-tar.log
	make -f udev-lfs-20140408/Makefile.lfs install $LFS_MAKE_FLAGS 		&> $LFS_LOG_FILE-make-install-customrules.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	
	LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update									&> $LFS_LOG_FILE-udevadm.log
}

########## Chapter Clean-Up ##########

echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/eudev-*/)
rm -rf $LFS_BUILD_DIRECTORY


show_build_errors ""
capture_file_list "" 
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi




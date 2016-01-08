#!/bin/bash
echo ""
echo "### 6.63. Systemd-224  (5.3 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.63
LFS_SOURCE_FILE_PREFIX=systemd
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
	### create a file to allow systemd to build when using Util-Linux built in Chapter 5 and disable LTO by default
	cat > config.cache << "EOF"
KILL=/bin/kill
MOUNT_PATH=/bin/mount
UMOUNT_PATH=/bin/umount
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include/blkid"
HAVE_LIBMOUNT=1
MOUNT_LIBS="-lmount"
MOUNT_CFLAGS="-I/tools/include/libmount"
cc_cv_CFLAGS__flto=no
EOF

	### Fix Build Error
	sed -i "s:blkid/::" $(grep -rl "blkid/blkid.h")
	
	### Apply Patch
	patch -Np1 -i ../systemd-224-compat-3.patch           &> $LFS_LOG_FILE-patch.log
	
	### Disable Tests
	sed -e 's:test/udev-test.pl ::g'  \
    -e 's:test-copy$(EXEEXT) ::g' \
    -i Makefile.in
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	./configure --prefix=/usr                                           \
            --sysconfdir=/etc                                       \
            --localstatedir=/var                                    \
            --config-cache                                          \
            --with-rootprefix=                                      \
            --with-rootlibdir=/lib                                  \
            --enable-split-usr                                      \
            --disable-firstboot                                     \
            --disable-ldconfig                                      \
            --disable-sysusers                                      \
            --without-python                                        \
            --docdir=/usr/share/doc/systemd-224                     \
            --with-dbuspolicydir=/etc/dbus-1/system.d               \
            --with-dbussessionservicedir=/usr/share/dbus-1/services \
            --with-dbussystemservicedir=/usr/share/dbus-1/system-services      &> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make  LIBRARY_PATH=/tools/lib$LFS_MAKE_FLAGS 												&> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	### None
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make LD_LIBRARY_PATH=/tools/lib install $LFS_MAKE_FLAGS 										&> $LFS_LOG_FILE-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	
	### Move NSS Libraries
	mv -v /usr/lib/libnss_{myhostname,mymachines,resolve}.so.2 /lib

	### Remove unnecessary dir
	rm -rfv /usr/lib/rpm

	### Create sysvinit compatibility links
	for tool in runlevel reboot shutdown poweroff halt telinit; do
     ln -sfv ../bin/systemctl /sbin/${tool}
	done
	ln -sfv ../lib/systemd/systemd /sbin/init
	
	### Remove reference to non-exitent group
	sed -i "s:0775 root lock:0755 root root:g" /usr/lib/tmpfiles.d/legacy.conf

	### Create /etc/machine-id file
	systemd-machine-id-setup

	### Modify test suite 
	sed -i "s:minix:ext4:g" src/test/test-path-util.c
	make LD_LIBRARY_PATH=/tools/lib -k check

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




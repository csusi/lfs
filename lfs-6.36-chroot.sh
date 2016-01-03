#!/bin/bash
echo ""
echo "### 6.36. Bash-4.3.30 (1.7 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

### TODO: Add some test or verification that, at the end when executing the 
### newly compiled bash shell that we just created, it is the one being run.

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.36
LFS_SOURCE_FILE_PREFIX=bash
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
	
	patch -Np1 -i ../bash-4.3.30-upstream_fixes-2.patch \
	  &> $LFS_LOG_FILE-patch.log
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	./configure --prefix=/usr                       \
            --bindir=/bin                       \
            --docdir=/usr/share/doc/bash-4.3.30 \
            --without-bash-malloc               \
            --with-installed-readline        \
	  &> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS         \
	  &> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Tests ... $LFS_SOURCE_FILE_NAME"  \
	 2>&1 | tee $LFS_LOG_FILE-make-tests.log
	
	chown -Rv nobody .           \
		&>> $LFS_LOG_FILE-make-tests.log
		
	su nobody -s /bin/bash -c "PATH=$PATH make tests"  \
		&>> $LFS_LOG_FILE-make-tests.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-install.log
	
	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	### Running 'exec /bin/bash --login +h' below
}
	
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo ""
echo "*** Note: Warning messages with 'error' in them are red herrings." 
show_build_errors ""
capture_file_list "" 
chapter_footer

echo "*** To continue, run:"
echo "*** --> cd /root/lfs "
echo "*** --> ./lfs-6.37-chroot.sh "
echo "***"
echo "*** Or run next 13 or 33 chapters in sequence (after changing dir as above):"
echo "*** --> ./lfs-6.37-to-6.50-chroot.sh"
echo "*** --> ./lfs-6.37-to-6.70-chroot.sh"
echo ""

exec /bin/bash --login +h



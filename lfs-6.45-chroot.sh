#!/bin/bash
echo ""
echo "### 6.45. Automake-1.15 (0.1 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="
echo "*** Note: This takes A LOT of time to run tests.  Like 20+ minutes."

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.45
LFS_SOURCE_FILE_PREFIX=automake
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "Chapter $LFS_SECTION $LFS_SOURCE_FILE_PREFIX - Started on $(date -u)" >> /build-logs/0-milestones.log

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
  sed -i 's:/\\\${:/\\\$\\{:' bin/automake.in
  
  echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
  ./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.15 	&> $LFS_LOG_FILE-configure.log

  echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
  make $LFS_MAKE_FLAGS 																					    &> $LFS_LOG_FILE-make.log

  sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh

  echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
  make check $LFS_MAKE_FLAGS 																				&> $LFS_LOG_FILE-make-check.log

  echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
  make install $LFS_MAKE_FLAGS 																			&> $LFS_LOG_FILE-make-install.log

  echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
  ### None
}

########## Chapter Clean-Up ##########

echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo "Chapter $LFS_SECTION $LFS_SOURCE_FILE_PREFIX - Started on $(date -u)" >> /build-logs/0-milestones.log

show_build_errors ""
capture_file_list "" 
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi




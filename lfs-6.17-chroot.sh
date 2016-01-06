#!/bin/bash
echo ""
echo "### 6.17. GCC-5.2.0   (82 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="
echo "### 82 SBU!! Time for a lunch/dinner/smoke/sleep break!!"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.17
LFS_SOURCE_FILE_PREFIX=gcc
LFS_BUILD_DIRECTORY=gcc-build    # Leave empty if not needed
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
	
	mkdir ../$LFS_BUILD_DIRECTORY
	cd ../$LFS_BUILD_DIRECTORY
	
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	SED=sed                       \
	../gcc-5.2.0/configure        \
     --prefix=/usr            \
     --enable-languages=c,c++ \
     --disable-multilib       \
     --disable-bootstrap      \
     --with-system-zlib       \
	  &> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS   \
	  &> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
	
	ulimit -s 32768
	make -k check $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-check.log
	
	../gcc-4.9.2/contrib/test_summary  \
	  &> $LFS_LOG_FILE-test-summary.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-install.log

}

########## Chapter Clean-Up ##########

echo ""
echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"

ln -sv ../usr/bin/cpp /lib

ln -sv gcc /usr/bin/cc

install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/5.2.0/liblto_plugin.so /usr/lib/bfd-plugins/

echo
echo "*** STOP AND LOOK IN BOOK THAT ALL THE OUTPUT IS CORRECT"
echo 

echo "*** Creating dummy. and checking linker is working"
echo "*** The output of this command should be.."
echo "*** [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"
echo "***************************************************************" 
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
echo ""

echo "*** Running: grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log"
echo "*** The output of this command should be.."
echo "*** /usr/lib/gcc/x86_64-unknown-linux-gnu/5.2.0/../../../lib64/crt1.o succeeded"
echo "*** /usr/lib/gcc/x86_64-unknown-linux-gnu/5.2.0/../../../lib64/crti.o succeeded"
echo "*** /usr/lib/gcc/x86_64-unknown-linux-gnu/5.2.0/../../../lib64/crtn.o succeeded"
echo "***************************************************************" 
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
echo ""


echo "*** Running: grep -B4 '^ /usr/include' dummy.log"
echo "*** The output of this command should be.."
echo "#include <...> search starts here:"
echo " /usr/lib/gcc/x86_64-unknown-linux-gnu/5.2.0/include"
echo " /usr/local/include"
echo " /usr/lib/gcc/x86_64-unknown-linux-gnu/5.2.0/include-fixed"
echo " /usr/include"
echo "***************************************************************" 
grep -B4 '^ /usr/include' dummy.log
echo ""

echo "*** Running: grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'"
echo "*** The output of this command should be.."
echo "SEARCH_DIR("/usr/x86_64-unknown-linux-gnu/lib64")"
echo "SEARCH_DIR("/usr/local/lib64")"
echo "SEARCH_DIR("/lib64")"
echo "SEARCH_DIR("/usr/lib64")"
echo "SEARCH_DIR("/usr/x86_64-unknown-linux-gnu/lib")"
echo "SEARCH_DIR("/usr/local/lib")"
echo "SEARCH_DIR("/lib")"
echo "SEARCH_DIR("/usr/lib");"
echo "***************************************************************" 
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
echo

echo "*** Running: grep '/lib.*/libc.so.6 ' dummy.log"
echo "*** The output of this command should be.."
echo "attempt to open /lib64/libc.so.6 succeeded"
echo "***************************************************************" 
grep "/lib.*/libc.so.6 " dummy.log
echo

echo "*** Running: grep found dummy.log"
echo "*** The output of this command should be.."
echo "found ld-linux-x86-64.so.2 at /lib64/ld-linux-x86-64.so.2"
echo "***************************************************************" 
grep found dummy.log
echo ""

rm -v dummy.c a.out dummy.log

echo "For 7.8: moving a misplaced file"
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib


echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo "Chapter $LFS_SECTION $LFS_SOURCE_FILE_PREFIX - Finished on $(date -u)" >> /build-logs/0-milestones.log


###### Not using standard 6.x footer I created, because I am inluding a STOP!! notice at end of script to verify all is well
LFS_WARNING_COUNT=$(grep -n " [Ww]arnings*:* " /build-logs/$LFS_SECTION* | wc -l)
LFS_ERROR_COUNT=$(grep -n " [Ee]rrors*:* " /build-logs/$LFS_SECTION* | wc -l)

echo ""
echo "*** Note: 12 warnings"
### Suppressing display of warnings in this script.  
if [ $LFS_WARNING_COUNT -ne 0 ]; then
    echo "*** $LFS_WARNING_COUNT Warnings Found In Build Logs for ... $LFS_SOURCE_FILE_NAME"
    grep -n " [Ww]arnings*:* " /build-logs/$LFS_SECTION*
else 
	  echo "*** $LFS_WARNING_COUNT Warnings Found In Build Logs for ... $LFS_SOURCE_FILE_NAME"
fi

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	  echo ""
	  echo "*** Note: A few unexpected failures cannot always be avoided. Be sure to compare with known"
	  echo "*** good build at:"
	  echo "***    http://www.linuxfromscratch.org/lfs/build-logs/7.8/"
	  echo "***    http://gcc.gnu.org/ml/gcc-testresults/"
	  echo "*** Past builds had errors on [check], [check-fixincludes], & [do-check]"
	  echo "***"
    echo "*** $LFS_ERROR_COUNT Errors Found In Build Logs for ... $LFS_SOURCE_FILE_NAME"
    grep -n " [Ee]rrors*:* " /build-logs/$LFS_SECTION*
else 
	  echo "*** $LFS_ERROR_COUNT Errors Found In Build Logs for ... $LFS_SOURCE_FILE_NAME"
fi

capture_file_list "" 

echo
echo "### Error Count: $LFS_ERROR_COUNT     Warning Count: $LFS_WARNING_COUNT"
echo "############################## End Chapter $LFS_SECTION #################################"
echo "*** STOP HERE!!!!"
echo "*** VALIDATE OUTPUT ABOVE WITH 6.17 EXPECTED RESULTS "
echo "*** Review the output of: $LFS_LOG_FILE-test-summary.log "
echo "*** "
echo "*** You are now ready to run:"
echo "*** --> ./lfs-6.18-chroot.sh"
echo "***"
echo ""

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit 0
fi

### Post-Note
### As the book states, it is likely there will be errors.  Compare it to the
### known good build-logs that can be found here: htt://www.linuxfromscratch.org/lfs/build-logs



#!/bin/bash
echo ""
echo "### 6.10. Adjusting the Toolchain (0.0 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

### TODO: Clean this up a bit!!  Add output to log files?
### I think this can only be run once or risk losing content in those
### mv commands.  Proceed with caution.

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.10
LFS_SOURCE_FILE_PREFIX=adjust-toolchain
LFS_BUILD_DIRECTORY=glibc-build    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

########## Begin LFS Chapter Content ##########

time {
	
	mv -v /tools/bin/{ld,ld-old}
	mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
	mv -v /tools/bin/{ld-new,ld}
	ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld
	
	gcc -dumpspecs | sed -e 's@/tools@@g'                   \
	    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
	    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
	    `dirname $(gcc --print-libgcc-file-name)`/specs
	
	
	echo "***************** STOP !!! *******************"
	echo "*** Sanity test of the tool chain."
	echo "*** Verify output below is:"
	echo "*** For 32bit builds: [Requesting program interpreter: /lib/ld-linux.so.2]" 
	echo "*** For 64bit builds:       [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"
	echo "*** "
	echo 'int main(){}' > dummy.c
	cc dummy.c -v -Wl,--verbose &> dummy.log
	readelf -l a.out | grep ': /lib'
	
	echo ""
	echo "*** Verify the output below is:"
	echo "*** For 32bit builds:"
	echo "*** /usr/lib/crt1.o succeeded"
	echo "*** /usr/lib/crti.o succeeded"
	echo "*** /usr/lib/crtn.o succeeded"
	echo "***"
	echo "*** For 64bit builds:"
	echo "*** /usr/lib/../lib64/crt1.o succeeded"
	echo "*** /usr/lib/../lib64/crti.o succeeded"
	echo "*** /usr/lib/../lib64/crtn.o succeeded"
	echo "***"

	grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
	
	
	echo ""
	echo "*** Verify the output below is:"
	echo "*** #include <...> search starts here:"
	echo "***  /usr/include"
	grep -B1 '^ /usr/include' dummy.log
	
	
	echo ''
	echo '*** Verify that the new linker is being used with the correct search paths'
	echo '*** For 32bit builds:'
	echo '*** SEARCH_DIR("/tools/i686-pc-linux-gnu/lib")'
	echo '*** SEARCH_DIR("/usr/lib")'
	echo '*** SEARCH_DIR("/lib");'
	echo "***"
	echo '**** For 64bit builds:'
	echo '*** SEARCH_DIR("=/tools/x86_64-unknown-linux-gnu/lib64")'
  echo '*** SEARCH_DIR("/usr/lib")'
  echo '*** SEARCH_DIR("/lib")'
  echo '*** SEARCH_DIR("=/tools/x86_64-unknown-linux-gnu/lib");'
  echo "***"
	grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
	
	echo ""
	echo "*** Verify the output below is:"
	echo "*** For 32bit builds: attempt to open /lib/libc.so.6 succeeded"
	echo "*** For 64bit builds: attempt to open /lib64/libc.so.6 succeeded"
	echo "*** "
	grep "/lib.*/libc.so.6 " dummy.log
	
	echo ""
	echo "*** Verify Output"
	echo "*** For 32bit builds: found ld-linux.so.2 at /lib/ld-linux.so.2"
	echo "*** For 64bit builds: found ld-linux-x86-64.so.2 at /lib64/ld-linux-x86-64.so.2"
	echo "*** "
	grep found dummy.log
	
	echo ""
	echo "*** Cleaning Directory"
	rm -v dummy.c a.out dummy.log

} 2> "$LFS_LOG_FILE-time.log"

########## Chapter Clean-Up ##########

echo ""
show_build_errors ""
capture_file_list "" 
chapter_footer
echo "***************** STOP !!! *******************"
echo "Review contents above to ensure build is correct."

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

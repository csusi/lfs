#!/bin/bash
echo ""
echo "### 5.35. Stripping (0.2 SBU - running as 'lfs')"
echo "### ================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=5.35
LFS_SOURCE_FILE_PREFIX=stripping
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=$LFS_MOUNT_DIR/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user lfs
check_lfs_partition_mounted_and_swap_on


########## Begin LFS Chapter Content ##########

### While optional, going to do to conserve space.  
strip --strip-debug /tools/lib/* 									&> $LFS_LOG_FILE-1-debugs.log

/usr/bin/strip --strip-unneeded /tools/{,s}bin/* 	&> $LFS_LOG_FILE-2-unneeded.log

rm -rf /tools/{,share}/{info,man,doc} 						&> $LFS_LOG_FILE-3-info-man_doc-files.log

echo ""
echo "##################################  STOP!!! ##################################"
echo "*** If builds are OK, it is time to exit as 'lfs' and return to "
echo "*** running as 'root', and run Ch. 5.36:"
echo "*** --> exit "
echo "*** --> ./lfs-5.36-root.sh"
echo ""

exit


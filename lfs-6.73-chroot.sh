#!/bin/bash
echo "### 6.73. Cleaning Up"
echo "### ================================================"
echo ""

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.73
LFS_SOURCE_FILE_PREFIX=cleanup
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

rm -rf /tmp/*  														&> $LFS_LOG_FILE-rm-temp.log

rm /usr/lib/lib{bfd,opcodes}.a						&> $LFS_LOG_FILE-rm-staticlibs.log
rm /usr/lib/libbz2.a											&>> $LFS_LOG_FILE-rm-staticlibs.log
rm /usr/lib/lib{com_err,e2p,ext2fs,ss}.a	&>> $LFS_LOG_FILE-rm-staticlibs.log
rm /usr/lib/libltdl.a											&>> $LFS_LOG_FILE-rm-staticlibs.log
rm /usr/lib/libz.a												&>> $LFS_LOG_FILE-rm-staticlibs.log

echo "Chapter 6 Completed on $(date -u)" >> /build-logs/0-milestones.log

echo "*** NOTE: The /tools directory is no longer necessary.  It can be removed if "
echo "*** desired.  When running the 'lfs-chroot-root.sh' script to re-enter the"
echo "*** LFS root partition, if it detects /tools is present, you will be given "
echo "*** a notice to delete it if desired."
echo "*** "
echo "*** Now would also be a good time to shut down and make a back-up VM."
echo "*** If shutting down do backup the VM, see section on Returning From "
echo "*** Shutting Down The Machine in the readme file."
echo "*** "
echo "*** When complete, run:"
echo "*** --> ./lfs-7.2-chroot.sh"
echo "***"
echo "*** Or run next 10 chapters in sequence:"
echo "*** --> ./lfs-7.2-to-8.2-chroot.sh"
echo ""

#!/bin/bash
echo ""
echo "### 7.9. Create the /etc/shells File (chrooted to lfs partition as 'root')"
echo "### ======================================================================"

### TODO: Compare this with the same files on my host OS.

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.9
LFS_SOURCE_FILE_PREFIX=etcshells
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
### TODO: Some kind of check that user is in chrooted to $LFS_MOUNT_DIR
check_user root


########## Begin LFS Chapter Content ##########

echo "*** Creating /etc/shells "

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

########## Chapter Clean-Up ##########

cat /etc/shells > $LFS_LOG_FILE-shells.log

echo "Chapter 7 Completed on $(date -u)" >> /build-logs/0-milestones.log

### Not showing logs or capturing file list.  I'm adding one file.  

echo "*** --> ./lfs-8.2-chroot.sh"
echo ""
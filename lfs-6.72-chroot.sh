#!/bin/bash
echo "### 6.72. Stripping Again  (0.0 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

echo ""
echo "TODO: Reconsider splitting this into 3.  Have this chapter logout.  Make a 6.x chroot (can be used later)"
echo "   and put the removal of debug into 6.73"
echo "Before performing the stripping, take special care to ensure that none of the binaries that are about to be stripped"
echo "are running. If unsure whether the user entered chroot with the command given in  Section 6.4, (Entering the Chroot"
echo "Environment),first exit from chroot and then re-enter with the following commands:"
echo ""
echo "When complete, run (need to 'exit' three times to get back to root):"
echo "-> exit "
echo "-> exit "
echo "-> exit "
echo "-> chroot $LFS_MOUNT_DIR /tools/bin/env -i HOME=/root TERM=$TERM PS1='\u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /tools/bin/bash --login"
echo "-> cd /root/lfs "
echo "-> /tools/bin/find /{,usr/}{bin,lib,sbin} -type f -exec /tools/bin/strip --strip-debug '{}' ';' " 
echo "-> ./lfs-6.73-chroot.sh"
echo ""

###6.4 chroot
###chroot "$LFS" /tools/bin/env -i \
###  HOME=/root \
###  TERM="$TERM" \
###  PS1='\u:\w\$ ' \
###  PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
###  /tools/bin/bash --login +h
###
###6.72 chroot
###chroot $LFS /tools/bin/env -i \
###  HOME=/root \
###  TERM=$TERM \
###  PS1='\u:\w\$ ' \
###  PATH=/bin:/usr/bin:/sbin:/usr/sbin \
###  /tools/bin/bash --login
###
###6.73 chroot
###chroot "$LFS" /usr/bin/env -i \
###  HOME=/root \
###  TERM="$TERM" \
###  PS1='\u:\w\$ ' \
###  PATH=/bin:/usr/bin:/sbin:/usr/sbin \
###  /bin/bash --login
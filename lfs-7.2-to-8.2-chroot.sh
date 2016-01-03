#!/bin/bash
echo ""
echo '### Linux From Scratch Ch 2.3 to 4.3 (chrooted to lfs partition as 'root')'
echo "### ======================================================================="
echo 

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root

./lfs-7.2-chroot.sh

./lfs-7.4-chroot.sh

./lfs-7.5-chroot.sh

./lfs-7.6-chroot.sh

./lfs-7.7-chroot.sh

./lfs-7.8-chroot.sh

./lfs-7.9-chroot.sh

./lfs-8.2-chroot.sh

echo ""
echo "########################## End Chapter 7.2 to 8.2 ##########################"
echo "*** It's time to start building the Linux Kernel. Run:"
echo "*** --> ./lfs-8.3.1-chroot.sh"
echo ""


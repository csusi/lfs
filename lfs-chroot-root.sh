#!/bin/bash
echo ""
echo "### A quick script to re-setup the chroot environment"
echo "###  after rebooting."
echo "### ================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root
check_lfs_partition_mounted_and_swap_on

echo ""
echo "*** Re-entering the chroot environment."
echo "*** Note: this is the chroot command from the end of Ch 6 that uses "
echo "*** the Bash shell at /bin/bash, and not /tools/bin/bash as done"
echo "*** earlier. If Ch 6 is not completed, this will not work."
echo "*** "
echo "*** To return to scripts directory, run:"
echo "*** --> cd /root/lfs "
echo "***"
echo "*** Note: If coming back to do a kernel re-compile, do the following:"
echo "*** --> cd /root/lfs "
echo "*** --> pushd /sources/linux*"
echo "*** (optional - will reset current .config) --> make defconfig "
echo "*** --> make menuconfig "
echo "***"
echo "*** When menuconfig is complete, run"
echo "*** --> popd ; ./lfs-8.3.2-root.sh "
echo ""

chroot "$LFS_MOUNT_DIR" /usr/bin/env -i \
  HOME=/root \
  TERM="$TERM" \
  PS1='\u:\w\$ ' \
  PATH=/bin:/usr/bin:/sbin:/usr/sbin \
  /bin/bash --login




#!/bin/bash
echo "### 8.3 Linux-4.20 Part 2 (3-49 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================"
echo ""

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=8.3
LFS_SOURCE_FILE_PREFIX=linux
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "Chapter 8.3.2 - Started Kernel Compiled on $(date -u)" >> /build-logs/0-milestones.log

cd $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)

echo "*** Running Make  ... $LFS_SOURCE_FILE_NAME"
make $LFS_MAKE_FLAGS 																						&> $LFS_LOG_FILE-make.log

echo "*** Running Make Modules Install ... $LFS_SOURCE_FILE_NAME"
make modules_install $LFS_MAKE_FLAGS 														&> $LFS_LOG_FILE-make-modules_install.log

echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"

cp -v arch/x86/boot/bzImage /boot/vmlinuz-4.2-lfs-7.8
cp -v System.map /boot/System.map-4.2
cp -v .config /boot/config-4.2

install -d /usr/share/doc/linux-4.2
cp -r Documentation/* /usr/share/doc/linux-4.2



echo "8.3.2. Configuring Linux Module Load Order"

install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

### Note: Not performing clean-up tasks of deleting the /sources/linux-x.x.x
### directory to make it easier to come back in and make changes to the 
### kernel if desired.  At this point the LFS build is done, and /sources
### could be deleted if desired.

echo "Chapter 8.3.2 - Finished Kernel Compiled on $(date -u)" >> /build-logs/0-milestones.log

show_build_errors ""
capture_file_list "" 
chapter_footer
echo "*** If this is is you first time through, run:"
echo "*** --> ./lfs-8.4-chroot.sh"
echo "***"
echo "*** If performing a kernel re-compile and Ch 8.4 -> 9.1 are complete, then "
echo "*** --> logout "
echo "*** --> ./lfs-9.3-unmount-and-reboot.sh"
echo ""

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

#!/bin/bash
echo ""
echo "### Systemd 7.10. Systemd Usage and Configuration (chrooted to lfs partition as 'root')"
echo "### ============================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.10
LFS_SOURCE_FILE_PREFIX=sysvbootscript
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

########## Begin LFS Chapter Content ##########

echo "*** 7.10.1. Basic Configuration "

### See book.  Not doing anything here for now.

echo "*** 7.10.2. Disabling Screen Clearing at Boot Time "

mkdir -pv /etc/systemd/system/getty@tty1.service.d

cat > /etc/systemd/system/getty@tty1.service.d/noclear.conf << EOF
[Service]
TTYVTDisallocate=no
EOF

echo "*** 7.10.3. Disabling tmpfs for /tmp  "

ln -sfv /dev/null /etc/systemd/system/tmp.mount

echo "*** 7.10.4. Configuring Automatic File Creation and Deletion  "

### See book.  Not doing anything here for now.

echo "*** 7.10.5. Overriding Default Services Behavior  "

### See book.  Not doing anything here for now.

echo "*** 7.10.6. Debugging the Boot Sequence "

### See book.  Not doing anything here for now.

########## Chapter Clean-Up ##########


### Not showing logs or capturing file list.  I'm adding one file.  

echo ""
echo "*** --> ./lfs-8.2-chroot.sh"
echo ""

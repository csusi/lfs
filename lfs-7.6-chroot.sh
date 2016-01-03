#!/bin/bash
echo ""
echo "### 7.6. System V Bootscript Usage & Config (chrooted to lfs partition as 'root')"
echo "### ============================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.6
LFS_SOURCE_FILE_PREFIX=sysvbootscript
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
### TODO: Some kind of check that user is in chrooted to $LFS_MOUNT_DIR
check_user root

########## Begin LFS Chapter Content ##########

echo "*** 7.6.1. How Do the System V Bootscripts Work? "

echo "*** 7.6.2. Configuring Sysvinit - /etc/inittab "

cat > /etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF

echo "*** 7.6.3. Udev Bootscripts "

echo "*** 7.6.4. Configuring the System Clock "

### TODO: Review if this is needed once you get booted.

echo "*** 7.6.5. Configuring the Linux Console "

### TODO: Being in the U.S., this is probably not relevant.  It updates the
### /etc/sysconfig/console file, which I see isn't a file on my host OS.

echo "*** 7.6.6. Creating Files at Boot "

### TODO: Optional.  Review in subsequent pass.

echo "*** 7.6.7. Configuring the sysklogd Script "

### TODO: Optional.  Review in subsequent pass.

echo "*** 7.6.8. The rc.site File "

### TODO: Optional.  Review in subsequent pass.

########## Chapter Clean-Up ##########

cat /etc/inittab > $LFS_LOG_FILE-inittab.log

### Not showing logs or capturing file list.  I'm adding one file.  

echo "*** --> ./lfs-7.7-chroot.sh"
echo ""
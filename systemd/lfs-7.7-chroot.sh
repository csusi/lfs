#!/bin/bash
echo ""
echo "### Systemd 7.7. Configuring the System Locale (chrooted to lfs partition as 'root')"
echo "### ============================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.7
LFS_SOURCE_FILE_PREFIX=system-locale
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

########## Begin LFS Chapter Content ##########

### Like in 7.2, do not add quotations around EOF limiter or it will
### mess up setting LFS_LANG

cat > /etc/locale.conf << EOF
LANG=$LFS_LANG
EOF


########## Chapter Clean-Up ##########

echo ""
echo "*** Start /etc/locale.conf"
cat /etc/locale.conf | tee $LFS_LOG_FILE-locale-conf.log
echo "*** End /etc/locale.conf "


### Not showing logs or capturing file list.  I'm adding one file.  

echo "*** --> ./lfs-7.8-chroot.sh"
echo ""

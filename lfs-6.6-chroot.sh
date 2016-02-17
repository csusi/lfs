#!/tools/bin/bash
echo ""
echo "### 6.6. Creating Essential Files and Symlinks (0.0 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

### Bash does not exist in /bin/bash yet, not until symlink below.  So script
### Interpreter above (#!/tools/bin/bash) is in a non-standard location

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.6
LFS_SOURCE_FILE_PREFIX=createfiles
LFS_LOG_FILE="/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX.log"

echo "*** Validating the environment."
# check_user root     # whoami fails 
check_chroot_to_lfs_rootdir 

########## Begin LFS Chapter Content ##########

echo "*** Linking essential files."
ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin  &>> $LFS_LOG_FILE
ln -sv /tools/bin/perl /usr/bin                  &>> $LFS_LOG_FILE
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib      &>> $LFS_LOG_FILE
ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib     &>> $LFS_LOG_FILE
sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la 
ln -sv bash /bin/sh                              &>> $LFS_LOG_FILE

ln -sv /proc/self/mounts /etc/mtab               &>> $LFS_LOG_FILE

echo "*** Creating etc/passwd file."
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

echo "*** Creating /etc/group file."
cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
nogroup:x:99:
users:x:999:
EOF

########## Chapter Clean-Up ##########

show_build_errors ""
capture_file_list ""

echo ""
echo "############################################################"
echo "*** Starting new shell."
echo "*** You are now ready to run:"
echo "*** --> ./lfs-6.7-chroot.sh"
echo "***"
echo "*** Or run next 3 or 28 chapters in sequence:"
echo "*** --> ./lfs-6.7-to-6.10-chroot.sh"
echo "*** --> ./lfs-6.7-to-6.34-chroot.sh"
echo ""

### Have moved these to the next chapter
### touch /var/log/{btmp,lastlog,wtmp}"
### chgrp -v utmp /var/log/lastlog"
### chmod -v 664 /var/log/lastlog"
### chmod -v 600 /var/log/btmp"

# To remove the  “I have no name!”prompt, start a new shell.
exec /tools/bin/bash --login +h


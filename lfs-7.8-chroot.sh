#!/bin/bash
echo ""
echo "### 7.8. Create the /etc/inputrc File (chrooted to lfs partition as 'root')"
echo "### ======================================================================="

### TODO: Compare this with the same files on my host OS.

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.8
LFS_SOURCE_FILE_PREFIX=etcinputrc
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
### TODO: Some kind of check that user is in chrooted to $LFS_MOUNT_DIR
check_user root


########## Begin LFS Chapter Content ##########

echo ""
echo "*** Creating /etc/inputrc file"

cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

########## Chapter Clean-Up ##########

cat /etc/inputrc > $LFS_LOG_FILE-inputrc.log

### Not showing logs or capturing file list.  I'm adding one file.  
echo ""
echo "*** --> ./lfs-7.9-chroot.sh"
echo ""

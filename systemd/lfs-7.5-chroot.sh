#!/bin/bash
echo ""
echo "### Systemd 7.5. Configuring the system clock (chrooted to lfs partition as 'root')"
echo "### ==================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.5
LFS_SOURCE_FILE_PREFIX=system-clock
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

########## Begin LFS Chapter Content ##########

echo "*** 7.5. Configuring the system clock "

### NOTE: If modifying this in the future, be careful not to re-add quotes around the 
### limit string EOF, otherwise it will no longer evaluate the shell env variables as desired.

### This is only necessary if hardware clock is set to local time.  On a VBox VM
### It is set to UTC, so commenting out.

#echo "*** Creating /etc/adjtime"
#cat > /etc/adjtime << EOF
#0.0 0 0.0
#0
#LOCAL
#EOF


########## Chapter Clean-Up ##########


### There is no need to show errors as nothing is being written to build-logs.
#show_build_errors ""
capture_file_list "" 
chapter_footer
echo "--> ./lfs-7.6-chroot.sh"
echo ""


#if [ $LFS_ERROR_COUNT -ne 0 ]; then
#	exit 4
#else
	exit
#fi

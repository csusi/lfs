#!/bin/bash
echo ""
echo "### Linux From Scratch Ch 6.7 to 6.10"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

echo "Chapter Ch. 6.7 to 6.10 started on $(date -u)" >> /build-logs/0-milestones.log

time {
	
	echo ""
	### TODO: Add in something to check the return codes for a fatal error.  If so, exit this script also.  
	for i in {7..10}
	do
		bash ./lfs-6.$i-chroot.sh
	done
	
	echo ""
	show_first_ten_errors_in_section_logs 6 7 10
	
} 

echo "Chapter Ch. 6.7 to 6.10 finished on $(date -u)" >> /build-logs/0-milestones.log
	
echo ""
echo "########################## End Chapter 6.7 to 6.10 ##########################"
echo "*** If builds are OK, run next 6 chapters:"
echo "*** --> ./lfs-6.11-to-6.17-chroot.sh"
echo ""

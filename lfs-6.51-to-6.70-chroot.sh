#!/bin/bash
echo ""
echo "### Linux From Scratch Ch 6.51 to 6.70"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

echo "Chapter Ch. 6.51 to 6.70 started on $(date -u)" >> /build-logs/0-milestones.log

time {
	
	echo ""
	for i in {51..70}
	do
		./lfs-6.$i-chroot.sh
	done
	
	echo ""
	show_first_ten_errors_in_section_logs 6 51 70
}

echo "Chapter Ch. 6.51 to 6.70 finished on $(date -u)" >> /build-logs/0-milestones.log

echo ""
echo "########################## End Chapter 6.51 to 6.70 ##########################"
echo "*** If builds are OK, run (Ch 6.71 is informational):"
echo "*** --> ./lfs-6.72-chroot.sh"
echo ""


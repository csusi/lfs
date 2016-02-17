#!/bin/bash
echo ""
echo "### Linux From Scratch Ch 6.36 to 6.50"
echo "### ========================================================================="


if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

echo "Chapter Ch. 6.36 to 6.50 started on $(date -u)" >> /build-logs/0-milestones.log

time {
	
	echo ""
	for i in {36..50}
	do
		./lfs-6.$i-chroot.sh
	done
	
	echo ""
	show_first_ten_errors_in_section_logs 6 36 50
	
}

echo "Chapter Ch. 6.36 to 6.50 finished on $(date -u)" >> /build-logs/0-milestones.log

echo ""
echo "########################## End Chapter 6.36 to 6.50 ##########################"
echo "*** If builds are OK, run next 20 chapters:"
echo "*** --> ./lfs-6.51-to-6.70-chroot.sh"
echo ""


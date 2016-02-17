#!/bin/bash
echo ""
echo "### Linux From Scratch Ch 6.18 to 6.25"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

echo "Chapter Ch. 6.18 to 6.25 started on $(date -u)" >> /build-logs/0-milestones.log

time {
	echo ""
	for i in {18..25}
	do
		./lfs-6.$i-chroot.sh
	done
	
	echo ""
	show_first_ten_errors_in_section_logs 6 18 25
	
}

echo "Chapter Ch. 6.18 to 6.25 finished on $(date -u)" >> /build-logs/0-milestones.log

echo ""
echo "########################## End Chapter 6.18 to 6.25 ##########################"
echo "*** If builds are OK, run next 10 chapters:"
echo "*** --> ./lfs-6.26-to-6.34-chroot.sh"
echo ""


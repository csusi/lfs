#!/bin/bash
echo ""
echo "### Linux From Scratch Ch 6.7 to 6.35"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

echo "Chapter Ch. 6.7 to 6.35 started on $(date -u)" >> /build-logs/0-milestones.log

time {

	echo ""
	for i in {7..35}
	do
		./lfs-6.$i-chroot.sh
	done
	
	echo ""
	show_first_ten_errors_in_section_logs 6 7 35

}

echo "Chapter Ch. 6.7 to 6.35 finished on $(date -u)" >> /build-logs/0-milestones.log

echo "########################## End Chapter 6.7 to 6.35 ##########################"
echo "*** If builds are OK, run Ch 6.36:"
echo "*** --> ./lfs-6.36-chroot.sh"
echo ""



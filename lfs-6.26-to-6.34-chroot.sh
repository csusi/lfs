#!/bin/bash
echo ""
echo "### Linux From Scratch Ch 6.26 to 6.34"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

echo "Chapter Ch. 6.26 to 6.34 started on $(date -u)" >> /build-logs/0-milestones.log

time {
	echo ""
	for i in {26..34}
	do
		./lfs-6.$i-chroot.sh
	done
	
	echo ""
	show_first_ten_errors_in_section_logs 6 26 34
}

echo "Chapter Ch. 6.26 to 6.34 finished on $(date -u)" >> /build-logs/0-milestones.log

echo ""
echo "########################## End Chapter 6.26 to 6.34 ##########################"
echo "*** If builds are OK, run chapter 6.35:"
echo "*** --> ./lfs-6.35-chroot.sh"
echo ""


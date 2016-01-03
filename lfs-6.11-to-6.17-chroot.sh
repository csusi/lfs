#!/bin/bash
echo ""
echo "### Linux From Scratch Ch 6.11 to 6.17"
echo "### ========================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "Chapter Ch. 6.11 to 6.17 started on $(date -u)" >> /build-logs/0-milestones.log

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

time {
	echo ""
	for i in {11..17}
	do
		./lfs-6.$i-chroot.sh
	done
	
	echo ""
	show_first_ten_errors_in_section_logs 6 11 17
}

echo "Chapter Ch. 6.11 to 6.17 finished on $(date -u)" >> /build-logs/0-milestones.log

echo ""
echo "###################### End Chapter 6.11 to 6.17 ##########################"
echo "*** If builds are OK, run next 7 chapters:"
echo "*** --> ./lfs-6.18-to-6.25-chroot.sh"
echo ""


#!/bin/bash
echo ""
echo "### Linux From Scratch Ch 5.11 to 5.20 (run as lfs)"
echo "### ======================================================="


if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user lfs
check_lfs_partition_mounted_and_swap_on

echo "Chapter Ch. 5.11 to 5.20 started on $(date -u)" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log

time {
	echo ""
	for i in {11..20}
	do
		./lfs-5.$i-lfs.sh
	done
	
	echo ""
	show_first_ten_errors_in_section_logs 5 11 20
}	

echo "Chapter Ch. 5.11 to 5.20 finished on $(date -u)" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log

echo ""
echo "########################## End Chapter 5.11 to 5.20 ##########################"
echo "*** If everything looks good, run next 10 chapters:"
echo "*** --> ./lfs-5.21-to-5.30-lfs.sh"
echo ""
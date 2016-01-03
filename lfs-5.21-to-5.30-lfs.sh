#!/bin/bash
echo ""
echo '### Linux From Scratch Ch 5.21 to 5.30 (run as lfs)'
echo "### ======================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user lfs
check_lfs_partition_mounted_and_swap_on 

echo "Chapter Ch. 5.21 to 5.30 started on $(date -u)" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log

time {	
	echo ""
	for i in {21..30}
	do
		./lfs-5.$i-lfs.sh
	done
	
	echo ""
	show_first_ten_errors_in_section_logs 5 21 30
}

echo "Chapter Ch. 5.21 to 5.30 finished on $(date -u)" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log

echo ""
echo "########################## End Chapter 5.21 to 5.30 ##########################"
echo "*** If everything looks good, run next 4 chapters:"
echo "*** --> ./lfs-5.31-to-5.35-lfs.sh"
echo ""
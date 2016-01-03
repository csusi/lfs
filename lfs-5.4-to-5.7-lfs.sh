#!/bin/bash
echo ""
echo '### Linux From Scratch Ch. 5.4 to 5.7 (run as lfs) ###'
echo "### ======================================================="

### TODO: Probably could add some better error checking here.  This assumes
### have gone through each script individually for an environment first and
### want to just chain several together in a subsequent installation.

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user lfs
check_lfs_partition_mounted_and_swap_on

echo "Chapter Ch. 5.4 to 5.7 started on $(date -u)" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log

time {

	for i in {4..7}
	do
		./lfs-5.$i-lfs.sh
	done
	
	echo ""
	show_first_ten_errors_in_section_logs 5 4 7
	
}


echo "Chapter Ch. 5.4 to 5.7 finished on $(date -u)" >> $LFS_MOUNT_DIR/build-logs/0-milestones.log

echo ""
echo "########################## End Ch. 5.4 to 5.7 ##########################"
echo "*** If everything looks good, run next 3 chapters:"
echo "*** --> ./lfs-5.8-to-5.10-lfs.sh"
echo ""
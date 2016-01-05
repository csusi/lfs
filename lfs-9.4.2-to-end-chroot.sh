#!/bin/bash
echo ""
echo '### (BLFS) Run 9.4.2 to End (chrooted to lfs partition as 'root')'
echo "### ======================================================="
echo 

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir

echo "(BLFS) 9.4.2 to End started on $(date -u)" >> /build-logs/0-milestones.log

time {
	
	echo ""
	### TODO: Add in something to check the return codes for a fatal error.  If so, exit this script also.  
	for i in {2..100}
	do
		if [ -f "./lfs-9.4.$i-chroot.sh" ]; then
			echo "Running ./lfs-9.4.$i-chroot.sh"
			bash ./lfs-9.4.$i-chroot.sh
		fi
	done

	echo ""
	echo "*** Displaying first 10 errors from logs."
	for i in {2..100}
	do
		if [ -f "./lfs-9.4.$i-chroot.sh" ]; then
			echo "--> grep -n \" [Ee]rrors*:* \|^FAIL:\" /build-logs/9.4.$i-* | head -n 10"
			grep -n " [Ee]rrors*:* \|^FAIL:" /build-logs/9.4.$i-* | head -n 10
			echo ""
		fi
	done

	
} 

echo "(BLFS) 9.4.2 to End finished on $(date -u)" >> /build-logs/0-milestones.log
	
echo ""
echo "########################## End Chapter 9.4.2 to End ##########################"
echo "*** If builds are OK, run:"
echo "*** --> exit"
echo "*** --> ./lfs-9.4.3-reboot.sh"
echo ""

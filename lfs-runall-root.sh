#!/tools/bin/bash
echo ""
echo "### Run All"
echo "### ========================================================================="

### An attempt to automate the complete process.  Run after Ch 0 system check

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

# Check for 1 variable.  It should be name of file that exists in /lfs/kernelconfigs



### Run this  --> ./lfs-2.3-to-4.3-root.sh"
### Has user quck input to confirm formatting $LFS_ROOT_PARTITION

### Make script "lfs-runall-lfs-4.4-to-5.35.sh" copied to /home/lfs
### 4.3 copies scripts to /home/lfs (may need to add a line to copy above script)

### Execue a shell running "lfs-runall-lfs-4.4-to-5.35.sh", replaces "--> su - lfs" 

	### "lfs-runall-lfs-4.4-to-5.35.sh" as lfs
	echo "--> cd lfs ; ./lfs-4.4-lfs.sh"
	echo "*** --> source ~/.bash_profile "
	echo "*** --> ./lfs-5.3-lfs.sh"
	echo "*** --> ./lfs-5.4-to-5.35-lfs.sh"
	### Script terminates, replacing the need for --> exit 

### Run these three scripts
echo "*** --> ./lfs-5.36-root.sh"
echo "*** --> ./lfs-6.2-root.sh"
echo "*** --> ./lfs-6.4-root.sh"

### NOTE: 6.4 automatically enters chroot at end.  Would need to ensure it knew
### instead of entering chroot, to run "lfs-runall-chroot-6.5-to-???.sh"
### the same with 6.6 and 6.35

### Make script "lfs-runall-chroot-6.5-to-???.sh"
### 6.4 Copies scripts from /root/lfs to $LFS_MOUNT_DIR/tools/lfs, chroot at end

	### "lfs-runall-chroot-6.5-to-???.sh"
	echo "*** ---> cd /tools/lfs ; ./lfs-6.5-chroot.sh"
	echo "*** --> mv /tools/lfs /root/lfs ; cd /root/lfs ; ./lfs-6.6-chroot.sh"
	### 6.6 executes new shell at end (exec /tools/bin/bash --login +h)

		### ?????
		echo "*** --> ./lfs-6.7-to-6.35-chroot.sh"
		echo "*** --> passwd root"  # Now done in base scripts, YAY!
		echo "*** --> ./lfs-6.36-chroot.sh"
		
			### ????
			### 6.36 launches new bash shell (exec /bin/bash --login +h)
			echo "*** --> cd /root/lfs "
			echo "*** --> ./lfs-6.37-to-6.70-chroot.sh"
			echo "*** --> ./lfs-6.72-chroot.sh"
			### 6.72 does nothing but has the user execute these commands:
			### script ends replacing need for -> exit 
			
		### Script ends, replacing need for -> exit "
		
	### Script ends, replacing need for -> exit "

### Make "lfs-runall-chroot-6.72.sh"
#### Execute it instead of --> chroot $LFS_MOUNT_DIR /tools/bin/env -i HOME=/root TERM=$TERM PS1='\u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /tools/bin/bash --login"

	### "lfs-runall-chroot-6.73.sh"
	echo "*** -> cd /root/lfs "
	echo "*** -> /tools/bin/find /{,usr/}{bin,lib,sbin} -type f -exec /tools/bin/strip --strip-debug '{}' ';' " &>>$LFS_LOG_FILE-removedebugs.log
	echo "*** -> ./lfs-6.73-chroot.sh"
	echo "*** --> ./lfs-7.2-to-8.2-chroot.sh"
	echo "*** --> ./lfs-8.3.1-chroot.sh"
	### Now, if I have a saved .config file like "VirtualBox.config" in the lfs, 
	### directory, I can copy that to /sources/linuxX.XX/.config, and skip the
	### entire process of running make defconfig & make menuconfig.  Then skip to:
	### Probably want to pass this as a shell variable so different .configs can be saved
	### maybe in a /root/lfs/kernel-configs
	echo "***--> ./lfs-8.3.2-chroot.sh "
	echo "*** ---> ./lfs-8.4-chroot.sh" ### This does nothing right now.  So can skip to 
	echo "*** ---> ./lfs-9.1-chroot.sh"
	### Script ends, ending need for --> logout"
	
echo "--> update-grub"
### Echo user to hitany key to reboot
echo "--> ./lfs-9.3-reboot.sh"

### BAM, DONE!  

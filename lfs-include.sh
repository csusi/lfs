### 6.x. Global Header
### ================================================

### TODO: varaible for filesystem type? e.g. ext3, ext4, other?


LFS_MOUNT_DIR=/mnt/lfs
LFS_SWAP_PARTITION=/dev/sdb1
LFS_ROOT_PARTITION=/dev/sdb2

### Count of lines in wget-list +2 for wget-list and mdsums files
LFS_SOURCES_EXPECTED_COUNT=82
LFS_SOURCES_LIST="http://www.linuxfromscratch.org/lfs/view/7.8/wget-list"
LFS_SOURCES_MD5_SUMS="http://www.linuxfromscratch.org/lfs/view/7.8//md5sums"

### TODO: if this becomes ../lfs-backup then may be able to keep build on host OS contained to user home dir instead of in /root
LFS_SOURCES_BACKUP_DIR=/root/lfs-backup/sources/

### Setting the '-j4' switch on all of the 'make' commands to use all four   
### processors of the VM. This can cause race conditions when compiling some 
### packages. If encountered, set 'LFS_MAKE_FLAGS='within the bash script 
### in the pre-configuration tasks.
LFS_MAKE_FLAGS=-j4

### Used in 6.9 to set the timezone.  
LFS_TIME_ZONE=America/Chicago

### Used in 6.52-groff  sets the page size.  
LFS_PAGE=letter

### Used 5.36 to make a backup of completed tools and move build-logs
### TODO: if this becomes ../lfs-backup then may be able to keep build on host OS contained to user home dir
### TODO: I think I took out making backups of ch5 build logs, so LFS_BUILD_LOGS_ARCHIVE_DIR is no longer needed.
LFS_TOOLS_BACKUP_DIR=/root/lfs-backup/tools
LFS_BUILD_LOGS_ARCHIVE_DIR=/root/lfs-backup/ch5-build-logs  


### Used in 6.25 to set the password for root on the new system
### TODO: I tried to automate this, but 'passwd' wasn't giving me any love
### to pipe in a password.  So just leaving it to require user input when the
### time comes. Also makes for a nice point to do a logical 
### break in the batched build of ch. 6
LFS_ROOT_PASSWORD=lfs

### Used in 7.5 for general networking configuration
### /etc/sysconfig/ifconfig.eth0
LFS_IP_ADDR=10.0.0.222
LFS_IP_GATEWAY=10.0.0.1
LFS_IP_PREFIX=24
LFS_IP_BROADCAST=10.0.255.255
### /etc/resolv.conf
LFS_IP_NAMESERVER1=10.0.0.1
LFS_IP_NAMESERVER2=10.0.0.52
### /etc/hostname & /etc/hosts
LFS_IP_HOSTNAME=lfs
LFS_IP_FQDN=lfs.susiland.net

### Used in 7.7 to set LANG env variable in /etc/profile
LFS_LANG=en_US.UTF-8

### Used in 9.1 to set /etc/lsb-release
LFS_DISTRIB_ID="Linux From Scratch"
LFS_DISTRIB_RELEASE="7.8"
LFS_DISTRIB_CODENAME="Linux From Scratch"
LFS_DISTRIB_DESCRIPTION="Linux From Scratch"


############################ Functions #############################

function check_user {
	if [ $( whoami ) != "$1" ]; then 
  	echo "*** Fatal Error - Script must be run as $1" 
  	exit 6 
  fi
}

function check_lfs_partition_mounted_and_swap_on {
	if [ -z $(awk -v needle="$LFS_ROOT_PARTITION" '$1==needle {print $2}' /proc/mounts)  ] ; then
	    echo "*** Fatal Error - $LFS_ROOT_PARTITION not mounted."
	    echo "*** Mount it with the command 'mount -v -t ext4 $LFS_ROOT_PARTITION $LFS_MOUNT_DIR'."
	    exit 7
	else
	    if [ ! $(awk -v needle="$LFS_ROOT_PARTITION" '$1==needle {print $2}' /proc/mounts) = "$LFS_MOUNT_DIR" ] ; then
	        echo "*** Fatal Error - $LFS_ROOT_PARTITION is not mounted at $LFS_MOUNT_DIR "
	        echo "*** Mount it with the command 'mount -v -t ext4 $LFS_ROOT_PARTITION $LFS_MOUNT_DIR'."
	        exit 7
	    else
	        echo "*** $LFS_ROOT_PARTITION mounted at $LFS_MOUNT_DIR "
	    fi
	fi
	if [ -z $(awk -v needle="$LFS_SWAP_PARTITION" '$1==needle {print $1}' /proc/swaps)  ] ; then
	    echo "*** Fatal Error - Swap drive $LFS_SWAP_PARTITION is not on."
	    echo "*** Enable it with the command '/sbin/swapon -v $LFS_SWAP_PARTITION'."
	 	  exit 11   
	else
      echo "*** Swap drive $LFS_SWAP_PARTITION is on."
	fi
}

function check_chroot_to_lfs_rootdir {
	### Ch 6.4 chroots at end
	### Ch 6.6 user starts new shell
	### Ch 6.36 user starts new shell
	### Why there needs to be three 'exit' at end of 6.72

	if [ ! $(awk -v needle="$LFS_ROOT_PARTITION" '$1==needle {print $2}' /proc/mounts) = "/" ] ; then
		echo "*** Fatal Error - $LFS_ROOT_PARTITION is not mounted at / "
	  echo "*** Mount it in the Host OS, and chroot to the mount point."
	  exit 14
	else
		echo "*** $LFS_ROOT_PARTITION mounted at /  "
	fi

	if [ -z $(awk -v needle="$LFS_SWAP_PARTITION" '$1==needle {print $1}' /proc/swaps)  ] ; then
	    echo "*** Fatal Error - Swap drive $LFS_SWAP_PARTITION is not on."
	    echo "*** Enable it with the command '/sbin/swapon -v $LFS_SWAP_PARTITION'."
	 	  exit 11   
	else
      echo "*** Swap drive $LFS_SWAP_PARTITION is on."
	fi
	
  if test !  -d "/sources" && test ! -d "/build-logs"  ; then
	  echo "*** Fatal Error - Not chrooted for $LFS_ROOT_PARTITION as root dir."  	
  	exit 14
	fi

}

function test_only_one_tarball_exists {
	echo "*** Validating one and only one tarball exists."
	LFS_SOURCE_FILE_NAME=$(ls | egrep "^$LFS_SOURCE_FILE_PREFIX.+tar")
	LFS_SOURCE_FILE_COUNT=$(ls | egrep "^$LFS_SOURCE_FILE_PREFIX.+tar" | wc -l)
	if [ $LFS_SOURCE_FILE_COUNT -eq 0 ]; then
		echo "*** No '$LFS_SOURCE_FILE_PREFIX' tarballs found.  Exiting script."
		exit 2
	elif [ $LFS_SOURCE_FILE_COUNT -gt 1 ]; then
		echo "*** Multiple '$LFS_SOURCE_FILE_PREFIX' tarballs found ($LFS_SOURCE_FILE_COUNT).  Exiting script."
		exit 3
	fi
}

function extract_tarball {
	# Function takes in one variable, which determines if there is a preceeding 
	# path to where the new LFS OS root directory will be.  This is necessary for
	# much of Chapter 5, when writing directly to the LFS_MOUNT_DIR path. After
	# 6.4, when the root account has chrooted to the LFS_MOUNT_DIR path,
	# specifying this path will no longer be necessary and /sources will be off
	# the root of the directory structure.  
	
	ROOT_PATH="$1"
	
	echo "*** Extracting ... $LFS_SOURCE_FILE_NAME"
	if [ ! -d $ROOT_PATH/sources/$LFS_SOURCE_FILE_PREFIX*/  ]; then
	    echo "*** Source directory does not exist. Extracting ... $LFS_SOURCE_FILE_NAME"
	    tar xf $LFS_SOURCE_FILE_NAME
	else
	    echo "*** Source directory found matching prefix '$LFS_SOURCE_FILE_PREFIX'.  Not Extracting"
	    LFS_DO_NOT_DELETE_SOURCES_DIRECTORY=1
	fi
}

function show_build_errors {
	# Function takes in one variable, which determines if there is a preceeding 
	# path to where the new LFS OS root directory will be.  This is necessary for
	# much of Chapter 5, when writing directly to the LFS_MOUNT_DIR path. After
	# 6.4, when the root account has chrooted to the LFS_MOUNT_DIR path,
	# specifying this path will no longer be necessary and /sources will be off
	# the root of the directory structure.  
	
	ROOT_PATH="$1"
	LFS_WARNING_COUNT=0
  LFS_ERROR_COUNT=0

	LFS_WARNING_COUNT=$(grep -n " [Ww]arnings*:* " $ROOT_PATH/build-logs/$LFS_SECTION* | wc -l)
	LFS_ERROR_COUNT=$(grep -n " [Ee]rrors*:* \|^FAIL:" $ROOT_PATH/build-logs/$LFS_SECTION* | wc -l)
	
	
#  ### Commenting this block out because some sections generate a lot of warnings that
#  ### are mostly noise.  Uncomment if desired to display them.
#	if [ $LFS_WARNING_COUNT -ne 0 ]; then
#	    echo "*** $LFS_WARNING_COUNT Warnings In Build Logs for ... $LFS_SOURCE_FILE_NAME"
#	    grep -n " [Ww]arnings*:* " $ROOT_PATH/build-logs/$LFS_SECTION*
#	else 
#		  echo "*** $LFS_WARNING_COUNT Warnings In Build Logs for ... $LFS_SOURCE_FILE_NAME"
#	fi


	if [ $LFS_ERROR_COUNT -ne 0 ]; then
	    echo "*** $LFS_ERROR_COUNT Errors Found In Build Logs for ... $LFS_SOURCE_FILE_NAME"
	    grep -n " [Ee]rrors*:* \|^FAIL:" $ROOT_PATH/build-logs/$LFS_SECTION*
	    echo "Compare against known good logs at: http://www.linuxfromscratch.org/lfs/build-logs"
	else 
		  echo "*** $LFS_ERROR_COUNT Errors Found In Build Logs for ... $LFS_SOURCE_FILE_NAME"
	fi
}

function capture_file_list {
  ### Not in the book. Capturing file list to see what files are added.
	### To see how the expected file system grows with each chapter, this is
	### cutting out the /proc /sys /dev and sources/build-logs/tools directories

	# Function takes in one variable, which determines if there is a preceeding 
	# path to where the new LFS OS root directory will be.  This is necessary for
	# much of Chapter 5, when writing directly to the LFS_MOUNT_DIR path. After
	# 6.4, when the root account has chrooted to the LFS_MOUNT_DIR path,
	# specifying this path will no longer be necessary and /sources will be off
	# the root of the directory structure.  
	
	ROOT_PATH="$1"
	find $ROOT_PATH/ \
	  -path $ROOT_PATH/proc -prune \
	  -or -path $ROOT_PATH/sys -prune  \
	  -or -path $ROOT_PATH/dev -prune  \
	  -or -path $ROOT_PATH/sources -prune  \
	  -or -print \
	  &> $ROOT_PATH/build-logs/$LFS_SECTION-filelist-chapter-end.log 
}


function chapter_footer {
	echo
	echo "### Error Count: $LFS_ERROR_COUNT    Warning Count: $LFS_WARNING_COUNT"
	echo "############ End Section $LFS_SECTION ################################"
	echo 
}

function show_first_ten_errors_in_section_logs {
	CHAPTER=$1
	START_SECTION=$2
	END_SECTION=$3
	case $CHAPTER in
		"5") 
			ROOT_PATH=$LFS_MOUNT_DIR
			echo $ROOT_PATH
			;;
		"6")
			ROOT_PATH=""
			;;
		*)
			echo "*** FATAL ERROR - invalid chapter designation.  Check function call."
			exit
			;;
	esac
		
	  
	echo "*** Displaying first 10 errors from logs."
	for (( i=$START_SECTION ; i <= $END_SECTION ; i++ ))
	do
		echo "--> grep -n \" [Ee]rrors*:* \|^FAIL:\" $ROOT_PATH/build-logs/$CHAPTER.$i-* | head -n 10"
		grep -n " [Ee]rrors*:* \|^FAIL:" $ROOT_PATH/build-logs/$CHAPTER.$i-* | head -n 10
		echo ""
	done
}

function check_MD5_sums {
	echo "*** Checking MD5"
	if [ "$BLFS_SOURCE_MD5" == "$(md5sum ./$BLFS_SOURCE_FILE_NAME | cut -d' ' -f1)" ]; then
		echo "*** Stored MD5 Matches Computed MD5 From File"
	else
		echo "*** WARNING: The stored MD5 sum in the 'blfs-wget-list' does not match"
		echo "*** the computed MD5 from the downloaded version.  This may be because a "
		echo "*** new version was added in the 'blfs-wget-list' file and the MD5"
		echo "*** was not updated, or a new file was added at the source that differs"
		echo "*** from the previously computed MD5.  Proceed at caution."
		read -p "*** Do you want to continue [Yy]? " -n 1 -r
		echo
		  if [[ $REPLY =~ ^[Yy]$ ]]; then 
			echo "*** Continuing with mis-matching MD5 sums."
		  else 
			exit 16
		  fi	
	fi
}


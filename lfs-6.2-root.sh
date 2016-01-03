#!/bin/bash
echo ""
echo "### 6.2. Preparing Virtual Kernel File Systems (0.0 SBU - running as 'root')"
echo "### ================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.2
LFS_SOURCE_FILE_PREFIX=prepfilesystem
LFS_LOG_FILE=$LFS_MOUNT_DIR/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX.log

echo "*** Validating the environment."
check_user root
check_lfs_partition_mounted_and_swap_on

########## Begin LFS Chapter Content ##########

echo "*** 6.2. Preparing Virtual Kernel File Systems"  2>&1  | tee $LFS_LOG_FILE
			   
mkdir -pv $LFS_MOUNT_DIR/{dev,proc,sys,run}  \
			  &>> $LFS_LOG_FILE

echo "*** 6.2.1. Creating Initial Device Nodes" 2>&1  |  tee -a $LFS_LOG_FILE
  
mknod -m 600 $LFS_MOUNT_DIR/dev/console c 5 1 \
  &>> $LFS_LOG_FILE
  
mknod -m 666 $LFS_MOUNT_DIR/dev/null c 1 3 \
  &>> $LFS_LOG_FILE

### Ugh, be careful not to miss this or it will cause problems in 6.13
echo "*** 6.2.2. Mounting and Populating /dev" 2>&1  |  tee -a $LFS_LOG_FILE

mount -v --bind /dev $LFS_MOUNT_DIR/dev  \
  &>> $LFS_LOG_FILE

echo "*** 6.2.3. Mounting Virtual Kernel File Systems" 2>&1  |  tee -a $LFS_LOG_FILE
  
mount -vt devpts devpts $LFS_MOUNT_DIR/dev/pts  -o gid=5,mode=620 \
  &>> $LFS_LOG_FILE
  
mount -vt proc proc $LFS_MOUNT_DIR/proc  \
  &>> $LFS_LOG_FILE
  
mount -vt sysfs sysfs $LFS_MOUNT_DIR/sys \
  &>> $LFS_LOG_FILE
  
mount -vt tmpfs tmpfs $LFS_MOUNT_DIR/run \
  &>> $LFS_LOG_FILE

echo "*** 6.2.3. (part 2) Checking /dev/shm a symlink to /run/shm" \
  2>&1  |  tee -a $LFS_LOG_FILE
  
if [ -h $LFS_MOUNT_DIR/dev/shm ]; then 
  echo '*** creating shm directory'  2>&1  |  tee -a $LFS_LOG_FILE
  mkdir -pv $LFS_MOUNT_DIR/$(readlink $LFS_MOUNT_DIR/dev/shm)  &>> $LFS_LOG_FILE
fi

########## Chapter Clean-Up ##########

echo ""
show_build_errors $LFS_MOUNT_DIR
capture_file_list $LFS_MOUNT_DIR
chapter_footer

echo "*** You are now ready to run ch 6.4 (ch 6.3 is skipped):"
echo "*** --> ./lfs-6.4-root.sh"
echo ""

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit 0
fi

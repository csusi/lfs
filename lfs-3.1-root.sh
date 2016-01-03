#!/bin/bash
echo ""
echo '### 3.1. Introduction  ###'
echo "### ================================================================="

### This is a bit more involved than in the book.  If a backup exists then it
### copies over those files.  Otherwise it downloads them.  Afterwards MD5
### sums are checked. 

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root
check_lfs_partition_mounted_and_swap_on

########## Begin LFS Chapter Content ##########

### The code here extends on what is covered in 3.1 to first check if
### there is a backup of the sources saved locally so it doesn't need
### to go out and retrieve it every time. If not, it will retrieve 
### sources from what is specified in $LFS_SOURCES_LIST and check them.

if [ ! -d "$LFS_MOUNT_DIR/sources" ]; then
    echo "*** Creating Directory $LFS_MOUNT_DIR/sources."
 	  mkdir $LFS_MOUNT_DIR/sources
    chmod a+wt $LFS_MOUNT_DIR/sources	
fi

if [ -d $LFS_SOURCES_BACKUP_DIR ]; then
    echo "*** Counting Backup Source Files. "
    SourcesBackupCount=$(find $LFS_SOURCES_BACKUP_DIR -maxdepth 1 -type f | wc -l)
else 
    echo "*** Setting count of source files to 0. "
    SourcesBackupCount=0 
fi

echo "*** Number of files at $LFS_SOURCES_BACKUP_DIR: $SourcesBackupCount"
echo "*** Expected number of $LFS_SOURCES_BACKUP_DIR: $LFS_SOURCES_EXPECTED_COUNT"

if [ $SourcesBackupCount -eq $LFS_SOURCES_EXPECTED_COUNT ]; then
   echo "*** Copying Source Files From $LFS_SOURCES_BACKUP_DIR to $LFS_MOUNT_DIR/sources "
   cp -r $LFS_SOURCES_BACKUP_DIR/* $LFS_MOUNT_DIR/sources 
else
    echo "*** Retrieving Source Files ***"
    wget -nc $LFS_SOURCES_LIST -P $LFS_MOUNT_DIR/sources
    wget -nc $LFS_SOURCES_MD5_SUMS -P $LFS_MOUNT_DIR/sources
    wget -nc -i $LFS_MOUNT_DIR/sources/wget-list -P $LFS_MOUNT_DIR/sources
    
    # Backup sources somewhere so you don't have to download them again (see above)
    if [ ! -d "$LFS_SOURCES_BACKUP_DIR" ]; then
      echo "*** Creating Directory $LFS_SOURCES_BACKUP_DIR "
      mkdir -p $LFS_SOURCES_BACKUP_DIR	
    fi
    echo "*** Making backup copy of sources to $LFS_SOURCES_BACKUP_DIR "
    cp -r $LFS_MOUNT_DIR/sources/* $LFS_SOURCES_BACKUP_DIR 
fi


echo ""
echo "*** Verifying md5sums of sources"
pushd  $LFS_MOUNT_DIR/sources
md5sum -c $LFS_MOUNT_DIR/sources/md5sums
popd

echo ""
echo "**************************** STOP!!!!!!! ****************************"
echo "************* Verify the MD5 Sums Above Are All OK!! ****************"
echo ""
echo "########################## End Chapter 3.1 ##########################"
echo "You are now ready to run:"
echo "--> ./lfs-4.2-root.sh"
echo ""

exit 0

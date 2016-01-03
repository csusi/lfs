### Not test much.  Restore tools from backup
# to be run as root

# To start back at 6.0 fresh, on /mnt/lfs there should be just 
# /sources and /build-logs directory.  This copies over /tools from backup

# TODO: obviously this needs to be improved

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root
check_lfs_partition_mounted_and_swap_on


rm -rf /mnt/lfs/tools
cp -r /root/lfs-backup/tools /mnt/lfs/tools

cp -r /root/lfs-scripts $LFS_MOUNT_DIR/tools/lfs-scripts

chmod -R 755 /mnt/lfs/tools
#!/bin/bash
echo ""
echo "### 4.4. Setting Up the Environment (running as lfs)"
echo "### ================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user lfs
check_lfs_partition_mounted_and_swap_on

########## Begin LFS Chapter Content ##########
  
echo '*** Setting Up the Environment (running as lfs)'

cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

### TODO: There may be an error here, whee LFS is being hardcoded as /mnt/lfs and if the lfs-include.sh variable LFS_MOUNT_DIR differs, this could become an issue.
### But I am changing the config statement in lfs-5.4-lfs to use LFS_MOUNT_DIR instead, so the LFS variable may not be used elsewhere.  

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF

echo ""
echo "########################### End Chapter 4.4 ###########################"
echo "*** The err msg you get below about 'dircolors' is harmless and can be ignored."
echo "*** Run:"
echo "*** --> source ~/.bash_profile "
echo "*** --> ./lfs-5.3-lfs.sh"


### Note: Book has user validate environment here.  This is being done in 5.3,
### along with other validatations.

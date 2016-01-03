#!/tools/bin/bash
echo ""
echo "### 6.5. Creating Directories (0.0 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

### Bash does not exist in /bin/bash yet, not until symlink below.  So script
### Interpreter above (#!/tools/bin/bash)  is in a non-standard location

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.5
LFS_SOURCE_FILE_PREFIX=create-dirs
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX.log

echo "*** Validating the environment."
# check_user root     # whoami fails 
check_chroot_to_lfs_rootdir 

### Not in book, making the prompt a little more readable.
PS1='\[\033[1;31m\]\u\[\033[1;30m\]:\[\033[1;34m\]\w\[\033[1;30m\] \$ \e[m'

########## Begin LFS Chapter Content ##########

echo "*** Creating /bin /boot /etc /usr directories and sub directories."  2>&1 | tee $LFS_LOG_FILE
mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}  	&>> $LFS_LOG_FILE
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}							&>> $LFS_LOG_FILE
install -dv -m 0750 /root												&>> $LFS_LOG_FILE
install -dv -m 1777 /tmp /var/tmp										&>> $LFS_LOG_FILE
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}						&>> $LFS_LOG_FILE
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}			&>> $LFS_LOG_FILE
mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}					&>> $LFS_LOG_FILE
mkdir -v  /usr/libexec													&>> $LFS_LOG_FILE
mkdir -pv /usr/{,local/}share/man/man{1..8}                 			&>> $LFS_LOG_FILE



echo "*** Checking for x86_64 processor."                   2>&1 | tee -a $LFS_LOG_FILE
case $(uname -m) in
x86_64) ln -sv lib /lib64
  ln -sv lib /usr/lib64                                     &>> $LFS_LOG_FILE
  ln -sv lib /usr/local/lib64                               &>> $LFS_LOG_FILE
  ;;                            
esac

echo "*** Creating /var directory and sub directories."			2>&1 | tee -a $LFS_LOG_FILE
mkdir -v /var/{log,mail,spool}                              &>> $LFS_LOG_FILE
ln -sv /run /var/run                                        &>> $LFS_LOG_FILE
ln -sv /run/lock /var/lock                                  &>> $LFS_LOG_FILE 
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}    &>> $LFS_LOG_FILE

########## Chapter Clean-Up ##########

capture_file_list ""

echo "" 
echo "#################### End Chapter $LFS_SECTION #######################"
echo "*** You are now ready to run:"
echo "*** --> mv /tools/lfs /root/lfs ; cd /root/lfs ; ./lfs-6.6-chroot.sh"
echo ""

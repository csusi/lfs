#!/bin/bash
echo ""
echo '### 5.3. General Compilation Instructions (running as lfs)'
echo '### ======================================================'

### TODO: use -H, --dereference-command-line from ls to handle the symlinks below
### TODO: Add these as tests

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user lfs
check_lfs_partition_mounted_and_swap_on

### Per book, final checks that the host environment is correct.
### Do not be too concerned if dates do not match.

echo
echo 'lrwxrwxrwx 1 root root 9 Feb 14 20:21 /bin/sh -> /bin/bash'
ls -al /bin/sh 

echo  
echo 'lrwxrwxrwx 1 root root 21 Jan 30 16:11 /usr/bin/awk -> /etc/alternatives/awk'
ls -alh /usr/bin/awk

echo
echo 'lrwxrwxrwx 1 root root 13 Feb 17 11:48 /etc/alternatives/awk -> /usr/bin/gawk'
ls -alh /etc/alternatives/awk

echo
echo '-rwxr-xr-x 1 root root 427K Jul  2  2013 /usr/bin/gawk'
ls -alh /usr/bin/gawk

echo
echo 'lrwxrwxrwx 1 root root 22 Feb 14 19:59 /usr/bin/yacc -> /etc/alternatives/yacc'
ls -alh /usr/bin/yacc 


echo
echo 'lrwxrwxrwx 1 root root 19 Feb 14 19:59 /etc/alternatives/yacc -> /usr/bin/bison.yacc'
ls -alh /etc/alternatives/yacc 

echo
echo '-rwxr-xr-x 1 root root 41 Dec 17  2013 /usr/bin/bison.yacc'
ls -alh /usr/bin/bison.yacc

echo 
echo '############################## End Chapter 5.3 ##############################'
echo "*** You are now ready to run:"
echo "*** --> ./lfs-5.4-lfs.sh"
echo "***"
echo "*** Or run next 3 or 31 chapters in sequence:"
echo "*** --> ./lfs-5.4-to-5.7-lfs.sh"
echo "*** --> ./lfs-5.4-to-5.35-lfs.sh"
echo ""

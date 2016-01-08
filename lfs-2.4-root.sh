#!/bin/bash
echo ""
echo "### 2.4. Setting The $LFS Variable  (run as root) ###"
echo "### ================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root

########## Begin LFS Chapter Content ##########

### This is in the book, but commenting out because it is set using the lfs-include.sh file
### export LFS=/mnt/lfs

### Note: In prior versions of the book (7.6), this chapter set mount points which
### is now done in ch2.5.  Therefore this script essentially does nothing.

echo ""
echo "########################## End Chapter 2.4 ##########################"
echo "You are now ready to run:"
echo "--> ./lfs-2.5-root.sh"
echo ""

exit 0

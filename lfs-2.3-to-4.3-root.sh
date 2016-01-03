#!/bin/bash
echo ""
echo '### Linux From Scratch Ch 2.3 to 4.3 (run as root)'
echo "### ======================================================="
echo 

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root

./lfs-2.3-root.sh

./lfs-2.4-root.sh

./lfs-2.5-root.sh

./lfs-3.1-root.sh

./lfs-4.2-root.sh

./lfs-4.3-root.sh

echo ""
echo "########################## End Chapter 2.3 to 4.3 ##########################"
echo "*** STOP! Verify all files downloaded and MD5 sums check from Ch. 3.1"
echo "*** Then run:"
echo "*** --> su - lfs "
echo "*** --> cd lfs ; ./lfs-4.4-lfs.sh"
echo ""


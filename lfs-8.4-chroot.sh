#!/bin/bash
echo "### 8.4. Using GRUB (chrooted to lfs partition as 'root')"
echo "### ====================================================="
echo ""

echo "*** To keep the process simpler by not having to flip around HDDs "
echo "*** use the Host OSs instance of grub.  In the next section, after "
echo "*** the lsb-release file is created, we will run update-grub "
echo "*** and it should find the new LFS instance on the partition."
echo "***"
echo "*** When completed, run:"
echo "*** ---> ./lfs-9.1-chroot.sh"
echo ""
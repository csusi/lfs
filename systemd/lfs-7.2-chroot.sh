#!/bin/bash
echo ""
echo "### Systemd 7.2 Network Config (chrooted to lfs partition as 'root')"
echo "### ==================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.2
LFS_SOURCE_FILE_PREFIX=netconfig
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

########## Begin LFS Chapter Content ##########

echo "*** 7.2.1.1. Static IP Configuration "

### NOTE: If modifying this in the future, be careful not to re-add quotes around the 
### limit string EOF, otherwise it will no longer evaluate the shell env variables as desired.

cat > /etc/systemd/network/10-static-eth0.network << EOF
[Match]
Name=eth0

[Network]
Address=$LFS_IP_ADDR
Gateway=$LFS_IP_GATEWAY
DNS=$LFS_IP_NAMESERVER1
EOF

echo "*** 7.2.2. Creating the /etc/resolv.conf File "

cat > /etc/resolv.conf << EOF
# Begin /etc/resolv.conf

domain $LFS_IP_DOMAINNAME
nameserver $LFS_IP_NAMESERVER1
nameserver $LFS_IP_NAMESERVER2
 
# End /etc/resolv.conf
EOF

### When using systemd-networkd for network configuration, another daemon, systemd-resolved, is responsible for creating the /etc/resolv.conf file. It is, however, placed in a non-standard location 
ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf

echo "*** 7.2.3. Configuring the system hostname "

echo "$LFS_IP_HOSTNAME" > /etc/hostname

echo "*** 7.5.4. Creating /etc/hosts File"

cat > /etc/hosts << EOF
# Begin /etc/hosts (network card version)

127.0.0.1 localhost
::1  localhost

$LFS_IP_ADDR $LFS_IP_FQDN $LFS_IP_HOSTNAME

# End /etc/hosts (network card version)
EOF

########## Chapter Clean-Up ##########
echo ""
echo "*** Start  /etc/systemd/network/10-static-eth0.network"
cat /etc/systemd/network/10-static-eth0.network | tee $LFS_LOG_FILE-10-static-eth0.log
echo "*** End "

echo ""
echo "*** Start /etc/resolv.conf"
cat /etc/resolv.conf | tee $LFS_LOG_FILE-resolv.log
echo "*** End /etc/resolv.conf"


echo ""
echo "*** Start /etc/hostname"
cat /etc/hostname | tee $LFS_LOG_FILE-hostname.log
echo "*** End /etc/hostname"


echo ""
echo "*** Start /etc/hosts"
cat /etc/hosts | tee $LFS_LOG_FILE-hosts.log
echo "*** End /etc/hosts"


### There is no need to show errors as nothing is being written to build-logs.
#show_build_errors ""
capture_file_list "" 
chapter_footer
echo "--> ./lfs-7.3-chroot.sh"
echo ""


#if [ $LFS_ERROR_COUNT -ne 0 ]; then
#	exit 4
#else
	exit
#fi

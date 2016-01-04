#!/bin/bash
echo ""
echo "### 7.5. Network Config (chrooted to lfs partition as 'root')"
echo "### ==================================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=7.5
LFS_SOURCE_FILE_PREFIX=netconfig
LFS_BUILD_DIRECTORY=    # Leave empty if not needed
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

########## Begin LFS Chapter Content ##########

echo "*** 7.5.1. Creating /etc/sysconfig/ifconfig.eth0"

### NOTE: If modifying this in the future, be careful not to re-add quotes around the 
### limit string EOF, otherwise it will no longer evaluate the shell env variables as desired.

cd /etc/sysconfig/
cat > ifconfig.eth0 << EOF
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=$LFS_IP_ADDR
GATEWAY=$LFS_IP_GATEWAY
PREFIX=$LFS_IP_PREFIX
BROADCAST=$LFS_IP_BROADCAST
EOF

echo "*** 7.5.2. Creating /etc/resolv.conf"

cat > /etc/resolv.conf << EOF
# Begin /etc/resolv.conf
# domain <Your Domain Name>
 
nameserver $LFS_IP_NAMESERVER1
nameserver $LFS_IP_NAMESERVER2
 
# End /etc/resolv.conf
EOF

echo "*** 7.5.3. Creating /etc/hostname"

echo "$LFS_IP_HOSTNAME" > /etc/hostname

echo "*** 7.5.4. Creating /etc/hosts File"

cat > /etc/hosts << EOF
# Begin /etc/hosts (network card version)
127.0.0.1 localhost
10.0.0.217 $LFS_IP_FQDN $LFS_IP_HOSTNAME
# End /etc/hosts (network card version)
EOF

########## Chapter Clean-Up ##########
echo ""
echo "*** Start  /etc/sysconfig/ifconfig.eth0"
cat /etc/sysconfig/ifconfig.eth0 | tee $LFS_LOG_FILE-ifconfig-eth0.log
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
echo "--> ./lfs-7.6-chroot.sh"
echo ""


#if [ $LFS_ERROR_COUNT -ne 0 ]; then
#	exit 4
#else
	exit
#fi
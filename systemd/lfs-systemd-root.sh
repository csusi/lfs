#!/bin/bash 
echo "" 
echo "### Configure LFS to build SystemD ###"
echo "### ========================================================="

### Change the location of the wget-list and md5sum files with 
### Appropriate systemd packages
LFS_SYSTEMD_SOURCES_LIST=\"http://linuxfromscratch.org/lfs/downloads/7.8-systemd/wget-list\"
LFS_SYSTEMD_SOURCES_MD5_SUMS=\"http://linuxfromscratch.org/lfs/downloads/7.8-systemd/md5sums\"
LFS_SYSTEMD_EXPECTED_COUNT=79
sed -ri 's@(LFS_SOURCES_LIST=)[^=]*$@\1'"$LFS_SYSTEMD_SOURCES_LIST"'@' ../lfs-include.sh
sed -ri 's@(LFS_SOURCES_MD5_SUMS=)[^=]*$@\1'"$LFS_SYSTEMD_SOURCES_MD5_SUMS"'@' ../lfs-include.sh
sed -ri 's@(LFS_SOURCES_EXPECTED_COUNT=)[^=]*$@\1'"$LFS_SYSTEMD_EXPECTED_COUNT"'@' ../lfs-include.sh

### 6.6  
### Additional entries in /etc/passwd
### Additional entries in /etc/group
cp lfs-6.6-chroot.sh ..

### 6.9 - Glibc  
### Installs the systemd support files for nscd
### In /etc/nsswitch.conf, changes "hosts: files dns" to "hosts: files dns myhostname"
### Different way of making /etc/localtime file by running:
###   lfs: cp -v /usr/share/zoneinfo/$LFS_TIME_ZONE /etc/localtime 
###   lfsd: ln -sfv /usr/share/zoneinfo/<xxx> /etc/localtime
cp lfs-6.9-chroot.sh ..

			   
### 6.21 - Attr  & 6.22 - Acl
### Running 'configure' does not include the --bindir=/bin directive.  This is odd
### and it makes me think it's an over sight in the systemd instructions because
### it doesn't explain why.
cp lfs-6.21-chroot.sh .. 
cp lfs-6.22-chroot.sh .. 

### 6.25 - Shadow
### Different information about including cracklib.html 
### http://www.linuxfromscratch.org/blfs/view/systemd/postlfs/cracklib.html
		
### 6.29 - Coreutils
### Minor difference in text noting that programs head, sleep, nice,test
### need to be moved and why
			
### 6.48 - Findutils
### Minor difference in text noting that some need to be moved 
### "Some packages in BLFS and beyond expect the find program in /bin, so make sure it's placed there:"

### 6.63 - systemd (was sysklogd, depricated in systemd) 
cp lfs-6.63-chroot.sh ..
		
###	6.64 - d-bus (was sysvinit, depricated in systemd)
cp lfs-6.64-chroot.sh ..
		
###	6.65 - Util-linux (was tar, moved to 6.67)
### Tar: No changes necessary, can just rename file
### Util-Linux: Removes the --without-systemd directives when running 'configure'
mv ../lfs-6.65-chroot.sh ../lfs-6.67-chroot.sh
sed -ri 's@(LFS_SECTION=)[^=]*$@\16.67@' ../lfs-6.67-chroot.sh
cp lfs-6.65-chroot.sh ../lfs-6.65-chroot.sh 
		
###	6.66 - man-db (was texinfo, moved to 6.68)
### Texinfo: No changes necessary, can just rename file
### Man-db: Remove a reference to a non-existent user
mv ../lfs-6.66-chroot.sh ../lfs-6.68-chroot.sh
sed -ri 's@(LFS_SECTION=)[^=]*$@\16.68@' ../lfs-6.68-chroot.sh
cp lfs-6.66-chroot.sh ../lfs-6.66-chroot.sh
		
###	6.67 - tar (was Eudev, depricated in systemd)
### Script copied from 6.65 above

###	6.68 - texinfo (was util-linux, moved to 6.65)
### Script copied from 6.65 above
		
###	6.69 - VIM (was man-db, moved to 6.66)
### VIM: No changes necessary, can just rename file
mv ../lfs-6.70-chroot.sh ../lfs-6.69-chroot.sh
sed -ri 's@(LFS_SECTION=)[^=]*$@\16.69@' ../lfs-6.69-chroot.sh

###	6.70 - About Debugging (was VIM, moved to 6.69)
### This is basically an empty section.  
mv ../lfs-6.71-chroot.sh ../lfs-6.70-chroot.sh
sed -ri 's@(LFS_SECTION=)[^=]*$@\16.70@' ../lfs-6.70-chroot.sh

### 6.71 - Stripping (was About Debugging)
### Stripping: No changes necessary, can just rename file
mv ../lfs-6.72-chroot.sh ../lfs-6.71-chroot.sh
sed -ri 's@(LFS_SECTION=)[^=]*$@\16.71@' ../lfs-6.71-chroot.sh
			
### 6.72 - Clean-Up (was Stripping)
### Clean-Up: No changes necessary, can just rename file
mv ../lfs-6.73-chroot.sh ../lfs-6.72-chroot.sh	
sed -ri 's@(LFS_SECTION=)[^=]*$@\16.71@' ../lfs-6.71-chroot.sh			

### 6.73 - Nothing Here

### 7.2 - General Network Configuration - Similar to LFS 7.5
cp lfs-7.2-chroot.sh ..		

### 7.3 - Device and Module Handling on an LFS System 
cp lfs-7.3-chroot.sh ..
		
### 7.4 - Creating Custom Symlinks to Devices  
cp lfs-7.4-chroot.sh ..
		
### 7.5 - Configuring the system clock 
cp lfs-7.5-chroot.sh ..
		
### 7.6 - Configuring the Linux Console 
cp lfs-7.6-chroot.sh ..
			
### 7.7 - Configuring the System Locale 
cp lfs-7.7-chroot.sh ..
		
### 7.8 - Creating the /etc/inputrc File - Similar to LFS 7.8
### inputrc: No changes necessary

### 7.9 - Creating the /etc/shells File - Similar to LFS 7.9
### shells: No changes necessary
		
### 7.10 - Systemd Usage and Configuration 
cp lfs-7.10-chroot.sh ..

### 7.2-to-8.2 - Adds 7.10 in there		
cp lfs-7.2-to-8.2-chroot.sh ..

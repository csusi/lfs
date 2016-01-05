#!/bin/bash
echo ""
echo "### (BLFS) Tcl (1 SBU - chrooted to lfs partition as 'root')"
echo "### ====================================================================="

### http://www.linuxfromscratch.org/blfs/view/stable/general/tcl.html

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=9.4.30
LFS_SOURCE_FILE_PREFIX=tcl8.6.4    # There's another TCL earlier downloaded.  Gets around checking for more than one source tar by including version number.
LFS_BUILD_DIRECTORY=    
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX
echo "BLFS $LFS_SOURCE_FILE_PREFIX started on $(date -u)" >> /build-logs/0-milestones.log

# Ideally, will retrieve and md5 check in script but doing that
# For initial packages as root on host OS
# BLFS_SOURCE_FTP_FQDN=openssl.org
# BLFS_SOURCE_FTP_PATH=source
BLFS_SOURCE_FILE_NAME="$(grep -o "MD5=$LFS_SOURCE_FILE_PREFIX.*=[a-z0-9]*" ./blfs-wget-list | cut -d= -f2)"
BLFS_SOURCE_MD5="$(grep -o "MD5=$LFS_SOURCE_FILE_PREFIX.*=[a-z0-9]*" ./blfs-wget-list | cut -d= -f3)"

echo "*** BLFS_SOURCE_FILE_NAME=$BLFS_SOURCE_FILE_NAME"
echo "*** BLFS_SOURCE_MD5=$BLFS_SOURCE_MD5"

echo "*** Validating the environment."
check_user root
check_chroot_to_lfs_rootdir 

########## Extract Source and Change Directory ##########

cd /sources
test_only_one_tarball_exists
check_MD5_sums
extract_tarball ""
cd $(ls -d /sources/$LFS_SOURCE_FILE_PREFIX*/)

########## Begin LFS Chapter Content ##########

time {
	echo "*** Running Pre-Configuration Tasks ... $BLFS_SOURCE_FTP_FILE"
	### TODO: There is a component for extracting optional documentation
	### Not doing that for now.
	
	export SRCDIR=`pwd` 

	cd unix 
	
	echo "*** Running Configure ... $BLFS_SOURCE_FTP_FILE"
	./configure --prefix=/usr           \
            --mandir=/usr/share/man     \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit)  		&> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $BLFS_SOURCE_FTP_FILE"
	make $LFS_MAKE_FLAGS           			&> $LFS_LOG_FILE-make.log
	
	sed -e "s#$SRCDIR/unix#/usr/lib#" \
    -e "s#$SRCDIR#/usr/include#"  \
    -i tclConfig.sh               

	sed -e "s#$SRCDIR/unix/pkgs/tdbc1.0.3#/usr/lib/tdbc1.0.3#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.3/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/tdbc1.0.3/library#/usr/lib/tcl8.6#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.3#/usr/include#"            \
    -i pkgs/tdbc1.0.3/tdbcConfig.sh                        

	sed -e "s#$SRCDIR/unix/pkgs/itcl4.0.3#/usr/lib/itcl4.0.3#" \
    -e "s#$SRCDIR/pkgs/itcl4.0.3/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/itcl4.0.3#/usr/include#"            \
    -i pkgs/itcl4.0.3/itclConfig.sh                        
	
	unset SRCDIR
	
	echo "*** Running Make Test ... $BLFS_SOURCE_FTP_FILE"
	make $LFS_MAKE_FLAGS test    			&> $LFS_LOG_FILE-make-check.log

	echo "*** Running Make Install ... $BLFS_SOURCE_FTP_FILE"
	make install 							&> $LFS_LOG_FILE-make-install.log
	make install-private-headers 			&> $LFS_LOG_FILE-make-installheaders.log
	ln -v -sf tclsh8.6 /usr/bin/tclsh 		&> $LFS_LOG_FILE-link-tclsh.log
	chmod -v 755 /usr/lib/libtcl8.6.so		&> $LFS_LOG_FILE-chmod-tclshl.log

	echo "*** Performing Post-Make Tasks ... $BLFS_SOURCE_FTP_FILE"
	# Did not download optional docs so don't need this right now
	#mkdir -v -p /usr/share/doc/tcl-8.6.4 			&> $LFS_LOG_FILE-mkdirs.log
	#cp -v -r  ../html/* /usr/share/doc/tcl-8.6.4	&> $LFS_LOG_FILE-cpdocs.log

}


########## Chapter Clean-Up ##########

echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo "BLFS $LFS_SOURCE_FILE_PREFIX finished on $(date -u)" >> /build-logs/0-milestones.log
echo ""  >> /build-logs/0-milestones.log

show_build_errors ""
capture_file_list "" 
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

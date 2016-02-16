#!/bin/bash
echo ""
echo "### 6.9. Glibc-2.22 (18.9 SBU - chrooted to lfs partition as 'root')"
echo "### ========================================================================="

### TODO This is an oddball chapter than needs review
# clean up formating in 6.9.2
# Add in 6.9.3 or separate script

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=6.9
LFS_SOURCE_FILE_PREFIX=glibc
LFS_LOG_FILE=/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX
echo "Chapter $LFS_SECTION $LFS_SOURCE_FILE_PREFIX - Started on $(date -u)" >> /build-logs/0-milestones.log

echo "*** Validating the environment."
check_user root     
check_chroot_to_lfs_rootdir 

########## Extract Source and Change Directory ##########

cd /sources
test_only_one_tarball_exists
extract_tarball ""
cd $(ls -d /sources/$LFS_SOURCE_FILE_PREFIX*/)

########## Begin LFS Chapter Content ##########

time {
	
echo "*** Running Pre-Configuration Tasks ... $LFS_SOURCE_FILE_NAME"
patch -Np1 -i ../glibc-2.22-fhs-1.patch \
  &> $LFS_LOG_FILE-1-patch1.log
  
patch -Np1 -i ../glibc-2.22-upstream_i386_fix-1.patch \
  &> $LFS_LOG_FILE-2-patch2.log

mkdir -v build
cd       build

echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
../configure --prefix=/usr          \
   --disable-profile      \
   --enable-kernel=2.6.32 \
   --enable-obsolete-rpc  \
   &> $LFS_LOG_FILE-1-configure.log

echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
make $LFS_MAKE_FLAGS \
  &> $LFS_LOG_FILE-2-make.log

echo "*** Running Make Check ... $LFS_SOURCE_FILE_NAME"
make check $LFS_MAKE_FLAGS \
  &> $LFS_LOG_FILE-3-make-check.log

touch /etc/ld.so.conf

echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
make install $LFS_MAKE_FLAGS \
  &> $LFS_LOG_FILE-4-make-install.log

echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
cp -v ../glibc-2.22/nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd

mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030

echo "*** Running Make localedata  ... $LFS_SOURCE_FILE_NAME"
make localedata/install-locales \
  &> $LFS_LOG_FILE-5-make-locales.log

echo "*** 6.9.2. Configuring Glibc"
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tar -xf ../tzdata2015f.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO


cp -v /usr/share/zoneinfo/$LFS_TIME_ZONE /etc/localtime

echo "*** 6.9.3. Configuring the Dynamic Loader"

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF


cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF

mkdir -pv /etc/ld.so.conf.d

} 

########## Chapter Clean-Up ##########

echo ""
echo "*** Running Clean Up Tasks ... $LFS_SOURCE_FILE_NAME"
cd /sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d /sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo "Chapter $LFS_SECTION $LFS_SOURCE_FILE_PREFIX - Started on $(date -u)" >> /build-logs/0-milestones.log

echo ""
echo "*** Note: See book about common failures running Make Check.  Search build-log "
echo " 6.9-glibc-make-check.log on /^FAIL:/ as common errors that are probably "
echo " not critical include: elf/tst-protected1b, elf/tst-protected1b, "
echo " posix/tst-getaddrinfo4, posix/tst-getaddrinfo5, and others." 
show_build_errors ""
capture_file_list "" 
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

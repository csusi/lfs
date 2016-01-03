#!/bin/bash
echo ""
echo "### 5.5. GCC-5.2.0 - Pass 1  (7.4 SBU - running as 'lfs') ###"
echo "### ========================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=5.5
LFS_SOURCE_FILE_PREFIX=gcc
LFS_BUILD_DIRECTORY=gcc-build    # Leave empty if not needed
LFS_LOG_FILE=$LFS_MOUNT_DIR/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX
echo "Chapter $LFS_SECTION $LFS_SOURCE_FILE_PREFIX - Started on $(date -u)" >> /build-logs/0-milestones.log

echo "*** Validating the environment."
check_user lfs
check_lfs_partition_mounted_and_swap_on

########## Extract Source and Change Directory ##########

cd $LFS_MOUNT_DIR/sources
test_only_one_tarball_exists
extract_tarball $LFS_MOUNT_DIR
cd $(ls -d  $LFS_MOUNT_DIR/sources/$LFS_SOURCE_FILE_PREFIX*/)

########## Begin LFS Chapter Content ##########

time {

	echo "*** Running Pre-Configuration Tasks ... $LFS_SOURCE_FILE_NAME"
	tar -xf ../mpfr-3.1.3.tar.xz
	mv -v mpfr-3.1.3 mpfr					&> $LFS_LOG_FILE-mv-mpfr.log
	tar -xf ../gmp-6.0.0a.tar.xz
	mv -v gmp-6.0.0 gmp						&> $LFS_LOG_FILE-mv-gmp.log
	tar -xf ../mpc-1.0.3.tar.gz
	mv -v mpc-1.0.3 mpc						&> $LFS_LOG_FILE-mv-mpc.log
	
	# change the location of GCC's default dynamic linker to use the one installed in /tools
	for file in \
	 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
	do
	  cp -uv $file{,.orig}
	  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
	      -e 's@/usr@/tools@g' $file.orig > $file
	  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
	  touch $file.orig
	done
	
	sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure
	
	mkdir ../$LFS_BUILD_DIRECTORY
	cd ../$LFS_BUILD_DIRECTORY
	
	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	../gcc-5.2.0/configure                             \
    --target=$LFS_TGT                              \
    --prefix=/tools                                \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++                       \
		&> $LFS_LOG_FILE-configure.log
	
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make.log
	
	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-make-install.log
}

########## Chapter Clean-Up ##########

echo ""
echo "*** Cleaning Up ... $LFS_SOURCE_FILE_NAME"
cd $LFS_MOUNT_DIR/sources
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  $LFS_MOUNT_DIR/sources/$LFS_SOURCE_FILE_PREFIX*/)
rm -rf $LFS_BUILD_DIRECTORY

echo "Chapter $LFS_SECTION $LFS_SOURCE_FILE_PREFIX - Finished on $(date -u)" >> /build-logs/0-milestones.log

echo ""
echo "*** v7.8 Note: If there is an error for no include path for stdc-predef.h, it is probably harmless."
show_build_errors $LFS_MOUNT_DIR
capture_file_list $LFS_MOUNT_DIR
chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

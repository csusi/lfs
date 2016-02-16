#!/bin/bash
echo ""
echo "### 5.10. GCC-5.3.0 (10.8 SBU - running as 'lfs')"
echo "### ================================================"

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

LFS_SECTION=5.10
LFS_SOURCE_FILE_PREFIX=gcc
LFS_LOG_FILE=$LFS_MOUNT_DIR/build-logs/$LFS_SECTION-$LFS_SOURCE_FILE_PREFIX

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
	cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h


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

	tar -xf ../mpfr-3.1.3.tar.xz
	mv -v mpfr-3.1.3 mpfr					&> $LFS_LOG_FILE-1-mv-mpfr.log
	tar -xf ../gmp-6.1.0.tar.xz
	mv -v gmp-6.1.0 gmp						&> $LFS_LOG_FILE-2-mv-gmp.log
	tar -xf ../mpc-1.0.3.tar.gz
	mv -v mpc-1.0.3 mpc						&> $LFS_LOG_FILE-3-mv-mpc.log


	mkdir -v build
	cd build

	echo "*** Running Configure ... $LFS_SOURCE_FILE_NAME"
	CC=$LFS_TGT-gcc                                    \
	CXX=$LFS_TGT-g++                                   \
	AR=$LFS_TGT-ar                                     \
	RANLIB=$LFS_TGT-ranlib                             \
	../configure                                       \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp                              \
		&> $LFS_LOG_FILE-1-configure.log
		
	echo "*** Running Make ... $LFS_SOURCE_FILE_NAME"
	make $LFS_MAKE_FLAGS \
	  &> $LFS_LOG_FILE-2-make.log

	echo "*** Running Make Install ... $LFS_SOURCE_FILE_NAME"
	make install $LFS_MAKE_FLAGS    \
	  &> $LFS_LOG_FILE-3-make-install.log

	echo "*** Performing Post-Make Tasks ... $LFS_SOURCE_FILE_NAME"
	ln -sv gcc /tools/bin/cc \
	  &> $LFS_LOG_FILE-4-make-symlink-for-gcc.log
}

########## Chapter Clean-Up ##########

echo "*** Cleaning Up ... $LFS_SOURCE_FILE_NAME"
cd $LFS_MOUNT_DIR/sources
rm -rf $(ls -d  $LFS_MOUNT_DIR/sources/$LFS_SOURCE_FILE_PREFIX*/build)
[ ! $LFS_DO_NOT_DELETE_SOURCES_DIRECTORY ] && rm -rf $(ls -d  $LFS_MOUNT_DIR/sources/$LFS_SOURCE_FILE_PREFIX*/)


show_build_errors $LFS_MOUNT_DIR
capture_file_list $LFS_MOUNT_DIR

echo "************ STOP!!!!!!! ************"
echo "*** Verify the toolchain is working!! ***"
echo "*** Output should have no errors and be: "
echo "***   [Requesting program interpreter: /tools/lib/ld-linux.so.2] for 32bit"
echo "***   [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2] for 64bit"


echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools'

### Note: I've moved 'rm -v dummy.c a.out' to 5.11

chapter_footer

if [ $LFS_ERROR_COUNT -ne 0 ]; then
	exit 4
else
	exit
fi

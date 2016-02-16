#!/bin/bash
echo ""
echo "### 0 Host System Requirements Check (0.0 SBU - running as 'root')"
echo "### ==================================================="

if [ ! -f ./lfs-include.sh ];then
    echo "*** Fatal Error - './lfs-include.sh' not found." ; exit 8 ; fi
source ./lfs-include.sh

echo "*** Validating the environment."
check_user root
if [ $( readlink -f /bin/sh ) != "/bin/bash" ]; then 
  echo "*** Fatal Error - /bin/sh not symlinked to /bin/bash" ; exit 12 ; fi

cat > lfs-0-version-check-root.sh << "EOF"
#!/bin/bash
# Simple script to list version numbers of critical development tools
export LC_ALL=C
bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH

echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1

if [ -h /usr/bin/yacc ]; then
  echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
  echo yacc is `/usr/bin/yacc --version | head -n1`
else
  echo "yacc not found" 
fi

bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1

if [ -h /usr/bin/awk ]; then
  echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
  echo awk is `/usr/bin/awk --version | head -n1`
else 
  echo "awk not found" 
fi

gcc --version | head -n1
g++ --version | head -n1
ldd --version | head -n1 | cut -d" " -f2-  # glibc version
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1
xz --version | head -n1

echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
  then echo "g++ compilation OK";
  else echo "g++ compilation failed"; fi
rm -f dummy.c dummy
EOF

cat > lfs-0-library-check-root.sh << "EOF"
#!/bin/bash
for lib in lib{gmp,mpfr,mpc}.la; do
  echo $lib: $(if find /usr/lib* -name $lib|
               grep -q $lib;then :;else echo not;fi) found
done
unset lib
EOF

### Note: Yes, I realize that a copy of these two files are probably already present in the directory
### and did not need to be re-created in the above two 'cat' statements.  But, doing it this way made
### sense the first time.

echo ""
bash lfs-0-version-check-root.sh
echo ""
bash lfs-0-library-check-root.sh
echo ""

echo ""
echo "*************************** STOP!!!!!!! ***************************"
echo "********** Verify the versions above match book version!! *********"
echo ""
echo "########################## End Chapter 0 ##########################"
echo "*** You are now ready to run:"
echo "*** --> ./lfs-2.3-root.sh"
echo "***"
echo "*** Or run next 6 chapters in sequence:"
echo "*** --> ./lfs-2.3-to-4.3-root.sh"
echo ""

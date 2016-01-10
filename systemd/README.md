Linux From Shell - SystemD
==========================

This is a work in progress.  
STATUS: It builds and boots, but networking is off.  Will ping itself, not other machines.  Probably a minor config issue but am moving onto other things for now.   

Instructions
------------

Before running ./lfs-0-root.sh, run:

--> cd systemd ; ./lfs-systemd-root.sh ; cd ..


Differences
-----------

Adds Package - D-Bus  
Adds Package - Systemd  
Removes Package - Eudev  
Removes Package - LFS-Bootscripts  
Removes Package - Sysklogd  
Removes Package - Udev-lfs Tarball  

See comments in lfs-systemd-root.sh for more detailed explanation of
changes for each script.

Kernel Configuration 
--------------------

    General setup  --->  
      [*] open by fhandle syscalls [CONFIG_FHANDLE]  
      [ ] Auditing support [CONFIG_AUDIT]  
      [*] Control Group support [CONFIG_CGROUPS]  
    Processor type and features  --->  
      [*] Enable seccomp to safely compute untrusted bytecode [CONFIG_SECCOMP]  
    Networking support  --->  
      Networking options  --->  
        <*> The IPv6 protocol [CONFIG_IPV6]  
    Device Drivers  --->  
      Generic Driver Options  --->  
        [ ] Support for uevent helper [CONFIG_UEVENT_HELPER]  
        [*] Maintain a devtmpfs filesystem to mount at /dev [CONFIG_DEVTMPFS]  
        [ ] Fallback user-helper invocation for firmware loading [CONFIG_FW_LOADER_USER_HELPER]  
    Firmware Drivers  --->  
        [*] Export DMI identification via sysfs to userspace [CONFIG_DMIID]  
    File systems  --->  
      [*] Inotify support for userspace [CONFIG_INOTIFY_USER]  
      <*> Kernel automounter version 4 support (also supports v3) [CONFIG_AUTOFS4_FS]  
      Pseudo filesystems  --->  
        [*] Tmpfs POSIX Access Control Lists [CONFIG_TMPFS_POSIX_ACL]  
        [*] Tmpfs extended attributes [CONFIG_TMPFS_XATTR]  
			


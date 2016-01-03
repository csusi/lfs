Linux From Shell
================

A Linux From Scratch implementation (7.8) using basic shell scripts.

The purpose of this project is to:

0. Build Linux, from scratch
0. Speed up the process a little
0. Learn by doing and tinkering

The scripts will build a working LFS system, and some initial BLFS packages.  

Instructions:
--------------

0. Build a Linux Host.  See below for a tested VirtualBox instance, which is known to work.
0. Retrieve scripts.  
  --> sudo -i  
  --> cd /root ; git clone https://github.com/csusi/lfs.git  
  --> chmod 770 lfs ; cd lfs ; chmod 760 *  
 If working on a branch, change to branch (Only a master, not necessary at this time)  
 ~~--> git checkout -b rb7.8 origin/rb7.8~~  
0. Review and update the file 'lfs-include.sh'. Some changes may be required for local needs. Especially...

    $LFS_TIME_ZONE - sets the time zone for new LFS OS  
    $PAGE - Sets default page size for printing based on country standard  
    Local Networking Settings for Ch. 7.5   
        
0. Need to be root to start:    
  --> sudo -i  
  --> cd /root/lfs 

0. Build the LFS system starting below. Each script covers a section of the book, and are named in the following pattern:

        XXX-C.S-YYYY.sh    
          XXX - LFS book
          C - Chapter Number  
          S - Section Number  
          YYYY - User account the script should be run as.  
            root - Run as host OS root user at /root/lfs   
            lfs - Run as lfs user on hos os at /home/lfs/lfs  
            chroot - Run when chrooted into LFS mount point as root at /home/lfs/lfs (on LFS partition)  
         
  --> ./lfs-0-root.sh
 
The scripts lfs-8.3.1-root.sh & lfs-8.3.2-root.sh - The Kernel build is broken in two parts.  The reason for this is that the first half extracts the source files and runs 'make mrproper'.  The break is to create the .config file containing kernel compilation options, which is a necessary step prior to compiling the kernel.  The second script then performs the compile.

Other
-----

Pay attention for chapters that require to stop and validate output when requested.  Check the logs (in /mnt/lfs/build-logs) for errors.  There are some harmless errors that occur, so check notes in book and script if they are critical. And, may god have mercy on your soul.

Scripts will write substantial output to /mnt/lfs/build-logs.  Start here when troubleshooting.

While working in the bulk of chapter 5, the scripts are located at '/home/lfs/lfs' where  they are actually run by the 'lfs' user.  Similarly, in much of chapter 6, the chrooted 'root' user will be running the scripts from '$LFS_MOUNT_DIR/root/lfs'. Therefore, if any changes are made to the scripts located at '/root/lfs', they will need to be copied to the appropriate location for the 'lfs' or chrooted 'root' user in Ch 5 and 6.

If a script determines that a source code directory already exists from extracted source tar, it will not re-extract the contents.  Likewise, at the end of the compilation the scripts will not delete a source directory it found earlier.  This is so the user can extract the source on their own, play around inside the source, and not have to worry about the scripts deleting their work.  Similarly, in 8.3.1 and 8.3.2, when the kernel is compiled, 8.3.1 will not overwrite and already extracted source, and 8.3.2 will never delete the source directory once it is created.    

Batch scripts are included to run build multiple chapters sequentially.  Use when familiar with, and comfortable chapters will compile correctly.
        
The last script from the book is 'lfs-9.3-unmount-and-reboot.sh'.  The scripts labeled as 9.4.# will build BLFS packages to get the process started.  Once your LFS boots, read below to run this and begin the process by compiling some additional critical components while in the host system.
   
Returning after rebooting Host OS
---------------------------------

If shutting down the Host OS, perform the following steps on rebooting.

    After Chapter 5 is complete:
        --> sudo -i
        --> cd /root/lfs
        --> ./lfs-remount-root.sh
        
    After Chapter 6 is complete (or to chroot to LFS when system is complete):
        --> sudo -i
        --> cd /root/lfs
        --> ./lfs-remount-root.sh
        --> ./lfs-chroot-root.sh 
                  
Tested Host OS  
--------------

    Linux Mint v17.2 xfce 64-bit in VirtualBox v5.0.12.  
        Create Virtual Machine...  
            Name: mint17.2-xfce-64b-lfs (Type: Linux; Version: Ubuntu 64-bit)  
            Memory: 2 GB RAM  
            Create a virtual hard disk now...  
                VDI(VirtualBox Disk Image)  
                Dynamically Allocated  
                Name: mint17.2-xfce-64b-lfs-sda  
                Size: 20 GB   
            Additional Settings...  
                General-> Advanced -> Shared Clipboard -> Bidirectional  (for convenience)  
                General-> Advanced -> Drag'n'Drop -> BiDirectional (for convenience)  
                System -> Motherboard -> Chipset -> PIIX3   
                System -> Motherboard -> Pointing Device -> USB Tablet  
                System -> Motherboard -> Extended Features -> Enable I/O APIC   
                System -> Motherboard -> Extended Features -> Disable EFI   
                System -> Motherboard -> Extended Features -> Enable Hardware Clock in UTC Time   
                System -> Processor -> 4 CPUs (NOT DEFAULT SETTING)  
                System -> Processor -> Execution Cap 100%   
                System -> Processor -> Disable Enable PAE/NX   
                System -> Acceleration -> Paravirtualization Interface -> Default   
                System -> Acceleration -> Enable VT-x/AMD-v   
                System -> Acceleration -> Enable Nested Paging   
                Display -> Screen -> Video Memory -> 128 MB (NOT DEFAULT SETTING)  
                Display -> Screen -> Monitor Count -> 1  
                Display -> Screen -> Scale Factor -> 100%   
                Display -> Screen -> Acceleration -> Enable 3D Acceleration (NOT DEFAULT SETTING)  
                Display -> Screen -> Enable 2D Video Acceleration   
                Display -> Remote Display -> Disabled   
                Display -> Video Capture -> Disabled   
                Storage -> Select Empty Optical Disk ->   
                    Choose Optical Disk File... -> F:\ISOs\Linux-Distros\linuxmint-17.2-xfce-64bit.iso  
                Storage -> Select Controller SATA (where other HDD is) ->  
                    Add New Storage Attachment -> Add Hard Disk -> Create New Disk ->   
                    VDI(VirtualBox Disk Image)  
                    Dynamically Allocated  
                    Name: mint17.2-xfce-64b-lfs-sdb  
                    Size: 10 GB  (This will be your new Linux system, allocate larger if desired)  
                Network -> Adapter 1 -> Enable Network Adapter   
                Network -> Adapter 1 -> Attached to -> Bridged Adaptor (NOT DEFAULT SETTING)  
        Install Linux Mint (This is the LFS host system)  
            Language: English (or desired language)  
            Installation Type: Something Else  
                Create New Partition Table on /dev/sda  
                Use /dev/sda free space to create swap partition   
                    2048 MB (RAM size or as desired), Primary Partition   
                    Locate at beginning of space, use as: swap area  
                Use /dev/sda free space to create main system partition   
                    19427 MB (or remainder of space), Primary Partition   
                    Start at begining of this space, Ext4, Mount point: "/"  
                (Note: Create alternative partitions for host as desired on   
                  /dev/sda only.  /dev/sdb will be used for the new Linux OS.)  
                Boot loader installation: /dev/sda  
                Install Now...  
                Set as needed: Location, Keyboard Layout, User ID, Computer Name  
                    Who are you? -> Log in automatically -> Enable (for convenience)  
        Boot Linux Instance  
        In VirtualBox Guest Window -> Devices -> Insert Guest Additions CD Image...  
        Install VirtualBox Guest Tools  
            Open Terminal   
            /media/css/VBOXADDITIONS_5.0.12_104815  (or location)  
            Purge existing tools: sudo apt-get purge virtualbox*   (probably 3 to remove)  
            Install VirtualBox Linux Additions: sudo bash ./VBoxLinuxAdditions.run  
            Close terminal window  
            In File Manager (click on Home on desktop) eject the VirtualBox CD  
        Restart Linux Instance  
        Open terminal window, verify VBox Additions: dmesg | egrep -i 'virtualbox|vbox'   
        Start -> System -> Screensaver -> Mode: Disable (waste of CPU when compiling)  
        Optional: Shut down & copy VM for fresh host OS install.    
        sudo apt-get install git -y     # Or if this is how you want to transfer scripts over  
        Configure git  
            git config --global user.name "me"  
            git config --global user.email "me@here.com"  
            su  # To keep git settings consistent between local user and root  
            git config --global user.name "me"  
            git config --global user.email "me@here.com"         
        sudo ln -sf /bin/bash /bin/sh        # Host system requirement for LFS              
        sudo apt-get install build-essential -y   # Critical for compiling source  
        sudo apt-get install -y ncurses-dev    
            # Note: In LFS 7.6 this was critical for ch6.70 or will get   
            # "Checking for tgetent() ... NOT FOUND!" when running configure.   
            # Not tested without installing in a lfs7.8 build and beyond, just   
            # so installing it anyhow to ensure it's present.  
        sudo apt-get install -y texinfo    # Installes makeinfo requirement  
        sudo apt-get update  
        sudo apt-get upgrade  
        Install a text editor you really like:   
            sudo apt-get install geany -y  
        Allow your GUI login to access & update contents of /root (where script files will be)  
            sudo usermod -a -G root <<GUI Login>>  
            sudo chmod -R 770 /root       
        Optional: Install a graphical partition editor: sudo apt-get install gparted -y    
        Configure LFS Virtual HDD (This follows book 2.2. Creating a New Partition)  
            Assuming this is a second virtual HDD (15 GB), configured as SCSI in VMWare  
            or SATA in VirtualBox.  Using cfdisk or disk partition program of choice:        
                sdb1 - Not Boot - Primary - Linux swap (82) - 1x RAM or as desired (2GB VM=2048)  
                sdb2 - Boot - Primary - linux (83) - Rest of HDD  
        Shut down & copy VM for fresh prepped host OS.   
        
Kernel Configuration for 'make menuconfig'
------------------------------------------

    For a VirtualBox guest instance, inside menuconfig make the following changes.
    Be sure to select built-in (*) and not module (M):
        - Device Drivers, Generic Driver Option, DISABLE support for uevent helper
        - Device Drivers, Generic Driver Option, Maintain a devtmpfs filesystem to mount at /dev
    
    For a VMWare guest instance, inside menuconfig make the following changes.
    Be sure to select built-in (*) and not module (M):
        - Device Drivers, Generic Driver Option, DISABLE support for uevent helper
        - Device Drivers, Generic Driver Option, Maintain a devtmpfs filesystem to mount at /dev
        - Device Drivers, SCSI device support, SCSI low-level drivers Enabled
        - Device Drivers, SCSI device support, SCSI low-level drivers, VMWare PVSCSI Enabled
        - Device Drivers, Fusion MPT device support Enabled
        - Device Drivers, Fusion MPT device support --> Fusion MTP ScsiHost SPI Enabled
        - Device Drivers, Fusion MPT device support --> Fusion MTP ScsiHost SAS Enabled
        - Device Drivers, Network device support, ethernet driver support, AMD PCnet32 PCI support
        - File System, Ext3 Journaling file system support

Exit Return Codes
-----------------

(Expected to do more with this for running in batches):

    1
    2   Fatal - No tarballs found    
    3   Fatal - multiple tarballs found 
    4
    5   Fatal - Not running as 'lfs'
    6   Fatal - Not running as 'root' 
    7   Fatal - $LFS_ROOT_PARTITION Not Mounted
    8   Fatal - lfs-global-variables.sh not found
    9   Fatal - lfs-global-header.sh not found
    10  Fatal - lfs-global-variables.sh not found
    11  Fatal - $LFS_SWAP_PARTITION Swap not on
    12  Fatal - 'spawn ls' failed - lfs-6.13-root.sh
    13  Fatal - /bin/sh not linked to /bin/bash - lfs-0-root.sh
    14  Fatal - Not chrooted to LFS root dir
    15  Fatal - MD5 did not match computed. User exited.
    
    127 Non-Fatal - lfs-6.x-script-footer.sh not found 
    4   Non-Fatal - Error count in logs > 0, advised to review before proceeding.

TODO
----

    In addition to any TODO still in the scripts...
    
    Might want to get rid of those very long batch sets.  Esp since I think one that 
    includes Ch 6 'Adjusting the tool chain' is causing post builds to fail.

    lfs-6.0-restore-tools-from-backup-root.sh - Needs to be cleaned up and tested.
    
    Beyond Linux From Scratch - Scripts lfs-9.4.X and in the BLFS are, as of this
    writing, being worked on.  
    
    Review error code numbering scheme, and possibly include error code checks
    in section batch scripts.
    
    Create a version for SystemD
	
Beyond Linux From Scratch Preparation
--------------------------------------

Because the basic LFS installation is very limited, this 9.4 section includes
builds for additional tools like openssl, wget, and git to facilitate building
the Beyond Linux From Scratch components when booted into our new LFS instance.

See the blfs-wget-list file for details of what each section builds.

     --> ./lfs-9.4.1-root.sh  
     --> ./lfs-chroot-root.sh
     --> ./lfs-9.4.2-chroot.sh  
     And keep installing packages in rest of Ch. Section.
	
	  

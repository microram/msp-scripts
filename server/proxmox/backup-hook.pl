#!/usr/bin/perl -w

# Proxmox removeable media backup script. Schedule using STOP mode. zfs-snapshots not supported. 

# Place this script in /usr/local/bin/backup-hook.pl
# Install command: echo "script: /usr/local/bin/backup-hook.pl" >> /etc/vzdump.conf 
# requires: gpg pks keys (gpg-keygen) for encryption. Set $recipient and enable $encryption=1
# requires: usbmount (apt-get install usbmount)

use strict;
use File::Basename;

## Set these user variables before use 
my $removable = "/media/usb/dump/";
my $mediatest = "/media/usb/lost+found/"; #Check for presence of removable media mounted. 
my $encrypted = 1;
my $recipient = "Test User"; #gpg private key full name
my $debuglog = 0;
my $phase = shift;

if ($phase eq 'job-start' || 
    $phase eq 'job-end'  || 
    $phase eq 'job-abort') { 

    my $dumpdir = $ENV{DUMPDIR};
    my $storeid = $ENV{STOREID};

    if ($debuglog) { print "HOOK-ENV: phase=$phase;dumpdir=$dumpdir;storeid=$storeid\n"; }

} elsif ($phase eq 'backup-start' || 
	 $phase eq 'backup-end' ||
	 $phase eq 'backup-abort' || 
	 $phase eq 'log-end' || 
	 $phase eq 'pre-stop' ||
	 $phase eq 'pre-restart' ||
         $phase eq 'post-restart') {

    my $mode = shift; # stop/suspend/snapshot
    my $vmid = shift;
    my $vmtype = $ENV{VMTYPE}; # openvz/qemu
    my $dumpdir = $ENV{DUMPDIR};
    my $storeid = $ENV{STOREID};
    my $hostname = $ENV{HOSTNAME};
    my $tarfile = $ENV{TARFILE}; # tarfile fullpath available starting in phase 'backup-start'
    my $filename = basename($tarfile); 
    my $logfile = $ENV{LOGFILE}; # logfile is only available in phase 'log-end'

    if ($debuglog) { print "HOOK-ENV: phase=$phase;dumpdir=$dumpdir;storeid=$storeid\n"; }

    if ($phase eq 'post-restart' &&  $mode eq 'stop') {

	## Check for removable media by presence of lost+found folder EXT2/3/4
	system ("[ -d ".$mediatest." ]") == 0 ||
	    die "Removable media not mounted. Skipping USB copy.";

        # Remove older backups from removeable media
        system ("rm -f -v " . $removable . "vzdump-$vmtype-$vmid-*");

	if ($encrypted) {

	    ## Encrypt using gpg. Set recipient variable above. 
            system ("gpg2 -v --batch --encrypt --compress-algo none --recipient '$recipient' --output $tarfile.gpg $tarfile") == 0 ||
                die "Error encryption failed.";

	    # Copy encrypted to removable. Do not die on failure to ensure cleanup
	    system ("rsync -av --stats $tarfile.gpg $removable") == 0 ||
                print "Error copy to removable media failed.";

            # Always remove temp encrypted file
	    system ("rm -f -v $tarfile.gpg");

	} else {

	    # Non-encrpyted copy to removable
            system ("cp -v $tarfile $removable") == 0 ||
                die "Error copy backup file to removable media failed.";

	}

	# Print directory listing to log 
	print "Removable media folder ".$removable;
	system ("ls -lh $removable");
    }

} else {

    die "got unknown phase '$phase'";

}

exit (0);

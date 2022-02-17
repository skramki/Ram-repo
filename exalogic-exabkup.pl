#!/usr/bin/perl
#Exalogic Backup Script

use Getopt::Long;
use lib '/u01/common/exalogic_backup/swscripts/lib/';
use SWRUN;
use SWCommon;
use Data::Dumper;
use Net::SMTP;

# Targets can be specified by listing the comma-separated IPs or hostnames or by using one of the predefined targets:

###########START: Global Parameters #####################
$| = 1;
$SCRIPT_PATH = "/u01/common/exalogic_backup/swscripts";
#$REPOSITORY_PATH = "/u01/common/exalogic_backup/exalogic-lctools.1.1";
#$EXABR_BIN = $REPOSITORY_PATH . "/bin/exabr";
#$EXABR_BIN_CMD = "$EXABR_BIN -r $REPOSITORY_PATH";
#$EXABR_BIN_CMD = "/exalogic-lctools/bin/exabr";
$REPOSITORY_PATH = "/u01/common/exalogic_backup";
$EXABR_BIN = "/exalogic-lctools/bin/exabr";
$EXABR_BIN_CMD = "$EXABR_BIN -r $REPOSITORY_PATH";
$EXABR_ALL_HW = "$EXABR_BIN_CMD backup all-hw";
$EXABR_ALL_vServers = "$EXABR_BIN_CMD backup all-itemized-vms";
$EXABR_STOP_CONTROLL_STACK = "$EXABR_BIN_CMD stop control-stack";
$EXABR_START_CONTROLL_STACK = "$EXABR_BIN_CMD start control-stack";
$EXABR_BACKUP_CONTROLL_STACK = "$EXABR_BIN_CMD backup control-stack";
$EMAIL_TO='skramki@gmail.com';
$SMTP_GW = "smtp.gmail.com";

$HOSTNAME = `hostname`;
chomp $HOSTNAME;

$EMAIL_FROM='norespond@' . $HOSTNAME;

###########END: Global Parameters #####################


#  all-ib (all Infiniband switches), all-mgmt (all management (Cisco) switches), all-cn (all compute nodes and their ILOMs),
#  all-sn (all storage nodes and their ILOMs), all-hw (all the hardware components), control-stack, user-vm (zfs snapshot)
#  or all-itemized-vms (all user-vservers listed in the configuration file)

$commands_return_code = 0;


#$run_command = new SWRUN();
$filename = SWCommon::get_script_name($0);
$run_command = new SWRUN($SCRIPT_PATH . "/" . $filename . ".log");



sub usage{
        print "This program backs up the exalogic datacenter\n";
        print "Unknown option: @_\n" if ( @_ );
        print "usage: $0 [OPTION]\n";
        print "\t\tOption (Only 1 option can be specified at a time)\n";
        print "\t\t-all\t\tBackup ALL Hardware Components, vServers and Control Stack <NOT WORKING!!!>\n";
        print "\t\t-hw\t\tBackup ALL Hardware Components (ILOMS, Compute Nodes, Switches, Storage Node Configs. <NOT WORKING!!!>\n";
        print "\t\t-vs\t\tBackup ALL vServers that are specified in exabr.config.\n";
        print "\t\t-cs\t\tBackup Control Stack.\n";
        exit(1);
}

sub email_message{
        my $to = shift(@_);
        my $from = shift(@_);
        my $subject = shift(@_);
        my $message = shift(@_);

        #print "HOSTNAME: $HOSTNAME\n";

        my $smtp = Net::SMTP->new("$SMTP_GW", Hello => $HOSTNAME, Timeout => 60,Debug   => 0) or die  $run_command->write_to_log("Could not connect to SMTP server: $SMTP_GW");
        #my $smtp = Net::SMTP->new("$SMTP_GW", Timeout => 60) or die "Could not connect to SMTP server: $SMTP_GW";
        $smtp->mail( $from );
        $smtp->to( $to );
        $smtp->data();
        $smtp->datasend("To: $to\n");
        $smtp->datasend("From: $from\n");
        $smtp->datasend("Subject: $subject\n");
        $smtp->datasend("\n"); # done with header
        $smtp->datasend($message);
        $smtp->dataend();
        $smtp->quit;


}



### MAIN ###
$commands_return_code = 0;
$mail_buffer = "";
#email_message($EMAIL_TO,$EMAIL_FROM,"test","test");
#exit(1);

if((@ARGV != 1) || ! GetOptions('help|?' => \$help_opt, 'all' => \$all_opt, 'hw'=>\$hw_opt,'vs'=>\$vs_opt,'cs'=>\$cs_opt) or defined $help){
        usage();
}

$run_command->write_to_log("###########################START $0 ##################################\n");

if($all_opt){  #not working
        print "This module is a work in progress.\n";
        $run_command->write_to_log("EXABR_ALL module is a work in progress\n");
        exit(1);
        #Backup All Hardway components
        print "Running: $EXABR_ALL_HW\n";
        $run_command->write_to_log("Running: $EXABR_ALL_HW\n");
        $commands_return_code += $run_command->run_and_log_output($EXABR_ALL_HW);

        #Backup ALL vServers
        print "Running: $EXABR_ALL_vServers\n";
        $run_command->write_to_log("Running: $EXABR_ALL_vServers\n");
        $commands_return_code += $run_command->run_and_log_output($EXABR_ALL_vServers);

        #Backup Control Stack
        #1. Stock Control Stack
        print "Running: $EXABR_STOP_CONTROLL_STACK\n";
        $run_command->write_to_log("Running: $EXABR_STOP_CONTROLL_STACK\n");
        $commands_return_code += $run_command->run_and_log_output($EXABR_STOP_CONTROLL_STACK);

        #2. Backup Control Stack
        print "Running: $EXABR_BACKUP_CONTROLL_STACK\n";
        $run_command->write_to_log("Running: $EXABR_BACKUP_CONTROLL_STACK\n");
        $commands_return_code += $run_command->run_and_log_output($EXABR_BACKUP_CONTROLL_STACK);


        #3. Start Control Stack
        print "Running: $EXABR_START_CONTROLL_STACK\n";
        $run_command->write_to_log("Running: $EXABR_START_CONTROLL_STACK\n");
        $commands_return_code += $run_command->run_and_log_output($EXABR_START_CONTROLL_STACK);
}
elsif($hw_opt){ #not working
        print "This module is a work in progress.\n";
        $run_command->write_to_log("EXABR_ALL_HW module is a work in progress\n");
        exit(1);

        #Backup All Hardway components
        print "Running: $EXABR_ALL_HW\n";
        $run_command->write_to_log("Running: $EXABR_ALL_HW\n");
        $commands_return_code += $run_command->run_and_log_output($EXABR_ALL_HW);
}
elsif($vs_opt){
        #Backup ALL vServers
        my $tmp_return = 0;
        print "Backing up all itemized vServers\n";
        $mail_buffer .= "Backing up all itemized vServers on $HOSTNAME\n";
        $run_command->write_to_log("Backing up all itemized vServers\n");

        print "----------------------------------------------\n";
        $mail_buffer .= "----------------------------------------------\n";
        $run_command->write_to_log("----------------------------------------------\n");

        print "Please be patient, backing up all the itemized vServers will take time\n";

        #$run_command->write_to_log("Running: $EXABR_ALL_vServers\n");
        #$mail_buffer .= "Running: $EXABR_ALL_vServers\n";
        $run_command->write_to_log("Backing up all itemized vServers\n");
        $mail_buffer .= "Backing up all itemized vServers\n";

        $commands_return_code += $run_command->run_and_log_output($EXABR_ALL_vServers);
}
elsif($cs_opt){
        my $tmp_return = 0;
        #Backup Control Stack
        print "Backing up the Exalogic Control Stack\n";
        $mail_buffer .= "Backing up the Exalogic Control Stack on $HOSTNAME\n";
        $run_command->write_to_log("Backing up the Exalogic Control Stack\n");

        print "----------------------------------------------\n";
        $mail_buffer .= "----------------------------------------------\n";
        $run_command->write_to_log("----------------------------------------------\n");

        #1. Stop Control Stack
        print "1. Stopping the Exalogic Control Stack...";
        $mail_buffer .= "1. Stopping the Exalogic Control Stack...";
        $run_command->write_to_log("1. Stopping the Exalogic Control Stack\n");

        $tmp_return = $run_command->run_and_log_output($EXABR_STOP_CONTROLL_STACK);

        if($tmp_return == 0){
                print "<OK>\n";
                $mail_buffer .= "<OK>\n";

        }
        else{

                print "<FAILED>\n";
                $mail_buffer .= "<FAILED>\n";

        }
        $commands_return_code += $tmp_return;

        #2. Backup Control Stack
        print "2. Backing Up the Exalogic Control Stack...";
        $mail_buffer .= "2. Backing Up the Exalogic Control Stack...";
        $run_command->write_to_log("2. Backing Up the Exalogic Control Stack\n");

        $tmp_return = $run_command->run_and_log_output($EXABR_BACKUP_CONTROLL_STACK);

        if($tmp_return == 0){
                print "<OK>\n";
                $mail_buffer .= "<OK>\n";

        }
        else{

                print "<FAILED>\n";
                $mail_buffer .= "<FAILED>\n";

        }
        $commands_return_code += $tmp_return;


        #3. Start Control Stack
        print "3. Starting the Exalogic Control Stack...";
        $mail_buffer .= "3. Starting the Exalogic Control Stack...";
        $run_command->write_to_log("3. Starting the Exalogic Control Stack\n");

        $tmp_return = $run_command->run_and_log_output($EXABR_START_CONTROLL_STACK);
        if($tmp_return == 0){
                print "<OK>\n";
                $mail_buffer .= "<OK>\n";

        }
        else{

                print "<FAILED>\n";
                $mail_buffer .= "<FAILED>\n";

        }
        $commands_return_code += $tmp_return;
}
else{
        usage();
}

print "----------------------------------------------\n";
$mail_buffer .= "----------------------------------------------\n";
$run_command->write_to_log("----------------------------------------------\n");

if($commands_return_code == 0){
        print "Backup SUCCESSFUL!\nPlease check log file(". $run_command->get_log_path() . ") for more information\n";
        $mail_buffer .= "Backup SUCCESSFUL!\nPlease check log file(". $run_command->get_log_path() . ") for more information\n";
        $run_command->write_to_log("Emailing Status\n");
        email_message($EMAIL_TO,$EMAIL_FROM,"Backup Successful on  $HOSTNAME",$mail_buffer);
        $run_command->write_to_log("###########################END $0 ##################################\n");
        exit(0);
}
else{
        print "Backup FAILED!\nPlease check log file(". $run_command->get_log_path() . ") for more information\n";
        $mail_buffer .= "Backup FAILED!\nPlease check log file(". $run_command->get_log_path() . " for more information\n";
        $run_command->write_to_log("Emailing Status..\n");
        email_message($EMAIL_TO,$EMAIL_FROM,"Backup Failed on  $HOSTNAME",$mail_buffer);
        $run_command->write_to_log("###########################END $0 ##################################\n");
        exit(1);
}

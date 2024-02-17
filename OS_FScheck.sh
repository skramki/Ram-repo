#!/bin/bash
i=`cat /root/server.lst`
HST1="$i"

for i in $HST1; do ssh $i "hostname; df -Ph /" |grep -v Filesystem; done > /root/scripts/VSvrFSChk/OSW_FSCheck1
sed 'N;s/\n/ /' /root/scripts/VSvrFSChk/OSW_FSCheck1 > /root/scripts/VSvrFSChk/OSW_FSCheck
cat /root/scripts/VSvrFSChk/OSW_FSCheck| awk '{ print $6 " " $1 }' | while read output;
do
echo $output
usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1 )
partition=$(echo $output | awk '{ print $2 }' )
if [ $usep -ge 90 ]; then
echo ""Running out of space \""$partition ($usep%)\"" ""
fi
done > /root/scripts/VSvrFSChk/output.txt
## Final Data Collection and mail Segment ###
rm -f /root/scripts/VSvrFSChk/final_out.log
for i in `grep Running /root/scripts/VSvrFSChk/output.txt | awk '{ print $1 }' `
do
if [ "$i" == "Running" ]
then
F_FILE=`cat /root/scripts/VSvrFSChk/output.txt | egrep -w Running > /root/scripts/VSvrFSChk/final_out.log`
else
echo "All Fine"
fi
done

###!/usr/bin/perl
use Net::SMTP;
###########START: Global Parameters #####################
#$| = 1;
$EMAIL_TO='skramki@gmail.com';
$SMTP_GW = "smtp.gmail.com";

$HOSTNAME = `hostname`;
chomp $HOSTNAME;

$EMAIL_FROM='FSCheck@' . $HOSTNAME;



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
##$mail_buffer .= `cat /root/scripts/VSvrFSChk/final_out.log`;
##email_message($EMAIL_TO,$EMAIL_FROM,"FSCheck  on  $HOSTNAME",$mail_buffer)
$filename = '/root/scripts/VSvrFSChk/final_out.log';
if (-e $filename) {
$mail_buffer .= `cat /root/scripts/VSvrFSChk/final_out.log`;
email_message($EMAIL_TO,$EMAIL_FROM,"FSCheck  on  $HOSTNAME",$mail_buffer);
}
### sendmail not installed in Compute Node hence using perl script for sending mail ###
#/root/scripts/VSvrFSChk/mailtoest.sh

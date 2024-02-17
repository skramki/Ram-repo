#!/bin/ksh

MAILTO="skramki@gmail.com"
CONTENT="/root/StorageCellMonitoring.log"
SUBJECT="`hostname`-Cell-Server-Report"


echo "######## USED MEMORY PERCENTAGE ########" > /root/StorageCellMonitoring.log
for i in `cat /root/cell_group`; do ssh $i hostname; ssh $i free | grep Mem | awk '{ print "Mem "($3/$2)*100" %" }';done >> /root/StorageCellMonitoring.log
echo "######## OP of MEMINFO #########" >> /root/StorageCellMonitoring.log
/usr/local/bin/dcli -l root -g cell_group "cat /proc/meminfo"|egrep -i 'MemTotal|MemFree' >> /root/StorageCellMonitoring.log
echo "######### OP of PS Command ##########" >> /root/StorageCellMonitoring.log
for hst in `cat cell_group`; do ssh $hst hostname; ssh $hst ps aux | awk '{ print  $6/1024  "  " $2 "  " $11} ' | sort -n -r|head -n 5; done >> /root/StorageCellMonitoring.log

(
 echo "Subject: $SUBJECT"
 cat $CONTENT
) | /bin/mailx -s $SUBJECT  $MAILTO
/root/StorageCellMonitoring.sh

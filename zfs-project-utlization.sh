#!/bin/sh
## Purpose              : To get ZFS Project Utilization Report
# How To Execute        : sh /root/scripts/Platform_Validation/zfs_replication_status.sh
# Internal ZFS Log File              : Find on /root/scripts/Platform_Validation/logs/zfssn01_project_utilization_$DATE.log
# External ZFS Log File              : Find on /root/scripts/Platform_Validation/logs/zfsextsn03_project_utilization_$DATE.log

## Input Files ##
DATE=`date '+%Y%m%d%H%M%S'`
ZLOG_FILE=/root/scripts/Platform_Validation/logs/zfssn01_project_utilization_$DATE.log
EXT_ZLOG_FILE=/root/scripts/Platform_Validation/logs/zfsextsn03_project_utilization_$DATE.log
ZFS_HST="zfssn01"
EXT_ZFS_HST="zfsextsn03"
## Input Files ##

echo "Review zfs internal log file -->  $ZLOG_FILE" ## $REP_SNAPLOG_FILE
echo "Review zfsEXT external log file -->  $EXT_ZLOG_FILE"  ## $EXT_SNAPLOG_FILE

## Get Project names ##
ssh $ZFS_HST 'shares ls' > /root/scripts/Platform_Validation/zfssn01_sharesls.txt
ssh $EXT_ZFS_HST 'shares ls' > /root/scripts/Platform_Validation/zfsextsn03_sharesls.txt
## Get Project names ##

## Main Script to get zfs Replication and Snapshot status ##
## Printoutput to Log file ##
echo Project Name , Mountpoint , Quota-Set , Reference Utilization , Snaphot Utilization , Total Space Utilization >> $ZLOG_FILE
for PRJ_NAME in `cat /root/scripts/Platform_Validation/zfssn01_sharesls.txt  | egrep -v "Children:|Manage encryption keys|Manage remote replication|Define custom property schema|Properties:|Projects:|pool =|usage_data =|usage_snapshots =|usage_total =" | tr -d "[:blank:]" | sed '/^$/d'`
do
## Total Project Space ##
ssh $ZFS_HST 'shares select '$PRJ_NAME' show' > /root/scripts/Platform_Validation/logs/zfssn01_Project_Input.log
PRJ_MOUNTPOINT=`cat /root/scripts/Platform_Validation/logs/zfssn01_Project_Input.log | egrep "mountpoint" | cut -d "=" -f2 | tr -d "[:blank:]" | sed '/^$/d'`
PRJ_QUOTA=`cat /root/scripts/Platform_Validation/logs/zfssn01_Project_Input.log | egrep "quota =" | egrep -v "defaultuserquota|defaultgroupquota" | cut -d "=" -f2 | tr -d "[:blank:]" | sed '/^$/d'`
PRJ_SPACE_DATA=`cat /root/scripts/Platform_Validation/logs/zfssn01_Project_Input.log | egrep "space_data =" | cut -d "=" -f2 | tr -d "[:blank:]" | sed '/^$/d'`
PRJ_SPACE_SNAPSHOTS=`cat /root/scripts/Platform_Validation/logs/zfssn01_Project_Input.log | egrep "space_snapshots =" | cut -d "=" -f2 | tr -d "[:blank:]" | sed '/^$/d'`
PRJ_SPACE_TOTAL=`cat /root/scripts/Platform_Validation/logs/zfssn01_Project_Input.log | egrep "space_total =" | cut -d "=" -f2 | tr -d "[:blank:]" | sed '/^$/d'`
echo $PRJ_NAME , $PRJ_MOUNTPOINT , $PRJ_QUOTA , $PRJ_SPACE_DATA , $PRJ_SPACE_SNAPSHOTS , $PRJ_SPACE_TOTAL >> $ZLOG_FILE
## Total Project Space ##
done
## Main Script to get zfs Replication and Snapshot status ##

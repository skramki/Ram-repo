#!/bin/sh
## Purpose              : To get ZFS Replication status of all Projects
# How To Execute        : sh /root/scripts/Platform_Validation/zfs_replication_status.sh
# Internal ZFS Log File              : Find on /root/scripts/Platform_Validation/logs/zfssn01_Replication_status_$DATE.log
# External ZFS Log File              : Find on /root/scripts/Platform_Validation/logs/zfsextsn03_Replication_status_$DATE.log

## Input Files ##
DATE=`date '+%Y%m%d%H%M%S'`
ZLOG_FILE=/root/scripts/Platform_Validation/logs/zfssn01_Replication_status_$DATE.log
SNAPLOG_FILE=/root/scripts/Platform_Validation/logs/zfssn01_Snapshot_status_$DATE.log
REP_SNAPLOG_FILE=/root/scripts/Platform_Validation/logs/zfssn01_Replication_Snapshot_$DATE.log
EXT_ZLOG_FILE=/root/scripts/Platform_Validation/logs/zfsextsn03_Replication_status_$DATE.log
EXT_SNAPLOG_FILE=/root/scripts/Platform_Validation/logs/zfsextsn03_Snapshot_status_$DATE.log
EXT_REP_SNAPLOG_FILE=/root/scripts/Platform_Validation/logs/zfsextsn03_Replication_Snapshot_$DATE.log
## Input Files ##

echo "Review zfs internal log file -->  $ZLOG_FILE" ## $REP_SNAPLOG_FILE
echo "Review zfsEXT external log file -->  $EXT_ZLOG_FILE"  ## $EXT_SNAPLOG_FILE

## Get Project names ##
ssh $ZFS_HST 'shares ls' > /root/scripts/Platform_Validation/zfssn01_sharesls.txt
ssh $EXT_ZFS_HST'shares ls' > /root/scripts/Platform_Validation/zfsextsn03_sharesls.txt
## Get Project names ##

## Main Script to get zfs Replication and Snapshot status ##
for PRJ_NAME in `cat /root/scripts/Platform_Validation/zfssn01_sharesls.txt  | egrep -v "Children:|Manage encryption keys|Manage remote replication|Define custom property schema|Properties:|Projects:|pool =|usage_data =|usage_snapshots =|usage_total =" | tr -d "[:blank:]" | sed '/^$/d'`
do
## Replication Status ##
ssh $ZFS_HST 'shares select '$PRJ_NAME' replication show' | egrep "^action-" > /root/scripts/Platform_Validation/logs/zfssn01_ReplicationINPUT.log
REP_STATUS=`cat /root/scripts/Platform_Validation/logs/zfssn01_ReplicationINPUT.log`
ssh $ZFS_HST 'shares select '$PRJ_NAME' replication select action-000 autosnaps show' > /root/scripts/Platform_Validation/logs/zfssn01_Rep_AutoSnapshotINPUT.log
AUTOSNAP_POLICY=`cat /root/scripts/Platform_Validation/logs/zfssn01_Rep_AutoSnapshotINPUT.log | egrep "autosnaps_retention_policies" | cut -d "=" -f2 | tr -d "[:blank:]" | sed '/^$/d'`
AUTOSNAP_REPLICA_DAYS=`cat /root/scripts/Platform_Validation/logs/zfssn01_Rep_AutoSnapshotINPUT.log | egrep "automatic-00" | awk '{print $5}' | tr -d "[:blank:]" | sed '/^$/d'`
echo $PRJ_NAME , $AUTOSNAP_POLICY , $AUTOSNAP_REPLICA_DAYS >> $REP_SNAPLOG_FILE
## Replication Status ##

## Snapshot Status ##
ssh $ZFS_HST 'shares select '$PRJ_NAME' snapshots list' | egrep -v "^.rr-" > /root/scripts/Platform_Validation/logs/zfssn01_SnapshotINPUT.log
TOTALSNAP_DAY=`cat /root/scripts/Platform_Validation/logs/zfssn01_SnapshotINPUT.log | egrep "^.auto-|^backup" | wc -l`
LASTSNAP_DAY=`cat /root/scripts/Platform_Validation/logs/zfssn01_SnapshotINPUT.log | egrep "^.auto-|^backup" | head -1`
FIRSTSNAP_DAY=`cat /root/scripts/Platform_Validation/logs/zfssn01_SnapshotINPUT.log | egrep "^.auto-|^backup" | tail -1`
## Snapshot Status ##

echo $PRJ_NAME , $TOTALSNAP_DAY , $LASTSNAP_DAY , $FIRSTSNAP_DAY , $AUTOSNAP_POLICY , $AUTOSNAP_REPLICA_DAYS , $REP_STATUS >> $ZLOG_FILE
#echo Snapshot , $TOTALSNAP_DAY , $LASTSNAP_DAY , $FIRSTSNAP_DAY >> $SNAPLOG_FILE

done

## Main Script to get zfs Replication and Snapshot status ##

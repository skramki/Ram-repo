#!/bin/sh
## Purpose      : Platform Validation on Exalogic Rack prior to Patching Pre-Checks
# How To Execute        : sh /root/scripts/Platform_Validation/Power_SupplyValidation_CNILOM_IBENV.sh
# Log File                      : Find on /root/scripts/Platform_Validation/logs/compute-PowerMaintenance-check_$DATE.log

DATE=`date '+%Y-%m-%d-%H-%M-%S'`
LOG_FILE=/root/scripts/Platform_Validation/logs/compute-PowerMaintenance-check_$DATE.log
COMPUT_NODE=/root/cn.lst
IB_SWITCH=/root/ibswitches.lst
ZFS_NODE=/root/zfs.lst

## Validate IB ENV_TEST ##

dcli -l root -g $IB_SWITCH env_test | egrep "PSU"  | egrep -v "Starting" >> $LOG_FILE

## Validate Compute Node Power Health Status ##

echo "Show Overall Power Health Status" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/Power | health"' | egrep "health" | grep -v Power >> $LOG_FILE
#echo "Show Power Supply 0 Health Status" >> $LOG_FILE
#dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/Power/Power_Supplies/Power_Supply_0 | health"' | grep health | grep -v Power >> $LOG_FILE
#echo "Show Power Supply 1 Health Status" >> $LOG_FILE
#dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/Power/Power_Supplies/Power_Supply_1 | health"' | grep health | grep -v Power >> $LOG_FILE
## Validate Compute Node Power Health Status ##

## Validate ZFS/Storage Node Power Health Status ##

echo "Show ZFS/Storage Node Power Health Status" >> $LOG_FILE
dcli -l root -g $ZFS_NODE 'maintenance hardware select chassis-000 select psu show' | egrep "psu-" >> $LOG_FILE
## Validate ZFS/Storage Node Power Health Status ##

echo "Health status Execution Completed"
echo "Validate Power Health Status to Log File --> $LOG_FILE"

## End ##

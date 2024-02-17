#!/bin/sh
## Purpose      : Platform Validation on Exalogic Rack prior to Patching Pre-Checks
# How To Execute        : ksh /root/scripts/Platform_Validation/Exalogic-PSU-Pre-Check.sh
# Log File                      : Find on $LOG_FILE

## Below files are Most important Input for this Pre-Check. Please make sure entered Servers are valid.
DATE=`date '+%Y-%m-%d-%H-%M-%S'`
RAK_SHORT_NAME=`hostname -s | cut -c 1-4`
LOG_FILE=/root/scripts/Platform_Validation/logs/$RAK_SHORT_NAME-Exalogic-pre-check_$DATE.log
ZLOG_FILE=/root/scripts/Platform_Validation/logs/$RAK_SHORT_NAME-ZFS-RepSnap-pre-check_$DATE.log
ZLOG_FILE_EXT=/root/scripts/Platform_Validation/logs/$RAK_SHORT_NAME-ZFSExternal-RepSnap-pre-check_$DATE.log
COMPUT_NODE=/root/cn.lst
VSERVER_LST=/root/vservers-20210928.lst
IB_SWITCH=/root/ibswitches.lst
ZFS_NODE=/root/zfs.lst
echo " Review EXARACKExalogic Pre-check log file --> $LOG_FILE"
echo "Review EXARACKInternal ZFS Replication & Snapshot log file -->  $ZLOG_FILE"
echo "Review EXARACKExternal ZFS Replication & Snapshot log file -->  $ZLOG_FILE_EXT"
EC_VSERVER=$RAK_SHORT_NAMEemoc
## Below files are Most important Input for this Pre-Check. Please make sure entered Servers are valid.


## View COMPUT_NODE, VSERVER_LST, IB_SWITCH, ZFS_NODE Node list involved on Pre-Checks
echo "## View COMPUT_NODE, VSERVER_LST, IB_SWITCH, ZFS_NODE Node list involved on Pre-Checks ##" >> $LOG_FILE

echo "# cat /root/cn.lst" >> $LOG_FILE
cat $COMPUT_NODE >> $LOG_FILE
##echo "# cat control.lst" >> $LOG_FILE
##cat control.lst >> $LOG_FILE
echo "# cat /root/vservers.lst | wc -l" >> $LOG_FILE
cat $VSERVER_LST | wc -l >> $LOG_FILE
echo "# cat /root/vservers.lst" >> $LOG_FILE
cat $VSERVER_LST >> $LOG_FILE
echo "# cat $IB_SWITCH" >> $LOG_FILE
cat $IB_SWITCH >> $LOG_FILE
echo "# cat $ZFS_NODE" >> $LOG_FILE
cat $ZFS_NODE >> $LOG_FILE
echo "# Control Stack VServer Name = $EC_VSERVER" >> $LOG_FILE
echo "# RACK_NAME = $RAK_SHORT_NAME" >> $LOG_FILE
echo "# Output of all Variables printed above #" >> $LOG_FILE

## Find EC Control VM's UUID
echo "##  Find EC Control VM's UUID ##" >> $LOG_FILE
echo "# find /OVS -wholename '*VirtualMachines/*/vm.cfg' -exec grep -H 'simple_' {} \;|grep Exalogic" >> $LOG_FILE
find /OVS -wholename '*VirtualMachines/*/vm.cfg' -exec grep -H 'simple_' {} \;|grep Exalogic >> $LOG_FILE

## vServers Validation
echo "## vServers Validation ##" >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST 'date'" >> $LOG_FILE
dcli -l root -g $VSERVER_LST 'date'  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST 'date' | grep -i hkt" >> $LOG_FILE
dcli -l root -g $VSERVER_LST 'date' | grep -i hkt  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST 'date' | grep -i hkt | wc -l" >> $LOG_FILE
dcli -l root -g $VSERVER_LST 'date' | grep -i hkt | wc -l  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST 'date' | grep -iv edt" >> $LOG_FILE
dcli -l root -g $VSERVER_LST 'date' | grep -iv edt  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST 'date' | grep -iv edt | wc -l" >> $LOG_FILE
dcli -l root -g $VSERVER_LST 'date' | grep -iv edt | wc -l  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST 'uptime'" >> $LOG_FILE
dcli -l root -g $VSERVER_LST 'uptime'  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST 'df -Ph'" >> $LOG_FILE
dcli -l root -g $VSERVER_LST 'df -Ph'  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST imageinfo | grep -i 'Image Version'" >> $LOG_FILE
dcli -l root -g $VSERVER_LST imageinfo | grep -i 'Image Version'  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST imageinfo" >> $LOG_FILE
dcli -l root -g $VSERVER_LST imageinfo  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST imagehistory" >> $LOG_FILE
dcli -l root -g $VSERVER_LST imagehistory  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST chkconfig --list | egrep "on"" >> $LOG_FILE
dcli -l root -g $VSERVER_LST chkconfig --list | egrep "on"  >> $LOG_FILE

echo "# dcli -l root -g $VSERVER_LST 'su - ccadm -c "/sw/monitoring/ccagent/agent_13.4.0.0.0/bin/emctl status agent | egrep "Last successful upload|Heartbeat Status""'" >> $LOG_FILE
dcli -l root -g $VSERVER_LST 'su - ccadm -c "/sw/monitoring/ccagent/agent_13.4.0.0.0/bin/emctl status agent | egrep "Last successful upload|Heartbeat Status""' >> $LOG_FILE


## Compute Node Validation
echo "## Compute Node Validation ##" >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'xm list'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'xm list' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'uptime'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'uptime' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'date'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'date' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'imageinfo'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'imageinfo' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'imageinfo | egrep "Image Version"'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'imageinfo | egrep "Image Version"' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'imagehistory'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'imagehistory' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'cat /etc/hosts'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'cat /etc/hosts' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'df -Ph'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'df -Ph' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE '/opt/exalogic.tools/tools/CheckHWnFWProfile'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE '/opt/exalogic.tools/tools/CheckHWnFWProfile' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ntpstat'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ntpstat' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ntpq -pn'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ntpq -pn' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ibswitches'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ibswitches' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ibswitches' | wc" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ibswitches' | wc >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ibstatus|grep state'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ibstatus|grep state' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ibstatus|grep rate'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ibstatus|grep rate' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ibcheckstate'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ibcheckstate' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'service ovs-agent status'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'service ovs-agent status' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'service oswbb status'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'service oswbb status' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/"'" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/"' >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/"' | grep system_fw_version" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/"' | grep system_fw_version >>$LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/Power | health"' | egrep "health" | grep -v Power" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/Power | health"' | egrep "health" | grep -v Power >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/Power/Power_Supplies/Power_Supply_0 | health"' | grep health | grep -v Power" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/Power/Power_Supplies/Power_Supply_0 | health"' | grep health | grep -v Power >> $LOG_FILE

echo "# dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/Power/Power_Supplies/Power_Supply_1 | health"' | grep health | grep -v Power" >> $LOG_FILE
dcli -l root -g $COMPUT_NODE 'ipmitool sunoem cli "show /system/Power/Power_Supplies/Power_Supply_1 | health"' | grep health | grep -v Power >> $LOG_FILE

echo "# ibhosts" >> $LOG_FILE
ibhosts >> $LOG_FILE

echo "# ibhosts | wc" >> $LOG_FILE
ibhosts | wc >> $LOG_FILE

# Validate ibswitches ##
echo "## Validating IBSWITCHES ##"
echo "# dcli -l root -g $IB_SWITCH version" >> $LOG_FILE
dcli -l root -g $IB_SWITCH version >> $LOG_FILE

echo "# dcli -l root -g $IB_SWITCH getmaster" >> $LOG_FILE
dcli -l root -g $IB_SWITCH getmaster >> $LOG_FILE

echo "# dcli -l root -g $IB_SWITCH showtopology" >> $LOG_FILE
dcli -l root -g $IB_SWITCH showtopology >> $LOG_FILE

echo "# dcli -l root -g $IB_SWITCH showvlan" >> $LOG_FILE
dcli -l root -g $IB_SWITCH showvlan >> $LOG_FILE

echo "# dcli -l root -g $IB_SWITCH showgwports" >> $LOG_FILE
dcli -l root -g $IB_SWITCH showgwports >> $LOG_FILE

echo "# dcli -l root -g $IB_SWITCH showvnics" >> $LOG_FILE
dcli -l root -g $IB_SWITCH showvnics >> $LOG_FILE

echo "# dcli -l root -g $IB_SWITCH lspci" >> $LOG_FILE
dcli -l root -g $IB_SWITCH lspci >> $LOG_FILE

echo "# dcli -l root -g $IB_SWITCH ibcheckerrors" >> $LOG_FILE
dcli -l root -g $IB_SWITCH ibcheckerrors >> $LOG_FILE

echo "# dcli -l root -g $IB_SWITCH listlinkup" >> $LOG_FILE
dcli -l root -g $IB_SWITCH listlinkup >> $LOG_FILE

echo "# dcli -l root -g $IB_SWITCH showunhealthy" >> $LOG_FILE
dcli -l root -g $IB_SWITCH showunhealthy >> $LOG_FILE

echo "# dcli -l root -g $IB_SWITCH env_test" >> $LOG_FILE
dcli -l root -g $IB_SWITCH env_test >> $LOG_FILE
# Validate ibswitches ##

## Validat EMOC ##
echo "##Validating EMOC ##"  >> $LOG_FILE

echo "# ssh $EC_VSERVER /opt/sun/xvmoc/bin/ecadm status" >> $LOG_FILE
ssh -t $EC_VSERVER /opt/sun/xvmoc/bin/ecadm status >> $LOG_FILE

echo "# ssh $EC_VSERVER service ovab status" >> $LOG_FILE
ssh -t $EC_VSERVER service ovab status >> $LOG_FILE

echo "# ssh $EC_VSERVER service ovmm status" >> $LOG_FILE
ssh -t $EC_VSERVER service ovmm status >> $LOG_FILE

echo "# ssh $EC_VSERVER service oracle-db status" >> $LOG_FILE
ssh -t $EC_VSERVER service oracle-db status >> $LOG_FILE

echo "# ssh $EC_VSERVER ps -ef | grep pmon | grep -v grep" >> $LOG_FILE
ssh -t $EC_VSERVER ps -ef | grep pmon | grep -v grep >> $LOG_FILE

echo "# ssh $EC_VSERVER /sbin/chkconfig --list oracle-db" >> $LOG_FILE
ssh -t $EC_VSERVER /sbin/chkconfig --list oracle-db >> $LOG_FILE

echo "# ssh $EC_VSERVER 'su - oraagent -c "/swpkg/monitoring/oem-agent/agent_13.4.0.0.0/bin/emctl status agent"'" >> $LOG_FILE
ssh $EC_VSERVER 'su - oraagent -c "/swpkg/monitoring/oem-agent/agent_13.4.0.0.0/bin/emctl status agent"' >> $LOG_FILE

echo "# ssh $EC_VSERVER cat /etc/hosts" >> $LOG_FILE
ssh $EC_VSERVER cat /etc/hosts >> $LOG_FILE
## Validat EMOC ##

## Validating Proxy Controller ##
echo "## Validating Proxy Controller ##"

echo "# ssh $RAK_SHORT_NAME-pc1 /opt/sun/xvmoc/bin/proxyadm status" >> $LOG_FILE
ssh $RAK_SHORT_NAME-pc1 /opt/sun/xvmoc/bin/proxyadm status >> $LOG_FILE

echo "# ssh $RAK_SHORT_NAME-pc1 'uptime'" >> $LOG_FILE
ssh $RAK_SHORT_NAME-pc1 'uptime' >> $LOG_FILE

echo "# ssh $RAK_SHORT_NAME-pc2 /opt/sun/xvmoc/bin/proxyadm status" >> $LOG_FILE
ssh $RAK_SHORT_NAME-pc2 /opt/sun/xvmoc/bin/proxyadm status >> $LOG_FILE

echo "# ssh $RAK_SHORT_NAME-pc2 'uptime'" >> $LOG_FILE
ssh $RAK_SHORT_NAME-pc2 'uptime' >> $LOG_FILE

## Validating Proxy Controller ##

### Validating Internal ZFS Replication & Snapshot Status ##
/root/scripts/Platform_Validation/zfs_replication_status.sh

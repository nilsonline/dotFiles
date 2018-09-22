#!/bin/bash

# Author: Nils Gerstner
# Last revision: 19th July 2018
# Version: 1.2
# Description: Script to stop IBM Integration Bus and IBM MQ QueueManager

QM=IB10QMGR
NODE=IB10NODE
MQSIPROFILE=/opt/ibm/iib-10.0.0.10/server/bin/mqsiprofile

# Colored message
function cmsg() {
        case "$1" in
        red)    COLOR="\033[1;31m"
                ;;
        blue)   COLOR="\033[1;34m"
                ;;
        grey)   COLOR="\033[1;30m"
                ;;
        lgrey)  COLOR="\033[0;37m"
                ;;
        esac
        printf "${COLOR}${2}\33[0m\n"
}

cmsg grey "Stopping integration node ${Node}"
echo "mqsistop ${NODE}"
mqsistop $NODE
COUNTER=20
until [ "$(mqsilist |grep IB10NODE |grep -o stopped)" = "stopped" ]; do
	if [ $COUNTER -lt 0 ]; then
		cmsg red "Integration node ${NODE} has not stoped as excpected"
		exit 1;
	fi
	COUNTER=$(($COUNTER-1))
	sleep 1s
done
cmsg blue "${NODE} has stopped"

cmsg grey "Stopping queue manager"
echo "endmqm IB10QMGR"
endmqm IB10QMGR
COUNTER=20
until [ "$(dspmq |grep $QM |grep -o 'Ended normally')" = "Ended normally" ]; do
	if [ $COUNTER -lt 0 ]; then
		cmsg red "Queue manager ${QM} has not stoped as excpected"
		exit 1;
	fi
	COUNTER=$(($COUNTER-1))
	sleep 1s
done
cmsg blue "${QM} has ended"
exit 0

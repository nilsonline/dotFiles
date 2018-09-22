#!/bin/bash

# Author: Nils Gerstner
# Last revision: 19th July 2018
# Version: v2.1
# Description: Script to start IBM MQ QueueManager and IBM Integration Bus

QM=IB10QMGR
NODE=IB10NODE
MQSIPROFILE=/opt/ibm/iib-10.0.0.10/server/bin/mqsiprofile

# Colored message
function cmsg {
	case "$1" in
	red) 	COLOR="\033[1;31m"
		;;
	blue)	COLOR="\033[1;34m"
		;;
	grey)	COLOR="\033[1;30m"
		;;
	lgrey)	COLOR="\033[0;37m"
	   	;;
	esac
	printf "${COLOR}${2}\33[0m\n"
}


function sourceMqsiprofile {
  # Does mqsiprofile exist?
  if [ ! -f $MQSIPROFILE ]; then
    cmsg red "File '${MQSIPROFILE}' does not exist!"
    exit 1;
  fi

  # Check if mqsiprofile allready points to a path
  PROFILE=$(which mqsiprofile |grep mqsiprofile)
  #INITIALIZED=1
if [ -z "${PROSPECTIVE_MQSI_BASE_FILEPATH+MQSI_PROFILE_NOT_SET}" ]; then # environment is not initialized -> source profile
#if [ "${PROFILE}" = "" ]; then
	cmsg grey "Initializing environment"
    echo "${MQSIPROFILE}"
    . ${MQSIPROFILE}
  elif [ "${PROFILE}" != "${MQSIPROFILE}" ]; then # wrong environment is initialized
    cmsg red "${PROFILE} is the wrong environment!\nPlease rerun the script from a clean shell"
    exit 1;
  else
    #INITIALIZED=0
  fi
}



function startMq {
  # Start queue manager
  cmsg grey "Starting queue manager ${QM}"
  echo "strmqm ${QM}"
  strmqm $QM
  RETURN=$?
  if [ $RETURN -eq 16 ]; then # if queue manager does not exist, strmqm returns 16
    exit 1;
  elif [ $RETURN -eq 5 ]; then # Queue manager is running
    RUNNING=0
  else
    RUNNING=1
  fi

  # Make sure queue manager is running
  COUNTER=10
  until [ $RUNNING -eq 0 ] || [ "$( dspmq |grep $QM |grep -o Running)" = "Running" ]; do
    COUNTER=$(($COUNTER-1));
    if [ $COUNTER -lt 0 ]; then
      cmsg red "Could not start QueueManager ${QM}"
      exit 1;
    fi
    cmsg lgrey "Countdown: ${COUNTER}"
    sleep 2s
  done

  # Ensure queue manager is reachable (send ping)
  COUNTER=10
  RESULT=1
  until [ $RESULT -eq 0 ]; do
    COUNTER=$(($COUNTER-1));
    echo "ping Queue Manager ${QM}" | runmqsc ${QM} <<<"PING QMGR" > /dev/null 2>&1 # '<<<' pass String as File
    pingresult=$?
    if [ $pingresult -eq 0 ]; then # ping succeeded
      cmsg blue "Queue manager ${QM} is responsive"
      RESULT=0
    elif [ $COUNTER -lt 0 ]; then
      cmsg red "QueueManager ${QM} running, but unresponsive!"
      exit 1;
    else
      sleep 1s
    fi
  done
}

function startNode {
  # Start Integration Node
  echo ""
  cmsg grey "Starting Integration Node ${NODE}"
  echo "mqsistart ${NODE}"
  if [ "$(echo $(mqsistart $NODE)|grep -o 'does not exist')" != "" ]; then
    cmsg red "${NODE} does not exist!"
    exit 1;
  fi

  # Make sure the Integration Node is running
  COUNTER=10
  until [ "$(mqsilist | grep ${NODE} |grep -o running)" = "running" ]; do
    COUNTER=$(($COUNTER-1))
    if [ $COUNTER -lt 1 ]; then
      cmsg red "${NODE} does not seem to start..."
      exit 1;
    fi
    cmsg lgrey "Countdown: ${COUNTER}"
    sleep 2s
  done
  cmsg blue "Integration Node ${NODE} is running"
}

sourceMqsiprofile
startMq
startNode
# Execute shell, if environment was initialized from script, so you do not lose the sourced profile in the shell
if [ $INITIALIZED -eq 1 ]; then
  echo "exec bash"
  exec bash
fi
exit 0

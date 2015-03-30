#!/bin/bash

#----------------------------
#This script run the script "launch.sh" several time for sequential testing
#----------------------------

#Variables to be passed
REMOTE_ip=$1
REMOTE_port=$2
REMOTE_username=$3
#----------------------

#-------------------------------------------------
Num_args=$#
if [ $((Num_args%2)) = 0 ]; then
    echo "[LAUNCH] parameters needed: > $Num_args"
    echo "         #1: remote ip"
    echo "         #2: remote port"
    echo "         #3: remote username"
    echo "         #Need a json configuration file and experiment name for each addition experiment that should be executed"
    echo "  TRACE_CMD_COMMAND can be set as an environment variable"
    echo "  to replace the original trace-cmd: it should be set as the"
    echo "  location of the binary for trace-cmd on the remote machine"
    exit
fi
#-------------------------------------------------

echo "Starting test sequence"

shift;shift;shift
while [ "$1" != "" ]; do
    ./launch.sh $REMOTE_ip $REMOTE_port $REMOTE_username $1 $2
    echo "Json: $1 , Exp: $2"
    shift;shift
done

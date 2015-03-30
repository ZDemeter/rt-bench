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
num_args=$#
num_tests=$((((num_args - 3)) / 2 ))
num_count=0
if [ "$((num_args % 2))" = 0 ] || [ "$num_args" -le "5" ]; then
    echo "[LAUNCH] parameters needed: (tried $num_args)"
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
shift;shift;shift
echo "Starting test sequence..."
echo "Number of tests to be executed: $num_tests"

while [ "$1" != "" ]; do
    echo "Initializing next test..."
    echo "$(($#/2)) tests left to run"
    read -t 2
    #clear
    ./launch.sh $REMOTE_ip $REMOTE_port $REMOTE_username $1 $2
    shift;shift
    num_count=$((num_count+1))
done

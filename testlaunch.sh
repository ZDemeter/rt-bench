#!/bin/bash

#----------------------------
#This script run the script "launch.sh" several time for sequential testing
#----------------------------

#Variables to be passed
REMOTE_ip=$1
REMOTE_port=$2
REMOTE_username=$3
SCHED_NAME="Scheduled"
SCHED_OUTPUT=$4
SCHED_SRC=${SCHED_OUTPUT%/*}
SCHED_TESTNAME=$5

echo "Atm PATH ..................... $SCHED_OUTPUT"
#----------------------

#-------------------------------------------------
num_args=$#
num_tests=$(wc -l < $SCHED_OUTPUT)
num_count=0
if [ "$num_args" -lt "5" ]; then
    echo "Variables: amount, $num_args , division, $((num_args % 2)) , tests , $num_tests"
    echo "[LAUNCH] parameters needed: (tried $num_args)"
    echo "         #1: remote ip"
    echo "         #2: remote port"
    echo "         #3: remote username"
    echo "         #4: file containing all the json files that should be executed with testname, connected on same row"
    echo "  TRACE_CMD_COMMAND can be set as an environment variable"
    echo "  to replace the original trace-cmd: it should be set as the"
    echo "  location of the binary for trace-cmd on the remote machine"
    exit
fi
#-------------------------------------------------
echo "" > input/$SCHED_TESTNAME/$SCHED_NAME.txt
echo "Starting test sequence..." | tee -a $SCHED_SRC/$SCHED_NAME.txt
echo "Number of tests to be executed: $num_tests" | tee -a $SCHED_OUTPUT/$SCHED_NAME.txt

while read line ; do
    ./launch.sh $REMOTE_ip $REMOTE_port $REMOTE_username $line
    
done <$SCHED_OUTPUT

#while [ "$1" != "" ]; do
#    echo -n "Initializing test $2 at " | tee -a $SCHED_SRC/$SCHED_NAME.txt
#    date +"%T" | tee -a $SCHED_SRC/$SCHED_NAME.txt
#    echo "$(($#/2)) tests left to run"
#    sleep 1
#    #clear
#    ./launch.sh $REMOTE_ip $REMOTE_port $REMOTE_username $1 $2
#    shift;shift
#    num_count=$((num_count+1))
#    echo -n "Finished at " | tee -a $SCHED_SRC/$SCHED_NAME.txt
#    date +"%T" | tee -a $SCHED_SRC/$SCHED_NAME.txt
#done

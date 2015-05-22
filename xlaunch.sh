#!/bin/bash

#----------------------------
#This script run the script "launch.sh" several time for sequential testing
#----------------------------

#Variables to be passed
REMOTE_ip=$1
REMOTE_port=$2
REMOTE_username=$3
SCHED_OUTPUT=$4         #input/var/runtests.txt
SCHED_TESTNAME=$5       #var_schedule
SCHED_NAME=$SCHED_TESTNAME
SCHED_SRC=${SCHED_OUTPUT%/*}    #input/var
SCHED_result_folder=${SCHED_SRC#*/} #var

test_file_pos=0
test_name_pos=0
num_args=$#
num_input=$(wc -l < $SCHED_OUTPUT)
at_line=0

if [ "$num_args" -lt "5" ] || [ "$((num_args % 2))" != "1" ] ; then
    echo "Variables: amount, $num_args , division, $((num_args % 2)) , tests , $num_tests"
    echo "[LAUNCH] parameters needed: (tried $num_args)"
    echo "         #1: remote ip"
    echo "         #2: remote port"
    echo "         #3: remote username"
    echo "         #4: file containing all the json files that should be executed with testname, connected on same row"
    echo "         #5: name for the test sequence"
    echo "  TRACE_CMD_COMMAND can be set as an environment variable"
    echo "  to replace the original trace-cmd: it should be set as the"
    echo "  location of the binary for trace-cmd on the remote machine"
    exit
fi
#-------------------------------------------------

#------------Checking for missing files----------------------
num_tests=$((num_input / 2))
echo "" > results/$SCHED_NAME.txt
while read line ; do
    sched_array[$at_line]=$line
    at_line=$((at_line+1))
done <$SCHED_OUTPUT

missing=0
for (( c=0; c<$num_tests; c++ )) ; do
    if [ ! -f ${sched_array[((c * 2))]} ] ; then
        echo "[TLOG][ERROR]File nr $c (${sched_array[((c * 2))]}) does not exist" | tee -a results/$SCHED_NAME.txt
        missing=$((missing + 1))
    fi
done
if [ "$missing" -gt "0" ] ; then
    echo "[TLOG][ERROR]Aborting process!($missing file(s) missing)" | tee -a results/$SCHED_NAME.txt
    exit 1
fi
echo "Date for attempted start: " | tee -a results/$SCHED_NAME.txt
date +"%A - %F" | tee -a results/$SCHED_NAME.txt
echo "[TLOG]All files found! Number of tests that will execute: $num_tests" | tee -a results/$SCHED_NAME.txt
#------------Checking for missing files----------------------

mkdir results/$SCHED_result_folder
mv results/$SCHED_NAME.txt results/$SCHED_result_folder/
echo -e "[TLOG]Starting test sequence...\n" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt

for (( c=1; c<=$num_tests; c++ )) ; do
    sleep 2
    test_file_pos=$((c * 2 - 2))
    test_name_pos=$((c * 2 - 1))
    echo "[TLOG]From [${sched_array[$test_file_pos]}] create [${sched_array[$test_name_pos]}]" |tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    echo -n "[TLOG]Initializing test $c at time: " |tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    date +"%T" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    ./launch.sh ${REMOTE_ip} ${REMOTE_port} ${REMOTE_username} ${sched_array[$test_file_pos]} ${sched_array[$test_name_pos]}
    echo -n "[TLOG]Test finished at time: " |tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    date +"%T" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    echo "[TLOG]Number of tests left to be run: $((num_tests - c))" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    echo "" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
done

cat results/$SCHED_result_folder/$SCHED_NAME.txt | mail -s "Tests for RT-Bench finished" zsolt.demeter.856@student.lu.se

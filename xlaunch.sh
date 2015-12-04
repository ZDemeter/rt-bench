#!/bin/bash

#----------------------------
#This script run the script "launch.sh" several time for sequential testing
#----------------------------

##
#Checking if input is a number or if it contains any other symbols
#@param a   Any input to be checked if containing a number
#@return    1 if a is a number or 0 if input contained any other symbols
#
isnum() { awk -v a="$1" 'BEGIN {print (a == a + 0)}'; }

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
did_fail=0

if [ "$num_args" -lt "5" ] || [ "$((num_args % 2))" != "1" ] ; then
    echo "Variables: amount, $num_args , division, $((num_args % 2)) , tests , $num_tests"
    echo "[LAUNCH] parameters needed: (entered arguments: $num_args)"
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
mkdir results/$SCHED_result_folder

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
echo "[TLOG]Running test: [${SCHED_result_folder}]" | tee -a results/$SCHED_NAME.txt
echo "[TLOG]All files found! Number of tests that will execute: $num_tests" | tee -a results/$SCHED_NAME.txt
#------------Checking for missing files----------------------



mv results/$SCHED_NAME.txt results/$SCHED_result_folder/
echo -e "[TLOG]Starting test sequence...\n" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt

for (( c=1; c<=$num_tests; c++ )) ; do
    sleep 1
    test_file_pos=$((c * 2 - 2))
    test_name_pos=$((c * 2 - 1))
    echo "[TLOG]From [${sched_array[$test_file_pos]}] create [${sched_array[$test_name_pos]}]" |tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    echo -n "[TLOG]Initializing test $c at time: " |tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    date +"%T" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    ./launch.sh ${REMOTE_ip} ${REMOTE_port} ${REMOTE_username} ${sched_array[$test_file_pos]} ${sched_array[$test_name_pos]}
    #---Check For Errors In Result---#
    lower_alpha=$(cat results/${sched_array[$test_name_pos]}/*.output.txt | grep thread1,SLBF_ALPHADELTA | awk -F',' '{print $4}')
    lower_delta=$(cat results/${sched_array[$test_name_pos]}/*.output.txt | grep thread1,SLBF_ALPHADELTA | awk -F',' '{print $5}')
    upper_alpha=$(cat results/${sched_array[$test_name_pos]}/*.output.txt | grep thread1,SUBF_ALPHADELTA | awk -F',' '{print $4}')
    upper_delta=$(cat results/${sched_array[$test_name_pos]}/*.output.txt | grep thread1,SUBF_ALPHADELTA | awk -F',' '{print $5}')

    if [ $(isnum $lower_alpha) -eq 1 ] && [ $(isnum $lower_delta) -eq 1 ] && [ $(isnum $upper_alpha) -eq 1 ] && [ $(isnum $upper_delta) -eq 1 ]; then
        if [ $(awk "BEGIN {print ($lower_delta < 0)}") -eq 1 ]; then
        lower_delta=$(awk "BEGIN {printf \"%.6f\", $lower_delta * -1}")
        fi

        if [ $(awk "BEGIN {print ($upper_delta < 0)}") -eq 1 ]; then
        upper_delta=$(awk "BEGIN {printf \"%.6f\", $upper_delta * -1}")
        fi

        if [ $(awk "BEGIN {print ($lower_alpha > 1 || $lower_alpha < 0 || $lower_delta > 1 || upper_alpha > 1 || upper_alpha < 0 || upper_delta > 1)}") -eq 1 ]; then
            did_fail=1
        fi
    else
        did_fail=1
    fi
    #--------------------------------#
    if [ $did_fail -eq 0 ]; then
        mv results/${sched_array[${test_name_pos}]} results/${SCHED_result_folder}/
        echo -n "[TLOG]Test finished at time: " |tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
        date +"%T" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
        echo "[TLOG]Number of tests left to be run: $((num_tests - c))" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
        echo "" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    else
        rm -rf results/${sched_array[${test_name_pos}]}/
        did_fail=0  #Resetting fail-check
        c=$(( c-1 ))         #Makes same test run again
        echo -n "[TLOG]Test failed at time: " |tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
        date +"%T" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
        echo "[TLOG]Test [FAILED] and is being rerun(slbf_a=[$lower_alpha], slbf_d=[$lower_delta], subf_a=[$upper_alpha], subf_d=[$upper_delta])" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
        echo "" | tee -a results/$SCHED_result_folder/$SCHED_NAME.txt
    fi
done
    
cat results/$SCHED_result_folder/$SCHED_NAME.txt | mail -s "Tests for RT-Bench finished" zsolt.demeter.856@student.lu.se

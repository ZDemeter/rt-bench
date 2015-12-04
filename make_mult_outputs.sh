#!/bin/bash

#Gather output data and configure
#--------------------------------
#Requires Two Inputs
#1: Test schedule that should be located in input test folder
#2: Number of Threads to collect data from
#--------------------------------

SCHED_INPUTS=$1
THREAD_AMOUNT=$2
SCHED_LOCATION=${SCHED_INPUTS%/*}
RES_FOLDER=$(echo "$SCHED_LOCATION" | sed 's/input/results/g')

num_inputs=$(wc -l < $SCHED_INPUTS) #Check number of lines in the runtest-file
num_tests=$((num_inputs / 2))       #Divide with 2 to get number of performed tests
counter=0
while read line ; do                            #Read lines and get names of all the tests to be able to create paths
	if [ "$((counter % 2))" -eq "1" ] ; then    #   
    	t_names[$at_line]=$line                 #
        at_line=$((at_line+1))                  #
    fi                                          #
    counter=$((counter + 1))                    #
done <$SCHED_INPUTS                             #

#------------------------------------------------
echo "" > $RES_FOLDER/slbf_values_temp.txt
for (( am=1; am<=${THREAD_AMOUNT}; am++ )); do
    echo "" | awk -v nam=${am} >> $RES_FOLDER/slbf_values_temp.txt '{ printf "Thread_"nam" Alpha_"nam" Delta_"nam" " }'
done
echo "" >> $RES_FOLDER/slbf_values_temp.txt

for (( c=0; c<$num_tests; c++ )) ; do
    for (( am=1; am<=THREAD_AMOUNT; am++ )); do
        cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread${am},SLBF_ALPHADELTA | awk -v nam=${am} >> $RES_FOLDER/slbf_values_temp.txt -F',' '{ split($1, a, "_") ; printf a[nam]" "$4" "$5" "}'
    done
    echo "" >> $RES_FOLDER/slbf_values_temp.txt
done
    sed -i 's/m//g' $RES_FOLDER/slbf_values_temp.txt
#------------------------------------------------
echo "" > $RES_FOLDER/subf_values_temp.txt
for (( am=1; am<=${THREAD_AMOUNT}; am++ )); do
    echo "" | awk -v nam=${am} >> $RES_FOLDER/subf_values_temp.txt '{ printf "Thread_"nam" Alpha_"nam" Delta_"nam" " }'
done
echo "" >> $RES_FOLDER/subf_values_temp.txt

for (( c=0; c<$num_tests; c++ )) ; do
    for (( am=1; am<=THREAD_AMOUNT; am++ )); do
        cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread${am},SUBF_ALPHADELTA | awk -v nam=${am} >> $RES_FOLDER/subf_values_temp.txt -F',' '{ split($1, a, "_") ; printf a[nam]" "$4" "$5" "}'
    done
    echo "" >> $RES_FOLDER/subf_values_temp.txt
done
sed -i 's/m//g' $RES_FOLDER/subf_values_temp.txt
#------------------------------------------------
for (( am=1; am<=${THREAD_AMOUNT}; am++ )); do
    echo "" | awk -v nam=${am} >> $RES_FOLDER/other_values_temp.txt '{ printf "Thread_"nam" Alpha_"nam" Delta1_"nam" Delta2_"nam" " }'
done
echo "" >> $RES_FOLDER/other_values_temp.txt

for (( c=0; c<$num_tests; c++ )) ; do
    for (( am=1; am<=${THREAD_AMOUNT}; am++ )); do
        cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread${am},ALPHADELTAS | awk -v nam=${am} >> $RES_FOLDER/other_values_temp.txt -F',' '{ split($1, a, "_") ; printf a[nam]" "$4" "$5" "$6" "}'
    done
    echo "" >> $RES_FOLDER/other_values_temp.txt
done
sed -i 's/m//g' $RES_FOLDER/other_values_temp.txt
#------------------------------------------------
echo "" > $RES_FOLDER/supplyfunction_values_temp.txt
for (( am=1; am<=${THREAD_AMOUNT}; am++ )); do
    echo "" | awk -v x=${am} >> $RES_FOLDER/supplyfunction_values_temp.txt '{ printf "Thread_"x" Lower_Alpha_"x" Lower_Delta_"x" Upper_Alpha_"x" Upper_Delta_"x" Just_Alpha_"x" " }'
done
echo "" >> $RES_FOLDER/supplyfunction_values_temp.txt

for (( c=0; c<$num_tests; c++ )); do
    for (( am=1; am<=${THREAD_AMOUNT}; am++ )); do
        cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread${am},SLBF_ALPHADELTA | awk >> $RES_FOLDER/supplyfunction_values_temp.txt -F',' '{split($1, a, "_") ; printf "%s %s %s", a[nam], $4, $5}'
        cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread${am},SUBF_ALPHADELTA | awk >> $RES_FOLDER/supplyfunction_values_temp.txt -F',' '{printf " %s %s", $4, $5}'
        cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread${am},JUSTALPHA | awk >> $RES_FOLDER/supplyfunction_values_temp.txt -F',' '{printf " %s", $4}'
    done
    echo "" >> $RES_FOLDER/supplyfunction_values_temp.txt
done
sed -i 's/m//g' $RES_FOLDER/supplyfunction_values_temp.txt
#------------------------------------------------
cat $RES_FOLDER/slbf_values_temp.txt | column -t > $RES_FOLDER/slbf_values.txt
cat $RES_FOLDER/subf_values_temp.txt | column -t > $RES_FOLDER/subf_values.txt
cat $RES_FOLDER/other_values_temp.txt | column -t > $RES_FOLDER/other_values.txt
cat $RES_FOLDER/supplyfunction_values_temp.txt | column -t > $RES_FOLDER/supplyfunction_values.txt

rm $RES_FOLDER/*temp.txt

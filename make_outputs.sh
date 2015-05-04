#!/bin/bash

#Gather output data and configure
#--------------------------------
#Requires One Input
#1: Test schedule that should be located in input test folder
#--------------------------------

SCHED_INPUTS=$1
SCHED_LOCATION=${SCHED_INPUTS%/*}
RES_FOLDER=$(echo "$SCHED_LOCATION" | sed 's/input/results/g')

num_inputs=$(wc -l < $SCHED_INPUTS)
num_tests=$((num_inputs / 2))
counter=0
while read line ; do
	if [ "$((counter % 2))" -eq "1" ] ; then
    	t_names[$at_line]=$line
        at_line=$((at_line+1))
    fi
    counter=$((counter + 1))
done <$SCHED_INPUTS

echo "" > $RES_FOLDER/slbf_values_temp.txt
awk >> $RES_FOLDER/slbf_values_temp.txt '{ print "Memory Alpha Delta" }' $RES_FOLDER/slbf_values_temp.txt
for (( c=0; c<$num_tests; c++ )) ; do
    cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread1,SLBF_ALPHADELTA | awk >> $RES_FOLDER/slbf_values_temp.txt -F',' '{ split($1, a, "_") ; print a[2]" "$4" "$5}'
done
sed -i 's/mem//g' $RES_FOLDER/slbf_values_temp.txt
sed -i 's/redone//g' $RES_FOLDER/slbf_values_temp.txt #temp

echo "" > $RES_FOLDER/subf_values_temp.txt
awk >> $RES_FOLDER/subf_values_temp.txt '{ print "Memory Alpha Delta" }' $RES_FOLDER/subf_values_temp.txt
for (( c=0; c<$num_tests; c++ )) ; do
    cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread1,SUBF_ALPHADELTA | awk >> $RES_FOLDER/subf_values_temp.txt -F',' '{ split($1, a, "_") ; print a[2]" "$4" "$5}'
done
sed -i 's/mem//g' $RES_FOLDER/subf_values_temp.txt
sed -i 's/redone//g' $RES_FOLDER/subf_values_temp.txt #temp

echo "" > $RES_FOLDER/other_values_temp.txt
awk >> $RES_FOLDER/other_values_temp.txt '{ print "Memory Alpha Delta1 Delta2" }' $RES_FOLDER/other_values_temp.txt
for (( c=0; c<$num_tests; c++ )) ; do
    cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread1,ALPHADELTAS | awk >> $RES_FOLDER/other_values_temp.txt -F',' '{ split($1, a, "_") ; print a[2]" "$4" "$5" "$6}'
done
sed -i 's/mem//g' $RES_FOLDER/other_values_temp.txt
sed -i 's/redone//g' $RES_FOLDER/other_values_temp.txt #temp

echo "" > $RES_FOLDER/supplyfunction_values_temp.txt
awk >> $RES_FOLDER/supplyfunction_values_temp.txt '{ print "Memory Lower_Alpha Lower_Delta Upper_Alpha Upper_Delta Just_Alpha" }' $RES_FOLDER/supplyfunction_values_temp.txt
for (( c=0; c<$num_tests; c++ )) ; do
    cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread1,SLBF_ALPHADELTA | awk >> $RES_FOLDER/supplyfunction_values_temp.txt -F',' '{split($1, a, "_") ; printf "%s %s %s", a[2], $4, $5}'
    cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread1,SUBF_ALPHADELTA | awk >> $RES_FOLDER/supplyfunction_values_temp.txt -F',' '{printf " %s %s", $4, $5}'
    cat $RES_FOLDER/${t_names[$c]}/${t_names[$c]}.output.txt | grep thread1,JUSTALPHA | awk >> $RES_FOLDER/supplyfunction_values_temp.txt -F',' '{printf " %s\n", $4}'
done
sed -i 's/mem//g' $RES_FOLDER/supplyfunction_values_temp.txt
sed -i 's/redone//g' $RES_FOLDER/supplyfunction_values_temp.txt #temp

cat $RES_FOLDER/slbf_values_temp.txt | column -t > $RES_FOLDER/slbf_values.txt
cat $RES_FOLDER/subf_values_temp.txt | column -t > $RES_FOLDER/subf_values.txt
cat $RES_FOLDER/other_values_temp.txt | column -t > $RES_FOLDER/other_values.txt
cat $RES_FOLDER/supplyfunction_values_temp.txt | column -t > $RES_FOLDER/supplyfunction_values.txt


rm $RES_FOLDER/*temp.txt

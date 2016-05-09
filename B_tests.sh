#!/bin/bash

#----------------------------
#This script run customized scripts hardcoded
#----------------------------

./xlaunch.sh 130.235.83.53 22 zsolt input/Bartrr_tests/bartrr_runtests.txt bartrr_sched
./xlaunch.sh 130.235.83.53 22 zsolt input/Bertrr_tests/bertrr_runtests.txt bertrr_sched
./xlaunch.sh 130.235.83.53 22 zsolt input/Burtrr_tests/burtrr_runtests.txt burtrr_sched

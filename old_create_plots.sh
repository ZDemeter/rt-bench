#!/bin/bash

#---------
#Create .m-file
#for printing
#plot in octave
#---------

NUM_PLOTS=$1

for(( p=0; p<$NUM_PLOTS; c++ )); do
	targ_path=$2
	line=$3

	cat build/plot_template.m > do_plot.m
	sed -i "s/INP_PATH/$targ_path/g" do_plot.m
	if [ $line -ne "0" ] ; then
		sed -i 's/%ADDLINE%//g' do_plot.m
		sed -i "s/PLOT_LINE/$line/g" do_plot.m
	fi
	

done
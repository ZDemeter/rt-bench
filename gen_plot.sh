#!/bin/bash

NR_CURVES=$1
NR_LINES=$2

###In General###
#PATH_CURVE=$3
#COL_X=$4
#COL_Y=$5
################
#LINE_PATH=$3
#LINE_OPT=$4
################
#OUT_NAME=$3
################

cp build/plot_template.m temp_plot_gen.m

###CURVE###
for (( c=1 ; c<=$NR_CURVES ; c++ ))
do
	PATH_CURVE=$3
	COL_X=$4
	COL_Y=$5
#--------------------------
	sed -i "/#Input Files#/a input_file_${c}=\"${PATH_CURVE}\";" temp_plot_gen.m
#--------------------------
	sed -i "/#Axis Options#/a x_axis_${c}=${COL_X}" temp_plot_gen.m
	sed -i "/#Axis Options#/a y_axis_${c}=${COL_Y}" temp_plot_gen.m
#--------------------------
	sed -i "/#Data Save#/a rff=open(input_file_${c}); \\
fgetl(rff); \\
while(-1 ~= (line=fgetl(rff))) \\
	val=str2num(line); \\
	data_${c}(line_i++,:)=val; \\
end \\
fclose(rff); \\
" temp_plot_gen.m	
#--------------------------
sed -i "/#Plotting Curve#/a plot(data_${c}(:,x_axis_${c}), data_${c}(:,y_axis_${c}), \"-ob\");" temp_plot_gen.m
#--------------------------

	shift;shift;shift
done

###LINE###
for (( c=1 ; c<=$NR_LINES ; c++ ))
do
	LINE_PATH=$3
	LINE_OPT=$4
#--------------------------
	lower_alpha=$(cat ${LINE_PATH}*.output.txt | grep thread1,SLBF_ALPHADELTA | awk -F',' '{print $4}')
	lower_delta=$(cat ${LINE_PATH}*.output.txt | grep thread1,SLBF_ALPHADELTA | awk -F',' '{print $5}')
	upper_alpha=$(cat ${LINE_PATH}*.output.txt | grep thread1,SUBF_ALPHADELTA | awk -F',' '{print $4}')
	upper_delta=$(cat ${LINE_PATH}*.output.txt | grep thread1,SUBF_ALPHADELTA | awk -F',' '{print $5}')

	if [ "$LINE_OPT" = "lower_alpha" ]; then
		line_value=$lower_alpha
	elif [ "$LINE_OPT" = "lower_delta"  ]; then
		line_value=$lower_delta
	elif [ "$LINE_OPT" = "upper_alpha"  ]; then
		line_value=$upper_alpha
	elif [ "$LINE_OPT" = "upper_delta"  ]; then
		line_value=$upper_delta
	else
		echo "Innapropriate line option (par 5)"
	fi
#--------------------------
	sed -i "/#Static Lines#/a stat_line_${c}=${line_value}" temp_plot_gen.m
#--------------------------
	sed -i "/#Plotting Line#/a plot([data_${c}(1,x_axis_1) data_1(end,x_axis_1)], [stat_line_${c} stat_line_${c}], \"-k\");" temp_plot_gen.m
#--------------------------
	shift;shift
done

OUT_NAME=$3
sed -i "/#Output Name#/a output_name=\"${OUT_NAME}\";" temp_plot_gen.m

line_value="0"

#octave temp_plot_gen.m
#rm temp_plot_gen.m


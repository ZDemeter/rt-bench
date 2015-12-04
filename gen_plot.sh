#!/bin/bash

num_args=$#
if [ "$num_args" -eq "0" ]; then
    echo "#----------------------------------------------------"
    echo "#Creates a customized plot from the input parameters."
    echo "#Parameters needed:"
    echo "			#1: Number of curves in the plot"
    echo "			#2: Number of horizontal lines to be added"
    echo "		#Next in pairs of 3 and several can be added:"
    echo "			#3: Path to the results to be plottet"
    echo "			#4: Column from results to be on the x-grid"
    echo "			#5: Column from results to be on the y-grid"
    echo "		#Next in pairs of 2 and several can be added:"
    echo "			#6: Path to folder containing .output-file to get value from to create horizontal line"
    echo "			#7: Specify which value to be used(Alternatives: "lower_alpha", "lower_delta", "upper_alpha", "upper_delta")"
    echo "		######"
    echo "			#8: Path with name of the plot"
    echo "#----------------------------------------------------"
    exit
fi
NR_CURVES=$1
NR_LINES=$2

cp build/plot_template.m temp_plot_gen.m

###CURVE###
for (( c=1 ; c<=$NR_CURVES ; c++ ))
do
	PATH_CURVE=$3
	#PATH_RESULT=${PATH_CURVE%/*}
	COL_X=$4
	COL_Y=$5
#--------------------------
	#sed -i "/#Input Files#/a input_file_${c}=\"${PATH_CURVE}\";" temp_plot_gen.m
	sed -i "/#Input Files#/a input_file_${c}=\"../../../${PATH_CURVE}\";" temp_plot_gen.m
#--------------------------
	sed -i "/#Axis Options#/a x_axis_${c}=${COL_X};" temp_plot_gen.m
	sed -i "/#Axis Options#/a y_axis_${c}=${COL_Y};" temp_plot_gen.m
#--------------------------
	sed -i "/#Data Save#/a rff=fopen(input_file_${c});\\
fgetl(rff);\\
while(-1 ~= (read_line=fgetl(rff)))\\
	val=str2num(read_line);\\
	data_${c}(line_i++,:)=val;\\
end\\
line_i=1;\\
fclose(rff);\\
" temp_plot_gen.m	
#--------------------------
sed -i "/#Plotting Curve#/a semilogx(data_${c}(:,x_axis_${c}), data_${c}(:,y_axis_${c}), \"-ob\");" temp_plot_gen.m
#--------------------------

	shift;shift;shift
done
sed -i "/#Plotting Curve#/a hold on;" temp_plot_gen.m

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
		exit
	fi
#--------------------------
	sed -i "/#Static Lines#/a stat_line_${c}=${line_value};" temp_plot_gen.m
#--------------------------
	sed -i "/#Plotting Line#/a plot([data_${c}(1,x_axis_1) data_1(end,x_axis_1)], [stat_line_${c} stat_line_${c}], \"-kr\");" temp_plot_gen.m
#--------------------------
	shift;shift
done

OUT_PATH=$3
OUT_NAME=${OUT_PATH##*/}
sed -i "/#Output Name#/a output_name=\"${OUT_NAME}\";\\
" temp_plot_gen.m
#--------------------------
RES_NAME=${OUT_PATH%/*}
RES_NAME=${RES_NAME##*/}
sed -i "/#Set Labels#/a #text(x,y,\"tag\"); \\
#xlabel(\"\");\\
#ylabel(\"\");\\
" temp_plot_gen.m
#--------------------------
#sed -i "/#Save Output#/a print(strcat(\"${PATH_RESULT}/\",output_name), '-depsc');\\
sed -i "/#Save Output#/a print(strcat(\"\",output_name), '-depsc');\\
hold off \\
close \\
" temp_plot_gen.m

echo "Gen-file put in ${OUT_PATH}."
mv temp_plot_gen.m ${OUT_PATH}_genfile.m

#octave temp_plot_gen.m
#rm temp_plot_gen.m

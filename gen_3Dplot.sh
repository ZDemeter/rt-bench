#!/bin/bash

num_args=$#
if [ "$num_args" -eq "0" ]; then
    echo "#----------------------------------------------------"
    echo "Creates a customized 3D-plot from the input parameters."
    echo "#Parameters needed:"
    echo "			#1: Path to the results to be plottet"
    echo "			#2: Column from results to be on the x-grid"
    echo "			#3: Column from results to be on the y-grid"
    echo "			#4: Column from results to be on the z-grid"
    echo "			#5: Path with name of the plot"
fi

cp build/plot_template.m temp_plot_gen.m

###CURVE###
	PATH_CURVE=$1
	PATH_RESULT=${PATH_CURVE%/*}
	COL_X=$2
	COL_Y=$3
	COL_Z=$4
#--------------------------
	sed -i "/#Input Files#/a input_file=\"../../../${PATH_CURVE}\";" temp_plot_gen.m
#--------------------------
	sed -i "/#Axis Options#/a x_axis=${COL_X};" temp_plot_gen.m
	sed -i "/#Axis Options#/a y_axis=${COL_Y};" temp_plot_gen.m
	sed -i "/#Axis Options#/a z_axis=${COL_Z};" temp_plot_gen.m
#--------------------------
	sed -i "/#Data Save#/a rff=fopen(input_file); \\
fgetl(rff); \\
while(-1 ~= (line=fgetl(rff))) \\
	val=str2num(line); \\
	data(line_i++,:)=val; \\
end \\
fclose(rff); \\
" temp_plot_gen.m	
#--------------------------
sed -i "/#Plotting Curve#/a tri=delaunay(data(:,x_axis),data(:,y_axis)); \\
trisurf(tri, data(:,x_axis), data(:,y_axis), data(:,z_axis)); \\
set(gca, 'XScale', 'log', 'YScale', 'log'); \\
view(-55,-15); \\
" temp_plot_gen.m
#--------------------------
sed -i "/#Set Labels#/a xlabel(\"\");\\
ylabel(\"\");\\
zlabel(\"\");\\
" temp_plot_gen.m
#--------------------------
OUT_PATH=$5
OUT_NAME=${OUT_PATH##*/}
sed -i "/#Output Name#/a output_name=\"${OUT_NAME}\";" temp_plot_gen.m
#--------------------------
sed -i "/#Save Output#/a print(strcat(\"\",output_name,\"_faceted\"), '-depsc'); \\
shading interp \\
print(strcat(\"\",output_name,\"_interp\"), '-depsc'); \\
close all\\
" temp_plot_gen.m
mv temp_plot_gen.m ${OUT_PATH}_genfile.m

#octave temp_plot_gen.m
#rm temp_plot_gen.m


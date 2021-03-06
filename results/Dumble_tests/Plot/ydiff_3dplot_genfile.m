%%Octave

clear all
read_line=0;
line_i=1;

#Input Files#
input_file_1="../../../results/Dumble_tests/slbf_values.txt";
input_file_2="../../../results/Dumble_tests/subf_values.txt";

#Output Name#
output_name="ydiff_3dplot_down";

#Axis Options#
z_axis=3;
y_axis=4;
x_axis=1;

#Data Save#
rff=fopen(input_file_1); 
fgetl(rff); 
while(-1 ~= (line=fgetl(rff))) 
	val=str2num(line); 
	data_1(line_i++,:)=val; 
end 
fclose(rff);

read_line=0;
line_i=1;

rff=fopen(input_file_2); 
fgetl(rff); 
while(-1 ~= (line=fgetl(rff))) 
	val=str2num(line); 
	data_2(line_i++,:)=val; 
end 
fclose(rff); 

#Plotting Curve#
tri=delaunay(data_1(:,x_axis),data_1(:,y_axis)); 
trisurf(tri, data_1(:,x_axis), data_1(:,y_axis), data_1(:,z_axis)-data_2(:,z_axis)); 
set(gca, 'XScale', 'log', 'YScale', 'log'); 
view(-55,-15); 


#Plotting Line#

#Set Labels#
xlabel("Memory Used (thread1)");
ylabel("Memory Used (thread2)");
zlabel("Delta Difference");

#Save Output#
print(strcat("",output_name,"_faceted"), '-depsc'); 
shading interp 
print(strcat("",output_name,"_interp"), '-depsc'); 
close all

clear all

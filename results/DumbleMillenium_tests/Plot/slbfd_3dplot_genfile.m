%%Octave

clear all
read_line=0;
line_i=1;

#Input Files#
input_file="../../../results/DumbleMillenium_tests/slbf_values.txt";

#Output Name#
output_name="slbfd_3dplot";

#Axis Options#
z_axis=3;
y_axis=4;
x_axis=1;

#Data Save#
rff=fopen(input_file); 
fgetl(rff); 
while(-1 ~= (line=fgetl(rff))) 
	val=str2num(line); 
	data(line_i++,:)=val; 
end 
fclose(rff); 


#Static Lines#

#Plotting Curve#
tri=delaunay(data(:,x_axis),data(:,y_axis)); 
trisurf(tri, data(:,x_axis), data(:,y_axis), data(:,z_axis)); 
set(gca, 'XScale', 'linear', 'YScale', 'log'); 
view(-55,-15); 


#Plotting Line#

#Set Labels#
xlabel("Memory Used (thread1)");
ylabel("Memory Used (thread2)");
zlabel("Delta (thread1)");

#Save Output#
print(strcat("",output_name,"_faceted"), '-depsc'); 
shading interp 
print(strcat("",output_name,"_interp"), '-depsc'); 
close all

clear all

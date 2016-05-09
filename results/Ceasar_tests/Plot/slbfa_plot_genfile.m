%%Octave

clear all
read_line=0;
line_i=1;

#Input Files#
input_file_1="../slbf_values.txt";

#Output Name#
output_name="slbfa_plot";


#Axis Options#
y_axis_1=2;
x_axis_1=1;

#Data Save#
rff=fopen(input_file_1);
fgetl(rff);
while(-1 ~= (read_line=fgetl(rff)))
	val=str2num(read_line);
	data_1(line_i++,:)=val(1:3);
end
line_i=1;
fclose(rff);


#Static Lines#

#Plotting Curve#
hold on;
plot(data_1(:,x_axis_1), data_1(:,y_axis_1), "-ob");

#Plotting Line#

#Set Labels#
xlabel("Loops");
ylabel("Lower Alpha");


#Save Output#
print(strcat("",output_name), '-depsc');
hold off 
close 

clear all

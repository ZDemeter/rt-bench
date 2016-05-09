%%Octave

clear all
read_line=0;
line_i=1;

#Input Files#
input_file_1="../../../results/Albertrrrerun_tests/slbf_values.txt";

#Output Name#
output_name="slbfd_plot";


#Axis Options#
y_axis_1=3;
x_axis_1=1;

#Data Save#
rff=fopen(input_file_1);
fgetl(rff);
while(-1 ~= (read_line=fgetl(rff)))
	val=str2num(read_line);
	data_1(line_i++,:)=val;
end
line_i=1;
fclose(rff);


#Static Lines#
stat_line_1=0.005997;

#Plotting Curve#
hold on;
semilogx(data_1(:,x_axis_1), data_1(:,y_axis_1), "-ob");

#Plotting Line#
plot([data_1(1,x_axis_1) data_1(end,x_axis_1)], [stat_line_1 stat_line_1], "-kr");

#Set Labels#
xlabel("Memory(doubles)");
ylabel("Lower Delta");


#Save Output#
print(strcat("",output_name), '-depsc');
hold off 
close 

clear all

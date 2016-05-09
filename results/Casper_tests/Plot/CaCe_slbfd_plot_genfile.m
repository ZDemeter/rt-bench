%%Octave

clear all
read_line=0;
line_i=1;

#Input Files#
input_file_2="../../../results/Ceasar_tests/slbf_values.txt";
input_file_1="../../../results/Casper_tests/slbf_values.txt";

#Output Name#
output_name="CaCe_slbfd_plot";


#Axis Options#
y_axis_2=3;
x_axis_2=1;
y_axis_1=3;
x_axis_1=1;

#Data Save#
rff=fopen(input_file_2);
fgetl(rff);
while(-1 ~= (read_line=fgetl(rff)))
	val=str2num(read_line);
	data_2(line_i++,:)=val*3;
end
line_i=1;
fclose(rff);

rff=fopen(input_file_1);
fgetl(rff);
while(-1 ~= (read_line=fgetl(rff)))
	val=str2num(read_line);
	data_1(line_i++,:)=val;
end
line_i=1;
fclose(rff);


#Static Lines#

#Plotting Curve#
hold on;
Ca=plot(data_2(:,x_axis_2), data_2(:,y_axis_2), "-or");
Ce=plot(data_1(:,x_axis_1), data_1(:,y_axis_1), "-ob");
legend([Ca;Ce], ["Casper";"Ceasar"])

#Plotting Line#

#Set Labels#
xlabel("Loops");
ylabel("Lower Delta");


#Save Output#
print(strcat("",output_name), '-depsc');
hold off 
close 

clear all

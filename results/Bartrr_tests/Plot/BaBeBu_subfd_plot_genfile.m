%%Octave

clear all
read_line=0;
line_i=1;

#Input Files#
input_file_3="../subf_values.txt";
input_file_2="../../Bertrr_tests/subf_values.txt";
input_file_1="../../Burtrr_tests/subf_values.txt";

#Output Name#
output_name="BaBeBu_subfd_plot";


#Axis Options#
y_axis_3=3;
x_axis_3=1;
y_axis_2=3;
x_axis_2=1;
y_axis_1=3;
x_axis_1=1;

#Data Save#
rff=fopen(input_file_3);
fgetl(rff);
while(-1 ~= (read_line=fgetl(rff)))
	val=str2num(read_line);
	data_3(line_i++,:)=val;
end
line_i=1;
fclose(rff);

rff=fopen(input_file_2);
fgetl(rff);
while(-1 ~= (read_line=fgetl(rff)))
	val=str2num(read_line);
	data_2(line_i++,:)=val;
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
Ba=semilogx(data_3(:,x_axis_3), data_3(:,y_axis_3), "-or");
Be=semilogx(data_2(:,x_axis_2), data_2(:,y_axis_2), "-og");
Bu=semilogx(data_1(:,x_axis_1), data_1(:,y_axis_1), "-ob");
legend([Ba;Be;Bu], ["Bartrr";"Bertrr";"Burtrr"]);

#Plotting Line#

#Set Labels#
xlabel("Memory(doubles)");
ylabel("Upper Delta");


#Save Output#
print(strcat("",output_name), '-depsc');
hold off 
close 

clear all

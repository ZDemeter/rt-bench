%%Octave
clear all

read_line=0;
line_i=1;


#Input Files#
input_file_3="../slbf_values.txt";
input_file_2="../../Bert_tests/slbf_values.txt";
input_file_1="../../Burt_tests/slbf_values.txt";

#Output Name#
output_name="cache_BaBeBu_slbfa_plot";


#Axis Options#
y_axis_3=2;
x_axis_3=1;
y_axis_2=2;
x_axis_2=1;
y_axis_1=2;
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
stat_line_1=768000;

#Plotting Curve#
hold on;
Ba=semilogx(data_3(:,x_axis_3), data_3(:,y_axis_3), "-or");
Be=semilogx(data_2(:,x_axis_2), data_2(:,y_axis_2), "-og");
Bu=semilogx(data_1(:,x_axis_1), data_1(:,y_axis_1), "-ob");
legend([Ba;Be;Bu], ["Bart";"Bert";"Burt"]);
#Plotting Line#
plot([stat_line_1 stat_line_1], get(gca, 'ylim'), "-kr");

#Set Labels#
xlabel("Memory(doubles)");
ylabel("Lower Alpha");


#Save Output#
print(strcat("",output_name), '-depsc');
hold off 
close 
clear all

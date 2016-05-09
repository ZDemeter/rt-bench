%%Octave

read_line=0;
line_i=1;

#Input Files#
input_file_1="../slbf_values.txt";
input_file_2="../subf_values.txt";

#Output Name#
output_name="ydiff_plot";


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
fclose(rff);

read_line=0;
line_i=1;

rff=fopen(input_file_2);
fgetl(rff);
while(-1 ~= (read_line=fgetl(rff)))
	val=str2num(read_line);
	data_2(line_i++,:)=val;
end
line_i=1;
fclose(rff);


#Plotting Curve#
hold on;

xt=data_1(:,x_axis_1);
for i=1:numel(data_1(:,y_axis_1))
	yt(i)=data_1(i,y_axis_1)-data_2(i,y_axis_1);
end

#semilogx(data_1(:,x_axis_1), data_1(:,y_axis_1), "-ob");

fill([xt(1);xt(:);xt(end)], [0;yt(:);0], 'm');

set(gca,'xscale','log');

#Set Labels#
xlabel("Memory(doubles)");
ylabel("Delta Difference");


#Save Output#
print(strcat("",output_name), '-depsc');
hold off 
close 

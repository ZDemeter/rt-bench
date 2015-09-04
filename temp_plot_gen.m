%%Octave

line=0;
line_i=1;

input_file_1="results/Fall_tests50/slbf_values.txt";

output_name="test_plot";

y_axis_1=2
x_axis_1=1

rff=open(input_file_1); 
fgetl(rff); 
while(-1 ~= (line=fgetl(rff))) 
	val=str2num(line); 
	data_1(line_i++,:)=val; 
end 
fclose(rff); 


stat_line_1=0.997989

hold on
plot(data_1(:,x_axis_1), data_1(:,y_axis_1), "-ob");

plot([data_1(1,x_axis_1) data_1(end,x_axis_1)], [stat_line_1 stat_line_1], "-k");

print(output_name, '-depsc');
hold off


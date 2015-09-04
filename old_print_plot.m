%%Octave

line=0;
line_i=1;
input_file=(
"results/Quick_tests/slbf_values.txt"
);
output_name=(
"results/Quick_tests/slbf_values"
);
line_roof=0.97;
num_axis=1;
alpha_axis=2;
delta_axis=3;
lim=1;

rff=fopen(input_file);
printf('rff value: %i\n', rff)

fgetl(rff);
while(-1 ~= (line=fgetl(rff)))
	val=str2num(line);
	val(2);
	if(val(2)>0 && val(2)<lim)
		outps(line_i++,:)=val;
	end
end
fclose(rff);
plot(outps(:,num_axis), outps(:,alpha_axis), "-ob");
hold on
plot([outps(1,num_axis) outps(end,num_axis)], [line_roof line_roof], "-k");
print(output_name, '-depsc');
hold off

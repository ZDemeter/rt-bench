%%Octave

line=0;
line_i=1;
input_file=(
"results/Quick_tests/other_values.txt"
);
output_name=(
"temp_output"
);
roof_line=0.97;
colx=1;
coly=2;
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
plot(outps(:,colx), outps(:,coly), '-d');
hold on
plot(outps(:,colx), roof_line, '-k');
print(output_name, '-depsc');
hold off

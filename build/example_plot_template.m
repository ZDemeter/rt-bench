%%Octave

line=0;
line_i=1;
input_file=(
"INP_PATH"
);
output_name=(
"OUTP_NAME"
);
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
hold on
fclose(rff);
plot(outps(:,colx), outps(:,coly), '-d');
%ADDLINE%plot(outps(:,colx), PLOT_LINE, '-d');
print(output_name, '-depsc');
hold off

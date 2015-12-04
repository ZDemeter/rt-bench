%%Octave

%Create 3D plot tests

PATH="results/Bart_tests/slbf_values.txt"

lim=1
line_i=1;
rff=fopen(PATH);
printf('rff value: %i\n', rff)

fgetl(rff);
while(-1 ~= (line_line=fgetl(rff)))
	val=str2num(line_line);
	val(1);
	if(val(2)>0 && val(2)<lim)
		outps(line_i++,:)=val;
	end
end
fclose(rff);

outps(:,1);

size(outps(:,1));
%{
mesh(outps)
%}
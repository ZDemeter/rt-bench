%%Octave

read_line=0;
line_i=1;
input_file=(
"../results/Bart_tests/slbf_values.txt"
);
output_name=(
"OUTP_NAME"
);
colx=1;
coly=2;
colz=3;
lim=1;

rff=fopen(input_file);
printf('rff value: %i\n', rff)

fgetl(rff);
while(-1 ~= (read_line=fgetl(rff)))
	val=str2num(read_line);
	val(1)
	if(val(2)>0 && val(2)<lim)
		outps(line_i++,:)=val;
	end
end
%outps
fclose(rff);


mesh(outps(:,colx), outps(:,coly), outps(:,colz) '-d');

print(output_name, '-depsc');



tri=delaunay(outps(:,x_axis), outps(:,y_axis));
trisurf(tri, outps(:,x_axis), outps(:,y_axis), outps(:,z_axis));
set(gca, 'xscale', 'log', 'yscale', 'log')
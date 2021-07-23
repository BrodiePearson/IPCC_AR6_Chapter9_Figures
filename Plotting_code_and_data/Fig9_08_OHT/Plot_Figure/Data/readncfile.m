% readncfile(fname)
% To use this script, you must set fname to equal the filename
A=ncinfo(fname);

for ll=1:length(A.Variables(:))
eval([A.Variables(ll).Name,'=ncread(fname,A.Variables(ll).Name);']);
end

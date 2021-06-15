function  IPCC_Write_NetCDF_Field(ncfilename, var_name, var_units, var, ...
     dim2_name, dim2, title, comments, hatching_mask)
%IPCC_Write_NetCDF_Field creates a NetCDF file containing a 2D field
%
%   IPCC_Write_NetCDF_Field(ncfilename, var_name, var_units, var, ...
%    dim1_name, dim1, dim2_name, dim2, comments, hatching_mask)
%
% Input variables:
%           ncfilename - name of netcdf file to be written 
%           var_name - The name that variable should be given in NC file
%           var_units - units of the variable
%           var - The mapped variable to be written to NC file
%           dim2_name - string name of second dimension (i.e. 'Latitude' or 'Temperature')
%           dim2 - second dimension vector
%           title - full description of figure
%           comments - any additional comments
%
% Output variables:
%           hatching_mask - mask of values for hatching (if neccessary)
%
% Function written by Brodie Pearson

% Check for existence of file
if exist(ncfilename)==2
    delete(ncfilename);
end

creator = "Brodie Pearson (brodie.pearson@oregonstate.edu)";
activity = "IPCC AR6 (Chapter 9)";
mask_note = "Mask has a value of 1 where >=80% of models agree on sign";

% Create variables in netcdf files
nccreate(ncfilename,var_name,'Dimensions', ...
    {dim2_name,size(dim2,1)});
if exist('hatching_mask')==1
    nccreate(ncfilename,'Mask','Dimensions', ...
        {dim2_name,size(dim2,1)});
end
nccreate(ncfilename,dim2_name, ...
    'Dimensions', {dim2_name,size(dim2,1)});

% Write variables to netcdf files
ncwrite(ncfilename,var_name,var);
if exist('hatching_mask')==1
    ncwrite(ncfilename,'Mask',hatching_mask);
end
ncwrite(ncfilename,dim2_name,dim2);

% Write metadata to netcdf file
ncwriteatt(ncfilename,'/','title',title);
ncwriteatt(ncfilename,'/','units',var_units);
ncwriteatt(ncfilename,'/','creator',creator);
ncwriteatt(ncfilename,'/','activity',activity);
ncwriteatt(ncfilename,'/','comments',comments);
if exist('hatching_mask')==1
    ncwriteatt(ncfilename,'/','mask_note',mask_note);
end



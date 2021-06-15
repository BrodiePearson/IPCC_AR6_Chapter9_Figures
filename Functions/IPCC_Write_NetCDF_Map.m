function  IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, var, ...
    latitude, longitude, title, comments, hatching_mask)
%IPCC_Write_NetCDF_Map creates a NetCDF file containing IPCC Map data
%
%   IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, var, ...
%       latitude, longitude, title, comments, hatching_mask)
%
% Input variables:
%           ncfilename - name of netcdf file to be written 
%           var_name - The name that variable should be given in NC file
%           var_units - units of the variable
%           var - The mapped variable to be written to NC file
%           latitude - input vector of latitude
%           longitude - input vector of longitudes
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
    {'Latitude',size(latitude,1), 'Longitude',size(longitude,1)});
if exist('hatching_mask')==1
    nccreate(ncfilename,'Mask','Dimensions', ...
        {'Latitude',size(latitude,1), 'Longitude',size(longitude,1)});
end
nccreate(ncfilename,'Latitude', ...
    'Dimensions', {'Latitude',size(latitude,1)});
nccreate(ncfilename,'Longitude', ...
    'Dimensions', {'Longitude',size(longitude,1)});

% Write variables to netcdf files
ncwrite(ncfilename,var_name,var);
if exist('hatching_mask')==1
    ncwrite(ncfilename,'Mask',hatching_mask);
end
ncwrite(ncfilename,'Latitude',latitude);
ncwrite(ncfilename,'Longitude',longitude);

% Write metadata to netcdf file
ncwriteatt(ncfilename,'/','title',title);
ncwriteatt(ncfilename,'/','units',var_units);
ncwriteatt(ncfilename,'/','creator',creator);
ncwriteatt(ncfilename,'/','activity',activity);
ncwriteatt(ncfilename,'/','comments',comments);
if exist('hatching_mask')==1
    ncwriteatt(ncfilename,'/','mask_note',mask_note);
end



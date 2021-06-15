function  IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, var, ...
    time, title, comments)
%IPCC_Write_NetCDF_timeseries creates a NetCDF file containing IPCC timeseries data
%
%   IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, var, ...
%       time, title, comments)
%
% Input variables:
%           ncfilename - name of netcdf file to be written 
%           var_name - The name that variable should be given in NC file
%           var_units - units of the variable
%           var - The mapped variable to be written to NC file
%           time - input vector of times
%           title - full description of figure
%           comments - any additional comments
%
%
% Function written by Brodie Pearson

% Check for existence of file
if exist(ncfilename)==2
    delete(ncfilename);
end

creator = "Brodie Pearson (brodie.pearson@oregonstate.edu)";
activity = "IPCC AR6 (Chapter 9)";

% Create variables in netcdf files
nccreate(ncfilename,var_name,'Dimensions', ...
    {'Time',size(time,1)});
nccreate(ncfilename,'Time', ...
    'Dimensions', {'Time',size(time,1)});

% Write variables to netcdf files
ncwrite(ncfilename,var_name,var);
ncwrite(ncfilename,'Time',time);

% Write metadata to netcdf file
ncwriteatt(ncfilename,'/','title',title);
ncwriteatt(ncfilename,'/','units',var_units);
ncwriteatt(ncfilename,'/','creator',creator);
ncwriteatt(ncfilename,'/','activity',activity);
ncwriteatt(ncfilename,'/','comments',comments);




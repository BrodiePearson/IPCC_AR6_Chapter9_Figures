%% IPCC AR6 Chapter 9 Example plotting with metadata
%
% This code demonstrates loading the IPCC-format data from Figure 9.3 and
% using this data to plot some Figure 9.3 subpanel maps. This bypasses the 
% need to download CMIP6 data and run the calculation and plotting code
% that is also provided in this directory.
%
% Written by Brodie Pearson

clear all

hist_change_start_year = 1950;
hist_change_end_year = 2014;
SSP_change_end_year = 2100;
HRSSP_change_end_year = 2050;

addpath ../../../Functions/

fontsize = 15;

%% Plot a mapped field (Panel 9.3b; climatology of HadISST) 

color_bar = IPCC_Get_Colorbar('temperature_nd', 21, false);

ncfilename = '../Plotted_Data/Fig9-3b_data.nc';
SST_OBS = ncread(ncfilename, 'SST')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

lims = [-2 30];

IPCC_Plot_Map(SST_OBS',lat,lon,lims, ...
    color_bar,"Observation-based Climatology (HadISST)",...
    1,fontsize, true, 'Sea Surface Temperature (SST; ^oC)')

%% Set colorbar for change rates instead of climatological temperatures

lim_max = 0.8;

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
color_bar = [color_bar2(3:11,:); color_bar1];

lims = [-0.4 1]*lim_max;

%% Hatching example (uses stippling rather than hatching)
% Plot CMIP modern SST rate of change Panel 9.3f

ncfilename = '../Plotted_Data/Fig9-3f_data.nc';
multimodel_change_CMIP = ncread(ncfilename, 'SST_ChangeRate');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(multimodel_change_CMIP ...
    ,lat,lon,lims, color_bar, ...
    "CMIP rate of change ("+hist_change_start_year+"-"+hist_change_end_year+")",2, ...
    fontsize,false,'')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,~logical(hatch'))

%% IPCC AR6 Chapter 9: Figure 9.11 (Surface speed maps)
%
% Code used to plot pre-processed surface speed maps. 
%
% Plotting code written by Brodie Pearson
% CMIP processed data provided by Yongqiang Yu & Lijuan Hua 

clear all

addpath ../../../Functions/
fontsize=20;

color_bar = IPCC_Get_Colorbar('temperature_nd', 21, true);
change_color_bar = IPCC_Get_Colorbar('temperature_d', 21, true);
lims = [0 0.5];
change_lims = [-1 1]*0.1;

%% Plot historical speeds

ncfilename = '../Plotted_Data/Fig9-11d_data.nc';
plot_var1 = ncread(ncfilename, 'surface_speed')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map(plot_var1' ...
    ,lat,lon,lims, ...
    color_bar,"CMIP Speed",...
    1,fontsize, true, '(m s^{-1})')


%% Plot SSP585 change in speeds (first validation maps)

ncfilename = '../Plotted_Data/Fig9-11e_data.nc';
speed_change = ncread(ncfilename, 'surface_speed_change');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(speed_change ...
    ,lat,lon,change_lims, ...
    change_color_bar,"SSP5-8.5 Speed Change",...
    2,fontsize, true,'(m s^{-1})')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(speed_change') & speed_change'~=0))

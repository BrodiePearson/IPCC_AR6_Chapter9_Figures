%% IPCC AR6 Chapter 9: Figure 9.11 (Barotropic Streamfunction maps)
%
% Code used to plot pre-processed barotropic streamfunction maps. 
%
% Plotting code written by Brodie Pearson
% CMIP processed data provided by Yongqiang Yu & Lijuan Hua 

clear all

addpath ../../../Functions/
fontsize=20;

color_bar = IPCC_Get_Colorbar('precip_d', 21, true);
change_color_bar = IPCC_Get_Colorbar('temperature_d', 21, true);
lims = [-200 200];
change_lims = [-20 20];

%% Plot historical BSFs

ncfilename = '../Plotted_Data/Fig9-11a_data.nc';
plot_var1 = ncread(ncfilename, 'msftbarot')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map(plot_var1' ...
    ,lat,lon,lims, ...
    color_bar,"CMIP BSF [10^9 kg s^{-1}]",...
    1,fontsize, true, '(10^9 kg s^{-1})')


%% Now plot change maps for figure

ncfilename = '../Plotted_Data/Fig9-11b_data.nc';
BSF_change = ncread(ncfilename, 'msftbarot_change');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(BSF_change ...
    ,lat,lon,change_lims, ...
    change_color_bar,"SSP5-8.5 Speed Change",...
    2,fontsize, true,'(m s^{-1})')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(BSF_change') & BSF_change'~=0))

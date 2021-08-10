%% IPCC AR6 Chapter 9: Figure 9.12 (Sea Level Rise)
%
% Code used to plot processed ocean sea-level rise data. 
%
% Plotting code written by Brodie Pearson

clear all

addpath ../../../Functions/

fontsize = 20;

color_bar = IPCC_Get_Colorbar('precip_nd', 21, false);

lims = [0 1]*0.4;

%% Plot OMIP high-res SSH standard deviation map 

ncfilename = '../Plotted_Data/Fig9-12h_data.nc';
plot_var1 = ncread(ncfilename, 'SSH_std')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map_Gappy(plot_var1' ...
    ,lat,lon,lims, ...
    color_bar,"OMIP High-res SSH std 1995-2014",...
    1,fontsize, true, '(m^{-2})')

%% Plot OMIP low-res SSH standard deivation map 

ncfilename = '../Plotted_Data/Fig9-12i_data.nc';
plot_var1 = ncread(ncfilename, 'SSH_std')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map_Gappy(plot_var1' ...
    ,lat,lon,lims, ...
    color_bar,"OMIP Low-res SSH std 1995-2014",...
    2,fontsize, true, '(m^{-2})')


%% Plot observed SSH standard deviation map 

ncfilename = '../Plotted_Data/Fig9-12g_data.nc';
plot_var1 = ncread(ncfilename, 'SSH_std')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map_Gappy(plot_var1' ...
    ,lat,lon,lims, ...
    color_bar,"Observed SSH std 1995-2014",...
    3,fontsize, true, '(m^{-2})')

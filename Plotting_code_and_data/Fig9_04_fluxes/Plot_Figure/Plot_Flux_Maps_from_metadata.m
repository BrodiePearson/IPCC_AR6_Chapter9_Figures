%% IPCC AR6 Chapter 9: Figure 9.4 (Surface Flux maps)
%
% Code used to plot the surface fluxes 
% using IPCC-formatted metadata (rather than direct CMIP output)
%
%
% Written by Brodie Pearson 

clear all

fontsize = 20;

addpath ../../../Functions/

% Define reference period for 'present-day' maps
ref_start_yr = 1995;
ref_end_yr = 2014;

change_color_bar = IPCC_Get_Colorbar('misc_d', 21, false);
wfo_color_bar = IPCC_Get_Colorbar('precip_d', 21, false);
heat_flux_color_bar = IPCC_Get_Colorbar('temperature_d', 21, false);
tau_color_bar = IPCC_Get_Colorbar('wind_nd', 21, true);

wfo_max = 250;
wfo_min= -wfo_max;
heat_flux_max = 300;
heat_flux_min = -heat_flux_max;
tau_max = 0.25;
tau_min = 0;
wfo_change_max = 35;
wfo_change_min= -wfo_change_max;
heat_flux_change_max = 10;
heat_flux_change_min = -heat_flux_change_max;
tau_change_max = 0.025;
tau_change_min = -tau_change_max;
hist_start_year = {'1995'};
hist_end_year = {'2014'};
ssp_start_year = {'2081'};
ssp_end_year = {'2100'};


%%

ncfilename = '../Plotted_Data/Fig9-4a_data.nc';
plot_var3 = ncread(ncfilename, 'wfo')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map(plot_var3',lat',lon',[wfo_min wfo_max], ...
    wfo_color_bar,"Observed Freshwater Flux ("+ref_start_yr+"-"+ref_end_yr+")",...
    1,fontsize, true, 'cm yr^{-1}')


%%

ncfilename = '../Plotted_Data/Fig9-4d_data.nc';
plot_var3 = ncread(ncfilename, 'hfds')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map(plot_var3',lat',lon',[heat_flux_min heat_flux_max], ...
    heat_flux_color_bar,"Observed Flux ("+ref_start_yr+"-"+ref_end_yr+")",...
    2,fontsize, true, 'W m^{-2}')


%%

ncfilename = '../Plotted_Data/Fig9-4g_data.nc';
plot_var3 = ncread(ncfilename, 'tau')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map(plot_var3',lat',lon',[tau_min tau_max], ...
    tau_color_bar,"Observed Wind Stress ("+ref_start_yr+"-"+...
    ref_end_yr+")",...
    3,fontsize, true, 'N m^{-2}')

ncfilename = '../Plotted_Data/Fig9-4g_data_tauu.nc';
norm_tauu = ncread(ncfilename, 'tauu')';
gap=25;
quiver_lat=lat(1:gap/5:end)';
quiver_lon=lon(1:gap:end)';
ncfilename = '../Plotted_Data/Fig9-4g_data_tauv.nc';
norm_tauv = ncread(ncfilename, 'tauv')';

[new_lat,new_lon]=meshgrid(quiver_lat,quiver_lon);

quiverm(new_lat',new_lon',100*norm_tauv,100*norm_tauu,'k')


%%

ncfilename = '../Plotted_Data/Fig9-4b_data.nc';
plot_var3 = ncread(ncfilename, 'wfo_trend')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(plot_var3',lat',lon',[wfo_change_min wfo_change_max], ...
    change_color_bar,"Observed Trend ("+ref_start_yr+"-"+ref_end_yr+")",...
    4,fontsize, true,'cm yr^{-1} (10 yr)^{-1}') 


[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var3) & plot_var3~=0))

%%

ncfilename = '../Plotted_Data/Fig9-4e_data.nc';
plot_var3 = ncread(ncfilename, 'hfds_trend')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(plot_var3',lat',lon',[-35 35], ...
    change_color_bar,"Observed Trend ("+ref_start_yr+"-"+ref_end_yr+")",...
    5,fontsize, true, 'W m^{-2} (10 yr)^{-1}')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var3) & plot_var3~=0))

%%

ncfilename = '../Plotted_Data/Fig9-4h_data.nc';
plot_var3 = ncread(ncfilename, 'tau_trend')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(1e2*plot_var3',lat',lon',1e2*[tau_change_min tau_change_max], ...
    change_color_bar,"Observed Trend ("+ref_start_yr+"-"+ref_end_yr+")",...
    6,fontsize, true, '10^{-2} N m^{-2} (10 yr)^{-1}')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var3) & plot_var3~=0))

%% Calculate rate of change of freshwater flux

hist_start_year = {'1995'};
hist_end_year = {'2014'};
ssp_start_year = {'2081'};
ssp_end_year = {'2100'};

%% Plot projected freshwater flux rates of change

ncfilename = '../Plotted_Data/Fig9-4c_data.nc';
plot_var3 = ncread(ncfilename, 'wfo_trend')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(plot_var3',lat',lon',[wfo_change_min wfo_change_max]/3, ...
    change_color_bar,"",7,fontsize, true,'cm yr^{-1} (10 yr)^{-1}')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var3) & plot_var3~=0))

%% Calculate rate of change of wind stress magnitude

ncfilename = '../Plotted_Data/Fig9-4i_data.nc';
plot_var3 = ncread(ncfilename, 'tau_trend')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(1e2*plot_var3',lat',lon',1e2*[tau_change_min tau_change_max]/5, ...
    change_color_bar,"Rate of change (SSP5-8.5; "+str2num(hist_start_year{1})+...
    "-"+str2num(ssp_end_year{1})+")",...
    8,fontsize, true, '10^{-2} N m^{-2} (10 yr)^{-1}')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var3) & plot_var3~=0))


%% Calculate rate of change of net heat flux

ncfilename = '../Plotted_Data/Fig9-4f_data.nc';
plot_var3 = ncread(ncfilename, 'hfds_trend')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(plot_var3',lat',lon',[heat_flux_change_min heat_flux_change_max]/2, ...
    change_color_bar,"Rate of change (SSP5-8.5; "+str2num(hist_start_year{1})+...
    "-"+str2num(ssp_end_year{1})+")",...
    9,fontsize, true, 'W m^{-2} (10 yr)^{-1}')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var3) & plot_var3~=0))


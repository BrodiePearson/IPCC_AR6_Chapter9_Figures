%% IPCC AR6 Chapter 9 Figure 9.3 (SST change maps)
%
% Code used to plot the processed CMIP6 data created by Calculate_*.m
% Using IPCC-formatted metadata (rather than direct CMIP output)
%
% Written by Brodie Pearson

clear all

hist_change_start_year = 1950;
hist_change_end_year = 2014;
SSP_change_start_year = 2005;
SSP_change_end_year = 2100;
HRSSP_change_start_year = 2005;
HRSSP_change_end_year = 2050;
bias_start_year = 1995;
bias_end_year = 2014;

addpath ../../../Functions/

fontsize = 15;

%% Plot mean SST averaged over past few decades

color_bar = IPCC_Get_Colorbar('temperature_nd', 21, false);

lims = [-2 30];

ncfilename = '../Plotted_Data/Fig9-3b_data.nc';
SST_OBS = ncread(ncfilename, 'SST')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map(SST_OBS',lat,lon,lims, ...
    color_bar,"Observation-based Climatology (HadISST; "+bias_start_year+"-"+bias_end_year+")",...
    1,fontsize, true, 'Sea Surface Temperature (SST; ^oC)')

% print(gcf,'../PNGs/Observed_SST_colorbar_from_metadata.png','-dpng','-r1000', '-painters');
% close(1);


%% Load SSP585 data & Create a plot of future change under SSP585

lim_max = 0.8;

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
color_bar = [color_bar2(3:11,:); color_bar1];

lims = [-0.4 1]*lim_max;


%% Plot Observed modern SST rate of change 

ncfilename = '../Plotted_Data/Fig9-3c_data.nc';
SST_change_OBS = ncread(ncfilename, 'SST_ChangeRate')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map(SST_change_OBS' ...
    ,lat,lon,lims, color_bar, ...
    "Observation-based rate of change ("+hist_change_start_year+"-"+hist_change_end_year+")",2, ...
    fontsize,false)

% print(gcf,'../PNGs/Observed_SST_change_labels_from_metadata.png','-dpng','-r1000', '-painters');
% 
% close(2)

%% Plot CMIP modern SST rate of change

ncfilename = '../Plotted_Data/Fig9-3f_data.nc';
multimodel_change_CMIP = ncread(ncfilename, 'SST_ChangeRate');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(multimodel_change_CMIP ...
    ,lat,lon,lims, color_bar, ...
    "CMIP rate of change ("+hist_change_start_year+"-"+hist_change_end_year+")",3, ...
    fontsize,false,'')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(multimodel_change_CMIP') & multimodel_change_CMIP'~=0))

%print(gcf,'../PNGs/CMIP_SST_changelabel_from_metadata.png','-dpng','-r1000', '-painters');

% close(1)

%% Plot HighResMIP modern SST rate of change

ncfilename = '../Plotted_Data/Fig9-3i_data.nc';
multimodel_change_HRMIP = ncread(ncfilename, 'SST_ChangeRate');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(multimodel_change_HRMIP ...
    ,lat,lon,lims, color_bar, ...
    "HighResMIP rate of change ("+hist_change_start_year+"-"+hist_change_end_year+")",4, ...
    fontsize,false,'')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(multimodel_change_HRMIP') & multimodel_change_HRMIP'~=0))
% 
% print(gcf,'../PNGs/HRMIP_SST_changelabel_from_metadata.png','-dpng','-r1000', '-painters');
% close(1)

%% Plot SSP585 predicted SST rate of change

ncfilename = '../Plotted_Data/Fig9-3d_data.nc';
multimodel_change_SSP585 = ncread(ncfilename, 'SST_ChangeRate');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(multimodel_change_SSP585 ...
    ,lat,lon,lims,color_bar, ...
    "SSP5-8.5 rate of change ("+ ...
    SSP_change_start_year+"-"+SSP_change_end_year+")",5, ...
    fontsize, true, 'SST Rate of Change (^oC/decade)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(multimodel_change_SSP585') & multimodel_change_SSP585'~=0))

% print(gcf,'../PNGs/SSP585_SST_changelabel_from_metadata.png','-dpng','-r1000', '-painters');
% close(1)


%% Plot HighResMIP SSP585 predicted SST rate of change

ncfilename = '../Plotted_Data/Fig9-3j_data.nc';
multimodel_change_HRSSP = ncread(ncfilename, 'SST_ChangeRate');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(multimodel_change_HRSSP ...
    ,lat,lon,lims,color_bar, ...
    "HighResMIP SSP5-8.5 rate of change (" ...
    +HRSSP_change_start_year+"-"+HRSSP_change_end_year+")",6, ...
    fontsize, true, 'SST Rate of Change (^oC/decade)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(multimodel_change_HRSSP') & multimodel_change_HRSSP'~=0))

% print(gcf,'../PNGs/HRSSP_SST_changelabel_from_metadata.png','-dpng','-r1000', '-painters');
% close(1)


%% Maps of present model biases realtive to map of present SST (Fig 1)

color_bar = IPCC_Get_Colorbar('chem_d', 21, true);

lim_max = 3;
lim_min = -lim_max;
lims = [lim_min lim_max];


%% Plot CMIP SST bias vs. observations

ncfilename = '../Plotted_Data/Fig9-3e_data.nc';
multimodel_CMIP_bias = ncread(ncfilename, 'SST_Bias');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

% Averaging Index is shifted by 1 for biases
IPCC_Plot_Map(multimodel_CMIP_bias ...
    ,lat,lon,lims,color_bar, ...
    "CMIP Bias ("+bias_start_year+"-"+bias_end_year+")",7, ...
    fontsize,true,'Model Bias (^oC)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(multimodel_CMIP_bias') & multimodel_CMIP_bias'~=0))

% print(gcf,'../PNGs/CMIP_SST_biaslabel_from_metadata.png','-dpng','-r1000', '-painters');
% 
% close(1)

%% Plot HRMIP SST bias vs. observations

ncfilename = '../Plotted_Data/Fig9-3h_data.nc';
multimodel_HRMIP_bias = ncread(ncfilename, 'SST_Bias');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(multimodel_HRMIP_bias ...
    ,lat,lon,lims,color_bar, ...
    "HighResMIP Bias ("+bias_start_year+"-"+bias_end_year+")",8, ...
    fontsize, true, 'Model Bias (^oC)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(multimodel_HRMIP_bias') & multimodel_HRMIP_bias'~=0))
% 
% print(gcf,'../PNGs/HighResMIP_SST_biaslabel_from_metadata.png','-dpng','-r1000', '-painters');
% close(1)

%% Plot rate of change for CMIP 2005-2050 and for low- & high-res HighResMIP

ncfilename = '../Plotted_Data/Fig9-3g_data.nc';
multimodel_2050_change_SSP585 = ncread(ncfilename, 'SST_ChangeRate');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
color_bar = [color_bar2(3:11,:); color_bar1];

lim_max = 0.8;
lims = [-0.4 1]*lim_max;

IPCC_Plot_Map(multimodel_2050_change_SSP585 ...
    ,lat,lon,lims, color_bar, ...
    "SSP5-8.5 rate of change (2005-2050)",9, ...
    fontsize,false,'')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(multimodel_2050_change_SSP585') & multimodel_2050_change_SSP585'~=0))

% print(gcf,'../PNGs/CMIP_2050_SST_changelabel_from_metadata.png','-dpng','-r1000', '-painters');
% close(1)

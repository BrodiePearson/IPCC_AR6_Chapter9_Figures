%% IPCC AR6 Chapter 9: Figure 9.6 Maps (Ocean Heat Content)
%
% Code used to plot pre-processed ocean heat content data. 
%
% Plotting code written by Brodie Pearson
% CMIP processed data provided by Yongqiang Yu & Lijuan Hua 
% Other datasets cited in report/caption


clear all

fontsize = 20;

addpath ../../../Functions/

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
change_color_bar = [color_bar2(3:11,:); color_bar1];

trend_color_bar = IPCC_Get_Colorbar('temperature_d', 21, false);
bias_color_bar = IPCC_Get_Colorbar('chem_d', 21, false);

lim_max = 15;
change_lims = [-0.4 1]*lim_max/3;
trend_lims = [-1 1]*lim_max;
bias_lims = [-1 1]*lim_max;

%% Plot rate of change projection for SSP126

ncfilename = '../Plotted_Data/Fig9-6g_data.nc';
ssp126_change_rate = ncread(ncfilename, 'OHC_ChangeRate');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(ssp126_change_rate ...
    ,lat,lon,change_lims, ...
    change_color_bar,"OHC change SSP1-2.6 (2005-2100)",...
    1,fontsize, true,'W m^{-2}')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(ssp126_change_rate') & ssp126_change_rate'~=0))

%% Plot SSP585 OHC change rate

ncfilename = '../Plotted_Data/Fig9-6d_data.nc';
ssp585_change_rate = ncread(ncfilename, 'OHC_ChangeRate');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(ssp585_change_rate ...
    ,lat,lon,change_lims, ...
    change_color_bar,"OHC change SSP5-8.5 (2005-2100)",...
    2,fontsize, true,'W m^{-2}')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(ssp585_change_rate') & ssp585_change_rate'~=0))

%% Plot obseved trends and biases in upper 2000m and CMIP bias

ncfilename = '../Plotted_Data/Fig9-6e_data.nc';
obs_trend_0to2000m = ncread(ncfilename, 'OHC_Trend');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map(obs_trend_0to2000m ...
    ,lat,lon,trend_lims, ...
    trend_color_bar,"Observed OHC trend 0-2000m (2005-2014)",...
    3,fontsize, true,'W m^{-2}')

%% Plot CMIP bias

ncfilename = '../Plotted_Data/Fig9-6f_data.nc';
cmip_0to2000m_bias = ncread(ncfilename, 'OHC_bias');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(cmip_0to2000m_bias ...
    ,lat,lon,bias_lims, ...
    bias_color_bar,"CMIP trend bias 0-2000m (2005-2014)",...
    4,fontsize, true,'W m^{-2}')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(cmip_0to2000m_bias') & cmip_0to2000m_bias'~=0))


%% Plot obseved trends and biases in upper 700m and CMIP bias


ncfilename = '../Plotted_Data/Fig9-6b_data.nc';
obs_trend_0to700m = ncread(ncfilename, 'OHC_Trend');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map(obs_trend_0to700m ...
    ,lat,lon,trend_lims/5, ...
    trend_color_bar,"Observed OHC trend 0-700m (2005-2014)",...
    5,fontsize, true,'W m^{-2}')

%%

ncfilename = '../Plotted_Data/Fig9-6c_data.nc';
cmip_0to700m_bias = ncread(ncfilename, 'OHC_bias');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(cmip_0to700m_bias ...
    ,lat,lon,bias_lims/5, ...
    bias_color_bar,"CMIP trend bias 0-700m (2005-2014)",...
    6,fontsize, true,'W m^{-2}')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(cmip_0to2000m_bias') & cmip_0to2000m_bias'~=0))

%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surfact temperature (SST) - named tos in CMIP6 

clear all

addpath ../../Matlab_Functions/

%data_path = '/Volumes/Seagate_IPCC/IPCC/tos/Gridded_1degree/';
data_path = '/Volumes/PromiseDisk/AR6_Data/tos/';

var_name = {'tos'};
fontsize = 25;

averaging_window_width = 10; %years

hist_change_start_year = 1950;
hist_change_end_year = 2014;

%% Load observational dataset

% Specify observation (HadISST) start year and eny year
obs_start_yr = 1870;
obs_end_yr = 2017;

data_dir = data_path + "observations/OBS_HadISST_reanaly_1_Omon_tos_" ...
    + obs_start_yr + "-" + obs_end_yr + ".nc";
SST_OBS = ncread(data_dir,'tos');
lat = ncread(data_dir,'lat');
lon = ncread(data_dir,'lon');
SST_OBS = SST_OBS - 273.15;

%% Get maps of model tos rate of change for historical time periods

[SST_change_CMIP lat lon] = IPCC_CMIP6_ChangeMap('historical', var_name, data_path, ...
    hist_change_start_year, hist_change_end_year, averaging_window_width);
SST_change_CMIP = squeeze(SST_change_CMIP);

%CMIP_model_names = IPCC_Which_Models(data_path,{'historical'},'CMIP6_','_');
IPCC_Get_CMIP6_Metadata(data_path, {'historical'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3e_md.csv', 'e',false)
IPCC_Get_CMIP6_Metadata(data_path, {'historical'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3f_md.csv', 'f',false)
IPCC_Get_CMIP6_Metadata(data_path, {'historical'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3a_md_CMIP.csv', 'a',false)

[SST_change_HRMIP lat lon] = IPCC_CMIP6_ChangeMap('hist-1950', var_name, data_path, ...
    hist_change_start_year, hist_change_end_year, averaging_window_width);
SST_change_HRMIP = squeeze(SST_change_HRMIP);

%HRMIP_model_names = IPCC_Which_Models(data_path,{'hist-1950'},'CMIP6_','_');
IPCC_Get_CMIP6_Metadata(data_path, {'hist-1950'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3h_md.csv', 'h',false)
IPCC_Get_CMIP6_Metadata(data_path, {'hist-1950'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3i_md.csv', 'i',false)
IPCC_Get_CMIP6_Metadata(data_path, {'hist-1950'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3a_md_historical_HighResMIP.csv', 'a',false)
IPCC_Get_CMIP6_Metadata(data_path, {'highres-future'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3a_md_projection_HighResMIP.csv', 'a',false)

%% Repeat for observations

% define indices for observation changes
index_start_yr = (hist_change_start_year - obs_start_yr)*12 +1; % Start in January
index_end_yr = (hist_change_end_year - obs_start_yr)*12 +12; % End in December

% Calculate change in tos across period (then convert to rate of change)
SST_change_OBS = ...
nanmean(SST_OBS(:,:,index_end_yr-averaging_window_width*12 + 1:index_end_yr),3) - ...
nanmean(SST_OBS(:,:,index_start_yr:index_start_yr + averaging_window_width*12 - 1),3);

% turn change into a rate of change (units: degress/decade)
SST_change_OBS = 10*SST_change_OBS/(hist_change_end_year - ...
    hist_change_start_year + 0.5*averaging_window_width);

%% Get maps of tos rate of change for SSP585 (relative to modern)

SSP_change_start_year = 2005;
SSP_change_end_year = 2100;

[SST_change_SSP585 lat lon] = IPCC_CMIP6_ChangeMap('ssp585', var_name, data_path, ...
    SSP_change_start_year, SSP_change_end_year, averaging_window_width);
SST_change_SSP585 = squeeze(SST_change_SSP585);

IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3d_md.csv', 'd',true)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3g_md.csv', 'g',true)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3a_md_ssp585.csv', 'a',false)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp585-extended'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3a_md_ssp585_extended.csv', 'a',false)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp126-extended'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3a_md_ssp126_extended.csv', 'a',false)

[SST_change_SSP126 lat lon] = IPCC_CMIP6_ChangeMap('ssp126', var_name, data_path, ...
    SSP_change_start_year, SSP_change_end_year, averaging_window_width);
SST_change_SSP126 = squeeze(SST_change_SSP126);

IPCC_Get_CMIP6_Metadata(data_path, {'ssp126'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3a_md_ssp126.csv', 'a',false)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp245'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3a_md_ssp245.csv', 'a',false)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp370'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3a_md_ssp370.csv', 'a',false)

HRSSP_change_start_year = 2005;
HRSSP_change_end_year = 2050;

[SST_change_HRSSP lat lon] = IPCC_CMIP6_ChangeMap('highres-future', var_name, data_path, ...
    HRSSP_change_start_year, HRSSP_change_end_year, averaging_window_width);
SST_change_HRSSP = squeeze(SST_change_HRSSP);

[SST_change_SSP585_2050 lat lon] = IPCC_CMIP6_ChangeMap('ssp585', var_name, data_path, ...
    HRSSP_change_start_year, HRSSP_change_end_year, averaging_window_width);
SST_change_SSP585_2050 = squeeze(SST_change_SSP585_2050);

IPCC_Get_CMIP6_Metadata(data_path, {'highres-future'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-3j_md.csv', 'j',true)

%% Compare HighResMIP changes in High-res modes against those of the 
% low-res models run for the same experiment

temp_data_path = '/Volumes/PromiseDisk/AR6_Data/tos_HR_partners/';

[SST_change_HRSSP_HR lat lon] = IPCC_CMIP6_ChangeMap('highres-future', var_name, temp_data_path, ...
    HRSSP_change_start_year, HRSSP_change_end_year, averaging_window_width);
SST_change_HRSSP_HR = squeeze(SST_change_HRSSP_HR);

temp_data_path = '/Volumes/PromiseDisk/AR6_Data/tos_LR_partners/';

[SST_change_HRSSP_LR lat lon] = IPCC_CMIP6_ChangeMap('highres-future', var_name, temp_data_path, ...
    HRSSP_change_start_year, HRSSP_change_end_year, averaging_window_width);
SST_change_HRSSP_LR = squeeze(SST_change_HRSSP_LR);

%% Calculate bias maps

experiments = {'historical','hist-1950'};
bias_start_year = 1995;
bias_end_year = 2014;

SST_maps = IPCC_CMIP6_Map( ...
    experiments, var_name, data_path, bias_start_year, bias_end_year);

SST_CMIP = SST_maps{1};
SST_HRMIP = SST_maps{2};

% Get observational SST for the same period
index_start_yr = (bias_start_year - obs_start_yr)*12 +1; % Start in January
index_end_yr = (bias_end_year - obs_start_yr)*12 +12; % End in December

SST_OBS = nanmean(SST_OBS(:,:,index_start_yr:index_end_yr),3);

SST_bias_CMIP = SST_CMIP - SST_OBS;
SST_bias_HRMIP = SST_HRMIP - SST_OBS;

%% Save data

savefile = 'SST_Maps';

save(savefile, 'SST_change_CMIP', 'SST_change_HRMIP', ...
    'SST_change_SSP585', 'SST_change_SSP126', 'SST_change_HRSSP', ...
    'SST_OBS', 'SST_bias_CMIP', 'SST_bias_HRMIP', 'SST_change_OBS', ...
    'lat', 'lon', 'bias_start_year', 'bias_end_year', ...
    'hist_change_start_year', 'hist_change_end_year', ...
    'SSP_change_start_year', 'SSP_change_end_year', ...
    'HRSSP_change_start_year', 'HRSSP_change_end_year', ...
    'SST_change_SSP585_2050', 'SST_change_HRSSP_HR', ...
    'SST_change_HRSSP_LR', ...
    'averaging_window_width');
% 
% %%
% 
% model_names = IPCC_Which_Models(data_path, 'historical', 'CMIP6_', '_');
% % Load historical simulation for early time period
% ACCESS_dummy = IPCC_CMIP6_Load({'historical'}, 'tos', model_names(1), data_path);
% 
% %start of 2005 to end of 2014
% ACCESS_early = nanmean(ACCESS_dummy(:,:,1861:1980),3);
% 
% ACCESS_dummy = IPCC_CMIP6_Load({'ssp585'}, 'tos', model_names(1), data_path);
% 
% %start of 2091 to end of 2100
% ACCESS_late = nanmean(ACCESS_dummy(:,:,913:1032),3); 
% 
% ACCESS_change = 10*(ACCESS_late - ...
%     ACCESS_early)/(2100 - ...
%     2005 + 0.5*10);
% 
% load('SST_Maps_Newest', 'SST_change_SSP585');
% 
% figure
% subplot(3,1,1)
% imagesc(fliplr(SST_change_SSP585(:,:,:,1))')
% subplot(3,1,2)
% imagesc(fliplr(ACCESS_change)')
% subplot(3,1,3)
% imagesc(fliplr(SST_change_SSP585(:,:,:,1))' - fliplr(ACCESS_change)')


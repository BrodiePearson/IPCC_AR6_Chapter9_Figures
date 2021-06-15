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

[SST_change_HRMIP lat lon] = IPCC_CMIP6_ChangeMap('hist-1950', var_name, data_path, ...
    hist_change_start_year, hist_change_end_year, averaging_window_width);

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

%% Get maps of tos rate of change for SSP585 (relative to modern

SSP_change_start_year = 2005;
SSP_change_end_year = 2100;

[SST_change_SSP585 lat lon] = IPCC_CMIP6_ChangeMap('ssp585', var_name, data_path, ...
    SSP_change_start_year, SSP_change_end_year, averaging_window_width);

HRSSP_change_start_year = 2005;
HRSSP_change_end_year = 2050;

[SST_change_HRSSP lat lon] = IPCC_CMIP6_ChangeMap('highres-future', var_name, data_path, ...
    HRSSP_change_start_year, HRSSP_change_end_year, averaging_window_width);

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

savefile = 'SST_Maps_Newest';

save(savefile, 'SST_change_CMIP', 'SST_change_HRMIP', ...
    'SST_change_SSP585', 'SST_change_HRSSP', ...
    'SST_OBS', 'SST_bias_CMIP', 'SST_bias_HRMIP', 'SST_change_OBS', ...
    'lat', 'lon', 'bias_start_year', 'bias_end_year', ...
    'hist_change_start_year', 'hist_change_end_year', ...
    'SSP_change_start_year', 'SSP_change_end_year', ...
    'HRSSP_change_start_year', 'HRSSP_change_end_year', ...
    'averaging_window_width');

%%

model_names = IPCC_Which_Models(data_path, 'historical', 'CMIP6_', '_');
% Load historical simulation for early time period
ACCESS_dummy = IPCC_CMIP6_Load({'historical'}, 'tos', model_names(1), data_path);

%start of 2005 to end of 2014
ACCESS_early = nanmean(ACCESS_dummy(:,:,1861:1980),3);

ACCESS_dummy = IPCC_CMIP6_Load({'ssp585'}, 'tos', model_names(1), data_path);

%start of 2091 to end of 2100
ACCESS_late = nanmean(ACCESS_dummy(:,:,913:1032),3); 

ACCESS_change = 10*(ACCESS_late - ...
    ACCESS_early)/(2100 - ...
    2005 + 0.5*10);

load('SST_Maps_Newest', 'SST_change_SSP585');

figure
subplot(3,1,1)
imagesc(fliplr(SST_change_SSP585(:,:,:,1))')
subplot(3,1,2)
imagesc(fliplr(ACCESS_change)')
subplot(3,1,3)
imagesc(fliplr(SST_change_SSP585(:,:,:,1))' - fliplr(ACCESS_change)')



% save(savefile, 'SST_change_OBS', 'SST_change_CMIP', 'SST_change_HRMIP', ...
%     'SST_change_SSP585', 'SST_change_HRSSP', 'SST_ref_OBS', ...
%     'SST_bias_CMIP', 'SST_bias_HRMIP', 'lat', 'lon', 'proj_ssp_ave_start', ...
%     'proj_ssp_ave_end', 'hist_ave_start', 'hist_ave_end','ref_start', ...
%     'ref_end', 'proj_hrssp_ave_start','proj_hrssp_ave_end');


% 
% %%
% 
% [ssp585_rate_of_change_map lat lon] = IPCC_CMIP6_MapChange(ssp585, var_name, ...
%     data_path, 2004, 2100, 10)
% 
% % Define averaging length for start and end of 'change' calculations
% ave_period = 10; %years
% 
% % Define start and end years of obs, and CMIP6 experiments
% obs_start_yr = 1870;
% obs_end_yr = 2017;
% HRMIP_start_yr = 1950;
% CMIP_start_yr = 1850;
% SSP_start_yr = 2015;
% 
% % Define start and end years for change calculation
% hist_change_start = 1950;
% hist_change_end = 2014;
% ssp_change_start = 2015;
% ssp_change_end = 2100;
% hrssp_change_start = 2015;
% hrssp_change_end = 2050;
% 
% %Define start/end years of 'present-day' averaging period
% ref_start = 1995;
% ref_end = 2014;
% 
% %% Calculate changes in SST between specific time periods 
% 
% index_CMIP_start = (hist_change_start - CMIP_start_yr)*12 +1; % Start in January
% index_CMIP_end = (hist_change_end - CMIP_start_yr)*12 +12; % End in December
% index_SSP_start = (ssp_change_start - SSP_start_yr)*12 +1; % Start in January
% index_SSP_end = (ssp_change_end - SSP_start_yr)*12 +12; % End in December
% index_HRMIP_start = (hist_change_start - HRMIP_start_yr)*12 +1; % Start in January
% index_HRMIP_end = (hist_change_end - HRMIP_start_yr)*12 +12; % End in December
% index_HRSSP_start = (hrssp_change_start - SSP_start_yr)*12 +1; % Start in January
% index_HRSSP_end = (hrssp_change_end - SSP_start_yr)*12 +12; % End in December
% experiments = {'historical','ssp585','hist-1950','highres-future'};
% start_indices = [index_CMIP_start, index_SSP_start, index_HRMIP_start, ...
%     index_HRSSP_start];
% end_indices = [index_CMIP_end, index_SSP_end, index_HRMIP_end, ...
%     index_HRSSP_end];
% 
% SST_change_maps = IPCC_CMIP6_MapChange( ...
%     experiments, var_name, data_path, start_indices, end_indices, ...
%     ave_period);
% 
% SST_change_CMIP = SST_change_maps{1};
% SST_change_SSP585 = SST_change_maps{2};
% SST_change_HRMIP = SST_change_maps{3};
% SST_change_HRSSP = SST_change_maps{4};
% 
% %% Calculate SST averaged over reference period for models (for bias)
% 
% index_CMIP_start = (ref_start - CMIP_start_yr)*12 +1; % Start in January
% index_CMIP_end = (ref_end - CMIP_start_yr)*12 +12; % End in December
% index_HRMIP_start = (ref_start - HRMIP_start_yr)*12 +1; % Start in January
% index_HRMIP_end = (ref_end - HRMIP_start_yr)*12 +12; % End in December
% experiments = {'historical','hist-1950'};
% start_indices = [index_CMIP_start, index_HRMIP_start];
% end_indices = [index_CMIP_end, index_HRMIP_end];
% 
% SST_ref_maps = IPCC_CMIP6_Map( ...
%     experiments, var_name, data_path, start_indices, end_indices);
% 
% SST_ref_CMIP = SST_ref_maps{1};
% SST_ref_HRMIP = SST_ref_maps{2};
% 
% %% Load observational dataset
% 
% data_dir = data_path + "OBS_HadISST_reanaly_1_Omon_tos_" ...
%     + obs_start_yr + "-" + obs_end_yr + ".nc";
% obs_sst_data = ncread(data_dir,'tos');
% lat = ncread(data_dir,'lat');
% lon = ncread(data_dir,'lon');
% obs_sst_data = obs_sst_data - 273.15;
% 
% %% Calculate observed SST over a specific time period (and CMIP/HRMIP bias)
% 
% % Select appropriate obs data (monthly)
% index_start_yr = (ref_start - obs_start_yr)*12 +1; % Start in January
% index_end_yr = (ref_end - obs_start_yr)*12 +12; % End in December
% 
% SST_ref_OBS = nanmean(obs_sst_data(:,:,index_start_yr:index_end_yr),3);
% 
% SST_bias_CMIP = SST_ref_CMIP - SST_ref_OBS;
% SST_bias_HRMIP = SST_ref_HRMIP - SST_ref_OBS;
% 
% %% Calculate SST change for observations
% 
% % Select appropriate obs data for start period
% index_start_yr = (hist_change_start - obs_start_yr)*12 +1; % Start in January
% index_end_yr = (hist_change_end - obs_start_yr)*12 +12; % End in December
% 
% SST_change_OBS = ...
% nanmean(obs_sst_data(:,:,index_end_yr-12*ave_period:index_end_yr),3) - ...
% nanmean(obs_sst_data(:,:,index_start_yr:index_start_yr+12*ave_period),3);
% 
% %% Save data and diagnose the mid points of multi-year averages for change calculation
% 
% proj_ssp_ave_start = ssp_change_start + 0.5*ave_period;
% proj_ssp_ave_end = ssp_change_end - 0.5*ave_period;
% proj_hrssp_ave_start = hrssp_change_start + 0.5*ave_period;
% proj_hrssp_ave_end = hrssp_change_end - 0.5*ave_period;
% hist_ave_start = hist_change_start + 0.5*ave_period;
% hist_ave_end = hist_change_end - 0.5*ave_period;
% 
% 
% savefile = 'SST_Maps_New';
% 
% save(savefile, 'SST_change_OBS', 'SST_change_CMIP', 'SST_change_HRMIP', ...
%     'SST_change_SSP585', 'SST_change_HRSSP', 'SST_ref_OBS', ...
%     'SST_bias_CMIP', 'SST_bias_HRMIP', 'lat', 'lon', 'proj_ssp_ave_start', ...
%     'proj_ssp_ave_end', 'hist_ave_start', 'hist_ave_end','ref_start', ...
%     'ref_end', 'proj_hrssp_ave_start','proj_hrssp_ave_end');

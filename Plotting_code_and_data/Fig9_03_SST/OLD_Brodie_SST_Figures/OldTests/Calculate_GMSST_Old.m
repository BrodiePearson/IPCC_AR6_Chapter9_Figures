%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surface temperature (SST) - named tos in CMIP6 

clear all

addpath ../../Matlab_Functions/

data_path = '/Volumes/Seagate_IPCC/IPCC/tos/Gridded_1degree/';


var_name = {'tos'};
fontsize=15;
smooth_length = 5; % (in years)
CMIP_start_yr = 1850;
HRMIP_start_yr = 1950;
SSP_start_yr = 2015;
ref_start_yr = 1970;
ref_end_yr = 1980;


%% Load historical and SSP datasets

ref_start_index = (ref_start_yr - CMIP_start_yr)*12+1;
ref_end_index = (ref_end_yr - CMIP_start_yr)*12+12;
experiments = {'historical','ssp126','ssp245','ssp370','ssp585'};

hist_models = IPCC_Which_Models(data_path,{'historical'},'CMIP6_','_');
ssp126_models = IPCC_Which_Models(data_path,{'ssp126'},'CMIP6_','_');
ssp245_models = IPCC_Which_Models(data_path,{'ssp245'},'CMIP6_','_');
ssp370_models = IPCC_Which_Models(data_path,{'ssp370'},'CMIP6_','_');
ssp585_models = IPCC_Which_Models(data_path,{'ssp585'},'CMIP6_','_');

% Load data from each historical model, any ssps for that model, and
% calculate anomolies relative to reference period
for ii=1:size(hist_models,2)
    [hist_data, lat, lon] = IPCC_CMIP6_Load({'historical'}, ...
        var_name, hist_models(1,ii), data_path);
    % If first iteration calculate grid cell areas for global mean weights
    if ii==1
        areas=NaN(size(lon.*lat'));    
        for i = 1:size(areas,1)
            for j=1:size(areas,2)
                areas(i,j) = areaquad(lat(j)-0.5, lon(i)-0.5, ...
                    lat(j)+0.5, lon(i)+0.5);
            end
        end
    end
    % Find Global mean SST
    CMIP_GMSST(:,ii) = IPCC_Global_Mean(hist_data,areas,smooth_length);
    % Find anomaly of global mean relative to the reference period
    CMIP_GMSST_anom(:,ii) = CMIP_GMSST(:,ii) - ...
       mean(CMIP_GMSST(ref_start_index:ref_end_index,ii)); 
    
    % Find out if analogous model exists for each ssp (and its index)
    ii_ssp126 = find(strcmp(ssp126_models,hist_models(1,ii)));
    if(~isempty(ii_ssp126))
        % Extract timeseries of global maps from experiment
        [SSP126_data, lat, lon] = IPCC_CMIP6_Load({'ssp126'}, var_name, ...
            ssp126_models(1,ii_ssp126), data_path);
        % De-anomalize the data
        SSP126_GMSST(:,ii_ssp126) = IPCC_Global_Mean(SSP126_data, ...
            areas,smooth_length);
        SSP126_GMSST_anom(:,ii_ssp126) = SSP126_GMSST(:,ii_ssp126) - ...
            mean(CMIP_GMSST(ref_start_index:ref_end_index,ii));
    end

    ii_ssp245 = find(strcmp(ssp245_models,hist_models(1,ii)));
    if(~isempty(ii_ssp245))
        % Extract timeseries of global maps from experiment
        [SSP245_data, lat, lon] = IPCC_CMIP6_Load({'ssp245'}, var_name, ...
            ssp245_models(1,ii_ssp245), data_path);
        % De-anomalize the data
        SSP245_GMSST(:,ii_ssp245) = IPCC_Global_Mean(SSP245_data, ...
            areas,smooth_length);
        SSP245_GMSST_anom(:,ii_ssp245) = SSP245_GMSST(:,ii_ssp245) - ...
            mean(CMIP_GMSST(ref_start_index:ref_end_index,ii));
    end
    
    ii_ssp370 = find(strcmp(ssp370_models,hist_models(1,ii)));
    if(~isempty(ii_ssp370))
        % Extract timeseries of global maps from experiment
        [SSP370_data, lat, lon] = IPCC_CMIP6_Load({'ssp370'}, var_name, ...
            ssp370_models(1,ii_ssp370), data_path);
        % De-anomalize the data
        SSP370_GMSST(:,ii_ssp370) = IPCC_Global_Mean(SSP370_data, ...
            areas,smooth_length);
        SSP370_GMSST_anom(:,ii_ssp370) = SSP370_GMSST(:,ii_ssp370) - ...
            mean(CMIP_GMSST(ref_start_index:ref_end_index,ii));
    end
    
    ii_ssp585 = find(strcmp(ssp585_models,hist_models(1,ii)));
    if(~isempty(ii_ssp585))
        % Extract timeseries of global maps from experiment
        [SSP585_data, lat, lon] = IPCC_CMIP6_Load({'ssp585'}, var_name, ...
            ssp585_models(1,ii_ssp585), data_path);
        % De-anomalize the data
        SSP585_GMSST(:,ii_ssp585) = IPCC_Global_Mean(SSP585_data, ...
            areas,smooth_length);
        SSP585_GMSST_anom(:,ii_ssp585) = SSP585_GMSST(:,ii_ssp585) - ...
            mean(CMIP_GMSST(ref_start_index:ref_end_index,ii));
    end
end

%% Load SST map timeseries and calculate global mean SST timeseries
% Do this for CMIP (historical), ScenarioMIP (SSP126, SSP 245, SSP 360 and SSP585)
% HighResMIP, and Observations

% Start with HighResMIP and OBS data

OBS_start_yr = 1870;
OBS_end_yr = 2017;
data_dir = data_path+"OBS_HadISST_reanaly_1_Omon_tos_" ...
    + OBS_start_yr + "-" + OBS_end_yr + ".nc";
OBS_data = ncread(data_dir,'tos');
OBS_data = OBS_data - 273.15;

HR_start_yr = 1950;
HR_end_yr = 2014;
data_dir = data_path+"CMIP6_NICAM16-7S_Omon_highresSST-" ...
    + "present_r1i1p1f1_TO2Ms_tos_" ...
    + HR_start_yr + "-" + HR_end_yr + ".nc";
HR_data = ncread(data_dir,'tos');
HR_data = HR_data - 273.15;

%% Calculate HighResMIP historical and future timeseries

HR_experiments = {'hist-1950','highres-future'};

HR_ref_start_index = (ref_start_yr - HRMIP_start_yr)*12+1;
HR_ref_end_index = (ref_end_yr - HRMIP_start_yr)*12+12;

HRMIP_models = IPCC_Which_Models(data_path,{'hist-1950'},'CMIP6_','_');
HRSSP_models = IPCC_Which_Models(data_path,{'highres-future'},'CMIP6_','_');

% Load data from each historical model, any ssps for that model, and
% calculate anomolies relative to reference period
for ii=1:size(HRMIP_models,2)
    [HRMIP_data, lat, lon] = IPCC_CMIP6_Load({'hist-1950'}, ...
        var_name, HRMIP_models(1,ii), data_path);
    % If first iteration calculate grid cell areas for global mean weights
    if ii==1
        areas=NaN(size(lon.*lat'));    
        for i = 1:size(areas,1)
            for j=1:size(areas,2)
                areas(i,j) = areaquad(lat(j)-0.5, lon(i)-0.5, ...
                    lat(j)+0.5, lon(i)+0.5);
            end
        end
    end
    % Find Global mean SST
    HRMIP_GMSST(:,ii) = IPCC_Global_Mean(HRMIP_data,areas,smooth_length);
    % Find anomaly of global mean relative to the reference period
    HRMIP_GMSST_anom(:,ii) = HRMIP_GMSST(:,ii) - ...
       mean(HRMIP_GMSST(HR_ref_start_index:HR_ref_end_index,ii)); 
    
    % Find out if analogous model exists for each ssp (and its index)
    ii_ssp_HR = find(strcmp(HRSSP_models,HRMIP_models(1,ii)));
    if(~isempty(ii_ssp_HR))
        % Extract timeseries of global maps from experiment
        [HRSSP_data, lat, lon] = IPCC_CMIP6_Load({'highres-future'}, ...
            var_name, HRSSP_models(1,ii_ssp_HR), data_path);
        % De-anomalize the data
        HRSSP_GMSST(:,ii_ssp_HR) = IPCC_Global_Mean(HRSSP_data, ...
            areas,smooth_length);
        HRSSP_GMSST_anom(:,ii_ssp_HR) = HRSSP_GMSST(:,ii_ssp_HR) - ...
            mean(HRMIP_GMSST(HR_ref_start_index:HR_ref_end_index,ii));
    end  
end

%% Calculate SST anomalies for HighResMIP and Observations

[OBS_GMSST] = IPCC_Global_Mean(OBS_data,areas,5);
[HR_GMSST] = IPCC_Global_Mean(HR_data,areas,5);

ref_start_index = (ref_start_yr - OBS_start_yr)*12+1;
ref_end_index = (ref_end_yr - OBS_start_yr)*12+12;

for i=1:size(OBS_GMSST,2)
   OBS_GMSST_anom(:,i) = OBS_GMSST(:,i) - ...
       mean(OBS_GMSST(ref_start_index:ref_end_index,i)); 
end

ref_start_index = (ref_start_yr - HR_start_yr)*12+1;
ref_end_index = (ref_end_yr - HR_start_yr)*12+12;

for i=1:size(HR_GMSST,2)
   HR_GMSST_anom(:,i) = HR_GMSST(:,i) - ...
       mean(HR_GMSST(ref_start_index:ref_end_index,i)); 
end

%% Create time series and save data

CMIP_time = CMIP_start_yr + (0:(1/12):(size(CMIP_GMSST,1)-1)/12);
SSP_time = SSP_start_yr + (0:(1/12):(size(SSP126_GMSST,1)-1)/12);
OBS_time = OBS_start_yr + (0:(1/12):(size(OBS_GMSST,1)-1)/12);
HR_time = HR_start_yr + (0:(1/12):(size(HR_GMSST,1)-1)/12);
HRMIP_time = HRMIP_start_yr + (0:(1/12):(size(HRMIP_GMSST,1)-1)/12);
HRSSP_time = SSP_start_yr + (0:(1/12):(size(HRSSP_GMSST,1)-1)/12);

filename = 'GMSST_Timeseries_Data.mat';

save(filename, 'OBS_GMSST_anom','HR_GMSST_anom', ...
    'CMIP_GMSST_anom', 'SSP126_GMSST_anom', ...
    'SSP245_GMSST_anom', 'SSP370_GMSST_anom','SSP585_GMSST_anom', ...
    'HRMIP_GMSST_anom','HRSSP_GMSST_anom', 'SSP_time','CMIP_time', ...
    'HRMIP_time','HRSSP_time','OBS_time','HR_time');






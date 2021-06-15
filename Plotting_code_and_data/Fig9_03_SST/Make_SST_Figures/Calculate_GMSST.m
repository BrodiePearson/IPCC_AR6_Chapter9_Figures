%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surface temperature (SST) - named tos in CMIP6 

clear all

addpath ../../Matlab_Functions/

%data_path = '/Volumes/Seagate_IPCC/IPCC/tos/Gridded_1degree/';
data_path = '/Volumes/PromiseDisk/AR6_Data/tos/';

var_name = {'tos'};
fontsize=15;
smooth_length = 1/12; % (in years)
CMIP_start_yr = 1850;
HRMIP_start_yr = 1950;
SSP_start_yr = 2015;
SSP_Extended_start_yr = 2100;
ref_start_yr = 1950;
ref_end_yr = 1980;

%% Load historical and SSP datasets

ref_start_index = (ref_start_yr - CMIP_start_yr)*12+1;
ref_end_index = (ref_end_yr - CMIP_start_yr)*12+12;
experiments = {'historical','ssp126','ssp245','ssp370','ssp585', ...
    'extended_ssp126', 'extended_ssp585'};

[GM_anom, model_names] = IPCC_CMIP6_GlobalAnomaly(experiments, var_name, ...
    data_path, ref_start_index, ref_end_index, smooth_length);

GMSST_CMIP = GM_anom{1};
GMSST_SSP126 = GM_anom{2};
GMSST_SSP245 = GM_anom{3};
GMSST_SSP370 = GM_anom{4};
GMSST_SSP585 = GM_anom{5};
GMSST_SSP126_Extended = GM_anom{6};
GMSST_SSP585_Extended = GM_anom{7};

models_CMIP = model_names{1};
models_SSP126 = model_names{2};
models_SSP245 = model_names{3};
models_SSP370 = model_names{4};
models_SSP585 = model_names{5};
models_SSP126_Extended = model_names{6};
models_SSP585_Extended = model_names{7};

HR_experiments = {'hist-1950','highres-future'};
HR_ref_start_index = (ref_start_yr - HRMIP_start_yr)*12+1;
HR_ref_end_index = (ref_end_yr - HRMIP_start_yr)*12+12;

[GM_anom_HR, model_names] = IPCC_CMIP6_GlobalAnomaly( ...
    HR_experiments, var_name, data_path, HR_ref_start_index, ...
    HR_ref_end_index, smooth_length);

GMSST_HRMIP = GM_anom_HR{1};
GMSST_HRSSP = GM_anom_HR{2};

models_HRMIP = model_names{1};
models_HRSSP = model_names{2};

%% Calculate SST anomalies for Observations
OBS_start_yr = 1870;
OBS_end_yr = 2017;
data_dir = data_path+"observations/OBS_HadISST_reanaly_1_Omon_tos_" ...
    + OBS_start_yr + "-" + OBS_end_yr + ".nc";
OBS_data = ncread(data_dir,'tos');
lat = ncread(data_dir,'lat');
lon = ncread(data_dir,'lon');
OBS_data = OBS_data - 273.15;

        areas=NaN(size(lon.*lat'));    
        for i = 1:size(areas,1)
            for j=1:size(areas,2)
                areas(i,j) = areaquad(lat(j)-0.5, lon(i)-0.5, ...
                    lat(j)+0.5, lon(i)+0.5);
            end
        end


OBS_GMSST = IPCC_Global_Mean(OBS_data,areas,5);
ref_start_index = (ref_start_yr - OBS_start_yr)*12+1;
ref_end_index = (ref_end_yr - OBS_start_yr)*12+12;

for i=1:size(OBS_GMSST,2)
   GMSST_OBS(:,i) = OBS_GMSST(:,i) - ...
       mean(OBS_GMSST(ref_start_index:ref_end_index,i)); 
end

%% Remove bad GMSST timeseries (filled with zero values)

tmpsize=size(GMSST_SSP126,2);
for ii=1:size(GMSST_SSP126,2)
    jj=tmpsize-ii+1; %reverse order
    if  nanmean(GMSST_SSP126(:,jj).^2)==0
        [jj nanmean(GMSST_SSP126(:,jj).^2) models_SSP126(jj)]
        GMSST_SSP126(:,jj)=[];
        models_SSP126(jj)=[];
    end
end

tmpsize=size(GMSST_SSP245,2);
for ii=1:size(GMSST_SSP245,2)
    jj=tmpsize-ii+1; %reverse order
    if  nanmean(GMSST_SSP245(:,jj).^2)==0
        [jj nanmean(GMSST_SSP245(:,jj).^2) models_SSP245(jj)]
        GMSST_SSP245(:,jj)=[];
        models_SSP245(jj)=[];
    end
end

tmpsize=size(GMSST_SSP370,2);
for ii=1:size(GMSST_SSP370,2)
    jj=tmpsize-ii+1; %reverse order
    if  nanmean(GMSST_SSP370(:,jj).^2)==0
        [jj nanmean(GMSST_SSP370(:,jj).^2) models_SSP370(jj)]
        GMSST_SSP370(:,jj)=[];
        models_SSP370(jj)=[];
    end
end

tmpsize=size(GMSST_SSP585,2);
for ii=1:size(GMSST_SSP585,2)
    jj=tmpsize-ii+1; %reverse order
    if  nanmean(GMSST_SSP585(:,jj).^2)==0
        [jj nanmean(GMSST_SSP585(:,jj).^2) models_SSP585(jj)]
        GMSST_SSP585(:,jj)=[];
        models_SSP585(jj)=[];
    end
end

tmpsize=size(GMSST_SSP126_Extended,2);
for ii=1:size(GMSST_SSP126_Extended,2)
    jj=tmpsize-ii+1; %reverse order
    if  nanmean(GMSST_SSP126_Extended(:,jj).^2)==0
        [jj nanmean(GMSST_SSP126_Extended(:,jj).^2) models_SSP126_Extended(jj)]
        GMSST_SSP126_Extended(:,jj)=[];
        models_SSP126_Extended(jj)=[];
    end
end

tmpsize=size(GMSST_SSP585_Extended,2);
for ii=1:size(GMSST_SSP585_Extended,2)
    jj=tmpsize-ii+1; %reverse order
    if  nanmean(GMSST_SSP585_Extended(:,jj).^2)==0
        [jj nanmean(GMSST_SSP585_Extended(:,jj).^2) models_SSP585_Extended(jj)]
        GMSST_SSP585_Extended(:,jj)=[];
        models_SSP585_Extended(jj)=[];
    end
end

tmpsize=size(GMSST_HRMIP,2);
for ii=1:size(GMSST_HRMIP,2)
    jj=tmpsize-ii+1; %reverse order
    if  nanmean(GMSST_HRMIP(:,jj).^2)==0
        [jj nanmean(GMSST_HRMIP(:,jj).^2) models_HRMIP(jj)]
        GMSST_HRMIP(:,jj)=[];
        models_HRMIP(jj)=[];
    end
end

tmpsize=size(GMSST_HRSSP,2);
for ii=1:size(GMSST_HRSSP,2)
    jj=tmpsize-ii+1; %reverse order
    if  nanmean(GMSST_HRSSP(:,jj).^2)==0
        [jj nanmean(GMSST_HRSSP(:,jj).^2) models_HRSSP(jj)]
        GMSST_HRSSP(:,jj)=[];
        models_HRSSP(jj)=[];
    end
end

tmpsize=size(GMSST_CMIP,2);
for ii=1:size(GMSST_CMIP,2)
    jj=tmpsize-ii+1; %reverse order
    if  nanmean(GMSST_CMIP(:,jj).^2)==0
        [jj nanmean(GMSST_CMIP(:,jj).^2) models_CMIP(jj)]
        GMSST_CMIP(:,jj)=[];
        models_CMIP(jj)=[];
    end
end



%% Create time series and save data

CMIP_time = CMIP_start_yr + (0:(1/12):(size(GMSST_CMIP,1)-1)/12);
SSP_time = SSP_start_yr + (0:(1/12):(size(GMSST_SSP126,1)-1)/12);
OBS_time = OBS_start_yr + (0:(1/12):(size(GMSST_OBS,1)-1)/12);
HRMIP_time = HRMIP_start_yr + (0:(1/12):(size(GMSST_HRMIP,1)-1)/12);
HRSSP_time = SSP_start_yr + (0:(1/12):(size(GMSST_HRSSP,1)-1)/12);
SSP_Extended_time = SSP_Extended_start_yr + (0:(1/12):(size(GMSST_SSP126_Extended,1)-1)/12);

filename = 'GMSST_Anomalies.mat';

save(filename, 'GMSST_CMIP','GMSST_SSP126', ...
    'GMSST_SSP245', 'GMSST_SSP370', ...
    'GMSST_SSP585', 'GMSST_HRMIP','GMSST_HRSSP', ...
    'GMSST_SSP126_Extended','GMSST_SSP585_Extended', ...
    'GMSST_OBS','SSP_time','CMIP_time', ...
    'HRMIP_time','HRSSP_time','OBS_time', 'SSP_Extended_time', 'ref_start_yr','ref_end_yr', ...
    'models_CMIP','models_SSP126','models_SSP245','models_SSP370','models_SSP585',...
    'models_SSP126_Extended','models_SSP585_Extended','models_HRMIP','models_HRSSP');


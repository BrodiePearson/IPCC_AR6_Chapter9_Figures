clear all

%% Fabio B Dias - 27.01.2020
% Script to

% 1: load individual altimeter products (mean), apply GIA/TPA corrections
% on those missing, calculate errors using Ablain et al (2019) matrix,
% and calculate the altimeter ensemble mean
%
% 2: load Tide Gauge ensemble mean from Matt Palmer (extracted from
% AR6_GMSL_ensemble_FGD_calculations.xlsx)
%
% 3: Merge TG + Altimeter ensembles for rate/trend calculations, Chap. 2 AR6
%
%%

cd('/Volumes/LaCie_1.5Tb/OneDrive - University of Helsinki/03_FGD_duplicate/SL/To_from_Fabio/')

% Load AR6 Chap2 GMSL database:
load Files_from_21.01.2021/IPCC_AR6_CH2_GMSL_2020-09-24.mat

% load error variance-covariance matrix from Ablain et al (2019)
error_matrix = 'Files_from_21.01.2021/60898.nc';

time_error = ncread(error_matrix,'time')./365 + 1950; % years from 1950 -> to 1993
covariance_matrix = ncread(error_matrix,'covariance_matrix');

%% Period = 1993:2018
Time_intervals = [1993;2018];
Time_indexes(1) = find(Time_intervals(1) == gmsl_yr_time);
Time_indexes(2) = find(Time_intervals(2) == gmsl_yr_time);

Time_ind_98 = find(1998 == gmsl_yr_time);

%% choosing altimeter products to use: same as in Cazenave et al (2018)
% 11 = AVISO
% 13 = CSIRO
% 14 = CU
% 15 = ESA
% 16 = NASA
% 17 = NOAA

time_altim = gmsl_yr_time(Time_indexes(1):Time_indexes(2));

figure,plot(time_altim,gmsl_yr_obs(11,Time_indexes(1):Time_indexes(2)),'b')
hold on
plot(time_altim,gmsl_yr_obs(13,Time_indexes(1):Time_indexes(2)),'r')
plot(time_altim,gmsl_yr_obs(14,Time_indexes(1):Time_indexes(2)),'c')
plot(time_altim,gmsl_yr_obs(15,Time_indexes(1):Time_indexes(2)),'m')
plot(time_altim,gmsl_yr_obs(16,Time_indexes(1):Time_indexes(2)))
plot(time_altim,gmsl_yr_obs(17,Time_indexes(1):Time_indexes(2)),'g')

%% apply missing corretion to individual estimates:

%gmsl_yr_obs([11 13 14 15 16 17]
% GIA: apply to ESA and NOAA -> found some values around
% 0.3mm/yr in Paltier (2004, 2009)
gmsl_yr_obs_adj = gmsl_yr_obs;
gmsl_yr_obs_adj(15,Time_indexes(1):Time_indexes(2)) = -0.33+gmsl_yr_obs_adj(15,Time_indexes(1):Time_indexes(2)); % ESA
gmsl_yr_obs_adj(17,Time_indexes(1):Time_indexes(2)) = -0.33+gmsl_yr_obs_adj(17,Time_indexes(1):Time_indexes(2)); % NOAA

% TPA: apply to AVISO, CU and CSIRO, just between 1993-1998
% Dieng et al (2017) found a value similar to Watson et al (2015)'s
% preferable value of 1.5 mm/yr
gmsl_yr_obs_adj(11,Time_indexes(1):Time_ind_98) = 1.5+gmsl_yr_obs_adj(11,Time_indexes(1):Time_ind_98); % AVISO
gmsl_yr_obs_adj(13,Time_indexes(1):Time_ind_98) = 1.5+gmsl_yr_obs_adj(13,Time_indexes(1):Time_ind_98); % CSIRO
gmsl_yr_obs_adj(14,Time_indexes(1):Time_ind_98) = 1.5+gmsl_yr_obs_adj(14,Time_indexes(1):Time_ind_98); % CU


plot(time_altim,gmsl_yr_obs_adj(11,Time_indexes(1):Time_indexes(2)),'--b')
plot(time_altim,gmsl_yr_obs_adj(13,Time_indexes(1):Time_indexes(2)),'--r')
plot(time_altim,gmsl_yr_obs_adj(14,Time_indexes(1):Time_indexes(2)),'--c')
plot(time_altim,gmsl_yr_obs_adj(15,Time_indexes(1):Time_indexes(2)),'--m')
plot(time_altim,gmsl_yr_obs_adj(17,Time_indexes(1):Time_indexes(2)),'--g')

legend('AVISO','CSIRO','CU','ESA','NASA','NOAA','AVISO corr.','CSIRO corr.','CU corr.','ESA corr.','NOAA corr.')

%% altimeter ensemble mean

% here use gmsl_yr_obs for non-corrected timeseries OR
% gmsl_yr_obs_adj for corrected timeseries with GIA/TPA corrections abova:
%altimeter_sl = gmsl_yr_obs([11 13 14 15 16 17],Time_indexes(1):Time_indexes(2));
altimeter_sl = gmsl_yr_obs_adj([11 13 14 15 16 17],Time_indexes(1):Time_indexes(2));
altimeter_sl_ensemble = nanmean(altimeter_sl, 1);
altimeter_yr_time = gmsl_yr_time(Time_indexes(1)):gmsl_yr_time(Time_indexes(2));

%calculate altimeter mean 1995-2014 (as Matt):
Tindexes(1) = find(1995 == altimeter_yr_time');
Tindexes(2) = find(2014 == altimeter_yr_time');
altim_mean_1995_2014 = mean(altimeter_sl_ensemble(Tindexes(1):Tindexes(2)));

altim_sl = squeeze(altimeter_sl(:,:))-altim_mean_1995_2014;
altim_sl_ensemble = squeeze(altimeter_sl_ensemble)-altim_mean_1995_2014;

%altim_error_ensemble = 3.7*ones(1,length(altim_sl_ensemble)); 

% - error from Ablain et al (2019), Section 5:
% "We estimated the GMSL uncertainty envelope from the square root of the
% diagonal terms of the error variance-covariance matrix (Fig 3)"
altim_error_ensemble_10day = sqrt(diag(covariance_matrix));

time_error_yr = (1993:2018);
altim_error_ensemble = nan(1,26);
% average error matrix per year:
count=1;
for years = 1993:2018;
    ind_yy = find(floor(time_error)==years);
    altim_error_ensemble(1,count) = 1.645*mean(1000*altim_error_ensemble_10day(ind_yy)); % convert cm2 to mm2, and 1sigma to 90% CI
    count = count+1;
end

% quick plot
figure,plot(altimeter_yr_time,altim_sl_ensemble,'-k','linewidth',2)
hold on,plot(altimeter_yr_time,altim_sl_ensemble+altim_error_ensemble,'--r')
hold on,plot(altimeter_yr_time,altim_sl_ensemble-altim_error_ensemble,'--r')
hold on,plot(altimeter_yr_time,altim_sl)


%% save our calculate altimeter ensemble
save('gmsl_altimeter_ensemble_28012021.mat','altimeter_yr_time','altim_sl','altim_sl_ensemble','altim_error_ensemble')

%% comparison of the new altimeter ensemble with Matt's file (Frederikse et al 2020)
% FR2020_altim = load('Files_from_21.01.2021/AR6_GMSL_altimeter_FGDprelim_nohead.csv');
% 
% figure,plot(FR2020_altim(:,1),FR2020_altim(:,2),'-k')
% hold on,plot(FR2020_altim(:,1),FR2020_altim(:,3),'-r')
% hold on,plot(FR2020_altim(:,1),FR2020_altim(:,4),'-r')
% hold on,plot(altimeter_yr_time+0.5,altim_sl_ensemble,'--h')
% hold on,plot(altimeter_yr_time+0.5,altim_sl_ensemble+altim_error_ensemble,'--r')
% hold on,plot(altimeter_yr_time+0.5,altim_sl_ensemble-altim_error_ensemble,'--r')
% close
%% load ensemble from 1900 onward sent from Matt:

load Files_from_21.01.2021/gmsl_td_ensemble_21012021.mat

gmsl_td_time_ensemble = gmsl_td_ensemble(:,1);
gmsl_td_sl_ensemble = gmsl_td_ensemble(:,2);
gmsl_td_error_ensemble = 1.645*gmsl_td_ensemble(:,5); % error are in 1-sigma from Matt's table, converting to 90% CI

clear gmsl_td_ensemble
%% merge td_ensemble(1900-1992) with altimeter_sl_ensemble(1993-2018)

tg_tstart = find(gmsl_td_time_ensemble==1901.5);
tg_tend = find(gmsl_td_time_ensemble==1992.5);

TG_SL_pt1 = gmsl_td_sl_ensemble(tg_tstart:tg_tend);
TG_Error_pt1 = gmsl_td_error_ensemble(tg_tstart:tg_tend);
TG_time_pt1 = gmsl_td_time_ensemble(tg_tstart:tg_tend);

% - Merge TG reconst. with our altim. ensemble:
merged_SL_TG_altim = cat(1,TG_SL_pt1,altim_sl_ensemble');
merged_time_TG_altim = cat(1,TG_time_pt1,altimeter_yr_time');
merged_error_TG_altim = cat(1,TG_Error_pt1,altim_error_ensemble');

%% some plots

figure,plot(merged_time_TG_altim,merged_SL_TG_altim,'-k','linewidth',2)
hold on,plot(merged_time_TG_altim,merged_SL_TG_altim+merged_error_TG_altim,'--r')
hold on,plot(merged_time_TG_altim,merged_SL_TG_altim-merged_error_TG_altim,'--r')


save('gmsl_altimeter+TG_ensemble_28012021.mat','merged_time_TG_altim','merged_SL_TG_altim','merged_error_TG_altim')

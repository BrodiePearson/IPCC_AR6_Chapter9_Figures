%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surfact temperature (SST) - named tos in CMIP6 

clear all

addpath ../../Matlab_Functions/
fontsize=15;
width = 3;

color_OBS = IPCC_Get_SSPColors('Observations');
color_HRMIP = IPCC_Get_SSPColors('HighResMIP');
color_HRSSP = IPCC_Get_SSPColors('HighResMIP');
color_CMIP = IPCC_Get_SSPColors('CMIP');
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

%% Load paleo data and calculate means/stds

% SST_LIG = ncread('paleo_gmsst_data/avg_anomaly_lig127k.nc','tos');
% TIME_LIG = ncread('paleo_gmsst_data/avg_anomaly_lig127k.nc','time');
% 
% SST_mHOL = ncread('paleo_gmsst_data/avg_anomaly_midHolocene.nc','tos');
% TIME_mHOL = ncread('paleo_gmsst_data/avg_anomaly_midHolocene.nc','time');
% 
% SST_mPLI = ncread('paleo_gmsst_data/avg_anomaly_midPliocene.nc','tos');
% TIME_mPLI = ncread('paleo_gmsst_data/avg_anomaly_midPliocene.nc','time');
% 
% SST_LIG_mn = nanmean(SST_LIG);
% SST_LIG_std = nanstd(SST_LIG);
% SST_mHOL_mn = nanmean(SST_mHOL);
% SST_mHOL_std = nanstd(SST_mHOL);
% SST_mPLI_mn = nanmean(SST_mPLI);
% SST_mPLI_std = nanstd(SST_mPLI);

%% Input paleo data from Alan M. (Slack) for observations and models
% Means and 95 percent confidence intervals
% Corrected for 1950-1980 period (minus 0.2 degrees) where neccessary

% The paleo data and refs are summarized in ACM_Summary_for_Brodie_LGM_LIG_MPWP.xlsx

%LGM observations
% Paul et al. (2021) , Tierney et al., (2020), MARGO (2009) 
LGM_obs_mean = -2.6;
LGM_obs_bounds = [-2.4 -2.8];

% LGM PMIP4/CMIP6
% Kageyama et al. (2021)
LGM_model_mean = -3.0;
LGM_model_bounds = [-1.7 -4.9]; 

%LIG observations
% Fischer et al., 2018, Turney et al. 2020
LIG_obs_mean = 0.4;
LIG_obs_bounds = [0 0.8];

% LIG PMIP4/CMIP6 & PMIP3/CMIP5
% Otto-Bliesner et al., 2021
LIG_model_mean = -0.2;
LIG_model_bounds = [-0.6 0.3]; 

%MPWP observations
% Fischer et al., 2018, Turney et al. 2020
MPWP_obs_mean = 2.7;
MPWP_obs_bounds = [2.1 3.2];

% MPWP PMIP4/CMIP6 & PMIP3/CMIP5
% Otto-Bliesner etal 2013, Otto-Bliesner et al., 2021
MPWP_model_mean = 2.6;
MPWP_model_bounds = [1 3.5]; 


%% Make plots

filename = 'GMSST_Anomalies.mat';
load(filename);

GMSST_CMIP = movmean(GMSST_CMIP,12);
GMSST_SSP126 = movmean(GMSST_SSP126,12);
GMSST_SSP245 = movmean(GMSST_SSP245,12);
GMSST_SSP370 = movmean(GMSST_SSP370,12);
GMSST_SSP585 = movmean(GMSST_SSP585,12);
%Fuse two HighResMIP simulations into one (historical and future)
% GMSST_HRSSP = [GMSST_HRMIP; GMSST_HRSSP];
% GMSST_HRMIP = movmean(GMSST_HRMIP,12);
% GMSST_HRSSP = movmean(GMSST_HRSSP,12);
GMSST_SSP126_Extended = movmean(GMSST_SSP126_Extended,12);
GMSST_SSP585_Extended = movmean(GMSST_SSP585_Extended,12);

GMSST_OBS_mean = nanmean(GMSST_OBS,2);
GMSST_HRMIP_mean = nanmean(GMSST_HRMIP,2);
GMSST_CMIP_mean = nanmean(GMSST_CMIP,2);
GMSST_SSP126_mean = nanmean(GMSST_SSP126,2);
GMSST_SSP245_mean = nanmean(GMSST_SSP245,2);
GMSST_SSP370_mean = nanmean(GMSST_SSP370,2);
GMSST_SSP585_mean = nanmean(GMSST_SSP585,2);
GMSST_HRSSP_mean = nanmean(GMSST_HRSSP,2);
GMSST_SSP126_Extended_mean = nanmean(GMSST_SSP126_Extended,2);
GMSST_SSP585_Extended_mean = nanmean(GMSST_SSP585_Extended,2);
GMSST_OBS_std = nanstd(GMSST_OBS,0,2);

GMSST_CMIP_mean = movmean([GMSST_CMIP_mean(7:12); GMSST_CMIP_mean; ...
    GMSST_SSP245_mean(1:5)],12,'Endpoints','discard');
GMSST_SSP126_mean = movmean([GMSST_CMIP_mean(end-5:end); GMSST_SSP126_mean; ...
    GMSST_SSP126_mean(end-12:end-8)],12,'Endpoints','discard');
GMSST_SSP245_mean = movmean([GMSST_CMIP_mean(end-5:end); GMSST_SSP245_mean; ...
    GMSST_SSP245_mean(end-12:end-8)],12,'Endpoints','discard');
GMSST_SSP370_mean = movmean([GMSST_CMIP_mean(end-5:end); GMSST_SSP370_mean; ...
    GMSST_SSP370_mean(end-12:end-8)],12,'Endpoints','discard');
GMSST_SSP585_mean = movmean([GMSST_CMIP_mean(end-5:end); GMSST_SSP585_mean; ...
    GMSST_SSP585_mean(end-12:end-8)],12,'Endpoints','discard');

GMSST_HighResMIP_mean = [GMSST_HRMIP_mean; GMSST_HRSSP_mean];
GMSST_HighResMIP_mean = movmean(GMSST_HighResMIP_mean,12);


%% Calculate likely and very likely bounds

GMSST_CMIP(GMSST_CMIP==0)=NaN(1);
GMSST_SSP126(GMSST_SSP126==0)=NaN(1);
GMSST_SSP245(GMSST_SSP245==0)=NaN(1);
GMSST_SSP370(GMSST_SSP370==0)=NaN(1);
GMSST_SSP585(GMSST_SSP585==0)=NaN(1);

CMIP_Likely_ubound=quantile(GMSST_CMIP,0.83,2);
CMIP_Likely_lbound=quantile(GMSST_CMIP,0.17,2);
% CMIP_Likely_Conf_Bounds = [CMIP_Likely_ubound' flipud(CMIP_Likely_lbound)'];
CMIP_VeryLikely_ubound=quantile(GMSST_CMIP,0.95,2);
CMIP_VeryLikely_lbound=quantile(GMSST_CMIP,0.05,2);
% CMIP_VeryLikely_Conf_Bounds = [CMIP_VeryLikely_ubound' flipud(CMIP_VeryLikely_lbound)'];
% CMIP_Time_Conf_Bounds = [CMIP_time fliplr(CMIP_time)];

SSP126_Likely_ubound=quantile(GMSST_SSP126,0.83,2);
SSP126_Likely_lbound=quantile(GMSST_SSP126,0.17,2);
% SSP126_Likely_Conf_Bounds = [SSP126_Likely_ubound' flipud(SSP126_Likely_lbound)'];
SSP126_VeryLikely_ubound=quantile(GMSST_SSP126,0.95,2);
SSP126_VeryLikely_lbound=quantile(GMSST_SSP126,0.05,2);
% SSP126_VeryLikely_Conf_Bounds = [SSP126_VeryLikely_ubound' flipud(SSP126_VeryLikely_lbound)'];

SSP245_Likely_ubound=quantile(GMSST_SSP245,0.83,2);
SSP245_Likely_lbound=quantile(GMSST_SSP245,0.17,2);
SSP245_Likely_Conf_Bounds = [SSP245_Likely_ubound' flipud(SSP245_Likely_lbound)'];
SSP245_VeryLikely_ubound=quantile(GMSST_SSP245,0.95,2);
SSP245_VeryLikely_lbound=quantile(GMSST_SSP245,0.05,2);
SSP245_VeryLikely_Conf_Bounds = [SSP245_VeryLikely_ubound' flipud(SSP245_VeryLikely_lbound)'];

SSP370_Likely_ubound=quantile(GMSST_SSP370,0.83,2);
SSP370_Likely_lbound=quantile(GMSST_SSP370,0.17,2);
SSP370_Likely_Conf_Bounds = [SSP370_Likely_ubound' flipud(SSP370_Likely_lbound)'];
SSP370_VeryLikely_ubound=quantile(GMSST_SSP370,0.95,2);
SSP370_VeryLikely_lbound=quantile(GMSST_SSP370,0.05,2);
SSP370_VeryLikely_Conf_Bounds = [SSP370_VeryLikely_ubound' flipud(SSP370_VeryLikely_lbound)'];

SSP585_Likely_ubound=quantile(GMSST_SSP585,0.83,2);
SSP585_Likely_lbound=quantile(GMSST_SSP585,0.17,2);
SSP585_Likely_Conf_Bounds = [SSP585_Likely_ubound' flipud(SSP585_Likely_lbound)'];
SSP585_VeryLikely_ubound=quantile(GMSST_SSP585,0.95,2);
SSP585_VeryLikely_lbound=quantile(GMSST_SSP585,0.05,2);
SSP585_VeryLikely_Conf_Bounds = [SSP585_VeryLikely_ubound' flipud(SSP585_VeryLikely_lbound)'];

SSP_Time_Conf_Bounds = [SSP_time fliplr(SSP_time)];

% Apply moving means to confidence bounds
CMIP_VeryLikely_ubound = movmean([CMIP_VeryLikely_ubound(7:12); CMIP_VeryLikely_ubound; ...
    SSP245_VeryLikely_ubound(1:5)],12,'Endpoints','discard');
SSP126_VeryLikely_ubound = movmean([CMIP_VeryLikely_ubound(end-5:end); SSP126_VeryLikely_ubound; ...
    SSP126_VeryLikely_ubound(end-12:end-8)],12,'Endpoints','discard');
SSP245_VeryLikely_ubound = movmean([CMIP_VeryLikely_ubound(end-5:end); SSP245_VeryLikely_ubound; ...
    SSP245_VeryLikely_ubound(end-12:end-8)],12,'Endpoints','discard');
SSP370_VeryLikely_ubound = movmean([CMIP_VeryLikely_ubound(end-5:end); SSP370_VeryLikely_ubound; ...
    SSP370_VeryLikely_ubound(end-12:end-8)],12,'Endpoints','discard');
SSP585_VeryLikely_ubound = movmean([CMIP_VeryLikely_ubound(end-5:end); SSP585_VeryLikely_ubound; ...
    SSP585_VeryLikely_ubound(end-12:end-8)],12,'Endpoints','discard');

CMIP_VeryLikely_lbound = movmean([CMIP_VeryLikely_lbound(7:12); CMIP_VeryLikely_lbound; ...
    SSP245_VeryLikely_lbound(1:5)],12,'Endpoints','discard');
SSP126_VeryLikely_lbound = movmean([CMIP_VeryLikely_lbound(end-5:end); SSP126_VeryLikely_lbound; ...
    SSP126_VeryLikely_lbound(end-12:end-8)],12,'Endpoints','discard');
SSP245_VeryLikely_lbound = movmean([CMIP_VeryLikely_lbound(end-5:end); SSP245_VeryLikely_lbound; ...
    SSP245_VeryLikely_lbound(end-12:end-8)],12,'Endpoints','discard');
SSP370_VeryLikely_lbound = movmean([CMIP_VeryLikely_lbound(end-5:end); SSP370_VeryLikely_lbound; ...
    SSP370_VeryLikely_lbound(end-12:end-8)],12,'Endpoints','discard');
SSP585_VeryLikely_lbound = movmean([CMIP_VeryLikely_lbound(end-5:end); SSP585_VeryLikely_lbound; ...
    SSP585_VeryLikely_lbound(end-12:end-8)],12,'Endpoints','discard');

CMIP_Likely_ubound = movmean([CMIP_Likely_ubound(7:12); CMIP_Likely_ubound; ...
    SSP245_Likely_ubound(1:5)],12,'Endpoints','discard');
SSP126_Likely_ubound = movmean([CMIP_Likely_ubound(end-5:end); SSP126_Likely_ubound; ...
    SSP126_Likely_ubound(end-12:end-8)],12,'Endpoints','discard');
SSP245_Likely_ubound = movmean([CMIP_Likely_ubound(end-5:end); SSP245_Likely_ubound; ...
    SSP245_Likely_ubound(end-12:end-8)],12,'Endpoints','discard');
SSP370_Likely_ubound = movmean([CMIP_Likely_ubound(end-5:end); SSP370_Likely_ubound; ...
    SSP370_Likely_ubound(end-12:end-8)],12,'Endpoints','discard');
SSP585_Likely_ubound = movmean([CMIP_Likely_ubound(end-5:end); SSP585_Likely_ubound; ...
    SSP585_Likely_ubound(end-12:end-8)],12,'Endpoints','discard');

CMIP_Likely_lbound = movmean([CMIP_Likely_lbound(7:12); CMIP_Likely_lbound; ...
    SSP245_Likely_lbound(1:5)],12,'Endpoints','discard');
SSP126_Likely_lbound = movmean([CMIP_Likely_lbound(end-5:end); SSP126_Likely_lbound; ...
    SSP126_Likely_lbound(end-12:end-8)],12,'Endpoints','discard');
SSP245_Likely_lbound = movmean([CMIP_Likely_lbound(end-5:end); SSP245_Likely_lbound; ...
    SSP245_Likely_lbound(end-12:end-8)],12,'Endpoints','discard');
SSP370_Likely_lbound = movmean([CMIP_Likely_lbound(end-5:end); SSP370_Likely_lbound; ...
    SSP370_Likely_lbound(end-12:end-8)],12,'Endpoints','discard');
SSP585_Likely_lbound = movmean([CMIP_Likely_lbound(end-5:end); SSP585_Likely_lbound; ...
    SSP585_Likely_lbound(end-12:end-8)],12,'Endpoints','discard');

CMIP_Likely_Conf_Bounds = [CMIP_Likely_ubound' flipud(CMIP_Likely_lbound)'];
CMIP_VeryLikely_Conf_Bounds = [CMIP_VeryLikely_ubound' flipud(CMIP_VeryLikely_lbound)'];
CMIP_Time_Conf_Bounds = [CMIP_time fliplr(CMIP_time)];

SSP126_Likely_Conf_Bounds = [SSP126_Likely_ubound' flipud(SSP126_Likely_lbound)'];
SSP126_VeryLikely_Conf_Bounds = [SSP126_VeryLikely_ubound' flipud(SSP126_VeryLikely_lbound)'];
SSP245_Likely_Conf_Bounds = [SSP245_Likely_ubound' flipud(SSP245_Likely_lbound)'];
SSP245_VeryLikely_Conf_Bounds = [SSP245_VeryLikely_ubound' flipud(SSP245_VeryLikely_lbound)'];
SSP370_Likely_Conf_Bounds = [SSP370_Likely_ubound' flipud(SSP370_Likely_lbound)'];
SSP370_VeryLikely_Conf_Bounds = [SSP370_VeryLikely_ubound' flipud(SSP370_VeryLikely_lbound)'];
SSP585_Likely_Conf_Bounds = [SSP585_Likely_ubound' flipud(SSP585_Likely_lbound)'];
SSP585_VeryLikely_Conf_Bounds = [SSP585_VeryLikely_ubound' flipud(SSP585_VeryLikely_lbound)'];




HRMIP_Likely_ubound=quantile(GMSST_HRMIP,0.83,2);
HRMIP_Likely_lbound=quantile(GMSST_HRMIP,0.17,2);
HRMIP_Likely_Conf_Bounds = [HRMIP_Likely_ubound' flipud(HRMIP_Likely_lbound)'];
HRMIP_VeryLikely_ubound=quantile(GMSST_HRMIP,0.95,2);
HRMIP_VeryLikely_lbound=quantile(GMSST_HRMIP,0.05,2);
%HRMIP_VeryLikely_Conf_Bounds = [HRMIP_VeryLikely_ubound' flipud(HRMIP_VeryLikely_lbound)'];
% 
% HRMIP_Time_Conf_Bounds = [HRMIP_time fliplr(HRMIP_time)];

HRSSP_Likely_ubound=quantile(GMSST_HRSSP,0.83,2);
HRSSP_Likely_lbound=quantile(GMSST_HRSSP,0.17,2);
HRSSP_Likely_Conf_Bounds = [HRSSP_Likely_ubound' flipud(HRSSP_Likely_lbound)'];
HRSSP_VeryLikely_ubound=quantile(GMSST_HRSSP,0.95,2);
HRSSP_VeryLikely_lbound=quantile(GMSST_HRSSP,0.05,2);
%HRSSP_VeryLikely_Conf_Bounds = [HRSSP_VeryLikely_ubound' flipud(HRSSP_VeryLikely_lbound)'];

HighResMIP_VeryLikely_lbound = [HRMIP_VeryLikely_lbound; HRSSP_VeryLikely_lbound];
HighResMIP_VeryLikely_ubound = [HRMIP_VeryLikely_ubound; HRSSP_VeryLikely_ubound];
HighResMIP_VeryLikely_Conf_Bounds = movmean([HighResMIP_VeryLikely_ubound' flipud(HighResMIP_VeryLikely_lbound)'],12);
HighResMIP_Likely_lbound = [HRMIP_Likely_lbound; HRSSP_Likely_lbound];
HighResMIP_Likely_ubound = [HRMIP_Likely_ubound; HRSSP_Likely_ubound];
HighResMIP_Likely_Conf_Bounds = movmean([HighResMIP_Likely_ubound' flipud(HighResMIP_Likely_lbound)'],12);

HighResMIP_time = [HRMIP_time HRSSP_time]';
HighResMIP_Time_Conf_Bounds = [HighResMIP_time; flipud(HighResMIP_time)];

SSP126_Extended_Likely_ubound=quantile(GMSST_SSP126_Extended,0.83,2);
SSP126_Extended_Likely_lbound=quantile(GMSST_SSP126_Extended,0.17,2);
SSP126_Extended_Likely_Conf_Bounds = [SSP126_Extended_Likely_ubound' flipud(SSP126_Extended_Likely_lbound)'];
SSP126_Extended_VeryLikely_ubound=quantile(GMSST_SSP126_Extended,0.95,2);
SSP126_Extended_VeryLikely_lbound=quantile(GMSST_SSP126_Extended,0.05,2);
SSP126_Extended_VeryLikely_Conf_Bounds = [SSP126_Extended_VeryLikely_ubound' flipud(SSP126_Extended_VeryLikely_lbound)'];

SSP585_Extended_Likely_ubound=quantile(GMSST_SSP585_Extended,0.83,2);
SSP585_Extended_Likely_lbound=quantile(GMSST_SSP585_Extended,0.17,2);
SSP585_Extended_Likely_Conf_Bounds = [SSP585_Extended_Likely_ubound' flipud(SSP585_Extended_Likely_lbound)'];
SSP585_Extended_VeryLikely_ubound=quantile(GMSST_SSP585_Extended,0.95,2);
SSP585_Extended_VeryLikely_lbound=quantile(GMSST_SSP585_Extended,0.05,2);
SSP585_Extended_VeryLikely_Conf_Bounds = [SSP585_Extended_VeryLikely_ubound' flipud(SSP585_Extended_VeryLikely_lbound)'];

SSP_Extended_Time_Conf_Bounds = [SSP_Extended_time fliplr(SSP_Extended_time)];


%% Diagnose model count numbers
CMIP_count = size(GMSST_CMIP,2);
SSP126_count = size(GMSST_SSP126,2);
SSP245_count = size(GMSST_SSP245,2);
SSP370_count = size(GMSST_SSP370,2);
SSP585_count = size(GMSST_SSP585,2);
HRMIP_count = size(GMSST_HRMIP,2);
HRSSP_count = size(GMSST_HRSSP,2);
SSP126_Extended_count = size(GMSST_SSP126_Extended,2);
SSP585_Extended_count = size(GMSST_SSP585_Extended,2);


%% Create Figures

ylims = [-.5 5]

figure('Position', [10 10 1200 400])
patch(SSP_Time_Conf_Bounds,SSP126_Likely_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
patch(SSP_Time_Conf_Bounds,SSP245_Likely_Conf_Bounds,color_SSP245, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP370_Likely_Conf_Bounds,color_SSP370, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP585_Likely_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
likely = patch(CMIP_Time_Conf_Bounds,CMIP_Likely_Conf_Bounds,color_CMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
% patch(HRMIP_Time_Conf_Bounds,HRMIP_Likely_Conf_Bounds,color_HRMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
%patch(HRSSP_Time_Conf_Bounds,HRSSP_Likely_Conf_Bounds,color_HRSSP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(HighResMIP_Time_Conf_Bounds,HighResMIP_Likely_Conf_Bounds,color_HRSSP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(SSP_time,GMSST_SSP126_mean,'Color', color_SSP126, 'LineWidth', width)
plot(SSP_time,GMSST_SSP245_mean,'Color', color_SSP245, 'LineWidth', width)
plot(SSP_time,GMSST_SSP370_mean,'Color', color_SSP370, 'LineWidth', width)
plot(SSP_time,GMSST_SSP585_mean,'Color', color_SSP585, 'LineWidth', width)
means=plot(CMIP_time,GMSST_CMIP_mean, 'Color', color_CMIP, 'LineWidth', width)
plot(OBS_time,GMSST_OBS_mean, 'Color', color_OBS, 'LineWidth', width)
% plot(HRMIP_time,GMSST_HRMIP_mean, 'Color', color_HRMIP, 'LineWidth', width)
%plot(HRSSP_time,GMSST_HRSSP_mean, 'Color', color_HRSSP, 'LineWidth', width)
plot(HighResMIP_time(6:end-5),GMSST_HighResMIP_mean(6:end-5), 'Color', color_HRSSP, 'LineWidth', width)
ylim(ylims)
xlim([1850 2101])
set(gca,'Xtick',[1850 1900 1950 2000 2050 2101],'Xticklabel',{'1850', '1900','1950','2000','2050', '2100'})
set(gca,'FontSize',20)

% Add labels for various lines
txt = "SSP5-8.5_{"+num2str(SSP585_count)+"}";
text(SSP_time(end/3)+10,GMSST_SSP585_mean(end/2)+2,txt,'FontSize',16, ...
    'Color', color_SSP585, 'FontWeight', 'bold')
txt = "SSP1-2.6_{"+num2str(SSP126_count)+"}";
text(SSP_time(end/3),GMSST_SSP126_mean(end/2)-0.7,txt,'FontSize',16, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
txt = "SSP2-4.5_{"+num2str(SSP245_count)+"}";
text(SSP_time(end/2)+20,GMSST_SSP126_mean(end/2)-0.6,txt,'FontSize',16, ...
    'Color', color_SSP245, 'FontWeight', 'bold')
txt = "SSP3-7.0_{"+num2str(SSP370_count)+"}";
text(SSP_time(end/4),GMSST_SSP370_mean(end),txt,'FontSize',16, ...
    'Color', color_SSP370, 'FontWeight', 'bold')
txt = "CMIP_{"+num2str(CMIP_count)+" models}";
text(CMIP_time(end/5)-20,GMSST_CMIP_mean(end/2)+0.5,txt,'FontSize',16, ...
    'Color', color_CMIP, 'FontWeight', 'bold')
txt = {"HighResMIP", "(historical_{"+num2str(HRMIP_count)+"}/SSP5-8.5_{"+num2str(HRSSP_count)+"})"};
text(HRMIP_time(end/4)+20,GMSST_HRMIP_mean(end/2)+1,txt,'FontSize',16, ...
    'Color', color_HRMIP, 'FontWeight', 'bold','HorizontalAlignment','center')
%txt = "(historical_{"+num2str(HRMIP_count)+"}/SSP5-8.5_{" ...
%    +num2str(HRSSP_count)+"})";
%text(HRMIP_time(end/4)-10,GMSST_HRMIP_mean(end/2)+0.9,txt,'FontSize',16, ...
%    'Color', color_HRMIP, 'FontWeight', 'bold')
txt = {'Observational',  'Reanalyses'};
text(OBS_time(end/3),GMSST_OBS_mean(end/2)+0.5,txt,'FontSize',16, ...
    'Color', color_OBS, 'FontWeight', 'bold','HorizontalAlignment','center')
txt = 'Global Mean SST (GMSST); modern history and model projections to 2100';
text(1855,4.7,txt,'FontSize',18, ...
    'Color', 'k', 'FontWeight', 'bold')
% txt = 'From paleo data (left panels), modern observations and models (this panel)';
% text(1855,4.2,txt,'FontSize',18, ...
%     'Color', 'k', 'FontWeight', 'normal')
% txt = "^oC";
% text(1835,2.5,txt,'FontSize',20, ...
%     'Color', color_CMIP)
ylabel('^o C     ')
set(get(gca,'YLabel'),'Rotation',0)

set(gca,'Box', 'on','Clipping','off')

plot([2104,2104], [GMSST_SSP126_mean(end), GMSST_SSP126_mean(end)] ...
    , '.', 'Color',color_SSP126, 'MarkerSize', 20)
plot([2104,2104], [SSP126_Likely_ubound(end), SSP126_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width)
plot([2104,2104], [SSP126_VeryLikely_ubound(end), SSP126_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width/2)

plot([2106,2106], [GMSST_SSP245_mean(end), GMSST_SSP245_mean(end)] ...
    , '.', 'Color',color_SSP245, 'MarkerSize', 20)
plot([2106,2106], [SSP245_Likely_ubound(end), SSP245_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP245, 'LineWidth', width)
plot([2106,2106], [SSP245_VeryLikely_ubound(end), SSP245_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP245, 'LineWidth', width/2)

plot([2108,2108], [GMSST_SSP370_mean(end), GMSST_SSP370_mean(end)] ...
    , '.', 'Color',color_SSP370, 'MarkerSize', 20)
plot([2108,2108], [SSP370_Likely_ubound(end), SSP370_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP370, 'LineWidth', width)
plot([2108,2108], [SSP370_VeryLikely_ubound(end), SSP370_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP370, 'LineWidth', width/2)

plot([2110,2110], [GMSST_SSP585_mean(end), GMSST_SSP585_mean(end)] ...
    , '.', 'Color',color_SSP585, 'MarkerSize', 20)
plot([2110,2110], [SSP585_Likely_ubound(end), SSP585_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width)
plot([2110,2110], [SSP585_VeryLikely_ubound(end), SSP585_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width/2)



ylength = ylims(2)-ylims(1);
patch([ref_start_yr ref_end_yr ref_end_yr ref_start_yr], ...
    [ylims(1)+0.05*ylength ylims(1)+0.05*ylength ylims(1) ylims(1)],'k', ...
    'EdgeColor', 'none','FaceAlpha', 0.2)
txt = {'Baseline Period'};
text(ref_end_yr+13,ylims(1)+0.03*ylength,txt,'FontSize',12, ...
    'Color', 'k','HorizontalAlignment','center')%, 'FontWeight', 'bold')
txt = {'CMIP6', '2100 means &', '(very) likely', 'ranges'};
text(2100+10,ylims(1)+0.15*ylength,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

set(gca,'TickDir','in');
xlim([1850 2101])
plot([1850 2101], [1850 2101]*0, 'k', 'LineWidth', width/10)
% set(gca,'Xtick',[1851 1900 1950 2000 2050 2100],'Xticklabel', ...
%     {'1850', '', '1900','1950','2000','2050 '2300'})

legend([means likely],'Mean GMSST', ...
    'CMIP6 Likely (17-83%) ranges','Box','off' ...
    ,'Position',[0.25 0.5 0.1 0.1],'FontSize',14)

%dim = [.7 .6 .5 .3];
%str = "MIP Model Counts:  "+num2str(CMIP_count)+"/"+num2str(HRMIP_count) ...
%    +"/"+num2str(SSP126_count)+"/"+num2str(SSP245_count)+"/"+ ...
%    num2str(SSP370_count)+"/"+num2str(SSP585_count);
%annotation('textbox',dim,'String',str,'FitBoxToText','on');

axes('Position',[.45 .5 .2 .3])
width=width/2;
box on
patch(SSP_Time_Conf_Bounds,SSP126_Likely_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
patch(SSP_Time_Conf_Bounds,SSP245_Likely_Conf_Bounds,color_SSP245, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP370_Likely_Conf_Bounds,color_SSP370, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP585_Likely_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
likely = patch(CMIP_Time_Conf_Bounds,CMIP_Likely_Conf_Bounds,color_CMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
% patch(HRMIP_Time_Conf_Bounds,HRMIP_Likely_Conf_Bounds,color_HRMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
% patch(HRSSP_Time_Conf_Bounds,HRSSP_Likely_Conf_Bounds,color_HRSSP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(HighResMIP_Time_Conf_Bounds,HighResMIP_Likely_Conf_Bounds,color_HRSSP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(SSP_time,GMSST_SSP126_mean,'Color', color_SSP126, 'LineWidth', width)
plot(SSP_time,GMSST_SSP245_mean,'Color', color_SSP245, 'LineWidth', width)
plot(SSP_time,GMSST_SSP370_mean,'Color', color_SSP370, 'LineWidth', width)
plot(SSP_time,GMSST_SSP585_mean,'Color', color_SSP585, 'LineWidth', width)
means=plot(CMIP_time,GMSST_CMIP_mean, 'Color', color_CMIP, 'LineWidth', width)
plot(OBS_time,GMSST_OBS_mean, 'Color', color_OBS, 'LineWidth', width)
% plot(HRMIP_time,GMSST_HRMIP_mean, 'Color', color_HRMIP, 'LineWidth', width)
% plot(HRSSP_time,GMSST_HRSSP_mean, 'Color', color_HRSSP, 'LineWidth', width)
plot(HighResMIP_time,GMSST_HighResMIP_mean, 'Color', color_HRSSP, 'LineWidth', width)
xlim([2000 2020])
plot([2000 2020], [2000 2020]*0, 'k', 'LineWidth', width/10)
ylim([0 1])
set(gca,'FontSize',12)
width=2*width;

print(gcf,'../PNGs/Modern_GMSST.png','-dpng','-r1000', '-painters');


%% Plot extended SSP timeseries

figure('Position', [10 10 200 400])
% subplot(100,1,1:67)

txt = "SSP5-8.5_{"+num2str(SSP585_Extended_count)+"}";
text(SSP_Extended_time(end/4),GMSST_SSP585_Extended_mean(end/2)+2,txt,'FontSize',12, ...
    'Color', color_SSP585, 'FontWeight', 'bold')

txt = "SSP1-2.6_{"+num2str(SSP126_Extended_count)+"}";
text(SSP_Extended_time(end/4),GMSST_SSP126_Extended_mean(end/2)+2,txt,'FontSize',12, ...
    'Color', color_SSP126, 'FontWeight', 'bold')

box on
patch(SSP_Extended_Time_Conf_Bounds,SSP126_Extended_Likely_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
patch(SSP_Extended_Time_Conf_Bounds,SSP585_Extended_Likely_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(SSP_Extended_time,GMSST_SSP126_Extended_mean,'Color', color_SSP126, 'LineWidth', width)
plot(SSP_Extended_time,GMSST_SSP585_Extended_mean,'Color', color_SSP585, 'LineWidth', width)
xlim([2100 2300])
plot([2100 2300], [2100 2300]*0, 'k', 'LineWidth', width/10)
ylim([0 15])
% set(gca,'Xtick',[2100],'Xticklabel',[])
% set(gca,'FontSize',15)
% subplot(100,1,70:100)
% box on
% patch(SSP_Extended_Time_Conf_Bounds,SSP126_Extended_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
% hold on
% patch(SSP_Extended_Time_Conf_Bounds,SSP585_Extended_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
% plot(SSP_Extended_time,GMSST_SSP126_Extended_mean,'Color', color_SSP126, 'LineWidth', width)
% plot(SSP_Extended_time,GMSST_SSP585_Extended_mean,'Color', color_SSP585, 'LineWidth', width)
% xlim([2100 2300])
% ylim([-.5 5])
set(gca,'Xtick',[2100 2200 2300],'Xticklabel',{'2100', '', '2300'})
set(gca,'Ytick',[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15], ...
    'Yticklabel',{'0','','','','','5','','','','','10','','','','','15'})
set(gca,'FontSize',15)
width=2*width;
ylabel('^o C     ')
set(get(gca,'YLabel'),'Rotation',0)

txt = 'Extended';
text(2105,14.5,txt,'FontSize',16, ...
    'Color', 'k', 'FontWeight', 'bold')
txt = 'projections';
text(2105,13.5,txt,'FontSize',16, ...
    'Color', 'k', 'FontWeight', 'bold')

print(gcf,'../PNGs/Extended_GMSST.png','-dpng','-r1000', '-painters');



%% Plot paleo data

offset=0.1;

figure('Position', [10 10 200 400])
% subplot(100,1,1:57)
plot([.5,.5]-offset, [1 1]*MPWP_obs_mean, '.', 'MarkerSize',25, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % Paleo-data ranges taken from Bopp et al., 2018 datasets
hold on
plot([.5,.5]-offset, MPWP_obs_bounds, '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 5.5Myr-400kyr BP
plot([2,2]-offset, [1 1]*LIG_obs_mean, '.', 'MarkerSize',25, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([2,2]-offset, LIG_obs_bounds, '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 400-22kyr BP
plot([3.5,3.5]-offset, [1 1]*LGM_obs_mean, '.', 'MarkerSize',25, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([3.5,3.5]-offset, LGM_obs_bounds, '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 22kyr BP- Present - New data from Alan (Slack Nov 2020)

plot([.5,.5]+offset, [1 1]*MPWP_model_mean, '.', 'MarkerSize',25, 'LineWidth', width/2,'MarkerEdgeColor', color_CMIP,'Color', color_CMIP) % Paleo-data ranges taken from Bopp et al., 2018 datasets
plot([.5,.5]+offset, MPWP_model_bounds, '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_CMIP) % 5.5Myr-400kyr BP
plot([2,2]+offset, [1 1]*LIG_model_mean, '.', 'MarkerSize',25, 'LineWidth', width/2,'MarkerEdgeColor', color_CMIP,'Color', color_CMIP) 
plot([2,2]+offset, LIG_model_bounds, '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_CMIP) % 400-22kyr BP
plot([3.5,3.5]+offset, [1 1]*LGM_model_mean, '.', 'MarkerSize',25, 'LineWidth', width/2,'MarkerEdgeColor', color_CMIP,'Color', color_CMIP) 
plot([3.5,3.5]+offset, LGM_model_bounds, '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_CMIP) % 22kyr BP- Present - New data from Alan (Slack Nov 2020)

% 
% 
% plot([2,2], [SST_LIG_mn, SST_LIG_mn], '.','MarkerEdgeColor', color_CMIP,'Color', color_CMIP, 'MarkerSize',35, 'LineWidth', width/2) % PMIP
% %plot([2,2], [SST_LIG_mn+SST_LIG_std, SST_LIG_mn - SST_LIG_std] ...
% %    , '-','MarkerEdgeColor', color_CMIP, 'MarkerSize',35,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
% plot([3.5,3.5], [SST_mHOL_mn, SST_mHOL_mn], '.','MarkerEdgeColor', color_CMIP, 'MarkerSize',35,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
% %plot([3.5,3.5], [SST_mHOL_mn+SST_mHOL_std, SST_mHOL_mn - SST_mHOL_std] ...
% %    , '-','MarkerEdgeColor', color_CMIP, 'MarkerSize',35,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
% plot([.5,.5], [SST_mPLI_mn, SST_mPLI_mn], '.','MarkerEdgeColor', color_CMIP, 'MarkerSize',35,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
% %plot([.5,.5], [SST_mPLI_mn+SST_mPLI_std, SST_mPLI_mn - SST_mPLI_std] ...
% %    ,'MarkerEdgeColor', color_CMIP, 'MarkerSize',35,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
xlim([0 4])
plot([0 5], [0 5]*0, 'k', 'LineWidth', width/10)
ylim([-5 5])
set(gca,'Xtick',[0.5 2 3.5],'Xticklabel',[])
set(gca,'Ytick',[-4 -3 -2 -1 0 1 2 3 4 5],'Yticklabel',{'-4','','-2','','0', '','2','','4', ''})
set(gca,'FontSize',15,'Box', 'on')
txt = {'Observations'};
text(0.1,-1.3,txt,'FontSize',14, ...
    'Color', color_OBS, 'FontWeight', 'bold','HorizontalAlignment','left')
txt = {'Models (PMIP)'};
text(0.1,-1.9,txt,'FontSize',14, ...
    'Color', color_CMIP, 'FontWeight', 'bold','HorizontalAlignment','left')
ylabel('^o C   ')
set(get(gca,'YLabel'),'Rotation',0)

text(0.5,-4.6-1,{'MPWP'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(2,-4.6-1,{'LIG'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(3.5,-4.6-1,{'LGM'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')

txt = 'Paleo GMSST';
text(0.1 ,4.6,txt,'FontSize',18, ...
    'Color', 'k', 'FontWeight', 'bold')

txt = {'Mean & 95% conf.','                 interval'};
text(0.3,3.8,txt,'FontSize',12, ...
    'Color', 'k','HorizontalAlignment','left')

print(gcf,'../PNGs/Paleo_GMSST.png','-dpng','-r1000', '-painters');


%% Save timeseries data in an Excel file

savefile = 'GMSST_Anomaly_Timeseries.xls';

Time_yr = CMIP_time';
Mean_degC = GMSST_CMIP_mean;
Likely_upper_bound = CMIP_Likely_ubound;
Likely_lower_bound = CMIP_Likely_lbound;
VeryLikely_upper_bound = CMIP_VeryLikely_ubound;
VeryLikely_lower_bound = CMIP_VeryLikely_lbound;
T = table(Time_yr,Mean_degC,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','CMIP');

Time_yr = OBS_time';
Mean_degC = GMSST_OBS_mean;
Standard_Deviation = GMSST_OBS_std;
T = table(Time_yr,Mean_degC,Standard_Deviation);
writetable(T,savefile,'Sheet','Obs. Reanalyses (HadISST)');

Time_yr = SSP_time';
Mean_degC = GMSST_SSP126_mean;
Likely_upper_bound = SSP126_Likely_ubound;
Likely_lower_bound = SSP126_Likely_lbound;
VeryLikely_upper_bound = SSP126_VeryLikely_ubound;
VeryLikely_lower_bound = SSP126_VeryLikely_lbound;
T = table(Time_yr,Mean_degC,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','SSP1-2.6');

Time_yr = SSP_time';
Mean_degC = GMSST_SSP245_mean;
Likely_upper_bound = SSP245_Likely_ubound;
Likely_lower_bound = SSP245_Likely_lbound;
VeryLikely_upper_bound = SSP245_VeryLikely_ubound;
VeryLikely_lower_bound = SSP245_VeryLikely_lbound;
T = table(Time_yr,Mean_degC,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','SSP2-4.5');

Time_yr = SSP_time';
Mean_degC = GMSST_SSP370_mean;
Likely_upper_bound = SSP370_Likely_ubound;
Likely_lower_bound = SSP370_Likely_lbound;
VeryLikely_upper_bound = SSP370_VeryLikely_ubound;
VeryLikely_lower_bound = SSP370_VeryLikely_lbound;
T = table(Time_yr,Mean_degC,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','SSP3-7.0');

Time_yr = SSP_time';
Mean_degC = GMSST_SSP585_mean;
Likely_upper_bound = SSP585_Likely_ubound;
Likely_lower_bound = SSP585_Likely_lbound;
VeryLikely_upper_bound = SSP585_VeryLikely_ubound;
VeryLikely_lower_bound = SSP585_VeryLikely_lbound;
T = table(Time_yr,Mean_degC,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','SSP5-8.5');

Time_yr = HRMIP_time';
Mean_degC = GMSST_HRMIP_mean;
Likely_upper_bound = HRMIP_Likely_ubound;
Likely_lower_bound = HRMIP_Likely_lbound;
VeryLikely_upper_bound = HRMIP_VeryLikely_ubound;
VeryLikely_lower_bound = HRMIP_VeryLikely_lbound;
T = table(Time_yr,Mean_degC,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','HighResMIP (historical)');

Time_yr = HRSSP_time';
Mean_degC = GMSST_HRSSP_mean;
Likely_upper_bound = HRSSP_Likely_ubound;
Likely_lower_bound = HRSSP_Likely_lbound;
VeryLikely_upper_bound = HRSSP_VeryLikely_ubound;
VeryLikely_lower_bound = HRSSP_VeryLikely_lbound;
T = table(Time_yr,Mean_degC,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','HighResMIP (future)');

Time_yr = SSP_Extended_time';
Mean_degC = GMSST_SSP126_Extended_mean;
Likely_upper_bound = SSP126_Extended_Likely_ubound;
Likely_lower_bound = SSP126_Extended_Likely_lbound;
VeryLikely_upper_bound = SSP126_Extended_VeryLikely_ubound;
VeryLikely_lower_bound = SSP126_Extended_VeryLikely_lbound;
T = table(Time_yr,Mean_degC,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','SSP1-2.6 Extended (2300)');

Time_yr = SSP_Extended_time';
Mean_degC = GMSST_SSP585_Extended_mean;
Likely_upper_bound = SSP585_Extended_Likely_ubound;
Likely_lower_bound = SSP585_Extended_Likely_lbound;
VeryLikely_upper_bound = SSP585_Extended_VeryLikely_ubound;
VeryLikely_lower_bound = SSP585_Extended_VeryLikely_lbound;
T = table(Time_yr,Mean_degC,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','SSP5-8.5 Extended (2300)');

%% Write data from modern timeseries into netcdf files

var_name = 'SST';
var_units = 'degrees Celsius';
comments = "Data is for panel (a) of Figure 9.3 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp126likelybounds.nc';
title = "Likely range of Global Mean Sea Surface Temperature Anomaly for "+ ...
    "SSP1-2.6 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP126_Likely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp245likelybounds.nc';
title = "Likely range of Global Mean Sea Surface Temperature Anomaly for "+ ...
    "SSP2-4.5 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP245_Likely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp370likelybounds.nc';
title = "Likely range of Global Mean Sea Surface Temperature Anomaly for "+ ...
    "SSP3-7.0 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP370_Likely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp585likelybounds.nc';
title = "Likely range of Global Mean Sea Surface Temperature Anomaly for "+ ...
    "SSP5-8.5 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP585_Likely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp126verylikelybounds.nc';
title = "Very likely range of Global Mean Sea Surface Temperature Anomaly for "+ ...
    "SSP1-2.6 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP126_VeryLikely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp245verylikelybounds.nc';
title = "Very likely range of Global Mean Sea Surface Temperature Anomaly for "+ ...
    "SSP2-4.5 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP245_VeryLikely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp370verylikelybounds.nc';
title = "Very likely range of Global Mean Sea Surface Temperature Anomaly for "+ ...
    "SSP3-7.0 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP370_VeryLikely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp585verylikelybounds.nc';
title = "Very likely range of Global Mean Sea Surface Temperature Anomaly for "+ ...
    "SSP5-8.5 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP585_VeryLikely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_HighResMIPlikelybounds.nc';
title = "Likely range of Global Mean Sea Surface Temperature Anomaly "+ ...
    "relative to baseline period using CMIP6 (HighResMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, HighResMIP_Likely_Conf_Bounds', ...
    HighResMIP_Time_Conf_Bounds, title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_CMIPlikelybounds.nc';
title = "Likely range of Global Mean Sea Surface Temperature Anomaly "+ ...
    "relative to baseline period using CMIP6 (CMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, CMIP_Likely_Conf_Bounds', ...
    CMIP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp126mean.nc';
title = "Mean Global Mean Sea Surface Temperature anomaly for SSP1-2.6 relative to "+ ...
    "baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, GMSST_SSP126_mean', ...
    SSP_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp245mean.nc';
title = "Mean Global Mean Sea Surface Temperature anomaly for SSP2-4.5 relative to "+ ...
    "baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, GMSST_SSP245_mean', ...
    SSP_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp370mean.nc';
title = "Mean Global Mean Sea Surface Temperature anomaly for SSP3-7.0 relative to "+ ...
    "baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, GMSST_SSP370_mean', ...
    SSP_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp585mean.nc';
title = "Mean Global Mean Sea Surface Temperature anomaly for SSP5-8.5 relative to "+ ...
    "baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, GMSST_SSP585_mean', ...
    SSP_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_HighResMIPmean.nc';
title = "Mean Global Mean Sea Surface Temperature anomaly relative to "+ ...
    "baseline period using CMIP6 (HighResMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, GMSST_HighResMIP_mean(6:end-5)', ...
    HighResMIP_time(6:end-5), title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_CMIPmean.nc';
title = "Mean Global Mean Sea Surface Temperature anomaly relative to "+ ...
    "baseline period using CMIP6 (CMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, GMSST_CMIP_mean', ...
    CMIP_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_Observedmean.nc';
title = "Mean Global Mean Sea Surface Temperature anomaly relative to "+ ...
    "baseline period using HadISST (observation-based)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, GMSST_OBS_mean', ...
    OBS_time', title, comments)

%% Write data for extended timeseries

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp126mean_extended.nc';
title = "Mean Global Mean Sea Surface Temperature anomaly relative to "+ ...
    "baseline period for SSP1-2.6 extended time period using CMIP6 (CMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, GMSST_SSP126_Extended_mean', ...
    SSP_Extended_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp585mean_extended.nc';
title = "Mean Global Mean Sea Surface Temperature anomaly relative to "+ ...
    "baseline period for SSP5-8.5 extended time period using CMIP6 (CMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, GMSST_SSP585_Extended_mean', ...
    SSP_Extended_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp126likelybounds_extended.nc';
title = "Likely range of Global Mean Sea Surface Temperature Anomaly for "+ ...
    "SSP1-2.6 relative to baseline period for extended CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP126_Extended_Likely_Conf_Bounds', ...
    SSP_Extended_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-3a_data_ssp585likelybounds_extended.nc';
title = "Likely range of Global Mean Sea Surface Temperature Anomaly for "+ ...
    "SSP5-8.5 relative to baseline period for extended CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP585_Extended_Likely_Conf_Bounds', ...
    SSP_Extended_Time_Conf_Bounds', title, comments)

%% Write paleo plot data

creator = "Brodie Pearson (brodie.pearson@oregonstate.edu)";
activity = "IPCC AR6 (Chapter 9)";
ncfilename = '../Plotted_Data/Fig9-3a_data_paleo.nc';
title = "Paleo global mean sea surface temperature datasets "+ ...
    "with both means and likely ranges where neccessary from observations" + ...
    "(obs) and model results";

% Create variables in netcdf files
nccreate(ncfilename,'MPWP_obs_mean');
nccreate(ncfilename,'MPWP_obs_likely_bound_upper');
nccreate(ncfilename,'MPWP_obs_likely_bound_lower');
nccreate(ncfilename,'MPWP_model_mean');
nccreate(ncfilename,'MPWP_model_likely_bound_upper');
nccreate(ncfilename,'MPWP_model_likely_bound_lower');
nccreate(ncfilename,'LIG_obs_mean');
nccreate(ncfilename,'LIG_obs_likely_bound_upper');
nccreate(ncfilename,'LIG_obs_likely_bound_lower');
nccreate(ncfilename,'LIG_model_mean');
nccreate(ncfilename,'LIG_model_likely_bound_upper');
nccreate(ncfilename,'LIG_model_likely_bound_lower');
nccreate(ncfilename,'LGM_obs_mean');
nccreate(ncfilename,'LGM_obs_likely_bound_upper');
nccreate(ncfilename,'LGM_obs_likely_bound_lower');
nccreate(ncfilename,'LGM_model_mean');
nccreate(ncfilename,'LGM_model_likely_bound_upper');
nccreate(ncfilename,'LGM_model_likely_bound_lower');

% Write variables to netcdf files
ncwrite(ncfilename,'MPWP_obs_mean',MPWP_obs_mean);
ncwrite(ncfilename,'MPWP_obs_likely_bound_upper',MPWP_obs_bounds(1));
ncwrite(ncfilename,'MPWP_obs_likely_bound_lower',MPWP_obs_bounds(2));
ncwrite(ncfilename,'MPWP_model_mean',MPWP_model_mean);
ncwrite(ncfilename,'MPWP_model_likely_bound_upper',MPWP_model_bounds(1));
ncwrite(ncfilename,'MPWP_model_likely_bound_lower',MPWP_model_bounds(2));
ncwrite(ncfilename,'LIG_obs_mean',LIG_obs_mean);
ncwrite(ncfilename,'LIG_obs_likely_bound_upper',LIG_obs_bounds(1));
ncwrite(ncfilename,'LIG_obs_likely_bound_lower',LIG_obs_bounds(2));
ncwrite(ncfilename,'LIG_model_mean',LIG_model_mean);
ncwrite(ncfilename,'LIG_model_likely_bound_upper',LIG_model_bounds(1));
ncwrite(ncfilename,'LIG_model_likely_bound_lower',LIG_model_bounds(2));
ncwrite(ncfilename,'LGM_obs_mean',LGM_obs_mean);
ncwrite(ncfilename,'LGM_obs_likely_bound_upper',LGM_obs_bounds(1));
ncwrite(ncfilename,'LGM_obs_likely_bound_lower',LGM_obs_bounds(2));
ncwrite(ncfilename,'LGM_model_mean',LGM_model_mean);
ncwrite(ncfilename,'LGM_model_likely_bound_upper',LGM_model_bounds(1));
ncwrite(ncfilename,'LGM_model_likely_bound_lower',LGM_model_bounds(2));


% Write metadata to netcdf file
ncwriteatt(ncfilename,'/','title',title);
ncwriteatt(ncfilename,'/','units',var_units);
ncwriteatt(ncfilename,'/','creator',creator);
ncwriteatt(ncfilename,'/','activity',activity);
ncwriteatt(ncfilename,'/','comments',comments);



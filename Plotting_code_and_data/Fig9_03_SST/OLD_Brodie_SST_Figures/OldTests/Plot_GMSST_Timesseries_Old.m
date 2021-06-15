%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surfact temperature (SST) - named tos in CMIP6 

clear all

addpath ../../Matlab_Functions/
fontsize=15;

color_OBS = [196 121 0]/255;
color_HRMIP = [0 79 0]/255;
color_HRSSP = [0 79 0]/255;
color_CMIP = [0 0 0]/255;
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

%% Load paleo data and calculate means/stds

SST_LIG = ncread('output_paleo/avg_anomaly_lig127k.nc','tos');
TIME_LIG = ncread('output_paleo/avg_anomaly_lig127k.nc','time');

SST_mHOL = ncread('output_paleo/avg_anomaly_midHolocene.nc','tos');
TIME_mHOL = ncread('output_paleo/avg_anomaly_midHolocene.nc','time');

SST_mPLI = ncread('output_paleo/avg_anomaly_midPliocene.nc','tos');
TIME_mPLI = ncread('output_paleo/avg_anomaly_midPliocene.nc','time');

SST_LIG_mn = nanmean(SST_LIG);
SST_LIG_std = nanstd(SST_LIG);
SST_mHOL_mn = nanmean(SST_mHOL);
SST_mHOL_std = nanstd(SST_mHOL);
SST_mPLI_mn = nanmean(SST_mPLI);
SST_mPLI_std = nanstd(SST_mPLI);


%% Make plots

filename = 'GMSST_Timeseries_Data.mat';

load(filename);

OBS_GMSST_anom_mean = nanmean(OBS_GMSST_anom,2);
HRMIP_GMSST_anom_mean = nanmean(HRMIP_GMSST_anom,2);
CMIP_GMSST_anom_mean = nanmean(CMIP_GMSST_anom,2);
SSP126_GMSST_anom_mean = nanmean(SSP126_GMSST_anom,2);
SSP245_GMSST_anom_mean = nanmean(SSP245_GMSST_anom,2);
SSP370_GMSST_anom_mean = nanmean(SSP370_GMSST_anom,2);
SSP585_GMSST_anom_mean = nanmean(SSP585_GMSST_anom,2);
HRSSP_GMSST_anom_mean = nanmean(HRSSP_GMSST_anom,2);


OBS_GMSST_anom_std = nanstd(OBS_GMSST_anom,0,2);
HRMIP_GMSST_anom_std = nanstd(HRMIP_GMSST_anom,0,2);
CMIP_GMSST_anom_std = nanstd(CMIP_GMSST_anom,0,2);
SSP126_GMSST_anom_std = nanstd(SSP126_GMSST_anom,0,2);
SSP245_GMSST_anom_std = nanstd(SSP245_GMSST_anom,0,2);
SSP370_GMSST_anom_std = nanstd(SSP370_GMSST_anom,0,2);
SSP585_GMSST_anom_std = nanstd(SSP585_GMSST_anom,0,2);
HRSSP_GMSST_anom_std = nanstd(HRSSP_GMSST_anom,0,2);

%% Diagnose model count numbers
CMIP_count = size(CMIP_GMSST_anom,2);
SSP126_count = size(SSP126_GMSST_anom,2);
SSP245_count = size(SSP245_GMSST_anom,2);
SSP370_count = size(SSP370_GMSST_anom,2);
SSP585_count = size(SSP585_GMSST_anom,2);
HRMIP_count = size(HRMIP_GMSST_anom,2);
HRSSP_count = size(HRSSP_GMSST_anom,2);

%% Write means, stds and times to CSV files

savefile = 'GMSST_Timeseries_Data.xls';

Time_yr = CMIP_time';
Mean_degC = CMIP_GMSST_anom_mean;
Std_degC = CMIP_GMSST_anom_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','CMIP');
Time_yr = OBS_time';
Mean_degC = OBS_GMSST_anom_mean;
T = table(Time_yr,Mean_degC);
writetable(T,savefile,'Sheet','Observations');
Time_yr = HRMIP_time';
Mean_degC = HRMIP_GMSST_anom_mean;
Std_degC = HRMIP_GMSST_anom_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','HighResMIP');
Time_yr = HRSSP_time';
Mean_degC = HRSSP_GMSST_anom_mean;
Std_degC = HRSSP_GMSST_anom_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','HighResMIP-SSP585');
Time_yr = SSP_time';
Mean_degC = SSP126_GMSST_anom_mean;
Std_degC = SSP126_GMSST_anom_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','SSP126');
Mean_degC = SSP245_GMSST_anom_mean;
Std_degC = SSP245_GMSST_anom_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','SSP245');
Mean_degC = SSP370_GMSST_anom_mean;
Std_degC = SSP370_GMSST_anom_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','SSP370');
Mean_degC = SSP585_GMSST_anom_mean;
Std_degC = SSP585_GMSST_anom_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','SSP585');

%% Calculate std/mean bounds for drawing polygon shading for uncertainty


width = 5;

SSP126_ubound=SSP126_GMSST_anom_mean+SSP126_GMSST_anom_std;
SSP126_lbound=SSP126_GMSST_anom_mean-SSP126_GMSST_anom_std;
SSP126_Conf_Bounds = [SSP126_ubound' fliplr(SSP126_lbound')];
SSP245_ubound=SSP245_GMSST_anom_mean+SSP245_GMSST_anom_std;
SSP245_lbound=SSP245_GMSST_anom_mean-SSP245_GMSST_anom_std;
SSP245_Conf_Bounds = [SSP245_ubound' fliplr(SSP245_lbound')];
SSP370_ubound=SSP370_GMSST_anom_mean+SSP370_GMSST_anom_std;
SSP370_lbound=SSP370_GMSST_anom_mean-SSP370_GMSST_anom_std;
SSP370_Conf_Bounds = [SSP370_ubound' fliplr(SSP370_lbound')];
SSP585_ubound=SSP585_GMSST_anom_mean+SSP585_GMSST_anom_std;
SSP585_lbound=SSP585_GMSST_anom_mean-SSP585_GMSST_anom_std;
SSP585_Conf_Bounds = [SSP585_ubound' fliplr(SSP585_lbound')];
SSP_Time_Conf_Bounds = [SSP_time fliplr(SSP_time)];

CMIP_ubound=CMIP_GMSST_anom_mean+CMIP_GMSST_anom_std;
CMIP_lbound=CMIP_GMSST_anom_mean-CMIP_GMSST_anom_std;
CMIP_Conf_Bounds = [CMIP_ubound' fliplr(CMIP_lbound')];
CMIP_Time_Conf_Bounds = [CMIP_time fliplr(CMIP_time)];

HRMIP_ubound=HRMIP_GMSST_anom_mean+HRMIP_GMSST_anom_std;
HRMIP_lbound=HRMIP_GMSST_anom_mean-HRMIP_GMSST_anom_std;
HRMIP_Conf_Bounds = [HRMIP_ubound' fliplr(HRMIP_lbound')];
HRMIP_Time_Conf_Bounds = [HRMIP_time fliplr(HRMIP_time)];
HRSSP_ubound=HRSSP_GMSST_anom_mean+HRSSP_GMSST_anom_std;
HRSSP_lbound=HRSSP_GMSST_anom_mean-HRSSP_GMSST_anom_std;
HRSSP_Conf_Bounds = [HRSSP_ubound' fliplr(HRSSP_lbound')];
HRSSP_Time_Conf_Bounds = [HRSSP_time fliplr(HRSSP_time)];

%% Create Figures

figure('Position', [10 10 1200 400])
patch(SSP_Time_Conf_Bounds,SSP126_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
patch(SSP_Time_Conf_Bounds,SSP245_Conf_Bounds,color_SSP245, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP370_Conf_Bounds,color_SSP370, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP585_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(HRSSP_Time_Conf_Bounds,HRSSP_Conf_Bounds,color_HRSSP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(HRMIP_Time_Conf_Bounds,HRMIP_Conf_Bounds,color_HRMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(CMIP_Time_Conf_Bounds,CMIP_Conf_Bounds,color_CMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(SSP_time,SSP126_GMSST_anom_mean,'Color', color_SSP126, 'LineWidth', width)
plot(SSP_time,SSP245_GMSST_anom_mean,'Color', color_SSP245, 'LineWidth', width)
plot(SSP_time,SSP370_GMSST_anom_mean,'Color', color_SSP370, 'LineWidth', width)
plot(SSP_time,SSP585_GMSST_anom_mean,'Color', color_SSP585, 'LineWidth', width)
plot(CMIP_time,CMIP_GMSST_anom_mean, 'Color', color_CMIP, 'LineWidth', width)
plot(OBS_time,OBS_GMSST_anom_mean, 'Color', color_OBS, 'LineWidth', width)
plot(HRMIP_time,HRMIP_GMSST_anom_mean, 'Color', color_HRMIP, 'LineWidth', width/2)
plot(HRSSP_time,HRSSP_GMSST_anom_mean, 'Color', color_HRSSP, 'LineWidth', width/2)
xlim([1850 2101])
ylim([-.5 5])
set(gca,'FontSize',20)

% Add labels for various lines
txt = "ssp585_{"+num2str(SSP585_count)+"}";
text(SSP_time(end/3),SSP585_GMSST_anom_mean(end/2)+2,txt,'FontSize',20, ...
    'Color', color_SSP585, 'FontWeight', 'bold')
txt = "ssp126_{"+num2str(SSP126_count)+"}";
text(SSP_time(end/3),SSP126_GMSST_anom_mean(end/2)-1,txt,'FontSize',20, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
txt = "ssp245_{"+num2str(SSP245_count)+"}";
text(SSP_time(end/2),SSP126_GMSST_anom_mean(end/2)-0.6,txt,'FontSize',20, ...
    'Color', color_SSP245, 'FontWeight', 'bold')
txt = "ssp370_{"+num2str(SSP370_count)+"}";
text(SSP_time(end/4),SSP370_GMSST_anom_mean(end),txt,'FontSize',20, ...
    'Color', color_SSP370, 'FontWeight', 'bold')
txt = "CMIP_{"+num2str(CMIP_count)+"}";
text(CMIP_time(end/5),CMIP_GMSST_anom_mean(end/2)+0.5,txt,'FontSize',20, ...
    'Color', color_CMIP, 'FontWeight', 'bold')
txt = "HighResMIP";
text(HRMIP_time(end/4),HRMIP_GMSST_anom_mean(end/2)+1.2,txt,'FontSize',15, ...
    'Color', color_HRMIP, 'FontWeight', 'bold')
txt = "(historical_{"+num2str(HRMIP_count)+"} and ssp585_{" ...
    +num2str(HRSSP_count)+"})";
text(HRMIP_time(end/4)-10,HRMIP_GMSST_anom_mean(end/2)+0.9,txt,'FontSize',15, ...
    'Color', color_HRMIP, 'FontWeight', 'bold')
txt = 'Observations';
text(OBS_time(end/3),OBS_GMSST_anom_mean(end/2)+0.5,txt,'FontSize',20, ...
    'Color', color_OBS, 'FontWeight', 'bold')
txt = 'Sea Surface Temperature Anomaly';
text(1855,4.7,txt,'FontSize',25, ...
    'Color', 'k', 'FontWeight', 'bold')
txt = 'From paleo data (left panels), modern observations and models (this panel)';
text(1855,4.2,txt,'FontSize',18, ...
    'Color', 'k', 'FontWeight', 'normal')
txt = "^oC";
text(1835,2.5,txt,'FontSize',20, ...
    'Color', color_CMIP)

set(gca,'Box', 'on','Clipping','off')

% Plot spans of 2100 GMSST
plot([2106,2106], [SSP126_ubound(end), SSP126_lbound(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width/2)
plot([2104,2104], [SSP245_ubound(end), SSP245_lbound(end)] ...
    , '-', 'Color',color_SSP245, 'LineWidth', width/2)
plot([2106,2106], [SSP370_ubound(end), SSP370_lbound(end)] ...
    , '-', 'Color',color_SSP370, 'LineWidth', width/2)
plot([2104,2104], [SSP585_ubound(end), SSP585_lbound(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width/2)

set(gca,'TickDir','out');

%%

figure('Position', [10 10 200 450])
subplot(100,1,1:82)
plot([1,1], [0.39, 0.39], 'ro-', 'MarkerSize',15) % Paleo-data ranges taken from Bopp et al., 2018 datasets
hold on
plot([1,1], [2.53, -1.5], 'r-', 'LineWidth', width) % 5.5Myr-400kyr BP
plot([2,2], [-2.20, -2.20], 'bo-', 'MarkerSize',15) 
plot([2,2], [-0.83, -3.33], 'b-', 'LineWidth', width) % 400-22kyr BP
plot([3,3], [-1.77, -1.77], 'ko-', 'MarkerSize',15)
plot([3,3], [-4.33, 0.21], 'k-', 'LineWidth', width) % 22kyr BP- Present
plot([1.5,1.5], [SST_LIG_mn, SST_LIG_mn], 'go-', 'MarkerSize',15) % PMIP
plot([1.5,1.5], [SST_LIG_mn+SST_LIG_std, SST_LIG_mn - SST_LIG_std] ...
    , 'g-', 'MarkerSize',15) % PMIP
plot([2.5,2.5], [SST_mHOL_mn, SST_mHOL_mn], 'go-', 'MarkerSize',15) % PMIP
plot([2.5,2.5], [SST_mHOL_mn+SST_mHOL_std, SST_mHOL_mn - SST_mHOL_std] ...
    , 'g-', 'MarkerSize',15) % PMIP
plot([3.5,3.5], [SST_mPLI_mn, SST_mPLI_mn], 'go-', 'MarkerSize',15) % PMIP
plot([3.5,3.5], [SST_mPLI_mn+SST_mPLI_std, SST_mPLI_mn - SST_mPLI_std] ...
    , 'g-', 'MarkerSize',15) % PMIP
xlim([0 4])
ylim([0 5])
set(gca,'Xtick',[1 2 3],'Xticklabel',[])
set(gca,'FontSize',20,'Box', 'on')
txt = {'5.5Ma-400kyr Before', 'Present (BP)'};
text(1.5,3,txt,'FontSize',15, ...
    'Color', 'r', 'FontWeight', 'bold','HorizontalAlignment','center')
txt = {'400ka-22ka'};
text(2.1,0.5,txt,'FontSize',15, ...
    'Color', 'b', 'FontWeight', 'bold','HorizontalAlignment','center')
txt = {'22ka', 'to Present'};
text(3,2,txt,'FontSize',15, ...
    'Color', 'k', 'FontWeight', 'bold','HorizontalAlignment','center')
subplot(100,1,85:100)
plot([1,1], [0.39, 0.39], 'ro-', 'MarkerSize',15) % Paleo-data ranges taken from Bopp et al., 2018 datasets
hold on
plot([1,1], [2.53, -1.5], 'r-', 'LineWidth', width) % 5.5Myr-400kyr BP
plot([2,2], [-2.20, -2.20], 'bo-', 'MarkerSize',15) 
plot([2,2], [-0.83, -3.33], 'b-', 'LineWidth', width) % 400-22kyr BP
plot([3,3], [-1.77, -1.77], 'ko-', 'MarkerSize',15)
plot([3,3], [-4.33, 0.21], 'k-', 'LineWidth', width) % 22kyr BP- Present
plot([1.5,1.5], [SST_LIG_mn, SST_LIG_mn], 'go-', 'MarkerSize',15) % PMIP
plot([1.5,1.5], [SST_LIG_mn+SST_LIG_std, SST_LIG_mn - SST_LIG_std] ...
    , 'g-', 'MarkerSize',15) % PMIP
plot([2.5,2.5], [SST_mHOL_mn, SST_mHOL_mn], 'go-', 'MarkerSize',15) % PMIP
plot([2.5,2.5], [SST_mHOL_mn+SST_mHOL_std, SST_mHOL_mn - SST_mHOL_std] ...
    , 'g-', 'MarkerSize',15) % PMIP
plot([3.5,3.5], [SST_mPLI_mn, SST_mPLI_mn], 'go-', 'MarkerSize',15) % PMIP
plot([3.5,3.5], [SST_mPLI_mn+SST_mPLI_std, SST_mPLI_mn - SST_mPLI_std] ...
    , 'g-', 'MarkerSize',15) % PMIP
xlim([0 4])
ylim([-4 0])
set(gca,'Xtick',[1 2 3],'Xticklabel',[])
yticks([-4 -2 0])
yticklabels({'-4','-2',''})
set(gca,'FontSize',20,'Box', 'on')
txt = {'PMIP'};
text(1,-2,txt,'FontSize',15, ...
    'Color', 'g', 'FontWeight', 'bold','HorizontalAlignment','center')
% txt = {'400kyr to 22kyr BP'};
% text(1,-4,txt,'FontSize',18, ...
%     'Color', 'b', 'FontWeight', 'bold','HorizontalAlignment','center')
% txt = {'22kyr BP', 'to Present'};
% text(1,-4,txt,'FontSize',18, ...
%     'Color', 'k', 'FontWeight', 'bold','HorizontalAlignment','center')
%ylabel('Sea Surface Temperature Anomaly (^oC)')
%xlabel('Year')






%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surfact temperature (SST) - named tos in CMIP6 

clear all

addpath ../../Matlab_Functions/
fontsize=15;

% color_OBS = [196 121 0]/255;
% color_HRMIP = [0 79 0]/255;
% color_HRSSP = [0 79 0]/255;
% color_CMIP = [0 0 0]/255;
color_OBS = IPCC_Get_SSPColors('Observations');
color_HRMIP = IPCC_Get_SSPColors('HighResMIP');
color_HRSSP = IPCC_Get_SSPColors('HighResMIP');
color_CMIP = IPCC_Get_SSPColors('CMIP');
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

%% Load paleo data and calculate means/stds

SST_LIG = ncread('paleo_gmsst_data/avg_anomaly_lig127k.nc','tos');
TIME_LIG = ncread('paleo_gmsst_data/avg_anomaly_lig127k.nc','time');

SST_mHOL = ncread('paleo_gmsst_data/avg_anomaly_midHolocene.nc','tos');
TIME_mHOL = ncread('paleo_gmsst_data/avg_anomaly_midHolocene.nc','time');

SST_mPLI = ncread('paleo_gmsst_data/avg_anomaly_midPliocene.nc','tos');
TIME_mPLI = ncread('paleo_gmsst_data/avg_anomaly_midPliocene.nc','time');

SST_LIG_mn = nanmean(SST_LIG);
SST_LIG_std = nanstd(SST_LIG);
SST_mHOL_mn = nanmean(SST_mHOL);
SST_mHOL_std = nanstd(SST_mHOL);
SST_mPLI_mn = nanmean(SST_mPLI);
SST_mPLI_std = nanstd(SST_mPLI);


%% Make plots

filename = 'GMSST_Anomalies.mat';
load(filename);

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
GMSST_HRMIP_std = nanstd(GMSST_HRMIP,0,2);
GMSST_CMIP_std = nanstd(GMSST_CMIP,0,2);
GMSST_SSP126_std = nanstd(GMSST_SSP126,0,2);
GMSST_SSP245_std = nanstd(GMSST_SSP245,0,2);
GMSST_SSP370_std = nanstd(GMSST_SSP370,0,2);
GMSST_SSP585_std = nanstd(GMSST_SSP585,0,2);
GMSST_HRSSP_std = nanstd(GMSST_HRSSP,0,2);
GMSST_SSP126_Extended_std = nanstd(GMSST_SSP126_Extended,0,2);
GMSST_SSP585_Extended_std = nanstd(GMSST_SSP585_Extended,0,2);

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

%% Write means, stds and times to CSV files

savefile = 'GMSST_Anomalies.xls';

Time_yr = CMIP_time';
Mean_degC = GMSST_CMIP_mean;
Std_degC = GMSST_CMIP_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','CMIP');
Time_yr = OBS_time';
Mean_degC = GMSST_OBS_mean;
T = table(Time_yr,Mean_degC);
writetable(T,savefile,'Sheet','Observations');
Time_yr = HRMIP_time';
Mean_degC = GMSST_HRMIP_mean;
Std_degC = GMSST_HRMIP_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','HighResMIP');
Time_yr = HRSSP_time';
Mean_degC = GMSST_HRSSP_mean;
Std_degC = GMSST_HRSSP_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','HighResMIP-SSP585');
Time_yr = SSP_time';
Mean_degC = GMSST_SSP126_mean;
Std_degC = GMSST_SSP126_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','SSP126');
Mean_degC = GMSST_SSP245_mean;
Std_degC = GMSST_SSP245_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','SSP245');
Mean_degC = GMSST_SSP370_mean;
Std_degC = GMSST_SSP370_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','SSP370');
Mean_degC = GMSST_SSP585_mean;
Std_degC = GMSST_SSP585_std;
T = table(Time_yr,Mean_degC,Std_degC);
writetable(T,savefile,'Sheet','SSP585');

%% Calculate std/mean bounds for drawing polygon shading for uncertainty


width = 3;

SSP126_ubound=GMSST_SSP126_mean+GMSST_SSP126_std;
SSP126_lbound=GMSST_SSP126_mean-GMSST_SSP126_std;
SSP126_Conf_Bounds = [SSP126_ubound' fliplr(SSP126_lbound')];
SSP245_ubound=GMSST_SSP245_mean+GMSST_SSP245_std;
SSP245_lbound=GMSST_SSP245_mean-GMSST_SSP245_std;
SSP245_Conf_Bounds = [SSP245_ubound' fliplr(SSP245_lbound')];
SSP370_ubound=GMSST_SSP370_mean+GMSST_SSP370_std;
SSP370_lbound=GMSST_SSP370_mean-GMSST_SSP370_std;
SSP370_Conf_Bounds = [SSP370_ubound' fliplr(SSP370_lbound')];
SSP585_ubound=GMSST_SSP585_mean+GMSST_SSP585_std;
SSP585_lbound=GMSST_SSP585_mean-GMSST_SSP585_std;
SSP585_Conf_Bounds = [SSP585_ubound' fliplr(SSP585_lbound')];
SSP_Time_Conf_Bounds = [SSP_time fliplr(SSP_time)];

SSP126_Extended_ubound=GMSST_SSP126_Extended_mean+GMSST_SSP126_Extended_std;
SSP126_Extended_lbound=GMSST_SSP126_Extended_mean-GMSST_SSP126_Extended_std;
SSP126_Extended_Conf_Bounds = [SSP126_Extended_ubound' fliplr(SSP126_Extended_lbound')];
SSP585_Extended_ubound=GMSST_SSP585_Extended_mean+GMSST_SSP585_Extended_std;
SSP585_Extended_lbound=GMSST_SSP585_Extended_mean-GMSST_SSP585_Extended_std;
SSP585_Extended_Conf_Bounds = [SSP585_Extended_ubound' fliplr(SSP585_Extended_lbound')];
SSP_Extended_Time_Conf_Bounds = [SSP_Extended_time fliplr(SSP_Extended_time)];

CMIP_ubound=GMSST_CMIP_mean+GMSST_CMIP_std;
CMIP_lbound=GMSST_CMIP_mean-GMSST_CMIP_std;
CMIP_Conf_Bounds = [CMIP_ubound' fliplr(CMIP_lbound')];
CMIP_Time_Conf_Bounds = [CMIP_time fliplr(CMIP_time)];

HRMIP_ubound=GMSST_HRMIP_mean+GMSST_HRMIP_std;
HRMIP_lbound=GMSST_HRMIP_mean-GMSST_HRMIP_std;
HRMIP_Conf_Bounds = [HRMIP_ubound' fliplr(HRMIP_lbound')];
HRMIP_Time_Conf_Bounds = [HRMIP_time fliplr(HRMIP_time)];
HRSSP_ubound=GMSST_HRSSP_mean+GMSST_HRSSP_std;
HRSSP_lbound=GMSST_HRSSP_mean-GMSST_HRSSP_std;
HRSSP_Conf_Bounds = [HRSSP_ubound' fliplr(HRSSP_lbound')];
HRSSP_Time_Conf_Bounds = [HRSSP_time fliplr(HRSSP_time)];

%% Create Figures

figure('Position', [10 10 1200 400])
patch(SSP_Time_Conf_Bounds,SSP126_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
%patch(SSP_Time_Conf_Bounds,SSP245_Conf_Bounds,color_SSP245, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
%patch(SSP_Time_Conf_Bounds,SSP370_Conf_Bounds,color_SSP370, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP585_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(HRSSP_Time_Conf_Bounds,HRSSP_Conf_Bounds,color_HRSSP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(HRMIP_Time_Conf_Bounds,HRMIP_Conf_Bounds,color_HRMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(CMIP_Time_Conf_Bounds,CMIP_Conf_Bounds,color_CMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(SSP_time,GMSST_SSP126_mean,'Color', color_SSP126, 'LineWidth', width)
plot(SSP_time,GMSST_SSP245_mean,'Color', color_SSP245, 'LineWidth', width)
plot(SSP_time,GMSST_SSP370_mean,'Color', color_SSP370, 'LineWidth', width)
plot(SSP_time,GMSST_SSP585_mean,'Color', color_SSP585, 'LineWidth', width)
plot(CMIP_time,GMSST_CMIP_mean, 'Color', color_CMIP, 'LineWidth', width)
plot(OBS_time,GMSST_OBS_mean, 'Color', color_OBS, 'LineWidth', width)
plot(HRMIP_time,GMSST_HRMIP_mean, 'Color', color_HRMIP, 'LineWidth', width)
plot(HRSSP_time,GMSST_HRSSP_mean, 'Color', color_HRSSP, 'LineWidth', width)
ylim([-.5 5])
set(gca,'Xtick',[1850 1900 1950 2000 2050 2101],'Xticklabel',{'1850', '1900','1950','2000','2050', '2100'})
set(gca,'FontSize',20)

% Add labels for various lines
txt = "SSP5-8.5_{"+num2str(SSP585_count)+"}";
text(SSP_time(end/3),GMSST_SSP585_mean(end/2)+2,txt,'FontSize',16, ...
    'Color', color_SSP585, 'FontWeight', 'bold')
txt = "SSP1-2.6_{"+num2str(SSP126_count)+"}";
text(SSP_time(end/3),GMSST_SSP126_mean(end/2)-1,txt,'FontSize',16, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
txt = "SSP2-4.5_{"+num2str(SSP245_count)+"}";
text(SSP_time(end/2),GMSST_SSP126_mean(end/2)-0.6,txt,'FontSize',16, ...
    'Color', color_SSP245, 'FontWeight', 'bold')
txt = "SSP3-7.0_{"+num2str(SSP370_count)+"}";
text(SSP_time(end/4),GMSST_SSP370_mean(end),txt,'FontSize',16, ...
    'Color', color_SSP370, 'FontWeight', 'bold')
txt = "CMIP_{"+num2str(CMIP_count)+"}";
text(CMIP_time(end/5),GMSST_CMIP_mean(end/2)+0.5,txt,'FontSize',16, ...
    'Color', color_CMIP, 'FontWeight', 'bold')
txt = "HighResMIP";
text(HRMIP_time(end/4),GMSST_HRMIP_mean(end/2)+1.2,txt,'FontSize',16, ...
    'Color', color_HRMIP, 'FontWeight', 'bold')
txt = "(historical_{"+num2str(HRMIP_count)+"}/SSP5-8.5_{" ...
    +num2str(HRSSP_count)+"})";
text(HRMIP_time(end/4)-10,GMSST_HRMIP_mean(end/2)+0.9,txt,'FontSize',16, ...
    'Color', color_HRMIP, 'FontWeight', 'bold')
txt = {'Observational'  'Reanalyses'};
text(OBS_time(end/3),GMSST_OBS_mean(end/2)+0.5,txt,'FontSize',16, ...
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
plot([2103,2103], [SSP126_ubound(end), SSP126_lbound(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width/2)
plot([2104,2104], [SSP245_ubound(end), SSP245_lbound(end)] ...
    , '-', 'Color',color_SSP245, 'LineWidth', width/2)
plot([2105,2105], [SSP370_ubound(end), SSP370_lbound(end)] ...
    , '-', 'Color',color_SSP370, 'LineWidth', width/2)
plot([2106,2106], [SSP585_ubound(end), SSP585_lbound(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width/2)

set(gca,'TickDir','in');
xlim([1850 2101])

%dim = [.7 .6 .5 .3];
%str = "MIP Model Counts:  "+num2str(CMIP_count)+"/"+num2str(HRMIP_count) ...
%    +"/"+num2str(SSP126_count)+"/"+num2str(SSP245_count)+"/"+ ...
%    num2str(SSP370_count)+"/"+num2str(SSP585_count);
%annotation('textbox',dim,'String',str,'FitBoxToText','on');

axes('Position',[.2 .4 .2 .3])
width=width/2;
box on
patch(SSP_Time_Conf_Bounds,SSP126_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
%patch(SSP_Time_Conf_Bounds,SSP245_Conf_Bounds,color_SSP245, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
%patch(SSP_Time_Conf_Bounds,SSP370_Conf_Bounds,color_SSP370, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP585_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(HRSSP_Time_Conf_Bounds,HRSSP_Conf_Bounds,color_HRSSP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(HRMIP_Time_Conf_Bounds,HRMIP_Conf_Bounds,color_HRMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(CMIP_Time_Conf_Bounds,CMIP_Conf_Bounds,color_CMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(SSP_time,GMSST_SSP126_mean,'Color', color_SSP126, 'LineWidth', width)
plot(SSP_time,GMSST_SSP245_mean,'Color', color_SSP245, 'LineWidth', width)
plot(SSP_time,GMSST_SSP370_mean,'Color', color_SSP370, 'LineWidth', width)
plot(SSP_time,GMSST_SSP585_mean,'Color', color_SSP585, 'LineWidth', width)
plot(CMIP_time,GMSST_CMIP_mean, 'Color', color_CMIP, 'LineWidth', width)
plot(OBS_time,GMSST_OBS_mean, 'Color', color_OBS, 'LineWidth', width)
plot(HRMIP_time,GMSST_HRMIP_mean, 'Color', color_HRMIP, 'LineWidth', width)
plot(HRSSP_time,GMSST_HRSSP_mean, 'Color', color_HRSSP, 'LineWidth', width)
xlim([2000 2020])
ylim([0 1])
set(gca,'FontSize',12)
width=2*width;

print(gcf,'../PNGs/Modern_GMSST.png','-dpng','-r1000', '-painters');


%% Plot extended SSP timeseries

figure('Position', [10 10 200 400])
subplot(100,1,1:67)

txt = "SSP5-8.5_{"+num2str(SSP585_Extended_count)+"}";
text(SSP_Extended_time(end/4),GMSST_SSP585_Extended_mean(end/2)+2,txt,'FontSize',12, ...
    'Color', color_SSP585, 'FontWeight', 'bold')

box on
patch(SSP_Extended_Time_Conf_Bounds,SSP126_Extended_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
patch(SSP_Extended_Time_Conf_Bounds,SSP585_Extended_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(SSP_Extended_time,GMSST_SSP126_Extended_mean,'Color', color_SSP126, 'LineWidth', width)
plot(SSP_Extended_time,GMSST_SSP585_Extended_mean,'Color', color_SSP585, 'LineWidth', width)
xlim([2100 2300])
ylim([5 15])
set(gca,'Xtick',[2100],'Xticklabel',[])
set(gca,'FontSize',15)
subplot(100,1,70:100)
box on
patch(SSP_Extended_Time_Conf_Bounds,SSP126_Extended_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
patch(SSP_Extended_Time_Conf_Bounds,SSP585_Extended_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(SSP_Extended_time,GMSST_SSP126_Extended_mean,'Color', color_SSP126, 'LineWidth', width)
plot(SSP_Extended_time,GMSST_SSP585_Extended_mean,'Color', color_SSP585, 'LineWidth', width)
txt = "SSP1-2.6_{"+num2str(SSP126_Extended_count)+"}";
text(SSP_Extended_time(end/2),GMSST_SSP126_Extended_mean(end/2)+2,txt,'FontSize',12, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
xlim([2100 2300])
ylim([-.5 5])
set(gca,'Xtick',[2100 2200 2300],'Xticklabel',{'2100', '', '2300'})
set(gca,'FontSize',15)
width=2*width;

print(gcf,'../PNGs/Extended_GMSST.png','-dpng','-r1000', '-painters');



%%

figure('Position', [10 10 200 400])
subplot(100,1,1:57)
plot([.5,.5], [0.39, 0.39], 'o-', 'MarkerSize',15, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % Paleo-data ranges taken from Bopp et al., 2018 datasets
hold on
plot([.5,.5], [2.53, -1.5], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 5.5Myr-400kyr BP
plot([2,2], [-2.20, -2.20], 'o-', 'MarkerSize',15, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([2,2], [-0.83, -3.33], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 400-22kyr BP
plot([3.5,3.5], [-3.1, -3.1], 'o-', 'MarkerSize',15, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([3.5,3.5], [-3.4, -2.9], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 22kyr BP- Present - New data from Alan (Slack Nov 2020)
% plot([3.5,3.5], [-1.77, -1.77], 'o-', 'MarkerSize',15, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % New data from Alan (Slack Nov 2020)
% plot([3.5,3.5], [-4.33, 0.21], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 22kyr BP- Present
plot([2,2], [SST_LIG_mn, SST_LIG_mn], 'o-','MarkerEdgeColor', color_CMIP,'Color', color_CMIP, 'MarkerSize',15, 'LineWidth', width/2) % PMIP
plot([2,2], [SST_LIG_mn+SST_LIG_std, SST_LIG_mn - SST_LIG_std] ...
    , '-','MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
plot([3.5,3.5], [SST_mHOL_mn, SST_mHOL_mn], 'o-','MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
plot([3.5,3.5], [SST_mHOL_mn+SST_mHOL_std, SST_mHOL_mn - SST_mHOL_std] ...
    , '-','MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
plot([.5,.5], [SST_mPLI_mn, SST_mPLI_mn], 'o-','MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
plot([.5,.5], [SST_mPLI_mn+SST_mPLI_std, SST_mPLI_mn - SST_mPLI_std] ...
    ,'MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
xlim([0 4])
ylim([-0.5 5])
set(gca,'Xtick',[0.5 2 3.5],'Xticklabel',[])
set(gca,'Ytick',[0 1 2 3 4 5],'Yticklabel',{'0', '','2','','4', ''})
set(gca,'FontSize',15,'Box', 'on')
txt = {'Observations'};
text(2,3.5,txt,'FontSize',16, ...
    'Color', color_OBS, 'FontWeight', 'bold','HorizontalAlignment','center')
txt = {'PMIP'};
text(2,2.8,txt,'FontSize',16, ...
    'Color', color_CMIP, 'FontWeight', 'bold','HorizontalAlignment','center')
subplot(100,1,60:100)
plot([.5,.5], [0.39, 0.39], 'o-', 'MarkerSize',15, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % Paleo-data ranges taken from Bopp et al., 2018 datasets
hold on
plot([.5,.5], [2.53, -1.5], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 5.5Myr-400kyr BP
plot([2,2], [-2.20, -2.20], 'o-', 'MarkerSize',15, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([2,2], [-0.83, -3.33], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 400-22kyr BP
plot([3.5,3.5], [-3.1, -3.1], 'o-', 'MarkerSize',15, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([3.5,3.5], [-3.4, -2.9], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 22kyr BP- Present - New data from Alan (Slack Nov 2020)
% plot([3.5,3.5], [-1.77, -1.77], 'o-', 'MarkerSize',15, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % New data from Alan (Slack Nov 2020)
% plot([3.5,3.5], [-4.33, 0.21], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 22kyr BP- Present
plot([2,2], [SST_LIG_mn, SST_LIG_mn], 'o-','MarkerEdgeColor', color_CMIP,'Color', color_CMIP, 'MarkerSize',15, 'LineWidth', width/2) % PMIP
plot([2,2], [SST_LIG_mn+SST_LIG_std, SST_LIG_mn - SST_LIG_std] ...
    , '-','MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
plot([3.5,3.5], [SST_mHOL_mn, SST_mHOL_mn], 'o-','MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
plot([3.5,3.5], [SST_mHOL_mn+SST_mHOL_std, SST_mHOL_mn - SST_mHOL_std] ...
    , '-','MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
plot([.5,.5], [SST_mPLI_mn, SST_mPLI_mn], 'o-','MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
plot([.5,.5], [SST_mPLI_mn+SST_mPLI_std, SST_mPLI_mn - SST_mPLI_std] ...
    ,'MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP
xlim([0 4])
ylim([-4 -0.5])
yticks([-4 -3 -2 -1 -0.5])
yticklabels({'-4','-3','-2','-1',''})
set(gca,'FontSize',15)
XTickString{1} = ['$$\begin{array}{c}' ...
    '5.5Ma \textrm{ to}' '\\'...
    '400ka ' '\\'...
    '\textrm{BP}' '\\'...
    '\end{array}$$'];
XTickString{2} = ['$$\begin{array}{c}' ...
    '400ka\textrm{ to}' '\\'...
    '22ka' '\\'...
    '\textrm{BP}' '\\'...
    '\end{array}$$'];
XTickString{3} = ['$$\begin{array}{c}' ...
    '22ka \textrm{ BP}' '\\'...
    '\textrm{to}' '\\'...
    '\textrm{Present}' '\\'...
    '\end{array}$$'];
set(gca,'xtick',[0.5 2 3.5],'XTickLabel',[]);
text(0.5,-4.6,XTickString{1},'FontSize',12, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(2,-4.6,XTickString{2},'FontSize',12, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(3.5,-4.6,XTickString{3},'FontSize',12, ...
    'HorizontalAlignment','center', 'Interpreter','latex')

print(gcf,'../PNGs/Paleo_GMSST.png','-dpng','-r1000', '-painters');







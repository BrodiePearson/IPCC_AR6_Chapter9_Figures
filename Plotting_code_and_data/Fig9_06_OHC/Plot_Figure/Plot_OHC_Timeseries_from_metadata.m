%% IPCC AR6 Chapter 9: Figure 9.6 Timeseries (Ocean Heat Content)
%
% Code used to plot pre-processed ocean heat content data. 
%
% Plotting code written by Brodie Pearson
% CMIP processed data provided by Yongqiang Yu & Lijuan Hua 
% Paleo processed data provided by Alan Mix
% Other datasets cited in report/caption

clear all

addpath ../../../Functions/
fontsize=15;
width = 3;

color_Shk = IPCC_Get_SSPColors('ssp370'); %red
color_SOSST = [196 121 0]/255; % orange
color_Uem = 'k'; % black
color_Bag = 'k'; % black
color_HadCM3 = [0 79 0]/255; % green
color_CMIP = [0 0 0]/255;
color_Lev = [196 121 0]/255; % orange

color_OBS = IPCC_Get_SSPColors('Observations');
color_HRMIP = IPCC_Get_SSPColors('HighResMIP');
color_HRSSP = IPCC_Get_SSPColors('HighResMIP');
color_CMIP = IPCC_Get_SSPColors('CMIP');
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

%% Load OHC trend fields (all experiments) and OHC mean (historical)

OHC_Data = readtable('./OHC_Timeseries.csv');

CMIP_time = OHC_Data{1:end,1}';
OHC_CMIP_mean = OHC_Data{1:end,2};
CMIP_Likely_lbound = OHC_Data{1:end,3};
CMIP_VeryLikely_lbound = OHC_Data{1:end,4};
CMIP_Likely_ubound = OHC_Data{1:end,5};
CMIP_VeryLikely_ubound = OHC_Data{1:end,6};
SSP_time = OHC_Data{1:end,7}';
OHC_SSP126_mean = OHC_Data{1:end,8};
SSP126_Likely_lbound = OHC_Data{1:end,9};
SSP126_VeryLikely_lbound = OHC_Data{1:end,10};
SSP126_Likely_ubound = OHC_Data{1:end,11};
SSP126_VeryLikely_ubound = OHC_Data{1:end,12};
SSP245_time = OHC_Data{1:end,13};
OHC_SSP245_mean = OHC_Data{1:end,14};
SSP245_Likely_lbound = OHC_Data{1:end,15};
SSP245_VeryLikely_lbound = OHC_Data{1:end,16};
SSP245_Likely_ubound = OHC_Data{1:end,17};
SSP245_VeryLikely_ubound = OHC_Data{1:end,18};
SSP370_time = OHC_Data{1:end,19};
OHC_SSP370_mean = OHC_Data{1:end,20};
SSP370_Likely_lbound = OHC_Data{1:end,21};
SSP370_VeryLikely_lbound = OHC_Data{1:end,22};
SSP370_Likely_ubound = OHC_Data{1:end,23};
SSP370_VeryLikely_ubound = OHC_Data{1:end,24};
SSP585_time = OHC_Data{1:end,25};
OHC_SSP585_mean = OHC_Data{1:end,26};
SSP585_Likely_lbound = OHC_Data{1:end,27};
SSP585_VeryLikely_lbound = OHC_Data{1:end,28};
SSP585_Likely_ubound = OHC_Data{1:end,29};
SSP585_VeryLikely_ubound = OHC_Data{1:end,30};
% Zanna_time = OHC_Data{1:end,31};
% Zanna = OHC_Data{1:end,32};
% Zanna_Likely_lbound = OHC_Data{1:end,33}';
% Zanna_Likely_ubound = OHC_Data{1:end,34}';
% Ishii2k_time = OHC_Data{1:end,35};
% Ishii2k = OHC_Data{1:end,36};
% Ishii2k_Likely_lbound = OHC_Data{1:end,37}';
% Ishii2k_Likely_ubound = OHC_Data{1:end,38}';

OHC_SSP126_mean(isnan(SSP_time')) = [];
SSP126_Likely_lbound(isnan(SSP_time')) = [];
SSP126_VeryLikely_lbound(isnan(SSP_time')) = [];
SSP126_Likely_ubound(isnan(SSP_time')) = [];
SSP126_VeryLikely_ubound(isnan(SSP_time')) = [];
OHC_SSP245_mean(isnan(SSP_time')) = [];
SSP245_Likely_lbound(isnan(SSP_time')) = [];
SSP245_VeryLikely_lbound(isnan(SSP_time')) = [];
SSP245_Likely_ubound(isnan(SSP_time')) = [];
SSP245_VeryLikely_ubound(isnan(SSP_time')) = [];
OHC_SSP370_mean(isnan(SSP_time')) = [];
SSP370_Likely_lbound(isnan(SSP_time')) = [];
SSP370_VeryLikely_lbound(isnan(SSP_time')) = [];
SSP370_Likely_ubound(isnan(SSP_time')) = [];
SSP370_VeryLikely_ubound(isnan(SSP_time')) = [];
OHC_SSP585_mean(isnan(SSP_time')) = [];
SSP585_Likely_lbound(isnan(SSP_time')) = [];
SSP585_VeryLikely_lbound(isnan(SSP_time')) = [];
SSP585_Likely_ubound(isnan(SSP_time')) = [];
SSP585_VeryLikely_ubound(isnan(SSP_time')) = [];
SSP_time(isnan(SSP_time')) = [];

SSP_Time_Conf_Bounds = [SSP_time fliplr(SSP_time)];

CMIP_Likely_Conf_Bounds = [CMIP_Likely_ubound' flipud(CMIP_Likely_lbound)'];
CMIP_VeryLikely_Conf_Bounds = [CMIP_VeryLikely_ubound' flipud(CMIP_VeryLikely_lbound)'];
CMIP_Time_Conf_Bounds = [CMIP_time fliplr(CMIP_time)];

SSP370_Likely_Conf_Bounds = [SSP370_Likely_ubound' flipud(SSP370_Likely_lbound)'];
SSP245_Likely_Conf_Bounds = [SSP245_Likely_ubound' flipud(SSP245_Likely_lbound)'];
SSP585_Likely_Conf_Bounds = [SSP585_Likely_ubound' flipud(SSP585_Likely_lbound)'];
SSP126_Likely_Conf_Bounds = [SSP126_Likely_ubound' flipud(SSP126_Likely_lbound)'];

SSP370_VeryLikely_Conf_Bounds = [SSP370_VeryLikely_ubound' flipud(SSP370_VeryLikely_lbound)'];
SSP245_VeryLikely_Conf_Bounds = [SSP245_VeryLikely_ubound' flipud(SSP245_VeryLikely_lbound)'];
SSP585_VeryLikely_Conf_Bounds = [SSP585_VeryLikely_ubound' flipud(SSP585_VeryLikely_lbound)'];
SSP126_VeryLikely_Conf_Bounds = [SSP126_VeryLikely_ubound' flipud(SSP126_VeryLikely_lbound)'];


anom_start = 2004;
anom_end = 2015;
csv_anom_start = 2004; %2004;
csv_anom_end = 2015;  %2015;

%% Load hybrid data (Zanna et al 2019)

OHC_Hybrid = ncread('./Data/OHC_GF_1870_2018_Zanna.nc','OHC_2000m')/1e3;
OHC_Hybrid_std = ncread('./Data/OHC_GF_1870_2018_Zanna.nc','error_OHC_2000')/1e3;
TIME_Hybrid = ncread('./Data/OHC_GF_1870_2018_Zanna.nc','time');
OHC_Hybrid_mean = OHC_Hybrid - nanmean(OHC_Hybrid(TIME_Hybrid<=anom_end & TIME_Hybrid>=anom_start));
Hybrid_ubound=OHC_Hybrid_mean+OHC_Hybrid_std;
Hybrid_lbound=OHC_Hybrid_mean-OHC_Hybrid_std;
Hybrid_Conf_Bounds = [Hybrid_ubound; flipud(Hybrid_lbound); Hybrid_ubound(1)];
Hybrid_Time_Conf_Bounds = [TIME_Hybrid; flipud(TIME_Hybrid); TIME_Hybrid(1)];

outstruct.Zanna_time=TIME_Hybrid(:);
outstruct.Zanna=OHC_Hybrid(:);
outstruct.Zanna_Likely_lbound=Hybrid_lbound(:);
outstruct.Zanna_Likely_ubound=Hybrid_ubound(:);
offset=mean(outstruct.Zanna(find(outstruct.Zanna_time>=csv_anom_start&outstruct.Zanna_time<=csv_anom_end)));
outstruct.Zanna=outstruct.Zanna-offset;
outstruct.Zanna_Likely_lbound=outstruct.Zanna_Likely_lbound-offset;
outstruct.Zanna_Likely_ubound=outstruct.Zanna_Likely_ubound-offset;

%% Load observation data (Ishii)

OHC_OBS_table = readtable('./Data/ishii_ohc_global_1955.txt');
OHC_OBS_mean = (1e-2)*table2array(OHC_OBS_table(:,4)); % Extract 0-2000m OHC data (Units 10^{22} J)
OHC_OBS_std = (1e-2)*table2array(OHC_OBS_table(:,5)); % Extract 0-2000m OHC 95% confidence == 2x st dev.!!
TIME_OBS = table2array(OHC_OBS_table(:,1));
OHC_OBS_mean = OHC_OBS_mean - nanmean(OHC_OBS_mean(TIME_OBS<=csv_anom_end & TIME_OBS>=csv_anom_start));
OBS_ubound=OHC_OBS_mean+OHC_OBS_std/2; % this factor of 2 added by BFK after FGD
OBS_lbound=OHC_OBS_mean-OHC_OBS_std/2; % this factor of 2 added by BFK after FGD
OBS_Conf_Bounds = [OBS_ubound; flipud(OBS_lbound); OBS_ubound(1)];
OBS_Time_Conf_Bounds = [TIME_OBS; flipud(TIME_OBS); TIME_OBS(1)];

outstruct.Ishii2k_time=TIME_OBS;
outstruct.Ishii2k=OHC_OBS_mean(:);
outstruct.Ishii2k_Likely_lbound=OBS_lbound(:);
outstruct.Ishii2k_Likely_ubound=OBS_ubound(:);

offset=mean(outstruct.Ishii2k(find(outstruct.Ishii2k_time>=anom_start&outstruct.Ishii2k_time<=anom_end)));
outstruct.Ishii2k=outstruct.Ishii2k-offset;
outstruct.Ishii2k_Likely_lbound=outstruct.Ishii2k_Likely_lbound-offset;
outstruct.Ishii2k_Likely_ubound=outstruct.Ishii2k_Likely_ubound-offset;

%% Load Hybrid 2 data (Cheng)


OHC_Hybrid2_table = readtable('./Data/Cheng_2016_Global_OHC_13_Jan_2021.txt');
OHC_Hybrid2_mean = (1e-3)*table2array(OHC_Hybrid2_table(:,2)); % Extract 0-2000m OHC data (Units 10^{22} J)
TIME_Hybrid2 = table2array(OHC_Hybrid2_table(:,1));
OHC_Hybrid2_mean = OHC_Hybrid2_mean - nanmean(OHC_Hybrid2_mean(TIME_Hybrid2<=anom_end & TIME_Hybrid2>=anom_start));


%% Make main timeseries plot

ylims = [-1 3.2];

figure('Position', [10 10 1200 300])
patch(SSP_Time_Conf_Bounds,SSP126_Likely_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
patch(SSP_Time_Conf_Bounds,SSP245_Likely_Conf_Bounds,color_SSP245, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP370_Likely_Conf_Bounds,color_SSP370, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP585_Likely_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
obs_std = patch(OBS_Time_Conf_Bounds,OBS_Conf_Bounds,color_OBS, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(Hybrid_Time_Conf_Bounds,Hybrid_Conf_Bounds,color_OBS,'EdgeColor', 'none', 'FaceAlpha', 0.2)
likely = patch(CMIP_Time_Conf_Bounds,CMIP_Likely_Conf_Bounds,color_CMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(SSP_time,OHC_SSP126_mean,'Color', color_SSP126, 'LineWidth', width)
plot(SSP_time,OHC_SSP245_mean,'Color', color_SSP245, 'LineWidth', width)
plot(SSP_time,OHC_SSP370_mean,'Color', color_SSP370, 'LineWidth', width)
plot(SSP_time,OHC_SSP585_mean,'Color', color_SSP585, 'LineWidth', width)
means = plot(CMIP_time,OHC_CMIP_mean, 'Color', color_CMIP, 'LineWidth', width);
ishii=plot(TIME_OBS,OHC_OBS_mean, 'Color', color_OBS, 'LineWidth', width/4)
zanna=plot(TIME_Hybrid,OHC_Hybrid_mean, '--', 'Color', color_OBS, 'LineWidth', width/2)
cheng=plot(TIME_Hybrid2,OHC_Hybrid2_mean, ':', 'Color', color_OBS, 'LineWidth', width)
ylim(ylims)
xlim([1850 2100])
set(gca,'Xtick',[1850 1900 1950 2000 2050 2100],'Xticklabel',{'1850', '1900','1950','2000','2050', '2100'})
set(gca,'Ytick',[-1 -0.5 0 0.5 1 1.5 2 2.5 3],'Yticklabel',{'-1', '','0','','1', '','2','','3'})
set(gca,'FontSize',20)
ylabel('10^{24} J            ')
set(get(gca,'YLabel'),'Rotation',0)

txt = "SSP5-8.5";
text(SSP_time(end/3)+3,OHC_SSP585_mean(end/2)+1,txt,'FontSize',16, ...
    'Color', color_SSP585, 'FontWeight', 'bold')
txt = "SSP1-2.6";
text(SSP_time(end/3)+3,OHC_SSP126_mean(end/2)-0.5+0.05,txt,'FontSize',16, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
txt = "SSP2-4.5";
text(SSP_time(2*end/3),OHC_SSP126_mean(end/2)-0.3,txt,'FontSize',16, ...
    'Color', color_SSP245, 'FontWeight', 'bold')
txt = "SSP3-7.0";
text(SSP_time(end/4)-5,OHC_SSP370_mean(end)-0.8+0.1,txt,'FontSize',16, ...
    'Color', color_SSP370, 'FontWeight', 'bold')
txt = "CMIP";
text(CMIP_time(end/2)+30,OHC_CMIP_mean(end/2)-0.3,txt,'FontSize',16, ...
    'Color', color_CMIP, 'FontWeight', 'bold')
txt = {'Observations',' & Hybrid'};
text(TIME_OBS(ceil(end/3)),OHC_OBS_mean(ceil(end/2))+0.5,txt,'FontSize',16, ...
    'Color', color_OBS, 'FontWeight', 'bold','HorizontalAlignment','center')
txt = 'Global OHC (0-2000m depth); Modern history and model projections to 2100';
text(1855,3.0,txt,'FontSize',18, ...
    'Color', 'k', 'FontWeight', 'bold')

set(gca,'Box', 'on','Clipping','off')

ylength = ylims(2)-ylims(1);
patch([anom_start anom_end anom_end anom_start], ...
    [ylims(1)+0.1*ylength ylims(1)+0.1*ylength ylims(1) ylims(1)],'k', ...
    'EdgeColor', 'none','FaceAlpha', 0.2)
txt = {'Baseline', 'Period'};
text(anom_end+8,ylims(1)+0.055*ylength,txt,'FontSize',12, ...
    'Color', 'k','HorizontalAlignment','center')%, 'FontWeight', 'bold')
txt = {'CMIP6','2100 means &', '(very) likely', 'ranges'};
text(2100+9,ylims(1)+0.28*ylength,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

plot([1850 2101], [1850 2100]*0, 'k', 'LineWidth', width/10)


% Plot spans of 2100 OHC

plot([2104,2104], [OHC_SSP126_mean(end), OHC_SSP126_mean(end)] ...
    , '.', 'Color',color_SSP126, 'MarkerSize', 20)
plot([2104,2104], [SSP126_Likely_ubound(end), SSP126_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width)
plot([2104,2104], [SSP126_VeryLikely_ubound(end), SSP126_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width/2)

plot([2106,2106], [OHC_SSP245_mean(end), OHC_SSP245_mean(end)] ...
    , '.', 'Color',color_SSP245, 'MarkerSize', 20)
plot([2106,2106], [SSP245_Likely_ubound(end), SSP245_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP245, 'LineWidth', width)
plot([2106,2106], [SSP245_VeryLikely_ubound(end), SSP245_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP245, 'LineWidth', width/2)

plot([2108,2108], [OHC_SSP370_mean(end), OHC_SSP370_mean(end)] ...
    , '.', 'Color',color_SSP370, 'MarkerSize', 20)
plot([2108,2108], [SSP370_Likely_ubound(end), SSP370_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP370, 'LineWidth', width)
plot([2108,2108], [SSP370_VeryLikely_ubound(end), SSP370_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP370, 'LineWidth', width/2)

plot([2110,2110], [OHC_SSP585_mean(end), OHC_SSP585_mean(end)] ...
    , '.', 'Color',color_SSP585, 'MarkerSize', 20)
plot([2110,2110], [SSP585_Likely_ubound(end), SSP585_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width)
plot([2110,2110], [SSP585_VeryLikely_ubound(end), SSP585_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width/2)

legend([means likely ishii zanna cheng obs_std],'Global Mean OHC', ...
    'CMIP6 17-83% ranges', 'Observations (Ishii)', ...
    'Hybrid (Zanna)', 'Hybrid (Cheng)','\pm 1\sigma (Obs. & Hybrid)','Box','off' ...
    ,'Position',[0.22 0.5 0.1 0.1],'FontSize',14)

%% Load data for paleo OHC panel

% Load in Alan's Excel file of data (contains future OHC/SST and several paleo records

[~,sheet_name]=xlsfinfo("./Data/9.2.2_ACM_Fig_9.9_OHC_Paleo_Data_update_2020_12_06.xlsx");

for k=1:numel(sheet_name)
  data{k}=xlsread( ...
      './Data/9.2.2_ACM_Fig_9.9_OHC_Paleo_Data_update_2020_12_06.xlsx', ...
      sheet_name{k});
end

% Extract oldest (LIG) OHC data from Shackleton 2020

tmp_data = cell2mat(data(1,2));

% Extract Shackleton time in ka CE (negative)
Time_OHC_Oldest = tmp_data(1:50,3)/1000;
% Extract Shackleton OHC in 10^4 ZJ
OHC_Oldest = tmp_data(1:50,9)/1e4;

OHC_LIG = OHC_Oldest(Time_OHC_Oldest>=-129 & Time_OHC_Oldest<=-116);

OHC_LIG_Likely_upper = quantile(OHC_LIG,0.83);
OHC_LIG_Likely_lower = quantile(OHC_LIG,0.17);

OHC_LIG_VeryLikely_upper = quantile(OHC_LIG,0.95);
OHC_LIG_VeryLikely_lower = quantile(OHC_LIG,0.05);
OHC_LIG_Mean = nanmean(OHC_LIG);

% Extract recent (LGM/mid-Holocene) OHC data from Baggenstos 2019

tmp_data = cell2mat(data(1,3));

% Extract Baggenstos time in ka CE (negative)
Time_OHC_Old = tmp_data(3:39,19)/1000;
% Extract Shackleton OHC in 10^4 ZJ
OHC_Old = tmp_data(3:39,25)/1e4;
Bag_OHC_Old_min = tmp_data(3:39,26)/1e4;
Bag_OHC_Old_max = tmp_data(3:39,27)/1e4;

OHC_LGM = OHC_Old(Time_OHC_Old>=-23.0 & Time_OHC_Old<=-19.0);
OHC_LGM_Likely_upper = quantile(OHC_LGM,0.83);
OHC_LGM_Likely_lower = quantile(OHC_LGM,0.17);
OHC_LGM_VeryLikely_upper = quantile(OHC_LGM,0.95);
OHC_LGM_VeryLikely_lower = quantile(OHC_LGM,0.05);
OHC_LGM_Mean = nanmean(OHC_LGM);

OHC_MH_Mean = OHC_Old(Time_OHC_Old>=-6.5 & Time_OHC_Old<=-5.5);
OHC_MH_upper = Bag_OHC_Old_max(Time_OHC_Old>=-6.5 & Time_OHC_Old<=-5.5);
OHC_MH_lower = Bag_OHC_Old_min(Time_OHC_Old>=-6.5 & Time_OHC_Old<=-5.5);



%% Plot paleo data

figure('Position', [10 10 200 350])
plot([.5,.5], [OHC_LIG_Mean, OHC_LIG_Mean], '.', 'MarkerSize',22, 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
hold on
plot([.5,.5], [OHC_LIG_Likely_lower, OHC_LIG_Likely_upper], '-', 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS)
plot([.5,.5], [OHC_LIG_VeryLikely_lower, OHC_LIG_VeryLikely_upper], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS)
plot([2,2], [OHC_LGM_Mean, OHC_LGM_Mean], '.', 'MarkerSize',22, 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([2,2], [OHC_LGM_Likely_lower, OHC_LGM_Likely_upper], '-', 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS)
plot([2,2], [OHC_LGM_VeryLikely_lower, OHC_LGM_VeryLikely_upper], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS)
plot([3.5,3.5], [OHC_MH_Mean, OHC_MH_Mean], '.', 'MarkerSize',22, 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([3.5,3.5], [OHC_MH_lower, OHC_MH_upper], '-', 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS)

xlim([0 4])
plot([0 5], [0 5]*0, 'k', 'LineWidth', width/10)
ylim([-2 2])
set(gca,'Xtick',[0.5 2 3.5],'Xticklabel',[])
set(gca,'Ytick',[-2 -1.5 -1 -0.5 0 0.5 1 1.5 2],'Yticklabel',{'-2','','-1','','0', '','1','','2'})
set(gca,'FontSize',15,'Box', 'on')
txt = {'Observed means and', '(very) likely ranges'};
text(2.1,1.2,txt,'FontSize',14, ...
    'Color', color_OBS, 'FontWeight', 'bold','HorizontalAlignment','center')
% ylabel('^o C')
% set(get(gca,'YLabel'),'Rotation',0)

text(0.5,-2.2,{'LIG'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(2,-2.2,{'LGM'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(3.5,-2.2,{'MH'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')

txt = 'Paleo OHC';
text(0.2,1.8,txt,'FontSize',18, ...
    'Color', 'k', 'FontWeight', 'bold')


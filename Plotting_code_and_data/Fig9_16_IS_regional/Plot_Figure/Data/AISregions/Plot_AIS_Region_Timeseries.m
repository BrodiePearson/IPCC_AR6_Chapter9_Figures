clear all
close all

addpath ../../Matlab_Functions/

fontsize=20;
width = 5;
start_year=1840;
end_year=2100;

%% Get IMBIE Data
dataAP=xlsread('imbie_dataset-2018_07_23.xlsx',2);
dataEAIS=xlsread('imbie_dataset-2018_07_23.xlsx',3);
dataWAIS=xlsread('imbie_dataset-2018_07_23.xlsx',4);

% Extract IMBIE Cumulative mass change (in Gt)
IMBIE_time = dataAP(:,1);

% Extract IMBIE cumul. ice mass
IMBIE_AP = dataAP(:,2);
IMBIE_AP_std = dataAP(:,3);
IMBIE_EAIS = dataEAIS(:,2);
IMBIE_EAIS_std = dataEAIS(:,3);
IMBIE_WAIS = dataWAIS(:,2);
IMBIE_WAIS_std = dataWAIS(:,3);

% Extract IMBIE Cumulative sea level equivalent (in mm)
IMBIE_AP_sl = dataAP(:,4);
IMBIE_AP_sl_std = dataAP(:,5);
IMBIE_EAIS_sl = dataEAIS(:,4);
IMBIE_EAIS_sl_std = dataEAIS(:,5);
IMBIE_WAIS_sl = dataWAIS(:,4);
IMBIE_WAIS_sl_std = dataWAIS(:,5);

% Read Bamber Data
dataB = textread('Bamber-etal_2018_readme.dat',[])


%% To-Do Read ISMIP6 / PROMICE data for SSP585 and SSP126


for jj = 1:length(j_rcp585)
   temp_cell (:,jj) = ISMIP6_data(j_rcp585(jj),i_start:i_end)';
end
ISMIP_ssp585_GrIS = cellfun(@str2num,temp_cell);
clear temp_cell
for jj = 1:length(j_rcp126)
   temp_cell (:,jj) = ISMIP6_data(j_rcp126(jj),i_start:i_end)';
end
ISMIP_ssp126_GrIS = cellfun(@str2num,temp_cell);

% Convert from SLE (mm) to Mass Change (Gt)
ISMIP_ssp585_GrIS = ISMIP_ssp585_GrIS*(-362.5);
ISMIP_ssp126_GrIS = ISMIP_ssp126_GrIS*(-362.5);

ISMIP_GrIS_SSP585 = nanmean(ISMIP_ssp585_GrIS,2);
ISMIP_GrIS_SSP126 = nanmean(ISMIP_ssp126_GrIS,2);
ISMIP_GrIS_SSP585_5 = quantile(ISMIP_ssp585_GrIS,0.05,2);
ISMIP_GrIS_SSP585_95 = quantile(ISMIP_ssp585_GrIS,0.95,2);
ISMIP_GrIS_SSP126_5 = quantile(ISMIP_ssp126_GrIS,0.05,2);
ISMIP_GrIS_SSP126_95 = quantile(ISMIP_ssp126_GrIS,0.95,2);

%% To-do: ADD Reader for Mouginot pnas data

[~,sheet_name]=xlsfinfo('Mouginot_pnas.1904242116.sd02.xlsx');

clear data

for k=1:numel(sheet_name)
  data{k}=xlsread('Mouginot_pnas.1904242116.sd02.xlsx',sheet_name{k});
end

Moug_data = cell2mat(data(1,2));
Moug_time = Moug_data(35,14:60)';
Moug_GrIS = Moug_data(43,14:60)';

%% Read Box data

temp = readtable('../Data_Greenland/Box_Greenland_mass_balance_totals_1840-2012_ver_20141130_with_uncert.csv');
Box_data=table2array(temp);
Box_time = [1840:1:2012]';
% Extract Total mass balance of GrIS
Box_data_GrIS = Box_data(1:end-1,12);
Box_data_GrIS = cellfun(@str2num,Box_data_GrIS);
Box_data_GrIS_std = Box_data(1:end-1,13);

%% Read Bamber data

T = readtable('Bamber-etal_2018_readme.dat');
Bamber_data=table2array(T);
Bamber_time = Bamber_data(:,1);
Bamber_data_GrIS = Bamber_data(:,2);
Bamber_data_GrIS_std = Bamber_data(:,3);
% Bamber_data_w_std = Bamber_data(:,5);
% Bamber_data_e = Bamber_data(:,6);
% Bamber_data_e_std = Bamber_data(:,7);

%% Make Plots

color_OBS = [196 121 0]/255;
color_HR = [0 79 0]/255;
color_CMIP = [0 0 0]/255;
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

running_mean = 1; % Running mean length in months

%% Construct IMBIE Data structure

GrIS_Imbie = IMBIE_data;
GrIS_Imbie_unc = IMBIE_data_std;
TIME_OBS = IMBIE_time;
GrIS_Imbie_sl = IMBIE_data_sl;
GrIS_Imbie_unc_sl = IMBIE_data_sl_std;
OBS_ubound=GrIS_Imbie+GrIS_Imbie_unc;
OBS_lbound=GrIS_Imbie-GrIS_Imbie_unc;
OBS_Conf_Bounds = [OBS_ubound; flipud(OBS_lbound); OBS_ubound(1)];
OBS_Time_Conf_Bounds = [TIME_OBS; flipud(TIME_OBS); TIME_OBS(1)];
ISMIP_585_Conf_Bounds = [ISMIP_GrIS_SSP585_95; flipud(ISMIP_GrIS_SSP585_5); ISMIP_GrIS_SSP585_95(1)];
ISMIP_126_Conf_Bounds = [ISMIP_GrIS_SSP126_95; flipud(ISMIP_GrIS_SSP126_5); ISMIP_GrIS_SSP126_95(1)];
ISMIP_Time_Conf_Bounds = [TIME_ISMIP; flipud(TIME_ISMIP); TIME_ISMIP(1)];

%% Diagnose cumulative Box Data and construct data structure
% Must sum (as currently in annual mass balance ith units of Gt per annum)
for ii=1:length(Box_data_GrIS)
    GrIS_Box(ii) = sum(Box_data_GrIS(1:ii));  
end

% Anomalize Box relative to year 2015
GrIS_Box = GrIS_Box - GrIS_Box(173); % Currently 2012 - CHANGE TO 2015

TIME_Box = Box_time;

%% Construct Moug Data structure

GrIS_Moug = Moug_GrIS;
TIME_Moug = Moug_time;

% Anomalize Box relative to year 2015
GrIS_Moug = GrIS_Moug - GrIS_Moug(44);

%% Anomalize IMBIE & Bamber
GrIS_Imbie = GrIS_Imbie - GrIS_Imbie(36);

%% Diagnose cumulative Bamber Data and construct data structure
% Must sum (as currently in annual mass balance ith units of Gt per annum)
for ii=1:length(Bamber_data_GrIS)
    GrIS_Bamber(ii) = sum(Bamber_data_GrIS(1:ii));  
end

TIME_Bamber = Bamber_time;
GrIS_Bamber = GrIS_Bamber - GrIS_Bamber(24);

%% Make plots

figure('Position', [10 10 1200 400])
yyaxis left
patch(OBS_Time_Conf_Bounds,OBS_Conf_Bounds,color_OBS, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
% patch(ISMIP_Time_Conf_Bounds,ISMIP_585_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
% patch(ISMIP_Time_Conf_Bounds,ISMIP_126_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(TIME_OBS,GrIS_Imbie, 'Color', color_OBS, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(TIME_Box,GrIS_Box, 'Color', color_SSP370, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(TIME_Bamber,GrIS_Bamber, 'Color', color_SSP585, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(TIME_Moug,GrIS_Moug, 'Color', color_SSP126, 'LineWidth', width/2,'LineStyle','-','Marker','none')
%plot(TIME_ISMIP,ISMIP_GrIS_SSP585, 'Color', color_SSP585, 'LineWidth', width/2,'LineStyle','-','Marker','none')
%plot(TIME_ISMIP,ISMIP_GrIS_SSP126, 'Color', color_SSP126, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(TIME_ISMIP,ISMIP_ssp585_GrIS, 'Color', color_SSP585, 'LineWidth', width/10,'LineStyle','-','Marker','none')
plot(TIME_ISMIP,ISMIP_ssp126_GrIS, 'Color', color_SSP126, 'LineWidth', width/10,'LineStyle','-','Marker','none')
xlim([1840 2100])
y_limits=[-5000 13000];
ylim(y_limits)
ylabel('Mass Change (Gt)','FontSize',20)
set(gca,'FontSize',20)
yyaxis right
ylim(-fliplr(y_limits)/360)
set ( gca, 'ydir', 'reverse' )
ylabel('Equivalent Sea Level Contribution (mm)','FontSize',20)
%plot(TIME_OBS,GrIS_Imbie_sl, 'Color', 'k', 'LineWidth', width/2,'LineStyle',':','Marker','none')
yyaxis left



txt = 'Mouginot';
text(TIME_Moug(1)+2,double(GrIS_Moug(floor(1)))+900,txt,'FontSize',20, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
txt = 'Box';
text(TIME_Box(floor(end/4))+5,double(GrIS_Box(floor(end/2)))-500,txt,'FontSize',20, ...
    'Color', color_SSP370, 'FontWeight', 'bold')
txt = 'Bamber';
text(TIME_OBS(floor(end/4))+20,double(GrIS_Bamber(floor(end/2)))-100,txt,'FontSize',20, ...
    'Color', color_SSP585, 'FontWeight', 'bold')
txt = 'IMBIE';
text(TIME_OBS(floor(end/4))+30,double(GrIS_Imbie(floor(end/2))-2500), ...
    txt,'FontSize',20, ...
    'Color', color_OBS, 'FontWeight', 'bold')
txt = 'RCP 2.6';
text(2070,800, ...
    txt,'FontSize',20, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
txt = 'RCP 8.5';
text(2060,-3200, ...
    txt,'FontSize',20, ...
    'Color', color_SSP585, 'FontWeight', 'bold')
txt = 'Greenland Ice Sheet Cumulative Mass Change';
text(1845,12200,txt,'FontSize',25, ...
    'Color', 'k', 'FontWeight', 'bold')
set(gca,'Box', 'off')
set(gca,'TickDir','out');
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

plot([start_year 2100],0*[start_year 2100], 'k:', 'LineWidth', 2)





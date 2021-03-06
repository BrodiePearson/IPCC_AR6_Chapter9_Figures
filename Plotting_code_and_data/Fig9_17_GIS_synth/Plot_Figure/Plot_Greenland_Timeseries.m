%% IPCC AR6 Chapter 9: Figure 9.17 (Greenland Synthesis)
%
% Code used to plot pre-processed Greenland timeseries. 
%
% Plotting code written by Brodie Pearson & Baylor Fox-Kemper
% Processed data provided by Tamsin Edwards
% Other datasets cited in report/caption

clear all

addpath ../../../Functions/

SL2M=362.5*1000/1e4; % Convert SL rise (m) to Mass Loss (10^4 Gt)

fontsize=20;
width = 5;
start_year=1972;
end_year=2100;

%% Load emulator data (Tamsin)

temp = readtable('./Processed_Data/summary_FAIR/summary_FAIR_SSP585.csv');
temp = temp(2:end,1:11);
Emu_data = table2cell(temp);
j_rcp585 = find(~cellfun('isempty',strfind(Emu_data(:,1),'GrIS')) ...
    & ~cellfun('isempty',strfind(Emu_data(:,2),'ALL')));

for jj = 1:length(j_rcp585)
    % Pull out MEAN of data set (median is 4th column)
   temp_cell(:,jj) = Emu_data(j_rcp585(jj),4)';
   % Pull out 0.95 likelihood (v. likely) bound
   upper_cell(:,jj) = Emu_data(j_rcp585(jj),6)';
   % Pull out 0.05 likelihood (v. likely) bound
   lower_cell(:,jj) = Emu_data(j_rcp585(jj),5)';
   % Pull out 0.83 likelihood (likely) bound
   upper_l_cell(:,jj) = Emu_data(j_rcp585(jj),8)';
   % Pull out 0.17 likelihood (likely) bound
   lower_l_cell(:,jj) = Emu_data(j_rcp585(jj),7)';
   TIME_Emu(jj) = Emu_data(j_rcp585(jj),3)';
end

TIME_Emu = cell2mat(TIME_Emu);

Emu_ssp585_GrIS = cell2mat(temp_cell);
Emu_ssp585_GrIS_95 = cell2mat(upper_cell);
Emu_ssp585_GrIS_5 = cell2mat(lower_cell);
Emu_ssp585_GrIS_83 = cell2mat(upper_l_cell);
Emu_ssp585_GrIS_17 = cell2mat(lower_l_cell);

% Convert from SLE (cm) to Mass Change (Gt)
Emu_ssp585_GrIS = 10*Emu_ssp585_GrIS*(-362.5);
Emu_ssp585_GrIS_5 = 10*Emu_ssp585_GrIS_5*(-362.5);
Emu_ssp585_GrIS_95 = 10*Emu_ssp585_GrIS_95*(-362.5);
Emu_ssp585_GrIS_17 = 10*Emu_ssp585_GrIS_17*(-362.5);
Emu_ssp585_GrIS_83 = 10*Emu_ssp585_GrIS_83*(-362.5);

temp = readtable('./Processed_Data/summary_FAIR/summary_FAIR_SSP126.csv');
temp = temp(2:end,1:11);
Emu_data = table2cell(temp);
j_rcp126 = find(~cellfun('isempty',strfind(Emu_data(:,1),'GrIS')) ...
    & ~cellfun('isempty',strfind(Emu_data(:,2),'ALL')));

for jj = 1:length(j_rcp126)
    % Pull out MEAN of data set (median is 4th column)
   temp_cell1(:,jj) = Emu_data(j_rcp126(jj),4)';
   % Pull out 0.95 likelihood (v. likely) bound
   upper_cell1(:,jj) = Emu_data(j_rcp126(jj),6)';
   % Pull out 0.05 likelihood (v. likely) bound
   lower_cell1(:,jj) = Emu_data(j_rcp126(jj),5)';
   % Pull out 0.83 likelihood (likely) bound
   upper_l_cell1(:,jj) = Emu_data(j_rcp126(jj),8)';
   % Pull out 0.17 likelihood (likely) bound
   lower_l_cell1(:,jj) = Emu_data(j_rcp126(jj),7)';
end

Emu_ssp126_GrIS = cell2mat(temp_cell1);
Emu_ssp126_GrIS_95 = cell2mat(upper_cell1);
Emu_ssp126_GrIS_5 = cell2mat(lower_cell1);
Emu_ssp126_GrIS_83 = cell2mat(upper_l_cell1);
Emu_ssp126_GrIS_17 = cell2mat(lower_l_cell1);

% Convert from SLE (cm) to Mass Change (Gt)
Emu_ssp126_GrIS = movmean(10*Emu_ssp126_GrIS*(-362.5),5);
Emu_ssp126_GrIS_5 = movmean(10*Emu_ssp126_GrIS_5*(-362.5),5);
Emu_ssp126_GrIS_95 = movmean(10*Emu_ssp126_GrIS_95*(-362.5),5);
Emu_ssp126_GrIS_17 = movmean(10*Emu_ssp126_GrIS_17*(-362.5),5);
Emu_ssp126_GrIS_83 = movmean(10*Emu_ssp126_GrIS_83*(-362.5),5);

%% Read ISMIP6 data for SSP585 and SSP126

temp = readtable('./Processed_Data/20201106_SLE_SIMULATIONS_SI.csv');
ISMIP6_data = table2cell(temp);
i_start = find(contains(temp.Properties.VariableNames,'y2015'));
i_end = find(contains(temp.Properties.VariableNames,'y2100'));
TIME_ISMIP = [2015:1:2100]';
j_ssp585 = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'GrIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'ALL')) ...
    & cellfun('isempty',strfind(ISMIP6_data(:,i_end+1),'New')) ...
    & (~cellfun('isempty',strfind(ISMIP6_data(:,8),'SSP585')) | ...
    ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP85')) ));
j_ssp126 = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'GrIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'ALL')) ...
    & cellfun('isempty',strfind(ISMIP6_data(:,i_end+1),'New')) ...
    & (~cellfun('isempty',strfind(ISMIP6_data(:,8),'SSP126')) | ...
    ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP26')) ));
clear temp_cell
for jj = 1:length(j_ssp585)
   temp_cell (:,jj) = ISMIP6_data(j_ssp585(jj),i_start:i_end)';
end
ISMIP_ssp585_GrIS = cell2mat(temp_cell);
clear temp_cell
for jj = 1:length(j_ssp126)
   temp_cell (:,jj) = ISMIP6_data(j_ssp126(jj),i_start:i_end)';
end
ISMIP_ssp126_GrIS = cell2mat(temp_cell);
clear temp_cell

% Convert from SLE (cm) to Mass Change (Gt) Add ISMIP GIS trend
ISMIP_ssp585_GrIS_full = 10*ISMIP_ssp585_GrIS*(-362.5) + (TIME_ISMIP-TIME_ISMIP(1))*0.019*10*(-362.5);
ISMIP_ssp126_GrIS_full = 10*ISMIP_ssp126_GrIS*(-362.5) + (TIME_ISMIP-TIME_ISMIP(1))*0.019*10*(-362.5);


ISMIP_ssp585_GrIS_5= movmean(quantile(ISMIP_ssp585_GrIS_full,0.05,2),5);
ISMIP_ssp585_GrIS_17= movmean(quantile(ISMIP_ssp585_GrIS_full,0.17,2),5);
ISMIP_ssp585_GrIS_50 = movmean(quantile(ISMIP_ssp585_GrIS_full,0.50,2),5);
ISMIP_ssp585_GrIS_83 = movmean(quantile(ISMIP_ssp585_GrIS_full,0.83,2),5);
ISMIP_ssp585_GrIS_95 = movmean(quantile(ISMIP_ssp585_GrIS_full,0.95,2),5);
ISMIP_ssp126_GrIS_5 = movmean(quantile(ISMIP_ssp126_GrIS_full,0.05,2),5);
ISMIP_ssp126_GrIS_17= movmean(quantile(ISMIP_ssp126_GrIS_full,0.17,2),5);
ISMIP_ssp126_GrIS_50 = movmean(quantile(ISMIP_ssp126_GrIS_full,0.50,2),5);
ISMIP_ssp126_GrIS_83 = movmean(quantile(ISMIP_ssp126_GrIS_full,0.83,2),5);
ISMIP_ssp126_GrIS_95 = movmean(quantile(ISMIP_ssp126_GrIS_full,0.95,2),5);

%This must be last to avoid affecting quantile diagnoses
ISMIP_ssp585_GrIS = movmean(nanmean(ISMIP_ssp585_GrIS_full,2),5);
ISMIP_ssp126_GrIS = movmean(nanmean(ISMIP_ssp126_GrIS_full,2),5);

%% To-do: ADD Reader for Mouginot pnas data

[~,sheet_name]=xlsfinfo('./Processed_Data/Mouginot_pnas.1904242116.sd02.xlsx');

clear data

for k=1:numel(sheet_name)
  data{k}=xlsread('./Processed_Data/Mouginot_pnas.1904242116.sd02.xlsx',sheet_name{k});
end

Moug_data = cell2mat(data(1,2));
Moug_time = Moug_data(35,14:60)';
Moug_GrIS = Moug_data(43,14:60)';

%% Read Box data

temp = readtable('./Processed_Data/Box_Greenland_mass_balance_totals_1840-2012_ver_20141130_with_uncert.csv');
Box_data=table2array(temp);
Box_time = [1840:1:2012]';
% Extract Total mass balance of GrIS
Box_data_GrIS = Box_data(1:end-1,12);
Box_data_GrIS_std = Box_data(1:end-1,13);

%% Diagnose cumulative Box Data and construct data structure
% Must sum (as currently in annual mass balance ith units of Gt per annum)
for ii=1:length(Box_data_GrIS)
    GrIS_Box(ii) = sum(Box_data_GrIS(1:ii));  
end

% Anomalize Box relative to year 2015
GrIS_Box = GrIS_Box(:) - GrIS_Box(find(Box_time==2012))+Moug_GrIS(find(Moug_time==2012))-Moug_GrIS(find(Moug_time==2015)); 
% Currently 2012 - CHANGE TO 2015--now crudely use difference from Mouginot


TIME_Box = Box_time(:);

Box_ubound=GrIS_Box(:)+Box_data_GrIS_std;
Box_lbound=GrIS_Box(:)-Box_data_GrIS_std;

%% Read data

T = readtable('./Processed_Data/Bamber-etal_2018_readme.dat');
Bamber_data=table2array(T);
Bamber_time = Bamber_data(:,1);
Bamber_data_GrIS = Bamber_data(:,2);
Bamber_data_GrIS_std = Bamber_data(:,3);

%% Diagnose cumulative Bamber Data and construct data structure
% Must sum (as currently in annual mass balance ith units of Gt per annum)
for ii=1:length(Bamber_data_GrIS)
    GrIS_Bamber(ii) = sum(Bamber_data_GrIS(1:ii));  
end

%% Anomalize Bamber
TIME_Bamber = Bamber_time(:);
GrIS_Bamber = GrIS_Bamber(:) - GrIS_Bamber(24);

Bamber_ubound=GrIS_Bamber(:)+Bamber_data_GrIS_std(:);
Bamber_lbound=GrIS_Bamber(:)-Bamber_data_GrIS_std(:);
Bamber_Conf_Bounds = [Bamber_ubound; flipud(Bamber_lbound); Bamber_ubound(1)];
Bamber_Time_Conf_Bounds = [TIME_Bamber; flipud(TIME_Bamber); TIME_Bamber(1)];



%% Make Plots

color_OBS = [196 121 0]/255;
color_HR = [0 79 0]/255;
color_CMIP = [0 0 0]/255;
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');


%% Get IMBIE Data

IMBIE_data0=xlsread('./Processed_Data/IMBIE_AR6.xlsx');

% Extract IMBIE Cumulative mass change (in Gt)
IMBIE_time = IMBIE_data0(:,1);

IMBIE_data = IMBIE_data0(:,7);  %No longer revert to IMBIE-2, latest is IMBIE_data0(:,7);
IMBIE_data_std = IMBIE_data0(:,8);  %No longer revert to IMBIE-2, latest is IMBIE_data0(:,8);
% Convert IMBIE Cumulative sea level equivalent (in mm)
IMBIE_data_sl = IMBIE_data*(-362.5);
IMBIE_data_sl_std = IMBIE_data_std*(-362.5);

IMBIE_data = IMBIE_data-IMBIE_data(277); % Baseline 2015



%% Construct IMBIE Data structure

GrIS_Imbie = IMBIE_data;
GrIS_Imbie_unc = IMBIE_data_std;
TIME_OBS = IMBIE_time;
OBS_ubound=GrIS_Imbie+GrIS_Imbie_unc;
OBS_lbound=GrIS_Imbie-GrIS_Imbie_unc;
OBS_Conf_Bounds = [OBS_ubound; flipud(OBS_lbound); OBS_ubound(1)];
OBS_Time_Conf_Bounds = [TIME_OBS; flipud(TIME_OBS); TIME_OBS(1)];



ISMIP_585_Conf_Bounds = [ISMIP_ssp585_GrIS_83; ...
    flipud(ISMIP_ssp585_GrIS_17); ...
    ISMIP_ssp585_GrIS_83(1)];
ISMIP_126_Conf_Bounds = [ISMIP_ssp126_GrIS_83; ...
    flipud(ISMIP_ssp126_GrIS_17); ...
    ISMIP_ssp126_GrIS_83(1)];
ISMIP_585_verylikely_Conf_Bounds = [ISMIP_ssp585_GrIS_95; ...
    flipud(ISMIP_ssp585_GrIS_5); ...
    ISMIP_ssp585_GrIS_95(1)];
ISMIP_126_verylikely_Conf_Bounds = [ISMIP_ssp126_GrIS_95; ...
    flipud(ISMIP_ssp126_GrIS_5); ...
    ISMIP_ssp126_GrIS_95(1)];
ISMIP_Time_Conf_Bounds = [TIME_ISMIP; flipud(TIME_ISMIP); TIME_ISMIP(1)];
Emu_Time_LikelyRange = [TIME_Emu'; flipud(TIME_Emu'); TIME_Emu(1)'];
Emu_585_LikelyRange = [Emu_ssp585_GrIS_83'; ...
    flipud(Emu_ssp585_GrIS_17'); ...
    Emu_ssp585_GrIS_83(:,1)];
Emu_126_LikelyRange = [Emu_ssp126_GrIS_83'; ...
    flipud(Emu_ssp126_GrIS_17'); ...
    Emu_ssp126_GrIS_83(:,1)];
Emu_585_VeryLikelyRange = [Emu_ssp585_GrIS_95'; ...
    flipud(Emu_ssp585_GrIS_5'); ...
    Emu_ssp585_GrIS_95(:,1)];
Emu_126_VeryLikelyRange = [Emu_ssp126_GrIS_95'; ...
    flipud(Emu_ssp126_GrIS_5'); ...
    Emu_ssp126_GrIS_95(:,1)];

%% Construct Moug Data structure

GrIS_Moug = Moug_GrIS;
TIME_Moug = Moug_time;

% Anomalize Box relative to year 2015
GrIS_Moug = GrIS_Moug - GrIS_Moug(44);


%% New emulator data (corrected; Greg Garner Mar 2021)

EMU_New_585= double(ncread('./Processed_Data/GIS_emulated_projections/icesheets-ipccar6-ismipemuicesheet-ssp585_GIS_globalsl_figuredata.nc','globalSL_quantiles'));
EMU_New_370= double(ncread('./Processed_Data/GIS_emulated_projections/icesheets-ipccar6-ismipemuicesheet-ssp370_GIS_globalsl_figuredata.nc','globalSL_quantiles'));
EMU_New_245= double(ncread('./Processed_Data/GIS_emulated_projections/icesheets-ipccar6-ismipemuicesheet-ssp245_GIS_globalsl_figuredata.nc','globalSL_quantiles'));
EMU_New_126= double(ncread('./Processed_Data/GIS_emulated_projections/icesheets-ipccar6-ismipemuicesheet-ssp126_GIS_globalsl_figuredata.nc','globalSL_quantiles'));
Emu_New_Time = ncread('./Processed_Data/GIS_emulated_projections/icesheets-ipccar6-ismipemuicesheet-ssp126_GIS_globalsl_figuredata.nc','years');
Emu_New_Time = [2015; Emu_New_Time];
Emu_New_Time_LikelyRange = [Emu_New_Time; flipud(Emu_New_Time); Emu_New_Time(1)];
Emu_New_585 = [0; EMU_New_585(:,3)];  % 0 added for baseline and 2015 start date
Emu_New_126 = [0; EMU_New_126(:,3)];  % 0 added for baseline and 2015 start date
Emu_New_585_LikelyRange = [0; EMU_New_585(:,4); ...
    flipud(EMU_New_585(:,2)); ...
    0; 0]; %EMU_New_585(1,4); 0];
Emu_New_585_VeryLikelyRange = [0; EMU_New_585(:,5); ...
    flipud(EMU_New_585(:,1)); ...
    0; 0]; %EMU_New_585(1,5); 0];
Emu_New_126_LikelyRange = [0; EMU_New_126(:,4); ...
    flipud(EMU_New_126(:,2)); ...
    0; 0]; %EMU_New_585(1,5); 0];
Emu_New_126_VeryLikelyRange = [0; EMU_New_126(:,5); ...
    flipud(EMU_New_126(:,1)); ...
    0; 0]; %EMU_New_585(1,5); 0];


%% Make plots

figure('Position', [10 10 1600 400])
subplot(1,100,1:75)
yyaxis left
plot(TIME_OBS,GrIS_Imbie/1e4, 'Color', color_OBS, 'LineWidth', width/4,'LineStyle','-','Marker','none')
hold on
plot(TIME_Bamber,GrIS_Bamber/1e4, 'Color', color_SSP370, 'LineWidth', width/4,'LineStyle','-','Marker','none')
patch(Bamber_Time_Conf_Bounds,Bamber_Conf_Bounds/1e4,color_SSP370, 'EdgeColor', 'none', 'FaceAlpha', 0.4)


ndstart=find(TIME_Box==start_year);
ndend=find(TIME_Box==end_year);
Box_Conf_Bounds = [Box_ubound(ndstart:ndend); flipud(Box_lbound(ndstart:ndend)); Box_ubound(ndstart)];
Box_Time_Conf_Bounds = [TIME_Box(ndstart:ndend); flipud(TIME_Box(ndstart:ndend)); TIME_Box(ndstart)];

plot(TIME_Box(ndstart:ndend),GrIS_Box(ndstart:ndend)/1e4, 'Color', color_SSP126, 'LineWidth', width/4,'LineStyle','-','Marker','none')
patch(Box_Time_Conf_Bounds,Box_Conf_Bounds/1e4,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.4)

patch([TIME_Box(ndstart) TIME_Box(ndstart+2) TIME_Box(ndstart+2) TIME_Box(ndstart) TIME_Box(ndstart)],...
    [max(GrIS_Box) max(GrIS_Box) min(GrIS_Box) min(GrIS_Box) max(GrIS_Box)]/1e4,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.4)

 txt = 'Box';
 text(1975,.5+GrIS_Box(ndstart)/1e4,txt,'FontSize',20, ...
     'Color', color_SSP126, 'FontWeight', 'bold')

 txt = ['Box Range'];
 text(start_year,1+max(GrIS_Box)/1e4,txt,'FontSize',10,'Color', color_SSP126)
 txt = ['1840-',num2str(start_year)];
 text(start_year,.5+max(GrIS_Box)/1e4,txt,'FontSize',10,'Color', color_SSP126)
 
plot(TIME_Moug,GrIS_Moug/1e4, 'Color', color_HR, 'LineWidth', width/4,'LineStyle','-','Marker','none')
patch(OBS_Time_Conf_Bounds,OBS_Conf_Bounds/1e4,color_OBS, 'EdgeColor', 'none', 'FaceAlpha', 0.4)

plot(TIME_ISMIP,ISMIP_ssp585_GrIS_full/1e4, 'Color', [color_SSP585 0.2], 'LineWidth', width/20,'LineStyle','-','Marker','none')
h4=plot(TIME_ISMIP,ISMIP_ssp585_GrIS_full(:,1)/1e4, 'Color', [color_SSP585 0.2], 'LineWidth', width/20,'LineStyle','-','Marker','none')
plot(TIME_ISMIP,ISMIP_ssp126_GrIS_full/1e4, 'Color', [color_SSP126 0.2], 'LineWidth', width/20,'LineStyle','-','Marker','none')

h1=patch(Emu_New_Time_LikelyRange,Emu_New_585_LikelyRange*(-362.5)/1e4,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.4)
patch(Emu_New_Time_LikelyRange,Emu_New_126_LikelyRange*(-362.5)/1e4,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.4)
h2=patch(Emu_New_Time_LikelyRange,Emu_New_585_VeryLikelyRange*(-362.5)/1e4,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(Emu_New_Time_LikelyRange,Emu_New_126_VeryLikelyRange*(-362.5)/1e4,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
h3=plot(Emu_New_Time,Emu_New_585*(-362.5)/1e4, 'Color', color_SSP585, 'LineWidth', width/1.5,'LineStyle','-','Marker','none')
plot(Emu_New_Time,Emu_New_126*(-362.5)/1e4, 'Color', color_SSP126, 'LineWidth', width/1.5,'LineStyle','-','Marker','none')



xlim([start_year end_year])
ylims=[-10 4];
ylim(ylims)
ylength = ylims(2)-ylims(1);
%ylabel('Mass Change (10^4 Gt)','FontSize',20)
ylabel('10^4 Gt    ')
set(get(gca,'YLabel'),'Rotation',0)
set(gca,'FontSize',20)
set(gca,'Ytick',[-10 -8 -6 -4 -2 0 2 4], ...
    'Yticklabel',{'', '-8','','-4','', '0','','4'})
yyaxis right
ylim(-10*fliplr(ylims)/362.5)
set ( gca, 'ydir', 'reverse' )
%ylabel('Equivalent Sea Level Contribution (m)','FontSize',20)
set(gca,'Ytick',[-0.1 -0.05 0 0.05 0.1 0.15 0.2 0.25], ...
    'Yticklabel',{'-0.1', '','0','','0.1', '','0.2',''})
labels=get(gca, 'YTick');
%set(gca, 'YTickLabel', get(gca, 'YTick')-[0 labels(2) 0 0]);
%plot(TIME_OBS,GrIS_Imbie_sl, 'Color', 'k', 'LineWidth', width/2,'LineStyle',':','Marker','none')
yyaxis left



txt = 'Mouginot';
text(1985,0.8*2,txt,'FontSize',20, ...
    'Color', color_HR, 'FontWeight', 'bold')
txt = 'Bamber';
text(1985,-0.4*2,txt,'FontSize',20, ...
    'Color', color_SSP370, 'FontWeight', 'bold')
txt = 'IMBIE';
text(2010,0.5*2, ...
    txt,'FontSize',20, ...
    'Color', color_OBS, 'FontWeight', 'bold')
txt = 'SSP1-2.6';
text(2075,1.0, ...
    txt,'FontSize',20, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
txt = 'SSP5-8.5';
text(2075,-3*2, ...
    txt,'FontSize',20, ...
    'Color', color_SSP585, 'FontWeight', 'bold')
txt = 'Modern & Projected Changes';
text(1974,1.7*2,txt,'FontSize',20, ...
    'Color', 'k', 'FontWeight', 'bold')
txt = 'm';
text(2101,-2,txt,'FontSize',20, ...
    'Color', 'k')
set(gca,'Box', 'on','Clipping','off')
set(gca,'TickDir','in');

% Plot Emulator 2100 ranges
offset = 2;

plot(offset+[2109,2109], [EMU_New_126(end,3)*(-362.5)/1e4, EMU_New_126(end,3)*(-362.5)/1e4] ...
    , '.', 'Color',color_SSP126, 'MarkerSize', 20)
plot(offset+[2109,2109], [EMU_New_126(end,4)*(-362.5)/1e4, EMU_New_126(end,2)*(-362.5)/1e4] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width)
plot(offset+[2109,2109], [EMU_New_126(end,5)*(-362.5)/1e4, EMU_New_126(end,1)*(-362.5)/1e4] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width/2)

plot(offset+[2110,2110], [EMU_New_245(end,3)*(-362.5)/1e4, EMU_New_245(end,3)*(-362.5)/1e4] ...
    , '.', 'Color',color_SSP245, 'MarkerSize', 20)
plot(offset+[2110,2110], [EMU_New_245(end,4)*(-362.5)/1e4, EMU_New_245(end,2)*(-362.5)/1e4] ...
    , '-', 'Color',color_SSP245, 'LineWidth', width)
plot(offset+[2110,2110], [EMU_New_245(end,5)*(-362.5)/1e4, EMU_New_245(end,1)*(-362.5)/1e4] ...
    , '-', 'Color',color_SSP245, 'LineWidth', width/2)

plot(offset+[2111,2111], [EMU_New_370(end,3)*(-362.5)/1e4, EMU_New_370(end,3)*(-362.5)/1e4] ...
    , '.', 'Color',color_SSP370, 'MarkerSize', 20)
plot(offset+[2111,2111], [EMU_New_370(end,4)*(-362.5)/1e4, EMU_New_370(end,2)*(-362.5)/1e4] ...
    , '-', 'Color',color_SSP370, 'LineWidth', width)
plot(offset+[2111,2111], [EMU_New_370(end,5)*(-362.5)/1e4, EMU_New_370(end,1)*(-362.5)/1e4] ...
    , '-', 'Color',color_SSP370, 'LineWidth', width/2)

plot(offset+[2112,2112], [EMU_New_585(end,3)*(-362.5)/1e4, EMU_New_585(end,3)*(-362.5)/1e4] ...
    , '.', 'Color',color_SSP585, 'MarkerSize', 20)
plot(offset+[2112,2112], [EMU_New_585(end,4)*(-362.5)/1e4, EMU_New_585(end,2)*(-362.5)/1e4] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width)
plot(offset+[2112,2112], [EMU_New_585(end,5)*(-362.5)/1e4, EMU_New_585(end,1)*(-362.5)/1e4] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width/2)

Tab_ISMIP_ssp126_GrIS_5=-0.04*SL2M;
Tab_ISMIP_ssp126_GrIS_17=-0.05*SL2M;
Tab_ISMIP_ssp126_GrIS_50=-0.06*SL2M;
Tab_ISMIP_ssp126_GrIS_83=-0.07*SL2M;
Tab_ISMIP_ssp126_GrIS_95=-0.08*SL2M;

Tab_ISMIP_ssp585_GrIS_5=-0.07*SL2M;
Tab_ISMIP_ssp585_GrIS_17=-0.09*SL2M;
Tab_ISMIP_ssp585_GrIS_50=-0.11*SL2M;
Tab_ISMIP_ssp585_GrIS_83=-0.14*SL2M;
Tab_ISMIP_ssp585_GrIS_95=-0.17*SL2M;


plot(offset+[2107.5,2107.5], [-9 2] ...
    , '-', 'Color','k', 'LineWidth', width/4)

plot(offset+[2105,2105], [Tab_ISMIP_ssp126_GrIS_50(end), Tab_ISMIP_ssp126_GrIS_50(end)] ...
    , '.', 'Color',color_SSP126, 'MarkerSize', 20)
plot(offset+[2105,2105], [Tab_ISMIP_ssp126_GrIS_83(end), Tab_ISMIP_ssp126_GrIS_17(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width)
plot(offset+[2105,2105], [Tab_ISMIP_ssp126_GrIS_95(end), Tab_ISMIP_ssp126_GrIS_5(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width/2)

plot(offset+[2106,2106], [Tab_ISMIP_ssp585_GrIS_50(end), Tab_ISMIP_ssp585_GrIS_50(end)] ...
    , '.', 'Color',color_SSP585, 'MarkerSize', 20)
plot(offset+[2106,2106], [Tab_ISMIP_ssp585_GrIS_83(end), Tab_ISMIP_ssp585_GrIS_17(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width)
plot(offset+[2106,2106], [Tab_ISMIP_ssp585_GrIS_95(end), Tab_ISMIP_ssp585_GrIS_5(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width/2)

txt = {'2100 medians,', '66% and 90% ranges'};
text(offset+2100+7.5,ylims(1)+0.9*ylength,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

txt = {'ISMIP6'};
text(offset+2100+4.5,ylims(1)+0.8*ylength,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

txt = {'Emulator'};
text(offset+2100+11,ylims(1)+0.8*ylength,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')



plot([start_year 2100],0*[start_year 2100], 'k:', 'LineWidth', 2)

legend([h3 h2 h1 h4],'Emulator median (SSPs)', ...
    'Emulator{\it 90%} range', ...
    'Emulator{\it 66%} range', ...
    'ISMIP6 models (RCPs/SSPs)', ...
    'Box','off' ...
    ,'Position',[0.3 0.3 0.1 0.1])

ax = gca;
ax.YAxis(2).Color = 'k';
ax.YAxis(1).Color = 'k';


print(gcf,'../PNGs/GIS_Timeseries_with_Box.png','-dpng','-r1000', '-painters');
print(gcf,'../PNGs/GIS_Timeseries_with_Box.eps','-depsc','-r1000', '-painters');

%% Plot paleo Mass Change Panel

SL2M=362.5*1000/1e4; % Convert SL (m) to Mass (10^4 Gt)

figure('Position', [10 10 240 400])
% Plot 
plot([.5,.5], -SL2M*[5.52, 5.52], '.', 'MarkerSize',35, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % Paleo-data ranges taken from Bopp et al., 2018 datasets
hold on
plot([.5,.5], -SL2M*[-0.57, 8.82], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 5.5Myr-400kyr BP
plot([2,2], -SL2M*[2.2, 2.2], '.', 'MarkerSize',35, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([2,2], -SL2M*[0.18, 6.2], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 400-22kyr BP
plot([3.5,3.5], -SL2M*[-2.74, -2.74], '.', 'MarkerSize',35, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([3.5,3.5], -SL2M*[-5.3, 0.17], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 22kyr BP- Present - New data from Alan (Slack Nov 2020)
xlim([0 4])
plot([0 5], [0 5]*0, 'k', 'LineWidth', width/10)

yyaxis left
y_limits=[-SL2M*10 SL2M*10];
ylim(y_limits)
ylabel('Mass Change (10^4 Gt)','FontSize',20)
set(gca,'FontSize',20)
yyaxis right
ylim(-fliplr(y_limits)/SL2M)
set ( gca, 'ydir', 'reverse','YColor','k')
set(gca,'Ytick',[-10 -5 0 5 10],'Yticklabel',{'-10','-5','0','5','10'})
ylabel('Equivalent Sea Level Contribution (m)','FontSize',20,'Color','k')
yyaxis left
set(gca,'Xtick',[0.5 2 3.5],'Xticklabel',[])
set(gca,'FontSize',15,'Box', 'on')

txt = {'Observed', 'mean and p-box'};
text(2.0,250,txt,'FontSize',14, ...
    'Color', color_OBS, 'FontWeight', 'bold','HorizontalAlignment','center')
text(0.5,-400,{'MPWP'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(2,-400,{'LIG'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(3.5,-400,{'LGM'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
txt = 'Paleo';
text(0.2,320,txt,'FontSize',18, ...
    'Color', 'k', 'FontWeight', 'bold')

print(gcf,'../PNGs/GISPaleoPbox.png','-dpng','-r1000', '-painters');





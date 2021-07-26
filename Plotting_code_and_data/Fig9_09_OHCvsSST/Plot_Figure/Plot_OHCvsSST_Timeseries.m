%% IPCC AR6 Chapter 9: Figure 9.9 (ocean heat content vs. SST)
%
% Code used to plot pre-processed ocean heat content and sea surface 
% temperature data. 
%
% Plotting code written by Brodie Pearson
% Processed data provided by Alan Mix
% Precise datasets cited in report/caption and detailed in Excel file

clear all

addpath ../../../Functions/

fontsize=20;
width = 3;

%Factor to multiply SSTs by to get on the same axis as OHC
SST_to_OHC_axis_factor = 20000/6;

%Factor to multiply SSTs by to get on the same axis as OHC fopr inset
SST_to_OHC_axis_factor_inset = 1200/12;
SST_to_OHC_axis_offset_inset = 200;

%Factor to multiply MOTs by to get on the same axis as OHC
MOT_to_OHC_axis_factor = 20000/3.66;

color_Shk = IPCC_Get_SSPColors('ssp370'); %red
color_SOSST = [196 121 0]/255; % orange
color_Uem = 'k'; % black
color_Bag = 'k'; % black
color_HadCM3 = [0 79 0]/255; % green
color_CMIP = [0 0 0]/255;
color_Lev = [196 121 0]/255; % orange
color_SSP126 = IPCC_Get_SSPColors('ssp126'); % darkblue
color_SSP245 = IPCC_Get_SSPColors('ssp245'); % yellow
color_SSP370 = IPCC_Get_SSPColors('ssp370'); %red
color_SSP585 = IPCC_Get_SSPColors('ssp585'); % dark red

%% Load in Alan's Excel file of data (contains future OHC/SST and several paleo records

[~,sheet_name]=xlsfinfo("./Data/9.2.2_ACM_Fig_9.9_OHC_Paleo_Data_update_2020_12_06.xlsx");

for k=1:numel(sheet_name)
  data{k}=xlsread( ...
      './Data/9.2.2_ACM_Fig_9.9_OHC_Paleo_Data_update_2020_12_06.xlsx', ...
      sheet_name{k});
end

%% Extract oldest (LIG) OHC data from Shackleton 2020

tmp_data = cell2mat(data(1,2));

% Extract Shackleton time in ka CE (negative)
Time_OHC_Oldest = tmp_data(1:50,3)/1000;
% Extract Shackleton OHC in ZJ
OHC_Oldest = tmp_data(1:50,9);
OHC_Oldest_min = tmp_data(1:50,10);
OHC_Oldest_max = tmp_data(1:50,11);

OHC_Oldest_bnds = [OHC_Oldest_max; flipud(OHC_Oldest_min); OHC_Oldest_max(1)];
Time_OHC_Oldest_bnds = [Time_OHC_Oldest; flipud(Time_OHC_Oldest); Time_OHC_Oldest(1)];

%% Extract oldest (LIG) SST data from source (Uemura et al 2018)

% Extract marine proxies time in ka CE (negative)
Time_SST_Oldest = tmp_data(1:end,19)/1000;
% Extract Shackleton SST in degC
SST_Oldest = tmp_data(1:end,20);

%% Extract oldest (LIG) Southern Ocean SST data from Marine Proxies

% Extract marine proxies time in ka CE (negative)
Time_SOSST_Oldest = tmp_data(1:end,24)/1000;
% Extract Shackleton SST in degC
SOSST_Oldest = tmp_data(1:end,25);
SOSST_Oldest_min = tmp_data(1:end,26);
SOSST_Oldest_max = tmp_data(1:end,27);

SOSST_Oldest_bnds = [SOSST_Oldest_max(1:2:end); flipud(SOSST_Oldest_min(1:2:end)); SOSST_Oldest_max(1)];
Time_SOSST_Oldest_bnds = [Time_SOSST_Oldest(1:2:end); flipud(Time_SOSST_Oldest(1:2:end)); Time_SOSST_Oldest(1)];

Time_SOSST_Oldest_bnds(isnan(SOSST_Oldest_bnds)) = [];
SOSST_Oldest_bnds(isnan(SOSST_Oldest_bnds)) = [];

%% Extract old (Deglacial/Holocene) OHC data from Shackleton 2019

tmp_data = cell2mat(data(1,3));

% Extract Shackleton time in ka CE (negative)
Time_OHC_Old = tmp_data(3:1502,3)/1000;
% Extract Shackleton OHC in ZJ
OHC_Old = tmp_data(3:1502,9);
OHC_Old_min = tmp_data(3:1502,10);
OHC_Old_max = tmp_data(3:1502,11);

OHC_Old_bnds = [OHC_Old_max; flipud(OHC_Old_min); OHC_Old_max(1)];
Time_OHC_Old_bnds = [Time_OHC_Old; flipud(Time_OHC_Old); Time_OHC_Old(1)];

%% Extract old (Deglacial/Holocene) OHC data from Baggenstos 2019

% Extract Baggenstos time in ka CE (negative)
Time_Bag_OHC_Old = tmp_data(3:39,19)/1000;
% Extract Shackleton OHC in ZJ
Bag_OHC_Old = tmp_data(3:39,25);
Bag_OHC_Old_min = tmp_data(3:39,26);
Bag_OHC_Old_max = tmp_data(3:39,27);

Bag_OHC_Old_bnds = [Bag_OHC_Old_max; flipud(Bag_OHC_Old_min); Bag_OHC_Old_max(1)];
Time_Bag_OHC_Old_bnds = [Time_Bag_OHC_Old; flipud(Time_Bag_OHC_Old); Time_Bag_OHC_Old(1)];

%% Extract old (Deglacial/Holocene) SST data from source (Uemura et al 2018)

% Extract marine proxies time in ka CE (negative)
Time_SST_Old = tmp_data(3:end,35)/1000;
% Extract Shackleton SST in degC
SST_Old = tmp_data(3:end,36);

%% Extract old (Deglacial/Holocene) Southern Ocean SST data from Marine Proxies

% Extract marine proxies time in ka CE (negative)
Time_SOSST_Old = tmp_data(3:end,40)/1000;
% Extract Shackleton SST in degC
SOSST_Old = tmp_data(3:end,41);
SOSST_Old_min = tmp_data(3:end,42);
SOSST_Old_max = tmp_data(3:end,43);

SOSST_Old_bnds = [SOSST_Old_max; flipud(SOSST_Old_min); SOSST_Old_max(1)];
Time_SOSST_Old_bnds = [Time_SOSST_Old; flipud(Time_SOSST_Old); Time_SOSST_Old(1)];

Time_SOSST_Old_bnds(isnan(SOSST_Old_bnds)) = [];
SOSST_Old_bnds(isnan(SOSST_Old_bnds)) = [];

%% Extract OHC projections

tmp_data = cell2mat(data(1,6));

% Extract Shackleton time in ka CE (negative)
Time_OHC_Proj = tmp_data(1:end,1)/1000;
% Extract Shackleton OHC in ZJ
OHC_Proj_1280Gt = tmp_data(1:end,12);
OHC_Proj_2560Gt = tmp_data(1:end,13);
OHC_Proj_3840Gt = tmp_data(1:end,14);
OHC_Proj_5120Gt = tmp_data(1:end,15);

%% Extract SAT projections

tmp_data = cell2mat(data(1,5));

% Extract Shackleton time in ka CE (negative)
Time_SAT_Proj = tmp_data(1:end,1)/1000;
% Extract Shackleton OHC in ZJ
SAT_Proj_1280Gt = tmp_data(1:end,4);
SAT_Proj_2560Gt = tmp_data(1:end,5);
SAT_Proj_3840Gt = tmp_data(1:end,6);
SAT_Proj_5120Gt = tmp_data(1:end,7);

%% Extract modern (1500-2000) OHC data from Levitus 2012

tmp_data = cell2mat(data(1,4));

% Extract Shackleton time in ka CE (negative)
Time_OHC_Mod = tmp_data(1:65,1)/1000;
% Extract Shackleton OHC in ZJ
OHC_Mod = tmp_data(1:65,4);

%% Extract modern (1500-2000) Temp source data from Uemeura 2018

% Extract Shackleton time in ka CE (negative)
Time_SST_Mod = tmp_data(1:14,12)/1000;
% Extract Shackleton OHC in ZJ
SST_Mod = tmp_data(1:14,13);

%% Extract modern (1500-2000) HadCM3 OHC data from Gregory et al

% Extract Shackleton time in ka CE (negative)
Time_HadCM3_Mod = tmp_data(1:end,17)/1000;
% Extract Shackleton OHC in ZJ
HadCM3_Mod = tmp_data(1:end,19);


%% Make plot (oldest/left plot first)

figure('Position', [10 10 1200 400])
subplot(1,100,1:35)
yyaxis left
y_limits=[-20000 30000];
xlim([-150 -110])
plot([-150 -110], [0 0], 'k-', 'LineWidth', width/10)
hold on
patch(Time_OHC_Oldest_bnds, OHC_Oldest_bnds,color_Shk, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(Time_SOSST_Oldest_bnds, SOSST_Oldest_bnds*SST_to_OHC_axis_factor,color_SOSST, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(Time_OHC_Oldest, OHC_Oldest, 'Color', color_Shk, 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(Time_SOSST_Oldest, SOSST_Oldest*SST_to_OHC_axis_factor, 'Color', color_SOSST, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(Time_SST_Oldest, SST_Oldest*SST_to_OHC_axis_factor, 'Color', color_Uem, 'LineWidth', width/2,'LineStyle','-','Marker','none')
h1=plot([-1e6 -2e6],[1 1], 'Color', 'k', 'LineWidth', ...
    width/2,'LineStyle','-','Marker','none');
h2=plot([-1e6 -2e6],[1 1], 'Color', 'k', 'LineWidth', ...
    width/2,'LineStyle','-','Marker','.', 'MarkerSize',20);
ylim(y_limits)
ylabel('OHC anomaly (10^{25} J = 10^4 ZJ)','FontSize',20)
set(gca,'FontSize',16)
yyaxis right
ylim([-6 9])
yticks([-6 -3 0 3 6 9])
yticklabels({'','','','','',''})
yyaxis left

xticks([-150 -140 -130 -120 -110])
xticklabels({'-150kyr CE','','-130kyr','','-110kyr      '})

yticks([-2 -1 0 1 2 3]*1e4)
yticklabels({'-2','-1','0','1','2','3'})
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

% Make middle panel

subplot(1,100,39:64)
yyaxis left
y_limits=[-20000 30000];
xlim([-40 2])
plot([-40 0], [0 0], 'k-', 'LineWidth', width/10)
hold on
patch(Time_OHC_Old_bnds, OHC_Old_bnds,color_Shk, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(Time_Bag_OHC_Old_bnds, Bag_OHC_Old_bnds,color_Bag, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(Time_SOSST_Old_bnds, SOSST_Old_bnds*SST_to_OHC_axis_factor,color_SOSST, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(Time_OHC_Old, OHC_Old, 'Color', color_Shk, 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(Time_Bag_OHC_Old, Bag_OHC_Old, 'Color', color_Bag, 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(Time_SOSST_Old, SOSST_Old*SST_to_OHC_axis_factor, 'Color', color_SOSST, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(Time_SST_Old, SST_Old*SST_to_OHC_axis_factor, 'Color', color_Uem, 'LineWidth', width/2,'LineStyle','-','Marker','none')
h1=plot([-1e6 -2e6],[1 1], 'Color', 'k', 'LineWidth', ...
    width/2,'LineStyle','-','Marker','none');
h2=plot([-1e6 -2e6],[1 1], 'Color', 'k', 'LineWidth', ...
    width/2,'LineStyle','-','Marker','.', 'MarkerSize',20);
ylim(y_limits)
set(gca,'FontSize',16)
yyaxis right
ylim([-6 9])
yticks([-6 -3 0 3 6 9])
yticklabels({'','','','','',''})
yyaxis left
xticks([-40 -30 -20 -10 0 2])
xticklabels({'      -40kyr','','-20kyr','','',''})
yticks([-2 -1 0 1 2 3]*1e4)
yticklabels({'','','','','',''})
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';


% Make right panel

subplot(1,100,68:100)
yyaxis left
y_limits=[-20000 30000];
xlim([2 14])
plot([2 14], [0 0], 'k-', 'LineWidth', width/10)
hold on
plot(Time_OHC_Proj, OHC_Proj_1280Gt, 'Color', color_SSP126, 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(Time_OHC_Proj, OHC_Proj_2560Gt, 'Color', color_SSP245, 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(Time_OHC_Proj, OHC_Proj_3840Gt, 'Color', color_SSP370, 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(Time_OHC_Proj, OHC_Proj_5120Gt, 'Color', color_SSP585, 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(Time_SAT_Proj, SAT_Proj_1280Gt*SST_to_OHC_axis_factor, 'Color', color_SSP126, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(Time_SAT_Proj, SAT_Proj_2560Gt*SST_to_OHC_axis_factor, 'Color', color_SSP245, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(Time_SAT_Proj, SAT_Proj_3840Gt*SST_to_OHC_axis_factor, 'Color', color_SSP370, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(Time_SAT_Proj, SAT_Proj_5120Gt*SST_to_OHC_axis_factor, 'Color', color_SSP585, 'LineWidth', width/2,'LineStyle','-','Marker','none')
h1=plot([-1e6 -2e6],[1 1], 'Color', 'k', 'LineWidth', ...
    width/2,'LineStyle','--','Marker','none');
h2=plot([-1e6 -2e6],[1 1], 'Color', 'k', 'LineWidth', ...
    width/2,'LineStyle','-');
ylim(y_limits)
yyaxis right
ylim([-6 9])
yticks([-6 -3 0 3 6 9])
yticklabels({'-6','-3','0','3','6','9'})
ylabel('Surface Temperature Anomaly (^oC)','FontSize',14)
yyaxis left
xticks([2.02 4 6 8 10 12 14])
xticklabels({'Present        ','','6000','','10000','','14000'})
yticks([-2 -1 0 1 2 3]*1e4)
yticklabels({'','','','','',''})
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

txt = {'Last Interglacial Observations'};
text(-22.2,28000, ...
    txt,'FontSize',14, ...
    'Color', 'k', 'FontWeight', 'bold')
txt = {'OHC: {\color[rgb]{0.949 0.0667 0.0667}Shackleton\color{black}}', ...
    'SST (Southern Ocean): {\color[rgb]{black}Uemera, \color[rgb]{0.7686 0.4745 0}Proxies}'};
text(-22.2,24000,txt,'FontSize',12, 'FontWeight', 'bold','interpreter','tex')

txt = {'Deglacial/Holocene Observations'};
text(-8.2,28000, ...
    txt,'FontSize',14, ...
    'Color', 'k', 'FontWeight', 'bold')
txt = {'OHC: {\color[rgb]{black}Baggenstos\color{black}, \color[rgb]{0.949 0.0667 0.0667}Shackleton\color{black}}', ...
    'SST (Southern Ocean): {\color[rgb]{black}Uemera, \color[rgb]{0.7686 0.4745 0}Proxies}'};
text(-8.2,24000,txt,'FontSize',12, 'FontWeight', 'bold','interpreter','tex')

txt = {'Model projections under different emissions'};
text(2.2,-2500, ...
    txt,'FontSize',14, ...
    'Color', 'k', 'FontWeight', 'bold')
txt = {'OHC and atmospheric surface temperature:', ...
    '{\color[rgb]{0.1137 0.2 0.3294}1280 Gt\color{black}, \color[rgb]{0.9176 0.8667 0.2392}2560 Gt\color{black}, \color[rgb]{0.9490 0.0667 0.0667}3840 Gt\color{black}, \color[rgb]{0.5176 0.0431 0.1333}5120 Gt}'};
text(2.2,-6500,txt,'FontSize',12, 'FontWeight', 'bold','interpreter','tex')

legend([h1 h2],'Ocean Heat Content (OHC)', ...
    'Surface Temperature','Box','off' ...
    ,'Position',[0.17 0.65 0.1 0.1],'Fontsize',14)
set(gca,'FontSize',16)



print(gcf,'../PNGs/OHCvsSST.png','-dpng','-r1000', '-painters');
close(1)

%%

figure('Position', [10 10 1200 150])
xlim([1.5 2.02])
plot([1.5 2.02], [0 0], 'k-', 'LineWidth', width/10)
hold on
plot(Time_OHC_Mod, OHC_Mod, 'Color', color_Lev, 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(Time_HadCM3_Mod, HadCM3_Mod, 'Color', color_HadCM3, 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(Time_SST_Mod, SST_Mod*SST_to_OHC_axis_factor_inset, 'Color', color_Uem, 'LineWidth', width/2,'LineStyle','-','Marker','none')
ylim([-0.06 0.06]*1e4)
yticks([-.06 -0.03 0 .03 .06]*1e4)
yticklabels({'-0.06','-0.03','0','0.03','0.06'})
ylabel('10^{25} J','FontSize',14)
yyaxis right
ylim([-6 6])
yticks([-6 -3 0 3 6])
yticklabels({'-6','-3','0','3','6'})
ylabel('^oC','FontSize',14)
yyaxis left
xlim([1.5 2.02])
xticks([1.5 1.6 1.7 1.8 1.9 2])
xticklabels({'1500 CE','1600','1700','1800','1900','2000'})
set(gca,'FontSize',16)
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

txt = {'Modern Historical Data'};
text(1.505,520, ...
    txt,'FontSize',14, ...
    'Color', 'k', 'FontWeight', 'bold')
txt = {'OHC: {\color[rgb]{0.7686 0.4745 0}Levitus (observed), \color[rgb]{0 0.3098 0}HadCM3 (modelled)}', ...
    'SST (Southern Ocean): {\color[rgb]{black}Uemera}'};
text(1.505,280,txt,'FontSize',12, 'FontWeight', 'bold','interpreter','tex')

print(gcf,'../PNGs/OHCvsSST_Modern.png','-dpng','-r1000', '-painters');
close(1)

%% Write data from timeseries into netcdf files

comments = "Data is for Figure 9.9 time series in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

var_name = 'ohc';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_Shackletonmean_LIG.nc';
title = "Mean Ocean Heat Content for Last Interglacial from Shackleton";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Oldest, ...
    Time_OHC_Oldest, title, comments)

var_name = 'ohc_LikelyRange';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_Shackletonlikely_LIG.nc';
title = "Likely range of Ocean Heat Content for Last Interglacial from Shackleton";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Oldest_bnds, ...
    Time_OHC_Oldest_bnds, title, comments)

var_name = 'sosst';
var_units = 'degrees Celsius';
ncfilename = '../Plotted_Data/Fig9-9_data_SouthernOceanSST_LIG.nc';
title = "Southern Ocean Sea Surface Temperature for Last Interglacial";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SOSST_Oldest, ...
    Time_SOSST_Oldest, title, comments)

var_name = 'gmsst';
var_units = 'degrees Celsius';
ncfilename = '../Plotted_Data/Fig9-9_data_GlobalMeanSST_LIG.nc';
title = "Global Mean Sea Surface Temperature for Last Interglacial";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SST_Oldest, ...
    Time_SST_Oldest, title, comments)

var_name = 'ohc';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_Shackletonmean_Deglacial.nc';
title = "Mean Ocean Heat Content for Deglacial/Holocene from Shackleton";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Old, ...
    Time_OHC_Old, title, comments)

var_name = 'ohc_LikelyRange';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_Shackletonlikely_Deglacial.nc';
title = "Likely range of Ocean Heat Content for Deglacial/Holocene from Shackleton";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Old_bnds, ...
    Time_OHC_Old_bnds, title, comments)

var_name = 'ohc';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_Baggenstosmean_Deglacial.nc';
title = "Mean Ocean Heat Content for Deglacial/Holocene from Baggenstos";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, Bag_OHC_Old, ...
    Time_Bag_OHC_Old, title, comments)

var_name = 'ohc_LikelyRange';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_Baggenstoslikely_Deglacial.nc';
title = "Likely range of Ocean Heat Content for Deglacial/Holocene from Baggenstos";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, Bag_OHC_Old_bnds, ...
    Time_Bag_OHC_Old_bnds, title, comments)

var_name = 'sosst';
var_units = 'degrees Celsius';
ncfilename = '../Plotted_Data/Fig9-9_data_SouthernOceanSST_Deglacial.nc';
title = "Southern Ocean Sea Surface Temperature for Deglacial/Holocene";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SOSST_Old, ...
    Time_SOSST_Old, title, comments)

var_name = 'gmsst';
var_units = 'degrees Celsius';
ncfilename = '../Plotted_Data/Fig9-9_data_GlobalMeanSST_Deglacial.nc';
title = "Global Mean Sea Surface Temperature for Deglacial/Holocene";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SST_Old, ...
    Time_SST_Old, title, comments)

var_name = 'ohc';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_Levitus_Modern.nc';
title = "Mean Ocean Heat Content for Modern period from Levitus";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Mod, ...
    Time_OHC_Mod, title, comments)

var_name = 'ohc';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_HadCM3_Modern.nc';
title = "Mean Ocean Heat Content for Modern period from HadCM3";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, HadCM3_Mod, ...
    Time_HadCM3_Mod, title, comments)

var_name = 'gmsst';
var_units = 'degrees Celsius';
ncfilename = '../Plotted_Data/Fig9-9_data_Uemera_Modern.nc';
title = "Global Mean Sea Surface Temperature for modern period from Uemura";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SST_Mod, ...
    Time_SST_Mod, title, comments)

%% Write projection data to NetCDF

var_name = 'ohc';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_ohc_1280Gt.nc';
title = "Mean Ocean Heat Content projection for 1280Gt emissions";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Proj_1280Gt, ...
    Time_OHC_Proj, title, comments)

var_name = 'ohc';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_ohc_2560Gt.nc';
title = "Mean Ocean Heat Content projection for 2560Gt emissions";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Proj_2560Gt, ...
    Time_OHC_Proj, title, comments)

var_name = 'ohc';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_ohc_3840Gt.nc';
title = "Mean Ocean Heat Content projection for 3840Gt emissions";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Proj_3840Gt, ...
    Time_OHC_Proj, title, comments)

var_name = 'ohc';
var_units = '10^4 Zeta Joules (10^25 Joules)';
ncfilename = '../Plotted_Data/Fig9-9_data_ohc_5120Gt.nc';
title = "Mean Ocean Heat Content projection for 5120Gt emissions";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Proj_5120Gt, ...
    Time_OHC_Proj, title, comments)

var_name = 'tas';
var_units = 'degrees Celsius';
ncfilename = '../Plotted_Data/Fig9-9_data_ohc_1280Gt.nc';
title = "Global Mean Atmospheric Surface Temperature projection for 1280Gt emissions";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SAT_Proj_1280Gt, ...
    Time_SAT_Proj, title, comments)

var_name = 'tas';
var_units = 'degrees Celsius';
ncfilename = '../Plotted_Data/Fig9-9_data_ohc_2560Gt.nc';
title = "Global Mean Atmospheric Surface Temperature projection for 2560Gt emissions";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SAT_Proj_2560Gt, ...
    Time_SAT_Proj, title, comments)

var_name = 'tas';
var_units = 'degrees Celsius';
ncfilename = '../Plotted_Data/Fig9-9_data_ohc_3840Gt.nc';
title = "Global Mean Atmospheric Surface Temperature projection for 3840Gt emissions";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SAT_Proj_3840Gt, ...
    Time_SAT_Proj, title, comments)

var_name = 'tas';
var_units = 'degrees Celsius';
ncfilename = '../Plotted_Data/Fig9-9_data_ohc_5120Gt.nc';
title = "Global Mean Atmospheric Surface Temperature projection for 5120Gt emissions";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SAT_Proj_5120Gt, ...
    Time_SAT_Proj, title, comments)


%% Write paleo plot data

creator = "Brodie Pearson (brodie.pearson@oregonstate.edu)";
activity = "IPCC AR6 (Chapter 9)";
ncfilename = '../Plotted_Data/Fig9-9_data_SST_to_OHC_Conversion_Factor.nc';
title = "Paleo global mean sea surface temperature datasets "+ ...
    "with both means and likely ranges where neccessary";
var_units = '10^4 Zeta Joules per degree Celsius';

% Create variables in netcdf files
nccreate(ncfilename,'SST_to_OHC_conversion_factor');

% Write variables to netcdf files
ncwrite(ncfilename,'SST_to_OHC_conversion_factor',SST_to_OHC_axis_factor);

% Write metadata to netcdf file
ncwriteatt(ncfilename,'/','title',title);
ncwriteatt(ncfilename,'/','units',var_units);
ncwriteatt(ncfilename,'/','creator',creator);
ncwriteatt(ncfilename,'/','activity',activity);
ncwriteatt(ncfilename,'/','comments',comments);


clear all

addpath ../../../Functions/

fontsize=20;
width = 5;
start_year=1840;
end_year=2100;

%% Get IMBIE Data (No IMBIE for GrIS sub-regions yet)

IMBIE_data0=xlsread('Data/IMBIE_latest/IMBIE_AR6.xlsx');

% Extract IMBIE Cumulative mass change (in Gt)
IMBIE_time = IMBIE_data0(:,1);
IMBIE_data = IMBIE_data0(:,7);  % no longer reverting to old IMBIE2
IMBIE_data_std = IMBIE_data0(:,8); 
% Convert IMBIE Cumulative sea level equivalent (in mm)
IMBIE_data_sl = IMBIE_data*(-362.5);
IMBIE_data_sl_std = IMBIE_data_std*(-362.5);

IMBIE_data = IMBIE_data - IMBIE_data(277);  % Anomalize IMBIE vs. 2015

%% Read Mouginot pnas data

[~,sheet_name]=xlsfinfo('Data/Data_Greenland/Mouginot_pnas.1904242116.sd02.xlsx');

clear data

for k=1:numel(sheet_name)
  data{k}=xlsread('Data/Data_Greenland/Mouginot_pnas.1904242116.sd02.xlsx',sheet_name{k});
end

Moug_data = cell2mat(data(1,2));
Moug_time = Moug_data(35,14:60)';
Moug_time_Conf_Bounds = [Moug_time; flipud(Moug_time); Moug_time(1)];
Moug_SW = Moug_data(36,14:60)';
Moug_SW_std = Moug_data(36,81:127)';
Moug_SW_Conf_Bounds = [Moug_SW+Moug_SW_std; flipud(Moug_SW-Moug_SW_std); Moug_SW(1)+Moug_SW_std(1)];
Moug_CW = Moug_data(37,14:60)';
Moug_CW_std = Moug_data(37,81:127)';
Moug_CW_Conf_Bounds = [Moug_CW+Moug_CW_std; flipud(Moug_CW-Moug_CW_std); Moug_CW(1)+Moug_CW_std(1)];
Moug_NW = Moug_data(38,14:60)';
Moug_NW_std = Moug_data(38,81:127)';
Moug_NW_Conf_Bounds = [Moug_NW+Moug_NW_std; flipud(Moug_NW-Moug_NW_std); Moug_NW(1)+Moug_NW_std(1)];
Moug_NO = Moug_data(39,14:60)';
Moug_NO_std = Moug_data(39,81:127)';
Moug_NO_Conf_Bounds = [Moug_NO+Moug_NO_std; flipud(Moug_NO-Moug_NO_std); Moug_NO(1)+Moug_NO_std(1)];
Moug_NE = Moug_data(40,14:60)';
Moug_NE_std = Moug_data(40,81:127)';
Moug_NE_Conf_Bounds = [Moug_NE+Moug_NE_std; flipud(Moug_NE-Moug_NE_std); Moug_NE(1)+Moug_NE_std(1)];
Moug_CE = Moug_data(41,14:60)';
Moug_CE_std = Moug_data(41,81:127)';
Moug_CE_Conf_Bounds = [Moug_CE+Moug_CE_std; flipud(Moug_CE-Moug_CE_std); Moug_CE(1)+Moug_CE_std(1)];
Moug_SE_uncorrected = Moug_data(42,14:60)';
Moug_SE_std = Moug_data(42,81:127)';
Moug_SE=Moug_SE_uncorrected;%+Moug_CE; Now CE is treated on its own.
Moug_SE_Conf_Bounds = [Moug_SE+Moug_SE_std; flipud(Moug_SE-Moug_SE_std); Moug_SE(1)+Moug_SE_std(1)];
Moug_Total = Moug_data(43,14:60)';
Moug_Total_std = Moug_data(43,81:127)';
Moug_Total_Conf_Bounds = [Moug_Total+Moug_Total_std; flipud(Moug_Total-Moug_Total_std); Moug_Total(1)+Moug_Total_std(1)];

%% Read Colgan data

[~,sheet_name]=xlsfinfo('Data/Data_Greenland/Colgan_MassBalance_07022019.xlsx');

clear data

for k=1:numel(sheet_name)
  data{k}=xlsread('Data/Data_Greenland/Colgan_MassBalance_07022019.xlsx',sheet_name{k});
end

Colg_data = cell2mat(data(1,6));
Colg_time = Colg_data(1,2:2:42)';
Colg_1_1 = Colg_data(3,2:2:42)';
Colg_1_2 = Colg_data(4,2:2:42)';
Colg_1_3 = Colg_data(5,2:2:42)';
Colg_1_4 = Colg_data(6,2:2:42)';
Colg_2_1 = Colg_data(7,2:2:42)';
Colg_2_2 = Colg_data(8,2:2:42)';
Colg_3_1 = Colg_data(9,2:2:42)';
Colg_3_3 = Colg_data(11,2:2:42)';
Colg_4_1 = Colg_data(12,2:2:42)';
Colg_4_2 = Colg_data(13,2:2:42)';
Colg_4_3 = Colg_data(14,2:2:42)';
Colg_5 = Colg_data(15,2:2:42)';
Colg_6_1 = Colg_data(16,2:2:42)';
Colg_6_2 = Colg_data(17,2:2:42)';
Colg_7_1 = Colg_data(18,2:2:42)';
Colg_7_2 = Colg_data(19,2:2:42)';
Colg_8_1 = Colg_data(20,2:2:42)';
Colg_8_2 = Colg_data(21,2:2:42)';

Colg_NO = Colg_1_1 + Colg_1_2 + Colg_1_3;
Colg_NE = Colg_1_4 + Colg_2_1 + Colg_2_2 + Colg_3_1;
Colg_SE = Colg_3_3 + Colg_4_1 + Colg_4_2 + Colg_4_3;
Colg_SW = Colg_5 + Colg_6_1 + Colg_6_2;
Colg_CW = Colg_7_1 + Colg_7_2 ;
Colg_NW = Colg_8_1 + Colg_8_2 ;

Colg_Total = Colg_data(22,2:2:42)';
Colg_Total_test = Colg_NO + Colg_NE + Colg_SE + Colg_SW + Colg_CW ...
    + Colg_NW;


%% Read Box data

% temp = readtable('../Data_Greenland/Box_Greenland_mass_balance_totals_1840-2012_ver_20141130_with_uncert.csv');
% Box_data=table2array(temp);
% Box_time = [1840:1:2012]';
% % Extract Total mass balance of GrIS
% Box_data_GrIS = Box_data(1:end-1,12);
% Box_data_GrIS = cellfun(@str2num,Box_data_GrIS);
% Box_data_GrIS_std = Box_data(1:end-1,13);

%% Read Bamber data

 T = readtable('Data/AISregions/Bamber-etal_2018_readme.dat');
 Bamber_data=table2array(T);
 Bamber_time = Bamber_data(:,1);
 Bamber_data_GrIS = Bamber_data(:,2);
 Bamber_data_GrIS_std = Bamber_data(:,3);
% Bamber_data_w_std = Bamber_data(:,5);
% Bamber_data_e = Bamber_data(:,6);
% Bamber_data_e_std = Bamber_data(:,7);


for ii=1:length(Bamber_data)
    AA_Bamber_GrIS(ii) = sum(Bamber_data_GrIS(1:ii)); 
    AA_Bamber_GrIS_std(ii) = sum(Bamber_data_GrIS_std(1:ii));  % This assumes correlated errors
end

GrIS_Bamber = AA_Bamber_GrIS' - AA_Bamber_GrIS(24);
GrIS_Bamber_std = AA_Bamber_GrIS_std';

TIME_Bamber = Bamber_time;

Bamber_ubound_GrIS=GrIS_Bamber+GrIS_Bamber_std;
Bamber_lbound_GrIS=GrIS_Bamber-GrIS_Bamber_std;
Bamber_Conf_Bounds_GrIS = [Bamber_ubound_GrIS; flipud(Bamber_lbound_GrIS); Bamber_ubound_GrIS(1)];
Bamber_Time_Conf_Bounds = [TIME_Bamber; flipud(TIME_Bamber); TIME_Bamber(1)];

%% Make Plots

Bamber_line =  [230, 159, 0]./255; %IPCC_Get_SSPColors('HighResMIP'); % Obs.
Bamber_shading = Bamber_line ; 
color_Bamber=Bamber_line;

color_OBS = [196 121 0]/255;
color_HR = [0 79 0]/255;
color_CMIP = [0 0 0]/255;
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

color_NO = [221 84 46]/255;
color_NE = [33 219 216]/255;
color_SE = [8 46 114]/255;
color_CE = (color_SE+color_NE)/2;  % new version here
color_SW = [236 156 46]/255;
color_CW = [50 127 81]/255;
color_NW = [128 54 168]/255;

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

%% Diagnose cumulative Box Data and construct data structure
% Must sum (as currently in annual mass balance ith units of Gt per annum)
% for ii=1:length(Box_data_GrIS)
%     GrIS_Box(ii) = sum(Box_data_GrIS(1:ii));  
% end
% 
% % Anomalize Box relative to year 2015
% GrIS_Box = GrIS_Box - GrIS_Box(173); % Currently 2012 - CHANGE TO 2015
% 
% TIME_Box = Box_time;

%% Diagnose cumulative Colgan Data and construct data structure
% Must sum (as currently in annual mass balance with units of Gt per annum)
for ii=1:length(Colg_Total)
    Total_Colg(ii) = sum(Colg_Total(1:ii));  
    NO_Colg(ii) = sum(Colg_NO(1:ii)); 
    NE_Colg(ii) = sum(Colg_NE(1:ii)); 
    SE_Colg(ii) = sum(Colg_SE(1:ii)); 
    SW_Colg(ii) = sum(Colg_SW(1:ii));
    CW_Colg(ii) = sum(Colg_CW(1:ii)); 
    NW_Colg(ii) = sum(Colg_NW(1:ii));
end

% Anomalize Box relative to year 2015
Total_Colg = Total_Colg - Total_Colg(21);
NO_Colg = NO_Colg - NO_Colg(21);
NE_Colg = NE_Colg - NE_Colg(21);
SE_Colg = SE_Colg - SE_Colg(21);
SW_Colg = SW_Colg - SW_Colg(21);
CW_Colg = CW_Colg - CW_Colg(21);
NW_Colg = NW_Colg - NW_Colg(21);

TIME_Colg = Colg_time;

%% Anomalize Moug Data structure

Total_Moug = Moug_Total - Moug_Total(44);
Moug_Total_Conf_Bounds=Moug_Total_Conf_Bounds - Moug_Total(44);
NO_Moug = Moug_NO - Moug_NO(44);
Moug_NO_Conf_Bounds=Moug_NO_Conf_Bounds - Moug_NO(44);
NE_Moug = Moug_NE - Moug_NE(44);
Moug_NE_Conf_Bounds=Moug_NE_Conf_Bounds - Moug_NE(44);
CE_Moug = Moug_CE - Moug_CE(44);
Moug_CE_Conf_Bounds=Moug_CE_Conf_Bounds - Moug_CE(44);
SE_Moug = Moug_SE - Moug_SE(44);
Moug_SE_Conf_Bounds=Moug_SE_Conf_Bounds - Moug_SE(44);
SW_Moug = Moug_SW - Moug_SW(44);
Moug_SW_Conf_Bounds=Moug_SW_Conf_Bounds - Moug_SW(44);
CW_Moug = Moug_CW - Moug_CW(44);
Moug_CW_Conf_Bounds=Moug_CW_Conf_Bounds - Moug_CW(44);
NW_Moug = Moug_NW - Moug_NW(44);
Moug_NW_Conf_Bounds=Moug_NW_Conf_Bounds - Moug_NW(44);
TIME_Moug = Moug_time;


%% Anomalize Bamber
 
TIME_Bamber = Bamber_time;
GrIS_Bamber = GrIS_Bamber - GrIS_Bamber(24); % Anomalize Bamber vs. 2015

%% Make plots


figure('Position', [10 10 600 400])
yyaxis left
h1=plot(TIME_Moug,Total_Moug, 'k--', 'LineWidth', width/2,'Marker','none')
hold on
patch(Moug_time_Conf_Bounds,Moug_Total_Conf_Bounds,'k', 'EdgeColor', 'none', 'FaceAlpha', 0.1)

plot(IMBIE_time,IMBIE_data,'k', 'LineWidth', width/2,'LineStyle','-','Marker','none')
patch(OBS_Time_Conf_Bounds(~isnan(OBS_Conf_Bounds)),OBS_Conf_Bounds(~isnan(OBS_Conf_Bounds)),'k', 'EdgeColor', 'none', 'FaceAlpha', 0.3)

plot(TIME_Bamber,GrIS_Bamber, 'Color', color_Bamber, 'LineWidth', width/2,'LineStyle','-','Marker','none')
patch(Bamber_Time_Conf_Bounds,Bamber_Conf_Bounds_GrIS,color_Bamber, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(TIME_Moug,NO_Moug, 'Color', color_NO, 'LineWidth', width/2,'LineStyle','-','Marker','none')
patch(Moug_time_Conf_Bounds,Moug_NO_Conf_Bounds,color_NO, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(TIME_Moug,NE_Moug, 'Color', color_NE, 'LineWidth', width/2,'LineStyle','-','Marker','none')
patch(Moug_time_Conf_Bounds,Moug_NE_Conf_Bounds,color_NE, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(TIME_Moug,CE_Moug, 'Color', color_CE, 'LineWidth', width/2,'LineStyle','-','Marker','none')
patch(Moug_time_Conf_Bounds,Moug_CE_Conf_Bounds,color_CE, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(TIME_Moug,SE_Moug, 'Color', color_SE, 'LineWidth', width/2,'LineStyle','-','Marker','none')
patch(Moug_time_Conf_Bounds,Moug_SE_Conf_Bounds,color_SE, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(TIME_Moug,SW_Moug, 'Color', color_SW, 'LineWidth', width/2,'LineStyle','-','Marker','none')
patch(Moug_time_Conf_Bounds,Moug_SW_Conf_Bounds,color_SW, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(TIME_Moug,CW_Moug, 'Color', color_CW, 'LineWidth', width/2,'LineStyle','-','Marker','none')
patch(Moug_time_Conf_Bounds,Moug_CW_Conf_Bounds,color_CW, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(TIME_Moug,NW_Moug, 'Color', color_NW, 'LineWidth', width/2,'LineStyle','-','Marker','none')
patch(Moug_time_Conf_Bounds,Moug_NW_Conf_Bounds,color_NW, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
%h2=plot(TIME_Colg,Total_Colg, 'Color', 'k', 'LineWidth', width/2,'LineStyle','--','Marker','none')
%plot(TIME_Colg,NO_Colg, 'Color', color_NO, 'LineWidth', width/2,'LineStyle','--','Marker','none')
%plot(TIME_Colg,NE_Colg, 'Color', color_NE, 'LineWidth', width/2,'LineStyle','--','Marker','none')
%plot(TIME_Colg,SE_Colg, 'Color', color_SE, 'LineWidth', width/2,'LineStyle','--','Marker','none')
%plot(TIME_Colg,SW_Colg, 'Color', color_SW, 'LineWidth', width/2,'LineStyle','--','Marker','none')
%plot(TIME_Colg,CW_Colg, 'Color', color_CW, 'LineWidth', width/2,'LineStyle','--','Marker','none')
%plot(TIME_Colg,NW_Colg, 'Color', color_NW, 'LineWidth', width/2,'LineStyle','--','Marker','none')
% patch(OBS_Time_Conf_Bounds,OBS_Conf_Bounds,color_OBS, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
% hold on
% patch(ISMIP_Time_Conf_Bounds,ISMIP_585_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
% patch(ISMIP_Time_Conf_Bounds,ISMIP_126_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
xlim([1970 2020])
y_limits=[-1000 6000];
ylim(y_limits)
ylabel('Mass Change (Gt)','FontSize',16)
set(gca,'FontSize',16)
yyaxis right
ylim(-fliplr(y_limits)/(360*1000))
set ( gca, 'ydir', 'reverse' )
ylabel('Equivalent Sea Level Contribution (m)','FontSize',16)
set(gca, 'YTickLabel', get(gca, 'YTick'));
%plot(TIME_OBS,GrIS_Imbie_sl, 'Color', 'k', 'LineWidth', width/2,'LineStyle',':','Marker','none')
yyaxis left

txt = {'Mouginot Total'};
text(1975,5000,txt,'FontSize',14, ...
    'Color', 'k', 'FontWeight', 'bold')
%txt = {'Colgan Total'};
%text(1990,2800,txt,'FontSize',14, ...
%    'Color', 'k', 'FontWeight', 'bold')
txt = {'Mouginot regions (see map)'};
text(1972,1800,txt,'FontSize',14, ...
    'Color', [.5 .5 .5], 'FontWeight', 'bold')
% txt = 'Box';
% text(TIME_Box(floor(end/4))+5,double(GrIS_Box(floor(end/2)))-500,txt,'FontSize',20, ...
%     'Color', color_SSP370, 'FontWeight', 'bold')

 txt = 'Bamber Total';
 endbamb=length(GrIS_Bamber);
 text(1990,4600,txt,'FontSize',14,'Color', color_Bamber, 'FontWeight', 'bold')
 
 txt = 'IMBIE Total';
 endbamb=length(GrIS_Bamber);
 text(1990,2800,txt,'FontSize',14,'Color', 'black', 'FontWeight', 'bold')
 
% txt = 'IMBIE';
% text(TIME_OBS(floor(end/4))+30,double(GrIS_Imbie(floor(end/2))-2500), ...
%     txt,'FontSize',20, ...
%     'Color', color_OBS, 'FontWeight', 'bold')
% txt = 'RCP 2.6';
% text(2070,800, ...
%     txt,'FontSize',20, ...
%     'Color', color_SSP126, 'FontWeight', 'bold')
% txt = 'RCP 8.5';
% text(2060,-3200, ...
%     txt,'FontSize',20, ...
%     'Color', color_SSP585, 'FontWeight', 'bold')
txt = {'Greenland Mass Change Relative to 2015'};
text(1971,6250,txt,'FontSize',20, ...
    'Color', 'k', 'FontWeight', 'bold')
set(gca,'Box', 'off')
set(gca,'TickDir','out');
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

plot([start_year 2100],0*[start_year 2100], 'k:', 'LineWidth', 2)
%legend([h1 h2],'Mouginot', 'Colgan', 'Box','off')

print('-dpng','-r400','../PNGs/GrIS_Regional_MB');



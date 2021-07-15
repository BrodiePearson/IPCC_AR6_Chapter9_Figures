clear all

addpath ../../../Functions/

fontsize=20;
width = 5;
start_year=1840;
end_year=2100;

%% Get IMBIE Data, anomalize, and calculate error envelopes

IMBIE_data0=xlsread('Data/IMBIE_latest/IMBIE_AR6.xlsx');

% Extract IMBIE Cumulative mass change (in Gt)
IMBIE_time = IMBIE_data0(:,1);
IMBIE_data = IMBIE_data0(:,9);       % No longer revert to IMBIE-2
IMBIE_data_std = IMBIE_data0(:,10);
% Convert IMBIE Cumulative sea level equivalent (in mm)
IMBIE_data_sl = IMBIE_data*(-362.5);
IMBIE_data_sl_std = IMBIE_data_std*(-362.5);

%% Define IMBIE regional data (as dummy datasets for now)
%% Don't use IMBIE Regional

IMBIE_data_p=csvread('Data/IMBIE_latest/apis_dm.csv');

%IMBIE_data_p=xlsread('AISregions/imbie_dataset-2018_07_23.xlsx','Antarctic Peninsula');

AA_Imbie_p = IMBIE_data_p(:,2);
AA_Imbie_p = AA_Imbie_p - AA_Imbie_p(277); % Baseline 2015
AA_Imbie_p_unc = IMBIE_data_p(:,3);
TIME_OBS_p = IMBIE_data_p(:,1);

OBS_ubound_p=AA_Imbie_p+AA_Imbie_p_unc;
OBS_lbound_p=AA_Imbie_p-AA_Imbie_p_unc;
OBS_Conf_Bounds_p = [OBS_ubound_p; flipud(OBS_lbound_p); OBS_ubound_p(1)];
OBS_Time_Conf_Bounds_p = [TIME_OBS_p; flipud(TIME_OBS_p); TIME_OBS_p(1)];

IMBIE_data_e=csvread('Data/IMBIE_latest/eais_dm.csv');
%IMBIE_data_e=xlsread('AISregions/imbie_dataset-2018_07_23.xlsx','East Antarctica');

AA_Imbie_e = IMBIE_data_e(:,2);
AA_Imbie_e = AA_Imbie_e - AA_Imbie_e(277);
AA_Imbie_e_unc = IMBIE_data_e(:,3);
TIME_OBS_e = IMBIE_data_e(:,1);

OBS_ubound_e=AA_Imbie_e+AA_Imbie_e_unc;
OBS_lbound_e=AA_Imbie_e-AA_Imbie_e_unc;
OBS_Conf_Bounds_e = [OBS_ubound_e; flipud(OBS_lbound_e); OBS_ubound_e(1)];
OBS_Time_Conf_Bounds_e = [TIME_OBS_e; flipud(TIME_OBS_e); TIME_OBS_e(1)];

IMBIE_data_w=csvread('Data/IMBIE_latest/wais_dm.csv');
%IMBIE_data_w=xlsread('AISregions/imbie_dataset-2018_07_23.xlsx','West Antarctica');

AA_Imbie_w = IMBIE_data_w(:,2);
AA_Imbie_w = AA_Imbie_w - AA_Imbie_w(277);
AA_Imbie_w_unc = IMBIE_data_w(:,3);
TIME_OBS_w = IMBIE_data_w(:,1);

OBS_ubound_w=AA_Imbie_w+AA_Imbie_w_unc;
OBS_lbound_w=AA_Imbie_w-AA_Imbie_w_unc;
OBS_Conf_Bounds_w = [OBS_ubound_w; flipud(OBS_lbound_w); OBS_ubound_w(1)];
OBS_Time_Conf_Bounds_w = [TIME_OBS_w; flipud(TIME_OBS_w); TIME_OBS_w(1)];

AA_Imbie = IMBIE_data;
AA_Imbie = AA_Imbie - AA_Imbie(277);
AA_Imbie_unc = IMBIE_data_std;
TIME_OBS = IMBIE_time;

OBS_ubound=AA_Imbie+AA_Imbie_unc;
OBS_lbound=AA_Imbie-AA_Imbie_unc;
OBS_Conf_Bounds = [OBS_ubound; flipud(OBS_lbound); OBS_ubound(1)];
OBS_Time_Conf_Bounds = [TIME_OBS; flipud(TIME_OBS); TIME_OBS(1)];

%% Extract, sum and anomalize Bamber data
% Must sum (as currently in annual mass balance ith units of Gt per annum)

T = readtable('./Data/Fig_MB_Antarctic_Timeseries/Bamber-etal_2018_readme.dat');
Bamber_data=table2array(T);
Bamber_time = Bamber_data(:,1);
Bamber_data_w = Bamber_data(:,4);
Bamber_data_w_std = Bamber_data(:,5);
Bamber_data_e = Bamber_data(:,6);
Bamber_data_e_std = Bamber_data(:,7);

for ii=1:length(Bamber_data_w)
    AA_Bamber_w(ii) = sum(Bamber_data_w(1:ii)); 
    AA_Bamber_e(ii) = sum(Bamber_data_e(1:ii)); 
    AA_Bamber_w_std(ii) = sum(Bamber_data_w_std(1:ii)); 
    AA_Bamber_e_std(ii) = sum(Bamber_data_e_std(1:ii)); 
end

AA_Bamber_w = AA_Bamber_w' - AA_Bamber_w(24);
AA_Bamber_e = AA_Bamber_e' - AA_Bamber_e(24);

TIME_Bamber = Bamber_time;

Bamber_ubound_e=AA_Bamber_e+AA_Bamber_e_std';
Bamber_lbound_e=AA_Bamber_e-AA_Bamber_e_std';
Bamber_Conf_Bounds_e = [Bamber_ubound_e; flipud(Bamber_lbound_e); Bamber_ubound_e(1)];
Bamber_ubound_w=AA_Bamber_w+AA_Bamber_w_std';
Bamber_lbound_w=AA_Bamber_w-AA_Bamber_w_std';
Bamber_Conf_Bounds_w = [Bamber_ubound_w; flipud(Bamber_lbound_w); Bamber_ubound_w(1)];
Bamber_Time_Conf_Bounds = [TIME_Bamber; flipud(TIME_Bamber); TIME_Bamber(1)];


%% Read ISMIP6 / PROMICE data for SSP585 and SSP126

%temp = readtable('./ISMIP_Data/20191213_SLE_SIMULATIONS.csv');
temp = readtable('./Data/Tamsinfiles/20201106_SLE_SIMULATIONS_SI.csv');
ISMIP6_data = table2cell(temp);
i_start = find(contains(temp.Properties.VariableNames,'y2015'));
i_end = find(contains(temp.Properties.VariableNames,'y2100'));
TIME_ISMIP = [2015:1:2100]';

j_rcp585_e = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'EAIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP85')));
j_rcp126_e = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'EAIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP26')));
j_rcp585_w = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'WAIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP85')));
j_rcp126_w = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'WAIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP26')));
j_rcp585_p = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'PEN')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP85')));
j_rcp126_p = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'PEN')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP26')));

for jj = 1:length(j_rcp585_e)
   temp_cell (:,jj) = ISMIP6_data(j_rcp585_e(jj),i_start:i_end)';
end
ISMIP_ssp585_EAIS = cell2mat(temp_cell);
clear temp_cell
for jj = 1:length(j_rcp126_e)
   temp_cell (:,jj) = ISMIP6_data(j_rcp126_e(jj),i_start:i_end)';
end
ISMIP_ssp126_EAIS = cell2mat(temp_cell);
clear temp_cell
for jj = 1:length(j_rcp585_w)
   temp_cell (:,jj) = ISMIP6_data(j_rcp585_w(jj),i_start:i_end)';
end
ISMIP_ssp585_WAIS = cell2mat(temp_cell);
clear temp_cell
for jj = 1:length(j_rcp126_w)
   temp_cell (:,jj) = ISMIP6_data(j_rcp126_w(jj),i_start:i_end)';
end
ISMIP_ssp126_WAIS = cell2mat(temp_cell);
clear temp_cell
for jj = 1:length(j_rcp585_p)
   temp_cell (:,jj) = ISMIP6_data(j_rcp585_p(jj),i_start:i_end)';
end
ISMIP_ssp585_PEN = cell2mat(temp_cell);
clear temp_cell
for jj = 1:length(j_rcp126_p)
   temp_cell (:,jj) = ISMIP6_data(j_rcp126_p(jj),i_start:i_end)';
end
ISMIP_ssp126_PEN = cell2mat(temp_cell);
clear temp_cell

ISMIP_ssp585_AIS = ISMIP_ssp585_EAIS + ISMIP_ssp585_WAIS + ISMIP_ssp585_PEN;
ISMIP_ssp126_AIS = ISMIP_ssp126_EAIS + ISMIP_ssp126_WAIS + ISMIP_ssp126_PEN;

% Convert from SLE (mm) to Mass Change (Gt)
ISMIP_ssp585_AIS = ISMIP_ssp585_AIS*(-360)*10;
ISMIP_ssp126_AIS = ISMIP_ssp126_AIS*(-360)*10;
ISMIP_ssp585_EAIS = ISMIP_ssp585_EAIS*(-360)*10;
ISMIP_ssp126_EAIS = ISMIP_ssp126_EAIS*(-360)*10;
ISMIP_ssp585_WAIS = ISMIP_ssp585_WAIS*(-360)*10;
ISMIP_ssp126_WAIS = ISMIP_ssp126_WAIS*(-360)*10;
ISMIP_ssp585_PEN = ISMIP_ssp585_PEN*(-360)*10;
ISMIP_ssp126_PEN = ISMIP_ssp126_PEN*(-360)*10;

ISMIP_AIS_SSP585 = mean(ISMIP_ssp585_AIS,2, 'omitnan');
ISMIP_AIS_SSP126 = mean(ISMIP_ssp126_AIS,2, 'omitnan');
ISMIP_EAIS_SSP585 = mean(ISMIP_ssp585_EAIS,2, 'omitnan');
ISMIP_EAIS_SSP126 = mean(ISMIP_ssp126_EAIS,2, 'omitnan');
ISMIP_WAIS_SSP585 = mean(ISMIP_ssp585_WAIS,2, 'omitnan');
ISMIP_WAIS_SSP126 = mean(ISMIP_ssp126_WAIS,2, 'omitnan');
ISMIP_PEN_SSP585 = mean(ISMIP_ssp585_PEN,2, 'omitnan');
ISMIP_PEN_SSP126 = mean(ISMIP_ssp126_PEN,2, 'omitnan');

ISMIP_AIS_SSP585_std = std(ISMIP_ssp585_AIS,0,2, 'omitnan');
ISMIP_AIS_SSP126_std = std(ISMIP_ssp126_AIS,0,2, 'omitnan');
ISMIP_EAIS_SSP585_std = std(ISMIP_ssp585_EAIS,0,2, 'omitnan');
ISMIP_EAIS_SSP126_std = std(ISMIP_ssp126_EAIS,0,2, 'omitnan');
ISMIP_WAIS_SSP585_std = std(ISMIP_ssp585_WAIS,0,2, 'omitnan');
ISMIP_WAIS_SSP126_std = std(ISMIP_ssp126_WAIS,0,2, 'omitnan');
ISMIP_PEN_SSP585_std = std(ISMIP_ssp585_PEN,0,2, 'omitnan');
ISMIP_PEN_SSP126_std = std(ISMIP_ssp126_PEN,0,2, 'omitnan');

SSP585_ubound=ISMIP_AIS_SSP585+ISMIP_AIS_SSP585_std;
SSP585_lbound=ISMIP_AIS_SSP585-ISMIP_AIS_SSP585_std;
SSP585_Conf_Bounds = [SSP585_ubound; flipud(SSP585_lbound); SSP585_ubound(1)];
SSP585_ubound_e=ISMIP_EAIS_SSP585+ISMIP_EAIS_SSP585_std;
SSP585_lbound_e=ISMIP_EAIS_SSP585-ISMIP_EAIS_SSP585_std;
SSP585_Conf_Bounds_e = [SSP585_ubound_e; flipud(SSP585_lbound_e); SSP585_ubound_e(1)];
SSP585_ubound_w=ISMIP_WAIS_SSP585+ISMIP_WAIS_SSP585_std;
SSP585_lbound_w=ISMIP_WAIS_SSP585-ISMIP_WAIS_SSP585_std;
SSP585_Conf_Bounds_w = [SSP585_ubound_w; flipud(SSP585_lbound_w); SSP585_ubound_w(1)];
SSP585_ubound_p=ISMIP_PEN_SSP585+ISMIP_PEN_SSP585_std;
SSP585_lbound_p=ISMIP_PEN_SSP585-ISMIP_PEN_SSP585_std;
SSP585_Conf_Bounds_p = [SSP585_ubound_p; flipud(SSP585_lbound_p); SSP585_ubound_p(1)];
SSP585_Time_Conf_Bounds = [TIME_ISMIP; flipud(TIME_ISMIP); TIME_ISMIP(1)];

%% Make Plots

color_WAIS = [124 130 130]/255;
color_EAIS = [0 159 0]/255;
color_AP = [0 159 159]/255;

color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

running_mean = 1; % Running mean length in months

%% Make plot without projections


figure('Position', [10 10 600 400])
yyaxis left
patch(OBS_Time_Conf_Bounds(~isnan(OBS_Conf_Bounds)),OBS_Conf_Bounds(~isnan(OBS_Conf_Bounds)),'k', 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
patch(OBS_Time_Conf_Bounds_e,OBS_Conf_Bounds_e,color_EAIS, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
patch(OBS_Time_Conf_Bounds_w,OBS_Conf_Bounds_w,color_WAIS, 'EdgeColor', 'none', 'FaceAlpha', 0.4)
patch(OBS_Time_Conf_Bounds_p,OBS_Conf_Bounds_p,color_AP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(OBS_Time_Conf_Bounds,OBS_Conf_Bounds,'k', 'EdgeColor', 'none', 'FaceAlpha', 0.1)

%patch(Bamber_Time_Conf_Bounds,Bamber_Conf_Bounds_e,color_EAIS, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
%patch(Bamber_Time_Conf_Bounds,Bamber_Conf_Bounds_w,color_WAIS, 'EdgeColor', 'none', 'FaceAlpha', 0.2)

h1=plot(TIME_OBS,AA_Imbie, 'Color', 'k', 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(TIME_OBS_e,AA_Imbie_e, 'Color', color_EAIS, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(TIME_OBS_w,AA_Imbie_w, 'Color', color_WAIS, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(TIME_OBS_p,AA_Imbie_p, 'Color', color_AP, 'LineWidth', width/2,'LineStyle','-','Marker','none')

hold on

h2=plot(TIME_Bamber,AA_Bamber_e+AA_Bamber_w, 'Color', 'k', 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(TIME_Bamber,AA_Bamber_e, 'Color', color_EAIS, 'LineWidth', width/2,'LineStyle','--','Marker','none')
plot(TIME_Bamber,AA_Bamber_w, 'Color', color_AP, 'LineWidth', width/2,'LineStyle',':','Marker','none')
plot(TIME_Bamber,AA_Bamber_w, 'Color', color_WAIS, 'LineWidth', width/2,'LineStyle','--','Marker','none')

xlim([1992 2020])
y_limits=[-1000 3000];
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



txt = {'Total'};
text(1993,2000,txt,'FontSize',14, ...
    'Color', 'k', 'FontWeight', 'bold')
txt = {'AP'};
text(1995,450,txt,'FontSize',14, ...
    'Color', color_AP, 'FontWeight', 'bold')
txt = {'EAIS'};
text(1995,-700,txt,'FontSize',14, ...
    'Color', color_EAIS, 'FontWeight', 'bold')
txt = {'WAIS'};
text(1995,1500,txt,'FontSize',14, ...
    'Color', color_WAIS, 'FontWeight', 'bold')
txt = ['{ \color{black}Bamber \color[rgb]{0 0.62 0.62}AP \color{black}+ \color[rgb]{0.4863 0.51 0.51}WAIS}'];
text(1996,2600,txt,'FontSize',14, 'FontWeight', 'bold','interpreter','tex')

txt = {'Antarctic Mass Change Relative to 2015'};
text(1992.5,3200,txt,'FontSize',20, ...
    'Color', 'k', 'FontWeight', 'bold')
set(gca,'Box', 'off')
set(gca,'TickDir','out');
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

plot([start_year 2100],0*[start_year 2100], 'k:', 'LineWidth', 2)
legend([h1 h2],'IMBIE', 'Bamber','off','Location','west')

%print(gcf,'./PNGs/Regional_Mass_Change_Timeseries.png','-dpng','-r1000', '-painters');


print('-dpng','-r400','../PNGs/AIS_Regional_MB');


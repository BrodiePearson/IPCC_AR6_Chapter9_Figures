%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% read the time series from Rignot et al PNAS2019
% for period 1979-2019 (extended, provided by Eric Rignot)
% Originally: Plot cumulative as in Rignot et al 2019
% Edited: Plot annual means
% Discharge = input/output; SMB from Racmo2.3; MB = SMB-D
% 
% scripts modified: Vincent Favier, Irina Gorodetskaya
% Scripts modified; Baylor Fox-Kemper

%%
clear
close all

addpath ./Functions/
addpath ../../../Functions/
%addpath /Users/irou/Applications/MATLAB/mylibs/kul/giv
%addpath(genpath('/Users/irou/Applications/MATLAB/mylibs/kul/web/boundedline-pkg-master'));

%% IPCC Color scheme
Zemp_shading = [0.5020 0.5020 0.5020]; %Obs uncertainty
Zemp_line = [0 0 0]; % Obs.
RCP26_shading = [0.2627 0.5765 0.7647]; % RCP 2.6 uncertainty
RCP85_shading = [0.9882 0.8196 0.7725]; % RCP 8.5 uncertainty
RCP26_line = [0.0000 0.2039 0.4000]; % RCP 2.6
RCP85_line = [0.6000 0 0.0078]; % RCP 2.6
Mankoff_shading = [0.200 0.4 0.6];
Mankoff_line = [0.2000 0 0.0078]  ; 
King_shading = [0.1 0.5 0.7];
King_line = [0.1000 0 0.8]   ;


%% Get IMBIE Data, anomalize, and calculate error envelopes
%% Define IMBIE regional data 

% IMBIE_data0=xlsread('IMBIE_latest/IMBIE_AR6.xlsx');
% 
% % Extract IMBIE Cumulative mass change (in Gt)
% IMBIE_time = IMBIE_data0(:,1);
% IMBIE_data = IMBIE_data0(:,9);       % No longer revert to IMBIE-2
% IMBIE_data_std = IMBIE_data0(:,10);
% % Convert IMBIE Cumulative sea level equivalent (in mm)
% IMBIE_data_sl = IMBIE_data*(-362.5);
% IMBIE_data_sl_std = IMBIE_data_std*(-362.5);

%% Define IMBIE regional data (no longer dummy datasets)

IMBIE_data=csvread('Data/IMBIE_latest/ais.csv');

%IMBIE_data_p=xlsread('AISregions/imbie_dataset-2018_07_23.xlsx','Antarctic Peninsula');

IMBIE_time = IMBIE_data(:,1);
AA_Imbie = IMBIE_data(:,2);
% AA_Imbie = AA_Imbie - AA_Imbie(277); % Baseline 2015
AA_Imbie_unc = IMBIE_data(:,3);
TIME_OBS = IMBIE_data(:,1);

% OBS_ubound=AA_Imbie+AA_Imbie_unc;
% OBS_lbound=AA_Imbie-AA_Imbie_unc;
% OBS_Conf_Bounds = [OBS_ubound; flipud(OBS_lbound); OBS_ubound(1)];
% OBS_Time_Conf_Bounds = [TIME_OBS; flipud(TIME_OBS); TIME_OBS(1)];

IMBIE_data_p=csvread('Data/IMBIE_latest/apis.csv');

%IMBIE_data_p=xlsread('AISregions/imbie_dataset-2018_07_23.xlsx','Antarctic Peninsula');

AA_Imbie_p = IMBIE_data_p(1:348,2);
%AA_Imbie_p = AA_Imbie_p - AA_Imbie_p(277); % Baseline 2015--not needed for
%annual rates
AA_Imbie_p_unc = IMBIE_data_p(1:348,3);
TIME_OBS_p = IMBIE_data_p(1:348,1);

% OBS_ubound_p=AA_Imbie_p+AA_Imbie_p_unc;
% OBS_lbound_p=AA_Imbie_p-AA_Imbie_p_unc;
% OBS_Conf_Bounds_p = [OBS_ubound_p; flipud(OBS_lbound_p); OBS_ubound_p(1)];
% OBS_Time_Conf_Bounds_p = [TIME_OBS_p; flipud(TIME_OBS_p); TIME_OBS_p(1)];

IMBIE_data_e=csvread('Data/IMBIE_latest/eais.csv');
%IMBIE_data_e=xlsread('AISregions/imbie_dataset-2018_07_23.xlsx','East Antarctica');

AA_Imbie_e = IMBIE_data_e(1:348,2);
%AA_Imbie_e = AA_Imbie_e - AA_Imbie_e(277);
AA_Imbie_e_unc = IMBIE_data_e(1:348,3);
TIME_OBS_e = IMBIE_data_e(1:348,1);

% OBS_ubound_e=AA_Imbie_e+AA_Imbie_e_unc;
% OBS_lbound_e=AA_Imbie_e-AA_Imbie_e_unc;
% OBS_Conf_Bounds_e = [OBS_ubound_e; flipud(OBS_lbound_e); OBS_ubound_e(1)];
% OBS_Time_Conf_Bounds_e = [TIME_OBS_e; flipud(TIME_OBS_e); TIME_OBS_e(1)];

IMBIE_data_w=csvread('Data/IMBIE_latest/wais.csv');
%IMBIE_data_w=xlsread('AISregions/imbie_dataset-2018_07_23.xlsx','West Antarctica');

AA_Imbie_w = IMBIE_data_w(1:348,2);
%AA_Imbie_w = AA_Imbie_w - AA_Imbie_w(277);
AA_Imbie_w_unc = IMBIE_data_w(1:348,3);
TIME_OBS_w = IMBIE_data_w(1:348,1);

% OBS_ubound_w=AA_Imbie_w+AA_Imbie_w_unc;
% OBS_lbound_w=AA_Imbie_w-AA_Imbie_w_unc;
% OBS_Conf_Bounds_w = [OBS_ubound_w; flipud(OBS_lbound_w); OBS_ubound_w(1)];
% OBS_Time_Conf_Bounds_w = [TIME_OBS_w; flipud(TIME_OBS_w); TIME_OBS_w(1)];

%AA_Imbie = IMBIE_data;
%AA_Imbie = AA_Imbie - AA_Imbie(277);
%AA_Imbie_unc = IMBIE_data_std;
%TIME_OBS = IMBIE_time;

OBS_ubound=AA_Imbie+AA_Imbie_unc;
OBS_lbound=AA_Imbie-AA_Imbie_unc;
OBS_Conf_Bounds = [OBS_ubound; flipud(OBS_lbound); OBS_ubound(1)];
OBS_Time_Conf_Bounds = [TIME_OBS; flipud(TIME_OBS); TIME_OBS(1)];

% add Bamber data
% 
% T = readtable('../Fig9_18_AIS_synth/Fig_MB_Antarctic_Timeseries/Bamber-etal_2018_readme.dat');
% Bamber_data=table2array(T);
% Bamber_time = Bamber_data(:,1);
% Bamber_data_w = Bamber_data(:,4);
% Bamber_data_w_std = Bamber_data(:,5);
% Bamber_data_e = Bamber_data(:,6);
% Bamber_data_e_std = Bamber_data(:,7);
% 
% Bamber_data_t = Bamber_data_w+Bamber_data_e;
% Bamber_data_t_std = sqrt(Bamber_data_w_std.^2+Bamber_data_e_std);

regionnames = {'WAIS' 'EAIS' 'AP' 'Antarctica'}
regioncolors = {[124 130 130]/255 [0 159 0]/255 [0 159 159]/255 [1 1 1]}
 
% Data files:
for j = 0:1:3
    
%% Position vectors 
% for a figure of 180 mm width and 250 mm height
figSize = [1 1 32/4 16/4];
% set size and position
set(gcf,'units','centimeters','position',figSize,'paperposition',figSize);

%grid on
set(gca, 'XTick',[datenum(datetime(1980,1,1)) datenum(datetime(1990,1,1)) datenum(datetime(2000,1,1)) ...
    datenum(datetime(2010,1,1)) datenum(datetime(2020,1,1))],...
    'Xlim', [datenum(datetime(1972,1,1)) datenum(datetime(2020,1,1))])
box on

    
    
if (j==0)
file_RIGNOT='Data/IrinaFigs/FigureMB_Antarctica/West.xlsx'
elseif (j==1)
file_RIGNOT='Data/IrinaFigs/FigureMB_Antarctica/East.xlsx'
elseif (j==2)
file_RIGNOT='Data/IrinaFigs/FigureMB_Antarctica/Peninsula.xlsx'
elseif (j==3)    
file_RIGNOT='Data/IrinaFigs/FigureMB_Antarctica/Antarctica.xlsx'
end

% Load data:

time=xlsread(file_RIGNOT,'Rignot','A2:A489');

year=floor(time);
month=(time-year)*12;
RIGNOT_time0=x2mdate(time);
%RIGNOT_time=(RIGNOT_time0(19:12:end));

% Loading in the monthly data
clear RIGNOT_MB RIGNOT_SMB RIGNOT_D

%RIGNOT_MB(:,1)=xlsread(file_RIGNOT,'Rignot','B2:B489');
%RIGNOT_MB(:,2)=xlsread(file_RIGNOT,'Rignot','C2:C489');
RIGNOT_MB(:,1)=xlsread(file_RIGNOT,'Rignot','F2:F489'); %These are incorrectly labeled in the xls file.
RIGNOT_MB(:,2)=xlsread(file_RIGNOT,'Rignot','G2:G489');


[RIGNOT_MBa_time,RIGNOT_MBa,RIGNOT_MBa_unc]=invcumul(RIGNOT_time0(:)/365,RIGNOT_MB(:,1),RIGNOT_MB(:,2));  % Time is in years here, for annual rates

%[IMBIE_MBa_time,IMBIE_MBa,IMBIE_MBa_unc]=invcumul(IMBIE_time,IMBIE_data,IMBIE_data_std); % This is back converting from cumulative

IMBIE_MBa_time=IMBIE_time;

if (j==0)
IMBIE_MBa=AA_Imbie_w;
IMBIE_MBa_unc=AA_Imbie_w_unc;
elseif (j==1)
IMBIE_MBa=AA_Imbie_e;
IMBIE_MBa_unc=AA_Imbie_e_unc;
elseif (j==2)
IMBIE_MBa=AA_Imbie_p;
IMBIE_MBa_unc=AA_Imbie_p_unc;
elseif (j==3)    
IMBIE_MBa=AA_Imbie;
IMBIE_MBa_unc=AA_Imbie_unc;
end


RIGNOT_SMB(:,1)=xlsread(file_RIGNOT,'Rignot','D2:D489');
RIGNOT_SMB(:,2)=xlsread(file_RIGNOT,'Rignot','E2:E489');

[RIGNOT_SMBa_time,RIGNOT_SMBa,RIGNOT_SMBa_unc]=invcumul(RIGNOT_time0(:)/365,RIGNOT_SMB(:,1),RIGNOT_SMB(:,2));  % Time is in years here, for annual rates

%RIGNOT_D(:,1)=xlsread(file_RIGNOT,'Rignot','F2:F489');
%RIGNOT_D(:,2)=xlsread(file_RIGNOT,'Rignot','G2:G489');
RIGNOT_D(:,1)=xlsread(file_RIGNOT,'Rignot','B2:B489');  %These are incorrectly labeled in the xls file.
RIGNOT_D(:,2)=xlsread(file_RIGNOT,'Rignot','C2:C489');

[RIGNOT_Da_time,RIGNOT_Da,RIGNOT_Da_unc]=invcumul(RIGNOT_time0(:)/365,RIGNOT_D(:,1),RIGNOT_D(:,2));  % Time is in years here, for annual rates

% Converting from Cumulative to Annual Rates, following Matt Palmer code.

% Outer loop is year by year
% for ii=1:length(RIGNOT_time)
%     ii
%     % Inner loop is months of the year.  Initialize series and error to 0.
%     sumMB=RIGNOT_MB(12*(ii-1)+7+(1:13),1)-RIGNOT_MB(12*(ii-1)+8,1);
%     errMB=RIGNOT_MB(12*(ii-1)+7+(1:13),2)-RIGNOT_MB(12*(ii-1)+8,2);
%     sumSMB=RIGNOT_SMB(12*(ii-1)+7+(1:13),1)-RIGNOT_SMB(12*(ii-1)+8,1);
%     errSMB=RIGNOT_SMB(12*(ii-1)+7+(1:13),2)-RIGNOT_SMB(12*(ii-1)+8,2);
%     sumD=RIGNOT_D(12*(ii-1)+7+(1:13),1)-RIGNOT_D(12*(ii-1)+8,1);
%     errD=RIGNOT_D(12*(ii-1)+7+(1:13),2)-RIGNOT_D(12*(ii-1)+8,2);
%           
%     RIGNOT_MBa(ii,:)=mean(RIGNOT_MB(12*(ii-1)+7+(2:13),1));
%     RIGNOT_SMBa(ii,:)=mean(RIGNOT_SMB(12*(ii-1)+7+(2:13),1));
%     RIGNOT_Da(ii,:)=mean(RIGNOT_D(12*(ii-1)+7+(2:13),1));
%     RIGNOT_MB0(ii,1)=sumMB(end);
%     RIGNOT_SMB0(ii,1)=sumSMB(end);
%     RIGNOT_D0(ii,1)=sumD(end);
%     RIGNOT_MB0(ii,2)=errMB(end);
%     RIGNOT_SMB0(ii,2)=errSMB(end);
%     RIGNOT_D0(ii,2)=errD(end);
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot time series in Gt a-1 with uncertainty range     figure(1)

ylabel(['Mass Change Rate (Gt a^{-1})'],'FontSize',20,'FontWeight','Bold','Color',cell2mat(regioncolors(j+1)));
% xticks([1980:10:2020])

% Title of each subplot
title(cell2mat(regionnames(j+1)),'FontSize',20,'FontWeight','Bold','Color',cell2mat(regioncolors(j+1))) 

x=RIGNOT_time0(:);
y1=RIGNOT_Da;
e1=RIGNOT_Da_unc;

y2=RIGNOT_SMBa;
e2=RIGNOT_SMBa_unc;

y3=RIGNOT_MBa;
e3=RIGNOT_MBa_unc;

x4=IMBIE_time*365;
y4=IMBIE_MBa;
e4=IMBIE_MBa_unc;

if j==0 %west
y4=AA_Imbie_w;
e4=AA_Imbie_w_unc;
elseif j==1 %east
y4=AA_Imbie_e;
e4=AA_Imbie_e_unc
elseif j==2 %peninsula
y4=AA_Imbie_p;
e4=AA_Imbie_p_unc    
elseif j==3 %total
y4=AA_Imbie;
e4=AA_Imbie_unc
end

map = [0 0 1;.4 0 .4;1 0 0;0 0 0];
map = [0 0 1;.7 .7 .2;1 0 0;0 0 0];
rsmb = boundedline(x, y2, e2, '-', 'cmap', map(1,:), 'alpha', 'transparency',0.2); %SMB is blue
hold on
rd = boundedline(x, y1, e1, '-', 'cmap', map(2,:), 'alpha', 'transparency',0.2); %Discharge is purple
hold on
rmb = boundedline(x, y3, e3, '-', 'cmap', map(3,:), 'alpha', 'transparency',0.2); %mass is red
hold on
imb = boundedline(x4, y4, e4, '-', 'cmap', map(4,:), 'alpha', 'transparency',0.2);

if j==1
%hbamb = boundedline(datenum(Bamber_time,1,1), Bamber_data_e, Bamber_data_e_std, '-', 'cmap', [230, 159, 0]./255, 'alpha', 'transparency',.4);
end
if j==3
%hbamb = boundedline(datenum(Bamber_time,1,1), Bamber_data_t, Bamber_data_t_std, '-', 'cmap', [230, 159, 0]./255, 'alpha', 'transparency',.4);
end

set(gca, 'XTick',[datenum(datetime(1980,1,1)) datenum(datetime(2000,1,1)) datenum(datetime(2020,1,1))],...
    'Xlim', [datenum(datetime(1980,1,1)) datenum(datetime(2020,1,1))])

datetick('x','yyyy','keeplimits')
set(gca,'FontSize',16)

print(gcf,['../PNGs/AIS_region_',num2str(j+1),'.png'],'-dpng','-r400', '-painters');

if j==3
%legend([rmb rsmb rd hbamb],'Rignot MB','Rignot SMB','Rignot Discharge','Bamber MB','FontSize',14,'Location','SouthWest','Box','off')
legend([rmb imb rsmb rd],'Rignot MB','IMBIE MB','Rignot SMB','Rignot Discharge','FontSize',14,'Location','SouthWest','Box','on')
print(gcf,['../PNGs/AISlegend.png'],'-dpng','-r400', '-painters');
end
close all
end









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% read the time series from Rignot et al PNAS2019
% for period 1979-2019 (extended, provided by Eric Rignot)
% Plot cumulative as in Rignot et al 2019
% Discharge = input/output; SMB from Racmo2.3; MB = SMB-D
% 
% scripts modified: Vincent Favier, Irina Gorodetskaya

%%
clear all
close all

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

%% Position vectors 
% for a figure of 180 mm width and 250 mm height
figure(2)
w_fig = 140; 
h_fig = 140; 

% To be change to improve the size of subplots and margins
bot_line =15; % bottom space
sep_v =20; % vertical separation between subplots
sep_h = 20; % horizontal separation between subplots
left_line =15; % left margin

w = 50; % width of the subplot
h = 50; % height of the subplot

% Create the Position vector 
bottom =[(1*h+sep_v+ bot_line);bot_line;bot_line;(1*h+sep_v+ bot_line)];
                
left = [left_line;left_line;(1*w+sep_h+left_line);(1*w+sep_h+left_line)];
     
w7 = w.*ones(4,1);
h7 = h.*ones(4,1); 

%position vector [left, bottom,width,height]./normalized
position_plots = [left./w_fig bottom./h_fig w7./w_fig h7./h_fig];

regionnames = {'WAIS' 'EAIS' 'AP' 'Antarctica'}
 
% Data files:
for j = 0:1:3
if (j==0)
file_RIGNOT='West.xlsx'
elseif (j==1)
file_RIGNOT='East.xlsx'
elseif (j==2)
file_RIGNOT='Peninsula.xlsx'
elseif (j==3)    
file_RIGNOT='Antarctica.xlsx'
end

% Load data:

time=xlsread(file_RIGNOT,'Rignot','A2:A489');

year=floor(time);
month=(time-year)*12;
RIGNOT_time=x2mdate(time);

RIGNOT_MB(:,1)=xlsread(file_RIGNOT,'Rignot','B2:B489');
RIGNOT_MB(:,2)=xlsread(file_RIGNOT,'Rignot','C2:C489');

RIGNOT_SMB(:,1)=xlsread(file_RIGNOT,'Rignot','D2:D489');
RIGNOT_SMB(:,2)=xlsread(file_RIGNOT,'Rignot','E2:E489');

RIGNOT_D(:,1)=xlsread(file_RIGNOT,'Rignot','F2:F489');
RIGNOT_D(:,2)=xlsread(file_RIGNOT,'Rignot','G2:G489');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot time series in Gt a-1 with uncertainty range     figure(1)
%4 subplots, 3 regions and total Antarcitca in top right corner

  %size of figure defined by IPCC visual style guide [cm]
     figSize = [1 1 20 20]; 
     % set size and position
     set(gcf,'units','centimeters','position',figSize,'paperposition',figSize);
     % subplot positions
     subplot('Position',position_plots(j+1,:) ) 

ylabel(['Mass Change (Gt a-1)'],'FontSize',9,'FontWeight','Bold');
% xticks([1980:10:2020])

% Title of each subplot
title(cell2mat(regionnames(j+1)),'FontSize',9,'FontWeight','Bold') ;

x=RIGNOT_time;
y1=RIGNOT_D(:,1);
e1=RIGNOT_D(:,2);
hold on

y2=RIGNOT_SMB(:,1);
e2=RIGNOT_SMB(:,2);
hold on

y3=RIGNOT_MB(:,1);
e3=RIGNOT_MB(:,2);

map = [0 0 1;.4 0 .4;1 0 0];
[l,p] = boundedline(x, y2, e2, '-', x, y1, e1, '-', x, y3, e3, '-', 'cmap', map, 'alpha', 'transparency',0.4);

% add Bamber data; IMBIE 

grid on

set(gca, 'XTick',[datenum(datetime(1980,1,1)) datenum(datetime(2000,1,1)) datenum(datetime(2020,1,1))],...
    'Xlim', [datenum(datetime(1980,1,1)) datenum(datetime(2020,1,1))])

datetick('x','yyyy','keeplimits')
xlabel('Years','FontSize',8,'FontWeight','Bold')

legend('Rignot SMB','Rignot D','Rignot MB','FontSize',14,'Location','SouthWest','Box','off')


end

  % save figure:
fileplot= 'Antarctica_Rignot_1979-2019';
fileplot_png = [fileplot '.png'];
print('-dpng', '-r300', fileplot_png) 








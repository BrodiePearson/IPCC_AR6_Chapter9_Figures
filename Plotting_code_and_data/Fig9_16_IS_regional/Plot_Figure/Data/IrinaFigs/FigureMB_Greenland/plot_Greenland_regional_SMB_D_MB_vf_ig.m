%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot Greenland observation data, start with results of
%Mouginot et al 2019 for the period 1972-2018, he sent excel file in September 2019
%add Bamber, IMBIE should also be added
% 
% original scripts: Tolly Adalgeirsdottir
% scripts modified: Vincent Favier, Irina Gorodetskaya
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clear all
close all

%addpath /Users/irou/Applications/MATLAB/mylibs/kul/giv

%addpath(genpath('/Users/irou/Applications/MATLAB/mylibs/kul/web/boundedline-pkg-master'));

%cfigure(40,30)
%% IPCC Color scheme
Zemp_shading = [0.5020 0.5020 0.5020]; %Obs uncertainty
Zemp_line = [0 0 0]; % Obs.
RCP26_shading = [0.2627 0.5765 0.7647]; % RCP 2.6 uncertainty
RCP85_shading = [0.9882 0.8196 0.7725]; % RCP 8.5 uncertainty
RCP26_line = [0.0000 0.2039 0.4000]; % RCP 2.6
RCP85_line = [0.6000 0 0.0078]; % RCP 2.6
Mankoff_shading = [0.200 0.4 0.6]
Mankoff_line = [0.2000 0 0.0078]   
King_shading = [0.1 0.5 0.7]
King_line = [0.1000 0 0.8]   

pwd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load the .mat file from Mankoff D data, see read_sort_Mankoff.m
load('Mankoff.mat');
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load the .mat file for Mouginot data, see read_sort_Mouginot.m
load('Mouginot_MB.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load the .mat file for King data, see read_sort_King.m
load('King_reg.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load the RCM_SMB.mat file for all the RCMs
load('RCM_SMB.mat');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot the regional figure

%% Position vectors 
% for a figure of 180 mm width and 250 mm height
w_fig = 180; 
h_fig = 250; 

% To be change to improve the size of subplots and margins
bot_line =15; % bottom space
sep_v =10; % vertical separation between subplots
sep_h = 10; % horizontal separation between subplots
left_line =15; % left margin

w = 50; % width of the subplot
h = 47.5; % height of the subplot

% Create the Position vector 
bottom =[bot_line;(1*h+1*sep_v+bot_line);(2*h+2*sep_v+bot_line);(3*h+3*sep_v+bot_line);...
		 (2*h+2*sep_v+bot_line);(1*h+1*sep_v+bot_line);bot_line];
                
left = [left_line;left_line;left_line;left_line;(2*w+sep_h+left_line);...               
	 (2*w+sep_h+left_line);(2*w+sep_h+left_line)];

     
w7 = w.*ones(7,1);
h7 = h.*ones(7,1); 

%position vector [left, bottom,width,height]./normalized
position_plots = [left./w_fig bottom./h_fig w7./w_fig h7./h_fig];

regionnames = {'Southwest (SW)' 'Central West (CW)' 'Northwest (NW)' 'North (NO)' 'Northeast (NE)' 'Central East (CE)' 'Southeast (SE)'}
%time_err=[time time(end:-1:1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot time series in Gt a-1 with uncertainty range     figure(1)
  for j = 0:1:6  %8 subplots, 7 regions and total GIS in top right corner
  %size of figure defined by IPCC visual style guide [cm]
     figSize = [1 1 18 25]; 
     % set size and position
     set(gcf,'units','centimeters','position',figSize,'paperposition',figSize);
     % subplot positions
     subplot('Position',position_plots(j+1,:) ) 

grid on
set(gca, 'XTick',[datenum(datetime(1980,1,1)) datenum(datetime(1990,1,1)) datenum(datetime(2000,1,1)) ...
    datenum(datetime(2010,1,1)) datenum(datetime(2020,1,1))],...
    'Xlim', [datenum(datetime(1972,1,1)) datenum(datetime(2020,1,1))])
box on

%%
%SMBcolor = [1,1,0]
SMBcolor = [0.5,0.5,0.5];
SMBblack = [0 0 0];

  hold on
 
      
X = Wilton_time
Y = Wilton_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);

%%
hold on							
X = Zolles_time
Y = Zolles_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);

%%
hold on							
X = Fettweis_time
Y = Fettweis_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);


%%
hold on							
X = ENS_time
Y = ENS_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);


%%
hold on							
X = Krebs_time
Y = Krebs_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);


%%
hold on							
X = Box_time
Y = Box_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);


%%
hold on							
X = Berends_time
Y = Berends_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);


%%
hold on							
X = Hanna_time
Y = Hanna_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);


%%
hold on							
X = Liston_time
Y = Liston_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);
% plot(datenum(X),Y(:,j+2),'Color',SMBblack,'LineWidth',4);
% mt = 'Liston'

%%
hold on							
X = Noel_time
Y = Noel_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);


%%
hold on							
X = Niwano_time
Y = Niwano_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);


%%
hold on							
X = Mottram_time
Y = Mottram_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);


%%
hold on							
X = Kampenhout_time
Y = Kampenhout_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);


%%
hold on							
X = Kapsch_time
Y = Kapsch_SMB
plot(datenum(X),Y(:,j+2),'Color',SMBcolor,'LineWidth',1);

y4 = min([Wilton_SMB(:,j+2) Zolles_SMB(:,j+2) Fettweis_SMB(:,j+2) ENS_SMB(:,j+2) ...
     Krebs_SMB(:,j+2) Box_SMB(:,j+2) Berends_SMB(:,j+2) Hanna_SMB(:,j+2) Liston_SMB(:,j+2) ...
     Noel_SMB(:,j+2) Niwano_SMB(:,j+2) Mottram_SMB(:,j+2) Kampenhout_SMB(:,j+2) Kapsch_SMB(:,j+2)])


%%
x=datenum(Mouginot_time);
y3=Mouginot_Reg_MB(:,j*2+1);
e3=Mouginot_Reg_MB(:,j*2+2);
hold on

y1=-Mouginot_Reg_D(:,j*2+1);
e1=Mouginot_Reg_D(:,j*2+2);
hold on

y2=Mouginot_Reg_SMB(:,j*2+1);
e2=Mouginot_Reg_SMB(:,j*2+2);
map = [0 0 1;.4 0 .4;1 0 0];

%%
[l,p] = boundedline(x, y2', e2', '-', x, y1', e1', '-', x, y3', e3', '-', 'cmap', map, 'alpha', 'transparency',0.4);

map = [.2 .7 .7;.7 .7 .2;.3 .3 .3];

%%
datetick('x','yyyy','keeplimits')
x1 = datenum(Mankoff_D_time);
y1=-Mankoff_D(:,j*2+1);
e1=Mankoff_D(:,j*2+2);

%%
x2 = datenum(King_time);
y2=-King_reg_D(:,j*2+1);
e2=King_reg_D(:,j*2+2);
[l,p] = boundedline(x1, y1', e1', '-', x2, y2', e2', '-', 'cmap', map, 'alpha', 'transparency',0.4);

%%
ylabel(['Mass Change (Gt a-1)'],'FontSize',9,'FontWeight','Bold');
if j==0 || j==6
xlabel('Years','FontSize',8,'FontWeight','Bold')
  end
% Title of each subplot
title(cell2mat(regionnames(j+1)),'FontSize',9,'FontWeight','Bold') 

%%
 A=[min(y1) min(y2) min(y3) y4];
y4 = max([Wilton_SMB(:,j+2) Zolles_SMB(:,j+2) Fettweis_SMB(:,j+2) ENS_SMB(:,j+2) ...
     Krebs_SMB(:,j+2) Box_SMB(:,j+2) Berends_SMB(:,j+2) Hanna_SMB(:,j+2) Liston_SMB(:,j+2) ...
     Noel_SMB(:,j+2) Niwano_SMB(:,j+2) Mottram_SMB(:,j+2) Kampenhout_SMB(:,j+2) Kapsch_SMB(:,j+2)])

 B = [max(y1) max(y2) max(y3) y4];
set(gca, 'Ylim', [1.2*min(A) 1.2*max(B)]) ;

  end

 
 %% 
%plot total Greenland time series in top right corner
pos_GIS=[(2*w+sep_h+left_line)/w_fig (3*h+3*sep_v+bot_line)/h_fig w/w_fig h/h_fig]
subplot('Position',pos_GIS)
grid on
set(gca, 'XTick',[datenum(datetime(1980,1,1)) datenum(datetime(1990,1,1)) datenum(datetime(2000,1,1)) ...
    datenum(datetime(2010,1,1)) datenum(datetime(2020,1,1))],...
    'Xlim', [datenum(datetime(1972,1,1)) datenum(datetime(2020,1,1))])

%upper curve of uncertainty:
%%
X = Wilton_time
Y = Wilton_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);

hold on							
X = Zolles_time
Y = Zolles_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);

hold on							
X = Fettweis_time
Y = Fettweis_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);

hold on							
X = ENS_time
Y = ENS_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);


hold on							
X = Krebs_time
Y = Krebs_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);

hold on							
X = Box_time
Y = Box_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);

hold on							
X = Berends_time
Y = Berends_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);


hold on							
X = Hanna_time
Y = Hanna_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);

hold on							
X = Liston_time
Y = Liston_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);
% plot(datenum(X),Y(:,1),'Color',SMBblack,'LineWidth',4);
% mt = 'Liston'

hold on							
X = Noel_time
Y = Noel_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);

hold on							
X = Niwano_time
Y = Niwano_SMB

hold on							
X = Mottram_time
Y = Mottram_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);

hold on							
X = Kampenhout_time
Y = Kampenhout_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);

hold on							
X = Kapsch_time
Y = Kapsch_SMB
plot(datenum(X),Y(:,1),'Color',SMBcolor,'LineWidth',1);

%%
x=datenum(Mouginot_time);
y3=Mouginot_MB(:,1);
e3=Mouginot_MB(:,2);
hold on

y1=-Mouginot_D(:,1);
e1=Mouginot_D(:,2);
hold on

%%
y2=Mouginot_SMB(:,1);
e2=Mouginot_SMB(:,2);
map = [0 0 1;.4 0 .4;1 0 0]
A=[min(y1) min(y2) min(y3)];
set(gca, 'Ylim', [1.2*min(A) 1.2*max(y2)]) ;
box on
[l,p] = boundedline(x, y2', e2', '-', x, y1', e1', '-', x, y3', e3', '-', 'cmap', map, 'alpha', 'transparency',0.4);
 
map = [.2 .7 .7;.7 .7 .2;.3 .3 .3];

datetick('x','yyyy','keeplimits')
x1 = datenum(Mankoff_D_time);
y11 = -M_D_total;
e11 = M_D_err;

x2 = datenum(King_time);
y22 = -King_D;
e22 = King_D_err;

file_Bamber='Bamber-etal_2018.dat'
%   Bamber=readmatrix(file_Bamber);
Bamber=dlmread(file_Bamber);
Bamber_time=datetime(Bamber(:,1),ones(25,1)*7,ones(25,1));

%%
x3 = datenum(Bamber_time);
y33 = Bamber(:,2);
e33 = Bamber(:,3);

[l,p] = boundedline(x1, y11', e11', '-', x2, y22', e22', '-', x3, y33', e33', '-', 'cmap', map, 'alpha', 'transparency',0.4);

  hold on							

ylabel(['Mass Change (Gt a-1)'],'FontSize',9,'FontWeight','Bold');
%xlabel('Years','FontSize',8,'FontWeight','Bold')
% Title of each subplot

title('Greenland Ice Sheet (GIS)','FontSize',9,'FontWeight','Bold')

OUTPATH_plot = './';
fileplot= [OUTPATH_plot 'Greenland_Regions_MB_D_SMB_']
fileplot_png = [fileplot '.png'];    
  print('-dpng', fileplot_png) 

%%
figure
%upper curve of uncertainty:
y1_G=Mouginot_MB(:,1)+Mouginot_MB(:,2)
%lower curve of uncertainty:
y2_G=Mouginot_MB(:,1)-Mouginot_MB(:,2)
 shade_plot_function(datenum(Mouginot_time),y1_G',y2_G',Zemp_shading);
hold on
plot(datenum(Mouginot_time),Mouginot_MB(:,1),'Color',Zemp_line,'LineWidth',2);
hold on							
shade_plot_function(datenum(Mankoff_D_time),-(M_D_total+M_D_err)',-(M_D_total-M_D_err)',RCP26_shading);
hold on
plot(datenum(Mankoff_D_time),-M_D_total,'g','LineWidth',2);
hold on
 shade_plot_function(datenum(Mouginot_time),-(Mouginot_D(:,1)+Mouginot_D(:,2))',-(Mouginot_D(:,1)-Mouginot_D(:,2))',RCP26_shading);
hold on
plot(datenum(Mouginot_time),-Mouginot_D(:,1),'Color',RCP26_line,'LineWidth',2);
hold on
 shade_plot_function(datenum(Mouginot_time),(Mouginot_SMB(:,1)+Mouginot_SMB(:,2))',(Mouginot_SMB(:,1)-Mouginot_SMB(:,2))',RCP85_shading);
hold on
plot(datenum(Mouginot_time),Mouginot_SMB(:,1),'Color',RCP85_line,'LineWidth',2);

hold on
 shade_plot_function(datenum(King_time),-(King_D+King_D_err)',-(King_D-King_D_err)',King_shading);
hold on
plot(datenum(King_time),-King_D,'m','LineWidth',2);
hold on

%%
shade_plot_function(datenum(Bamber_time),(Bamber(:,2)+Bamber(:,3))',(Bamber(:,2)-Bamber(:,3))',Zemp_shading);
hold on
plot(datenum(Bamber_time),Bamber(:,2),'r','LineWidth',2);							
 datetick('x','yyyy','keeplimits')
hold off

% Save figure with title showing highlighted SMB model:

OUTPATH_plot = './';
fileplot= [OUTPATH_plot 'Greenland_MB_D_SMB_']
fileplot_png = [fileplot '.png'];    
  print('-dpng', fileplot_png)        



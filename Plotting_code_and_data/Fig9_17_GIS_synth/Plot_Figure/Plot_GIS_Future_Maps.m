%% IPCC AR6 Chapter 9: Figure 9.17 (Greenland Synthesis)
%
% Code used to plot maps of projected Greenland Ice Sheet changes. 
%
% Plotting code written by Baylor Fox-Kemper
% Processed data provided by Sophie?
% Other datasets cited in report/caption

close all

addpath ../../../Functions/

fname='./Processed_Data/dHdt_GIS_B19_LL.nc'
 readncfile
 
 rate=IPCC_Get_Colorbar('cryo_d');
 
 [LAT,LON]=meshgrid(lat,lon);
 
 % Bamber are in m/yr??, I think...
 
 IPCC_Plot_Polar(dHdt,LAT,LON,[-1 1],rate,'Observations\newline  (2010-2017)',1,2,25,0);

 h1=figure(1);
 print(h1,'../PNGs/BamberdHdt.png','-dpng','-r1000', '-painters');
 
 fname='./Processed_Data/GIS_mean_F.nc'
 
 readncfile
 
 GIS_Mean0=GIS_Mean;
 
 LAT2=double(lat);
 LON2=double(lon);
% GIS_Mean1=GIS_Mean;  %/40*7; this factor makes them more akin... 
 
 clear GIS_Mean
 
  % ISMIP6 are in m/yr.
 
 IPCC_Plot_Polar(GIS_Mean0,LAT2,LON2,[-1 1],rate,'ISMIP6 Model Mean\newline   (2093-2100)',4,2,25,1,'Elevation Change (m/yr)');

 % ISMIP6 are in m/yr.
 
 h2=figure(2);
 print(h2,'../PNGs/ISMIP6dHdt.png','-dpng','-r1000', '-painters');
 
 
 h3=figure(3);
 %This doesn't appear to plot anything...
 %print(h1,'BamberdHdt.png','-dpng','-r1000', '-painters');
 
 
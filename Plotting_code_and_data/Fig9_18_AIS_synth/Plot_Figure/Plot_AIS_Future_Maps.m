%% IPCC AR6 Chapter 9: Figure 9.18 (Antarctic Synthesis)
%
% Code used to plot polar maps of projected Antarctic changes
%
% Plotting code written by Baylor Fox-Kemper
% Processed data provided by Sophie?
% Other datasets cited in report/caption

close all

addpath ../../../Functions/

fname='./Processed_Data/dHdt_AIS_B19_LL.nc'
 readncfile
 
 rate=IPCC_Get_Colorbar('cryo_d');
 
 [LAT,LON]=meshgrid(lat,lon);
 
 % Bamber are in m/yr??, I think...
 
 IPCC_Plot_Polar(dHdt,LAT,LON,[-1 1],rate,'Observations \newline   (1992-2016)',1,-2,25,1,'Elevation Change (m/yr)');

 h1=figure(1);
 saveas(h1,'../PNGs/BamberdHdt','png');
 
% fname='AISmeanF.nc'
% fname='../AIS_RCP8.5_2061-2100/AIS_mean_RCP8.5_2061_2100.nc'
% fname='../SophieNData/AIS_mean_masked.nc'
 fname='./Processed_Data/AIS_mean_masked_v2.nc'
 
 readncfile
 
 LAT2=double(lat);
 LON2=double(lon);
 
  % ISMIP6 are in m/yr.
 
 IPCC_Plot_Polar(AIS_Mean,LAT2,LON2,[-1 1],rate,'ISMIP6 Model Mean \newline   (2061-2100)',2,-2,25,1,'Elevation Change (m/yr)');

 h2=figure(2);
 saveas(h2,'../PNGs/ISMIP6dHdt','png');
 
 fname='./Processed_Data/Schroeder.nc'
 readncfile
 
 % setup south polar lambert azimuthal basemap.
 % The longitude lon_0 is at 6-o'clock, and the
 % latitude circle boundinglat is tangent to the edge
 % of the map at lon_0.

 [X,Y]=meshgrid(double(x),double(y));
 
% [lat,lon]=polarstereo_inv(double(X),double(Y),6378137,0.08181919,-71,-180);
 [X2,Y2]=polarstereo_fwd(LAT2,LON2,6378137,0.0,-71,0);

% LAT3=double(lat);
% LON3=double(lon);
 
 % Assemble back from the differences, following Gerhard's code
 
 % First 07-17
 sec_diff_07_17=nan*sec_diff_12_17;
 ndx=~isnan(sec_diff_12_17(:));
 sec_diff_07_17(ndx)=(sec_diff_12_17(ndx)+sec_diff_07_12(ndx))/2;
 
 % 78-17 where possible, else 92-17 where possible, else 07-17 where possible, else 12-17
 sec_diff_composite=nan*sec_diff_12_17;
 
 ndx=~isnan(sec_diff_12_17);
 sec_diff_composite(ndx)=sec_diff_12_17(ndx);
 
 ndx=~isnan(sec_diff_07_17);
 sec_diff_composite(ndx)=sec_diff_07_17(ndx);
 
 ndx=~isnan(sec_diff_92_17);
 sec_diff_composite(ndx)=sec_diff_92_17(ndx);
 
 ndx=~isnan(sec_diff_78_17);
 sec_diff_composite(ndx)=sec_diff_78_17(ndx);
 
 % Interpolate onto ISMIP grid for plotting
 % sec=interp2(LON3,LAT3,sec_diff_composite,LON2,LAT2,'nearest');
 % ndx=~isnan(sec_diff_composite);

 sec_diff_composite=sec_diff_composite';
 
 F = scatteredInterpolant(X(:),Y(:),sec_diff_composite(:),'nearest');
 secsch = F(X2,Y2);

 % Schroeder are in m/yr.
  
 IPCC_Plot_Polar(secsch,LAT2,LON2,[-1 1],rate,'Observations\newline (1978-2017)',3,-2,25,1,'Elevation Change (m/yr)');

 h3=figure(3);
 saveas(h3,'../PNGs/Schroeder','png');
 
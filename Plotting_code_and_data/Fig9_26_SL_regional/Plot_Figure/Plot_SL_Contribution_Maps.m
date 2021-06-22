%% IPCC AR6 Chapter 9: Figure 9.26 maps (Sea level rise contributions)
%
% Code used to plot pre-processed sea level rise contributions 
%
% Plotting code written by Brodie Pearson
% Processed data provided by Gregory Garner

clear all

addpath ../../../Functions/

fontsize = 15;

lims = [-0.3 0.6];

landwater_lims = [-0.05 0.1];


color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
color_bar = [color_bar2(1:11,:); color_bar1];

%% Load SSP126 inputs

quantiles = ncread('data/SSP126/regional_projections/glaciers-ipccar6-gmipemuglaciers-ssp126_localsl_figuredata.nc','quantiles');
years = ncread('data/SSP126/regional_projections/glaciers-ipccar6-gmipemuglaciers-ssp126_localsl_figuredata.nc','years');
lat = double(ncread('data/SSP126/regional_projections/glaciers-ipccar6-gmipemuglaciers-ssp126_localsl_figuredata.nc','lat'));
lon = double(ncread('data/SSP126/regional_projections/glaciers-ipccar6-gmipemuglaciers-ssp126_localsl_figuredata.nc','lon'));

ssp126_glaciers = ncread('data/SSP126/regional_projections/glaciers-ipccar6-gmipemuglaciers-ssp126_localsl_figuredata.nc','localSL_quantiles');
ssp126_Greenland = ncread('data/SSP126/regional_projections/icesheets-ipccar6-ismipemuicesheet-ssp126_GIS_localsl_figuredata.nc','localSL_quantiles');
ssp126_landwater = ncread('data/SSP126/regional_projections/landwaterstorage-ssp-landwaterstorage-ssp126_localsl_figuredata.nc','localSL_quantiles');
ssp126_Antarctic = ncread('data/SSP126/regional_projections/icesheets-pb1e-icesheets-ssp126_AIS_localsl_figuredata.nc','localSL_quantiles');
ssp126_oceandynamics = ncread('data/SSP126/regional_projections/oceandynamics-tlm-oceandynamics-ssp126_localsl_figuredata.nc','localSL_quantiles');
ssp126_landmotion = ncread('data/SSP126/regional_projections/verticallandmotion-kopp14-verticallandmotion_localsl_figuredata.nc','localSL_quantiles');

years_alt = ncread('data/SSP126/regional_projections/verticallandmotion-kopp14-verticallandmotion_localsl_figuredata.nc','years');

%% Isolate median maps at 2100, convert units from mm to m, regrid to 1 deg

% Isolate the median map at 2100
ssp126_glaciers = double(squeeze(ssp126_glaciers(9,:,3)))/1000.0; % Units are mm; convert to meters
ssp126_Greenland = double(squeeze(ssp126_Greenland(9,:,3)))/1000.0; 
ssp126_Antarctic = double(squeeze(ssp126_Antarctic(9,:,3)))/1000.0; 
ssp126_landwater = double(squeeze(ssp126_landwater(9,:,3)))/1000.0; 
ssp126_oceandynamics = double(squeeze(ssp126_oceandynamics(9,:,3)))/1000.0; 
ssp126_landmotion = double(squeeze(ssp126_landmotion(9,:,3)))/1000.0;

ssp126_glaciers = ssp126_glaciers';
ssp126_Greenland = ssp126_Greenland';
ssp126_Antarctic = ssp126_Antarctic';
ssp126_landwater = ssp126_landwater';
ssp126_oceandynamics = ssp126_oceandynamics';
ssp126_landmotion = ssp126_landmotion';

% wrap around longitude bands for re-gridding averages
ssp126_glaciers = [ssp126_glaciers; ssp126_glaciers(lon<-179)];
ssp126_Greenland = [ssp126_Greenland; ssp126_Greenland(lon<-179)];
ssp126_Antarctic = [ssp126_Antarctic; ssp126_Antarctic(lon<-179)];
ssp126_landwater = [ssp126_landwater; ssp126_landwater(lon<-179)];
ssp126_oceandynamics = [ssp126_oceandynamics; ssp126_oceandynamics(lon<-179)];
ssp126_landmotion = [ssp126_landmotion; ssp126_landmotion(lon<-179)];
lon = [lon; lon(lon<-179)+360];
lat = [lat; lat(lon<-179)];
ssp126_glaciers = [ssp126_glaciers; ssp126_glaciers(lon>179)];
ssp126_Greenland = [ssp126_Greenland; ssp126_Greenland(lon>179)];
ssp126_Antarctic = [ssp126_Antarctic; ssp126_Antarctic(lon>179)];
ssp126_landwater = [ssp126_landwater; ssp126_landwater(lon>179)];
ssp126_oceandynamics = [ssp126_oceandynamics; ssp126_oceandynamics(lon>179)];
ssp126_landmotion = [ssp126_landmotion; ssp126_landmotion(lon>179)];
lon = [lon; lon(lon>179)-360];
lat = [lat; lat(lon>179)];

for ii=1:360
   for jj=1:180
      ssp126_glaciers_gridded(ii,jj) = nanmean((ssp126_glaciers(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp126_Greenland_gridded(ii,jj) = nanmean((ssp126_Greenland(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp126_Antarctic_gridded(ii,jj) = nanmean((ssp126_Antarctic(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp126_landwater_gridded(ii,jj) = nanmean((ssp126_landwater(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp126_oceandynamics_gridded(ii,jj) = nanmean((ssp126_oceandynamics(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp126_landmotion_gridded(ii,jj) = nanmean((ssp126_landmotion(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      lon_grid(ii) = ii-180;
      lat_grid(jj) = jj-90;
   end
end

%% Make SSP1-2.6 plots

IPCC_Plot_Map_NoLonShift([ssp126_glaciers_gridded', ssp126_glaciers_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP1-2.6 2100 Median Glacier SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP126_Glacier_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP126_Glacier.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map_NoLonShift([ssp126_Greenland_gridded', ssp126_Greenland_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP1-2.6 2100 Median Greenland Ice Sheet SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP126_Greenland_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP126_Greenland.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map_NoLonShift([ssp126_Antarctic_gridded', ssp126_Antarctic_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP1-2.6 2100 Median Antarctic Ice Sheet SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP126_Antarctic_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP126_Antarctic.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map_NoLonShift([ssp126_landmotion_gridded', ssp126_landmotion_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP1-2.6 2100 Median Vertical Land Motion SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP126_LandMotion_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP126_LandMotion.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map_NoLonShift([ssp126_landwater_gridded', ssp126_landwater_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],landwater_lims, color_bar, ...
    'SSP1-2.6 2100 Median Land Water SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP126_LandWater_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP126_LandWater.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map_NoLonShift([ssp126_oceandynamics_gridded', ssp126_oceandynamics_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP1-2.6 2090 Median Ocean Dynamics SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP126_OceanDynamics_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP126_OceanDynamics.png','-dpng','-r1000', '-painters');
close(1);

%% Load SSP585 inputs

quantiles = ncread('data/SSP585/regional_projections/glaciers-ipccar6-gmipemuglaciers-ssp585_localsl_figuredata.nc','quantiles');
years = ncread('data/SSP585/regional_projections/glaciers-ipccar6-gmipemuglaciers-ssp585_localsl_figuredata.nc','years');
lat = double(ncread('data/SSP585/regional_projections/glaciers-ipccar6-gmipemuglaciers-ssp585_localsl_figuredata.nc','lat'));
lon = double(ncread('data/SSP585/regional_projections/glaciers-ipccar6-gmipemuglaciers-ssp585_localsl_figuredata.nc','lon'));

ssp585_glaciers = ncread('data/SSP585/regional_projections/glaciers-ipccar6-gmipemuglaciers-ssp585_localsl_figuredata.nc','localSL_quantiles');
ssp585_Greenland = ncread('data/SSP585/regional_projections/icesheets-ipccar6-ismipemuicesheet-ssp585_GIS_localsl_figuredata.nc','localSL_quantiles');
ssp585_landwater = ncread('data/SSP585/regional_projections/landwaterstorage-ssp-landwaterstorage-ssp585_localsl_figuredata.nc','localSL_quantiles');
ssp585_Antarctic = ncread('data/SSP585/regional_projections/icesheets-pb1e-icesheets-ssp585_AIS_localsl_figuredata.nc','localSL_quantiles');
ssp585_oceandynamics = ncread('data/SSP585/regional_projections/oceandynamics-tlm-oceandynamics-ssp585_localsl_figuredata.nc','localSL_quantiles');
ssp585_landmotion = ncread('data/SSP585/regional_projections/verticallandmotion-kopp14-verticallandmotion_localsl_figuredata.nc','localSL_quantiles');

years_alt = ncread('data/SSP585/regional_projections/verticallandmotion-kopp14-verticallandmotion_localsl_figuredata.nc','years');

%% Isolate median maps at 2100, convert units from mm to m, regrid to 1 deg

% Isolate the median map at 2100
ssp585_glaciers = double(squeeze(ssp585_glaciers(9,:,3)))/1000.0; % Units are mm; convert to meters
ssp585_Greenland = double(squeeze(ssp585_Greenland(9,:,3)))/1000.0; 
ssp585_Antarctic = double(squeeze(ssp585_Antarctic(9,:,3)))/1000.0; 
ssp585_landwater = double(squeeze(ssp585_landwater(9,:,3)))/1000.0; 
ssp585_oceandynamics = double(squeeze(ssp585_oceandynamics(9,:,3)))/1000.0; 
ssp585_landmotion = double(squeeze(ssp585_landmotion(9,:,3)))/1000.0; 

ssp585_glaciers = ssp585_glaciers';
ssp585_Greenland = ssp585_Greenland';
ssp585_Antarctic = ssp585_Antarctic';
ssp585_landwater = ssp585_landwater';
ssp585_oceandynamics = ssp585_oceandynamics';
ssp585_landmotion = ssp585_landmotion';

% wrap around longitude bands for re-gridding averages
ssp585_glaciers = [ssp585_glaciers; ssp585_glaciers(lon<-179)];
ssp585_Greenland = [ssp585_Greenland; ssp585_Greenland(lon<-179)];
ssp585_Antarctic = [ssp585_Antarctic; ssp585_Antarctic(lon<-179)];
ssp585_landwater = [ssp585_landwater; ssp585_landwater(lon<-179)];
ssp585_oceandynamics = [ssp585_oceandynamics; ssp585_oceandynamics(lon<-179)];
ssp585_landmotion = [ssp585_landmotion; ssp585_landmotion(lon<-179)];
lon = [lon; lon(lon<-179)+360];
lat = [lat; lat(lon<-179)];
ssp585_glaciers = [ssp585_glaciers; ssp585_glaciers(lon>179)];
ssp585_Greenland = [ssp585_Greenland; ssp585_Greenland(lon>179)];
ssp585_Antarctic = [ssp585_Antarctic; ssp585_Antarctic(lon>179)];
ssp585_landwater = [ssp585_landwater; ssp585_landwater(lon>179)];
ssp585_oceandynamics = [ssp585_oceandynamics; ssp585_oceandynamics(lon>179)];
ssp585_landmotion = [ssp585_landmotion; ssp585_landmotion(lon>179)];
lon = [lon; lon(lon>179)-360];
lat = [lat; lat(lon>179)];

for ii=1:360
   for jj=1:180
      ssp585_glaciers_gridded(ii,jj) = nanmean((ssp585_glaciers(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp585_Greenland_gridded(ii,jj) = nanmean((ssp585_Greenland(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp585_Antarctic_gridded(ii,jj) = nanmean((ssp585_Antarctic(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp585_landwater_gridded(ii,jj) = nanmean((ssp585_landwater(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp585_oceandynamics_gridded(ii,jj) = nanmean((ssp585_oceandynamics(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp585_landmotion_gridded(ii,jj) = nanmean((ssp585_landmotion(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      lon_grid(ii) = ii-180;
      lat_grid(jj) = jj-90;
   end
end

%% Make SSP5-8.5 plots

IPCC_Plot_Map_NoLonShift([ssp585_glaciers_gridded', ssp585_glaciers_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP5-8.5 2100 Median Glacier SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP585_Glacier_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP585_Glacier.png','-dpng','-r1000', '-painters');
close(1);

%ssp585_Greenland_gridded(:,1:5)=NaN;
%ssp585_Greenland_gridded(300,1:140)=ssp585_Greenland_gridded(300,40);
IPCC_Plot_Map_NoLonShift([ssp585_Greenland_gridded', ssp585_Greenland_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP5-8.5 2100 Median Greenland Ice Sheet SL contribution',1,fontsize,true, '(m)')


print(gcf,'../PNGs/SSP585_Greenland_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP585_Greenland.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map_NoLonShift([ssp585_Antarctic_gridded', ssp585_Antarctic_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP5-8.5 2100 Median Antarctic Ice Sheet SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP585_Antarctic_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP585_Antarctic.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map_NoLonShift([ssp585_landmotion_gridded', ssp585_landmotion_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP5-8.5 2100 Median Vertical Land Motion SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP585_LandMotion_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP585_LandMotion.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map_NoLonShift([ssp585_landwater_gridded', ssp585_landwater_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],landwater_lims, color_bar, ...
    'SSP5-8.5 2100 Median Land Water SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP585_LandWater_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP585_LandWater.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map_NoLonShift([ssp585_oceandynamics_gridded', ssp585_oceandynamics_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP5-8.5 2090 Median Ocean Dynamics SL contribution',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP585_OceanDynamics_Colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP585_OceanDynamics.png','-dpng','-r1000', '-painters');
close(1);

%% Save all the plotted data

var_name = 'SL_change';
var_units = 'meters';
comments = "Data is for Figure 9.26 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

ncfilename = '../Plotted_Data/Fig9-26_data_ssp126_glacier_map.nc';
title = "Projected contribution of Glaciers to 2100 Sea Level Change under SSP1-2.6";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp126_glaciers_gridded', ssp126_glaciers_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp126_Greenland_map.nc';
title = "Projected contribution of Greenland Ice Sheets to 2100 Sea Level Change under SSP1-2.6";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp126_Greenland_gridded', ssp126_Greenland_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp126_Antarctic_map.nc';
title = "Projected contribution of Antarctic Ice Sheets to 2100 Sea Level Change under SSP1-2.6";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp126_Antarctic_gridded', ssp126_Antarctic_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_landmotion_map.nc';
title = "Projected contribution of Vertical Land Motion to 2100 Sea Level Change (identical across SSPs)";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp126_landmotion_gridded', ssp126_landmotion_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp126_landwater_map.nc';
title = "Projected contribution of Land Water Storage to 2100 Sea Level Change under SSP1-2.6";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp126_landwater_gridded', ssp126_landwater_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp126_oceandynamics_map.nc';
title = "Projected contribution of Ocean Dynamics and Thermal Expansion to 2100 Sea Level Change under SSP1-2.6";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp126_oceandynamics_gridded', ssp126_oceandynamics_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)

%% Repeat for SSP5-8.5

ncfilename = '../Plotted_Data/Fig9-26_data_ssp585_glacier_map.nc';
title = "Projected contribution of Glaciers to 2100 Sea Level Change under SSP5-8.5";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp585_glaciers_gridded', ssp585_glaciers_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp585_Greenland_map.nc';
title = "Projected contribution of Greenland Ice Sheets to 2100 Sea Level Change under SSP5-8.5";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp585_Greenland_gridded', ssp585_Greenland_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp585_Antarctic_map.nc';
title = "Projected contribution of Antarctic Ice Sheets to 2100 Sea Level Change under SSP5-8.5";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp585_Antarctic_gridded', ssp585_Antarctic_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp585_landwater_map.nc';
title = "Projected contribution of Land Water Storage to 2100 Sea Level Change under SSP5-8.5";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp585_landwater_gridded', ssp585_landwater_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp585_oceandynamics_map.nc';
title = "Projected contribution of Ocean Dynamics and Thermal Expansion to 2100 Sea Level Change under SSP5-8.5";
IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp585_oceandynamics_gridded', ssp585_oceandynamics_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title, comments)


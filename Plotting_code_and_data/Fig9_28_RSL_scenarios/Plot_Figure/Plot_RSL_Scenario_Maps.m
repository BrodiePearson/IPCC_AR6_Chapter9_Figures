%% IPCC AR6 Chapter 9: Figure 9.28 (regional sea level)
%
% Code used to plot pre-processed regional sea level maps 
%
% Plotting code written by Brodie Pearson
% Processed data provided by Gregory Garner

clear all

addpath ../../../Functions/
fontsize = 15;

lims = [-0.2 1.4];

lims_range = [0 1];


color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
color_bar = [color_bar2(8:11,:); color_bar1];

color_bar_range = IPCC_Get_Colorbar('wind_nd', 21, false);

%% Load inputs

quantiles = ncread('data/pb_1e/ssp126/total-workflow_figuredata.nc','quantiles');
years = ncread('data/pb_1e/ssp126/total-workflow_figuredata.nc','years');
lat = double(ncread('data/pb_1e/ssp126/total-workflow_figuredata.nc','lat'));
lon = double(ncread('data/pb_1e/ssp126/total-workflow_figuredata.nc','lon'));

ssp119_SL_quantiles = ncread('data/pb_1e/ssp119/total-workflow_figuredata.nc','sea_level_change');
ssp126_SL_quantiles = ncread('data/pb_1e/ssp126/total-workflow_figuredata.nc','sea_level_change');
ssp245_SL_quantiles = ncread('data/pb_1e/ssp245/total-workflow_figuredata.nc','sea_level_change');
ssp370_SL_quantiles = ncread('data/pb_1e/ssp370/total-workflow_figuredata.nc','sea_level_change');
ssp585_SL_quantiles = ncread('data/pb_1e/ssp585/total-workflow_figuredata.nc','sea_level_change');

%% Isolate median maps at 2100, convert units from mm to m, regrid to 1 deg

% Isolate the median map at 2100
ssp119_SL_median = double(squeeze(ssp119_SL_quantiles(:,9,3)))/1000.0; % Units are mm; convert to meters
ssp126_SL_median = double(squeeze(ssp126_SL_quantiles(:,9,3)))/1000.0; % Units are mm; convert to meters
ssp245_SL_median = double(squeeze(ssp245_SL_quantiles(:,9,3)))/1000.0; % Units are mm; convert to meters
ssp370_SL_median = double(squeeze(ssp370_SL_quantiles(:,9,3)))/1000.0; % Units are mm; convert to meters
ssp585_SL_median = double(squeeze(ssp585_SL_quantiles(:,9,3)))/1000.0; % Units are mm; convert to meters

ssp370_SL_likely_range = (double(squeeze(ssp370_SL_quantiles(:,9,4))) ...
    - double(squeeze(ssp370_SL_quantiles(:,9,2))))/1000.0;

% wrap around longitude bands for re-gridding averages
ssp119_SL_median = [ssp119_SL_median; ssp119_SL_median(lon<-179)];
ssp126_SL_median = [ssp126_SL_median; ssp126_SL_median(lon<-179)];
ssp245_SL_median = [ssp245_SL_median; ssp245_SL_median(lon<-179)];
ssp370_SL_median = [ssp370_SL_median; ssp370_SL_median(lon<-179)];
ssp585_SL_median = [ssp585_SL_median; ssp585_SL_median(lon<-179)];
ssp370_SL_likely_range = [ssp370_SL_likely_range; ssp370_SL_likely_range(lon<-179)];

lon = [lon; lon(lon<-179)+360];
lat = [lat; lat(lon<-179)];

ssp119_SL_median = [ssp119_SL_median; ssp119_SL_median(lon>179)];
ssp126_SL_median = [ssp126_SL_median; ssp126_SL_median(lon>179)];
ssp245_SL_median = [ssp245_SL_median; ssp245_SL_median(lon>179)];
ssp370_SL_median = [ssp370_SL_median; ssp370_SL_median(lon>179)];
ssp585_SL_median = [ssp585_SL_median; ssp585_SL_median(lon>179)];
ssp370_SL_likely_range = [ssp370_SL_likely_range; ssp370_SL_likely_range(lon>179)];

lon = [lon; lon(lon>179)-360];
lat = [lat; lat(lon>179)];

for ii=1:360
   for jj=1:180
      ssp119_SL_median_gridded(ii,jj) = nanmean((ssp119_SL_median(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp126_SL_median_gridded(ii,jj) = nanmean((ssp126_SL_median(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp245_SL_median_gridded(ii,jj) = nanmean((ssp245_SL_median(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp370_SL_median_gridded(ii,jj) = nanmean((ssp370_SL_median(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp585_SL_median_gridded(ii,jj) = nanmean((ssp585_SL_median(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      ssp370_SL_likely_range_gridded(ii,jj) = nanmean((ssp370_SL_likely_range(abs(lat-jj+90)<=0.5 ...
          & abs(lon-ii+180)<=0.5)));
      lon_grid(ii) = ii-180;
      lat_grid(jj) = jj-90;
   end
end

%% Make plot of 2100 Regional Sea Level Rise for SSP119
% This particular experiment requires a shift in the fields because
% wrapping around to remove white latitude strip causes a contour error.
% Instead we move the white latitude band to the edge of the map so it is
% not visible

% SSP1-1.9 has some mid-ocean regions without data due to limited model availability
% We fill these masked values with zero so they do not plot as strong
% cooling and are identifiable
ssp_119_alt=ssp119_SL_median_gridded;
ssp_119_alt(ssp_119_alt<-32)=0;

IPCC_Plot_Map_NoLonShift(circshift(ssp_119_alt',150,2), ...
    lat_grid',circshift(lon_grid',150,1),lims, color_bar, ...
    'SSP1-1.9 Median GMSL Projection (2100 relative to 1995-2014)',1,fontsize,true, '(m)')


print(gcf,'../PNGs/SSP119_SL_Rise_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP119_SL_Rise.png','-dpng','-r1000', '-painters');
close(1);

var_name = 'SL_Change';
var_units = 'meters';

ncfilename = '../Plotted_Data/Fig9-28a_data.nc';
title_nc = "Regional Sea Level Rise at 2100 for SSP1-1.9 (with respect to 1995-2014)";
comments = "Data is for panel (a) of Figure 9.28 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, circshift(ssp119_SL_median_gridded',150,2), ...
    lat_grid', circshift(lon_grid',150,1), title_nc, comments)


%% Make plot of 2100 Regional Sea Level Rise for SSP126

IPCC_Plot_Map_NoLonShift([ssp126_SL_median_gridded', ssp126_SL_median_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP1-2.6 Median GMSL Projection (2100 relative to 1995-2014)',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP126_SL_Rise_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP126_SL_Rise.png','-dpng','-r1000', '-painters');
close(1);

ncfilename = '../Plotted_Data/Fig9-28b_data.nc';
title_nc = "Regional Sea Level Rise at 2100 for SSP1-2.6 (with respect to 1995-2014)";
comments = "Data is for panel (b) of Figure 9.28 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp126_SL_median_gridded', ssp126_SL_median_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title_nc, comments)

%% Make SSP245 plot

IPCC_Plot_Map_NoLonShift([ssp245_SL_median_gridded', ssp245_SL_median_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP2-4.5 Median GMSL Projection (2100 relative to 1995-2014)',2,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP245_SL_Rise_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP245_SL_Rise.png','-dpng','-r1000', '-painters');
close(2);

ncfilename = '../Plotted_Data/Fig9-28c_data.nc';
title_nc = "Regional Sea Level Rise at 2100 for SSP2-4.5 (with respect to 1995-2014)";
comments = "Data is for panel (c) of Figure 9.28 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp245_SL_median_gridded', ssp245_SL_median_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title_nc, comments)


%% Make plot of 2100 Regional Sea Level Rise for SSP126

IPCC_Plot_Map_Gappy([ssp370_SL_median_gridded', ssp370_SL_median_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP3-7.0 Median GMSL Projection (2100 relative to 1995-2014)',1,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP370_SL_Rise_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP370_SL_Rise.png','-dpng','-r1000', '-painters');
close(1);

ncfilename = '../Plotted_Data/Fig9-28d_data.nc';
title_nc = "Regional Sea Level Rise at 2100 for SSP3-7.0 (with respect to 1995-2014)";
comments = "Data is for panel (d) of Figure 9.28 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp370_SL_median_gridded', ssp370_SL_median_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title_nc, comments)


%% Make SSP585 plot

IPCC_Plot_Map_NoLonShift([ssp585_SL_median_gridded', ssp585_SL_median_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims, color_bar, ...
    'SSP5-8.5 Median GMSL Projection (2100 relative to 1995-2014)',3,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP585_SL_Rise_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP585_SL_Rise.png','-dpng','-r1000', '-painters');
close(3);

ncfilename = '../Plotted_Data/Fig9-28e_data.nc';
title_nc = "Regional Sea Level Rise at 2100 for SSP5-8.5 (with respect to 1995-2014)";
comments = "Data is for panel (e) of Figure 9.28 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp585_SL_median_gridded', ssp585_SL_median_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title_nc, comments)

%% Make SSP245 'likely range' plot

IPCC_Plot_Map_Gappy([ssp370_SL_likely_range_gridded', ssp370_SL_likely_range_gridded(1,:)'], ...
    lat_grid',[lon_grid'; lon_grid(1)],lims_range, color_bar_range, ...
    'SSP3-7.0 Span of Likely range of change',4,fontsize,true, '(m)')

print(gcf,'../PNGs/SSP370_SL_likely_range_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP370_SL_likely_range.png','-dpng','-r1000', '-painters');
close(4);

var_name = 'Range_of_SL_Change';
ncfilename = '../Plotted_Data/Fig9-28f_data.nc';
title_nc = "Span of likely range of Sea Level Rise at 2100 for SSP3-7.0 (with respect to 1995-2014)";
comments = "Data is for panel (f) of Figure 9.28 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, [ssp370_SL_likely_range_gridded', ssp370_SL_likely_range_gridded(1,:)'], ...
    lat_grid', [lon_grid'; lon_grid(1)], title_nc, comments)





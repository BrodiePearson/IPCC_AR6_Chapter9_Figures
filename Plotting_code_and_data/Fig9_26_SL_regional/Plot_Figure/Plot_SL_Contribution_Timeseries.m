%% IPCC AR6 Chapter 9: Figure 9.26 timeseries (Sea level rise contributions)
%
% Code used to plot pre-processed sea level rise contributions 
%
% Plotting code written by Brodie Pearson
% Processed data provided by Gregory Garner

clear all

addpath ../../../Functions/

fontsize = 15;
width=4;

color_OBS = IPCC_Get_SSPColors('Observations');
color_HRMIP = IPCC_Get_SSPColors('HighResMIP');
color_HRSSP = IPCC_Get_SSPColors('HighResMIP');
color_CMIP = IPCC_Get_SSPColors('CMIP');
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

%% Load SSP126 and SSP585 inputs

quantiles = ncread('data/SSP126/global_projections/thermalexpansion-tlm-thermalexpansion-ssp126_globalsl_figuredata.nc','quantiles');
years = ncread('data/SSP126/global_projections/thermalexpansion-tlm-thermalexpansion-ssp126_globalsl_figuredata.nc','years');

ssp126_thermalexpansion = ncread('data/SSP126/global_projections/thermalexpansion-tlm-thermalexpansion-ssp126_globalsl_figuredata.nc','globalSL_quantiles');
ssp126_Greenland = ncread('data/SSP126/global_projections/icesheets-ipccar6-ismipemuicesheet-ssp126_GIS_globalsl_figuredata.nc','globalSL_quantiles');
ssp126_Antarctic = ncread('data/SSP126/global_projections/icesheets-pbox1e-icesheets-ssp126_AIS_globalsl_figuredata.nc','globalSL_quantiles');
ssp126_landwater = ncread('data/SSP126/global_projections/landwaterstorage-ssp-landwaterstorage-ssp126_globalsl_figuredata.nc','globalSL_quantiles');
ssp126_glaciers = ncread('data/SSP126/global_projections/glaciers-ipccar6-gmipemuglaciers-ssp126_globalsl_figuredata.nc','globalSL_quantiles');
ssp126_total = ncread('data/SSP126/global_projections/pbox1e_total_ssp126_globalsl_figuredata.nc','globalSL_quantiles');

ssp585_thermalexpansion = ncread('data/SSP585/global_projections/thermalexpansion-tlm-thermalexpansion-ssp585_globalsl_figuredata.nc','globalSL_quantiles');
ssp585_Greenland = ncread('data/SSP585/global_projections/icesheets-ipccar6-ismipemuicesheet-ssp585_GIS_globalsl_figuredata.nc','globalSL_quantiles');
ssp585_Antarctic = ncread('data/SSP585/global_projections/icesheets-pbox1e-icesheets-ssp585_AIS_globalsl_figuredata.nc','globalSL_quantiles');
ssp585_landwater = ncread('data/SSP585/global_projections/landwaterstorage-ssp-landwaterstorage-ssp585_globalsl_figuredata.nc','globalSL_quantiles');
ssp585_glaciers = ncread('data/SSP585/global_projections/glaciers-ipccar6-gmipemuglaciers-ssp585_globalsl_figuredata.nc','globalSL_quantiles');
ssp585_total = ncread('data/SSP585/global_projections/pbox1e_total_ssp585_globalsl_figuredata.nc','globalSL_quantiles');

years = years(1:9);


%% Isolate median timeseries to 2100, convert units from mm to m, regrid to 1 deg

% Isolate the median map at 2100
ssp126_glaciers_median = double(squeeze(ssp126_glaciers(1:9,3)))/1000.0; % Units are mm; convert to meters
ssp126_Greenland_median = double(squeeze(ssp126_Greenland(1:9,3)))/1000.0; 
ssp126_Antarctic_median = double(squeeze(ssp126_Antarctic(1:9,3)))/1000.0; 
ssp126_landwater_median = double(squeeze(ssp126_landwater(1:9,3)))/1000.0; 
ssp126_thermalexpansion_median = double(squeeze(ssp126_thermalexpansion(1:9,3)))/1000.0; 
ssp126_total_median = double(squeeze(ssp126_total(1:9,3)))/1000.0;

ssp585_glaciers_median = double(squeeze(ssp585_glaciers(1:9,3)))/1000.0; % Units are mm; convert to meters
ssp585_Greenland_median = double(squeeze(ssp585_Greenland(1:9,3)))/1000.0; 
ssp585_Antarctic_median = double(squeeze(ssp585_Antarctic(1:9,3)))/1000.0; 
ssp585_landwater_median = double(squeeze(ssp585_landwater(1:9,3)))/1000.0; 
ssp585_thermalexpansion_median = double(squeeze(ssp585_thermalexpansion(1:9,3)))/1000.0; 
ssp585_total_median = double(squeeze(ssp585_total(1:9,3)))/1000.0;

%% Create SSP126 confidence bounds

Time_Conf_Bounds = [years' flipud(years)'];

ssp126_total_lower_likely = double(squeeze(ssp126_total(1:9,2)))/1000.0; 
ssp126_total_lower_verylikely = double(squeeze(ssp126_total(1:9,1)))/1000.0; 
ssp126_total_upper_likely = double(squeeze(ssp126_total(1:9,4)))/1000.0; 
ssp126_total_upper_verylikely = double(squeeze(ssp126_total(1:9,5)))/1000.0; 

ssp126_total_VeryLikely_Conf_Bounds = [ssp126_total_upper_verylikely' flipud(ssp126_total_lower_verylikely)'];
ssp126_total_Likely_Conf_Bounds = [ssp126_total_upper_likely' flipud(ssp126_total_lower_likely)'];

ssp126_glaciers_lower_likely = double(squeeze(ssp126_glaciers(1:9,2)))/1000.0; 
ssp126_glaciers_lower_verylikely = double(squeeze(ssp126_glaciers(1:9,1)))/1000.0; 
ssp126_glaciers_upper_likely = double(squeeze(ssp126_glaciers(1:9,4)))/1000.0; 
ssp126_glaciers_upper_verylikely = double(squeeze(ssp126_glaciers(1:9,5)))/1000.0; 
ssp126_glaciers_VeryLikely_Conf_Bounds = [ssp126_glaciers_upper_verylikely' flipud(ssp126_glaciers_lower_verylikely)'];
ssp126_glaciers_Likely_Conf_Bounds = [ssp126_glaciers_upper_likely' flipud(ssp126_glaciers_lower_likely)'];

ssp126_Antarctic_lower_likely = double(squeeze(ssp126_Antarctic(1:9,2)))/1000.0; 
ssp126_Antarctic_lower_verylikely = double(squeeze(ssp126_Antarctic(1:9,1)))/1000.0; 
ssp126_Antarctic_upper_likely = double(squeeze(ssp126_Antarctic(1:9,4)))/1000.0; 
ssp126_Antarctic_upper_verylikely = double(squeeze(ssp126_Antarctic(1:9,5)))/1000.0; 
ssp126_Antarctic_VeryLikely_Conf_Bounds = [ssp126_Antarctic_upper_verylikely' flipud(ssp126_Antarctic_lower_verylikely)'];
ssp126_Antarctic_Likely_Conf_Bounds = [ssp126_Antarctic_upper_likely' flipud(ssp126_Antarctic_lower_likely)'];

ssp126_Greenland_lower_likely = double(squeeze(ssp126_Greenland(1:9,2)))/1000.0; 
ssp126_Greenland_lower_verylikely = double(squeeze(ssp126_Greenland(1:9,1)))/1000.0; 
ssp126_Greenland_upper_likely = double(squeeze(ssp126_Greenland(1:9,4)))/1000.0; 
ssp126_Greenland_upper_verylikely = double(squeeze(ssp126_Greenland(1:9,5)))/1000.0; 
ssp126_Greenland_VeryLikely_Conf_Bounds = [ssp126_Greenland_upper_verylikely' flipud(ssp126_Greenland_lower_verylikely)'];
ssp126_Greenland_Likely_Conf_Bounds = [ssp126_Greenland_upper_likely' flipud(ssp126_Greenland_lower_likely)'];

ssp126_thermalexpansion_lower_likely = double(squeeze(ssp126_thermalexpansion(1:9,2)))/1000.0; 
ssp126_thermalexpansion_lower_verylikely = double(squeeze(ssp126_thermalexpansion(1:9,1)))/1000.0; 
ssp126_thermalexpansion_upper_likely = double(squeeze(ssp126_thermalexpansion(1:9,4)))/1000.0; 
ssp126_thermalexpansion_upper_verylikely = double(squeeze(ssp126_thermalexpansion(1:9,5)))/1000.0; 
ssp126_thermalexpansion_VeryLikely_Conf_Bounds = [ssp126_thermalexpansion_upper_verylikely' flipud(ssp126_thermalexpansion_lower_verylikely)'];
ssp126_thermalexpansion_Likely_Conf_Bounds = [ssp126_thermalexpansion_upper_likely' flipud(ssp126_thermalexpansion_lower_likely)'];

ssp126_landwater_lower_likely = double(squeeze(ssp126_landwater(1:9,2)))/1000.0; 
ssp126_landwater_lower_verylikely = double(squeeze(ssp126_landwater(1:9,1)))/1000.0; 
ssp126_landwater_upper_likely = double(squeeze(ssp126_landwater(1:9,4)))/1000.0; 
ssp126_landwater_upper_verylikely = double(squeeze(ssp126_landwater(1:9,5)))/1000.0; 
ssp126_landwater_VeryLikely_Conf_Bounds = [ssp126_landwater_upper_verylikely' flipud(ssp126_landwater_lower_verylikely)'];
ssp126_landwater_Likely_Conf_Bounds = [ssp126_landwater_upper_likely' flipud(ssp126_landwater_lower_likely)'];

%% Create SSP585 confidence bounds

ssp585_total_lower_likely = double(squeeze(ssp585_total(1:9,2)))/1000.0; 
ssp585_total_lower_verylikely = double(squeeze(ssp585_total(1:9,1)))/1000.0; 
ssp585_total_upper_likely = double(squeeze(ssp585_total(1:9,4)))/1000.0; 
ssp585_total_upper_verylikely = double(squeeze(ssp585_total(1:9,5)))/1000.0; 

ssp585_total_VeryLikely_Conf_Bounds = [ssp585_total_upper_verylikely' flipud(ssp585_total_lower_verylikely)'];
ssp585_total_Likely_Conf_Bounds = [ssp585_total_upper_likely' flipud(ssp585_total_lower_likely)'];

ssp585_glaciers_lower_likely = double(squeeze(ssp585_glaciers(1:9,2)))/1000.0; 
ssp585_glaciers_lower_verylikely = double(squeeze(ssp585_glaciers(1:9,1)))/1000.0; 
ssp585_glaciers_upper_likely = double(squeeze(ssp585_glaciers(1:9,4)))/1000.0; 
ssp585_glaciers_upper_verylikely = double(squeeze(ssp585_glaciers(1:9,5)))/1000.0; 
ssp585_glaciers_VeryLikely_Conf_Bounds = [ssp585_glaciers_upper_verylikely' flipud(ssp585_glaciers_lower_verylikely)'];
ssp585_glaciers_Likely_Conf_Bounds = [ssp585_glaciers_upper_likely' flipud(ssp585_glaciers_lower_likely)'];

ssp585_Antarctic_lower_likely = double(squeeze(ssp585_Antarctic(1:9,2)))/1000.0; 
ssp585_Antarctic_lower_verylikely = double(squeeze(ssp585_Antarctic(1:9,1)))/1000.0; 
ssp585_Antarctic_upper_likely = double(squeeze(ssp585_Antarctic(1:9,4)))/1000.0; 
ssp585_Antarctic_upper_verylikely = double(squeeze(ssp585_Antarctic(1:9,5)))/1000.0; 
ssp585_Antarctic_VeryLikely_Conf_Bounds = [ssp585_Antarctic_upper_verylikely' flipud(ssp585_Antarctic_lower_verylikely)'];
ssp585_Antarctic_Likely_Conf_Bounds = [ssp585_Antarctic_upper_likely' flipud(ssp585_Antarctic_lower_likely)'];

ssp585_Greenland_lower_likely = double(squeeze(ssp585_Greenland(1:9,2)))/1000.0; 
ssp585_Greenland_lower_verylikely = double(squeeze(ssp585_Greenland(1:9,1)))/1000.0; 
ssp585_Greenland_upper_likely = double(squeeze(ssp585_Greenland(1:9,4)))/1000.0; 
ssp585_Greenland_upper_verylikely = double(squeeze(ssp585_Greenland(1:9,5)))/1000.0; 
ssp585_Greenland_VeryLikely_Conf_Bounds = [ssp585_Greenland_upper_verylikely' flipud(ssp585_Greenland_lower_verylikely)'];
ssp585_Greenland_Likely_Conf_Bounds = [ssp585_Greenland_upper_likely' flipud(ssp585_Greenland_lower_likely)'];

ssp585_thermalexpansion_lower_likely = double(squeeze(ssp585_thermalexpansion(1:9,2)))/1000.0; 
ssp585_thermalexpansion_lower_verylikely = double(squeeze(ssp585_thermalexpansion(1:9,1)))/1000.0; 
ssp585_thermalexpansion_upper_likely = double(squeeze(ssp585_thermalexpansion(1:9,4)))/1000.0; 
ssp585_thermalexpansion_upper_verylikely = double(squeeze(ssp585_thermalexpansion(1:9,5)))/1000.0; 
ssp585_thermalexpansion_VeryLikely_Conf_Bounds = [ssp585_thermalexpansion_upper_verylikely' flipud(ssp585_thermalexpansion_lower_verylikely)'];
ssp585_thermalexpansion_Likely_Conf_Bounds = [ssp585_thermalexpansion_upper_likely' flipud(ssp585_thermalexpansion_lower_likely)'];

ssp585_landwater_lower_likely = double(squeeze(ssp585_landwater(1:9,2)))/1000.0; 
ssp585_landwater_lower_verylikely = double(squeeze(ssp585_landwater(1:9,1)))/1000.0; 
ssp585_landwater_upper_likely = double(squeeze(ssp585_landwater(1:9,4)))/1000.0; 
ssp585_landwater_upper_verylikely = double(squeeze(ssp585_landwater(1:9,5)))/1000.0; 
ssp585_landwater_VeryLikely_Conf_Bounds = [ssp585_landwater_upper_verylikely' flipud(ssp585_landwater_lower_verylikely)'];
ssp585_landwater_Likely_Conf_Bounds = [ssp585_landwater_upper_likely' flipud(ssp585_landwater_lower_likely)'];



% 
% %% Plot Timeseries of medians
% 
% figure('Position', [10 10 500 300])
% 
% txt = "SSP1-2.6";
% text(2025,0.5,txt,'FontSize',24, ...
%     'Color', color_SSP126, 'FontWeight', 'bold')
% 
% box on
% patch(Time_Conf_Bounds,ssp126_total_Likely_Conf_Bounds,IPCC_Get_LineColors(6, 1), 'EdgeColor', 'none', 'FaceAlpha', 0.4)
% hold on
% patch(Time_Conf_Bounds,ssp126_total_VeryLikely_Conf_Bounds,IPCC_Get_LineColors(6, 1), 'EdgeColor', 'none', 'FaceAlpha', 0.2)
% plot(years,ssp126_total_median,'Color', IPCC_Get_LineColors(6, 1), 'LineWidth', width)
% plot(years,ssp126_thermalexpansion_median,'Color', IPCC_Get_LineColors(6, 2), 'LineWidth', width/2)
% plot(years,ssp126_glaciers_median,'Color', IPCC_Get_LineColors(6, 3), 'LineWidth', width/2)
% plot(years,ssp126_Antarctic_median,'Color', IPCC_Get_LineColors(6, 4), 'LineWidth', width/2)
% plot(years,ssp126_Greenland_median,'Color', IPCC_Get_LineColors(6, 5), 'LineWidth', width/2)
% plot(years,ssp126_landwater_median,'Color', IPCC_Get_LineColors(6, 6), 'LineWidth', width/2)
% xlim([2020 2100])
% plot([2020 2100], [2100 2300]*0, 'k', 'LineWidth', width/10)
% ylim([-0.05 0.45])
% set(gca,'Xtick',[2020 2040 2060 2080 2100],'Xticklabel',{'2020','','2060', '', '2100'})
% set(gca,'Ytick',[-0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5 0.6], ...
%     'Yticklabel',{'-0.3','','','0','','','0.3','','','0.6'})
% set(gca,'FontSize',15)
% ylabel('(m)     ')
% set(get(gca,'YLabel'),'Rotation',0)

%% Create SSP126 plot

figure('Position', [10 10 600 300])
subplot(1,100,1:80)

box on
plot(years,ssp126_thermalexpansion_median,'Color', IPCC_Get_LineColors(5, 1), 'LineWidth', width)
hold on
plot(years,ssp126_glaciers_median,'Color', IPCC_Get_LineColors(5, 2), 'LineWidth', width)
plot(years,ssp126_Antarctic_median,'Color', IPCC_Get_LineColors(5, 3), 'LineWidth', width)
plot(years,ssp126_Greenland_median,'Color', IPCC_Get_LineColors(5, 4), 'LineWidth', width)
plot(years,ssp126_landwater_median,'Color', IPCC_Get_LineColors(5, 5), 'LineWidth', width)
xlim([2020 2100])
plot([2020 2100], [2020 2100]*0, 'k', 'LineWidth', width/10)
ylim([-0.05 0.35])
set(gca,'Xtick',[2020 2040 2060 2080 2100],'Xticklabel',{'2020','','2060', '', '2100'})
set(gca,'Ytick',[-0.05 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35], ...
    'Yticklabel',{'','0','','0.1','','0.2','','0.3',''})
set(gca,'FontSize',15)
ylabel('(m)     ')
set(get(gca,'YLabel'),'Rotation',0)

txt = "SSP1-2.6";
text(2025,0.3,txt,'FontSize',30, ...
    'Color', color_SSP126, 'FontWeight', 'bold')

set(gca,'Box', 'on','Clipping','off')

plot([2104,2104], [ssp126_thermalexpansion_median(end), ssp126_thermalexpansion_median(end)] ...
    , '.', 'Color',IPCC_Get_LineColors(5, 1), 'MarkerSize', 20)
plot([2104,2104], [ssp126_thermalexpansion_upper_likely(end), ssp126_thermalexpansion_lower_likely(end)] ...
    , '-', 'Color',IPCC_Get_LineColors(5, 1), 'LineWidth', width)
% plot([2104,2104], [ssp126_thermalexpansion_upper_verylikely(end), ssp126_thermalexpansion_lower_verylikely(end)] ...
%     , '-', 'Color',IPCC_Get_LineColors(5, 1), 'LineWidth', width/2)
% ssp126_thermalexpansion_upper_verylikely(end)
% ssp126_thermalexpansion_upper_likely(end)

plot([2106,2106], [ssp126_glaciers_median(end), ssp126_glaciers_median(end)] ...
    , '.', 'Color',IPCC_Get_LineColors(5, 2), 'MarkerSize', 20)
plot([2106,2106], [ssp126_glaciers_upper_likely(end), ssp126_glaciers_lower_likely(end)] ...
    , '-', 'Color',IPCC_Get_LineColors(5, 2), 'LineWidth', width)
% plot([2106,2106], [ssp126_glaciers_upper_verylikely(end), ssp126_glaciers_lower_verylikely(end)] ...
%     , '-', 'Color',IPCC_Get_LineColors(5, 2), 'LineWidth', width/2)

plot([2108,2108], [ssp126_Greenland_median(end), ssp126_Greenland_median(end)] ...
    , '.', 'Color',IPCC_Get_LineColors(5, 4), 'MarkerSize', 20)
plot([2108,2108], [ssp126_Greenland_upper_likely(end), ssp126_Greenland_lower_likely(end)] ...
    , '-', 'Color',IPCC_Get_LineColors(5, 4), 'LineWidth', width)
% plot([2108,2108], [ssp126_Greenland_upper_verylikely(end), ssp126_Greenland_lower_verylikely(end)] ...
%     , '-', 'Color',IPCC_Get_LineColors(5, 4), 'LineWidth', width/2)

plot([2110,2110], [ssp126_Antarctic_median(end), ssp126_Antarctic_median(end)] ...
    , '.', 'Color',IPCC_Get_LineColors(5, 3), 'MarkerSize', 20)
plot([2110,2110], [ssp126_Antarctic_upper_likely(end), ssp126_Antarctic_lower_likely(end)] ...
    , '-', 'Color',IPCC_Get_LineColors(5, 3), 'LineWidth', width)
% plot([2110,2110], [ssp126_Antarctic_upper_verylikely(end), ssp126_Antarctic_lower_verylikely(end)] ...
%     , '-', 'Color',IPCC_Get_LineColors(5, 3), 'LineWidth', width/2)
% ssp126_Antarctic_upper_verylikely(end)

plot([2112,2112], [ssp126_landwater_median(end), ssp126_landwater_median(end)] ...
    , '.', 'Color',IPCC_Get_LineColors(5, 5), 'MarkerSize', 20)
plot([2112,2112], [ssp126_landwater_upper_likely(end), ssp126_landwater_lower_likely(end)] ...
    , '-', 'Color',IPCC_Get_LineColors(5, 5), 'LineWidth', width)
% plot([2112,2112], [ssp126_landwater_upper_verylikely(end), ssp126_landwater_lower_verylikely(end)] ...
%     , '-', 'Color',IPCC_Get_LineColors(5, 5), 'LineWidth', width/2)

txt = {'2100 medians', '& 17^{th}-83^{rd}', 'percentiles'};
text(2100+10,-0.04,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

print(gcf,'../PNGs/SSP126_SL_Regional.png','-dpng','-r1000', '-painters');

%% Create SSP585 plot

figure('Position', [10 10 600 300])
subplot(1,100,1:80)

box on
%patch(Time_Conf_Bounds,ssp585_thermalexpansion_Likely_Conf_Bounds,IPCC_Get_LineColors(5, 1), 'EdgeColor', 'none', 'FaceAlpha', 0.2)
%hold on
%patch(Time_Conf_Bounds,ssp585_thermalexpansion_VeryLikely_Conf_Bounds,IPCC_Get_LineColors(5, 1), 'EdgeColor', 'none', 'FaceAlpha', 0.1)
%patch(Time_Conf_Bounds,ssp585_glaciers_Likely_Conf_Bounds,IPCC_Get_LineColors(5, 2), 'EdgeColor', 'none', 'FaceAlpha', 0.2)
%patch(Time_Conf_Bounds,ssp585_glaciers_VeryLikely_Conf_Bounds,IPCC_Get_LineColors(5, 2), 'EdgeColor', 'none', 'FaceAlpha', 0.1)
%patch(Time_Conf_Bounds,ssp585_Antarctic_Likely_Conf_Bounds,IPCC_Get_LineColors(5, 3), 'EdgeColor', 'none', 'FaceAlpha', 0.2)
%patch(Time_Conf_Bounds,ssp585_Antarctic_VeryLikely_Conf_Bounds,IPCC_Get_LineColors(5, 3), 'EdgeColor', 'none', 'FaceAlpha', 0.1)
%patch(Time_Conf_Bounds,ssp585_Greenland_Likely_Conf_Bounds,IPCC_Get_LineColors(5, 4), 'EdgeColor', 'none', 'FaceAlpha', 0.2)
%patch(Time_Conf_Bounds,ssp585_Greenland_VeryLikely_Conf_Bounds,IPCC_Get_LineColors(5, 4), 'EdgeColor', 'none', 'FaceAlpha', 0.1)
%patch(Time_Conf_Bounds,ssp585_landwater_Likely_Conf_Bounds,IPCC_Get_LineColors(5, 5), 'EdgeColor', 'none', 'FaceAlpha', 0.2)
%patch(Time_Conf_Bounds,ssp585_landwater_VeryLikely_Conf_Bounds,IPCC_Get_LineColors(5, 5), 'EdgeColor', 'none', 'FaceAlpha', 0.1)
plot(years,ssp585_thermalexpansion_median,'Color', IPCC_Get_LineColors(5, 1), 'LineWidth', width)
hold on
plot(years,ssp585_glaciers_median,'Color', IPCC_Get_LineColors(5, 2), 'LineWidth', width)
plot(years,ssp585_Antarctic_median,'Color', IPCC_Get_LineColors(5, 3), 'LineWidth', width)
plot(years,ssp585_Greenland_median,'Color', IPCC_Get_LineColors(5, 4), 'LineWidth', width)
plot(years,ssp585_landwater_median,'Color', IPCC_Get_LineColors(5, 5), 'LineWidth', width)
xlim([2020 2100])
plot([2020 2100], [2020 2100]*0, 'k', 'LineWidth', width/10)
ylim([-0.05 0.35])
set(gca,'Xtick',[2020 2040 2060 2080 2100],'Xticklabel',{'2020','','2060', '', '2100'})
set(gca,'Ytick',[-0.05 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35], ...
    'Yticklabel',{'','0','','0.1','','0.2','','0.3',''})
set(gca,'FontSize',15)
ylabel('(m)     ')
set(get(gca,'YLabel'),'Rotation',0)

txt = "SSP5-8.5";
text(2025,0.3,txt,'FontSize',30, ...
    'Color', color_SSP585, 'FontWeight', 'bold')

txt = "Thermal Expansion";
text(2062,0.3,txt,'FontSize',14, ...
    'Color', IPCC_Get_LineColors(5, 1), 'FontWeight', 'bold')

txt = "Glaciers";
text(2085,0.2,txt,'FontSize',14, ...
    'Color', IPCC_Get_LineColors(5, 2), 'FontWeight', 'bold')

txt = "Antarctic Ice Sheet";
text(2025,-0.02,txt,'FontSize',14, ...
    'Color', IPCC_Get_LineColors(5, 3), 'FontWeight', 'bold')

txt = "Greenland Ice Sheet";
text(2022,0.13,txt,'FontSize',14, ...
    'Color', IPCC_Get_LineColors(5, 4), 'FontWeight', 'bold')

txt = "Land Water Storage";
text(2060,-0.02,txt,'FontSize',14, ...
    'Color', IPCC_Get_LineColors(5, 5), 'FontWeight', 'bold')

set(gca,'Box', 'on','Clipping','off')

plot([2104,2104], [ssp585_thermalexpansion_median(end), ssp585_thermalexpansion_median(end)] ...
    , '.', 'Color',IPCC_Get_LineColors(5, 1), 'MarkerSize', 20)
plot([2104,2104], [ssp585_thermalexpansion_upper_likely(end), ssp585_thermalexpansion_lower_likely(end)] ...
    , '-', 'Color',IPCC_Get_LineColors(5, 1), 'LineWidth', width)
% plot([2104,2104], [ssp585_thermalexpansion_upper_verylikely(end), ssp585_thermalexpansion_lower_verylikely(end)] ...
%     , '-', 'Color',IPCC_Get_LineColors(5, 1), 'LineWidth', width/2)
% ssp585_thermalexpansion_upper_verylikely(end)
% ssp585_thermalexpansion_upper_likely(end)

plot([2106,2106], [ssp585_glaciers_median(end), ssp585_glaciers_median(end)] ...
    , '.', 'Color',IPCC_Get_LineColors(5, 2), 'MarkerSize', 20)
plot([2106,2106], [ssp585_glaciers_upper_likely(end), ssp585_glaciers_lower_likely(end)] ...
    , '-', 'Color',IPCC_Get_LineColors(5, 2), 'LineWidth', width)
% plot([2106,2106], [ssp585_glaciers_upper_verylikely(end), ssp585_glaciers_lower_verylikely(end)] ...
%     , '-', 'Color',IPCC_Get_LineColors(5, 2), 'LineWidth', width/2)

plot([2108,2108], [ssp585_Greenland_median(end), ssp585_Greenland_median(end)] ...
    , '.', 'Color',IPCC_Get_LineColors(5, 4), 'MarkerSize', 20)
plot([2108,2108], [ssp585_Greenland_upper_likely(end), ssp585_Greenland_lower_likely(end)] ...
    , '-', 'Color',IPCC_Get_LineColors(5, 4), 'LineWidth', width)
% plot([2108,2108], [ssp585_Greenland_upper_verylikely(end), ssp585_Greenland_lower_verylikely(end)] ...
%     , '-', 'Color',IPCC_Get_LineColors(5, 4), 'LineWidth', width/2)

plot([2110,2110], [ssp585_Antarctic_median(end), ssp585_Antarctic_median(end)] ...
    , '.', 'Color',IPCC_Get_LineColors(5, 3), 'MarkerSize', 20)
plot([2110,2110], [ssp585_Antarctic_upper_likely(end), ssp585_Antarctic_lower_likely(end)] ...
    , '-', 'Color',IPCC_Get_LineColors(5, 3), 'LineWidth', width)
% plot([2110,2110], [ssp585_Antarctic_upper_verylikely(end), ssp585_Antarctic_lower_verylikely(end)] ...
%     , '-', 'Color',IPCC_Get_LineColors(5, 3), 'LineWidth', width/2)
% ssp585_Antarctic_upper_verylikely(end)

plot([2112,2112], [ssp585_landwater_median(end), ssp585_landwater_median(end)] ...
    , '.', 'Color',IPCC_Get_LineColors(5, 5), 'MarkerSize', 20)
plot([2112,2112], [ssp585_landwater_upper_likely(end), ssp585_landwater_lower_likely(end)] ...
    , '-', 'Color',IPCC_Get_LineColors(5, 5), 'LineWidth', width)
% plot([2112,2112], [ssp585_landwater_upper_verylikely(end), ssp585_landwater_lower_verylikely(end)] ...
%     , '-', 'Color',IPCC_Get_LineColors(5, 5), 'LineWidth', width/2)

txt = {'2100 medians', '& 17^{th}-83^{rd}', 'percentiles'};
text(2100+10,-0.04,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

print(gcf,'../PNGs/SSP585_SL_Regional.png','-dpng','-r1000', '-painters');

%% Save data from figures

var_name = 'SL_change';
var_units = 'meters';
comments = "Data is for Figure 9.26 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

ncfilename = '../Plotted_Data/Fig9-26_data_ssp126_glacier_timeseries.nc';
title = "Median projected contribution of Glaciers to Sea Level Change under SSP1-2.6";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, ssp126_glaciers_median, ...
    years, title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp126_Greenland_timeseries.nc';
title = "Median projected contribution of Greenland Ice Sheets to Sea Level Change under SSP1-2.6";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, ssp126_Greenland_median, ...
    years, title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp126_Antarctic_timeseries.nc';
title = "Median projected contribution of Antarctic Ice Sheets to Sea Level Change under SSP1-2.6";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, ssp126_Antarctic_median, ...
    years, title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp126_thermalexpansion_timeseries.nc';
title = "Median projected contribution of Ocean Thermal Expansion to Sea Level Change under SSP1-2.6";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, ssp126_thermalexpansion_median, ...
    years, title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp126_landwater_timeseries.nc';
title = "Median projected contribution of Land Water Storage to Sea Level Change under SSP1-2.6";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, ssp126_landwater_median, ...
    years, title, comments)

% Repeat for SSP5-8.5

ncfilename = '../Plotted_Data/Fig9-26_data_ssp585_glacier_timeseries.nc';
title = "Median projected contribution of Glaciers to Sea Level Change under SSP5-8.5";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, ssp585_glaciers_median, ...
    years, title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp585_Greenland_timeseries.nc';
title = "Median projected contribution of Greenland Ice Sheets to Sea Level Change under SSP5-8.5";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, ssp585_Greenland_median, ...
    years, title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp585_Antarctic_timeseries.nc';
title = "Median projected contribution of Antarctic Ice Sheets to Sea Level Change under SSP5-8.5";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, ssp585_Antarctic_median, ...
    years, title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp585_thermalexpansion_timeseries.nc';
title = "Median projected contribution of Ocean Thermal Expansion to Sea Level Change under SSP5-8.5";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, ssp585_thermalexpansion_median, ...
    years, title, comments)

ncfilename = '../Plotted_Data/Fig9-26_data_ssp585_landwater_timeseries.nc';
title = "Median projected contribution of Land Water Storage to Sea Level Change under SSP5-8.5";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, ssp585_landwater_median, ...
    years, title, comments)

% Save ranges that are used for bars to right of plot

creator = "Brodie Pearson (brodie.pearson@oregonstate.edu)";
activity = "IPCC AR6 (Chapter 9)";

ncfilename = '../Plotted_Data/Fig9-26_2100likelyranges.nc';
title = "Medians and 17th-83rd percentiles of projected sea level contributions for SSP1-2.6 or SSP5-8.5";

% Create variables in netcdf files
nccreate(ncfilename,'ssp585_landwater_median');
nccreate(ncfilename,'ssp585_landwater_83rd_percentile');
nccreate(ncfilename,'ssp585_landwater_17th_percentile');
ncwrite(ncfilename,'ssp585_landwater_median',ssp585_landwater_median(end));
ncwrite(ncfilename,'ssp585_landwater_83rd_percentile',ssp585_landwater_upper_likely(end));
ncwrite(ncfilename,'ssp585_landwater_17th_percentile',ssp585_landwater_lower_likely(end));

nccreate(ncfilename,'ssp585_Greenland_median');
nccreate(ncfilename,'ssp585_Greenland_83rd_percentile');
nccreate(ncfilename,'ssp585_Greenland_17th_percentile');
ncwrite(ncfilename,'ssp585_Greenland_median',ssp585_Greenland_median(end));
ncwrite(ncfilename,'ssp585_Greenland_83rd_percentile',ssp585_Greenland_upper_likely(end));
ncwrite(ncfilename,'ssp585_Greenland_17th_percentile',ssp585_Greenland_lower_likely(end));

nccreate(ncfilename,'ssp585_Antarctic_median');
nccreate(ncfilename,'ssp585_Antarctic_83rd_percentile');
nccreate(ncfilename,'ssp585_Antarctic_17th_percentile');
ncwrite(ncfilename,'ssp585_Antarctic_median',ssp585_Antarctic_median(end));
ncwrite(ncfilename,'ssp585_Antarctic_83rd_percentile',ssp585_Antarctic_upper_likely(end));
ncwrite(ncfilename,'ssp585_Antarctic_17th_percentile',ssp585_Antarctic_lower_likely(end));

nccreate(ncfilename,'ssp585_thermalexpansion_median');
nccreate(ncfilename,'ssp585_thermalexpansion_83rd_percentile');
nccreate(ncfilename,'ssp585_thermalexpansion_17th_percentile');
ncwrite(ncfilename,'ssp585_thermalexpansion_median',ssp585_thermalexpansion_median(end));
ncwrite(ncfilename,'ssp585_thermalexpansion_83rd_percentile',ssp585_thermalexpansion_upper_likely(end));
ncwrite(ncfilename,'ssp585_thermalexpansion_17th_percentile',ssp585_thermalexpansion_lower_likely(end));

nccreate(ncfilename,'ssp585_glaciers_median');
nccreate(ncfilename,'ssp585_glaciers_83rd_percentile');
nccreate(ncfilename,'ssp585_glaciers_17th_percentile');
ncwrite(ncfilename,'ssp585_glaciers_median',ssp585_glaciers_median(end));
ncwrite(ncfilename,'ssp585_glaciers_83rd_percentile',ssp585_glaciers_upper_likely(end));
ncwrite(ncfilename,'ssp585_glaciers_17th_percentile',ssp585_glaciers_lower_likely(end));

nccreate(ncfilename,'ssp126_landwater_median');
nccreate(ncfilename,'ssp126_landwater_83rd_percentile');
nccreate(ncfilename,'ssp126_landwater_17th_percentile');
ncwrite(ncfilename,'ssp126_landwater_median',ssp126_landwater_median(end));
ncwrite(ncfilename,'ssp126_landwater_83rd_percentile',ssp126_landwater_upper_likely(end));
ncwrite(ncfilename,'ssp126_landwater_17th_percentile',ssp126_landwater_lower_likely(end));

nccreate(ncfilename,'ssp126_Greenland_median');
nccreate(ncfilename,'ssp126_Greenland_83rd_percentile');
nccreate(ncfilename,'ssp126_Greenland_17th_percentile');
ncwrite(ncfilename,'ssp126_Greenland_median',ssp126_Greenland_median(end));
ncwrite(ncfilename,'ssp126_Greenland_83rd_percentile',ssp126_Greenland_upper_likely(end));
ncwrite(ncfilename,'ssp126_Greenland_17th_percentile',ssp126_Greenland_lower_likely(end));

nccreate(ncfilename,'ssp126_Antarctic_median');
nccreate(ncfilename,'ssp126_Antarctic_83rd_percentile');
nccreate(ncfilename,'ssp126_Antarctic_17th_percentile');
ncwrite(ncfilename,'ssp126_Antarctic_median',ssp126_Antarctic_median(end));
ncwrite(ncfilename,'ssp126_Antarctic_83rd_percentile',ssp126_Antarctic_upper_likely(end));
ncwrite(ncfilename,'ssp126_Antarctic_17th_percentile',ssp126_Antarctic_lower_likely(end));

nccreate(ncfilename,'ssp126_thermalexpansion_median');
nccreate(ncfilename,'ssp126_thermalexpansion_83rd_percentile');
nccreate(ncfilename,'ssp126_thermalexpansion_17th_percentile');
ncwrite(ncfilename,'ssp126_thermalexpansion_median',ssp126_thermalexpansion_median(end));
ncwrite(ncfilename,'ssp126_thermalexpansion_83rd_percentile',ssp126_thermalexpansion_upper_likely(end));
ncwrite(ncfilename,'ssp126_thermalexpansion_17th_percentile',ssp126_thermalexpansion_lower_likely(end));

nccreate(ncfilename,'ssp126_glaciers_median');
nccreate(ncfilename,'ssp126_glaciers_83rd_percentile');
nccreate(ncfilename,'ssp126_glaciers_17th_percentile');
ncwrite(ncfilename,'ssp126_glaciers_median',ssp126_glaciers_median(end));
ncwrite(ncfilename,'ssp126_glaciers_83rd_percentile',ssp126_glaciers_upper_likely(end));
ncwrite(ncfilename,'ssp126_glaciers_17th_percentile',ssp126_glaciers_lower_likely(end));



% Write metadata to netcdf file
ncwriteatt(ncfilename,'/','title',title);
ncwriteatt(ncfilename,'/','units',var_units);
ncwriteatt(ncfilename,'/','creator',creator);
ncwriteatt(ncfilename,'/','activity',activity);
ncwriteatt(ncfilename,'/','comments',comments);


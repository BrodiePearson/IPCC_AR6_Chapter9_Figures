%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surfact temperature (SST) - named tos in CMIP6 

clear all

hist_change_start_year = 1950;
hist_change_end_year = 2014;
SSP_change_end_year = 2100;
HRSSP_change_end_year = 2050;

savefile = 'SST_Maps_Newest';
load(savefile)

fontsize = 15;

%% Plot mean SST averaged over past few decades

color_bar = IPCC_Get_Colorbar('temperature_nd', 21, false);

lims = [-2 30];

%figure(2)
mask = SST_OBS<15 | SST_OBS>25;

IPCC_Plot_Map(SST_OBS',lat,lon,lims, ...
    color_bar,"Observation-based Climatology (HadISST; "+bias_start_year+"-"+bias_end_year+")",...
    1,fontsize, true, 'Sea Surface Temperature (SST; ^oC)',mask')

print(gcf,'../PNGs/Observed_SST_colorbar.png','-dpng','-r1000', '-painters');

close(1)

IPCC_Plot_Map(SST_OBS',lat,lon,lims, ...
    color_bar,"Observation-based Climatology (HadISST; "+bias_start_year+"-"+bias_end_year+")",...
    1,fontsize, false, '',mask')

print(gcf,'../PNGs/Observed_SST.png','-dpng','-r1000', '-painters');

close(1);


%% Load SSP585 data & Create a plot of future change under SSP585

multimodel_change_CMIP = nanmean(SST_change_CMIP,4);
multimodel_change_HRMIP = nanmean(SST_change_HRMIP,4);
multimodel_change_SSP585 = nanmean(SST_change_SSP585,4);
multimodel_change_HRSSP = nanmean(SST_change_HRSSP,4);

% lim_max = nanmax(abs([multimodel_change_HRMIP(:); SST_change_OBS(:); ...
%     multimodel_change_CMIP(:); multimodel_change_SSP585(:); multimodel_change_HRSSP(:)]));
lim_max = 0.8;

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
color_bar = [color_bar2(3:11,:); color_bar1];

lims = [-0.4 1]*lim_max;


%% Plot Observed modern SST rate of change 

IPCC_Plot_Map(SST_change_OBS' ...
    ,lat,lon,lims, color_bar, ...
    "Observation-based rate of change ("+hist_change_start_year+"-"+hist_change_end_year+")",2, ...
    fontsize,false)

print(gcf,'../PNGs/Observed_SST_change.png','-dpng','-r1000', '-painters');

close(2)

%% Plot CMIP modern SST rate of change

IPCC_Plot_Map(multimodel_change_CMIP' ...
    ,lat,lon,lims, color_bar, ...
    "CMIP_{"+num2str(size(SST_change_CMIP,4))+"} rate of change ("+hist_change_start_year+"-"+hist_change_end_year+")",3, ...
    fontsize,false)

print(gcf,'../PNGs/CMIP_SST_change.png','-dpng','-r1000', '-painters');

close(3)

%% Plot HighResMIP modern SST rate of change

IPCC_Plot_Map(multimodel_change_HRMIP' ...
    ,lat,lon,lims, color_bar, ...
    "HighResMIP_{"+num2str(size(SST_change_HRMIP,4))+"} rate of change ("+hist_change_start_year+"-"+hist_change_end_year+")",4, ...
    fontsize,false)

print(gcf,'../PNGs/HRMIP_SST_change.png','-dpng','-r1000', '-painters');

close(4)

%% Plot SSP585 predicted SST rate of change

IPCC_Plot_Map(multimodel_change_SSP585' ...
    ,lat,lon,lims,color_bar, ...
    "SSP5-8.5_{"+num2str(size(SST_change_SSP585,4))+"} rate of change ("+ ...
    SSP_change_start_year+"-"+SSP_change_end_year+")",5, ...
    fontsize, true, 'SST Change (^oC)')

print(gcf,'../PNGs/SSP585_SST_change_colorbar.png','-dpng','-r1000', '-painters');

close(5)

IPCC_Plot_Map(multimodel_change_SSP585' ...
    ,lat,lon,lims,color_bar, ...
    "SSP5-8.5_{"+num2str(size(SST_change_SSP585,4))+"} rate of change ("+ ...
    SSP_change_start_year+"-"+SSP_change_end_year+")",5, ...
    fontsize, false)

print(gcf,'../PNGs/SSP585_SST_change.png','-dpng','-r1000', '-painters');

close(5)

%% Plot HighResMIP SSP585 predicted SST rate of change

IPCC_Plot_Map(multimodel_change_HRSSP' ...
    ,lat,lon,lims,color_bar, ...
    "HighResMIP_{"+num2str(size(SST_change_HRSSP,4))+"} SSP5-8.5 rate of change (" ...
    +HRSSP_change_start_year+"-"+HRSSP_change_end_year+")",6, ...
    fontsize, true, 'SST Change (^oC)')

print(gcf,'../PNGs/HRSSP_SST_change_colorbar.png','-dpng','-r1000', '-painters');

close(6)

IPCC_Plot_Map(multimodel_change_HRSSP' ...
    ,lat,lon,lims,color_bar, ...
    "HighResMIP_{"+num2str(size(SST_change_HRSSP,4))+"} SSP5-8.5 rate of change (" ...
    +HRSSP_change_start_year+"-"+HRSSP_change_end_year+")",6, ...
    fontsize, false)

print(gcf,'../PNGs/HRSSP_SST_change.png','-dpng','-r1000', '-painters');

close(6)

%% Test maps

temp = multimodel_change_HRSSP;
temp_neg = temp;
temp_neg(multimodel_change_HRSSP>=0)=NaN;
temp_pos = temp;
temp_pos(multimodel_change_HRSSP<=0)=NaN;

figure
subplot(2,1,1)
imagesc(fliplr(temp_neg)')
c = colorbar;
c.Label.String = 'HRSSP Negative';
colormap('Bone')
%c.Limits = lims;
subplot(2,1,2)
imagesc(-fliplr(temp_pos)')
c2 = colorbar;
c2.Label.String = 'HRSSP Positive';


%% Maps of present model biases realtive to map of present SST (Fig 1)

color_bar = IPCC_Get_Colorbar('chem_d', 21, true);

% lim_max = nanmax(abs([multimodel_CMIP_bias(:); multimodel_HRMIP_bias(:)]));
lim_max = 8;
lim_min = -lim_max;
lims = [lim_min lim_max];

multimodel_CMIP_bias = nanmean(SST_bias_CMIP,3);
multimodel_HRMIP_bias = nanmean(SST_bias_HRMIP,3);

%% Plot CMIP SST bias vs. observations

% Averaging Index is shifted by 1 for biases
IPCC_Plot_Map(multimodel_CMIP_bias' ...
    ,lat,lon,lims,color_bar, ...
    "CMIP_{"+num2str(size(SST_bias_CMIP,3))+"} Bias ("+bias_start_year+"-"+bias_end_year+")",7, ...
    fontsize,false)

print(gcf,'../PNGs/CMIP_SST_bias.png','-dpng','-r1000', '-painters');
close(7)

%% Plot HRMIP SST bias vs. observations

IPCC_Plot_Map(multimodel_HRMIP_bias' ...
    ,lat,lon,lims,color_bar, ...
    "HighResMIP_{"+num2str(size(SST_bias_HRMIP,3))+"} Bias ("+bias_start_year+"-"+bias_end_year+")",8, ...
    fontsize, true, 'Model Bias (^oC)')

print(gcf,'../PNGs/HighResMIP_SST_bias_colorbar.png','-dpng','-r1000', '-painters');
close(8)

IPCC_Plot_Map(multimodel_HRMIP_bias' ...
    ,lat,lon,lims,color_bar, ...
    "HighResMIP_{"+num2str(size(SST_bias_HRMIP,3))+"} Bias ("+bias_start_year+"-"+bias_end_year+")",8, ...
    fontsize, false)

print(gcf,'../PNGs/HighResMIP_SST_bias.png','-dpng','-r1000', '-painters');
close(8)

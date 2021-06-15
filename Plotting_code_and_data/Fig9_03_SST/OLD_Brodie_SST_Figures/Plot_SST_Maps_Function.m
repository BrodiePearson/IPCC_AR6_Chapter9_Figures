%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surfact temperature (SST) - named tos in CMIP6 

clear all
% 
% ref_start = 1995;
% ref_end = 2014;

savefile = 'SST_Maps_New';
load(savefile)

%% Calculate means and stds of multi-model data

SST_change_mean_OBS = SST_change_OBS;
SST_change_mean_CMIP = nanmean(SST_change_CMIP,3);
SST_bias_mean_CMIP = nanmean(SST_bias_CMIP,3);
SST_change_mean_HRMIP = nanmean(SST_change_HRMIP,3);
SST_bias_mean_HRMIP = nanmean(SST_bias_HRMIP,3);
SST_change_mean_SSP585 = nanmean(SST_change_SSP585,3);
SST_change_mean_HRSSP = nanmean(SST_change_HRSSP,3);

%%

fontsize = 25;

color_bar = IPCC_Get_Colorbar('temperature_nd', 21, false);

lim_min = nanmin(SST_ref_OBS(:));
lim_max = nanmax(SST_ref_OBS(:));

%figure(2)
mask = SST_ref_OBS<15 | SST_ref_OBS>25;

IPCC_Plot_Map(SST_ref_OBS',lat,lon,[lim_min lim_max], ...
    color_bar,"Observations ( "+ref_start+"-"+ref_end+")",...
    1,fontsize, true, 'Sea Surface Temperature (SST; ^oC)',mask')


%% Load SSP585 data & Create a plot of future change under SSP585

lim_max = nanmax(abs([SST_change_mean_HRMIP(:); SST_change_mean_OBS(:); ...
    SST_change_mean_CMIP(:); SST_change_mean_SSP585(:); SST_change_mean_HRSSP(:)]));
lim_max = 0.8;
% lim_min = -lim_max;
% 
% color_bar = IPCC_Get_Colorbar('temperature_d', 21, false);

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
color_bar = [color_bar2(3:11,:); color_bar1];

lims = [-0.4 1]*lim_max;

IPCC_Plot_Map(SST_change_mean_OBS'*10/(hist_ave_end-hist_ave_start) ...
    ,lat,lon,lims, color_bar, ...
    "Observed Change Rate "+hist_ave_start+"-"+hist_ave_end,2, ...
    fontsize,false)

IPCC_Plot_Map(SST_change_mean_CMIP'*10/(hist_ave_end-hist_ave_start) ...
    ,lat,lon,lims, color_bar, ...
    "CMIP Change Rate "+hist_ave_start+"-"+hist_ave_end,3, ...
    fontsize,false)

IPCC_Plot_Map(SST_change_mean_HRMIP'*10/(hist_ave_end-hist_ave_start) ...
    ,lat,lon,lims, color_bar, ...
    "HighResMIP Change Rate "+hist_ave_start+"-"+hist_ave_end,4, ...
    fontsize,false)

IPCC_Plot_Map(SST_change_mean_SSP585'*10/(proj_ssp_ave_end-proj_ssp_ave_start) ...
    ,lat,lon,lims,color_bar, ...
    "SSP585 Change Rate "+proj_ssp_ave_start+"-"+proj_ssp_ave_end,7, ...
    fontsize, true, 'SST Change (^oC)/decade')

IPCC_Plot_Map(SST_change_mean_HRSSP'*10/(proj_hrssp_ave_end-proj_hrssp_ave_start) ...
    ,lat,lon,lims,color_bar, ...
    "HighResMIP SSP585 Change Rate "+proj_hrssp_ave_start+"-"+proj_hrssp_ave_end,8, ...
    fontsize, true, 'SST Change (^oC)/decade')

%% Maps of present model biases realtive to map of present SST (Fig 1)

color_bar = IPCC_Get_Colorbar('chem_d', 21, true);

lim_max = nanmax(abs([SST_bias_mean_CMIP(:); SST_bias_mean_HRMIP(:)]));
lim_max = 8;
lim_min = -lim_max;

IPCC_Plot_Map(SST_bias_mean_CMIP' ...
    ,lat,lon,[lim_min lim_max],color_bar, ...
    "CMIP Bias ("+ref_start+"-"+ref_end+")",10, ...
    fontsize,false)

IPCC_Plot_Map(SST_bias_mean_HRMIP' ...
    ,lat,lon,[lim_min lim_max],color_bar, ...
    "HighResMIP Bias ("+ref_start+"-"+ref_end+")",11, ...
    fontsize, true, 'Model Bias (^oC)')

%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surfact temperature (SST) - named tos in CMIP6 

clear all

var_name = {'tos'};

fontsize = 25;
data_path = '../../../../../';

% Define reference period for 'present-day' maps
ref_start_yr = 1995;
ref_end_yr = 2014;

% Define averaging length for start and end of 'change' calculations
ave_period = 10; %years

% Define the time period over which HighResMIP, CMIP, and Obs are all
% available change calculation
common_start_yr = 1950;
common_end_yr = 2014;

% Define the time period with overlapping obs and CMIP, before HighResMIP,
% for early change calculation
early_start_yr = 1885;
early_end_yr = 1949;

% Define thetime period for projections using CMIP and likely HighResMIP
proj_start_yr = 2015;
proj_end_yr = 2079;

% Define start and end years of models, CMIP, and HighResMIP
obs_start_yr = 1870;
HR_start_yr = 1950;
CMIP_start_yr = 1850;
SSP_start_yr = 2015;


%% Load observational dataset and high-res model data (change to multimodel when available)

obs_end_yr = 2017;
data_dir = data_path + "/tos/Gridded_1degree/OBS_HadISST_reanaly_1_Omon_tos_" ...
    + obs_start_yr + "-" + obs_end_yr + ".nc";
obs_sst_data = ncread(data_dir,'tos');
obs_sst_data = obs_sst_data - 273.15;


%% Load HighResMIP data

% model_name = {'CNRM-CM6-1-HR', 'CNRM-CM6-1', 'ECMWF-IFS-HR', ...
%     'ECMWF-IFS-LR'};

model_name = {'CNRM-CM6-1-HR', 'ECMWF-IFS-HR'};

exp_name = {'hist-1950'};

[HR_sst_data, lat, lon] = IPCC_CMIP6_Load(exp_name, var_name, model_name, data_path);

%% Create lists of model names and experiment names for this figure

model_name = {'CAMS-CSM1-0', 'CanESM5', 'CNRM-CM6-1', 'CESM2', ...
    'CESM2-WACCM', 'CNRM-ESM2-1', 'IPSL-CM6A-LR', 'MIROC6'};

exp_name = {'historical'};

[multi_model_data, lat, lon] = IPCC_CMIP6_Load(exp_name, var_name, model_name, data_path);


%% Plot observed SST over a specific time period (then CMIP and HighResMIP)

% Select appropriate obs data (monthly)
index_start_yr = (ref_start_yr - obs_start_yr)*12 +1; % Start in January
index_end_yr = (ref_end_yr - obs_start_yr)*12 +12; % End in December

obs_map_data = obs_sst_data(:,:,index_start_yr:index_end_yr);

% Then plot CMIP + HighResMIP biases relative to observations over same period

% Select appropriate HR [HighResMIP] data (monthly)
index_start_yr = (ref_start_yr - HR_start_yr)*12 +1; % Start in January
index_end_yr = (ref_end_yr - HR_start_yr)*12 +12; % End in December

HR_map_data = HR_sst_data(:,:,index_start_yr:index_end_yr,:);

% Select appropriate CMIP data (monthly)
index_start_yr = (ref_start_yr - CMIP_start_yr)*12 +1; % Start in January
index_end_yr = (ref_end_yr - CMIP_start_yr)*12 +12; % End in December

CMIP_map_data = multi_model_data(:,:,index_start_yr:index_end_yr,:);

MMM_CMIP = nanmean(CMIP_map_data, 4);

MMM_HR = nanmean(HR_map_data, 4);

color_bar = IPCC_Get_Colorbar('temperature_nd', 21, false);

plot_var1 = nanmean(obs_map_data,3)';
plot_var2 = nanmean(MMM_CMIP,3)';
plot_var3 = nanmean(MMM_HR,3)';

lim_min = nanmin(plot_var1(:));
lim_max = nanmax(plot_var1(:));

%figure(2)
mask = plot_var1<15 | plot_var1>25;

IPCC_Plot_Map(plot_var1,lat,lon,[lim_min lim_max], ...
    color_bar,"Observations ( "+ref_start_yr+"-"+ref_end_yr+")",...
    1,fontsize, true, 'Sea Surface Temperature (SST; ^oC)',mask)
savefig('SST_Obs.fig')

% figure
% cbar_limits = [lim_min lim_max];
% colorscheme=color_bar;
% plot_title = "Observations ( "+ref_start_yr+"-"+ref_end_yr+")";
% plot_bar = true;
% bar_title = 'Sea Surface Temperature (SST; ^oC)';
% stipple_mask = mask;
% landareas = shaperead('landareas.shp','UseGeoCoords',true);
% colors = colorscheme;
% latitude = lat;
% 
% mapped_variable = [plot_var1 plot_var1(:,1)];
% longitude = [lon; lon(1)];
% 
% levels = cbar_limits(1)+(0:size(colors,1))*(cbar_limits(2)- ...
%     cbar_limits(1))/(size(colors,1));
% 
% axesm ('eckert4','Frame','on','Grid','on','MeridianLabel','on','ParallelLabel','on');
% setm(gca, 'Origin', [0 210 0], 'MlabelLocation', 60, ...
%     'PlabelLocation',[-60, -30, 0, 30, 60] ,...
%     'MlabelParallel','north','MeridianLabel','off',...
%     'ParallelLabel','off','MlineLocation',60,...
%     'PlineLocation',[-60, -30, 0, 30, 60],'FontSize', fontsize, ...
%     'PLabelMeridian', 'west')
% %setm(gca, 'Origin', [0 210 0])
% 
% geoshow(landareas,'FaceColor',[0 0 0],'EdgeColor',[.6 .6 .6]);
% contourm(latitude,longitude,mapped_variable, levels,'Fill','on','LineColor', 'k')
% title(plot_title, 'FontSize', fontsize)
% caxis(cbar_limits)
% colormap(gca,colors)
% box off
% axis off




%% Plot temperature change over common period (1950-2014)
% For now a 10-year mean will be used at each end of the time-period

% Select appropriate obs data for start period
index_start_yr = (common_start_yr - obs_start_yr)*12 +1; % Start in January
index_end_yr = (common_end_yr - obs_start_yr)*12 +12; % End in December

obs_start_change_data = obs_sst_data(:,:,index_start_yr:index_start_yr+12*ave_period);

obs_end_change_data = obs_sst_data(:,:,index_end_yr-12*ave_period:index_end_yr);

% colorchoice = flip(divergent_sst_map); % Flip for blue=cold and red=hot

% Select appropriate HR data for start period
index_start_yr = (common_start_yr - HR_start_yr)*12 +1; % Start in January
index_end_yr = (common_end_yr - HR_start_yr)*12 +12; % End in December

HR_start_change_data = HR_sst_data(:,:,index_start_yr:index_start_yr+12*ave_period);

HR_end_change_data = HR_sst_data(:,:,index_end_yr-12*ave_period:index_end_yr);

% Select appropriate CMIP data for start period
index_start_yr = (common_start_yr - CMIP_start_yr)*12 +1; % Start in January
index_end_yr = (common_end_yr - CMIP_start_yr)*12 +12; % End in December

CMIP_start_change_data = nanmean(multi_model_data(:,:, ...
    index_start_yr:index_start_yr+12*ave_period,:,:),4);

CMIP_end_change_data = nanmean(multi_model_data(:,:, ...
    index_end_yr-12*ave_period:index_end_yr,:,:),4);

common_period_start_yr = common_start_yr + 0.5*ave_period;
common_period_end_yr = common_end_yr - 0.5*ave_period;

plot_var4 = nanmean(obs_end_change_data,3)' - nanmean(obs_start_change_data,3)';
plot_var5 = nanmean(CMIP_end_change_data,3)' - nanmean(CMIP_start_change_data,3)';
plot_var6 = nanmean(HR_end_change_data,3)' - nanmean(HR_start_change_data,3)';


%% Plot temparuture change over early period (1885-1949; CMIP and OBS only)
% For now a 10-year mean will be used at each end of the time-period

% Select appropriate obs data for start period
index_start_yr = (early_start_yr - obs_start_yr)*12 +1; % Start in January
index_end_yr = (early_end_yr - obs_start_yr)*12 +12; % End in December

obs_start_change_data = obs_sst_data(:,:,index_start_yr:index_start_yr+12*ave_period);

obs_end_change_data = obs_sst_data(:,:,index_end_yr-12*ave_period:index_end_yr);

% Select appropriate CMIP data for start period
index_start_yr = (early_start_yr - CMIP_start_yr)*12 +1; % Start in January
index_end_yr = (early_end_yr - CMIP_start_yr)*12 +12; % End in December

CMIP_start_change_data = nanmean(multi_model_data(:,:,index_start_yr:index_start_yr+12*ave_period,:,:),4);

CMIP_end_change_data = nanmean(multi_model_data(:,:,index_end_yr-12*ave_period:index_end_yr,:,:),4);

early_period_start_yr = early_start_yr + 0.5*ave_period;
early_period_end_yr = early_end_yr - 0.5*ave_period;

plot_var7 = nanmean(obs_end_change_data,3)' - nanmean(obs_start_change_data,3)';
plot_var8 = nanmean(CMIP_end_change_data,3)' - nanmean(CMIP_start_change_data,3)';


%% Load SSP585 data & Create a plot of future change under SSP585

exp_name = {'ssp585'};

[multi_model_data, lat, lon] = IPCC_CMIP6_Load(exp_name, var_name, model_name, data_path);

% Select appropriate CMIP data (monthly)
index_start_yr = (proj_start_yr - SSP_start_yr)*12 +1; % Start in January
index_end_yr = (proj_end_yr - SSP_start_yr)*12 +12; % End in December

CMIP_start_change_data = nanmean(multi_model_data(:,:,index_start_yr:index_start_yr+12*ave_period,:,:),4);

CMIP_end_change_data = nanmean(multi_model_data(:,:,index_end_yr-12*ave_period:index_end_yr,:,:),4);

proj_period_start_yr = proj_start_yr + 0.5*ave_period;
proj_period_end_yr = proj_end_yr - 0.5*ave_period;

plot_var9 = nanmean(CMIP_end_change_data,3)' - ...
    nanmean(CMIP_start_change_data,3)';

lim_max = nanmax(abs([plot_var4(:); plot_var5(:); plot_var6(:); plot_var7(:); ...
    plot_var8(:); plot_var9(:)]));
lim_min = -lim_max;

color_bar = IPCC_Get_Colorbar('temperature_d', 21, false);

IPCC_Plot_Map(plot_var4 ...
    ,lat,lon,[lim_min lim_max], color_bar, ...
    "Observed Change "+common_period_start_yr+"-"+common_period_end_yr,2, ...
    fontsize,false)
savefig('SST_Obs_Change_Common.fig')

IPCC_Plot_Map(plot_var5 ...
    ,lat,lon,[lim_min lim_max], color_bar, ...
    "CMIP Change "+common_period_start_yr+"-"+common_period_end_yr,3, ...
    fontsize,false)
savefig('SST_CMIP_Change_Common.fig')

IPCC_Plot_Map(plot_var6 ...
    ,lat,lon,[lim_min lim_max], color_bar, ...
    "HighResMIP Change "+common_period_start_yr+"-"+common_period_end_yr,4, ...
    fontsize,false)
savefig('SST_HighResMIP_Change_Common.fig')

IPCC_Plot_Map(plot_var7 ...
    ,lat,lon,[lim_min lim_max],color_bar, ...
    "Observed Change "+early_period_start_yr+"-"+early_period_end_yr,5, ...
    fontsize,false)
savefig('SST_Obs_Change_Early.fig')

IPCC_Plot_Map(plot_var8 ...
    ,lat,lon,[lim_min lim_max],color_bar, ...
    "CMIP Change "+early_period_start_yr+"-"+early_period_end_yr,6, ...
    fontsize,false)
savefig('SST_CMIP_Change_Early.fig')

IPCC_Plot_Map(plot_var9 ...
    ,lat,lon,[lim_min lim_max],color_bar, ...
    "SSP585 Change "+proj_period_start_yr+"-"+proj_period_end_yr,7, ...
    fontsize, true, 'SST Change (^oC)')
savefig('SST_SSP585_Change.fig')

%% Maps of present model biases realtive to map of present SST (Fig 1)

% Subtract SST's CMIP (plot_var2) and HighResMIP (plot_var2) SST's from the
% present day observed SST (plot_var1)
plot_var10 = plot_var2 - plot_var1;
plot_var11 = plot_var3 - plot_var1;

color_bar = IPCC_Get_Colorbar('chem_d', 21, true);

lim_max = nanmax(abs([plot_var10(:); plot_var11(:)]));
lim_min = -lim_max;

IPCC_Plot_Map(plot_var10 ...
    ,lat,lon,[lim_min lim_max],color_bar, ...
    "CMIP Bias ("+ref_start_yr+"-"+ref_end_yr+")",10, ...
    fontsize,false)
savefig('SST_CMIP_Bias.fig')

IPCC_Plot_Map(plot_var11 ...
    ,lat,lon,[lim_min lim_max],color_bar, ...
    "HighResMIP Bias ("+ref_start_yr+"-"+ref_end_yr+")",11, ...
    fontsize, true, 'Model Bias (^oC)')
savefig('SST_HighResMIP_Bias.fig')

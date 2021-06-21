%% IPCC AR6 Chapter 9: Figure 9.6 Maps (Ocean Heat Content)
%
% Code used to plot pre-processed ocean heat content data. 
%
% Plotting code written by Brodie Pearson
% CMIP processed data provided by Yongqiang Yu & Lijuan Hua 
% Other datasets cited in report/caption


clear all

fontsize = 20;

addpath ../../../Functions/

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
change_color_bar = [color_bar2(3:11,:); color_bar1];

trend_color_bar = IPCC_Get_Colorbar('temperature_d', 21, false);
bias_color_bar = IPCC_Get_Colorbar('chem_d', 21, false);

lim_max = 15;
change_lims = [-0.4 1]*lim_max/3;
trend_lims = [-1 1]*lim_max;
bias_lims = [-1 1]*lim_max;


%% Load OHC trend fields (all experiments) and OHC mean (historical)

% First load last 10 year mean of each experiment
experiment = {'extract'};
suffix = '.nc';

% Define 1 x 1 degree grid for interpolation of different model data maps
lon = -179.5:179.5;
lat = -90:90;
[grid_lat, grid_lon] = meshgrid(lat,lon);


prefix = {'last10year_ohc700_'; 'last10year_ohc700_'; 'last10year_ohc700_'; ...
    'trend_ohc700_'; 'trend_ohc2000_'; 'trend_ohc2000'; 'trend_ohc700'};
data_path = {'./Processed_Data/historical_022521'; './Processed_Data/ssp126_030521'; ...
    './Processed_Data/ssp585_030521'; ...
    './Processed_Data//historical_022521'; './Processed_Data/historical_022521'; ...
    './Processed_Data/obs'; './Processed_Data/obs'};
count = {0,0,0,0,0,0};
for kk=1:size(data_path,1)
    datadir=dir(data_path{kk}+"/"+char(experiment)+"/");
    filenames = {datadir.name}; % Load filenames in path
    if contains(data_path{kk},'obs') % Observational data extraction
        obs_index = find(contains(filenames,char(prefix{kk})));
        if kk==7 % Get 700m OHC
            tmp_ohc = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
            "/"+filenames(obs_index)),'var255_0_131_700mbelowsealevel');
        tmp_lat = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
            "/"+filenames(obs_index)),'latitude');
        tmp_lon = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
            "/"+filenames(obs_index)),'longitude');
        elseif kk==6 % Get 2000m OHC
            tmp_ohc = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
            "/"+filenames(obs_index)),'var255_0_131_2000mbelowsealevel');
        tmp_lat = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
            "/"+filenames(obs_index)),'latitude');
        tmp_lon = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
            "/"+filenames(obs_index)),'longitude');
        else
        tmp_ohc = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
            "/"+filenames(obs_index)),'ohc');
        tmp_lat = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
            "/"+filenames(obs_index)),'lat');
        tmp_lon = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
            "/"+filenames(obs_index)),'lon');
        end
        if ndims(tmp_lon)==1
            [tmp_lat, tmp_lon] = meshgrid(tmp_lat,tmp_lon);
        end
        tmp_lon = wrapTo180(tmp_lon);
        tmp_ohc_gridded = griddata(tmp_lat,tmp_lon,tmp_ohc,grid_lat,grid_lon);
        ohc700{kk} = tmp_ohc_gridded;
        tmp_lon(tmp_lon>179) = tmp_lon(tmp_lon>179)-360;
        tmp_ohc_gridded = griddata(tmp_lat,tmp_lon,tmp_ohc,grid_lat,grid_lon);
        ohc700{kk}(1,:) = tmp_ohc_gridded(1,:);
        tmp_lon(tmp_lon<-179) = tmp_lon(tmp_lon<-179)+360;
        tmp_ohc_gridded = griddata(tmp_lat,tmp_lon,tmp_ohc,grid_lat,grid_lon);
        ohc700{kk}(end,:) = tmp_ohc_gridded(end,:);
            
    else % model data extraction
        
    i_models = find(contains(filenames,prefix{kk}) & ~contains(filenames,'CMCC-ESM2') ...
        & ~contains(filenames,'EC-Earth3-Veg-LR') & ~contains(filenames,'GFDL-ESM4') ...
        & ~contains(filenames,'NESM3'));
    for ii=1:size(i_models,2)
        count{kk} = count{kk} + 1;
        model_names{kk,count{kk}} = ...
            {strtok(erase(erase(filenames{1,i_models(ii)},prefix{kk}),suffix))};
        if kk==5 % Get 2000m OHC
            tmp_ohc = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                "/"+filenames(i_models(ii))),'OHC2000');
        else
            tmp_ohc = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                "/"+filenames(i_models(ii))),'OHC700');
            if kk==2 || kk==3 % SSP, so get historical for each model
                tmp_ohc_ref_hist = ncread(char(data_path{1}+"/"+char(experiment)+ ...
                "/"+filenames(i_models(ii))),'OHC700');
            end
        end
        tmp_ohc(tmp_ohc>1e100)=NaN(1); % Get rid of bad fill data
        if kk==2 ||kk==3 % SSP, so get historical for each model
            tmp_ohc_ref_hist(tmp_ohc_ref_hist>1e100)=NaN(1);
        end
        try
            var = 'latitude';
            tmp_lat = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                "/"+filenames(i_models(ii))),var);
        catch
            try
                var = 'LATITUDE';
                tmp_lat = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                    "/"+filenames(i_models(ii))),var);
            catch
                try
                    var = 'LAT';
                    tmp_lat = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                        "/"+filenames(i_models(ii))),var);
                catch
                    try
                        var = 'NAV_LAT';
                        tmp_lat = double(ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                            "/"+filenames(i_models(ii))),var));
                    catch
                        warning('No latitude values found')
                    end
                end
            end
        end
        try
            var = 'longitude';
            tmp_lon = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                "/"+filenames(i_models(ii))),var);
        catch
            try
                var = 'LONGITUDE';
                tmp_lon = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                    "/"+filenames(i_models(ii))),var);
            catch
                try
                    var = 'LON';
                    tmp_lon = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                        "/"+filenames(i_models(ii))),var);
                catch
                    try
                        var = 'NAV_LON';
                        tmp_lon = double(ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                        "/"+filenames(i_models(ii))),var));
                    catch
                        warning('No latitude values found')
                    end
                end
            end
        end
        if ndims(tmp_lon)==1
            [tmp_lat, tmp_lon] = meshgrid(tmp_lat,tmp_lon);
        end
        tmp_lon = wrapTo180(tmp_lon);
        tmp_ohc_gridded = griddata(tmp_lat,tmp_lon,tmp_ohc,grid_lat,grid_lon);
        ohc700{kk}(:,:,count{kk}) = tmp_ohc_gridded;
        tmp_lon(tmp_lon>179) = tmp_lon(tmp_lon>179)-360;
        tmp_ohc_gridded = griddata(tmp_lat,tmp_lon,tmp_ohc,grid_lat,grid_lon);
        ohc700{kk}(1,:,count{kk}) = tmp_ohc_gridded(1,:);
        tmp_lon(tmp_lon<-179) = tmp_lon(tmp_lon<-179)+360;
        tmp_ohc_gridded = griddata(tmp_lat,tmp_lon,tmp_ohc,grid_lat,grid_lon);
        ohc700{kk}(end,:,count{kk}) = tmp_ohc_gridded(end,:);
        
        if kk==2 ||kk==3 % SSP, so get historical for each model
            tmp_lon = wrapTo180(tmp_lon);
            tmp_ohc_gridded = griddata(tmp_lat,tmp_lon,tmp_ohc_ref_hist,grid_lat,grid_lon);
            ohc700_ref{kk}(:,:,count{kk}) = tmp_ohc_gridded;
            tmp_lon(tmp_lon>179) = tmp_lon(tmp_lon>179)-360;
            tmp_ohc_gridded = griddata(tmp_lat,tmp_lon,tmp_ohc_ref_hist,grid_lat,grid_lon);
            ohc700_ref{kk}(1,:,count{kk}) = tmp_ohc_gridded(1,:);
            tmp_lon(tmp_lon<-179) = tmp_lon(tmp_lon<-179)+360;
            tmp_ohc_gridded = griddata(tmp_lat,tmp_lon,tmp_ohc_ref_hist,grid_lat,grid_lon);
            ohc700_ref{kk}(end,:,count{kk}) = tmp_ohc_gridded(end,:);
        end
    end
    end
end

%% Plot OHC fields to test models fields are sensible

lim_max = 5e10;
lim_min = 0;

% Mean OHC colorbar
color_bar = IPCC_Get_Colorbar('temperature_nd', 21, false);

figure('Position', [10 10 1200 1200])
for ii=1:size(ohc700{1},3)
   subplot(ceil(sqrt(size(ohc700{1},3))), ...
        ceil(sqrt(size(ohc700{1},3))), ii);
    imagesc(lon,lat,fliplr(ohc700{1}(:,:,ii))');
    colormap(color_bar)
    title(model_names{1,ii})
    colorbar
    caxis([lim_min lim_max])
end
print(gcf,'../PNGs/Test_Maps/CMIP_OHC_Maps.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ohc700{2},3)
   subplot(ceil(sqrt(size(ohc700{2},3))), ...
        ceil(sqrt(size(ohc700{2},3))), ii);
    imagesc(lon,lat,fliplr(ohc700{2}(:,:,ii))');
    colormap(color_bar)
    title(model_names{2,ii})
    colorbar
    caxis([lim_min lim_max])
end
print(gcf,'../PNGs/Test_Maps/SSP126_OHC_Maps.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ohc700_ref{2},3)
   subplot(ceil(sqrt(size(ohc700_ref{2},3))), ...
        ceil(sqrt(size(ohc700_ref{2},3))), ii);
    imagesc(lon,lat,fliplr(ohc700_ref{2}(:,:,ii))');
    colormap(color_bar)
    title(model_names{2,ii})
    colorbar
    caxis([lim_min lim_max])
end
print(gcf,'../PNGs/Test_Maps/SSP126_ref_OHC_Maps.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ohc700{3},3)
   subplot(ceil(sqrt(size(ohc700{3},3))), ...
        ceil(sqrt(size(ohc700{3},3))), ii);
    imagesc(lon,lat,fliplr(ohc700{3}(:,:,ii))');
    colormap(color_bar)
    title(model_names{3,ii})
    colorbar
    caxis([lim_min lim_max])
end
print(gcf,'../PNGs/Test_Maps/SSP585_OHC_Maps.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ohc700_ref{3},3)
   subplot(ceil(sqrt(size(ohc700_ref{3},3))), ...
        ceil(sqrt(size(ohc700_ref{3},3))), ii);
    imagesc(lon,lat,fliplr(ohc700_ref{3}(:,:,ii))');
    colormap(color_bar)
    title(model_names{3,ii})
    colorbar
    caxis([lim_min lim_max])
end
print(gcf,'../PNGs/Test_Maps/SSP585_ref_OHC_Maps.png','-dpng','-r100', '-painters');
close(1)

lims = [0 1.5e9];
figure('Position', [10 10 1200 1200])
for ii=1:size(ohc700{4},3)
   subplot(ceil(sqrt(size(ohc700{4},3))), ...
        ceil(sqrt(size(ohc700{4},3))), ii);
    imagesc(lon,lat,fliplr(ohc700{4}(:,:,ii))'*120);
    colormap(color_bar)
    title(model_names{4,ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/OHC_Trend_0-700m_Maps.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ohc700{5},3)
   subplot(ceil(sqrt(size(ohc700{5},3))), ...
        ceil(sqrt(size(ohc700{5},3))), ii);
    imagesc(lon,lat,fliplr(ohc700{5}(:,:,ii))'*120);
    colormap(color_bar)
    title(model_names{5,ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/OHC_Trend_0-2000m_Maps.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
imagesc(lon,lat,fliplr(ohc700{6})'*120/10);
colormap(color_bar)
title('Observed Trend')
colorbar
caxis(lims)
print(gcf,'../PNGs/Test_Maps/Observed_OHC_Trend_0-2000m_Maps.png','-dpng','-r100', '-painters');
close(1)


%% Calculate projected rate of change maps

% Wrap OHC values
ssp126_change_rates = [ohc700{2} - ohc700_ref{2}; ...
    ohc700{2}(1,:,:) - ohc700_ref{2}(1,:,:)];
ssp126_change_rate = [nanmean(ssp126_change_rates,3)]';
% Diagnose OHC rate of change (J m^{-2} year^{-1})
ssp126_change_rate = ssp126_change_rate/(2100-2014);
%  Convert to W m^{-2}
ssp126_change_rate = ssp126_change_rate/(365*24*60*60);

%% Plot rate of change projection for SSP126

IPCC_Plot_Map(ssp126_change_rate, ...
     lat,[lon, lon(1)],change_lims, ...
    change_color_bar,"OHC change SSP1-2.6 (2005-2100)",...
    1,fontsize, true,'W m^{-2}')

hatch = abs(sum(sign(ssp126_change_rates),3))/size(ssp126_change_rates,3);
latitude = lat;
longitude = [lon'; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hold on
[c1, h1]=contourm(latitude,longitude,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);

print(gcf,'../PNGs/SSP126_OHC_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/SSP126_OHC.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/SSP126_OHC_Hatch_check.png','-dpng','-r100', '-painters');
close(1);

ncfilename = '../Plotted_Data/Fig9-6g_data.nc';
var_name = 'OHC_ChangeRate';
var_units = 'Watts per square meter';
title = "Rate of Change of ocean heat contentfrom 0-700m depth under SSP1-2.6"+...
    "between 2005-2100"+ ...
    " calculated from a CMIP6 (CMIP & ScenarioMIP) model ensemble";
comments = "Data is for panel (g) of Figure 9.6 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, ssp126_change_rate, ...
    lat', [lon, lon(1)]', title, comments, hatching_mask')

%% Plot SSP585 OHC change rate

% Wrap OHC values
ssp585_change_rates = [ohc700{3} - ohc700_ref{3}; ...
    ohc700{3}(1,:,:) - ohc700_ref{3}(1,:,:)];
ssp585_change_rate = [nanmean(ssp585_change_rates,3)]';
% Diagnose OHC rate of change (J m^{-2} year^{-1})
ssp585_change_rate = ssp585_change_rate/(2100-2014);
%  Convert to W m^{-2}
ssp585_change_rate = ssp585_change_rate/(365*24*60*60);

IPCC_Plot_Map(ssp585_change_rate, ...
     lat,[lon, lon(1)],change_lims, ...
    change_color_bar,"OHC change SSP5-8.5 (2005-2100)",...
    1,fontsize, true,'W m^{-2}')

hatch = abs(sum(sign(ssp585_change_rates),3))/size(ssp585_change_rates,3);
latitude = lat;
longitude = [lon'; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hold on
[c1, h1]=contourm(latitude,longitude,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);

print(gcf,'../PNGs/SSP585_OHC_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'./PNGs/SSP585_OHC.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/SSP585_OHC_Hatch_check.png','-dpng','-r100', '-painters');
close(1);

ncfilename = '../Plotted_Data/Fig9-6d_data.nc';
var_name = 'OHC_ChangeRate';
var_units = 'Watts per square meter';
title = "Rate of Change of ocean heat contentfrom 0-700m depth under SSP5-8.5"+...
    "between 2005-2100"+ ...
    " calculated from a CMIP6 (CMIP & ScenarioMIP) model ensemble";
comments = "Data is for panel (d) of Figure 9.6 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, ssp585_change_rate, ...
    lat', [lon, lon(1)]', title, comments, hatching_mask')

%% Plot obseved trends and biases in upper 2000m and CMIP bias

% Wrap OHC values [convert per year to per second = W m^{-2}]
obs_trend_0to2000m = [ohc700{6}; ohc700{6}(1,:)]/(365*24*60*60);

IPCC_Plot_Map(obs_trend_0to2000m', ...
     lat,[lon, lon(1)],trend_lims, ...
    trend_color_bar,"Observed OHC trend 0-2000m (2005-2014)",...
    1,fontsize, true,'W m^{-2}')

print(gcf,'../PNGs/Observed_OHC_Trend_0-2000m_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/Observed_OHC_Trend_0-2000m.png','-dpng','-r1000', '-painters');
close(1);

% Wrap OHC values [convert J m^{-2} month^{-1} to W m^{-2} ]
cmip_0to2000m_trends = [ohc700{5} ; ohc700{5}(1,:,:)]*12/(365*24*60*60);
cmip_0to2000m_trend = nanmean(cmip_0to2000m_trends,3)';

ncfilename = '../Plotted_Data/Fig9-6e_data.nc';
var_name = 'OHC_Trend';
var_units = 'Watts per square meter';
title = "Trend in ocean heat content from 0-2000m depth between 2005-2014"+ ...
    " calculated from observational reanalyses";
comments = "Data is for panel (e) of Figure 9.6 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, obs_trend_0to2000m', ...
    lat', [lon, lon(1)]', title, comments)

%% Plot CMIP bias

cmip_0to2000m_biases = cmip_0to2000m_trends - obs_trend_0to2000m;
cmip_0to2000m_bias = nanmean(cmip_0to2000m_biases,3);

IPCC_Plot_Map(cmip_0to2000m_bias', ...
     lat,[lon, lon(1)],bias_lims, ...
    bias_color_bar,"CMIP trend bias 0-2000m (2005-2014)",...
    1,fontsize, true,'W m^{-2}')

hatch = abs(sum(sign(cmip_0to2000m_biases(1:end-1,:,:)),3))/size(cmip_0to2000m_biases(1:end-1,:,:),3)';
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon'; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 

hatch(2,:)=1; hatch(65,70:end)=1; hatch(60,1:60)=1;
hatch(35,:)=1; hatch(185,1:60)=1;
hatch(10,1:40)=1; hatch(end-1,:)=1;
hatch(170,:)=1; hatch(350,120:end)=1;
hatch(245,:)=1;
hatch(315,:)=1;
hold on
[c1, h1]=contourm(latitude,longitude,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);

print(gcf,'../PNGs/CMIP_Trend_Bias_0-2000m_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/CMIP_Trend_Bias_0-2000m.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/CMIP_Trend_Bias_0-2000m_Hatch_check.png','-dpng','-r100', '-painters');
close(1);

ncfilename = '../Plotted_Data/Fig9-6f_data.nc';
var_name = 'OHC_bias';
var_units = 'Watts per square meter';
title = "Bias in the trends of ocean heat content from 0-2000m depth between 2005-2014"+ ...
    " calculated as difference between CMIP6 (CMIP) model ensemble and observations";
comments = "Data is for panel (f) of Figure 9.6 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, cmip_0to2000m_bias', ...
    lat', [lon, lon(1)]', title, comments, hatching_mask')

%% Plot obseved trends and biases in upper 700m and CMIP bias

% Wrap OHC values [convert per year to per second = W m^{-2}]
obs_trend_0to700m = [ohc700{7}; ohc700{7}(1,:)]/(365*24*60*60);

IPCC_Plot_Map(obs_trend_0to700m', ...
     lat,[lon, lon(1)],trend_lims/5, ...
    trend_color_bar,"Observed OHC trend 0-700m (2005-2014)",...
    1,fontsize, true,'W m^{-2}')

print(gcf,'../PNGs/Observed_OHC_Trend_0-700m_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'./PNGs/Observed_OHC_Trend_0-700m.png','-dpng','-r1000', '-painters');
close(1);

% Wrap OHC values [convert J m^{-2} month^{-1} to W m^{-2} ]
cmip_0to700m_trends = [ohc700{4} ; ohc700{4}(1,:,:)]*12/(365*24*60*60);
cmip_0to700m_trend = nanmean(cmip_0to700m_trends,3)';
% cmip_trend_0to700m = [nanmean(ohc700{5},3); nanmean(ohc700{5}(1,:,:),3)]' ...
%     *12/(365*24*60*60);
% cmip_trend_0to700m = [nanmean(ohc700{5},3); nanmean(ohc700{5}(1,:,:),3)]' ...
%     *12/(365*24*60*60);

ncfilename = '../Plotted_Data/Fig9-6b_data.nc';
var_name = 'OHC_Trend';
var_units = 'Watts per square meter';
title = "Trend in ocean heat content from 0-700m depth between 1971-2014"+ ...
    " calculated from observational reanalyses";
comments = "Data is for panel (b) of Figure 9.6 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, obs_trend_0to700m', ...
    lat', [lon, lon(1)]', title, comments)

%%

cmip_0to700m_biases = cmip_0to700m_trends - obs_trend_0to700m;
cmip_0to700m_bias = nanmean(cmip_0to700m_biases,3);

IPCC_Plot_Map(cmip_0to700m_bias', ...
     lat,[lon, lon(1)],bias_lims/5, ...
    bias_color_bar,"CMIP trend bias 0-700m (2005-2014)",...
    1,fontsize, true,'W m^{-2}')

hatch = abs(sum(sign(cmip_0to700m_biases(1:end-1,:,:)),3))/size(cmip_0to700m_biases(1:end-1,:,:),3)';
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon'; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
% hatch(185,85:90)=1; hatch(195,90:140)=1; hatch(315,90:120)=1; hatch(1,20:60)=1;
hatch(2,:)=1; hatch(65,70:end)=1; hatch(60,1:60)=1;
hatch(35,:)=1; hatch(185,1:60)=1;
hatch(end-3,1:40)=1;
hatch(170,:)=1;
hatch(245,:)=1;
hatch(297,:)=1;
hold on
[c1, h1]=contourm(latitude,longitude,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);

print(gcf,'../PNGs/CMIP_Trend_Bias_0-700m_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'./PNGs/CMIP_Trend_Bias_0-700m.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/CMIP_Trend_Bias_0-700m_Hatch_check.png','-dpng','-r100', '-painters');
close(1);

ncfilename = '../Plotted_Data/Fig9-6c_data.nc';
var_name = 'OHC_bias';
var_units = 'Watts per square meter';
title = "Bias in the trends of ocean heat content from 0-700m depth between 1971-2014"+ ...
    " calculated as difference between CMIP6 (CMIP) model ensemble and observations";
comments = "Data is for panel (c) of Figure 9.6 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, cmip_0to700m_bias', ...
    lat', [lon, lon(1)]', title, comments, hatching_mask')



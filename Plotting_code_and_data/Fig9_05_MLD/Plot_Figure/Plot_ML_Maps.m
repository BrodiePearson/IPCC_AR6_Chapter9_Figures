%% IPCC AR6 Chapter 9: Figure 9.5 (Mixed Layer Depths)
%
% Code used to plot pre-processed CMIP6 mixed layer depth data. 
%
% Plotting code written by Brodie Pearson
% Processed data provided by Yongqiang Yu & Lijuan Hua

clear all

fontsize = 24;
addpath ../../../Functions/


%% Load observations

load ./Processed_Data/UCSDML/ucsd.mat
lat_obs=lat;
lon_obs=lon;

color_bar = IPCC_Get_Colorbar('wind_nd', 21, true);

[lat, lon] = meshgrid(lat_obs,lon_obs);

ML_Obs_Summer=summer_filmn_mld_dt;
ML_Obs_Winter=winter_filmn_mld_dt;

%% Load models

experiment = {'regrid1x1'};
prefix = 'regrid_02_';
suffix = '.nc';
count_ssp126_02 = 0;
count_ssp126_08 = 0;
count_ssp585_02 = 0;
count_ssp585_08 = 0;
count_hist_02 = 0;
count_hist_08 = 0;

data_path = './Processed_Data/modified_ssp126'; %data_path = './ssp126_modelbymodel';
datadir=dir(data_path+"/"+char(experiment)+"/");
filenames = {datadir.name}; % Load filenames in path
for ii=1:size(filenames,2)
   if contains(filenames{1,ii},'_02_') && (~contains(filenames{1,ii},'CESM') ...
           || contains(filenames{1,ii},'WACCM'))% File is SH summer/NH winter
       count_ssp126_02 = count_ssp126_02 + 1;
       model_names_ssp126_02(count_ssp126_02) = ...
           {strtok(erase(filenames{1,ii},prefix),suffix)};
       mld_ssp126_02(:,:,count_ssp126_02) = ...
           ncread(char(data_path+"/"+char(experiment)+"/"+filenames(ii)),'mlotst');
   end
   if contains(filenames{1,ii},'_08_') && (~contains(filenames{1,ii},'CESM') ...
           || contains(filenames{1,ii},'WACCM')) % File is SH winter/NH summer
       count_ssp126_08 = count_ssp126_08 + 1;
       model_names_ssp126_08(count_ssp126_08) = ...
           {strtok(erase(filenames{1,ii},prefix),suffix)};
       mld_ssp126_08(:,:,count_ssp126_08) = ...
           ncread(char(data_path+"/"+char(experiment)+"/"+filenames(ii)),'mlotst');
   end
end

data_path = './Processed_Data/modified_ssp585'; %data_path = './ssp585_modelbymodel';
datadir=dir(data_path+"/"+char(experiment)+"/");
filenames = {datadir.name}; % Load filenames in path
for ii=1:size(filenames,2)
   if contains(filenames{1,ii},'_02_') && (~contains(filenames{1,ii},'CESM') ...
           || contains(filenames{1,ii},'WACCM')) % File is SH summer/NH winter
       count_ssp585_02 = count_ssp585_02 + 1;
       model_names_ssp585_02(count_ssp585_02) = ...
           {strtok(erase(filenames{1,ii},prefix),suffix)};
       mld_ssp585_02(:,:,count_ssp585_02) = ...
           ncread(char(data_path+"/"+char(experiment)+"/"+filenames(ii)),'mlotst');
   end
   if contains(filenames{1,ii},'_08_') && (~contains(filenames{1,ii},'CESM') ...
           || contains(filenames{1,ii},'WACCM')) % File is SH winter/NH summer
       count_ssp585_08 = count_ssp585_08 + 1;
       model_names_ssp585_08(count_ssp585_08) = ...
           {strtok(erase(filenames{1,ii},prefix),suffix)};
       mld_ssp585_08(:,:,count_ssp585_08) = ...
           ncread(char(data_path+"/"+char(experiment)+"/"+filenames(ii)),'mlotst');
   end
end

data_path = './Processed_Data/modified_historical'; %data_path = './historical_modelbymodel';
datadir=dir(data_path+"/"+char(experiment)+"/");
filenames = {datadir.name}; % Load filenames in path
for ii=1:size(filenames,2)
   if contains(filenames{1,ii},'_02_') && (~contains(filenames{1,ii},'CESM') ...
           || contains(filenames{1,ii},'WACCM')) % File is SH summer/NH winter
       count_hist_02 = count_hist_02 + 1;
       model_names_hist_02(count_hist_02) = ...
           {strtok(erase(filenames{1,ii},prefix),suffix)};
       mld_hist_02(:,:,count_hist_02) = ...
           ncread(char(data_path+"/"+char(experiment)+"/"+filenames(ii)),'mlotst');
   end
   if contains(filenames{1,ii},'_08_') && (~contains(filenames{1,ii},'CESM') ...
           || contains(filenames{1,ii},'WACCM')) % File is SH winter/NH summer
       count_hist_08 = count_hist_08 + 1;
       model_names_hist_08(count_hist_08) = ...
           {strtok(erase(filenames{1,ii},prefix),suffix)};
       mld_hist_08(:,:,count_hist_08) = ...
           ncread(char(data_path+"/"+char(experiment)+"/"+filenames(ii)),'mlotst');
       lat_model = ncread(char(data_path+"/"+char(experiment)+"/"+filenames(ii)),'lat');
       lon_model = ncread(char(data_path+"/"+char(experiment)+"/"+filenames(ii)),'lon');
   end
end

[lat, lon] = meshgrid(lat_model,lon_model);

for ii=1:size(mld_ssp126_02,3)
   temp = NaN(size(lat));
   temp02 = mld_ssp126_02(:,:,ii);
   temp08 = mld_ssp126_08(:,:,ii);
   temp(lat<0)=temp02(lat<0);
   temp(lat>=0)=temp08(lat>=0);
   MLD_ssp126_Summer_models(:,:,ii) = temp;
   temp(lat>=0)=temp02(lat>=0);
   temp(lat<0)=temp08(lat<0);
   MLD_ssp126_Winter_models(:,:,ii) = temp;
end

for ii=1:size(mld_ssp585_02,3)
   temp = NaN(size(lat));
   temp02 = mld_ssp585_02(:,:,ii);
   temp08 = mld_ssp585_08(:,:,ii);
   temp(lat<0)=temp02(lat<0);
   temp(lat>=0)=temp08(lat>=0);
   MLD_ssp585_Summer_models(:,:,ii) = temp;
   temp(lat>=0)=temp02(lat>=0);
   temp(lat<0)=temp08(lat<0);
   MLD_ssp585_Winter_models(:,:,ii) = temp;
end

for ii=1:size(mld_hist_02,3)
   temp = NaN(size(lat));
   temp02 = mld_hist_02(:,:,ii);
   temp08 = mld_hist_08(:,:,ii);
   temp(lat<0)=temp02(lat<0);
   temp(lat>=0)=temp08(lat>=0);
   MLD_hist_Summer_models(:,:,ii) = temp;
   temp(lat>=0)=temp02(lat>=0);
   temp(lat<0)=temp08(lat<0);
   MLD_hist_Winter_models(:,:,ii) = temp;
end

%% Calculate MLD biases for all models/seasons, and multimodel mean bias

% Interpolate MLD observations (2x2 grid) onto the same grid as the models
% (1x1 grid) using interp2
interp_obs_lon=0:1:359;
interp_obs_lat=-89.5:1:89.5;
ML_Obs_Summer_interp = ...
    interp2(circshift(wrapTo360(lon_obs),180),lat_obs, ...
    circshift(ML_Obs_Summer,180,1)',interp_obs_lon,interp_obs_lat')';
ML_Obs_Winter_interp = ...
    interp2(circshift(wrapTo360(lon_obs),180),lat_obs, ...
    circshift(ML_Obs_Winter,180,1)',interp_obs_lon,interp_obs_lat')';

ML_Bias_Summer_models = MLD_hist_Summer_models - ML_Obs_Summer_interp;
ML_Bias_Winter_models = MLD_hist_Winter_models - ML_Obs_Winter_interp;

%% Calculate projected changes in mixed layer depth

for ii = 1:size(model_names_ssp126_02,2)
    hist_index = find(strcmp(model_names_hist_02,model_names_ssp126_02(ii)));
    ML_SSP126_Change_Summer_models(:,:,ii) = ...
        MLD_ssp126_Summer_models(:,:,ii) - MLD_hist_Summer_models(:,:,hist_index);
    ML_SSP126_Change_Winter_models(:,:,ii) = ...
        MLD_ssp126_Winter_models(:,:,ii) - MLD_hist_Winter_models(:,:,hist_index);
end

for ii = 1:size(model_names_ssp585_02,2)
    hist_index = find(strcmp(model_names_hist_02,model_names_ssp585_02(ii)));
    ML_SSP585_Change_Summer_models(:,:,ii) = ...
        MLD_ssp585_Summer_models(:,:,ii) - MLD_hist_Summer_models(:,:,hist_index);
    ML_SSP585_Change_Winter_models(:,:,ii) = ...
        MLD_ssp585_Winter_models(:,:,ii) - MLD_hist_Winter_models(:,:,hist_index);
end

%%

color_bar = IPCC_Get_Colorbar('wind_nd', 21, true);

plot_var1 = ML_Obs_Winter_interp;
plot_var1 = [plot_var1; plot_var1(1,:)];
lon_tmp = [lon_model; lon_model(1)];
lon_tmp = lon_tmp(1:1:end);
lat_tmp = lat_model(1:1:end);
plot_var1 = plot_var1(1:1:end,1:1:end);
lim_max = 500;
lim_min = 0;

IPCC_Plot_Map_Gappy(plot_var1',lat_tmp,lon_tmp,[lim_min lim_max], ...
    color_bar,"Winter Mixed Layer Depth",...
    1,fontsize, true,'(m)')

print(gcf,'../PNGs/Winter_MLD_climatology_colorbar.png','-dpng','-r400', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/Winter_MLD_climatology.png','-dpng','-r400', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-5a_data.nc';
var_name = 'MLD';
var_units = 'meters';
title = "Observed Winter Mixed Layer Depth between 2000 and 2019";
comments = "Data is for panel (a) of Figure 9.5 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    lat_tmp, lon_tmp, title, comments)


%%

plot_var1 = ML_Obs_Summer_interp;
plot_var1 = [plot_var1; plot_var1(1,:)];
plot_var1 = plot_var1(1:1:end,1:1:end);
lim_max = 150;
lim_min = 0;

IPCC_Plot_Map_Gappy(plot_var1',lat_tmp,lon_tmp,[lim_min lim_max], ...
    color_bar,"Summer Mixed Layer Depth",...
    1,fontsize, true,'(m)')

print(gcf,'../PNGs/Summer_MLD_climatology_colorbar.png','-dpng','-r400', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/Summer_MLD_climatology.png','-dpng','-r400', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-5e_data.nc';
var_name = 'MLD';
var_units = 'meters';
title = "Observed Summer Mixed Layer Depth between 2000 and 2019";
comments = "Data is for panel (e) of Figure 9.5 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    lat_tmp, lon_tmp, title, comments)

%%

color_bar = IPCC_Get_Colorbar('precip_d', 20, false);

[lat, lon] = meshgrid(lat_model,lon_model);

lim_max = 300;
lim_min = -lim_max;
plot_var6 = nanmean(ML_Bias_Winter_models,3);
plot_var6 = [plot_var6; plot_var6(1,:)];
%plot_var6=0*plot_var6;
IPCC_Plot_Map_Gappy(plot_var6',lat_model,[lon_model; lon_model(1)],[lim_min lim_max], ...
    color_bar,"Bias in Winter MLD",...
    1,fontsize, true,'(m)')

hatch = abs(nansum(sign(ML_Bias_Winter_models),3))/size(ML_Bias_Winter_models,3);
hatch(hatch==0)=NaN(1);
hatch(abs(hatch)>=0.6) = 1;
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
% hatch(1:60:end,:)=1;
% hatch(140,:)=1;
% hatch(200,:)=1;
% hatch(215,:)=1;
% hatch(330,:)=1;
hatch(1:60:end,:)=1;
hatch(:,end-5:end)=1;
hatch(:,1:5)=1;
hatch(90,:)=1;
hatch(290,:)=1;
hatch(286,1:end/3)=1;
hatch(340,:)=1;
%hatch(350,1:end/3)=1;
hatch(220,2*end/3:end)=1;
hatch(310,3*end/4:end)=1;
%hatch(330:360,:)=1;
hatch(1:5,end/2:end)=1;
hatch(1:2,1:end/2)=1;
hatch(end-1:end,:)=1;
hold on
[c1, h1]=contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);

print(gcf,'../PNGs/Winter_MLD_bias_colorbar_surfacem.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/Winter_MLD_bias.png','-dpng','-r1000', '-painters');

contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lon_temp,lat_temp] = meshgrid(lon_model,lat_model);
stipplem(lat_temp,lon_temp,~logical(hatch)','color','k','markersize',2, ...
    'marker','+');

print(gcf,'../PNGs/Test_Maps/Winter_MLD_bias_Hatch_Check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-5b_data.nc';
var_name = 'MLD_Bias';
var_units = 'meters';
title = "Bias in Winter Mixed Layer Depth between CMIP6 (CMIP) and observations";
comments = "Data is for panel (b) of Figure 9.5 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var6', ...
    lat_tmp, lon_tmp, title, comments, hatching_mask')


%%

lim_max = 100;
lim_min = -lim_max;
plot_var6 = nanmean(ML_Bias_Summer_models,3);
plot_var6 = [plot_var6; plot_var6(1:2,:)];
%plot_var6=0*plot_var6;
IPCC_Plot_Map_Gappy(plot_var6',lat_model,[lon_model; lon_model(1:2)],[lim_min lim_max], ...
    color_bar,"Bias in Summer MLD",...
    1,fontsize, true,'(m)')

hatch = abs(nansum(sign(ML_Bias_Summer_models),3))/size(ML_Bias_Summer_models,3);
hatch(hatch==0)=NaN(1);
hatch(abs(hatch)>=0.6) = 1;
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1;
hatch(140,:)=1;
%hatch(200,:)=1;
hatch(215,:)=1;
hatch(330,:)=1;
hold on
[c1, h1]=contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);


print(gcf,'../PNGs/Summer_MLD_bias_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/Summer_MLD_bias.png','-dpng','-r1000', '-painters');

contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','k');
hatch(hatch==3)=0;
[lon_temp,lat_temp] = meshgrid(lon_model,lat_model);
stipplem(lat_temp,lon_temp,~logical(hatch)','color','k','markersize',2, ...
    'marker','+');

print(gcf,'../PNGs/Test_Maps/Summer_MLD_bias_Hatch_Check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-5f_data.nc';
var_name = 'MLD_Bias';
var_units = 'meters';
title = "Bias in Summer Mixed Layer Depth between CMIP6 (CMIP) and observations";
comments = "Data is for panel (f) of Figure 9.5 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var6', ...
    lat_model,[lon_model; lon_model(1:2)], title, comments, hatching_mask')


%% Plot projected changes in SST

color_bar = IPCC_Get_Colorbar('temperature_d', 20, false);

lim_max = 300;
lim_min = -lim_max;
plot_var6 = nanmean(ML_SSP585_Change_Winter_models,3);
plot_var6 = [plot_var6; plot_var6(1:2,:)];
%plot_var6=0*plot_var6;
IPCC_Plot_Map(plot_var6',lat_model,[lon_model; lon_model(1:2)],[lim_min lim_max], ...
    color_bar,"SSP585 change in Winter MLD",...
    1,fontsize, true,'(m)')

hatch = abs(nansum(sign(ML_SSP585_Change_Winter_models),3))/size(ML_SSP585_Change_Winter_models,3);
hatch(hatch==0)=NaN(1);
hatch(abs(hatch)>=0.6) = 1;
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1;
hatch(:,end-5:end)=1;
hatch(:,1:5)=1;
hatch(90,:)=1;
%hatch(290,:)=1;
hatch(286,:)=1;
%hatch(215,:)=1;
%hatch(330:360,:)=1;
hatch(1:5,end/2:end)=1;
hatch(1:2,1:end/2)=1;
hatch(end-1:end,:)=1;
hold on
[c1, h1]=contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);
landareas = shaperead('landareas.shp','UseGeoCoords',true);
geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);

print(gcf,'../PNGs/Winter_MLD_SSP585_Change_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/Winter_MLD_SSP585_Change.png','-dpng','-r1000', '-painters');

contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','k');
hatch(hatch==3)=0;
[lon_temp,lat_temp] = meshgrid(lon_model,lat_model);
stipplem(lat_temp,lon_temp,~logical(hatch)','color','k','markersize',2, ...
    'marker','+');

print(gcf,'../PNGs/Test_Maps/Winter_MLD_SSP585_Change_Hatch_Check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-5d_data.nc';
var_name = 'MLD_Bias';
var_units = 'meters';
title = "Change in Winter Mixed Layer Depth under SSP5-8.5 between 1995 and 2100 using CMIP6 (CMIP & ScenarioMIP)";
comments = "Data is for panel (d) of Figure 9.5 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var6', ...
    lat_model,[lon_model; lon_model(1:2)], title, comments, hatching_mask')


%%

plot_var6 = nanmean(ML_SSP126_Change_Winter_models,3);
plot_var6 = [plot_var6; plot_var6(1:2,:)];
%plot_var6=0*plot_var6;
IPCC_Plot_Map(plot_var6',lat_model,[lon_model; lon_model(1:2)],[lim_min lim_max], ...
    color_bar,"SSP126 change in Winter MLD",...
    1,fontsize, true,'(m)')

hatch = abs(nansum(sign(ML_SSP126_Change_Winter_models),3))/size(ML_SSP126_Change_Winter_models,3);
hatch(hatch==0)=NaN(1);
hatch(abs(hatch)>=0.6) = 1;
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1;
hatch(:,end-5:end)=1;
hatch(:,1:5)=1;
hatch(90,:)=1;
hatch(290,:)=1;
hatch(286,1:end/3)=1;
hatch(340,:)=1;
%hatch(350,1:end/3)=1;
hatch(220,2*end/3:end)=1;
hatch(310,3*end/4:end)=1;
%hatch(330:360,:)=1;
hatch(1:5,end/2:end)=1;
hatch(1:2,1:end/2)=1;
hatch(end-1:end,:)=1;
hold on
[c1, h1]=contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);
landareas = shaperead('landareas.shp','UseGeoCoords',true);
geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);

print(gcf,'../PNGs/Winter_MLD_SSP126_Change_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/Winter_MLD_SSP126_Change.png','-dpng','-r1000', '-painters');

contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','k');
hatch(hatch==3)=0;
[lon_temp,lat_temp] = meshgrid(lon_model,lat_model);
stipplem(lat_temp,lon_temp,~logical(hatch)','color','k','markersize',2, ...
    'marker','+');

print(gcf,'../PNGs/Test_Maps/Winter_MLD_SSP126_Change_Hatch_Check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-5c_data.nc';
var_name = 'MLD_Bias';
var_units = 'meters';
title = "Change in Winter Mixed Layer Depth under SSP1-2.6 between 1995 and 2100 using CMIP6 (CMIP & ScenarioMIP)";
comments = "Data is for panel (c) of Figure 9.5 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var6', ...
    lat_model,[lon_model; lon_model(1:2)], title, comments, hatching_mask')


%%

lim_max = 20;
lim_min = -lim_max;
plot_var6 = nanmean(ML_SSP585_Change_Summer_models,3);
plot_var6 = [plot_var6; plot_var6(1:2,:)];
%plot_var6=0*plot_var6;
IPCC_Plot_Map(plot_var6',lat_model,[lon_model; lon_model(1:2)],[lim_min lim_max], ...
    color_bar,"SSP585 change in Summer MLD",...
    1,fontsize, true,'(m)')

hatch = abs(nansum(sign(ML_SSP585_Change_Summer_models),3))/size(ML_SSP585_Change_Summer_models,3);
hatch(hatch==0)=NaN(1);
hatch(abs(hatch)>=0.6) = 1;
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1;
hatch(:,end-5:end)=1;
hatch(:,1:5)=1;
%hatch(90,:)=1;
%hatch(290,:)=1;
hatch(286,1:end/3+5)=1;
hatch(340,:)=1;
%hatch(350,1:end/3)=1;
hatch(270,2*end/3:end)=1;
%hatch(310,3*end/4:end)=1;
%hatch(330:360,:)=1;
hatch(1:5,end/2:end)=1;
hatch(1:2,1:end/2)=1;
hatch(end-1:end,:)=1;
hold on
[c1, h1]=contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);
landareas = shaperead('landareas.shp','UseGeoCoords',true);
geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);

print(gcf,'../PNGs/Summer_MLD_SSP585_Change_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/Summer_MLD_SSP585_Change.png','-dpng','-r1000', '-painters');

contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','k');
hatch(hatch==3)=0;
[lon_temp,lat_temp] = meshgrid(lon_model,lat_model);
stipplem(lat_temp,lon_temp,~logical(hatch)','color','k','markersize',2, ...
    'marker','+');

print(gcf,'../PNGs/Test_Maps/Summer_MLD_SSP585_Change_Hatch_Check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-5h_data.nc';
var_name = 'MLD_Bias';
var_units = 'meters';
title = "Change in Summer Mixed Layer Depth under SSP5-8.5 between 1995 and 2100 using CMIP6 (CMIP & ScenarioMIP)";
comments = "Data is for panel (h) of Figure 9.5 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var6', ...
    lat_model,[lon_model; lon_model(1:2)], title, comments, hatching_mask')



%%

% IPCC_Plot_Map(plot_var4,lat_model,lon_model,[lim_min lim_max], ...
%     color_bar,"SSP126 change in Summer MLD",...
%     1,fontsize, true,'(m)',ML_SSP126_Change_Summer_models)

plot_var6 = nanmean(ML_SSP126_Change_Summer_models,3);
plot_var6 = [plot_var6; plot_var6(1:2,:)];
%plot_var6=0*plot_var6;
IPCC_Plot_Map(plot_var6',lat_model,[lon_model; lon_model(1:2)],[lim_min lim_max], ...
    color_bar,"SSP126 change in Summer MLD",...
    1,fontsize, true,'(m)')

hatch = abs(nansum(sign(ML_SSP126_Change_Summer_models),3))/size(ML_SSP126_Change_Summer_models,3);
hatch(hatch==0)=NaN(1);
hatch(abs(hatch)>=0.6) = 1;
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1;
hatch(:,end-5:end)=1;
hatch(:,1:5)=1;
hatch(150,:)=1;
hatch(90,:)=1;
%hatch(286,1:end/3+5)=1;
%hatch(340,:)=1;
%hatch(350,1:end/3)=1;
%hatch(270,2*end/3:end)=1;
%hatch(310,3*end/4:end)=1;
%hatch(330:360,:)=1;
hatch(1:5,end/2:end)=1;
hatch(1:2,1:end/2)=1;
hatch(end-1:end,:)=1;
hold on
[c1, h1]=contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);
landareas = shaperead('landareas.shp','UseGeoCoords',true);
geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);

print(gcf,'../PNGs/Summer_MLD_SSP126_Change_colorbar.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/Summer_MLD_SSP126_Change.png','-dpng','-r1000', '-painters');

contourm(lat_model,lon_model,hatch',[3 3],'Fill','off','LineColor','k');
hatch(hatch==3)=0;
[lon_temp,lat_temp] = meshgrid(lon_model,lat_model);
stipplem(lat_temp,lon_temp,~logical(hatch)','color','k','markersize',2, ...
    'marker','+');

print(gcf,'../PNGs/Test_Maps/Summer_MLD_SSP126_Change_Hatch_Check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-5g_data.nc';
var_name = 'MLD_Bias';
var_units = 'meters';
title = "Change in Summer Mixed Layer Depth under SSP1-2.6 between 1995 and 2100 using CMIP6 (CMIP & ScenarioMIP)";
comments = "Data is for panel (g) of Figure 9.5 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var6', ...
    lat_model,[lon_model; lon_model(1:2)], title, comments, hatching_mask')

%%
lim_max = 20;
lim_min = -lim_max;

clear title

for ii=1:size(model_names_ssp126_02,2)
   subplot(ceil(sqrt(size(model_names_ssp126_02,2))), ...
        ceil(sqrt(size(model_names_ssp126_02,2))), ii);
    imagesc(lon_model,lat_model,fliplr(ML_SSP126_Change_Summer_models(:,:,ii))');
    %colormap(heat_flux_color_bar)
    colorbar
    caxis([lim_min lim_max])
    title(char(model_names_ssp126_02(ii)))
end
print(gcf,'../PNGs/Test_Maps/Summer_MLD_SSP126_Change_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)
for ii=1:size(model_names_ssp585_02,2)
   subplot(ceil(sqrt(size(model_names_ssp585_02,2))), ...
        ceil(sqrt(size(model_names_ssp585_02,2))), ii);
    imagesc(lon_model,lat_model,fliplr(ML_SSP585_Change_Summer_models(:,:,ii))');
    %colormap(heat_flux_color_bar)
    colorbar
    caxis([lim_min lim_max])
    title(char(model_names_ssp585_02(ii)))
end
print(gcf,'../PNGs/Test_Maps/Summer_MLD_SSP585_Change_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)
for ii=1:size(model_names_hist_02,2)
   subplot(ceil(sqrt(size(model_names_hist_02,2))), ...
        ceil(sqrt(size(model_names_hist_02,2))), ii);
    imagesc(lon_model,lat_model,fliplr(MLD_hist_Summer_models(:,:,ii))');
    %colormap(heat_flux_color_bar)
    colorbar
    caxis([0 100])
    title(char(model_names_hist_02(ii)))
end
print(gcf,'../PNGs/Test_Maps/Summer_MLD_hist_Change_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)

for ii=1:size(model_names_ssp126_08,2)
   subplot(ceil(sqrt(size(model_names_ssp126_08,2))), ...
        ceil(sqrt(size(model_names_ssp126_08,2))), ii);
    imagesc(lon_model,lat_model,fliplr(ML_SSP126_Change_Winter_models(:,:,ii))');
    %colormap(heat_flux_color_bar)
    colorbar
    caxis([lim_min lim_max])
    title(char(model_names_ssp126_08(ii)))
end
print(gcf,'../PNGs/Test_Maps/Winter_MLD_SSP126_Change_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)
for ii=1:size(model_names_ssp585_08,2)
   subplot(ceil(sqrt(size(model_names_ssp585_08,2))), ...
        ceil(sqrt(size(model_names_ssp585_08,2))), ii);
    imagesc(lon_model,lat_model,fliplr(ML_SSP585_Change_Winter_models(:,:,ii))');
    %colormap(heat_flux_color_bar)
    colorbar
    caxis([lim_min lim_max])
    title(char(model_names_ssp585_08(ii)))
end
print(gcf,'../PNGs/Test_Maps/Winter_MLD_SSP585_Change_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)

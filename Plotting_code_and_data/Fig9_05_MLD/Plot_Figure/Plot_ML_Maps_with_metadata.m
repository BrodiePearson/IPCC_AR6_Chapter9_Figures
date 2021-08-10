%% IPCC AR6 Chapter 9: Figure 9.5 (Mixed Layer Depths)
%
% Code used to plot pre-processed CMIP6 mixed layer depth data. 
% Using IPCC-formatted metadata (rather than direct CMIP output)
%
% Plotting code written by Brodie Pearson
% Processed data provided by Yongqiang Yu & Lijuan Hua

clear all

fontsize = 24;
addpath ../../../Functions/

color_bar = IPCC_Get_Colorbar('wind_nd', 21, true);

%%

color_bar = IPCC_Get_Colorbar('wind_nd', 21, true);
lim_max = 500;
lim_min = 0;

ncfilename = '../Plotted_Data/Fig9-5a_data.nc';
plot_var1 = ncread(ncfilename, 'MLD')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map_Gappy(plot_var1',lat,lon,[lim_min lim_max], ...
    color_bar,"Winter Mixed Layer Depth",...
    1,fontsize, true,'(m)')

%%

lim_max = 150;
lim_min = 0;

ncfilename = '../Plotted_Data/Fig9-5e_data.nc';
plot_var1 = ncread(ncfilename, 'MLD')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');

IPCC_Plot_Map_Gappy(plot_var1',lat,lon,[lim_min lim_max], ...
    color_bar,"Winter Mixed Layer Depth",...
    2,fontsize, true,'(m)')

%%

color_bar = IPCC_Get_Colorbar('precip_d', 20, false);

lim_max = 300;
lim_min = -lim_max;
ncfilename = '../Plotted_Data/Fig9-5b_data.nc';
plot_var6 = ncread(ncfilename, 'MLD_Bias')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map_Gappy(plot_var6',lat,lon,[lim_min lim_max], ...
    color_bar,"Bias in Winter MLD",...
    3,fontsize, true,'(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var6) & plot_var6~=0))

%%

lim_max = 100;
lim_min = -lim_max;
ncfilename = '../Plotted_Data/Fig9-5f_data.nc';
plot_var6 = ncread(ncfilename, 'MLD_Bias')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map_Gappy(plot_var6',lat,lon,[lim_min lim_max], ...
    color_bar,"Bias in Summer MLD",...
    4,fontsize, true,'(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var6) & plot_var6~=0))

%% Plot projected changes

color_bar = IPCC_Get_Colorbar('temperature_d', 20, false);

lim_max = 300;
lim_min = -lim_max;
ncfilename = '../Plotted_Data/Fig9-5d_data.nc';
plot_var6 = ncread(ncfilename, 'MLD_Bias')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map_Gappy(plot_var6',lat,lon,[lim_min lim_max], ...
    color_bar,"SSP585 change in Winter MLD",...
    5,fontsize, true,'(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var6) & plot_var6~=0))

%%

lim_max = 300;
lim_min = -lim_max;
ncfilename = '../Plotted_Data/Fig9-5c_data.nc';
plot_var6 = ncread(ncfilename, 'MLD_Bias')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map_Gappy(plot_var6',lat,lon,[lim_min lim_max], ...
    color_bar,"SSP126 change in Winter MLD",...
    6,fontsize, true,'(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var6) & plot_var6~=0))

%%

lim_max = 20;
lim_min = -lim_max;
ncfilename = '../Plotted_Data/Fig9-5h_data.nc';
plot_var6 = ncread(ncfilename, 'MLD_Bias')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map_Gappy(plot_var6',lat,lon,[lim_min lim_max], ...
    color_bar,"SSP585 change in Summer MLD",...
    7,fontsize, true,'(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var6) & plot_var6~=0))

%%

ncfilename = '../Plotted_Data/Fig9-5g_data.nc';
plot_var6 = ncread(ncfilename, 'MLD_Bias')';
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map_Gappy(plot_var6',lat,lon,[lim_min lim_max], ...
    color_bar,"SSP126 change in Summer MLD",...
    8,fontsize, true,'(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_var6) & plot_var6~=0))


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

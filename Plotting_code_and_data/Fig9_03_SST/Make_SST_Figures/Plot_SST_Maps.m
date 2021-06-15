%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surfact temperature (SST) - named tos in CMIP6 

clear all

hist_change_start_year = 1950;
hist_change_end_year = 2014;
SSP_change_end_year = 2100;
HRSSP_change_end_year = 2050;

addpath ../../Matlab_Functions/

savefile = 'SST_Maps';
load(savefile)

fontsize = 15;

%% Plot mean SST averaged over past few decades

color_bar = IPCC_Get_Colorbar('temperature_nd', 21, false);

lims = [-2 30];

IPCC_Plot_Map(SST_OBS',lat,lon,lims, ...
    color_bar,"Observation-based Climatology (HadISST; "+bias_start_year+"-"+bias_end_year+")",...
    1,fontsize, true, 'Sea Surface Temperature (SST; ^oC)')

print(gcf,'../PNGs/Observed_SST_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/Observed_SST.png','-dpng','-r1000', '-painters');
close(1);

ncfilename = '../Plotted_Data/Fig9-3b_data.nc';
var_name = 'SST';
var_units = 'degrees Celsius';
title = "Sea Surface Temperature Observation-based climatology for 1995-2014"+ ...
    " using HadISST";
comments = "Data is for panel (b) of Figure 9.3 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, SST_OBS', ...
    lat, lon, title, comments)


%% Load SSP585 data & Create a plot of future change under SSP585

multimodel_change_CMIP = nanmean(SST_change_CMIP,3);
multimodel_change_HRMIP = nanmean(SST_change_HRMIP,3);
multimodel_change_SSP585 = nanmean(SST_change_SSP585,3);
multimodel_change_HRSSP = nanmean(SST_change_HRSSP,3);

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

print(gcf,'../PNGs/Observed_SST_change_labels.png','-dpng','-r100', '-painters');
title('')
print(gcf,'../PNGs/Observed_SST_change.png','-dpng','-r1000', '-painters');

close(2)

ncfilename = '../Plotted_Data/Fig9-3c_data.nc';
var_name = 'SST_ChangeRate';
var_units = 'degrees Celsius per decade';
title = "Rate of Change of Sea Surface Temperature between 1950-2014"+ ...
    " using HadISST (observation-based)";
comments = "Data is for panel (c) of Figure 9.3 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, SST_change_OBS', ...
    lat, lon, title, comments)

%% Plot CMIP modern SST rate of change

IPCC_Plot_Map(multimodel_change_CMIP' ...
    ,lat,lon,lims, color_bar, ...
    "CMIP_{"+num2str(size(SST_change_CMIP,3))+"} rate of change ("+hist_change_start_year+"-"+hist_change_end_year+")",1, ...
    fontsize,false,'')

hatch = abs(sum(sign(SST_change_CMIP),3))/size(SST_change_CMIP,3);
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
% hatch(185,85:90)=1; hatch(195,90:140)=1; hatch(315,90:120)=1; hatch(1,20:60)=1;
% hatch(240,90:120)=1;
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

print(gcf,'../PNGs/CMIP_SST_changelabel.png','-dpng','-r100', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/CMIP_SST_change.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/CMIP_SST_change_Hatch_check.png','-dpng','-r100', '-painters');

close(1)

ncfilename = '../Plotted_Data/Fig9-3f_data.nc';
var_name = 'SST_ChangeRate';
var_units = 'degrees Celsius per decade';
title = "Rate of Change of Sea Surface Temperature between 1950-2014"+ ...
    " calculated from a CMIP6 (CMIP) model ensemble";
comments = "Data is for panel (f) of Figure 9.3 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, multimodel_change_CMIP', ...
    lat, lon, title, comments, hatching_mask')

%% Plot HighResMIP modern SST rate of change

IPCC_Plot_Map(multimodel_change_HRMIP' ...
    ,lat,lon,lims, color_bar, ...
    "HighResMIP_{"+num2str(size(SST_change_HRMIP,3))+"} rate of change ("+hist_change_start_year+"-"+hist_change_end_year+")",1, ...
    fontsize,false,'')

hatch = abs(sum(sign(SST_change_HRMIP),3))/size(SST_change_HRMIP,3);
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
% hatch(185,85:90)=1; hatch(195,90:140)=1; hatch(315,90:120)=1; hatch(1,20:60)=1;
hatch(240,:)=1;
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

print(gcf,'../PNGs/HRMIP_SST_changelabel.png','-dpng','-r100', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/HRMIP_SST_change.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/HRMIP_SST_change_Hatch_check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-3i_data.nc';
var_name = 'SST_ChangeRate';
var_units = 'degrees Celsius per decade';
title = "Rate of Change of Sea Surface Temperature between 1950-2014"+ ...
    " calculated from a CMIP6 (HighResMIP) model ensemble";
comments = "Data is for panel (i) of Figure 9.3 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, multimodel_change_CMIP', ...
    lat, lon, title, comments, hatching_mask')

%% Plot SSP585 predicted SST rate of change

IPCC_Plot_Map(multimodel_change_SSP585' ...
    ,lat,lon,lims,color_bar, ...
    "SSP5-8.5_{"+num2str(size(SST_change_SSP585,3))+"} rate of change ("+ ...
    SSP_change_start_year+"-"+SSP_change_end_year+")",1, ...
    fontsize, true, 'SST Rate of Change (^oC/decade)')

hatch = abs(sum(sign(SST_change_SSP585),3))/size(SST_change_SSP585,3);
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
% hatch(185,85:90)=1; hatch(195,90:140)=1; hatch(315,90:120)=1; hatch(1,20:60)=1;
hatch(240,:)=1;
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

print(gcf,'../PNGs/SSP585_SST_changelabel.png','-dpng','-r100', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/SSP585_SST_change.png','-dpng','-r1000', '-painters');


contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/SSP585_SST_change_Hatch_check.png','-dpng','-r100', '-painters');
close(1)

areas=NaN(size(lon.*lat'));
for i = 1:size(areas,1)
    for j=1:size(areas,2)
        areas(i,j) = areaquad(lat(j)-0.5, lon(i)-0.5, ...
            lat(j)+0.5, lon(i)+0.5);
    end
end

hatch = abs(sum(sign(SST_change_SSP585),3))/size(SST_change_SSP585,3);
hatch(abs(hatch)>=0.6) = 1; % If this is true at least 80% of models agree
hatch(abs(hatch)<0.6) = 0;
fraction_of_CMIP_warming_in_21st_century_SSP585 = nansum(areas(hatch==1))./(nansum(areas(hatch==1))+ ...
    nansum(areas(hatch==0)))

ncfilename = '../Plotted_Data/Fig9-3d_data.nc';
var_name = 'SST_ChangeRate';
var_units = 'degrees Celsius per decade';
title = "Rate of Change of Sea Surface Temperature under SSP5-8.5 between 2005-2100"+ ...
    " calculated from a CMIP6 (CMIP & ScenarioMIP) model ensemble";
comments = "Data is for panel (d) of Figure 9.3 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, multimodel_change_SSP585', ...
    lat, lon, title, comments, hatching_mask')

%% Plot HighResMIP SSP585 predicted SST rate of change

IPCC_Plot_Map(multimodel_change_HRSSP' ...
    ,lat,lon,lims,color_bar, ...
    "HighResMIP_{"+num2str(size(SST_change_HRSSP,3))+"} SSP5-8.5 rate of change (" ...
    +HRSSP_change_start_year+"-"+HRSSP_change_end_year+")",1, ...
    fontsize, true, 'SST Rate of Change (^oC/decade)')

hatch = abs(sum(sign(SST_change_HRSSP),3))/size(SST_change_HRSSP,3);
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
% hatch(185,85:90)=1; hatch(195,90:140)=1; hatch(315,90:120)=1; hatch(1,20:60)=1;
hatch(240,:)=1;
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


print(gcf,'../PNGs/HRSSP_SST_changelabel.png','-dpng','-r100', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/HRSSP_SST_change.png','-dpng','-r1000', '-painters');


contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/HRSSP_SST_change_Hatch_check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-3j_data.nc';
var_name = 'SST_ChangeRate';
var_units = 'degrees Celsius per decade';
title = "Rate of Change of Sea Surface Temperature under SSP5-8.5 between 2005-2050"+ ...
    " calculated from a CMIP6 (HighResMIP) model ensemble";
comments = "Data is for panel (j) of Figure 9.3 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, multimodel_change_HRSSP', ...
    lat, lon, title, comments, hatching_mask')

%% Maps of present model biases realtive to map of present SST (Fig 1)

color_bar = IPCC_Get_Colorbar('chem_d', 21, true);

% lim_max = nanmax(abs([multimodel_CMIP_bias(:); multimodel_HRMIP_bias(:)]));
lim_max = 3;
lim_min = -lim_max;
lims = [lim_min lim_max];

multimodel_CMIP_bias = nanmean(SST_bias_CMIP,3);
multimodel_HRMIP_bias = nanmean(SST_bias_HRMIP,3);

%% Plot CMIP SST bias vs. observations

% Averaging Index is shifted by 1 for biases
IPCC_Plot_Map(multimodel_CMIP_bias' ...
    ,lat,lon,lims,color_bar, ...
    "CMIP_{"+num2str(size(SST_bias_CMIP,3))+"} Bias ("+bias_start_year+"-"+bias_end_year+")",1, ...
    fontsize,true,'Model Bias (^oC)')

hatch = abs(sum(sign(SST_bias_CMIP),3))/size(SST_bias_CMIP,3);
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
% hatch(185,85:90)=1; hatch(195,90:140)=1; hatch(315,90:120)=1; hatch(1,20:60)=1;
hatch(235,:)=1; hatch(180,1:91)=1; hatch(162,1:50)=1;
hatch(210,:)=1; hatch(55,90:110)=1;
hatch(340,:)=1;
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


print(gcf,'../PNGs/CMIP_SST_biaslabel.png','-dpng','-r100', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/CMIP_SST_bias.png','-dpng','-r1000', '-painters');


contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/CMIP_SST_bias_Hatch_check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-3e_data.nc';
var_name = 'SST_Bias';
var_units = 'degrees Celsius';
title = "CMIP6 (CMIP) bias in Sea Surface Temperature for period 1995-2014"+ ...
    " relative to HadISST";
comments = "Data is for panel (e) of Figure 9.3 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, multimodel_CMIP_bias', ...
    lat, lon, title, comments, hatching_mask')

%% Plot HRMIP SST bias vs. observations

IPCC_Plot_Map(multimodel_HRMIP_bias' ...
    ,lat,lon,lims,color_bar, ...
    "HighResMIP_{"+num2str(size(SST_bias_HRMIP,3))+"} Bias ("+bias_start_year+"-"+bias_end_year+")",1, ...
    fontsize, true, 'Model Bias (^oC)')

hatch = abs(sum(sign(SST_bias_HRMIP),3))/size(SST_bias_HRMIP,3);
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
% hatch(185,85:90)=1; hatch(195,90:140)=1; hatch(315,90:120)=1; hatch(1,20:60)=1;
% hatch(235,:)=1;
hatch(1,:)=1; hatch(end,:)=1;
hatch(210,:)=1; hatch(310,:)=1; hatch(320,:)=1; hatch(145,120:end)=1;
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
landareas = shaperead('landareas.shp','UseGeoCoords',true);
geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);


print(gcf,'../PNGs/HighResMIP_SST_biaslabel.png','-dpng','-r100', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/HighResMIP_SST_bias.png','-dpng','-r1000', '-painters');


contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/HighResMIP_SST_bias_Hatch_check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-3h_data.nc';
var_name = 'SST_Bias';
var_units = 'degrees Celsius';
title = "CMIP6 (HighResMIP) bias in Sea Surface Temperature for period 1995-2014"+ ...
    " relative to HadISST";
comments = "Data is for panel (h) of Figure 9.3 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, multimodel_HRMIP_bias', ...
    lat, lon, title, comments, hatching_mask')

%%
lim_max = 0.8;

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
color_bar = [color_bar2(3:11,:); color_bar1];

lims = [-0.4 1]*lim_max;
% Check model SST fields
figure('Position', [10 10 1200 1200])
for ii=1:size(SST_change_CMIP,3)
   subplot(ceil(sqrt(size(SST_change_CMIP,3))), ...
        ceil(sqrt(size(SST_change_CMIP,3))), ii);
    imagesc(lon,lat,fliplr(SST_change_CMIP(:,:,ii))');
    colormap(color_bar)
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/CMIP_TOS_Change_Maps.png','-dpng','-r100', '-painters');
close(1)
figure('Position', [10 10 1200 1200])
for ii=1:size(SST_change_HRMIP,3)
   subplot(ceil(sqrt(size(SST_change_HRMIP,3))), ...
        ceil(sqrt(size(SST_change_HRMIP,3))), ii);
    imagesc(lon,lat,fliplr(SST_change_HRMIP(:,:,ii))');
    colormap(color_bar)
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/HRMIP_TOS_Change_Maps.png','-dpng','-r100', '-painters');
close(1)
figure('Position', [10 10 1200 1200])
for ii=1:size(SST_change_SSP585,3)
   subplot(ceil(sqrt(size(SST_change_SSP585,3))), ...
        ceil(sqrt(size(SST_change_SSP585,3))), ii);
    imagesc(lon,lat,fliplr(SST_change_SSP585(:,:,ii))');
    colormap(color_bar)
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/SSP585_TOS_Change_Maps.png','-dpng','-r100', '-painters');
close(1)
figure('Position', [10 10 1200 1200])
for ii=1:size(SST_change_HRSSP,3)
   subplot(ceil(sqrt(size(SST_change_HRSSP,3))), ...
        ceil(sqrt(size(SST_change_HRSSP,3))), ii);
    imagesc(lon,lat,fliplr(SST_change_HRSSP(:,:,ii))');
    colormap(color_bar)
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/HRSSP_TOS_Change_Maps.png','-dpng','-r100', '-painters');
close(1)

%%

hatch = abs(sum(sign(SST_change_SSP126),3))/size(SST_change_SSP126,3);
hatch(abs(hatch)>=0.6) = 1; % If this is true at least 90% of models agree
hatch(abs(hatch)<0.6) = 0;
fraction_of_CMIP_warming_in_21st_century_SSP126 = nansum(areas(hatch==1))./(nansum(areas(hatch==1))+ ...
    nansum(areas(hatch==0)))

%% Plot rate of change for CMIP 2005-2050 and for low- & high-res HighResMIP

multimodel_2050_change_SSP585 = nanmean(SST_change_SSP585_2050,3);

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
color_bar = [color_bar2(3:11,:); color_bar1];

lim_max = 0.8;
lims = [-0.4 1]*lim_max;

IPCC_Plot_Map(multimodel_2050_change_SSP585' ...
    ,lat,lon,lims, color_bar, ...
    "SSP5-8.5_{"+num2str(size(SST_change_SSP585_2050,3))+"} rate of change (2005-2050)",1, ...
    fontsize,false,'')

hatch = abs(sum(sign(SST_change_SSP585_2050),3))/size(SST_change_SSP585_2050,3);
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
% hatch(185,85:90)=1; hatch(195,90:140)=1; hatch(315,90:120)=1; hatch(1,20:60)=1;
% hatch(235,:)=1;
% hatch(210,:)=1;
% hatch(210,:)=1;
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

print(gcf,'../PNGs/CMIP_2050_SST_changelabel.png','-dpng','-r100', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/CMIP_2050_SST_change.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/CMIP_2050_SST_change_Hatch_check.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-3g_data.nc';
var_name = 'SST_ChangeRate';
var_units = 'degrees Celsius per decade';
title = "Rate of Change of Sea Surface Temperature under SSP5-8.5 between 2005-2050"+ ...
    " calculated from a CMIP6 (CMIP & ScenarioMIP) model ensemble";
comments = "Data is for panel (g) of Figure 9.3 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, multimodel_2050_change_SSP585', ...
    lat, lon, title, comments, hatching_mask')

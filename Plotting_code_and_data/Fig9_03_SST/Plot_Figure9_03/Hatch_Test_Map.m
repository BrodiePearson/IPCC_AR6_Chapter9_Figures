%% Code to process CMIP6 data from historical and SSP experiments
% This example is for sea surfact temperature (SST) - named tos in CMIP6 

clear all; close all; clc;

hist_change_start_year = 1950;
hist_change_end_year = 2014;
SSP_change_end_year = 2100;
HRSSP_change_end_year = 2050;

addpath ../../Matlab_Functions/

savefile = 'SST_Maps';
load(savefile)

fontsize = 15;


%% Maps of present model biases realtive to map of present SST (Fig 1)

color_bar = IPCC_Get_Colorbar('chem_d', 21, true);

% lim_max = nanmax(abs([multimodel_CMIP_bias(:); multimodel_HRMIP_bias(:)]));
lim_max = 8;
lim_min = -lim_max;
lims = [lim_min lim_max];

multimodel_CMIP_bias = nanmean(SST_bias_CMIP,3);
multimodel_HRMIP_bias = nanmean(SST_bias_HRMIP,3);

%% Plot HRMIP SST bias vs. observations

hatch_test_base_map = multimodel_HRMIP_bias(1:10:end,1:10:end);
hatch_test_base_map_shift = [hatch_test_base_map;hatch_test_base_map(1,:)];
lat_test = lat(1:10:end);
lon_test = wrapTo180(lon(1:10:end));
lon_test_shift = [lon_test;lon_test(1)];

hatch = abs(sum(sign(SST_bias_HRMIP(1:10:end,1:10:end,:)),3))/ ...
    size(SST_bias_HRMIP,3);
hatch(abs(hatch)>0.6) = 1; % If this is true at least 90% of models agree
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 3;

% IPCC_Plot_Map(hatch' ...
%     ,lat_test,lon_test,[0 3],color_bar, ...
%     "HighResMIP_{"+num2str(size(SST_bias_HRMIP,3))+"} Bias ("+bias_start_year+"-"+bias_end_year+")",2, ...
%     fontsize, true, 'Model Bias (^oC)')


IPCC_Plot_Map(hatch_test_base_map_shift' ...
    ,lat_test,lon_test_shift,lims,color_bar, ...
    "HighResMIP_{"+num2str(size(SST_bias_HRMIP,3))+"} Bias ("+bias_start_year+"-"+bias_end_year+")",1, ...
    fontsize, true, 'Model Bias (^oC)');

%% Apply hatching
hatch_test1 = ones(size(hatch));
hatch_test1(20:24,8:12) = 3;
[Lon,Lat] = meshgrid(wrapTo360(lon_test),lat_test); 
% lon_test_shift = circshift(lon_test,0);
% hatch_shift = circshift(hatch,0,1);
%lon_test_shift = [lon_test;lon_test(1)];
hatch_shift = [hatch;hatch(1,:)];
% hold on
% [~,h] = contourfm(Lat,Lon,hatch',[2 2],'Fill','off');
% set(h,'Tag','HatchingRegion');
% hp = findobj(gca,'Tag','HatchingRegion');
hold on
[c2, h2] = contourm(lat_test,wrapTo360(lon_test_shift),hatch_shift',[3 3],'LineColor','r','Fill','off');
% close(1)
% 
% % IPCC_Plot_Map(hatch_test_base_map' ...
% %     ,lat_test,lon_test,lims,color_bar, ...
% %     "HighResMIP_{"+num2str(size(SST_bias_HRMIP,3))+"} Bias ("+bias_start_year+"-"+bias_end_year+")",1, ...
% %     fontsize, true, 'Model Bias (^oC)');
% 
% IPCC_Plot_Map(hatch' ...
%     ,lat_test,lon_test,[0 3],color_bar, ...
%     "HighResMIP_{"+num2str(size(SST_bias_HRMIP,3))+"} Bias ("+bias_start_year+"-"+bias_end_year+")",2, ...
%     fontsize, true, 'Model Bias (^oC)')
% 
% hold on
patch_info = c2 
for ii=1:size(c2,2)
   if c2(1,size(c2,2)-ii+1)==3
       %patch_info(:,size(c2,2)-ii+1)=patch_info(:,size(c2,2)-ii+2);
       patch_info(1,size(c2,2)-ii+1)=NaN(1);
       patch_info(2,size(c2,2)-ii+1)=NaN(1);
   end
end
%patch_info(:,size(c2,2))=patch_info(:,size(c2,2)-1);
%patch_info(patch_info==0)=[];
%set(h2,'linestyle','none','Tag','HatchingRegion');

% This version plots inside the patches
h=patchesm(patch_info(2,:),patch_info(1,:),'b','FaceAlpha',0.2,'Linestyle','none');

% This version plots OUTSIDE the patches
%h=patchesm(c2(2,:),c2(1,:),'b','FaceAlpha',0.2,'Linestyle','none');

% set(h2.Children(1),'Tag','HatchingRegion');
% hp = findobj(gca,'Tag','HatchingRegion');
for ii=1:size(h,2)
    %hatchfill2(h(:,ii),'outspeckle','HatchAngle',45,'LineWidth',0.001);
    hatchfill2(h(:,ii),'speckle','LineWidth',0.001);
end

% [Lon,Lat] = meshgrid(wrapTo180(lon),lat); 
% [x,y] = mfwdtran(Lat,Lon);
% Lon = circshift(Lon,-61,2);
% Lat = circshift(Lat,-61,2);
% % hatch_wfo = circshift(hatch_wfo,-61,1);
% [c2, h2] = contourf(Lat,Lon,hatch',[3 3],'Fill','off','LineColor','r');
% set(h2,'linestyle','none','Tag','HatchingRegion');
% hp = findobj(gca,'Tag','HatchingRegion');
% hh = hatchfill2(hp,'single','HatchAngle',45,'LineWidth',1,'Fill','off');
% landareas = shaperead('landareas.shp','UseGeoCoords',true);
% geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);


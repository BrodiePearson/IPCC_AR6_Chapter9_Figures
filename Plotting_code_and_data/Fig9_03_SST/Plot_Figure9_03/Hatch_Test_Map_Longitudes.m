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
Lon_hatch_band = 60.5;


%% Maps of present model biases realtive to map of present SST (Fig 1)

color_bar = IPCC_Get_Colorbar('chem_d', 21, true);

% lim_max = nanmax(abs([multimodel_CMIP_bias(:); multimodel_HRMIP_bias(:)]));
lim_max = 8;
lim_min = -lim_max;
lims = [lim_min lim_max];

multimodel_CMIP_bias = nanmean(SST_bias_CMIP,3);
multimodel_HRMIP_bias = nanmean(SST_bias_HRMIP,3);

%% Plot HRMIP SST bias vs. observations

hatch_test_base_map = multimodel_HRMIP_bias;
hatch_test_base_map_shift = [hatch_test_base_map;hatch_test_base_map(1,:)];
lat_test = lat;
lon_test = wrapTo180(lon);
lon_test_shift = [lon_test;lon_test(1)];
[Lon,Lat] = meshgrid(wrapTo360(lon_test),lat_test); 

hatch = abs(sum(sign(SST_bias_HRMIP),3))/ ...
    size(SST_bias_HRMIP,3);
hatch(abs(hatch)>0.8) = 1; % If this is true at least 90% of models agree
hatch(abs(hatch)<0.8) = 3;
hatch(isnan(hatch)) = 3;
hatch(abs(Lat')>85) = 1;
hatch(Lon'==Lon_hatch_band ) = 1;

% hatch_test_base_map = multimodel_HRMIP_bias(1:10:end,1:10:end);
% hatch_test_base_map_shift = [hatch_test_base_map;hatch_test_base_map(1,:)];
% lat_test = lat(1:10:end);
% lon_test = wrapTo180(lon(1:10:end));
% lon_test_shift = [lon_test;lon_test(1)];
% 
% hatch = abs(sum(sign(SST_bias_HRMIP(1:10:end,1:10:end,:)),3))/ ...
%     size(SST_bias_HRMIP,3);
% hatch(abs(hatch)>0.6) = 1; % If this is true at least 90% of models agree
% hatch(abs(hatch)<0.6) = 3;
% hatch(isnan(hatch)) = 3;

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
[c2, h2] = contourm(lat_test,wrapTo180(lon_test_shift),hatch_shift',[3 3],'LineColor','r','Fill','off');

patch_info = c2;
for ii=1:size(c2,2)
   if c2(1,size(c2,2)-ii+1)==3
       %patch_info(:,size(c2,2)-ii+1)=patch_info(:,size(c2,2)-ii+2);
       patch_info(1,size(c2,2)-ii+1)=NaN(1);
       patch_info(2,size(c2,2)-ii+1)=NaN(1);
   end
end

indx = find(isnan(patch_info(1,:)));
for ii = 1:size(indx,2) -1
   all_patches{ii} = patch_info(:,indx(1,ii)+1:indx(1,ii+1)-1); 
end
%patch_info(:,size(c2,2))=patch_info(:,size(c2,2)-1);
%patch_info(patch_info==0)=[];
%set(h2,'linestyle','none','Tag','HatchingRegion');

%This version plots inside the patches
% h=patchesm(patch_info(2,:),patch_info(1,:),'b','FaceAlpha',0.2,'Linestyle','none');
% for ii=1:size(h,2)
%     hatchfill2(h(:,ii),'single','HatchAngle',45,'LineWidth',0.001);
%     %hatchfill2(h(:,ii),'speckle','LineWidth',0.001);
% end

for ii=1:size(c2,2)
    if c2(1,ii)==0 || c2(1,ii)==3
        c2(1,ii)=Lon_hatch_band;
        c2(2,ii)=45;
    end
end

% This version plots OUTSIDE the patches
h=patchesm(c2(2,:),c2(1,:),'b','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);

landareas = shaperead('landareas.shp','UseGeoCoords',true);
geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);

% 
% for ii=2:2 %size(lon_test_shift)
%     % Step through each longitude
%     % Found out if each latitude lies within a polygon for this lat
%     dummy = ones(size(lat_test));
%     % and for the next lat
%     dummyp1 = ones(size(lat_test));
%     for jj=1:size(lat_test)
%         for kk=1:size(all_patches,2)
%             % Test whether it is in each polygon (kk==no. of polygons)
%             dummy(jj) = dummy(jj)*double(~inpolygon(lon_test_shift(ii),lat_test(jj), ...
%                 all_patches{kk}(1,:),all_patches{kk}(2,:)));
%             if ii==size(lon_test_shift) % wrap around
%                 dummyp1(jj) = dummyp1(jj)*double(~inpolygon(lon_test_shift(1),lat_test(jj), ...
%                     all_patches{kk}(1,:),all_patches{kk}(2,:)));
%             else
%                 dummyp1(jj) = dummyp1(jj)*double(~inpolygon(lon_test_shift(ii+1),lat_test(jj), ...
%                     all_patches{kk}(1,:),all_patches{kk}(2,:)));
%             end
%         end
%     end
%     % Set values within significant regions to be NaNs so patch misses them
%     dummy=double(dummy);
%     dummy(dummy==0)=NaN(1);
%     dummyp1=double(dummyp1);
%     dummyp1(dummyp1==0)=NaN(1);
%     
%     % create patches for these longitudinal strips of data, bound by adjaecent
%     % longitudes
%     indx = find(isnan(dummy));
%     indxp1 = find(isnan(dummyp1));
%     if size(indx)==1
%         if indx == 1
%             lat_min = lat_test(indx+1);
%             lat_max = lat_test(end);
%             lat_minp1 = lat_test(indxp1+1);
%             lat_maxp1 = lat_test(end);
%             lon_min = lon_test_shift(ii);
%             if ii==size(lon_test_shift)
%                 lon_max = lon_test_shift(1);
%             else
%                 lon_max = lon_test_shift(ii+1);
%             end
%             c_temp = [lon_min, lat_min; lon_min, lat_max; lon_max, lat_maxp1;...
%                 lon_max,lat_minp1; lon_min, lat_min];
%         elseif indx == size(lat_test)
%             lat_min = lat_test(1);
%             lat_max = lat_test(end-1);
%             lat_minp1 = lat_test(1);
%             lat_maxp1 = lat_test(end-1);
%             lon_min = lon_test_shift(ii);
%             if ii==size(lon_test_shift)
%                 lon_max = lon_test_shift(1);
%             else
%                 lon_max = lon_test_shift(ii+1);
%             end
%             c_temp = [lon_min, lat_min; lon_min, lat_max; lon_max, lat_maxp1;...
%                 lon_max,lat_minp1; lon_min, lat_min];
%             
%         else
%             lat_min = lat_test(1);
%             lat_max = lat_test(indx-1);
%             lat_minp1 = lat_test(1);
%             lat_maxp1 = lat_test(indxp1-1);
%             lon_min = lon_test_shift(ii);
%             if ii==size(lon_test_shift)
%                 lon_max = lon_test_shift(1);
%             else
%                 lon_max = lon_test_shift(ii+1);
%             end
%             c_temp = [lon_min, lat_min; lon_min, lat_max; lon_max, lat_maxp1;...
%                 lon_max,lat_minp1; lon_min, lat_min];
%             lat_min = lat_test(indx+1);
%             lat_max = lat_test(end);
%             lat_minp1 = lat_test(indxp1+1);
%             lat_maxp1 = lat_test(end);
%             c_temp = [c_temp; NaN(1), NaN(1); [lon_min, lat_min; lon_min, lat_max; lon_max, lat_maxp1;...
%                 lon_max,lat_minp1; lon_min, lat_min]];
%         end
%         h_dummy=patchesm(c_temp(:,2)',c_temp(:,1)','r','FaceAlpha',0.8,'Linestyle','none');
%     elseif size(indx)== size(lon_test_shift)
%         
%     else
%         for mm = 1:size(indx)
%             lat_min = lat_test(indx(mm)+1);
%             lat_max = lat_test(indx(mm+1)-1);
%             lat_minp1 = lat_test(indxp1(mm)+1);
%             lat_maxp1 = lat_test(indxp1(mm+1)-1);
%             lon_min = lon_test_shift(ii);
%             if ii==size(lon_test_shift)
%                 lon_max = lon_test_shift(1);
%             else
%                 lon_max = lon_test_shift(ii+1);
%             end
%             if mm==1
%                 c_temp = [lon_min, lat_min; lon_min, lat_max; lon_max, lat_maxp1;...
%                     lon_max,lat_minp1; lon_min, lat_min];
%             else
%                 c_temp = [c_temp; NaN(1), NaN(1); [lon_min, lat_min; lon_min, lat_max; lon_max, lat_maxp1;...
%                     lon_max,lat_minp1; lon_min, lat_min]];
%             end
%         end
%         h_dummy=patchesm(c_temp(:,2)',c_temp(:,1)','r','FaceAlpha',0.8,'Linestyle','none');
%         %if size(h_dummy,2)>=1
%         %    for ll=1:size(h_dummy,2)
%         %        hatchfill2(h_dummy,'single','HatchAngle',45,'LineWidth',0.001);
%         %    end
%         %end
%     end
% end
% % landareas = shaperead('landareas.shp','UseGeoCoords',true);
% % geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);
% 
% 
% 

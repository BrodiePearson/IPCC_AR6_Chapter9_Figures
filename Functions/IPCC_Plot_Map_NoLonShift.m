function  IPCC_Plot_Map_NoLonShift(mapped_variable, latitude, longitude, ...
    cbar_limits, color_bar, plot_title, figure_number, fontsize, ...
    plot_bar, bar_title, hatch_models,obs_flag)
%IPCC_Plot_Map Plot IPCC-style global map of a variable
%
%    IPCC_Plot_Map(mapped_variable, latitude, longitude, ...
%               cbar_limits, color_bar, plot_title, figure_number, ...
%               fontsize, plot_bar, bar_title, stipple_mask)
%
%    returns plot showing global map of a variable in the style of IPCC AR6
%    chapter 9. Can also facilitate stippling for regions covered by a mask
%    (e.g. low confidence regions or other desired regional distinction)
%
% Input variables:
%           mapped_variable - M x N array of the variable to be mapped
%           latitude - vector of length M with latitudes
%           longitude - vector of length N with longitudes
%           cbar_limits - min and max values of colorbar given as [min max]
%           color_bar - colorbar values, specified as a vector of numbers
%                       or through color_bar = IPCC_Get_Colorbar(varargins)
%           title - A string describing the figure content
%           figure_number - Specifed to avoid over-writing old figures
%           fontsize - for all writing on figure
%           plot_bar - true is color bar should be plotted
%           bar_title - Title for color bar
%           hatch_models - a M x N x Y array containing M x N maps of
%                           mapped_variable for Y models. Hatching condition
%                           depends on number of models. Or an MxN field of
%                           pvalues (1=significant, other values
%                           non-significant) if the obs_flag is on
%           obs_flag - true if hatch_models is a pvalue array rather than
%                       multimodel data
%
% Function written by Brodie Pearson

landareas = shaperead('landareas.shp','UseGeoCoords',true);
if ~exist('fontsize')
    fontsize = 15;
end

%if longitude(1)~=longitude(end)
%'fixing longs'
%[mapped_variable, latitude, longitude]=IPCC_Fix_Long(mapped_variable, latitude, longitude, 210);
%end

size(mapped_variable)
size(longitude)
size(latitude)

colors=color_bar;

% This bit was meant to wrap around meridian, but it breaks contour mapping
% if size(longitude,1)~=1 && size(longitude,2)~=1
%     mapped_variable = [mapped_variable mapped_variable(:,1)];
%     % if ndims(squeeze(longitude))==1
%     if ndims(squeeze(longitude))==2 && size(longitude,1)>1 && size(longitude,2)>1
%         longitude = [longitude longitude(:,1)];
%         latitude = [latitude latitude(:,1)];
%     else
%         longitude = [longitude; longitude(1)];
%     end
    
    % end
    % elseif ndims(squeeze(longitude))==2
%     longitude = [longitude longitude(:,1)]; 
%     latitude = [latitude latitude(:,1)]; 
% end

% If lat, lon, and variable are all provided 
% as a vector of length M, sort and turn into 2D



size(mapped_variable)
size(longitude)
size(latitude)

levels = cbar_limits(1)+(0:size(colors,1))*(cbar_limits(2)- ...
    cbar_limits(1))/(size(colors,1));

if size(figure_number)==1
    figure(figure_number)
else
    subplot(figure_number(1), figure_number(2), figure_number(3))
end

axesm ('eckert4','Frame','on','Grid','on','MeridianLabel','on','ParallelLabel','on');
 setm(gca, 'Origin', [0 210 0], 'MlabelLocation', 60, ...
     'PlabelLocation',[-60, -30, 0, 30, 60] ,...
     'MlabelParallel','north','MeridianLabel','off',...
     'ParallelLabel','off','MlineLocation',60,...
     'PlineLocation',[-60, -30, 0, 30, 60],'FontSize', fontsize, ...
     'PLabelMeridian', 'west')
%setm(gca, 'Origin', [0 210 0])

geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);
contourm(latitude,longitude,mapped_variable, levels,'Fill','on','LineStyle', 'none')
%contourfm(latitude,longitude,mapped_variable, levels,'Fill','on')
geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);
title(plot_title, 'FontSize', fontsize)
caxis(cbar_limits)
colormap(gca,colors)
box off
axis off
if exist('stipple_mask')
    if length(stipple_mask)>0
     if ndims(squeeze(longitude))==2 && size(longitude,1)>1 && size(longitude,2)>1
        lat_temp = latitude;
        lon_temp = longitude;
     else
%     if ndims(squeeze(longitude))==1
        [lat_temp,lon_temp] = meshgrid(longitude,latitude);
     end
%     elseif ndims(squeeze(longitude))==2
%         lat_temp = latitude;
%         lon_temp = longitude;
%     end
%    stipple_mask = [stipple_mask stipple_mask(:,1)];
    stipplem(lon_temp,lat_temp,stipple_mask,'color','w');
    end
end
if ~exist('plot_bar') || plot_bar==true
    if exist('bar_title')
        H=colorbar('FontSize', fontsize, 'Location', 'southoutside');
        set(get(H,'XLabel'),'string',bar_title);
    else
        colorbar('FontSize', fontsize, 'Location', 'southoutside');
    end
end

if exist('hatch_models')
    if exist('obs_flag') && obs_flag==true
        hatch=hatch_models;
        hatch(hatch==1) = 1;
        hatch(hatch~=1) = 3;
    else
        hatch = abs(sum(sign(hatch_models),3))/size(hatch_models,3);
        if size(hatch_models,3) >= 10
            hatch(abs(hatch)>0.8) = 1; % If this is true at least 90% of models agree
            hatch(abs(hatch)<0.8) = 3;
        else
            hatch(abs(hatch)>0.6) = 1; % If this is true at least 80% of models agree
            hatch(abs(hatch)<0.6) = 3;
            %hatch(:,1:80)=1;
            %hatch(:,end-80:end)=1;
        end
    end
    hatch(isnan(hatch)) = 3;
    
    hatch_shift = [hatch;hatch(1,:)];
    if size(longitude,1)~=size(hatch_shift,1) % match sizes of hatching map and longitudes
        longitude = [longitude;longitude(1)];
    end
    size(longitude)
    size(latitude)
    size(hatch_shift)
    
    hold on
    [c2, h2] = contourm(latitude,wrapTo180(longitude),hatch_shift', ...
        [3 3],'LineColor','none','Fill','off');
    
    patch_info = c2;
    for ii=1:size(c2,2)
        if c2(1,size(c2,2)-ii+1)==3
            patch_info(1,size(c2,2)-ii+1)=NaN(1);
            patch_info(2,size(c2,2)-ii+1)=NaN(1);
        end
    end
    
    indx = find(isnan(patch_info(1,:)));
    for ii = 1:size(indx,2) -1
        all_patches{ii} = patch_info(:,indx(1,ii)+1:indx(1,ii+1)-1);
    end
    
    for ii=1:size(c2,2)
        if c2(1,ii)==0 || c2(1,ii)==3
            c2(1,ii)=60.5;
            c2(2,ii)=0;
        end
    end
    
    % This version plots OUTSIDE the patches
    h=patchesm(c2(2,:),c2(1,:),'b','FaceAlpha',0,'Linestyle','none');
    hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);
    
    landareas = shaperead('landareas.shp','UseGeoCoords',true);
    geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);
    
end

end
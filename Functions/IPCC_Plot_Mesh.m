function  IPCC_Plot_Map(mapped_variable, latitude, longitude, ...
    cbar_limits, colorscheme, plot_title, figure_number, fontsize, ...
    plot_bar, bar_title, stipple_mask)
%IPCC_Plot_Map Function to plot IPCC maps of variables.
% Input variables:
%           mapped_variable - M x N array of the variable to be mapped
%           latitude - vector of length M with latitudes
%           longitude - vector of length N with longitudes
%           cbar_limits - min and max values of colorbar given as [min max]
%           colorscheme - IPCC colorbar choice (specified as a name)
%           title - A string describing the figure content
%           figure_number
%           stipple - a M x N array of 

landareas = shaperead('landareas.shp','UseGeoCoords',true);
if ~exist('fontsize')
    fontsize = 15;
end

colors=colorscheme;


size(mapped_variable)
%size(longitude)
%size(latitude)

mapped_variable = [mapped_variable mapped_variable(:,1)];
% if ndims(squeeze(longitude))==1
if ndims(squeeze(longitude))==2 && size(longitude,1)>1 && size(longitude,2)>1
    longitude = [longitude longitude(:,1)];
    latitude = [latitude latitude(:,1)];
else
    longitude = [longitude; longitude(1)];
end
    % elseif ndims(squeeze(longitude))==2
%     longitude = [longitude longitude(:,1)]; 
%     latitude = [latitude latitude(:,1)]; 
% end
size(mapped_variable)
%size(longitude)
%size(latitude)

levels = cbar_limits(1)+(0:size(colors,1))*(cbar_limits(2)- ...
    cbar_limits(1))/(size(colors,1));

if size(figure_number)==1
    figure('Position', [0 0 1000 700])
else
    subplot(figure_number(1), figure_number(2), figure_number(3))
end

axesm ('eckert4','Frame','on','Grid','on','MeridianLabel','on','ParallelLabel','on');
  setm(gca, 'Origin', [0 210 0], 'MlabelLocation', 60, ...
      'PlabelLocation',[-60, -30, 0, 30, 60] ,...
      'MlabelParallel','south','MeridianLabel','off',...
      'ParallelLabel','off','MlineLocation',60,...
      'PlineLocation',[-60, -30, 0, 30, 60],'FontSize', fontsize, ...
      'PLabelMeridian', 'east')
%setm(gca, 'Origin', [0 210 0])

geoshow(landareas,'FaceColor',[.761 .698 .502],'EdgeColor',[.6 .6 .6]);
surfacem(latitude,longitude,mapped_variable)%, levels,'Fill','on','LineStyle', 'none')
title(plot_title, 'FontSize', fontsize)
caxis(cbar_limits)
colormap(gca,colors)
box off
axis off
if exist('stipple_mask')
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
    stipple_mask = [stipple_mask stipple_mask(:,1)];
    stipplem(lon_temp,lat_temp,stipple_mask,'color','w');
end
if ~exist('plot_bar') || plot_bar==true
    if exist('bar_title')
 %       H=colorbar('FontSize', fontsize, 'Location', 'South');
 %       set(get(H,'title'),'string',bar_title);
    else
 %       colorbar('FontSize', fontsize, 'Location', 'South');
    end
end

end
function  [greenland]=IPCC_Plot_Polar(mapped_variable, latitude, longitude, ...
    cbar_limits, colorscheme, plot_title, figure_number, Pole, fontsize, ...
    plot_bar, bar_title, stipple_mask)
%function  IPCC_Plot_Polar(mapped_variable, latitude, longitude, cbar_limits, colorscheme, plot_title, figure_number, Pole, fontsize,plot_bar, bar_title, stipple_mask)
%IPCC_Plot_Map Function to plot IPCC maps of variables.
% Input variables:
%           mapped_variable - M x N array of the variable to be mapped
%           latitude - vector of length M with latitudes
%           longitude - vector of length N with longitudes
%           cbar_limits - min and max values of colorbar given as [min max]
%           colorscheme - IPCC colorbar choice (specified as a name)
%           title - A string describing the figure content
%           figure_number
%           Pole=1 for north, -1 for south, 2 for GIS, -2 for AIS
%           stipple - a M x N array of 

landareas = shaperead('landareas.shp','UseGeoCoords',true);
if ~exist('fontsize')
    fontsize = 15;
end

colors=colorscheme;

size(mapped_variable)
%size(longitude)
%size(latitude)

%mapped_variable = [mapped_variable mapped_variable(:,1)];
% if ndims(squeeze(longitude))==1
%if ndims(squeeze(longitude))==2 && size(longitude,1)>1 && size(longitude,2)>1
%    longitude = [longitude longitude(:,1)];
%    latitude = [latitude latitude(:,1)];
%else
%    longitude = [longitude; longitude(1)];
%end
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
    figure('Position',[0 0 611 611])
else
    subplot(figure_number(1), figure_number(2), figure_number(3))
end

ecru=[.761 .698 .502];
white=[1 1 1];

axesm('eqaazim','Frame','on','Grid','on','MeridianLabel','on','ParallelLabel','on');
  if abs(Pole)==1
    setm(gca, 'Origin', [Pole*90 0 0],'FLatLimit',[-Inf 75], ...
      'MlabelLocation', 60, ...
      'PlabelLocation',[-60, -30, 0, 30, 60] ,...
      'MlabelParallel','south','MeridianLabel','off',...
      'ParallelLabel','off','MlineLocation',60,...
      'PlineLocation',[-60, -30, 0, 30, 60],'FontSize', fontsize, ...
      'PLabelMeridian', 'east')
      landcolor=ecru;
  elseif Pole==2
%      axesm('MapProjection','mercator','Frame','off','Grid','off','MeridianLabel','off','ParallelLabel','off');
       setm(gca, 'Origin', [70 -40 0],'FLatLimit',[-Inf 16.0], ...
       'MlabelLocation', 60, ...
       'PlabelLocation',[-60, -30, 0, 30, 60] ,...
       'MlabelParallel','south','MeridianLabel','off',...
       'ParallelLabel','off','MlineLocation',60,...
       'PlineLocation',[-60, -30, 0, 30, 60],'FontSize', fontsize, ...
       'PLabelMeridian', 'east')
      landcolor=white;
%      worldmap('greenland')
%      greenland = shaperead('landareas', 'UseGeoCoords', true,...
%      'Selector',{@(name) strcmp(name,'Greenland'), 'Name'})
%        axesm('eqaconic', 'Frame', 'on', 'Grid', 'on');
  elseif Pole==-2
      setm(gca, 'Origin', [0.5*Pole*90 0 0],'FLatLimit',[-Inf 30], ...
      'MlabelLocation', 60, ...
      'PlabelLocation',[-60, -30, 0, 30, 60] ,...
      'MlabelParallel','south','MeridianLabel','off',...
      'ParallelLabel','off','MlineLocation',60,...
      'PlineLocation',[-60, -30, 0, 30, 60],'FontSize', fontsize, ...
      'PLabelMeridian', 'east')     
      landcolor=white;
%      worldmap('antarctica')
%      antarctica = shaperead('landareas', 'UseGeoCoords', true,...
%      'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});
%      setm(gca, 'Origin', [0.5*Pole*90 0 0]);
  else
    setm(gca, 'Origin', [0 210 0])
    landcolor=ecru;
  end

geoshow(landareas,'FaceColor',landcolor,'EdgeColor',[.6 .6 .6]);
surfacem(latitude,longitude,mapped_variable)%, levels,'Fill','on','LineStyle', 'none')
h=title(plot_title, 'FontSize', fontsize)
set(h,'Position',get(h,'Position')+[0 -0.02 0])
caxis(cbar_limits)
colormap(gca,colors)
framem('off')
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
        H=colorbar('FontSize', fontsize, 'Location', 'EastOutside');
        set(get(H,'XLabel'),'string',bar_title);
        set(H,'Position',get(H,'Position')+[-0.02 0.02 0 0])
    else
        colorbar('FontSize', fontsize, 'Location', 'EastOutside');
        set(H,'Position',get(H,'Position')+[-0.02 0.02 0 0])
    end
end

end
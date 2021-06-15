function  IPCC_Plot_EBUS(mapped_variable, latitude, longitude, ...
    cbar_limits, colorscheme, plot_title, figure_number, EBUS, fontsize, ...
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
%           EBUS=1 for CA Current, 2 for Humboldt, 3 for Canary, 4 for
%           Benguela
%           stipple - a M x N array of 

landareas = shaperead('landareas.shp','UseGeoCoords',true);
if ~exist('fontsize')
    fontsize = 15;
end

colors=colorscheme;
size(mapped_variable)

levels = cbar_limits(1)+(0:size(colors,1))*(cbar_limits(2)- ...
    cbar_limits(1))/(size(colors,1));

if size(figure_number)==1
    figure('Position',[0 0 650 700])
else
    subplot(figure_number(1), figure_number(2), figure_number(3))
end

ecru=[.761 .698 .502];
white=[1 1 1];

% these properties are extracted from 600km offshore to a meridian about 2500km offshore
% 155°W for the California, 
% 130°W for the Humboldt, 
% 45°W for the Canary, 
% 15°W for the Benguela Current systems

%h=axesm('eqaazim','Frame','off','Grid','on','MeridianLabel','off','ParallelLabel','off');
h=axesm('MapProjection','mercator','Grid','on','MeridianLabel','off','ParallelLabel','on')
  if EBUS==1  % California
    setm(h,'MapLatLimit',[20 50] ,'MapLonLimit',[-135 -105])
    h = quiverm([20 50],[-135 -105],100*[1 1]*cos(30),100*[1 1]*sin(30));
    %setm(h, 'Origin', [30 -155+20 0],'FLatLimit',[-Inf 20])%, ...
      %'MlabelLocation', 60, ...
      %'PlabelLocation',[-60, -30, 0, 30, 60] ,...
      %'MlabelParallel','south','MeridianLabel','off',...
      %'ParallelLabel','off','MlineLocation',60,...
      %'PlineLocation',[-60, -30, 0, 30, 60],'FontSize', fontsize, ...
      %'PLabelMeridian', 'east')
      landcolor=ecru;
  elseif EBUS==2  % Humboldt
      setm(h,'MapLatLimit',[-45 -15] ,'MapLonLimit',[-85 -65])
      %setm(h, 'Origin', [-30 -130+20 0],'FLatLimit',[-Inf 20])%, ...
      %'MlabelLocation', 60, ...
      %'PlabelLocation',[-60, -30, 0, 30, 60] ,...
      %'MlabelParallel','south','MeridianLabel','off',...
      %'ParallelLabel','off','MlineLocation',60,...
      %'PlineLocation',[-60, -30, 0, 30, 60],'FontSize', fontsize, ...
      %'PLabelMeridian', 'east')      
      landcolor=ecru;
  elseif EBUS==3   % Canary
      setm(h,'MapLatLimit',[20 45] ,'MapLonLimit',[-30 -5])
      %setm(h, 'Origin', [30 -45+20 0],'FLatLimit',[-Inf 20])%, ...
      %'MlabelLocation', 60, ...
      %'PlabelLocation',[-60, -30, 0, 30, 60] ,...
      %'MlabelParallel','south','MeridianLabel','off',...
      %'ParallelLabel','off','MlineLocation',60,...
      %'PlineLocation',[-60, -30, 0, 30, 60],'FontSize', fontsize, ...
      %'PLabelMeridian', 'east')      
      landcolor=ecru;
  elseif EBUS==4   %Benguela
      setm(h,'MapLatLimit',[-35 -10] ,'MapLonLimit',[0 25])
      %setm(h, 'Origin', [-30 -15+20 0],'FLatLimit',[-Inf 20])%, ...
      %'MlabelLocation', 60, ...
      %'PlabelLocation',[-60, -30, 0, 30, 60] ,...
      %'MlabelParallel','south','MeridianLabel','off',...
      %'ParallelLabel','off','MlineLocation',60,...
      %'PlineLocation',[-60, -30, 0, 30, 60],'FontSize', fontsize, ...
      %'PLabelMeridian', 'east')      
      landcolor=ecru;
  else
    setm(gca, 'Origin', [0 210 0])
    landcolor=ecru;
  end

geoshow(landareas,'FaceColor',landcolor,'EdgeColor',[.6 .6 .6]);
surfacem(latitude,longitude,mapped_variable)%, levels,'Fill','on','LineStyle', 'none')
geoshow(landareas,'FaceColor',landcolor,'EdgeColor',[.6 .6 .6]);
hh=title(plot_title, 'FontSize', fontsize)

if EBUS==3
    
else
    set(hh,'Position',get(hh,'Position')+[0 -0.06 0])
end

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
        [lat_temp,lon_temp] = meshgrid(longitude,latitude);
    end
%    stipple_mask = [stipple_mask stipple_mask(:,1)];
    stip=logical(~isnan(stipple_mask).*(stipple_mask==1));
    size(lon_temp)
    size(lat_temp)
    size(stip)
    stipplem(lon_temp,lat_temp,stip,'color','k','density',1500,'marker','x');
end
if ~exist('plot_bar') || plot_bar==true
    if exist('bar_title')
        H=colorbar('FontSize', fontsize, 'Location', 'SouthOutside');
        set(get(H,'XLabel'),'string',bar_title);
        set(get(H,'title'),'string','(0.1 N/m^2/yr)');
        set(H,'Position',get(H,'Position')+[0 -0.06 0 0])
        set(H,'XTick',[cbar_limits(1):.01:cbar_limits(2)])
    else
        colorbar('FontSize', fontsize, 'Location', 'SouthOutside');
    end
end

end

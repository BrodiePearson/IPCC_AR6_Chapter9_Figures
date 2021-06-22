function  IPCC_Plot_Map(mapped_variable, latitude, longitude, ...
    cbar_limits, colorscheme, plot_title, figure_number, fontsize, ...
    plot_bar, bar_title, stipple_mask)
% function  IPCC_Plot_Map(mapped_variable, latitude, longitude, ...
%     cbar_limits, colorscheme, plot_title, figure_number, fontsize, ...
%     plot_bar, bar_title, stipple_mask)
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

size(mapped_variable)
size(longitude)
size(longitude,1)
size(longitude,2)

colors=colorscheme;
% if size(longitude,1)~=1 && size(longitude,2)~=1
    mapped_variable = [mapped_variable mapped_variable(:,1)];
    % if ndims(squeeze(longitude))==1
    if ndims(squeeze(longitude))==2 && size(longitude,1)>1 && size(longitude,2)>1
        longitude = [longitude longitude(:,1)];
        latitude = [latitude latitude(:,1)];
    else
        longitude = [longitude; longitude(1)];
    end
% end
    % elseif ndims(squeeze(longitude))==2
%     longitude = [longitude longitude(:,1)]; 
%     latitude = [latitude latitude(:,1)]; 
% end

% If lat, lon, and variable are all provided 
% as a vector of length M, sort and turn into 2D



size(mapped_variable)
size(longitude)

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
%contourm(latitude,longitude,mapped_variable, levels,'Fill','on','LineStyle', 'none')
%geoshow(landareas,'FaceColor',[0 0 0]+0.7,'EdgeColor',[.6 .6 .6]);
%title(plot_title, 'FontSize', fontsize)
title(plot_title, 'FontSize', fontsize,'fontweight','normal') %edit TH 07-01-2020

% if contains(plot_title,'SSP126')
%     title('SSP1-2.6', 'FontSize', fontsize,'fontweight','bold', ...
%         'Color',IPCC_Get_SSPColors('ssp126'));
% elseif contains(plot_title,'SSP245')
%     title('SSP2-4.5', 'FontSize', fontsize,'fontweight','bold', ...
%         'Color',IPCC_Get_SSPColors('ssp245'));
% elseif contains(plot_title,'SSP585')
%     title('SSP5-8.5', 'FontSize', fontsize,'fontweight','bold', ...
%         'Color',IPCC_Get_SSPColors('ssp585'));
% end


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
        H=colorbar('FontSize', fontsize, 'Location', 'southoutside');
        H.TickLabels={'<1','10','100','>1000'}; %hardcode ticks, TH 07-01-2020
        H.Ticks=[log10(1),log10(10),log10(100),log10(1000)]; %hardcode ticks, TH 07-01-2020
        set(get(H,'XLabel'),'string',bar_title);
    else
        colorbar('FontSize', fontsize, 'Location', 'southoutside');
    end
end

end
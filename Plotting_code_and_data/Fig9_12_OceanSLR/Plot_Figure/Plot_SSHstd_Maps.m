%% IPCC AR6 Chapter 9: Figure 9.12 (Sea Level Rise)
%
% Code used to plot processed ocean sea-level rise data. 
%
% Plotting code written by Brodie Pearson

clear all

addpath ../../../Functions/

fontsize = 20;

color_bar = IPCC_Get_Colorbar('precip_nd', 21, false);

lims = [0 1]*0.4;

load('./Processed_Data/SSH_std_Maps.mat')

%% Plot validation maps

for ii=1:size(omip_highres,3)
   subplot(ceil(sqrt(size(omip_highres,3))), ...
        ceil(sqrt(size(omip_highres,3))), ii);
    imagesc(lon,lat,fliplr(omip_highres(:,:,ii))');
    colormap(color_bar)
    title(model_names{1,ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/OMIP_highres_Maps.png','-dpng','-r100', '-painters');
close(1)
for ii=1:size(omip_lowres,3)
   subplot(ceil(sqrt(size(omip_lowres,3))), ...
        ceil(sqrt(size(omip_lowres,3))), ii);
    imagesc(lon,lat,fliplr(omip_lowres(:,:,ii))');
    colormap(color_bar)
    title(model_names{2,ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/OMIP_lowres_Maps.png','-dpng','-r100', '-painters');
close(1)


%% Plot OMIP high-res SSH standard deviation map 

latitude = lat';
longitude = [lon'; lon(1)];

plot_var1 = nanmean(omip_highres,3);
plot_var1 = [plot_var1; plot_var1(1,:,:)];

IPCC_Plot_Map_Gappy(plot_var1',latitude,longitude,lims, ...
    color_bar,"OMIP High-res_{"+num2str(model_count{1})+" models} SSH std 1995-2014",...
    1,fontsize, true, '(m^{-2})')

title('')
colorbar off
print(gcf,'../PNGs/OMIP_HR_SSHstd.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-12h_data.nc';
var_name = 'SSH_std';
var_units = 'm';
title = "Standard Deviation of Sea Surface Height from high-resolution CMIP6 (OMIP) models";
comments = "Data is for panel (h) of Figure 9.12 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude, longitude, title, comments)

%% Plot OMIP low-res SSH standard deivation map 

latitude = lat';
longitude = [lon'; lon(1)];

plot_var1 = nanmean(omip_lowres,3);
plot_var1 = [plot_var1; plot_var1(1,:,:)];


IPCC_Plot_Map_Gappy(plot_var1',latitude,longitude,lims, ...
    color_bar,"OMIP Low-res_{"+num2str(model_count{2})+" models} SSH std 1995-2014",...
    1,fontsize, true, '(m^{-2})')

title('')
colorbar off
print(gcf,'../PNGs/OMIP_LR_SSHstd.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-12i_data.nc';
var_name = 'SSH_std';
var_units = 'm';
title = "Standard Deviation of Sea Surface Height from low-resolution CMIP6 (OMIP) models";
comments = "Data is for panel (i) of Figure 9.12 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude, longitude, title, comments)

%% Plot observed SSH standard deviation map 

latitude = lat_obs';
longitude = [lon_obs; lon_obs(1)];

plot_var1 = SSH_std_OBS;
plot_var1 = [plot_var1; plot_var1(1,:,:)];


IPCC_Plot_Map_Gappy(plot_var1',latitude,longitude,lims, ...
    color_bar,"Observed SSH std 1995-2014",...
    1,fontsize, true, '(m)')

print(gcf,'../PNGs/Observed_SSHstd_title.png','-dpng','-r1000', '-painters');
% title('')
% colorbar off
% print(gcf,'./PNGs/Observed_SSHstd.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-12g_data.nc';
var_name = 'SSH_std';
var_units = 'm';
title = "Standard Deviation of Sea Surface Height from observations";
comments = "Data is for panel (g) of Figure 9.12 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude', longitude, title, comments)

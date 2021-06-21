%% IPCC AR6 Chapter 9: Figure 9.12 (Sea Level Rise)
%
% Code used to plot processed ocean sea-level rise data. 
%
% Plotting code written by Brodie Pearson

clear all

addpath ../../../Functions/

fontsize = 20;


color_bar = IPCC_Get_Colorbar('temperature_nd', 21, true);
%change_color_bar = IPCC_Get_Colorbar('temperature_d', 21, true);

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
change_color_bar = [color_bar2(3:11,:); color_bar1];


color_bar1 = [2 71 104
    19 93 129
    36 116 154
    54 138 179
    71 161 204
    89 183 228
    121 197 233
    153 210 237
    185 223 241
    217 235 245
    248 248 248
    246 231 207
    243 212 166
    241 195 124
    238 176 83
    235 158 42
    204 138 40
    173 117 38
    142 97 36
    111 76 34
    80 56 33]/255;

%color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
change_color_bar = color_bar1; %color_bar1(5:end,:);

% lims = [-0.4 1]*lim_max;

lims = [-0.6 0.601];
%change_lims = [-1 1]*0.1;

%% Load observed std and model ensemble SSH statistics

SSH_std_OBS = ncread('./Processed_Data/obs/std_obs.nc','sla');
lat_obs = ncread('./Processed_Data/obs/std_obs.nc','lat');
lon_obs = ncread('./Processed_Data/obs/std_obs.nc','lon');

load('./Processed_Data/SSH_Maps.mat')

lon = -179.5:179.5;
    lat = -90:90;
    
 %% Remove global mean change from each model's Sea Level Change field
 
 % Calculate area of each 1x1 degree region
 areas=NaN(size(lat.*lon'));
 for ii = 1:size(areas,1)
     for jj=1:size(areas,2)
         areas(ii,jj) = areaquad(lat(jj)-0.5, lon(ii)-0.5, ...
             lat(jj)+0.5, lon(ii)+0.5);
     end
 end
 
  for kk=1:size(dynamic_ssp585,3)
     dynamic_ssp585_demeaned(:,:,kk) = ...
         dynamic_ssp585(:,:,kk) - IPCC_Global_Mean(dynamic_ssp585(:,:,kk),areas',1);
 end
  for kk=1:size(thermosteric_ssp585,3)
     thermosteric_ssp585_demeaned(:,:,kk) = ...
         thermosteric_ssp585(:,:,kk) - IPCC_Global_Mean(thermosteric_ssp585(:,:,kk),areas',1);
  end
  for kk=1:size(halosteric_ssp585,3)
     halosteric_ssp585_demeaned(:,:,kk) = ...
         halosteric_ssp585(:,:,kk) - IPCC_Global_Mean(halosteric_ssp585(:,:,kk),areas',1);
  end
 for kk=1:size(dynamic_ssp126,3)
     dynamic_ssp126_demeaned(:,:,kk) = ...
         dynamic_ssp126(:,:,kk) - IPCC_Global_Mean(dynamic_ssp126(:,:,kk),areas',1);
 end
  for kk=1:size(thermosteric_ssp126,3)
     thermosteric_ssp126_demeaned(:,:,kk) = ...
         thermosteric_ssp126(:,:,kk) - IPCC_Global_Mean(thermosteric_ssp126(:,:,kk),areas',1);
  end
  for kk=1:size(halosteric_ssp126,3)
     halosteric_ssp126_demeaned(:,:,kk) = ...
         halosteric_ssp126(:,:,kk) - IPCC_Global_Mean(halosteric_ssp126(:,:,kk),areas',1);
  end

%% Plot validation maps


figure('Position', [10 10 1200 1200])
for ii=1:size(dynamic_ssp585_demeaned,3)
   subplot(ceil(sqrt(size(dynamic_ssp585_demeaned,3))), ...
        ceil(sqrt(size(dynamic_ssp585_demeaned,3))), ii);
    imagesc(lon,lat,fliplr(dynamic_ssp585_demeaned(:,:,ii))');
    colormap(change_color_bar)
    title(model_names{1,ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/Dynamic_ssp585_demeaned_Maps.png','-dpng','-r100', '-painters');
close(1)
figure('Position', [10 10 1200 1200])
for ii=1:size(thermosteric_ssp585_demeaned,3)
   subplot(ceil(sqrt(size(thermosteric_ssp585_demeaned,3))), ...
        ceil(sqrt(size(thermosteric_ssp585_demeaned,3))), ii);
    imagesc(lon,lat,fliplr(thermosteric_ssp585_demeaned(:,:,ii))');
    colormap(change_color_bar)
    title(model_names{2,ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/Thermosteric_ssp585_demeaned_Maps.png','-dpng','-r100', '-painters');
close(1)
figure('Position', [10 10 1200 1200])
for ii=1:size(thermosteric_ssp585_demeaned,3)
   subplot(ceil(sqrt(size(halosteric_ssp585_demeaned,3))), ...
        ceil(sqrt(size(halosteric_ssp585_demeaned,3))), ii);
    imagesc(lon,lat,fliplr(halosteric_ssp585_demeaned(:,:,ii))');
    colormap(change_color_bar)
    title(model_names{3,ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/Halosteric_ssp585_demeaned_Maps.png','-dpng','-r100', '-painters');
close(1)
figure('Position', [10 10 1200 1200])
for ii=1:size(dynamic_ssp126_demeaned,3)
   subplot(ceil(sqrt(size(dynamic_ssp126_demeaned,3))), ...
        ceil(sqrt(size(dynamic_ssp126_demeaned,3))), ii);
    imagesc(lon,lat,fliplr(dynamic_ssp126_demeaned(:,:,ii))');
    colormap(change_color_bar)
    title(model_names{4,ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/Dynamic_ssp126_demeaned_Maps.png','-dpng','-r100', '-painters');
close(1)
figure('Position', [10 10 1200 1200])
for ii=1:size(thermosteric_ssp126_demeaned,3)
   subplot(ceil(sqrt(size(thermosteric_ssp126_demeaned,3))), ...
        ceil(sqrt(size(thermosteric_ssp126_demeaned,3))), ii);
    imagesc(lon,lat,fliplr(thermosteric_ssp126_demeaned(:,:,ii))');
    colormap(change_color_bar)
    title(model_names{5,ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/Thermosteric_ssp126_demeaned_Maps.png','-dpng','-r100', '-painters');
close(1)
figure('Position', [10 10 1200 1200])
for ii=1:size(thermosteric_ssp126_demeaned,3)
   subplot(ceil(sqrt(size(halosteric_ssp126_demeaned,3))), ...
        ceil(sqrt(size(halosteric_ssp126_demeaned,3))), ii);
    imagesc(lon,lat,fliplr(halosteric_ssp126_demeaned(:,:,ii))');
    colormap(change_color_bar)
    title(model_names{6,ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/Halosteric_ssp126_demeaned_Maps.png','-dpng','-r100', '-painters');
close(1)



%% Plot Dynamic SSH change map for SSP585

% SSH_hist_wrapped = [SSH_hist; SSH_hist(1,:,:)];
latitude = lat';
longitude = [lon'; lon(1)];
% longitude = [lon'; lon(1)];

plot_var1 = nanmean(dynamic_ssp585_demeaned,3);
plot_var1 = [plot_var1; plot_var1(1,:,:)];


IPCC_Plot_Map_Gappy(plot_var1',latitude,longitude,lims, ...
    change_color_bar,"SSP5-8.5_{"+num2str(model_count{1})+" models} Steric SSH change 1984-2100",...
    1,fontsize, true, '(m)')

hatch = abs(sum(sign(dynamic_ssp585_demeaned),3))/size(dynamic_ssp585_demeaned,3)';
hatch = [hatch; hatch(1,:,:)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch; hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1;
hatch(55:60,105)=1;
% hatch(29,:)=1; hatch(150,:)=1; hatch(90,70:90)=1;
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

print(gcf,'../PNGs/StericSSH_ssp585_demeaned_title.png','-dpng','-r100', '-painters');
% title('')
% print(gcf,'../PNGs/StericSSH_ssp585_demeaned_colorbar.png','-dpng','-r1000', '-painters');
% colorbar off
% print(gcf,'../PNGs/StericSSH_ssp585_demeaned.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/StericSSH_ssp585_demeaned_hatchcheck.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-12a_data.nc';
var_name = 'StericSeaLevel';
var_units = 'm';
title = "Steric Relative Sea Level Change for SSP5-8.5 between 1984-2015"+ ...
    " and 2081-2100 from a CMIP6 ensemble";
comments = "Data is for panel (a) of Figure 9.12 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude, longitude, title, comments, hatching_mask')

%% Plot Steric SSH change map for SSP126

% SSH_hist_wrapped = [SSH_hist; SSH_hist(1,:,:)];
latitude = lat';
longitude = [lon'; lon(1)];
% longitude = [lon'; lon(1)];

plot_var1 = nanmean(dynamic_ssp126_demeaned,3);
plot_var1 = [plot_var1; plot_var1(1,:,:)];


IPCC_Plot_Map_Gappy(plot_var1',latitude,longitude,lims/2, ...
    change_color_bar,"SSP1-2.6_{"+num2str(model_count{4})+" models} Dynamic SSH change 1984-2100",...
    1,fontsize, false, '')

hatch = abs(sum(sign(dynamic_ssp126_demeaned),3))/size(dynamic_ssp126_demeaned,3)';
hatch = [hatch; hatch(1,:,:)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch; hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1;
% hatch(29,:)=1; hatch(150,:)=1; hatch(90,70:90)=1;
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

print(gcf,'../PNGs/StericSSH_ssp126_demeaned_title.png','-dpng','-r100', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/StericSSH_ssp126_demeaned.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/StericSSH_ssp126_demeaned_hatchcheck.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-12d_data.nc';
var_name = 'StericSeaLevel';
var_units = 'm';
title = "Steric Relative Sea Level Change for SSP1-2.6 between 1984-2015"+ ...
    " and 2081-2100 from a CMIP6 ensemble";
comments = "Data is for panel (d) of Figure 9.12 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude, longitude, title, comments, hatching_mask')

%% Plot Thermosteric SSH change map for SSP585

% SSH_hist_wrapped = [SSH_hist; SSH_hist(1,:,:)];
latitude = lat';
longitude = [lon'; lon(1)];
% longitude = [lon'; lon(1)];

plot_var1 = nanmean(thermosteric_ssp585_demeaned,3);
plot_var1 = [plot_var1; plot_var1(1,:,:)];


IPCC_Plot_Map_Gappy(plot_var1',latitude,longitude,lims, ...
    change_color_bar,"SSP5-8.5_{"+num2str(model_count{2})+" models} Thermosteric SSH change 1984-2100",...
    1,fontsize, true, '(m)')

hatch = abs(sum(sign(thermosteric_ssp585_demeaned),3))/size(thermosteric_ssp585_demeaned,3)';
hatch = [hatch; hatch(1,:,:)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch; hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1;
% hatch(29,:)=1; hatch(150,:)=1; hatch(90,70:90)=1;
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

print(gcf,'../PNGs/ThermostericSSH_ssp585_demeaned_title.png','-dpng','-r100', '-painters');
% title('')
% %print(gcf,'./PNGs/ThermostericSSH_ssp585_demeaned_colorbar.png','-dpng','-r1000', '-painters');
% colorbar off
% print(gcf,'../PNGs/ThermostericSSH_ssp585_demeaned.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/ThermostericSSH_ssp585_demeaned_hatchcheck.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-12b_data.nc';
var_name = 'ThermostericSeaLevel';
var_units = 'm';
title = "Thermosteric Relative Sea Level Change for SSP5-8.5 between 1984-2015"+ ...
    " and 2081-2100 from a CMIP6 ensemble";
comments = "Data is for panel (b) of Figure 9.12 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude, longitude, title, comments, hatching_mask')

%% Plot Thermosteric SSH change map for SSP126

% SSH_hist_wrapped = [SSH_hist; SSH_hist(1,:,:)];
latitude = lat';
longitude = [lon'; lon(1)];
% longitude = [lon'; lon(1)];

plot_var1 = nanmean(thermosteric_ssp126_demeaned,3);
plot_var1 = [plot_var1; plot_var1(1,:,:)];


IPCC_Plot_Map_Gappy(plot_var1',latitude,longitude,lims, ...
    change_color_bar,"SSP1-2.6_{"+num2str(model_count{5})+" models} Thermosteric SSH change 1984-2100",...
    1,fontsize, false, '')

hatch = abs(sum(sign(thermosteric_ssp126_demeaned),3))/size(thermosteric_ssp126_demeaned,3)';
hatch = [hatch; hatch(1,:,:)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch; hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1;
% hatch(29,:)=1; hatch(150,:)=1; hatch(90,70:90)=1;
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

print(gcf,'../PNGs/ThermostericSSH_ssp126_demeaned_title.png','-dpng','-r100', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/ThermostericSSH_ssp126_demeaned.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/ThermostericSSH_ssp126_demeaned_hatchcheck.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-12e_data.nc';
var_name = 'ThermostericSeaLevel';
var_units = 'm';
title = "Thermosteric Relative Sea Level Change for SSP1-2.6 between 1984-2015"+ ...
    " and 2081-2100 from a CMIP6 ensemble";
comments = "Data is for panel (e) of Figure 9.12 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude, longitude, title, comments, hatching_mask')


%% Plot Halosteric SSH change map for SSP585

% SSH_hist_wrapped = [SSH_hist; SSH_hist(1,:,:)];
latitude = lat';
longitude = [lon'; lon(1)];
% longitude = [lon'; lon(1)];

plot_var1 = nanmean(halosteric_ssp585_demeaned,3);
plot_var1 = [plot_var1; plot_var1(1,:,:)];


IPCC_Plot_Map_Gappy(plot_var1',latitude,longitude,lims, ...
    change_color_bar,"SSP5-8.5_{"+num2str(model_count{3})+" models} Halosteric SSH change 1984-2100",...
    1,fontsize, true, '(m)')

hatch = abs(sum(sign(halosteric_ssp585_demeaned),3))/size(halosteric_ssp585_demeaned,3)';
hatch = [hatch; hatch(1,:,:)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch; hatching_mask(hatching_mask~=1)=0; 
%hatch(350,1:50)=1;
hatch(60,1:60)=1;
%hatch(100,60:80)=1;
%hatch(30,130:end)=1;
% hatch(1:60:end,:)=1;
% hatch(29,:)=1; hatch(150,:)=1; hatch(90,70:90)=1;
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

print(gcf,'../PNGs/HalostericSSH_ssp585_demeaned_title.png','-dpng','-r100', '-painters');
% title('')
% %print(gcf,'./PNGs/HalostericSSH_ssp585_demeaned_colorbar.png','-dpng','-r1000', '-painters');
% colorbar off
% print(gcf,'../PNGs/HalostericSSH_ssp585_demeaned.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/HalostericSSH_ssp585_demeaned_hatchcheck.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-12c_data.nc';
var_name = 'HalostericSeaLevel';
var_units = 'm';
title = "Halosteric Relative Sea Level Change for SSP5-8.5 between 1984-2015"+ ...
    " and 2081-2100 from a CMIP6 ensemble";
comments = "Data is for panel (c) of Figure 9.12 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude, longitude, title, comments, hatching_mask')

%% Plot Halosteric SSH change map for SSP126

% SSH_hist_wrapped = [SSH_hist; SSH_hist(1,:,:)];
latitude = lat';
longitude = [lon'; lon(1)];
% longitude = [lon'; lon(1)];

plot_var1 = nanmean(halosteric_ssp126_demeaned,3);
plot_var1 = [plot_var1; plot_var1(1,:,:)];


IPCC_Plot_Map_Gappy(plot_var1',latitude,longitude,lims, ...
    change_color_bar,"SSP1-2.6_{"+num2str(model_count{6})+" models} Halosteric SSH change 1984-2100",...
    1,fontsize, false, '')

hatch = abs(sum(sign(halosteric_ssp126_demeaned),3))/size(halosteric_ssp126_demeaned,3)';
hatch = [hatch; hatch(1,:,:)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch; hatching_mask(hatching_mask~=1)=0; 
hatch(300,1:30)=1;
%hatch(10,:)=1;
hatch(1:60:end,:)=1;
% hatch(29,:)=1; hatch(150,:)=1; hatch(90,70:90)=1;
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

print(gcf,'../PNGs/HalostericSSH_ssp126_demeaned_title.png','-dpng','-r100', '-painters');
% title('')
% colorbar off
% print(gcf,'../PNGs/HalostericSSH_ssp126_demeaned.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/HalostericSSH_ssp126_demeaned_hatchcheck.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-12f_data.nc';
var_name = 'HalostericSeaLevel';
var_units = 'm';
title = "Halosteric Relative Sea Level Change for SSP1-2.6 between 1984-2015"+ ...
    " and 2081-2100 from a CMIP6 ensemble";
comments = "Data is for panel (f) of Figure 9.12 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude, longitude, title, comments, hatching_mask')

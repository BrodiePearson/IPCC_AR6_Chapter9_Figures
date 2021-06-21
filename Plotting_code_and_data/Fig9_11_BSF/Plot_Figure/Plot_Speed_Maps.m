%% IPCC AR6 Chapter 9: Figure 9.11 (Surface speed maps)
%
% Code used to plot pre-processed surface speed maps. 
%
% Plotting code written by Brodie Pearson
% CMIP processed data provided by Yongqiang Yu & Lijuan Hua 

clear all

addpath ../../../Functions/
fontsize=20;

color_bar = IPCC_Get_Colorbar('temperature_nd', 21, true);
change_color_bar = IPCC_Get_Colorbar('temperature_d', 21, true);
lims = [0 0.5];
change_lims = [-1 1]*0.1;


%% Load model speeds

prefix = 'sqrt_uv_';
suffix = '.nc';
count_ssp585 = 0;
count_hist = 0;

% Define 1 x 1 degree grid for interpolation of different model data maps
lon = -179.5:179.5;
lat = -90:90;
[grid_lat, grid_lon] = meshgrid(lat,lon);

data_path = './Processed_Data/speed/historical/extract/'; %data_path = './ssp126_modelbymodel';
datadir=dir(data_path);
filenames = {datadir.name}; % Load filenames in path
for ii=1:size(filenames,2)
   if contains(filenames{1,ii},'sqrt_uv')
       count_hist = count_hist + 1;
       model_names_hist(count_hist) = ...
           {strtok(erase(filenames{1,ii},prefix),suffix)};
       tmp_speed = ncread(char(data_path+"/"+filenames(ii)),'uo');
       try
           var = 'latitude';
           tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
       catch
           try
               var = 'lat';
               tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
           catch
              try
                   var = 'nav_lat';
                   tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
               catch
                   warning('No latitude values found')
               end
           end
       end
       try
           var = 'longitude';
           tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
       catch
           try
               var = 'lon';
               tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
           catch
               try
                   var = 'nav_lon';
                   tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
               catch
                   warning('No longitude values found')
               end
           end
       end
       tmp_lon = wrapTo180(tmp_lon);
       tmp_speed_gridded = griddata(tmp_lat,tmp_lon,tmp_speed,grid_lat,grid_lon);
       speed_hist(:,:,count_hist) = tmp_speed_gridded;
       tmp_lon(tmp_lon>179) = tmp_lon(tmp_lon>179)-360;
       tmp_speed_gridded = griddata(tmp_lat,tmp_lon,tmp_speed,grid_lat,grid_lon);
       speed_hist(1,:,count_hist) = tmp_speed_gridded(1,:);
       tmp_lon(tmp_lon<-179) = tmp_lon(tmp_lon<-179)+360;
       tmp_speed_gridded = griddata(tmp_lat,tmp_lon,tmp_speed,grid_lat,grid_lon);
       speed_hist(end,:,count_hist) = tmp_speed_gridded(end,:);
   end
end

data_path = './Processed_Data/speed/ssp585/extract/'; %data_path = './ssp126_modelbymodel';
datadir=dir(data_path);
filenames = {datadir.name}; % Load filenames in path
for ii=1:size(filenames,2)
    if contains(filenames{1,ii},'sqrt_uv')
        count_ssp585 = count_ssp585 + 1;
        model_names_ssp585(count_ssp585) = ...
            {strtok(erase(filenames{1,ii},prefix),suffix)};
        tmp_speed = ncread(char(data_path+"/"+filenames(ii)),'uo');
        try
            var = 'latitude';
            tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
        catch
            try
                var = 'lat';
                tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
            catch
                try
                    var = 'nav_lat';
                    tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
                catch
                    warning('No latitude values found')
                end
            end
        end
        try
            var = 'longitude';
            tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
        catch
            try
                var = 'lon';
                tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
            catch
                try
                    var = 'nav_lon';
                    tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
                catch
                    warning('No longitude values found')
                end
            end
        end
        tmp_lon = wrapTo180(tmp_lon);
        tmp_speed_gridded = griddata(tmp_lat,tmp_lon,tmp_speed,grid_lat,grid_lon);
        speed_ssp585(:,:,count_ssp585) = tmp_speed_gridded;
        tmp_lon(tmp_lon>179) = tmp_lon(tmp_lon>179)-360;
        tmp_speed_gridded = griddata(tmp_lat,tmp_lon,tmp_speed,grid_lat,grid_lon);
        speed_ssp585(1,:,count_ssp585) = tmp_speed_gridded(1,:);
        tmp_lon(tmp_lon<-179) = tmp_lon(tmp_lon<-179)+360;
        tmp_speed_gridded = griddata(tmp_lat,tmp_lon,tmp_speed,grid_lat,grid_lon);
        speed_ssp585(end,:,count_ssp585) = tmp_speed_gridded(end,:);
    end
end


%% Plot validation maps


figure('Position', [10 10 1200 1200])
for ii=1:size(speed_hist,3)
   subplot(ceil(sqrt(size(speed_hist,3))), ...
        ceil(sqrt(size(speed_hist,3))), ii);
    imagesc(lon,lat,fliplr(speed_hist(:,:,ii))');
    colormap(color_bar)
    title(model_names_hist{ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/Speed_historical_Maps.png','-dpng','-r100', '-painters');
close(1)


%% Plot historical speeds

speed_hist_wrapped = [speed_hist; speed_hist(1,:,:)];
latitude = lat';
longitude = [lon'; lon(1)];

plot_var1 = nanmean(speed_hist_wrapped,3);


IPCC_Plot_Map(plot_var1',latitude,longitude,lims, ...
    color_bar,"CMIP_{"+num2str(count_hist)+" models} Speed",...
    1,fontsize, true, '(m s^{-1})')


print(gcf,'../PNGs/Speed_historical_title.png','-dpng','-r1000', '-painters');
% title('')
% print(gcf,'./PNGs/Speed_historical_colorbar.png','-dpng','-r1000', '-painters');
% colorbar off
% print(gcf,'./PNGs/Speed_historical.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-11d_data.nc';
var_name = 'surface_speed';
var_units = 'meters per second';
title = "Ocean Surface Speed climatology for 1995-2014 using CMIP6 (CMIP)";
comments = "Data is for panel (d) of Figure 9.11 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude, longitude, title, comments)
clear title


%% Plot SSP585 change in speeds (first validation maps)

speed_ssp585_wrapped = [speed_ssp585; speed_ssp585(1,:,:)];

speed_change_models = speed_ssp585_wrapped-speed_hist_wrapped;

speed_change = nanmean(speed_change_models,3);

figure('Position', [10 10 1200 1200])
for ii=1:size(speed_change_models,3)
   subplot(ceil(sqrt(size(speed_change_models,3))), ...
        ceil(sqrt(size(speed_change_models,3))), ii);
    imagesc(lon,lat,fliplr(speed_change_models(:,:,ii))');
    colormap(change_color_bar)
    title(model_names_ssp585{ii})
    colorbar
    caxis(change_lims)
end
print(gcf,'../PNGs/Test_Maps/Speed_Change_Maps.png','-dpng','-r100', '-painters');
close(1)


%% Now plot change maps for figure

IPCC_Plot_Map(speed_change',latitude,longitude,change_lims, ...
    change_color_bar,"SSP5-8.5_{"+num2str(count_ssp585)+" models} Speed Change",...
    1,fontsize, true,'(m s^{-1})')

hatch = abs(sum(sign(speed_change_models),3))/size(speed_change_models,3)';
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1;
hatch(29,:)=1; hatch(150,:)=1; hatch(90,70:90)=1;
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

print(gcf,'../PNGs/Speed_ssp585_title.png','-dpng','-r1000', '-painters');
% title('')
% print(gcf,'./PNGs/Speed_ssp585_colorbar.png','-dpng','-r1000', '-painters');
% colorbar off
% print(gcf,'./PNGs/Speed_ssp585.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/Speed_ssp585_hatchcheck.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-11e_data.nc';
var_name = 'surface_speed_change';
var_units = 'meters per second';
title = "Change in Ocean Surface Speed between 1995 and 2100 under SSP5-8.5 using CMIP6 (CMIP & ScenarioMIP)";
comments = "Data is for panel (e) of Figure 9.11 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, speed_change', ...
    latitude, longitude, title, comments,hatching_mask')




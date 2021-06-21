%% IPCC AR6 Chapter 9: Figure 9.11 (Barotropic Streamfunction maps)
%
% Code used to plot pre-processed barotropic streamfunction maps. 
%
% Plotting code written by Brodie Pearson
% CMIP processed data provided by Yongqiang Yu & Lijuan Hua 

clear all

addpath ../../../Functions/
fontsize=20;

color_bar = IPCC_Get_Colorbar('precip_d', 21, true);
change_color_bar = IPCC_Get_Colorbar('temperature_d', 21, true);
lims = [-200 200];
change_lims = [-20 20];

%% Load model BSFs

prefix = 'regrid_monmean_';
suffix = '.nc';
count_ssp585 = 0;
count_hist = 0;

% Define 1 x 1 degree grid for interpolation of different model data maps
lon = -179.5:179.5;
lat = -90:90;
[grid_lat, grid_lon] = meshgrid(lat,lon);

data_path = './Processed_Data/msftbarot/historical/regrid1x1/'; %data_path = './ssp126_modelbymodel';
data_path_hist=data_path;
datadir=dir(data_path);
filenames = {datadir.name}; % Load filenames in path
figure('Position', [10 10 1200 1200])
for ii=1:size(filenames,2)
   if contains(filenames{1,ii},'regrid_monmean_')
       count_hist = count_hist + 1;
       model_names_hist(count_hist) = ...
           {strtok(erase(filenames{1,ii},prefix),suffix)};
       tmp_BSF = ncread(char(data_path+"/"+filenames(ii)),'msftbarot');
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
       tmp_BSF_gridded = griddata(tmp_lat,tmp_lon,tmp_BSF,grid_lat,grid_lon);
       BSF_hist(:,:,count_hist) = tmp_BSF_gridded;
       tmp_lon(tmp_lon>179) = tmp_lon(tmp_lon>179)-360;
       tmp_BSF_gridded = griddata(tmp_lat,tmp_lon,tmp_BSF,grid_lat,grid_lon);
       BSF_hist(1,:,count_hist) = tmp_BSF_gridded(1,:);
       tmp_lon(tmp_lon<-179) = tmp_lon(tmp_lon<-179)+360;
       tmp_BSF_gridded = griddata(tmp_lat,tmp_lon,tmp_BSF,grid_lat,grid_lon);
       BSF_hist(end,:,count_hist) = tmp_BSF_gridded(end,:);
       subplot(ceil(sqrt(size(filenames,2))), ...
           ceil(sqrt(size(filenames,2))), ii);
       imagesc(tmp_lon,tmp_lat,fliplr(tmp_BSF)'/1e9);
       colormap(color_bar)
       title({strtok(erase(filenames{1,ii},prefix),suffix)})
       colorbar
       caxis(change_lims)
   end
end

print(gcf,'../PNGs/Test_Maps/BSF_historical_Maps_naturalgrid.png','-dpng','-r100', '-painters');
close(1)


data_path = './Processed_Data/msftbarot/ssp585/regrid1x1/'; %data_path = './ssp126_modelbymodel';
datadir=dir(data_path);
filenames = {datadir.name}; % Load filenames in path
for ii=1:size(filenames,2)
    if contains(filenames{1,ii},'regrid_monmean_')
        count_ssp585 = count_ssp585 + 1;
        model_names_ssp585(count_ssp585) = ...
            {strtok(erase(filenames{1,ii},prefix),suffix)};
        tmp_BSF = ncread(char(data_path+"/"+filenames(ii)),'msftbarot');
        tmp_BSF_histforssp585 = ncread(char(data_path_hist+"/"+filenames(ii)),'msftbarot');
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
        tmp_BSF_gridded = griddata(tmp_lat,tmp_lon,tmp_BSF,grid_lat,grid_lon);
        tmp_BSF_hist_gridded = griddata(tmp_lat,tmp_lon,tmp_BSF_histforssp585,grid_lat,grid_lon);
        BSF_ssp585(:,:,count_ssp585) = tmp_BSF_gridded;
        BSF_histforssp585(:,:,count_ssp585) = tmp_BSF_hist_gridded;
        tmp_lon(tmp_lon>179) = tmp_lon(tmp_lon>179)-360;
        tmp_BSF_gridded = griddata(tmp_lat,tmp_lon,tmp_BSF,grid_lat,grid_lon);
        tmp_BSF_hist_gridded = griddata(tmp_lat,tmp_lon,tmp_BSF_histforssp585,grid_lat,grid_lon);
        BSF_histforssp585(1,:,count_ssp585) = tmp_BSF_hist_gridded(1,:);
        BSF_ssp585(1,:,count_ssp585) = tmp_BSF_gridded(1,:);
        tmp_lon(tmp_lon<-179) = tmp_lon(tmp_lon<-179)+360;
        tmp_BSF_gridded = griddata(tmp_lat,tmp_lon,tmp_BSF,grid_lat,grid_lon);
        tmp_BSF_hist_gridded = griddata(tmp_lat,tmp_lon,tmp_BSF_histforssp585,grid_lat,grid_lon);
        BSF_ssp585(end,:,count_ssp585) = tmp_BSF_gridded(end,:);
        BSF_histforssp585(end,:,count_ssp585) = tmp_BSF_hist_gridded(end,:);
    end
end


%% Plot validation maps


figure('Position', [10 10 1200 1200])
for ii=1:size(BSF_hist,3)
   subplot(ceil(sqrt(size(BSF_hist,3))), ...
        ceil(sqrt(size(BSF_hist,3))), ii);
    imagesc(lon,lat,fliplr(BSF_hist(:,:,ii))'/1e9);
    colormap(color_bar)
    title(model_names_hist{ii})
    colorbar
    caxis(lims)
end
print(gcf,'../PNGs/Test_Maps/BSF_historical_Maps.png','-dpng','-r100', '-painters');
close(1)


%% Plot historical BSFs

BSF_hist_wrapped = [BSF_hist; BSF_hist(1,:,:)]/1e9;
latitude = lat';
longitude = [lon'; lon(1)];

plot_var1 = nanmean(BSF_hist_wrapped,3);


IPCC_Plot_Map(plot_var1',latitude,longitude,lims, ...
    color_bar,"CMIP_{"+num2str(count_hist)+" models} BSF [10^9 kg s^{-1}]",...
    1,fontsize, true, '(10^9 kg s^{-1})')


print(gcf,'../PNGs/BSF_historical_title.png','-dpng','-r1000', '-painters');
% title('')
% print(gcf,'./PNGs/BSF_historical_colorbar.png','-dpng','-r1000', '-painters');
% colorbar off
% print(gcf,'./PNGs/BSF_historical.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-11a_data.nc';
var_name = 'msftbarot';
var_units = '10^9 kilograms per second';
title = "Ocean Barotropic Streamfunction climatology for 1995-2014 using CMIP6 (CMIP)";
comments = "Data is for panel (a) of Figure 9.11 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var1', ...
    latitude, longitude, title, comments)
clear title

%% Plot SSP585 change in BSFs (first validation maps)

BSF_change_models = BSF_ssp585-BSF_histforssp585;

BSF_change_models_wrapped = [BSF_change_models; BSF_change_models(1,:,:)]/1e9;

BSF_change = nanmean(BSF_change_models_wrapped,3);

figure('Position', [10 10 1200 1200])
for ii=1:size(BSF_change_models_wrapped,3)
   subplot(ceil(sqrt(size(BSF_change_models_wrapped,3))), ...
        ceil(sqrt(size(BSF_change_models_wrapped,3))), ii);
    imagesc(lon,lat,fliplr(BSF_change_models_wrapped(:,:,ii))');
    colormap(change_color_bar)
    title(model_names_ssp585{ii})
    colorbar
    caxis(change_lims)
end
print(gcf,'../PNGs/Test_Maps/BSF_Change_Maps.png','-dpng','-r100', '-painters');
close(1)


%% Now plot change maps for figure

IPCC_Plot_Map(BSF_change',latitude,longitude,change_lims, ...
    change_color_bar,"SSP5-8.5_{"+num2str(count_ssp585)+" models} BSF Change [10^9 kg s^{-1}]",...
    1,fontsize, true,'(10^9 kg s^{-1})')

hatch = abs(sum(sign(BSF_change_models_wrapped),3))/size(BSF_change_models_wrapped,3)';
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hatch(1:60:end,:)=1; hatch(150,:)=1;
%hatch(29,:)=1; hatch(150,:)=1; hatch(90,70:90)=1;
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

print(gcf,'../PNGs/BSF_ssp585_title.png','-dpng','-r1000', '-painters');
% title('')
% print(gcf,'./PNGs/BSF_ssp585_colorbar.png','-dpng','-r1000', '-painters');
% colorbar off
% print(gcf,'./PNGs/BSF_ssp585.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/BSF_ssp585_hatchcheck.png','-dpng','-r100', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-11b_data.nc';
var_name = 'msftbarot_change';
var_units = '10^9 kilograms per second';
title = "Change in Barotropic Streamfunction between 1995 and 2100 under SSP5-8.5 using CMIP6 (CMIP & ScenarioMIP)";
comments = "Data is for panel (b) of Figure 9.11 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, BSF_change', ...
    latitude, longitude, title, comments,hatching_mask')




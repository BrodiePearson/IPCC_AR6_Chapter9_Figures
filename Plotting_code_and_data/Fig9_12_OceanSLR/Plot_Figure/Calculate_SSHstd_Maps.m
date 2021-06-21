%% IPCC AR6 Chapter 9: Figure 9.12 (Sea Level Rise)
%
% Code used to calculate standard deviation of sea surface heitght
% from pre-processed data. 
%
% Calculation code written by Brodie Pearson
% CMIP processed data provided by Yongqiang Yu & Lijuan Hua 

clear all

addpath ../../../Functions/
fontsize = 20;

%% Load observed SSH std

SSH_std_OBS = ncread('./Processed_Data/obs/std_obs.nc','sla');
lat_obs = ncread('./Processed_Data/obs/std_obs.nc','lat');
lon_obs = ncread('./Processed_Data/obs/std_obs.nc','lon');

%% Load model dynamic SSH fields

% Loop over the 6 different sets of models required
% kk= 1 (SSP585 steric), 2 (SSP585 thermosteric), 3 (SSP585 halosteric),
% 4 (SSP126 steric), 5 (SSP126 thermosteric), 6 (SSP126 halosteric),
% 7 (OMIP low-res SSH std), 8 (OMIP low-res SSH std)

data_paths = {'./Processed_Data/omip_highres/extract/', './Processed_Data/omip_lowres/extract/'};

prefixes = {'std_','std_'};
suffixes = {'.nc', '.nc'};


for kk=1:size(data_paths,2)
    
    prefix = prefixes{kk};
    suffix = suffixes{kk};
    data_path = data_paths{kk};
    
    model_count{kk} = 0;
    
    % Define 1 x 1 degree grid for interpolation of different model data maps
    lon = -179.5:179.5;
    lat = -90:90;
    [grid_lat, grid_lon] = meshgrid(lat,lon);
    
    datadir=dir(data_path);
    filenames = {datadir.name}; % Load filenames in path
    for ii=1:size(filenames,2)
        if contains(filenames{1,ii},suffix)
            model_count{kk} = model_count{kk} + 1;
            model_names(kk,model_count{kk}) = ...
                {erase(erase(filenames{1,ii},prefix),suffix)};
            if kk==2 && (contains(filenames{ii},'CESM2') || ...
                    contains(filenames{ii},'FGOALS-f3-L'))
                tmp_SSH = ncread(char(data_path+"/"+filenames(ii)),'zos');
            else
                tmp_SSH = ncread(char(data_path+"/"+filenames(ii)),'ssh');
            end
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
                        try
                            var = 'LATITUDE';
                            tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
                        catch
                            try
                                var = 'LAT';
                                tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
                            catch
                                try
                                    var = 'NAV_LAT';
                                    tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
                                catch
                                    try
                                        var = 'Latitude';
                                        tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
                                    catch
                                        try
                                            var = 'TLAT';
                                            tmp_lat = double(ncread(char(data_path+"/"+filenames(ii)),var));
                                        catch
                                            warning('No latitude values found')
                                        end
                                    end
                                end
                            end
                        end
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
                        try
                            var = 'LONGITUDE';
                            tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
                        catch
                            try
                                var = 'LON';
                                tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
                            catch
                                try
                                    var = 'NAV_LON';
                                    tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
                                catch
                                    try
                                        var = 'Longitude';
                                        tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
                                    catch
                                        try
                                            var = 'TLONG';
                                            tmp_lon = double(ncread(char(data_path+"/"+filenames(ii)),var));
                                        catch
                                            warning('No longitude values found')
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            tmp_lon = wrapTo180(tmp_lon);
            % regrid
            tmp_SSH(isnan(tmp_SSH))=0; tmp_lat(isnan(tmp_lat))=0; tmp_lon(isnan(tmp_lon))=0;
            if contains(filenames{1,ii},'NCAR')
                for ll=1:360
                    for mm=1:181
                        tmp_SSH_gridded(ll,mm) = nanmean((tmp_SSH(abs(tmp_lat-grid_lat(ll,mm))<=0.5 ...
                            & abs(tmp_lon-grid_lon(ll,mm))<=0.5)))/100; 
                        % convert units from cm to m (only NCAR high-res
                        % model)
                    end
                end
            else
                tmp_SSH_gridded = griddata(tmp_lat,tmp_lon,tmp_SSH,grid_lat,grid_lon);
            end
            if kk==1
                omip_highres(:,:,model_count{kk}) = tmp_SSH_gridded;
            elseif kk==2
                omip_lowres(:,:,model_count{kk}) = tmp_SSH_gridded;
            end
            tmp_lon(tmp_lon>179) = tmp_lon(tmp_lon>179)-360;
            if kk==1
                omip_highres(1,:,model_count{kk}) = tmp_SSH_gridded(1,:);
            elseif kk==2
                omip_lowres(1,:,model_count{kk}) = tmp_SSH_gridded(1,:);
            end
            tmp_lon(tmp_lon<-179) = tmp_lon(tmp_lon<-179)+360;
            if kk==1
                omip_highres(end,:,model_count{kk}) = tmp_SSH_gridded(end,:);
            elseif kk==2
                omip_lowres(end,:,model_count{kk}) = tmp_SSH_gridded(end,:);
            end
        end
    end
    
end

save('./Processed_Data/SSH_std_Maps.mat', ...
    'omip_lowres','omip_highres', 'SSH_std_OBS','lat_obs', ...
    'lon_obs', 'lat','lon' ,'model_names','model_count')


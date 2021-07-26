%% IPCC AR6 Chapter 9: Chapter 4 collaboration (Temperature Transects)
%
% Code used to calculate temperature transects used in Chapter 4
%
% Calculation code written by Brodie Pearson

clear all

addpath ../../../Functions/
fontsize = 15;
experiments = {'observations','historical','ssp126','ssp370','ssp585'};

% Historical period is for calculating projected rates of change,
% second histroical period is for comparison with observational period
data_path = '/Volumes/PromiseDisk/AR6_Data/thetao_with_chapter_4/';

start_year = {'','2005','2081','2081','2081'};
end_year = {'','2014','2100','2100','2100'};
start_year_historicalvsssp = '1995';
end_year_historicalvsssp = '2014';

mask_lim=0.6; % Limit for masks, 0.6 if 80% of models agree, 0.8 if 90%


% Find out which models are available for each experiment (models for first
% historical and the SSPs should be the same)
for ii=2:size(experiments,2)
    if ii==2
       data_path_old = data_path;
       data_path='/Volumes/PromiseDisk/AR6_Data/thetao/'
       models{ii} = IPCC_Which_Models(data_path,experiments(ii),'CMIP6_','_');
       data_path=data_path_old;
    else
       models{ii} = IPCC_Which_Models(data_path,experiments(ii),'CMIP6_','_'); 
    end
end

%% Create transect template (fixed size)
%  for interpolation of different data onto a common grid

depths = 0:10:6000;
latitudes = -89.5:1:89.5;
latitudes_upper_bounds = -89:1:90;
latitudes_lower_bounds = -90:1:89;

transect_grid = nan(size(latitudes,2),size(depths,2));

%% Load CMIP6 data and calculate zonal mean transect

% Get historical temperature fields
for ii=1:size(experiments,2)%
    if ii==2
       data_path='/Volumes/PromiseDisk/AR6_Data/thetao/'
    end
    if contains(experiments(ii),'observations')
        jj=1;
        T_o_anom=ncread(data_path + ...
            "observations/RG_ArgoClim_Temperature_2017.nc",'ARGO_TEMPERATURE_ANOMALY');
        T_o_mean=ncread(data_path + ...
            "observations/RG_ArgoClim_Temperature_2017.nc",'ARGO_TEMPERATURE_MEAN');
        P_o=ncread(data_path + ...
            "observations/RG_ArgoClim_Temperature_2017.nc",'PRESSURE');
        LAT=ncread( data_path + ...
            "observations/RG_ArgoClim_Temperature_2017.nc",'LATITUDE');
        LON=ncread( data_path + ...
            "observations/RG_ArgoClim_Temperature_2017.nc",'LONGITUDE');
        % Convert observed longitude (spanning ~20-380) into [-180 180 interval]
        LON(LON>180) = LON(LON>180)-360;
        
        % Extract 2005-2014 from ARGO observations and de-anomalize
        T_o = nanmean(T_o_anom(:,:,:,13:132),4);
        theta = T_o + T_o_mean;
        clear T_o_mean T_o_anom
        models{ii}=nan(1,1);
    else
        models{ii} = IPCC_Which_Models(data_path,experiments(ii),'CMIP6_','_');
        
        % Remove isopycnal models (since transects are not comparable to z-models
         models{ii}(contains(models{ii},'NorESM2-LM')) = [];
         models{ii}(contains(models{ii},'NorESM2-MM')) = [];
        if contains(experiments(ii),'ssp') % Only runs to 2099
            % This one is a different ensemble member in ssp vs. historical
            models{ii}(contains(models{ii},'CNRM-ESM2-1')) = [];
        end
    end
    
    for jj = 1:size(models{ii},2)
        if ~contains(experiments(ii),'observations')
            [theta, LAT, LON] = IPCC_CMIP6_Load(experiments(ii), ...
                {'thetao'}, models{ii}(jj), data_path,start_year(ii),end_year(ii));
            if contains(experiments(ii),'ssp')
                [theta_ref, LAT, LON] = IPCC_CMIP6_Load({'historical'}, ...
                    {'thetao'}, models{ii}(jj), data_path, ...
                    {start_year_historicalvsssp},{end_year_historicalvsssp});
            end
        end
        
        if size(LAT,2)==1
            [LAT, LON] = meshgrid(LAT,LON);
        end
        
        [Atlantic_Mask, Pacific_Mask, Indian_Mask] = IPCC_Basin_Mask(LAT, LON);
        if contains(experiments(ii),'observations')
            for yy=1:size(latitudes,2)
                for k=1:size(P_o)
                    levels(yy,k) = Depth(P_o(k),latitudes(yy));
                end
            end
        else
            levels = IPCC_CMIP6_Load_Levels(experiments(ii), ...
                {'thetao'}, models{ii}(jj), data_path,start_year(ii),end_year(ii));
            levels=levels{1};
            % All CESM2 models (except CESM2-FV2) have depth in cm - convert to m
            if contains(models{ii}(jj),'CESM2') && ...
                    ~contains(models{ii}(jj),'CESM2-FV2')
                levels = levels/100;
            end
        end
        
        theta_Atlantic = Atlantic_Mask.*theta;
        theta_Pacific = Pacific_Mask.*theta;
        theta_Indian = Indian_Mask.*theta;
        if contains(experiments(ii),'ssp')
            theta_Atlantic_ref = Atlantic_Mask.*theta_ref;
            theta_Pacific_ref = Pacific_Mask.*theta_ref;
            theta_Indian_ref = Indian_Mask.*theta_ref;
        end
        %
        for kk = 1:size(theta_Indian,3)
            for ll = 1:size(transect_grid,1)
                Atl = theta_Atlantic(:,:,kk);
                Pac = theta_Pacific(:,:,kk);
                Ind = theta_Indian(:,:,kk);
                Global = theta(:,:,kk);
                theta_Atlantic_transect(ll,kk) = nanmean(Atl( ...
                    LAT >= latitudes_lower_bounds(ll) & ...
                    LAT < latitudes_upper_bounds(ll)));
                theta_Pacific_transect(ll,kk) = nanmean(Pac( ...
                    LAT >= latitudes_lower_bounds(ll) & ...
                    LAT < latitudes_upper_bounds(ll)));
                theta_Indian_transect(ll,kk) = nanmean(Ind( ...
                    LAT >= latitudes_lower_bounds(ll) & ...
                    LAT < latitudes_upper_bounds(ll)));
                theta_Global_transect(ll,kk) = nanmean(Global( ...
                    LAT >= latitudes_lower_bounds(ll) & ...
                    LAT < latitudes_upper_bounds(ll)));
                if contains(experiments(ii),'ssp')
                    Atl_ref = theta_Atlantic_ref(:,:,kk);
                    Pac_ref = theta_Pacific_ref(:,:,kk);
                    Ind_ref = theta_Indian_ref(:,:,kk);
                    Global_ref = theta_ref(:,:,kk);
                    theta_Atlantic_transect_ref(ll,kk) = nanmean(Atl_ref( ...
                        LAT >= latitudes_lower_bounds(ll) & ...
                        LAT < latitudes_upper_bounds(ll)));
                    theta_Pacific_transect_ref(ll,kk) = nanmean(Pac_ref( ...
                        LAT >= latitudes_lower_bounds(ll) & ...
                        LAT < latitudes_upper_bounds(ll)));
                    theta_Indian_transect_ref(ll,kk) = nanmean(Ind_ref( ...
                        LAT >= latitudes_lower_bounds(ll) & ...
                        LAT < latitudes_upper_bounds(ll)));
                    theta_Global_transect_ref(ll,kk) = nanmean(Global_ref( ...
                        LAT >= latitudes_lower_bounds(ll) & ...
                        LAT < latitudes_upper_bounds(ll)));
                end
            end
        end
        
        for ll = 1:size(transect_grid,1)
            if contains(experiments(ii),'observations')
                Atlantic_transect{ii}(ll,:,jj) = ...
                    interp1(squeeze(levels(ll,:)),squeeze(theta_Atlantic_transect(ll,:)),depths);
                Pacific_transect{ii}(ll,:,jj) = ...
                    interp1(squeeze(levels(ll,:)),squeeze(theta_Pacific_transect(ll,:)),depths);
                Indian_transect{ii}(ll,:,jj) = ...
                    interp1(squeeze(levels(ll,:)),squeeze(theta_Indian_transect(ll,:)),depths);
                Global_transect{ii}(ll,:,jj) = ...
                    interp1(squeeze(levels(ll,:)),squeeze(theta_Global_transect(ll,:)),depths);
            else
                Atlantic_transect{ii}(ll,:,jj) = ...
                    interp1(levels,squeeze(theta_Atlantic_transect(ll,:)),depths);
                Pacific_transect{ii}(ll,:,jj) = ...
                    interp1(levels,squeeze(theta_Pacific_transect(ll,:)),depths);
                Indian_transect{ii}(ll,:,jj) = ...
                    interp1(levels,squeeze(theta_Indian_transect(ll,:)),depths);
                Global_transect{ii}(ll,:,jj) = ...
                    interp1(levels,squeeze(theta_Global_transect(ll,:)),depths);
                if contains(experiments(ii),'ssp')
                    Atlantic_transect_ref{ii}(ll,:,jj) = ...
                        interp1(levels,squeeze(theta_Atlantic_transect_ref(ll,:)),depths);
                    Pacific_transect_ref{ii}(ll,:,jj) = ...
                        interp1(levels,squeeze(theta_Pacific_transect_ref(ll,:)),depths);
                    Indian_transect_ref{ii}(ll,:,jj) = ...
                        interp1(levels,squeeze(theta_Indian_transect_ref(ll,:)),depths);
                    Global_transect_ref{ii}(ll,:,jj) = ...
                        interp1(levels,squeeze(theta_Global_transect_ref(ll,:)),depths);
                end
            end
        end
        clear theta_Global_transect theta_Indian_transect theta_Pacific_transect
        clear theta_Atlantic_transect
        clear theta_Global_transect_ref theta_Indian_transect_ref theta_Pacific_transect_ref
        clear theta_Atlantic_transect_ref
    end
    if ii==2
       data_path='/Volumes/PromiseDisk/AR6_Data/thetao_with_chapter_4/';
    end
end


%% Save data in more usable format

for ii=1:size(experiments,2)
    if contains(experiments(ii),'observations')
        Global_observations = Global_transect{ii};
        Pacific_observations = Pacific_transect{ii};
        Atlantic_observations = Atlantic_transect{ii};
        Indian_observations = Indian_transect{ii};
        start_year_observations = start_year{ii};
        end_year_observations = end_year{ii};
        
    elseif contains(experiments(ii),'ssp')
       Global_hist = Global_transect_ref{ii}; 
       Global_ssp = Global_transect{ii};
       Global_diff = Global_ssp - Global_hist;
       Global_mask = abs(sum(sign(Global_diff),3))/size(Global_diff,3);
       Global_mask(abs(Global_mask)>mask_lim) = 1;
       Global_mask(abs(Global_mask)<mask_lim) = 0;
       Global_mask(isnan(Global_mask)) = 0;
       
       Atlantic_hist = Atlantic_transect_ref{ii}; 
       Atlantic_ssp = Atlantic_transect{ii};
       Atlantic_diff = Atlantic_ssp - Atlantic_hist;
       Atlantic_mask = abs(sum(sign(Atlantic_diff),3))/size(Atlantic_diff,3);
       Atlantic_mask(abs(Atlantic_mask)>mask_lim) = 1;
       Atlantic_mask(abs(Atlantic_mask)<mask_lim) = 0;
       Atlantic_mask(isnan(Atlantic_mask)) = 0;
       
       Pacific_hist = Pacific_transect_ref{ii}; 
       Pacific_ssp = Pacific_transect{ii};
       Pacific_diff = Pacific_ssp - Pacific_hist;
       Pacific_mask = abs(sum(sign(Pacific_diff),3))/size(Pacific_diff,3);
       Pacific_mask(abs(Pacific_mask)>mask_lim) = 1;
       Pacific_mask(abs(Pacific_mask)<mask_lim) = 0;
       Pacific_mask(isnan(Pacific_mask)) = 0;
       
       Indian_hist = Indian_transect_ref{ii}; 
       Indian_ssp = Indian_transect{ii};
       Indian_diff = Indian_ssp - Indian_hist;
       Indian_mask = abs(sum(sign(Indian_diff),3))/size(Indian_diff,3);
       Indian_mask(abs(Indian_mask)>mask_lim) = 1;
       Indian_mask(abs(Indian_mask)<mask_lim) = 0;
       Indian_mask(isnan(Indian_mask)) = 0;
       
       if contains(experiments(ii),'ssp126')
           Global_mean_hist_for_ssp126 = nanmean(Global_hist,3);
           Global_mean_ssp126 = nanmean(Global_ssp,3);
           Global_mask_ssp126 = Global_mask;
           
           Pacific_mean_hist_for_ssp126 = nanmean(Pacific_hist,3);
           Pacific_mean_ssp126 = nanmean(Pacific_ssp,3);
           Pacific_mask_ssp126 = Pacific_mask;
           
           Atlantic_mean_hist_for_ssp126 = nanmean(Atlantic_hist,3);
           Atlantic_mean_ssp126 = nanmean(Atlantic_ssp,3);
           Atlantic_mask_ssp126 = Atlantic_mask;
           
           Indian_mean_hist_for_ssp126 = nanmean(Indian_hist,3);
           Indian_mean_ssp126 = nanmean(Indian_ssp,3);
           Indian_mask_ssp126 = Indian_mask;
           models_ssp126 = models{ii};
           
           start_year_ssp = start_year{ii};
           end_year_ssp = end_year{ii};
           
       elseif contains(experiments(ii),'ssp370')
           Global_mean_hist_for_ssp370 = nanmean(Global_hist,3);
           Global_mean_ssp370 = nanmean(Global_ssp,3);
           Global_mask_ssp370 = Global_mask;
           
           Pacific_mean_hist_for_ssp370 = nanmean(Pacific_hist,3);
           Pacific_mean_ssp370 = nanmean(Pacific_ssp,3);
           Pacific_mask_ssp370 = Pacific_mask;
           
           Atlantic_mean_hist_for_ssp370 = nanmean(Atlantic_hist,3);
           Atlantic_mean_ssp370 = nanmean(Atlantic_ssp,3);
           Atlantic_mask_ssp370 = Atlantic_mask;
           
           Indian_mean_hist_for_ssp370 = nanmean(Indian_hist,3);
           Indian_mean_ssp370 = nanmean(Indian_ssp,3);
           Indian_mask_ssp370 = Indian_mask;
           models_ssp370 = models{ii};
           
       elseif contains(experiments(ii),'ssp585')
           Global_mean_hist_for_ssp585 = nanmean(Global_hist,3);
           Global_mean_ssp585 = nanmean(Global_ssp,3);
           Global_mask_ssp585 = Global_mask;
           
           Pacific_mean_hist_for_ssp585 = nanmean(Pacific_hist,3);
           Pacific_mean_ssp585 = nanmean(Pacific_ssp,3);
           Pacific_mask_ssp585 = Pacific_mask;
           
           Atlantic_mean_hist_for_ssp585 = nanmean(Atlantic_hist,3);
           Atlantic_mean_ssp585 = nanmean(Atlantic_ssp,3);
           Atlantic_mask_ssp585 = Atlantic_mask;
           
           Indian_mean_hist_for_ssp585 = nanmean(Indian_hist,3);
           Indian_mean_ssp585 = nanmean(Indian_ssp,3);
           Indian_mask_ssp585 = Indian_mask;
           models_ssp585 = models{ii};
           model_names_sspvshistorical = models{ii};
       end
    elseif contains(experiments(ii),'hist')
        start_year_historicalvsobs = start_year{ii};
        end_year_historicalvsobs = end_year{ii};
        start_year_historicalvsobs = start_year{ii};
        model_names_obsvshistorical = models{ii};
        
        Global_bias = Global_transect{ii} - Global_observations; 
        Global_bias_mean = nanmean(Global_bias,3);
        Global_bias_mask = abs(sum(sign(Global_bias),3))/size(Global_bias,3);
        Global_bias_mask(abs(Global_bias_mask)>mask_lim) = 1;
        Global_bias_mask(abs(Global_bias_mask)<mask_lim) = 0;
        Global_bias_mask(isnan(Global_bias_mask)) = 0;
        
        Pacific_bias = Pacific_transect{ii} - Pacific_observations; 
        Pacific_bias_mean = nanmean(Pacific_bias,3);
        Pacific_bias_mask = abs(sum(sign(Pacific_bias),3))/size(Pacific_bias,3);
        Pacific_bias_mask(abs(Pacific_bias_mask)>mask_lim) = 1;
        Pacific_bias_mask(abs(Pacific_bias_mask)<mask_lim) = 0;
        Pacific_bias_mask(isnan(Pacific_bias_mask)) = 0;
        
        Atlantic_bias = Atlantic_transect{ii} - Atlantic_observations; 
        Atlantic_bias_mean = nanmean(Atlantic_bias,3);
        Atlantic_bias_mask = abs(sum(sign(Atlantic_bias),3))/size(Atlantic_bias,3);
        Atlantic_bias_mask(abs(Atlantic_bias_mask)>mask_lim) = 1;
        Atlantic_bias_mask(abs(Atlantic_bias_mask)<mask_lim) = 0;
        Atlantic_bias_mask(isnan(Atlantic_bias_mask)) = 0;
        
        Indian_bias = Indian_transect{ii} - Indian_observations; 
        Indian_bias_mean = nanmean(Indian_bias,3);
        Indian_bias_mask = abs(sum(sign(Indian_bias),3))/size(Indian_bias,3);
        Indian_bias_mask(abs(Indian_bias_mask)>mask_lim) = 1;
        Indian_bias_mask(abs(Indian_bias_mask)<mask_lim) = 0;
        Indian_bias_mask(isnan(Indian_bias_mask)) = 0;
    end
end

Global_mean_hist = Global_mean_hist_for_ssp370;
Pacific_mean_hist = Pacific_mean_hist_for_ssp370;
Atlantic_mean_hist = Atlantic_mean_hist_for_ssp370;
Indian_mean_hist = Indian_mean_hist_for_ssp370;

save('./Data/Temperature_Transects_80pct_mask.mat', 'Indian_observations',...
    'Global_observations', 'Pacific_observations','Atlantic_observations', ...
    'Global_mean_hist',  'Global_mean_ssp126', 'Global_mask_ssp126', ...
    'Pacific_mean_hist',  'Pacific_mean_ssp126', 'Pacific_mask_ssp126', ...
    'Atlantic_mean_hist',  'Atlantic_mean_ssp126', 'Atlantic_mask_ssp126', ...
    'Indian_mean_hist',  'Indian_mean_ssp126', 'Indian_mask_ssp126', ...
    'Global_mean_ssp370', 'Global_mask_ssp370', ...
    'Pacific_mean_ssp370', 'Pacific_mask_ssp370', ...
    'Atlantic_mean_ssp370', 'Atlantic_mask_ssp370', ...
    'Indian_mean_ssp370', 'Indian_mask_ssp370', ...
    'Global_mean_ssp585', 'Global_mask_ssp585', ...
    'Pacific_mean_ssp585', 'Pacific_mask_ssp585', ...
    'Atlantic_mean_ssp585', 'Atlantic_mask_ssp585', ...
    'Indian_mean_ssp585', 'Indian_mask_ssp585', ...
    'Global_bias_mean','Global_bias_mask', ...
    'Pacific_bias_mean','Pacific_bias_mask', ...
    'Atlantic_bias_mean','Atlantic_bias_mask', ...
    'Indian_bias_mean','Indian_bias_mask', ...
    'model_names_sspvshistorical','model_names_obsvshistorical', ...
    'latitudes', 'depths', ...
    'start_year_historicalvsobs','start_year_ssp', ...
    'end_year_historicalvsobs','end_year_ssp', ...
    'start_year_historicalvsssp','end_year_historicalvsssp')


